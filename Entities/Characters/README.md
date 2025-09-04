# BaseCharacter Class Documentation

## Overview

The `BaseCharacter` class defines the foundational behavior and attributes for all character entities in the game. A **Character** is any entity that possesses a health value and interacts with the game world through movement, combat, or strategic roles.

---

## Core Attributes

### 🩸 Health
- All characters have a `health` value.
- Health determines survivability and is used to trigger death or destruction events.

### 🧭 Movement Type
Characters can have one of the following movement types:

| Type     | Description                                                                 |
|----------|-----------------------------------------------------------------------------|
| `static` | No movement. Typically used for stationary objects like towers or the core. |
| `grounded` | Movement is enabled and gravity is applied. Used for walking characters.   |
| `flying` | Movement is enabled but gravity is **not** applied. Used for airborne units. |

---

## Character Types

### 👤 Player
- Controlled by human input.
- Defends the core and towers against enemies.
- Uses weapons, tools, and upgrades to enhance defenses.

### 👾 Enemy
- AI-controlled.
- Can attack players, towers, and the core.
- **Primary objective**: destroy the core.

### 🗼 Tower
- Stationary defense unit.
- Automatically attacks enemies.
- Protects the core from incoming threats.

### 💠 Core
- Central base that must be defended.
- If destroyed, the player **loses the game**.
- Passive entity, typically static.

---

## Gameplay Logic Summary

- Enemies spawn and attempt to reach and destroy the core.
- Players must strategically defend using towers and direct combat.
- Towers provide automated defense but can be upgraded by players.
- Movement type affects how each character navigates the environment.
- Health values are used to determine damage, death, and destruction.
