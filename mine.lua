local distance = 0
local curfuel = turtle.getFuelLevel()

print("how far do you want to go?")
local maxdistance = tonumber(read())

print("do you want the turtle to use fuel?(y/n)")
local usefuel = read()

print("how long do you want the branch to be?(in blocks)")
local branchlength = tonumber(read())

print("Do you want your turtle to wait for you?(y/n)")
local wait = read()


local loopcost = 4*3 + branchlength*4 *2

local notif = {
  "electrodynamics:deepslateoretin",
  "minecraft:deepslate_copper_ore",
}

local cellId = 11


local useless= {
  "minecraft:dirt",
  "minecraft:stone",
  "minecraft:cobblestone",
  "minecraft:gravel",
  "minecraft:sand",
  "minecraft:sandstone",
  "minecraft:clay",
  "minecraft:diorite",
  "minecraft:andesite",
  "minecraft:granite",
  "minecraft:dripstone",
  "minecraft:deepslate",
  "minecraft:cobbled_deepslate",
  "minecraft:tuff",
  "minecraft:flint",
  "minecraft:smooth_basalt",
  "minecraft:calcite",
  "minecraft:amethyst_block",
  "minecraft:budding_amethyst",
  "minecraft:moss_block",
  "minecraft:moss_carpet",
  "minecraft:water",
  "minecraft:lava",
  "minecraft:grass",
  "minecraft:grass_block",
  "minecraft:grass_path",
  "minecraft:mycelium",
  "minecraft:podzol",
  "minecraft:coarse_dirt",
  "minecraft:farmland",
  "computercraft:turtle_normal",
  "computercraft:turtle_advanced",
  "computercraft:computer_normal",
  "computercraft:computer_advanced",
  "computercraft:disk_drive",
  "computercraft:printer",
  "computercraft:monitor",
  "computercraft:advanced_monitor",
}

-- checks if an element is in a table
local function tablehas(t, v)
  for i=1, #t do
    if t[i] == v then
      return true
    end
  end
  return false
end

-- checks if the turtle has found a block and notifies the player
local function Notif(has_block, block)
  -- check if the turtle has a rednet modem
  local has_modem = peripheral.find("modem")
  if not has_modem then
    return
  end
  if has_block and tablehas(notif, block.name) then
    rednet.open("left")
    local name = os.getComputerLabel()
    local time = textutils.formatTime(os.time())
    local message = time .. " : " .. name .. " has found a " .. block.name .. "!\nHe will be waiting for you now. At distance " .. distance
    rednet.send(cellId, message, "NotifMine")
    rednet.close("left")

    -- Wait for turtle input
    print("Waiting for user input")
    os.pullEvent("key")
  end
end

local function mine()
  local function digAndMove()
    -- This function moves forward, digs, and moves back
    -- to its starting position.
    turtle.dig()
    turtle.forward()
    mine()
    turtle.back()
  end

  local function digAndMoveDown()
    -- This function moves down, digs, and moves up
    -- to its starting position.
    turtle.digDown()
    turtle.down()
    mine()
    turtle.up()
  end

  local function digAndMoveUp()
    -- This function moves up, digs, and moves down
    -- to its starting position.
    turtle.digUp()
    turtle.up()
    mine()
    turtle.down()
  end

  local function turnLeftAndInspect()
    -- This function turns left, inspects the block in front of it,
    -- and returns true if the block is not in the useless table.
    turtle.turnLeft()
    local has_block, data = turtle.inspect()
    Notif(has_block, data)
    return has_block and not tablehas(useless, data.name)
  end

  local function turnRightAndInspect()
    -- This function turns right, inspects the block in front of it,
    -- and returns true if the block is not in the useless table.
    turtle.turnRight()
    local has_block, data = turtle.inspect()
    Notif(has_block, data)
    return has_block and not tablehas(useless, data.name)
  end

  local function inspectAndMine()
    -- This function inspects the block in front of it,
    -- and mines it if it is not in the useless table.
    local has_block, data = turtle.inspect()
    Notif(has_block, data)
    if has_block and not tablehas(useless, data.name) then
      digAndMove()
    else
      turtle.dig()
    end
  end

  local top_has_block, top_data = turtle.inspectUp()
  Notif(top_has_block, top_data)
  if top_has_block and not tablehas(useless, top_data.name) then
    turtle.digUp()
    turtle.up()
    mine()
    turtle.down()
  else
    turtle.digUp()
  end

  if turnLeftAndInspect() then
    inspectAndMine()
  end

  if turnRightAndInspect() then
    inspectAndMine()
  end

  if turnRightAndInspect() then
    inspectAndMine()
  end

  if turnLeftAndInspect() then
    inspectAndMine()
  end

  local down_has_block, down_data = turtle.inspectDown()
  Notif(down_has_block, down_data)
  if down_has_block and not tablehas(useless, down_data.name) then
    turtle.digDown()
    turtle.down()
    mine()
    turtle.up()
  end
end


local function fuel()
    for i=1, 16 do
      turtle.select(i)
      if (turtle.getItemCount(i) ~= 0 and turtle.getItemDetail(i).name ~= "minecraft:chest" and turtle.refuel(turtle.getItemCount(i))) then return end
    end
end

local function dropUseless()
  for i=1, 16 do
    turtle.select(i)
    if (turtle.getItemCount(i) ~= 0) then
      for k,v in pairs(useless) do
        if (turtle.getItemDetail().name == v) then
          print("Dropping "..turtle.getItemDetail().name)
          turtle.drop()
          break
        end
      end

    end
  end
end

local function inv()
  total = 0
  for i=1, 16 do
    if turtle.getItemCount(i) ~= 0 then
      total=total+1
    end
  end
  return total
end

local function chest()
  chestPlaced = false
  for i=1, 16 do
    if (turtle.getItemCount(i) ~= 0 and turtle.getItemDetail(i).name == "minecraft:chest") then
      turtle.digDown()
      turtle.select(i)
      turtle.placeDown()
      chestPlaced = true
    end
  end

  if chestPlaced then
    print("Placed Chest")
    for i=1, 16 do
      if (turtle.getItemCount(i) ~= 0 and turtle.getItemDetail(i).name ~= "minecraft:chest") then
        turtle.select(i)
        turtle.dropDown()
      end
    end
  end

  return chestPlaced
end

local function tun (len)
  for i=1,len do
    mine()
    while turtle.forward() == false do turtle.dig() end
    turtle.digUp()
  end
end

while true do
  -- Refuel
  if usefuel == "y" then
    fuel()
  end
  -- Clear inventory of useless items
  dropUseless()

  -- Strip mining algorithm
  tun(3)
  tl(1)
  if turtle.detect() then -- if the tunnel is already dug turn around but if not dig the tunnel
    tun(branchlength)
    tl(2)
    gof(branchlength)
  else
    tr(2)
  end

  if turtle.detect() then -- if the tunnel is already dug turn around but if not dig the tunnel
    tun(branchlength)
    tl(2)
    gof(branchlength)
    tr(1)
  else
    tl(1)
  end



  -- make calculations to see if we need to go back to base
  distance = distance + 4
  curfuel = turtle.getFuelLevel()

  local futfuel = curfuel - loopcost - distance
  if futfuel <= 0 then
      print("Out of fuel, at distance "..distance)
      print("going back to base")
      tl(2)
      for i=1, distance do
        turtle.forward()
      end
      tl(2)
    break
  end

  -- on the center of the screen write the distance, the fuel and the number of items in the inventory
  term.clear()
  term.setCursorPos(1,1)
  print("Distance: "..distance)
  print("Fuel: "..curfuel)
  print("Items: "..inv())
  -- check if the turtle have to go back to base
  if distance >= maxdistance then
    print("Max distance reached, going back to base")
    tl(2)
    for i=1, distance do
      turtle.forward()
    end
    tl(2)
    break
  end

  -- Inventory Check
  if inv() == 16 then
    print("Invetory Full")
    if chest() == false then
      print("No Chests. Stopping.")
      break
    end
  end

  if wait == "y" then
    print("Press enter to continue")
    read()
  end

end