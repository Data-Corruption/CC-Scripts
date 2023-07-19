-- 'update' program
local url = "https://Data-Corruption.github.io/CC-Scripts/Programs/"
local program_list = "programs.txt"

-- Fetch the program list
shell.run("wget", url .. program_list, program_list)
local f = fs.open(program_list, "r")

-- Parse the program list
local programs = {}
local line = f.readLine()
while line do
  table.insert(programs, line)
  line = f.readLine()
end
f.close()

-- Update each program
for _, program in ipairs(programs) do
  print("Updating " .. program .. "...")
  -- delete the old version
  shell.run("rm", program)
  -- download the new version
  shell.run("wget", url .. program, program)
end

print("All scripts updated!")
