import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxGradient;

var camOver:FlxCamera = new FlxCamera();
var bigChar:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/credits/chars"));
var quote:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/credits/quotes"));

var titleText:FunkinText = new FunkinText(10, 10, 0, "Jeffy's Infinite Irida - Shucks Demo Credits", 32, false).setFormat(Paths.font("SuperMario256.ttf"), 32);

static var credits:Array<String> = CoolUtil.getAnimsListFromSprite(bigChar);
var chars:FlxGroup = new FlxGroup();

var specialThx:FunkinText = new FunkinText(10, 10, 0, "!!!", 32, false);
var theThx:FlxGroup = new FlxGroup();

var clickText:FunkinText;

var selecting:Bool = false;
var curCred:Int;

// instead of multiple cases, an array w/ characters + positions
var charData:Array<Dynamic> = [
    { name: "coquers", x: -500, y: 250 },
    { name: "betasheep", x: -275, y: 175 },
    { name: "boingbingus", x: -75, y: 275 },
    { name: "ciphie", x: -100, y: 150 },
    { name: "kane", x: 100, y: 150 },
    { name: "m3zra", x: 275, y: 125 },
    { name: "wellwoven", x: 325, y: 300 },
    { name: "firemaster", x: 500, y: 100 },
    { name: "scrilopolis", x: 675, y: 200 },
    { name: "asyu", x: 575, y: 375 },
    { name: "torders", x: 800, y: 200 },
    { name: "frikko", x: 900, y: 125 },
    { name: "valcant", x: 925, y: 375 },
    { name: "awaken", x: 1050, y: 400 },
    { name: "care", x: 1100, y: 150 },
    { name: "karlie", x: 1250, y: 300 },
    { name: "diggin", x: 1400, y: 300 },
    { name: "lewis", x: 1400, y: 75 },
    { name: "leebert", x: 1600, y: 150 },
    { name: "pablo", x: 1800, y: 325, flipX: true },
    { name: "hazey", x: 670, y: 0 }
];

// fallback function instead of .find() to avoid null pointer issues
function getCharData(name:String):Dynamic {
    for (d in charData)
        if (d.name.toLowerCase() == name.toLowerCase())
            return d;
    return null;
}

function create() {
    FlxG.mouse.visible = true;
    FlxG.cameras.add(camOver, false).bgColor = FlxColor.TRANSPARENT;

    var bg:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/credits/bg"));
    add(bg).screenCenter();
    bg.x += 55;
    bg.scale.set(2.5, 2.5);
    bg.antialiasing = Options.antialiasing;
	
    for (num => a in credits) {
        var char:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/credits/chars"));
        char.addAnim("idle", a, 0);
        char.playAnim("idle");

        char.scale.set(0.5, 0.5);
        char.updateHitbox();

        char.antialiasing = Options.antialiasing;

        bigChar.addAnim(a, a, 24, true);
        quote.addAnim(a, a);

        var data = getCharData(a);
        if (data != null) {
            char.setPosition(data.x, data.y);
            if (Reflect.hasField(data, "flipX")) char.flipX = data.flipX;
        } else {
            trace("No position data for " + a);
            char.visible = false;
        }

        chars.add(char).ID = num;
    }

    for (num => a in ["Efkli:\nShucks Vocal Mixing", "Springon:\nShucks Visualizer", "Top Hat:\nIcons", "Sirvko"]) {
        var text:FunkinText = new FunkinText(0, 0, 0, a, 32, true);
        text.setPosition(theThx.members[0] == null ? FlxG.width / 2 - text.width / 2 : theThx.members[0].x, (FlxG.height / 5 * (num + 1)) - text.height / 1.5);
        text.setFormat(Paths.font("SuperMario256.ttf"), 48, FlxColor.WHITE);
        theThx.add(text).setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1);

        var icon:FunkinSprite = new FunkinSprite(text.x - 155, text.getMidpoint().y - 65, Paths.image("menus/credits/specialthx/" + a.split(":\n")[0].toLowerCase()));
        theThx.add(icon).scale.set(130 / icon.width, 130 / icon.height);
        icon.updateHitbox();

        text.antialiasing = icon.antialiasing = Options.antialiasing;
    }

    // cam over shit hi
    var back:FunkinSprite = new FunkinSprite(0, 50).makeSolid(FlxG.width, 620, FlxColor.BLACK);
    add(back).alpha = 0.5;

    var grad:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, 620, [FlxColor.TRANSPARENT, FlxColor.BLACK], 1, 0);
    add(grad).y = 50;

    add(theThx).camera = camOver;

    add(bigChar).antialiasing = grad.antialiasing = quote.antialiasing = Options.antialiasing;
    add(quote).scale.set(720/920, 720/920);

    back.camera = grad.camera = bigChar.camera = quote.camera = camOver;

    camOver.alpha = 0;

    // normal camera shit bye
    add(chars);

    add(new FunkinSprite().makeSolid(FlxG.width, 50, FlxColor.BLACK)).scrollFactor.set();
    add(new FunkinSprite(0, 720 - 50).makeSolid(FlxG.width, 50, FlxColor.BLACK)).scrollFactor.set();

    add(titleText).scrollFactor.set();

    specialThx.setFormat(Paths.font("SuperMario256.ttf"), 32);
    add(specialThx).scrollFactor.set();
    specialThx.x = FlxG.width - specialThx.width - 10;

    add(clickText = new FunkinText(0, 720 - 40, FlxG.width, "Click to view info", 32, false).setFormat(Paths.font("SuperMario256.ttf"), 32)).scrollFactor.set();
    clickText.alignment = "center";

    titleText.antialiasing = specialThx.antialiasing = clickText.antialiasing = Options.antialiasing;
}

function update(elapsed:Float) {
    clickText.y = lerp(clickText.y, curCred != null && !selecting ? 680 : 720, 0.33);
    clickText.alpha = lerp(clickText.alpha, curCred != null && !selecting ? 1 : 0, 0.3);

    camOver.alpha = lerp(camOver.alpha, selecting ? 1 : 0, 0.11);

    if (!selecting) {
        FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, 125 + (FlxG.mouse.screenX-(FlxG.width/2)), (1/30) * 240 * elapsed);

        curCred = null;

        specialThx.color = FlxG.mouse.overlaps(specialThx) ? FlxColor.RED : FlxColor.WHITE;

        for (a in chars.members) {
            if (FlxG.mouse.overlaps(a) && curCred == null) curCred = a.ID;
            a.alpha = lerp(a.alpha, curCred == a.ID ? 1 : 0.5, 0.33);
            a.animation.curAnim.curFrame = curCred != a.ID ? 0 : 10;
        }

        if (FlxG.mouse.justPressed && curCred != null) {
            bigChar.visible = quote.visible = !(theThx.visible = false);
            bigChar.playAnim(credits[curCred]);
            quote.playAnim(credits[curCred]);
            bigChar.setPosition(-bigChar.width, (FlxG.height - bigChar.height) / 2);
            quote.setPosition(FlxG.width, 20 + (FlxG.height - quote.height) / 2);

            selecting = true;
        }

        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(specialThx)) {
            bigChar.visible = quote.visible = !(theThx.visible = true);
            titleText.text = "Jeffy's Infinite Irida - Shucks Demo Special Thanks";
            selecting = true;
        }
    } else {
        bigChar.x = lerp(bigChar.x, FlxG.width / 4 - bigChar.width / 2, 0.04);
        if(quote.visible) quote.x = lerp(quote.x, ((FlxG.width / 4) * 3) - quote.width / 2, 0.04);
    }
    
    if (controls.BACK && !selecting)
        FlxG.switchState(new MainMenuState());
    if (controls.BACK && selecting) {
        titleText.text = "Jeffy's Infinite Irida - Shucks Demo Credits";
        selecting = false;
    }
}
