---guilty triggers
--set a global time period and control it with in1
--set number of steps with in2.

--https://www.ableton.com/en/blog/telefon-tel-aviv-shifting-time/

-- just change the time between trigs

--set a division and control of, let's say two bars, 
--and then instead of dividing those two bars into two bars of 
--32nd notes, you have 32 steps that can be any length. 
--Each step can be its own length, and you can draw in step lengths using a multi-slider or a graph, 
--and it'll loop around those two bars perfectly, but the distance between steps is not measured in note length, 
--it's measured in a pure time value. So each step can have its own time value, 
--and so you're constantly getting these different time divisions. 
--You can use this to trigger other things. 
--If you put a synth after the Guilt system and play chords or melodies, 
--it will play the notes that you're holding down almost like an arpeggiator, 
--but play them at the times that you determine on the multi-slider.

--make the time bwtween note trigs modulate as a sine wave over time. 

input[1].stream = function(v)
	crow.tell('stream',1,v) -- sends the voltage to druid
	for i=1,4 do 
		output[i].action = pulse(0.02,8)
	end
end

function init()
	input[1].mode('stream', 0.01)
end
