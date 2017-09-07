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
		line = line & ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" ' 30columns+
		maxstring=len(line) - len(replace(line, ";", "")) 
		'crt.dialog.messagebox(maxstring & " DEBUG use: " & line)	
		string00 = split(line, ";")(0)
		string01 = split(line, ";")(1)
		string02 = split(line, ";")(2)
		string03 = split(line, ";")(3)
		string04 = split(line, ";")(4)
		string05 = split(line, ";")(5)
		string06 = split(line, ";")(6)
		string07 = split(line, ";")(7)
		string08 = split(line, ";")(8)
		string09 = split(line, ";")(9)
		string10 = split(line, ";")(10)
		string11 = split(line, ";")(11)
		string12 = split(line, ";")(12)
		string13 = split(line, ";")(13)
		string14 = split(line, ";")(14)
		string15 = split(line, ";")(15)
		string16 = split(line, ";")(16)
		string17 = split(line, ";")(17)
		string18 = split(line, ";")(18)
		string19 = split(line, ";")(19)
		string20 = split(line, ";")(20)
		string21 = split(line, ";")(21)
		string22 = split(line, ";")(22)
		string23 = split(line, ";")(23)
		string24 = split(line, ";")(24)
		string25 = split(line, ";")(25)
		string26 = split(line, ";")(26)
		string27 = split(line, ";")(27)
		string28 = split(line, ";")(28)
		string29 = split(line, ";")(29)
		string30 = split(line, ";")(30)
		
		HOSTNAME = string01
		crt.Screen.Send "ssh -o ""StrictHostKeyChecking no"" -l " & USERNAME & " " & HOSTNAME & Chr(13)
		ResultConnect = crt.screen.WaitForStrings("assword","placeholder", logintimeout)
		Select Case ResultConnect
		Case 1 'assword
			crt.Screen.Send PASSWORD & Chr(13)
			crt.Screen.WaitForString("#")
			crt.Screen.Send "!DEBUG00 " & string00 & vbCr
			crt.Screen.WaitForString "#", sendwaitsec
			crt.Screen.Send "!DEBUG01 " & string01 & vbCr
			crt.Screen.WaitForString "#", sendwaitsec
			crt.Screen.Send "!DEBUG02 " & string02 & vbCr
			crt.Screen.WaitForString "#", sendwaitsec
			crt.Screen.Send "!DEBUG03 " & string03 & vbCr
			crt.Screen.WaitForString "#", sendwaitsec
			crt.Screen.Send "!DEBUG04 " & string04 & vbCr
			crt.Screen.WaitForString "#", sendwaitsec
			crt.Screen.Send Chr(13)
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
