--[[
    Description: Vertically select all items under mouse-click (selected tracks).
    Version: 1.0.0
    Author: Thonex
    Changelog:
        Initial Release
]]--

function itemUnderMouse()
  reaper.BR_GetMouseCursorContext()
  return reaper.BR_GetMouseCursorContext_Item()
end


function Vertically_select_all_items_under_mouse_on_selected_tracks()

  reaper.PreventUIRefresh(1)
  reaper.ClearConsole() 
  reaper.Undo_BeginBlock()
  
  
  local Clicked_Item = itemUnderMouse()
  if Clicked_Item ~= nil then
      reaper.SetMediaItemSelected(Clicked_Item, 0 )
  end
  
  Mouse_Pos = reaper.BR_PositionAtMouseCursor( true )

  Num_Sel_1 = reaper.CountSelectedMediaItems(0 )
  
  t_Prev_Sel_ID = {}

  for i=0,  Num_Sel_1 -1 do -- scans already selected PLUS the clicked item (clicked item will be first ID)
     t_Prev_Sel_ID[i] = reaper.GetSelectedMediaItem(0,i)  
  end
  

  local L_Start, R_End = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false) -- Get Time Selection initial pos
  local _, __ = reaper.GetSet_LoopTimeRange(true, false, Mouse_Pos-.001, Mouse_Pos+.001, false) -- Set TimeSelection 1 ms to right and left of mouse click
  reaper.Main_OnCommand( 40718, 0) -- Item: Select all items on selected tracks in current time selection

   for i=0,  Num_Sel_1 -1 do -- reselct all previous items
      reaper.SetMediaItemSelected( t_Prev_Sel_ID[i], 1 )   
   end

  local _, __ = reaper.GetSet_LoopTimeRange(true, false, L_Start, R_End, false) -- Set Time Selection to initial pos

  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.Undo_EndBlock("Vertically select all items under cursor on selected tracks",-1)

end 

Vertically_select_all_items_under_mouse_on_selected_tracks()
