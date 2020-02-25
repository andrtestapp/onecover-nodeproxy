
&Before("BeforeStart")
Procedure Perf_BeforeStart(Cancel)
	Perf_SendDebug(True);
	AttachIdleHandler("RestartPerf", 60, True);
EndProcedure

Procedure Perf_SendDebug(isStart)
	
	BaseName = "DefAlias";
	
	HTTPConnection = New HTTPConnection("localhost", 3000, , , , 3);
	
	Headers = New Map();
	Headers.Insert("accept-charset", "utf-8");
	Headers.Insert("content-type", "application/xml");
	
	HTTPRequest = New HTTPRequest("/e1crdbg/rdbg?cmd=setMeasureMode", Headers);
	Template = "<?xml version=""1.0"" encoding=""UTF-8""?>
	|<request xmlns=""http://v8.1c.ru/8.3/debugger/debugBaseData"" 
	|xmlns:cfg=""http://v8.1c.ru/8.1/data/enterprise/current-config"" 
	|xmlns:debugRDBGRequestResponse=""http://v8.1c.ru/8.3/debugger/debugRDBGRequestResponse"" 
	|xmlns:debugRTEFilter=""http://v8.1c.ru/8.3/debugger/debugRTEFilter"" 
	|xmlns:v8=""http://v8.1c.ru/8.1/data/core"" 
	|xmlns:xs=""http://www.w3.org/2001/XMLSchema"" 
	|xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">
	|<debugRDBGRequestResponse:infoBaseAlias>" + BaseName + "</debugRDBGRequestResponse:infoBaseAlias>
	|<debugRDBGRequestResponse:idOfDebuggerUI>a99bb725-e768-4136-998c-4d33550f6c5a</debugRDBGRequestResponse:idOfDebuggerUI>
	|#ID#
	|</request>";
	If isStart Then		
		Body = StrReplace(Template, "#ID#", "<debugRDBGRequestResponse:measureModeSeanceID>7606ec99-923f-446a-bf5e-2f44c6fd2823</debugRDBGRequestResponse:measureModeSeanceID>");
	Else
		Body = StrReplace(Template, "#ID#", "");
	EndIf;
	
	HTTPRequest.SetBodyFromString(Body);
	Try
		Answer = HTTPConnection.Post(HTTPRequest);
		If Answer.StatusCode <> 200 Then
			Perf_Log.Perf_SendDebugPart(Answer.GetBodyAsString());
		EndIf;
	Except
		Perf_Log.Perf_SendDebugPart(DetailErrorDescription(ErrorInfo())) ;
	EndTry;
	If Not isStart Then
		AttachIdleHandler("RestartPerf", 60, True);
	EndIf;
EndProcedure


Procedure RestartPerf() Export
	Perf_SendDebug(False);
	Perf_SendDebug(True);
EndProcedure

&After("OnExit")
Procedure Perf_OnExit()
	Perf_SendDebug(False);
EndProcedure
