package com.finegamedesign.turnhere
{
    import org.flixel.*;
    [SWF(width="640", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="Preloader")]

    public class TurnHere extends FlxGame
    {
        public function TurnHere()
        {
            super(320,240,MenuState,2);
        }
    }
}
