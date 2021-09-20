package;

import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var curWeek:Int = 0;
	var curDifficulty:Int = 1;

	var weekData:Array<Dynamic> = [
		['Tutorial'],
		['Bass', "Rappin", "Faster"]
	];

	public static var weekUnlocked:Array<Bool> = [true, true];

	var weekCharacters:Array<Dynamic> = [
		['', 'bf', 'gf'],
		['ryan', 'bf', 'gf']
	];

	var weekNames:Array<String> = [
		"",
		"Gunz"
	];

	var weekText:FlxSprite;
	var weekDifficulty:FlxSprite;
	var ui_tex:FlxFramesCollection;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var weekCharacterTutorial:FlxSprite;
	var weekCharacterVsRyan:FlxSprite;
	var weekCharacterTutorialBack:FlxSprite;
	var weekCharacterVsRyanBack:FlxSprite;

	var weekCharTutorialTween:FlxTween;
	var weekCharVsRyanTween:FlxTween;
	var weekCharTutorialTweenBack:FlxTween;
	var weekCharVsRyanTweenBack:FlxTween;
	
	var weekTutorialBg:FlxSprite;
	var weekVsRyanBg:FlxSprite;

	var moveCamera:Bool = true;

	var isCutscene:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		curWeek = 0;
		curDifficulty = 1;

		persistentUpdate = persistentDraw = true;

		//CREATE OBJECTS
		trace("CREATING OBJECTS");

		ui_tex = Paths.getSparrowAtlas("campaign_menu_UI_assets", "preload");

		//Week background
		weekTutorialBg = new FlxSprite(0, 0);
		weekTutorialBg.loadGraphic(Paths.image("storymenu/tutorialBackground", "preload"));
		weekTutorialBg.scale.set(0.7, 0.7);
		weekTutorialBg.updateHitbox();
		weekTutorialBg.setPosition(0, 0);
		weekTutorialBg.antialiasing = true;

		weekVsRyanBg = new FlxSprite(0, 0);
		weekVsRyanBg.loadGraphic(Paths.image("storymenu/ryanBackground", "preload"));
		weekVsRyanBg.scale.set(0.7, 0.7);
		weekVsRyanBg.updateHitbox();
		weekVsRyanBg.setPosition(0, 0);
		weekVsRyanBg.antialiasing = true;
		weekVsRyanBg.alpha = 0;

		//Background overlay
		var weekBackgroundOverlay = new FlxSprite(0, 0);
		weekBackgroundOverlay.loadGraphic(Paths.image("storymenu/weekBackgroundOverlay", "preload"));
		weekBackgroundOverlay.scale.set(0.7, 0.7);
		weekBackgroundOverlay.updateHitbox();
		weekBackgroundOverlay.setPosition(0, 0);
		weekBackgroundOverlay.antialiasing = true;

		//Week character TUTORIAL
		weekCharacterTutorial = new FlxSprite(0, 0);
		weekCharacterTutorial.loadGraphic(Paths.image("storymenu/tutorial", "preload"));
		weekCharacterTutorial.scale.set(0.7, 0.7);
		weekCharacterTutorial.updateHitbox();
		weekCharacterTutorial.setPosition(-160, -70);
		weekCharacterTutorial.antialiasing = true;

		//Week character VS RYAN
		weekCharacterVsRyan = new FlxSprite(0, 0);
		weekCharacterVsRyan.loadGraphic(Paths.image("storymenu/ryan", "preload"));
		weekCharacterVsRyan.scale.set(0.7, 0.7);
		weekCharacterVsRyan.updateHitbox();
		weekCharacterVsRyan.setPosition(-160, -2000);
		weekCharacterVsRyan.antialiasing = true;

		//Week character TUTORIAL
		weekCharacterTutorialBack = new FlxSprite(0, 0);
		weekCharacterTutorialBack.loadGraphic(Paths.image("storymenu/tutorial", "preload"));
		weekCharacterTutorialBack.scale.set(0.7, 0.7);
		weekCharacterTutorialBack.updateHitbox();
		weekCharacterTutorialBack.setPosition(-160, -70);
		weekCharacterTutorialBack.antialiasing = true;

		//Week character VS RYAN
		weekCharacterVsRyanBack = new FlxSprite(0, 0);
		weekCharacterVsRyanBack.loadGraphic(Paths.image("storymenu/ryan", "preload"));
		weekCharacterVsRyanBack.scale.set(0.7, 0.7);
		weekCharacterVsRyanBack.updateHitbox();
		weekCharacterVsRyanBack.setPosition(-160, -2000);
		weekCharacterVsRyanBack.antialiasing = true;

		//Week overlay
		var weekOverlay = new FlxSprite(0, 0);
		weekOverlay.loadGraphic(Paths.image("storymenu/weekOverlay", "preload"));
		weekOverlay.scale.set(0.7, 0.7);
		weekOverlay.updateHitbox();
		weekOverlay.setPosition(0, 0);
		weekOverlay.antialiasing = true;

		//DYNAMIC

		//Week text
		weekText = new FlxSprite(0, 0);
		weekText.loadGraphic(Paths.image("storymenu/week0", "preload"));
		weekText.scale.set(0.8, 0.8);
		weekText.updateHitbox();
		weekText.setPosition(FlxG.width - 430, FlxG.height - weekText.scale.y - 90);
		weekText.antialiasing = true;

		//TODO: Position the difficulty arrows correctly
		//Week difficulty
		//DIFF TEXT
		weekDifficulty = new FlxSprite(0, 0);
		weekDifficulty.frame = ui_tex.getByName("HARD0000");
		weekDifficulty.scale.set(1, 1);
		weekDifficulty.updateHitbox();
		weekDifficulty.setPosition(weekText.x + 120, weekText.y - weekDifficulty.scale.y - 80);
		weekDifficulty.antialiasing = true;

		//LEFT ARROW
		leftArrow = new FlxSprite(0, 0);
		leftArrow.frame = ui_tex.getByName("arrow left0000");
		leftArrow.scale.set(1, 1);
		leftArrow.updateHitbox();
		leftArrow.setPosition(weekText.x + leftArrow.scale.x - 5, weekDifficulty.y - 7);
		leftArrow.antialiasing = true;
		
		//RIGHT ARROW
		rightArrow = new FlxSprite(0, 0);
		rightArrow.frame = ui_tex.getByName("arrow right0000");
		rightArrow.scale.set(1, 1);
		rightArrow.updateHitbox();
		rightArrow.setPosition(FlxG.width - 65, weekDifficulty.y - 7);
		rightArrow.antialiasing = true;

		//DRAW OBJECTS
		trace("DRAWING OBJECTS");
		add(weekTutorialBg);
		add(weekVsRyanBg);
		add(weekBackgroundOverlay);
		add(weekCharacterTutorialBack);
		add(weekCharacterTutorial);
		add(weekCharacterVsRyanBack);
		add(weekCharacterVsRyan);
		add(weekOverlay);
		add(weekText);
		add(weekDifficulty);
		add(leftArrow);
		add(rightArrow);

		if (Conductor.bpm == 0) Conductor.changeBPM(160);
		
		updateDiff();
		updateWeek();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (!stopspamming)
		{
			if (FlxG.keys.justPressed.UP)
			{
				changeWeek(1);
			}
			else if (FlxG.keys.justPressed.DOWN)
			{
				changeWeek(-1);
			}
			else if (FlxG.keys.justPressed.LEFT)
			{
				changeDiff(-1);
			}
			else if (FlxG.keys.justPressed.RIGHT)
			{
				changeDiff(1);
			}
			else if (FlxG.keys.justPressed.ENTER)
			{
				selectWeek();
			}
			else if (FlxG.keys.justPressed.BACKSPACE && !movedBack && !selectedWeek)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				movedBack = true;
				FlxG.switchState(new MainMenuState());
			}
			#if DEBUG_MOD
			else if (FlxG.keys.justPressed.F)
			{
				if (!FlxG.save.data.spanishMode) FlxG.switchState(new VideoState('assets/videos/level3_end.webm', new StoryMenuState(), 0, true));
				else FlxG.switchState(new VideoState('assets/videos/level3_end_spanish.webm', new StoryMenuState(), 0, true));
			}
			else if (FlxG.keys.justPressed.Z)
			{
				FlxG.save.data.memeSongUnlocked = !FlxG.save.data.memeSongUnlocked;
			}
			#end
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	var prevWeek:Int = 0;
	var prevDiff:Int = 0;

	function changeWeek(amount:Int)
	{
		if (curWeek + amount <= 1 && curWeek + amount >= 0)
		{
			curWeek += amount;
			if (prevWeek != curWeek) 
				FlxG.sound.play(Paths.sound("scrollMenu"));
		}
		trace(curWeek);
		updateWeek();
		prevWeek = curWeek;
	}

	function updateWeek()
	{
		weekText.loadGraphic(Paths.image("storymenu/week" + curWeek));
		weekText.centerOffsets(true);
		switch (curWeek)
		{
			case 0:
				if (prevWeek != curWeek)
				{
					if (weekCharVsRyanTween != null) weekCharVsRyanTween.cancel();
					if (weekCharVsRyanTweenBack != null) weekCharVsRyanTweenBack.cancel();
					weekCharVsRyanTween = FlxTween.tween(weekCharacterVsRyan, {x: 0, y: -2000}, 1, {ease: FlxEase.expoInOut});
					weekCharTutorialTween = FlxTween.tween(weekCharacterTutorial, {x: -160, y: -70}, 1, {ease: FlxEase.expoInOut});
					weekCharVsRyanTweenBack = FlxTween.tween(weekCharacterVsRyanBack, {x: 0, y: -2000}, 1, {ease: FlxEase.expoInOut});
					weekCharTutorialTweenBack = FlxTween.tween(weekCharacterTutorialBack, {x: -160, y: -70}, 1, {ease: FlxEase.expoInOut});
					FlxTween.tween(weekVsRyanBg, {alpha: 0}, 0.5, {ease: FlxEase.expoIn});
					FlxTween.tween(weekTutorialBg, {alpha: 1}, 0.5, {ease: FlxEase.expoIn});
				}
				weekText.offset.x = 40;
			case 1:
				if (prevWeek != curWeek)
				{
					if (weekCharTutorialTween != null) weekCharTutorialTween.cancel();
					if (weekCharTutorialTweenBack != null) weekCharTutorialTweenBack.cancel();
					weekCharVsRyanTween = FlxTween.tween(weekCharacterVsRyan, {x: 0, y: -20}, 1, {ease: FlxEase.expoInOut});
					weekCharTutorialTween = FlxTween.tween(weekCharacterTutorial, {x: 0, y: 2000}, 1, {ease: FlxEase.expoInOut});
					weekCharVsRyanTweenBack = FlxTween.tween(weekCharacterVsRyanBack, {x: 0, y: -20}, 1, {ease: FlxEase.expoInOut});
					weekCharTutorialTweenBack = FlxTween.tween(weekCharacterTutorialBack, {x: 0, y: 2000}, 1, {ease: FlxEase.expoInOut});
					FlxTween.tween(weekVsRyanBg, {alpha: 1}, 0.5, {ease: FlxEase.expoIn});
					FlxTween.tween(weekTutorialBg, {alpha: 0}, 0.5, {ease: FlxEase.expoIn});
				}
				weekText.offset.x = 20;
		}
	}

	function changeDiff(amount:Int)
	{
		if (curDifficulty + amount <= 3 && curDifficulty + amount >= 0)
		{
			curDifficulty += amount;
			if (prevDiff != curDifficulty) 
				FlxG.sound.play(Paths.sound("scrollMenu"));
			prevDiff = curDifficulty;
		}
		trace(curDifficulty);
		updateDiff();
	}

	function updateDiff()
	{
		switch (curDifficulty)
		{
			case 0:
				weekDifficulty.frame = ui_tex.getByName("EASY0000");
				weekDifficulty.offset.x = 20;
				weekDifficulty.offset.y = 0;
			case 1:
				weekDifficulty.frame = ui_tex.getByName("NORMAL0000");
				weekDifficulty.offset.x = 70;
				weekDifficulty.offset.y = 0;
			case 2:
				weekDifficulty.frame = ui_tex.getByName("HARD0000");
				weekDifficulty.offset.x = 20;
				weekDifficulty.offset.y = 0;
			case 3:
				weekDifficulty.frame = null;
				weekDifficulty.loadGraphic(Paths.image("storymenu/insane"));
				weekDifficulty.offset.x = 75;
				weekDifficulty.offset.y = 0;
		}
	}

	function selectWeek(?selWeek:Int, ?selDiff:Int)
	{
		if (weekUnlocked[curWeek])
			{
				moveCamera = false;
				if (stopspamming == false)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
	
					stopspamming = true;
				}
				FlxTween.tween(weekVsRyanBg, {"scale.x": 1.2, "scale.y": 1.2}, 0.4, {type: ONESHOT, ease: FlxEase.linear});
				FlxTween.tween(weekTutorialBg, {"scale.x": 1.2, "scale.y": 1.2}, 0.4, {type: ONESHOT, ease: FlxEase.linear});
				FlxTween.tween(weekCharacterVsRyanBack, {"scale.x": 1.2, "scale.y": 1.2, alpha: 0}, 0.4, {type: ONESHOT, ease: FlxEase.linear});
				FlxTween.tween(weekCharacterTutorialBack, {"scale.x": 1.2, "scale.y": 1.2, alpha: 0}, 0.4, {type: ONESHOT, ease: FlxEase.linear});
				FlxTween.tween(FlxG.camera, {zoom: 3, angle: 90}, 1.5, {ease: FlxEase.expoIn});
	
				PlayState.storyPlaylist = weekData[curWeek];
				PlayState.isStoryMode = true;
				selectedWeek = true;
	
				var diffic = "";
	
				switch (curDifficulty)
				{
					case 0:
						diffic = '-easy';
					case 2:
						diffic = '-hard';
					case 3:
						diffic = "-insane";
				}
	
				PlayState.storyDifficulty = curDifficulty;
	
				if (PlayState.storyPlaylist[0].toLowerCase() == "tutorial" && curDifficulty == 3)
				{
					PlayState.SONG = Song.loadFromJson("tutorial-insane".toLowerCase(), "tutorial-insane");
				}
				else
				{
					PlayState.SONG = Song.loadFromJson(StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase() + diffic, StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase());
				}
				PlayState.storyWeek = curWeek;
				PlayState.campaignScore = 0;

				FlxFlicker.flicker(weekText, 1, 0.06, false, false);
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					LoadingState.loadAndSwitchState(new PlayState(), true);
				});
			}
	}

	override function stepHit()
	{
		super.beatHit();
	}

	override function beatHit()
	{
		if (curBeat % 4 == 0)
		{
			FlxG.camera.zoom = 1.15;
			FlxTween.tween(FlxG.camera, {zoom: 1}, 0.3, {ease: FlxEase.linear});
		}
		
		if (curBeat % 4 != 0)
		{
			FlxG.camera.zoom = 1.03;
			FlxTween.tween(FlxG.camera, {zoom: 1}, 0.3, {ease: FlxEase.linear}); //Make something else than this cuz its broken and idk how to fix it
		}
	}
}
