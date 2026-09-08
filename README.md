<p align="center">
  <img src="Mods/ConcentrationRedux/icon.png" width="180" height="180" alt="Concentration Redux Emblem" />
</p>

# Concentration Redux

A Baldur's Gate 3 mod powered by Norbyte's **Script Extender (BG3SE)** that redesigns the game's concentration economy into two distinct cognitive layers: **Focus** and **Concentration**.

---

## The Philosophy: Cognitive Bandwidth

In vanilla 5e / Baldur's Gate 3, concentration creates arbitrary friction:
- High-value party buffs (*Bless*, *Shield of Faith*, *Heroism*) compete with active combat emanations and conduits (*Spirit Guardians*, *Wall of Fire*, *Haste*), turning casters into passive buff-bots or forcing them to completely abandon party support.
- Buffs vanish from stray 1-damage surface ticks or off-screen archers.
- Outside turn-based combat, 10-turn (60-second) timers expire while looting chests or reading dialogue.

**Concentration Redux** redesigns spellcaster focus into three tactical stances:

| Stance | Conditions | Defensive Resilience | Allowed Actions |
|---|---|---|---|
| **Pure Support** (Solo Focus) | Only Focus is active (*Bless*, *Shield of Faith*, *Heroism*, *Blade Ward*, etc.) | **100% Unbreakable by Damage**. No Constitution saving throws against damage ticks or surfaces. Hard CC (Stun, Paralysis, Sleep, Incapacitation) shatters Focus. | All actions, spells, and attacks permitted. Indefinite duration until Long Rest or manual dismissal. |
| **Dedicated Juggernaut** (Solo Concentration) | Only a Concentration spell is active (*Haste*, *Spirit Guardians*, *Wall of Fire*, *Hold Person*, *Fog Cloud*) | Uses native engine concentration slot with standard Con saves. Benefits from **War Caster** Advantage. | Whitelisted stances (*Dodge*, *Dash*, *Shove*, *Throw*, etc.). Weapon attacks permitted for **Combat Domains** (*War*, *Tempest*). Casting other spells breaks concentration. |
| **The Overclock** (Both Active) | Both Focus and Concentration are maintained simultaneously | **Dual Focus Bandwidth**: Focus remains resilient while Concentration rolls standard saves with **War Caster** Advantage. | Pushes mental focus to the limit. If Concentration drops first, the remaining Focus gracefully continues undisturbed. |

---

## Spell Classifications

### 1. Focus (Indefinite Duration Buffs)
- **Combat & Defensive Wards**: *Bless*, *Shield of Faith*, *Blade Ward*, *Guidance*, *Resistance*, *Heroism*, *Protection from Evil and Good*, *Barkskin*, *Stoneskin*, *Shield of Thralls*
- **Utility & Exploration**: *Dancing Lights* (indefinite remote illumination that never strips pre-cast buffs)
- **Social Charms (10-Turn Timer)**: *Friends* (routed to Focus to protect combat conduits during dialogue checks, while retaining its 10-turn timer for Tactician/Honour Mode hostility)
- **Single-Target Marks**: *Hunter's Mark*, *Hex*, *Bane*, *Bestow Curse*
- **Physical Augmentations**: *Enlarge/Reduce*, *Fly*, *Expeditious Retreat*, *Blur*, *Magic Weapon*, *Elemental Weapon*
- **Stealth & Senses**: *Invisibility*, *Greater Invisibility*, *Pass Without Trace*, *Detect Thoughts*

*Note: Focus buffs are mutually exclusive per caster. Casting a new Focus spell naturally replaces the active one.*

> [!NOTE]
> **Class Spells vs. Bound Equipment & Scrolls**:
> - **Class Spells & Feats**: Genuine class investments (e.g., Cleric/Druid/Wizard spellbooks, Bard *Magical Secrets*, multiclassing, and *Magic Initiate*) utilize the full **Focus** system.
> - **Bound Equipment & Scrolls**: Spells granted by equipment, weapons, armor, accessories (e.g. *Darkfire Shortbow*, *The Whispering Promise*, *Hellrider's Pride*, amulets/rings), and consumable scrolls intentionally follow **standard vanilla rules** (temporary duration, normal engine concentration or status, and standard damage saving throws) to preserve class identity and prevent item cheese.

### 2. Concentration (Combat Stances & Conduits)
- **Tactical Speed & Augmentation Conduits**: *Haste* (Concentration Conduit with Dual-Duration & Intelligent Lethargy Resolution: when **self-cast**, duration is **unlimited**; when cast on an **ally**, duration is **10 rounds**. Ending gracefully after 10 rounds, or dismissing voluntarily via portrait "X", hard-cast spells, reaction spells, or concentration swaps safely releases the recipient with **no Lethargy**; having your conduit broken by damage inflicts 1 turn of **Lethargy**).
- **Emanations & Auras**: *Spirit Guardians* (Radiant / Necrotic), *Aura of Vitality*, *Crusader's Mantle*, *Holy Aura*
- **Sustained Beams & Activations**: *Call Lightning*, *Moonbeam*, *Witch Bolt*, *Heat Metal*, *Sunbeam*, *Eyebite*, *Telekinesis*
- **Hazard Anchors**: *Wall of Fire*, *Darkness*, *Cloud of Daggers*, *Fog Cloud*, *Silence*, *Spike Growth*, *Sleet Storm*, *Hunger of Hadar*, *Cloudkill*, *Evard's Black Tentacles*, *Insect Plague*
- **Hard Crowd Control**: *Hold Person*, *Hold Monster*, *Hypnotic Pattern*, *Banishment*, *Tasha's Hideous Laughter*, *Slow*, *Confusion*, *Otiluke's Resilient Sphere*
- **Attack Modifiers**: *True Strike* (intentionally kept on standard short-duration vanilla rules)

### 3. The Cantrip Conundrum (Focus & Concentration Cantrips)
In vanilla Baldur's Gate 3, defensive and utility cantrips often suffer from awkward action economy and duration limits. Here is how they integrate into the Concentration Redux architecture:
- **Blade Ward (Physical Damage Aegis):** Converted to Focus (indefinite buff). Whether evaluated against vanilla's fleeting 2-turn duration or 5e update patches where it lasts 10 rounds alongside spells like *Bless*, Blade Ward is the quintessential defensive ward. As Focus, it becomes a continuous physical shield (resistance to Bludgeoning, Piercing, and Slashing weapon damage) that eliminates tedious re-casting outside turn-based combat. Because it occupies your single Focus slot, running Blade Ward creates an authentic tactical trade-off against *Shield of Faith* (+2 AC to prevent attacks from connecting), *Bless* (+1d4 attack and saves), or *Resistance* (+1d4 saves). Gear that applies Blade Ward upon healing (such as *Hellrider's Pride* or *The Reviving Hands*) continues to apply standard temporary vanilla statuses without disturbing your Focus slot.
- **Resistance (Defensive Twin to Guidance):** Converted to Focus (indefinite buff). In vanilla, Resistance is rarely used because burning an action and a concentration slot for a 10-turn +1d4 save bonus cannot compete with *Bless* or *Spirit Guardians*. As Focus, it becomes a reliable zero-slot ward for exploration and pre-buffing. Because it occupies your single Focus slot, it forces an honest tactical choice against *Bless* (+1d4 attack and saves) or *Shield of Faith* (+2 AC), while eliminating the dialogue trap during conversation saving throws.
- **Friends (Social Utility with Difficulty Awareness):** Converted to Focus layer with duration retained (10 turns). Cast almost exclusively inside dialogue rolls, vanilla Friends instantly wipes out whatever combat spell your caster was maintaining prior to the conversation. Moving it to Focus protects your active combat conduits. However, because NPC suspicion and hostility triggers fire on status expiration, its standard 10-turn timer is intentionally preserved so higher difficulty (Tactician/Honour Mode) social penalties function exactly as intended.
- **Dancing Lights (Exploration Lighting):** Converted to Focus (indefinite duration). Allows races lacking Darkvision (Humans, Halflings, Githyanki) to illuminate distant high ground or gloom-covered arenas at an 18m range without sacrificing pre-cast combat buffs. Floating wisps automatically despawn cleanly whenever you dismiss Focus or cast another buff.
- **True Strike (Preserved on Vanilla Rules):** Left on standard 2-turn combat conduit rules. True Strike is an offensive attack modifier, not a cognitive ward. Converting it to an indefinite Focus buff would either provide permanent free Advantage for zero spell slots or conflict with one-hit consumption triggers. Leaving it as a short-duration conduit preserves standard combat attack math.

### 4. Reapplication Spells (*Hex* & *Hunter's Mark*)
- When a marked target dies, the corpse target is cleanly detached from tracking while preserving `INNATE_CONCENTRATION_CASTER` on the caster.
- The free `Target_Hex_Reapply` and `Target_HuntersMark_Reapply` spells remain accessible on the hotbar and are fully whitelisted so re-marking a new foe never breaks active Concentration.

### 5. Loss of Control & Incapacitation
- If a caster is afflicted with `STUNNED`, `PARALYZED`, `PETRIFIED`, `SLEEP`, `UNCONSCIOUS`, `KNOCKED_OUT`, `INCAPACITATED`, `BANISHED`, `POLYMORPH`, or `DOWNED`/`DEAD`, Focus and all linked party buffs immediately collapse, honoring standard 5e rules.

### 6. Manual Dismissal (Releasing Spells Voluntarily)
- **Dismissing Focus (Buffs)**: While maintaining Focus (*Bless*, *Shield of Faith*, *Blade Ward*, *Guidance*), the caster automatically gains a free, 0-action cost **Dismiss Focus** ability (`Shout_DismissInnateConcentration`) on their hotbar. Using it voluntarily releases Focus on demand without needing to cast another spell or rest.
- **Dismissing Concentration (Conduits)**: Because Concentration (*Haste*, *Spirit Guardians*, *Wall of Fire*, *Cloud of Daggers*, *Hold Person*, *Fog Cloud*) runs in the engine's native concentration slot, players can cancel it at any moment using Baldur's Gate 3's **native "X" button** located directly beneath the character's portrait on the bottom-left HUD, or by casting another spell. For *Haste*, voluntarily dismissing it releases the buff cleanly **without causing Lethargy**.

### 7. Reaction Spells & Gish Wards
- **Personal Reaction Defensives (Shield & Absorb Elements)**:
  - Characters with **Combat Channeling** (those who can melee while concentrating, including *Bladesingers*, *Eldritch Knights*, *Paladins 2+*, *War/Tempest Clerics*, *Swords/Valour Bards*, *Arcane Tricksters*, *Circle of Spores Druids*, *Pact of the Blade Warlocks*, *Monks*, or anyone with *War Caster*) can cast **personal reaction defensives** (*Shield*, *Absorb Elements*) **without breaking Concentration**!
  - Pure casters lacking martial-magical discipline (e.g., standard Wizards or Sorcerers without War Caster/Bladesong) still shatter active conduits if they cast *Shield*.
- **Counter-Magic & Retaliatory Damage Reactions (Always Shatters)**:
  - Casting *Counterspell* (external offensive counter-magic) or retaliatory damage reactions (*Hellish Rebuke*) demands 100% of your spell focus and **immediately shatters active conduits for ALL casters**, including gishes.
- **Melee Spell Cantrips (Green-Flame Blade, Booming Blade, Vengeful Blade)**:
  - Characters with **Combat Channeling** can cast **melee spell cantrips** (*Green-Flame Blade*, *Booming Blade*, *Vengeful Blade*) in melee combat **without breaking Concentration**!
- **Physical Reactions & Class Features**:
  - Non-magical reactions (melee *Opportunity Attacks*) and non-spell reaction features (*Warding Flare*, *Wrath of the Storm*, *Cutting Words*, *Uncanny Dodge*, *Deflect Missiles*) expend no spell slots and are 100% safe for all casters.

### 8. Withers Respec Cleanup
- Visiting Withers to respec automatically triggers a full cleanup via `CharacterRespecCompleted`, guaranteeing no lingering buffs or statuses bleed into a newly chosen class.

---

## Combat Channeling & Gish Archetypes

Attacking with weapons while sustaining an active combat conduit requires true martial-magical discipline:

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
| **Mundane** | **Champion, Battle Master, Thief, Assassin, Barbarian** | *Never* | Raw physical momentum shatters active conduits. |

> [!IMPORTANT]
> **Smites Shatter Conduits**: Expending spell slots for magical burst strikes (*Divine Smite*, *Searing Smite*, *Thunderous Smite*, *Wrathful Smite*, *Blinding Smite*, etc.) requires an instant burst of spell focus and **immediately shatters active combat conduits** (*Spirit Guardians*), displaying an overhead notice (*"Channel broken by Smite!"*), while leaving passive Focus buffs (*Bless*, *Shield of Faith*) completely undisturbed.

> [!NOTE]
> **No Unearned Advantage**: Gish training grants the physical discipline to attack while channeling, but **does not grant Advantage on concentration saving throws** (Advantage remains strictly reserved for the *War Caster* feat or advantage gear).

---

## War Caster Synergy

The **War Caster** feat (`WarCaster_Concentration`) integrates directly into both focus layers:
- **Baseline Behavior (Without War Caster)**:
  - **Concentration**: Naturally rolls its independent Constitution saving throw with **Advantage** during Overclock (and is 100% unbreakable when solo).
  - **Channeling**: Rolls a standard 1d20 Constitution saving throw (no Advantage).
- **With War Caster**:
  - Grants **Advantage** to Channeling saving throws (both solo and during Overclock).
  - Because Concentration already rolls with Advantage, **War Caster ensures BOTH independent saving throws have Advantage during an Overclock!**
- **Reactive Spellcasting (Shocking Grasp)**: Using War Caster to cast *Shocking Grasp* as an Opportunity Attack reaction in lieu of a melee strike is **explicitly permitted and will NOT break Channeling**. (Casting *Shocking Grasp* with an Action on your own turn remains standard spellcasting and breaks the channel).

---

## Changelog

### v1.0.4
- **Blade Ward Focus Conversion**:
  - Converted *Blade Ward* (`Shout_BladeWard`) into an indefinite **Focus** buff (`INNATE_BUFF_BLADE_WARD`, duration -1).
  - Grants continuous resistance to Bludgeoning, Piercing, and Slashing weapon damage, occupying your single Focus slot to force genuine tactical trade-offs against *Shield of Faith* (+2 AC), *Bless* (+1d4 attack/saves), or *Resistance*.
  - Equipment procs applying Blade Ward on heal (e.g. *Hellrider's Pride*, *The Reviving Hands*) continue to apply standard vanilla short-duration statuses without disturbing your Focus slot.
- **Tactical Movement & Action Whitelist Fix**:
  - Fixed Jump (`Projectile_Jump`, `Projectile_Jump_Monk`), Crouch/Stealth (`Shout_Hide`, `Shout_CunningAction_Hide`), Dash (`Shout_Dash`, `Shout_ActionSurge_Dash`, `Shout_StepOfTheWind_Dash`), Disengage (`Shout_Disengage`), Shove (`Target_Shove`), Dip (`Shout_Dip`), Throw (`Throw_Throw`), and Help (`Target_Help`) inadvertently collapsing active combat conduits with a *"Channel broken by spellcasting!"* overhead notice.
  - Implemented an `IsWhitelistedAction` pattern-matching filter in the server engine to automatically recognize all current and future tactical movement actions, bonus actions, and stance variants.

### v1.0.3
- **Cantrip Focus Overhaul**:
  - **Resistance**: Converted to the Focus layer (`INNATE_BUFF_RESISTANCE`, indefinite duration). Serves as a zero-slot defensive counterpart to *Guidance* for exploration and conversation saving throws, mutually exclusive with *Bless* and *Shield of Faith*.
  - **Friends**: Converted to Focus (`INNATE_BUFF_FRIENDS`) to prevent dialogue rolls from breaking pre-cast combat conduits. Standard 10-turn duration intentionally preserved so Tactician and Honour Mode NPC hostility triggers function as designed.
  - **Dancing Lights**: Converted to Focus (`INNATE_BUFF_DANCING_LIGHTS`, indefinite duration) to allow 18m ranged illumination without sacrificing combat buffs. Floating wisps despawn cleanly upon dismissing or replacing Focus.
  - **True Strike**: Formally preserved on vanilla 2-turn combat conduit rules to protect combat attack math.
- **Documentation & UI**:
  - Added Section 3 ("The Cantrip Conundrum") explaining cantrip design philosophy and balance choices.
  - Fixed unsupported `[olist]` BBCode tags on Nexus to standard `[list]`.
  - Documented emergency reaction spell disruption (*Shield*, *Counterspell*, *Hellish Rebuke*) and whitelisted reapplication spells (*Hex*, *Hunter's Mark*, *Call Lightning*).
- **Tooling & Build System**:
  - Updated `build.ps1` to structure internal package directories with the Patch 7 UUID (`ConcentrationRedux_5ca2dda8-eedc-41be-95f0-50747d552d10.pak`) and automatically synchronize release archives.

### v1.0.2
- **Smite Disruption**:
  - Expending spell slots for magical strikes (*Divine Smite*, *Searing Smite*, *Thunderous Smite*, *Wrathful Smite*, etc.) now immediately shatters active combat conduits (*Spirit Guardians*), displaying an overhead notice (*"Channel broken by Smite!"*). Passive Focus buffs (*Bless*, *Shield of Faith*) remain undisturbed.
- **Combat Channeling & Gish Archetype Overhaul**:
  - **Monk**: Granted at Level 1 across all subclasses (core spiritual discipline and Ki flow).
  - **Paladin & Ranger**: Unlocked at Level 2 alongside their official Spellcasting feature (Level 1 characters remain mundane combatants).
  - **Eldritch Knight Fighter & Arcane Trickster Rogue**: Unlocked at Level 3. Mundane fighters (*Champion*, *Battle Master*) and rogues (*Thief*, *Assassin*) cannot attack while maintaining active conduits.
  - **Bladesinger Wizard**: Added full support for Bladesingers and active *Bladesong*.
  - **College of Swords & Valour Bard**: Added full support for Blade Flourishes and battle skalds.
  - **Pact of the Blade Warlock**: Added full support for Bound Pact Weapons and Hexblades.
  - **Circle of Spores Druid**: Added full support for frontline melee and *Symbiotic Entity*.
  - **Barbarian Exclusion**: Pure physical rage continues to disrupt active concentration conduits.
- **War Caster Synergy**:
  - Clarified that gish multiclassing allows weapon attacks while channeling, but does not grant unearned Advantage on concentration saving throws (Advantage remains exclusive to War Caster or advantage gear).

### v1.0.1
- Fixed `IsWeaponAction` Script Extender crash when casting spells while concentrating.
- Added *Guidance* as a zero-slot Focus buff.
- Improved active conduit interruption with `AI_HELPER_BREAKCONCENTRATION`.

### v1.0.0
- Initial release of Concentration Redux: two-layer focus economy (Focus vs. Concentration), The Overclock, 36+ converted spells, and custom UI portrait badges.

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

