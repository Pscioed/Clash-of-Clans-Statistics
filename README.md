# Clash-of-Clans-Statistics

## Installation

https://www.microsoft.com/en-us/sql-server/sql-server-downloads  
https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15  
Using Sql Server Configuration Manager:  
&nbsp;&nbsp;&nbsp;&nbsp;SQL Server Network Configuration > Protocols for SQLEXPRESS > TCP/IP  
&nbsp;&nbsp;&nbsp;&nbsp;Protocol > Enabled > Yes  
&nbsp;&nbsp;&nbsp;&nbsp;IP Addresses > IPAll > TCP Dynamic Ports > ""  
&nbsp;&nbsp;&nbsp;&nbsp;IP Addresses > IPAll > TCP Port > 1433  
Start the service "SQL Server Browser"  
Create a database in SSMS  
Execute sql scripts on the database  
Create a user for node > db_datareader and db_datawriter  
Create a user for grafana > db_datareader  

https://nodejs.org/en/download/  
npm install  
Create .env file > API_KEY, CLAN_TAG, SQL_CONNECTION_STRING  
Task Scheduler  
&nbsp;&nbsp;&nbsp;&nbsp;Create basic task  
&nbsp;&nbsp;&nbsp;&nbsp;Daily  
&nbsp;&nbsp;&nbsp;&nbsp;Midnight  
&nbsp;&nbsp;&nbsp;&nbsp;Start a program  
&nbsp;&nbsp;&nbsp;&nbsp;"C:\Program Files\nodejs\node.exe", main.js, C:\<path>\Clash-of-Clans-Statistics  

https://grafana.com/grafana/download  
Create datasource in Grafana > localhost\sqlexpress  
Install plugin Scatter  
Import dashboard from clan_statistics.json  
Create a user with Viewer permission  
Set up port forwarding  
