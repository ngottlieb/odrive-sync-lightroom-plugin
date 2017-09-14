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
]]

LrTasks.startAsyncTask(function()
  LrFunctionContext.callWithContext("odrivesync.sync", function( context )
    local progressScope = LrProgressScope({ title= "Syncing with odrive", functionContext= context })

    catalog = LrApplication.activeCatalog()
    selectedPhotos = catalog:getTargetPhotos()
    cloudPaths = {}
    
    for i,photo in ipairs(selectedPhotos) do
      if progressScope:isCanceled() then break end
      -- this section of the task should execute extremely fast
      -- compared to the later loop, so I'm not bothering to iterate
      -- the progress bar until we get into the next loop
      basePath = photo:getRawMetadata("path")
      cPath = basePath .. ".cloud"
      table.insert(cloudPaths, cPath)
    end
    
    for i,path in ipairs(cloudPaths) do
      if progressScope:isCanceled() then break end
      LrShell.openPathsViaCommandLine( { path }, "/usr/local/bin/odrive", "sync" )
      progressScope:setPortionComplete( i - 1, #cloudPaths )
    end
  end)
end)
