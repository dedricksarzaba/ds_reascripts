--[[
 * ReaScript Name: Snap View to Right Edge of Time Selection
 * Author: Dedrick Sarzaba
 * REAPER: 6.23
 * Version: 1.0
--]]

function main()
  
  start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false) --get time selection
  
  reaper.GetSet_ArrangeView2(0, true, 0, 0, end_time - 0.3, end_time + 0.5) --move the arrange view zoom
  
  -- zoom in 5x
  --zoom_level = 5
  
  --for i=0, zoom_level, 1 do
    --reaper.Main_OnCommand(1012, 0)
  --end

end

reaper.Undo_BeginBlock()

main()

reaper.Undo_EndBlock("Snap View to Right Edge of Time Selection", 0)
