# Concentration Redux
*Dual-Stance Spellcasting Architecture for Baldur's Gate 3 (Patch 7 & Patch 8)*

---

### ✦ The Problem in Vanilla 5e
In D&D 5e and vanilla Baldur's Gate 3, nearly every worthwhile spell competes for a single, restrictive concentration slot:
- Casting an iconic staple like *Bless* or *Shield of Faith* completely locks your caster out of using *Spirit Guardians*, *Wall of Fire*, *Call Lightning*, or *Hold Person*.
- Buffs vanish from a single stray 1-damage surface tick or an off-screen archer.
- Outside turn-based combat, 10-turn (60-second) timers expire while looting chests or reading dialogue.

---

### ✦ The Redesign: Three Tactical Stances
Concentration Redux splits spellcasting focus into two distinct, congruent cognitive layers:

#### 1. Pure Support (Solo Focus)
- **Condition:** Only maintaining a Focus buff (*Bless*, *Shield of Faith*, *Heroism*, *Haste*, etc.).
- **Defensive Resilience:** **100% Unbreakable by Damage.** No Constitution saving throws required against damage ticks, DoTs, or environmental surfaces.
- **Duration:** Indefinite until Long Rest or manual dismissal.
- **Allowed Actions:** All weapon attacks, spells, and abilities permitted.

#### 2. Dedicated Juggernaut (Solo Concentration)
- **Condition:** Only maintaining an active combat conduit (*Spirit Guardians*, *Wall of Fire*, *Fog Cloud*, *Moonbeam*, *Hold Person*, etc.).
- **Defensive Resilience:** Runs in the native engine slot with standard Constitution saving throws. Benefits from **War Caster** Advantage.
- **Allowed Actions:** Whitelisted tactical actions (*Dash*, *Disengage*, *Shove*, *Throw*, *Jump*, etc.). Weapon attacks are permitted for martial domains (*War* & *Tempest*). Casting unauthorized spells breaks the conduit.

#### 3. The Overclock (Both Active Simultaneously)
- **Condition:** Caster is actively maintaining both Focus AND Concentration at the same time.
- **Defensive Resilience:** Pushes your caster's mental bandwidth to the absolute limit. When taking damage:
  - The native Concentration conduit rolls standard saves (with War Caster if proficient).
  - Focus independently rolls a Constitution saving throw **with Advantage** (2d20, pick highest)!
- **Graceful Fallback:** If your combat conduit drops or is dismissed, Focus seamlessly drops back into unbreakable solo mode!

---

### ✦ Spell Classifications

#### 1. Focus (Indefinite Duration Buffs)
- **Combat & Defensive Wards:** *Bless*, *Shield of Faith*, *Heroism*, *Protection from Evil and Good*, *Barkskin*, *Stoneskin*, *Shield of Thralls*
- **Single-Target Marks:** *Hunter's Mark*, *Hex*, *Bane*, *Bestow Curse*
- **Physical Augmentations:** *Haste*, *Enlarge/Reduce*, *Fly*, *Expeditious Retreat*, *Blur*, *Magic Weapon*, *Elemental Weapon*
- **Stealth & Senses:** *Invisibility*, *Greater Invisibility*, *Pass Without Trace*, *Detect Thoughts*

*Note: Focus buffs are mutually exclusive per caster. Casting a new Focus spell naturally replaces your current one.*

> **Class Spells vs. Equipment & Scrolls:**  
> Class investments (spellbook spells, Bard Magical Secrets, multiclassing, Magic Initiate feats) utilize the full Focus system.  
> Spells granted by bound equipment (e.g. Whispering Promise, Darkfire Shortbow) and consumable scrolls intentionally follow vanilla rules (10-turn limit, standard damage saves) to prevent item abuse.

#### 2. Concentration (Combat Stances & Conduits)
- **Emanations & Auras:** *Spirit Guardians* (Radiant / Necrotic), *Aura of Vitality*, *Crusader's Mantle*, *Holy Aura*
- **Sustained Beams & Activations:** *Call Lightning*, *Moonbeam*, *Witch Bolt*, *Heat Metal*, *Sunbeam*, *Eyebite*, *Telekinesis*
- **Hazard Anchors:** *Wall of Fire*, *Darkness*, *Cloud of Daggers*, *Fog Cloud*, *Silence*, *Spike Growth*, *Sleet Storm*, *Hunger of Hadar*, *Cloudkill*, *Evard's Black Tentacles*, *Insect Plague*
- **Hard Crowd Control:** *Hold Person*, *Hold Monster*, *Hypnotic Pattern*, *Banishment*, *Tasha's Hideous Laughter*, *Slow*, *Confusion*, *Otiluke's Resilient Sphere*

#### 3. Reapplication Spells (*Hex* & *Hunter's Mark*)
- When your marked target dies, the corpse target is cleanly detached from tracking while preserving Focus on the caster.
- The free *Reapply* abilities remain on your hotbar and are fully whitelisted—re-marking a new foe will never break active Concentration.

---

### ✦ UI, Dismissal & Visual Clarity
- **Side-by-Side Portrait Badges:** Both conditions display clearly in the character's portrait buff tray:
  - Radiant Sun icon for **Focus**
  - Purple Mind Conduit icon for **Concentration**
- **Dismissing Focus:** While maintaining Focus, the caster gains a free, 0-action **Dismiss Focus** ability on their hotbar to cancel it on demand.
- **Dismissing Concentration:** Uses Baldur's Gate 3's **native 'X' button** directly beneath the portrait HUD (or by casting another conduit).

---

### ✦ Tactical Synergies & Balance Rules

#### Combat Channeling Perk
War Domain and Tempest Domain Clerics receive the **Combat Channeling** perk at Level 1:
- Execute melee and ranged weapon attacks, leverage Extra Attack, and trigger special weapon actions (*Lacerate*, *Topple*, *Flourish*, *Cleave*, *Pommel Strike*, etc.) without breaking active Concentration.
- Script Extender dynamically inspects weapon action properties to support modded martial actions and weapon masteries.
- Non-combat domains attempting unauthorized physical attacks will shatter their active channel.

#### War Caster Feat Integration
- **Without War Caster:** Focus rolls with Advantage during Overclock; Channeling rolls a standard 1d20 save.
- **With War Caster:** Grants Advantage to Channeling saves. Because Focus already rolls with Advantage, **War Caster ensures BOTH saves have Advantage during Overclock!**
- **Reactive Spellcasting:** Casting *Shocking Grasp* as an Opportunity Attack reaction via War Caster is fully permitted and will not break your active channel.

#### Strict Reaction Spells
- Casting emergency spell reactions (*Shield*, *Counterspell*, *Hellish Rebuke*) immediately shatters active combat conduits.
- Tooltips and reaction cards feature clear **Concentration Disruption** warnings.
- Keep "Ask" enabled in your Reactions tab (*K*) so you can deliberately choose when to trade your channel in life-or-death situations.

#### Loss of Control (5e Compliance)
If a caster is afflicted with hard incapacitation (*Stunned*, *Paralyzed*, *Petrified*, *Sleep*, *Unconscious*, *Downed*, *Dead*), Focus and all linked buffs immediately drop.

---

### ✦ Requirements & Installation
- **Game Version:** Baldur's Gate 3 (**Patch 7 / Patch 8+**)
- **Required Mod:** [Baldur's Gate 3 Script Extender (BG3SE)](https://github.com/Norbyte/bg3se/releases) (v32 or newer recommended)

#### Installation via Vortex or BG3 Mod Manager:
1. Download the `.zip` archive from the Files tab.
2. Import and install via **Vortex** or **BG3 Mod Manager**.
3. Enable **Concentration Redux** in your active load order and export.
4. Safe to install on existing playthroughs!
