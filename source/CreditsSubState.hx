package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

#if windows
import Discord.DiscordClient;
#end

class CreditsSubState extends MusicBeatState
{
	var curSelected:Int = 0;
	
	var bg:FlxSprite;
	var unselected:FlxSprite;
	var selection:FlxSprite;
	var credits:FlxSprite;
	var shit:FlxSprite;
	
	var menuItems:FlxTypedGroup<FlxSprite>;
	
	var personShit:Array<String> = ['0', '1', '2', '3', '4', '5'];

	override function create()
	{
		bg = new FlxSprite(-1300, -90);
		add(bg);
		bg.loadGraphic(Paths.image('mainMenuCity'));
		FlxTween.linearMotion(bg, -1300, -90, -600, -90, 1, true, {type: FlxTween.ONESHOT, ease: FlxEase.expoInOut});

		unselected = new FlxSprite(-600, -90);
		add(unselected);
		unselected.loadGraphic(Paths.image('creditsAssets/Unselected'));

		shit = new FlxSprite(-600, -90);
		add(shit);
		shit.loadGraphic(Paths.image('creditsAssets/ShiftnExit'));

		credits = new FlxSprite(-600, -90);
		add(credits);
		credits.loadGraphic(Paths.image('creditsAssets/CREDITS'));

		for (i in 0...personShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(10 + (i * 40), 90 + (i * 140));
			menuItem.ID = i;
			menuItem.scrollFactor.set();
			menuItem.alpha = 0;
			menuItems.add(menuItem);
			menuItem.x -= 200;
			menuItem.alpha = 0;
			FlxTween.tween(menuItem,{x : menuItem.x + 200,alpha:1},0.6,{ease:FlxEase.smoothStepOut,startDelay: 0.3*i});
		}

		selection = new FlxSprite(-600, -90);
		selection.frames = Paths.getSparrowAtlas('creditsAssets/Select');
		selection.animation.addByPrefix('0','JellyFish',1,true);
		selection.animation.addByPrefix('1','GenoX',1,true);
		selection.animation.addByPrefix('2','Smokey',1,true);
		selection.animation.addByPrefix('3','NoLime',1,true);
		selection.animation.addByPrefix('4','Pincer',1,true);
		selection.animation.addByPrefix('5','Moisty',1,true);
		selection.antialiasing = true;
		add(selection);
		selection.animation.play('0');

		super.create();
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.ACCEPT)
		{
			switch(curSelected)
			{
				case 0:
					FlxG.openURL("https://www.youtube.com/c/JellyFishEdm");
				case 1:
					FlxG.openURL("https://www.youtube.com/c/GenoXLOID");
				case 2:
					FlxG.openURL("https://twitter.com/Smokey_5_");
				case 3:
					FlxG.openURL("https://twitter.com/C0nfuzzl3dis/");
				case 4:
					FlxG.openURL("https://youtube.com/channel/UCVgVvwOzvsR8pRwVy316SyA");
				case 5:
					FlxG.openURL("hhttps://www.youtube.com/channel/UC7M0aIL8-eVSJker9p0OyUQ");
			}
			var funnystring = Std.string(curSelected);
			FlxG.openURL(funnystring);
		}
		if (controls.UP_P)
		{
			changeSelection(-1);
		}
		if (controls.DOWN_P)
		{
			changeSelection(1);
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		selection.animation.play(personShit[curSelected]);
	}
}
		