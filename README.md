# Simple Roleplay Actions
A lightweight FiveM roleplay actions resource providing 3D overhead /me and /do text with optional chat integration, proximity rendering, and built-in spam protection.

## Features
- **3D Roleplay Actions:** `/me` and `/do` displayed above players.
- **Configurable Rendering:** Adjustable scale, color, outline, and shadow.
- **Proximity-Based Visibility:** Range-limited rendering with height offset.
- **Optional Chat Integration:** Formatted chat output with prefixes and suggestions.
- **Spam Protection:** Cooldowns and burst limits with optional admin bypass.
- **Server Logging:** Optional server-side console logging.

## /me Command
Performs a character action.

**Usage:** `/me [message]`

<img width="747" height="638" alt="image" src="https://github.com/user-attachments/assets/626daa6e-c2c0-4f82-8a90-f285dd103cda" />

## /do Command
Describes the environment or a state.

**Usage:** `/do [message]`

<img width="747" height="638" alt="image" src="https://github.com/user-attachments/assets/be6d09f6-05aa-4c77-9c60-2fc163298121" />

## Config
Core configuration options defined in `config.lua`:

### Global Options
| Option | Type | Default | Description |
|---|---:|---|---|
| `locale` | string | `'en'` | Language key. |
| `displayTime` | number | `6` | Time (in seconds) that overhead text remains visible. |
| `textScale` | number | `0.5` | Scale of the 3D overhead text. |
| `textColor` | table `{r,g,b}` | `{255,230,100}` | Default RGB color used for overhead text. |
| `radius` | number | `20.0` | Maximum draw distance in meters. |
| `baseHeight` | number | `1.2` | Vertical offset above the player entity. |
| `serverLogging` | bool | `true` | Log actions to the server console. |

### Spam Protection Options
| Option | Type | Default | Description |
|---|---:|---|---|
| `cooldownMs` | number | `1000` | Minimum delay between messages per player. |
| `burstLimit` | number | `3` | Max actions allowed per burst window. |
| `burstWindowMs` | number | `10000` | Duration of burst window (ms). |
| `allowAdminBypass` | bool | `true` | Allow ACE permissions to bypass limits. |
| `notify` | bool | `false` | Notify user when an action is blocked. |

### Action-Specific Options (`/me` and `/do`)
| Option | Type | Default | Description |
|---|---:|---|---|
| `color` | table `{r,g,b}` | `{100,230,255}` | Overhead text color. |
| `chat` | bool | `false` | Send action to chat. |
| `overheadFormat` | string | `'* %s *'` | Format for overhead text. |

## Installation
1. Place the resource folder into your `resources` directory.
2. Add `ensure simple-rp-actions` to your `server.cfg`.
3. Configure options in `config.lua` as needed.
> Note: A more advanced variant with additional features (NUI, Discord profile support, and extended customization) is coming very soon.
> See: https://github.com/chillnook/AdvancedRoleplayActions

## Permissions
Admins may bypass spam limits using the following ACE permission:

`actiontext.bypass`

## License
**Personal and non-commercial use only.**

You may:
- Use and modify this script for free.

You may not:
- Sell, resell, monetize, sublicense, or redistribute this script or derivative works.

This software is provided “as is”, without warranty of any kind.
