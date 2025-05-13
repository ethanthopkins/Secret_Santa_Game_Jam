function scr_item(argument0) {
	item = argument0;

	itemType = ga_item[item, 4];

	if (itemType == 0){
		minVal = ga_item[item, 1];
		maxVal = ga_item[item, 2];
		output = irandom_range(minVal, maxVal);
	
		return(output);
	}


}
