class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :new_visitor, unless: -> { cookies[:first_visit] } 
  
  def new_visitor
    cookies.permanent[:new_visit] = 1
	@new_visit = true
  end
end