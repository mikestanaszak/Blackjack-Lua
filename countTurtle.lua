local mainCompID = 542

local betCount = 0
for i = 1, 27 do
    turtle.suck()
end

for i = 1, 16 do
    local num = turtle.getItemCount(i)
    if num > 0 then
        betCount = betCount + num
        turtle.select(i)
        turtle.turnRight()
        turtle.drop()
        turtle.turnLeft()
    end
end
rednet.send(mainCompID, betCount)