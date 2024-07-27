package states;

import flixel.text.FlxText;
import flixel.FlxState;
import flixel.util.FlxColor;

class MainMenuState extends FlxState
{
	override public function create()
	{
		super.create();

		var text = new FlxText(0, 0, 0, "Guys this isn't finished yet :(", 64);
		text.font = Paths.font('JF-Dot-ShinonomeMin14');
		text.color = FlxColor.GRAY;
		text.alpha = 1;
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
