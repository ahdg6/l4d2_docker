/*
*	Flare Gun
*	Copyright (C) 2023 Silvers
*
*	This program is free software: you can redistribute it and/or modify
*	it under the terms of the GNU General Public License as published by
*	the Free Software Foundation, either version 3 of the License, or
*	(at your option) any later version.
*
*	This program is distributed in the hope that it will be useful,
*	but WITHOUT ANY WARRANTY; without even the implied warranty of
*	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*	GNU General Public License for more details.
*
*	You should have received a copy of the GNU General Public License
*	along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/



#define PLUGIN_VERSION 		"2.16"

/*======================================================================================
	Plugin Info:

*	Name	:	[L4D2] Flare Gun
*	Author	:	SilverShot
*	Descrp	:	Converts the grenade launcher into a flare gun amongst other types.
*	Link	:	https://forums.alliedmods.net/showthread.php?t=175241
*	Plugins	:	https://sourcemod.net/plugins.php?exact=exact&sortby=title&search=1&author=Silvers

========================================================================================
	Change Log:

2.16 (05-Sep-2023)
	- Fixed the plugin stumbling players when the stumble option is turned off. Thanks to "Proaxel" for reporting.

2.15 (25-May-2023)
	- Fixed cvars "l4d2_flare_gun_prefs" and "l4d2_flare_gun_type_default" not being followed. Thanks to "Voevoda" for reporting.
	- Fixed rare invalid entity error. Thanks to "Voevoda" for reporting.

2.14 (11-Dec-2022)
	- Changes to fix compile warnings on SourceMod 1.11.

2.13a (24-Feb-2021)
	- Added Simplified Chinese and Traditional Chinese translations. Thanks to "HarryPotter" for providing. 

2.13 (01-Oct-2020)
	- Added forward "OnFlareGunProjectile" to notify plugins when a modified Grenade Launcher projectile was created.
	- Fixed compile errors on SM 1.11.

2.12 (05-Sep-2020)
	- Fixed cvar "l4d2_flare_gun_menu" not restricting menu access.
	- Defaults to checking "sm_flaregun" SM command override if no cvar value is set.
	- The cvar "l4d2_flare_gun_menu_admin" now checks SM command override if no cvar value is set.
	- Thanks to "maclarens" for reporting.

2.11 (15-May-2020)
	- Better cookies and admin checks.
	- Replaced "point_hurt" entity with "SDKHooks_TakeDamage" function.

2.10 (10-May-2020)
	- Extra checks to prevent "IsAllowedGameMode" throwing errors.
	- Various changes to tidy up code.
	- Various minor optimizations.

2.9 (09-Apr-2020)
	- Added cvar "l4d2_flare_gun_prefs" to set client preferences on or off. Thanks to "Voevoda" for requesting.

2.8 (01-Apr-2020)
	- Fixed "IsAllowedGameMode" from throwing errors when the "_tog" cvar was changed before MapStart.
	- Fixed not precaching "env_shake" which caused stutter on first explosion.
	- Removed "colors.inc" dependency.
	- Updated these translation file encodings to UTF-8 (to display all characters correctly): German (de).

2.7.5 (30-Oct-2019)
	- Fixed the grenade launcher exploding next to players after a map transition.
	- Some optimizations and fixes.

2.7.4 (03-Jul-2019)
	- Fixed minor memory leak when using the Homing Type.

2.7.3 (28-Jun-2019)
	- Changed PrecacheParticle method.

2.7.2 (01-Jun-2019)
	- Changed from RequestFrame to SpawnPost, for better response when projectiles are created.
	- Removed gamedata signature/SDKCall dependency for stagger. Thanks to Lux editing Airstrike plugin.
	- Now uses native VScript API for stagger function thanks to "Timocop"'s function and "Lux" reporting.

2.7.1b (18-Feb-2019)
    - Changed the gamedata to be compatible with plugins that detour the OnStaggered function.

2.7.1 (21-Jul-2018)
	- Changed from CreateTimer to RequestFrame, for faster response when projectiles are created.
	- Added compatibility for my modified version of the "Helicopter Gunship" plugin.

2.7 (05-May-2018)
	- Converted plugin source to the latest syntax utilizing methodmaps. Requires SourceMod 1.8 or newer.

2.6 (01-Apr-2018)
	- Added cvar "l4d2_flare_gun_menu_button" to enable opening the menu instead of using the console command.
	- Attempt to fix godmode bug.

2.5 (27-May-2012)
	- Fixed the damage cvars not applying full damage to special infected - Thanks to "disawar1" for bug report.

2.4 (25-May-2012)
	- Fixed the Timed Bomb type not following the damage cvar settings.
	- Fixed the Homing Type breaking the total number of projectiles.

2.3 (20-May-2012)
	- Added German translations - Thanks to "Dont Fear The Reaper".
	- Fixed errors reported by "Dont Fear The Reaper".
	- New gamedata "l4d2_flare_gun.txt" file required.
	- The cvar "l4d2_flare_gun_hurt_stumble" now stumbles survivors and infected away from the explosion origin.

2.2 (10-May-2012)
	- Added "Homing" type to direct the projectile movement.
	- Added cvar "l4d2_flare_gun_modes_off" to control which game modes the plugin works in.
	- Added cvar "l4d2_flare_gun_modes_tog" same as above.
	- Added cvar "l4d2_flare_gun_god" to prevent ledge grab and fall damage when using the Jump type.
	- Added cvar "l4d2_flare_gun_damage_homing" to control the Homing Rocket explosion damage.
	- Added cvar "l4d2_flare_gun_time_homing" to control how long the Homing Rocket lasts.
	- Added cvar "l4d2_flare_gun_speed_homing" to control how fast Homing Rockets travel.
	- Prevents shooting the Grenade Launcher when limiting the number of projectiles.
	- Should no longer explode when using a sticky type too close to a wall.
	- Small changes and fixes.

2.1 (11-Jan-2012)
	- Fixed a bug in the menu which gave the wrong Flare Gun type to non-admins.
	- Increased a string size to better support translations.

2.0 (01-Jan-2012)
	- Plugin separated and taken from the "Flare and Light Package" plugin.
	- Added Jump type which launches players into the air.
	- Added Remote type which sticks and detonates when players right click (shove).
	- Added Sensor Bomb type which detonates when infected or special infected go near.
	- Added Sticky type which sticks and has no explosion.
	- Added Timed bombs which detonate after l4d2_flare_gun_time_timed.
	- Added and changed many cvars.
	- Changed the command "sm_flaregun" to show players a menu of Grenade Launcher types.
	- Changed the cvar "l4d2_flare_gun_type", add the numbers together to choose allowed Grenade Launcher types for non-admins.
	- Changed cvar "l4d2_flare_gun_max" to limit how many simultaneous flares players are allowed. (Admins limited by cvar below).
	- Added cvar "l4d2_flare_gun_max_total" to limit the total amount of flares at one time.
	- Projectiles which have been shot after the max limits will be removed.
	- Removed cvar "l4d2_flare_gun_bounce".
	- Removed cvar "l4d2_flare_gun_time".

1.0.3 (10-Mar-2012)
	- Added "l4d2_flare_gun_bounce 3" to make grenade launcher projectiles stick to surfaces.
	- Added "l4d2_flare_gun_bounce 4" to do the same as above and explode after "l4d2_flare_gun_time".
	- Added a new cvar to change the grenade launcher projectile bounciness (l4d2_flare_gun_elasticity).

1.0.2 (30-Jan-2012)
	- Fixed the Flare Gun hint text displaying when the game mode is disallowed.

1.0.1 (29-Jan-2012)
	- Fixed Flare Gun hint text displaying when Flare Gun is off.
	- Change the default Flare Gun Speed (l4d2_flare_gun_speed) cvar from 600 to 1000.

1.0 (29-Jan-2011)
	- Initial release.

========================================================================================

	This plugin was made using source code from the following plugins.
	If I have used your code and not credited you, please let me know.

*	Thanks to "pimpinjuice" for a "Proper way to deal damage without extensions" - Used by AtomicStryker below
	https://forums.alliedmods.net/showthread.php?t=111684

*	Thanks to "AtomicStryker" for "[L4D & L4D2] Boomer Splash Damage" - Where the damage code is from
	https://forums.alliedmods.net/showthread.php?t=98794

*	Thanks to "nakashimakun" for "[L4D & L4D2] Kill Counters." - Where the clientprefs code is from
	https://forums.alliedmods.net/showthread.php?t=140000

*	Thanks to "FoxMulder" for "[SNIPPET] Kill Entity in Seconds" - Used to delete flare models
	https://forums.alliedmods.net/showthread.php?t=129135

*	Thanks to "Downtown1", "ProdigySim" and "psychonic" for "[EXTENSION] Left 4 Downtown 2 L4D2 Only" - Used gamedata to stumble players.
	https://forums.alliedmods.net/showthread.php?t=134032

======================================================================================*/

#pragma semicolon 1

#pragma newdecls required
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <clientprefs>

#define CVAR_FLAGS			FCVAR_NOTIFY
// #define GAMEDATA			"l4d2_flare_gun"
#define CHAT_TAG			"\x04[Flare Gun] \x05"
#define	MAX_ENTITIES		7
#define	MAX_PROJECTILES		16
#define	MAX_STICKY_BOMBS	3

#define MODEL_BOUNDING		"models/props/cs_assault/box_stack2.mdl"
#define MODEL_SPRITE		"models/sprites/glow01.spr"

#define PARTICLE_BOMB		"weapon_pipebomb"
#define PARTICLE_FLARE		"flare_burning"
#define PARTICLE_SMOKE		"RPG_Parent"

#define PARTICLE_SPARKS		"fireworks_sparkshower_01e"
#define SOUND_EXPLODE3		"weapons/hegrenade/explode3.wav"
#define SOUND_EXPLODE4		"weapons/hegrenade/explode4.wav"
#define SOUND_EXPLODE5		"weapons/hegrenade/explode5.wav"
#define SOUND_FIRE			"ambient/fire/interior_fire02_stereo.wav"


// Cvar Handles
ConVar g_hCvarAllow, g_hCvarAmmo, g_hCvarAutoMenu, g_hCvarDamageFFScale, g_hCvarDamageFFSelf, g_hCvarDamageHoming, g_hCvarDamageJump, g_hCvarDamageRemote, g_hCvarDamageSensor, g_hCvarDamageTimed, g_hCvarDefault, g_hCvarDistance, g_hCvarElasticity, g_hCvarForce, g_hCvarGod, g_hCvarGravity, g_hCvarHurt, g_hCvarHurtSI, g_hCvarHurtStumble, g_hCvarLight, g_hCvarLightCols, g_hCvarMPGameMode, g_hCvarMax, g_hCvarMaxTotal, g_hCvarMenu, g_hCvarMenuAdmin, g_hCvarMenuButton, g_hCvarModes, g_hCvarModesOff, g_hCvarModesTog, g_hCvarPrefs, g_hCvarReload, g_hCvarSmoke, g_hCvarSparks, g_hCvarSpeed, g_hCvarSpeedHoming, g_hCvarSprite, g_hCvarSpriteCols, g_hCvarTimeBounce, g_hCvarTimeHoming, g_hCvarTimeJump, g_hCvarTimeRemote, g_hCvarTimeSensor, g_hCvarTimeSticky, g_hCvarTimeTimed, g_hCvarType;

// Cvar Variables
int g_iCvarAmmo, g_iCvarAuto, g_iCvarDefault, g_iCvarGod, g_iCvarHurt, g_iCvarHurtSI, g_iCvarHurtStumble, g_iCvarMax, g_iCvarMaxTotal, g_iCvarSmoke, g_iCvarSpeed, g_iCvarType;
bool g_bCvarAllow, g_bMapStarted, g_bCvarLight, g_bCvarMenuButton, g_bCvarPrefs, g_bCvarReload, g_bCvarSparks, g_bCvarSprite;
char g_sCvarCols[12], g_sGunMenuAdmin[16], g_sGunMenu[16], g_sSpriteCols[12];
float g_fCvarDamageFFScale, g_fCvarDamageFFSelf, g_fCvarDamageHoming, g_fCvarDamageJump, g_fCvarDamageRemote, g_fCvarDamageSensor, g_fCvarDamageTimed, g_fCvarDistance, g_fCvarElasticity, g_fCvarForce, g_fCvarGravity, g_fCvarSpeedHoming, g_fCvarTimeBounce, g_fCvarTimeHoming, g_fCvarTimeJump, g_fCvarTimeRemote, g_fCvarTimeSensor, g_fCvarTimeSticky, g_fCvarTimeTimed;

// Plugin Variables
// Handle g_sdkStagger; // Stagger: SDKCall method
int g_iAmmoOffset, g_iGrenadeLimit;

// Grenade Launcher
ConVar g_hNadeAmmo, g_hNadeVariance, g_hNadeVelocity, g_hNadeVelocityUp;
int g_iCvarAmmoDefault, g_iNadeSpeedDefault, g_iNadeSpeedUp, g_iNadeVariance;
Handle g_hCookie, g_hForwardProjectile;
bool g_bBlockHook;

int g_iMenu[MAXPLAYERS+1];
int g_iType[MAXPLAYERS+1];
bool g_bChecked[MAXPLAYERS+1];
bool g_bEquipped[MAXPLAYERS+1];
float g_fLastHurt[MAXPLAYERS+1];
float g_fLastMenu[MAXPLAYERS+1];

int g_iHoming[MAXPLAYERS+1];
int g_iSticky[MAXPLAYERS+1][MAX_STICKY_BOMBS+1];
int g_iFlareEntities[MAX_PROJECTILES][MAX_ENTITIES]; // [0]=grenade_launcher_projectile; [1]=Flare particle; [2]=Sparks particle; [3]=Light_Dynamic; [4]=Env_Sprite; [5]=Type; [6]=Client.


enum
{
	INDEX_ENTITY,
	INDEX_FLARE,
	INDEX_SPARKS,
	INDEX_LIGHT,
	INDEX_SPRITE,
	INDEX_TYPE,
	INDEX_CLIENT
}

enum
{
	ENUM_DEFAULT	= (1 << 0),
	ENUM_FLARE		= (1 << 1),
	ENUM_BOUNCE		= (1 << 2),
	ENUM_STICKY		= (1 << 3),
	ENUM_JUMP		= (1 << 4),
	ENUM_REMOTE		= (1 << 5),
	ENUM_TIMED		= (1 << 6),
	ENUM_SENSOR		= (1 << 7),
	ENUM_HOMING		= (1 << 8)
}

enum
{
	TYPE_DEFAULT = 1,
	TYPE_FLARE,
	TYPE_BOUNCE,
	TYPE_STICKY,
	TYPE_JUMP,
	TYPE_REMOTE,
	TYPE_TIMED,
	TYPE_SENSOR,
	TYPE_HOMING
}



// ====================================================================================================
//					PLUGIN INFO / START / END
// ====================================================================================================
public Plugin myinfo =
{
	name = "[L4D2] Flare Gun",
	author = "SilverShot",
	description = "Converts the grenade launcher into a flare gun amongst other types.",
	version = PLUGIN_VERSION,
	url = "https://forums.alliedmods.net/showthread.php?t=175241"
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	EngineVersion test = GetEngineVersion();
	if( test != Engine_Left4Dead2 )
	{
		strcopy(error, err_max, "Plugin only supports Left 4 Dead 2.");
		return APLRes_SilentFailure;
	}

	g_hForwardProjectile = CreateGlobalForward("OnFlareGunProjectile", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
	return APLRes_Success;
}

public void OnPluginStart()
{
	/* Stagger: SDKCall method
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof(sPath), "gamedata/%s.txt", GAMEDATA);
	if( FileExists(sPath) == false ) SetFailState("\n==========\nMissing required file: \"%s\".\nRead installation instructions again.\n==========", sPath);

	Handle hGameData = LoadGameConfigFile(GAMEDATA);
	if( hGameData == null ) SetFailState("Failed to load \"%s.txt\" gamedata.", GAMEDATA);

	StartPrepSDKCall(SDKCall_Player);
	if( PrepSDKCall_SetFromConf(hGameData, SDKConf_Signature, "CTerrorPlayer::OnStaggered") == false )
		SetFailState("Could not load the 'CTerrorPlayer::OnStaggered' gamedata signature.");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
	g_sdkStagger = EndPrepSDKCall();
	if( g_sdkStagger == null )
		SetFailState("Could not prep the 'CTerrorPlayer::OnStaggered' function.");
	*/


	// Translations
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, PLATFORM_MAX_PATH, "translations/flaregun.phrases.txt");
	if( FileExists(sPath) )
		LoadTranslations("flaregun.phrases");
	else
		SetFailState("Missing required 'translations/flaregun.phrases.txt', please download and install.");

	LoadTranslations("core.phrases");


	// Cvars
	g_hCvarAllow =			CreateConVar(	"l4d2_flare_gun_allow",				"1",			"0=Plugin off, 1=Plugin on.", CVAR_FLAGS );
	g_hCvarAmmo =			CreateConVar(	"l4d2_flare_gun_ammo",				"1",			"0=Unlimited ammo, 1=Default ammo, else how many grenades are given in Grenade Launchers.", CVAR_FLAGS );
	g_hCvarAutoMenu =		CreateConVar(	"l4d2_flare_gun_auto_menu",			"1",			"0=Off, 1=Display the !flaregun menu when players first pickup Grenade Launchers.", CVAR_FLAGS );
	g_hCvarDamageFFScale =	CreateConVar(	"l4d2_flare_gun_damage_ff_scale",	"0.15",			"Scales friendly fire damage to other players.", CVAR_FLAGS );
	g_hCvarDamageFFSelf =	CreateConVar(	"l4d2_flare_gun_damage_ff_self",	"0.15",			"Scales friendly fire damage to yourself.", CVAR_FLAGS );
	g_hCvarDamageHoming =	CreateConVar(	"l4d2_flare_gun_damage_homing",		"75.0",			"Maximum damage the Homing rocket explosions can cause.", CVAR_FLAGS );
	g_hCvarDamageJump =		CreateConVar(	"l4d2_flare_gun_damage_jump",		"50.0",			"Maximum damage the Jump explosions can cause.", CVAR_FLAGS );
	g_hCvarDamageRemote =	CreateConVar(	"l4d2_flare_gun_damage_remote",		"75.0",			"Maximum damage the Remote Bomb explosions can cause.", CVAR_FLAGS );
	g_hCvarDamageSensor =	CreateConVar(	"l4d2_flare_gun_damage_sensor",		"75.0",			"Maximum damage the Sensor Bomb explosions can cause.", CVAR_FLAGS );
	g_hCvarDamageTimed =	CreateConVar(	"l4d2_flare_gun_damage_timed",		"75.0",			"Maximum damage the Timed explosions can cause.", CVAR_FLAGS );
	g_hCvarDistance =		CreateConVar(	"l4d2_flare_gun_distance",			"250.0",		"How far can the explosions cause damage.", CVAR_FLAGS );
	g_hCvarElasticity =		CreateConVar(	"l4d2_flare_gun_elasticity",		"1.0",			"Changes the projectile bounciness. Valve default: 1.0.", CVAR_FLAGS );
	g_hCvarForce =			CreateConVar(	"l4d2_flare_gun_force",				"600.0",		"How much force is applied to the Jump type.", CVAR_FLAGS );
	g_hCvarGod =			CreateConVar(	"l4d2_flare_gun_god",				"3",			"0=Off, When using the jump type: 1=Prevent Ledge Grab, 2=Prevent fall damage, 3=Both.", CVAR_FLAGS);
	g_hCvarGravity =		CreateConVar(	"l4d2_flare_gun_gravity",			"0.4",			"Changes the projectile gravity, negative numbers make it fly upward!", CVAR_FLAGS );
	g_hCvarHurt =			CreateConVar(	"l4d2_flare_gun_hurt",				"10",			"0=Off, Hurt survivors this much and ignite zombies/infected/explosives when bouncing. This enables l4d2_flare_gun_hurt_special.", CVAR_FLAGS, true, 0.0, true, 100.0 );
	g_hCvarHurtSI =			CreateConVar(	"l4d2_flare_gun_hurt_special",		"10",			"Hurt special infected this much when they touch the flare. Damage is limited to once per second, same as above.", CVAR_FLAGS, true, 0.0, true, 100.0 );
	g_hCvarHurtStumble =	CreateConVar(	"l4d2_flare_gun_hurt_stumble",		"1",			"Stumble survivors/special infected in explosions (does not affect stock types).", CVAR_FLAGS, true, 0.0, true, 1.0 );
	g_hCvarLight =			CreateConVar(	"l4d2_flare_gun_light",				"1",			"Turn on/off the attached light_dynamic glow.", CVAR_FLAGS );
	g_hCvarLightCols =		CreateConVar(	"l4d2_flare_gun_light_color",		"200 20 15",	"The light color. Three values between 0-255 separated by spaces. RGB Color255 - Red Green Blue.", CVAR_FLAGS );
	g_hCvarMax =			CreateConVar(	"l4d2_flare_gun_max",				"3",			"Max simultaneous flares a player can shoot.", CVAR_FLAGS, true, 1.0, true, float(MAX_PROJECTILES));
	g_hCvarMaxTotal =		CreateConVar(	"l4d2_flare_gun_max_total",			"16",			"Limit the total number of simultaneous grenade flares to this many.", CVAR_FLAGS, true, 1.0, true, float(MAX_PROJECTILES));
	g_hCvarMenu =			CreateConVar(	"l4d2_flare_gun_menu",				"",				"Players with these flags have access to flare gun type menu. (Empty = All).", CVAR_FLAGS );
	g_hCvarMenuAdmin =		CreateConVar(	"l4d2_flare_gun_menu_admin",		"z",			"Players with these flags have access to all the flare gun types in the menu.", CVAR_FLAGS );
	g_hCvarMenuButton =		CreateConVar(	"l4d2_flare_gun_menu_button",		"1",			"0=Off. 1=Use ZOOM (scope) key to open the menu. Only accessible to players with l4d2_flare_gun_menu flags.", CVAR_FLAGS );
	g_hCvarModes =			CreateConVar(	"l4d2_flare_gun_modes",				"",				"Turn on the plugin in these game modes, separate by commas (no spaces). (Empty = all).", CVAR_FLAGS );
	g_hCvarModesOff =		CreateConVar(	"l4d2_flare_gun_modes_off",			"",				"Turn off the plugin in these game modes, separate by commas (no spaces). (Empty = none).", CVAR_FLAGS );
	g_hCvarModesTog =		CreateConVar(	"l4d2_flare_gun_modes_tog",			"0",			"Turn on the plugin in these game modes. 0=All, 1=Coop, 2=Survival, 4=Versus, 8=Scavenge. Add numbers together.", CVAR_FLAGS );
	g_hCvarPrefs =			CreateConVar(	"l4d2_flare_gun_prefs",				"1",			"0=Default type on pickup (set to l4d2_flare_gun_type_default cvar). 1=Save previous selection to client preferences.", CVAR_FLAGS );
	g_hCvarReload =			CreateConVar(	"l4d2_flare_gun_reload",			"1",			"0=No reloading, quick shooting, 1=Default reloading after 1 shot.", CVAR_FLAGS );
	g_hCvarSparks =			CreateConVar(	"l4d2_flare_gun_sparks",			"1",			"0=Off, 1=Turn on the attached firework particle effect.", CVAR_FLAGS );
	g_hCvarSpeed =			CreateConVar(	"l4d2_flare_gun_speed",				"1000",			"The grenade launcher projectile speed.", CVAR_FLAGS );
	g_hCvarSpeedHoming =	CreateConVar(	"l4d2_flare_gun_speed_homing",		"400",			"The homing rocket projectile speed.", CVAR_FLAGS );
	g_hCvarSmoke =			CreateConVar(	"l4d2_flare_gun_smoke",				"1",			"0=Off, 1=The Sacrifice flare smoke, 2=Flare smoke but RPG smoke on Bounce type.", CVAR_FLAGS, true, 0.0, true, 2.0);
	g_hCvarSprite =			CreateConVar(	"l4d2_flare_gun_sprite",			"1",			"Turn on/off the attached glowing sprite.", CVAR_FLAGS );
	g_hCvarSpriteCols =		CreateConVar(	"l4d2_flare_gun_sprite_color",		"200 20 15",	"Set the glowing sprite color. Three values between 0-255 separated by spaces. RGB Color255 - Red Green Blue.", CVAR_FLAGS );
	g_hCvarTimeBounce =		CreateConVar(	"l4d2_flare_gun_time_bounce",		"10.0",			"How many seconds before removing Bounce projectiles.", CVAR_FLAGS );
	g_hCvarTimeHoming =		CreateConVar(	"l4d2_flare_gun_time_homing",		"10.0",			"How many seconds before removing Homing Rockets (explodes on time up).", CVAR_FLAGS );
	g_hCvarTimeJump =		CreateConVar(	"l4d2_flare_gun_time_jump",			"60.0",			"How many seconds before removing Jump projectiles.", CVAR_FLAGS );
	g_hCvarTimeRemote =		CreateConVar(	"l4d2_flare_gun_time_remote",		"60.0",			"How many seconds before removing Remote Bomb projectiles.", CVAR_FLAGS );
	g_hCvarTimeSensor =		CreateConVar(	"l4d2_flare_gun_time_sensor",		"30.0",			"How many seconds before removing Sensor projectiles.", CVAR_FLAGS );
	g_hCvarTimeSticky =		CreateConVar(	"l4d2_flare_gun_time_sticky",		"20.0",			"How many seconds before removing Sticky Flare projectiles.", CVAR_FLAGS );
	g_hCvarTimeTimed =		CreateConVar(	"l4d2_flare_gun_time_timed",		"5.0",			"How many seconds before removing Timed projectiles.", CVAR_FLAGS );
	g_hCvarType =			CreateConVar(	"l4d2_flare_gun_types",				"239",			"Which types can players use (admins can use all). 1=Stock, 2=Flare, 4=Bounce, 8=Sticky Flare, 16=Jump, 32=Remote Bomb, 64=Sticky Bomb Timed, 128=Sensor Bomb, 256=Homing Rocket, 511=All.", CVAR_FLAGS );
	g_hCvarDefault =		CreateConVar(	"l4d2_flare_gun_type_default",		"2",			"The default type of grenade launcher new players receive. Same as types but only use 1 value, do not add up.", CVAR_FLAGS );
	CreateConVar(							"l4d2_flare_gun_version",			PLUGIN_VERSION,	"Flare Gun plugin version.", FCVAR_NOTIFY|FCVAR_DONTRECORD);
	AutoExecConfig(true,					"l4d2_flare_gun");

	g_hCvarMPGameMode = FindConVar("mp_gamemode");
	g_hCvarMPGameMode.AddChangeHook(ConVarChanged_Allow);
	g_hCvarAllow.AddChangeHook(ConVarChanged_Allow);
	g_hCvarModes.AddChangeHook(ConVarChanged_Allow);
	g_hCvarModesOff.AddChangeHook(ConVarChanged_Allow);
	g_hCvarModesTog.AddChangeHook(ConVarChanged_Allow);
	g_hCvarAmmo.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarAutoMenu.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarDamageFFScale.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarDamageFFSelf.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarDamageJump.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarDamageRemote.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarDamageSensor.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarDamageTimed.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarDistance.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarElasticity.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarForce.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarGod.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarGravity.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarHurt.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarHurtSI.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarHurtStumble.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarLight.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarLightCols.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarMax.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarMaxTotal.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarMenu.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarMenuAdmin.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarMenuButton.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarPrefs.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarReload.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarSparks.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarSpeed.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarSpeedHoming.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarSmoke.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarSprite.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarSpriteCols.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarTimeRemote.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarTimeBounce.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarTimeHoming.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarTimeJump.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarTimeSensor.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarTimeSticky.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarTimeTimed.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarType.AddChangeHook(ConVarChanged_Cvars);
	g_hCvarDefault.AddChangeHook(ConVarChanged_Cvars);

	RegConsoleCmd("sm_flaregun",	CmdFlareGun,	"Opens the Flare Gun menu to select different types.");

	g_hNadeAmmo = FindConVar("ammo_grenadelauncher_max");
	g_hNadeVariance = FindConVar("grenadelauncher_vel_variance");
	g_hNadeVelocity = FindConVar("grenadelauncher_velocity");
	g_hNadeVelocityUp = FindConVar("grenadelauncher_vel_up");

	g_iCvarAmmoDefault = g_hNadeAmmo.IntValue;
	g_iNadeVariance = g_hNadeVariance.IntValue;
	g_iNadeSpeedDefault = g_hNadeVelocity.IntValue;
	g_iNadeSpeedUp = g_hNadeVelocityUp.IntValue;

	g_iAmmoOffset = FindSendPropInfo("CTerrorPlayer", "m_iAmmo");

	// Used to save client options if the grenade launcher flare gun bounces/explodes on impact
	g_hCookie = RegClientCookie("l4d2_flare_gun", "Flare Gun Type", CookieAccess_Protected);
	SetCookieMenuItem(Menu_Status, 0, "Flare Gun Type");
}

public void OnPluginEnd()
{
	ResetPlugin();
}

public void OnMapStart()
{
	g_bMapStarted = true;

	PrecacheModel(MODEL_BOUNDING, true);
	PrecacheModel(MODEL_SPRITE, true);

	PrecacheSound(SOUND_EXPLODE3, true);
	PrecacheSound(SOUND_EXPLODE4, true);
	PrecacheSound(SOUND_EXPLODE5, true);
	PrecacheSound(SOUND_FIRE, true);

	PrecacheParticle(PARTICLE_BOMB);
	PrecacheParticle(PARTICLE_FLARE);
	PrecacheParticle(PARTICLE_SMOKE);
	PrecacheParticle(PARTICLE_SPARKS);



	// Pre-cache env_shake -_- WTF
	int shake  = CreateEntityByName("env_shake");
	if( shake != -1 )
	{
		DispatchKeyValue(shake, "spawnflags", "8");
		DispatchKeyValue(shake, "amplitude", "16.0");
		DispatchKeyValue(shake, "frequency", "1.5");
		DispatchKeyValue(shake, "duration", "0.9");
		DispatchKeyValue(shake, "radius", "50");
		TeleportEntity(shake, view_as<float>({ 0.0, 0.0, -1000.0 }), NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(shake);
		ActivateEntity(shake);
		AcceptEntityInput(shake, "Enable");
		AcceptEntityInput(shake, "StartShake");
		RemoveEdict(shake);
	}
}

public void OnMapEnd()
{
	for( int i = 1; i <= MaxClients; i++ )
	{
		g_bEquipped[i] = false;
		g_fLastMenu[i] = 0.0;
	}

	g_bMapStarted = false;
	g_iGrenadeLimit = 0;
	DeleteAllFlares();
}



// ====================================================================================================
//					INTRO / COOKIES
// ====================================================================================================
public void OnClientDisconnect(int client)
{
	g_bChecked[client] = false;
}

public void OnClientPostAdminCheck(int client)
{
	g_iType[client] = 0;
	g_iMenu[client] = 0;
	g_fLastHurt[client] = 0.0;
	g_fLastMenu[client] = 0.0;

	if( !g_bCvarAllow || IsFakeClient(client) )
		return;

	if( g_bChecked[client] )
	{
		g_bChecked[client] = false;
		DefaultCheck(client);
	} else {
		g_bChecked[client] = true;
	}
}

public void OnClientCookiesCached(int client)
{
	if( !g_bCvarAllow || IsFakeClient(client) )
		return;

	if( g_bChecked[client] )
	{
		g_bChecked[client] = false;
		DefaultCheck(client);
	} else {
		g_bChecked[client] = true;
	}
}

void DefaultCheck(int client)
{
	// Verify they can use the !flaregun / !settings menus.
	int access;
	int flag = ReadFlagString(g_sGunMenuAdmin);
	if( CheckCommandAccess(client, "l4d2_flare_gun_menu_admin", flag, view_as<bool>(flag)) )
	{
		access = 2;
	}
	else
	{
		flag = ReadFlagString(g_sGunMenu);
		if( CheckCommandAccess(client, "sm_flaregun", flag, view_as<bool>(flag)) )
			access = 1;
	}

	g_iMenu[client] = access;


	// Get client cookies, set type if available or default.
	char sCookie[3];
	GetClientCookie(client, g_hCookie, sCookie, sizeof(sCookie));

	if( !g_bCvarPrefs || sCookie[0] == 0 )
	{
		IntToString(g_iCvarDefault, sCookie, sizeof(sCookie));
		SetClientCookie(client, g_hCookie, sCookie);
		g_iType[client] = g_iCvarDefault;
	}
	else if( g_bCvarPrefs )
	{
		int type = StringToInt(sCookie);

		if( access != 2 && g_bCvarPrefs )
		{
			if( (type == TYPE_DEFAULT	&& !(g_iCvarType & ENUM_DEFAULT)) ||
				(type == TYPE_FLARE		&& !(g_iCvarType & ENUM_FLARE)) ||
				(type == TYPE_BOUNCE	&& !(g_iCvarType & ENUM_BOUNCE)) ||
				(type == TYPE_STICKY	&& !(g_iCvarType & ENUM_STICKY)) ||
				(type == TYPE_JUMP		&& !(g_iCvarType & ENUM_JUMP)) ||
				(type == TYPE_REMOTE	&& !(g_iCvarType & ENUM_REMOTE)) ||
				(type == TYPE_TIMED		&& !(g_iCvarType & ENUM_TIMED)) ||
				(type == TYPE_SENSOR	&& !(g_iCvarType & ENUM_SENSOR)) ||
				(type == TYPE_HOMING	&& !(g_iCvarType & ENUM_HOMING))
			)
				type = g_iCvarDefault;
			else
				g_iType[client] = type;
		}
		else
		{
			g_iType[client] = type;
		}
	}

	if( access )
		SDKHook(client, SDKHook_WeaponEquip, OnWeaponEquip);
}



// ====================================================================================================
//					CVARS
// ====================================================================================================
public void OnConfigsExecuted()
{
	IsAllowed();

	if( g_bCvarAllow )
	{
		if( g_iCvarAmmo > 1 )
			g_hNadeAmmo.IntValue = g_iCvarAmmo;
		g_hNadeVariance.FloatValue = 0.1;
		g_hNadeVelocity.IntValue = 10;
		g_hNadeVelocityUp.IntValue = 1;
	}
}

void ConVarChanged_Allow(Handle convar, const char[] oldValue, const char[] newValue)
{
	IsAllowed();
}

void ConVarChanged_Cvars(Handle convar, const char[] oldValue, const char[] newValue)
{
	GetCvars();
}

void GetCvars()
{
	g_iCvarAmmo = g_hCvarAmmo.IntValue;
	if( g_iCvarAmmo > 1 )
		g_hNadeAmmo.IntValue = g_iCvarAmmo;

	g_iCvarAuto = g_hCvarAutoMenu.IntValue;
	g_fCvarDamageFFScale = g_hCvarDamageFFScale.FloatValue;
	g_fCvarDamageFFSelf = g_hCvarDamageFFSelf.FloatValue;
	g_fCvarDamageHoming = g_hCvarDamageHoming.FloatValue;
	g_fCvarDamageJump = g_hCvarDamageJump.FloatValue;
	g_fCvarDamageRemote = g_hCvarDamageRemote.FloatValue;
	g_fCvarDamageSensor = g_hCvarDamageSensor.FloatValue;
	g_fCvarDamageTimed = g_hCvarDamageTimed.FloatValue;
	g_fCvarDistance = g_hCvarDistance.FloatValue;
	g_fCvarElasticity = g_hCvarElasticity.FloatValue;
	g_fCvarForce = g_hCvarForce.FloatValue;
	g_iCvarGod = g_hCvarGod.IntValue;
	g_fCvarGravity = g_hCvarGravity.FloatValue;
	g_iCvarHurt = g_hCvarHurt.IntValue;
	g_iCvarHurtSI = g_hCvarHurtSI.IntValue;
	g_iCvarHurtStumble = g_hCvarHurtStumble.IntValue;
	g_bCvarLight = g_hCvarLight.BoolValue;
	g_hCvarLightCols.GetString(g_sCvarCols, sizeof(g_sCvarCols));
	g_iCvarMax = g_hCvarMax.IntValue;
	g_iCvarMaxTotal = g_hCvarMaxTotal.IntValue;
	g_hCvarMenu.GetString(g_sGunMenu, sizeof(g_sGunMenu));
	g_hCvarMenuAdmin.GetString(g_sGunMenuAdmin, sizeof(g_sGunMenuAdmin));
	g_bCvarMenuButton = g_hCvarMenuButton.BoolValue;
	g_bCvarPrefs = g_hCvarPrefs.BoolValue;
	g_bCvarReload = g_hCvarReload.BoolValue;
	g_bCvarSparks = g_hCvarSparks.BoolValue;
	g_iCvarSmoke = g_hCvarSmoke.IntValue;
	g_bCvarSprite = g_hCvarSprite.BoolValue;
	g_hCvarSpriteCols.GetString(g_sSpriteCols, sizeof(g_sSpriteCols));
	g_fCvarTimeBounce = g_hCvarTimeBounce.FloatValue;
	g_fCvarTimeHoming = g_hCvarTimeHoming.FloatValue;
	g_fCvarTimeJump = g_hCvarTimeJump.FloatValue;
	g_fCvarTimeRemote = g_hCvarTimeRemote.FloatValue;
	g_fCvarTimeSensor = g_hCvarTimeSensor.FloatValue;
	g_fCvarTimeSticky = g_hCvarTimeSticky.FloatValue;
	g_fCvarTimeTimed = g_hCvarTimeTimed.FloatValue;
	g_iCvarSpeed = g_hCvarSpeed.IntValue;
	g_fCvarSpeedHoming = g_hCvarSpeedHoming.FloatValue;
	g_iCvarType = g_hCvarType.IntValue;
	g_iCvarDefault = g_hCvarDefault.IntValue;
}

void IsAllowed()
{
	bool bCvarAllow = g_hCvarAllow.BoolValue;
	bool bAllowMode = IsAllowedGameMode();
	GetCvars();

	if( g_bCvarAllow == false && bCvarAllow == true && bAllowMode == true )
	{
		g_bCvarAllow = true;
		LateLoad();
		HookEvent("round_end", Event_RoundEnd, EventHookMode_PostNoCopy);
	}

	else if( g_bCvarAllow == true && (bCvarAllow == false || bAllowMode == false) )
	{
		g_bCvarAllow = false;
		ResetPlugin();
		UnhookEvent("round_end", Event_RoundEnd, EventHookMode_PostNoCopy);
	}
}

int g_iCurrentMode;
bool IsAllowedGameMode()
{
	if( g_hCvarMPGameMode == null )
		return false;

	int iCvarModesTog = g_hCvarModesTog.IntValue;
	if( iCvarModesTog != 0 )
	{
		if( g_bMapStarted == false )
			return false;

		g_iCurrentMode = 0;

		int entity = CreateEntityByName("info_gamemode");
		if( IsValidEntity(entity) )
		{
			DispatchSpawn(entity);
			HookSingleEntityOutput(entity, "OnCoop", OnGamemode, true);
			HookSingleEntityOutput(entity, "OnSurvival", OnGamemode, true);
			HookSingleEntityOutput(entity, "OnVersus", OnGamemode, true);
			HookSingleEntityOutput(entity, "OnScavenge", OnGamemode, true);
			ActivateEntity(entity);
			AcceptEntityInput(entity, "PostSpawnActivate");
			if( IsValidEntity(entity) ) // Because sometimes "PostSpawnActivate" seems to kill the ent.
				RemoveEdict(entity); // Because multiple plugins creating at once, avoid too many duplicate ents in the same frame
		}

		if( g_iCurrentMode == 0 )
			return false;

		if( !(iCvarModesTog & g_iCurrentMode) )
			return false;
	}

	char sGameModes[64], sGameMode[64];
	g_hCvarMPGameMode.GetString(sGameMode, sizeof(sGameMode));
	Format(sGameMode, sizeof(sGameMode), ",%s,", sGameMode);

	g_hCvarModes.GetString(sGameModes, sizeof(sGameModes));
	if( sGameModes[0] )
	{
		Format(sGameModes, sizeof(sGameModes), ",%s,", sGameModes);
		if( StrContains(sGameModes, sGameMode, false) == -1 )
			return false;
	}

	g_hCvarModesOff.GetString(sGameModes, sizeof(sGameModes));
	if( sGameModes[0] )
	{
		Format(sGameModes, sizeof(sGameModes), ",%s,", sGameModes);
		if( StrContains(sGameModes, sGameMode, false) != -1 )
			return false;
	}

	return true;
}

void OnGamemode(const char[] output, int caller, int activator, float delay)
{
	if( strcmp(output, "OnCoop") == 0 )
		g_iCurrentMode = 1;
	else if( strcmp(output, "OnSurvival") == 0 )
		g_iCurrentMode = 2;
	else if( strcmp(output, "OnVersus") == 0 )
		g_iCurrentMode = 4;
	else if( strcmp(output, "OnScavenge") == 0 )
		g_iCurrentMode = 8;
}

void LateLoad()
{
	// In-case the plugin is reloaded whilst clients are connected.
	for( int i = 1; i <= MaxClients; i++ )
	{
		if( IsClientInGame(i) && !IsFakeClient(i) )
		{
			// Hook WeaponEquip and get player cookies
			DefaultCheck(i);
		}
	}

	if( g_iCvarAmmo > 1 )
		g_hNadeAmmo.IntValue = g_iCvarAmmo;
	g_hNadeVariance.FloatValue = 0.1;
	g_hNadeVelocity.IntValue = 10;
	g_hNadeVelocityUp.IntValue = 1;
}

void ResetPlugin()
{
	// Reset grenade launcher projectile speed
	g_hNadeAmmo.IntValue = g_iCvarAmmoDefault;
	g_hNadeVariance.IntValue = g_iNadeVariance;
	g_hNadeVelocity.IntValue = g_iNadeSpeedDefault;
	g_hNadeVelocityUp.IntValue = g_iNadeSpeedUp;

	DeleteAllFlares();

	for( int i = 1; i <= MaxClients; i++ )
	{
		if( g_iMenu[i] && IsClientInGame(i) )
			SDKUnhook(i, SDKHook_WeaponEquip, OnWeaponEquip);
		g_iMenu[i] = 0;
		g_fLastMenu[i] = 0.0;
	}
}



// ====================================================================================================
//					EVENTS
// ====================================================================================================
void Event_RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	for( int i = 1; i <= MaxClients; i++ )
	{
		g_bEquipped[i] = false;
		g_fLastMenu[i] = 0.0;
	}
	g_iGrenadeLimit = 0;
	DeleteAllFlares();
}



// ====================================================================================================
// 					FLARE GUN MENU
// ====================================================================================================
Action CmdFlareGun(int client, int args) // sm_flaregun command.
{
	if( g_bCvarAllow )
		MenuFlareGun(client, false);
	return Plugin_Handled;
}

int Menu_Status(int client, CookieMenuAction action, any info, char[] buffer, int maxlen) // sm_settings command.
{
	switch(action)
	{
		case CookieMenuAction_DisplayOption:
			Format(buffer, maxlen, "%T", "MenuTitle", client);
		case CookieMenuAction_SelectOption:
			MenuFlareGun(client, true);
	}

	return 0;
}

// Menu that appears when a user types !settings or !flaregun
void MenuFlareGun(int client, bool back)
{
	int access = g_iMenu[client];
	if( access == 0 )
	{
		ReplyToCommand(client, "[SM] %T.", "No Access", client);
		return;
	}

	Menu menu = new Menu(Menu_FlareDisplay);
	static char text[64];

	Format(text, sizeof(text), "%T", "MenuTitle", client);
	menu.SetTitle(text);

	// Display list depending on whats allowed
	if( access == 1 )
	{
		if( g_iCvarType & ENUM_DEFAULT )
		{
			Format(text, sizeof(text), "%T", "TitleDefault", client);
			menu.AddItem("0", text);
		}
		if( g_iCvarType & ENUM_FLARE )
		{
			Format(text, sizeof(text), "%T", "TitleFlare", client);
			menu.AddItem("1", text);
		}
		if( g_iCvarType & ENUM_BOUNCE )
		{
			Format(text, sizeof(text), "%T", "TitleBounce", client);
			menu.AddItem("2", text);
		}
		if( g_iCvarType & ENUM_STICKY )
		{
			Format(text, sizeof(text), "%T", "TitleSticky", client);
			menu.AddItem("3", text);
		}
		if( g_iCvarType & ENUM_JUMP )
		{
			Format(text, sizeof(text), "%T", "TitleJump", client);
			menu.AddItem("4", text);
		}
		if( g_iCvarType & ENUM_REMOTE )
		{
			Format(text, sizeof(text), "%T", "TitleRemote", client);
			menu.AddItem("5", text);
		}
		if( g_iCvarType & ENUM_TIMED )
		{
			Format(text, sizeof(text), "%T", "TitleTimed", client);
			menu.AddItem("6", text);
		}
		if( g_iCvarType & ENUM_SENSOR )
		{
			Format(text, sizeof(text), "%T", "TitleSensor", client);
			menu.AddItem("7", text);
		}
		if( g_iCvarType & ENUM_HOMING )
		{
			Format(text, sizeof(text), "%T", "TitleHoming", client);
			menu.AddItem("8", text);
		}
	}
	// Admins see all.
	else
	{
		Format(text, sizeof(text), "%T", "TitleDefault", client);
		menu.AddItem("0", text);
		Format(text, sizeof(text), "%T", "TitleFlare", client);
		menu.AddItem("1", text);
		Format(text, sizeof(text), "%T", "TitleBounce", client);
		menu.AddItem("2", text);
		Format(text, sizeof(text), "%T", "TitleSticky", client);
		menu.AddItem("3", text);
		Format(text, sizeof(text), "%T", "TitleJump", client);
		menu.AddItem("4", text);
		Format(text, sizeof(text), "%T", "TitleRemote", client);
		menu.AddItem("5", text);
		Format(text, sizeof(text), "%T", "TitleTimed", client);
		menu.AddItem("6", text);
		Format(text, sizeof(text), "%T", "TitleSensor", client);
		menu.AddItem("7", text);
		Format(text, sizeof(text), "%T", "TitleHoming", client);
		menu.AddItem("8", text);
	}

	if( back )
		menu.ExitBackButton = true;
	else
		menu.ExitButton = true;
	menu.Display(client, 30);
}

int Menu_FlareDisplay(Menu menu, MenuAction action, int param1, int param2)
{
	switch( action )
	{
		case MenuAction_Select:
		{
			static char sTemp[4];
			menu.GetItem(param2, sTemp, sizeof(sTemp));
			param2 = StringToInt(sTemp);
			FlareGun(param1, param2);
		}
		case MenuAction_Cancel:
		{
			if( param2 == MenuCancel_ExitBack )
				ShowCookieMenu(param1);
		}
		case MenuAction_End:
			delete menu;
	}

	return 0;
}

void FlareGun(int client, int type)
{
	type++;

	switch( type )
	{
		case TYPE_DEFAULT:
		{
			SetClientCookie(client, g_hCookie, "1");
			CPrintToChat(client, "%s%T", CHAT_TAG, "TypeDefault", client);
		}
		case TYPE_FLARE:
		{
			SetClientCookie(client, g_hCookie, "2");
			CPrintToChat(client, "%s%T", CHAT_TAG, "TypeFlare", client);
		}
		case TYPE_BOUNCE:
		{
			SetClientCookie(client, g_hCookie, "3");
			CPrintToChat(client, "%s%T", CHAT_TAG, "TypeBounce", client);
		}
		case TYPE_STICKY:
		{
			SetClientCookie(client, g_hCookie, "4");
			CPrintToChat(client, "%s%T", CHAT_TAG, "TypeSticky", client);
		}
		case TYPE_JUMP:
		{
			SetClientCookie(client, g_hCookie, "5");
			CPrintToChat(client, "%s%T", CHAT_TAG, "TypeJump", client);
		}
		case TYPE_REMOTE:
		{
			SetClientCookie(client, g_hCookie, "6");
			CPrintToChat(client, "%s%T", CHAT_TAG, "TypeRemote", client);
		}
		case TYPE_TIMED:
		{
			SetClientCookie(client, g_hCookie, "7");

			static char sTemp[256], sWeapon[32];
			FormatEx(sWeapon, sizeof(sWeapon), "%0.1f", g_fCvarTimeTimed);
			Format(sTemp, sizeof(sTemp), "%s%T", CHAT_TAG, "TypeTimed", client);
			ReplaceString(sTemp, sizeof(sTemp), "<TIME>", sWeapon);
			CPrintToChat(client, sTemp);
		}
		case TYPE_SENSOR:
		{
			SetClientCookie(client, g_hCookie, "8");
			CPrintToChat(client, "%s%T", CHAT_TAG, "TypeSensor", client);
		}
		case TYPE_HOMING:
		{
			SetClientCookie(client, g_hCookie, "9");
			CPrintToChat(client, "%s%T", CHAT_TAG, "TypeHoming", client);
		}
	}

	g_iType[client] = type;
}



// ====================================================================================================
// 					WEAPON EQUIP
// ====================================================================================================
// Display hint when picking up grenade_launcher
void OnWeaponEquip(int client, int weapon)
{
	if( IsClientInGame(client) && GetClientTeam(client) == 2 && IsValidEntity(weapon) )
	{
		static char sWeapon[128];
		GetEntityClassname(weapon, sWeapon, sizeof(sWeapon));
		if( strcmp(sWeapon[7], "grenade_launcher") == 0 )
		{
			if( g_bCvarPrefs == false )
				g_iType[client] = TYPE_DEFAULT;

			if( g_bEquipped[client] == false )
			{
				int type = g_iType[client];
				switch( type )
				{
					case TYPE_DEFAULT:			Format(sWeapon, sizeof(sWeapon), "%T", "TitleDefault", client);
					case TYPE_FLARE:			Format(sWeapon, sizeof(sWeapon), "%T", "TitleFlare", client);
					case TYPE_BOUNCE:			Format(sWeapon, sizeof(sWeapon), "%T", "TitleBounce", client);
					case TYPE_STICKY:			Format(sWeapon, sizeof(sWeapon), "%T", "TitleSticky", client);
					case TYPE_JUMP:				Format(sWeapon, sizeof(sWeapon), "%T", "TitleJump", client);
					case TYPE_REMOTE:			Format(sWeapon, sizeof(sWeapon), "%T", "TitleRemote", client);
					case TYPE_TIMED:			Format(sWeapon, sizeof(sWeapon), "%T", "TitleTimed", client);
					case TYPE_SENSOR:			Format(sWeapon, sizeof(sWeapon), "%T", "TitleSensor", client);
					case TYPE_HOMING:			Format(sWeapon, sizeof(sWeapon), "%T", "TitleHoming", client);
				}

				static char sTemp[256];
				Format(sTemp, sizeof(sTemp), "%s%T", CHAT_TAG, "Equipped", client);
				ReplaceString(sTemp, sizeof(sTemp), "<MODE>", sWeapon);
				CPrintToChat(client, sTemp);

				if( g_iCvarAuto )
					MenuFlareGun(client, false);
			}

			if( g_bCvarPrefs )
				SDKUnhook(client, SDKHook_WeaponEquip, OnWeaponEquip);
			else
				g_bEquipped[client] = true;
		}
	}
}



// ====================================================================================================
// 					ON ENTITY CREATED
// ====================================================================================================
// Called when someone shoots a grenade launcher projectile
public void OnEntityCreated(int entity, const char[] classname)
{
	if( g_bCvarAllow && !g_bBlockHook && strcmp(classname, "grenade_launcher_projectile") == 0 )
	{
		SDKHook(entity, SDKHook_SpawnPost, SpawnPost_MakeNade);
	}
}

void ReloadAmmoGrenadeLauncher(int client, bool reload, bool ammo)
{
	static char sClass[25];
	int iWeapon = GetPlayerWeaponSlot(client, 0);
	if( iWeapon != -1 )
	{
		GetEdictClassname(iWeapon, sClass, sizeof(sClass));

		if( strcmp(sClass[7], "grenade_launcher") == 0 )
		{
			int iAmmo = GetEntData(client, g_iAmmoOffset + 68);

			if( iAmmo != 0 )
			{
				if( reload == true && ammo == false )
				{
					SetEntProp(iWeapon, Prop_Send, "m_iClip1", 1, 1);
					SetEntData(client, g_iAmmoOffset + 68, iAmmo -1);
				}
				else if( reload == false && ammo == true )
				{
					SetEntData(client, g_iAmmoOffset + 68, iAmmo +1);
				}
				else
				{
					SetEntProp(iWeapon, Prop_Send, "m_iClip1", 1, 1);
				}
			}
		}
	}
}

void SpawnPost_MakeNade(int entity)
{
	if( !IsValidEntRef(entity) )
		return;

	// 1 frame later required to get velocity
	RequestFrame(OnFrame_MakeNade, EntIndexToEntRef(entity));
}

void OnFrame_MakeNade(int entity)
{
	if( !IsValidEntRef(entity) )
		return;


	// Support for Helicopter Gunship by panxiaohai, modified version by SilverShot.
	if( GetEntProp(entity, Prop_Data, "m_iHammerID") == 2467737 ) return;

	int client = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	if( client < 1 || client > MaxClients || !IsClientInGame(client) )
	{
		if( client == -1 )
		{
			return;
		}
		else
		{
			RemoveEntity(entity);
			return;
		}
	}


	if( g_iGrenadeLimit >= g_iCvarMaxTotal )
	{
		RemoveEntity(entity);
		ReloadAmmoGrenadeLauncher(client, true, true);
		return;
	}


	int index = GetFlareIndex();
	if( index == -1 )
	{
		RemoveEntity(entity);
		ReloadAmmoGrenadeLauncher(client, true, true);
		return;
	}


	int type = g_iType[client];
	int kill;

	// Limit flares when using the right click detonate for JUMP or BOMB types.
	if( type == TYPE_JUMP || type == TYPE_REMOTE )
	{
		int count;
		for( int i = 1; i <= MAX_STICKY_BOMBS; i++ )
		{
			if( IsValidEntRef(g_iSticky[client][i]) )
				count++;
		}

		if( count >= MAX_STICKY_BOMBS )
		{
			kill = 1;
		}
	}
	else if( type == TYPE_HOMING )
	{
		if( IsValidEntRef(g_iHoming[client]) )
		{
			kill = 1;
		}
	}
	else
	{
		// Non-admins are limited to cvar amount of flares each.
		if( g_iMenu[client] != 2 )
		{
			int count;
			for( int i = 0; i < MAX_PROJECTILES; i++ )
			{
				if( g_iFlareEntities[i][MAX_ENTITIES -1] == client )
					count++;
			}

			if( count >= g_iCvarMax )
			{
				kill = 1;
			}
		}
	}


	// Set ammo and/or reload
	if( kill )
		ReloadAmmoGrenadeLauncher(client, true, true);
	else if( g_bCvarReload == false && g_iCvarAmmo == 0 )
		ReloadAmmoGrenadeLauncher(client, true, true);
	else if( g_bCvarReload == false && g_iCvarAmmo != 0 )
		ReloadAmmoGrenadeLauncher(client, true, false);
	else if( g_iCvarAmmo == 0 )
		ReloadAmmoGrenadeLauncher(client, false, true);


	if( kill )
	{
		ReloadAmmoGrenadeLauncher(client, true, true);
		RemoveEntity(entity);
		return;
	}


	if( type == TYPE_HOMING )
	{
		static char sClass[25];
		int iWeapon = GetPlayerWeaponSlot(client, 0);
		if( iWeapon != -1 )
		{
			GetEdictClassname(iWeapon, sClass, sizeof(sClass));

			if( strcmp(sClass[7], "grenade_launcher") == 0 )
			{
				int iAmmo = GetEntData(client, g_iAmmoOffset + 68);

				if( iAmmo == 0 && GetEntProp(iWeapon, Prop_Send, "m_iClip1") == 0 )
					type = TYPE_DEFAULT;
			}
		}
	}


	// Default explosion, don't do anything.
	if( type == TYPE_DEFAULT )
	{
		// Forward
		Call_StartForward(g_hForwardProjectile);
		Call_PushCell(client);
		Call_PushCell(entity);
		Call_PushCell(type);
		Call_Finish();

		float vVel[3];
		GetEntPropVector(entity, Prop_Send, "m_vInitialVelocity", vVel);
		ScaleVector(vVel, float(g_iCvarSpeed) / 10 );
		TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, vVel);
		return;
	}

	bool bHookNewProjectile = true;
	int entityindex, iEnt1, iEnt2, iEnt3, iEnt4;

	if( type >= TYPE_BOUNCE )
		bHookNewProjectile = true;
	else
		bHookNewProjectile = false;


	// Can't find how to disable explosions so delete old projectile and create new so it bounces
	if( bHookNewProjectile )
	{
		g_iGrenadeLimit++;

		// Save origin and velocity
		float vPos[3], vAng[3], vVel[3];
		GetEntPropVector(entity, Prop_Data, "m_angRotation", vAng);
		GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", vPos);
		GetEntPropVector(entity, Prop_Send, "m_vInitialVelocity", vVel);

		if( type == TYPE_HOMING )
			ScaleVector(vVel, g_fCvarSpeedHoming / 10 );
		else
			ScaleVector(vVel, float(g_iCvarSpeed) / 10 );
		RemoveEntity(entity);

		// Create new projectile
		g_bBlockHook = true;
		entity = CreateEntityByName("grenade_launcher_projectile");
		g_bBlockHook = false;

		if( entity == -1 )	return;

		entityindex = entity;
		entity = EntIndexToEntRef(entity);

		SetEntProp(entity, Prop_Data, "m_iHammerID", index);
		SetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity", client);

		DispatchSpawn(entity);

		// Set origin and velocity
		float vDir[3];
		GetAngleVectors(vAng, vDir, NULL_VECTOR, NULL_VECTOR);
		vPos[0] += vDir[0] * 10;
		vPos[1] += vDir[1] * 10;
		vPos[2] += vDir[2] * 10;
		TeleportEntity(entity, vPos, vAng, vVel);
	}
	else
	{
		entityindex = EntRefToEntIndex(entity);
		float vVel[3];
		GetEntPropVector(entity, Prop_Send, "m_vInitialVelocity", vVel);
		ScaleVector(vVel, float(g_iCvarSpeed) / 10 );
		TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, vVel);
	}


	// Forward
	Call_StartForward(g_hForwardProjectile);
	Call_PushCell(client);
	Call_PushCell(entity);
	Call_PushCell(type);
	Call_Finish();


	// Set gravity and elasticity
	if( type == TYPE_HOMING )
	{
		SetEntPropFloat(entity, Prop_Data, "m_flGravity", 0.001);
	}
	else
	{
		SetEntPropFloat(entity, Prop_Data, "m_flGravity", g_fCvarGravity);
		SetEntPropFloat(entity, Prop_Data, "m_flElasticity", g_fCvarElasticity);
	}


	// Attach particles etc
	if( g_iCvarSmoke == 2 && type == TYPE_BOUNCE )
	{
		iEnt1 = DisplayParticle(PARTICLE_SMOKE, view_as<float>({ 0.0, 0.0, 0.0 }), view_as<float>({ 180.0, 0.0, 90.0 }), entity);
		iEnt1 = EntIndexToEntRef(iEnt1);

		// Refire
		SetVariantString("OnUser1 !self:Stop::0.65:-1");
		AcceptEntityInput(iEnt1, "AddOutput");
		SetVariantString("OnUser1 !self:FireUser2::0.7:-1");
		AcceptEntityInput(iEnt1, "AddOutput");
		AcceptEntityInput(iEnt1, "FireUser1");

		SetVariantString("OnUser2 !self:Start::0:-1");
		AcceptEntityInput(iEnt1, "AddOutput");
		SetVariantString("OnUser2 !self:FireUser1::0:-1");
		AcceptEntityInput(iEnt1, "AddOutput");
	}
	else if( g_iCvarSmoke == 1 || g_iCvarSmoke == 2 )
	{
		iEnt1 = DisplayParticle(PARTICLE_FLARE, view_as<float>({ 0.0, 0.0, 0.0 }), view_as<float>({ 180.0, 0.0, 90.0 }), entity);
		iEnt1 = EntIndexToEntRef(iEnt1);
	}

	if( g_bCvarSparks )
	{
		iEnt2 = DisplayParticle(PARTICLE_SPARKS, view_as<float>({ 0.0, 0.0, 0.0 }), view_as<float>({ 180.0, 0.0, 90.0 }), entity);
		iEnt2 = EntIndexToEntRef(iEnt2);
	}

	if( g_bCvarLight )
	{
		iEnt3 = MakeLightDynamic(view_as<float>({ 0.0, 0.0, 0.0 }), view_as<float>({ 180.0, 0.0, 90.0 }), entity);
		iEnt3 = EntIndexToEntRef(iEnt3);
	}

	if( g_bCvarSprite )
	{
		iEnt4 = MakeEnvSprite(view_as<float>({ 0.0, 0.0, 0.0 }), view_as<float>({ 180.0, 0.0, 90.0 }), entity);
		iEnt4 = EntIndexToEntRef(iEnt4);
	}


	// Sticky bomb launcher
	if( type >= TYPE_JUMP && type < TYPE_SENSOR )
	{
		bool bSaved;
		int iEntity, iNum;
		for( int i = 1; i <= MAX_STICKY_BOMBS; i++ )
		{
			iEntity = g_iSticky[client][i];
			if( IsValidEntRef(iEntity) )
			{
				iNum++;
			}
			else if( !bSaved )
			{
				bSaved = true;
				g_iSticky[client][i] = entity;
				iNum += 1;
			}
		}

		g_iSticky[client][0] = iNum;
	}


	// Save data
	g_iFlareEntities[index][INDEX_ENTITY] = entity;
	g_iFlareEntities[index][INDEX_FLARE] = iEnt1;
	g_iFlareEntities[index][INDEX_SPARKS] = iEnt2;
	g_iFlareEntities[index][INDEX_LIGHT] = iEnt3;
	g_iFlareEntities[index][INDEX_SPRITE] = iEnt4;
	g_iFlareEntities[index][INDEX_TYPE] = type;
	g_iFlareEntities[index][INDEX_CLIENT] = client;

	// Timer to delete projectile / detonate
	switch( type )
	{
		case TYPE_REMOTE:	CreateTimer(g_fCvarTimeRemote,	TimerDeleteFlares,	entity,		TIMER_FLAG_NO_MAPCHANGE);
		case TYPE_BOUNCE:	CreateTimer(g_fCvarTimeBounce,	TimerDeleteFlares,	entity,		TIMER_FLAG_NO_MAPCHANGE);
		case TYPE_JUMP:		CreateTimer(g_fCvarTimeJump,	TimerDeleteFlares,	entity,		TIMER_FLAG_NO_MAPCHANGE);
		case TYPE_SENSOR:	CreateTimer(g_fCvarTimeSensor,	TimerDeleteFlares,	entity,		TIMER_FLAG_NO_MAPCHANGE);
		case TYPE_STICKY:	CreateTimer(g_fCvarTimeSticky,	TimerDeleteFlares,	entity,		TIMER_FLAG_NO_MAPCHANGE);
		case TYPE_TIMED:	CreateTimer(g_fCvarTimeTimed,	TimerDeleteExplode,	entity,		TIMER_FLAG_NO_MAPCHANGE);
		case TYPE_HOMING:
		{
			g_iHoming[client] = entity;

			CreateTimer(0.1,				TimerHomingThink,	index,		TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(g_fCvarTimeHoming,	TimerDeleteExplode,	entity,		TIMER_FLAG_NO_MAPCHANGE);

			EmitSoundToAll(SOUND_FIRE, entity, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
		}
	}

	// Hook touch to ignite stuff or stick.
	if( bHookNewProjectile )
		SDKHook(entityindex, SDKHook_Touch, SDKHook_Touch_Callback);
}

Action TimerDeleteFlares(Handle timer, int entity)
{
	if( EntRefToEntIndex(entity) != INVALID_ENT_REFERENCE )
	{
		for( int i = 0; i < MAX_PROJECTILES; i++ )
		{
			if( entity == g_iFlareEntities[i][INDEX_ENTITY] )
			{
				g_iGrenadeLimit--;
				DeleteAllFlares(i);
				return Plugin_Continue;
			}
		}
	}

	return Plugin_Continue;
}

Action TimerDeleteExplode(Handle timer, int entity)
{
	if( EntRefToEntIndex(entity) != INVALID_ENT_REFERENCE )
	{
		for( int i = 0; i < MAX_PROJECTILES; i++ )
		{
			if( entity == g_iFlareEntities[i][INDEX_ENTITY] )
			{
				CreateExplosion(entity, g_iFlareEntities[i][INDEX_TYPE]);
				g_iGrenadeLimit--;
				DeleteAllFlares(i);
				return Plugin_Continue;
			}
		}
	}

	return Plugin_Continue;
}

Action TimerHomingThink(Handle timer, int index)
{
	int entity = g_iFlareEntities[index][INDEX_ENTITY];
	if( IsValidEntRef(entity) == false )
	{
		return Plugin_Stop;
	}

	int client = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	if( client < 1 || IsClientInGame(client) == false || IsPlayerAlive(client) == false )
	{
		CreateExplosion(entity, TYPE_HOMING);
		g_iGrenadeLimit--;
		DeleteAllFlares(index);
		return Plugin_Stop;
	}

	static char sClass[25];
	int iWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if( iWeapon != -1 )
	{
		GetEdictClassname(iWeapon, sClass, sizeof(sClass));

		if( strcmp(sClass[7], "grenade_launcher") == 0 )
		{
			iWeapon = 0;
		}
	}

	if( iWeapon != 0 )
	{
		CreateExplosion(entity, TYPE_HOMING);
		g_iGrenadeLimit--;
		DeleteAllFlares(index);
		return Plugin_Stop;
	}

	static float vAng[3], vPos[3];
	GetClientEyeAngles(client, vAng);
	GetClientEyePosition(client, vPos);

	Handle trace = TR_TraceRayFilterEx(vPos, vAng, MASK_SHOT, RayType_Infinite, TraceFilter, client);

	if( TR_DidHit(trace) )
	{
		static float vAim[3], vLoc[3];
		TR_GetEndPosition(vAim, trace);
		GetEntPropVector(entity, Prop_Data, "m_vecOrigin", vLoc);

		MakeVectorFromPoints(vLoc, vAim, vAim);

		GetEntPropVector(entity, Prop_Send, "m_vInitialVelocity", vAng);
		vAng[0] += vAim[0];
		vAng[1] += vAim[1];
		vAng[2] += vAim[2];

		NormalizeVector(vAng, vAng);
		ScaleVector(vAng, g_fCvarSpeedHoming);
		TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, vAng);
	}

	delete trace;
	return Plugin_Continue;
}

bool TraceFilter(int entity, int contentsMask, int client)
{
	if( entity == entity || entity == client )
		return false;
	return true;
}

void SDKHook_Touch_Callback(int entity, int victim)
{
	int client = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	int index = GetEntProp(entity, Prop_Data, "m_iHammerID");
	if( client < 1 ) return;

	// Make the grenade projectile stick
	if( victim && g_iFlareEntities[index][INDEX_TYPE] == TYPE_HOMING )
	{
		static char sTemp[10];
		GetEdictClassname(victim, sTemp, sizeof(sTemp));

		if( strncmp(sTemp, "trigger_", 8) == 0 )
			return;

		CreateExplosion(entity, TYPE_HOMING);
		g_iGrenadeLimit--;
		DeleteAllFlares(index);
		return;
	}

	if( victim == 0 )
	{
		int type = g_iType[client];

		if( type >= TYPE_STICKY )
		{
			SetEntPropVector(entity, Prop_Data, "m_vecAbsVelocity", view_as<float>({ 0.0, 0.0, 0.0 }));
			SetEntityMoveType(entity, MOVETYPE_NONE);
			SetEntProp(entity, Prop_Send, "m_nSolidType", 6);
			SDKUnhook(entity, SDKHook_Touch, SDKHook_Touch_Callback);

			if( type == TYPE_SENSOR )
			{
				int trigger = CreateEntityByName("trigger_multiple");
				DispatchKeyValue(trigger, "model", MODEL_BOUNDING);
				static char sTemp[32];
				Format(sTemp, sizeof(sTemp), "%d%d", trigger, entity);
				DispatchKeyValue(entity, "targetname", sTemp);
				DispatchKeyValue(trigger, "spawnflags", "64");
				DispatchSpawn(trigger);
				ActivateEntity(trigger);

				float vPos[3];
				GetEntPropVector(entity, Prop_Data, "m_vecOrigin", vPos);
				vPos[2] += 5.0;
				TeleportEntity(trigger, vPos, NULL_VECTOR, NULL_VECTOR);

				SetEntProp(trigger, Prop_Send, "m_nSolidType", 2);
				SetEntProp(trigger, Prop_Data, "m_iHammerID", index);
				SetEntPropEnt(trigger, Prop_Send, "m_hOwnerEntity", client);
				SDKHook(trigger, SDKHook_Touch, OnTouchSensor);
			}
		}

		return;
	}


	if( g_iCvarHurt == 0 && g_iCvarHurtSI == 0 ) return;

	static char sClass[16];

	// Only damage players once per second.
	bool bInfected;
	if( victim > 0 && victim <= MaxClients )
	{
		float fEngineTime = GetGameTime();
		if( fEngineTime - g_fLastHurt[victim] < 1.0 ) // How often to hurt the player (once every 1.0 secs)
			return;

		g_fLastHurt[victim] = fEngineTime;

		if( GetClientTeam(victim) == 3 )
		{
			if( g_iCvarHurtSI == 0 )
				return;
			bInfected = true;
		}
		else if( g_iCvarHurt == 0 )
			return;
	}
	else if( victim > MaxClients )
	{
		// Only damage these types (survivors, common, special, explosives).
		GetEntityNetClass(victim, sClass, sizeof(sClass));
		if( strcmp(sClass, "Infected") != 0 && strcmp(sClass, "CPhysicsProp") != 0 && strcmp(sClass, "CGasCan") != 0 && strcmp(sClass, "Witch") != 0 )
			return;
	}


	// Create a point_hurt
	float vPos[3];
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", vPos);
	SDKHooks_TakeDamage(victim, client, client, bInfected ? float(g_iCvarHurtSI) : float(g_iCvarHurt), DMG_BURN, -1, NULL_VECTOR, vPos);
}

void OnTouchSensor(int entity, int client)
{
	if( client > 0 && client <= MaxClients )
	{
		if( GetClientTeam(client) == 3 )
		{
			int index = GetEntProp(entity, Prop_Data, "m_iHammerID");
			CreateExplosion(entity, TYPE_SENSOR);
			g_iGrenadeLimit--;
			DeleteAllFlares(index);
			SDKUnhook(entity, SDKHook_Touch, OnTouchSensor);
			RemoveEntity(entity);
		}
	}
	else
	{
		static char sTemp[10];
		GetEdictClassname(client, sTemp, sizeof(sTemp));

		if( strcmp(sTemp, "infected") == 0 )
		{
			int index = GetEntProp(entity, Prop_Data, "m_iHammerID");
			CreateExplosion(entity, TYPE_SENSOR);
			g_iGrenadeLimit--;
			DeleteAllFlares(index);
			SDKUnhook(entity, SDKHook_Touch, OnTouchSensor);
			RemoveEntity(entity);
		}
	}
}



// ====================================================================================================
//					ON PLAYER RUN CMD / MENU / STICKY BOMB LAUNCHER
// ===================================================================================================
public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	static char sClass[25];

	// Menu on ZOOM key, once a second to lower CPU usage
	if( g_bCvarAllow && g_bCvarMenuButton && buttons & IN_ZOOM && GetGameTime() - g_fLastMenu[client] > 1.0 )
	{
		g_fLastMenu[client] = GetGameTime();
		GetClientWeapon(client, sClass, sizeof(sClass));
		if( strcmp(sClass[7], "grenade_launcher") == 0 )
		{
			MenuFlareGun(client, false);
		}
	}

	// Sticky launch
	if( g_bCvarAllow && buttons & IN_ATTACK2 )
	{
		if( g_iSticky[client][0] )
		{
			int type = g_iType[client];
			if( (type == TYPE_JUMP || type == TYPE_REMOTE) && GetClientTeam(client) == 2 && IsPlayerAlive(client) )
			{
				GetClientWeapon(client, sClass, sizeof(sClass));
				if( strcmp(sClass[7], "grenade_launcher") == 0 )
				{
					LaunchPlayer(client);
					return Plugin_Continue;
				}
			}
		}
	}

	return Plugin_Continue;
}

void LaunchPlayer(int client)
{
	int entity;

	// Explosion only
	if( g_iType[client] == TYPE_REMOTE )
	{
		for( int i = 1; i <= MAX_STICKY_BOMBS; i++ )
		{
			entity = g_iSticky[client][i];
			if( IsValidEntRef(entity) )
			{
				entity = EntRefToEntIndex(entity);
				CreateExplosion(entity, TYPE_REMOTE); // Explosion and damage
				g_iGrenadeLimit--;
				RemoveEntity(entity);
			}
			g_iSticky[client][i] = 0;
		}
		g_iSticky[client][0] = 0;
	}
	else // Explosion and teleport
	{
		int iNum = g_iSticky[client][0];
		if( iNum == 0 ) return;
		iNum = 0;

		float vPos[3], vClientPos[3], vClientVel[3];
		float vFinalVel[3], vForce, fDistance;//, fRange;
		int iStickyCount;

		GetClientAbsOrigin(client, vClientPos);										// Player position
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", vClientVel);			// Player velocity
		ScaleVector(vClientVel, 0.3);												// Scale velocity 0.3

		for( int i = 1; i <= MAX_STICKY_BOMBS; i++ )								// Loop sticky bombs
		{
			entity = g_iSticky[client][i];											// Get sticky bomb entity ID
			if( IsValidEntRef(entity) )												// Check it's valid
			{
				entity = EntRefToEntIndex(entity);									// Convert sticky bomb entity ref ID to entity index
				g_iGrenadeLimit--;

				CreateExplosion(entity, TYPE_JUMP); 								// Kaboom!

				GetEntPropVector(entity, Prop_Send, "m_vecOrigin", vPos);			// Get sticky bomb position
				fDistance = GetVectorDistance(vPos, vClientPos);					// Check player in range to sticky bomb
				if( fDistance <= g_fCvarDistance )
				{
					// fRange+= fDistance;
					iStickyCount += 1;

					MakeVectorFromPoints(vPos, vClientPos, vPos);					// Vector from grenade to client position

					vForce = (1.0 / fDistance) * g_fCvarForce;						// The force of the push
					vForce = vForce / (iStickyCount * 1.5);

					ScaleVector(vPos, vForce);
					vFinalVel[0] += vPos[0] / 1.5;									// Reduce side movement
					vFinalVel[1] += vPos[1] / 1.5;
					vFinalVel[2] += vPos[2];

					iNum = 1;
				}

				g_iSticky[client][i] = 0;
				RemoveEntity(entity);
			}
		}

		if( iNum == 0 )
			return;

		if( g_iCvarGod == 1 || g_iCvarGod == 3 ) // Ledge
			AcceptEntityInput(client, "DisableLedgeHang");

		if( g_iCvarGod == 2 || g_iCvarGod == 3 ) // Fall
			SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);

		if( g_iCvarGod )
			SDKHook(client, SDKHook_PreThink, OnPreThink);

		// Finally teleport the player
		g_iSticky[client][0] = 0;
		AddVectors(vClientVel, vFinalVel, vFinalVel);
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vFinalVel);
	}
}

Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	// if( damagetype == 32 ) // #define DMG_FALL (1<<5)
	if( damagetype & (1<<5) ) // #define DMG_FALL (1<<5)
	{
		damage = 0.0;
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

void OnPreThink(int client)
{
	if( GetEntityFlags(client) & FL_ONGROUND )
	{
		if( g_iCvarGod == 2 || g_iCvarGod == 3 ) // Fall
			SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);

		if( g_iCvarGod == 1 || g_iCvarGod == 3 && IsPlayerAlive(client) ) // Ledge
			AcceptEntityInput(client, "EnableLedgeHang");

		SDKUnhook(client, SDKHook_PreThink, OnPreThink); // 2018: Should of unhooked after use, right?
	}
}

int g_iEntityExplosion;
void CreateExplosion(int client, int type)
{
	float vPos[3];
	static char sTemp[16];
	GetEntPropVector(client, Prop_Data, "m_vecAbsOrigin", vPos);

	// Get the max damage for type
	float fDamage;
	switch( type )
	{
		case TYPE_REMOTE:	fDamage = g_fCvarDamageRemote;
		case TYPE_HOMING:	fDamage = g_fCvarDamageHoming;
		case TYPE_JUMP:		fDamage = g_fCvarDamageJump;
		case TYPE_SENSOR:	fDamage = g_fCvarDamageSensor;
		default:			fDamage = g_fCvarDamageTimed;
	}

	FloatToString(fDamage, sTemp, sizeof(sTemp));


	// Shake!
	int entity = CreateEntityByName("env_shake");
	if( entity != -1 )
	{
		DispatchKeyValue(entity, "spawnflags", "8");
		DispatchKeyValue(entity, "amplitude", "16.0");
		DispatchKeyValue(entity, "frequency", "1.5");
		DispatchKeyValue(entity, "duration", "0.9");
		FloatToString(g_fCvarDistance, sTemp, sizeof(sTemp));
		DispatchKeyValue(entity, "radius", sTemp);
		DispatchSpawn(entity);
		ActivateEntity(entity);
		AcceptEntityInput(entity, "Enable");

		TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);
		AcceptEntityInput(entity, "StartShake");

		SetVariantString("OnUser1 !self:Kill::1.1:1");
		AcceptEntityInput(entity, "AddOutput");
		AcceptEntityInput(entity, "FireUser1");
	}

	// Loop through survivors, work out distance, scale damage according to friendly fire and distance.
	// Enable godmode so the explosion below does not hurt, and only our ff scaled affects clients.
	bool bSetDamage;
	float fClients[MAXPLAYERS+1];

	int owner = GetEntPropEnt(client, Prop_Send, "m_hOwnerEntity");
	if( owner > 0 && owner <= MaxClients && IsClientInGame(owner) )
	{
		float vPosFF[3];
		float fHurt, fDistance;
		bSetDamage = true;

		for( int i = 1; i <= MaxClients; i++ )
		{
			if( IsClientInGame(i) && GetClientTeam(i) == 2 && IsPlayerAlive(i) )
			{
				GetClientAbsOrigin(i, vPosFF);
				fDistance = GetVectorDistance(vPos, vPosFF);

				if( fDistance <= g_fCvarDistance )
				{
					if( i == owner )
						fHurt = fDamage * g_fCvarDamageFFSelf;
					else
						fHurt = fDamage * g_fCvarDamageFFScale;
					fDistance = 100 * fDistance / g_fCvarDistance;
					fDistance = fHurt * fDistance / 100;
					fHurt = fHurt - fDistance;

					fClients[i] = fHurt;
					if( fHurt != 0.0 )
					{
						SetEntProp(i, Prop_Data, "m_takedamage", 0);

						if( g_iCvarHurtStumble && (type != TYPE_JUMP || i != owner) )
						{
							StaggerClient(GetClientUserId(i), vPos);
							// SDKCall(g_sdkStagger, i, entity, vPos); // Stagger: SDKCall method
						}
					}
				}
			}
		}
	}


	// Create explosion, kills infected/special infected and credits owner for kill. Also pushes physics entities.
	entity = CreateEntityByName("env_explosion");
	g_iEntityExplosion = EntIndexToEntRef(entity);

	// Block explosion entity causing stumble
	for( int i = 1; i <= MaxClients; i++ )
	{
		if( IsClientInGame(i) )
		{
			SDKHook(i, SDKHook_OnTakeDamage, OnTakeExplosion);
		}
	}

	FloatToString(fDamage, sTemp, sizeof(sTemp));
	DispatchKeyValue(entity, "iMagnitude", sTemp);
	DispatchKeyValue(entity, "spawnflags", "1916");
	FloatToString(g_fCvarDistance, sTemp, sizeof(sTemp));
	DispatchKeyValue(entity, "iRadiusOverride", sTemp);
	DispatchSpawn(entity);
	TeleportEntity(entity, vPos, NULL_VECTOR, NULL_VECTOR);
	SetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity", owner);
	AcceptEntityInput(entity, "Explode");

	for( int i = 1; i <= MaxClients; i++ )
	{
		if( IsClientInGame(i) )
		{
			SDKUnhook(i, SDKHook_OnTakeDamage, OnTakeExplosion);
		}
	}


	// Hurt survivors with scaled damage, except don't let the owner hurt himself (so the teleporting with the jump mode works).
	if( bSetDamage == true )
	{
		for( int i = 1; i <= MaxClients; i++ )
		{
			fDamage = fClients[i];
			if( fDamage != 0.0 )
			{
				SetEntProp(i, Prop_Data, "m_takedamage", 2);
				SDKHooks_TakeDamage(i, i != owner ? owner : 0, i != owner ? owner : 0, fDamage, DMG_GENERIC);
			}
		}
	}

	// Explosion effect
	DisplayParticle(PARTICLE_BOMB, vPos, NULL_VECTOR);

	// Sound
	int random = GetRandomInt(0, 2);
	switch( random )
	{
		case 0:		EmitSoundToAll(SOUND_EXPLODE3, entity, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
		case 1:		EmitSoundToAll(SOUND_EXPLODE4, entity, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
		case 2:		EmitSoundToAll(SOUND_EXPLODE5, entity, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, SNDVOL_NORMAL, SNDPITCH_NORMAL, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
	}
}

Action OnTakeExplosion(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if( inflictor > MaxClients && EntIndexToEntRef(inflictor) == g_iEntityExplosion )
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}



// ====================================================================================================
//					PARTICLES
// ====================================================================================================
int DisplayParticle(const char[] sParticle, const float vPos[3], const float vAng[3], int client = 0)
{
	int entity = CreateEntityByName("info_particle_system");

	if( entity != -1 )
	{
		DispatchKeyValue(entity, "effect_name", sParticle);
		DispatchSpawn(entity);
		ActivateEntity(entity);
		AcceptEntityInput(entity, "start");

		if( client )
		{
			// Attach to survivor
			SetVariantString("!activator");
			AcceptEntityInput(entity, "SetParent", client);
		}

		TeleportEntity(entity, vPos, vAng, NULL_VECTOR);

		return entity;
	}

	return 0;
}

void PrecacheParticle(const char[] sEffectName)
{
	static int table = INVALID_STRING_TABLE;
	if( table == INVALID_STRING_TABLE )
	{
		table = FindStringTable("ParticleEffectNames");
	}

	if( FindStringIndex(table, sEffectName) == INVALID_STRING_INDEX )
	{
		bool save = LockStringTables(false);
		AddToStringTable(table, sEffectName);
		LockStringTables(save);
	}
}



// ====================================================================================================
//					MAKE LIGHTS ETC
// ====================================================================================================
int MakeLightDynamic(const float vOrigin[3], const float vAngles[3], int client)
{
	int entity = CreateEntityByName("light_dynamic");
	if( entity == -1)
	{
		LogError("Failed to create 'light_dynamic'");
		return 0;
	}

	static char sTemp[16];
	Format(sTemp, sizeof(sTemp), "%s 255", g_sCvarCols);
	DispatchKeyValue(entity, "_light", sTemp);
	DispatchKeyValue(entity, "brightness", "1");
	DispatchKeyValueFloat(entity, "spotlight_radius", 32.0);
	DispatchKeyValueFloat(entity, "distance", 300.0);
	DispatchKeyValue(entity, "style", "6");
	DispatchSpawn(entity);
	AcceptEntityInput(entity, "TurnOn");

	// Attach
	SetVariantString("!activator");
	AcceptEntityInput(entity, "SetParent", client);

	TeleportEntity(entity, vOrigin, vAngles, NULL_VECTOR);
	return entity;
}

int MakeEnvSprite(const float vOrigin[3], const float vAngles[3], int client)
{
	int entity = CreateEntityByName("env_sprite");
	if( entity == -1)
	{
		LogError("Failed to create 'env_sprite'");
		return 0;
	}

	DispatchKeyValue(entity, "rendercolor", g_sSpriteCols);
	DispatchKeyValue(entity, "model", MODEL_SPRITE);
	DispatchKeyValue(entity, "spawnflags", "3");
	DispatchKeyValue(entity, "rendermode", "9");
	DispatchKeyValue(entity, "GlowProxySize", "256.0");
	DispatchKeyValue(entity, "renderamt", "120");
	DispatchKeyValue(entity, "scale", "256.0");
	DispatchSpawn(entity);

	// Attach
	SetVariantString("!activator");
	AcceptEntityInput(entity, "SetParent", client);

	TeleportEntity(entity, vOrigin, vAngles, NULL_VECTOR);
	return entity;
}



// ====================================================================================================
//					DELETE ENTITIES
// ====================================================================================================
void DeleteAllFlares(int index = -1)
{
	int entity;

	if( index == -1 )
	{
		for( int i = 0; i <= MAXPLAYERS; i++ )
		{
			for( int x = 0; x <= MAX_STICKY_BOMBS; x++ )
			{
				g_iSticky[i][x] = 0;
			}
		}

		entity = g_iFlareEntities[0][INDEX_ENTITY];
		g_iFlareEntities[0][INDEX_ENTITY] = 0;
		if( IsValidEntRef(entity) )
		{
			StopSound(entity, SNDCHAN_AUTO, SOUND_FIRE);
			RemoveEntity(entity);
		}

		for( int i = 1; i < MAX_PROJECTILES; i++ )
		{
			for( int x = 0; x < MAX_ENTITIES -2; x++ )
			{
				entity = g_iFlareEntities[i][x];
				g_iFlareEntities[i][x] = 0;

				if( IsValidEntRef(entity) )
					RemoveEntity(entity);
			}

			g_iFlareEntities[i][MAX_ENTITIES -1] = 0;
			g_iFlareEntities[i][MAX_ENTITIES -2] = 0;
		}
	}
	else
	{
		entity = g_iFlareEntities[index][INDEX_ENTITY];
		g_iFlareEntities[index][INDEX_ENTITY] = 0;
		if( IsValidEntRef(entity) )
		{
			StopSound(entity, SNDCHAN_AUTO, SOUND_FIRE);
			RemoveEntity(entity);
		}

		for( int i = 0; i < MAX_ENTITIES -2; i++ )
		{
			entity = g_iFlareEntities[index][i];
			g_iFlareEntities[index][i] = 0;

			if( IsValidEntRef(entity) )
				RemoveEntity(entity);
		}

		g_iFlareEntities[index][MAX_ENTITIES -1] = 0;
		g_iFlareEntities[index][MAX_ENTITIES -2] = 0;
	}
}

int GetFlareIndex()
{
	int entity;
	for( int i = 0; i < MAX_PROJECTILES; i++ )
	{
		entity = g_iFlareEntities[i][INDEX_ENTITY];
		if( entity == 0 || EntRefToEntIndex(entity) == INVALID_ENT_REFERENCE )
			return i;
	}
	return -1;
}



// ====================================================================================================
//					OTHER
// ====================================================================================================
bool IsValidEntRef(int entity)
{
	if( entity && EntRefToEntIndex(entity) != INVALID_ENT_REFERENCE )
		return true;
	return false;
}

// Credit to Timocop on VScript function
void StaggerClient(int iUserID, const float fPos[3])
{
	static int iScriptLogic = INVALID_ENT_REFERENCE;
	if( iScriptLogic == INVALID_ENT_REFERENCE || !IsValidEntity(iScriptLogic) )
	{
		iScriptLogic = EntIndexToEntRef(CreateEntityByName("logic_script"));
		if( iScriptLogic == INVALID_ENT_REFERENCE || !IsValidEntity(iScriptLogic) )
			LogError("Could not create 'logic_script");

		DispatchSpawn(iScriptLogic);
	}

	static char sBuffer[96];
	Format(sBuffer, sizeof(sBuffer), "GetPlayerFromUserID(%d).Stagger(Vector(%d,%d,%d))", iUserID, RoundFloat(fPos[0]), RoundFloat(fPos[1]), RoundFloat(fPos[2]));
	SetVariantString(sBuffer);
	AcceptEntityInput(iScriptLogic, "RunScriptCode");
	RemoveEntity(iScriptLogic);
}

void CPrintToChat(int client, char[] message, any ...)
{
	static char buffer[256];
	VFormat(buffer, sizeof(buffer), message, 3);

	ReplaceString(buffer, sizeof(buffer), "{default}",		"\x01");
	ReplaceString(buffer, sizeof(buffer), "{white}",		"\x01");
	ReplaceString(buffer, sizeof(buffer), "{cyan}",			"\x03");
	ReplaceString(buffer, sizeof(buffer), "{lightgreen}",	"\x03");
	ReplaceString(buffer, sizeof(buffer), "{orange}",		"\x04");
	ReplaceString(buffer, sizeof(buffer), "{green}",		"\x04"); // Actually orange in L4D2, but replicating colors.inc behaviour
	ReplaceString(buffer, sizeof(buffer), "{olive}",		"\x05");

	PrintToChat(client, buffer);
}