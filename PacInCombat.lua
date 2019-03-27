-- Required Libraries
local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")

-- Initialize our Namespace Table
PacInCombat = {}
 
PacInCombat.name = "PacInCombat"
PacInCombat.version = "1.0.0"
 
-- Initialize our Variables
function PacInCombat:Initialize()
  PacInCombat.CreateSettingsWindow()
  PacInCombat.savedVariables = ZO_SavedVars:NewAccountWide("PacInCombatSavedVariables", 1, nil, {})

  enableDebug = PacInCombat.savedVariables.enableDebug

  self.inCombat = IsUnitInCombat("player")

  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)
end
 


function PacInCombat.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == PacInCombat.name then
    PacInCombat:Initialize()

    -- Debug output if we have that enabled. 
    if enableDebug == true then
      d("Pacrooti's In Combat Loaded.")
    end
  
  end
end

function PacInCombat.OnPlayerCombatState(event, inCombat)

    if inCombat ~= PacInCombat.inCombat then
      -- The player's state has changed. Update the stored state...
      PacInCombat.inCombat = inCombat
   
      -- ...and then announce the change.
      if inCombat then
        if PacInCombat.savedVariables.enableInCombat == true then
          d("Entering combat.")
        end
      else
        if PacInCombat.savedVariables.enableInCombat == true then
          d("Exiting combat.")
        end
      end
   
    end
end

--  Settings Menu Function via LibAddonMenu-2.0
function PacInCombat.CreateSettingsWindow()
  local panelData = {
      type = "panel",
      name = "Pacrooti's In Combat",
      displayName = "Pacrooti's In Combat",
      author = "Erica Z",
      version = PacInCombat.version,
      slashCommand = "/pic",
      registerForRefresh = true,
      registerForDefaults = true,
  }

  local cntrlOptionsPanel = LAM2:RegisterAddonPanel("PacInCombat_settings", panelData)


  local optionsData = {
      [1] = {
          type = "header",
          name = "In Combat Status",
      },

      [2] = {
          type = "checkbox",
          name = "Enable In Combat",
          default = true,
          getFunc = function() return PacInCombat.savedVariables.enableInCombat end,
          setFunc = function(newValue) PacInCombat.savedVariables.enableInCombat = newValue end,
      },

      [3] = {
          type = "header",
          name = "Debug Messages",
      },

      [4] = {
          type = "checkbox",
          name = "Enable Debug Messages",
          default = false,
          getFunc = function() return PacInCombat.savedVariables.enableDebug end,
          setFunc = function(newValue) PacInCombat.savedVariables.enableDebug = newValue end,
      }
  }

  LAM2:RegisterOptionControls("PacInCombat_settings", optionsData)

end

EVENT_MANAGER:RegisterForEvent(PacInCombat.name, EVENT_ADD_ON_LOADED, PacInCombat.OnAddOnLoaded)