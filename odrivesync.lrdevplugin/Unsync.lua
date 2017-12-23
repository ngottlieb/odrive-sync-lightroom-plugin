--[[----------------------------------------------------------------------------

Unsync.lua
Encodes the odrive unsync logic.

------------------------------------------------------------------------------]]

-- Access the Lightroom SDK namespaces.
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'
local LrShell = import 'LrShell'
local LrFunctionContext = import 'LrFunctionContext'
local LrProgressScope = import 'LrProgressScope'
local LrFileUtils = import 'LrFileUtils'
local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'
local LrPrefs = import "LrPrefs"

LrTasks.startAsyncTask(function()
  LrFunctionContext.callWithContext("odrivesync.unsync", function( context )
    local progressScope = LrProgressScope({ title= "Unyncing with odrive", functionContext= context })
    local prefs = LrPrefs.prefsForPlugin()

    catalog = LrApplication.activeCatalog()
    selectedPhotos = catalog:getTargetPhotos()
    paths = {}
    unsyncedAlready = {}
    missingFiles = {}
    
    for i,photo in ipairs(selectedPhotos) do
      if progressScope:isCanceled() then break end
      
      basePath = photo:getRawMetadata("path")
      cPath = basePath .. ".cloud"
      -- check if already has ".cloud" extension
      if LrFileUtils.exists(cPath) then
        table.insert(unsyncedAlready, cPath)
      -- if not .cloud, we can unsync
      elseif LrFileUtils.exists(basePath) then
        table.insert(paths, basePath)
      else -- no .cloud, no original file == file missing?
        table.insert(missingFiles, basePath)
      end
      
      table.insert(paths, photo:getRawMetadata("path"))
    end
    
    for i,path in ipairs(paths) do
      if progressScope:isCanceled() then break end
      LrShell.openPathsViaCommandLine( { path }, prefs.odriveCliPath, "unsync" )
      progressScope:setPortionComplete( i - 1, #paths )
    end
    
    -- if any didn't work, present results:
    if #unsyncedAlready > 0 or #missingFiles > 0 then
      local f = LrView.osFactory()

      -- need to convert our path lists to "title/value" pairs for simple_list to work
      unsyncedTitleValues = {}
      for i,path in ipairs(unsyncedAlready) do table.insert(unsyncedTitleValues, { title = path, value = i }) end
      missingFilesTitleValues = {}
      for i,path in ipairs(missingFiles) do table.insert(missingFilesTitleValues, { title = path, value = i }) end
      
      innerBlocks = {
        spacing = f:control_spacing(),
      }
      if #unsyncedTitleValues > 0 then
        table.insert(innerBlocks,
          f:group_box({
            title = "Already Unsynced",
            size = "regular",
            f:simple_list({
                width = 800,
                items = unsyncedTitleValues
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
          title = "Odrive Unsync",
          resizable = true,
          contents = contents,
          cancelVerb = "< exclude >"
      })
    end
  end)
end)
