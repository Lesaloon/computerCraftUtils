-- this program is used to make a staircase down to the desired level
-- the first argument is the number of blocks to go down
-- the second argument is the number of blocks to go forward

local args = {...}
local down = tonumber(args[1])
local forward = tonumber(args[2])

-- for how many blocks the turtle have to forward to make the staircase
local forwardcount = 0
local downcount = 0
local ratio = down / forward;
-- round the ratio to the nearest integer
ratio = math.floor(ratio + 0.5)

-- now every loop the turtle will go down one block
-- and forward ratio blocks

while downcount < down do
	turtle.digDown()
	while turtle.down() == false do turtle.digDown() end
	downcount = downcount + 1
	forwardcount = 0
	while forwardcount < ratio and forwardcount < forward do
		turtle.dig()
		while turtle.forward() == false do turtle.dig() end
		forwardcount = forwardcount + 1
	end
end
