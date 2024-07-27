package states;

import flixel.text.FlxText;
import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();

		var text = new FlxText(0, 0, 0, "Guys this isn't finished yet :(", 64);
		text.font = Paths.font('DTM-Sans');
		text.color = FlxColor.WHITE;
		text.screenCenter(X);
		add(text);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
