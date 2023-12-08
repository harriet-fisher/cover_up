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
    @cv = @the_message.resume

    render({ :template => "messages/show" })
  end

  def cover
    the_id = params.fetch("request_id")

    matching_requests = Message.where({ :id => the_id })
    @the_request = matching_requests.at(0)

    @company_job_analysis = Response.where({ :id => the_response_id, :response_number => 1 })
    @resume_analysis = Response.where({ :id => the_response_id, :response_number => 2 })
    @cover_letter = Response.where({ :id => the_response_id, :response_number => 3 })

    render({ :template => "messages/coverletter" })
  end

  def create
    the_message = Message.new
    the_message.job_body = params.fetch("job_body")
    the_message.company_body = params.fetch("company_body")
    the_message.company_name = params.fetch("company_name")
    the_message.message_body = params.fetch("message_body")
    the_message.user_id = params.fetch("user_id")
    the_message.role = params.fetch("role")
    the_message.resume.attach(params[:resume]) if params[:resume].present?
    the_message.save

    if the_message.valid?
      redirect_to("/generate/#{the_message.id}", { :notice => "Message sent successfully." })
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
