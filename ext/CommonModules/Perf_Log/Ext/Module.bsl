Procedure Perf_SendDebugPart(Val ErrorText) Export
	
	WriteLogEvent("Debug perfom", EventLogLevel.Error, , , ErrorText);

EndProcedure
