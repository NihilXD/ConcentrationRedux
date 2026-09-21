-- ==============================================================================
-- Concentration Redux - Kinetic Witch Bolt: Server Bootstrap
-- ==============================================================================

local MOD_NAME = "CR_KineticWitchBolt"
local _P = function(msg)
    if Ext and Ext.Utils and Ext.Utils.Print then
        Ext.Utils.Print(msg)
    else
        print(msg)
    end
end

_P(string.format("[%s] Initializing Kinetic Witch Bolt Server Engine...", MOD_NAME))

local function NormalizeGuid(id)
    if not id then return nil end
    local raw = id:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
    return raw or id
end

-- Active Tether Registry: [normCasterGuid] = { victim = normTargetGuid, tier = number, slotLevel = number, establishedTime = ms, lastTurnTime = ms, turnsInCombat = number }
local ActiveTethers = {}
local PendingCastInfo = {}
local ActiveFlings = {}

local TIER_CONFIG = {
    [1] = {
        name = "Target_WitchBolt_Whip",
        maxDist = 1.5,
        diceCount = 1,
        diceSides = 4,
        allowLarge = false,
        allowHuge = false,
        canProne = false
    },
    [2] = {
        name = "Target_WitchBolt_Whip_3",
        maxDist = 3.0,
        diceCount = 1,
        diceSides = 6,
        allowLarge = true,
        allowHuge = false,
        canProne = true
    },
    [3] = {
        name = "Target_WitchBolt_Whip_5",
        maxDist = 4.5,
        diceCount = 2,
        diceSides = 6,
        allowLarge = true,
        allowHuge = true,
        canProne = true
    }
}

-- -----------------------------------------------------------------------------
-- 1. Direct Stats Injection via Ext.Stats
-- -----------------------------------------------------------------------------
Ext.Events.StatsLoaded:Subscribe(function()
    _P(string.format("[%s] StatsLoaded: Injecting Kinetic Witch Bolt descriptions & parameters...", MOD_NAME))

    local function PatchStat(statName, props)
        pcall(function()
            local stat = Ext.Stats.Get(statName)
            if stat then
                for k, v in pairs(props) do
                    stat[k] = v
                end
            end
        end)
    end

    -- Tier 1
    PatchStat("Projectile_WitchBolt", {
        Description = "h_cr_projectile_witchbolt_desc;1",
        TooltipUpcastDescription = "h_cr_witchbolt_upcast_desc;1"
    })
    PatchStat("Projectile_WitchBolt_2", {
        Description = "h_cr_projectile_witchbolt_desc;1"
    })
    PatchStat("WITCH_BOLT", {
        DisplayName = "h_cr_witchbolt_status_name;1",
        Description = "h_cr_witchbolt_status_desc;1"
    })
    PatchStat("WITCH_BOLT_OWNER", {
        DisplayName = "h_cr_witchbolt_owner_name;1",
        Description = "h_cr_witchbolt_owner_desc;1"
    })
    PatchStat("WITCH_BOLT_CHARGED", {
        DisplayName = "h_cr_witchbolt_whip_name;1",
        Description = "h_cr_witchbolt_charged_desc;1"
    })

    -- Tier 2 (Level 3-4 Upcast)
    PatchStat("Projectile_WitchBolt_3", {
        Description = "h_cr_projectile_witchbolt_desc_3;1"
    })
    PatchStat("Projectile_WitchBolt_4", {
        Description = "h_cr_projectile_witchbolt_desc_3;1"
    })
    PatchStat("WITCH_BOLT_3", {
        DisplayName = "h_cr_witchbolt_status_name_3;1",
        Description = "h_cr_witchbolt_status_desc_3;1"
    })
    PatchStat("WITCH_BOLT_OWNER_3", {
        DisplayName = "h_cr_witchbolt_owner_name_3;1",
        Description = "h_cr_witchbolt_owner_desc_3;1"
    })
    PatchStat("WITCH_BOLT_CHARGED_3", {
        DisplayName = "h_cr_witchbolt_whip_name;1",
        Description = "h_cr_witchbolt_charged_desc_3;1"
    })

    -- Tier 3 (Level 5-6 Upcast)
    PatchStat("Projectile_WitchBolt_5", {
        Description = "h_cr_projectile_witchbolt_desc_5;1"
    })
    PatchStat("Projectile_WitchBolt_6", {
        Description = "h_cr_projectile_witchbolt_desc_5;1"
    })
    PatchStat("WITCH_BOLT_5", {
        DisplayName = "h_cr_witchbolt_status_name_5;1",
        Description = "h_cr_witchbolt_status_desc_5;1"
    })
    PatchStat("WITCH_BOLT_OWNER_5", {
        DisplayName = "h_cr_witchbolt_owner_name_5;1",
        Description = "h_cr_witchbolt_owner_desc_5;1"
    })
    PatchStat("WITCH_BOLT_CHARGED_5", {
        DisplayName = "h_cr_witchbolt_whip_name;1",
        Description = "h_cr_witchbolt_charged_desc_5;1"
    })

    -- Whip Spells
    PatchStat("Target_WitchBolt_Whip", {
        TargetRadius = 18.0,
        DisplayName = "h_cr_witchbolt_whip_name;1",
        Description = "h_cr_witchbolt_whip_desc_1;1"
    })
    PatchStat("Target_WitchBolt_Whip_3", {
        TargetRadius = 18.0,
        DisplayName = "h_cr_witchbolt_whip_name;1",
        Description = "h_cr_witchbolt_whip_desc_3;1"
    })
    PatchStat("Target_WitchBolt_Whip_5", {
        TargetRadius = 18.0,
        DisplayName = "h_cr_witchbolt_whip_name;1",
        Description = "h_cr_witchbolt_whip_desc_5;1"
    })
end)

local function RollDice(count, sides)
    local total = 0
    local rolls = {}
    for i = 1, count do
        local r = math.random(1, sides)
        table.insert(rolls, r)
        total = total + r
    end
    return total, rolls
end

local function GetCasterSpellDC(caster)
    if not caster then return 12 end
    local intScore = Osi.GetAbility(caster, "Intelligence") or 10
    local wisScore = Osi.GetAbility(caster, "Wisdom") or 10
    local chaScore = Osi.GetAbility(caster, "Charisma") or 10
    local spellMod = math.max(
        math.floor((intScore - 10) / 2),
        math.floor((wisScore - 10) / 2),
        math.floor((chaScore - 10) / 2)
    )
    local lvl = Osi.GetLevel(caster) or 1
    local prof = (lvl >= 9 and 4) or (lvl >= 5 and 3) or 2
    return math.max(10, 8 + prof + spellMod)
end

-- -----------------------------------------------------------------------------
-- 2. Tether Tracking Lifecycle
-- -----------------------------------------------------------------------------
local function DischargeTether(caster)
    if not caster then return end
    local rawCaster = NormalizeGuid(caster)
    _P(string.format("[%s] Discharging tether for caster %s.", MOD_NAME, tostring(caster)))

    local data = ActiveTethers[rawCaster] or ActiveTethers[caster]
    local victim = data and data.victim
    local rawVictim = data and data.rawVictim

    pcall(function()
        -- Pure status cleanup: NEVER call Osi.RemoveSpell as it corrupts hotbar mappings
        Osi.RemoveStatus(caster, "WITCH_BOLT_OWNER")
        Osi.RemoveStatus(caster, "WITCH_BOLT_OWNER_3")
        Osi.RemoveStatus(caster, "WITCH_BOLT_OWNER_5")
        Osi.RemoveStatus(caster, "WITCH_BOLT_CHARGED")
        Osi.RemoveStatus(caster, "WITCH_BOLT_CHARGED_3")
        Osi.RemoveStatus(caster, "WITCH_BOLT_CHARGED_5")
        if rawCaster and rawCaster ~= caster then
            Osi.RemoveStatus(rawCaster, "WITCH_BOLT_OWNER")
            Osi.RemoveStatus(rawCaster, "WITCH_BOLT_OWNER_3")
            Osi.RemoveStatus(rawCaster, "WITCH_BOLT_OWNER_5")
            Osi.RemoveStatus(rawCaster, "WITCH_BOLT_CHARGED")
            Osi.RemoveStatus(rawCaster, "WITCH_BOLT_CHARGED_3")
            Osi.RemoveStatus(rawCaster, "WITCH_BOLT_CHARGED_5")
        end
        if victim then
            Osi.RemoveStatus(victim, "WITCH_BOLT")
            Osi.RemoveStatus(victim, "WITCH_BOLT_3")
            Osi.RemoveStatus(victim, "WITCH_BOLT_5")
        end
        if rawVictim and rawVictim ~= victim then
            Osi.RemoveStatus(rawVictim, "WITCH_BOLT")
            Osi.RemoveStatus(rawVictim, "WITCH_BOLT_3")
            Osi.RemoveStatus(rawVictim, "WITCH_BOLT_5")
        end
        Osi.BreakConcentration(caster)
        if rawCaster and rawCaster ~= caster then
            Osi.BreakConcentration(rawCaster)
        end
    end)
    if rawCaster then
        ActiveTethers[rawCaster] = nil
    end
    ActiveTethers[caster] = nil
end

local function TriggerConduitShock(caster, data, reason)
    if not data or not data.victim or Osi.IsDead(data.victim) == 1 then
        DischargeTether(caster)
        return false
    end

    -- Maximum tether range check: 24.0m limit
    local cx, cy, cz = Osi.GetPosition(caster)
    if not cx and data.rawCaster then
        cx, cy, cz = Osi.GetPosition(data.rawCaster)
    end
    local vx, vy, vz = Osi.GetPosition(data.victim)
    if not vx and data.rawVictim then
        vx, vy, vz = Osi.GetPosition(data.rawVictim)
    end
    if cx and vx then
        local dx = cx - vx
        local dy = cy - vy
        local dz = cz - vz
        local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
        if dist > 24.0 then
            _P(string.format("[%s] Tether broken: distance %.2fm exceeds 24.0m limit.", MOD_NAME, dist))
            DischargeTether(caster)
            return false
        end
    end

    local diceCount = data.slotLevel or (data.tier == 3 and 5 or (data.tier == 2 and 3 or 1))
    local dmg, rolls = RollDice(diceCount, 12)
    local rollBreakdown = table.concat(rolls, "+")
    _P(string.format("[%s] Conduit shock (%s)! Caster %s -> Victim %s: %d Lightning damage (%dd12: [%s]).",
        MOD_NAME, reason or "Auto", tostring(caster), tostring(data.victim), dmg, diceCount, rollBreakdown))

    pcall(function() Osi.PlayEffect(data.victim, "5bbedd95-2d56-4974-ab7a-ccfa0a9e36fd", "Root") end)
    Osi.ApplyDamage(data.victim, dmg, "Lightning", caster)
    pcall(function()
        Osi.ShowOverheadNotice(data.victim, string.format("Shock: %d Dmg (%dd12: %s)", dmg, diceCount, rollBreakdown))
    end)

    if Osi.IsDead(data.victim) == 1 then
        _P(string.format("[%s] Victim %s eliminated by conduit shock.", MOD_NAME, tostring(data.victim)))
        DischargeTether(caster)
        return false
    end

    return true
end

-- Track cast level & initial target
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(caster, target, spell, spellType, spellElement, storyActionID)
    if spell:find("^Projectile_WitchBolt") then
        local lvl = 1
        local num = spell:match("Projectile_WitchBolt_(%d+)")
        if num then lvl = tonumber(num) end
        local rawCaster = NormalizeGuid(caster)
        local rawTarget = NormalizeGuid(target)
        PendingCastInfo[rawCaster] = { target = rawTarget, level = lvl, missed = false }
        if caster ~= rawCaster then
            PendingCastInfo[caster] = PendingCastInfo[rawCaster]
        end
    end
end)

-- If the spell missed, mark it so we do not establish a tether
Ext.Osiris.RegisterListener("MissedBy", 4, "after", function(defender, attacker, source, storyActionID)
    local rawAttacker = NormalizeGuid(attacker)
    local rawDefender = NormalizeGuid(defender)
    local pInfo = PendingCastInfo[rawAttacker] or PendingCastInfo[attacker]

    if pInfo and (pInfo.target == rawDefender or pInfo.target == defender) then
        _P(string.format("[%s] Witch Bolt missed target %s! Tether cancelled.", MOD_NAME, tostring(defender)))
        pInfo.missed = true
        DischargeTether(attacker)
        pcall(function()
            Osi.RemoveStatus(defender, "WITCH_BOLT")
            Osi.RemoveStatus(defender, "WITCH_BOLT_3")
            Osi.RemoveStatus(defender, "WITCH_BOLT_5")
            if rawDefender and rawDefender ~= defender then
                Osi.RemoveStatus(rawDefender, "WITCH_BOLT")
                Osi.RemoveStatus(rawDefender, "WITCH_BOLT_3")
                Osi.RemoveStatus(rawDefender, "WITCH_BOLT_5")
            end
            Osi.BreakConcentration(attacker)
            if rawAttacker and rawAttacker ~= attacker then
                Osi.BreakConcentration(rawAttacker)
            end
        end)
    end
end)

local function RegisterTether(victim, caster, tier)
    if not victim or not caster then return end
    local rawCaster = NormalizeGuid(caster)
    local rawVictim = NormalizeGuid(victim)

    local existing = ActiveTethers[rawCaster] or ActiveTethers[caster]
    if existing and (existing.victim == victim or existing.rawVictim == rawVictim or existing.victim == rawVictim or existing.rawVictim == victim) then
        _P(string.format("[%s] RegisterTether ignored: tether already active between %s and %s", MOD_NAME, tostring(caster), tostring(victim)))
        return
    end

    local pInfo = PendingCastInfo[rawCaster] or PendingCastInfo[caster]
    if pInfo and pInfo.missed then
        _P(string.format("[%s] RegisterTether aborted: initial bolt was marked as missed.", MOD_NAME))
        return
    end

    local slotLevel = (tier == 3 and 5) or (tier == 2 and 3) or 1
    if pInfo and (pInfo.target == rawVictim or pInfo.target == victim) then
        slotLevel = pInfo.level
        PendingCastInfo[rawCaster] = nil
        PendingCastInfo[caster] = nil
    end

    local tetherData = {
        caster = caster,
        rawCaster = rawCaster,
        victim = victim,
        rawVictim = rawVictim,
        tier = tier or 1,
        slotLevel = slotLevel,
        establishedTime = Ext.Utils.MonotonicTime(),
        lastTurnTime = Ext.Utils.MonotonicTime(),
        turnsInCombat = 0,
        hasLeftTurn = false,
        whipUsedThisTurn = false
    }

    ActiveTethers[rawCaster] = tetherData
    if caster ~= rawCaster then
        ActiveTethers[caster] = tetherData
    end

    _P(string.format("[%s] Registered Tether: Caster %s -> Victim %s (Tier %d, Level %d)",
        MOD_NAME, tostring(caster), tostring(victim), tier or 1, slotLevel))

    -- Apply owner status (channel maintain status, NO whip unlocked on Turn 1)
    local ownerStatus = (tier == 3 and "WITCH_BOLT_OWNER_5") or (tier == 2 and "WITCH_BOLT_OWNER_3") or "WITCH_BOLT_OWNER"
    pcall(function()
        if Osi.HasActiveStatus(caster, ownerStatus) == 0 then
            Osi.ApplyStatus(caster, ownerStatus, -1.0, 1, caster)
        end
        if rawCaster and rawCaster ~= caster and Osi.HasActiveStatus(rawCaster, ownerStatus) == 0 then
            Osi.ApplyStatus(rawCaster, ownerStatus, -1.0, 1, rawCaster)
        end
        -- Ensure charged status is clear on Turn 1 so whip is NOT shown yet
        Osi.RemoveStatus(caster, "WITCH_BOLT_CHARGED")
        Osi.RemoveStatus(caster, "WITCH_BOLT_CHARGED_3")
        Osi.RemoveStatus(caster, "WITCH_BOLT_CHARGED_5")
        if rawCaster and rawCaster ~= caster then
            Osi.RemoveStatus(rawCaster, "WITCH_BOLT_CHARGED")
            Osi.RemoveStatus(rawCaster, "WITCH_BOLT_CHARGED_3")
            Osi.RemoveStatus(rawCaster, "WITCH_BOLT_CHARGED_5")
        end
    end)
end

-- -----------------------------------------------------------------------------
-- 3. Turn Progression: Strictly Turn-Start Conduit Shocks & Turn 2 Whip Unlock
-- -----------------------------------------------------------------------------
local function CheckVictimTetherBreak(character)
    if not character then return end
    local rawChar = NormalizeGuid(character)

    for casterKey, tether in pairs(ActiveTethers) do
        if tether and (character == tether.victim or character == tether.rawVictim or rawChar == tether.victim or rawChar == tether.rawVictim) then
            local now = Ext.Utils.MonotonicTime()
            if now - (tether.lastEscapeTime or 0) >= 1500 then
                tether.lastEscapeTime = now
                local caster = tether.caster or tether.rawCaster
                local dc = GetCasterSpellDC(caster)
                local strScore = Osi.GetAbility(character, "Strength") or 10
                local strMod = math.floor((strScore - 10) / 2)
                local d20 = math.random(1, 20)
                local total = d20 + strMod
                local passed = (total >= dc)

                _P(string.format("[%s] Tether Escape Save (STR): Victim %s rolled %d + %d (STR) = %d vs DC %d -> %s",
                    MOD_NAME, tostring(character), d20, strMod, total, dc, passed and "BROKE TETHER" or "TETHER HELD"))

                if passed then
                    pcall(function()
                        Osi.ShowOverheadNotice(character, string.format("STR Save: %d vs DC %d (Tether Broken!)", total, dc))
                        Osi.PlayEffect(character, "5bbedd95-2d56-4974-ab7a-ccfa0a9e36fd", "Root")
                    end)
                    DischargeTether(caster)
                else
                    pcall(function()
                        Osi.ShowOverheadNotice(character, string.format("STR Save: %d vs DC %d (Tether Holds)", total, dc))
                    end)
                end
            end
            break
        end
    end
end

local function OnCharacterTurnStarted(character)
    if not character then return end
    local rawCaster = NormalizeGuid(character)
    local data = ActiveTethers[rawCaster] or ActiveTethers[character]

    if data then
        local now = Ext.Utils.MonotonicTime()
        -- Debounce: ignore multiple turn events fired for the same character within 1.0 second
        if now - (data.lastTurnTime or 0) < 1000 then return end

        data.lastTurnTime = now
        data.turnsInCombat = (data.turnsInCombat or 0) + 1
        data.whipUsedThisTurn = false

        _P(string.format("[%s] Turn %d started for caster %s", MOD_NAME, data.turnsInCombat + 1, tostring(character)))

        -- Turn 2+ (turnsInCombat >= 1): automatic conduit shock & unlock Tether Whip via WITCH_BOLT_CHARGED
        if data.turnsInCombat >= 1 then
            TriggerConduitShock(character, data, "TurnStart")
            local chargedStatus = (data.tier == 3 and "WITCH_BOLT_CHARGED_5") or (data.tier == 2 and "WITCH_BOLT_CHARGED_3") or "WITCH_BOLT_CHARGED"
            pcall(function()
                -- Boosts: UnlockSpell(Target_WitchBolt_Whip) handles hotbar presentation cleanly
                Osi.ApplyStatus(character, chargedStatus, -1.0, 1, character)
                if rawCaster and rawCaster ~= character then
                    Osi.ApplyStatus(rawCaster, chargedStatus, -1.0, 1, rawCaster)
                end
            end)
        end
    end
end

-- Catch Status Applied
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, source, storyActionID)
    if status == "WITCH_BOLT" then
        RegisterTether(target, source, 1)
    elseif status == "WITCH_BOLT_3" then
        RegisterTether(target, source, 2)
    elseif status == "WITCH_BOLT_5" then
        RegisterTether(target, source, 3)
    end
end)

-- Catch Status Removed
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status, source, storyActionID)
    local rawTarget = NormalizeGuid(target)

    -- If caster loses CONCENTRATION status, tether dissolves
    if status == "CONCENTRATION" then
        if ActiveTethers[target] or (rawTarget and ActiveTethers[rawTarget]) then
            _P(string.format("[%s] Tether dissolved: caster %s lost CONCENTRATION", MOD_NAME, tostring(target)))
            DischargeTether(target)
        end
    end
end)

-- If the target dies, immediately dissolve tether
Ext.Osiris.RegisterListener("Died", 1, "after", function(character)
    local rawChar = NormalizeGuid(character)
    for c, data in pairs(ActiveTethers) do
        if data.victim == character or data.rawVictim == rawChar or data.victim == rawChar then
            _P(string.format("[%s] Tether target %s died! Dissolving tether.", MOD_NAME, tostring(character)))
            DischargeTether(c)
            break
        end
    end
end)

-- Turn progression listener (fires in initiative combat)
Ext.Osiris.RegisterListener("TurnStarted", 1, "after", function(character)
    local rawChar = NormalizeGuid(character)
    local data = ActiveTethers[rawChar] or ActiveTethers[character]
    if data and data.hasLeftTurn then
        data.hasLeftTurn = false
        OnCharacterTurnStarted(character)
    end

    -- Check if it is the tethered victim's turn: roll Strength Save vs Caster DC to break the tether!
    CheckVictimTetherBreak(character)
end)

Ext.Osiris.RegisterListener("TurnEnded", 1, "after", function(character)
    local rawChar = NormalizeGuid(character)
    local data = ActiveTethers[rawChar] or ActiveTethers[character]
    if data then
        data.hasLeftTurn = true
        local chargedStatus = (data.tier == 3 and "WITCH_BOLT_CHARGED_5") or (data.tier == 2 and "WITCH_BOLT_CHARGED_3") or "WITCH_BOLT_CHARGED"
        pcall(function()
            Osi.RemoveStatus(character, chargedStatus)
            if rawChar and rawChar ~= character then
                Osi.RemoveStatus(rawChar, chargedStatus)
            end
        end)
    end
end)

-- Turn progression listener (fires when player cycles between party members in turn-based mode)
Ext.Osiris.RegisterListener("GainedControl", 1, "after", function(character)
    local rawChar = NormalizeGuid(character)

    -- If player took control of the tethered victim, roll Strength check to break tether
    CheckVictimTetherBreak(character)

    for casterGuid, data in pairs(ActiveTethers) do
        if data then
            local isCaster = (character == data.caster or character == data.rawCaster or rawChar == data.caster or rawChar == data.rawCaster)
            if not isCaster then
                -- Control moved away to another character (companion, summon, etc.) -> caster finished their turn
                if not data.hasLeftTurn then
                    _P(string.format("[%s] Turn ended for caster %s (control switched to %s)", MOD_NAME, tostring(data.caster), tostring(character)))
                    data.hasLeftTurn = true
                    local chargedStatus = (data.tier == 3 and "WITCH_BOLT_CHARGED_5") or (data.tier == 2 and "WITCH_BOLT_CHARGED_3") or "WITCH_BOLT_CHARGED"
                    pcall(function()
                        Osi.RemoveStatus(data.caster, chargedStatus)
                        if data.rawCaster and data.rawCaster ~= data.caster then
                            Osi.RemoveStatus(data.rawCaster, chargedStatus)
                        end
                    end)
                end
            else
                -- Control returned to the caster!
                if data.hasLeftTurn then
                    _P(string.format("[%s] Turn started for caster %s (control returned to caster)", MOD_NAME, tostring(character)))
                    data.hasLeftTurn = false
                    OnCharacterTurnStarted(character)
                end
            end
        end
    end
end)

local function IsConcentratingOnWitchBolt(character)
    if not character or character == "" then return false end
    local isConc = false
    pcall(function()
        local entity = Ext.Entity.Get(character)
        if not entity then
            local raw = NormalizeGuid(character)
            if raw and raw ~= character then
                entity = Ext.Entity.Get(raw)
            end
        end
        if entity and entity.Concentration and entity.Concentration.SpellId then
            local proto = entity.Concentration.SpellId.Prototype or ""
            local origProto = entity.Concentration.SpellId.OriginatorPrototype or ""
            if proto:find("WitchBolt") or origProto:find("WitchBolt") then
                isConc = true
            end
        end
    end)
    if not isConc then
        pcall(function()
            local raw = NormalizeGuid(character)
            local function checkStatus(c)
                return Osi.HasActiveStatus(c, "WITCH_BOLT_OWNER") == 1 or 
                       Osi.HasActiveStatus(c, "WITCH_BOLT_OWNER_TECHNICAL") == 1 or
                       Osi.HasActiveStatus(c, "WITCH_BOLT_OWNER_3") == 1 or 
                       Osi.HasActiveStatus(c, "WITCH_BOLT_OWNER_5") == 1 or
                       Osi.HasActiveStatus(c, "CONCENTRATION") == 1 or
                       Osi.HasActiveStatus(c, "CHANNEL_ACTIVE") == 1 or
                       Osi.HasActiveStatus(c, "CHANNEL_ACTIVE_COMBAT") == 1
            end
            if checkStatus(character) then
                isConc = true
            elseif raw and raw ~= character and checkStatus(raw) then
                isConc = true
            end
        end)
    end
    return isConc
end

local function GetNearbyCreatures(targetX, targetY, targetZ, maxRadius, excludeList)
    local found = {}
    local seen = {}

    local function checkCandidate(guid)
        if not guid then return end
        local rawGuid = NormalizeGuid(guid)
        if not rawGuid or seen[rawGuid] or seen[guid] then return end
        seen[rawGuid] = true
        seen[guid] = true

        for _, ex in ipairs(excludeList) do
            if ex and (guid == ex or rawGuid == ex or (NormalizeGuid(ex) and rawGuid == NormalizeGuid(ex))) then
                return
            end
        end

        local isDead = false
        pcall(function()
            if Osi.IsDead(guid) == 1 or (rawGuid and Osi.IsDead(rawGuid) == 1) then
                isDead = true
            end
        end)
        if isDead then return end

        local gx, gy, gz = Osi.GetPosition(guid)
        if not gx and rawGuid then
            gx, gy, gz = Osi.GetPosition(rawGuid)
        end

        if gx then
            local dx = targetX - gx
            local dz = targetZ - gz
            local dy = (targetY and gy) and (targetY - gy) or 0
            local dist2D = math.sqrt(dx * dx + dz * dz)
            if dist2D <= maxRadius and math.abs(dy) <= 3.0 then
                table.insert(found, { guid = guid, rawGuid = rawGuid, dist = dist2D })
            end
        end
    end

    -- 1. Query all characters in the game level
    pcall(function()
        local allChars = Osi.DB_IsCharacter:Get(nil)
        if allChars then
            for _, row in ipairs(allChars) do
                checkCandidate(row[1])
            end
        end
    end)

    -- 2. Query combat characters (column 2 is character GUID)
    pcall(function()
        local combatChars = Osi.DB_CombatCharacters:Get(nil, nil)
        if combatChars then
            for _, row in ipairs(combatChars) do
                checkCandidate(row[2])
            end
        end
    end)

    -- 3. Query party members
    pcall(function()
        local party = Osi.DB_PartyMembers:Get(nil)
        if party then
            for _, row in ipairs(party) do
                checkCandidate(row[1])
            end
        end
    end)

    -- Sort candidate creatures closest to landing point first
    table.sort(found, function(a, b) return a.dist < b.dist end)
    return found
end

local function RollBystanderDexSave(target, dc)
    if not target then return false end
    local dexScore = Osi.GetAbility(target, "Dexterity") or 10
    local dexMod = math.floor((dexScore - 10) / 2)
    local d20 = math.random(1, 20)
    local total = d20 + dexMod
    local passed = (total >= dc)

    _P(string.format("[%s] Bystander Dodge Save (DEX): %s rolled %d + %d (DEX) = %d vs DC %d -> %s",
        MOD_NAME, tostring(target), d20, dexMod, total, dc, passed and "SAVED" or "FAILED"))

    if passed then
        pcall(function()
            Osi.ShowOverheadNotice(target, string.format("DEX Save: %d vs DC %d (Dodged Knockdown)", total, dc))
        end)
        return false
    else
        pcall(function()
            Osi.ShowOverheadNotice(target, string.format("DEX Save: %d vs DC %d (Knocked Prone)", total, dc))
            Osi.ApplyStatus(target, "PRONE", 100, 1)
        end)
        return true
    end
end

local function ResolveWhipLanding(fling)
    local victim = fling.victim
    local rawVictim = fling.rawVictim
    local caster = fling.caster
    local rawCaster = fling.rawCaster
    local destX = fling.destX
    local destY = fling.destY
    local destZ = fling.destZ
    local dist = fling.dist
    local cfg = fling.cfg
    local dc = GetCasterSpellDC(caster)

    -- Option B: Victim already failed the Strength save against the whip throw.
    -- On landing impact, victim is automatically knocked Prone from the crash!
    pcall(function()
        Osi.ApplyStatus(victim, "PRONE", 100, 1)
        if rawVictim and rawVictim ~= victim then
            Osi.ApplyStatus(rawVictim, "PRONE", 100, 1)
        end
        Osi.ShowOverheadNotice(victim, "Knocked Prone")
    end)

    -- Search for any creature near the landing spot within 2.4m (excluding victim & caster)
    local candidates = GetNearbyCreatures(destX, destY, destZ, 2.4, { victim, rawVictim, caster, rawCaster })
    local struckCreature = candidates[1] and candidates[1].guid

    -- If target slammed into another creature:
    if struckCreature then
        local dmg, rolls = RollDice(cfg.diceCount, cfg.diceSides)
        local rollBreakdown = table.concat(rolls, "+")
        _P(string.format("[%s] Kinetic Collision! Victim %s smashed into %s for %d Bludgeoning damage (%dd%d: [%s]).",
            MOD_NAME, tostring(victim), tostring(struckCreature), dmg, cfg.diceCount, cfg.diceSides, rollBreakdown))

        Osi.ApplyDamage(victim, dmg, "Bludgeoning", caster)
        Osi.ApplyDamage(struckCreature, dmg, "Bludgeoning", caster)
        pcall(function()
            Osi.ShowOverheadNotice(victim, string.format("Whip Collision: %d Bludgeoning (%dd%d: %s)", dmg, cfg.diceCount, cfg.diceSides, rollBreakdown))
            Osi.ShowOverheadNotice(struckCreature, string.format("Slammed: %d Bludgeoning (%dd%d: %s)", dmg, cfg.diceCount, cfg.diceSides, rollBreakdown))
            Osi.PlayEffect(struckCreature, "5bbedd95-2d56-4974-ab7a-ccfa0a9e36fd", "Root")
        end)

        -- The struck bystander makes a Dexterity Saving Throw vs Caster DC to avoid being knocked down
        RollBystanderDexSave(struckCreature, dc)
    else
        -- Kinetic impact on ground/wall
        if dist >= 1.0 then
            local dmg, rolls = RollDice(cfg.diceCount, cfg.diceSides)
            local rollBreakdown = table.concat(rolls, "+")
            _P(string.format("[%s] Kinetic Ground Impact! Victim %s took %d Bludgeoning damage (%dd%d: [%s]).",
                MOD_NAME, tostring(victim), dmg, cfg.diceCount, cfg.diceSides, rollBreakdown))
            Osi.ApplyDamage(victim, dmg, "Bludgeoning", caster)
            pcall(function()
                Osi.ShowOverheadNotice(victim, string.format("Whip Impact: %d Bludgeoning (%dd%d: %s)", dmg, cfg.diceCount, cfg.diceSides, rollBreakdown))
            end)
        end
    end
end

-- -----------------------------------------------------------------------------
-- 4. Tether Lifecycle & Distance Guardian (Purely range and concentration safety)
-- -----------------------------------------------------------------------------
Ext.Events.Tick:Subscribe(function()
    local now = Ext.Utils.MonotonicTime()

    -- 1. Process active in-flight kinetic whip flings (smooth airborne arc)
    if #ActiveFlings > 0 then
        local remainingFlings = {}
        for _, fling in ipairs(ActiveFlings) do
            local elapsed = now - fling.startTime
            local progress = elapsed / fling.duration

            if progress < 1.0 then
                -- Interpolate horizontal position (X, Z) and baseline height (Y)
                local curX = fling.startX + (fling.destX - fling.startX) * progress
                local curZ = fling.startZ + (fling.destZ - fling.startZ) * progress
                local baseHeight = fling.startY + (fling.destY - fling.startY) * progress
                -- Parabolic arc in the air!
                local arcY = baseHeight + math.sin(progress * math.pi) * fling.maxApex

                pcall(function()
                    Osi.TeleportToPosition(fling.victim, curX, arcY, curZ, "", 1, 0, 1, 0, 0)
                    if fling.rawVictim and fling.rawVictim ~= fling.victim then
                        Osi.TeleportToPosition(fling.rawVictim, curX, arcY, curZ, "", 1, 0, 1, 0, 0)
                    end
                end)
                table.insert(remainingFlings, fling)
            else
                -- Landing impact: Snap firmly to ground mesh with impact effects!
                pcall(function()
                    Osi.TeleportToPosition(fling.victim, fling.destX, fling.destY, fling.destZ, "", 1, 0, 1, 0, 1)
                    if fling.rawVictim and fling.rawVictim ~= fling.victim then
                        Osi.TeleportToPosition(fling.rawVictim, fling.destX, fling.destY, fling.destZ, "", 1, 0, 1, 0, 1)
                    end
                    Osi.PlayEffect(fling.victim, "5bbedd95-2d56-4974-ab7a-ccfa0a9e36fd", "Root")
                    Osi.PlayAnimation(fling.victim, "knockdown_land")
                end)
                ResolveWhipLanding(fling)
            end
        end
        ActiveFlings = remainingFlings
    end

    if next(ActiveTethers) == nil then return end

    local toDischarge = {}
    local visited = {}

    for casterKey, data in pairs(ActiveTethers) do
        local primaryCaster = data.rawCaster or NormalizeGuid(casterKey)
        if not visited[primaryCaster] and data and data.victim then
            visited[primaryCaster] = true

            -- 1. Check concentration (after 2s grace period from cast)
            if now - (data.establishedTime or 0) > 2000 then
                local concActive = IsConcentratingOnWitchBolt(data.caster)
                if not concActive and data.rawCaster then
                    concActive = IsConcentratingOnWitchBolt(data.rawCaster)
                end
                if not concActive then
                    _P(string.format("[%s] Tether broken: caster %s is no longer concentrating on Witch Bolt.", MOD_NAME, tostring(data.caster)))
                    table.insert(toDischarge, primaryCaster)
                    goto continue
                end
            end

            -- 2. Check if victim is dead
            if Osi.IsDead(data.victim) == 1 or (data.rawVictim and Osi.IsDead(data.rawVictim) == 1) then
                _P(string.format("[%s] Tether broken: victim %s is dead.", MOD_NAME, tostring(data.victim)))
                table.insert(toDischarge, primaryCaster)
                goto continue
            end

            -- 3. Check distance (max 24.0m limit - generous combat tolerance)
            local cx, cy, cz = Osi.GetPosition(data.caster)
            if not cx and data.rawCaster then
                cx, cy, cz = Osi.GetPosition(data.rawCaster)
            end
            local vx, vy, vz = Osi.GetPosition(data.victim)
            if not vx and data.rawVictim then
                vx, vy, vz = Osi.GetPosition(data.rawVictim)
            end
            if cx and vx then
                local dx = cx - vx
                local dy = cy - vy
                local dz = cz - vz
                local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
                if dist > 24.0 then
                    _P(string.format("[%s] Tether broken: distance %.2fm exceeds 24.0m limit.", MOD_NAME, dist))
                    table.insert(toDischarge, primaryCaster)
                    goto continue
                end
            end
        end
        ::continue::
    end

    for _, caster in ipairs(toDischarge) do
        DischargeTether(caster)
    end
end)

-- -----------------------------------------------------------------------------
-- 5. Whipping & Kinetic Collision Resolution
-- -----------------------------------------------------------------------------
local function GetTetherVictim(caster)
    local rawCaster = NormalizeGuid(caster)
    local data = ActiveTethers[rawCaster] or ActiveTethers[caster]
    if data then
        return data.victim, data.tier, data.rawVictim
    end
    return nil, 1, nil
end

local function HandleTetherWhip(caster, targetX, targetY, targetZ, spell)
    local ok, err = pcall(function()
        local rawCaster = NormalizeGuid(caster)
        local data = ActiveTethers[rawCaster] or ActiveTethers[caster]
        if not data or (data.turnsInCombat or 0) < 1 then
            _P(string.format("[%s] Whip rejected: Tether Whip cannot be used on Turn 1 (turnsInCombat=%d)",
                MOD_NAME, data and data.turnsInCombat or 0))
            return
        end

        if data.whipUsedThisTurn then
            _P(string.format("[%s] Whip rejected: Tether Whip has already been used this turn.", MOD_NAME))
            return
        end

        local victim, tier, rawVictim = GetTetherVictim(caster)
        if not victim or Osi.IsDead(victim) == 1 then
            _P(string.format("[%s] Whip aborted: No active tethered victim found for caster %s", MOD_NAME, tostring(caster)))
            return
        end

        local cfg = TIER_CONFIG[tier] or TIER_CONFIG[1]
        local vx, vy, vz = Osi.GetPosition(victim)
        if not vx and rawVictim then
            vx, vy, vz = Osi.GetPosition(rawVictim)
        end
        if not vx then
            _P(string.format("[%s] Whip aborted: could not resolve position for victim %s", MOD_NAME, tostring(victim)))
            return
        end

        local cx, cy, cz = Osi.GetPosition(caster)
        if not cx and rawCaster then
            cx, cy, cz = Osi.GetPosition(rawCaster)
        end

        data.whipUsedThisTurn = true

        -- Immediately consume whip: remove charged status for remainder of turn
        local chargedStatus = (data.tier == 3 and "WITCH_BOLT_CHARGED_5") or (data.tier == 2 and "WITCH_BOLT_CHARGED_3") or "WITCH_BOLT_CHARGED"
        pcall(function()
            Osi.RemoveStatus(caster, chargedStatus)
            if rawCaster and rawCaster ~= caster then
                Osi.RemoveStatus(rawCaster, chargedStatus)
            end
        end)

        -- Option B: Victim makes a Strength Saving Throw vs Caster's Spell DC to resist being thrown!
        local dc = GetCasterSpellDC(caster)
        local strScore = Osi.GetAbility(victim, "Strength") or 10
        local strMod = math.floor((strScore - 10) / 2)
        local d20 = math.random(1, 20)
        local total = d20 + strMod
        local passed = (total >= dc)

        _P(string.format("[%s] Tether Whip Save (STR): Victim %s rolled %d + %d (STR) = %d vs DC %d -> %s",
            MOD_NAME, tostring(victim), d20, strMod, total, dc, passed and "RESISTED WHIP" or "FAILED (FLUNG)"))

        if passed then
            pcall(function()
                Osi.ShowOverheadNotice(victim, string.format("STR Save: %d vs DC %d (Resisted Whip!)", total, dc))
                Osi.PlayEffect(victim, "5bbedd95-2d56-4974-ab7a-ccfa0a9e36fd", "Root")
            end)
            return
        else
            pcall(function()
                Osi.ShowOverheadNotice(victim, string.format("STR Save: %d vs DC %d (Whip Caught!)", total, dc))
            end)
        end

        local dx = targetX - vx
        local dz = targetZ - vz
        local dist = math.sqrt(dx * dx + dz * dz)

        -- 1. Clamping to maximum allowed throw distance relative to victim
        local destX = targetX
        local destZ = targetZ
        local destY = targetY or vy
        if dist > cfg.maxDist and dist > 0.001 then
            local ratio = cfg.maxDist / dist
            destX = vx + dx * ratio
            destZ = vz + dz * ratio
        end

        -- 2. Clamping relative to caster: ensure victim never lands beyond 18.0m from the caster
        if cx then
            local cdx = destX - cx
            local cdz = destZ - cz
            local cdist = math.sqrt(cdx * cdx + cdz * cdz)
            local MAX_TETHER_RADIUS = 18.0
            if cdist > MAX_TETHER_RADIUS and cdist > 0.001 then
                local cratio = MAX_TETHER_RADIUS / cdist
                destX = cx + cdx * cratio
                destZ = cz + cdz * cratio
            end
        end

        _P(string.format("[%s] Tether Whip launching: Victim %s flinging from (%.2f, %.2f) to (%.2f, %.2f) [Dist: %.2fm, Max: %.2fm]",
            MOD_NAME, tostring(victim), vx, vz, destX, destZ, dist, cfg.maxDist))

        -- Visual & Audio at launch: crack of lightning surge & victim thrown airborne
        pcall(function()
            Osi.PlayEffect(victim, "5bbedd95-2d56-4974-ab7a-ccfa0a9e36fd", "Root")
            Osi.PlayAnimation(victim, "knockdown_fall")
        end)

        -- Queue flight trajectory in ActiveFlings
        local flingData = {
            victim = victim,
            rawVictim = rawVictim,
            caster = caster,
            rawCaster = rawCaster,
            startX = vx,
            startY = vy,
            startZ = vz,
            destX = destX,
            destY = destY,
            destZ = destZ,
            dist = dist,
            cfg = cfg,
            startTime = Ext.Utils.MonotonicTime(),
            duration = 280, -- 280ms swift violent arc
            maxApex = math.min(2.5, 0.7 + dist * 0.3)
        }
        table.insert(ActiveFlings, flingData)
    end)
    if not ok then
        _P(string.format("[%s] Error in HandleTetherWhip: %s", MOD_NAME, tostring(err)))
    end
end

-- Catch the Whip Cast
Ext.Osiris.RegisterListener("UsingSpellAtPosition", 8, "after", function(caster, targetX, targetY, targetZ, spell, spellType, spellElement, storyActionID)
    if spell and spell:find("^Target_WitchBolt_Whip") then
        _P(string.format("[%s] UsingSpellAtPosition: %s cast by %s at (%.2f, %.2f, %.2f)",
            MOD_NAME, spell, tostring(caster), targetX or 0, targetY or 0, targetZ or 0))
        HandleTetherWhip(caster, targetX, targetY, targetZ, spell)
    end
end)

_P(string.format("[%s] Kinetic Witch Bolt Server Engine loaded successfully.", MOD_NAME))
