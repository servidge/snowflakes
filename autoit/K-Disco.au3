#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=WinMDNSv2.exe
#AutoIt3Wrapper_Compression=3
#AutoIt3Wrapper_Res_Description=mDNS Zeroconf Receiver-pcap
#AutoIt3Wrapper_Res_Fileversion=0.0.2.0
#AutoIt3Wrapper_Res_LegalCopyright=Sebastian Bönning 2020
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_Field=ProductName|WinMDNSv2
#AutoIt3Wrapper_Res_Field=ProductVersion|2.0
#AutoIt3Wrapper_Res_Field=OriginalFileName|WinMDNSv2.exe
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
; Winpcap autoit3 UDF demo - V1.2c
; Copyleft GPL3 Nicolas Ricquemaque 2009-2011
; original source from http://opensource.grisambre.net/pcapau3/
; or from https://github.com/dbkaynor/AutoIt3/blob/master/Saves/wincap/Winpcap_demo.au3
; genauer Startpunkt unklar. 
; exact starting point unclear.
; 
; still botched for mdns discovery and ssh connect to replace less than useful vendor software
;===================================================================================================================================================================
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <StaticConstants.au3>
#include <ComboConstants.au3>
#include <Winpcap.au3>
$VER = "2.0"
$MACMARKER="B8:27:EB:"
$WinMDNSVer = "WinMDNS - v"& $VER &" - Sebastian Bönning - 2019-" & @YEAR
$winpcap = _PcapSetup()
If ($winpcap = -1) Then
	FileInstall("npcap-0.9987.exe", @TempDir & '\', 1)
	MsgBox(16, "Pcap Fehler !", "WinPcap oder " & @CRLF & "Npcap Treiber in WinPcap API Mode" & @CRLF & "nicht gefunden!" &  @CRLF &  @CRLF & "Bitte passend installieren und Programm neu starten. Danke!" &  @CRLF & "Installation von Npcap 0.9987 wird gestartet. " )
	$sPath = @TempDir & '\npcap-0.9987.exe'
	ShellExecute($sPath, ' /winpcap_mode=yes')
	FileDelete(@TempDir & "\npcap-0.9987.exe")
	Exit
EndIf

$pcap_devices = _PcapGetDeviceList()
;_ArrayDisplay($pcap_devices, "Devices list", -1, 1) ; display it

If ($pcap_devices = -1) Then
	MsgBox(16, "Pcap error !", _PcapGetLastError())
	Exit
EndIf

FileInstall("Putty.exe", @TempDir & '\', 1)

GUICreate("Packet capture", 650, 400)
Global $ComboInterface = GUICtrlCreateCombo("", 80, 15, 555, Default, $CBS_DROPDOWNLIST)
GUICtrlSetTip(-1, "Available input sources")
GUICtrlSetData(-1, "Pcap capture file")
For $i = 0 To UBound($pcap_devices) - 1
	ConsoleWrite(@ScriptLineNumber & " " & $pcap_devices[$i][1] & @CRLF)
	GUICtrlSetData(-1, $i & " " & $pcap_devices[$i][1], "Pcap capture file")
Next

GUICtrlSetStyle(GUICtrlCreateLabel("IP:", 10, 40, 90), $SS_RIGHT)
$IP = GUICtrlCreateInput("", 100, 40, 535)
GUICtrlSetTip(-1, "Erste IP address auf Port")

GUICtrlSetStyle(GUICtrlCreateLabel("MAC:", 10, 60, 90), $SS_RIGHT)
$MAC = GUICtrlCreateInput("", 100, 60, 535)
GUICtrlSetTip(-1, "MAC des Port")


GUICtrlSetStyle(GUICtrlCreateLabel("Filter:", 10, 80, 90), $SS_RIGHT)
$filter = GUICtrlCreateInput("host 224.0.0.251 and port 5353", 100, 80, 535)

GUICtrlSetTip(-1, "Filter to apply to packets")

GUICtrlSetStyle(GUICtrlCreateLabel("SSH Username:", 10, 100, 90), $SS_RIGHT)
$USERNAME=GUICtrlCreateInput("admin", 100, 100, 535)
GUICtrlSetTip(-1, "Username fuer SSH Verbindung")


;$packetwindow = GUICtrlCreateListView("Nr|Time|Len|L2|L3-Packet", 10, 130, 570, 200)
$packetwindow = GUICtrlCreateListView("Nr|Time|Len|L2|L3-Packet", 10, 130, 630, 200)
_GUICtrlListView_SetColumn($packetwindow, 0, "Nr", 40, 1)
_GUICtrlListView_SetColumnWidth($packetwindow, 1, 80)
_GUICtrlListView_SetColumn($packetwindow, 2, "Len", 40, 1)
_GUICtrlListView_SetColumnWidth($packetwindow, 3, 180)
_GUICtrlListView_SetColumnWidth($packetwindow, 4, 330)

;$promiscuous = GUICtrlCreateCheckbox("promiscuous", 400, 45)
$start = GUICtrlCreateButton("Start", 20, 340, 60)
$stop = GUICtrlCreateButton("Stop", 110, 340, 60)
GUICtrlSetState(-1, $GUI_DISABLE)
$clear = GUICtrlCreateButton("Clear", 200, 340, 60)
$stats = GUICtrlCreateButton("Stats", 290, 340, 60)
$StartSSH = GUICtrlCreateButton("SSH auf IP", 380, 340, 260)
GUICtrlSetState(-1, $GUI_DISABLE)
;$save = GUICtrlCreateCheckbox("Save packets", 395, 340, 90, 30)
GUICtrlSetStyle(GUICtrlCreateLabel("Interface:", 10, 20, 60), $SS_RIGHT)

GUICtrlCreateLabel($WinMDNSVer, 10, 380, 250, 20)

GUISetState()

$i = 0
$pcap = 0
$packet = 0
$pcapfile = 0
$prom = 0
Do
	$msg = GUIGetMsg()

	If ($msg = $ComboInterface) Then
				For $n = 0 To UBound($pcap_devices) - 1
				ConsoleWrite(@ScriptLineNumber & " >>" & StringMid(GUICtrlRead($ComboInterface), 2, 100) & "<<" & @CRLF)
				ConsoleWrite(@ScriptLineNumber & " >>" & $pcap_devices[$n][1] & "<<" & @CRLF)

				If $pcap_devices[$n][1] = StringStripWS(StringMid(GUICtrlRead($ComboInterface), 2, 100),3) Then
					$int = $pcap_devices[$n][0]
					GUICtrlSetData($IP,$pcap_devices[$n][7])
					GUICtrlSetData($MAC,$pcap_devices[$n][6])
					GUICtrlSetData($filter,"host 224.0.0.251 and udp port 5353 and ether dst host 01:00:5E:00:00:FB and not ether host "&$pcap_devices[$n][6])
					ExitLoop
				EndIf
			Next
	EndIf
	If ($msg = $start) Then
		$pcap = _PcapStartCapture($int, GUICtrlRead($filter), $prom)
		If ($pcap = -1) Then
			MsgBox(16, "Pcap error !", _PcapGetLastError())
			ContinueLoop
		EndIf
		$linktype = _PcapGetLinkType($pcap)
		If ($linktype[1] <> "EN10MB") Then
			MsgBox(16, "Pcap error !", "This example only works for Ethernet captures")
			ContinueLoop
		EndIf
		GUICtrlSetState($stop, $GUI_ENABLE)
		GUICtrlSetState($stats, $GUI_ENABLE)
		GUICtrlSetState($start, $GUI_DISABLE)
		GUICtrlSetState($StartSSH , $GUI_DISABLE)
		;GUICtrlSetState($save, $GUI_DISABLE)
	EndIf

	If ($msg = $stop) Then
		If IsPtr($pcapfile) Then
			_PcapStopCaptureFile($pcapfile)
			$pcapfile = 0
		EndIf
		If Not IsInt($pcap) Then _PcapStopCapture($pcap)
		$pcap = 0
		GUICtrlSetState($stop, $GUI_DISABLE)
		GUICtrlSetState($stats, $GUI_DISABLE)
		GUICtrlSetState($start, $GUI_ENABLE)
		;GUICtrlSetState($StartSSH , $GUI_ENABLE)
		;GUICtrlSetState($save, $GUI_ENABLE)
	EndIf

	If ($msg = $clear) Then
		_PcapGetStats($pcap)
		_GUICtrlListView_DeleteAllItems($packetwindow)
		GUICtrlSetState($StartSSH , $GUI_DISABLE)
		$i = 0
	EndIf
	
	If ($msg = $StartSSH) Then
		SSHstart()
	EndIf

	If ($msg = $stats) Then
		$s = _PcapGetStats($pcap)
		_ArrayDisplay($s, "Capture statistics")
	EndIf

	If IsPtr($pcap) Then ; If $pcap is a Ptr, then the capture is running
		$time0 = TimerInit()
		While (TimerDiff($time0) < 500) ; Retrieve packets from queue for maximum 500ms before returning to main loop, not to "hang" the window for user
			$packet = _PcapGetPacket($pcap)
			If IsInt($packet) Then ExitLoop
			$payload = MyDissector($packet[3])
			GUICtrlCreateListViewItem($i & "|" & StringTrimRight($packet[0], 4) & "|" & $packet[2] & "|" & $payload, $packetwindow)
			;MsgBox(0, "Result", $payload)
			if StringLeft($payload, 9) = $MACMARKER Then
				;MsgBox(0, "Result", "String startet mit 00:90:B8:")
				GUICtrlSetBkColor(-1,0xff0000)
			EndIf
			
			$data = $packet[3]
			if $i <= 1 then
				_GUICtrlListView_SetItemSelected($packetwindow, $i)
				GUICtrlSetState($StartSSH , $GUI_ENABLE)
			EndIf
			_GUICtrlListView_EnsureVisible($packetwindow, $i)
			
			$i += 1
			
			
			If IsPtr($pcapfile) Then _PcapWriteLastPacket($pcapfile)
		WEnd
	EndIf

Until $msg = $GUI_EVENT_CLOSE

If IsPtr($pcapfile) Then _PcapStopCaptureFile($pcapfile) ; A file is still open: close it
If IsPtr($pcap) Then _PcapStopCapture($pcap) ; A capture is still running: close it
OnExit()
_PcapFree()

Exit


Func MyDissector($data) ; Quick example packet dissector....
	Local $macdst = StringMid($data, 3, 2) & ":" & StringMid($data, 5, 2) & ":" & StringMid($data, 7, 2) & ":" & StringMid($data, 9, 2) & ":" & StringMid($data, 11, 2) & ":" & StringMid($data, 13, 2)
	Local $macsrc = StringMid($data, 15, 2) & ":" & StringMid($data, 17, 2) & ":" & StringMid($data, 19, 2) & ":" & StringMid($data, 21, 2) & ":" & StringMid($data, 23, 2) & ":" & StringMid($data, 25, 2)
	Local $ethertype = BinaryMid($data, 13, 2)

	If $ethertype = "0x0806" Then Return $macsrc & " -> " & $macdst & "|" & "ARP " & $macsrc & " -> " & $macdst

	If $ethertype = "0x0800" Then
		Local $src = Number(BinaryMid($data, 27, 1)) & "." & Number(BinaryMid($data, 28, 1)) & "." & Number(BinaryMid($data, 29, 1)) & "." & Number(BinaryMid($data, 30, 1))
		Local $dst = Number(BinaryMid($data, 31, 1)) & "." & Number(BinaryMid($data, 32, 1)) & "." & Number(BinaryMid($data, 33, 1)) & "." & Number(BinaryMid($data, 34, 1))
		Switch BinaryMid($data, 24, 1)
			Case "0x01"
				Return $macsrc & " -> " & $macdst & "|" & "ICMP " & $src & " -> " & $dst
			Case "0x02"
				Return $macsrc & " -> " & $macdst & "|" & "IGMP " & $src & " -> " & $dst
			Case "0x06"
				Local $srcport = Number(BinaryMid($data, 35, 1)) * 256 + Number(BinaryMid($data, 36, 1))
				Local $dstport = Number(BinaryMid($data, 37, 1)) * 256 + Number(BinaryMid($data, 38, 1))
				Local $flags = BinaryMid($data, 48, 1)
				Local $f = ""
				If BitAND($flags, 0x01) Then $f = "Fin "
				If BitAND($flags, 0x02) Then $f &= "Syn "
				If BitAND($flags, 0x04) Then $f &= "Rst "
				If BitAND($flags, 0x08) Then $f &= "Psh "
				If BitAND($flags, 0x10) Then $f &= "Ack "
				If BitAND($flags, 0x20) Then $f &= "Urg "
				If BitAND($flags, 0x40) Then $f &= "Ecn "
				If BitAND($flags, 0x80) Then $f &= "Cwr "
				$f = StringTrimRight(StringReplace($f, " ", ","), 1)
				Return $macsrc & " -> " & $macdst & "|" & "TCP(" & $f & ") " & $src & ":" & $srcport & " -> " & $dst & ":" & $dstport
			Case "0x11"
				Local $srcport = Number(BinaryMid($data, 35, 1)) * 256 + Number(BinaryMid($data, 36, 1))
				Local $dstport = Number(BinaryMid($data, 37, 1)) * 256 + Number(BinaryMid($data, 38, 1))
				
				
				Return $macsrc & " -> " & $macdst & "|" & "UDP " & $src & ":" & $srcport & " -> " & $dst & ":" & $dstport
			Case Else
				Return $macsrc & " -> " & $macdst & "|" & "IP " & BinaryMid($data, 24, 1) & " " & $src & " -> " & $dst
		EndSwitch
		Return $macsrc & " -> " & $macdst & "|" & BinaryMid($data, 13, 2) & " " & $src & " -> " & $dst
	EndIf

	If $ethertype = "0x8137" Or $ethertype = "0x8138" Or $ethertype = "0x0022" Or $ethertype = "0x0025" Or $ethertype = "0x002A" Or $ethertype = "0x00E0" Or $ethertype = "0x00FF" Then
		Return $macsrc & " -> " & $macdst & "|" & "IPX " & $macsrc & " -> " & $macdst
	EndIf

	Return $macsrc & " -> " & $macdst & "|" & "[" & $ethertype & "] " & $macsrc & " -> " & $macdst
EndFunc   ;==>MyDissector


Func OnExit()
	If ProcessExists("Putty.exe") Then ProcessClose("Putty.exe")
	FileDelete(@TempDir & "\Putty.exe")
	FileDelete(@TempDir & "\npcap-0.9987.exe")
EndFunc


Func SSHstart()
;Aktuelle Zeile ermitteln
$zeile = _GUICtrlListView_GetSelectedIndices($packetwindow)
;MsgBox(0, "Information", "zeile ist: " & $zeile )

;aktuell ausgewählte zeile darstellen
;;MsgBox(0, "Information", "Item Text: " & @CRLF & @CRLF & _GUICtrlListView_GetItemTextString($packetwindow, -1 ))

;$zeile zeile in Array
;MsgBox(0, "Information", "Item 2 Text: " & _GUICtrlListView_GetItemText($packetwindow, Int($zeile),3))

;Spalte aus Zeile nehemen mit Payload
$spalte = _GUICtrlListView_GetItemText($packetwindow, Int($zeile),4)
;MsgBox(0, "Information", "Spalte ist: " & $spalte )

;Spalte aufteilen in einzelne Felder. 
$splitter = StringSplit($spalte," ")
;For $x = 1 To $splitter[0]
;    MsgBox(0,$x,$splitter[$x])
;Next
;IP adresse+Port aus spalte
$teil2 = $splitter[2]
;MsgBox(0, "Information", "teil2 ist: " & $teil2 )

;Aufteilen von IP und Port in einzelteile
$reg=StringRegExp($teil2,"([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})\:([0-9]{1,5})",3)
;MsgBox(0, "Information", "Reg 1 ist: " & $reg[0] )
;IP Adresse aus aufteilung
$SSHipADRESS = $reg[0]
;SSH vorbereitungen
$SSHUser=GUICtrlRead($USERNAME)
$sPath = @TempDir & '\Putty.exe'
ShellExecute($sPath, ' -ssh -l ' & $SSHUser & ' ' & $SSHipADRESS)
If @error Then ConsoleWrite("Putty ist mit folgendem Fehler gestartet worden: " & @error & @CRLF & "ggf. auf die IP  " & $SSHipADRESS & " eine SSH Verbindung aufbauen")



EndFunc
