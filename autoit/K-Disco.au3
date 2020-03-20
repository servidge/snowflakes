#NoTrayIcon
#RequireAdmin
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

GUICreate("Packet capture", 500, 400)
Global $ComboInterface = GUICtrlCreateCombo("", 80, 15, 400, Default, $CBS_DROPDOWNLIST)
GUICtrlSetTip(-1, "Available input sources")
GUICtrlSetData(-1, "Pcap capture file")
For $i = 0 To UBound($pcap_devices) - 1
	ConsoleWrite(@ScriptLineNumber & " " & $pcap_devices[$i][1] & @CRLF)
	GUICtrlSetData(-1, $i & " " & $pcap_devices[$i][1], "Pcap capture file")
Next

GUICtrlSetStyle(GUICtrlCreateLabel("IP:", 10, 40, 90), $SS_RIGHT)
$IP = GUICtrlCreateInput("", 100, 40, 330)
GUICtrlSetTip(-1, "Erste IP address auf Port")

GUICtrlSetStyle(GUICtrlCreateLabel("MAC:", 10, 60, 90), $SS_RIGHT)
$MAC = GUICtrlCreateInput("", 100, 60, 330)
GUICtrlSetTip(-1, "MAC des Port")


GUICtrlSetStyle(GUICtrlCreateLabel("Filter:", 10, 80, 90), $SS_RIGHT)
$filter = GUICtrlCreateInput("host 224.0.0.251 and port 5353", 100, 80, 330)
GUICtrlSetTip(-1, "Filter to apply to packets")

GUICtrlSetStyle(GUICtrlCreateLabel("SSH Username:", 10, 100, 90), $SS_RIGHT)
$USERNAME=GUICtrlCreateInput("admin", 100, 100, 330)
GUICtrlSetTip(-1, "Username fuer SSH Verbindung")


$packetwindow = GUICtrlCreateListView("Nr|Time|Len|Packet", 10, 130, 470, 200)
_GUICtrlListView_SetColumn($packetwindow, 0, "Nr", 40, 1)
_GUICtrlListView_SetColumnWidth($packetwindow, 1, 80)
_GUICtrlListView_SetColumn($packetwindow, 2, "Len", 40, 1)
_GUICtrlListView_SetColumnWidth($packetwindow, 3, 330)

;$promiscuous = GUICtrlCreateCheckbox("promiscuous", 400, 45)
$start = GUICtrlCreateButton("Start", 20, 340, 60)
$stop = GUICtrlCreateButton("Stop", 110, 340, 60)
GUICtrlSetState(-1, $GUI_DISABLE)
$clear = GUICtrlCreateButton("Clear", 200, 340, 60)
$stats = GUICtrlCreateButton("Stats", 290, 340, 60)
$StartSSH = GUICtrlCreateButton("SSH auf IP", 380, 340, 60)
GUICtrlSetState(-1, $GUI_DISABLE)
;$save = GUICtrlCreateCheckbox("Save packets", 395, 340, 90, 30)
GUICtrlSetStyle(GUICtrlCreateLabel("Interface:", 10, 20, 60), $SS_RIGHT)

FileInstall("Putty.exe", @TempDir & '\', 1)



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
					GUICtrlSetData($filter,"host 224.0.0.251 and port 5353 and not ether host "&$pcap_devices[$n][6]) 
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
			GUICtrlCreateListViewItem($i & "|" & StringTrimRight($packet[0], 4) & "|" & $packet[2] & "|" & MyDissector($packet[3]), $packetwindow)
			$data = $packet[3]
			_GUICtrlListView_EnsureVisible($packetwindow, $i)
			_GUICtrlListView_SetItemSelected($packetwindow, $i)
			$i += 1
			GUICtrlSetState($StartSSH , $GUI_ENABLE)
			If IsPtr($pcapfile) Then _PcapWriteLastPacket($pcapfile)
		WEnd
	EndIf

Until $msg = $GUI_EVENT_CLOSE

If IsPtr($pcapfile) Then _PcapStopCaptureFile($pcapfile) ; A file is still open: close it
If IsPtr($pcap) Then _PcapStopCapture($pcap) ; A capture is still running: close it
_PcapFree()

Exit


Func MyDissector($data) ; Quick example packet dissector....
	Local $macdst = StringMid($data, 3, 2) & ":" & StringMid($data, 5, 2) & ":" & StringMid($data, 7, 2) & ":" & StringMid($data, 9, 2) & ":" & StringMid($data, 11, 2) & ":" & StringMid($data, 13, 2)
	Local $macsrc = StringMid($data, 15, 2) & ":" & StringMid($data, 17, 2) & ":" & StringMid($data, 19, 2) & ":" & StringMid($data, 21, 2) & ":" & StringMid($data, 23, 2) & ":" & StringMid($data, 25, 2)
	Local $ethertype = BinaryMid($data, 13, 2)

	If $ethertype = "0x0806" Then Return "ARP " & $macsrc & " -> " & $macdst

	If $ethertype = "0x0800" Then
		Local $src = Number(BinaryMid($data, 27, 1)) & "." & Number(BinaryMid($data, 28, 1)) & "." & Number(BinaryMid($data, 29, 1)) & "." & Number(BinaryMid($data, 30, 1))
		Local $dst = Number(BinaryMid($data, 31, 1)) & "." & Number(BinaryMid($data, 32, 1)) & "." & Number(BinaryMid($data, 33, 1)) & "." & Number(BinaryMid($data, 34, 1))
		Switch BinaryMid($data, 24, 1)
			Case "0x01"
				Return "ICMP " & $src & " -> " & $dst
			Case "0x02"
				Return "IGMP " & $src & " -> " & $dst
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
				Return "TCP(" & $f & ") " & $src & ":" & $srcport & " -> " & $dst & ":" & $dstport
			Case "0x11"
				Local $srcport = Number(BinaryMid($data, 35, 1)) * 256 + Number(BinaryMid($data, 36, 1))
				Local $dstport = Number(BinaryMid($data, 37, 1)) * 256 + Number(BinaryMid($data, 38, 1))
				Return "UDP " & $src & ":" & $srcport & " -> " & $dst & ":" & $dstport
			Case Else
				Return "IP " & BinaryMid($data, 24, 1) & " " & $src & " -> " & $dst
		EndSwitch
		Return BinaryMid($data, 13, 2) & " " & $src & " -> " & $dst
	EndIf

	If $ethertype = "0x8137" Or $ethertype = "0x8138" Or $ethertype = "0x0022" Or $ethertype = "0x0025" Or $ethertype = "0x002A" Or $ethertype = "0x00E0" Or $ethertype = "0x00FF" Then
		Return "IPX " & $macsrc & " -> " & $macdst
	EndIf

	Return "[" & $ethertype & "] " & $macsrc & " -> " & $macdst
EndFunc   ;==>MyDissector


Func OnExit()
	If ProcessExists("Putty.exe") Then ProcessClose("Putty.exe")
	FileDelete(@TempDir & "\Putty.exe")
	FileDelete(@TempDir & "\npcap-0.9987.exe")
EndFunc


Func SSHstart()
$zeile = _GUICtrlListView_GetSelectedIndices($packetwindow)
MsgBox(0, "Information", "zeile ist: " & $zeile )

;aktuell ausgewählte zeile darstellen
MsgBox(0, "Information", "Item Text: " & @CRLF & @CRLF & _GUICtrlListView_GetItemTextString($packetwindow, -1 ))

;$zeile zeile in Array
MsgBox(0, "Information", "Item 2 Text: " & _GUICtrlListView_GetItemText($packetwindow, Int($zeile),3))



EndFunc
