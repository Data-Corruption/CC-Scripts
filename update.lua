-- Minimized line count for easy copy-paste

local url, f, p = "https://data-corruption.github.io/CC-Scripts/Programs/", fs.open("programs.txt", "r"), {}
shell.run("wget", url .. "programs.txt", "programs.txt")
if f then for l in f.readLine do table.insert(p, l) end; f.close() end
for _, pr in ipairs(p) do shell.run("rm", pr); shell.run("wget", url .. pr, pr) end
print("All scripts updated!")