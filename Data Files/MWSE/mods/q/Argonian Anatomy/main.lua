
local config = require("q.Argonian Anatomy.config")
local util = require("q.Argonian Anatomy.util")

-- This function returns references to all actors in active cells, and optionally the Player reference.
-- A filter parameter can be passed (optional). Filter is a table with tes3.objectType.* constants. If no filter is passed,
-- { tes3.objectType.npc } is used as a filter.
---@param includePlayer boolean
---@param filter number|number[]|nil
---@return tes3reference[]
local function actorsInActiveCells(includePlayer, filter )
    includePlayer = includePlayer or false
    filter = filter or { tes3.objectType.npc }

    return coroutine.wrap(function() ---@diagnostic disable-line
        for _, cell in pairs(tes3.getActiveCells()) do
            for reference in cell:iterateReferences(filter) do ---@diagnostic disable-line
                coroutine.yield(reference)
            end
        end
        if includePlayer then
            coroutine.yield(tes3.player)
        end
    end)
end



local function checkWerewolf()
	if tes3.mobilePlayer.werewolf then
		util.removeSkeleton(tes3.player)
	end

	event.unregister(tes3.event.simulate, checkWerewolf)
	event.register()
end



local function processNPCs()
    for reference in actorsInActiveCells(false, { tes3.objectType.npc }) do
		if not reference.mobile.werewolf then
			loadSkeleton(reference)
		end
    end
end

event.register(tes3.event.initialized, function ()
    event.register(tes3.event.loaded, function ()
		if not tes3.mobilePlayer.werewolf then
			loadSkeleton(tes3.player)
		end
    end)
    event.register(tes3.event.cellChanged, processNPCs)
end)

event.register(tes3.event.modConfigReady, function()
	dofile("q.Argonian Anatomy.mcm")
end)