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
management1ask = "Bitte Loginprompt eingeben oder Vorschlag mit Ok bestätigen"
userabort = " q   Script beenden "

sub main
crt.dialog.messagebox("START")
crt.screen.send " " & chr(13)
crt.screen.send " " & chr(13)
crt.screen.send " " & chr(13)
crt.screen.send " " & chr(13)
currentline = crt.screen.get(crt.screen.currentrow - 1 , 0, crt.screen.currentrow - 1, crt.screen.columns)
management = inputbox("Prompt eingeben:" &vbcr&vbcr & management1ask &vbcr& userabort, "Prompt?",trim(currentline))		' does not work well
if management = "q" then wscript.quit

dim fso, f
set fso = createobject("scripting.filesystemobject")
inputfile = crt.dialog.fileopendialog("Inputdatei Auswählen", "open", "csv-config-input.txt", "text files (*.txt)|*.txt||")
'inputfile="csv-config-input.txt" 'old securecrt version. before ~6.7
set f = fso.opentextfile(inputfile, forreading, 0)

dim line, parameter
do while f.atendofstream <> true
	line = f.readline
	line = ltrim(line)
	line = line & ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" ' 30columns+
	if (left(line,1) = "!") then
	crt.dialog.messagebox("DEBUG commet: " + line)
	else
	crt.dialog.messagebox("DEBUG use: " + line)	
	end if
loop
crt.dialog.messagebox("ENDE")
end sub

