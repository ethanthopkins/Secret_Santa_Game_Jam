room = ROOM;
layer_set_visible("Col",false);

global.textSpeed = .75;


#region SETUP ENUMS / ARRAYS
globalvar ga_heroes, ga_magic, ga_item, ga_inv, ga_monsters;

//Create Item Array
ga_item[0,0] = "HERB";
ga_item[0,1] = 2; //Min Heal
ga_item[0,2] = 2; //Max Heal
ga_item[0,3] = 0;
ga_item[0,4] = 0; //Type of Item - 0: Healing

//Create Inventory Array
ga_inv[0] = 0; 
ga_inv[1] = 0;
ga_inv[2] = -1; //-1:Empty

enum e_spells{
	heal,
	hurt
}

enum e_spell_stats{
	name,
	hp_healed_min,
	hp_healed_max,
	mp_cost,
}

///Create Magic Array
ga_magic[e_spells.heal,e_spell_stats.name] = "HEAL"; //Name
ga_magic[e_spells.heal,e_spell_stats.hp_healed_min] = 4; //Minimum HP Healed
ga_magic[e_spells.heal,e_spell_stats.hp_healed_max] = 8; //Maximum HP Healed
ga_magic[e_spells.heal,e_spell_stats.mp_cost] = 4; //MP Used per heal

ga_magic[e_spells.hurt,e_spell_stats.name] = "HURT";
ga_magic[e_spells.hurt,e_spell_stats.hp_healed_min] = -2;
ga_magic[e_spells.hurt,e_spell_stats.hp_healed_max] = -4;
ga_magic[e_spells.hurt,e_spell_stats.mp_cost] = 2;

//TYPE OF MONSTERS
enum e_mon{
	cake
}

//MONSTER STATS
enum e_mon_stats{
	knows_heal,
	knows_hurt,
	knows_sleep,
	knows_stun,
	knows_attack,
	name,
	hp_current,
	hp_max,
	dam_min,
	dam_max,
	xp_value,
	gold_value,
}

//CREATE MONSTERS
ga_monsters[e_mon.cake,e_mon_stats.name] = "CAKE";
ga_monsters[e_mon.cake,e_mon_stats.hp_current] = 3; 
ga_monsters[e_mon.cake,e_mon_stats.hp_max] = 3; 
ga_monsters[e_mon.cake,e_mon_stats.dam_min] = 1; 
ga_monsters[e_mon.cake,e_mon_stats.dam_max] = 2; 
ga_monsters[e_mon.cake,e_mon_stats.xp_value] = 1; 
ga_monsters[e_mon.cake,e_mon_stats.gold_value] = 2; 
ga_monsters[e_mon.cake,e_mon_stats.knows_attack] = true;
ga_monsters[e_mon.cake,e_mon_stats.knows_heal] = false;
ga_monsters[e_mon.cake,e_mon_stats.knows_hurt] = false;
ga_monsters[e_mon.cake,e_mon_stats.knows_sleep] = false;
ga_monsters[e_mon.cake,e_mon_stats.knows_stun] = false;

#endregion

randomize();
