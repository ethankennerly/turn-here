package com.finegamedesign.turnhere
{
    import org.flixel.*;
    import flash.media.Sound;
    import flash.utils.setInterval;
   
    public class PlayState extends FlxState
    {
        [Embed(source="/../data/blip.mp3")] protected var SndBlip:Class;
        private var blipSound:Sound;
        private var blipCount:int;
        private var blipText:FlxText;

        override public function create():void
        {
            blipCount = 0;
            blipSound = new SndBlip();   
            setInterval(blip, 1000);
            add(new FlxText(0,0,100,"BLIP EVERY SECOND"));
            blipText = new FlxText(320-40,0,100,blipCount.toString());
            add(blipText);
        }

        private function blip():void
        {
            blipSound.play();
            blipCount++;
            blipText.text = blipCount.toString();
        }
    }
}
