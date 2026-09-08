# Concentration Redux: NPC & Enemy AI Behavior Reference

This document provides a technical and design breakdown of how **Concentration Redux** interacts with non-player characters (NPCs), enemies, boss encounters, and the underlying Baldur's Gate 3 / Divinity Engine 4 combat AI.

---

## 1. Architectural Scope: Global Spell Overrides vs. Isolated Statuses

### Global Spell Metadata
In Baldur's Gate 3, spell entries like `Target_Bless`, `Target_ShieldOfFaith`, and `Target_Haste` in `Spell_Target.txt` are shared engine-wide. Because Concentration Redux modifies these base class spells, **any humanoid enemy, ally, or neutral NPC that casts these standard class spells casts the modded version**.

### Status Isolation
The mod **does not overwrite the base game's vanilla status entries** (`BLESS`, `SHIELD_OF_FAITH`, `HASTE`). Instead, it routes class spells into dedicated custom statuses (`INNATE_BUFF_BLESS`, `CHANNEL_HASTE`, etc.).

* **Pre-Scripted Encounters & Bosses:** Enemies that start an encounter with pre-applied, scripted buffs placed via the level editor or story scripts (e.g. pre-cast `BLESS`, `SANCTUARY`, `HASTE`, or unique boss auras like Nere's *Shield of Screams* or Cazador's *Mist Form*) use vanilla status IDs. These are **not altered or hijacked** by the mod and run on standard vanilla logic.
* **Class Spells Only:** The custom behavior activates when an NPC actively *casts* a supported class spell during gameplay.

---

## 2. Enemy Focus Buffs (*Bless*, *Shield of Faith*, *Barkskin*, *Blur*, etc.)

When an enemy spellcaster (such as a Goblin Boastful Priest, Cultist of the Absolute, or Flaming Fist Cleric) casts a Focus spell:

### Indefinite Duration
Focus buffs no longer expire after 10 rounds (60 seconds). As long as the enemy caster remains alive and conscious, their allies remain buffed throughout combat.

### 100% Unbreakable by Damage (Solo Focus)
In `main.lua`, the damage listener checks whether the damaged caster is in **Solo Focus** or **The Overclock**:
```lua
-- If victim is NOT in Overclock (Focus only), Focus is unburdened: 100% UNBREAKABLE!
if not hasConc then
    return
end
```
* **Effect:** If the enemy caster is only maintaining a Focus buff, **taking damage (e.g. an arrow, Magic Missile, or surface fire tick) will NOT break the buff**.
* **Design Impact:** Enemy support casters become authentic tactical priority targets rather than pushovers whose buffs can be trivially wiped by 1-damage chip attacks.

### Player Counterplay Against Enemy Buffers
Players have three distinct methods to dismantle enemy Focus buffs:
1. **Kill the Caster:** The `Died` event hook in `main.lua` immediately calls `CleanUpInnateBuffs(char)`, stripping the buff from all recipients.
2. **Hard Crowd Control (Incapacitation):** Inflicting hard CC (*Hold Person*, *Sleep*, *Hypnotic Pattern*, *Banishment*, *Tasha's Hideous Laughter*, *Stun*, or *Paralysis*) triggers `IsIncapacitatingStatus`, instantly collapsing Focus (`"Focus Lost (Incapacitated)"`).
3. **Eliminate the Recipient:** Damaging or killing the buffed frontline enemy directly.

---

## 3. Combat AI Decision-Making: Why Enemies Don't "Chain-Cast" Bless

A common concern with non-concentration buffs is whether the enemy AI will get stuck repeatedly casting *Bless* every turn because it doesn't "see" that it is concentrating.

**The AI will not chain-cast Bless.** Here is why:

### Utility Scoring Based on Status Presence
The BG3 combat AI does not operate on a rule of *"If I am not concentrating, cast a buff."* Instead, it uses **Utility Scoring** evaluated against `TooltipStatusApply` and `SpellProperties`:
1. When evaluating `Target_Bless`, the AI scans valid targets in range against `INNATE_BUFF_BLESS`.
2. The AI calculates:
   $$\text{Utility Score} = \text{Benefit of applying status to unbuffed targets} - \text{Resource Costs (Action Point + Level 1 Spell Slot)}$$
3. Once an enemy ally has `INNATE_BUFF_BLESS`, the engine calculates the utility gain of re-applying that status to them as **0**.
4. An action with **0 utility gain and positive resource costs** produces a negative score.
5. The AI discards `Bless` and selects an action with positive utility—such as *Guiding Bolt*, *Sacred Flame*, *Inflict Wounds*, *Hold Person*, or a weapon attack.

### Stacking Immunity
`INNATE_BUFF_BLESS` inherits from `BLESS` and uses:
```txt
data "StackId" "INNATE_CONCENTRATION_BUFF"
data "StackPriority" "1"
```
The game engine recognizes it as a non-stacking unique status. The AI cannot "double bless" a target.

### Server Script Protection (`CleanUpInnateBuffs`)
Even if an enemy caster attempts to cast another Focus spell (e.g. switching from *Bless* to *Shield of Faith*):
* The `UsingSpell` hook (`existing.Spell ~= spell`) automatically purges their prior Focus buff before applying the new one.
* An enemy caster can **never stack multiple Focus buffs** from themselves simultaneously.

---

## 4. Enemy AI & "The Overclock"

### Liberated Spellcasting Bandwidth
In vanilla BG3, an enemy cleric who casts *Bless* on Turn 1 will lose it on Turn 2 if they cast an offensive spell like *Hold Person*, *Moonbeam*, or *Spirit Guardians*. 

Because *Bless* no longer requires the engine's native concentration slot, **the enemy AI can maintain its defensive buff on Turn 1 and freely cast an offensive concentration spell on Turn 2**.

### Overclock Damage Saves for Enemies
When an enemy maintains both Focus and an active combat conduit, they enter **The Overclock**:
1. When damaged, the native engine rolls a standard concentration saving throw for their conduit (*Hold Person*).
2. Concurrently, the server script rolls an independent Constitution saving throw **with Advantage** for their Focus (*Bless*), factoring in the enemy's Constitution modifier and level.
3. If the player breaks the enemy's offensive concentration, their *Bless* remains active.

---

## 5. Enemy Combat Channeling & Martial Archetypes

### Dynamic Class & Passive Detection
The mod inspects character tags, class hierarchies, and signature passives dynamically:
* `DivineSmite`, `Paladin_Spellcasting` (Paladins 2+)
* `Ranger_Spellcasting` (Rangers 2+)
* `WarPriest`, `WrathOfTheStorm` (War & Tempest Clerics)
* `UnarmoredDefense_Monk`, `Ki_Passive` (Monks)
* `BladeFlourish`, `CombatInspiration` (Swords & Valour Bards)
* `PactOfTheBlade`, `Hexblade` (Blade Warlocks)
* `WeaponBond`, `WarMagic` (Eldritch Knights)
* `SymbioticEntity`, `HaloOfSpores` (Spores Druids)

### Gishes vs. Pure Casters
* **Enemy Gishes:** Enemy Paladins (e.g. Minthara, Ketheric Thorm, Flaming Fist Paladins), Githyanki warriors, and enemy Monks/Rangers are recognized as Combat Channelers. They can sustain an active combat conduit (*Hold Person*, *Spirit Guardians*) and attack players with weapons without losing concentration.
* **Pure Enemy Mages:** Generic enemy Wizards, Necromancers, or Cultists who lack martial passives will drop active combat conduits if they make a physical weapon attack (displaying `"Channel broken by physical attack!"`).
* **Enemy Smites:** If an enemy Paladin expends a spell slot on *Divine Smite* while concentrating on a conduit like *Hold Person*, the smite hook shatters the combat conduit (`"Channel broken by Smite!"`) while preserving any passive Focus buff (*Heroism*, *Bless*).

---

## 6. Enemy *Haste* & Player Disruption Rewards

When an enemy spellcaster casts `Target_Haste`:

### Dual-Duration
* **Self-Cast:** Operates as an indefinite combat conduit (`CHANNEL_HASTE`).
* **Ally-Cast:** Operates for 10 tactical rounds (`CHANNEL_HASTE_ALLY`).

### Tactical Disruption Rewards
The mod's Haste tracker actively tracks enemy casters and their targets:
* If the player breaks the enemy caster's concentration via damage, an environmental surface check, or hard crowd control (*Hold Person*, *Sleep*, *Hypnotic Pattern*, *Banishment*, *Stun*):
  * The server script flags an **involuntary disruption** (`isViolentDisruption = true`).
  * The buffed enemy (whether a boss or an elite minion) is immediately afflicted with **`HASTE_LETHARGY` for 1 round (6.0s)**, displaying overhead:
    `"Lethargic! (Damage Disruption)"` or `"Lethargic! (Incapacitated Disruption)"`.
  * The enemy target loses its turn, making disrupting enemy Haste casters rewarding.

---

## Summary Matrix

| Mechanics Area | Behavior on Enemies & NPCs |
| :--- | :--- |
| **Focus Buffs (*Bless*, *Shield of Faith*)** | Indefinite duration. 100% immune to chip damage in Solo Focus. Broken on caster death, hard CC (*Hold Person*, *Sleep*, *Stun*), or buff replacement. |
| **Chain-Casting Prevention** | AI utility scoring evaluates `INNATE_BUFF_BLESS` presence on targets. Costing resources for 0 utility produces negative score; AI moves to offensive actions. |
| **The Overclock** | AI can cast *Bless* on Turn 1 and *Hold Person* on Turn 2. Damage rolls standard saves for conduit and independent Advantage saves for Focus. |
| **Combat Channeling** | Enemy Paladins, Githyanki, Monks, and Rangers attack without dropping conduits; pure enemy mages drop conduits if making physical strikes. |
| **Smites** | Enemy *Divine Smite* shatters active combat conduits (*Hold Person*), leaving Focus buffs intact. |
| **Haste Disruption** | Breaking an enemy caster's Haste slaps the buffed enemy with 1 round of **Lethargy**. |
| **Pre-scripted Encounters** | Vanilla status IDs and boss-specific auras remain completely untouched and vanilla-compliant. |
