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
import toby.Monster;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.addons.text.FlxTypeText;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

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
	public var monster:Monster;
	public var box:FlxShapeBox;
	public var dialogText:FlxTypeText;
	public var defaultText:String;
	public var targetSpr:FlxSprite;
	public var targetChoiceSpr_0:FlxSprite;
	public var targetChoiceSpr_1:FlxSprite;
	public var targetChoiceTween:FlxTween;
	public var attacked:Bool = false;
	public var isSoul:Bool = false;
	public var soulBlue:Bool = false;
	private var missed:Bool = false;

    override public function create()
    {
        camGame = new FlxCamera();
        camGame.bgColor.alpha = 0;
        FlxG.cameras.add(camGame, false);

		//monster = new Monster(0, 0, "Ty");
		// template monster lol:
        monster = new Monster(100, 100, "Template");
		monster.data.health = 25;
		monster.data.maxHealth = 25;
		monster.data.attack = 5;
		monster.data.defense = 1;
		monster.data.xpReward = 10;
		monster.data.goldReward = 2;

		var monsterSprite:FlxSprite = new FlxSprite(0, 0);
		monsterSprite.loadGraphic("assets/images/monsters/" + monster.data.name + ".png");
		monsterSprite.screenCenter(X);
		monsterSprite.scale.set(0.3, 0.3);
		add(monsterSprite);

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

		box = new FlxShapeBox(32, 470, 570, 135, {thickness: 6, jointStyle: MITER, color: FlxColor.WHITE}, FlxColor.BLACK);
		box.scrollFactor.set();
		box.screenCenter(X);
		box.active = false;
		box.cameras = [camGame];
		add(box);

		//defaultText = '* Ya know, it\'s funny how\n  it all lead to this.'; // oh em gee FlixelTale Ty fight leak?!?!??!
		//defaultText = '* You feel like you\'re going to\n  have a bad time.'; // sans text
		defaultText = '* Template Text';
		dialogText = new FlxTypeText(box.x + 14, box.y + 14, Std.int(box.width), defaultText, 32, true);
		dialogText.font = Paths.font('DTM-Mono');
		dialogText.sounds = [FlxG.sound.load(Paths.soundSwag("txt2"), 0.86)];
		dialogText.scrollFactor.set();
		dialogText.cameras = [camGame];
		add(dialogText);
		dialogText.start(0.04, true);

		heart = new FlxSprite(0, 0, Paths.battleimages('heart'));
		heart.color = FlxColor.RED;
		heart.scrollFactor.set();
		heart.active = false;
		heart.cameras = [camGame];
		add(heart);

		targetSpr = new FlxSprite(dialogText.x, dialogText.y, Paths.battleimages('target'));
		targetSpr.scrollFactor.set();
		targetSpr.active = false;
		targetSpr.cameras = [camGame];
		targetSpr.visible = false;
		add(targetSpr);

		targetChoiceSpr_1 = new FlxSprite(dialogText.x, dialogText.y, Paths.battleimages('targetchoice_1'));
		targetChoiceSpr_1.scrollFactor.set();
		targetChoiceSpr_1.cameras = [camGame];
		targetChoiceSpr_1.visible = false;
		add(targetChoiceSpr_1);

		targetChoiceSpr_0 = new FlxSprite(dialogText.x, dialogText.y, Paths.battleimages('targetchoice_0'));
		targetChoiceSpr_0.scrollFactor.set();
		targetChoiceSpr_0.cameras = [camGame];
		targetChoiceSpr_0.visible = false;
		add(targetChoiceSpr_0);

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
						case 'Talk':
							var isDialogStageOne = true;
							heart.setPosition(box.x + 16, box.y + 26);
						
							if (isDialogStageOne) {
								dialogText.resetText('* Check');
								dialogText.start(0.1, true);
								dialogText.skip();
						
								if (FlxG.keys.justPressed.Z) {
									dialogText.resetText('* ${monster.data.name} ${monster.data.attack} ATK ${monster.data.defense} DEF \n* A template monster for UTBE.\n* Can only deal ${monster.data.attack} damage.');
									dialogText.start(0.1, true);
									isDialogStageOne = false;
								}
							}															
						case 'Fight':
							targetChoiceSpr_0.x = dialogText.x - 2;
							targetChoiceSpr_1.x = dialogText.x - 2;
							choiceChoiced = true;
							dialogText.visible = false;
							targetSpr.visible = true;
							targetChoiceSpr_1.visible = true;
							trace("unun");
							targetChoiceTween = FlxTween.tween(targetChoiceSpr_1, {x: box.x + box.shapeWidth - targetChoiceSpr_1.width - 10, y: dialogText.y - 10}, 2, 
    						{
        						onComplete: function(tween:FlxTween):Void
        						{						
        	    					FlxG.sound.play(Paths.soundSwag('slice'));
									targetChoiceSpr_0.visible = false;
									targetChoiceSpr_1.visible = false;
									targetSpr.visible = false;
           	 						var boxTween:FlxTween = FlxTween.tween(box, {x: 540, shapeWidth: box.shapeHeight}, 0.5, 
									{
										onComplete: function(tween:FlxTween):Void
										{
											changeChoice();
											heart.x = ((box.x - box.offset.x) + box.shapeWidth / 2) - heart.width;
											heart.y = ((box.y - box.offset.y) + box.shapeWidth / 2) - heart.height;
											heart.visible = true;
											isSoul = true;
										}
									}
            						);
            						boxTween.start();
            						missed = true;
        						}
    						}
						);
						targetChoiceTween.start();
					}
				}
				else
				{
					dialogText.visible = true;
					if (actions[selected] == 'Item' && TobyData.items.length <= 0)
						return;

					actionselected = true;

					switch (actions[selected])
					{
						case 'Fight' | 'Talk':
							heart.setPosition(box.x + 16, box.y + 26);
							dialogText.resetText('* ${monster.data.name}');
							dialogText.start(0.1, true);
							dialogText.skip();
						case 'Item':
							heart.setPosition(box.x + 16, box.y + 26);
							dialogText.resetText('* Pie');
							dialogText.start(0.1, true);
							dialogText.skip();
						case 'Spare':
							heart.setPosition(box.x + 16, box.y + 26);
							dialogText.resetText('* Spare');
							dialogText.start(0.1, true);
							dialogText.skip();
					}
				}
			}
			else if (FlxG.keys.justPressed.X && actionselected)
			{
				actionselected = false;
				changeChoice();

				dialogText.visible = true;
				dialogText.resetText(defaultText);
				dialogText.start(0.04, true);
			}
		}
		else
		{
			if (FlxG.keys.justPressed.Z || missed == true)
			{
				if (targetChoiceTween.active)
				{
					targetChoiceTween.cancel();
					FlxG.sound.play(Paths.soundSwag('slice'));
					targetChoiceSpr_0.x = targetChoiceSpr_1.x;
					attacked = true;
					monster.health -= 10;
					new FlxTimer().start(1, (timer:FlxTimer) ->
					{
						attacked = false;
						targetChoiceSpr_0.visible = false;
						targetChoiceSpr_1.visible = false;
						targetSpr.visible = false;
						var boxTween:FlxTween = FlxTween.tween(box, {x: 540, shapeWidth: box.shapeHeight}, 0.5, {
							onComplete: function(tween:FlxTween):Void
							{
								changeChoice();
								heart.x = ((box.x - box.offset.x) + box.shapeWidth / 2) - heart.width;
								heart.y = ((box.x - box.offset.y) + box.shapeWidth / 2) - heart.height;
								heart.visible = true;
								isSoul = true;
							}
						});
						boxTween.start();
					}, 1);
				}
			}
			else if (attacked)
			{
				targetChoiceSpr_0.visible = !targetChoiceSpr_0.visible;
			}
			else if (isSoul)
			{
				if (FlxG.keys.pressed.UP)
					heart.y -= TobyData.speed;
				if (FlxG.keys.pressed.DOWN)
					heart.y += TobyData.speed;
				if (FlxG.keys.pressed.LEFT)
					heart.x -= TobyData.speed;
				if (FlxG.keys.pressed.RIGHT)
					heart.x += TobyData.speed;
				FlxSpriteUtil.bound(heart, box.x, (box.x + box.shapeWidth), box.y, (box.y + box.shapeHeight));
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