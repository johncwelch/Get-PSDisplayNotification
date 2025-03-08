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


# SIG # Begin signature block
# MIIMgAYJKoZIhvcNAQcCoIIMcTCCDG0CAQMxDTALBglghkgBZQMEAgEwewYKKwYB
# BAGCNwIBBKBtBGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBCIiHhwTV7Re+2
# eTpBlDBZJDq4EeS182k6Ft0QTJ1iP6CCCaswggQEMIIC7KADAgECAggYeqmowpYh
# DDANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzETMBEGA1UEChMKQXBwbGUg
# SW5jLjEmMCQGA1UECxMdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxFjAU
# BgNVBAMTDUFwcGxlIFJvb3QgQ0EwHhcNMTIwMjAxMjIxMjE1WhcNMjcwMjAxMjIx
# MjE1WjB5MS0wKwYDVQQDDCREZXZlbG9wZXIgSUQgQ2VydGlmaWNhdGlvbiBBdXRo
# b3JpdHkxJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRMw
# EQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQGEwJVUzCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAIl2TwZbmkHupSMrAqNf13M/wDWwi4QKPwYkf6eVP+tP
# DpOvtA7QyD7lbRizH+iJR7/XCQjk/1aYKRXnlJ25NaMKzbTA4eJg9MrsKXhFaWlg
# a1+KkvyeI+Y6wiKzMU8cuvK2NFlC7rCpAgMYkQS2s3guMx+ARQ1Fb7sOWlt/OufY
# CNcLDjJt+4Y25GyrxBGKcIQmqp9E0fG4xnuUF5tI9wtYFrojxZ8VOX7KXcMyXw/g
# Un9A6r6sCGSVW8kanOWAyh9qRBxsPsSwJh8d7HuvXqBqPUepWBIxPyB2KG0dHLDC
# ThFpJovL1tARgslOD/FWdNDZCEtmeKKrrKfi0kyHWckCAwEAAaOBpjCBozAdBgNV
# HQ4EFgQUVxftos/cfJihEOD8voctLPLjF1QwDwYDVR0TAQH/BAUwAwEB/zAfBgNV
# HSMEGDAWgBQr0GlHlHYJ/vRrjS5ApvdHTX8IXjAuBgNVHR8EJzAlMCOgIaAfhh1o
# dHRwOi8vY3JsLmFwcGxlLmNvbS9yb290LmNybDAOBgNVHQ8BAf8EBAMCAYYwEAYK
# KoZIhvdjZAYCBgQCBQAwDQYJKoZIhvcNAQELBQADggEBAEI5dGuh3MakjzcqjLMd
# CkS8lSx/vFm4rGH7B5CSMrnUvzvBUDlqRHSi7FsfcOWq3UtsHCNxLV/RxZO+7puK
# cGWCnRbjGhAXiS2ozf0MeFhJDCh/M+4Aehu0dqy2tbtP36gbncgZl0oLVmcvwj62
# s8SDOvB3bXTELiNR7pqlA29g9KVIpwbCu1riHx9GRX7kl/UnELcgInJvctrGUHXF
# PSWPXaMA6Z82jEg5j7M76pCALpWaYPR4zvQOClM+ovpP2B6uhJWNMrxWTYnpeBjg
# rJpCunpGG4Siic4U6IjRWIv2rlbELAUqRa8L2UupAg80rIjHYVWJRMkncwfuguVO
# 9XAwggWfMIIEh6ADAgECAggGHmabX9eOKjANBgkqhkiG9w0BAQsFADB5MS0wKwYD
# VQQDDCREZXZlbG9wZXIgSUQgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxJjAkBgNV
# BAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRMwEQYDVQQKDApBcHBs
# ZSBJbmMuMQswCQYDVQQGEwJVUzAeFw0yMDA5MTYwMzU4MzBaFw0yNTA5MTcwMzU4
# MzBaMIGNMRowGAYKCZImiZPyLGQBAQwKNzk2NDg4Vkc5NTE4MDYGA1UEAwwvRGV2
# ZWxvcGVyIElEIEluc3RhbGxlcjogSm9obiBXZWxjaCAoNzk2NDg4Vkc5NSkxEzAR
# BgNVBAsMCjc5NjQ4OFZHOTUxEzARBgNVBAoMCkpvaG4gV2VsY2gxCzAJBgNVBAYT
# AlVTMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw0uP+x8FCIpcy4DJ
# xqWRX3Pdtr55nnka0f22c7Ko+IAC//91iQxQLuz8fqbe4b3pEyemzfDB0GSVyhnY
# AYLVYMjVaUamr2j7apX8M3QxIcxrlHAJte1Mo+ntsQic4+syz5HZm87ew4R/52T3
# zzvtsjaKRIfy0VT35E9T4zVhpq3vdJkUCuQrHrXljxXhOEzJrJ9XllDDJ2QmYZc0
# K29YE9pVPFiZxkbf5xmtx1CZhiUulCI0ypnj7dGxLJxRtJhsFChzeSflkOBtn9H/
# RVuBjb0DaRib/mEK7FCbYgEbcIL5QcO3pUlIyghXaQoZsNaViszg7Xzfdh16efby
# y+JLaQIDAQABo4ICFDCCAhAwDAYDVR0TAQH/BAIwADAfBgNVHSMEGDAWgBRXF+2i
# z9x8mKEQ4Py+hy0s8uMXVDBABggrBgEFBQcBAQQ0MDIwMAYIKwYBBQUHMAGGJGh0
# dHA6Ly9vY3NwLmFwcGxlLmNvbS9vY3NwMDMtZGV2aWQwNzCCAR0GA1UdIASCARQw
# ggEQMIIBDAYJKoZIhvdjZAUBMIH+MIHDBggrBgEFBQcCAjCBtgyBs1JlbGlhbmNl
# IG9uIHRoaXMgY2VydGlmaWNhdGUgYnkgYW55IHBhcnR5IGFzc3VtZXMgYWNjZXB0
# YW5jZSBvZiB0aGUgdGhlbiBhcHBsaWNhYmxlIHN0YW5kYXJkIHRlcm1zIGFuZCBj
# b25kaXRpb25zIG9mIHVzZSwgY2VydGlmaWNhdGUgcG9saWN5IGFuZCBjZXJ0aWZp
# Y2F0aW9uIHByYWN0aWNlIHN0YXRlbWVudHMuMDYGCCsGAQUFBwIBFipodHRwOi8v
# d3d3LmFwcGxlLmNvbS9jZXJ0aWZpY2F0ZWF1dGhvcml0eS8wFwYDVR0lAQH/BA0w
# CwYJKoZIhvdjZAQNMB0GA1UdDgQWBBRdVgk/6FL+2RJDsLeMey31Hn+TBzAOBgNV
# HQ8BAf8EBAMCB4AwHwYKKoZIhvdjZAYBIQQRDA8yMDE5MDIwNjAwMDAwMFowEwYK
# KoZIhvdjZAYBDgEB/wQCBQAwDQYJKoZIhvcNAQELBQADggEBAHdfmGHh7XOchb/f
# reKxq4raNtrvb7DXJaubBNSwCjI9GhmoAJIQvqtAHSSt4CHsffoekPkWRWaJKgbk
# +UTCZLMy712KfWtRcaSNNzOp+5euXkEsrCurBm/Piua+ezeQWt6RzGNM86bOa34W
# 4r6jdYm8ta9ql4So07Z4kz3y5QN7fI20B8kG5JFPeN88pZFLUejGwUpshXFO+gbk
# GrojkwbpFuRAsiEZ1ngeqtObaO8BRKHahciFNpuTXk1I0o0XBZ2JmCUWzx3a6T4u
# fME1heNtNLRptGYMtZXH4tboV39Wf5lgHc4KR85Mbw52srsRU22NE8JWAvgFp/Qz
# qX5rmVIxggIrMIICJwIBATCBhTB5MS0wKwYDVQQDDCREZXZlbG9wZXIgSUQgQ2Vy
# dGlmaWNhdGlvbiBBdXRob3JpdHkxJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRp
# b24gQXV0aG9yaXR5MRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQGEwJVUwII
# Bh5mm1/XjiowCwYJYIZIAWUDBAIBoHwwEAYKKwYBBAGCNwIBDDECMAAwGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwLwYJKoZIhvcNAQkEMSIEIJ/M8jMjN/CtJq0S+CmRqCvdlYti+5eenX0JygKI
# nfv8MAsGCSqGSIb3DQEBAQSCAQCiOBVRRCW8KV6ghpyREGhTIrUq/Zo8wSuE6rNu
# 5/Xz7jfkA+1Kxgj2NK0p2F0f0UWNHQerPjW3k2TRQ3gorMrMw6nilIIeb0OkwU/j
# BhIXlNSfDATTd/kNBIDifTk/Gma2Ek7cOcJ+Q9Y8H0rQeVGas0rDrMVWBwHcDLOp
# Buvw3BG1w5GYx6n7r2Q8rmxtnKkA4L30p7BiNXy+fIL1JAijlCWCbYjxG6mrm0YU
# vEx8zt5ujvLm2I5kG7Bkjk/AD0ZqeXnuYw2KgOohQ68InYEln7YYC+OYJbLDoVa1
# Z8wsiuCtcfGh4XySkFdX5e7OFg7Tt782HAVYGXDvj4GhMmSQ
# SIG # End signature block
