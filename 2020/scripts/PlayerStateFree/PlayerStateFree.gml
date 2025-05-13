// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PlayerStateFree(){
	hsp = lengthdir_x(inputMagnitude * walkSpeed, inputDirection);
	vsp = lengthdir_y(inputMagnitude * walkSpeed, inputDirection);

	PlayerCollision();
	//update sprite index
	var _oldSprite = sprite_index;
	if (inputMagnitude != 0)
	{
		direction = inputDirection
		sprite_index = spriteRun;	
	}else sprite_index = spriteIdle;	
	if (_oldSprite != sprite_index) localFrame = 0;
	
	//update image index
	PlayerAnimateSprite();
}