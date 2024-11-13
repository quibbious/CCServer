# Clients

// Clients can send and recieve data, but only to Servers.
// When sending data with an operational request [OPR] string attached, the [OPR] string acts to tell the server WHAT to do with the request.
// Clients can store data onto Servers (whether it be onto variables or files)
// Client can also command Servers using special request strings [SPR] (keys) that allow the usage of admin functions.
// Clients do not hold a list of [SPR]s, and must obtain them from a Server or an Administrator of Servers. 


## Request Structure:

REQUEST = KEY; SPR/OPR; DATA; STORE_METHOD; END
KEY: 
SPR: Special Operation Request OR OPR: Operation Request
VLD: Server-used 'valid key' response // do not use if you are client, will result in error!
DATA: Data to be sent
STORE_METHOD: disk path/file name
END: Ends the request
## Operational Functions(OPR): 

`
echo(msg: str) ECHO
`

## Special Request Functions:
`
shutdown() SHUT

startup() STRT

whitelist_add(computers: list) WLST_ADD

whitelist_remove(computers: list) WLST_RMV

mem_dump(key: str, variables: list) -> returns data in vars MDMP

disk_dump(key: str, disks: list) -> returns file names in disk(s) DDMP

file_dump(key: str, files: list) FDMP
create_key(key: str) CKEY

delete_key(key:  str) DKEY

remove_dir(path: str) RDIR

remove_file(path: str, file_name: str) RFLE

save_to_variable(variable_name: int (must be global)) SVAR

save_to_file(file_name: str, path: str) SFLE // if not file create file else store in the path as .txt or other format


listen(echo: bool, port: int, time_duration: int) LISN
`

## Example Requests:
In this example, the server key is '398583aKLmP'


Client: 'KEY 398583aKLmP; SPR shutdown; OPR nil;  DATA "data12345"; STORE DISK "/home/data.txt"; END;'

Server: 'KEY VLD; SPR VLD; TFR "/home/data.txt" true; END;'

