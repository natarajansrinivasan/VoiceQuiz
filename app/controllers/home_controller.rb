require "twilio-ruby"

class HomeController < ApplicationController

  # base URL of this application
  # BASE_URL = "http://localhost:3000/home"
  BASE_URL = "http://ec2-23-21-156-76.compute-1.amazonaws.com/home"


  def index
	@post_to = BASE_URL + '/process_answer'

	@questions = Question.all

	#@current_question_index = 0
	#@current_question = @questions[@current_question_index]

	if cookies[:current_question]
		@current_question_index = cookies[:current_question].to_i + 1
		if (@current_question_index == @questions.length)
			@current_question_index = 0
		end
		@current_question = @questions[@current_question_index]
		cookies[:current_question] = @current_question_index
	else
		@current_question_index = 0
		@current_question = @questions[@current_question_index]
		cookies[:current_question] = @current_question_index
	end

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
