-- [ Информация ] --------------------------------------------------------------------#
script_name         = 'AutoBug'          -- Название скрипта.                         |
script_desc         = '{FFFFD7}Зажмите{9999FF} [LSHIFT] + [W]{FFFFD7} сидя на вело/мото{7E994C}.' -- Описание скрипта. |
script_version      = 2                  -- Порядковый номер скрипта.                 |
script_version_text = "2.0"              -- Версия скрипта.                           |
script_author       = 'Vl4dik'           -- Автор скрипта.                            |
author_url          = 'vk.com/vl4dik'    -- VK автора.                                |
--------------------------------------------------------------------------------------#

-- [ Подключение библиотек и плагинов ] ------------------#
require "lib.moonloader" -- Подключение библиотеки.    -- |
local inicfg   = require 'inicfg'                      -- |
local dlstatus = require('moonloader').download_status -- |
-- [ Кодировка ] -----------------------------------------#
encoding = require 'encoding'                          -- |
encoding.default = 'CP1251'                            -- |
u8 = encoding.UTF8                                     -- |
-- [ Цвета ] ---------------------------------------------#
local color_script = '{D592D8}' -- Фиолетовый.            |
local color_text   = '{FFFFD7}' -- Бежевый.               |
local color_true   = '{7E994C}' -- Зеленый.               |
local color_error  = '{D64530}' -- Красный.               |
local color_moon   = '{9999FF}' -- Голубой.               |
----------------------------------------------------------#

-- [ Директория ] --
if not doesDirectoryExist(getWorkingDirectory() .. "/config/" .. "Scripts by " .. script_author .. "/" .. script_name .. " v" .. script_version_text) then
	createDirectory(getWorkingDirectory() .. "/config/" .. "Scripts by " .. script_author .. "/[" .. script_name .. "] - v" .. script_version_text)
end

-- [ Конфиг ] --
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

-- [ Автообновление ] -------------------------------------------------------------------------------------------------------------------------------------------------#                                                                                                           -- |
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
				sampAddChatMessage("{D592D8}[" .. script_name .. "]:{7E994C} Успешно{FFFFD7} запущен{7E994C}.{FFFFD7} Версия{7E994C}: " .. color_script .. script_version_text .. "{FFFFD7} Автор{7E994C}: {D592D8}" .. script_author, -1)
				sampAddChatMessage("{D592D8}[" .. script_name .. "]: " .. script_desc .. "{FFFFD7} ВК автора{7E994C}: {D592D8}" .. author_url, -1)
			elseif tonumber(updateIni.info.version) > script_version then
				sampAddChatMessage("{D592D8}[" .. script_name .. "]:{7E994C} Успешно{FFFFD7} запущен{7E994C}.{FFFFD7} Версия{7E994C}: " .. color_error .. script_version_text .. "{FFFFD7} Автор{7E994C}: {D592D8}" .. script_author, -1)
				sampAddChatMessage("{D592D8}[" .. script_name .. "]: " .. script_desc .. "{FFFFD7} ВК автора{7E994C}: {D592D8}" .. author_url, -1)
				update_state = true
			end
			os.remove(update_path)
			--[[if ini["settings"]["auto_update"] and tonumber(updateIni.info.version) > script_version then
				if ini["settings"]["msg_update"] then
					sampAddChatMessage("{D592D8}[" .. script_name .. "]:{FFFFD7} Вышло{7E994C} НОВОЕ ОБНОВЛЕНИЕ{FFFFD7} скрипта до последней версии{7E994C} - " .. updateIni.info.version_text, -1)
					sampAddChatMessage("{D592D8}[" .. script_name .. "]:{FFFFD7} Пытаюсь обновиться до новой версии{7E994C}...", -1)
					sampAddChatMessage("{D592D8}[" .. script_name .. "]:{FFFFD7} Загрузка обновления завершена{7E994C} успешно.", -1)
					update_state = true
				end
			elseif not ini["settings"]["auto_update"] then
				if ini["settings"]["msg_update"] then
					sampAddChatMessage("{D592D8}[" .. script_name .. "]:{FFFFD7} У Вас выключено автообновление скрипта{7E994C}.{FFFFD7} Вы не получаете обновления{7E994C}.", -1)
					sampAddChatMessage("{D592D8}[" .. script_name .. "]:{FFFFD7} Вышло{7E994C} НОВОЕ ОБНОВЛЕНИЕ{FFFFD7} скрипта до последней версии{7E994C} - " .. updateIni.info.version_text, -1)
					sampAddChatMessage("{D592D8}[" .. script_name .. "]:{FFFFD7} На данный момент вы имеете{D64530} устаревшую{FFFFD7} версию скрипта версии{D64530} - " .. script_version_text, -1)
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
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
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
    sampShowDialog(1000, "Автообновление v" .. script_version_text, "{FFFFFF}Это урок по обновлению\n{FFF000}Новая версия", "Закрыть", "", 0)
end