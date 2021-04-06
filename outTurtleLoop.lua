function spitOut(i)
    local num = math.ceil(i / 64)
    local stacks = math.floor(i/64)
    local leftOver = i % 64

    for j = 1, num do
        turtle.suck()
    end
    
    for j = 1, stacks do
        for k = 1, 16 do
            if turtle.getItemDetail(k) ~= nil then
                if turtle.getItemCount(k) == 64 then
                    turtle.select(k)
                    turtle.dropUp()
                    break
                end
            end
        end
    end

    for j = 1, 16 do
        if turtle.getItemDetail(j) ~= nil then
            turtle.select(j)
            turtle.dropUp(leftOver)
        end
    end
    turtle.drop()
end

local modemSide = "right"
local programToRun = "purpose" 
rednet.open("left")

while true do
id, msg, dist = rednet.receive() 
    if msg ~= nil then 
        spitOut(msg)
    end
end