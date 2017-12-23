Odrive Sync Lightroom Plugin
=======================

### Overview
This plugin provides an in-app interface between Lightroom and [odrive](https://www.odrive.com). [odrive](https://www.odrive.com) is a cloud storage solution that let's you "sync" and "unsync" files between the cloud and your local machine, leaving `.cloud` placeholders behind. Using this plugin, you can keep your entire Lightroom library on the cloud and recall files to your local machine on-demand from within Lightroom when you need to work on them or export them.

Requirements
------------
* [odrive](https://www.odrive.com) and premium subscription (they say they are working on an "unsync only" subscription, but as of yet, it's not available)
* [odrive CLI](https://docs.odrive.com/v1.0/docs/odrive-cli) -- binary version, not Python

Installation
------------
1. Download the latest release from this repo
2. In Lightroom, go to `File -> Plug-in Manager`
3. Click "Add" and locate the `.lrplugin` package you downloaded
4. Ensure the "Odrive CLI Path" section is correctly filled in
5. If you're not already set up with odrive, move your Lightroom photo library to within your odrive folder so that odrive can work with the files and automatically sync them to your cloud storage provider. *Note: It is important to do this from within the Lightroom interface so that LR maintains accurate paths for all the files in your catalog.*

Workflow
--------
I use this plugin to allow me to keep a minimal number of photos on-disk on my laptop's SSD. In general, any photo that I'm done with for the time being, I "unsync." I keep my `.lrcat` and previews database stored locally, so I can use my entire catalog in Lightroom, and if I need to work on or export a photo, I "sync" it and proceed as needed.

Sync and unsync actions are available in the `Library -> Plug-in Extras` menu and can be run on any single photo or group of photos that you select in the main browser.

![The plugin sync and unsync actions are available in the `Library -> Plug-in Extras` menu](https://raw.githubusercontent.com/ngottlieb/odrive-lightroom-plugin/master/Screenshots/Sync_Screenshot.png)

More Info
---------
The original blog post about this plugin is available here: [http://www.nicholasgottlieb.com/2017/09/14/on-demand-cloud-storage-with-lightroom-and-odrive/](http://www.nicholasgottlieb.com/2017/09/14/on-demand-cloud-storage-with-lightroom-and-odrive/).

Contributing
------------
Pull requests for new features are welcome.

Find It Useful?
---------------
Consider paying what you feel this plugin is worth to you. [paypal.me/NGottlieb](http://paypal.me/NGottlieb/20)