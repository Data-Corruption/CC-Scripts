-- Temp example program for testing purposes 
for i = 1, 5 do
  if turtle.detect() then -- checks if there's a block in front
    turtle.dig() -- digs the block if one is detected
  end
  turtle.forward() -- moves forward whether a block was dug or not
end
