defineTable(query={#Vendor=crowdstrike #event_simpleName=MotwWritten | SourceURL := coalesce(HostUrl, ReferrerUrl)
| match(file="GenAIKeywordsForDownload.csv", column="AIDomainName1", field=SourceURL, mode=glob, strict=true, include=["AIProductName", aid])}, include=[aid, AIProductName, ContextProcessId], name="downloaded_files") | #event_simpleName=ProcessRollup2 | match(file="downloaded_files", field=[aid, TargetProcessId], column=[aid, ContextProcessId], include=[AIProductName]) | upper("UserName", as=UserName)
| groupBy([UserName, AIProductName], limit=max)
| sort(field=[_count, UserName], order=desc, limit=15)
