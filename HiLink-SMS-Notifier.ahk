	
; =======================================
; =======================================
;
; HiLink-SMS-Notifier
; A simple script for Huawei E303 user to get notified when a new SMS arrive. Written on Authotkey_L.
;
; This script make use of Hi.link web interface to fetch current inbox value, if value changes detected this script will play a notification ; sound and a beautiful notification pop up, based on [Notify.ahk by Gwarble](http://www.gwarble.com/ahk/Notify/.)
;
; Tested only on Windows 7 x64.
;
; Cheers
; @dediello
; https://github.com/dedisuryadi/HiLink-SMS-Notifier
;
; =======================================
; =======================================

#NoEnv
#Persistent
#Include Notify.ahk

; cache sms inbox count value
oldValue := getInboxCount()

; Refresh interval in milliseconds
refreshInterval = 30000

; Refresh immediately on script start
; and then Refresh on a refreshInterval
Gosub, Refresh
SetTimer, Refresh, %refreshInterval%
return


Refresh:
	
	; get latest inbox count
	newValue := getInboxCount()	

	if (newValue > oldValue)
	{
		; make oldValue new
		oldValue := newValue
		
		; NOTIFY
		Send {Volume_Down 30} ; add a cool fade effect
		SoundPlay, %A_WinDir%\Media\Windows Ringout.wav ; ring ring
		Notify("You've got new SMS", "click to open", 30, "AC=openInbox GC=000 TC=DADADA MC=878787 Image=16")
		sleep 1000
		Send {Volume_Up 30} ; normalize sound volume
	}	
	
	return
	
	
OpenInbox:

	SetTitleMatchMode, 2
	DetectHiddenWindows, on
	
	IfWinNotExist, HiLink -
		run http://hi.link/html/smsinbox.html
	else
		WinActivate
	return
	
	
getInboxCount()
{
	ComObjError(false)
	HttpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	HttpObj.Open("GET", "http://hi.link/api/sms/sms-count")
	HttpObj.Send()
	RegExMatch(HttpObj.ResponseText, "<LocalInbox>(\d+)</LocalInbox>", inbox)
	return inbox1
}

  
CapsLock & s::
	Send, ^s ; To save a changed script
	Sleep, 300 ; give it time to save the script
	Reload
	Return