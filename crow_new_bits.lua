#window

First of a few features relating #14 to extend the built-in utility of the inputs.

'window' uses the input as a window comparator with up to 16 windows (so 17 indices). When a new window is entered, an event is called in the lua environment providing the user the index of the window that's been entered, and whether that window was entered from above or below.

The main use case I can see with this is to use the input jacks as a 'selector' (of modes / processing / equations / scales), hence the event giving the user the index (ie position in the provided window table) of the current window.

--- Selector
-- five 2V windows in the (-5,5) range
input[1].mode( 'window', { -3, -1, 1, 3 }, 0.1 )

 -- different windows set different LFO speeds
input[1].window = function( win )
  output[1]( lfo( win ) )
end
--- Use a voltage source to trigger events
limit = 4.0 -- cause an event when passing +/- 4V
output[1].slew = 5.0
input[1].mode( 'window', { -limit, limit }, 0.1 )

input[1].window = function( win, is_rising )
  if win == 2 then
    output[1].volts = (is_rising) and -5 or 5 -- start a slope!
    myMetro:start() -- restart the clock
  else -- in the endzones
    myMetro:stop()
  end
end
Random bits:

Windows are 1-based, and '1' is voltages less than the first window.
Tables can be up to 16 elements long. If you need more windows, you probably want forthcoming 'scale'
An optional second argument is hysteresis voltage at window edges
Without declaring a function in the user script, this sends default ^^ message for norns:
^^window( channel, window_index, is_rising )
Realtime values are still available like v = input[1].volts

#volume

Using a basic RMS calculation with a ~300ms settling time for VU style amplitude tracking. Works like 'stream' (ie polling), so it's useful for mapping the amplitude of an audio signal to a voltage (ie. envelope following). Due to the RMS shaping, different waveforms will give different amplitudes, while DC signals will settle to their nominal voltage (with slew).

--- volume usage:
-- envelope follow the signal on input 1 and send a smoothed version out on output 1
input[1].mode( 'volume', 0.01 ) -- detect RMS volume and call the event every 10ms seconds
output[1].slew = 0.01
input[1].volume = function(level)
  output[1].volts = level
end

#scale

-- set input 1 to quantize based on a major pentatonic scale, 12TET, 1v/8ve
input[1].mode( 'scale', {0,2,4,7,9} )
input[1].scale = function( note )
  -- this is called any time the input moves to a new note
end

-- shortcut for chromatic scaling
input[1].mode( 'scale', {} )

-- n-TET support, eg: 19TET pentatonic
input[1].mode( 'scale', {0,3,6,9,11}, 19 )

-- non-v/8 support, eg: buchla pitch
input[1].mode( 'scale', {0,2,4,7,9}, 12, 1.2 )

-- non-v/8 support, eg: major arpeggio over 2 octaves
input[1].mode( 'scale', {0,4,7,11,14,17,21}, 12, 2.0 )
Incomplete:

Just intonation support
Better testing
Event callback type signature
Here are some ideas for the event callback type signature with some initial thoughts on pros/cons of the different choices. As always, it should come down to how these will integrate into a script. I'm happy to add a couple helper functions to the lua input library to allow conversion to different use-cases. eg: we can convert from note to volts very easily with an Input method.

--option1
input[1].scale = function( note )
  -- octave & note combined to a linear range where 0 == 0V
  -- notes would be integers like MIDI notes
  -- should they be sequential per the scale, or absolute like MIDI notes (ie. have gaps)
  -- eg sequential with scale {0,2,4,7,9} -> [1,2,3,4,5]
  -- eg absolute with same scale {0,2,4,7,9} -> [0,2,4,7,9
end

--option2
input[1].scale = function( note, octave )
  -- separate note & octave
  -- can easily achieve option1 with: octave+note/12 (or whatever nTET setting)
  -- is it useful to have them separate? i think not?
end

--option3
input[1].scale = function( volts )
  -- just pass the quantized voltage that has been landed at
  -- this feels more like a voltage processor where we're just cleaning up values
  -- eg: scale {0,2,4,7,9} -> [0.0, 0.16, 0.33, 0.55, 0.7]
  -- unfortunately you can't use the value as a table-lookup
  -- seems easier to make these values by using options1/2 and the input scale table
end