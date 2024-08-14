--- Quad looping phasing AD envelopes
-- Clock signal on input 1
-- Each output is an identical AD envelope
-- Each output moves slowly in and out of phase based on input 2 which gently modulates the envelopes

-- initialize global variables
phase_offset = 0
phase_step = 0.01
attack_offset = 0
decay_offset = 0
attack_scale = 0.1
decay_scale = 0.1

-- define the envelope function
function env(attack, decay)
  output[1].action = ar(0, attack, decay)
  output[2].action = ar(0, attack, decay)
  output[3].action = ar(0, attack, decay)
  output[4].action = ar(0, attack, decay)
end

-- define the input change function for input 2
function input2_change(state)
  local s = util.linlin(0, 5, 0, 1, state)
  attack_offset = s * 0.1
  decay_offset = s * 0.1
  print("Attack Offset:", attack_offset, "Decay Offset:", decay_offset)
end

-- define the clock input function
function clock()
  phase_offset = phase_offset + phase_step
  
  -- calculate the envelope parameters
  local attack = attack_offset + math.sin(phase_offset) * attack_scale
  local decay = decay_offset + math.sin(phase_offset + math.pi) * decay_scale
  print("Phase Offset:", phase_offset, "Attack:", attack, "Decay:", decay)
  
  -- generate the envelope output
  env(attack, decay)
end

-- set up the input handlers
input[2].mode("change", function(state) input2_change(state) end)

-- set up the clock input
input[1].mode("change", function(state)
  if state == 1 then
    clock()
  end
end)
