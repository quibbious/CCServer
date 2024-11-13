function Client()
    modem = peripheral.find('modem')
    STORE_METHODS = {'FILE','VAR'}
    servers = {}
    computerID = os.getComputerID()
    function FindServers(protocol, hostname)
    
        local servers = modem.lookup(protocol, hostname)
        print("found servers" .. servers)
    end


    function SendRequest(WHO,KEY, SPR, OPR, DATA, STORE_METHOD)

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
            KEY = nil
            SPR = nil
        end
        -- "; OPR " .. OPR ..
        if OPR == nil then
            request = "KEY " .. KEY .. "; SPR " .. SPR .. "; DATA " .. DATA .. "; STORE " .. STORE_METHOD .. "; END;"
            modem.send(computerID, request, WHO)
        elseif SPR == nil then
            request = "KEY " .. nil .. "; OPR " .. OPR .. "; DATA " .. DATA .. "; STORE " .. STORE_METHOD .. "; END;"
            modem.send(computerID, request, WHO)
        end
    end
end

function runtime()
    -- Instantiate the server instance
    local Client = Client()
    if not Client then
        print("Client instance is nil!")
        return
    end
    FindServers("Server",nil)
    

    while true do
        print("WHO: ")
        WHO = io.read()
        print("KEY: ")
        KEY = io.read()
        print("SPR: ")
        SPR = io.read()
        print("OPR: ")
        OPR = io.read()
        print("DATA: ")
        DATA = io.read()
        print("STORE_METHOD: ")
        STORE_METHOD = io.read()

        SendRequest(WHO,KEY,SPR,OPR,DATA,STORE_METHOD)
    end
end
