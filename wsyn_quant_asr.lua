--- digital analog shift register
-- four stages of delay for an incoming cv
-- input 1: cv to delay
-- input 2: trigger to capture input & shift
-- output 1-4: newest to oldest output
-- ii: 4 stages of ASR for w/syn

reg = {}
reg_LEN = 4

q = {}
function init()
    for n=1,4 do
        output[n].slew = 0
    end
    input[1].mode('none')
    input[2]{ mode      = 'change'
            , direction = 'rising'
            }
    for i=1,reg_LEN do
        reg[i] = input[1].volts
    end
    --wsyn setup
    --todo make this settable from a global preset
    ii.wsyn.ar_mode(1)--0 or 1, 0 is constant on
		ii.wsyn.curve(math.random(-40, 40)/10)
		ii.wsyn.ramp(math.random(-5, 5)/10)
		ii.wsyn.fm_index(math.random(-50, 50)/10)
		ii.wsyn.fm_env(math.random(-50, 40)/10)
		ii.wsyn.fm_ratio(math.random(1, 4), math.random(1, 4))
		ii.wsyn.lpg_time(math.random(-28, -5)/10)
		ii.wsyn.lpg_symmetry(math.random(-50, -30)/10)

    metro[1].event = iiseq
    metro[1].time  = 0.005
    metro[1]:start()
end

function iiseq()
    if #q > 0 then
        ii.wsyn.play_note(table.remove(q)-12,2)
    end
end

function update(r)
    for n=1,4 do
        output[n].volts = r[n]
    end
    for n=1,4 do
        table.insert(q, r[n]) -- queue a note for i2c transmission
    end
end

input[2].change = function()
    capture = input[1].volts
    table.remove(reg)
    table.insert(reg, 1, input[1].volts)
    update(reg)
end