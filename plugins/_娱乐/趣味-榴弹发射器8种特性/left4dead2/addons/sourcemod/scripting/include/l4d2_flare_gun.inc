#if defined _flaregun_included
  #endinput
#endif
#define _flaregun_included


enum
{
	FLAREGUN_TYPE_DEFAULT = 1,
	FLAREGUN_TYPE_FLARE,
	FLAREGUN_TYPE_BOUNCE,
	FLAREGUN_TYPE_STICKY,
	FLAREGUN_TYPE_JUMP,
	FLAREGUN_TYPE_REMOTE,
	FLAREGUN_TYPE_TIMED,
	FLAREGUN_TYPE_SENSOR,
	FLAREGUN_TYPE_HOMING
}


/**
 * @brief Called when a Flare Gun projectile is created.
 * @remarks Does not trigger if the maximum number of projectiles has been created.
 *
 * @param		client		Who created the projectile.
 * @param		entity		Projectile entity index.
 * @param		type		The Flare Gun type created.
 */
forward void OnFlareGunProjectile(int client, int entity, int type);