// i prefer doing this in hx, sorry <3

import flixel.util.FlxTimer;

var hasPlayedInGameCutscene:Bool = false;
var hasPlayedCutscene:Bool = false;
var cutsceneSkipped:Bool = false;
var canSkipCutscene:Bool = false;

var picoPlayer:FlxAnimate;
var picoOpponent:FlxAnimate;
var bloodPool:FlxAnimate;
var cigarette:FlxSprite;
var skipText:FlxText;

var playerShoots:Bool;
var explode:Bool;

function onCreate() {
    bloodPool = new FlxAnimate(0, 0);
    Paths.loadAnimateAtlas(bloodPool, 'week3/philly/erect/bloodPool');
    bloodPool.anim.addBySymbol('doAnim', 'poolAnim', 24, false);
    bloodPool.visible = false;

    picoPlayer = new FlxAnimate(0, 0);
    Paths.loadAnimateAtlas(picoPlayer, 'week3/philly/erect/pico_doppleganger');
    picoPlayer.anim.addBySymbol('shoot', 'shootPlayer', 24, false);
    picoPlayer.anim.addBySymbol('explode', 'explodePlayer', 24, false);
    picoPlayer.anim.addBySymbol('loop', 'loopPlayer', 24, true);
    picoPlayer.anim.addBySymbol('cigarette', 'cigarettePlayer', 24, false);

    picoOpponent = new FlxAnimate(0, 0);
    Paths.loadAnimateAtlas(picoOpponent, 'week3/philly/erect/pico_doppleganger');
    picoOpponent.anim.addBySymbol('shoot', 'shootOpponent', 24, false);
    picoOpponent.anim.addBySymbol('explode', 'explodeOpponent', 24, false);
    picoOpponent.anim.addBySymbol('loop', 'loopOpponent', 24, true);
    picoOpponent.anim.addBySymbol('cigarette', 'cigaretteOpponent', 24, false);

    add(picoPlayer);
    add(picoOpponent);
    add(bloodPool);
}

var canStart = false;
function onStartCountdown() {
    if (!canStart && PlayState.seenCutscene) {
	PlayState.inCutscene = true;
	for (bar in [healthBar, healthBar.bg, iconP1, iconP2, scoreTxt])
	    bar.visible = false;
	doppleGangerCutscene();

	canStart = true;
	return Function_Stop;
    }
    return Function_Continue;
}

function doppleGangerCutscene(){
    var dadCamX = dad.getMidpoint().x + 150 + dad.cameraPosition[0] + game.opponentCameraOffset[0];
    var dadCamY = dad.getMidpoint().y - 100 + dad.cameraPosition[1] + game.opponentCameraOffset[1];

    var bfCamX = boyfriend.getMidpoint().x - 100 + boyfriend.cameraPosition[0] + game.boyfriendCameraOffset[0];
    var bfCamY = boyfriend.getMidpoint().y - 100 + boyfriend.cameraPosition[1] + game.boyfriendCameraOffset[1];

    // 50/50 chance for who shoots
    if(FlxG.random.bool(50)){
	playerShoots = true;
    } else {
	playerShoots = false;
    }
    if(FlxG.random.bool(8)){
	// trace('Doppelganger will explode!');
	explode = true;
    } else {
	// trace('Doppelganger will smoke!');
	explode = false;
    }

    var cigarettePos:Array<Float> = [];
    var shooterPos:Array<Float> = [];

    cigarette = new FlxSprite(0, 0);

    picoPlayer.setPosition(game.boyfriend.x + 48.5, game.boyfriend.y + 400);
    picoOpponent.setPosition(game.dad.x + 82, game.dad.y + 400);

    //picoPlayer.zIndex = PlayState.instance.currentStage.getBoyfriend().zIndex + 1;

    if(playerShoots){
	//picoOpponent.zIndex = picoPlayer.zIndex - 1;
	//bloodPool.zIndex = picoOpponent.zIndex - 1;
	//cigarette.zIndex = PlayState.instance.currentStage.getBoyfriend().zIndex - 2;
	cigarette.flipX = true;

	cigarette.setPosition(boyfriend.x - 143.5, boyfriend.y + 210);
	bloodPool.setPosition(dad.x - 1487, dad.y - 173);

	shooterPos = [bfCamX, bfCamY];
	cigarettePos = [dadCamX, dadCamY];
    }else{
	//picoOpponent.zIndex = picoPlayer.zIndex + 1;
	//bloodPool.zIndex = picoPlayer.zIndex - 1;
	//cigarette.zIndex = PlayState.instance.currentStage.getDad().zIndex - 2;

	bloodPool.setPosition(boyfriend.x - 788.5, boyfriend.y - 173);
	cigarette.setPosition(boyfriend.x - 478.5, boyfriend.y + 205);

	cigarettePos = [bfCamX, bfCamY];
	shooterPos = [dadCamX, dadCamY];
    }
    var midPoint:Array<Float> = [(shooterPos[0] + cigarettePos[0])/2, (shooterPos[1] + cigarettePos[1])/2];

    cigarette.frames = Paths.getSparrowAtlas('week3/philly/erect/cigarette');
    cigarette.animation.addByPrefix('cigarette spit', 'cigarette spit', 24, false);
    cigarette.visible = false;

    addBehindDad(cigarette);

    boyfriend.visible = false;
    dad.visible = false;

    if (!explode) {
	FlxG.sound.playMusic(Paths.music("week3/cutscene"), 1, false);
    }else{
	FlxG.sound.playMusic(Paths.music("week3/cutscene2"), 1, false);
    }

    new FlxTimer().start(0.3, _ -> { FlxG.sound.play(Paths.sound('week3/cutscene/picoGasp'), 1.0); });

    if (playerShoots) {
	picoPlayer.anim.play("shootPlayer");
	var opAnim = explode ? "explodeOpponent" : "cigaretteOpponent";
	picoOpponent.anim.play(opAnim);

	picoPlayer.anim.curFrame = 878;
	picoOpponent.anim.curFrame = explode ? 301 : 577;

	new FlxTimer().start(6.29, _ -> { FlxG.sound.play(Paths.sound('week3/cutscene/picoShoot'), 1.0); });
	new FlxTimer().start(10.33, _ -> { FlxG.sound.play(Paths.sound('week3/cutscene/picoSpin'), 1.0); });
    }else{
	picoOpponent.anim.play("shootOpponent");
	var plAnim = explode ? "explodePlayer" : "cigarettePlayer";
	picoPlayer.anim.play(plAnim);

	picoOpponent.anim.curFrame = 0;
	picoPlayer.anim.curFrame = explode ? 1179 : 1455;

	new FlxTimer().start(6.29, _ -> { FlxG.sound.play(Paths.sound('week3/cutscene/picoShoot'), 1.0); });
	new FlxTimer().start(10.33, _ -> { FlxG.sound.play(Paths.sound('week3/cutscene/picoSpin'), 1.0); });
    }

    if (explode) {
	new FlxTimer().start(3.7, _ -> { FlxG.sound.play(Paths.sound('week3/cutscene/picoCigarette2'), 1.0); });
        new FlxTimer().start(8.75, _ -> { FlxG.sound.play(Paths.sound('week3/cutscene/picoExplode'), 1.0); });
    } else {
	new FlxTimer().start(3.7, _ -> { FlxG.sound.play(Paths.sound('week3/cutscene/picoCigarette'), 1.0); });
    }

    FlxG.sound.play(Paths.sound('week3/cutscene/picoGasp'), 1);

    camFollow.setPosition(midPoint[0], midPoint[1]);

    new FlxTimer().start(4, _ -> {
	camFollow.setPosition(cigarettePos[0], cigarettePos[1]);
    });

    new FlxTimer().start(6.3, _ -> {
	camFollow.setPosition(shooterPos[0], shooterPos[1]);
    });

    new FlxTimer().start(8.75, _ -> {
	cutsceneSkipped = true;
	canSkipCutscene = false;
	//FlxTween.tween(skipText, {alpha: 0}, 0.5, {ease: FlxEase.quadIn, onComplete: _ -> {skipText.visible = false;}});
	// cutting off skipping here. really dont think its needed after this point and it saves problems from happening
	camFollow.setPosition(cigarettePos[0], cigarettePos[1]);
	if(explode)
	    gf.animation.play('drop70', true);
    });

    new FlxTimer().start(11.2, _ -> {
	if(explode) {
	    bloodPool.anim.play('doAnim');
	    bloodPool.visible = true;
	}
    });

    new FlxTimer().start(11.5, _ -> {
	if(!explode){
	    cigarette.visible = true;
	    cigarette.animation.play('cigarette spit');
	}
    });

    new FlxTimer().start(13, _ -> {
	if(!explode || playerShoots){
	    game.startCountdown();
	    PlayState.inCutscene = false;
	}

	if(explode){
	    if(playerShoots){
		picoPlayer.visible = false;
		boyfriend.visible = true;
	    }else{
		picoOpponent.visible = false;
		//PlayState.instance.disableKeys = true;
		dad.visible = true;

		new FlxTimer().start(1, function(tmr)
		{
		    camHUD.fade(0x000000, 1, false);
		    //PlayState.instance.camCutscene.fade(0xFF000000, 1, false, null, true);
		});

		new FlxTimer().start(2, function(tmr)
		{
		    game.endSong();
		});
	    }
	}else{
	    picoPlayer.visible = false;
	    boyfriend.visible = true;
	    picoOpponent.visible = false;
	    dad.visible = true;
	}

	    hasPlayedCutscene = true;
	    //cutsceneMusic.stop();
    });
    setVar('playerShoots', playerShoots);
    setVar('explode', explode);
}

function onUpdatePost() {
    if (playerShoots) {
	if (picoPlayer.anim.curFrame >= 1178)
	    picoPlayer.anim.curFrame = 1178;
	if (picoOpponent.anim.curFrame >= (!explode ? 877 : 576)) {
	    picoOpponent.anim.curFrame = !explode ? 877 : 569;
	    if (explode && bloodPool.anim.curFrame >= 85) bloodPool.anim.curFrame = 85;
	}
    } else {
	if (picoOpponent.anim.curFrame >= 300)
	    picoOpponent.anim.curFrame = 300;

	if (picoPlayer.anim.curFrame >= (!explode ? 1750 : 1454)) {
	    picoPlayer.anim.curFrame = !explode ? 1750 : 1447;
	    if (explode && bloodPool.anim.curFrame >= 85) bloodPool.anim.curFrame = 85;
	}
    }
    if (playerShoots && explode) {
	game.opponentVocals.volume = 0;
	for(note in game.notes) {
	    if (!note.mustPress)
		note.offsetY = ClientPrefs.data.downScroll ? 100 : -100;
	}
    }
}

function opponentNoteHit(note) { if (playerShoots && explode) game.opponentStrums.members[note.noteData].playAnim('static', true); }