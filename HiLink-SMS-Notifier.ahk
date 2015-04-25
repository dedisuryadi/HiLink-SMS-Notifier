	
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

	
getInboxCount()
{
	ComObjError(false)
	HttpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	HttpObj.Open("GET", "http://hi.link/api/sms/sms-count")
	HttpObj.Send()
	RegExMatch(HttpObj.ResponseText, "<LocalInbox>(\d+)</LocalInbox>", inbox)
	HttpObj.quit
	
	return inbox1
}


Refresh:
	
	; get latest inbox count
	newValue := getInboxCount()
	
	; detect deleted message
	if (newValue < oldValue)
	{	
		Notify("SMS Deleted!", "You deleted " . oldValue-newValue . " messages"  , 10, "AC=openInbox GC=000 TC=DADADA MC=878787 Image=16")
		
		; update oldValue
		oldValue := newValue
	}

	; detect new message
	if (newValue > oldValue)
	{		
		; NOTIFY
		SoundPlay, %A_WinDir%\Media\Windows Ringout.wav ; ring ring
		Notify("You've got new SMS", "click to open", 35, "AC=openInbox GC=000 TC=DADADA MC=878787 Image=16")
		
		; make oldValue new
		oldValue := newValue
	}	
	
	return
	
	
openInbox:

	SetTitleMatchMode, 2
	SetTitleMatchMode, Slow
	
	IfWinExist, HiLink -
		WinActivate
	else
	{
		run http://hi.link/html/smsinbox.html
	}	
	return

  
CapsLock & s::
	Send, ^s ; To save a changed script
	Sleep, 300 ; give it time to save the script
	Reload
	Return