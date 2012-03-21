xml.instruct!
xml.Response do
	xml.Gather(:action => @post_to, :method => 'GET', :numDigits => 1, :timeout => 60) do
	        xml.Say "Please listen to the question carefully and the options. Please press 1 to choose Option 1 as the answer. Please press 2 to choose Option 2 as the answer. Please press 3 to choose Option 3 as the answer. Please press 4 to choose Option 4 as the answer. Please press 0 to repeat the question"

		xml.Say "Here is the question. " + @current_question.q_text + " The options are, Option 1 " + @current_question.option_1 + " Option 2 " + @current_question.option_2 + " Option 3 " + @current_question.option_3 + " Option 4 " + @current_question.option_4
	end
end
