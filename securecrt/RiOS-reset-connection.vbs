# $language = "VBScript"
# $interface = "1.0"
' Script zum connection reset ohne Service restart auf Riverbed Steelheads
' Script for connection reset without service restart on Riverbed Steelheads
' Einen einfacheren Weg gibt es nicht. Siehe https://splash.riverbed.com/thread/2935 oder https://splash.riverbed.com/ideas/1226
' There is no better way to reset several connections. Siehe https://splash.riverbed.com/thread/2935 oder https://splash.riverbed.com/ideas/1226
' Part of https://github.com/servidge/snowflakes
' Auswahl der Connections via logfile des "show connections (passthrough)" // Selection of the connections via logfile of the "show connections (passthrough)"
' Quelle//Source:
' PI 10.10.10.10:11111       10.20.20.20:232       TCP         2015/02/17 17:42:53
' Ziel//Target:
' tcp connection send pass-reset source-addr 10.10.10.10 source-port 11111 dest-addr 10.20.20.20 dest-port 232

'crt.Screen.Synchronous = True
'crt.Screen.IgnoreEscape = True
Const ForReading = 1
Management1ask = "Bitte Loginprompt eingeben oder Vorschlag mit OK bestätigen"
Userabort = " q   Script beenden "
MATCH = ":4300"	'Suchstring // Searchstring in Connection (: colon is in each line)

Sub reset(subline)
	If InStr(1,subline,MATCH,1) then 
		subline=Replace(subline,":"," ")
		Do Until InStr(subline, "  ") = 0
			subline = Replace(subline, "   ", " ")
			subline = Replace(subline, "  ", " ")
		Loop
		parameter = Split( subline )
		crt.Screen.Send "!tcp connection send pass-reset source-addr " & parameter(1) & " source-port " & parameter(2) & " dest-addr " & parameter(3) & " dest-port " & parameter(4) & vbCR
		crt.Screen.WaitForString management, 1
	End If
End Sub

Sub main
crt.Dialog.MessageBox("START")
crt.Screen.Send " " & Chr(13)
crt.Screen.Send "conf t" & vbCr
crt.Screen.Send " " & Chr(13)
crt.Screen.Send " " & Chr(13)
crt.Screen.Send " " & Chr(13)
currentline = crt.Screen.Get(crt.screen.CurrentRow - 1 , 0, crt.screen.CurrentRow - 1, crt.Screen.Columns)
management = inputbox("Prompt eingeben:" &vbCr&vbCr & Management1ask &vbCr& Userabort, "Prompt?",Trim(currentline))		' Does not work well
If Management = "q" then wscript.quit

Dim fso, f
Set fso = CreateObject("Scripting.FileSystemObject")
'inputfile = crt.Dialog.FileOpenDialog("Inputdatei Auswählen", "Open", "RiOS-reset-connection-input.txt", "Text Files (*.txt)|*.txt||")
inputfile="RiOS-reset-connection-input.txt" 'Old SecureCRT Version. before ~6.7
Set f = fso.OpenTextFile(inputfile, ForReading, 0)

Dim line, parameter
Do While f.AtEndOfStream <> True
	line = f.Readline
	line=LTrim(line)
	If (Left(line,Len("O")) = "O") Then 		' optimized Connections
	'reset(line)
	ElseIf (Left(line,Len("PI")) = "PI") Then	' passthrough intentional Connections
	'reset(line)
	ElseIf (Left(line,Len("PU")) = "PU") Then	' passthrough unintentional Connections
	reset(line)
	ElseIf (Left(line,Len("H")) = "H") Then		' half opend Connections
	reset(line)
	ElseIf (Left(line,Len("C")) = "C") Then		' half closed Connections
	reset(line)
	Else										' probably not a connection
	'crt.Dialog.MessageBox("debug" + line)
	End If
Loop
crt.Dialog.MessageBox("ENDE")
End Sub
