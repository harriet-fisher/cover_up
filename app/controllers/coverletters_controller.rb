class CoverlettersController < ApplicationController
  def index
    matching_coverletters = Coverletter.all

    @list_of_coverletters = matching_coverletters.order({ :created_at => :desc })

    render({ :template => "coverletters/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_coverletters = Coverletter.where({ :id => the_id })

    @the_coverletter = matching_coverletters.at(0)

    render({ :template => "coverletters/show" })
  end

  def create
    the_coverletter = Coverletter.new
    the_coverletter.body = params.fetch("query_body")
    the_coverletter.job_id = params.fetch("query_job_id")
    the_coverletter.company_id = params.fetch("query_company_id")
    the_coverletter.user_id = params.fetch("query_user_id")

    if the_coverletter.valid?
      the_coverletter.save
      redirect_to("/coverletters", { :notice => "Coverletter created successfully." })
    else
      redirect_to("/coverletters", { :alert => the_coverletter.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_coverletter = Coverletter.where({ :id => the_id }).at(0)

    the_coverletter.body = params.fetch("query_body")
    the_coverletter.job_id = params.fetch("query_job_id")
    the_coverletter.company_id = params.fetch("query_company_id")
    the_coverletter.user_id = params.fetch("query_user_id")

    if the_coverletter.valid?
      the_coverletter.save
      redirect_to("/coverletters/#{the_coverletter.id}", { :notice => "Coverletter updated successfully."} )
    else
      redirect_to("/coverletters/#{the_coverletter.id}", { :alert => the_coverletter.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_coverletter = Coverletter.where({ :id => the_id }).at(0)

    the_coverletter.destroy

    redirect_to("/coverletters", { :notice => "Coverletter deleted successfully."} )
  end
end
