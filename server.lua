
keys = {"keyA","keyB"}

function Server()
    local modem = peripheral.find('modem') or error("could not find modem", 0)
    local serverID = os.getComputerID()
    local drive = peripheral.find('drive')
    local whitelist = {}

    function SPR()
        function STRT()
            rednet.open(modem)
            rednet.host("Server","Server " .. serverID)
            rednet.broadcast("Server" .. serverID .. " is online!")
        end
        function SHUT()
            rednet.broadcast("Server" .. serverID .. " powering down...")
            rednet.unhost("Server","Server " .. serverID)
            rednet.close(modem)
        end
        function WLST_ADD(computerIDs)
            for _, id in ipairs(computerIDs) do
              table.insert(whitelist, id)
            end
          end
          function WLST_RMV(computerIDs)
            for _, id in ipairs(computerIDs) do
              for i, existingID in ipairs(whitelist) do
                if existingID == id then
                  table.remove(whitelist, i)
                  break
                end
              end
            end
        end
          function WLST_SHO()
            for _, id in ipairs(whitelist) do
              print(id)
            end
          end
        function MDMP()
            for variable,value in pairs(_G) do
                print("Global key", variable, "value", value)
            end
        end
        function DDMP()
            if drive.isDiskPresent() then
                print(drive.getMountPath())
            end
            
        end
        function FDMP()
        end
        function CKEY()
        end
        function DKEY()
        end
        function RDIR()
        end
        function RFLE()
        end
        function SVAR()
        end
        function SFLE()
        end
        function ECHO()
        end
        function STR()
        end
        function LISN()
        end
        function BLCK()
        end
        
    end

    function OPR()
        function ECHO()
        end
        
    end
end

