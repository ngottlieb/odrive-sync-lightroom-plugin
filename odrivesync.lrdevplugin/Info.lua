--[[----------------------------------------------------------------------------

Info.lua
Plugin that allows a user to call odrive sync or unsync on the path of a file in
the library.

------------------------------------------------------------------------------]]

return {
	
	LrSdkVersion = 3.0,
	LrSdkMinimumVersion = 1.3, -- minimum SDK version required by this plug-in

	LrToolkitIdentifier = 'com.adobe.lightroom.sdk.odrivesync',

	LrPluginName = LOC "$$$/OdriveSync/PluginName=Odrive Sync",

	-- Add the menu item to the Library menu.
	
	LrLibraryMenuItems = {
	    {
		    title = LOC "$$$/OdriveSync/CustomDialog=Sync",
		    file = "Sync.lua",
        enabledWhen = "anythingSelected"
		},
		{
		    title = LOC "$$$/OdriveSync/CustomDialog=Unsync",
		    file = "Unsync.lua",
        enabledWhen = "anythingSelected"
		},
	},
  
  LrPluginInfoProvider = 'PluginInfoProvider.lua',
  
	VERSION = { major=1, minor=0, revision=0 },
}