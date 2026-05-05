#Vendor=crowdstrike
| match(file="GenAIKeyword.csv", column="AIFileKeywordMatch", field=FileName, mode=glob, strict=true, include=[AIFileKeywordMatch])
| groupBy([aid, FileName], function=([selectFromMax(field="@timestamp", include=[@timestamp, #event_simpleName, UserName, ComputerName, FilePath])]), limit=max)
| sort(field=@timestamp, order=desc, limit=max)
|formatTime(format="%d %B %Y, %H:%M:%S", as="EasternTime", field="@timestamp", timezone="America/Los_Angeles")
| table([PacificTime, "#event_simpleName", UserName, ComputerName, FileName, FilePath, CommandLine, aid, aip])
