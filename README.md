<p align="center">
  <img src="Mods/ConcentrationRedux/icon.png" width="180" height="180" alt="Concentration Redux Emblem" />
</p>

# Concentration Redux

A Baldur's Gate 3 mod powered by Norbyte's **Script Extender (BG3SE)** that redesigns the game's concentration economy into two distinct cognitive layers: **Focus** and **Concentration**.

---

## The Philosophy: Cognitive Bandwidth

In vanilla 5e / Baldur's Gate 3, concentration creates arbitrary friction:
- High-value party buffs (*Bless*, *Shield of Faith*, *Haste*) compete with active combat emanations (*Spirit Guardians*, *Wall of Fire*), turning casters into passive buff-bots or forcing them to completely abandon party support.
- Buffs vanish from stray 1-damage surface ticks or off-screen archers.
- Outside turn-based combat, 10-turn (60-second) timers expire while looting chests or reading dialogue.

**Concentration Redux** redesigns spellcaster focus into three tactical stances:

| Stance | Conditions | Defensive Resilience | Allowed Actions |
|---|---|---|---|
| **Pure Support** (Solo Focus) | Only Focus is active (*Bless*, *Shield of Faith*, *Heroism*, *Haste*, etc.) | **100% Unbreakable by Damage**. No Constitution saving throws against damage ticks or surfaces. Hard CC (Stun, Paralysis, Sleep, Incapacitation) shatters Focus. | All actions, spells, and attacks permitted. Indefinite duration until Long Rest or manual dismissal. |
| **Dedicated Juggernaut** (Solo Concentration) | Only a Concentration spell is active (*Spirit Guardians*, *Wall of Fire*, *Hold Person*, *Fog Cloud*) | Uses native engine concentration slot with standard Con saves. Benefits from **War Caster** Advantage. | Whitelisted stances (*Dodge*, *Dash*, *Shove*, *Throw*, etc.). Weapon attacks permitted for **Combat Domains** (*War*, *Tempest*). Casting other spells breaks concentration. |
| **The Overclock** (Both Active) | Both Focus and Concentration are maintained simultaneously | **Dual Focus Bandwidth**: Focus remains resilient while Concentration rolls standard saves with **War Caster** Advantage. | Pushes mental focus to the limit. If Concentration drops first, the remaining Focus gracefully continues undisturbed. |

---

## Spell Classifications

### 1. Focus (Indefinite Duration Buffs)
- **Combat & Defensive Wards**: *Bless*, *Shield of Faith*, *Guidance*, *Resistance*, *Heroism*, *Protection from Evil and Good*, *Barkskin*, *Stoneskin*, *Shield of Thralls*
- **Utility & Exploration**: *Dancing Lights* (indefinite remote illumination that never strips pre-cast buffs)
- **Social Charms (10-Turn Timer)**: *Friends* (routed to Focus to protect combat conduits during dialogue checks, while retaining its 10-turn timer for Tactician/Honour Mode hostility)
- **Single-Target Marks**: *Hunter's Mark*, *Hex*, *Bane*, *Bestow Curse*
- **Physical Augmentations**: *Haste*, *Enlarge/Reduce*, *Fly*, *Expeditious Retreat*, *Blur*, *Magic Weapon*, *Elemental Weapon*
- **Stealth & Senses**: *Invisibility*, *Greater Invisibility*, *Pass Without Trace*, *Detect Thoughts*

*Note: Focus buffs are mutually exclusive per caster. Casting a new Focus spell naturally replaces the active one.*

> [!NOTE]
> **Class Spells vs. Bound Equipment & Scrolls**:
> - **Class Spells & Feats**: Genuine class investments (e.g., Cleric/Druid/Wizard spellbooks, Bard *Magical Secrets*, multiclassing, and *Magic Initiate*) utilize the full **Focus** system.
> - **Bound Equipment & Scrolls**: Spells granted by equipment, weapons, armor, accessories (e.g. *Darkfire Shortbow*, *The Whispering Promise*, amulets/rings), and consumable scrolls intentionally follow **standard vanilla rules** (10-turn duration, normal engine concentration, and standard damage saving throws) to preserve class identity and prevent item cheese.

### 2. Concentration (Combat Stances & Conduits)
- **Emanations & Auras**: *Spirit Guardians* (Radiant / Necrotic), *Aura of Vitality*, *Crusader's Mantle*, *Holy Aura*
- **Sustained Beams & Activations**: *Call Lightning*, *Moonbeam*, *Witch Bolt*, *Heat Metal*, *Sunbeam*, *Eyebite*, *Telekinesis*
- **Hazard Anchors**: *Wall of Fire*, *Darkness*, *Cloud of Daggers*, *Fog Cloud*, *Silence*, *Spike Growth*, *Sleet Storm*, *Hunger of Hadar*, *Cloudkill*, *Evard's Black Tentacles*, *Insect Plague*
- **Hard Crowd Control**: *Hold Person*, *Hold Monster*, *Hypnotic Pattern*, *Banishment*, *Tasha's Hideous Laughter*, *Slow*, *Confusion*, *Otiluke's Resilient Sphere*
- **Attack Modifiers**: *True Strike* (intentionally kept on standard short-duration vanilla rules)

### 3. Reapplication Spells (*Hex* & *Hunter's Mark*)
- When a marked target dies, the corpse target is cleanly detached from tracking while preserving `INNATE_CONCENTRATION_CASTER` on the caster.
- The free `Target_Hex_Reapply` and `Target_HuntersMark_Reapply` spells remain accessible on the hotbar and are fully whitelisted so re-marking a new foe never breaks active Concentration.

### 4. Loss of Control & Incapacitation
- If a caster is afflicted with `STUNNED`, `PARALYZED`, `PETRIFIED`, `SLEEP`, `UNCONSCIOUS`, `KNOCKED_OUT`, `INCAPACITATED`, `BANISHED`, `POLYMORPH`, or `DOWNED`/`DEAD`, Focus and all linked party buffs immediately collapse, honoring standard 5e rules.

### 5. Manual Dismissal (Releasing Spells Voluntarily)
- **Dismissing Focus (Buffs)**: While maintaining Focus (*Bless*, *Haste*, *Shield of Faith*, *Guidance*), the caster automatically gains a free, 0-action cost **Dismiss Focus** ability (`Shout_DismissInnateConcentration`) on their hotbar. Using it voluntarily releases Focus on demand without needing to cast another spell or rest.
- **Dismissing Concentration (Conduits)**: Because Concentration (*Spirit Guardians*, *Wall of Fire*, *Cloud of Daggers*, *Hold Person*, *Fog Cloud*) runs in the engine's native concentration slot, players can cancel it at any moment using Baldur's Gate 3's **native "X" button** located directly beneath the character's portrait on the bottom-left HUD, or by casting another spell.

### 6. Reaction Spells (Strict Mode Enforced)
- **Zero Spell Magic While Channeling**: Casting reaction spells (*Shield*, *Counterspell*, *Hellish Rebuke*) immediately **shatters** Channeling. Maintaining a continuous combat conduit demands 100% of your magical bandwidth; attempting to weave an emergency spell snaps the tether.
- **In-Game Warning Popups**: The mod injects a dedicated **Channel Disruption** warning into the tooltip and reaction prompt card of all three reaction spells:
  > ⚠️ *Channel Disruption: Casting this spell requires complete magical focus and will immediately shatter any active Channel.*
- **Reactions Tab ("Ask" Toggle)**: Keep **"Ask"** checked (the question mark icon) in your character's Reactions tab (`K`) for *Shield*, *Counterspell*, and *Hellish Rebuke*. The game will always pause combat and prompt you before casting, preventing accidental channel loss while letting you deliberately trade your channel in life-or-death situations.
- **Physical Reactions Allowed**: Non-magical physical reactions (e.g. melee *Opportunity Attacks*) remain fully permitted for gish archetypes.
- **Class Abilities Allowed**: Non-spell reaction features (*Warding Flare*, *Wrath of the Storm*, *Cutting Words*, *Uncanny Dodge*, *Deflect Missiles*) do not use spell slots and do not disrupt Channeling.

### 7. Withers Respec Cleanup
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

## Installation & Development

### Requirements
- Baldur's Gate 3 (Patch 7 / Patch 8+)
- [Baldur's Gate 3 Script Extender (BG3SE)](https://github.com/Norbyte/bg3se) (v32+) with console enabled (`Console.CreateConsole = true` in `bin/ScriptExtenderSettings.json`).

### Deployment & Packaging Options
Run PowerShell in the project root:
```powershell
# Validate all files
.\build.ps1

# Package into .pak and install to AppData Mods (for Vortex / BG3MM / Patch 7)
.\build.ps1 -Package

# Deploy loose files directly into Baldur's Gate 3\Data (for active live development)
.\build.ps1 -Deploy

# Remove deployed mod files
.\build.ps1 -Clean
```

### Live Reloading
When playing with the loose files installed, open the BG3SE console and type:
```
reset
```
This reloads `main.lua` instantaneously without needing to restart the game.
