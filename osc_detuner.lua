--- simple detuner
-- put a 1/v oct CV into input 1, and get CV out for the following:
-- out1: fifth up
-- out2: fifth down
-- out3: seventh down
-- out4: trig out
-- input 2 sweeps octaves +/- 2 octaves


function init()
	input[1].mode( 'scale', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12} )--chromatic
	input[2].mode( 'scale', {-24, -12, 0, 12, 24} )--octaves
	print('simple detuner loaded')
end

input[1].scale = function( note )
	-- invert negative voltages, eg negative phase of LFO
	if note.volts < 0 then
		note.volts = note.volts * -1
	end
	output[1].volts = note.volts
	-- trig everytime the input moves to a new note
	output[4](pulse(0.01,8))
end

input[2].scale = function( note )
	if note.volts < 0 then
		note.volts = note.volts * -1
	end
	output[3].volts = note.volts
	output[4](pulse(0.01,8))
end