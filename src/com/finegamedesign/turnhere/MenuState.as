package com.finegamedesign.turnhere
{
    import org.flixel.*;

    public class MenuState extends FlxState
    {
        override public function create():void
        {
            var t:FlxText;
            t = new FlxText(0,FlxG.height/3,FlxG.width,"Turn Here");
            t.size = 16;
            t.alignment = "center";
            add(t);
            t = new FlxText(FlxG.width/2-50,FlxG.height/2,100,"PRESS LEFT OR RIGHT TO STAY IN THE MIDDLE\n\nClick to play\n\nHigh Score " + FlxG.score);
            
            t.alignment = "center";
            add(t);
            
            FlxG.mouse.show();
        }

        override public function update():void
        {
            super.update();

            if(FlxG.mouse.justPressed())
            {
                FlxG.mouse.hide();
                FlxG.switchState(new PlayState());
            }
        }
    }
}
