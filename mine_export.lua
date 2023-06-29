local distance = 0
local curfuel = turtle.getFuelLevel()

print("how far do you want to go?")
local maxdistance = tonumber(read())

print("how long do you want the branch to be?(in blocks)")
local branchlength = tonumber(read())


local loopcost = 4*3 + branchlength*4 *2

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
}


function tl (c)
  for i=1, c do
    turtle.turnLeft()
  end
end

function tr (c)
  for i=1, c do
    turtle.turnRight()
  end
end

function tun (len)
  for i=1,len do
    turtle.dig()
    while turtle.forward() == false do turtle.dig() end
    turtle.digUp()
  end
end

function gof (len)
  for i=1, len do
    while turtle.forward() == false do turtle.dig() end
  end
end

function dropUseless()
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

function inv()
  total = 0
  for i=1, 16 do
    if turtle.getItemCount(i) ~= 0 then
      total=total+1
    end
  end
  return total
end

function chest()
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

while true do

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

end