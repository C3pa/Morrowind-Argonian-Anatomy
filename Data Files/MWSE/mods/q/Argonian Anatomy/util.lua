local config = require("q.Argonian Anatomy.config")

local this = {}

---@param reference tes3reference
---@return boolean loaded
---@return boolean loadedForPlayer
function this.loadSkeleton(reference)
    if config[reference.object.race.id:lower()] then

        tes3.loadAnimation{
            reference = reference,
            file = "zilla\\base_animkna.nif"
        }

		if reference == tes3.player then
			return true, true
		end
		return true, false
    end

	return false, false
end

---@param reference tes3reference
---@return boolean removed
function this.removeSkeleton(reference)
    if config[reference.object.race.id:lower()] then

        tes3.loadAnimation{
            reference = reference,
        }
		return true
    end

	return false
end

return this