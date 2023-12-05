class HomeController < ApplicationController
  def index
    render({:template => "home/index"})
  end

  def start
    render({:template => "home/start"})
  end
end
