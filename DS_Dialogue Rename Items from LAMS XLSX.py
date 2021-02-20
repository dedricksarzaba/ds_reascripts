# ReaScript Name: Rename Items from LAMS XLSX
# Author: Dedrick Sarzaba
# REAPER: 6.23
# Version: 1.0
# Python Version 3.9

### IMPORTANT! ###
### This script requires REAPER to use python (Preferences>Plug-ins>ReaScript>Enable Python for use with Reascript).
### This script uses openpyxl to read into the excel spreadsheet. To install openpyxl, use pip. (https://openpyxl.readthedocs.io/en/stable/)

import os
import openpyxl

### User configureable variables ###

column_value = "Unique Name" # Change this to the name of the column where the filenames are

### End User Configureable variables ###

if RPR_GetOS() == "Win32" or RPR_GetOS() == "Win64":
  sep = "\\"
else:
  sep = "/"

### Main Function ###

def main():
  
  # Prompt user for excel or csv file, save it to variable "file"
  retval, file, title, defext = RPR_GetUserFileNameForRead("","Select File to Import", "xlsx")
  
  if retval:
    
    RPR_PreventUIRefresh(1)
    
    names = readExcel(file)
    
    # Check if there are actual filenames in the list
    if len(names) > 1:
    
      sel_items = RPR_CountSelectedMediaItems(0) # Count the amount of selected items
      
      if sel_items == 0: # If no items selected, error
        RPR_ShowMessageBox("No Items Selected", "Error!", 0) 
      
      # Rename the items
      for i in range(sel_items):
        item = RPR_GetSelectedMediaItem(0, i)
        take = RPR_GetActiveTake(item)
        RPR_GetSetMediaItemTakeInfo_String(take, "P_NAME", names[i], 1)
    
    else: # If no names in the list, error
      RPR_ShowMessageBox("Can't find 'Unique Name'", "Error!", 0)
      
    RPR_PreventUIRefresh(-1)
  
  else: # If no excel selected, error
    RPR_ShowMessageBox("No Excel Sheet Selected", "Error!", 0)
  

### Read Excel ###

def readExcel(file):
  
  names = []
  
  # Load excel workbook and find the Script worksheet
  xlsx = openpyxl.load_workbook(file)
  script = xlsx["Script"]
      
  # Get the filenames
  for col in script.iter_cols():
    if col[0].value == column_value:
      for cell in col:
        names.append(cell.value)
  return names[1:]
 
### INIT ###

RPR_Undo_BeginBlock()

main()

RPR_Undo_EndBlock("Rename Items From LAMS Excel/CSV", -1)
