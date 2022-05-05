--[[
 * ReaScript Name: Rename Items from LAMS CSV
 * Author: Dedrick Sarzaba
 * Version 1.0
 * REAPER: 6.52
--]]

-- User configureable variables --

column_index = 5 --Change this to the index of where the filenames are. By DEFAULT this is set to 5 as LAMS exports the "Unique Name" column here.
ignore_strings = "Unique Name" -- Text to ignore during the filename lookup

-- End user configureable variables

sep = ","

-- UTILITIES -------------------------------------------------------------

-- Save item selection
function SaveSelectedItems (table)
  for i = 0, reaper.CountSelectedMediaItems(0)-1 do
    table[i+1] = reaper.GetSelectedMediaItem(0, i)
  end
end

-- CSV to Table --
-- http://lua-users.org/wiki/LuaCsv
function ParseCSVLine (line,sep)
  local res = {}
  local pos = 1
  sep = sep or ','
  while true do
    local c = string.sub(line,pos,pos)
    if (c == "") then break end
    if (c == '"') then
      -- quoted value (ignore separator within)
      local txt = ""
      repeat
        local startp,endp = string.find(line,'^%b""',pos)
        txt = txt..string.sub(line,startp+1,endp-1)
        pos = endp + 1
        c = string.sub(line,pos,pos)
        if (c == '"') then txt = txt..'"' end
        -- check first char AFTER quoted string, if it is another
        -- quoted string without separator, then append it
        -- this is the way to "escape" the quote char in a quote. example:
        --   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
      until (c ~= '"')
      table.insert(res,txt)
      assert(c == sep or c == "")
      pos = pos + 1
    else
      -- no quotes used, just look for the first separator
      local startp,endp = string.find(line,sep,pos)
      if (startp) then
        table.insert(res,string.sub(line,pos,startp-1))
        pos = endp + 1
      else
        -- no separator found -> use rest of string and terminate
        table.insert(res,string.sub(line,pos))
        break
      end
    end
  end
  return res
end


--- read CSV ---

function readCSV(file)
  
  lines = {} --create table for each line in the CSV
  fileNames = {} --create table for each FileName in each line
  
  f = io.input(file) --set the csv file as input
  
  repeat
  
    line = f:read("*l") --read one line of the csv
  
    if line then
      table.insert(lines, ParseCSVLine(line,sep)) --insert lines into the table until the end of the csv
    end
    
  until not line
  
  for i in pairs(lines) do
    if lines[i][column_index] == ignore_strings then
      --do nothing if the value is "Unique Name"
    elseif string.len(lines[i][column_index]) == 0 then
      --do nothing if the value is an empty string
    else
      table.insert(fileNames, lines[i][column_index]) --add the filename to the fileNames table
    end
  end

    f:close()

end


-- get Table Length ---

function tableLength(T)
  local count = 0
  for h in pairs(T) do
    count = count + 1
  end
  return count
end

-- Save item selection
function SaveSelectedItems (table)
  for i = 0, reaper.CountSelectedMediaItems(0)-1 do
    table[i+1] = reaper.GetSelectedMediaItem(0, i)
  end
end

--------------------------------------------------------- END OF UTILITIES

-- MAIN --


function main()

  count_sel_items = reaper.CountSelectedMediaItems(0)
  
  if count_sel_items > 0 then

    --Prompt user for excel or csv file
    retval, file = reaper.GetUserFileNameForRead("","Select File to Import", "csv")
    
    -- Read the CSV, but if the user did not pick one then prompt an error
    
    if retval then
    
      sel_items = {}
      SaveSelectedItems(sel_items)
      count_sel_items = tableLength(sel_items)
    
      readCSV(file)
      
      count_fileNames = tableLength(fileNames)
      count_renamedItems = 0
      
      if count_fileNames > 0 then
        for i,item in ipairs(sel_items) do
          take = reaper.GetActiveTake(item)
          reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", fileNames[i], true)
          count_renamedItems = count_renamedItems + 1
          if count_renamedItems == count_fileNames then
            break
          end
        end
      reaper.ShowMessageBox(tostring(count_fileNames).. " filenames found.\n"..tostring(count_sel_items).." items selected.\n"..tostring(count_renamedItems).." items renamed.","Result",0)
      else reaper.ShowMessageBox("No filenames found, is the column index correct?","Error!",0)
      end
    
    elseif retval == false then
    
      reaper.ShowMessageBox("No .csv file selected.", "Error!", 0)
      
    end
  
  else reaper.ShowMessageBox("No items selected.","Error!",0)
  end

end


-- INIT --
reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Rename Items From LAMS CSV", 0)
reaper.PreventUIRefresh(-1)
