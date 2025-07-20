local c = C_EquipmentSet

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")

local function saveSet(setName)
  if not c.GetEquipmentSetID(setName) then
    c.CreateEquipmentSet(setName)
  end
  for i = 1, 18 do
    if i ~= 16 and i ~= 17 then
      c.IgnoreSlotForSave(i)
    end
  end
  c.SaveEquipmentSet(c.GetEquipmentSetID(setName))
  print("[WeaponRack] Set '" .. setName .. "' created.")
end

local function listSets()
  local sets = c.GetEquipmentSetIDs()
  if not sets or #sets == 0 then
    print("[WeaponRack] No weapon sets found.")
    return
  end
  print("[WeaponRack] Available weapon sets:")
  for _, setID in ipairs(sets) do
    local setName = c.GetEquipmentSetInfo(setID)
    if setName then
      print("  - " .. setName .. " (ID: " .. setID .. ")")
    end
  end
end

local function deleteSet(setName)
  local setID = c.GetEquipmentSetID(setName)
  if setID then
    c.DeleteEquipmentSet(setID)
    print("[WeaponRack] Deleted set '" .. setName .. "'.")
  else
    print("[WeaponRack] Set '" .. setName .. "' not found.")
  end
end

local function setExists(setName)
  local setID = c.GetEquipmentSetID(setName)
  if setID ~= nil then
    return setID
  end
  print("[WeaponRack] Set '" .. setName .. "' not found.")
  return nil
end

-- This functionality requires a full game restart to work properly.
local function printSetItems(setName)
  local setID = setExists(setName)
  print("Set ID: " .. (setID or "Not found"))
  if setID then
    local itemIds = c.GetItemIDs(setID)
    if not itemIds or #itemIds == 0 then
      print("[WeaponRack] No items found in set '" .. setName .. "'.")
      return
    end
    print("[WeaponRack] Items in set '" .. setName .. "':")
    for slotIndex, itemId in ipairs(itemIds) do
      if itemId then
        local itemLink = select(2, C_Item.GetItemInfo(itemId))
        if itemLink then
          print("  Slot " .. slotIndex .. ": " .. itemLink)
        else
          print("  Slot " .. slotIndex .. ": Item ID " .. itemId .. " (not found)")
        end
      else
        print("  Slot " .. slotIndex .. ": Empty")
      end
    end
  end
end

-- local function onEvent(self, event, ...)
--   if event == "PLAYER_LOGIN" then
--     print("[WeaponRack] Addon loaded. Use /weaponrack for commands.")
--   end
-- end

-- f:SetScript("OnEvent", onEvent)


-- Usage: /weaponrack <command> [setname]
-- Commands: save <setname>, delete <setname>, list
SLASH_WEAPONRACK1 = "/weaponrack"
SlashCmdList["WEAPONRACK"] = function(msg)
  local cmd, arg = msg:match("^(%S+)%s*(.*)$")
  cmd = cmd and cmd:lower() or ""
  arg = arg and arg:match("^%s*(.-)%s*$") or ""

  if cmd == "save" and arg ~= "" then
    saveSet(arg)
  elseif cmd == "delete" and arg ~= "" then
    deleteSet(arg)
  elseif cmd == "list" then
    listSets()
  elseif cmd == "info" then
    printSetItems(arg)
  else
    print("[WeaponRack] Usage: /weaponrack save <setname> | delete <setname> | list")
  end
end
