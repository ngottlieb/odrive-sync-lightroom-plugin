--[[----------------------------------------------------------------------------

PluginInfoProvider.lua

Responsible for managing the dialog entry in the Plugin Manager dialog window which
manages the individual plug-ins installed in the Lightroom application.

This creates a section in the plugin management dialog that asks for the path to the odrive
executable. It also includes a link to the download page for the odrive CLI and encourages
users to install it.

------------------------------------------------------------------------------]]

require "PluginInit"

local LrHttp = import "LrHttp"
local LrView = import "LrView"
local LrPrefs = import "LrPrefs"
local LrFileUtils = import "LrFileUtils"
local LrDialogs = import "LrDialogs"

sectionsForTopOfDialog = function ( f, propertyTable )
end


sectionsForBottomOfDialog = function( f, propertyTable )
  local prefs = LrPrefs.prefsForPlugin()
  if prefs.odriveCliPath == nil then
    prefs.odriveCliPath = PluginInit.defaultOdrivePath
  end
  
  -- check to see if the executable listed in the path exists
  executableFound = LrFileUtils.exists(prefs.odriveCliPath)

  if executableFound then
    synopsis = "All set, odrive CLI found"
  else
    synopsis = "ACTION REQUIRED -- CLI not found at path provided"
  end
  
  -- try to make checking for CLI interactive somehow? Want to bind to custom thing, PLUS 
  -- the thing in prefs. Maybe we can just add a boolean to prefs that we don't use anywhere.

  section = {
        bind_to_object = prefs,
        synopsis = synopsis,
				title = LOC "$$$/OdriveSync/PluginManager=Odrive CLI Path",
				f:row {
					spacing = f:control_spacing(),
          f:edit_field {
            value = LrView.bind("odriveCliPath")
          },
					f:push_button {
						width = 150,
						title = LOC "$$$/OdriveSync/ButtonTitle=Download CLI",
						enabled = true,
						action = function()
							LrHttp.openUrlInBrowser( PluginInit.URL )
						end,
					},
				},
			}
      
  return { section }
end

return {
  sectionsForTopOfDialog = sectionsForTopOfDialog,
  sectionsForBottomOfDialog = sectionsForBottomOfDialog
}