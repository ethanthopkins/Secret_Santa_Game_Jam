if room = rKitchen
{
	audio_play_sound(sn_Christmas,10,true);	
}

if room = rBattle
{
	audio_stop_sound(sn_Christmas);
	audio_play_sound(snBattle,10,true);
}

if room = rGameWon
{
	audio_stop_sound(snBattle);
	audio_play_sound(sn_Christmas,10,true);	
}

if room = rGameOver
{
	audio_stop_sound(snBattle);
	audio_play_sound(sn_Christmas,10,true);	
}