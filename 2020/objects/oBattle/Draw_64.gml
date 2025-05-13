if (battle == true) && (state == "READY"){
	fontSize = font_get_size(fFont);
	var BUFFER = 4;
	
	var optionX = 32;
	var optionY = 16;
	
	var magicX = optionX + 100;
	var magicY = optionY;
	
	#region OPTIONAL BLACK OVERLAY FOR WHOLE SCREEN [OFF]
	// [ DRAW A BLACK RECTANGLE TO HIDE THE GAME WORLD + PLAYER ]
	/*
	x1 = 0;
	y1 = 0;
	x2 = x1 + room_width;
	y2 = y1 + room_height;
	
	draw_set_colour(c_black);
	draw_rectangle(x1, y1, x2, y2, false); //Comment this out if you don't want a black screen covering the overworld
	*/
	// ======= END RECTANGLE ======
	#endregion
	
	#region OPTIONAL BLACK BOXES TO MAKE TEXT/STATS EASIER TO READ [ON]
	// [ DRAW BLACK BOXES BEHIND TEXT/STATS
	if (!showMagicOptions && !showInventory) x1 = 0; else x1 = (magicX - optionX);
	y1 = 0;
	if (!showMagicOptions && !showInventory) x2 = x1 + (string_width("ITE") * 2); else x2 = x1 + (string_width("ITEM") * 2);
	y2 = y1 + (string_height("ITE") * 6);
	draw_set_font(fFont );
	
	draw_set_colour(c_black);
	draw_rectangle(x1, y1, x2, y2, false);
	
	draw_set_colour(c_black);
	draw_rectangle(x1, y1, x2, y2, true);
	draw_rectangle(x1 + BUFFER, y1 + BUFFER, x2 - BUFFER, y2 - BUFFER, true);
	
	x1 = 0;
	y1 = room_height - (fontSize * 2);
	x2 = x1 + string_width("999 999");
	y2 = room_height
	
	draw_set_colour(c_black);
	draw_rectangle(x1, y1, x2, y2, false);
	draw_set_colour(c_black);
	draw_rectangle(x1, y1, x2, y2, true);
	draw_rectangle(x1 + BUFFER, y1 + BUFFER, x2 - BUFFER, y2 - BUFFER, true);
	
	#endregion
	
	//DRAW THE OPTIONS + ARROW
	draw_set_font(fFont);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_colour(c_white);

	//If we're not shoing magic or inventory options, display ACTION text [ATT / DEF] ETC
	if (!showMagicOptions) && (!showInventory){
		for (var i = 0; i < array_length_1d(a_text); i ++){
			text = a_text[i];
			if (selected_option == i){
				if (playerTurn) && (!showBattleText){
					draw_sprite(spr_arrow, 0, optionX - sprite_get_width(spr_arrow), optionY + ((fontSize + BUFFER) * i));
				}
			}
			draw_text(optionX + shakeX, optionY + ((fontSize + BUFFER) * i) + shakeY, text);
		}
	}else{
		//Else if we're showing magic options
		if (showMagicOptions){

			for (var j = 0; j < 2; j ++){
				text = ga_magic[j, e_spell_stats.name];
				if (magic_option == j){
					draw_sprite(spr_arrow, 0, magicX - sprite_get_width(spr_arrow), magicY + ((fontSize + BUFFER) * j));	
				}
				draw_text(magicX, magicY + ((fontSize + BUFFER) * j), text);
			}
		}
		//If we're showing the inventory
		if (showInventory){
			var itemX = optionX + 100;
			var itemY = optionY;
		
			for (var j = 0; j < array_length_1d(ga_inv); j ++){
				//If there's an item in this slot, show the NAME of the item
				if (ga_inv[j] != -1){
					item = ga_inv[j];
					text = ga_item[item, 0];
				}else{
					//If there's no item in slot, display "EMPTY"
					text = "EMPTY";
				}
				if (inv_option == j){
					draw_sprite(spr_arrow, 0, itemX - sprite_get_width(spr_arrow), itemY + ((fontSize + BUFFER) * j));	
				}
				draw_text(itemX, itemY + ((fontSize + BUFFER) * j), text);
			}
		}
	}

	//DRAW THE MESSAGES
	draw_set_colour(c_black);
	guiX = surface_get_width(application_surface) / 2;
	guiY = surface_get_height(application_surface); 
	draw_sprite(spr_GUI_textbox, 0, guiX, guiY);

	if (showBattleText){
		textX = guiX - ((sprite_get_width(spr_GUI_textbox) / 2) - (BUFFER * 3));
		textY = guiY - (sprite_get_height(spr_GUI_textbox) - (BUFFER * 3));
		
		sep = (fontSize + BUFFER);
		w = sprite_get_width(spr_GUI_textbox) - (BUFFER * 6);
		
		var totalMessageSize = 0;
	
		for (var a = 0; a <= messageCounter; a ++){
			draw_text_ext(textX + shakeX, textY + totalMessageSize + shakeY, ds_messages[| a], (fontSize + BUFFER), w);
			totalMessageSize += string_height_ext(ds_messages[| a], sep, w);
		}
		
		maxMessageHeight = sprite_get_height(spr_GUI_textbox) - (BUFFER * 6);
		
		//Make sure we can fit the messages inside the textbow
		while (totalMessageSize > maxMessageHeight){
			totalMessageSize -= string_height_ext(ds_messages[| 0], sep, w);
			ds_list_delete(ds_messages, 0);
			messageCounter --;
		}
	}

	//DRAW THE PLAYER'S HP
	draw_set_valign(fa_bottom);
	draw_set_halign(fa_left);
	hpX = BUFFER *2;
	hpY = surface_get_height(application_surface) - BUFFER;

	draw_text(hpX + shakeX, (hpY - (fontSize + 2)) + shakeY, "HP");
	draw_text(hpX + shakeX + (string_width("999 ")), (hpY - (fontSize + 2)) + shakeY, "MP");
	draw_text(hpX + shakeX, hpY + shakeY, string(playerShownHP));
	draw_text(hpX + shakeX + (string_width("999 ")), hpY + shakeY, string(playerMP));

	//DRAW THE MONSTER
	mx = surface_get_width(application_surface) / 2;
	my = surface_get_height(application_surface) / 2;

	draw_set_valign(fa_bottom);
	draw_set_halign(fa_center);
	draw_set_colour(c_black);
	draw_text(mx, my - (sprite_get_height(spr_monster)), monsterName);
	draw_sprite_ext(spr_monster, monsterType, mx, my, 4, 4, 0, c_white, 1);

}






