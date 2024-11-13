function Client()
    STORE_METHODS = {'FILE','VAR'}
    servers = {}
    function FindServers(protocol, hostname)
    
        local servers = rednet.lookup(protocol, hostname)
        table.insert(servers, 0, hostname)
        print("found servers" .. servers)
    end


    function SendRequest(KEY, SPR, OPR, DATA, STORE_METHOD)

        if type(DATA) ~= "string" then 
            error("DATA must be of type STRING", 0)
        end

        -- Check if STORE_METHOD is valid (must be in STORE_METHODS)
        local isValidMethod = false
        for _, method in ipairs(STORE_METHODS) do
            if STORE_METHOD == method then
                isValidMethod = true
                break
            end
        end

        if not isValidMethod then
            error("INVALID STORAGE METHOD", 0)
        end

        -- Handle the logic for KEY, SPR, OPR as per your original conditions
        if SPR then
            SPR = SPR
            OPR = nil
        elseif KEY == nil or SPR == nil then
            OPR = OPR
        end
        -- "; OPR " .. OPR ..
        if OPR == nil then
            request = "KEY " .. KEY .. "; SPR " .. SPR .. "; DATA " .. DATA .. "; STORE " .. STORE_METHOD .. "; END;"   
        elseif SPR == nil then
            request = "KEY " .. nil .. "; OPR " .. OPR .. "; DATA " .. DATA .. "; STORE " .. STORE_METHOD .. "; END;"  
            
        end
    end
end