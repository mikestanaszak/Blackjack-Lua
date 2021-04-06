local modemSide = "right"
local programToRun = "purpose" 
rednet.open("right")

while true do
    sleep(0.5)
    shell.run( programToRun ) 
end
