class HomeController < ApplicationController
  require 'tempfile'
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
    @prompt += "job title: #{@the_message.job_title}"
    @curr_cover = "Rewrite my current cover letter to make me appear as the best candidate for the specified job: \n"
    @curr_cover += @the_message.message_body
    @cv = @the_message.resume
  
    client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_KEY"), organization_id: ENV.fetch("ORG_ID"))

    my_assistant = client.assistants.retrieve(id: "asst_FhPRmOWyLQXB0xdLuDgSblZG")

    Tempfile.create('uploaded_cv', binmode: true) do |tempfile|
      tempfile.write(@cv.download)
      tempfile.rewind

      processed_cv = client.files.upload(parameters: {file: tempfile.path, purpose: "assistants" })
      @cv_id = processed_cv.fetch("id")

      thread = client.threads.create()
      thread_id = thread.fetch("id")

      message_1_params = {
        content: @prompt,
        role: "user"
      }
      first_message = client.messages.create(
      thread_id: thread_id, parameters: message_1_params)

      message_2_params = {
        role: "user",
        content: "now, read my resume and identify how you can highlight and exemplify the most relevant experiences, skills, and aspects relative to the job and company description I just provided",
        file_ids: [processed_cv.fetch("id")]
      }
      second_message = client.messages.create(thread_id: thread_id, parameters: message_2_params)

      message_3_params = {
        role: "user",
        content: @curr_cover
      }
      third_message = client.messages.create(thread_id: thread.fetch("id"), parameters: message_3_params)

      run_params = {assistant_id: "asst_FhPRmOWyLQXB0xdLuDgSblZG"}
      run = client.runs.create(thread_id: thread_id, parameters: run_params)
      run_id = run.fetch("id")

      completed = false
      until completed
        current_run = client.runs.retrieve(thread_id: thread_id, id: run_id)
        @run_status = current_run.fetch("status")
        completed = @run_status == "completed"
        sleep(2) unless completed
      end

      all_messages = client.messages.list(thread_id: thread_id)
      assistant_messages = []

      for message in all_messages.fetch("data")
        if message.fetch("role") == "assistant"
          assistant_messages.push(message)
        end
      end

      text_value = assistant_messages.at(0).fetch("content").at(0).fetch("text").fetch("value")
      new_response = Response.new
      new_response.message_id = @the_message.id
      new_response.user_id = @the_message.user_id
      new_response.body = text_value
      new_response.response_number = 3
      new_response.save
      client.files.delete(id:@cv_id)
    end
    redirect_to("/cover/#{@the_message.id}")
  end
end
