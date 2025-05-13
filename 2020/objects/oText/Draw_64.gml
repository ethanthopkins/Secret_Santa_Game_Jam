/// @desc Draw Textbox
NineSliceBoxStretched(sTextBoxBg,x1,y1,x2,y2,background);

DrawSetText(color, font,h_align,v_align)
var _print = string_copy(message,1,textProgress);

if (responses[0] != -1) && (textProgress >= string_length(message))
{
	for (var i = 0; i < array_length_1d(responses); i++)
	{
		_print += "\n";
		if (i == responseSelected) _print += "> ";
		_print += responses[i]
		if (i == responseSelected) _print += " <";
	}
}

draw_text((x1+x2) /2, y1+adjust8, _print);
draw_set_color(color);
draw_text((x1+x2) /2, y1+adjust7, _print);
