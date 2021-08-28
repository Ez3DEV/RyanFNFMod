package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var selector:FlxText;
	var curSelected:Int = 0;

	var options:Array<OptionCategory>;

	public var acceptInput:Bool = true;

	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<Alphabet>;
	public static var versionShit:FlxText;

	var currentSelectedCat:OptionCategory;
	var blackBorder:FlxSprite;
	override function create()
	{
		instance = this;

		if (!FlxG.save.data.spanishMode)
			{
				options = [
					new OptionCategory("Gameplay", [
						new DFJKOption(controls),
						new DownscrollOption("Change the layout of the strumline."),
						new GhostTapOption("Ghost Tapping is when you tap a direction and it doesn't give you a miss."),
						new Judgement("Customize your Hit Timings (LEFT or RIGHT)"),
						#if desktop
						new FPSCapOption("Cap your FPS"),
						#end
						new ScrollSpeedOption("Change your scroll speed (1 = Chart dependent)"),
						new AccuracyDOption("Change how accuracy is calculated. (Accurate = Simple, Complex = Milisecond Based)"),
						new ResetButtonOption("Toggle pressing R to gameover."),
						// new OffsetMenu("Get a note offset based off of your inputs!"),
						new HideScore("Hide score popup on note hit."),
						new CustomizeGameplay("Drag'n'Drop Gameplay Modules around to your preference")
					]),
					new OptionCategory("Appearance", [
						new SpanishMode("Change the language of the game."),
						#if desktop
						new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay."),
						new RainbowFPSOption("Make the FPS Counter Rainbow"),
						new AccuracyOption("Display accuracy information."),
						new NPSDisplayOption("Shows your current Notes Per Second."),
						new SongPositionOption("Show the songs current position (as a bar)"),
						new CpuStrums("CPU's strumline lights up when a note hits it."),
						#else
						new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay.")
						#end
					]),
					
					new OptionCategory("Misc", [
						#if desktop
						new FPSOption("Toggle the FPS Counter"),
						new ReplayOption("View replays"),
						#end
						new FlashingLightsOption("Toggle flashing lights that can cause epileptic seizures and strain."),
						new WatermarkOption("Enable and disable all watermarks from the engine."),
						new BotPlay("Showcase your charts and mods with autoplay.")
					])
					
				];
			}
			else
			{
				options = [
					new OptionCategory("Gameplay", [
						new DFJKOption(controls),
						new DownscrollOption("Cambiar como se ven las flechas."),
						new GhostTapOption("Ghost tapping es cuando tocas una flecha cuando no hay y no te da un miss."),
						new Judgement("Personaliza los timings al presionar (IZQUIERDA o DERECHA)"),
						#if desktop
						new FPSCapOption("Bloquea tus FPS"),
						#end
						new ScrollSpeedOption("Cambia la velocidad de las flechas (1 = Depende del mapa)"),
						new AccuracyDOption("Cambia como se calcula la precision. (Accurate = Simple, Complex = Basado en milisegundos)"),
						new ResetButtonOption("Activa o desactiva la R para reiniciar rapido."),
						// new OffsetMenu("Get a note offset based off of your inputs!"),
						new HideScore("Oculta el score cuando se toca una nota."),
						new CustomizeGameplay("Arrastra y suelta los elementos del gameplay a tu gusto!")
					]),
					new OptionCategory("Apariencia", [
						new SpanishMode("Cambia el idioma del juego."),
						#if desktop
						new DistractionsAndEffectsOption("Activa o desactiva las distracciones de los niveles."),
						new RainbowFPSOption("Haz que el contador de FPS sea de color arcoiris"),
						new AccuracyOption("Muestra la informacion de precision."),
						new NPSDisplayOption("Muestra tus notas por segundo actuales."),
						new SongPositionOption("Muestra la posicion actual de la cancion (en una barra)."),
						new CpuStrums("Las notas del enemigo brillan cuando las presiona."),
						#else
						new DistractionsAndEffectsOption("Activa o desactiva las distracciones de los niveles.")
						#end
					]),
					
					new OptionCategory("Misc", [
						#if desktop
						new FPSOption("Activa o desactiva el contador de FPS"),
						new ReplayOption("Ve los replays"),
						#end
						new FlashingLightsOption("Activa o desactiva luces que pueden causar epilepsia."),
						new WatermarkOption("Activa o desactiva todas las marcas de agua del Kade Engine."),
						new BotPlay("Muestra tus charts y mod con AutoPlay.")
					])
					
				];
			}

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuBG"));

		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false, true);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		currentDescription = "none";

		if (!FlxG.save.data.spanishMode) versionShit = new FlxText(5, FlxG.height + 40, 0, "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription, 12);
		else versionShit = new FlxText(5, FlxG.height + 40, 0, "Offset (Izquierda, Derecha, Shift para mas lento): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Descripcion - " + currentDescription, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		
		blackBorder = new FlxSprite(-30,FlxG.height + 40).makeGraphic((Std.int(versionShit.width + 900)),Std.int(versionShit.height + 600),FlxColor.BLACK);
		blackBorder.alpha = 0.5;

		add(blackBorder);

		add(versionShit);

		FlxTween.tween(versionShit,{y: FlxG.height - 18},2,{ease: FlxEase.elasticInOut});
		FlxTween.tween(blackBorder,{y: FlxG.height - 18},2, {ease: FlxEase.elasticInOut});

		super.create();
	}

	var isCat:Bool = false;
	

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (acceptInput)
		{
			if (controls.BACK && !isCat)
				FlxG.switchState(new MainMenuState());
			else if (controls.BACK)
			{
				isCat = false;
				grpControls.clear();
				for (i in 0...options.length)
					{
						var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false);
						controlLabel.isMenuItem = true;
						controlLabel.targetY = i;
						grpControls.add(controlLabel);
						// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
					}
				curSelected = 0;
			}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			
			if (isCat)
			{
				
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
				{
					if (FlxG.keys.pressed.SHIFT)
						{
							if (FlxG.keys.pressed.RIGHT)
								currentSelectedCat.getOptions()[curSelected].right();
							if (FlxG.keys.pressed.LEFT)
								currentSelectedCat.getOptions()[curSelected].left();
						}
					else
					{
						if (FlxG.keys.justPressed.RIGHT)
							currentSelectedCat.getOptions()[curSelected].right();
						if (FlxG.keys.justPressed.LEFT)
							currentSelectedCat.getOptions()[curSelected].left();
					}
				}
				else
				{

					if (FlxG.keys.pressed.SHIFT)
					{
						if (FlxG.keys.justPressed.RIGHT)
							FlxG.save.data.offset += 0.1;
						else if (FlxG.keys.justPressed.LEFT)
							FlxG.save.data.offset -= 0.1;
					}
					else if (FlxG.keys.pressed.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (FlxG.keys.pressed.LEFT)
						FlxG.save.data.offset -= 0.1;
					
				
				}
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
					versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
				else
					if (!FlxG.save.data.spanishMode) versionShit.text = "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
					else versionShit.text = "Offset (Izquierda, Derecha, Shift para mas lento): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Descripcion - " + currentDescription;
			}
			else
			{
				if (FlxG.keys.pressed.SHIFT)
					{
						if (FlxG.keys.justPressed.RIGHT)
							FlxG.save.data.offset += 0.1;
						else if (FlxG.keys.justPressed.LEFT)
							FlxG.save.data.offset -= 0.1;
					}
					else if (FlxG.keys.pressed.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (FlxG.keys.pressed.LEFT)
						FlxG.save.data.offset -= 0.1;
			}
		

			if (controls.RESET)
					FlxG.save.data.offset = 0;

			if (controls.ACCEPT)
			{
				if (isCat)
				{
					if (currentSelectedCat.getOptions()[curSelected].press()) {
						grpControls.remove(grpControls.members[curSelected]);
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, currentSelectedCat.getOptions()[curSelected].getDisplay(), true, false);
						ctrl.isMenuItem = true;
						grpControls.add(ctrl);
					}
				}
				else
				{
					currentSelectedCat = options[curSelected];
					isCat = true;
					grpControls.clear();
					for (i in 0...currentSelectedCat.getOptions().length)
						{
							var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), true, false);
							controlLabel.isMenuItem = true;
							controlLabel.targetY = i;
							grpControls.add(controlLabel);
							// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
						}
					curSelected = 0;
				}
			}
		}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end
		
		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		if (isCat)
			currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
		else
			currentDescription = "Please select a category";
		if (isCat)
		{
			if (currentSelectedCat.getOptions()[curSelected].getAccept())
				versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
			else
				if (!FlxG.save.data.spanishMode) versionShit.text = "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
				else versionShit.text = "Offset (Izquierda, Derecha, Shift para mas lento): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Descripcion - " + currentDescription;
		}
		else
			if (!FlxG.save.data.spanishMode) versionShit.text = "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
			else versionShit.text = "Offset (Izquierda, Derecha, Shift para mas lento): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Descripcion - " + currentDescription;
		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
