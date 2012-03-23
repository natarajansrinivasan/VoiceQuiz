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

	if cookies[:cookie_data]
		@cookie_data = cookies[:cookie_data].split(",").map { |s| s.to_i }

		#increment current question index to iterate to the next question, unless we have been asked to repeat the current question
		@cookie_data[0] += 1 unless params['repeat_question'] == '1'		
		@current_question_index = @cookie_data[0]
		@current_question = @questions[@current_question_index]

		if params['repeat_question'] == '1'
			@repeat_question_rendering = true
		end

		#update the cookie
		cookies[:cookie_data] = @cookie_data.join(",")
	else
		@current_question_index = 0
		@current_question = @questions[@current_question_index]

		# cookie does not exist yet, create it here with the sole data element representing the current question index
		cookies[:cookie_data] = @current_question_index

		@render_intro = true
	end

	render :action => "ask_question.xml.builder"
  end

  def process_answer
	if !params['Digits'] or params['Digits'] == '0' or !['1','2','3','4'].member?(params['Digits'])
		redirect_to BASE_URL + '/index?repeat_question=1'
    		return
  	end

	@cookie_data = cookies[:cookie_data].split(",").map { |s| s.to_i }
	@current_question_index = @cookie_data[0]
	@current_question = Question.all[@current_question_index]
	@correct_answer = @current_question.answer

	@answer = "Option " + params['Digits']

	if (@answer != @correct_answer)
		if @cookie_data.length > 1
			# this means there was a wrong answer already
			# so, increment the count of wrong answers; this will be the second element in the cookie data array
			@cookie_data[1] += 1

		else
			# as the cookie data array has only one element, this must be the first wrong answer
			# add the count of wrong answers, i.e. 1, to the cookie data array
			@cookie_data << 1
		end
		
		# add the index of the current question to the list of wrongly answered questions
		@cookie_data << @current_question_index

		# now put the array back into a string and update the cookie
		cookies[:cookie_data] = @cookie_data.join(",")
	end 

	@total_number_of_questions = Question.count
	@current_question_index = @current_question_index + 1
	if (@current_question_index < @total_number_of_questions)
		redirect_to :action => 'index'
		return
	end

	# now the quiz is done, compute total score and render it
	if @cookie_data.length > 1
		@total_wrong_answers = @cookie_data[1]
		@result = "#{((@total_number_of_questions - @total_wrong_answers).to_f/@total_number_of_questions.to_f * 100.0).round}%"		
	else
		@result = "100%"
	end

	# delete cookies
	cookies.delete :cookie_data
	#cookies.delete :current_question
	#cookies.delete :wrong_answers

	render :action => "render_report.xml.builder"
	
  end

end
