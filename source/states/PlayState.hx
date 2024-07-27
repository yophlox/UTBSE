package states;

import flixel.text.FlxText;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxCamera;
import flixel.ui.FlxBar;
import flixel.FlxG;
import backend.TobyData;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
    final actions:Array<String> = ['Fight', 'Talk', 'Item', 'Spare'];
    public var items:FlxTypedGroup<FlxSprite>;
    public var camGame:FlxCamera;
    public var hpName:FlxSprite;
    public var hpBar:FlxBar;
    public var hpInfo:FlxText;
    public var stats:FlxText;
	public var actionselected:Bool = false;
	public var selected:Int = 0;
	public var heart:FlxSprite;
	public var choiceChoiced:Bool = false;

    override public function create()
    {
        camGame = new FlxCamera();
        camGame.bgColor.alpha = 0;
        FlxG.cameras.add(camGame, false);

        var bottomY = FlxG.height - 100;

        stats = new FlxText(390, bottomY, 0, TobyData.name + '   LV ' + TobyData.lv, 22);
        stats.setFormat(Paths.font('Small'), 22, FlxColor.WHITE, 'center', FlxColor.TRANSPARENT);
        stats.setPosition(390, bottomY);
        stats.scrollFactor.set();
        stats.cameras = [camGame];
        add(stats);

        hpName = new FlxSprite(stats.x + stats.width + 10, stats.y + 5, Paths.battleimages('hpname'));
        hpName.scrollFactor.set();
        hpName.active = false;
        hpName.cameras = [camGame];
        add(hpName);

        hpBar = new FlxBar(hpName.x + hpName.width + 5, hpName.y - 5, LEFT_TO_RIGHT, Std.int(TobyData.maxHp * 1.2), 20, TobyData, 'hp', 0, TobyData.maxHp);
        hpBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW);
        hpBar.scrollFactor.set();
        hpBar.cameras = [camGame];
        add(hpBar);

        items = new FlxTypedGroup<FlxSprite>();

        var centerX = FlxG.width / 2;
        for (i in 0...actions.length)
        {
            var bt:FlxSprite = new FlxSprite(0, hpBar.y + 32, Paths.battleimages(actions[i].toLowerCase() + 'bt_1'));

            switch (actions[i])
            {
                case 'Fight':
                    bt.x = centerX - 250;
                case 'Talk':
                    bt.x = centerX - 125;
                case 'Item':
                    bt.x = centerX;
                case 'Spare':
                    bt.x = centerX + 125;
            }

            bt.scrollFactor.set();
            bt.cameras = [camGame];
            bt.ID = i;
            items.add(bt);
        }

        add(items);

		heart = new FlxSprite(0, 0, Paths.battleimages('heart'));
		heart.color = FlxColor.RED;
		heart.scrollFactor.set();
		heart.active = false;
		heart.cameras = [camGame];
		add(heart);

		changeChoice();
		actionselected = false;
        super.create();
    }

    override public function update(elapsed:Float)
    {
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new states.TitleState());
		else if (FlxG.keys.justPressed.LEFT && !actionselected)
			changeChoice(-1);
		else if (FlxG.keys.justPressed.RIGHT && !actionselected)
			changeChoice(1);    
		if (!choiceChoiced)
		{
			if (FlxG.keys.justPressed.Z)
			{
				FlxG.sound.play(Paths.soundSwag('menuconfirm'));

				if (actionselected)
				{
					heart.visible = false;
					switch (actions[selected])
					{
						case 'Fight':
							choiceChoiced = true;
					}
				}
				else
				{
					if (actions[selected] == 'Item' && TobyData.items.length <= 0)
						return;

					actionselected = true;

					switch (actions[selected])
					{
						case 'Fight' | 'Talk':
						case 'Item':
						case 'Spare':
					}
				}
			}
			else if (FlxG.keys.justPressed.X && actionselected)
			{
				actionselected = false;
				changeChoice();
			}
		}
	}

	private function changeChoice(num:Int = 0):Void
	{
		if (num != 0)
			FlxG.sound.play(Paths.soundSwag('menumove'));

		selected = FlxMath.wrap(selected + num, 0, actions.length - 1);

		items.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == selected)
			{
				spr.loadGraphic(Paths.battleimages(actions[spr.ID].toLowerCase() + 'bt_0'));

				heart.setPosition(spr.x + 8, spr.y + 14);
			}
			else
				spr.loadGraphic(Paths.battleimages(actions[spr.ID].toLowerCase() + 'bt_1'));
		});
	}
}