#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=cisco.ico
#AutoIt3Wrapper_Outfile=WinMDNS.exe
#AutoIt3Wrapper_Compression=3
#AutoIt3Wrapper_Res_Description=mDNS Zeroconf Receiver
#AutoIt3Wrapper_Res_Fileversion=0.0.1.3
#AutoIt3Wrapper_Res_LegalCopyright=Sebastian Bönning 2020
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_Field=ProductName|WinMDNS
#AutoIt3Wrapper_Res_Field=ProductVersion|1.5
#AutoIt3Wrapper_Res_Field=OriginalFileName|WinMDNS.exe
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===================================================================================================================================================================
; was WinCDP - Cisco Discovery for Windows - Chris Hall 2010-2012 - https://github.com/chall32/WinCDP
; botched for mdns discovery and ssh connect to replace less than useful vendor software
;===================================================================================================================================================================
$VER = "1.5"

#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <File.au3>
#Include <String.au3>
#include <GuiButton.au3>
#include <ComboConstants.au3>
$WinMDNSVer = "WinMDNS - v"& $VER &" - Sebastian Bönning - 2019-" & @YEAR

if IsAdmin() = 0 then
	MsgBox(16,"Exiting","Adminrechte werden benötigt")
	Exit
	EndIf
FileInstall("WinDump.exe", @TempDir & '\', 1)
FileInstall("Putty.exe", @TempDir & '\', 1)

GUISetIcon("icon.ico")

$log = FileOpen(@TempDir & "\MDNS.txt", 2)
$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
$strComputer = "localhost"
$Output=""
$Nic_Friend =""
$Hardware=""
$IData=""
$MDNSDevice="127.0.0.1"

SplashTextOn("Bitte Warten","Netzwerkkarten werden per WMI ermittelt.", 350, 50)
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter Where PhysicalAdapter=True", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
If IsObj($colItems) then
   For $objItem In $colItems
			$value = $objItem.NetConnectionID
			$colItems2 = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
			For $objItem2 In $colItems2
				If $objItem.Index = $objItem2.Index Then
				If StringLen($value) > 1 Then $Output = $Output & $value & "|"
				FileWriteLine($log, "[" & $objItem.NetConnectionID & "]")
				FileWriteLine($log, "ProductName=" & $objItem.ProductName)
						FileWriteLine($log, "SettingID=" & $objItem2.SettingID)
						FileWriteLine($log, "MAC=" & $objItem2.MACAddress)
						
				EndIf
			Next
	Next
Else
   Msgbox(0,"WMI Output","Keine WMI Objecte gefunden für Klasse: " & "Win32_NetworkAdapterConfiguration" )
Endif
SplashOff()
GUICreate("Zeroconf, MDNS Receiveer für Windows", 550, 300, (@DesktopWidth - 550) / 2, (@DesktopHeight - 400) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
GUICtrlCreateGroup("Selection ", 15, 10, 520, 137)
GUICtrlCreateLabel("Netzwerk Verbindung:", 30, 35, 110, 20)
$Nic_Friendly = GUICtrlCreateCombo("",145,33,350,20, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, $Output)
GUICtrlCreateLabel("Netzwerk Karte:", 30, 62, 110, 20)
GUICtrlCreateLabel("SSH Username:", 30, 89, 110, 20)

$USERNAME=GUICtrlCreateInput("admin", 145, 89, 350, 20)
$Get = GUICtrlCreateButton("Aufzeichnen", 120, 112, 100)
$StartSSH = GUICtrlCreateButton("SSH auf IP", 260, 112, 100)
GUICtrlSetState($StartSSH, $GUI_DISABLE)
$Cancel = GUICtrlCreateButton("Abbrechen", 400, 112, 100)
If RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System", "EnableLUA") > 0 Then
    GUICtrlSetImage($Get, "imageres.dll", -2, 0)
	 _GUICtrlButton_SetShield($Get)
EndIf
GUICtrlCreateGroup("Results ", 15, 157, 520, 60)
GUICtrlCreateLabel("IP Addresse:", 280, 187, 70, 20)
GUICtrlCreateLabel("Eigene MAC:", 30, 187, 70, 20)
$EigeneMAC="FF:FF:FF:FF:FF:FF"
GUICtrlCreateLabel($EigeneMAC, 140, 187, 100, 20)
GUICtrlCreateLabel($WinMDNSVer, 300, 275, 250, 20)

GUISetState()
	While 1
		Switch GUIGetMsg()

		Case $Nic_Friendly
		
			$Nic_Friend = GUICtrlRead ($Nic_Friendly)
			$IData = IniReadSection(@TempDir & "\MDNS.txt", $Nic_Friend)
			$Hardware = $IData[1][1]
			$EigeneMAC = $IData[3][1]
			GUICtrlCreateLabel($Hardware, 145, 62, 350, 20)
			GUICtrlCreateLabel($EigeneMAC, 140, 187, 100, 20)
			ClearResults()
		 Case $Get
			GUICtrlCreateLabel("", 390, 187, 120, 20)
			If GUICtrlRead($Nic_Friendly) = "" Then
			   MsgBox(64,"Ungültige Auswahl", "Bitte eine Netzwerkkarte im Dropdownmenü auswählen")
			   ContinueLoop
			EndIf
			GetMDNS($Nic_Friendly)
		Case $GUI_EVENT_CLOSE
			OnExit()
			ExitLoop
		Case $Cancel
			GUICtrlSetState($StartSSH, $GUI_DISABLE)
			OnExit()
			ExitLoop
		Case $StartSSH
			SSHstart()
		Case Else
				;;;
		EndSwitch
	WEnd
Exit

	Func GetMDNS($Nic_Friendly)
		GUICtrlCreateLabel("", 120, 247, 350, 20 )
		GUICtrlSetState($Get, $GUI_DISABLE)
		GUICtrlSetState($StartSSH, $GUI_DISABLE)
		ClearResults()
		$ID = $IData[2][1]
		$WinDumpPID = Run(@ComSpec & " /c " & @TempDir & '\WinDump.exe -i \Device\NPF_' & $ID & ' -nn -s 1500 -c 1 -n host 224.0.0.251 and port 5353 and not ether host ' & $EigeneMAC & '>%temp%\MDNS_OUT.txt', "", @SW_HIDE) 
		$Secs = 1
		$Status1 = GUICtrlCreateLabel("Läuft ... nach 90 Sekunden Sekunden wird abgebrochen ...", 120, 227, 350, 20 )
		$iBegin = TimerInit()
		Do
			$msg = GUIGetMsg()
			If $msg = $Cancel Then
				ProcessClose("WinDump.exe")
				ExitLoop
			EndIf
			If Ceiling(TimerDiff($iBegin)) = ($Secs * 1000) or Ceiling(TimerDiff($iBegin)) > ($Secs * 1000) Then
				GUICtrlCreateLabel(Round($Secs,0) & " Sekunden vergangen", 220, 247, 120, 20 )
				$Secs = $Secs + 1
			EndIf
			$WinDumpPID = ProcessExists($WinDumpPID)
		Until $WinDumpPID = "0" Or TimerDiff($iBegin) > 90000
		GUICtrlDelete($Status1)
		GUICtrlCreateLabel("", 220, 247, 120, 20 )
		GUICtrlCreateLabel("", 120, 227, 350, 20 )
$file = FileOpen(@TempDir & "\MDNS_OUT.txt")
Filewrite(@TempDir & "\MDNS_OUT.txt",Chr(10))
$end = _FileCountLines(@TempDir & "\MDNS_OUT.txt")

If $end > 0 Then
$line = 0
Do
	If StringInStr(FileReadLine($file, $line), "224.0.0.251.5353") Then
		$SwitchIP = StringSplit(FileReadLine($file, $line), " ")
		$SwitchIP = StringStripWS($SwitchIP[3],8)
		$teile = StringSplit($SwitchIP, ".")
		$MDNSDevice = $teile[1]&"."&$teile[2]&"."&$teile[3]&"."&$teile[4]
		GUICtrlCreateLabel($MDNSDevice, 390, 187, 120, 20)
		GUICtrlSetState($StartSSH, $GUI_ENABLE)
	EndIf
	$line = $line + 1
Until $line = $end
Else

If ProcessExists("WinDump.exe") Then ProcessClose("WinDump.exe")
	GUICtrlCreateLabel("KEINE MDNS DATEN GEFUNDEN ... !", 120, 227, 350, 20 )
	GUICtrlCreateLabel("Tipp: LAN Kabel abziehen, neu stecken und Prozess neu starten", 120, 247, 350, 20 )
	GUICtrlSetState($StartSSH, $GUI_DISABLE)
EndIf
	FileClose($file)
	FileDelete(@TempDir & "\MDNS_OUT.txt")
	GUICtrlSetState($Get, $GUI_ENABLE)
EndFunc

Func ClearResults()
	GUICtrlCreateLabel("", 140, 250, 120, 20)
EndFunc

Func SSHstart()
	$SSHUser=GUICtrlRead($USERNAME)
	$sPath = @TempDir & '\Putty.exe'
	ShellExecute($sPath, ' -ssh -l ' & $SSHUser & ' ' & $MDNSDevice)
	If @error Then ConsoleWrite("Run failed with error: " & @error & @CRLF)
EndFunc

Func OnExit()
	If ProcessExists("WinDump.exe") Then ProcessClose("WinDump.exe")
	If ProcessExists("Putty.exe") Then ProcessClose("Putty.exe")
	FileClose($log)
	FileDelete(@TempDir & "\MDNS.txt")
	FileDelete(@TempDir & "\WinDump.exe")
	FileDelete(@TempDir & "\Putty.exe")
EndFunc
