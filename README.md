Installation: 
1. insert the 'insert.sql' in your db
2. If you want to use webhooks you can eiter yownload my logger system or implement your own system in the server.lua
3. Add 'ensure DFNZ_GUIDE' to your server.cfg below the depencys


Example script starting order:
 - ensure oxmysql
 - ensure es_extended
 - ensure ox_lib
 - ensure ox_target (optional) --> if you dont want to use it set Config.UseTarget = false
 - ensure DFNZ_LOGGER (optional) --> if you dont want to use it set Config.UseLogger = false
 - ensure DFNZ_GUIDE


Optional scripts download:
 - ox_target: https://github.com/overextended/ox_target/releases
 - DFNZ_LOGGER: https://github.com/dFineZ/DFNZ_LOGGER/tree/main
