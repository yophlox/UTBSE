package backend;

import flixel.FlxG;
import flixel.util.FlxSave;
import openfl.Lib;

class TobyData
{
	public static var name:String = 'FRISK';
	public static var room:Int = 272;
	public static var hp:Int = 20;
	public static var maxHp:Int = 20;
	public static var attack:Float = 10;
	public static var defense:Float = 10;
	public static var gold:Int = 0;
	public static var speed:Int = 2;
	public static var xp:Int = 0;
	public static var lv:Int = 1;
	public static var kills:Int = 0;
	public static var items:Array<String> = ['Pie', 'SnowPiece', 'I. Noodles', 'SnowPiece'];
	public static var flags:Array<Int> = [for (i in 0...512) 0]; // 512 flags with the value 0.

	public static function save():Void
	{
		var save:FlxSave = new FlxSave();
		save.bind('file', Lib.application.meta.get('file'));
		save.data.name = name;
		save.data.room = room;
		save.data.hp = hp;
		save.data.maxHp = maxHp;
		save.data.attack = attack;
		save.data.defense = defense;
		save.data.gold = gold;
		save.data.xp = xp;
		save.data.lv = lv;
		save.data.kills = kills;
		save.data.items = items;
		save.data.flags = flags;
		save.close();
	}

	public static function load():Void
	{
		var save:FlxSave = new FlxSave();
		save.bind('file', Lib.application.meta.get('file'));

		if (!save.isEmpty())
		{
			if (save.data.name != null)
				name = save.data.name;

			if (save.data.room != null)
				room = save.data.room;

			if (save.data.hp != null)
				hp = save.data.hp;

			if (save.data.maxHp != null)
				maxHp = save.data.maxHp;

			if (save.data.attack != null)
				attack = save.data.attack;

			if (save.data.defense != null)
				defense = save.data.defense;

			if (save.data.gold != null)
				gold = save.data.gold;

			if (save.data.xp != null)
				xp = save.data.xp;

			if (save.data.lv != null)
				lv = save.data.lv;

			if (save.data.kills != null)
				kills = save.data.kills;

			if (save.data.items != null)
				flags = save.data.items;

			if (save.data.flags != null)
				flags = save.data.flags;
		}

		save.destroy();
	}

	public static function levelUp():Bool
	{
		final love:Int = TobyData.lv;

		switch (TobyData.xp)
		{
			case value if (value >= 99999):
				TobyData.lv = 20;
				TobyData.xp = 99999;
			case value if (value >= 50000):
				TobyData.lv = 19;
			case value if (value >= 25000):
				TobyData.lv = 18;
			case value if (value >= 15000):
				TobyData.lv = 17;
			case value if (value >= 10000):
				TobyData.lv = 16;
			case value if (value >= 7000):
				TobyData.lv = 15;
			case value if (value >= 5000):
				TobyData.lv = 14;
			case value if (value >= 3500):
				TobyData.lv = 13;
			case value if (value >= 2500):
				TobyData.lv = 12;
			case value if (value >= 1700):
				TobyData.lv = 11;
			case value if (value >= 1200):
				TobyData.lv = 10;
			case value if (value >= 800):
				TobyData.lv = 9;
			case value if (value >= 500):
				TobyData.lv = 8;
			case value if (value >= 300):
				TobyData.lv = 7;
			case value if (value >= 200):
				TobyData.lv = 6;
			case value if (value >= 120):
				TobyData.lv = 5;
			case value if (value >= 70):
				TobyData.lv = 4;
			case value if (value >= 30):
				TobyData.lv = 3;
			case value if (value >= 10):
				TobyData.lv = 2;
		}

		if (TobyData.xp != love)
		{
			TobyData.maxHp = 16 + TobyData.lv * 4;
			TobyData.attack = 8 + TobyData.lv * 2;
			TobyData.defense = 9 + Math.ceil(TobyData.lv / 4);

			if (TobyData.lv == 20)
			{
				TobyData.maxHp = 99;
				TobyData.attack = 99;
				TobyData.defense = 99;
			}

			return true;
		}

		return false;
	}
}
