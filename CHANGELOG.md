# Concentration Redux - Changelog

## v1.1.1
- **Spell Weaving (Cantrips, Bonus Actions & Quickened Metamagic)**:
  - **All Cantrips (Level 0)**: Pure casters now have an active combat loop every turn! All cantrips (*Fire Bolt*, *Ray of Frost*, *Eldritch Blast*, *Sacred Flame*, *Acid Splash*, *Shocking Grasp*, etc.) are recognized as reflexive magic and can be cast freely without breaking an active Channel stance.
  - **Native Bonus Action Spells**: Spells requiring only a Bonus Action (*Misty Step*, *Healing Word*, *Mass Healing Word*, *Spiritual Weapon*, *Sanctuary*) can now be cast without breaking Channel, enabling fluid tactical repositioning and emergency triage.
  - **Sorcerer Quickened Spell Metamagic**: Quickening a standard-action leveled spell converts it to a bonus action weave, allowing Sorcerers to spend Sorcery Points to cast leveled spells without dropping their active Channel stance.
  - **Standard Action Leveled Spells**: Casting standard-action leveled spells (Level 1+) or offensive reactions (*Counterspell*, *Hellish Rebuke*) continues to demand total mental concentration and breaks active Channel stances.
- **In-Game Tooltip Trailers**:
  - Updated all 326+ in-game combat Channel spell cards with explicit spell-weaving guidance: *"Casting Cantrips, Bonus Action spells, or Quickened spells does not break Channel."*
- **Counterspell & Interrupted Cast Icon Cleanup**:
  - Fixed an issue where casting a Focus spell that was Counterspelled or interrupted left an orphaned Focus concentration icon on the caster's portrait. Spell focus application is now strictly deferred until spell resolution, and `CastSpellFailed` events immediately clean up any pending casts and synchronization trackers.

---

## v1.1.0 (DnD 5.5e Beyond Compatibility & Comprehensive Tooltips)
- **Terminology Standardization (Focus & Channel)**:
  - Streamlined and standardized all terminology across the entire mod, Lua engine, and documentation to strictly use **Focus** (buff layer) and **Channel** (combat layer). Removed legacy and ambiguous references to "conduit".
- **100% Comprehensive Tooltip Coverage Across All Concentration Spells**:
  - Over 480+ in-game spell cards, upcasts (levels 2–6), scrolls, racial abilities (e.g. Drow *Faerie Fire*), and applied status tooltips now feature dedicated **Focus** and **Channel** mechanic descriptions.
  - Bumped internal localization version hierarchy to `version="10"`, guaranteeing mod descriptions always override base game strings regardless of load order.
- **DnD 5.5e All-In-One BEYOND Compatibility**:
  - **New Classes Supported**:
    - **Illrigger**: Full Combat Channeling for all subclasses (*Sanguine Knight*, *Hellspeaker*, *Painkiller*, *Shadowmaster*, *Architect of Ruin*). Whitelisted all Seals, Interdicts, Hell abilities, and Blood Price.
    - **Monster Hunter**: Full Combat Channeling for *Carver Guild*, *Devourer Guild*, and *Occultist Guild*. Whitelisted all Mutations and Hunting Tactics.
    - **Artificer**: Combat Channeling for martial gish subclasses (*Battle Smith*, *Armorer*). Whitelisted Experimental Elixirs, Armor Models, and Defensive Field.
    - **Gunslinger**: Combat Channeling for the *Spellslinger* gun gish subclass.
  - **New Subclasses Across Existing Classes**:
    - *Fighter*: Rune Knight, Psi Warrior, Arcane Archer, Cavalier, Banneret, Viking.
    - *Rogue*: Soulknife, Blade of Radiance, Arachnoid Stalker.
    - *Bard*: College of Dance, College of Choreography.
    - *Cleric*: Forge Domain, Twilight Domain, Dragon Domain.
    - *Wizard & Warlock*: Bladesinger (Bladesinging School) and Hexblade.
    - *Monk, Paladin, Ranger*: All 2024 subclasses (*Mercy*, *Kensei*, *Sun Soul*, *Mystic Arts*, *Glory*, *Noble Genie*, *Conquest*, *Watchers*, *Fey Wanderer*, *Winter Walker*, *Hollow Warden*) fully integrated.
  - **38 Custom/Revised Concentration Spells**:
    - Audited, categorized, and annotated all 2024 concentration spells (*Holy Weapon*, *Spellfire Storm*, *Dragon's Breath*, *Summon Celestial*, *Summon Dragon*, *Void Strike*, *Murmurs of Doom*, etc.).
- **Engine & Packaging Stability (Patch 7 / Patch 8+)**:
  - Fixed a launch crash (`0xC0000005` in `bg3_dx11.exe`) caused by raw XML linebreaks creating text DOM nodes without attributes in Larian's localization parser.
  - Re-architected localization pipeline into clean single-line entries with `&#10;` line breaks and compiled binary `.loca`.
  - Removed duplicate package namespace directories and automated loose file cleanup on deployment.

---

## v1.0.5
- **Haste Dual Duration & Intelligent Lethargy System**:
  - **Self-Cast (Indefinite)**: Operates as an indefinite Channel spell with unlimited duration.
  - **Ally-Cast (10 Rounds)**: Standard tactical duration of 10 rounds (60 seconds) when cast on party members, companions, or summons.
  - **Safe Release (No Lethargy)**: Voluntarily ending *Haste*—by clicking portrait "X", casting non-whitelisted spells or offensive reactions, swapping Channel spells, or letting the 10 rounds expire naturally on an ally—safely releases the recipient with zero Lethargy (*"Haste Ended (Safe Release)"*).
  - **Involuntary Disruption (Inflicts Lethargy)**: Breaking your Channel involuntarily via damage, environmental surfaces, or hard crowd control (*Hold Person*, *Sleep*, *Hypnotic Pattern*, *Banishment*, *Stun*, *Paralyze*) inflicts 1 turn of Lethargy (*"Lethargic! (Damage/Incapacitated Disruption)"*).
  - **Sorcerer Twinned Haste Support**: Twinned Haste grants the caster an indefinite buff while the ally receives the 10-round buff. When the ally's duration expires, the ally releases safely without Lethargy, leaving the caster's Haste intact.
  - **In-Game Tooltips**: Fully updated spell card and status tooltips reflecting dual-duration and intelligent lethargy rules.
- **Gish Reaction Defensives & Melee Cantrips**:
  - Combat Channelers and characters with *War Caster* (enabling build-your-own gish setups on pure Sorcerers or Wizards) can cast personal reaction defensives (*Shield*, *Absorb Elements*) and melee spell cantrips (*Green-Flame Blade*, *Booming Blade*, *Vengeful Blade*) without breaking active Channel spells.
  - Offensive counter-magic (*Counterspell*) and retaliatory damage reactions (*Hellish Rebuke*) demand full casting focus and continue to break active Channel spells for all casters.
- **Gish Combat Stances & Class Forms**:
  - Activating martial class stances and disciplines (*Bladesong*, *Symbiotic Entity*, *Bind Pact Weapon*, *Hexblade's Curse*, *Weapon Bond*, Monk Ki maneuvers/stances, Bardic *Blade Flourishes*, and martial *Channel Divinities*) never breaks an active Channel spell.
- **Loss of Control & Hard CC**:
  - Hard incapacitation conditions (*Stunned*, *Paralyzed*, *Sleeping*, *Incapacitated*, *Banished*) reliably sever both Focus and Channel and trigger full disruption penalties.

---

## v1.0.4
- **Blade Ward Focus Conversion**: Converted to indefinite Focus buff (`INNATE_BUFF_BLADE_WARD`), granting continuous physical weapon resistance.
- **Tactical Movement & Action Whitelist**: Added comprehensive whitelist for Jump, Crouch/Stealth, Dash, Disengage, Shove, Dip, Throw, and Help.
