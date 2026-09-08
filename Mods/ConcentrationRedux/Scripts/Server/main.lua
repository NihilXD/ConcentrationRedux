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
    ["WarPriest"] = true,               -- War Domain Cleric (Level 1)
    ["WrathOfTheStorm"] = true,          -- Tempest Domain Cleric (Level 1)
    ["Combat_Channeling_Active"] = true,
    
    -- Monk (Level 1+: Core mental discipline and Ki flow)
    ["UnarmoredDefense_Monk"] = true,
    ["MartialArts_Mastery"] = true,
    ["MartialArts_UnarmedDamage"] = true,
    ["MartialArts_BonusUnarmedStrike"] = true,
    ["Ki_Passive"] = true,
    
    -- Paladin (Level 2+ only: Unlocked with Divine Smite & Spellcasting)
    ["DivineSmite"] = true,
    ["Paladin_Spellcasting"] = true,
    
    -- Ranger (Level 2+ only: Unlocked with Ranger Spellcasting)
    ["Ranger_Spellcasting"] = true,
    
    -- Eldritch Knight Fighter (Level 3+ subclass)
    ["WeaponBond"] = true,
    ["WarMagic"] = true,
    ["EldritchStrike"] = true,
    ["EldritchKnight_Spellcasting"] = true,
    
    -- Arcane Trickster Rogue (Level 3+ subclass)
    ["MageHandLegerdemain"] = true,
    ["MageHand_Legerdemain"] = true,
    ["ArcaneTrickster_Spellcasting"] = true,
    ["MagicalAmbush"] = true,
    
    -- Bladesinger Wizard (Level 2+ subclass)
    ["Bladesong"] = true,
    ["Bladesong_Passive"] = true,
    ["Bladesinger"] = true,
    ["Bladesinger_Training"] = true,
    ["TrainingInWarAndSong"] = true,
    ["Bladesinger_Bladesong"] = true,
    ["Bladesong_ExtraAttack"] = true,
    
    -- Bard: College of Swords & College of Valour (Level 3+ subclasses)
    ["Bard_CollegeOfSwords"] = true,
    ["BladeFlourish"] = true,
    ["SlashingFlourish"] = true,
    ["DefensiveFlourish"] = true,
    ["MobileFlourish"] = true,
    ["Bard_CollegeOfValour"] = true,
    ["CombatInspiration"] = true,
    
    -- Warlock: Pact of the Blade & Hexblade (Level 3+ / Melee Warlock)
    ["PactOfTheBlade"] = true,
    ["Warlock_PactOfTheBlade"] = true,
    ["PactOfTheBlade_ExtraAttack"] = true,
    ["Hexblade"] = true,
    ["Hex_Warrior"] = true,
    ["Hexblade_Curse"] = true,
    
    -- Druid: Circle of Spores (Level 2+ subclass)
    ["CircleOfTheSpores"] = true,
    ["HaloOfSpores"] = true,
    ["SymbioticEntity"] = true
}

local GISH_TAGS = {
    "MONK_e1e460bb-d0ae-4452-8529-c9e176558731"
}

-- Whitelisted actions that NEVER disrupt an active channel
local WHITELISTED_ACTIONS = {
    -- Dodge
    ["Action_Dodge"] = true,
    ["Shout_Dodge"] = true,
    ["Shout_PatientDefense"] = true,

    -- Jump (physical jump vs transmutation spell Enhance Leap Target_Jump)
    ["Jump"] = true,
    ["Cast_Jump"] = true,
    ["Projectile_Jump"] = true,
    ["Projectile_Jump_Monk"] = true,

    -- Dash
    ["Dash"] = true,
    ["Shout_Dash"] = true,
    ["Shout_Dash_BonusAction"] = true,
    ["Shout_CunningAction_Dash"] = true,
    ["Shout_ActionSurge_Dash"] = true,
    ["Shout_StepOfTheWind_Dash"] = true,
    ["Shout_Dash_ExpeditiousRetreat"] = true,

    -- Hide / Crouch / Stealth
    ["Action_Hide"] = true,
    ["Shout_Hide"] = true,
    ["Shout_Hide_BonusAction"] = true,
    ["Shout_CunningAction_Hide"] = true,

    -- Disengage
    ["Disengage"] = true,
    ["Shout_Disengage"] = true,
    ["Shout_Disengage_BonusAction"] = true,
    ["Shout_CunningAction_Disengage"] = true,
    ["Shout_StepOfTheWind_Disengage"] = true,

    -- Shove
    ["Shove"] = true,
    ["Target_Shove"] = true,
    ["Target_Shove_BonusAction"] = true,

    -- Dip
    ["Dip"] = true,
    ["Shout_Dip"] = true,
    ["Shout_Dip_BonusAction"] = true,

    -- Throw
    ["Throw"] = true,
    ["Throw_Throw"] = true,
    ["Throw_FrenziedThrow"] = true,
    ["Target_Throw"] = true,
    ["Projectile_Throw"] = true,

    -- Help
    ["Help"] = true,
    ["Action_Help"] = true,
    ["Target_Help"] = true,

    -- Potions & Consumables
    ["UsePotion"] = true,
    ["DrinkPotion"] = true,
    ["UseConsumable"] = true,
    ["Use_Potion"] = true,
    ["Drink_Potion"] = true,
    ["Use_Consumable"] = true,
    ["Shout_DrinkPotion"] = true,

    -- Martial utilities & Turn actions
    ["Shout_SecondWind"] = true,
    ["Shout_ActionSurge"] = true,
    ["Shout_ShortRest"] = true,
    ["Action_EndTurn"] = true,

    -- Gish stances & class features (never break concentration)
    ["Shout_Bladesong"] = true,
    ["Shout_Bladesong_End"] = true,
    ["Shout_Bladesong_Activate"] = true,
    ["Shout_ActivateBladesong"] = true,
    ["Shout_SymbioticEntity"] = true,
    ["Shout_WildShape_Spore"] = true,
    ["Shout_BindPactWeapon"] = true,
    ["Target_BindPactWeapon"] = true,
    ["Target_HexbladeCurse"] = true,
    ["Shout_WeaponBond"] = true,
    ["Target_WeaponBond"] = true,
    ["Shout_WholenessOfBody"] = true,

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

local function IsGishStanceOrFeature(spell)
    if not spell then return false end
    local lower = spell:lower()
    
    -- Bladesinger Wizard: Bladesong activation and dismissal
    if lower:find("bladesong") or lower:find("blade_song") then
        return true
    end
    
    -- Circle of Spores Druid: Symbiotic Entity / Spore Wildshape
    if lower:find("symbioticentity") or lower:find("symbiotic_entity") or lower:find("wildshape_spore") then
        return true
    end
    
    -- Warlock: Pact of the Blade & Hexblade stances
    if lower:find("bindpactweapon") or lower:find("bind_pact_weapon") or lower:find("pactweapon") or lower:find("pact_weapon")
       or lower:find("hexblade") or lower:find("hex_warrior") then
        return true
    end
    
    -- Fighter: Eldritch Knight Weapon Bond
    if lower:find("weaponbond") or lower:find("weapon_bond") then
        return true
    end
    
    -- Monk Ki stances and disciplines
    if lower:find("stepofthewind") or lower:find("step_of_the_wind")
       or lower:find("patientdefense") or lower:find("patient_defense")
       or lower:find("wholenessofbody") or lower:find("wholeness_of_body")
       or lower:find("deflectmissiles") or lower:find("deflect_missiles")
       or lower:find("kiresonation") or lower:find("harmonyoffireandwater") then
        return true
    end
    
    -- Bard: Bardic / Combat Inspiration & Flourishes
    if lower:find("bladeflourish") or lower:find("blade_flourish")
       or lower:find("bardicinspiration") or lower:find("bardic_inspiration")
       or lower:find("combinspiration") or lower:find("combat_inspiration") then
        return true
    end
    
    -- Channel Divinity (Martial & Gish Subclasses)
    if lower:find("guidedstrike") or lower:find("guided_strike") or lower:find("wargod")
       or lower:find("destructivewrath") or lower:find("destructive_wrath")
       or lower:find("sacredweapon") or lower:find("sacred_weapon")
       or lower:find("vowofenmity") or lower:find("vow_of_enmity")
       or lower:find("nature_wrath") or lower:find("turnundead") then
        return true
    end
    
    -- Battle Master Maneuvers & Martial Stances
    if lower:find("maneuver") or lower:find("rally") or lower:find("evasivefootwork") or lower:find("parry") or lower:find("riposte") then
        return true
    end

    -- Rogue / Arcane Trickster: Cunning Actions
    if lower:find("cunningaction") or lower:find("cunning_action") or lower:find("sneakattack") then
        return true
    end
    
    return false
end

local function IsWhitelistedAction(spell)
    if not spell then return false end
    if WHITELISTED_ACTIONS[spell] then return true end
    if IsGishStanceOrFeature(spell) then return true end
    
    local lower = spell:lower()
    
    -- Movement & Tactical stances
    if lower == "projectile_jump" or lower:find("projectile_jump") then return true end
    if lower:find("dash") then return true end
    if lower:find("hide") or lower:find("stealth") or lower:find("crouch") then return true end
    if lower:find("disengage") then return true end
    if lower:find("shove") then return true end
    if lower:find("dip") then return true end
    if lower:find("throw") then return true end
    if lower:find("help") then return true end
    if lower:find("dodge") or lower:find("patientdefense") then return true end
    if lower:find("secondwind") or lower:find("actionsurge") then return true end
    if lower:find("reapply") or lower:find("reactivate") then return true end
    if lower:find("dismiss") then return true end
    if lower:find("potion") or lower:find("drink") or lower:find("consumable") then return true end
    
    return false
end

-- Mapping of Innate spells to their isolated target status
local INNATE_SPELLS = {
    ["Target_Bless"] = { Status = "INNATE_BUFF_BLESS" },
    ["Target_Bless_2"] = { Status = "INNATE_BUFF_BLESS" },
    ["Target_Bless_3"] = { Status = "INNATE_BUFF_BLESS" },
    ["Target_Bless_4"] = { Status = "INNATE_BUFF_BLESS" },
    ["Target_Bless_5"] = { Status = "INNATE_BUFF_BLESS" },
    ["Target_Bless_6"] = { Status = "INNATE_BUFF_BLESS" },
    ["Target_ShieldOfFaith"] = { Status = "INNATE_BUFF_SHIELD_OF_FAITH" },
    ["Target_Guidance"] = { Status = "INNATE_BUFF_GUIDANCE" },
    ["Target_Resistance"] = { Status = "INNATE_BUFF_RESISTANCE" },
    ["Shout_BladeWard"] = { Status = "INNATE_BUFF_BLADE_WARD" },
    ["Target_BladeWard"] = { Status = "INNATE_BUFF_BLADE_WARD" },
    ["Target_DancingLights"] = { Status = "INNATE_BUFF_DANCING_LIGHTS" },
    ["Target_DancingLights_DeepRothe"] = { Status = "INNATE_BUFF_DANCING_LIGHTS" },
    ["Target_Friends"] = { Status = "INNATE_BUFF_FRIENDS" },
    ["Target_Heroism"] = { Status = "INNATE_BUFF_HEROISM" },
    ["Target_Heroism_2"] = { Status = "INNATE_BUFF_HEROISM" },
    ["Target_Heroism_3"] = { Status = "INNATE_BUFF_HEROISM" },
    ["Target_Heroism_4"] = { Status = "INNATE_BUFF_HEROISM" },
    ["Target_Heroism_5"] = { Status = "INNATE_BUFF_HEROISM" },
    ["Target_Heroism_6"] = { Status = "INNATE_BUFF_HEROISM" },
    ["Target_ProtectionFromEvilAndGood"] = { Status = "INNATE_BUFF_PROTECTION_FROM_EVIL_AND_GOOD" },
    ["Target_Barkskin"] = { Status = "INNATE_BUFF_BARKSKIN" },
    ["Target_Stoneskin"] = { Status = "INNATE_BUFF_STONESKIN" },
    ["Target_EnlargeReduce"] = { Status = "INNATE_BUFF_ENLARGE" },
    ["Target_EnlargeReduce_Enlarge"] = { Status = "INNATE_BUFF_ENLARGE" },
    ["Target_EnlargeReduce_Reduce"] = { Status = "INNATE_BUFF_REDUCE" },
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

local function HasCombatChanneling(character)
    if not character then return false end
    
    -- 1. Check inherent domain & martial passives
    for passive, _ in pairs(COMBAT_PASSIVES) do
        if Osi.HasPassive(character, passive) == 1 then
            return true
        end
    end
    
    -- 2. Check gish class tags via Osiris (Monk)
    for _, tag in ipairs(GISH_TAGS) do
        local isT = false
        pcall(function()
            if Osi.IsTagged(character, tag) == 1 then
                isT = true
            elseif type(character) == "string" then
                local rawUuid = character:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
                if rawUuid and rawUuid ~= character and Osi.IsTagged(rawUuid, tag) == 1 then
                    isT = true
                end
            end
        end)
        if isT then return true end
    end
    
    -- 3. Check BG3SE entity classes component
    local isGish = false
    pcall(function()
        local entity = GetEntitySafe(character)
        if entity and entity.Classes and entity.Classes.Classes then
            for _, cl in ipairs(entity.Classes.Classes) do
                local clsStr = tostring(cl.Class or ""):lower()
                local subStr = tostring(cl.SubClass or ""):lower()
                local lvl = tonumber(cl.Level or 0) or 0
                
                -- Monk: all Monks starting at Level 1 (core discipline & mental focus)
                if clsStr:find("monk") or clsStr:find("e8f1e007") then
                    if lvl >= 1 then
                        isGish = true
                        return
                    end
                end
                
                -- Paladin: hybrid gish starting at Level 2 (when spellcasting unlocks; level 1 is mundane)
                if clsStr:find("paladin") or clsStr:find("ff4d9430") then
                    if lvl >= 2 then
                        isGish = true
                        return
                    end
                end
                
                -- Ranger: hybrid gish starting at Level 2 (when spellcasting unlocks; level 1 is mundane)
                if clsStr:find("ranger") or clsStr:find("0fc3e11f") or clsStr:find("36e29d61") then
                    if lvl >= 2 then
                        isGish = true
                        return
                    end
                end
                
                -- Fighter: only Eldritch Knight (Level 3+ subclass)
                if clsStr:find("fighter") or clsStr:find("72764536") then
                    if subStr:find("eldritch") or subStr:find("e504cd60") or subStr:find("b764b8a7") then
                        isGish = true
                        return
                    end
                end
                
                -- Rogue: only Arcane Trickster (Level 3+ subclass)
                if clsStr:find("rogue") or clsStr:find("e8b01031") then
                    if subStr:find("trickster") or subStr:find("b886f452") or subStr:find("arcane") then
                        isGish = true
                        return
                    end
                end
                
                -- Wizard: only Bladesinger subclass
                if clsStr:find("wizard") or clsStr:find("a86596d0") then
                    if subStr:find("bladesing") or subStr:find("blade_sing") then
                        isGish = true
                        return
                    end
                end
                
                -- Bard: College of Swords or College of Valour (Level 3+ subclasses)
                if clsStr:find("bard") or clsStr:find("92cdc989") then
                    if subStr:find("sword") or subStr:find("d1c015ae") 
                       or subStr:find("valour") or subStr:find("valor") or subStr:find("2b46330c") then
                        isGish = true
                        return
                    end
                end
                
                -- Druid: Circle of Spores (Level 2+ subclass)
                if clsStr:find("druid") or clsStr:find("457e0b4e") then
                    if subStr:find("spore") or subStr:find("4b60434f") then
                        if lvl >= 2 then
                            isGish = true
                            return
                        end
                    end
                end
                
                -- Catch-all for custom Bladesinger classes/subclasses
                if subStr:find("bladesing") or clsStr:find("bladesing") then
                    isGish = true
                    return
                end
            end
        end
    end)
    if isGish then return true end
    
    -- 4. Check active gish engine statuses (Bladesong, Bound Pact Blade, Symbiotic Entity, Hexblade)
    local hasGishStatus = false
    pcall(function()
        if Osi.HasActiveStatus(character, "BLADESONG") == 1 or Osi.HasActiveStatus(character, "BLADESONG_ACTIVE") == 1
           or Osi.HasActiveStatus(character, "PACT_BLADE") == 1 or Osi.HasActiveStatus(character, "PACT_BLADE_OWNER") == 1
           or Osi.HasActiveStatus(character, "SYMBIOTIC_ENTITY") == 1
           or Osi.HasActiveStatus(character, "MAG_HEXBLADE_HEX") == 1 then
            hasGishStatus = true
        elseif type(character) == "string" then
            local rawUuid = character:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
            if rawUuid and rawUuid ~= character then
                if Osi.HasActiveStatus(rawUuid, "BLADESONG") == 1 or Osi.HasActiveStatus(rawUuid, "BLADESONG_ACTIVE") == 1
                   or Osi.HasActiveStatus(rawUuid, "PACT_BLADE") == 1 or Osi.HasActiveStatus(rawUuid, "PACT_BLADE_OWNER") == 1
                   or Osi.HasActiveStatus(rawUuid, "SYMBIOTIC_ENTITY") == 1
                   or Osi.HasActiveStatus(rawUuid, "MAG_HEXBLADE_HEX") == 1 then
                    hasGishStatus = true
                end
            end
        end
    end)
    if hasGishStatus then return true end
    
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

local CONC_TRACKER_STATUS = "ACTIVE_CONCENTRATION_TRACKER"

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
    if not isConc then
        pcall(function()
            if Osi.HasActiveStatus(character, "CONCENTRATION") == 1 or Osi.HasActiveStatus(character, CONC_TRACKER_STATUS) == 1 then
                isConc = true
            elseif type(character) == "string" then
                local raw = character:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
                if raw and raw ~= character and (Osi.HasActiveStatus(raw, "CONCENTRATION") == 1 or Osi.HasActiveStatus(raw, CONC_TRACKER_STATUS) == 1) then
                    isConc = true
                end
            end
        end)
    end
    return isConc
end

local function BreakCharacterConcentration(character)
    if not character or character == "" then return end
    pcall(function() Osi.ApplyStatus(character, "AI_HELPER_BREAKCONCENTRATION", 0.1, 1) end)
    pcall(function() Osi.PROC_GLO_BreakConcentration(character) end)
    pcall(function() Osi.RemoveStatus(character, "CONCENTRATION") end)
    pcall(function() Osi.RemoveStatus(character, CONC_TRACKER_STATUS) end)
    
    if type(character) == "string" then
        local rawUuid = character:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
        if rawUuid and rawUuid ~= character then
            pcall(function() Osi.ApplyStatus(rawUuid, "AI_HELPER_BREAKCONCENTRATION", 0.1, 1) end)
            pcall(function() Osi.PROC_GLO_BreakConcentration(rawUuid) end)
            pcall(function() Osi.RemoveStatus(rawUuid, "CONCENTRATION") end)
            pcall(function() Osi.RemoveStatus(rawUuid, CONC_TRACKER_STATUS) end)
        end
    end
end

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

local function IsValidEntity(targetGuid)
    if not targetGuid or targetGuid == "" then return false end
    local valid = false
    pcall(function()
        local entity = Ext.Entity.Get(targetGuid)
        if entity ~= nil then
            valid = true
        end
    end)
    return valid
end

local function CleanUpInnateBuffs(caster)
    local info, realKey = GetActiveInnateCasterInfo(caster)
    if info and info.Targets then
        for target, _ in pairs(info.Targets) do
            if IsValidEntity(target) then
                if info.Status and Osi.HasActiveStatus(target, info.Status) == 1 then
                    Osi.RemoveStatus(target, info.Status)
                end
                if info.Status == "INNATE_BUFF_DANCING_LIGHTS" then
                    pcall(function() Osi.Die(target) end)
                end
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

-- ==============================================================================
-- Haste Channel Tracking (Channel Spell with Conditional Lethargy)
-- ==============================================================================
local ActiveHasteChannels = {}        -- [casterUuid] = { Targets = { [targetUuid] = true } }
local HasteTargetToCaster = {}        -- [targetUuid] = casterUuid
local LastDamageTimes = {}            -- [charUuid] = monotonic_timestamp
local VoluntaryInterruptionTimes = {} -- [charUuid] = monotonic_timestamp
local InvoluntaryDisruptionTimes = {} -- [charUuid] = monotonic_timestamp
local PendingHasteCaster = nil
local PendingHasteTime = 0

local function ResolveHasteTermination(caster, target)
    local rawCaster = nil
    if caster and caster ~= "" then
        rawCaster = caster:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or caster
    end
    local hasteInfo = nil
    if rawCaster then
        hasteInfo = ActiveHasteChannels[rawCaster] or ActiveHasteChannels[caster]
    end
    local singleTarget = nil
    if target and target ~= "" then
        singleTarget = target:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or target
        if not hasteInfo then
            local mappedCaster = HasteTargetToCaster[singleTarget] or HasteTargetToCaster[target]
            if mappedCaster then
                rawCaster = mappedCaster
                hasteInfo = ActiveHasteChannels[rawCaster] or ActiveHasteChannels[mappedCaster]
            end
        end
    end
    
    if not hasteInfo then return end
    
    local now = Ext.Utils.MonotonicTime()
    local lastDmg = 0
    local lastVol = 0
    local lastInvol = 0
    if rawCaster then
        lastDmg = LastDamageTimes[rawCaster] or (caster and LastDamageTimes[caster]) or 0
        lastVol = VoluntaryInterruptionTimes[rawCaster] or (caster and VoluntaryInterruptionTimes[caster]) or 0
        lastInvol = InvoluntaryDisruptionTimes[rawCaster] or (caster and InvoluntaryDisruptionTimes[caster]) or 0
    end
    
    local tookRecentDamage = (now - lastDmg < 1200)
    local wasVoluntary = (now - lastVol < 1200)
    local wasIncapacitated = (now - lastInvol < 1500)
    if not wasIncapacitated and rawCaster then
        pcall(function()
            if Osi.HasActiveStatus(rawCaster, "DOWNED") == 1 or Osi.HasActiveStatus(rawCaster, "DEAD") == 1 then
                wasIncapacitated = true
            end
        end)
    end
    
    local isViolentDisruption = (tookRecentDamage or wasIncapacitated) and not wasVoluntary
    
    -- Case A: Single Target Expiration (e.g. Twinned Haste ally 10-turn expiration or single-target dispel)
    -- When 'caster' is nil, 'target' is specified, and the caster is still actively concentrating with other targets!
    if not caster and singleTarget and hasteInfo.Targets then
        local terminateTarget = singleTarget
        if hasteInfo.Targets[terminateTarget] or hasteInfo.Targets[target] then
            hasteInfo.Targets[terminateTarget] = nil
            hasteInfo.Targets[target] = nil
            HasteTargetToCaster[terminateTarget] = nil
            HasteTargetToCaster[target] = nil
            
            local isValid = IsValidEntity(target) or IsValidEntity(terminateTarget)
            if isValid then
                pcall(function()
                    if Osi.HasActiveStatus(target, "CHANNEL_HASTE") == 1 then Osi.RemoveStatus(target, "CHANNEL_HASTE") end
                    if Osi.HasActiveStatus(target, "CHANNEL_HASTE_ALLY") == 1 then Osi.RemoveStatus(target, "CHANNEL_HASTE_ALLY") end
                    if Osi.HasActiveStatus(target, "INNATE_BUFF_HASTE") == 1 then Osi.RemoveStatus(target, "INNATE_BUFF_HASTE") end
                end)
                
                if isViolentDisruption then
                    Ext.Utils.Print(string.format("[%s] Haste ended on %s via disruption! Applying Lethargy (Dmg: %s, CC: %s)", 
                        MOD_NAME, tostring(target), tostring(tookRecentDamage), tostring(wasIncapacitated)))
                    pcall(function()
                        Osi.ApplyStatus(target, "HASTE_LETHARGY", 6.0, 1)
                        if wasIncapacitated then
                            Osi.ShowOverheadNotice(target, "Lethargic! (Incapacitated Disruption)")
                        else
                            Osi.ShowOverheadNotice(target, "Lethargic! (Damage Disruption)")
                        end
                    end)
                else
                    Ext.Utils.Print(string.format("[%s] Haste ended on %s safely. No Lethargy applied.", MOD_NAME, tostring(target)))
                    pcall(function()
                        Osi.ShowOverheadNotice(target, "Haste Ended (Safe Release)")
                    end)
                end
            else
                Ext.Utils.Print(string.format("[%s] Pruned annihilated/chasm entity %s from Haste targets", MOD_NAME, tostring(target)))
            end
            
            -- Count remaining targets for this caster
            local remainingCount = 0
            for _, _ in pairs(hasteInfo.Targets) do
                remainingCount = remainingCount + 1
            end
            
            if remainingCount == 0 then
                if rawCaster then
                    ActiveHasteChannels[rawCaster] = nil
                    if caster then ActiveHasteChannels[caster] = nil end
                    pcall(function()
                        if IsCharacterConcentrating(rawCaster) then
                            VoluntaryInterruptionTimes[rawCaster] = Ext.Utils.MonotonicTime()
                            BreakCharacterConcentration(rawCaster)
                        end
                    end)
                end
            else
                Ext.Utils.Print(string.format("[%s] Twinned Haste: %d targets remain active for caster %s", MOD_NAME, remainingCount, tostring(rawCaster)))
            end
            return
        end
    end
    
    -- Case B: Full Channel Collapse (Caster lost concentration, took damage, became incapacitated, died, or dismissed)
    for hasteTarget, _ in pairs(hasteInfo.Targets) do
        local isValid = IsValidEntity(hasteTarget)
        if isValid then
            if isViolentDisruption then
                Ext.Utils.Print(string.format("[%s] Haste channel violently broken! Applying Lethargy to %s (Dmg: %s, CC: %s)", 
                    MOD_NAME, tostring(hasteTarget), tostring(tookRecentDamage), tostring(wasIncapacitated)))
                pcall(function()
                    Osi.ApplyStatus(hasteTarget, "HASTE_LETHARGY", 6.0, 1)
                    if wasIncapacitated then
                        Osi.ShowOverheadNotice(hasteTarget, "Lethargic! (Incapacitated Disruption)")
                    else
                        Osi.ShowOverheadNotice(hasteTarget, "Lethargic! (Damage Disruption)")
                    end
                end)
            else
                Ext.Utils.Print(string.format("[%s] Haste channel ended voluntarily. No Lethargy applied to %s", MOD_NAME, tostring(hasteTarget)))
                pcall(function()
                    Osi.ShowOverheadNotice(hasteTarget, "Haste Ended (Safe Release)")
                end)
            end
            
            pcall(function()
                if Osi.HasActiveStatus(hasteTarget, "CHANNEL_HASTE") == 1 then
                    Osi.RemoveStatus(hasteTarget, "CHANNEL_HASTE")
                end
                if Osi.HasActiveStatus(hasteTarget, "CHANNEL_HASTE_ALLY") == 1 then
                    Osi.RemoveStatus(hasteTarget, "CHANNEL_HASTE_ALLY")
                end
                if Osi.HasActiveStatus(hasteTarget, "INNATE_BUFF_HASTE") == 1 then
                    Osi.RemoveStatus(hasteTarget, "INNATE_BUFF_HASTE")
                end
            end)
        else
            Ext.Utils.Print(string.format("[%s] Pruned annihilated/chasm entity %s during channel collapse", MOD_NAME, tostring(hasteTarget)))
        end
        
        local rawHasteTarget = hasteTarget:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or hasteTarget
        HasteTargetToCaster[rawHasteTarget] = nil
        HasteTargetToCaster[hasteTarget] = nil
    end
    
    if rawCaster then
        ActiveHasteChannels[rawCaster] = nil
        if caster then ActiveHasteChannels[caster] = nil end
        -- Gracefully release caster's concentration slot if all Haste targets ended
        pcall(function()
            if IsCharacterConcentrating(rawCaster) then
                VoluntaryInterruptionTimes[rawCaster] = Ext.Utils.MonotonicTime()
                BreakCharacterConcentration(rawCaster)
            end
        end)
    end
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
    if spell == "Target_Haste" or (spell and spell:find("Target_Haste")) then
        PendingHasteCaster = caster
        PendingHasteTime = Ext.Utils.MonotonicTime()
    end
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

-- Hook every recipient receiving the innate buff status or Haste channel
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, causee, storyActionID)
    if status == "CHANNEL_HASTE" or status == "CHANNEL_HASTE_ALLY" or status == "INNATE_BUFF_HASTE" then
        local caster = causee
        local now = Ext.Utils.MonotonicTime()
        if (not caster or caster == "") and PendingHasteCaster and (now - PendingHasteTime < 2500) then
            caster = PendingHasteCaster
        end
        if not caster or caster == "" then
            pcall(function()
                local party = Osi.DB_PartyMembers:Get(nil) or Osi.DB_Players:Get(nil)
                if party then
                    for _, row in ipairs(party) do
                        local m = row[1]
                        if m and IsCharacterConcentrating(m) then
                            caster = m
                            break
                        end
                    end
                end
            end)
        end
        if caster and caster ~= "" then
            local rawCaster = caster:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or caster
            local rawTarget = target:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or target
            
            -- Ally duration safety check: If cast on someone else, ensure ally receives 10-turn status
            if rawCaster ~= rawTarget and status == "CHANNEL_HASTE" then
                pcall(function()
                    Osi.RemoveStatus(target, "CHANNEL_HASTE")
                    Osi.ApplyStatus(target, "CHANNEL_HASTE_ALLY", 60.0, 1, caster)
                end)
                return
            end
            
            ActiveHasteChannels[rawCaster] = ActiveHasteChannels[rawCaster] or { Targets = {} }
            ActiveHasteChannels[rawCaster].Targets[rawTarget] = true
            ActiveHasteChannels[rawCaster].Targets[target] = true
            ActiveHasteChannels[caster] = ActiveHasteChannels[rawCaster]
            
            HasteTargetToCaster[rawTarget] = rawCaster
            HasteTargetToCaster[target] = rawCaster
            Ext.Utils.Print(string.format("[%s] Registered Haste channel: Caster %s -> Target %s (Self: %s, Status: %s)", MOD_NAME, tostring(caster), tostring(target), tostring(rawCaster == rawTarget), tostring(status)))
        end
    end

    if status:find("INNATE_BUFF_") and status ~= "INNATE_BUFF_HASTE" then
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
        local rawTarget = target:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or target
        local tNow = Ext.Utils.MonotonicTime()
        InvoluntaryDisruptionTimes[rawTarget] = tNow
        InvoluntaryDisruptionTimes[target] = tNow

        if Osi.HasActiveStatus(target, INNATE_CASTER_STATUS) == 1 then
            Osi.RemoveStatus(target, INNATE_CASTER_STATUS)
            CleanUpInnateBuffs(target)
            pcall(function()
                Osi.ShowOverheadNotice(target, "Focus Lost (Incapacitated)")
            end)
        end

        -- Involuntary disruption: hard CC severs Haste with Lethargy
        if ActiveHasteChannels[rawTarget] or ActiveHasteChannels[target] then
            ResolveHasteTermination(target, nil)
        end
    end

    -- Chasm and Target Annihilation handling (shoved into chasm, falling death, disintegrated)
    if status == "CHASM" or status == "FALLING_DEATH" or status == "DISINTEGRATED" then
        local rawTarget = target:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or target
        Ext.Utils.Print(string.format("[%s] Entity %s annihilated via %s - pruning all concentration and channel references", MOD_NAME, tostring(target), tostring(status)))
        ResolveHasteTermination(target, nil)
        ResolveHasteTermination(nil, target)
        for caster, hasteInfo in pairs(ActiveHasteChannels) do
            if hasteInfo.Targets then
                hasteInfo.Targets[target] = nil
                hasteInfo.Targets[rawTarget] = nil
            end
        end
        HasteTargetToCaster[target] = nil
        HasteTargetToCaster[rawTarget] = nil
    end
end)

-- Cleanup when caster loses the Innate Concentration status (manual cancel, rest, etc.)
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status, causee, storyActionID)
    if status == "CONCENTRATION" then
        if Osi.HasActiveStatus(target, CONC_TRACKER_STATUS) == 1 then
            Osi.RemoveStatus(target, CONC_TRACKER_STATUS)
        end
        ResolveHasteTermination(target, nil)
    end
    if status == "CHANNEL_HASTE" or status == "CHANNEL_HASTE_ALLY" or status == "INNATE_BUFF_HASTE" then
        ResolveHasteTermination(nil, target)
    end
    if status == INNATE_CASTER_STATUS then
        CleanUpInnateBuffs(target)
    end
end)

-- Character Death Listener: Cleans up deceased casters and handles marked target deaths
Ext.Osiris.RegisterListener("Died", 1, "after", function(char)
    local rawChar = char:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or char
    if Osi.HasActiveStatus(char, CONC_TRACKER_STATUS) == 1 then
        Osi.RemoveStatus(char, CONC_TRACKER_STATUS)
    end
    ResolveHasteTermination(char, nil)
    ResolveHasteTermination(nil, char)
    if ActiveInnateCasters[char] then
        Osi.RemoveStatus(char, INNATE_CASTER_STATUS)
        CleanUpInnateBuffs(char)
    end
    for caster, info in pairs(ActiveInnateCasters) do
        if info.Targets then
            info.Targets[char] = nil
            info.Targets[rawChar] = nil
        end
    end
    for caster, hasteInfo in pairs(ActiveHasteChannels) do
        if hasteInfo.Targets then
            hasteInfo.Targets[char] = nil
            hasteInfo.Targets[rawChar] = nil
        end
    end
    HasteTargetToCaster[char] = nil
    HasteTargetToCaster[rawChar] = nil
end)

-- Cleanup on Long Rest
Ext.Osiris.RegisterListener("LongRestStarted", 0, "after", function()
    for caster, _ in pairs(ActiveInnateCasters) do
        Osi.RemoveStatus(caster, INNATE_CASTER_STATUS)
        CleanUpInnateBuffs(caster)
    end
    ActiveInnateCasters = {}
    ActiveHasteChannels = {}
    HasteTargetToCaster = {}
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
    
    -- Smites are magical spell strikes that expend spell slots; they are NOT standard weapon attacks
    if spell:lower():find("smite") then return false end
    
    if spellType == "MeleeWeapon" or spellType == "RangedWeapon" then return true end
    
    local isWeapon = false
    pcall(function()
        local stat = Ext.Stats.Get(spell)
        if stat then
            if stat.SpellType == "MeleeWeapon" or stat.SpellType == "RangedWeapon" then
                isWeapon = true
                return
            end
            if type(stat.RequirementConditions) == "string" then
                local req = stat.RequirementConditions
                if req:find("Weapon") or req:find("HasWeapon") or req:find("Melee") or req:find("Ranged") or req:find("MainHand") or req:find("OffHand") then
                    isWeapon = true
                    return
                end
            end
            if type(stat.UseCosts) == "string" and stat.UseCosts:find("WeaponActionPoint") then
                isWeapon = true
                return
            end
            if type(stat.SpellFlags) == "string" and stat.SpellFlags:find("HasWeaponProperties") then
                isWeapon = true
                return
            end
            if type(stat.TooltipDamageList) == "string" and (
                stat.TooltipDamageList:find("MainWeaponDamageType") or 
                stat.TooltipDamageList:find("WeaponDamageType")
            ) then
                isWeapon = true
                return
            end
        end
    end)
    if isWeapon then return true end
    
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

local function IsPersonalDefensiveReaction(spell)
    if not spell then return false end
    local lower = spell:lower()
    
    -- Explicitly exclude offensive counter-magic and retaliatory damage reactions
    if lower:find("counterspell") or lower:find("hellish") or lower:find("rebuke") then
        return false
    end
    
    -- Shield spell (reaction)
    if lower == "target_shield" or lower:find("^target_shield_") or lower == "shout_shield" or lower:find("^shout_shield_") or lower == "shield" then
        if not lower:find("faith") and not lower:find("thrall") then
            return true
        end
    end
    
    -- Absorb Elements (reaction)
    if lower:find("absorbelements") or lower:find("absorb_elements") or (lower:find("absorb") and lower:find("element")) then
        return true
    end
    
    return false
end

local function IsMeleeSpellCantrip(spell)
    if not spell then return false end
    local lower = spell:lower()
    
    -- Iconic 5e melee blade cantrips
    if lower:find("greenflame") or lower:find("green_flame")
       or lower:find("boomingblade") or lower:find("booming_blade")
       or lower:find("vengefulblade") or lower:find("vengeful_blade")
       or lower:find("swordburst") or lower:find("sword_burst") then
        return true
    end
    
    -- General cantrips requiring weapon or with weapon strike properties
    local isCantripMelee = false
    pcall(function()
        local stat = Ext.Stats.Get(spell)
        if stat then
            local isCantrip = (stat.Level == 0 or stat.PowerLevel == 0)
            if isCantrip then
                local req = tostring(stat.RequirementConditions or ""):lower()
                local flags = tostring(stat.SpellFlags or ""):lower()
                local sType = tostring(stat.SpellType or "")
                if req:find("weapon") or req:find("hasweapon") or flags:find("hasweaponproperties") or sType:find("Weapon") then
                    isCantripMelee = true
                end
            end
        end
    end)
    return isCantripMelee
end

local function IsConcentrationSpell(spell)
    if not spell then return false end
    local isConc = false
    pcall(function()
        local stat = Ext.Stats.Get(spell)
        if stat and stat.SpellFlags then
            if type(stat.SpellFlags) == "string" and stat.SpellFlags:find("IsConcentration") then
                isConc = true
            elseif type(stat.SpellFlags) == "table" or type(stat.SpellFlags) == "userdata" then
                if tostring(stat.SpellFlags):find("IsConcentration") then
                    isConc = true
                end
            end
        end
    end)
    return isConc
end

local function HandleSpellInterruption(caster, spell, spellType)
    if not IsCharacterConcentrating(caster) then return end
    
    -- Focus buffs (Bless, Shield of Faith, Guidance, etc.) never break Channel (entering Overclock)
    if GetInnateSpellInfo(spell) ~= nil then return end
    
    -- Whitelisted utility and tactical actions
    if IsWhitelistedAction(spell) then return end
    
    local rawUuid = caster:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or caster
    
    -- Smites (Divine Smite, Searing Smite, Thunderous Smite, etc.) channel magical spell slots into strikes and break an active Channel spell
    if spell:lower():find("smite") then
        Ext.Utils.Print(string.format("[%s] Smite '%s' breaking active channel for %s", MOD_NAME, tostring(spell), tostring(caster)))
        VoluntaryInterruptionTimes[rawUuid] = Ext.Utils.MonotonicTime()
        VoluntaryInterruptionTimes[caster] = VoluntaryInterruptionTimes[rawUuid]
        BreakCharacterConcentration(caster)
        pcall(function() Osi.ShowOverheadNotice(caster, "Channel broken by Smite!") end)
        return
    end
    
    -- If casting another Channel spell, let the native engine handle replacement
    if IsConcentrationSpell(spell) then
        VoluntaryInterruptionTimes[rawUuid] = Ext.Utils.MonotonicTime()
        VoluntaryInterruptionTimes[caster] = VoluntaryInterruptionTimes[rawUuid]
        return
    end
    
    -- War Caster Opportunity Attack reaction
    if (spell == "Target_ShockingGrasp" or spell:find("ShockingGrasp")) and HasConcentrationAdvantage(caster) then
        if CurrentTurnCharacter == nil or CurrentTurnCharacter ~= caster then
            return
        end
    end
    
    -- Combat Channeling perks (Gish archetypes)
    if HasCombatChanneling(caster) then
        -- Personal reaction defensives (Shield, Absorb Elements)
        if IsPersonalDefensiveReaction(spell) then
            Ext.Utils.Print(string.format("[%s] Personal defensive reaction '%s' permitted under Combat Channeling for %s", MOD_NAME, tostring(spell), tostring(caster)))
            return
        end
        
        -- Melee spell cantrips (Green-Flame Blade, Booming Blade, Vengeful Blade)
        if IsMeleeSpellCantrip(spell) then
            Ext.Utils.Print(string.format("[%s] Melee spell cantrip '%s' permitted under Combat Channeling for %s", MOD_NAME, tostring(spell), tostring(caster)))
            return
        end
    end
    
    local isWep = false
    pcall(function() isWep = IsWeaponAction(spell, spellType) end)
    
    if isWep then
        if HasCombatChanneling(caster) then
            return
        else
            Ext.Utils.Print(string.format("[%s] Physical action '%s' breaking active channel for %s", MOD_NAME, tostring(spell), tostring(caster)))
            VoluntaryInterruptionTimes[rawUuid] = Ext.Utils.MonotonicTime()
            VoluntaryInterruptionTimes[caster] = VoluntaryInterruptionTimes[rawUuid]
            BreakCharacterConcentration(caster)
            pcall(function() Osi.ShowOverheadNotice(caster, "Channel broken by physical attack!") end)
            return
        end
    end
    
    Ext.Utils.Print(string.format("[%s] Spell '%s' breaking active channel for %s", MOD_NAME, tostring(spell), tostring(caster)))
    VoluntaryInterruptionTimes[rawUuid] = Ext.Utils.MonotonicTime()
    VoluntaryInterruptionTimes[caster] = VoluntaryInterruptionTimes[rawUuid]
    BreakCharacterConcentration(caster)
    pcall(function() Osi.ShowOverheadNotice(caster, "Channel broken by spellcasting!") end)
end

Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    HandleSpellInterruption(caster, spell, spellType)
end)

Ext.Osiris.RegisterListener("CastSpell", 5, "after", function(caster, spell, spellType, spellElement, storyActionID)
    HandleSpellInterruption(caster, spell, spellType)
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
        
        local rawUuid = targetGuid:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or targetGuid
        local tNow = Ext.Utils.MonotonicTime()
        LastDamageTimes[rawUuid] = tNow
        LastDamageTimes[targetGuid] = tNow
        
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
    local rawUuid = defender:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or defender
    local tNow = Ext.Utils.MonotonicTime()
    LastDamageTimes[rawUuid] = tNow
    LastDamageTimes[defender] = tNow
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
    ActiveHasteChannels = {}
    HasteTargetToCaster = {}
    
    pcall(function()
        local candidatePool = {}
        local function CollectEntities(database)
            if not database then return end
            pcall(function()
                local list = database:Get(nil)
                if list then
                    for _, row in ipairs(list) do
                        local guid = row[1]
                        if guid and guid ~= "" and IsValidEntity(guid) then
                            local raw = guid:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or guid
                            candidatePool[raw] = guid
                        end
                    end
                end
            end)
        end

        CollectEntities(Osi.DB_Players)
        CollectEntities(Osi.DB_PartyMembers)
        CollectEntities(Osi.DB_PartyFollowers)
        CollectEntities(Osi.DB_IsPlayerOrPartyMember)
        CollectEntities(Osi.DB_CombatCharacters)
        
        -- Identify which characters are actively concentrating, specifically targeting Haste casters
        local hasteCasters = {}
        local otherConcentrators = {}
        for rawGuid, entityGuid in pairs(candidatePool) do
            if IsCharacterConcentrating(entityGuid) or IsCharacterConcentrating(rawGuid) then
                local concSpell = nil
                pcall(function()
                    concSpell = Osi.GetConcentrationSpell(entityGuid)
                end)
                if not concSpell and rawGuid ~= entityGuid then
                    pcall(function()
                        concSpell = Osi.GetConcentrationSpell(rawGuid)
                    end)
                end
                if concSpell and tostring(concSpell):lower():find("haste") then
                    hasteCasters[rawGuid] = entityGuid
                else
                    otherConcentrators[rawGuid] = entityGuid
                end
            end
        end
        
        for rawTarget, target in pairs(candidatePool) do
            local entity = Ext.Entity.Get(target) or Ext.Entity.Get(rawTarget)
            if entity and entity.StatusMachine and entity.StatusMachine.Statuses then
                for _, statusObj in ipairs(entity.StatusMachine.Statuses) do
                    local sId = statusObj.StatusId
                    if sId and (sId == "CHANNEL_HASTE" or sId == "CHANNEL_HASTE_ALLY" or sId == "INNATE_BUFF_HASTE") then
                        local causee = nil
                        if statusObj.Causee and statusObj.Causee.EntityUuid then
                            causee = statusObj.Causee.EntityUuid
                        elseif statusObj.StatusCausee and statusObj.StatusCausee.EntityUuid then
                            causee = statusObj.StatusCausee.EntityUuid
                        end
                        
                        -- Fallbacks if causee metadata is null in save file:
                        if not causee or causee == "" then
                            if sId == "CHANNEL_HASTE" then
                                -- Self-cast indefinite Haste: target is the caster
                                causee = target
                            elseif sId == "CHANNEL_HASTE_ALLY" then
                                -- Ally 10-round Haste: prioritize caster specifically concentrating on Target_Haste
                                for _, cGuid in pairs(hasteCasters) do
                                    causee = cGuid
                                    break
                                end
                                if not causee or causee == "" then
                                    for _, cGuid in pairs(otherConcentrators) do
                                        causee = cGuid
                                        break
                                    end
                                end
                            end
                        end
                        
                        if causee and causee ~= "" then
                            local rawCaster = causee:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or causee
                            ActiveHasteChannels[rawCaster] = ActiveHasteChannels[rawCaster] or { Targets = {} }
                            ActiveHasteChannels[rawCaster].Targets[rawTarget] = true
                            ActiveHasteChannels[rawCaster].Targets[target] = true
                            ActiveHasteChannels[causee] = ActiveHasteChannels[rawCaster]
                            HasteTargetToCaster[rawTarget] = rawCaster
                            HasteTargetToCaster[target] = rawCaster
                            Ext.Utils.Print(string.format("[%s] Reconstructed Haste channel: Caster %s -> Target %s", MOD_NAME, tostring(causee), tostring(target)))
                        end
                    end
                    
                    if sId and sId:find("INNATE_BUFF_") and sId ~= "INNATE_BUFF_HASTE" then
                        local causee = nil
                        if statusObj.Causee and statusObj.Causee.EntityUuid then
                            causee = statusObj.Causee.EntityUuid
                        elseif statusObj.StatusCausee and statusObj.StatusCausee.EntityUuid then
                            causee = statusObj.StatusCausee.EntityUuid
                        end
                        
                        if not causee or causee == "" then
                            for _, cGuid in pairs(candidatePool) do
                                if Osi.HasActiveStatus(cGuid, INNATE_CASTER_STATUS) == 1 then
                                    causee = cGuid
                                    break
                                end
                            end
                            if not causee or causee == "" then
                                causee = target
                            end
                        end
                        
                        if causee and causee ~= "" then
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

-- Continuous synchronization of concentration state & self-healing save recovery
local tickCounter = 0
Ext.Events.Tick:Subscribe(function()
    tickCounter = tickCounter + 1
    if tickCounter % 15 == 0 then
        UpdateAllConcentrationTrackers()
    end
    -- Self-healing check: if party has active Haste but runtime tables are empty, rebuild immediately
    if tickCounter % 60 == 0 then
        local hasteActive = false
        pcall(function()
            local party = Osi.DB_PartyMembers:Get(nil)
            if party then
                for _, row in ipairs(party) do
                    local m = row[1]
                    if m and (Osi.HasActiveStatus(m, "CHANNEL_HASTE") == 1 or Osi.HasActiveStatus(m, "CHANNEL_HASTE_ALLY") == 1) then
                        hasteActive = true
                        break
                    end
                end
            end
        end)
        if hasteActive and next(ActiveHasteChannels) == nil then
            Ext.Utils.Print(string.format("[%s] Detected orphaned Haste status in party; running state reconstruction.", MOD_NAME))
            ReconstructSessionStateFromEngine()
        end
    end
end)

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level, isEditor)
    ReconstructSessionStateFromEngine()
end)

Ext.Events.SessionLoaded:Subscribe(function()
    ReconstructSessionStateFromEngine()
    Ext.Utils.Print(string.format("[%s] Dual concentration engine active. Save state reconstructed.", MOD_NAME))
end)
