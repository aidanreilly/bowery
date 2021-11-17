--- seq m8
-- creates variations on an external sequence
-- in1: sequencer 1v/oct
-- in2: clock
-- out1: voice 1 1v/oct
-- out2: voice 1 trig
-- out3: voice 2 1v/oct
-- out4: voice 2 trig

notes = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
-- transpose amount
t1 = 0
t2 = 0
-- clock div amount
d1 = 3
d2 = 1
-- sequins step amount
s1 = 1
s2 = 3

-- public params
public.add('trans 1', 0, {-2, 2}, function(v) t1 = v end)
public.add('trans 2', 0, {-2, 2}, function(v) t2 = v end)
public.add('clk/dv 1', 1, {1, 16}, function(v) d1 = v end)
public.add('clk/dv 2', 3, {1, 16}, function(v) d2 = v end)
public.add('sq stp 1', 3, {1, 15}, function(v) s1 = v end)
public.add('sq stp 2', 5, {1, 15}, function(v) s2 = v end)

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
  --make v1 notes 
  v1 = seq_1() + t1
  output[1].volts = v1
  output[2]:clock(d1) -- divided trig out
end

function sequence_2()
  v2 = seq_2() + t2
  output[3].volts = v2
  output[4]:clock(d2)
end

function init()
    input[2].mode('clock', 1)
    input[2].change = clock.run(function()
      while true do
        clock.sync(1)
        get_notes()
        sequence_1()
        sequence_2()
        end
    end)
    print('loaded seq m8')
end