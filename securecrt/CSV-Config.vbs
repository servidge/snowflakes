# $language = "vbscript"
# $interface = "1.0"
' Script zum konfigurieren anhand einer csv Input Datei. 
' Script to configure devices using a csv input file.
' Part of https://github.com/servidge/snowflakes
' Beispiel für CSV Input Datei, !=Zeilenstart für Kommentar, Semikolon als Trenner
' Sample CSV input File, !=start of line as comment, semicolon as a separator
' !beispieldatei - dummyinput
' Hostname1;192.168.1.1;loopback 1;10.10.1.1;255.255.255.255;
' Hostname2;192.168.2.1;loopback 1;10.10.2.1;255.255.255.255;

'crt.screen.synchronous = true
'crt.screen.ignoreescape = true
const forreading = 1
USERNAME="USERNAME"
PASSWORD="PASSWORT"
ENABLE="SECRET"
Const logintimeout = 8
Const sendwaitsec = 2
Const sendmarker = "#"
Const separator = ";"
Const sepadd = 30


management1ask = "Bitte Loginprompt eingeben oder Vorschlag mit Ok bestätigen // Please enter loginprompt or confirm suggestion with Ok"
userabort = " q   Script beenden / Quit "

sub main
crt.dialog.messagebox("START")
crt.screen.send " " & chr(13)
crt.screen.send " " & chr(13)
crt.screen.send " " & chr(13)
crt.screen.send " " & chr(13)
currentline = crt.screen.get(crt.screen.currentrow - 1 , 0, crt.screen.currentrow - 1, crt.screen.columns)
management = inputbox("Enter Service Prompt:" &vbcr&vbcr & management1ask &vbcr& userabort, "Prompt?",trim(currentline))		' does not work well
if management = "q" then wscript.quit


dim fso, f
set fso = createobject("scripting.filesystemobject")
inputfile = crt.dialog.fileopendialog("Select Inputfile", "open", "csv-config-input.txt", "text files (*.txt)|*.txt||")
'inputfile="csv-config-input.txt" 'old securecrt version. before ~6.7
set f = fso.opentextfile(inputfile, forreading, 0)

dim line, parameter, maxstring
do while f.atendofstream <> true
	line = f.readline
	line = ltrim(line)
	if len(line) = 0 then
		'crt.dialog.messagebox("DEBUG commet: BLANK " )
	elseif (left(line,1) = "!") then
		'crt.dialog.messagebox("DEBUG commet: " & line)
	else
		'line = line & ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" ' 30columns+
		for i = 1 to sepadd ' 30columns+ backup
			line = line & separator
		next
		'maxstring=len(line) - len(replace(line, separator, "")) 
		'crt.dialog.messagebox(maxstring & " DEBUG use: " & line)	
		 	
		item00 = split(line, separator)(0)
		item01 = split(line, separator)(1)
		item02 = split(line, separator)(2)
		item03 = split(line, separator)(3)
		item04 = split(line, separator)(4)
		item05 = split(line, separator)(5)
		item06 = split(line, separator)(6)
		item07 = split(line, separator)(7)
		item08 = split(line, separator)(8)
		item09 = split(line, separator)(9)
		item10 = split(line, separator)(10)
		item11 = split(line, separator)(11)
		item12 = split(line, separator)(12)
		item13 = split(line, separator)(13)
		item14 = split(line, separator)(14)
		item15 = split(line, separator)(15)
		item16 = split(line, separator)(16)
		item17 = split(line, separator)(17)
		item18 = split(line, separator)(18)
		item19 = split(line, separator)(19)
		item20 = split(line, separator)(20)
		item21 = split(line, separator)(21)
		item22 = split(line, separator)(22)
		item23 = split(line, separator)(23)
		item24 = split(line, separator)(24)
		item25 = split(line, separator)(25)
		item26 = split(line, separator)(26)
		item27 = split(line, separator)(27)
		item28 = split(line, separator)(28)
		item29 = split(line, separator)(29)
		item30 = split(line, separator)(30)
		'##### Configjob START ##################
		configjob="ter len 0" & chr(13)
		configjob=configjob & "conf t " & chr(13)
		configjob=configjob & "!DEBUG00 " & item00 & chr(13)
		configjob=configjob & "!DEBUG01 " & item01 & chr(13)
		configjob=configjob & "!DEBUG02 " & item02 & chr(13)
		configjob=configjob & "!DEBUG03 " & item03 & chr(13)
		configjob=configjob & "!DEBUG04 " & item04 & chr(13)
		configjob=configjob & "end" 
		'##### Configjob ENDE  ##################
		HOSTNAME = item01
		crt.Screen.Send "ssh -o ""StrictHostKeyChecking no"" -l " & USERNAME & " " & HOSTNAME & Chr(13)
		ResultConnect = crt.screen.WaitForStrings("assword","placeholder", logintimeout)
		Select Case ResultConnect
		Case 1 'assword
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
		Case 2 'placeholder
			'log todo
		Case Else 'timeout
			'log todo
			crt.Screen.Send Chr(3)
			crt.Screen.Send Chr(3)
			crt.Screen.Send Chr(13)
			crt.Screen.Send Chr(13)
		End Select
		
		crt.Screen.Send Chr(13)
		crt.Screen.WaitForString(management)
	end if
loop
crt.dialog.messagebox("ENDE")
end sub
