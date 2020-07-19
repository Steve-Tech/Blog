' ________  ________  ________  ___  __    ________  ________  ________  ___  ___  ________   ________          ________  ___  ___  ________  ________   ________  _______   ________     
'|\   __  \|\   __  \|\   ____\|\  \|\  \ |\   ____\|\   __  \|\   __  \|\  \|\  \|\   ___  \|\   ___ \        |\   ____\|\  \|\  \|\   __  \|\   ___  \|\   ____\|\  ___ \ |\   __  \    
'\ \  \|\ /\ \  \|\  \ \  \___|\ \  \/  /|\ \  \___|\ \  \|\  \ \  \|\  \ \  \\\  \ \  \\ \  \ \  \_|\ \       \ \  \___|\ \  \\\  \ \  \|\  \ \  \\ \  \ \  \___|\ \   __/|\ \  \|\  \   
' \ \   __  \ \   __  \ \  \    \ \   ___  \ \  \  __\ \   _  _\ \  \\\  \ \  \\\  \ \  \\ \  \ \  \ \\ \       \ \  \    \ \   __  \ \   __  \ \  \\ \  \ \  \  __\ \  \_|/_\ \   _  _\  
'  \ \  \|\  \ \  \ \  \ \  \____\ \  \\ \  \ \  \|\  \ \  \\  \\ \  \\\  \ \  \\\  \ \  \\ \  \ \  \_\\ \       \ \  \____\ \  \ \  \ \  \ \  \ \  \\ \  \ \  \|\  \ \  \_|\ \ \  \\  \| 
'   \ \_______\ \__\ \__\ \_______\ \__\\ \__\ \_______\ \__\\ _\\ \_______\ \_______\ \__\\ \__\ \_______\       \ \_______\ \__\ \__\ \__\ \__\ \__\\ \__\ \_______\ \_______\ \__\\ _\ 
'    \|_______|\|__|\|__|\|_______|\|__| \|__|\|_______|\|__|\|__|\|_______|\|_______|\|__| \|__|\|_______|        \|_______|\|__|\|__|\|__|\|__|\|__| \|__|\|_______|\|_______|\|__|\|__|
' _____        _____ _                  _____        _   
'| __  |_ _   |   __| |_ ___ _ _ ___   |_   ____ ___| |_ 
'| __ -| | |  |__   |  _| -_| | | -_|    | || -_|  _|   |
'|_____|_  |  |_____|_| |___|\_/|___|    |_||___|___|_|_|
'      |___|            The above is best viewed with Word Wrap turned off unless your using a small font and/or a big screen
'
'Background Changer by Steve Tech
'
'You may look at my code and if you can make it better please tell me and I might use yours instead of mine (don't worry I will add credits).
'If you know more than me please look at line 88 and 89 and tell me if there is a better way of killing a task and running a reg file.
'I haven't programmed vbs in a long time.

title = "Background Changer"

Set WshShell = WScript.CreateObject("WScript.Shell")
If WScript.Arguments.Length = 0 Then
	Set ObjShell = CreateObject("Shell.Application")
	ObjShell.ShellExecute "wscript.exe" _
	, """" & WScript.ScriptFullName & """ RunAsAdministrator", , "runas", 1
	WScript.Quit
End if

'This is not needed because the above code already makes you run it as an Administrator,
'But It's there just to be on the safe side and stop people from saying its not working because their not running as admin.
Function CSI_IsAdmin()
'Version 1.31
'http://csi-windows.com/toolkit/csi-isadmin
	CSI_IsAdmin = False
	On Error Resume Next
	key = CreateObject("WScript.Shell").RegRead("HKEY_USERS\S-1-5-19\Environment\TEMP")
	If err.number = 0 Then CSI_IsAdmin = True
End Function

do While CSI_IsAdmin = False
If NOT CSI_IsAdmin Then
	msg = MsgBox ("Error." & vbNewLine & "Please Run as Administrator.", vbOKCancel, title)
	Select Case msg
	Case vbOK
		Set WshShell = WScript.CreateObject("WScript.Shell")
		If WScript.Arguments.Length = 0 Then
			Set ObjShell = CreateObject("Shell.Application")
			ObjShell.ShellExecute "wscript.exe" _
			, """" & WScript.ScriptFullName & """ RunAsAdministrator", , "runas", 1
			WScript.Quit
		End if
	Case vbCancel
		WScript.Quit
	End Select
	WScript.Quit
End If
loop
'Now this bit is needed it's the first message
msg = MsgBox ("Do you want to change your background?" & vbNewLine & vbNewLine & "WARNING: USE AT YOUR OWN RISK." & vbNewLine & "Please Note: I am not responsible for any damage to your computer nor am I responsible for any trouble you get into.", vbYesNo, title)
Select Case msg
Case vbno
	WScript.Quit
End Select

'Check if this is a School/Work computer
Const HKEY_LOCAL_MACHINE = &H80000002
Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
If Not oReg.EnumKey(HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Policies\System\", "Wallpaper") = 0 Then
  msg = MsgBox ("This may not be a School or Work computer." & vbNewLine & "I do not recommend using this on a Home computer." & vbNewLine & "Do you still want to continue", 52, title)
Select Case msg
Case vbno
	WScript.Quit
End Select
End If

Set wShell=CreateObject("WScript.Shell")
Set oExec=wShell.Exec("mshta.exe ""about:<input type=file id=FILE><script>FILE.click();new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).WriteLine(FILE.value);close();resizeTo(0,0);</script>""")
FileSelected = oExec.StdOut.ReadLine

FileSelected = Replace(FileSelected,"\","/")

text = "Your file path:"
msg = MsgBox (text & vbNewLine & FileSelected, 65, title)
Select Case msg
Case vbCancel
	WScript.Quit
End Select

Dim position
do
	'UCase to make the reply upper case so the program can ignore the case
	position = UCase(InputBox ("Choose a Picture Position" & vbNewLine & chr(149) & "Center" & vbNewLine & chr(149) & "Tile" & vbNewLine & chr(149) & "Stretch" & vbNewLine & chr(149) & "Fit" & vbNewLine & chr(149) & "Fill",title,"Center"))
	'Check if it's an option. The numbers arn't really needed but their just for advanced and lazy people like I am
	If position="CENTER" or position="TILE" or position="STRETCH" or position="FIT" or position="FILL" or position="0" or position="1" or position="2" or position="3" or position="4" then
		Exit Do
	else
		msg = MsgBox ("Please select a valid option.", 49, title)
		Select Case msg
		Case vbCancel
			WScript.Quit
		End Select
	End If
loop
'Change the reply to a number that is used in the registry and the numbers skip this step
position = Replace(position,"CENTER","0")
position = Replace(position,"TILE","1")
position = Replace(position,"STRETCH","2")
position = Replace(position,"FIT","3")
position = Replace(position,"FILL","4")

strTemp = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr"
If WshShell.RegRead(strTemp) = "1" then
	msg = MsgBox ("Would you like to enable Task Manager?", 35, title)
	Select Case msg
	Case vbYes
		tskmgr = """DisableTaskMgr""=dword:00000000"
	Case vbNo
		tskmgr = ""
	Case vbCancel
		WScript.Quit
	End Select
End If
'Get the location for the file then create it
Set objShell = Wscript.CreateObject("Wscript.Shell")
startup = objShell.SpecialFolders("startup")
Set objFSO=CreateObject("Scripting.FileSystemObject")
outFile=startup & "\Background Change.reg"
Set objFile = objFSO.CreateTextFile(outFile,True)
objFile.Write "Windows Registry Editor Version 5.00" & vbCrLf & vbCrLf & "[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System]" & vbCrLf & """Wallpaper""=" & chr(34) & FileSelected & chr(34) & vbCrLf & """WallpaperStyle""=" & chr(34) & position & chr(34) & vbCrLf & tskmgr
objFile.Close
objShell.Run "cmd.exe /c Taskkill /IM explorer.exe /F", 2, True
objShell.Run "cmd.exe /c regedit /s " & chr(34) & outFile & chr(34), 2, True
Set oExec=wShell.Exec("explorer.exe")
MsgBox "Done!" & vbNewLine & "Thank's for using Steve's Background Changer.", 64, title