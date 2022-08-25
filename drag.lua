local Module = {}

local DraggableWindows = {}

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local MouseButton1Down = false

local function GetSelectedWindow()
	for _,Window in pairs(DraggableWindows) do
		if Window.IsActive then
			return Window
		end
	end
end

local function GetWindowTableObject(Window)
	for _,Window in pairs(DraggableWindows) do
		if Window.Object == Window then
			return Window
		end
	end
end

Module.AddDraggableWindow = function(Window)
	table.insert(DraggableWindows, {
		Object = Window,
		MouseInWindow = false,
		SetOffset = UDim2.fromOffset(0, 0),
		IsActive = false
	})
	
	Window.MouseEnter:Connect(function()
		GetWindowTableObject().IsActive = true
	end)
	
	Window.MouseLeave:Connect(function() 
		if not MouseButton1Down then 
			GetWindowTableObject().IsActive = false
		end 
	end)
end

Mouse.Button1Down:Connect(function()
	local SelectedWindow = GetSelectedWindow()
	
	SelectedWindow.SetOffset = UDim2.fromOffset(SelectedWindow.Object.Position.X.Offset - Mouse.X, SelectedWindow.Object.Position.Y.Offset - Mouse.Y)
	MouseButton1Down = true
end)

Mouse.Button1Up:Connect(function() 
	MouseButton1Down = false 
end)

game:GetService('RunService').RenderStepped:Connect(function()
	local SelectedWindow = GetSelectedWindow()
	
	if MouseButton1Down and SelectedWindow.IsActive then
		SelectedWindow.Object.Position = UDim2.fromOffset(Mouse.X + SelectedWindow.SetOffset.X.Offset, Mouse.Y + SelectedWindow.SetOffset.Y.Offset)
	end
end)

return Module
