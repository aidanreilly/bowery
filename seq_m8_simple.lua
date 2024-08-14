--- seq m8
-- creates variations on an external sequence
-- in1: sequencer 1v/oct
-- in2: clock
-- out1: voice 1 1v/oct
-- out2: voice 1 trig
-- out3: voice 2 1v/oct
-- out4: voice 2 trig

-- empty notes register
notes = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

-- transpose amount
t1 = 7/12 --fifth
t2 = -1 --octave

-- clock div amounts + div counters
d1 = 3
d2 = 5
c1 = 0
c2 = 0

-- sequins step amount
s1 = 3
s2 = 5

-- make a new sequins from notes
notes_sequins = sequins(notes)

-- set up the sequins
seq_1 = notes_sequins:step(s1)
seq_2 = notes_sequins:step(s2)

function get_notes()
  -- get notes from external sequencer into 16 stage shift register
  table.remove(notes)
  table.insert(notes, 1, input[1].volts)
end

function sequence_1()
  v = seq_1() + t1
  output[1].volts = v
  output[2](pulse())
end

function sequence_2()
  v = seq_2() - t2
  output[3].volts = v
  output[4](pulse())
end

function init()
  input[2].mode('change')
  input[2].change = function()
    get_notes()
    -- increment count for every clock pulse
    c1 = c1 + 1
    c2 = c2 + 1
    if c1 >= d1 then
      c1 = 0
      sequence_1()
    end
    if c2 >= d2 then
      c2 = 0
      sequence_2()
    end
  end
  print('loaded seq m8')
end
