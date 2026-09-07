-- ==============================================================================
-- Concentration Redux - Script Extender Server Bootstrap
-- Author: NihilXD
-- ==============================================================================
Ext.Utils.Print("[Concentration Redux] BG3 Script Extender detected and loaded successfully!")
Ext.Utils.Print("[Concentration Redux] Initializing Concentration Redux Server Engine...")

local MOD_NAME = "Concentration Redux"
local INNATE_CASTER_STATUS = "INNATE_CONCENTRATION_CASTER"
local COMBAT_CHANNELING_PERK = "Combat_Channeling_Perk"

-- Signature class passives that inherently grant Combat Channeling
local COMBAT_PASSIVES = {
    [COMBAT_CHANNELING_PERK] = true,
    ["WarPriest"] = true,               -- War Domain Cleric
    ["WrathOfTheStorm"] = true,          -- Tempest Domain Cleric
    ["Combat_Channeling_Active"] = true
}

-- Whitelisted actions that NEVER disrupt an active channel
local WHITELISTED_ACTIONS = {
    ["Action_Dodge"] = true,
    ["Shove"] = true,
    ["Throw"] = true,
    ["Dash"] = true,
    ["Disengage"] = true,
    ["Dip"] = true,
    ["Jump"] = true,
    ["Cast_Jump"] = true,
    ["Action_Hide"] = true,
    ["Action_Help"] = true,
    ["Help"] = true,
    ["UsePotion"] = true,
    ["DrinkPotion"] = true,
    ["UseConsumable"] = true,
    ["Action_EndTurn"] = true,
    
    -- Channel re-activations (moving or triggering ongoing active effects)
    ["Target_CallLightning_Reapply"] = true,
    ["Target_Moonbeam_Reapply"] = true,
    ["Target_WitchBolt_Reapply"] = true,
    ["Target_Eyebite_Reapply"] = true,
    ["Target_Telekinesis_Reapply"] = true,
    ["Target_HuntersMark_Reapply"] = true,
    ["Target_Hex_Reapply"] = true,
    ["Target_DismissInnateConcentration"] = true,
    ["Shout_DismissInnateConcentration"] = true
}

-- Mapping of Innate spells to their isolated target status
local INNATE_SPELLS = {
    ["Target_Bless"] = { Status = "INNATE_BUFF_BLESS" },
    ["Target_Bless_4"] = { Status = "INNATE_BUFF_BLESS" },
    ["Target_Bless_5"] = { Status = "INNATE_BUFF_BLESS" },
    ["Target_Bless_6"] = { Status = "INNATE_BUFF_BLESS" },
    ["Target_ShieldOfFaith"] = { Status = "INNATE_BUFF_SHIELD_OF_FAITH" },
    ["Target_Heroism"] = { Status = "INNATE_BUFF_HEROISM" },
    ["Target_Heroism_2"] = { Status = "INNATE_BUFF_HEROISM" },
    ["Target_Heroism_3"] = { Status = "INNATE_BUFF_HEROISM" },
    ["Target_Heroism_4"] = { Status = "INNATE_BUFF_HEROISM" },
    ["Target_Heroism_5"] = { Status = "INNATE_BUFF_HEROISM" },
    ["Target_Heroism_6"] = { Status = "INNATE_BUFF_HEROISM" },
    ["Target_ProtectionFromEvilAndGood"] = { Status = "INNATE_BUFF_PROTECTION_FROM_EVIL_AND_GOOD" },
    ["Target_Barkskin"] = { Status = "INNATE_BUFF_BARKSKIN" },
    ["Target_Stoneskin"] = { Status = "INNATE_BUFF_STONESKIN" },
    ["Target_ShieldOfThralls"] = { Status = "INNATE_BUFF_SHIELD_OF_THRALLS" },
    ["Target_Haste"] = { Status = "INNATE_BUFF_HASTE" },
    ["Target_EnlargeReduce"] = { Status = "INNATE_BUFF_ENLARGE" },
    ["Target_Fly"] = { Status = "INNATE_BUFF_FLY" },
    ["Target_Fly_4"] = { Status = "INNATE_BUFF_FLY" },
    ["Target_Fly_5"] = { Status = "INNATE_BUFF_FLY" },
    ["Target_Fly_6"] = { Status = "INNATE_BUFF_FLY" },
    ["Target_ExpeditiousRetreat"] = { Status = "INNATE_BUFF_EXPEDITIOUS_RETREAT" },
    ["Target_Blur"] = { Status = "INNATE_BUFF_BLUR" },
    ["Target_MagicWeapon"] = { Status = "INNATE_BUFF_MAGIC_WEAPON" },
    ["Target_MagicWeapon_4"] = { Status = "INNATE_BUFF_MAGIC_WEAPON" },
    ["Target_MagicWeapon_6"] = { Status = "INNATE_BUFF_MAGIC_WEAPON" },
    ["Target_ElementalWeapon_Acid"] = { Status = "INNATE_BUFF_ELEMENTAL_WEAPON_ACID" },
    ["Target_ElementalWeapon_Cold"] = { Status = "INNATE_BUFF_ELEMENTAL_WEAPON_COLD" },
    ["Target_ElementalWeapon_Fire"] = { Status = "INNATE_BUFF_ELEMENTAL_WEAPON_FIRE" },
    ["Target_ElementalWeapon_Lightning"] = { Status = "INNATE_BUFF_ELEMENTAL_WEAPON_LIGHTNING" },
    ["Target_ElementalWeapon_Thunder"] = { Status = "INNATE_BUFF_ELEMENTAL_WEAPON_THUNDER" },
    ["Target_Invisibility"] = { Status = "INNATE_BUFF_INVISIBILITY" },
    ["Target_Invisibility_3"] = { Status = "INNATE_BUFF_INVISIBILITY" },
    ["Target_Invisibility_4"] = { Status = "INNATE_BUFF_INVISIBILITY" },
    ["Target_Invisibility_5"] = { Status = "INNATE_BUFF_INVISIBILITY" },
    ["Target_Invisibility_6"] = { Status = "INNATE_BUFF_INVISIBILITY" },
    ["Target_Invisibility_Greater"] = { Status = "INNATE_BUFF_GREATER_INVISIBILITY" },
    ["Target_PassWithoutTrace"] = { Status = "INNATE_BUFF_PASS_WITHOUT_TRACE" },
    ["Target_DetectThoughts"] = { Status = "INNATE_BUFF_DETECT_THOUGHTS" },
    ["Target_HuntersMark"] = { Status = "INNATE_BUFF_HUNTERS_MARK" },
    ["Target_Hex"] = { Status = "INNATE_BUFF_HEX_WISDOM" },
    ["Target_Hex_Strength"] = { Status = "INNATE_BUFF_HEX_STRENGTH" },
    ["Target_Hex_Dexterity"] = { Status = "INNATE_BUFF_HEX_DEXTERITY" },
    ["Target_Hex_Constitution"] = { Status = "INNATE_BUFF_HEX_CONSTITUTION" },
    ["Target_Hex_Intelligence"] = { Status = "INNATE_BUFF_HEX_INTELLIGENCE" },
    ["Target_Hex_Wisdom"] = { Status = "INNATE_BUFF_HEX_WISDOM" },
    ["Target_Hex_Charisma"] = { Status = "INNATE_BUFF_HEX_CHARISMA" },
    ["Target_Bane"] = { Status = "INNATE_BUFF_BANE" },
    ["Target_Bane_2"] = { Status = "INNATE_BUFF_BANE" },
    ["Target_Bane_3"] = { Status = "INNATE_BUFF_BANE" },
    ["Target_Bane_4"] = { Status = "INNATE_BUFF_BANE" },
    ["Target_Bane_5"] = { Status = "INNATE_BUFF_BANE" },
    ["Target_Bane_6"] = { Status = "INNATE_BUFF_BANE" },
    ["Target_BestowCurse_Attack"] = { Status = "INNATE_BUFF_BESTOW_CURSE_ATTACK" },
    ["Target_BestowCurse_Damage"] = { Status = "INNATE_BUFF_BESTOW_CURSE_DAMAGE" },
    ["Target_BestowCurse_Dread"] = { Status = "INNATE_BUFF_BESTOW_CURSE_DREAD" },
    ["Target_BestowCurse_Disadvantage_Strength"] = { Status = "INNATE_BUFF_BESTOW_CURSE_DISADVANTAGE_STRENGTH" },
    ["Target_BestowCurse_Disadvantage_Dexterity"] = { Status = "INNATE_BUFF_BESTOW_CURSE_DISADVANTAGE_DEXTERITY" },
    ["Target_BestowCurse_Disadvantage_Constitution"] = { Status = "INNATE_BUFF_BESTOW_CURSE_DISADVANTAGE_CONSTITUTION" },
    ["Target_BestowCurse_Disadvantage_Intelligence"] = { Status = "INNATE_BUFF_BESTOW_CURSE_DISADVANTAGE_INTELLIGENCE" },
    ["Target_BestowCurse_Disadvantage_Wisdom"] = { Status = "INNATE_BUFF_BESTOW_CURSE_DISADVANTAGE_WISDOM" },
    ["Target_BestowCurse_Disadvantage_Charisma"] = { Status = "INNATE_BUFF_BESTOW_CURSE_DISADVANTAGE_CHARISMA" }
}

-- Session state tracking: Caster GUID -> { Spell = string, Status = string, Targets = { [targetGUID] = true } }
local ActiveInnateCasters = {}

-- ==============================================================================
-- Helper Functions
-- ==============================================================================

local ITEM_SPELL_PATTERNS = {
    "Scroll", "_Item", "Item_", "_Equipment", "Equipment_",
    "_Ring", "Ring_", "_Amulet", "Amulet_", "_Weapon", "Weapon_",
    "_Boots", "Boots_", "_Helm", "Helm_", "_Armor", "Armor_",
    "_Cloak", "Cloak_", "_Staff", "Staff_", "_Bow", "Bow_",
    "DarkfireShortbow", "GontrMael", "Markoheshkir", "Grymskull"
}

local function IsItemOrScrollSpell(spell)
    if not spell then return true end
    for _, pattern in ipairs(ITEM_SPELL_PATTERNS) do
        if spell:find(pattern) then return true end
    end
    if (spell:find("_Shield") or spell:find("Shield_")) and not spell:find("ShieldOfFaith") and not spell:find("ShieldOfThralls") then
        return true
    end
    return false
end

local function GetInnateSpellInfo(spell)
    if not spell then return nil end
    if IsItemOrScrollSpell(spell) then return nil end
    local info = INNATE_SPELLS[spell]
    if info then return info end
    local baseSpell = spell:gsub("_[0-9]+$", "")
    return INNATE_SPELLS[baseSpell]
end

local function HasCombatChanneling(character)
    if not character then return false end
    for passive, _ in pairs(COMBAT_PASSIVES) do
        if Osi.HasPassive(character, passive) == 1 then
            return true
        end
    end
    return false
end

local CONCENTRATION_ADVANTAGE_PASSIVES = {
    ["WarCaster_Concentration"] = true,
    ["WarCaster_Bonuses"] = true,
    ["MAG_AdvantageOnConcentration"] = true,
    ["MAG_AdvantageOnConcentration_Amulet"] = true,
    ["MAG_AdvantageOnConcentration_Armor"] = true,
    ["MAG_AdvantageOnConcentration_Robes"] = true,
    ["MAG_AdvantageOnConcentration_Passive"] = true
}

local function HasConcentrationAdvantage(character)
    if not character then return false end
    for passive, _ in pairs(CONCENTRATION_ADVANTAGE_PASSIVES) do
        if Osi.HasPassive(character, passive) == 1 then
            return true
        end
    end
    local entity = Ext.Entity.Get(character)
    if entity and entity.Passives and entity.Passives.Passives then
        for _, p in ipairs(entity.Passives.Passives) do
            if p.Passive and CONCENTRATION_ADVANTAGE_PASSIVES[p.Passive.PassiveId] then
                return true
            end
        end
    end
    return false
end



local function GetEntitySafe(character)
    if not character then return nil end
    local entity = nil
    pcall(function()
        entity = Ext.Entity.Get(character)
        if not entity and type(character) == "string" then
            local rawUuid = character:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
            if rawUuid then
                entity = Ext.Entity.Get(rawUuid)
            end
        end
    end)
    return entity
end

local function GetActiveInnateCasterInfo(guidOrName)
    if not guidOrName then return nil, nil end
    if ActiveInnateCasters[guidOrName] then return ActiveInnateCasters[guidOrName], guidOrName end
    for k, v in pairs(ActiveInnateCasters) do
        if k:find(guidOrName, 1, true) or guidOrName:find(k, 1, true) then
            return v, k
        end
    end
    return nil, nil
end

local function IsCharacterConcentrating(character)
    if not character or character == "" then return false end
    local isConc = false
    pcall(function()
        local entity = GetEntitySafe(character)
        if entity and entity.Concentration and entity.Concentration.SpellId then
            local proto = entity.Concentration.SpellId.Prototype or ""
            local origProto = entity.Concentration.SpellId.OriginatorPrototype or ""
            local srcType = entity.Concentration.SpellId.SourceType or ""
            if (proto ~= "" and proto ~= "Sentinel") or (origProto ~= "" and origProto ~= "Sentinel") or (srcType ~= "" and srcType ~= "Sentinel") then
                isConc = true
            end
        end
    end)
    return isConc
end

local CONC_TRACKER_STATUS = "ACTIVE_CONCENTRATION_TRACKER"

local function UpdateConcentrationTracker(character)
    if not character or character == "" then return end
    pcall(function()
        local isConc = IsCharacterConcentrating(character)
        local hasTracker = (Osi.HasActiveStatus(character, CONC_TRACKER_STATUS) == 1)
        
        if isConc and not hasTracker then
            Osi.ApplyStatus(character, CONC_TRACKER_STATUS, -1.0, 1, character)
            Ext.Utils.Print(string.format("[%s] Applied concentration tracker to %s", MOD_NAME, tostring(character)))
        elseif not isConc and hasTracker then
            Osi.RemoveStatus(character, CONC_TRACKER_STATUS)
            Ext.Utils.Print(string.format("[%s] Removed concentration tracker from %s", MOD_NAME, tostring(character)))
        end
    end)
end

local function UpdateAllConcentrationTrackers()
    pcall(function()
        local party = Osi.DB_PartyMembers:Get(nil)
        if not party then party = Osi.DB_Players:Get(nil) end
        if party then
            for _, row in ipairs(party) do
                local member = row[1]
                if member then
                    UpdateConcentrationTracker(member)
                end
            end
        end
    end)
end

local function CleanUpInnateBuffs(caster)
    local info, realKey = GetActiveInnateCasterInfo(caster)
    if info and info.Targets then
        for target, _ in pairs(info.Targets) do
            if info.Status and Osi.HasActiveStatus(target, info.Status) == 1 then
                Osi.RemoveStatus(target, info.Status)
            end
        end
    end
    
    -- Thorough party sweep to clear all recipients of this caster's buff
    local function ClearGroup(dbGroup)
        pcall(function()
            local list = dbGroup:Get(nil)
            if list then
                for _, row in ipairs(list) do
                    local member = row[1]
                    if member and info and info.Status then
                        if Osi.HasActiveStatus(member, info.Status) == 1 then
                            Osi.RemoveStatus(member, info.Status)
                        end
                    end
                end
            end
        end)
    end
    
    ClearGroup(Osi.DB_PartyMembers)
    ClearGroup(Osi.DB_Players)
    
    if realKey then
        ActiveInnateCasters[realKey] = nil
    end
    ActiveInnateCasters[caster] = nil
    Ext.Utils.Print(string.format("[%s] Cleaned up innate buffs for caster: %s", MOD_NAME, tostring(caster)))
end

local function GetConstitutionSaveBonus(entityGuid)
    local bonus = 0
    pcall(function()
        local conScore = 10
        local queryVal = Osi.GetAbility(entityGuid, "Constitution")
        if queryVal and queryVal > 0 then
            conScore = queryVal
        elseif type(entityGuid) == "string" then
            local rawUuid = entityGuid:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
            if rawUuid then
                local q2 = Osi.GetAbility(rawUuid, "Constitution")
                if q2 and q2 > 0 then conScore = q2 end
            end
        end
        bonus = math.floor((conScore - 10) / 2)
        
        -- Check proficiency from passives if present
        local hasProf = false
        if Osi.HasPassive(entityGuid, "Resilient_Constitution") == 1 or
           Osi.HasPassive(entityGuid, "SavingThrow_Constitution") == 1 then
            hasProf = true
        end
        if hasProf then
            local level = 1
            pcall(function()
                level = Osi.GetLevel(entityGuid) or 1
            end)
            local profBonus = math.floor((level - 1) / 4) + 2
            bonus = bonus + profBonus
        end
    end)
    return bonus
end

-- ==============================================================================
-- 1. Tracking Innate Buff Application & Target Association
-- ==============================================================================

-- Hook cast start: record spell and clear prior buffs if switching spells
Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    local innateInfo = GetInnateSpellInfo(spell)
    if innateInfo then
        local existing = ActiveInnateCasters[caster]
        if existing and existing.Spell ~= spell then
            CleanUpInnateBuffs(caster)
        end
        ActiveInnateCasters[caster] = {
            Spell = spell,
            Status = innateInfo.Status,
            Targets = {}
        }
        -- Ensure ONLY the CASTER gets INNATE_CONCENTRATION_CASTER
        if Osi.HasActiveStatus(caster, INNATE_CASTER_STATUS) == 0 then
            Osi.ApplyStatus(caster, INNATE_CASTER_STATUS, -1.0, 1, caster)
        end
    end
end)

-- Hook every recipient receiving the innate buff status
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, causee, storyActionID)
    if status:find("INNATE_BUFF_") then
        if causee and causee ~= "" then
            if not ActiveInnateCasters[causee] then
                ActiveInnateCasters[causee] = {
                    Status = status,
                    Targets = {}
                }
            end
            ActiveInnateCasters[causee].Targets[target] = true
            ActiveInnateCasters[causee].Status = status
            
            -- Guarantee CASTER has INNATE_CONCENTRATION_CASTER
            if Osi.HasActiveStatus(causee, INNATE_CASTER_STATUS) == 0 then
                Osi.ApplyStatus(causee, INNATE_CASTER_STATUS, -1.0, 1, causee)
            end
            Ext.Utils.Print(string.format("[%s] Registered target %s for caster %s (status: %s)", MOD_NAME, tostring(target), tostring(causee), tostring(status)))
        end
    end
end)

-- Manual Dismissal Spell listener (Shout_DismissInnateConcentration)
Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    if spell == "Shout_DismissInnateConcentration" or spell == "Target_DismissInnateConcentration" then
        Osi.RemoveStatus(caster, INNATE_CASTER_STATUS)
        CleanUpInnateBuffs(caster)
        pcall(function()
            Osi.ShowOverheadNotice(caster, "Focus Dismissed")
        end)
    end
end)

-- Incapacitation & Loss-of-Control Listener (breaks Focus on hard CC)
local INCAPACITATING_STATUSES = {
    ["DOWNED"] = true, ["DYING"] = true, ["DEAD"] = true,
    ["STUNNED"] = true, ["STUNNED_DEATHSHEAD_USED"] = true, ["STUNNED_STUNNINGGAZE"] = true,
    ["PARALYZED"] = true, ["PARALYZED_SPECTATOR"] = true, ["PETRIFIED"] = true,
    ["INCAPACITATED"] = true, ["INCAPACITATED_DND"] = true,
    ["SLEEP"] = true, ["SLEEPING"] = true, ["SLEEPING_MAGICAL"] = true, ["SLEEPING_EYEBITE"] = true,
    ["UNCONSCIOUS"] = true, ["KNOCKED_OUT"] = true,
    ["BANISHED"] = true, ["HOLD_PERSON"] = true, ["HOLD_MONSTER"] = true,
    ["POLYMORPH"] = true
}

local function IsIncapacitatingStatus(status)
    if not status then return false end
    if INCAPACITATING_STATUSES[status] then return true end
    local upper = status:upper()
    if upper:find("STUN") or upper:find("PARALY") or upper:find("PETRIF")
       or upper:find("SLEEP") or upper:find("BANISH") or upper:find("INCAPACITAT")
       or upper:find("KNOCKED_OUT") or upper:find("UNCONSCIOUS") then
        return true
    end
    return false
end

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, causee, storyActionID)
    if status == "CONCENTRATION" then
        UpdateConcentrationTracker(target)
    end
    if IsIncapacitatingStatus(status) then
        if Osi.HasActiveStatus(target, INNATE_CASTER_STATUS) == 1 then
            Osi.RemoveStatus(target, INNATE_CASTER_STATUS)
            CleanUpInnateBuffs(target)
            pcall(function()
                Osi.ShowOverheadNotice(target, "Focus Lost (Incapacitated)")
            end)
        end
    end
end)

-- Cleanup when caster loses the Innate Concentration status (manual cancel, rest, etc.)
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status, causee, storyActionID)
    if status == "CONCENTRATION" then
        if Osi.HasActiveStatus(target, CONC_TRACKER_STATUS) == 1 then
            Osi.RemoveStatus(target, CONC_TRACKER_STATUS)
        end
    end
    if status == INNATE_CASTER_STATUS then
        CleanUpInnateBuffs(target)
    end
end)

-- Character Death Listener: Cleans up deceased casters and handles marked target deaths
Ext.Osiris.RegisterListener("Died", 1, "after", function(char)
    if Osi.HasActiveStatus(char, CONC_TRACKER_STATUS) == 1 then
        Osi.RemoveStatus(char, CONC_TRACKER_STATUS)
    end
    if ActiveInnateCasters[char] then
        Osi.RemoveStatus(char, INNATE_CASTER_STATUS)
        CleanUpInnateBuffs(char)
    end
    for caster, info in pairs(ActiveInnateCasters) do
        if info.Targets and info.Targets[char] then
            info.Targets[char] = nil
        end
    end
end)

-- Cleanup on Long Rest
Ext.Osiris.RegisterListener("LongRestStarted", 0, "after", function()
    for caster, _ in pairs(ActiveInnateCasters) do
        Osi.RemoveStatus(caster, INNATE_CASTER_STATUS)
        CleanUpInnateBuffs(caster)
    end
    ActiveInnateCasters = {}
end)

-- Cleanup on Withers Respec
Ext.Osiris.RegisterListener("RespecCompleted", 1, "after", function(character)
    if Osi.HasActiveStatus(character, INNATE_CASTER_STATUS) == 1 then
        Osi.RemoveStatus(character, INNATE_CASTER_STATUS)
        CleanUpInnateBuffs(character)
    end
end)

-- ==============================================================================
-- 2. Active Channel Action Restriction Enforcer
-- ==============================================================================

local CurrentTurnCharacter = nil

Ext.Osiris.RegisterListener("TurnStarted", 1, "after", function(character)
    CurrentTurnCharacter = character
end)

Ext.Osiris.RegisterListener("TurnEnded", 1, "after", function(character)
    if CurrentTurnCharacter == character then
        CurrentTurnCharacter = nil
    end
end)

Ext.Osiris.RegisterListener("CombatEnded", 1, "after", function(combatGuid)
    CurrentTurnCharacter = nil
end)

local function IsWeaponAction(spell, spellType)
    if not spell then return false end
    if spellType == "MeleeWeapon" or spellType == "RangedWeapon" then return true end
    
    local stat = nil
    pcall(function() stat = Ext.Stats.Get(spell) end)
    if stat then
        local req = stat.RequirementConditions or ""
        if req:find("Weapon") or req:find("HasWeapon") or req:find("Melee") or req:find("Ranged") or req:find("MainHand") or req:find("OffHand") then
            return true
        end
        local useCosts = stat.UseCosts or ""
        if useCosts:find("WeaponActionPoint") then return true end
        local props = stat.SpellProperties or ""
        if props:find("MainWeaponDamage") or props:find("OffHandWeaponDamage") or props:find("WeaponDamage") then return true end
        local tooltipDamage = stat.TooltipDamageList or ""
        if tooltipDamage:find("MainWeaponDamageType") or tooltipDamage:find("WeaponDamageType") then return true end
        local flags = stat.SpellFlags or ""
        if flags:find("HasWeaponProperties") then return true end
    end
    
    local lowerSpell = spell:lower()
    if lowerSpell:find("attack") or lowerSpell:find("weapon") or lowerSpell:find("strike") 
       or lowerSpell:find("shot") or lowerSpell:find("topple") or lowerSpell:find("lacerate")
       or lowerSpell:find("flourish") or lowerSpell:find("pierce") or lowerSpell:find("pommel")
       or lowerSpell:find("cleave") or lowerSpell:find("brace") or lowerSpell:find("smash")
       or lowerSpell:find("slash") or lowerSpell:find("pin") or lowerSpell:find("tenacity")
       or lowerSpell:find("heartstopper") or lowerSpell:find("backbreaker") or lowerSpell:find("weakening")
       or lowerSpell:find("rush") or lowerSpell:find("thrust") or lowerSpell:find("flurry") then
        return true
    end
    return false
end

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    if IsCharacterConcentrating(caster) then
        if GetInnateSpellInfo(spell) ~= nil then return end
        if WHITELISTED_ACTIONS[spell] then return end
        
        if (spell == "Target_ShockingGrasp" or spell:find("ShockingGrasp")) and HasConcentrationAdvantage(caster) then
            if CurrentTurnCharacter == nil or CurrentTurnCharacter ~= caster then
                return
            end
        end
        
        if IsWeaponAction(spell, spellType) then
            if HasCombatChanneling(caster) then
                return
            else
                pcall(function() Osi.BreakConcentration(caster) end)
                pcall(function() Osi.ShowOverheadNotice(caster, "Channel broken by physical attack!") end)
                return
            end
        end
        
        pcall(function() Osi.BreakConcentration(caster) end)
        pcall(function() Osi.ShowOverheadNotice(caster, "Channel broken by spellcasting!") end)
    end
end)

-- ==============================================================================
-- 3. Dynamic Concentration Checks on Taking Damage (The Overclock)
-- ==============================================================================

local lastDamageCheck = {}

local function RollD20()
    local r = nil
    pcall(function()
        r = math.random(1, 20)
    end)
    if not r or type(r) ~= "number" or r < 1 then
        pcall(function()
            r = Ext.Utils.Random(1, 20)
        end)
    end
    if not r or type(r) ~= "number" or r < 1 then
        local t = Ext.Utils.MonotonicTime() or 0
        r = (t % 20) + 1
    end
    -- If r was returned as a float in [0.0, 1.0)
    if type(r) == "number" and r > 0 and r <= 1 then
        r = math.floor(r * 20) + 1
    end
    return math.max(1, math.min(20, math.floor(r or 10)))
end

local function HandleDamageConcentrationCheck(victim, damageAmount)
    if not victim then return end
    
    local victimGuid = nil
    if type(victim) == "userdata" then
        pcall(function()
            if victim.Uuid and victim.Uuid.EntityUuid then
                victimGuid = victim.Uuid.EntityUuid
            end
        end)
    else
        victimGuid = tostring(victim)
    end
    if not victimGuid or victimGuid == "" then return end
    
    -- Normalize UUID to ensure debouncing works across userdata and Osiris strings
    local rawUuid = victimGuid:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or victimGuid
    
    -- Debounce duplicate damage events for the same victim within 1000ms (1 full second)
    -- This prevents multi-damage riders (e.g. physical + fire + poison) and AttackedBy fallback
    -- from forcing 3-4 rolls for a single attack.
    local now = Ext.Utils.MonotonicTime()
    if lastDamageCheck[rawUuid] and (now - lastDamageCheck[rawUuid] < 1000) then
        return
    end
    
    -- 1. FOCUS CHECK:
    -- Does this character maintain an active Focus spell?
    local hasFocus = (Osi.HasActiveStatus(victimGuid, INNATE_CASTER_STATUS) == 1)
    if not hasFocus and rawUuid then
        hasFocus = (Osi.HasActiveStatus(rawUuid, INNATE_CASTER_STATUS) == 1)
    end
    if not hasFocus then
        local info = GetActiveInnateCasterInfo(victimGuid)
        hasFocus = (info ~= nil)
    end
    if not hasFocus then return end
    
    -- 2. CONCENTRATION CHECK:
    -- Is the character also maintaining a native concentration spell?
    -- Overclock = maintaining BOTH Focus AND native Concentration simultaneously!
    local hasConc = IsCharacterConcentrating(victimGuid) or (Osi.HasActiveStatus(victimGuid, CONC_TRACKER_STATUS) == 1)
    if not hasConc and rawUuid then
        hasConc = IsCharacterConcentrating(rawUuid) or (Osi.HasActiveStatus(rawUuid, CONC_TRACKER_STATUS) == 1)
    end
    
    -- STANCE CHECK:
    -- If victim is NOT in Overclock (Focus only), Focus is unburdened: 100% UNBREAKABLE!
    if not hasConc then
        return
    end
    
    -- Mark timestamp AFTER confirming Overclock
    lastDamageCheck[rawUuid] = now
    
    -- OVERCLOCK STANCE:
    -- Maintaining BOTH Focus and Concentration simultaneously!
    -- Focus rolls an independent Constitution saving throw with Advantage!
    local dmg = tonumber(damageAmount) or 0
    if dmg <= 0 then dmg = 1 end
    local saveDC = math.max(10, math.floor(dmg / 2))
    local conBonus = GetConstitutionSaveBonus(victimGuid)
    local roll1 = RollD20()
    local roll2 = RollD20()
    local bestRoll = math.max(roll1, roll2)
    local totalCheck = bestRoll + conBonus
    
    local info, realCasterKey = GetActiveInnateCasterInfo(victimGuid)
    local displayTarget = realCasterKey or victimGuid
    
    if totalCheck >= saveDC then
        pcall(function()
            Ext.Utils.Print(string.format("[%s] Overclock Focus Save SUCCESS (Advantage): %s rolled (%d, %d) -> %d + %d = %d vs DC %d (Focus Maintained!)", 
                MOD_NAME, tostring(displayTarget), roll1, roll2, bestRoll, conBonus, totalCheck, saveDC))
            Osi.ShowOverheadNotice(displayTarget, string.format("Focus Saved! (%d vs DC %d)", totalCheck, saveDC))
        end)
    else
        pcall(function()
            Ext.Utils.Print(string.format("[%s] Overclock Focus Save FAILURE (Advantage): %s rolled (%d, %d) -> %d + %d = %d vs DC %d (Focus Broken!)", 
                MOD_NAME, tostring(displayTarget), roll1, roll2, bestRoll, conBonus, totalCheck, saveDC))
            Osi.ShowOverheadNotice(displayTarget, string.format("Focus Broken! (%d vs DC %d)", totalCheck, saveDC))
        end)
        Osi.RemoveStatus(victimGuid, INNATE_CASTER_STATUS)
        if rawUuid then
            Osi.RemoveStatus(rawUuid, INNATE_CASTER_STATUS)
        end
        if realCasterKey then
            Osi.RemoveStatus(realCasterKey, INNATE_CASTER_STATUS)
        end
        CleanUpInnateBuffs(victimGuid)
    end
end

-- Hook all damage sources via Script Extender DealDamage event (spells, surfaces, AoE, weapons)
if Ext.Events and Ext.Events.DealDamage then
    Ext.Events.DealDamage:Subscribe(function(e)
        if not e or not e.Target then return end
        local targetGuid = nil
        pcall(function()
            if type(e.Target) == "userdata" then
                if e.Target.Uuid and e.Target.Uuid.EntityUuid then
                    targetGuid = e.Target.Uuid.EntityUuid
                end
            elseif type(e.Target) == "string" then
                targetGuid = e.Target
            end
        end)
        if not targetGuid then return end
        
        local totalDmg = 0
        pcall(function()
            if e.Attack and type(e.Attack) == "number" then
                totalDmg = e.Attack
            elseif e.Damage and type(e.Damage) == "number" then
                totalDmg = e.Damage
            elseif e.Amount and type(e.Amount) == "number" then
                totalDmg = e.Amount
            end
        end)
        if totalDmg <= 0 then
            totalDmg = 1
        end
        
        pcall(function()
            HandleDamageConcentrationCheck(targetGuid, totalDmg)
        end)
    end)
end

-- Osiris AttackedBy fallback for physical weapon attack hits
Ext.Osiris.RegisterListener("AttackedBy", 7, "after", function(defender, attackerOwner, attacker, damageType, damageAmount, damageCause, storyActionID)
    local dmg = tonumber(damageAmount) or 0
    if dmg <= 0 then dmg = 1 end
    pcall(function()
        HandleDamageConcentrationCheck(defender, dmg)
    end)
end)

-- ==============================================================================
-- 4. Savegame / Reload Persistence Engine
-- ==============================================================================

local function ReconstructSessionStateFromEngine()
    ActiveInnateCasters = {}
    pcall(function()
        local party = Osi.DB_PartyMembers:Get(nil)
        if not party then party = Osi.DB_Players:Get(nil) end
        if not party then return end
        
        for _, row in ipairs(party) do
            local target = row[1]
            local entity = Ext.Entity.Get(target)
            if entity and entity.StatusMachine and entity.StatusMachine.Statuses then
                for _, statusObj in ipairs(entity.StatusMachine.Statuses) do
                    local sId = statusObj.StatusId
                    if sId and sId:find("INNATE_BUFF_") then
                        local causee = nil
                        if statusObj.Causee and statusObj.Causee.EntityUuid then
                            causee = statusObj.Causee.EntityUuid
                        elseif statusObj.StatusCausee and statusObj.StatusCausee.EntityUuid then
                            causee = statusObj.StatusCausee.EntityUuid
                        end
                        if causee then
                            if not ActiveInnateCasters[causee] then
                                ActiveInnateCasters[causee] = {
                                    Targets = {},
                                    Status = sId
                                }
                            end
                            ActiveInnateCasters[causee].Targets[target] = true
                            ActiveInnateCasters[causee].Status = sId
                            
                            if Osi.HasActiveStatus(causee, INNATE_CASTER_STATUS) == 0 then
                                Osi.ApplyStatus(causee, INNATE_CASTER_STATUS, -1.0, 1, causee)
                            end
                        end
                    end
                end
            end
        end
        Ext.Utils.Print(string.format("[%s] Reconstructed dual concentration state from savegame.", MOD_NAME))
    end)
end

-- Session state reconstruction handled via Ext.Events.SessionLoaded

-- Continuous synchronization of concentration state
local tickCounter = 0
Ext.Events.Tick:Subscribe(function()
    tickCounter = tickCounter + 1
    if tickCounter % 15 == 0 then
        UpdateAllConcentrationTrackers()
    end
end)


Ext.Events.SessionLoaded:Subscribe(function()
    ReconstructSessionStateFromEngine()
    Ext.Utils.Print(string.format("[%s] v1.0.0 initialized successfully. Dual concentration engine active.", MOD_NAME))
end)
