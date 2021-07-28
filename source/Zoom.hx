package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.FlxG;

class Zoom extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		makeGraphic(200, 5, FlxColor.WHITE, false);
	}


	
//	var danceDir:Bool = false;

	public function fly():Void
	{
		//x = 0;
		y = FlxG.random.int(-1000, 1000);
		x = -1000;
		velocity.x = 13000;
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			fly();
		});
	}
}
