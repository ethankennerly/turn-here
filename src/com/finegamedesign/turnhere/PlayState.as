package com.finegamedesign.turnhere
{
    import org.flixel.*;
   
    public class PlayState extends FlxState
    {
        [Embed(source="/../data/blip.mp3")] protected var SndBlip:Class;
		[Embed(source="/../data/player.png")] protected var ImgPlayer:Class;
		[Embed(source="/../data/wall.png")] protected var ImgWall:Class;
        private var blipCount:int;
        private var blipText:FlxText;
        private var player:FlxSprite;
        private var walls:FlxGroup;
        private var driftTimer:FlxTimer;
        private var turnTimer:FlxTimer;

        override public function create():void
        {
            super.create();
            FlxG.bgColor = 0xFF222222;
            blipCount = 0;
            turnTimer = new FlxTimer();
            driftTimer = new FlxTimer();
            player = new FlxSprite(180, 4000 + 240 - 48, ImgPlayer);
            player.velocity.y = -128;
            var instructionText:FlxText = new FlxText(0, 0, 100, "BLIP EVERY SECOND");
            instructionText.scrollFactor.x = 0.0;
            instructionText.scrollFactor.y = 0.0;
            walls = createWalls();
            add(walls);
            add(player);
            add(instructionText);
            blipText = new FlxText(320 - 40, 0, 100, blipCount.toString());
            blipText.scrollFactor.x = 0.0;
            blipText.scrollFactor.y = 0.0;
            add(blipText);
            turnTimer.start(1, int.MAX_VALUE, blip);
			FlxG.camera.setBounds(0, 0, 4800, 4800, true);
			FlxG.camera.follow(player);
        }

        private function createWalls():FlxGroup
        {
            var walls:FlxGroup = new FlxGroup();
            for (var y:int = player.y - 120; y < player.y + 120; y += 32) {
                var wall:FlxSprite;
                wall = new FlxSprite(180 - 32, y, ImgWall);
                walls.add(wall);
                wall = new FlxSprite(180 + 32, y + 16, ImgWall);
                walls.add(wall);
            }
            return walls;
        }

		override public function update():void 
        {
            recyclePosition(walls);
            updateInput();
            FlxG.overlap(walls, player, overlapRoad);			
            super.update();
        }

        private function updateInput():void
        {
            var x:int = 0;
            if (FlxG.keys.justPressed("LEFT")) {
                x--;
            }
            if (FlxG.keys.justPressed("RIGHT")) {
                x++;
            }
            if (0 != x) {
                player.velocity.x = 320 * x;
                driftTimer.start(0.125, 1, drift);
            }
        }

        private function drift(timer:FlxTimer):void
        {
            player.velocity.x = 0;
        }

        private function recyclePosition(walls:FlxGroup):void
        {
            var members:Array = walls.members; 
            for (var w:int =0; w < walls.length; w++) {
                if (player.y < members[w].y && !(members[w].onScreen())) {
                    members[w].y -= 240 + 16;
                }
            }
        }

		protected function overlapRoad(EnemyObject:FlxObject, PlayerObject:FlxObject):void 
        {
            FlxG.play(SndBlip);
            EnemyObject.flicker(1);
            PlayerObject.flicker(1);
		}

        private function blip(timer:FlxTimer):void
        {
            FlxG.play(SndBlip);
            blipCount++;
            blipText.text = blipCount.toString();
        }
    }
}
