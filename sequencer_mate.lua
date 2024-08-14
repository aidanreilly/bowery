--- sequencer mate + w/syn
-- in1: sampling clock
-- in2: input voltage
-- out1: s&h input (quantized chromatically)
-- out2: s&h input (fifth down)
-- out3: s&h input (octave down)
-- out4: trig out

function init()
  input[1]{ mode = 'change', direction = 'rising'}
  ii.wsyn.ar_mode(1)--0 or 1, 0 is constant on
  ii.wsyn.curve(-5)
  ii.wsyn.ramp(0)
  ii.wsyn.fm_index(0.01)
  ii.wsyn.fm_env(1)
  ii.wsyn.fm_ratio(4,1)
  ii.wsyn.lpg_time(0.1)
  ii.wsyn.lpg_symmetry(-5)
	print('seq mate loaded')
end

input[1].change = function()
    r = math.random() * 10.0 - 5.0
    v = input[2].volts
    --input note passed to out1
    output[1].volts = math.floor(v*12)/12
    --down a fifth 
    output[2].volts = math.floor((v*12)/12)+5/12
    --down an octave
    output[3].volts = math.floor((v*12)/12)+1
    --trig out
    output[4](pulse(0.01,8))
		--output[4](ar(0.01,0.1, 7, 'log'))
		--play 3 w/syn notes
		ii.wsyn.voices(3)
		ii.wsyn.play_note(math.floor(v*12)/12, 1)
		ii.wsyn.play_note(math.floor((v*12)/12) +1, 1)
		ii.wsyn.play_note(math.floor((v*12)/12) -2, 1)
end
