_addon.name = 'eMObserver'
_addon.version = '1.0'
_addon.author = 'evilmaniac (bz)'
_addon.commands = {'eo', 'emo'}

res   = require 'resources'
texts = require 'texts'

require 'actions'

local w = windower
local p = player

local watch_list = {
	['Degei'] = {
		['spells'] = {},
		['abilities'] = {},
		['tp_moves'] = {
			-- Flaming Kick
			[3390] = 'Use Water',
			[4324] = 'Use Water',
			[4356] = 'Use Water',
			-- Flash Flood
			[3392] = 'Use Thunder',
			[4326] = 'Use Thunder',
			[4358] = 'Use Thunder',
			-- Icy Grasp
			[3391] = 'Use Fire',
			[4325] = 'Use Fire',
			[4357] = 'Use Fire',
			-- Eroding Flesh
			[3393] = 'Use Wind',
			[4327] = 'Use Wind',
			[4359] = 'Use Wind',
			-- Fulminous Smash
			[3389] = 'Use Earth',
			[4323] = 'Use Earth',
			[4355] = 'Use Earth',
		}
	},
	['Aita'] = {
		['spells'] = {},
		['abilities'] = {},
		['tp_moves'] = {
			-- Flaming Kick
			[3390] = 'Use Water',
			[4324] = 'Use Water',
			[4356] = 'Use Water',
			-- Flash Flood
			[3392] = 'Use Thunder',
			[4326] = 'Use Thunder',
			[4358] = 'Use Thunder',
			-- Icy Grasp
			[3391] = 'Use Fire',
			[4325] = 'Use Fire',
			[4357] = 'Use Fire',
			-- Eroding Flesh
			[3393] = 'Use Wind',
			[4327] = 'Use Wind',
			[4359] = 'Use Wind',
			-- Fulminous Smash
			[3389] = 'Use Earth',
			[4323] = 'Use Earth',
			[4355] = 'Use Earth',
		}
	},
	['Leshonn'] = {
		['spells'] = {},
		['abilities'] = {},
		['tp_moves'] = {
			-- Undulating Shockwave
			[3368] = 'Use Ice',
			[4310] = 'Use Ice',
			-- Shrieking Gale
			[2726] = 'Use Stone',
			[3367] = 'Use Stone',
			[4036] = 'Use Stone',
			[4309] = 'Use Stone',
		}
	},
	['Gartell'] = {
		['spells'] = {},
		['abilities'] = {},
		['tp_moves'] = {
			-- Undulating Shockwave
			[3368] = 'Use Ice',
			[4310] = 'Use Ice',
			-- Shrieking Gale
			[2726] = 'Use Stone',
			[3367] = 'Use Stone',
			[4036] = 'Use Stone',
			[4309] = 'Use Stone',
		}
	},
	['Aminon'] = {
		['spells'] = {},
		['abilities'] = {},
		['tp_moves'] = {
			-- Demonfire
			[3402] = 'Use Fire',
			[4367] = 'Use Fire',
			-- Torrential Pain
			[3407] = 'Use Water',
			[4372] = 'Use Water',
			-- Frozen Blood
			[3403] = 'Use Ice',
			[4368] = 'Use Ice',
			-- Ensepulcher
			[3405] = 'Use Earth',
			[4370] = 'Use Earth',
			-- Ceaseless Surge
			[3406] = 'Use Thunder',
			[4371] = 'Use Thunder',
			-- Blast of Reticence
			[3404] = 'Use Wind',
			[4369] = 'Use Wind',
			-- Bane of Tartarus
			[3410] = 'Use Sleep',
			[4375] = 'Use Sleep',
		}
	},
}

name_index = {}
language = w.ffxi.get_info().language:lower()

local win_equip = nil
local win_equip_init =
function()
        window_config = {
        pos = { x = 256, y = 256 },
        padding = 8,
        text = {
            font = 'Arial',
            size = 12,
            stroke = {
                width = 2,
                alpha = 255
            },
            Fonts = { 'Arial' }
        },
        bg = { alpha=0 },
        flags = {}
    }

    return texts.new(window_config)
end

win_equip_update =
function(actor, action, message)
	local s = actor .. ' \\cs(255,150,100)→\\cr ' .. action
	s = message and s .. ' \\cs(255,150,100)→\\cr ' .. message or s

    win_equip:text(s)
    win_equip:show()
end

win_equip = win_equip_init()
win_equip_update('Observer', 'Waiting...')

windower.register_event('action', function(a)
	--[[
		https://github.com/Windower/Lua/wiki/Action-Event
		Categories:
		    01: Melee attack
		    02: Finish ranged attack
		    03: Finish weapon skill
		    	Category for the execution of player WSs or direct damage abilities like Jump
		    04: Finish spell casting
		    05: Finish item use
		    06: Use job ability
		    07: Begin weapon skill or TP move
		    	Category for the initiation of weapon skill or monster TP move.
		    08: Begin spell casting or interrupt casting
		    09: Begin item use or interrupt usage
		    10: Unknown -- Probably was intended to be the "readies" messages for JAs, which was unnecessary because they are instant.
		    11: Finish TP move
		    	Category for the completion of monster weapon skills (TP moves)
		    12: Begin ranged attack
		    13: Pet completes ability/WS
		    14: Unblinkable job ability
		    15: Some RUN job abilities
	--]]

	local actor = w.ffxi.get_mob_by_id(a.actor_id)
	local category = a.category
	local param = a.param
	local targets = a.targets

	if actor and watch_list[actor.name] ~= nil then
		if actor.is_npc and category == 7 and watch_list[actor.name]['tp_moves'][targets[1].actions[1].param] then
			win_equip_update(actor.name, res.monster_abilities[targets[1].actions[1].param].en,
				watch_list[actor.name]['tp_moves'][targets[1].actions[1].param])
		elseif category == 8 and watch_list[actor.name]['spells'][targets[1].actions[1].param] then
			win_equip_update(actor.name, res.spells[targets[1].actions[1].param].en,
				watch_list[actor.name]['spells'][targets[1].actions[1].param])
		end
	end
end)