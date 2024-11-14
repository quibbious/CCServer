-- Server.lua

-- SPR Class (Special Request Processor)
local SPR = {}
SPR.__index = SPR

-- SPR Constructor
function SPR:new(modem, serverID, drive)
    local instance = setmetatable({}, SPR)
    instance.modem = modem
    instance.serverID = serverID
    instance.drive = drive
    instance.Blacklist = {}
    return instance
end

-- Method: Start Server
function SPR:STRT()
    self.modem.open()
    self.modem.host("Server", "Server")
    self.modem.broadcast("Server is online!")
    print("Server started.")
end

-- Method: Shutdown Server
function SPR:SHUT()
    self.modem.broadcast("Server powering down...")
    self.modem.unhost("Server", "Server")
    self.modem.close()
    print("Server shut down.")
end

-- Method: Add to Blacklist
function SPR:BLST_ADD(computerIDs)
    for _, id in ipairs(computerIDs) do
        table.insert(self.Blacklist, id)
        print("Added to Blacklist:", id)
    end
end

-- Method: Remove from Blacklist
function SPR:BLST_RMV(computerIDs)
    for _, id in ipairs(computerIDs) do
        for i, existingID in ipairs(self.Blacklist) do
            if existingID == id then
                table.remove(self.Blacklist, i)
                print("Removed from Blacklist:", id)
                break
            end
        end
    end
end

-- Method: Show Blacklist
function SPR:BLST_SHO()
    print("Blacklist:")
    for _, id in ipairs(self.Blacklist) do
        print(id)
    end
end

-- Method: Dump Globals
function SPR:MDMP()
    print("Dumping global variables:")
    for variable, value in pairs(_G) do
        print("Global key:", variable, "value:", value)
    end
end

-- Method: Dump Disk Data
function SPR:DDMP()
    if self.drive and self.drive.isDiskPresent() then
        print("Drive mount path:", self.drive.getMountPath())
    else
        print("No disk present.")
    end
end

-- Method: Listen on Modem
function SPR:LISN(time, echo)
    if type(echo) ~= "boolean" then
        error("echo must be a boolean", 0)
    end

    if echo then
        local startTime = os.clock()
        print("Listening with echo for " .. time .. " seconds.")
        while os.clock() - startTime < time do
            local id, message = self.modem.receive(1)
            if id then
                self.modem.send(id, "ECHO: " .. message)
                print("Echoed message to " .. id .. ": " .. message)
            end
        end
    else
        print("Listening without echo for " .. time .. " seconds.")
        local id, message = self.modem.receive(time)
        if id then
            print(id .. " sent message: " .. message)
        else
            print("No messages received.")
        end
    end
end

-- Server Class
local Server = {}
Server.__index = Server

-- Server Constructor
function Server:new()
    local modem = peripheral.find("modem")
    if not modem then
        error("Could not find modem peripheral.", 0)
    end

    local drive = peripheral.find("drive") or nil
    local serverID = os.getComputerID()
    local modem = peripheral.find('modem') or error("could not find modem",0)
    local instance = setmetatable({}, Server)
    instance.keys = { "keyA", "keyB" }
    instance.modem = modem
    instance.drive = drive
    instance.serverID = serverID
    instance.spr = nil  -- Will hold the SPR instance
    return instance
end

-- Method: Decode Request
function Server:DecodeRequest(message)
    local parts = {}
    for part in string.gmatch(message, "[^;]+") do
        table.insert(parts, part:match("^%s*(.-)%s*$"))
    end
    return parts
end

-- Method: Authorize Key
function Server:authorize(key)
    for _, validKey in ipairs(self.keys) do
        if key == validKey then
            return true
        end
    end
    return false
end

-- Method: Handle Command
function Server:handleCommand(parts)
    local KEY = parts[1]
    local OPERATION = parts[2]
    local DATA = parts[3]
    local STORE_METHOD = parts[4]
    local END = parts[5]  -- Not used in current implementation

    if not self:authorize(KEY) then
        print("Unauthorized access attempt detected with key:", KEY)
        return
    end

    if not self.spr then
        self.spr = SPR:new(self.modem, self.serverID, self.drive)
    end

    -- Check if the command exists in SPR
    if self.spr[OPERATION] then
        -- Handle different command data
        if OPERATION == "WLST_ADD" or OPERATION == "WLST_RMV" then
            -- Assuming data is a comma-separated list of IDs
            local computerIDs = {}
            for id in string.gmatch(DATA, "[^,]+") do
                table.insert(computerIDs, id)
            end
            self.spr[OPERATION](self.spr, computerIDs)
        elseif OPERATION == "LISN" then
            -- Assuming data contains time and echo separated by comma
            local time, echoStr = DATA:match("([^,]+),([^,]+)")
            local timeNum = tonumber(time)
            local echo = echoStr == "true"
            if timeNum then
                self.spr:LISN(timeNum, echo)
            else
                print("Invalid LISN parameters.")
            end
        else
            self.spr[OPERATION](self.spr)
        end
    else
        print("Invalid command received:", OPERATION)
    end
end

-- Main Program Execution
local function main()
    -- Initialize Server
    local server = Server:new()
    print("Server initialized with ID:", server.serverID)

    -- Starting the server manually (optional)
    server.spr = SPR:new(server.modem, server.serverID, server.drive)
    server.spr:STRT()


    while true do
        print("Waiting for messages...")

        local id, message = modem.receive()

        local parts = server:DecodeRequest(message)
        

        server:handleCommand(parts)
    end
end

-- Run the main function
main()
