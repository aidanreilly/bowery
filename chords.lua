--- generate a chord from a single input 
-- in1: chord root, send 1v/oct
-- in2: chord choice, send -5 to +5V
-- out1-4: chord degrees

-- Try chords from here: https://github.com/monome/norns/blob/dev/lua/lib/musicutil.lua

chords = { {0,0,0,0,0} --Root
, {0,4,7,9,0} -- Maj6
, {0,4,7,11,0} -- Maj7
, {0,4,7,10,0} -- Dom7
, {0,4,8,10,0} -- Aug7
, {0,5,7,10,0} -- Sus4
, {0,3,7,11,0} -- MinMaj7
, {0,3,7,9,0} -- Min6
, {0,3,7,10,0} -- Min7
, {0,3,6,9,0} -- Dim7
, {0,3,6,10,0} -- HalfDim7
, {0,3,7,9,0} -- Min6
, {0,3,7,10,0} -- Min7
, {12,-12,12,-12,12} --OctUpDown
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
	-- send 1v/oct into in1
	root = input[1].volts
	-- output chord degrees on each out1-4
	for n=1,4 do
		output[n].volts = root + (chords[sel][n]/12)
    end
end