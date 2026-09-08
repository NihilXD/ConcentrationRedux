# Concentration Redux
*Dual-Stance Spellcasting Architecture for Baldur's Gate 3*

---

## Description
In D&D 5e and vanilla Baldur's Gate 3, nearly every iconic spell competes for a single, restrictive concentration slot. Casting a staple buff like *Bless* or *Shield of Faith* locks your caster out of using combat spells like *Spirit Guardians*, *Wall of Fire*, *Call Lightning*, or *Hold Person*. Worse, buffs vanish from a single 1-damage surface tick or an off-screen archer, and 10-turn timers expire while looting chests or reading dialogue.

**Concentration Redux** redesigns spellcaster focus into two distinct, congruent cognitive layers:
- **Focus (Buff Layer):** Indefinite, damage-unbreakable utility and defensive wards (*Bless*, *Shield of Faith*, *Blade Ward*, *Heroism*).
- **Concentration (Conduit Layer):** High-intensity, stance-based combat conduits (*Haste*, *Spirit Guardians*, *Wall of Fire*, *Fog Cloud*, *Moonbeam*).
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
  - **Wards & Protection:** *Bless*, *Shield of Faith*, *Blade Ward*, *Guidance*, *Resistance*, *Heroism*, *Protection from Evil and Good*, *Barkskin*, *Stoneskin*, *Shield of Thralls*
  - **Utility & Exploration:** *Dancing Lights* (indefinite remote illumination that never strips pre-cast buffs)
  - **Social Charms (10-Turn Timer):** *Friends* (routed to Focus to protect combat conduits during dialogue checks, while retaining its 10-turn timer for Tactician/Honour Mode hostility)
  - **Single-Target Marks:** *Hunter's Mark*, *Hex*, *Bane*, *Bestow Curse* (reapplication abilities are whitelisted and never break active conduits)
  - **Augmentations & Stealth:** *Enlarge/Reduce*, *Fly*, *Blur*, *Invisibility*, *Pass Without Trace*, *Detect Thoughts*
- **Concentration Spells (Combat Conduits):**
  - Speed & Augmentation Conduits: *Haste* (Indefinite Channel Conduit: voluntary dismissal via portrait "X", hard-cast spells, reaction spells, or concentration swaps cleanly ends Haste with **no Lethargy**; channel broken via damage inflicts 1 turn of **Lethargy**)
  - Auras & Beams: *Spirit Guardians*, *Aura of Vitality*, *Crusader's Mantle*, *Call Lightning*, *Moonbeam*, *Witch Bolt*, *Heat Metal*, *Sunbeam*, *Telekinesis*
  - Hazard Anchors: *Wall of Fire*, *Cloud of Daggers*, *Fog Cloud*, *Darkness*, *Silence*, *Spike Growth*, *Sleet Storm*, *Hunger of Hadar*, *Cloudkill*
  - Hard CC: *Hold Person*, *Hold Monster*, *Hypnotic Pattern*, *Banishment*, *Tasha's Hideous Laughter*, *Slow*, *Confusion*
  - Attack Modifiers: *True Strike* (intentionally kept on standard short-duration vanilla rules)

> **Class Spells vs. Bound Gear & Scrolls:** Genuine class investments utilize the full Focus system. Spells granted by equipment (e.g. Whispering Promise, Hellrider's Pride, Darkfire Shortbow) and consumable scrolls follow standard vanilla rules (temporary duration, standard damage saves) to prevent item abuse.

### 3. The Cantrip Conundrum (Focus & Concentration Cantrips)
In vanilla Baldur's Gate 3, defensive and utility cantrips often suffer from awkward action economy and duration limits. Here is how they integrate into the Concentration Redux architecture:
- **Blade Ward (Physical Damage Aegis):** Converted to Focus (indefinite buff). Whether evaluated against vanilla's fleeting 2-turn duration or 5e update patches where it lasts 10 rounds alongside spells like *Bless*, Blade Ward is the quintessential defensive ward. As Focus, it becomes a continuous physical shield (resistance to Bludgeoning, Piercing, and Slashing weapon damage) that eliminates tedious re-casting outside turn-based combat. Because it occupies your single Focus slot, running Blade Ward creates an authentic tactical trade-off against *Shield of Faith* (+2 AC to prevent attacks from connecting), *Bless* (+1d4 attack and saves), or *Resistance* (+1d4 saves). Gear that applies Blade Ward upon healing (such as *Hellrider's Pride* or *The Reviving Hands*) continues to apply standard temporary vanilla statuses without disturbing your Focus slot.
- **Resistance (Defensive Twin to Guidance):** Converted to Focus (indefinite buff). In vanilla, Resistance is rarely used because burning an action and a concentration slot for a 10-turn +1d4 save bonus cannot compete with *Bless* or *Spirit Guardians*. As Focus, it becomes a reliable zero-slot ward for exploration and pre-buffing. Because it occupies your single Focus slot, it forces an honest tactical choice against *Bless* (+1d4 attack and saves) or *Shield of Faith* (+2 AC), while eliminating the dialogue trap during conversation saving throws.
- **Friends (Social Utility with Difficulty Awareness):** Converted to Focus layer with duration retained (10 turns). Cast almost exclusively inside dialogue rolls, vanilla Friends instantly wipes out whatever combat spell your caster was maintaining prior to the conversation. Moving it to Focus protects your active combat conduits. However, because NPC suspicion and hostility triggers fire on status expiration, its standard 10-turn timer is intentionally preserved so higher difficulty (Tactician/Honour Mode) social penalties function exactly as intended.
- **Dancing Lights (Exploration Lighting):** Converted to Focus (indefinite duration). Allows races lacking Darkvision (Humans, Halflings, Githyanki) to illuminate distant high ground or gloom-covered arenas at an 18m range without sacrificing pre-cast combat buffs. Floating wisps automatically despawn cleanly whenever you dismiss Focus or cast another buff.
- **True Strike (Preserved on Vanilla Rules):** Left on standard 2-turn combat conduit rules. True Strike is an offensive attack modifier, not a cognitive ward. Converting it to an indefinite Focus buff would either provide permanent free Advantage for zero spell slots or conflict with one-hit consumption triggers. Leaving it as a short-duration conduit preserves standard combat attack math.

### 4. UI & Visual Clarity
- **Congruent Portrait Badges:** Side-by-side badges in the portrait buff tray (Radiant Sun for **Focus**, glowing Mind Conduit for **Concentration**).
- **Dismissing Focus:** Free, 0-action **Dismiss Focus** ability added to your hotbar.
- **Dismissing Concentration:** Uses BG3's **native 'X' button** beneath the portrait HUD (or casting another conduit).

### 5. Tactical Synergies & Rules
- **Spellcasting Snaps Conduits:** Channeling an active combat conduit (*Spirit Guardians*, *Wall of Fire*, *Call Lightning*) demands 100% of your spellcasting bandwidth:
  - Hard-casting any standard spell (*Fireball*, *Guiding Bolt*, *Magic Missile*) immediately snaps your active conduit. (Casting a Focus buff like *Bless* or *Shield of Faith* enters **The Overclock**).
  - Casting emergency reaction spells (*Shield*, *Counterspell*, *Hellish Rebuke*) also snaps active conduits (clear in-game tooltip warnings provided).
  - *Non-spell reactions* (*Warding Flare*, *Wrath of the Storm*, *Cutting Words*, *Uncanny Dodge*, *Deflect Missiles*) expend no spell slots and are 100% safe to use!
- **Smites Shatter Conduits:** Expending spell slots for magical burst strikes (*Divine Smite*, *Searing Smite*, *Thunderous Smite*, *Wrathful Smite*, *Blinding Smite*, etc.) requires an instant burst of spell focus and **immediately shatters active combat conduits** (*Spirit Guardians*), while leaving passive Focus buffs (*Bless*, *Shield of Faith*) completely undisturbed!
- **Combat Channeling & Gish Archetypes:** Making weapon attacks while maintaining an active combat conduit requires true mind-body magical discipline:
  - **War Domain & Tempest Domain Clerics** (Level 1)
  - **Monks** (Level 1+: core spiritual discipline and Ki flow)
  - **Paladins & Rangers** (Level 2+: when spellcasting unlocks; level 1 characters are mundane combatants)
  - **Bladesinger Wizards** (Level 2+: the epitome of martial blade-magic and Bladesong)
  - **Circle of Spores Druids** (Level 2+: frontline fungal melee brawlers / *Symbiotic Entity*)
  - **College of Swords & Valour Bards** (Level 3+: blade flourishes and frontline battle skalds)
  - **Pact of the Blade Warlocks** (Level 3+: bound pact weapon specialists & Hexblades)
  - **Eldritch Knight Fighters & Arcane Trickster Rogues** (Level 3+: dedicated martial-arcane gishes)
  - *Mundane fighters (Champion/Battle Master), mundane rogues (Thief/Assassin), and Barbarians cannot attack without disrupting active Concentration.*
- **Advantage Balance:** Gish training allows weapon attacks while channeling, but **does not grant Advantage on concentration saving throws** (Advantage remains strictly reserved for the *War Caster* feat or advantage gear).
- **War Caster Synergy:** Grants Advantage to Channeling saves. Because Focus already rolls with Advantage during Overclock, **War Caster ensures BOTH independent saves have Advantage!** Furthermore, casting *Shocking Grasp* as an Opportunity Attack reaction via War Caster is fully permitted.
- **Whitelisted Tactical Actions & Recasts:** 
  - Non-magical maneuvers (*Dash*, *Disengage*, *Shove*, *Throw*, *Dip*, *Dodge*, *Hide*) never disrupt active conduits.
  - Re-activating ongoing concentration conduits (*Call Lightning*, *Moonbeam*, *Sunbeam*, *Witch Bolt*, *Eyebite*, *Telekinesis* recast/move) is fully whitelisted.
  - Re-targeting marks (*Reapply Hunter's Mark*, *Reapply Hex*) is free and preserves active conduits.
- **Loss of Control (5e Compliant):** Hard incapacitation (*Stunned*, *Paralyzed*, *Petrified*, *Sleep*, *Unconscious*, *Downed*, *Dead*) shatters Focus and all linked party buffs.

---

## Requirements
- **Baldur's Gate 3:** Patch 7 or Patch 8+
- **Script Extender:** [Baldur's Gate 3 Script Extender (BG3SE)](https://github.com/Norbyte/bg3se/releases) (v32 or newer recommended)

---

## Support the Project
If Concentration Redux made your spellcasters fun and tactically rewarding to play, consider buying me a coffee! Any support is deeply appreciated and helps fuel future updates:

☕ **[Support on Ko-fi (ko-fi.com/nihilxd)](https://ko-fi.com/nihilxd)**
