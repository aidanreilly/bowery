--- basic attempt music mouse sketch

-- at a high level, music mouse has the following functionality:
-- harmonic mode - chromatic, octatonic, mid-eastern, diatonic, pentatonic, quartal
-- treatment - chord, arp, line, improvise
-- transposition - semitones
-- interval of transp - num. semitones
-- mouse movement - parallel, contrary musical changes
-- voicing - chord-melody, voice pairs
-- articulation - legato, staccato, half legato 
-- tempo 
-- etc

-- this has x and y coordinates triggering a root note and chord shape
-- music crow has quantized notes on outs 2-4
-- trigger on out 4, when either in 1 or in 2 senses a change 
-- output 1 moves the base note up and down the scale 
-- output 2-4 play the chord, using output 1 as the root note, and moves the chord up the scale

--select a chord from the chords array
chord_sel = 2
root = 0

--lydian chords array
chords = { {0, 4, 7} --Maj
, {0, 5, 7} --Sus4
, {0, 3, 7} --Min
, {0, 4, 8} --Augmented
, {0, 3, 6} --Dim
}


function init()
	print('music crow loaded')
	-- quantize inputs to scale
	input[1].mode( 'scale', {0, 2, 4, 6, 7, 8, 10, 12} )--Lydian minor
	input[2].mode( 'scale', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12} )--chromatic
end

input[1].scale = function( note )
	-- invert negative voltages, eg negative phase of LFO
	if note.volts < 0 then
		note.volts = note.volts * -1
	end
	output[1].slew = 0.001
	--scale out 1
	output[1].volts = note.volts
	root = note.volts
	-- this is called any time the input moves to a new note
	output[4](pulse(0.01,8))
end

input[2].scale = function( note )
	-- invert negative voltages, eg negative phase of LFO
	if note.volts < 0 then
		note.volts = note.volts * -1
	end	
	for n=2,3 do
		output[n].slew = 0.001
		output[n].volts = root + note.volts + chords[chord_sel][n]/12
	end
	output[4](pulse(0.01,8))
end