function Server()
    local keys = {"keyA", "keyB"}
    local modem = peripheral.find('modem') or error("Could not find modem", 0)
    local serverID = os.getComputerID()
    local drive = peripheral.find('drive')
    local whitelist = {}
    local valid_SPRs = {'SHUT', 'STRT', 'WLST_ADD', 'WLST_RMV', 'WLST_SHO', 'MDMP', 'DDMP', 'FDMP', 'CKEY', 'DKEY', 'RDIR', 'RFLE', 'SVAR', 'SFLE', 'LISN'}
    local valid_OPRs = {'ECHO'}
    
    -- Decode request message
    local function DecodeRequest(id, message)
        local clientID = id
        local parts = {}
        for part in string.gmatch(message, '[^;]+') do
            table.insert(parts, part:match("^%s*(.-)%s*$"))
        end
        print(parts)
        return parts
    end

    -- Handle Special Operational Functions (with keys)
    local function SPR(key)
        local authorized = false
        for _, validKey in ipairs(keys) do
            if key == validKey then
                authorized = true
                break
            end
        end

        if not authorized then
            print("Unauthorized access attempt detected.")
            return
        end

        -- Special operational functions
        local function STRT()
            peripheral.find("modem", rednet.open)
            rednet.host("Server", "Server " .. serverID)
            rednet.broadcast("Server " .. serverID .. " is online!")
        end

        local function SHUT()
            rednet.broadcast("Server " .. serverID .. " powering down...")
            rednet.unhost("Server", "Server " .. serverID)
            rednet.close(modem)
        end

        local function WLST_ADD(computerIDs)
            for _, id in ipairs(computerIDs) do
                table.insert(whitelist, id)
            end
        end

        local function WLST_RMV(computerIDs)
            for _, id in ipairs(computerIDs) do
                for i, existingID in ipairs(whitelist) do
                    if existingID == id then
                        table.remove(whitelist, i)
                        break
                    end
                end
            end
        end

        local function WLST_SHO()
            for _, id in ipairs(whitelist) do
                print(id)
            end
        end

        local function MDMP()
            for variable, value in pairs(_G) do
                print("Global key:", variable, "value:", value)
            end
        end

        local function DDMP()
            if drive and drive.isDiskPresent() then
                print(drive.getMountPath())
            end
        end

        local function LISN(time, echo)
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
                local id, message = rednet.receive(time)
                if id then
                    print(id .. " sent message: " .. message)
                end
            end
        end

        -- Return the methods you want to be callable externally
        return {
            STRT = STRT,
            SHUT = SHUT,
            WLST_ADD = WLST_ADD,
            WLST_RMV = WLST_RMV,
            WLST_SHO = WLST_SHO,
            MDMP = MDMP,
            DDMP = DDMP,
            LISN = LISN
        }
    end

    -- Return the method for handling special operations
    return {
        SPR = SPR,
        DecodeRequest = DecodeRequest
    }
end

function runtime()
    -- Instantiate the server instance
    local serverInstance = Server()
    if not serverInstance then
        print("Server instance is nil!")
        return
    end

    -- Test the SPR function with a key
    serverInstance.SPR("keyA")

    -- Access and call STRT (start) method
    local specialFuncs = serverInstance.SPR("keyA")  -- Get the special functions table
    if specialFuncs then
        specialFuncs.STRT()
    else
        print("No special functions available.")
    end

    -- Main loop
    while true do
        print('Waiting for messages...')
        local id, message = rednet.receive()
        if id and message then
            print("Received message from " .. id .. ": " .. message)
            local parts = serverInstance.DecodeRequest(id, message)
        end
    end
end

runtime()