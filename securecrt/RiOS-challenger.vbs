# $language = "VBScript"
# $interface = "1.0"
' Script zum "cli challenge generate" auf Riverbed Steelheads und anschlieﬂendem "cli challenge response"
' Script to "cli challenge generate" on Riverbed Steelheads and then send the "cli challenge response"
' helpful with dozens of devices, probably faster than the reaction time of ...
' Part of https://github.com/servidge/snowflakes
' adelvgtest2 # cli challenge generate
' Generated challenge: 03124100
' adelvgtest2 # cli challenge response 1E436D1591

Sub Main
Const Timeout = 2
crt.Screen.Synchronous = True
 challe1 = "Generated challenge: 03124100"
 respon1 = "1E436D1591"
 challe2 = "Generated challenge: 09109232"
 respon2 = "1ED665211F"
 challe3 = "Generated challenge: 08195332"
 respon3 = "1ED6653462"
 challe4 = "Generated challenge: 01087168"
 respon4 = "1ED6654680"
 challe5 = "Generated challenge: 07037389"
 respon5 = "1ED6655AB9"
 challe6 = "Generated challenge: 14042103"
 respon6 = "1ED6656103"
 challe7 = "Generated challenge: 07110116"
 respon7 = "1ED665792C"

crt.Screen.Send "cli challenge generate" & vbCr
 
'Caseloop
do
	caseCount = 0
	caseCount = crt.screen.WaitForStrings(" # ",_
	challe1,_
	challe2,_
	challe3,_
	challe4,_
	challe5,_
	challe6,_
	challe7,_
	"unlikelyunlikely", 20)
	
		Select Case caseCount
			Case 1
				crt.Sleep 50
				crt.Screen.Send "cli challenge generate" & vbCr
					
			Case 2
				crt.Sleep 200
				crt.Screen.Send "cli challenge response " & respon1 & vbCr
				'MsgBox "That's a Bingo!"
				crt.Sleep 2000
				Exit Do
			Case 3
				crt.Sleep 200
				crt.Screen.Send "cli challenge response " & respon2 & vbCr
				'MsgBox "That's a Bingo!"
				crt.Sleep 2000
				Exit Do
			Case 4
				crt.Sleep 200
				crt.Screen.Send "cli challenge response " & respon3 & vbCr
				'MsgBox "That's a Bingo!"
				crt.Sleep 2000
				Exit Do
			Case 5
				crt.Sleep 200
				crt.Screen.Send "cli challenge response " & respon4 & vbCr
				'MsgBox "That's a Bingo!"
				crt.Sleep 2000
				Exit Do
			Case 6
				crt.Sleep 200
				crt.Screen.Send "cli challenge response " & respon5 & vbCr
				'MsgBox "That's a Bingo!"
				crt.Sleep 2000		
				Exit Do
			Case 7
				crt.Sleep 200
				crt.Screen.Send "cli challenge response " & respon6 & vbCr
				'MsgBox "That's a Bingo!"
				crt.Sleep 2000
				Exit Do
			Case 8
				crt.Sleep 200
				crt.Screen.Send "cli challenge response " & respon7 & vbCr
				'MsgBox "That's a Bingo!"
				crt.Sleep 2000	
				Exit Do		
			Case 9
				MsgBox "That's not a Bingo!!!!!!!!!!!!!!!!!!!!!!!!!!"
		Case Else
	End Select
Loop

crt.Sleep 200
'crt.Screen.Send "conf t" & vbCr
'crt.Screen.Send "internal set modify - /stats/config/alarm/........ " & vbCr
'crt.Screen.Send "wr mem" & vbCr
MsgBox "That's a Bingo!"

End Sub
