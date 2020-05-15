--- generate a chord from a single input 
-- in1: chord root, send 1v/oct
-- in2: chord choice, send -5 to +5V
-- out1-4: chord degrees

-- chord shapes!
chords = { {0,0,0,0,0} --Root -5V
, {1,5,8,13,1} --Major
, {5,8,13,17,-4} --Major inv 1
, {8,13,17,-4,1} --Major inv 2
, {-11,-7,-4,1,5} --Major inv 3
, {-7,-4,1,5,8} --Major inv 4
, {1,5,8,11,1} --Major 7th
, {5,8,12,1,17} --Major 7th inv 2 0V
, {8,12,1,17,20} --Major 7th inv 3
, {-11,-7,-4,0,1} --Major 7th inv 4
, {-7,5,8,12,24} --Major 7th no root
, {1,1,1,1,1} --Root
, {-23,-11,1,13,25} --organ
, {-11,1,1,15,25} --2 up 1 down octave +5V
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