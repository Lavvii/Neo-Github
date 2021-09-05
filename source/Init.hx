package;

import flixel.addons.ui.FlxUIState;
import sys.thread.Thread;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;

import lime.app.Application;

import Discord.DiscordClient;

import flixel.FlxSprite;

using StringTools;

/**
 * @author BrightFyre
 */
class Init extends FlxUIState
{
    public static var loadTxt:FlxText;
    var loadingImage:FlxSprite;

	override function create()
	{   
		loadingImage = new FlxSprite(0,0).loadGraphic(Paths.image('backwall','shared'));
		loadingImage.updateHitbox();
        loadingImage.screenCenter();
        loadingImage.antialiasing = true;
        add(loadingImage);
        
        loadTxt = new FlxText(0, 0, 0, "initialized game", 30);
		loadTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		loadTxt.screenCenter(X);
		loadTxt.alignment = RIGHT;
		loadTxt.y = 600;
		loadTxt.x = 0;
		add(loadTxt);

        trace('starting caching..');
        
        Thread.create(() -> 
        {
            cache();
        });


        super.create();
    }

    var calledDone = false;

    function initSettings()
    {
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");

        FlxG.save.bind('save', 'neo');
        
        DiscordClient.initialize();

		Application.current.onExit.add(function(exitCode) 
		{
			DiscordClient.shutdown();
		});
		
		PlayerSettings.init();

		KadeEngineData.initSave();
		
        Highscore.load();

        //FlxG.sound.muteKeys = null;
		//FlxG.sound.volumeUpKeys = null;
        //FlxG.sound.volumeDownKeys = null;
        FlxG.sound.volume = 1;
        FlxG.sound.muted = false;
		FlxG.fixedTimestep = false;
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = false;
		FlxG.console.autoPause = false;
        FlxG.autoPause = false;
        FlxGraphic.defaultPersist = true;

        FlxG.worldBounds.set(0,0);
    }

    function cache()
    {
        initSettings();

        loadTxt.text = "Loading Songs";

        var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		FreeplayState.addWeek(['Tutorial'], 1, ['gf']);

        if (StoryMenuState.weekUnlocked[2] || isDebug)
			FreeplayState.addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);

		if (StoryMenuState.weekUnlocked[2] || isDebug)
			FreeplayState.addWeek(['Spookeez', 'South', 'Illusion'], 2, ['spooky', 'spooky', 'monster']);

		if (StoryMenuState.weekUnlocked[3] || isDebug)
			FreeplayState.addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);

		if (StoryMenuState.weekUnlocked[4] || isDebug)
			FreeplayState.addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);

		if (StoryMenuState.weekUnlocked[5] || isDebug)
			FreeplayState.addWeek(['Cocoa', 'Eggnog', 'Hallucination'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas']);


        loadTxt.text = "Loading Sounds";

        FlxG.sound.cache(Paths.sound('missnote1', 'shared'));
        FlxG.sound.cache(Paths.sound('missnote2', 'shared'));
        FlxG.sound.cache(Paths.sound('missnote3', 'shared'));

        loadTxt.text = "Loaded Everything";
        trace("Finished caching...");

        end();
    }

    function end()
    {
        FlxG.switchState(new TitleState());
    }
}