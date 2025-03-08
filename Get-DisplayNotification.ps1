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