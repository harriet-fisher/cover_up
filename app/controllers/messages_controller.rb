require 'aws-sdk-s3'
class MessagesController < ApplicationController
  def index
    matching_messages = Message.all

    @list_of_messages = matching_messages.order({ :created_at => :desc })

    render({ :template => "messages/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_messages = Message.where({ :id => the_id })

    @the_message = matching_messages.at(0)

    @prompt = "Rewrite my cover letter so that it is tailored to this company's job description and company description using my current experience\n"
    @prompt += "company name: #{@the_message.company_name}\n"
    @prompt += "company description: #{@the_message.company_body}\n"
    @prompt += "job description: #{@the_message.job_body}\n"
    @prompt += "current cover letter: #{@the_message.message_body}\n"
    @prompt += "current experience available at: #{@the_message.resume}"

    @response = send_to_openai(@prompt)

    render({ :template => "messages/show" })
  end

  def send_to_openai(prompt)
    client = OpenAI::Client.new(api_key: ENV.fetch("OPEN_AI_KEY"))

    thread = client.beta.threads.create()

    message = client.beta.threads.messages.create(
    thread_id=thread.id,
    role="user",
    content=@prompt)

    run = client.beta.threads.runs.create(
    thread_id=thread.id,
    assistant_id=asst_FhPRmOWyLQXB0xdLuDgSblZG,
    instructions="Please address the user as #{current_user.full_name}."
    )

    response = client.beta.threads.messages.list(
    thread_id=thread.id
    )
  end

  def create
    the_message = Message.new
    the_message.job_body = params.fetch("query_job_body")
    the_message.company_body = params.fetch("query_company_body")
    the_message.company_name = params.fetch("query_company_name")
    the_message.message_body = params.fetch("query_message_body")
    the_message.user_id = params.fetch("query_user_id")

    if params[:uploaded_cv]
      s3 = Aws::S3::Resource.new(region: ENV.fetch("AWS_REGION"))
      obj = s3.bucket(ENV.fetch("AWS_BUCKET")).object("uploads/#{SecureRandom.uuid}/#{params[:uploaded_cv].original_filename}")
      obj.upload_file(params[:uploaded_cv].tempfile, acl: 'private')
      uploaded_file_url = obj.public_url
      the_message.resume = uploaded_file_url
    end

    if the_message.valid?
      the_message.save
      redirect_to("/messages/#{the_message.id}", { :notice => "Message sent successfully." })
    else
      redirect_to("/messages", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_message = Message.where({ :id => the_id }).at(0)

    the_message.job_body = params.fetch("query_job_body")
    the_message.company_body = params.fetch("query_company_body")
    the_message.company_name = params.fetch("query_company_name")
    the_message.message_body = params.fetch("query_message_body")
    the_message.user_id = params.fetch("query_user_id")

    if the_message.valid?
      the_message.save
      redirect_to("/messages/#{the_message.id}", { :notice => "Message updated successfully."} )
    else
      redirect_to("/messages/#{the_message.id}", { :alert => the_message.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_message = Message.where({ :id => the_id }).at(0)

    the_message.destroy

    redirect_to("/messages", { :notice => "Message deleted successfully."} )
  end
end
