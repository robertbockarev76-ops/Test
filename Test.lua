local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/robertbockarev76-ops/robertoscript/refs/heads/main/Robertinio'))()

local Window = Rayfield:CreateWindow({
	Name = "Roberto Hub",
	LoadingTitle = "Roberto Hub is Loading...",
	LoadingSubtitle = "by Robert",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "RobertoHub",
		FileName = "Config"
	},
   KeySystem = false,
   KeySettings = {
      Title = "Roberto Hub",
      Subtitle = "Key System",
      Key = {"1280"}
   }
})

local Tab = Window:CreateTab("Main", 4483362458)
local Section = Tab:CreateSection("Player")

Tab:CreateButton({
   Name = "Speed Boost",
   Callback = function()
      local character = game.Players.LocalPlayer.Character
      if character and character:FindFirstChildOfClass("Humanoid") then
         character.Humanoid.WalkSpeed = 50
      end
   end,
})

Rayfield:LoadConfiguration()
