-- this program is a will control a turtle to harvest and plant a field
-- the turtle will start at the top of the field and work down
-- the turtle will harvest potatoes that have the age of 7

function getItemIndex(itemName)
    for slot = 1, 16, 1 do
        local item = turtle.getItemDetail(slot)
        if(item ~= nil) then
            if(item["name"] == itemName) then
                return slot
            end
        end
    end
end

function doPotato()
    isBlock, data = turtle.inspect()
    if(isBlock) then
        if(data["name"] == "minecraft:potatoes") then
            if(data["state"]["age"] == 7) then

                turtle.dig()
                turtle.suck()

                turtle.select(getItemIndex("minecraft:potato"))
                turtle.place()
            end
        end
    else
        turtle.select(getItemIndex("minecraft:potato"))
        turtle.place()
    end
end


while true do
    -- check left side for potatoes
    turtle.turnLeft()

    doPotato()  --harvest potato

    -- check right side for potatoes
    turtle.turnRight()
    turtle.turnRight()

    doPotato()  --harvest potato

    turtle.turnLeft()

    isBlock, data = turtle.inspect()
    if not isBlock then
        turtle.forward()
    else

        -- if there is a chest in front of us, drop all the potatoes but keep 64 of them

        if data["name"] == "minecraft:chest" then
            -- get all the slot with potatoes
            local slots = {}
            for slot = 2, 16, 1 do
                local item = turtle.getItemDetail(slot)
                if(item ~= nil) then
                    if(item["name"] == "minecraft:potato") then
                        table.insert(slots, slot)
                    end
                end
            end

            -- drop all the potatoes
            for _, slot in pairs(slots) do
                turtle.select(slot)
                turtle.drop()
            end
        end

        turtle.turnRight()
        turtle.turnRight()
        sleep(60*2)
    end
end