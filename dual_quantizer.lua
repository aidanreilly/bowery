--- simple dual quantizer
-- quantized notes on outs 1 and 3, with a trigger on outs 2 and 4 for every new note

function init()
	-- quantize based on a phrygian scale
	input[1].mode( 'scale', {0,1,3,5,7,8,10,12} )
	input[2].mode( 'scale', {0,1,3,5,7,8,10,12} )

	-- quantize based on a major pentatonic scale
	--input[1].mode( 'scale', {0,2,4,7,9} )
	--input[2].mode( 'scale', {0,2,4,7,9} )
	print('dual quantizer loaded')
end

input[1].scale = function( note )
	-- invert negative voltages, eg negative phase of LFO
	if note.volts < 0 then
		note.volts = note.volts * -1
	end
	output[1].volts = note.volts
	-- this is called any time the input moves to a new note
	output[2](pulse(0.01,8))
end

input[2].scale = function( note )
	if note.volts < 0 then
		note.volts = note.volts * -1
	end
	output[3].volts = note.volts
	output[4](pulse(0.01,8))
end