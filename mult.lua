--- simple buff mult. put a voltage into input 1, send voltage to druid and all outputs
-- in1: voltage to be multed
-- out1-4: duplicates of in1 voltage

input[1].stream = function(v)
	crow.tell('stream',1,v) -- sends the voltage to druid
	for n=1,4 do
    output[n].volts = v -- because v == input[1].volts
  end
end

function init()
	input[1].mode('stream', 0.01)
end
