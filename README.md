<h1>IamAdren's Toll Booth Script</h1>
<p>This script is a EZ-Pass type of system to your server.</p>

## Features
- EZ-Pass type of payment system.
- If a user passes through the toll with a "unregistered" or "stolen" vehicle it will alert law enforcement.
- Discord Bot with stats command.

## Dependencies
- ESX (Version 1.0)

## Screenshots / Preview

## How to install the Script
1. Import tollBooth.sql to your database
2. Add this in your server.cfg:
```
ensure tollBooth
```
3. Edit the config.lua file to your liking

## How to install the Discord Bot
1. Create a bot account at discord.com/developers and grab the token.
2. Add your token into config.js
3. Add you MySQL server connection details into config.js
4. CD into your directory
5. Type ``npm i``
6. Type ``node index.js``
