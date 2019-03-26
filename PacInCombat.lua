-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
PacInCombat = {}
 
PacInCombat.name = "PacInCombat"
 
-- Next we create a function that will initialize our addon
function PacInCombat:Initialize()
    self.inCombat = IsUnitInCombat("player")

    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)
end
 
-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function PacInCombat.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == PacInCombat.name then
    PacInCombat:Initialize()
    d("Pacrooti's In Combat Loaded.")
  
  end
end

function PacInCombat.OnPlayerCombatState(event, inCombat)
    -- The ~= operator is "not equal to" in Lua.
    if inCombat ~= PacInCombat.inCombat then
      -- The player's state has changed. Update the stored state...
      PacInCombat.inCombat = inCombat
   
      -- ...and then announce the change.
      if inCombat then
        d("Entering combat.")
      else
        d("Exiting combat.")
      end
   
    end
end

EVENT_MANAGER:RegisterForEvent(PacInCombat.name, EVENT_ADD_ON_LOADED, PacInCombat.OnAddOnLoaded)