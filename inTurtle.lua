local real_currency_name = "minecraft:diamond"
local countTurtleID = 548
for i = 1, 27 do
    turtle.suck()
end

for i = 1, 16 do
    local data = turtle.getItemDetail(i)
        if data ~= nil then
            if data.name == real_currency_name then
                turtle.select(i)
                turtle.drop()
            else
                turtle.select(i)
                turtle.dropDown()
            end
        end
end

rednet.send(countTurtleID, "begin")