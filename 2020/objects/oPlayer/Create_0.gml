/// @desc Declare Variables
state = PlayerStateFree;
lock = false;

image_index = 3;
image_speed = 0;
walkSpeed = 1.5;
hsp = 0;
vsp = 0;
activate = noone;

collisionMap = layer_tilemap_get_id(layer_get_id("Col"));

spriteIdle = sPlayer
spriteRun = sPlayerRun

localFrame = 0;

