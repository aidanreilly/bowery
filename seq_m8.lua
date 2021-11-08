--- seq m8
-- creates variations on an external sequence
-- in1: sequencer 1v/oct
-- in2: clock
-- out1: voice 1 1v/oct
-- out2: voice 1 trig
-- out3: voice 2 1v/oct
-- out4: voice 2 trig

notes = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

--transpose amount
t1 = 0
t2 = 0

--clock div amount
d1 = 3
d2 = 1

--sequins step amount
s1 = 1
s2 = 3

-- make a new sequins from notes
notes_sequins = sequins(notes)

-- set up the sequins
seq_1 = notes_sequins:step(s1)
seq_2 = notes_sequins:step(s2)

function sequence()
  -- get notes from external seq into 16 stage shift register
  table.remove(notes)
  table.insert(notes, 1, input[1].volts)
  --make v1 notes
  v1 = seq_1() 
  v1 = v1 + t1
  output[1].volts = v1
  --make v2 notes
  v2 = seq_2() 
  v2 = v2 + t2
  output[3].volts = v2  
end

int_clk = clock.run(function()
  while true do
    clock.sync(1)
    output[2]:clock(d1) -- divide the clock
    output[4]:clock(d2)
    sequence()
  end
end)

function init()
    input[2].mode('clock', 1)
    input[2].change = sequence
    print('loaded seq m8')
end