package;

import CumFart.CumFart;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class MainMenuState extends MusicBeatState
{
	static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options', 'donate'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	public static var debugTools:Bool = false;

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.1" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var bg:FlxSprite;
	var city:FlxSprite;
	var wall:FlxSprite;
	var light0:FlxSprite;
	var light1:FlxSprite;

	function autism2(tween:FlxTween) 
	{
		// haxe funny
		for (i in 0...menuItems.members.length)
		{
			FlxTween.tween(menuItems.members[i], {y: (i * 130) + 100, alpha: 1}, 0.5, {ease: FlxEase.expoInOut});
		}
	}

	override function create()
	{

		// i have autism why didint i just move the camera
		// welp, too late now
		

		// where the states from
		var bgx = 0;
		switch (CumFart.stateFrom) 
		{
			case "freeplay":
				trace("Came from freeplay");
				bgx = -600;
			case "title":
				bgx = -130;
			case "donate":
				trace("Came from donate");
				bgx = -600;
			case "none":
				trace("Came from nothing??? maybe havent defined it yet(search for CumFart.stateFrom");
		}

		bg = new FlxSprite(bgx, -300).loadGraphic(Paths.image('menuAssets/SkyBG'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.8, 0.8);
		add(bg);

		city = new FlxSprite(bgx, -300).loadGraphic(Paths.image('menuAssets/buildings'));
		city.antialiasing = true;
		city.scrollFactor.set(0.9, 0.9);
		add(city);

		light0 = new FlxSprite(-130, -90).loadGraphic(Paths.image('menuAssets/lights0'));
		light0.antialiasing = true;
		light0.scrollFactor.set(0.9, 0.9);
		add(light0);

		light1 = new FlxSprite(-130, -90).loadGraphic(Paths.image('menuAssets/lights1'));
		light1.antialiasing = true;
		light1.scrollFactor.set(0.9, 0.9);
		add(light1);

		wall = new FlxSprite(bgx, -300).loadGraphic(Paths.image('menuAssets/Walls'));
		wall.antialiasing = true;
		add(wall);

		FlxTween.linearMotion(bg, bgx, -90, -1300, -90, 1, true, {ease: FlxEase.expoInOut, onComplete: autism2});
		FlxTween.linearMotion(city, bgx, -90, -1300, -90, 1, true, {ease: FlxEase.expoInOut});
		FlxTween.linearMotion(light0, bgx, -90, -1300, -90, 1, true, {ease: FlxEase.expoInOut});
		FlxTween.linearMotion(light1, bgx, -90, -1300, -90, 1, true, {ease: FlxEase.expoInOut});
		FlxTween.linearMotion(wall, bgx, -90, -1300, -90, 1, true, {ease: FlxEase.expoInOut});

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		if (curBeat % 2 == 1)
		{
			light0.visible = true;
			light1.visible = false;
		}
		if (curBeat % 2 == 0)
		{
			light0.visible = false;
			light1.visible = true;
		}

		persistentUpdate = persistentDraw = true;

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();
	if (CumFart.stateFrom == "title") { 
		var logoBl = new FlxSprite(500, 0);
		logoBl.loadGraphic(Paths.image('senpaicuminmyassandcallmeobama'));
		logoBl.antialiasing = true;
		logoBl.setGraphicSize(700);
		//logoBl.screenCenter(X);
	//	logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
	//	logoBl.animation.play('bump');
		logoBl.updateHitbox();
			add(logoBl);

		FlxTween.linearMotion(logoBl, 500, 0, -670, 0, 1, true, {type: FlxTweenType.ONESHOT, ease: FlxEase.expoInOut});
	}

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('main_menu');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(-50, -240);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.setGraphicSize(400);
			menuItems.add(menuItem);
			menuItem.alpha = 0;
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}


		//FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - NEO v 3.0 " : " FNF - NEO v 3.0 "), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.keys.justPressed.D && FlxG.keys.pressed.CONTROL)
		{
			debugTools = !debugTools;
			trace('debug tools: ' + debugTools);
			FlxG.sound.play(Paths.sound('confirmMenu', 'preload'));
		}

		#if debug
		debugTools = true;
		#end

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.x = 50;
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];
		CumFart.stateFrom = "mainmenu";
		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
			
			case 'donate':
				trace("Credits selected lol");
				FlxG.switchState(new CreditsSubState());
		}
	}

	function changeItem(huh:Int = 0)
	{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
