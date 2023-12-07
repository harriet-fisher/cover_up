class HomeController < ApplicationController
  def index
    render({:template => "home/index"})
  end

  def start
    render({:template => "home/start"})
  end

  def generate
    the_id = params.fetch("path_id")

    matching_messages = Message.where({ :id => the_id })

    @the_message = matching_messages.at(0)

    @prompt = "Read this company's job description and company description and identify traits, skills, and experience of their ideal candidate\n"
    @prompt += "company name: #{@the_message.company_name}\n"
    @prompt += "company description: #{@the_message.company_body}\n"
    @prompt += "job description: #{@the_message.job_body}\n"
    @curr_cover = "finally, rewrite my current cover letter to make me appear as the best candidate for the specified job: \n"
    @curr_cover += @the_message.message_body
    @cv = @the_message.resume

    send_to_openai(@prompt, @curr_cover, @cv, @the_message)
  end

  def send_to_openai(prompt,cover,cv, message)
    client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_KEY"), organization_id: ENV.fetch("ORG_ID"))
    my_assistants = client.beta.assistants.list(
    order="desc",
    limit="20",)

    @to_show = my_assistants.fetch("data")
    render({:template => "home/test"})
=begin

    my_assistant = client.beta.assistants.retrieve("asst_FhPRmOWyLQXB0xdLuDgSblZG")

    processed_cv = client.files.create(
    file=open(cv),
    purpose="assistant")

    thread = client.beta.threads.create()

    first_message = client.beta.threads.messages.create(
    thread_id: thread.fetch("id"),
    role: "user",
    content: prompt)

    second_message = client.beta.threads.messages.create(
    thread_id: thread.fetch("id"),
    role: "user",
    content: "now, read my resume and identify how you can highlight and exemplify the most relevant experiences, skills, and aspects relative to the job and company description I just provided",
    file_id: processed_cv.fetch("id"))

    third_message = client.beta.threads.messages.create(
    thread_id: thread.fetch("id"),
    role: "user",
    content: cover)

    run = client.beta.threads.runs.create(
    thread_id: thread.fetch("id"),
    assistant_id: asst_FhPRmOWyLQXB0xdLuDgSblZG,
    instructions: "Please address the user as #{current_user.full_name} and rewrite their current cover letter to be tailored for the specified company and job based on their experience"
    )

    all_messages = client.beta.threads.messages.list(
      thread_id: thread.fetch("id")
    )

    for message in all_messages.fetch("data")
      if messagethread.fetch("role") == "assistant"
        assistant_message = message
        break
      end
    end

    new_response = Message.new
    new_response.role = "assistant"
    new_response.message_id = @the_message.id
    new_response.company_name = @the_message.company_name
    new_response.job_id = @the_message.job_id
    new_response.company_id = @the_message.company_id
    new_response.user_id = @the_message.user_id
    new_response.message_body = assistant_message.fetch("content").at(0).fetch("text").fetch("value")
    new_response.save
    @the_message.message_id = new_response.id
    @the_message.save
    redirect_to("/messages/new/#{@the_message.id}/#{new_message.id}", { :notice => "Cover Letter Generated Successfully." })
=end
end
end
