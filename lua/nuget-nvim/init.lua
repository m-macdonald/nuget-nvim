
-- Creates an object for the module. All of the module's function are exposed through this object.
local M = {}

local function does_nuget_exist()
    local success = pcall(function()
        io.popen('nuget help', 'r')
    end)

    if not success then
       error('nuget not found on the path. An absolute path must be provided in the config if nuget is not exposed in the path')
    end
end

M.say_hello = function() print("hello") end
M.find_nuget = does_nuget_exist
-- M.setup = setup()

return M
