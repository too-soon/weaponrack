local c = C_EquipmentSet

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")

local function saveWeaponSet(setName)
  if not c.GetEquipmentSetID(setName) then
    c.CreateEquipmentSet(setName)
  end
  for i = 1, 17 do
    if i ~= 16 and i ~= 17 then
      c.IgnoreSlotForSave(i)
    end
  end
  c.SaveEquipmentSet(c.GetEquipmentSetID(setName))
  print("[WeaponRack] Set '" .. setName .. "' created.")
end

-- Usage: /weaponrack <command> [setname]
-- Commands: save <setname>, delete <setname>, list
local function listWeaponSets()
  local sets = c.GetNumEquipmentSets and c.GetNumEquipmentSets() or 0
  if sets == 0 then
    print("[WeaponRack] No sets found.")
    return
  end
  print("[WeaponRack] Equipment Sets:")
  for i = 1, sets do
    local name = c.GetEquipmentSetInfo(i)
    print("  - " .. (name or "Unknown"))
  end
end

SLASH_WEAPONRACK1 = "/weaponrack"
SlashCmdList["WEAPONRACK"] = function(msg)
  local cmd, arg = msg:match("^(%S+)%s*(.*)$")
  cmd = cmd and cmd:lower() or ""
  arg = arg and arg:match("^%s*(.-)%s*$") or ""

  if cmd == "save" and arg ~= "" then
    saveWeaponSet(arg)
  elseif cmd == "delete" and arg ~= "" then
    local setID = c.GetEquipmentSetID(arg)
    if setID then
      c.DeleteEquipmentSet(setID)
      print("[WeaponRack] Deleted set '" .. arg .. "'.")
    else
      print("[WeaponRack] Set '" .. arg .. "' not found.")
    end
  elseif cmd == "list" then
    listWeaponSets()
  else
    print("[WeaponRack] Usage: /weaponrack save <setname> | delete <setname> | list")
  end
end
