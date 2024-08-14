---bouncing ball trigger thing

HEIGHT = 10 -- initial height
TIME = 0.2 -- half of first bounce time
ENERGY = 0.5 -- how much energy is preserved each bounce (out of 1.0)
-- height, bouncetime will change as the ball bounces
height = 10
bouncetime = 0.4 

function init()
  input[1]{ mode = 'change', direction = 'rising' }
end

input[1].change = function()
  reset()
  output[1].action = bouncing_ball_trigger 
  print 'bounce'
end

function reset()
  height = HEIGHT
  bouncetime = TIME
end

function bounce()
  height = height * ENERGY
  bouncetime = bouncetime * ENERGY
  if bouncetime < 0.002 then reset() end -- reset the ball when done bouncing
  print (bouncetime)
  return height
end


-- yeah but wtf time is not declared :/

bouncing_ball_trigger =
loop{ to( bounce(), time, 'log' ) -- bounce is a function & will be called each time around  
  , to( bounce(), time, 'log' )
  , to( bounce(), time, 'log' )
  , to( bounce(), time, 'log' )
  , to( bounce(), time, 'log' )
  , to( bounce(), time, 'log' )
  , to( 0, time, 'expo' )
    }
