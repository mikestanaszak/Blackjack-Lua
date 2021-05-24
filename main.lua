term.redirect(peripheral.wrap("right"))
term.setBackgroundColor(colors.black)
local mon = peripheral.wrap("right")
mon.setTextScale(0.5)
mon.clear()

local modemSide = "left"

local inTurtleID = 559
local outTurtleID = 560

rednet.open(modemSide)

local bet = 0
local minBet = 2
local maxBet = 10

local accepted_currency = "Diamond"
local real_currency_name = "minecraft:diamond"

local mouseWidth = 0
local mouseHeight = 0
local w,h=mon.getSize()
local curx, cury
local amnt_due
local winner_payout
local winning_amount
local balance = 100

local playerValue = 0
local dealerValue = 0

local function center_printing (text)
	curx, cury = term.getCursorPos()
	term.setCursorPos((w-#text)/2,cury)
	term.write(text) --write the text
	term.setCursorPos(curx,cury+1)
	term.setCursorPos(1,math.floor(h/2)) 
end

local function paywinner(winning_amount)
	term.setCursorPos(1,13)
	winner_payout = winning_amount
	center_printing ("You have withdrawn "..winner_payout.." "..accepted_currency.."!!")
	rednet.send(outTurtleID, winner_payout)
	sleep(3)
	term.clear()
end

local function playWithdrawButtons()
	mon.setBackgroundColor((colours.green))
	term.setCursorPos(1,4)
	center_printing("Play")
	mon.setBackgroundColor((colours.red))
	term.setCursorPos(1,6)
	center_printing("Withdraw")
end

local function mainScreen()
	mon.setBackgroundColour((colours.black))
	term.clear()
	playWithdrawButtons()
	mon.setBackgroundColour((colours.black))
    term.setCursorPos(1,1)
    center_printing ("Please deposit "..accepted_currency.."(s) to play")
    term.setCursorPos(1,2)
    center_printing ("Current Balance: "..balance.. " " ..accepted_currency.."(s)")
end


local function updateChars(cards,actualcards)
	for key, value in pairs(actualcards.did) do
		if value == 1 or value == 14 or value == 27 or value == 40 then
			table.insert(cards.did,"A")
		elseif value == 2 or value == 15 or value == 28 or value == 41 then
			table.insert(cards.did,"2")
		elseif value == 3 or value == 16 or value == 29 or value == 42 then
			table.insert(cards.did,"3")
		elseif value == 4 or value == 17 or value == 30 or value == 43 then
			table.insert(cards.did,"4")
		elseif value == 5 or value == 18 or value == 31 or value == 44 then
			table.insert(cards.did,"5")
		elseif value == 6 or value == 19 or value == 32 or value == 45 then
			table.insert(cards.did,"6")
		elseif value == 7 or value == 20 or value == 33 or value == 46 then
			table.insert(cards.did,"7")
		elseif value == 8 or value == 21 or value == 34 or value == 47 then
			table.insert(cards.did,"8")
		elseif value == 9 or value == 22 or value == 35 or value == 48 then
			table.insert(cards.did,"9")
		elseif value == 10 or value == 23 or value == 36 or value == 49 then
			table.insert(cards.did,"10")
		elseif value == 11 or value == 24 or value == 37 or value == 50 then
			table.insert(cards.did,"J")
		elseif value == 12 or value == 25 or value == 38 or value == 51 then
			table.insert(cards.did,"Q")
		elseif value == 13 or value == 26 or value == 39 or value == 52 then
			table.insert(cards.did,"K")
		end
	end

	for key, value in pairs(actualcards.pid) do
		if value == 1 or value == 14 or value == 27 or value == 40 then
			table.insert(cards.pid,"A")
		elseif value == 2 or value == 15 or value == 28 or value == 41 then
			table.insert(cards.pid,"2")
		elseif value == 3 or value == 16 or value == 29 or value == 42 then
			table.insert(cards.pid,"3")
		elseif value == 4 or value == 17 or value == 30 or value == 43 then
			table.insert(cards.pid,"4")
		elseif value == 5 or value == 18 or value == 31 or value == 44 then
			table.insert(cards.pid,"5")
		elseif value == 6 or value == 19 or value == 32 or value == 45 then
			table.insert(cards.pid,"6")
		elseif value == 7 or value == 20 or value == 33 or value == 46 then
			table.insert(cards.pid,"7")
		elseif value == 8 or value == 21 or value == 34 or value == 47 then
			table.insert(cards.pid,"8")
		elseif value == 9 or value == 22 or value == 35 or value == 48 then
			table.insert(cards.pid,"9")
		elseif value == 10 or value == 23 or value == 36 or value == 49 then
			table.insert(cards.pid,"10")
		elseif value == 11 or value == 24 or value == 37 or value == 50 then
			table.insert(cards.pid,"J")
		elseif value == 12 or value == 25 or value == 38 or value == 51 then
			table.insert(cards.pid,"Q")
		elseif value == 13 or value == 26 or value == 39 or value == 52 then
			table.insert(cards.pid,"K")
		end
	end
end

local function displayCards(cards)
	mon.setBackgroundColour((colours.black))
	term.clear()
	local d = ""
	local p = ""
	if cards.key then
		for key, value in pairs(cards.did) do
			d = d.."    "..value
		end
		for key, value in pairs(cards.pid) do
			p = p.."    "..value 
		end
		mon.setBackgroundColor((colours.black))
		term.setCursorPos(1,3)
		center_printing("Dealer Hand: "..d)
		term.setCursorPos(1,5)
		center_printing("Your Hand: "..p)
	else
		for key, value in pairs(cards.pid) do
			p = p.."    "..value 
		end
		term.setCursorPos(1,3)
		mon.setBackgroundColor((colours.black))
		center_printing("Dealer Hand:     "..cards.did[1].."    ?")
		--center_printing("Dealer Hand:     "..cards.did[1].." "    ..cards.did[2])
		term.setCursorPos(1,5)
		center_printing("Your Hand: "..p)
	end
end

local function hitStandButtons()
	mon.setBackgroundColor((colours.grey))
	term.setCursorPos(1,15)
	center_printing("Hit")
	term.setCursorPos(1,18)
	center_printing("Stand")
	mon.setBackgroundColor((colours.black))
end

local List = {}

function List.new ()
    return {first = 0, last = -1}
end
List = List.new()
function List.pushleft (list, value)
	local first = list.first - 1
	list.first = first
	list[first] = value
end

function List.pushright (list, value)
	local last = list.last + 1
	list.last = last
	list[last] = value
end
  
function List.popleft (list)
	local first = list.first
	if first > list.last then error("list is empty") end
	local value = list[first]
	list[first] = nil        -- to allow garbage collection
	list.first = first + 1
	return value
end
  
function List.popright (list)
	local last = list.last
	if list.first > last then error("list is empty") end
	local value = list[last]
	list[last] = nil         -- to allow garbage collection
	list.last = last - 1
	return value
end

local function calculateScore(cards)
	List.pushright(List,0)
	local listLength = 1
	for key,value in pairs(cards.pid) do
		if(value == "A") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List,1 + temp)
				List.pushright(List,11 + temp)
				listLength = listLength + 1
			end
		elseif(value == "2") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 2 + temp)
			end
		elseif(value == "3") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 3 + temp)
			end
		elseif(value == "4") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 4 + temp)
			end
		elseif(value == "5") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 5 + temp)
			end
		elseif(value == "6") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 6 + temp)
			end
		elseif(value == "7") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 7 + temp)
			end
		elseif(value == "8") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 8 + temp)
			end
		elseif(value == "9") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 9 + temp)
			end
		else
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 10 + temp)
			end
		end
	end

	local bool = true
	playerValue = 0
	for i=1, listLength do
		local temp = List.popleft(List)
		if (playerValue < temp and temp <= 21) then
			playerValue = temp
			bool = false
		end
	end

	if (bool) then
		playerValue = 22
	end

	listLength = 1
	List.pushright(List, 0)

	for key,value in pairs(cards.did) do
		if(value == "A") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List,1 + temp)
				List.pushright(List,11 + temp)
				listLength = listLength + 1
			end
		elseif(value == "2") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 2 + temp)
			end
		elseif(value == "3") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 3 + temp)
			end
		elseif(value == "4") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 4 + temp)
			end
		elseif(value == "5") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 5 + temp)
			end
		elseif(value == "6") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 6 + temp)
			end
		elseif(value == "7") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 7 + temp)
			end
		elseif(value == "8") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 8 + temp)
			end
		elseif(value == "9") then
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 9 + temp)
			end
		else
			for i=1, listLength do
				local temp = List.popleft(List)
				List.pushright(List, 10 + temp)
			end
		end
	end
	bool = true
	dealerValue = 0
	for i=1, listLength do
		local temp = List.popleft(List)
		if (dealerValue < temp and temp <= 21) then
			dealerValue = temp
			bool = false
		end
	end

	if (bool) then
		dealerValue = 22
	end
end

local function playHand()
	local actualcards = {pid = {}, did = {}}
	local cardChars = {pid ={}, did = {}}
	local temp = 0
	playerValue = 0
	dealerValue = 0
	table.insert(actualcards.pid, math.random(1,52))
	while true do
		temp = math.random(1,52)
		if temp ~= actualcards.pid[1] then
			table.insert(actualcards.pid,temp)
			break
		end
	end
	while true do
		temp = math.random(1,52)
		if actualcards.pid[1] ~= temp and actualcards.pid[2] ~= temp then
			table.insert(actualcards.did, temp)
			break
		end
	end
	while true do
		temp = math.random(1,52)
		if temp ~= actualcards.did[1] and temp ~= actualcards.pid[1] and temp ~= actualcards.did[2] then
			table.insert(actualcards.did,temp)
			break
		end
	end
	cardChars.key = false
	updateChars(cardChars, actualcards)
	displayCards(cardChars)
	calculateScore(cardChars,playerValue,dealerValue)
	if playerValue == 21 then
		mon.setBackgroundColor((colors.green))
		term.clear()
		term.setCursorPos(1,16)
		center_printing("You have won x3 "..bet.." Diamond(s)")
		mon.setBackgroundColor((colors.black))
		balance = balance + bet * 3
		sleep(2)
		mainScreen()
		return
	end
	while true do
		cardChars = {pid = {}, did = {}}
		updateChars(cardChars, actualcards)
		displayCards(cardChars)
		hitStandButtons()
		calculateScore(cardChars,playerValue,dealerValue)
		--print(playerValue.." "..dealerValue)
		if(playerValue > 21) then
			mon.setBackgroundColor((colors.red))
			term.clear()
			term.setCursorPos(1,16)
			center_printing("You have lost, you busted!")
			mon.setBackgroundColor((colors.black))
			bet = 0
			sleep(2)
			mainScreen()
			return
		end
		local event, value1, value2, value3, value4 = os.pullEvent()
		if event == "monitor_touch" then
			if value3 == 15 then
				while true do
					local temp = math.random(1,52)
					local bool = true
					for key,value in pairs(actualcards.pid) do
						if temp == value then
							bool = false
							break
						end
					end
					for key,value in pairs(actualcards.did) do
						if temp == value then
							bool = false
							break
						end
					end
					if bool then
						table.insert(actualcards.pid,temp)
						break
					end
				end
			elseif value3 == 18 then
				while true do
					cardChars = {pid = {}, did = {}}
					cardChars.key = true
					updateChars(cardChars, actualcards)
					displayCards(cardChars)
					hitStandButtons()
					calculateScore(cardChars,playerValue,dealerValue)
					print(playerValue.." "..dealerValue)
					sleep(1)
					if dealerValue >= 17 then
						if dealerValue > 21 then
							mon.setBackgroundColor((colors.green))
							term.clear()
							term.setCursorPos(1,16)
							center_printing("You have won, dealer bust")
							mon.setBackgroundColor((colors.black))
							balance = balance + bet * 2
							sleep(2)
							mainScreen()
							return
						elseif dealerValue > playerValue then
							mon.setBackgroundColor((colors.red))
							term.clear()
							term.setCursorPos(1,16)
							center_printing("You have lost, Dealer had "..dealerValue.." and you had "..playerValue)
							mon.setBackgroundColor((colors.black))
							bet = 0
							sleep(2)
							mainScreen()
							return
						elseif dealerValue == playerValue then
							mon.setBackgroundColor((colours.grey))
							term.clear()
							term.setCursorPos(1,16)
							center_printing("You have tied, Dealer had "..dealerValue.." and you had "..playerValue)
							mon.setBackgroundColor((colors.black))
							balance = balance + bet
							bet = 0
							sleep(2)
							mainScreen()
							return
						elseif dealerValue < playerValue then
							mon.setBackgroundColor((colors.green))
							term.clear()
							term.setCursorPos(1,16)
							center_printing("You have won, Dealer had "..dealerValue.." and you had "..playerValue)
							mon.setBackgroundColor((colors.black))
							balance = balance + bet * 2
							bet = 0
							sleep(2)
							mainScreen()
							return
						end
					else
						while true do
							local temp = math.random(1,52)
							local bool = true
							for key,value in pairs(actualcards.pid) do
								if temp == value then
									bool = false
									break
								end
							end
							for key,value in pairs(actualcards.did) do
								if temp == value then
									bool = false
									break
								end
							end
							if bool then
								table.insert(actualcards.did,temp)
								break
							end
						end
					end
				end
			end
		end
	end
end

local function betButtons()
	while true do
		mon.setBackgroundColour((colours.black))
		term.clear()
		term.setCursorPos(1,1)
    	center_printing ("How much would you like to bet?")
		term.setCursorPos(1,2)
		center_printing ("Current Balance: "..balance.. " " ..accepted_currency.."(s)")
		term.setCursorPos(1,3)
		center_printing ("Current Bet: " ..bet.. " " ..accepted_currency.. "(s)")
		term.setCursorPos(1,7)
		mon.setBackgroundColour((colours.green))
		center_printing ("Increase Bet +1")
		term.setCursorPos(1,9)
		mon.setBackgroundColour((colours.red))
		center_printing ("Descrease Bet -1")
		term.setCursorPos(1,20)
		mon.setBackgroundColour((colours.grey))
		center_printing ("Play Hand")
		local event, value1, value2, value3, value4 = os.pullEvent()
		if event == "monitor_touch" then
			if value3 == 7 then
				if balance >= bet + 1 then
					bet = bet + 1
				else
					term.setCursorPos(1,12)
					mon.setBackgroundColour((colours.red))
					center_printing ("Error: Cannot increase bet size")
					sleep(1)
				end
			elseif value3 == 9 then
				if bet ~= 1 then
					bet = bet - 1
				else
					term.setCursorPos(1,12)
					mon.setBackgroundColour((colours.red))
					center_printing ("Error: Cannot decrease bet size")
					sleep(1)
				end
			elseif value3 == 20 then
				if bet > 0 then
					balance = balance - bet
					break
				end
			end
		end
	end
	playHand()
end
mainScreen()
while true do
	local event, value1, value2, value3, value4 = os.pullEvent()
	if event == "rednet_message" then
		balance = value2 + balance
		mainScreen()
	elseif event == "monitor_touch" then
		if value3 == 4 then
			if balance > 0 then
				bet = balance
				betButtons()
			else 
				mon.setBackgroundColour((colours.red))
				term.setCursorPos(1,10)
				center_printing ("Error: Put money in before attempting to play")
				sleep(1)
				mainScreen()
			end
		elseif value3 == 6 then
			if balance > 0 then
				paywinner(balance)
				balance = 0
				mainScreen()
			else 
				mon.setBackgroundColour((colours.red))
				term.setCursorPos(1,10)
				center_printing ("Error: You need money in order to withdraw")
				sleep(1)
				mainScreen()
			end
		end
	end
end
