## 获取节点进程信息

```bat
wmic process where "SessionId!=0" get ProcessId,Caption,SessionId,executablepath,CREATIONDATE /format:csv > E:/c.txt
```

```bat
C:\Users\huanle0610.HL-PC>wmic /NODE:192.168.61.134 /USER:administrator /PASSWORD:Password process where "SessionId!=0" get ProcessId,Caption,SessionId,executablepath,CREATIONDATE /format:csv
```


## 登录者信息

```bat
C:\Users\Administrator>query user /SERVER:192.168.61.134
 USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME
 administrator         console             1  Active       1:13  7/24/2016 11:30AM
 w7                                        2  Disc         1:13  7/24/2016 11:41AM

C:\Users\Administrator>query user
 USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME
>administrator         console             1  Active      none   7/24/2016 12:56PM
```





## 参考
[Useful commands for Windows administrators](http://www.robvanderwoude.com/ntadmincommands.php)