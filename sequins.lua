s = sequins
repetitions = s{3,5,7}
notes = s{9,5,7,0,14,2}
steps = s{2,1,-2,3}
rhythms = s{1/4,1/3,1,1/2,1/6}

function init()
  --wsyn setup
  --todo make this settable from a global preset    
  ii.pullup(true)
  ii.wsyn.ar_mode(1)--0 or 1, 0 is constant on
  ii.wsyn.curve(-5)
  ii.wsyn.ramp(0)
  ii.wsyn.fm_index(0.01)
  ii.wsyn.fm_env(1)
  ii.wsyn.fm_ratio(4,1)
  ii.wsyn.lpg_time(0.1)
  ii.wsyn.lpg_symmetry(-5)
  go()
end

function arp(sync_value)
  for i = 1,repetitions() do
    clock.sync(sync_value)
    output[1].volts = notes()/12
    output[2](pulse())
    ii.wsyn.play_note(notes()/12, 2)
  end
  notes:step(steps())
  go()
end

function go()
  seq = clock.run(arp,rhythms())
end

function stop()
  clock.cancel(seq)
end