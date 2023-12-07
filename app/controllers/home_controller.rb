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

    @response = send_to_openai(@prompt, @curr_cover, @cv)
  end

  def send_to_openai(prompt,cover,cv)
    client = OpenAI::Client.new(access_token: ENV.fetch("OPEN_AI_KEY"), organization_id = ENV.fetch("org-ca8ZMJcAPDcpg16u9Vj1NxCe"))
    my_assistant = client.beta.assistants.retrieve("asst_FhPRmOWyLQXB0xdLuDgSblZG")

    processed_cv = client.files.create(
    file=open(cv),
    purpose="assistant")

    thread = client.beta.threads.create()

    first_message = client.beta.threads.messages.create(
    thread_id: thread["id"],
    role: "user",
    content: prompt)

    second_message = client.beta.threads.messages.create(
    thread_id: thread["id"],
    role: "user",
    content: "now, read my resume and identify how you can highlight and exemplify the most relevant experiences, skills, and aspects relative to the job and company description I just provided"
    file_id: processed_cv["id"])

    third_message = client.beta.threads.messages.create(
    thread_id: thread["id"],
    role: "user",
    content: cover)

    run = client.beta.threads.runs.create(
    thread_id: thread["id"],
    assistant_id: asst_FhPRmOWyLQXB0xdLuDgSblZG,
    instructions: "Please address the user as #{current_user.full_name} and rewrite their current cover letter to be tailored for the specified company and job based on their experience"
    )

    @response = client.beta.threads.messages.retrieve(
      message_id="msg_abc123",
      thread_id="thread_abc123",
    )
  end

end
