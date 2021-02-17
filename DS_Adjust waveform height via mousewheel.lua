--[[
 * ReaScript Name: Adjust waveform height via mousewheel
 * Author: Dedrick Sarzaba
 * REAPER: 6.23
 * About: Changes waveform (peaks) view height via mousewheel, similar to how it works in PT.
--]]


-- MAIN --

function main()

  is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
  
  if val > 0 then
    reaper.Main_OnCommand(40155,0)
  else
    reaper.Main_OnCommand(40156,0)
  end
  
end

-- INIT --
reaper.Undo_BeginBlock()

main()

reaper.Undo_EndBlock("Adjust waveform height via mousewheel", -1)

