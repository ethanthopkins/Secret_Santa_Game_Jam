//Setup text array to display ACTIONS
a_text[0] = "ATT";
a_text[1] = "DEF";
a_text[2] = "MGK";
a_text[3] = "ITE";
a_text[4] = "RUN";

playerMAX_HP = 20;
playerHP = 20;
playerMP = 10;
playerShownHP = playerHP;
playerGold = 0;
playerXP = 0;

isAsleep = false; //Asleep or not
stunned = 0; //How many turns are we stunned for

monsterHP = 3; //Value is updated for different monsters in [STEP EVENT] [state "INIT"]
ds_mon_actions = ds_list_create();

selected_option = 0; //Which option is the arrow over?
playerTurn = true;
ds_messages = ds_list_create();
messageCounter = 0; //Tracks which message we're on
showBattleText = false; //Display battle text or not (player must press through it before next actor can take their turn

messageTimer = 0;
timeBeforeButtonAccepted = 15;

enemyTimer = 0;
timeTillEnemyAttacks = 15;
battleOption = 0; //Which option has been selected by either monster or player

playerDead = false;
battle = false;
victory = false;

battleSpawnTimer = 0;
timeTillBattleSpawns = 10;
state = "INIT";

//Screen Shake
screenShake = false;
maxShakeX = 5;
maxShakeY = 5;
shakeX = 0;
shakeY = 0;
shakeTimer = 0;
timeTillShakeEnds = 30;