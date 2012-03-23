xml.instruct!
xml.Response do
	xml.Gather(:action => @post_to, :method => 'GET', :numDigits => 1, :timeout => 90) do

		if @render_intro
	        	xml.Say "Welcome to the Quiz. Here are your instructions.  Please listen to the questions and the options carefully.  Please press 1 to choose Option 1 as the answer.  Please press 2 to choose Option 2 as the answer.  Please press 3 to choose Option 3 as the answer.  Please press 4 to choose Option 4 as the answer.  Please press 0 to repeat the question.   "
			xml.Say "Here is the first question.    "
		elsif @repeat_question_rendering
			xml.Say "You either pressed 0 to repeat the question, or, pressed an invalid key. We expect 1, 2, 3, or 4. So here is the same question again. "
		else
			xml.Say "Here is the next question.    "
		end


		xml.Say " " + @current_question.q_text + ".   The options are, Option 1,  " + @current_question.option_1 + ",   Option 2,  " + @current_question.option_2 + ",  Option 3,  " + @current_question.option_3 + ",  Option 4,  " + @current_question.option_4 + ".   "
	end
end
