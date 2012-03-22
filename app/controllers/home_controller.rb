require "twilio-ruby"

class HomeController < ApplicationController

  # base URL of this application
  # BASE_URL = "http://localhost:3000/home"
  # BASE_URL = "http://ec2-23-21-156-76.compute-1.amazonaws.com/home"

  if Rails.env.production?
	BASE_URL = "http://ec2-23-21-156-76.compute-1.amazonaws.com/home"
  else  
	BASE_URL = "http://localhost:3000/home"
  end

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

	@current_question_index = cookies[:current_question].to_i
	@current_question = Question.all[@current_question_index]
	@correct_answer = @current_question.answer

	@answer = "Option " + params['Digits']
	# @result = @answer == @correct_answer ? "100%" : "0%"

	if (@answer != @correct_answer)
		if cookies[:wrong_answers]
			# format the current cookie data as an array of integers; first element is count, following elements are indices of
			# questions that were wrongly answered
			@current_wrong_answers_data = cookies[:wrong_answers].split(",").map { |s| s.to_i }

			# first element in the array is the total number of wrong answers
			@current_wrong_answers_data[0] += 1

		else
			# the cookie does not exist, as this must be the first wrong answer
			# first element in the array is the total number of wrong answers, make it 1
			@current_wrong_answers_data = [1];
		end

		# add the index of the current question to the list of wrongly answered questions
		@current_wrong_answers_data << @current_question_index

		# now put the array back into a string and update the cookie
		cookies[:wrong_answers] = @current_wrong_answers_data.join(",")
	end 

	@current_question_index = @current_question_index + 1
	if (@current_question_index < Question.all.length)
		redirect_to :action => 'index'
		return
	end

	# now the quiz is done, compute total score and return it
	if cookies[:wrong_answers]
		@total_wrong_answers = cookies[:wrong_answers].split(",")[0].to_i
		@result = "#{((Question.all.length - @total_wrong_answers).to_f/Question.all.length.to_f * 100.0).round}%"		
	else
		@result = "100%"
	end

	# delete cookies
	cookies.delete :current_question
	cookies.delete :wrong_answers

	render :action => "render_report.xml.builder"
	
  end

end
