--[[
 * ReaScript Name: Zoom Out Without Undo
 * Author: Dedrick Sarzaba
 * REAPER: 6.14
 * Version: 1.0
--]]

--[[
 * Changelog:
 * v1.0 (2020-10-21)
  + Initial Release
--]]

zoom_level = 4 --Set this to the amount of times you want the want to zoom out. (4 means 4x)

function main()
  for i=1,zoom_level,1 do
   reaper.Main_OnCommand(1011, 0)
  end
end
  
reaper.defer(main)


