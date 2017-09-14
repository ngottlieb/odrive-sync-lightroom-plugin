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
local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'
local LrShell = import 'LrShell'
local LrFunctionContext = import 'LrFunctionContext'
local LrProgressScope = import 'LrProgressScope'
local LrFileUtils = import 'LrFileUtils'
local LrView = import 'LrView'

LrTasks.startAsyncTask(function()
  LrFunctionContext.callWithContext("odrivesync.sync", function( context )
    local progressScope = LrProgressScope({ title= "Syncing with odrive", functionContext= context })

    catalog = LrApplication.activeCatalog()
    selectedPhotos = catalog:getTargetPhotos()
    cloudPaths = {}
    inSyncAlready = {}
    missingFiles = {}
    
    for i,photo in ipairs(selectedPhotos) do
      if progressScope:isCanceled() then break end
      -- this section of the task should execute extremely fast
      -- compared to the later loop, so I'm not bothering to iterate
      -- the progress bar until we get into the next loop
      basePath = photo:getRawMetadata("path")
      cPath = basePath .. ".cloud"
      -- check if base path already exists; if yes, then file is in sync already
      if LrFileUtils.exists(basePath) then
        table.insert(inSyncAlready, basePath)
      -- if .cloud extension is there, we can sync it
      elseif LrFileUtils.exists(cPath) then
        table.insert(cloudPaths, cPath)
      else -- no .cloud, no original file == file missing?
        table.insert(missingFiles, basePath)
      end
    end
    
    for i,path in ipairs(cloudPaths) do
      if progressScope:isCanceled() then break end
      -- check if the '.cloud' extension actually exists
      LrShell.openPathsViaCommandLine( { path }, "/usr/local/bin/odrive", "sync" )
      progressScope:setPortionComplete( i - 1, #cloudPaths )
    end
    
    -- no need to display dialog box unless some were not synced
    if #inSyncAlready > 0 or #missingFiles > 0 then
      local f = LrView.osFactory()

      -- need to convert our path lists to "title/value" pairs for simple_list to work
      inSyncTitleValues = {}
      for i,path in ipairs(inSyncAlready) do table.insert(inSyncTitleValues, { title = path, value = i }) end
      missingFilesTitleValues = {}
      for i,path in ipairs(missingFiles) do table.insert(missingFilesTitleValues, { title = path, value = i }) end
      
      innerBlocks = {
        spacing = f:control_spacing(),
      }
      if #inSyncTitleValues > 0 then
        table.insert(innerBlocks,
          f:group_box({
            title = "Already in Sync",
            size = "regular",
            f:simple_list({
                width = 800,
                items = inSyncTitleValues
            })
          })
        )
      end
      
      if #missingFilesTitleValues > 0 then
        table.insert(innerBlocks,
          f:group_box({
            title = "Missing Files",
            size = "regular",
            f:simple_list({
              width = 800,
              items = missingFilesTitleValues
            })
          })
        )
      end
      
      contents = f:column(innerBlocks)

      LrDialogs.presentModalDialog( {
          title = "Odrive Sync",
          resizable = true,
          contents = contents,
          cancelVerb = "< exclude >"
      })
    end
  end)
end)
