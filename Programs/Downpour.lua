-- Target Blocks that don't have "ore" in their name
local targetBlocks = {
    "minecraft:obsidian", "minecraft:glowstone", "minecraft:netherrack",
    "minecraft:nether_brick", "minecraft:ancient_debris",
    "minecraft:coal_block", "minecraft:iron_block", "minecraft:gold_block",
    "minecraft:redstone_block", "minecraft:lapis_block",
    "minecraft:diamond_block", "minecraft:emerald_block",
    "minecraft:quartz_block"
}

-- Container Block Identifiers
local containerBlocks = {"barrel", "chest", "shulker", "jar", "sack", "toolbox"}

-- Get the initial orientation. 0-3 Clockwise.
local startingOrientation = 0
local currentOrientation = 0

-- Find slot with stack of barrels, error if none found
local barrelSlot = 0
local barrelCount = 0
for i = 1, 16 do
    local data = turtle.getItemDetail(i)
    if data ~= nil then
        if data.name == "minecraft:barrel" then
            barrelSlot = i
            barrelCount = data.count
        end
    end
end
if barrelSlot == 0 then
    print("No barrels found in inventory.")
    return
end

-- Turning functions
function turnRight()
    turtle.turnRight()
    currentOrientation = currentOrientation + 1
    if currentOrientation > 3 then currentOrientation = 0 end
end
function turnLeft()
    turtle.turnLeft()
    currentOrientation = currentOrientation - 1
    if currentOrientation < 0 then currentOrientation = 3 end
end

-- Check for block, dig if necessary, move forward, repeat x times
function forward(x)
    for i = 1, x do
        if turtle.detect() then turtle.dig() end
        turtle.forward()
    end
end

-- Uses inspectDown() to check for bedrock and returns true if found, false if not
function atBedrockOrContainer()
    local success, data = turtle.inspectDown()
    if success then
        if data.name == "minecraft:bedrock" then return true end
        for i = 1, #containerBlocks do
            if string.match(data.name, containerBlocks[i]) then
                return true
            end
        end
    end
    return false
end

-- Uses inspect() to check for target blocks and returns true if found, false if not
function facingTargetBlock()
    local success, data = turtle.inspect()
    if success then
        if string.match(data.name, "ore") then return true end
        for i = 1, #targetBlocks do
            if data.name == targetBlocks[i] then return true end
        end
    end
    return false
end

-- Unloads all items from the turtle into a barrel in front of it
function unload()
    -- if block in front is a container, dig it
    if turtle.detect() then turtle.dig() end
    -- place barrel
    turtle.select(barrelSlot)
    turtle.place()
    -- unload everything except the barrel stack into the placed barrel
    for i = 1, 16 do
        if i ~= barrelSlot then
            turtle.select(i)
            turtle.drop()
        end
    end
end

-- Digs down to bedrock, checking for ores around it and mining them
function dip()
    local depth = 0
    while not atBedrockOrContainer() do
        -- Dig down
        if turtle.detectDown() then turtle.digDown() end
        turtle.down()
        depth = depth + 1
        -- look around for target blocks
        if facingTargetBlock() then turtle.dig() end
        for i = 0, 2 do
            if facingTargetBlock() then turtle.dig() end
            turnRight()
        end
    end
    -- Go back up
    for i = 1, depth do
        if turtle.detectUp() then turtle.digUp() end
        turtle.up()
    end
    -- Return to starting orientation
    while currentOrientation ~= startingOrientation do turnRight() end
    -- Unload
    turnLeft()
    unload()
    turnRight()
end

function main(...)
    -- Get Rows and Columns
    local tArgs = {...}
    if #tArgs < 2 then
        print("Usage: Downpour <rows> <columns>")
        return
    end
    local Rows = tonumber(tArgs[1])
    local Columns = tonumber(tArgs[2])
    print("Setting up for " .. Rows .. "x" .. Columns .. " downpour.")

    -- Check if turtle is advanced
    local isAdvancedTurle = false
    if turtle.getFuelLimit() >= 100000 then isAdvancedTurle = true end
    if isAdvancedTurle then
        print("☑ Advanced Turtle")
    else
        print("☐ Advanced Turtle")
    end

    -- Check for enough fuel
    local fuelPerDip = 2
    if isAdvancedTurle then fuelPerDip = 1 end
    if turtle.getFuelLevel() < Rows * Columns * fuelPerDip then
        print("Not enough fuel for this job.")
        return
    end
    print("☑ Fuel.")

    -- Check for enough barrels
    if Rows * Columns > barrelCount then
        print("Not enough barrels for this job.")
        return
    end
    print("☑ Barrels.\n")
    print("Starting Downpour...")

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
end
