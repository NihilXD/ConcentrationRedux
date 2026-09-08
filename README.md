<p align="center">
  <img src="Mods/ConcentrationRedux/icon.png" width="180" height="180" alt="Concentration Redux Emblem" />
</p>

# Concentration Redux

A Baldur's Gate 3 mod powered by Norbyte's **Script Extender (BG3SE)** that replaces the vanilla concentration limit with two distinct tactical slots: **Focus** and **Channel**.

---

## The Philosophy: Cognitive Bandwidth

In vanilla 5e / Baldur's Gate 3, concentration creates arbitrary friction:
- High-value party buffs (*Bless*, *Shield of Faith*, *Heroism*) compete with active combat spells (*Spirit Guardians*, *Wall of Fire*, *Haste*), turning casters into passive buff-bots or forcing them to completely abandon party support.
- Buffs vanish from stray 1-damage surface ticks or off-screen archers.
- Outside turn-based combat, 10-turn (60-second) timers expire while looting chests or reading dialogue.

**Concentration Redux** redesigns spellcaster focus into three tactical stances:

| Stance | Conditions | Defensive Resilience | Allowed Actions |
|---|---|---|---|
| **Pure Support** (Solo Focus) | Only Focus is active (*Bless*, *Shield of Faith*, *Heroism*, *Blade Ward*, etc.) | **100% Unbreakable by Damage**. No Constitution saving throws against damage ticks or surfaces. Hard CC (Stun, Paralysis, Sleep, Incapacitation) breaks Focus. | All actions, spells, and attacks permitted. Indefinite duration until Long Rest or manual dismissal. |
| **Combat Channeling** (Solo Channel) | Only a Channel spell is active (*Haste*, *Spirit Guardians*, *Wall of Fire*, *Hold Person*, *Fog Cloud*) | Uses standard Constitution saving throws against damage. Benefits from **War Caster** Advantage. | Whitelisted tactical actions (*Dash*, *Disengage*, *Shove*, *Throw*, etc.). Weapon attacks permitted for **Combat Channelers** (martial domains, paladins, gishes). Casting non-whitelisted spells breaks Channel. |
| **The Overclock** (Both Active) | Both Focus and Channel are maintained simultaneously | **Dual Bandwidth**: Focus remains resilient (rolls saves with Advantage) while Channel rolls standard saves (with **War Caster** Advantage). | Maintain both spells at once. If Channel drops, Focus continues undisturbed. |

---

## Spell Classifications

### 1. Focus (Indefinite Duration Buffs)
- **Combat & Defensive Wards**: *Bless*, *Shield of Faith*, *Blade Ward*, *Guidance*, *Resistance*, *Heroism*, *Protection from Evil and Good*, *Barkskin*, *Stoneskin*
- **Utility & Exploration**: *Dancing Lights* (indefinite remote illumination that never strips pre-cast buffs)
- **Social Charms (10-Turn Timer)**: *Friends* (routed to Focus to protect active Channel spells during dialogue checks, while retaining its 10-turn timer for Tactician/Honour Mode hostility)
- **Single-Target Marks**: *Hunter's Mark*, *Hex*, *Bane*, *Bestow Curse*
- **Physical Augmentations**: *Enlarge/Reduce*, *Fly*, *Expeditious Retreat*, *Blur*, *Magic Weapon*, *Elemental Weapon*
- **Stealth & Senses**: *Invisibility*, *Greater Invisibility*, *Pass Without Trace*, *Detect Thoughts*

*Note: Focus buffs are mutually exclusive per caster. Casting a new Focus spell naturally replaces the active one.*

> [!NOTE]
> **Class Spells vs. Bound Equipment & Scrolls**:
> - **Class Spells & Feats**: Genuine class investments (e.g., Cleric/Druid/Wizard spellbooks, Bard *Magical Secrets*, multiclassing, and *Magic Initiate*) utilize the full **Focus** system.
> - **Bound Equipment & Scrolls**: Spells granted by equipment, weapons, armor, accessories (e.g. *Darkfire Shortbow*, *The Whispering Promise*, *Hellrider's Pride*, amulets/rings), and consumable scrolls intentionally follow **standard vanilla rules** (temporary duration, normal engine concentration or status, and standard damage saving throws) to preserve class identity and prevent item cheese.

### 2. Channel (Combat Spells & Stances)
- **Tactical Speed & Augmentation**: *Haste* (Channel Spell with Dual-Duration & Intelligent Lethargy Resolution: when **self-cast**, duration is **unlimited**; when cast on an **ally**, duration is **10 rounds**. Ending gracefully after 10 rounds, or dismissing voluntarily via portrait "X", hard-cast spells, reaction spells, or Channel swaps safely releases the recipient with **no Lethargy**; having your Channel broken by damage inflicts 1 turn of **Lethargy**).
- **Emanations & Auras**: *Spirit Guardians* (Radiant / Necrotic), *Aura of Vitality*, *Crusader's Mantle*, *Holy Aura*
- **Sustained Beams & Activations**: *Call Lightning*, *Moonbeam*, *Witch Bolt*, *Heat Metal*, *Sunbeam*, *Eyebite*, *Telekinesis*
- **Area Hazards & Fields**: *Wall of Fire*, *Darkness*, *Cloud of Daggers*, *Fog Cloud*, *Silence*, *Spike Growth*, *Sleet Storm*, *Hunger of Hadar*, *Cloudkill*, *Evard's Black Tentacles*, *Insect Plague*
- **Hard Crowd Control**: *Hold Person*, *Hold Monster*, *Hypnotic Pattern*, *Banishment*, *Tasha's Hideous Laughter*, *Slow*, *Confusion*, *Otiluke's Resilient Sphere*
- **Attack Modifiers**: *True Strike* (intentionally kept on standard short-duration vanilla rules)

### 3. The Cantrip Conundrum (Focus & Channel Cantrips)
In vanilla Baldur's Gate 3, defensive and utility cantrips often suffer from awkward action economy and duration limits. Here is how they integrate into the Concentration Redux architecture:
- **Blade Ward (Physical Damage Aegis):** Converted to Focus (indefinite buff). Whether evaluated against vanilla's fleeting 2-turn duration or 5e update patches where it lasts 10 rounds alongside spells like *Bless*, Blade Ward is the quintessential defensive ward. As Focus, it becomes a continuous physical shield (resistance to Bludgeoning, Piercing, and Slashing weapon damage) that eliminates tedious re-casting outside turn-based combat. Because it occupies your single Focus slot, running Blade Ward creates an authentic tactical trade-off against *Shield of Faith* (+2 AC to prevent attacks from connecting), *Bless* (+1d4 attack and saves), or *Resistance* (+1d4 saves). Gear that applies Blade Ward upon healing (such as *Hellrider's Pride* or *The Reviving Hands*) continues to apply standard temporary vanilla statuses without disturbing your Focus slot.
- **Resistance (Defensive Twin to Guidance):** Converted to Focus (indefinite buff). In vanilla, Resistance is rarely used because burning an action and a concentration slot for a 10-turn +1d4 save bonus cannot compete with *Bless* or *Spirit Guardians*. As Focus, it becomes a reliable zero-slot ward for exploration and pre-buffing. Because it occupies your single Focus slot, it forces an honest tactical choice against *Bless* (+1d4 attack and saves) or *Shield of Faith* (+2 AC), while eliminating the dialogue trap during conversation saving throws.
- **Friends (Social Utility with Difficulty Awareness):** Converted to Focus layer with duration retained (10 turns). Cast almost exclusively inside dialogue rolls, vanilla Friends instantly wipes out whatever combat spell your caster was maintaining prior to the conversation. Moving it to Focus protects your active Channel spells. However, because NPC suspicion and hostility triggers fire on status expiration, its standard 10-turn timer is intentionally preserved so higher difficulty (Tactician/Honour Mode) social penalties function exactly as intended.
- **Dancing Lights (Exploration Lighting):** Converted to Focus (indefinite duration). Allows races lacking Darkvision (Humans, Halflings, Githyanki) to illuminate distant high ground or gloom-covered arenas at an 18m range without sacrificing pre-cast Channel buffs. Floating wisps automatically despawn cleanly whenever you dismiss Focus or cast another buff.
- **True Strike (Preserved on Vanilla Rules):** Left on standard 2-turn Channel rules. True Strike is an offensive attack modifier, not a cognitive ward. Converting it to an indefinite Focus buff would either provide permanent free Advantage for zero spell slots or conflict with one-hit consumption triggers. Leaving it as a short-duration Channel preserves standard combat attack math.

### 4. Reapplication Spells (*Hex* & *Hunter's Mark*)
- When a marked target dies, the corpse target is cleanly detached from tracking while preserving `INNATE_CONCENTRATION_CASTER` on the caster.
- The free `Target_Hex_Reapply` and `Target_HuntersMark_Reapply` spells remain accessible on the hotbar and are fully whitelisted so re-marking a new foe never breaks your active Channel.

### 5. Loss of Control & Incapacitation
- If a caster is afflicted with `STUNNED`, `PARALYZED`, `PETRIFIED`, `SLEEP`, `UNCONSCIOUS`, `KNOCKED_OUT`, `INCAPACITATED`, `BANISHED`, `POLYMORPH`, or `DOWNED`/`DEAD`, Focus and all linked party buffs immediately collapse, honoring standard 5e rules.

### 6. Manual Dismissal (Releasing Spells Voluntarily)
- **Dismissing Focus (Buffs)**: While maintaining Focus (*Bless*, *Shield of Faith*, *Blade Ward*, *Guidance*), the caster automatically gains a free, 0-action cost **Dismiss Focus** ability (`Shout_DismissInnateConcentration`) on their hotbar. Using it voluntarily releases Focus on demand without needing to cast another spell or rest.
- **Dismissing Channel Spells**: Because Channel spells (*Haste*, *Spirit Guardians*, *Wall of Fire*, *Cloud of Daggers*, *Hold Person*, *Fog Cloud*) run in the engine's native concentration slot under the hood, players can cancel them at any moment using Baldur's Gate 3's **native "X" button** located directly beneath the character's portrait on the bottom-left HUD, or by casting another Channel spell. For *Haste*, voluntarily dismissing it releases the buff cleanly **without causing Lethargy**.

### 7. Reaction Spells & Gish Wards
- **Personal Reaction Defensives (Shield & Absorb Elements)**:
  - Characters with **Combat Channeling** (those who can melee while concentrating, including *Bladesingers*, *Eldritch Knights*, *Paladins 2+*, *War/Tempest Clerics*, *Swords/Valour Bards*, *Arcane Tricksters*, *Circle of Spores Druids*, *Pact of the Blade Warlocks*, *Monks*, or anyone with *War Caster*) can cast **personal reaction defensives** (*Shield*, *Absorb Elements*) **without breaking Channel**!
  - Pure casters lacking martial-magical discipline (e.g., standard Wizards or Sorcerers without War Caster/Bladesong) still break their active Channel if they cast *Shield*.
- **Counter-Magic & Retaliatory Damage Reactions (Always Breaks)**:
  - Casting *Counterspell* (external offensive counter-magic) or retaliatory damage reactions (*Hellish Rebuke*) demands 100% of your spell focus and **immediately breaks active Channel spells for ALL casters**, including gishes.
- **Melee Spell Cantrips (Green-Flame Blade, Booming Blade, Vengeful Blade)**:
  - Characters with **Combat Channeling** can cast **melee spell cantrips** (*Green-Flame Blade*, *Booming Blade*, *Vengeful Blade*) in melee combat **without breaking Channel**!
- **Gish Combat Stances & Class Features**:
  - Activating martial combat stances (*Bladesong*, Circle of Spores *Symbiotic Entity*, *Pact Weapon Binding*, *Hexblade's Curse*, Eldritch Knight *Weapon Bond*, Monk *Step of the Wind / Patient Defense / Wholeness of Body*, Bardic *Blade Flourishes*, and martial *Channel Divinities*) **never breaks Channel**!
- **Physical Reactions & Class Features**:
  - Non-magical reactions (melee *Opportunity Attacks*) and non-spell reaction features (*Warding Flare*, *Wrath of the Storm*, *Cutting Words*, *Uncanny Dodge*, *Deflect Missiles*) expend no spell slots and are 100% safe for all casters.

### 8. Withers Respec Cleanup
- Visiting Withers to respec automatically triggers a full cleanup via `CharacterRespecCompleted`, guaranteeing no lingering buffs or statuses bleed into a newly chosen class.

---

## Combat Channeling & Gish Archetypes

Attacking with weapons while sustaining an active Channel spell requires true martial-magical discipline:

| Class | Recognized Archetype | Unlock Level | Notes |
| :--- | :--- | :---: | :--- |
| **Cleric** | **War Domain & Tempest Domain** | Level 1 | Inherent divine martial training. |
| **Monk** | **All Monks** | Level 1 | Core spiritual discipline and Ki flow. |
| **Paladin** | **All Paladins** | Level 2+ | Unlocked with Spellcasting (Level 1 is mundane). |
| **Ranger** | **All Rangers** | Level 2+ | Unlocked with Spellcasting (Level 1 is mundane). |
| **Wizard** | **Bladesinger** | Level 2+ | Bladesong passives and active status. |
| **Druid** | **Circle of Spores** | Level 2+ | Frontline fungal melee (*Symbiotic Entity*). |
| **Bard** | **College of Swords & Valour** | Level 3+ | Blade Flourishes and battle skalds. |
| **Warlock** | **Pact of the Blade** | Level 3+ | Bound Pact Weapons and Hexblades. |
| **Fighter** | **Eldritch Knight Only** | Level 3+ | *Weapon Bond* and *War Magic*. |
| **Rogue** | **Arcane Trickster Only** | Level 3+ | *Mage Hand Legerdemain*. |
| **Mundane** | **Champion, Battle Master, Thief, Assassin, Barbarian** | *Never* | Raw physical momentum breaks active Channel spells. |

> [!IMPORTANT]
> **Smites Break Channels**: Expending spell slots for magical burst strikes (*Divine Smite*, *Searing Smite*, *Thunderous Smite*, *Wrathful Smite*, *Blinding Smite*, etc.) requires an instant burst of magical force and **immediately breaks an active Channel spell** (*Spirit Guardians*), displaying an overhead notice (*"Channel broken by Smite!"*), while leaving passive Focus buffs (*Bless*, *Shield of Faith*) completely undisturbed.

> [!NOTE]
> **No Unearned Advantage**: Gish training grants the physical discipline to attack while channeling, but **does not grant Advantage on concentration saving throws** (Advantage remains strictly reserved for the *War Caster* feat or advantage gear).

---

## War Caster Synergy

The **War Caster** feat (`WarCaster_Concentration`) integrates directly into both slots:
- **Baseline Behavior (Without War Caster)**:
  - **Focus**: 100% unbreakable by damage when solo; rolls an independent Constitution saving throw with **Advantage** during The Overclock.
  - **Channel**: Rolls a standard 1d20 Constitution saving throw (no Advantage).
- **With War Caster**:
  - Grants **Advantage** to Channel saving throws (both solo and during The Overclock).
  - Because Focus already rolls with Advantage during The Overclock, **War Caster ensures BOTH independent saving throws have Advantage during an Overclock!**
- **Reactive Spellcasting (Shocking Grasp)**: Using War Caster to cast *Shocking Grasp* as an Opportunity Attack reaction in lieu of a melee strike is **explicitly permitted and will NOT break Channeling**. (Casting *Shocking Grasp* with an Action on your own turn remains standard spellcasting and breaks the channel).

---

## Changelog

### v1.1.0 (DnD 5.5e Beyond Compatibility & Comprehensive Tooltips)
- **Terminology Standardization (Focus & Channel)**:
  - Streamlined and standardized all terminology across the entire mod, Lua engine, and documentation to strictly use **Focus** (buff layer) and **Channel** (combat layer). Removed legacy and ambiguous references to "conduit".
- **100% Comprehensive Tooltip Coverage Across All Concentration Spells**:
  - Over 480+ in-game spell cards, upcasts (levels 2–6), scrolls, racial abilities (e.g. Drow *Faerie Fire*), and applied status tooltips now feature dedicated **Focus** and **Channel** mechanic descriptions.
  - Bumped internal localization version numbers to `version="10"`, guaranteeing mod descriptions always override base game strings regardless of load order.
- **New Classes & Subclasses Supported (DnD 5.5e All-In-One BEYOND)**:
  - **Illrigger**: Full Combat Channeling for all subclasses (*Sanguine Knight*, *Hellspeaker*, *Painkiller*, *Shadowmaster*, *Architect of Ruin*). Whitelisted all Seals, Interdicts, Hell abilities, and Blood Price.
  - **Monster Hunter**: Full Combat Channeling for *Carver Guild*, *Devourer Guild*, and *Occultist Guild*. Whitelisted all Mutations and Hunting Tactics.
  - **Artificer**: Combat Channeling for martial gish subclasses (*Battle Smith*, *Armorer*). Whitelisted Experimental Elixirs, Armor Models, and Defensive Field.
  - **Gunslinger**: Combat Channeling for the *Spellslinger* gun gish subclass.
  - **New Martial & Gish Subclasses Across Existing Classes**:
    - **Fighter**: *Rune Knight*, *Psi Warrior*, *Arcane Archer*, *Cavalier*, *Banneret*, *Viking*.
    - **Rogue**: *Soulknife*, *Blade of Radiance*, *Arachnoid Stalker*.
    - **Bard**: *College of Dance*, *College of Choreography*.
    - **Cleric**: *Forge Domain*, *Twilight Domain*, *Dragon Domain*.
    - **Wizard & Warlock**: *Bladesinger* (Bladesinging School) and *Hexblade*.
    - **Monk, Paladin, Ranger**: All 2024 subclasses (*Mercy*, *Kensei*, *Sun Soul*, *Mystic Arts*, *Glory*, *Noble Genie*, *Conquest*, *Watchers*, *Fey Wanderer*, *Winter Walker*, *Hollow Warden*) fully integrated.
- **Spell Classification & Tooltips (DnD 5.5e Spells)**:
  - Audited and updated all 38 custom and revised concentration spells from *DnD 5.5e Beyond* with explicit **Focus** or **Channel** trailers and mechanics.
  - Focus additions: *Holy Weapon*, *Dragon's Breath*, *Aura of Vitality* (upcasts 4-6), *Circle of Power*, *Cacophonic Shield*, *Fount of Moonlight*, *Cloak of Shadow*, *Fire Dance*, *Elminster's Elusion*, *Blade Ward (2024)*, *Hex*, and *Body Warping of Gorgoroth*.
  - Channel additions: *Hell's Lash*, *Sleep (2024)*, *Spellfire Storm*, *Dawn*, *Enervation*, *Ashardalon's Stride*, *Void Strike*, *Murmurs of Doom*, *Cloud of Daggers (2024)*, *Conjure Minor Elementals (2024)*, *Conjure Woodland Beings (2024)*, *Summon Celestial*, and *Summon Dragon*.
- **Spell Weaving (Cantrips, Bonus Actions & Quickened Metamagic)**:
  - **All Cantrips (Level 0)**: Pure casters now have an active combat loop every turn! All cantrips (*Fire Bolt*, *Ray of Frost*, *Eldritch Blast*, *Sacred Flame*, *Acid Splash*, *Shocking Grasp*, etc.) are recognized as reflexive magic and can be cast freely without breaking an active Channel.
  - **Native Bonus Action Spells**: Spells requiring only a Bonus Action (*Misty Step*, *Healing Word*, *Mass Healing Word*, *Spiritual Weapon*, *Sanctuary*) can now be cast without breaking Channel, enabling fluid tactical repositioning and emergency triage.
  - **Sorcerer Quickened Spell Metamagic**: Quickening a standard-action leveled spell converts it to a bonus action weave, allowing Sorcerers to spend Sorcery Points to cast leveled spells without dropping their active Channel stance.
  - **Action Leveled Spells**: Casting standard-action leveled spells (Level 1+) or offensive reactions (*Counterspell*, *Hellish Rebuke*) continues to demand total mental concentration and breaks active Channel stances.
- **Engine & Packaging Stability (Patch 7 / Patch 8+)**:
  - Resolved a launch crash (`0xC0000005` in `bg3_dx11.exe`) caused by raw XML linebreaks creating text DOM nodes without attributes in Larian's localization parser.
  - Re-architected localization pipeline into clean single-line entries with `&#10;` line breaks and compiled binary `.loca`.
  - Removed duplicate package namespace directories and automated loose file cleanup on deployment.

### v1.0.5
- **Haste Dual Duration & Intelligent Lethargy System**:
  - **Self-Cast (Indefinite)**: Operates as an indefinite Channel spell with unlimited duration.
  - **Ally-Cast (10 Rounds)**: Standard tactical duration of 10 rounds (60 seconds) when cast on party members, companions, or summons.
  - **Safe Release (No Lethargy)**: Voluntarily ending *Haste*—via portrait "X", casting non-whitelisted spells or offensive reactions, swapping Channel spells, or letting the 10 rounds expire naturally on an ally—safely releases the recipient with zero Lethargy (*"Haste Ended (Safe Release)"*).
  - **Involuntary Disruption (Inflicts Lethargy)**: Breaking your Channel involuntarily via damage, environmental surfaces, or hard crowd control (*Hold Person*, *Sleep*, *Hypnotic Pattern*, *Banishment*, *Stun*, *Paralyze*) inflicts 1 turn of Lethargy (*"Lethargic! (Damage/Incapacitated Disruption)"*).
  - **Sorcerer Twinned Haste Support**: Twinned Haste grants the caster an indefinite buff while the ally receives the 10-round buff. When the ally's duration expires, the ally releases safely without Lethargy, leaving the caster's Haste intact.
  - **In-Game Tooltips**: Fully updated spell card and status tooltips reflecting dual-duration and intelligent lethargy rules.
- **In-Game Tooltip Indicators for All Focus & Channel Spells**:
  - Embedded explicit tactical indicators on all Focus buffs (*Bless*, *Shield of Faith*, *Blade Ward*, *Guidance*, *Hex*, *Bane*, etc.):
    > *Focus: Occupies your Focus slot with indefinite duration. Immune to damage interruption; does not conflict with an active Channel spell.*
  - Embedded matching tactical indicators across all combat Channel spells (*Spirit Guardians*, *Wall of Fire*, *Hold Person*, *Moonbeam*, *Hypnotic Pattern*, smites, hazards, etc.):
    > *Channel: Occupies your Channel slot. Subject to damage saving throws; does not conflict with an active Focus spell. Casting Cantrips, Bonus Action spells, or Quickened spells does not break Channel.*
- **Gish Reaction Defensives & Melee Cantrips**:
  - Combat Channelers and characters with *War Caster* (enabling build-your-own gish setups on pure Sorcerers or Wizards) can cast personal reaction defensives (*Shield*, *Absorb Elements*) and melee spell cantrips (*Green-Flame Blade*, *Booming Blade*, *Vengeful Blade*) without breaking Channel.
  - Offensive counter-magic (*Counterspell*) and retaliatory damage reactions (*Hellish Rebuke*) demand full casting focus and continue to break active Channel spells for all casters.
- **Gish Combat Stances & Class Forms**:
  - Activating martial class stances and disciplines (*Bladesong*, *Symbiotic Entity*, *Bind Pact Weapon*, *Hexblade's Curse*, *Weapon Bond*, Monk Ki maneuvers/stances, Bardic *Blade Flourishes*, and martial *Channel Divinities*) never breaks an active Channel spell.
- **Loss of Control & Hard CC**:
  - Hard incapacitation conditions (*Stunned*, *Paralyzed*, *Sleeping*, *Incapacitated*, *Banished*) reliably sever both Focus and Channel and trigger full disruption penalties.

### v1.0.4
- **Blade Ward Focus Conversion**:
  - Converted *Blade Ward* (`Shout_BladeWard`) into an indefinite **Focus** buff (`INNATE_BUFF_BLADE_WARD`, duration -1).
  - Grants continuous resistance to Bludgeoning, Piercing, and Slashing weapon damage, occupying your single Focus slot to force genuine tactical trade-offs against *Shield of Faith* (+2 AC), *Bless* (+1d4 attack/saves), or *Resistance*.
  - Equipment procs applying Blade Ward on heal (e.g. *Hellrider's Pride*, *The Reviving Hands*) continue to apply standard vanilla short-duration statuses without disturbing your Focus slot.
- **Tactical Movement & Action Whitelist Fix**:
  - Fixed Jump (`Projectile_Jump`, `Projectile_Jump_Monk`), Crouch/Stealth (`Shout_Hide`, `Shout_CunningAction_Hide`), Dash (`Shout_Dash`, `Shout_ActionSurge_Dash`, `Shout_StepOfTheWind_Dash`), Disengage (`Shout_Disengage`), Shove (`Target_Shove`), Dip (`Shout_Dip`), Throw (`Throw_Throw`), and Help (`Target_Help`) inadvertently breaking active Channel spells with a *"Channel broken by spellcasting!"* overhead notice.
  - Implemented an `IsWhitelistedAction` pattern-matching filter in the server engine to automatically recognize all current and future tactical movement actions, bonus actions, and stance variants.

### v1.0.3
- **Cantrip Focus Overhaul**:
  - **Resistance**: Converted to the Focus layer (`INNATE_BUFF_RESISTANCE`, indefinite duration). Serves as a zero-slot defensive counterpart to *Guidance* for exploration and conversation saving throws, mutually exclusive with *Bless* and *Shield of Faith*.
  - **Friends**: Converted to Focus (`INNATE_BUFF_FRIENDS`) to prevent dialogue rolls from breaking pre-cast Channel spells. Standard 10-turn duration intentionally preserved so Tactician and Honour Mode NPC hostility triggers function as designed.
  - **Dancing Lights**: Converted to Focus (`INNATE_BUFF_DANCING_LIGHTS`, indefinite duration) to allow 18m ranged illumination without sacrificing combat buffs. Floating wisps despawn cleanly upon dismissing or replacing Focus.
  - **True Strike**: Formally preserved on vanilla 2-turn Channel rules to protect combat attack math.
- **Documentation & UI**:
  - Added Section 3 ("The Cantrip Conundrum") explaining cantrip design philosophy and balance choices.
  - Fixed unsupported `[olist]` BBCode tags on Nexus to standard `[list]`.
  - Documented emergency reaction spell disruption (*Shield*, *Counterspell*, *Hellish Rebuke*) and whitelisted reapplication spells (*Hex*, *Hunter's Mark*, *Call Lightning*).
- **Tooling & Build System**:
  - Updated `build.ps1` to structure internal package directories with the Patch 7 UUID (`ConcentrationRedux_5ca2dda8-eedc-41be-95f0-50747d552d10.pak`) and automatically synchronize release archives.

### v1.0.2
- **Smite Disruption**:
  - Expending spell slots for magical strikes (*Divine Smite*, *Searing Smite*, *Thunderous Smite*, *Wrathful Smite*, etc.) now immediately breaks active Channel spells (*Spirit Guardians*), displaying an overhead notice (*"Channel broken by Smite!"*). Passive Focus buffs (*Bless*, *Shield of Faith*) remain undisturbed.
- **Combat Channeling & Gish Archetype Overhaul**:
  - **Monk**: Granted at Level 1 across all subclasses (core spiritual discipline and Ki flow).
  - **Paladin & Ranger**: Unlocked at Level 2 alongside their official Spellcasting feature (Level 1 characters remain mundane combatants).
  - **Eldritch Knight Fighter & Arcane Trickster Rogue**: Unlocked at Level 3. Mundane fighters (*Champion*, *Battle Master*) and rogues (*Thief*, *Assassin*) cannot attack while maintaining active Channel spells.
  - **Bladesinger Wizard**: Added full support for Bladesingers and active *Bladesong*.
  - **College of Swords & Valour Bard**: Added full support for Blade Flourishes and battle skalds.
  - **Pact of the Blade Warlock**: Added full support for Bound Pact Weapons and Hexblades.
  - **Circle of Spores Druid**: Added full support for frontline melee and *Symbiotic Entity*.
  - **Barbarian Exclusion**: Pure physical rage continues to break active Channel spells.
- **War Caster Synergy**:
  - Clarified that gish multiclassing allows weapon attacks while channeling, but does not grant unearned Advantage on concentration saving throws (Advantage remains exclusive to War Caster or advantage gear).

### v1.0.1
- Fixed `IsWeaponAction` Script Extender crash when casting spells while concentrating.
- Added *Guidance* as a zero-slot Focus buff.
- Improved Channel interruption with `AI_HELPER_BREAKCONCENTRATION`.

### v1.0.0
- Initial release of Concentration Redux: two-slot system (Focus vs. Channel), The Overclock, 36+ converted spells, and custom UI portrait badges.

---

## Installation & Development

### Requirements
- Baldur's Gate 3 (Patch 7 / Patch 8+)
- [Baldur's Gate 3 Script Extender (BG3SE)](https://github.com/Norbyte/bg3se) (v32+) with console enabled (`Console.CreateConsole = true` in `bin/ScriptExtenderSettings.json`).

### Deployment & Packaging Options
Run PowerShell in the project root:
```powershell
# Validate all files
powershell -ExecutionPolicy Bypass -File .\build.ps1

# Package into .pak and install to AppData Mods (for Vortex / BG3MM / Patch 7)
powershell -ExecutionPolicy Bypass -File .\build.ps1 -Package

# Deploy loose files directly into Baldur's Gate 3\Data (for active live development)
powershell -ExecutionPolicy Bypass -File .\build.ps1 -Deploy

# Remove deployed mod files
powershell -ExecutionPolicy Bypass -File .\build.ps1 -Clean
```

### Live Reloading
When playing with loose files installed, open the BG3SE console and type:
```
reset
```
This reloads `main.lua` instantaneously without needing to restart the game.

---

## Support the Project
If Concentration Redux made your spellcasters fun and tactically rewarding to play, consider buying me a coffee:
- ☕ **[Support on Ko-fi](https://ko-fi.com/nihilxd)**

