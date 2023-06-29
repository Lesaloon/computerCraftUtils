-- this program will excavate a mine of arbitrary size

local args = {...}
local len = tonumber(args[1])
local width = tonumber(args[2])
local height = tonumber(args[3])

-- compute the path length of the turtle
local pathlength = 2*len + 2*width + 2*height

-- compute the fuel cost of the turtle
local fuelcost = 2*len + 2*width + 2*height + 2*len*width + 2*len*height + 2*width*height

-- check if the turtle has enough fuel
if turtle.getFuelLevel() < fuelcost then
  print("Not enough fuel")
  return
end

for x=1, width do
    for y=1, height do
        for z=1, len do
            turtle.dig()
            turtle.forward()
        end
        -- go back to the start of the line
        for z=1, len do
            turtle.back()
        end
        -- go up one block
        turtle.digUp()
        turtle.up()
    end
    -- go back to the start of the line
    for y=1, height do
        turtle.down()
    end
    -- go to the next line
    turtle.turnRight()
    turtle.dig()
    turtle.forward()
    turtle.turnLeft()
end
-- go back to the start of the line
for x=1, width do
    turtle.back()
end
