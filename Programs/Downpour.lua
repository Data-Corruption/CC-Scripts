-- Rows and Columns Variables
local Rows = 4
local Columns = 4

-- Target Blocks/Ores
local targetBlocks = {
  "minecraft:coal_ore", 
  "minecraft:iron_ore", 
  "minecraft:gold_ore", 
  "minecraft:redstone_ore", 
  "minecraft:lapis_ore", 
  "minecraft:diamond_ore", 
  "minecraft:emerald_ore", 
  "minecraft:deepslate_coal_ore", 
  "minecraft:deepslate_iron_ore", 
  "minecraft:deepslate_gold_ore", 
  "minecraft:deepslate_redstone_ore", 
  "minecraft:deepslate_lapis_ore", 
  "minecraft:deepslate_diamond_ore", 
  "minecraft:deepslate_emerald_ore", 
  "minecraft:obsidian", 
  "minecraft:glowstone", 
  "minecraft:netherrack", 
  "minecraft:nether_quartz_ore", 
  "minecraft:nether_gold_ore", 
  "minecraft:nether_brick", 
  "minecraft:ancient_debris", 
  "minecraft:coal_block", 
  "minecraft:iron_block", 
  "minecraft:gold_block", 
  "minecraft:redstone_block", 
  "minecraft:lapis_block", 
  "minecraft:diamond_block", 
  "minecraft:emerald_block", 
  "minecraft:quartz_block"
}

-- Trash Blocks/Ores
local trashBlocks = {
  "minecraft:gravel", 
  "minecraft:dirt", 
  "minecraft:cobblestone", 
  "minecraft:diorite", 
  "minecraft:granite",
  "minecraft:clay_ball"
}

-- Get the initial orientation. 0-3 Clockwise.
local startingOrientation = 0
local currentOrientation = 0

-- Turning functions
function turnRight()
  turtle.turnRight()
  currentOrientation = currentOrientation + 1
  if currentOrientation > 3 then
    currentOrientation = 0
  end
end
function turnLeft()
  turtle.turnLeft()
  currentOrientation = currentOrientation - 1
  if currentOrientation < 0 then
    currentOrientation = 3
  end
end

-- Check for block, dig if necessary, move forward, repeat x times
function forward(x)
  for i = 1, x do
    if turtle.detect() then
      turtle.dig()
    end
    turtle.forward()
  end
end

-- Uses inspectDown() to check for bedrock and returns true if found, false if not
function atBedrock()
  local success, data = turtle.inspectDown()
  if success then
    if data.name == "minecraft:bedrock" then
      return true
    else
      return false
    end
  else
    return false
  end
end

-- Uses inspect() to check for target blocks and returns true if found, false if not
function facingTargetBlock()
  local success, data = turtle.inspect()
  if success then
    for i = 1, #targetBlocks do
      if data.name == targetBlocks[i] then
        return true
      end
    end
    return false
  else
    return false
  end
end

-- Drops trash blocks
function poop()
  for i = 1, #trashBlocks do
    turtle.select(i)
    turtle.drop()
  end
end

-- Digs down to bedrock, checking for ores around it and mining them
function dip()
  local depth = 0
  while not atBedrock() do
    -- Dig down
    if turtle.detectDown() then
      turtle.digDown()
    end
    turtle.down()
    depth = depth + 1
    -- look around for target blocks
    for i = 0, 2 do
      if facingTargetBlock() then
        turtle.dig()
      end
      turnRight()
    end
  end
  -- Drop trash blocks
  poop()
  -- Go back up
  for i = 1, depth do
    if turtle.detectUp() then
      turtle.digUp()
    end
    turtle.up()
  end
  -- Return to starting orientation
  while currentOrientation ~= startingOrientation do
    turnRight()
  end
end

-- Start off by turning right
turnRight()

-- Downpour
for i = 1, Rows do
  for j = 1, Columns do
    -- Dip
    dip()
    -- Move forward three times and down once
    forward(3)
    turnRight()
    forward(1)
    turnLeft()
  end
  -- Move to starting position for next row
  turnRight()
  turnRight()
  forward(Columns * 3)
  turnRight()
  forward(Columns)
  turnLeft()
  forward(2)
  turnLeft()
  forward(1)
  turnLeft()
end