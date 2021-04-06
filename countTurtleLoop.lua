local modemSide = "right"
local programToRun = "purpose" 
rednet.open("left")

while true do
id, msg, dist = rednet.receive() 
    if msg == "begin" then 
        shell.run( programToRun ) 
    end
end
