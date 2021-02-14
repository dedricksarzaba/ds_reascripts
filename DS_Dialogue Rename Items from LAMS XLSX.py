# ReaScript Name: Rename Items from LAMS XLSX
# Author: Dedrick Sarzaba
# REAPER: 6.23
# Version: 1.0
# Python Version 3.9

### Main Function ###

import os
import openpyxl

if RPR_GetOS() == "Win32" or RPR_GetOS() == "Win64":
  sep = "\\"
else:
  sep = "/"

def main():
  
  # Prompt user for excel or csv file, save it to variable "file"
  retval, file, title, defext = RPR_GetUserFileNameForRead("","Select File to Import", "xlsx")
  
  if retval:
    
    RPR_PreventUIRefresh(1)
    
    names = readExcel(file)
    
    sel_items = RPR_CountSelectedMediaItems(0) # count the amount of selected items
    
    if sel_items == 0: # if no items selected, error
      RPR_ShowMessageBox("No Items Selected", "Error!", 0) 
    
    
    #rename the items
    for i in range(sel_items):
      item = RPR_GetSelectedMediaItem(0, i)
      take = RPR_GetActiveTake(item)
      RPR_GetSetMediaItemTakeInfo_String(take, "P_NAME", names[i], 1)
      
    RPR_PreventUIRefresh(-1)
  
  else:
  
    RPR_ShowMessageBox("No Excel Sheet Selected", "Error!", 0)
  

### Read Excel ###

def readExcel(file):
  
  names = ()
  
  # Load excel workbook and find the Script worksheet
  xlsx = openpyxl.load_workbook(file)
  script = xlsx["Script"]
      
  # Get the filenames and put them into tuple names
  for name in script.iter_cols(min_row=2, min_col=7, max_col=7, values_only=True):
    names = name
  
  return names
    

### INIT ###

RPR_Undo_BeginBlock()

main()

RPR_Undo_EndBlock("Rename Items From LAMS Excel/CSV", -1)
