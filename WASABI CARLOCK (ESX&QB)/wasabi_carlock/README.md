#wasabi_carlock

This resource was created as a interactive car lock key system for ESX Servers.

<b>Features:</b>
- Skill bar based success for lockpicking / hotwiring
- Automatically have keys to all cars you own(You can relog and still have keys to cars you own)
- Interactive sounds (Must download script/add sound files; directions below)
- Ability to rob peds at gunpoint for their keys
- `/givekey` command to give key to nearby players(Configurable command)
- Hotwiring / lockpicking vehicles
- Easy to integrate with other scripts (i.e.Dealerships, jobs, etc)


## Installation

- Download this

- Put script in your `resources` directory(Must be named `wasabi_carlock`! or will not work!)

- *Optional but recommended!* Download `mythic_progbar` and ensure if you don't already have: https://github.com/WasabiRobby/mythic_progbar

- Check if `lockpick` is in your items table and if not add it in


- Add `ensure wasabi_carlock` in your `server.cfg`
  ^^ Note: Make sure script is named `wasabi_carlock` or you may run in to issues.

### Interactive Sounds Installation
Sounds are included in the `CarLockSounds` directory. To use them follow these steps:
1. Download this: https://github.com/plunkettscott/interact-sound
2. Place in `resources` directory
3. Copy the files from inside the `InteractiveSounds` directory within `wasabi_carlock`
4. Paste them in the `interact-sound` resource file under `client/html/sounds/`
5. Add the following to the `interact-sound`'s files section of the  `fxmanifest.lua`:
 -   - ```lua
        'client/html/sounds/**.ogg',
      ```
    - Example:
  ```lua
    files {
    'client/html/index.html',
    -- Begin Sound Files Here...
    -- client/html/sounds/ ... .ogg
    'client/html/sounds/**.ogg',
    }
    ```
6. Add `ensure interact-sound` to your `server.cfg`
7. Set `Config.CustomSounds` to `true` in the `config.lua` of the wasabi_carlock resource. 

### 3rd Party Integration(i.e. Car dealers, and job scripts)
To add keys to dealerships, garages etc; you must trigger the add keys event. Here is an example below:
```lua
local plate = GetVehicleNumberPlateText(vehicle)
TriggerServerEvent('wasabi_carlock:addKey', plate)
```

## Preview
- Video Preview: https://streamable.com/oeecll

# Support
Join our discord <a href='https://discord.gg/XJFNyMy3Bv'>HERE</a> for additional scripts and support!
