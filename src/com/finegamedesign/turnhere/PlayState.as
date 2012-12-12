package com.finegamedesign.turnhere
{
    import org.flixel.*;
   
    public class PlayState extends FlxState
    {
        [Embed(source="/../data/blip.mp3")] protected var SndBlip:Class;
		[Embed(source="/../data/player.png")] protected var ImgPlayer:Class;
		[Embed(source="/../data/wall.png")] protected var ImgWall:Class;
        private var blipCount:int;
        private var roadX:int;
        private var targetX:int;
        private var follow:FlxObject;
        private var turn:int;
        private var blipText:FlxText;
        private var player:FlxSprite;
        private var walls:FlxGroup;
        private var wallArray:Array;
        private var driftTimer:FlxTimer;
        private var turnTimer:FlxTimer;

        override public function create():void
        {
            FlxG.visualDebug = true;
            super.create();
            FlxG.bgColor = 0xFF222222;
            blipCount = 0;
            turn = 40;
            turnTimer = new FlxTimer();
            driftTimer = new FlxTimer();
            player = new FlxSprite(8000, 16000, ImgPlayer);
            player.velocity.y = -240;  // -128;
            roadX = player.x;
            targetX = player.x;
            follow = new FlxObject(player.x, player.y - 48);
            follow.velocity.y = player.velocity.y;
            var instructionText:FlxText = new FlxText(0, 0, 100, "PRESS LEFT OR RIGHT\nSTAY IN THE MIDDLE");
            instructionText.scrollFactor.x = 0.0;
            instructionText.scrollFactor.y = 0.0;
            walls = createWalls();
            add(walls);
            add(player);
            add(follow);
            add(instructionText);
            blipText = new FlxText(320 - 40, 0, 100, blipCount.toString());
            blipText.scrollFactor.x = 0.0;
            blipText.scrollFactor.y = 0.0;
            add(blipText);
            // turnTimer.start(1, int.MAX_VALUE, blip);
			FlxG.camera.setBounds(0, 0, player.x * 2, player.y, true);
			FlxG.camera.follow(follow);
        }

        private function createWalls():FlxGroup
        {
            var walls:FlxGroup = new FlxGroup();
            wallArray = [];
            for (var y:int = player.y - 240; y < player.y + 240; y += 240) {
                for (var x:int = player.x - 32 - 96; x <= player.x + 32 + 96; x += 64 + 96) {
                    var wall:FlxSprite = new FlxSprite(x, y, ImgWall);
                    wallArray.push(wall);
                    walls.add(wall);
                }
            }
            return walls;
        }

		override public function update():void 
        {
            FlxG.overlap(walls, player, overlapRoad);
            follow.x = player.x;
            recyclePosition(wallArray);
            updateInput();
            super.update();
            if (1 <= blipCount && !player.onScreen()) {
                FlxG.switchState(new MenuState());
            }
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
                targetX = player.x + Math.abs(turn) * x;
            }
        }

        private function drift(timer:FlxTimer):void
        {
            player.velocity.x = 0;
            player.x = targetX;
        }

        private function recyclePosition(members:Array):void
        {
            for (var w:int=0; w < members.length; w++) {
                if (player.y < members[w].y && !(members[w].onScreen())) {
                    if (0 == w % 2) {
                        blip(null);
                    }
                    members[w].x = members[(w + 2) % members.length].x + turn;
                    members[w].y = members[(w + 2) % members.length].y - 240 - 96;  
                        // -48 // too hard.
                    // trace("recyclePosition: " + members[w].x + " " + members[w].y);
                }
            }
        }

		protected function overlapRoad(EnemyObject:FlxObject, PlayerObject:FlxObject):void 
        {
            FlxG.play(SndBlip);
            if (! EnemyObject.flickering) {
                EnemyObject.flicker(0.0625);
            }
            if (! PlayerObject.flickering) {
                PlayerObject.flicker(0.0625);
            }
            if (6 <= blipCount) {
                FlxG.switchState(new MenuState());
            }
		}

        private function blip(timer:FlxTimer):void
        {
            FlxG.play(SndBlip);
            blipCount++;
            FlxG.score = blipCount;
            blipText.text = blipCount.toString();
            if (FlxG.random() < 0.5) {
                turn *= -1;
            }
            // trace("blip" + blipCount + ": " + turn);
            if (blipCount % 4 == 3) {
                player.velocity.y -= 16;
                follow.velocity.y -= 16;
            }
        }
    }
}
