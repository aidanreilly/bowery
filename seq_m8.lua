--- seq m8
-- creates variations on an external sequence
-- in1: sequencer 1v/oct
-- in2: clock
-- out1: voice 2 1v/oct
-- out2: voice 2 trig
-- out3: bass 1v/oct
-- out4: bass trig

notes = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

-- make a new sequins from notes by passing it as the argument to the 'sequins' function
notes_sequins = sequins(notes)

-- set up the sequins
seq_1 = notes_sequins:step(3)
seq_2 = notes_sequins:step(5)

function sequence()
  -- get notes from external seq into 16 stage shift register
  table.remove(notes)
  table.insert(notes, 1, input[1].volts)
  --make notes
  output[1].volts = seq_1()
  output[3].volts = seq_2()
  --make gates
  output[2](pulse())
  output[4](pulse())
end

function init()
    input[2]{mode = 'change', direction = 'rising'}
    input[2].change = sequence
    print('seq m8 loaded m8')
end