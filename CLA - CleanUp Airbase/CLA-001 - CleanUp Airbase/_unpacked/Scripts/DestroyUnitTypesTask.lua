--- Set TASK to destroy certain unit types.
-- @classmod DESTROYUNITTYPESTASK

Include.File("DestroyBaseTask")

DESTROYUNITTYPESTASK = {
  ClassName = "DESTROYUNITTYPESTASK",
	GoalVerb = "Destroy",
}

--- Creates a new DESTROYUNITTYPESTASK.
-- @tparam string DestroyGroupType 		String describing the group to be destroyed. f.e. "Radar Installations", "Fleet", "Batallion", "Command Centers".
-- @tparam string DestroyUnitType 		String describing the unit to be destroyed. f.e. "radars", "ships", "tanks", "centers".
-- @tparam table{string,...} DestroyGroupNames 	Table of string containing the group names of which the radars are be destroyed.
-- @tparam string DestroyUnitTypes	 	Table of string containing the type names of the units to achieve mission success.
-- @treturn DESTROYUNITTYPESTASK
function DESTROYUNITTYPESTASK:New( DestroyGroupType, DestroyUnitType, DestroyGroupNames, DestroyUnitTypes )
trace.f(self.ClassName)

	-- Inheritance
	local Child = BASE:Inherit( self, DESTROYBASETASK:New( DestroyGroupType, DestroyUnitType, DestroyGroupNames ) )
	
	if type(DestroyUnitTypes) == 'table' then
		Child.DestroyUnitTypes = DestroyUnitTypes
	else
		Child.DestroyUnitTypes = { DestroyUnitTypes }
	end
	
	Child.Name = 'Destroy Unit Types'
	Child.GoalVerb = "Destroy " .. DestroyGroupType

	--env.info( 'New Types Child = ' .. tostring(Child) )
	--env.info( 'New Types self = ' .. tostring(self) )

	Child.AddEvent( Child, world.event.S_EVENT_DEAD, Child.EventDead )

	return Child
end

--- Report Goal Progress.
-- @tparam 	Group DestroyGroup 		Group structure describing the group to be evaluated.
-- @tparam 	Unit DestroyUnit 		Unit structure describing the Unit to be evaluated.
function DESTROYUNITTYPESTASK:ReportGoalProgress( DestroyGroup, DestroyUnit )
trace.f(self.ClassName)

	local DestroyCount = 0
	for UnitTypeID, UnitType in pairs( self.DestroyUnitTypes ) do
		if DestroyUnit and DestroyUnit:getTypeName() == UnitType then
			if DestroyUnit and DestroyUnit:getLife() <= 1.0 then
				DestroyCount = DestroyCount + 1
			end
		end
	end
	return DestroyCount
end
