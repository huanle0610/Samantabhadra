 

'PARAMETERS

'

strComputer = "machineName"   'use "." for local computer

strUser = "domain\user" 'comment this line for current user

strPassword = "password" 'comment this line for current user

'CONSTANTS

'

wbemImpersonationLevelImpersonate = 3

wbemAuthenticationLevelPktPrivacy = 6


'=======================================================================

'MAIN

'=======================================================================


'Connect to machine

'

If Not strUser = "" Then


	'Connect using user and password

	'

	Set objLocator = CreateObject("WbemScripting.SWbemLocator")

	Set objWMI = objLocator.ConnectServer _ (strComputer, "root\cimv2", strUser, strPassword)

	objWMI.Security_.ImpersonationLevel = wbemImpersonationLevelImpersonate

	objWMI.Security_.AuthenticationLevel = wbemAuthenticationLevelPktPrivacy


Else


	'Connect using current user

	'

	Set objWMI = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 


End If


'Get OS name

'

Set colOS = objWMI.InstancesOf ("Win32_OperatingSystem")


For Each objOS in colOS

	strName = objOS.Name

Next


If Instr(strName, "Windows 2000") > 0 Then


	'——————————————————————-

	'Code for Windows 2000

	'——————————————————————-


	'Get user name

	'

	Set colComputer = objWMI.ExecQuery("Select * from Win32_ComputerSystem")


	For Each objComputer in colComputer

		Wscript.Echo "User: " & objComputer.UserName

	Next


	'——————————————————————


Else


	'——————————————————————

	'Code for Windows XP or later

	'——————————————————————


	'Get interactive session

	'

	Set colSessions = objWMI.ExecQuery _

		  ("Select * from Win32_LogonSession Where LogonType = 2") 


	If colSessions.Count = 0 Then

		'No interactive session found

		'

		Wscript.Echo "No interactive user found"

	Else

		'Interactive session found

		'

		For Each objSession in colSessions 


			Set colList = objWMI.ExecQuery("Associators of " _

			& "{Win32_LogonSession.LogonId=" & objSession.LogonId & "} " _

			& "Where AssocClass=Win32_LoggedOnUser Role=Dependent" ) 


			'Show user info

			'

			For Each objItem in colList

				WScript.Echo "User: " & objItem.Name

				WScript.Echo "FullName: " & objItem.FullName

				WScript.Echo "Domain: " & objItem.Domain

			Next 


			'Show session start time

			'

			Wscript.Echo "Start Time: " & objSession.StartTime

		Next

	End If 


	'——————————————————————


End If


'=======================================================================