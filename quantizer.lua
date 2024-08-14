--- quantizer
-- in1: voltage to quantize
-- in2: clock
-- out1: in2 quantized to scale1 on clock pulses
-- out2: in2 quantized to scale2 on clock pulses
-- out3: in2 quantized to scale3 on clock pulses
-- out4: in2 quantized to scale3 on clock pulses

scales =
{ chromatic  = {} -- empty table for chromatic
, chord1  = {0,3,7} -- minor triad
, chord2  = {0,4,7,11} -- maj7
, chord3  = {0,3,7,11} -- mMaj7
}

-- update clocked outputs
input[2].change = function(state)
  output[1].volts = input[1].volts -- pass sequence to output
  output[2].volts = input[1].volts -- + 7/12 -- up a fifth
  output[3].volts = input[1].volts -- - 3/12 -- down a minor third
  output[4].volts = input[1].volts -- - 12/12 -- down an octave
end

function init()
  input[1].mode('scale',scales[1])
  input[2].mode('change',1,0.1,'rising')
  output[1].scale = scales[1]
  output[2].scale = scales[2]
  output[3].scale = scales[3]
  output[4].scale = scales[4]
end

