#the way this actually works is SO dumb

<#
	.SYNOPSIS
	This script is a bridge between PowerShell and the AppleScript Display Notificatin UI primitive. It allows you to send OS notifications from powershell

	READ THIS PART, BECAUSE DISPLAY NOTIFICATION FROM THE COMMAND LINE IS WIERD AF
	     for this to work AT ALL, you have to open Script Editor (not Script Debugger or any other AppleScript tool) and run display notification once. It can be very simple: display notification "test" 

		if you have NEVER run that command from script editor, you'll get the "allow notifications from script editor" notifications. YOU HAVE TO PICK "ALLOW" FOR THIS TO WORK. Like sounds, all of it. I do NOT know why, nor do I think i want to, but when you run: osascript -e 'display notification "test notification"' from terminal or a powershell window, the application icon is Script Editor. I do not know why this is used that way, my guess is it's a limitation of notifications and what terminal actually does

	
	.DESCRIPTION
	This module takes advantage of piping commands to /usr/bin/osascript to allow powershell to use AppleScript's Display Notifications function,
	(https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/DisplayNotifications.htmlfor more details)

	As with some of the other modules in this series, this attempts to plug a hole in PowerShell on macOS by allowing access to things that are useful in a GUI, like user input, or choosing a folder/folders.

	This module takes advantage of osascript's ability to run AppleScript from the Unix shell environment. There are a number of parameters you can use with this, (in -Detailed) to customize the dialog. The only required parameter is the notification text, -notificationText 

	Use Get-Help Get-DisplayNotification - Detailed for Parameter List

	This script has no returns at all. It just displays a notification.

	Note that PowerShell is case insensitive, so the parameters are as well

	.INPUTS
	None, there's nothing you can pipe to this

	.OUTPUTS
	None

	.EXAMPLE
	Basic Diplay Notification: 
	
		Get-DisplayNotification -notificationText "The notification text"

	That will give you a dialog that lets you choose a single folder
	.EXAMPLE
	Display Notification with a sound:

		Get-DisplayNotification -notificationText "The notification text" -soundName "basso"
	
	the sounds you can use here are the ones in /System/Library/Sounds/, you don't have to use the filename extension

	.EXAMPLE
	Display Notification with a custom title:

		Get-DisplayNotification -notificationText "The notification text" -title "My New Title"

	Note that while this will in theory replace the "name" of the sending app, because of the weirdness talked about above, the app icon is always script editor's

	.EXAMPLE
	Display Notification with a custom subtitle:

		Get-DisplayNotification -notificationText "The notification text" -subtitle "Not Oceansgate"

	.LINK
	https://github.com/johncwelch/Get-PSDisplayNotification
	#>

function Get-DisplayNotification {
	Param (
		#we do the params this way so the help shows the description
		[Parameter(Mandatory = $true)][string]
		#required, text for the notification
		$notificationText,
		[Parameter(Mandatory = $false)][string]
		#the name of the sound you want to play
		$soundName,
		[Parameter(Mandatory = $false)][string]
		#default filename for the dialog
		$subTitle,
		[Parameter(Mandatory = $false)][string]
		#default filename for the dialog
		$title
	)

	if (-Not $IsMacOS) {
		Write-Output "This module only runs on macOS, exiting"
		Exit
	}

	$displayNotificationCommand = "display notification "

	##parameter processing
	#notification text
	#since this is mandatory, we don't have to test
	$displayNotificationCommand = $displayNotificationCommand + "`"$notificationText`" "

	#sound name text
	if(-not [string]::IsNullOrEmpty($soundName)) {
		$displayNotificationCommand = $displayNotificationCommand + "sound name `"$soundName`" "
	}

	#subtitle processing
	if(-not [string]::IsNullOrEmpty($subTitle)) {
		$displayNotificationCommand = $displayNotificationCommand + "subtitle `"$subTitle`" "
	}

	#title processing
	if(-not [string]::IsNullOrEmpty($title)) {
		$displayNotificationCommand = $displayNotificationCommand + "with title `"$title`" "
	}

	$displayNotificationCommand |/usr/bin/osascript -so
}

#what the module shows the world
Export-ModuleMember -Function Get-DisplayNotification