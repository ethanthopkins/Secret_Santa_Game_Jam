#region INITIALISATION OF VARIABLES - THIS IS DONE EVERY TIME A BATTLE IS SPAWNED
if (state == "INIT"){
	if (ds_exists(ds_messages, ds_type_list)){
		ds_list_destroy(ds_messages);	
	}
	
	//GET A RANDOM MONSTER FROM THE LIST
	totalMonsters = array_height_2d(ga_monsters) - 1;
	monsterType = irandom(totalMonsters);
	
	//SETUP VARIABLES FROM GLOBAL ARRAY (to save always typing them out)
	monsterName = ga_monsters[monsterType, e_mon_stats.name];
	monsterHP = ga_monsters[monsterType, e_mon_stats.hp_current];
	monsterHP_MAX = ga_monsters[monsterType, e_mon_stats.hp_max];
	monsterMinDmg = ga_monsters[monsterType, e_mon_stats.dam_min];
	monsterMaxDmg = ga_monsters[monsterType, e_mon_stats.dam_max];
	xpGained = ga_monsters[monsterType, e_mon_stats.xp_value];
	goldGained = ga_monsters[monsterType, e_mon_stats.gold_value];

	selected_option = 0; //Which option is the arrow over?
	playerTurn = true;
	ds_messages = ds_list_create();
	messageCounter = 0; //Tracks which message we're on
	showBattleText = false; //Display battle text or not (player must press through it before next actor can take their turn

	messageTimer = 0;

	enemyTimer = 0;
	battleOption = 0; //Which option has been selected by either monster or player

	playerDead = false;
	playerDamageMod = 1; //Multiply any damage done to player by this mod
	runsAway = false;
	isAsleep = false;
	stunned = 0;
	
	victory = false;
	victorySoundPlayed = false;
	
	showMagicOptions = false; //Show magic menu or not
	magic_option = 0; //Which spell are we using
	showInventory = false; //Show inventory or not
	inv_option = 0; //Which item are we using
with (oPlayer)
{
	lock = true;	
}
	battleSpawnTimer = 0;

	//Screen Shake
	shakeTimer = 0;

	state = "READY";
	battle = true;
}
#endregion

if (battle == true) && (state == "READY"){
	
	#region SELECT OPTION
	if (playerTurn) && (!showBattleText){
		
		//Reset Damage Modifier to Player
		playerDamageMod = 1;
		
		if (!isAsleep) && (stunned <= 0){

			if (!showMagicOptions) && (!showInventory){
				if (keyboard_check_pressed(vk_down)){
					//If not at the last option, go down one
					if (selected_option + 1) <= (array_length_1d(a_text) - 1){
						selected_option ++;
					//Else go back to the first option
					}else{
						selected_option = 0;	
					}
					//Play Sound
					audio_play_sound(snd_move_arrow, 1, false);
				}

				if (keyboard_check_pressed(vk_up)){
					//if not at the topmost option, go up 1
					if ((selected_option - 1) >= 0){
						selected_option --;
						//Else go to bottom
					}else{
						selected_option = array_length_1d(a_text) - 1;
					}
					//Play Sound
					audio_play_sound(snd_move_arrow, 1, false);
				}
			
				//If Option is Pressed
				if (keyboard_check_pressed(vk_space)){
					messageCounter = 0;
					if (!ds_exists(ds_messages, ds_type_list)){
						ds_messages = ds_list_create();	
					}
					//Attack
					if (selected_option == 0){
	
						ds_messages[| 0] = "Player ATTACKS!";
						roll = choose("HIT", "HIT","MISS");
			
						if (roll = "MISS"){
							ds_messages[| 1] = "But misses...";	
						}else{
							//If a hit is rolled
							dmg = irandom(1) + 1;
					
							monsterHP -= dmg;
					
							if (monsterHP <= 0){
								victory = true;
								ds_messages[| 2] = monsterName + " dies..."
						
								ds_messages[| 3] = "PLAYER gains " + string(xpGained) + " xp!"
								ds_messages[| 4] = "PLAYER gains " + string(goldGained) + " gold!";
							}
					
							ds_messages[| 1] = "And hits for " + string(dmg) + " damage ~!";
						}
			
					}
					//Defend
					if (selected_option == 1){
						ds_messages[| 0] = "Player DEFENDS!";
						playerDamageMod = 0.5;
					}
					//Magic
					if (selected_option == 2){
						showMagicOptions = true;
					}
					//Item
					if (selected_option == 3){
						showInventory = true
					}
					//Run
					if (selected_option == 4){
						ds_messages[| 0] = "You try to run to the other side of the kitchen!";
						roll = choose("Fails", "Succeeds");
			
						if (roll = "Fails"){
							ds_messages[| 1] = "But slips over some water. That's what you\n get for not cleaning up after yourself";
						}else{
							runsAway = true;
							ds_messages[| 1] = "And you hide inside a cabinet for all of eternity";
						}
					}
		
					if (selected_option != 2) && (selected_option != 3){
						showBattleText = true;
					}
				
					battleOption = selected_option;
					audio_play_sound(snd_option, 1, false);
				}
			}else{
				//SHOW MAGIC MENU 
				if (showMagicOptions){
					if (keyboard_check_pressed(vk_down)){
						//If not at the last option, go down one
						if (magic_option + 1) <= (array_height_2d(ga_magic) - 1){
							magic_option ++;
						//Else go back to the first option
						}else{
							magic_option = 0;	
						}
						//Play Sound
						audio_play_sound(snd_move_arrow, 1, false);
					}

					if (keyboard_check_pressed(vk_up)){
						//if not at the topmost option, go up 1
						if ((magic_option - 1) >= 0){
							magic_option --;
							//Else go to bottom
						}else{
							magic_option = array_height_2d(ga_magic) - 1;
						}
						//Play Sound
						audio_play_sound(snd_move_arrow, 1, false);
					}
				
					//CHOOSE SPELLS
					if (keyboard_check_pressed(vk_space)){
						manaCost = ga_magic[magic_option, e_spell_stats.mp_cost];
					
						if (playerMP >= manaCost){
						
							healHurt = scr_healHurt(magic_option);
							spellName = ga_magic[magic_option, e_spell_stats.name];
							
							//Check that we're not healing over the player's maximum HP
							if ( (playerHP + healHurt) > playerMAX_HP ) healValue = (playerMAX_HP - playerHP);
							else healValue = healHurt;
						
							//HEAL
							if (magic_option == 0){
								ds_messages[| 0] = "Player casts " + spellName;
								ds_messages[| 1] = "and heals for " + string(healValue) + "HP!";
							
								playerHP += healValue;
							}
							
							//HURT
							if (magic_option == 1){
								ds_messages[| 0] = "Player casts " + ga_magic[magic_option, e_spell_stats.name];
								ds_messages[| 1] = "and " + monsterName + " takes " + string(-healHurt) + " dmg!";
							
								monsterHP += healHurt;
							
								//IF THE MONSTER IS DEAD, UPDATE MESSAGES, SET VICTORY TO TRUE (TO END BATTLE) AND ADD GOLD/XP TO PLAYER
								if (monsterHP <= 0){
									victory = true;
									ds_messages[| 2] = monsterName + " dies..."		
									ds_messages[| 3] = "PLAYER gains " + string(xpGained) + " xp!"
									ds_messages[| 4] = "PLAYER gains " + string(goldGained) + " gold!";
									
									//Add gold/xp to Player
									playerXP += xpGained;
									playerGold += goldGained;
								}
							}
						
							//Remove Mana from Player
							playerMP -= manaCost;
						
						}else{
							//Not enough MP - loses turn	
							ds_messages[| 0] = "Player tries to cast a spell...";
							ds_messages[| 1] = "but you are too distracted by this horrifying reality!";
						}
					
						//CONTINUE THE BATTLE
						showBattleText = true;
						showMagicOptions = false;
						showInventory = false;
					}
				}
				//INVENTORY
				if (showInventory){
					if (keyboard_check_pressed(vk_down)){
						//If not at the last option, go down one
						if (inv_option + 1) <= (array_length_1d(ga_inv) - 1){
							inv_option ++;
						//Else go back to the first option
						}else{
							inv_option = 0;	
						}
						//Play Sound
						audio_play_sound(snd_move_arrow, 1, false);
					}

					if (keyboard_check_pressed(vk_up)){
						//if not at the topmost option, go up 1
						if ((inv_option - 1) >= 0){
							inv_option --;
							//Else go to bottom
						}else{
							inv_option = (array_length_1d(ga_inv) - 1);
						}
						//Play Sound
						audio_play_sound(snd_move_arrow, 1, false);
					}
				
					if (keyboard_check_pressed(vk_space)){
						//if inventory slot is NOT empty
						if (ga_inv[inv_option] != -1){
					
							//Check what type of ITEM it is
							var item = ga_inv[inv_option];
					
							//Type = HEALING
							if (ga_item[item, 4] == 0){
								healHurt = scr_item(item);
								
								//Check that we're not healing over the player's maximum HP
								if ( (playerHP + healHurt) > playerMAX_HP ) healValue = (playerMAX_HP - playerHP);
								else healValue = healHurt;
								
								ds_messages[| 0] = "Player uses " + ga_item[item, 0] + "!";
								ds_messages[| 1] = "and is healed for " + string(healValue) + "HP!";
						
								ga_inv[inv_option] = -1;
								playerHP += healValue;
							}
					
							//CONTINUE THE BATTLE
							showBattleText = true;
							showMagicOptions = false;
							showInventory = false;
						}
					}
				}
			
				//BACK TO MAIN OPTIONS
				if (showInventory) || (showMagicOptions){
					if (keyboard_check_pressed(vk_backspace)){
						showInventory = false;
						showMagicOptions = false;
					}
				}
			}
		
		}else{
			//Player is either Asleep or Stunned...
			if (!ds_exists(ds_messages, ds_type_list)){
				ds_messages = ds_list_create();	
			}
			
			if (isAsleep){
				ds_messages[| 0] = "PLAYER is asleep...";	
			}
			if (stunned > 0){
				ds_messages[| 0] = "PLAYER is stunned...";	
			}
			
			//CONTINUE THE BATTLE
			showBattleText = true;
			showMagicOptions = false;
			showInventory = false;
		}
	
	}

	#endregion

	#region MESSAGES

		//Cycle through messages
		if (showBattleText){
			messageTimer ++;
		
			//Wait a few seconds before accepting player input
			if (messageTimer >= timeBeforeButtonAccepted){
				if (keyboard_check_pressed(vk_space)){
					//Go to next message if there is one
					if (messageCounter + 1) <= (ds_list_size(ds_messages) - 1){
						messageCounter ++;
					//Otherwise next actor takes their turn
					}else{
						//We've shown all the messages
						if (playerDead) || (victory) || (runsAway){
							battle = false;
							showBattleText = false;
							room = rGameWon
							
							if (playerDead) room = rGameOver; //run death animation/code for Player
							
							state = "NO BATTLE";
							
						}else{
							playerTurn = !playerTurn;
							messageCounter = 0;
					
							if (ds_exists(ds_messages, ds_type_list)){
								ds_list_destroy(ds_messages);	
							}
							showBattleText = false;
						}
					}
					messageTimer = 0;
				
					//If this is an attack / hurt spell
					if (battleOption == 0){
						if (!playerTurn){
							if (messageCounter == 1) && (playerShownHP != playerHP){
								playerShownHP = playerHP;
								screenShake = true;
							}
						}
					}
					
					//If healing (MAGIC OR ITEM)
					if (playerShownHP != playerHP) && (playerTurn) && (messageCounter == 1){
						playerShownHP = playerHP;
					}
				
					//Check if player is dead
					if (playerHP <= 0) && (!playerDead){
						playerDead = true;
						room = rGameOver
					}
					
					//Play Victory Sounds
					if (victory){
						if (messageCounter == 2) && (!victorySoundPlayed){
							audio_play_sound(snd_victory, 1, false);	
							victorySoundPlayed = true;
							room = rGameWon
						}
					}
				}
			}
		}
	
	#endregion

	#region SHAKE
	if (screenShake == true){
		shakeTimer ++;
	
		//Set a random x/y coordinate to move to (within the range of negative and positive maxShakeX/Y
		shakeX = irandom_range(-maxShakeX, maxShakeX);
		shakeY = irandom_range(-maxShakeY, maxShakeY);
	
		if (shakeTimer >= timeTillShakeEnds){
			screenShake = false;
			shakeTimer = 0;
			shakeX = 0;
			shakeY = 0;
		}
	}
	#endregion

	#region ENEMY TURN

	if (!playerTurn) && (!showBattleText){
		//We want there to be a little time before the enemy attacks so we use a timer
		enemyTimer ++;
	
		if (enemyTimer >= timeTillEnemyAttacks){
			if (!ds_exists(ds_messages, ds_type_list)){
				ds_messages = ds_list_create();	
			}
			messageCounter = 0;
			showBattleText = true;
			enemyTimer = 0;
			dmg = 0; //reset "dmg" so we have a value of 0
			
			//MONSTER CHOOSES ATTACK BASED ON THE ga_monster ARRAY - it has to KNOW an attack/spell to USE it
			
			//Make a list of possible options for Monster
			ds_list_clear(ds_mon_actions); //-clear list of any entries it may have
			
			//Add all the actions that are TRUE for this monster type
			for (var actions = e_mon_stats.knows_heal; actions <= e_mon_stats.knows_attack; actions ++){
				if (ga_monsters[monsterType, actions] == true){
					ds_list_add(ds_mon_actions, actions);	
				}
			}
			
			//Pick a RANDOM action from the monster list
			roll = irandom_range(0, (ds_list_size(ds_mon_actions) - 1));
			
			monsterOption = ds_mon_actions[| roll];
			
			if (monsterOption == e_mon_stats.knows_attack){
				battleOption = 0;
		
				ds_messages[| 0] = monsterName + " attacks ~!";
				roll = choose("Hits", "Hits", "Misses");
		
				if (roll == "Hits"){
					dmg = irandom_range(monsterMinDmg, monsterMaxDmg);
					dmg = floor(dmg * playerDamageMod);
				
					if dmg < 1 dmg = 1;
				
					ds_messages[| 1] = "And hits for " + string(dmg) + " damage~!";
				}else{
					ds_messages[| 1] = "But misses, thankfully!";	
				}
			}
			
			if (monsterOption == e_mon_stats.knows_sleep){
				battleOption = 1;
				
				ds_messages[| 0] = monsterName + " casts SLEEP~!";
				roll = choose("FAIL", "SUCCEED");
				
				if (roll == "SUCCEED"){
					ds_messages[| 1] = "PLAYER is asleep...";
					isAsleep = true;
				}else{
					ds_messages[| 1] = "the spell fails~!";
				}
			}
			
			if (monsterOption == e_mon_stats.knows_stun){
				battleOption = 2;
				
				ds_messages[| 0] = monsterName + " casts STUN~!";
				roll = choose("FAIL", "FAIL", "SUCCEED");
				
				if (roll == "SUCCEED"){
					ds_messages[| 1] = "PLAYER is stunned...";
					stunned = 3;
				}else{
					ds_messages[| 1] = "PLAYER dodges~!";
				}
			}
			
			if (monsterOption == e_mon_stats.knows_heal){
				battleOption = 3;
				healHurt = scr_healHurt(e_mon_stats.knows_heal);
				
				ds_messages[| 0] = monsterName + " casts HEAL~!";
				
				//Work out how much HP is actually healed (it may be capped by the monster's max)
				if ( (monsterHP + healHurt) > monsterHP_MAX) healValue = (monsterHP_MAX - monsterHP);
				else healValue = healHurt;
				
				monsterHP += healValue;
				
				ds_messages[| 1] = monsterName + " is healed for " + string(healValue) + " HP";
			}
			
			if (monsterOption == e_mon_stats.knows_hurt){
				battleOption = 0;
				dmg = abs(scr_healHurt(e_mon_stats.knows_hurt));
				show_debug_message("dmg = scr_healHurt(e_mon_stats.knows_hurt); = " + string(dmg));
				
				ds_messages[| 0] = monsterName + " casts HURT~!";
				ds_messages[| 1] = "PLAYER is hurt for " + string(dmg) + " HP";
			}
			
			//Check to see if player wakes up
			if (isAsleep){
				isAsleep = choose(true, false);
				
				if (!isAsleep) ds_messages[| 2] = "PLAYER wakes up!";
			}
			
			if (stunned > 0){
				stunned --;
				
				if (stunned <= 0){
					ds_messages[| 2] = "PLAYER is no longer stunned!";
				}
			}
		
			audio_play_sound(snd_option, 1, false);
			
			//REDUCE PLAYER HP, IF NEEDED
			if (playerHP - dmg) < 0 playerHP = 0;
			else playerHP -= dmg; //dmg may equal 0 so it's OK to run this every turn
		}
	}

	#endregion
}