-- this program is used to bore a tunnel in a straight line
-- the tunnel is 3x3 blocks
-- the tunnel is 3 blocks high
-- the tunnel is 3 blocks wide

local args = {...}

if #args ~= 1 then
  print("Usage: tunel <length>")
  return
end

local length = tonumber(args[1])

if length == nil then
  print("Usage: tunel <length>")
  return
end

local function dig()
  while turtle.detect() do
	turtle.dig()
  end
end

local function digUp()
  while turtle.detectUp() do
	turtle.digUp()
  end
end

local function digDown()
  while turtle.detectDown() do
	turtle.digDown()
  end
end

local function forward()
  while not turtle.forward() do
	turtle.dig()
  end
end

local function up()
  while not turtle.up() do
	turtle.digUp()
  end
end

local function down()
  while not turtle.down() do
	turtle.digDown()
  end
end

for i=1, length do
	dig()
	forward()
	digUp()
	turtle.turnLeft()
	dig()
	up()
	dig()
	turtle.turnRight()
	turtle.turnRight()
	dig()
	down()
	dig()
	turtle.turnLeft()
end