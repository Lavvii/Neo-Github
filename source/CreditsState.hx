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

using StringTools;

class CreditsState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var bg:FlxSprite;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

/*	function autism(tween:FlxTween) { // magnus wtf is this fr
		var i = 0;
		grpCreds.forEach(function(credit:Alphabet) {
		i++;
		FlxTween.linearMotion(credit, credit.x, credit.y, credit.x, (70 * i) + 200, 0.5, true, {type: FlxTween.ONESHOT, ease: FlxEase.expoInOut});
		credit.startTypedText();
	}
	);
	}*/

	override function create()
	{
		var initCreditslist = CoolUtil.coolTextFile(Paths.txt('credits'));

		for (i in 0...initCreditslist.length)
		{
			var data:Array<String> = initCreditslist[i].split(':');
		}

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		bg = new FlxSprite(-1300, -90);
		add(bg);
		bg.loadGraphic(Paths.image('mainMenuCity'));
		FlxTween.linearMotion(bg, -1300, -90, -600, -90, 1, true, {type: FlxTween.ONESHOT, ease: FlxEase.expoInOut});

		grpSongs = new FlxTypedGroup<Alphabet>();

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 200, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
		//	grpSongs.add(songText);
		}


		// listen its like 12 am and im tired i just had mylast day of school be nice
		new FlxTimer().start(0.9, function(tmr:FlxTimer) {
			add(grpSongs);
			for (i in 0...iconArray.length) {
				add(iconArray[i]);
			}
		});

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");
		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));
 TextField();
			texFel.width = FlxG.width;
			var texFel:TextField = new
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST: " + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			CumFart.stateFrom = "donate";
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			switch(curSelected) {
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
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0;
		}

		iconArray[curSelected].alpha = 1;
		//iconArray[curSelected + 1].alpha = 0.6;
		//iconArray[curSelected - 1].alpha = 0.6;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			// TRY TO COPE WITH MY RETARDNESS
			if (item.targetY + (change * 2) == 0) { // ok this is kinda smart ngl
				item.alpha = 0;
			}
			// I LEGIT AM SO FUCKING RETARDED I CANT EVEN FIGURE OUT THIS STUPID FUCKING ALPHABET SHIT WHY MUCH I USE A TIMER FOR EVERYTHING THIS IS NOT GOOD PRACTICE
			new FlxTimer().start(0.05, function(tmr:FlxTimer)
		{
			item.alpha = 0;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}

			if (item.targetY - 1 == 0 || item.targetY + 1 == 0) {
				item.alpha = 0.6;
			}
		});
		}
	}
}
