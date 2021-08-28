package;

import lime.app.Application;
import lime.system.DisplayMode;
import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class OptionCategory
{
	private var _options:Array<Option> = new Array<Option>();
	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	
	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Category";
	public final function getName() {
		return _name;
	}

	public function new (catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}
	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;
	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	public function getValue():String { return throw "stub!"; };
	
	// Returns whether the label is to be updated.
	public function press():Bool { return throw "stub!"; }
	private function updateDisplay():String { return throw "stub!"; }
	public function left():Bool { return throw "stub!"; }
	public function right():Bool { return throw "stub!"; }
}



class DFJKOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		OptionsMenu.instance.openSubState(new KeyBindMenu());
		return false;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Key Bindings";
		else
			return "Controles";
	}
}

class CpuStrums extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.cpuStrums = !FlxG.save.data.cpuStrums;
		
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return  FlxG.save.data.cpuStrums ? "Light CPU Strums" : "CPU Strums stay static";
		else
			return  FlxG.save.data.cpuStrums ? "Iluminar flechas del CPU" : "Flechas del CPU estaticas";
	}

}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.cpuStrums ? "Downscroll" : "Upscroll";
	}
}

class GhostTapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.ghost = !FlxG.save.data.ghost;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return FlxG.save.data.cpuStrums ? "Ghost Tapping" : "No Ghost Tapping";
		else
			return FlxG.save.data.downscroll ? "Ghost Tapping" : "Ghost Tapping Des";
	}
}

class AccuracyOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on");
		else
			return "Precision " + (!FlxG.save.data.accuracyDisplay ? "des" : "act");
	}
}

class SongPositionOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Song Position " + (!FlxG.save.data.songPosition ? "off" : "on");
		else
			return "Mostrar posicion " + (!FlxG.save.data.songPosition ? "des" : "act");
	}
}

class DistractionsAndEffectsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.distractions = !FlxG.save.data.distractions;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Distractions " + (!FlxG.save.data.distractions ? "off" : "on");
		else
			return "Distracciones " + (!FlxG.save.data.distractions ? "des" : "act");
	}
}

class ResetButtonOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.resetButton = !FlxG.save.data.resetButton;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Reset Button " + (!FlxG.save.data.resetButton ? "off" : "on");
		else
			return "Boton de reinicio " + (!FlxG.save.data.resetButton ? "des" : "act");
	}
}

class FlashingLightsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.flashing = !FlxG.save.data.flashing;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Flashing Lights " + (!FlxG.save.data.flashing ? "off" : "on");
		else
			return "Luces parpadeantes " + (!FlxG.save.data.flashing ? "des" : "act");
	}
}

class Judgement extends Option
{
	

	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}
	
	public override function press():Bool
	{
		return true;
	}

	private override function updateDisplay():String
	{
		return "Safe Frames";
	}

	override function left():Bool {

		if (Conductor.safeFrames == 1)
			return false;

		Conductor.safeFrames -= 1;
		FlxG.save.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();
		return true;
	}

	override function getValue():String {
		return "Frames seguros: " + Conductor.safeFrames +
		" - SIK: " + HelperFunctions.truncateFloat(45 * Conductor.timeScale, 0) +
		"ms GD: " + HelperFunctions.truncateFloat(90 * Conductor.timeScale, 0) +
		"ms BD: " + HelperFunctions.truncateFloat(135 * Conductor.timeScale, 0) + 
		"ms SHT: " + HelperFunctions.truncateFloat(155 * Conductor.timeScale, 0) +
		"ms TOTAL: " + HelperFunctions.truncateFloat(Conductor.safeZoneOffset,0) + "ms";
	}

	override function right():Bool {

		if (Conductor.safeFrames == 20)
			return false;

		Conductor.safeFrames += 1;
		FlxG.save.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();
		return true;
	}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fps = !FlxG.save.data.fps;
		(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "FPS Counter " + (!FlxG.save.data.fps ? "off" : "on");
		else
			return "Contador de FPS " + (!FlxG.save.data.fps ? "des" : "act");
	}
}



class FPSCapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "FPS Cap";
		else
			return "Bloqueo de FPS";
	}
	
	override function right():Bool {
		if (FlxG.save.data.fpsCap >= 290)
		{
			FlxG.save.data.fpsCap = 290;
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);
		}
		else
			FlxG.save.data.fpsCap = FlxG.save.data.fpsCap + 10;
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		return true;
	}

	override function left():Bool {
		if (FlxG.save.data.fpsCap > 290)
			FlxG.save.data.fpsCap = 290;
		else if (FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = Application.current.window.displayMode.refreshRate;
		else
			FlxG.save.data.fpsCap = FlxG.save.data.fpsCap - 10;
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
		return true;
	}

	override function getValue():String
	{
		if (!FlxG.save.data.spanishMode)
		{
			return "Current FPS Cap: " + FlxG.save.data.fpsCap + 
			(FlxG.save.data.fpsCap == Application.current.window.displayMode.refreshRate ? "Hz (Refresh Rate)" : "");
		}
		else
		{
			return "Bloqueo de FPS actual: " + FlxG.save.data.fpsCap + 
			(FlxG.save.data.fpsCap == Application.current.window.displayMode.refreshRate ? "Hz (Refresh Rate)" : "");
		}
	}
}


class ScrollSpeedOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Scroll Speed";
		else
			return "Velocidad de scroll";
	}

	override function right():Bool {
		FlxG.save.data.scrollSpeed += 0.1;

		if (FlxG.save.data.scrollSpeed < 1)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.scrollSpeed > 4)
			FlxG.save.data.scrollSpeed = 4;
		return true;
	}

	override function getValue():String {
		if (!FlxG.save.data.spanishMode)
			return "Current Scroll Speed: " + HelperFunctions.truncateFloat(FlxG.save.data.scrollSpeed,1);
		else
			return "Velocidad de scroll actual: " + HelperFunctions.truncateFloat(FlxG.save.data.scrollSpeed,1);
		
	}

	override function left():Bool {
		FlxG.save.data.scrollSpeed -= 0.1;

		if (FlxG.save.data.scrollSpeed < 1)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.scrollSpeed > 4)
			FlxG.save.data.scrollSpeed = 4;

		return true;
	}
}


class RainbowFPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fpsRain = !FlxG.save.data.fpsRain;
		(cast (Lib.current.getChildAt(0), Main)).changeFPSColor(FlxColor.WHITE);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "FPS Rainbow" + (!FlxG.save.data.fpsRain ? "off" : "on");
		else
			return "FPS Arcoiris" + (!FlxG.save.data.fpsRain ? "des" : "act");
	}
}

class NPSDisplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.npsDisplay = !FlxG.save.data.npsDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "NPS Display " + (!FlxG.save.data.npsDisplay ? "off" : "on");
		else
			return "Mostrar NPS " + (!FlxG.save.data.fpsRain ? "des" : "act");
	}
}

class ReplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new LoadReplayState());
		return false;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Load replays";
		else
			return "Cargar replays";
	}
}

class AccuracyDOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		FlxG.save.data.accuracyMod = FlxG.save.data.accuracyMod == 1 ? 0 : 1;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Accuracy Mode: "+ (FlxG.save.data.accuracyMod == 0 ? "Accurate" : "Complex");
		else
			return "Modo de precision: " + (FlxG.save.data.accuracyMod == 0 ? "Preciso" : "Complejo");
	}
}

class CustomizeGameplay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new GameplayCustomizeState());
		return false;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Customize Gameplay";
		else
			return "Personalizar gameplay";
	}
}

class WatermarkOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		Main.watermarks = !Main.watermarks;
		FlxG.save.data.watermark = Main.watermarks;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Watermarks " + (!Main.watermarks ? "off" : "on");
		else
			return "Marcas de agua " + (!Main.watermarks ? "des" : "act");
	}
}

class OffsetMenu extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		var poop:String = Highscore.formatSong("Tutorial", 1);

		PlayState.SONG = Song.loadFromJson(poop, "Tutorial");
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = 0;
		PlayState.storyWeek = 0;
		PlayState.offsetTesting = true;
		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());
		return false;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Time your offset";
		else
			return "Ajusta el desfase";
	}
}
class BotPlay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		FlxG.save.data.botplay = !FlxG.save.data.botplay;
		trace('BotPlay : ' + FlxG.save.data.botplay);
		display = updateDisplay();
		return true;
	}
	
	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "BotPlay " + (FlxG.save.data.botplay ? "on" : "off");
		else
			return "BotPlay " + (FlxG.save.data.botplay ? "act" : "des");
	}
}

class HideScore extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.hideScore = !FlxG.save.data.hideScore;
		trace('HideScore: ' + FlxG.save.data.hideScore);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		if (!FlxG.save.data.spanishMode)
			return "Hide Score Popup " + (FlxG.save.data.botplay ? "on" : "off");
		else
			return "Ocultar Popup de Score " + (FlxG.save.data.botplay ? "act" : "des");
	}
}

class SpanishMode extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.spanishMode = !FlxG.save.data.spanishMode;
		trace("SpanishMode: " + FlxG.save.data.spanishMode);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return (FlxG.save.data.spanishMode ? "Espanol" : "English");
	}
}