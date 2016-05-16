--ZeldaA/I Basic Stuff

--Notes
--11a638 b button 59 is equipped 
--11a66d inventory 1 sword 17 sword and shield 
--1d8e45,e3d is what equipment is being shown on the equipment menu, 62 is deku shield, 59  is kokiri sword
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
--1daa36 is if you're in a player-started text box, 1 or 0, 0 if not
--11a641 is what shield is equipped, 17 is deku shield
--1daa98 is something to do with speed, 2 bytes float
--1daaa4 is some collison check, 128 if collison
--0x800000 bytes are hard to get through
 
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
-Shop 45
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
prevcount=memory.readbyte(0x11a60) --Number of rupees
cladder=true--do we need to go down the ladder
maxfitness=-100--Maximum fitness that has been achieved
maxstate=-1 --Maximum state that has been achieved

--Test Functions

--Test Function 1 Press Start
function pressStart()
	if key["Start"]==true then --Requires pressing and releasing 
		key["Start"]=false
		joypad.set(key,1)
	else
		key["Start"]=true
		joypad.set(key,1)
	end
end--Doesn't actually need to release

--Press A
function pressA()--Probably can use Test function X-10.23, same results without over calculating fitness
	if key["A"]==true then
		key["A"]=false
		joypad.set(key,1)
	else
		key["A"]=true
		joypad.set(key,1)
	end
end

--Test Function X-10.23
function pressAandRight() --For textboxes, pressing A and Right handles textboxes, including the shop textboxes
	key["A Right"]=true	
	joypad.set(key,1)
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	emu.frameadvance()
	if key["A"]==true then
		key["A"]=false
		joypad.set(key,1)
	else
		key["A"]=true
		joypad.set(key,1)
	end
	frames=frames+14 --For sufficient buffering
end

--Test Function 2 Move Up
function moveUp()
	key["A Up"]=true
	joypad.set(key,1)
end

--Read B Button, reads what item is on the bButton, Test Function
function readBButton()
	bButton=memory.readbyte(0x11a638)
	return bButton
end

--Test B Button, Test function
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

--Core Fitness Functions

function checkState(ladder) --Check the state
	if memory.readbyte(0x1c8545)==52 then --Intro
		state=0
		cladder=true
	end
	if ladder==true and memory.readfloat(0x1DAA58,true)>=-20 and memory.readbyte(0x1c8545)==85 then--Balcony
		cladder=true
		state=1
	elseif memory.readbyte(0x1d8b81)==13 then
		state=1
		cladder=true
	elseif memory.readbyte(0x11a66d)==0 and memory.readbyte(0x1c8545)==85 then--Bottom of ladder
		state=2
	end
	if memory.readfloat(0x1DAA58,true)==-80 then
		cladder=false
	end
	if memory.readbyte(0x11a66d)==1 and memory.readbyte(0x11a638)~=59 then -- Equip Sword
		state=3
	end
	if memory.readbyte(0x11a638)==59 and memory.readbyte(0x11a66d)==1 then --Collect Rupees and get shield
		state=4
	end
	if memory.readbyte(0x11a641)~=17 and memory.readbyte(0x11a66d)==17  then--Equip Shield
		state=5
	end
	if memory.readbyte(0x11a641)==17 then --Enter Deku Tree
		state=6
	end
	return state
end

function maxState(state)--What's the highest state the AI has achieved
	if state>maxstate then
		maxstate=state
		maxfitness=0
	end
	return maxstate
end

function calculateFitness(state,prevcount) --Calculate the fitness
	fitness=0 --Make sure fitness is zeroed
	if state==0 then --Pre Kokiri Forest
		fitness=fitness+10000-math.abs(0-memory.readfloat(0x1DAA54,true))
		fitness=fitness+10000-math.abs(0-memory.readfloat(0x1DAA58,true))
		fitness=fitness+10000-math.abs(-202-memory.readfloat(0x1DAA5C,true))
	end
	if state==1 then --Ladder
		fitness=fitness+10000-math.abs(-80-memory.readfloat(0x1DAA58,true))
		if memory.readbyte(0x1c8545)~=85 then
			fitness=0
		end
	end
	if state==2 then --Getting the Sword
		fitness=fitness+10000-math.abs(-784-memory.readfloat(0x1DAA54,true))
		fitness=fitness+10000-math.abs(120-memory.readfloat(0x1DAA58,true))
		fitness=fitness+10000-math.abs(1045-memory.readfloat(0x1DAA5C,true))/6
		if memory.readbyte(0x11a66d)==1 then
			fitness=fitness+20000
		end
		if memory.readbyte(0x1c8545)~=85 then
			fitness=0
		end
	end
	if state==3 then --Equipping Sword
		if memory.readbyte(0x101918)==1 then
			fitness=1000
		end
		if memory.readbyte(0x1d8e3d)==59 then
			fitness=2000
		end
		if memory.readbyte(0x11a638)==59 then
			fitness=3000
		end
		if  memory.readbyte(0x101918)==0 then
			fitness=0
		end
	end
	if state==4 then --Rupees Collecting
		fitness=1000*(memory.readbyte(0x11a605))
		if prevcount < memory.readbyte(0x11a605) then
			fitness=fitness+10000
			prevcount=memory.readbyte(0x11a60)
		end
		if memory.readbyte(0x11a605)>=40 then
			fitness=40000
			if memory.readbyte(0x1c8545)==45 then
				fitness=fitness+10000
			end
			if memory.readbyte(0x1db085) ==30 and memory.readbyte(0x1db086)==136 then
				fitness=fitness+10000
			end
			if memory.readbyte(0x11a66d)==17 then
				fitness=fitness+20000
			end
		end
	end
	if state==5 then --Equipping Shield
		if memory.readbyte(0x101918)==1 then
			fitness=1000
		end
		if memory.readbyte(0x1d8e45)==62 then
			--press the A button
			fitness=2000
		end
		if memory.readbyte(0x101918)==0 then
			fitness=0
		end
	end
	if state==6 then --Mido and Getting to the deku tree
		--Deku tree entrance (4250. -155, -1380)
		fitness=fitness+10000-math.abs(4250-memory.readfloat(0x1DAA54,true))
		fitness=fitness+10000-math.abs(-155-memory.readfloat(0x1DAA58,true))
		fitness=fitness+10000-math.abs(-1380-memory.readfloat(0x1DAA5C,true))
		if memory.readbyte(0x1c8545)==85 then
			fitness=fitness+20000
		end
		if memory.readbyte(0x1c8545)~=85 then
			fitness=0
		end
	end
	fitness=fitness+maxstate*100000 --Reward being at a higher state
	if maxState(state)~=state then --Punish for being at a lower state
		fitness=-1
	end
	if fitness>maxfitness then --Set max fitness
		maxfitness=fitness
	end
	return fitness
end

--Main Loop

while true do
   --Statements
	if frames%60==0 then --Used for testing/seeing fitness values
		console.log(calculateFitness(checkState(cladder),prevcount))
		console.log(checkState(cladder))
		console.log(maxstate)
	end
	if memory.readbyte(0x1daa36)==1 then--Textboxes
		pressAandRight()
	end
	emu.frameadvance() --Advance the emulator one frame
	frames=frames+1
end