--- quantizer
-- in1: clock
-- in2: voltage to quantize
-- out1: in2 quantized to scale1 on clock pulses
-- out2: in2 quantized to scale2 on clock pulses
-- out3: in2 quantized to scale3 on clock pulses
-- out4: in2 quantized to scale3 on clock pulses

scales =
{ phryg  = {0,1,3,5,7,8,10,12}
, phryg1  = {0,1,3,5,7}
, phryg2  = {0,1,3,5}
, phryg3  = {0,1,3}
}

-- update clocked outputs
input[1].change = function(state)
  output[1].volts = input[2].volts
  output[2].volts = input[2].volts
  output[3].volts = input[2].volts
  output[4].volts = input[2].volts
end

function init()
  input[1].mode('change',1,0.1,'rising')
  input[2].mode('scale',scales[1])
  output[1].scale = scales[1]
  output[2].scale = scales[2]
  output[3].scale = scales[3]
  output[4].scale = scales[4]
end

