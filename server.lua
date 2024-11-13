
keys = {"keyA","keyB"}

function Server()
    local modem = peripheral.find('modem') or error("could not find modem", 0)
    local serverID = os.getComputerID()
    local drive = peripheral.find('drive')
    local whitelist = {}

    function SPR()
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
        function LISN() -- listen on port for x time, echo boolean
        end
        function BLCK() -- block computerID(s)
        end
        
    end

    function OPR() -- Operational Functions
        function ECHO() -- ECHO DATA to CLIENT
        end
        
    end
end

