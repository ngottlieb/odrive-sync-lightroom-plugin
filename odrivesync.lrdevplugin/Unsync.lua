--[[----------------------------------------------------------------------------

ADOBE SYSTEMS INCORPORATED
 Copyright 2007 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE: Adobe permits you to use, modify, and distribute this file in accordance
with the terms of the Adobe license agreement accompanying it. If you have received
this file from a source other than Adobe, then your use, modification, or distribution
of it requires the prior written permission of Adobe.

--------------------------------------------------------------------------------

ShowCustomDialog.lua
From the Hello World sample plug-in. Displays a custom dialog and writes debug info.

------------------------------------------------------------------------------]]

-- Access the Lightroom SDK namespaces.
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'
local LrShell = import 'LrShell'
local LrFunctionContext = import 'LrFunctionContext'
local LrProgressScope = import 'LrProgressScope'

--[[
	Demonstrates a custom dialog with a simple binding. The dialog displays a
	checkbox and a text field.  When the check box is selected the text field becomes
	enabled, if the checkbox is unchecked then the text field is disabled.
	
	The check_box.value and the edit_field.enabled are bound to the same value in an
	observable table.  When the check_box is checked/unchecked the changes are reflected
	in the bound property 'isChecked'.  Because the edit_field.enabled value is also bound then
	it reflects whatever value 'isChecked' has.
]]

LrTasks.startAsyncTask(function()
  LrFunctionContext.callWithContext("odrivesync.unsync", function( context )
    local progressScope = LrProgressScope({ title= "Syncing with odrive", functionContext= context })

    catalog = LrApplication.activeCatalog()
    selectedPhotos = catalog:getTargetPhotos()
    paths = {}
    
    for i,photo in ipairs(selectedPhotos) do
      if progressScope:isCanceled() then break end
      table.insert(paths, photo:getRawMetadata("path"))
    end
    
    for i,path in ipairs(paths) do
      if progressScope:isCanceled() then break end
      LrShell.openPathsViaCommandLine( { path }, "/usr/local/bin/odrive", "unsync" )
      progressScope:setPortionComplete( i - 1, #paths )
    end
  end)
end)
