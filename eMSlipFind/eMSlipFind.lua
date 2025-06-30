_addon.name = 'eMSlipFind'
_addon.version = '1.0'
_addon.author = 'evilmaniac (bz)'
_addon.commands = {'sf', 'slipfind'}

res   = require 'resources'
slips = require 'slips'

name_index = {}
language = windower.ffxi.get_info().language:lower()

local w = windower
local _storages = {
	'inventory', 'storage',
	'safe', 'safe2',
	'locker','satchel',
	'sack', 'case',
	'wardrobe','wardrobe2',
	'wardrobe3','wardrobe4',
	'wardrobe5','wardrobe6',
	'wardrobe7','wardrobe8'
}


windower.register_event('addon command',
	function (...)
		local command = table.concat({...},' ')
		if not command then return end

		local storages = {}
		local count = 0

		if has_value(command, _storages) == true then table.insert(storages, command)  end
		w.add_to_chat(4, command .. ':')

        local items = windower.ffxi.get_items()
        for _, storage in ipairs(storages) do
            for _, item in ipairs(items[storage]) do
                local slip_number = slips.get_slip_number_by_id(slips.get_slip_id_by_item_id(item.id))
                if item ~= nil and item.id > 0 and slip_number ~= nil then
                	count = count + 1
                    w.add_to_chat(4, res.items[item.id].en .. ' inside [[ ' .. storage .. ' ]] can be added to Slip # [[ ' .. slip_number .. ' ]]')
                end
            end
        end

        w.add_to_chat(4, 'Total: ' .. count)

	end)

function has_value(s, t) 
	for _, v in ipairs(t) do
		if v == s then return true end
	end
end