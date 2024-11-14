# Servers

// Servers can send and recieve data, but only in the form of confirmations or ECHO requests.
// When sent data with an operational request[OPR] string attached, the [OPR] string acts to tell the server WHAT to do with the request.
// Servers can also save sent data to variables or files/disks.
// Servers can also be commanded by special request strings [SPR] (keys) that dictate which connections are allowed, and which are denied.
// Servers also hold a list of [SPR]'s that can be used to validate an admin request.


## Request Structure:

REQUEST = SPR; OPR; DATA; STORE_METHOD; END

SPR: Special Operation Request
OPR: Operation Request
VLD: Server-used 'valid key' response
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


CLIENT: 'KEY 12345ABC; SPR nil; OPR ECHO; DATA "HELLO SERVER"; STORE nil; END;'

SERVER: 'KEY VLD; SPR nil; OPR VLD; TFR ERR, NO_METHOD; END;'


