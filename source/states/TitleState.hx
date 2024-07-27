package states;

import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class TitleState extends FlxState
{
	var titleText:FlxText;

	override function create():Void
	{
		var titleImage:FlxSprite = new FlxSprite(0, 0, Paths.image('title/titleimage'));
		titleImage.scale.set(2, 2);
		titleImage.updateHitbox();
		titleImage.screenCenter();
		titleImage.scrollFactor.set();
		add(titleImage);

		titleText = new FlxText(0, 555, 0, '[PRESS Z OR ENTER]', 16);
		titleText.font = Paths.font('Small');
		titleText.color = FlxColor.GRAY;
		titleText.alpha = 0.0001;
		titleText.screenCenter(X);
		titleText.scrollFactor.set();
		add(titleText);

		var versionText = new FlxText(5, FlxG.height - 18, 0, 'UTBE Alpha 1', 16);// + Application.current.meta.get('version'), 16);
		versionText.font = Paths.font('Small');
		versionText.color = FlxColor.GRAY;
		versionText.scrollFactor.set();
		versionText.active = false;
		add(versionText);

		FlxG.sound.play(Paths.sound('intronoise'), () -> titleText.alpha = 1);

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.Z && titleText.alpha == 1)
			FlxG.switchState(new MainMenuState());
		else if (FlxG.keys.justPressed.F)
			FlxG.fullscreen = !FlxG.fullscreen;
		super.update(elapsed);
	}
}