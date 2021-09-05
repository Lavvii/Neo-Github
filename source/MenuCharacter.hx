package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class CharacterSetting
{
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var scale(default, null):Float;
	public var flipped(default, null):Bool;

	public function new(x:Int = 0, y:Int = 0, scale:Float = 1.0, flipped:Bool = false)
	{
		this.x = x;
		this.y = y;
		this.scale = scale;
		this.flipped = flipped;
	}
}

class MenuCharacter extends FlxSprite
{
	private static var settings:Map<String, CharacterSetting> = [
		'dad' => new CharacterSetting(-15, 130, 1),
		'spooky' => new CharacterSetting(-60, 70, 1),
		'pico' => new CharacterSetting(20, -20, 1.0, true),
		'mom' => new CharacterSetting(-40, 40, 1),
		'parents-christmas' => new CharacterSetting(70, 130, 1),
		'senpai' => new CharacterSetting(-40, -60, 1)
	];

	private var flipped:Bool = false;

	public function new(x:Int, y:Int, scale:Float, flipped:Bool)
	{
		super(x, y);
		this.flipped = flipped;

		antialiasing = true;

		frames = Paths.getSparrowAtlas('menuAssets/storyShit');

		animation.addByPrefix('dad', "Week 1", 24);
		animation.addByPrefix('spooky', "Week 2", 24);
		animation.addByPrefix('pico', "Week 3", 24);
		animation.addByPrefix('mom', "week 4", 24);
		animation.addByPrefix('parents-christmas', "week 5", 24);
		animation.addByPrefix('senpai', "SENPAI idle Black Lines", 24);

		//setGraphicSize(Std.int(width * scale));
		//updateHitbox();
	}

	public function setCharacter(character:String):Void
	{
		if (character == '')
		{
			visible = false;
			return;
		}
		else
		{
			visible = true;
		}

		animation.play(character);

		var setting:CharacterSetting = settings[character];
		//offset.set(setting.x, setting.y);
		//setGraphicSize(Std.int(width * setting.scale));
		flipX = setting.flipped != flipped;
	}
}
