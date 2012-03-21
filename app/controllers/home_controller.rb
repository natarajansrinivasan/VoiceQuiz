require "twilio-ruby"

class HomeController < ApplicationController

  # base URL of this application
  # BASE_URL = "http://localhost:3000/home"
  BASE_URL = "http://ec2-23-21-156-76.compute-1.amazonaws.com/home"

  @current_question = ""

  def index
	@post_to = BASE_URL + '/process_answer'
	render :action => "ask_question.xml.builder"
  end

  def process_answer
	if !params['Digits'] or params['Digits'] == '0'
    		redirect_to :action => 'index'
    		return
  	end

  	@current_answer = "Option 3"

	@answer = "Option " + params['Digits']
	@result = @answer == @current_answer ? "100%" : "0%"

	render :action => "render_report.xml.builder"
	
  end

end
