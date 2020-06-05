-- [ ���������� ] --------------------------------------------------------------------#
script_name         = 'AutoBug'          -- �������� �������.                         |
script_desc         = '{FFFFD7}�������{9999FF} [LSHIFT] + [W]{FFFFD7} ���� �� ����/����{7E994C}.' -- �������� �������. |
script_version      = 2                  -- ���������� ����� �������.                 |
script_version_text = "2.0"              -- ������ �������.                           |
script_author       = 'Vl4dik'           -- ����� �������.                            |
author_url          = 'vk.com/vl4dik'    -- VK ������.                                |
--------------------------------------------------------------------------------------#

-- [ ����������� ��������� � �������� ] ------------------#
require "lib.moonloader" -- ����������� ����������.    -- |
local inicfg   = require 'inicfg'                      -- |
local dlstatus = require('moonloader').download_status -- |
-- [ ��������� ] -----------------------------------------#
encoding = require 'encoding'                          -- |
encoding.default = 'CP1251'                            -- |
u8 = encoding.UTF8                                     -- |
-- [ ����� ] ---------------------------------------------#
local color_script = '{D592D8}' -- ����������.            |
local color_text   = '{FFFFD7}' -- �������.               |
local color_true   = '{7E994C}' -- �������.               |
local color_error  = '{D64530}' -- �������.               |
local color_moon   = '{9999FF}' -- �������.               |
----------------------------------------------------------#

-- [ ���������� ] --
if not doesDirectoryExist(getWorkingDirectory() .. "/config/" .. "Scripts by " .. script_author .. "/" .. script_name .. " v" .. script_version_text) then
	createDirectory(getWorkingDirectory() .. "/config/" .. "Scripts by " .. script_author .. "/[" .. script_name .. "] - v" .. script_version_text)
end

-- [ ������ ] --
local ini = inicfg.load(nil, "Scripts by " .. script_author .. "/[" .. script_name .. "] - v" .. script_version_text .. "/settings.ini")
if ini == nil or ini["settings"]["script_version"] == nil or ini["settings"]["script_version"] ~= script_version then
	ini = {
		settings = {
			script_version = script_version,
			auto_update = true,
			msg_update = true
		}
	}
	inicfg.save(ini, "Scripts by " .. script_author .. "/[" .. script_name .. "] - v" .. script_version_text .. "/settings.ini")
	ini = inicfg.load(nil, "Scripts by " .. script_author .. "/[" .. script_name .. "] - v" .. script_version_text .. "/settings.ini")
end

-- [ �������������� ] -------------------------------------------------------------------------------------------------------------------------------------------------#                                                                                                           -- |
local update_url = "https://raw.githubusercontent.com/VI4dik/" .. script_name .. "/master/update.ini"                                                               -- |
local update_path = getWorkingDirectory() .. "/config/" .. "Scripts by " .. script_author .. "/[" .. script_name .. "] - v" .. script_version_text .. "/update.ini" -- |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
local script_url = "https://github.com/VI4dik/" .. script_name .. "/blob/master/" .. script_name .. ".lua?raw=true"                                                 -- |
local script_path = thisScript().path                                                                                                                               -- |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
update_state = false                                                                                                                                                -- |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------#

bike = {[481] = true, [509] = true, [510] = true}
moto = {[448] = true, [461] = true, [462] = true, [463] = true, [468] = true, [471] = true, [521] = true, [522] = true, [523] = true, [581] = true, [586] = true}

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

	sampRegisterChatCommand("update", cmd_update)
	
	downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
			
            if tonumber(updateIni.info.version) == script_version then
				sampAddChatMessage("{D592D8}[" .. script_name .. "]:{7E994C} �������{FFFFD7} �������{7E994C}.{FFFFD7} ������{7E994C}: " .. color_script .. script_version_text .. "{FFFFD7} �����{7E994C}: {D592D8}" .. script_author, -1)
				sampAddChatMessage("{D592D8}[" .. script_name .. "]: " .. script_desc .. "{FFFFD7} �� ������{7E994C}: {D592D8}" .. author_url, -1)
			elseif tonumber(updateIni.info.version) > script_version then
				sampAddChatMessage("{D592D8}[" .. script_name .. "]:{7E994C} �������{FFFFD7} �������{7E994C}.{FFFFD7} ������{7E994C}: " .. color_error .. script_version_text .. "{FFFFD7} �����{7E994C}: {D592D8}" .. script_author, -1)
				sampAddChatMessage("{D592D8}[" .. script_name .. "]: " .. script_desc .. "{FFFFD7} �� ������{7E994C}: {D592D8}" .. author_url, -1)
				update_state = true
			end
			os.remove(update_path)
			--[[if ini["settings"]["auto_update"] and tonumber(updateIni.info.version) > script_version then
				if ini["settings"]["msg_update"] then
					sampAddChatMessage("{D592D8}[" .. script_name .. "]:{FFFFD7} �����{7E994C} ����� ����������{FFFFD7} ������� �� ��������� ������{7E994C} - " .. updateIni.info.version_text, -1)
					sampAddChatMessage("{D592D8}[" .. script_name .. "]:{FFFFD7} ������� ���������� �� ����� ������{7E994C}...", -1)
					sampAddChatMessage("{D592D8}[" .. script_name .. "]:{FFFFD7} �������� ���������� ���������{7E994C} �������.", -1)
					update_state = true
				end
			elseif not ini["settings"]["auto_update"] then
				if ini["settings"]["msg_update"] then
					sampAddChatMessage("{D592D8}[" .. script_name .. "]:{FFFFD7} � ��� ��������� �������������� �������{7E994C}.{FFFFD7} �� �� ��������� ����������{7E994C}.", -1)
					sampAddChatMessage("{D592D8}[" .. script_name .. "]:{FFFFD7} �����{7E994C} ����� ����������{FFFFD7} ������� �� ��������� ������{7E994C} - " .. updateIni.info.version_text, -1)
					sampAddChatMessage("{D592D8}[" .. script_name .. "]:{FFFFD7} �� ������ ������ �� ������{D64530} ����������{FFFFD7} ������ ������� ������{D64530} - " .. script_version_text, -1)
					update_state = true
				end
			end]]
            
        end
    end)
	
while true do
	wait(0)
		
		if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("������ ������� ��������!", -1)
                    thisScript():reload()
                end
            end)
            break
        end
		
		if isCharOnAnyBike(playerPed) and isKeyCheckAvailable() and isKeyDown(0xA0) then -- onBike&onMoto SpeedUP [LSHIFT]
			if bike[getCarModel(storeCarCharIsInNoSave(playerPed))] then
				setGameKeyState(16, 255)
				wait(10)
				setGameKeyState(16, 0)
			elseif moto[getCarModel(storeCarCharIsInNoSave(playerPed))] then
				setGameKeyState(1, -128)
				wait(10)
				setGameKeyState(1, 0)
			end
		end
		
		--[[if isCharOnFoot(playerPed) and isKeyDown(0x32) and isKeyCheckAvailable() then -- onFoot&inWater SpeedUP [1]
			setGameKeyState(16, 256)
			wait(10)
			setGameKeyState(16, 0)
		elseif isCharInWater(playerPed) and isKeyDown(0x32) and isKeyCheckAvailable() then
			setGameKeyState(16, 256)
			wait(10)
			setGameKeyState(16, 0)
		end]]
	end
end

function isKeyCheckAvailable()
	if not isSampLoaded() then
		return true
	end
	if not isSampfuncsLoaded() then
		return not sampIsChatInputActive() and not sampIsDialogActive()
	end
	return not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive()
end

function cmd_update(arg)
    sampShowDialog(1000, "�������������� v" .. script_version_text, "{FFFFFF}��� ���� �� ����������\n{FFF000}����� ������", "�������", "", 0)
end