
keys = {"keyA","keyB"}

function Server()
    
    local modem = peripheral.find('modem') or error("could not find modem", 0)
    local serverID = os.getComputerID()
    local drive = peripheral.find('drive')
    local whitelist = {}
    valid_SPRs = {'SHUT','STRT','WLST_ADD','WLST_RMV','WLST_SHO','MDMP','DDMP','FDMP','CKEY','DKEY','RDIR','RFLE','SVAR','SFLE','LISN'}
    valid_OPRs = {'ECHO'}
    function DecodeRequest(id, message)
        clientID = id
        local parts = {}

        for part in string.gmatch(message, '[^;]+') do
            table.insert(parts, part:match("^%s*(.-)%s*$"))
        end
        
        print(parts)
        return parts
    end

    function ParseRequest(parts)
        
    end

    function RequestIncludes(request)
    end

    function SPR(key) -- Special Operational Functions (key required)
        -- Check if the provided key is valid
        local authorized = false
        for _, validKey in ipairs(keys) do
            if key == validKey then
                authorized = true
                break
            end
        end

        if not authorized then
            print("Unauthorized access attempt from" .. id .."detected. Blocking request.")
            
            return
        end

        function STRT() -- startup
            rednet.open(modem)
            rednet.host("Server","Server " .. serverID)
            rednet.broadcast("Server" .. serverID .. " is online!")
        end
        function SHUT() -- shutdown
            rednet.broadcast("Server" .. serverID .. " powering down...")
            rednet.unhost("Server","Server " .. serverID)
            rednet.close(modem)
        end
        function WLST_ADD(computerIDs) -- whitelist add
            for _, id in ipairs(computerIDs) do
              table.insert(whitelist, id)
            end
          end
          function WLST_RMV(computerIDs) -- whitelist remove
            for _, id in ipairs(computerIDs) do
              for i, existingID in ipairs(whitelist) do
                if existingID == id then
                  table.remove(whitelist, i)
                  break
                end
              end
            end
        end
          function WLST_SHO() -- whitelist show
            for _, id in ipairs(whitelist) do
              print(id)
            end
          end
        function MDMP() -- memory dump
            for variable,value in pairs(_G) do
                print("Global key", variable, "value", value)
            end
        end
        function DDMP() -- disk dump
            if drive.isDiskPresent() then
                print(drive.getMountPath())
            end
            
        end
        function FDMP() -- file dump
        end
        function CKEY() -- create key
        end
        function DKEY() -- delete key
        end
        function RDIR() -- remove directory
        end
        function RFLE() -- remove file
        end
        function SVAR() -- save DATA in variable
        end
        function SFLE() -- save DATA in file
        end
        function LISN(time, echo)
            if type(echo) ~= "boolean" then 
                error("echo must be a boolean", 0)
            end
        
            if echo then
                local startTime = os.clock()
                while os.clock() - startTime < time do
                    local id, message = rednet.receive(1)
                    if id then
                        rednet.send(id, "ECHO: " .. message)
                    end
                end
            else
                id, message = rednet.receive(time)
                if id then
                    print(id .. " sent message: " .. message)
                end
            end
        end        
        function BLCK() -- block computerID(s)
        end
        
    end

    function OPR() -- Operational Functions (no key needed)
        function ECHO() -- ECHO DATA to CLIENT
        end
        
    end
end


function runtime()
    
    local serverInstance = Server()
    print('dbg1')
    serverInstance.SPR("keyA")
    serverInstance.STRT()
    while true do 
        print('dbg2')
        LISN(20,true)
        if os.pullEvent("rednet_message") then 
            id, message = rednet.receive()
            DecodeRequest(id, message)
        end
    end
end
