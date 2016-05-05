--ZeldaA/I Basic Stuff

--Notes
--11a638 b button 59 is equipped 
--11a66d inventory 1 sword 17 sword and shield 
--1d8e45 is what equipment is being shown on the equipment menu, 62 is deku shield, 59  is kokiri sword
--1c8545 is what room you're in, 45 is kokiri shop
--1db085 is the person you're talking to, 2 bytes, 7975 is Mido, 7816 is the shop owner, may be possible others 
--11a605 is the rupee counter, really is 2 bytes, only need this one tho
--1d8b81 is what is on the A button
--118C18, something to do with links facing direction, 4 bytes as of now, maybe NOT ACTUALLY DIRECTION
--1DAA54 is the x coordinate, 4 byte float
--1DAA58 is the y coordinate, 4 byte float
--1DAA5C is the z coordinate, 4 byte float
--1ca112 is how many pick-up-able actors (hearts rupees) are in the current map
--101918 is if you're are paused or not, 1 or 0, 0 if not
--1daa36 is if you're in a text box, 1 or 0, 0 if not
--11a641 is what shield is equipped, 17 is deku shield
--1daa98 is something to do with speed, 2 bytes float
 
--[[
--Specific Places
-Exit of Link's House (0,0,-202)
-Bottom of the Ladder (-29.59, -80,987.9)
-In front of crawlspace (-784, 120, 1045)
-In front of sword chest (-231.0055, 178, 2211)
-Deku shop entrance ( 858 ,0,-427)
-Deku shop exit (0,0, 213) 
-Deku tree entrance (4250. -155, -1380)

--Area Values
-Link's House 52
-Kokiri Forest 85
-Mido's House 40
-Inside the Deku Tree 0 (Kinda messed up but it'll work)

--People Values
-Mido 7975
-Shop Owner 7816

--A button Values
-Enter 2
-Open 4
-Decide 6
-Speak 15
-Next 16


]]--
--Declarations 	

key={}--Key array, used for button presses
maxfitness=0--Max Fitness Variable
frames=0 --Total Number of Frames, Emulator runs at ~60fps I think
state=0 --What state/part of the quest we are on

--Test Function 1 Press Start
function pressStart()
	if key["Start"]==true then 
		key["Start"]=false
		joypad.set(key,1)
	else
		key["Start"]=true
		joypad.set(key,1)
	end
end

--Press A
function pressA()
	if key["A"]==true then
		key["A"]=false
		joypad.set(key,1)
	else
		key["A"]=true
		joypad.set(key,1)
	end
end

--Test Function X-10.23
function pressAandRight()
	if key["A Right"]==true then
		key["A Right"]=false
		joypad.set(key,1)
	else
		key["A Right"]=true
		joypad.set(key,1)
	end
	emu.frameadvance()
	if key["A"]==true then
		key["A"]=false
		joypad.set(key,1)
	else
		key["A"]=true
		joypad.set(key,1)
	end
end

--Test Function 2 Move Up
function moveUp()
	key["A Up"]=true
	joypad.set(key,1)
end

--Read B Button
function readBButton()
	bButton=memory.readbyte(0x11a638)
	return bButton
end

--Test B Button
function TestBButton(value)
	if value == 59 then
		return true
	end
	return false
end

--Get Rupee Count
function getRupees()
	rupees=memory.readbyte(0x11a605)
	return rupees
end

--Check Rupee Count
function checkRupees(value)
	if value == 40 then
		return true
	end
	return false
end

--[[
function checkState() --Check the state
	if in_links_room then
		state=0
	end
	if no_sword then
		state=1
	end
	if sword and not_sword_onB then
		state=3
	end
	if sword_onB and noShield then
		state=4
	end
	if not_shield_equip then
		state=5
	end
	if shield_equip then
		state=6
	end
	return state
end

function calculateFitness(state) --Calculate the fitness
	fitness=0
	if state==0 then --Pre Kokiri Forest
		fitness+=10000-abs(goalx-linkx)
		fitness+=10000-abs(goaly-linky)
		fitness+=10000-abs(goalz-linkz)
	end
	if state==1 then --Getting the Sword
		fitness+=10000-abs(goalx-linkx)
		fitness+=10000-abs(goaly-linky)
		fitness+=10000-abs(goalz-linkz)
		if sword_inventory
			fitness+=20000
		end
	end
	if state==3 then --Equipping Sword
		if in_menu==true then
			fitness=1000
		end
		if cursor==sword then
			fitness=2000
		end
		if b_button==sword then
			fitness=3000
		end
		if in_menu==false then
			fitness=0
		end
	end
	if state==4 then --Rupees Collecting
		fitness=40000-1000*(current_rupee_count)
		if prev_rupee_count < current_rupee_count then
			fitness+=10000
		end
		if current_rupee_count==40 then
			if in_shop then
				fitness+=10000
			end
			if talking_to_shopkeep then
				fitness+=10000
			end
			if shield_inventory then
				fitness+=20000
			end
		end
	end
	if state==5 then --Equipping Shield
		if in_menu==true then
			fitness=1000
		end
		if cursor==sword then
			pressA()
			fitness=2000
		end
		if in_menu==false then
			fitness=0
		end
	end
	if state==6 then --Mido and Getting to the deku tree
		fitness+=10000-abs(goalx-linkx)
		fitness+=10000-abs(goaly-linky)
		fitness+=10000-abs(goalz-linkz)
		Might be two different maps
	end
	return fitness
end

function pressACheck() --Press A when specific stuff happens
	if a_button==open then
		press the a button
	end 
	if a_button==speak then
		press the a button
		check for person importance
	end
	if deciding then
		move right
		press a_button
	end
	if speaking then
		press the A button
		press right --For the shop
	end
end
]]--

while true do
   --Statements
	pressAandRight()
	emu.frameadvance()
end
