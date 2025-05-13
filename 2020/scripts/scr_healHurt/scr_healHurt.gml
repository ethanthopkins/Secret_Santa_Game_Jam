function scr_healHurt(argument0) {
	option = argument0;

	minVal = ga_magic[option, 1];
	maxVal = ga_magic[option, 2];

	totalVal = irandom_range(minVal, maxVal);

	return(totalVal);


}
