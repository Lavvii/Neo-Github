package;

import Song.SwagSong;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	public static var songs:Array<SongMetadata> = [];
	public static var bpms:Array<Float> = [];
	public static var charts:Array<SwagSong> = [];

	var selector:FlxText;
	static var curSelected:Int = 0;
	static var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var bg:FlxSprite;
	var bgtop:FlxSprite;
	var bgnottop:FlxSprite; // i have a headache i just went to kennywood 

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];
	var camZoom:FlxTween;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		//moved adding songs to init cuz i can cache them from there yuhhhh
		//brightfyre

		camZoom = FlxTween.tween(this, {}, 0);
		
		// LOAD CHARACTERS

		bg = new FlxSprite(-1300, -90);
		add(bg);
		bg.loadGraphic(Paths.image('mainMenuCity'));
		FlxTween.linearMotion(bg, -1300, -90, -600, -90, 1, true, {type: FlxTweenType.ONESHOT, ease: FlxEase.expoInOut});

		grpSongs = new FlxTypedGroup<Alphabet>();

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 200, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		add(bgtop);
		add(bgnottop);


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

		trace(bpms);


		super.create();
	}

	public static function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		FlxG.sound.cache(Paths.inst(songName));
		trace("cached " + songName);
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
		bpms.push(Song.loadFromJson(songName, StringTools.replace(songName," ", "-").toLowerCase()).bpm);

		for (i in 0...2)
		{
			//var poop:String = Highscore.formatSong(StringTools.replace(songName," ", "-").toLowerCase(), i);

			//charts.push(Song.loadFromJson(poop, StringTools.replace(songName," ", "-").toLowerCase()));
		}

	}

	public static function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
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

	override function beatHit()
	{
		super.beatHit();
		if (!accepted)
		{
			bopOnBeat();
		}
	}

	function bopOnBeat()
	{
		if (!accepted)
		{
			FlxG.camera.zoom += 0.015;
			camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.1);
		}
	}

	var accepted:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

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
			CumFart.stateFrom = "freeplay";
			FlxG.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			accepted = true;
			trace(StringTools.replace(songs[curSelected].songName," ", "-").toLowerCase());

			var poop:String = Highscore.formatSong(StringTools.replace(songs[curSelected].songName," ", "-").toLowerCase(), curDifficulty);

			trace(poop);

			for (i in 0...grpSongs.members.length)
			{
				if (i == curSelected)
				{
					FlxFlicker.flicker(grpSongs.members[i], 0.75, 0.06, false, false);
					FlxFlicker.flicker(iconArray[i], 0.75, 0.06, false, false);
				}
				else
				{
					FlxTween.tween(grpSongs.members[i], {alpha: 0.0}, 0.4, {ease: FlxEase.quadIn});
					FlxTween.tween(iconArray[i], {alpha: 0.0}, 0.4, {ease: FlxEase.quadIn});
				}
			}

			PlayState.SONG = Song.loadFromJson(poop, StringTools.replace(songs[curSelected].songName," ", "-").toLowerCase());
			//PlayState.SONG = charts[curSelected];
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);

			FlxG.sound.play(Paths.sound('confirmMenu'));

			FlxG.camera.fade(FlxColor.BLACK, 0.75, false);

			FlxG.sound.music.fadeOut(0.75, 0);

			new FlxTimer().start(0.75, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState());
			});
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

		Conductor.changeBPM(bpms[curSelected]);

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
			if (item.targetY + (change * 2) == 0) 
			{ 
				// ok this is kinda smart ngl
				item.alpha = 0;
			}

			// I LEGIT AM SO FUCKING RETARDED I CANT EVEN FIGURE OUT THIS STUPID FUCKING ALPHABET SHIT WHY MUCH I USE A TIMER FOR EVERYTHING THIS IS NOT GOOD PRACTICE
			new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				if (item.targetY == 0)
				{
					item.alpha = 1;
					// item.setGraphicSize(Std.int(item.width));
				}
				else if (item.targetY - 1 == 0 || item.targetY + 1 == 0) 
				{
					item.alpha = 0.6;
				}
				else 
				{
					item.alpha = 0;
				}
			});
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
