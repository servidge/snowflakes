# $language = "VBScript"
# $interface = "1.0"
' Script zum konfigurieren anhand einer csv Input Datei. 
' Script to configure devices using a csv input file.
' Part of https://github.com/servidge/snowflakes
' Beispiel für CSV Input Datei, !=Zeilenstart für Kommentar, Semikolon als Trenner
' Sample CSV input File, !=start of line as comment, semicolon as a separator
' !beispieldatei - dummyinput
' Hostname1;192.168.1.1;loopback 1;10.10.1.1;255.255.255.255;
' Hostname2;192.168.2.1;loopback 1;10.10.2.1;255.255.255.255;
Option Explicit
'On Error Resume Next
'crt.screen.synchronous = true
'crt.screen.ignoreescape = true
Dim USERNAME, PASSWORD, ENABLE, HOSTNAME
Dim management1ask, userabort
Dim fso, f, inputfile, logextension, logfile, filelogging
Dim currentline, management, line, i, n
Dim maxstring
Dim configjob, itemARR, item, LINEJOB, ARRJOB, startrow
Dim ResultConnect
Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8
Const logintimeout = 8
Const sendwaitsec = 2
Const sendmarker = "#"
Const separator = ";"
Const sepadd = 30
USERNAME="USERNAME"
PASSWORD="PASSWORT"
ENABLE="SECRET"
logextension = ".log"
Const logpath = ".\"
management1ask = "Bitte Loginprompt eingeben oder Vorschlag mit Ok bestaetigen // Please enter loginprompt or confirm suggestion with Ok"
userabort = " q   Script beenden / Quit "
Set fso = CreateObject("Scripting.FileSystemObject")


crt.dialog.messagebox("START")
inputfile = crt.dialog.fileopendialog("Select Inputfile", "open", "CSV-Config-input.txt", "text files (*.txt)|*.txt||")
'inputfile="CSV-Config-input.txt" 'old securecrt version. before ~6.7
logfile = fso.GetBaseName(inputfile)&logextension
If not fso.FileExists(logpath & logfile) then
	Set filelogging = fso.OpenTextFile(logpath & logfile,ForWriting,True)
		filelogging.WriteLine("angelegt am - "&now()&" - generated ")
	Set filelogging = Nothing
End If


Sub main
crt.screen.send " " & chr(13)
crt.screen.send " " & chr(13)
crt.screen.send " " & chr(13)
crt.screen.send " " & chr(13)
currentline = crt.screen.get(crt.screen.currentrow - 1 , 0, crt.screen.currentrow - 1, crt.screen.columns)
management = inputbox("Enter Service Prompt:" &vbcr&vbcr & management1ask &vbcr& userabort, "Prompt?",trim(currentline))		' does not work well
If management = "q" then wscript.quit

do
	USERNAME = crt.Dialog.Prompt("Enter your username", "Login", USERNAME, False)
loop until USERNAME <> ""
do
	PASSWORD = crt.Dialog.Prompt("Enter your login password", "Password", "", True)
loop until PASSWORD <> ""
do
	enable = crt.Dialog.Prompt("Enter your enable secret", "Secret", "", True)
loop until enable <> ""

writelog "SCRIPT", "START"
Set f = fso.opentextfile(inputfile, ForReading, 0)
do while f.atendofstream <> true
	line = f.readline
	line = ltrim(line)
	If len(line) = 0 then
		'crt.dialog.messagebox("DEBUG commet: BLANK " )
	ElseIf (left(line,1) = "!") then
		'crt.dialog.messagebox("DEBUG commet: " & line)
	Else
		'line = line & ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" ' 30columns+
		for i = 1 to sepadd ' 30columns+ backup
			line = line & separator
		next
		maxstring=len(line) - len(replace(line, separator, "")) 
		'crt.dialog.messagebox(maxstring & " DEBUG use: " & line)	
		
			itemARR = split(line, separator)
			For Each item in itemARR
				'crt.dialog.messagebox(" DEBUG use: " & item)			
			Next

		'##### Configjob START ##################
		'##### Configjob type 1, only single variables
		configjob="ter len 0" & chr(13)
		configjob=configjob & "conf t " & chr(13)
		configjob=configjob & "!DEBUG00 " & itemARR(0) & chr(13)
		configjob=configjob & "!DEBUG01 " & itemARR(1) & chr(13)
		configjob=configjob & "!DEBUG02 " & itemARR(2) & chr(13)
		configjob=configjob & "!DEBUG03 " & itemARR(3) & chr(13)
		configjob=configjob & "!DEBUG04 " & itemARR(4) & chr(13)
		configjob=configjob & "end" 
		'##### Configjob type 2, whole command per column
		' startrow = 5 ' count from 0
		' configjob="ter len 0" & chr(13)
		' configjob=configjob & "conf t " & chr(13)
		' for n = startrow to maxstring
		' If len(Trim(itemARR(n))) <> 0 then
		' 	configjob=configjob &"!"& itemARR(n) & chr(13) '"!"=debug
		' End If
		' next
		' configjob=configjob & "end" 
		'##### Configjob ENDE  ##################
		HOSTNAME = itemARR(1)
		
		crt.Screen.Send "ssh -o ""StrictHostKeyChecking no"" -l " & USERNAME & " " & HOSTNAME & Chr(13)
		ResultConnect = crt.screen.WaitForStrings("assword","placeholder", logintimeout)
		Select Case ResultConnect
		Case 1 'assword ("Perfect World")
			crt.Screen.Send PASSWORD & Chr(13)
			crt.Screen.WaitForString sendmarker, sendwaitsec
			
			ARRJOB = split(configjob, chr(13))
			For Each LINEJOB in ARRJOB
				'crt.dialog.messagebox(LINEJOB)
				crt.Screen.Send LINEJOB & Chr(13)
				crt.Screen.WaitForString sendmarker, sendwaitsec
			Next
			
			crt.Screen.Send Chr(13) 
			crt.Screen.WaitForString sendmarker, sendwaitsec
			crt.Screen.Send "exit" & Chr(13)
			writelog HOSTNAME, "OK"
		Case 2 'placeholder
			writelog HOSTNAME, "placeholder"
		Case Else 'timeout
			writelog HOSTNAME, "timeout"
			crt.Screen.Send Chr(3)
			crt.Screen.Send Chr(3)
			crt.Screen.Send Chr(13)
			crt.Screen.Send Chr(13)
		End Select
		
		crt.Screen.Send Chr(13)
		crt.Screen.WaitForString(management)
	End If
loop
writelog "SCRIPT", "ENDE"
crt.dialog.messagebox("ENDE")
End Sub

Sub writelog(val0,val1) 
  Dim file
  Set file = fso.OpenTextFile(logpath & logfile, ForAppending, True)
  file.write now() & Chr(9) & val0 & Chr(9) & val1 & Chr(9) & vbCrLf
  file.close
End Sub

