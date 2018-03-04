class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
#  before_action :save_session
  before_action :print_session 
  
#  def save_session
#    session[:sort] = params[:sort]
#    session[:direction] = params[:direction]
#    session[:ratings] = params[:ratings]
#  end
  
  def print_session
    printf "This is my session sort: %s\n", session[:sort].to_s
	printf "This is my session sort direction: %s\n", session[:direction].to_s
  end
  
end