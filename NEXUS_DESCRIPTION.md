# Concentration Redux
*Dual-Stance Spellcasting Architecture for Baldur's Gate 3*

---

## Description
In D&D 5e and vanilla Baldur's Gate 3, nearly every iconic spell competes for a single, restrictive concentration slot. Casting a staple buff like *Bless* or *Shield of Faith* locks your caster out of using combat spells like *Spirit Guardians*, *Wall of Fire*, *Call Lightning*, or *Hold Person*. Worse, buffs vanish from a single 1-damage surface tick or an off-screen archer, and 10-turn timers expire while looting chests or reading dialogue.

**Concentration Redux** redesigns spellcaster focus into two distinct, congruent cognitive layers:
- **Focus (Buff Layer):** Indefinite, damage-unbreakable utility and defensive wards (*Bless*, *Shield of Faith*, *Haste*, *Heroism*).
- **Concentration (Conduit Layer):** High-intensity, stance-based combat conduits (*Spirit Guardians*, *Wall of Fire*, *Fog Cloud*, *Moonbeam*).
- **The Overclock:** Maintain both simultaneously! Pushes mental bandwidth to the limit with independent saving throws.

---

## Installation instructions
1. Download the mod archive from the **Files** tab.
2. Import and install via **Vortex** or **Baldur's Gate 3 Mod Manager (BG3MM)**.
3. Ensure **Concentration Redux** is enabled in your active load order and export.
4. Launch the game—safe to install mid-playthrough!

---

## Main features

### 1. Three Tactical Stances
- **Pure Support (Solo Focus):** Only Focus is active. **100% Unbreakable by Damage.** No Constitution saves against damage ticks or surfaces. Indefinite duration until Long Rest or manual dismissal.
- **Dedicated Juggernaut (Solo Concentration):** Only a combat conduit is active. Uses the native engine concentration slot with standard Con saves (benefits from War Caster). Whitelisted tactical actions (*Dash*, *Disengage*, *Shove*, *Throw*). Weapon attacks allowed for martial domains (*War* & *Tempest*).
- **The Overclock (Both Active Simultaneously):** Maintain both Focus and Concentration at the same time! When damaged, the native conduit rolls standard saves, while Focus independently rolls a Constitution saving throw **with Advantage**! If the combat conduit drops, Focus gracefully continues undisturbed.

### 2. Spell Classifications
- **Focus Spells (Indefinite Buffs):**
  - **Wards & Protection:** *Bless*, *Shield of Faith*, *Guidance*, *Heroism*, *Protection from Evil and Good*, *Barkskin*, *Stoneskin*, *Shield of Thralls*
  - Single-Target Marks: *Hunter's Mark*, *Hex*, *Bane*, *Bestow Curse* (reapplication abilities are whitelisted and never break active conduits)
  - Augmentations & Stealth: *Haste*, *Enlarge/Reduce*, *Fly*, *Blur*, *Invisibility*, *Pass Without Trace*, *Detect Thoughts*
- **Concentration Spells (Combat Conduits):**
  - Auras & Beams: *Spirit Guardians*, *Aura of Vitality*, *Crusader's Mantle*, *Call Lightning*, *Moonbeam*, *Witch Bolt*, *Heat Metal*, *Sunbeam*, *Telekinesis*
  - Hazard Anchors: *Wall of Fire*, *Cloud of Daggers*, *Fog Cloud*, *Darkness*, *Silence*, *Spike Growth*, *Sleet Storm*, *Hunger of Hadar*, *Cloudkill*
  - Hard CC: *Hold Person*, *Hold Monster*, *Hypnotic Pattern*, *Banishment*, *Tasha's Hideous Laughter*, *Slow*, *Confusion*

> **Class Spells vs. Bound Gear & Scrolls:** Genuine class investments utilize the full Focus system. Spells granted by equipment (e.g. Whispering Promise, Darkfire Shortbow) and consumable scrolls follow standard vanilla rules (10-turn limit, standard damage saves) to prevent item abuse.

### 3. UI & Visual Clarity
- **Congruent Portrait Badges:** Side-by-side badges in the portrait buff tray (Radiant Sun for **Focus**, glowing Mind Conduit for **Concentration**).
- **Dismissing Focus:** Free, 0-action **Dismiss Focus** ability added to your hotbar.
- **Dismissing Concentration:** Uses BG3's **native 'X' button** beneath the portrait HUD (or casting another conduit).

- **Combat Channeling & Gish Archetypes:** Making weapon attacks while maintaining an active combat conduit requires true mind-body magical discipline:
  - **War Domain & Tempest Domain Clerics** (Level 1)
  - **Monks** (Level 1+: core spiritual discipline and Ki flow)
  - **Paladins & Rangers** (Level 2+: when spellcasting unlocks; level 1 characters are mundane combatants)
  - **Bladesinger Wizards** (Level 2+: the epitome of martial blade-magic and Bladesong)
  - **Eldritch Knight Fighters & Arcane Trickster Rogues** (Level 3+: dedicated martial-arcane gishes)
  - *Mundane fighters (Champion/Battle Master), mundane rogues (Thief/Assassin), and Barbarians cannot attack without disrupting active Concentration.*
- **Smites Shatter Conduits:** Expending spell slots for magical strikes (*Divine Smite*, *Searing Smite*, *Thunderous Smite*, *Wrathful Smite*, etc.) requires a burst of spellcasting focus and **immediately shatters active combat conduits** (*Spirit Guardians*), while leaving passive Focus buffs (*Bless*, *Shield of Faith*) completely undisturbed!
- **War Caster Synergy:** Grants Advantage to Channeling saves. Because Focus already rolls with Advantage during Overclock, **War Caster ensures BOTH independent saves have Advantage!** Casting *Shocking Grasp* as an Opportunity Attack reaction via War Caster is fully permitted.
- **Strict Reaction Discipline:** Casting emergency reaction spells (*Shield*, *Counterspell*, *Hellish Rebuke*) shatters active combat conduits (clear tooltip warnings provided).
- **Loss of Control (5e Compliant):** Hard incapacitation (*Stunned*, *Paralyzed*, *Petrified*, *Sleep*, *Unconscious*, *Downed*, *Dead*) shatters Focus and all linked party buffs.

---

## Requirements
- **Baldur's Gate 3:** Patch 7 or Patch 8+
- **Script Extender:** [Baldur's Gate 3 Script Extender (BG3SE)](https://github.com/Norbyte/bg3se/releases) (v32 or newer recommended)

---

## Support the Project
If Concentration Redux made your spellcasters fun and tactically rewarding to play, consider buying me a coffee! Any support is deeply appreciated and helps fuel future updates:

☕ **[Support on Ko-fi (ko-fi.com/nihilxd)](https://ko-fi.com/nihilxd)**
