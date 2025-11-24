#event_simpleName=ITQueryResult | lower("@rawstring", as=@rawstring) | lower("execution_id", as=execution_id) | upper("hostname", as=hostname)
// --------------------------------------------------Modify as per the string you're searching for----------------------------------------------------------

| @rawstring=* hostname=* execution_id=*

// --------------------------------------------------Modify as per the string you're searching for----------------------------------------------------------
|formatTime(format="%d %B %Y, %H:%M:%S", as="JobPacificTime", field="@timestamp", timezone="America/Los_Angeles")
|formatTime(format="%d %B %Y, %H:%M:%S", as="PacificTime", field="result.mtime", timezone="America/Los_Angeles")
|sort(field=[sequence_id],type=[number],order=desc,limit=max)
| groupBy([aid], function=(collect([PacificTime, hostname, product_type_desc, result.data, sequence_id, executable_type, task_type, result.type, result.path, result.key, query, domain, ou, execution_id, JobPacificTime])), limit=max)
|sort(field=[hostname],type=[string],order=asc,limit=max)
| table([PacificTime, hostname, product_type_desc, result.data, sequence_id, executable_type, task_type, result.type, result.key, domain, ou, execution_id, JobPacificTime, query, result.path, aid], limit=max)
| rename("hostname", as="HostName")
| rename("product_type_desc", as="ProductType")
| rename("result.data", as="ResultData")
| rename("sequence_id", as="SequenceID")
| rename("executable_type", as="ExecutableType")
| rename("task_type", as="TaskType")
| rename("result.type", as="ResultType")
| rename("result.path", as="ResultPath")
| rename("result.key", as="ResultKey")
| rename("query", as="Query")
| rename("domain", as="Domain")
| rename("ou", as="OU")
| rename("execution_id", as="JobID")
