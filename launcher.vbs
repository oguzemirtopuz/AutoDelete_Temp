' ==============================================================================
' Sessiz Calistirici (Arka planda konsol penceresi acilmadan calistirir)
' ==============================================================================
Set objFSO = CreateObject("Scripting.FileSystemObject")
strCurrentDir = objFSO.GetParentFolderName(WScript.ScriptFullName)
strPsScript = """" & strCurrentDir & "\clean_temp.ps1"""

Set objShell = CreateObject("Wscript.Shell")
' 0 = Gizli pencere, False = Betigin bitmesini beklemeden devam et
objShell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File " & strPsScript, 0, False
