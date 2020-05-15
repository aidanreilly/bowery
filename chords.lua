--- generate a chord from a single input 
-- in1: chord root, send 1v/oct
-- in2: chord choice, send -5 to +5V
-- out1-4: chord degrees

-- chord shapes!
chords = { {0,0,0,0,0} --Root -5V
, {0,4,7,12,0} --Major
, {4,7,12,16,-5} --Major inv 1
, {7,12,16,-5,0} --Major inv 2
, {-12,-8,-5,0,4} --Major inv 3
, {-8,-5,0,4,7} --Major inv 4
, {0,4,7,11,0} --Major 7th
, {4,7,11,0,16} --Major 7th inv 2 0V
, {7,11,0,16,19} --Major 7th inv 3
, {-12,-8,-5,-1,0} --Major 7th inv 4
, {-8,4,7,11,23} --Major 7th no root
, {0,0,0,0,0} --Root
, {-24,-12,0,12,24} --organ
, {-12,0,0,12,24} --2 up 1 down octave +5V
}

function init()
	--use a metro to clock the sampling of in1 and in2
	metro[1].event = create_chord
	metro[1].time  = 0.005
	metro[1]:start()
	input[1].mode('none')
    input[2].mode('none')
    for n=1,4 do
        output[n].slew = 0.001
    end
end

function create_chord()
	--sel is used to pick out the chord from the chords list
	sel = math.floor(input[2].volts/0.75 + 7.5)
	root = input[1].volts
	-- output chord degrees on each out1-4
	for n=1,4 do
		output[n].volts = root + (chords[sel][n]/12)
    end
end