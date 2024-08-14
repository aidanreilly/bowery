--- Music Mouse Emulator for Crow
-- This script emulates the behavior of Laurie Spiegel's Music Mouse software, which generates melodies by tracing a grid of squares with a cursor.
-- The cursor position and direction are controlled by CV inputs, and the melody is output as a sequence of voltages.

-- Set the grid size
grid_size = 8

-- Define the grid
grid = {}
for i = 1, grid_size do
  grid[i] = {}
  for j = 1, grid_size do
    grid[i][j] = 0
  end
end

-- Set the initial cursor position
cursor_x = 1
cursor_y = 1
cursor_direction = 1 -- 1: up, 2: right, 3: down, 4: left

-- Set the output scale (in semitones)
output_scale = {0, 2, 4, 5, 7, 9, 11}

-- Define the output sequence
output_sequence = {}
output_index = 1

-- Input and Output Definitions
input[1].mode('stream', 0.01) -- Set input 1 to stream mode with a poll time of 0.01 seconds
input[2].mode('stream', 0.01) -- Set input 2 to stream mode with a poll time of 0.01 seconds
output[1].slew = 0.01 -- Set output 1 slew time to 0.01 seconds

-- Main Loop
function process()
  -- Read input voltages
  local x_cv = input[1].volts -- CV input for cursor x-position
  local y_cv = input[2].volts -- CV input for cursor y-position
  
  -- Update cursor position and direction based on CV inputs
  if x_cv > 0 then
    cursor_x = cursor_x + 1
    if cursor_x > grid_size then
      cursor_x = 1
    end
    cursor_direction = 2 -- right
  elseif x_cv < 0 then
    cursor_x = cursor_x - 1
    if cursor_x < 1 then
      cursor_x = grid_size
    end
    cursor_direction = 4 -- left
  end
  if y_cv > 0 then
    cursor_y = cursor_y - 1
    if cursor_y < 1 then
      cursor_y = grid_size
    end
    cursor_direction = 1 -- up
  elseif y_cv < 0 then
    cursor_y = cursor_y + 1
    if cursor_y > grid_size then
      cursor_y = 1
    end
    cursor_direction = 3 -- down
  end
  
  -- Get the current square value and update it
  local value = grid[cursor_x][cursor_y]
  grid[cursor_x][cursor_y] = (value + 1) % 8
  
  -- Calculate the output voltage based on the current square value and cursor direction
  local note = output_scale[value + 1] + (cursor_direction - 1) * 12 -- Calculate note based on square value and cursor direction
  local frequency = 440 * 2^(note/12) -- Calculate frequency based on note
  output_sequence[output_index] = frequency -- Add frequency to output sequence
  output_index = output_index + 1
  if output_index > 16 then
    output_index = 1
  end
end

-- Output the current frequency
output[1].volts = output_sequence[1] -- Set output 1 voltage to the first frequency in the sequence
for i = 1, 15 do
  output_sequence[i] = output_sequence[i+1] -- Shift the output sequence to the left
end
output_sequence[16] = nil -- Remove the last frequency from the sequence
 