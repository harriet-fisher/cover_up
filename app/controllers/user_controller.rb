class UserController < ApplicationController
  def show
    @cover_letters = Message.where({ :user_id => current_user.id }).order(created_at: :desc)
    render({ :template => "user/show" })
  end
end
