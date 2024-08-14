--- simple gate logic combiner
-- clock signals in1 and in2 get combined on the rising edge of in2 in various logic combinations producing gates on outs 1-4

function init()
    input[1]{ mode = 'change', direction = 'rising' }
    input[2]{ mode = 'change', direction = 'rising' }
    for n=1,4 do
        output[n].slew = 0.001
    end
end

input[1].change = function()
	v1 = input[1].volts 
	v2 = input[2].volts
	--if v1 < v2 then in1 = 1 and in2 = 0
	--out1 in1 and in2 
	--out2 in1 or in2 
	--out3 in1 not in2
	--out4 in1 xor in2
end