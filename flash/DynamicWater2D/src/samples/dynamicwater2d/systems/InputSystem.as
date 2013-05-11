package samples.dynamicwater2d.systems
{
	import flash.geom.Point;
	import nape.phys.Body;
	import quadra.core.EventManager;
	import quadra.core.QuadraGame;
	import quadra.world.components.lib.NapePhysicsComponent;
	import quadra.world.Entity;
	import quadra.world.systems.ProcessingSystem;
	import samples.dynamicwater2d.events.GameEvent;
	import samples.dynamicwater2d.Game;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	

	public class InputSystem extends ProcessingSystem
	{
		public function InputSystem()
		{
			QuadraGame.current.stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		protected override function process(elapsedTime:Number):void
		{
			
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(Game.current.stage, TouchPhase.BEGAN);
			if (touch)
			{
				var localPos:Point = touch.getLocation(Game.current);				
				trace("Touched object at position: " + localPos);
				
				var rock:Entity = world.tagManager.getTag("rock");
				var body:Body = NapePhysicsComponent(rock.getComponent(NapePhysicsComponent)).body;
				body.position.setxy(localPos.x, localPos.y);
				body.velocity.setxy(0, 0);
				
				//if (!_isDroppingRock)
				//{
					//_rock.visible = true;
					//_isDroppingRock = true;
					//_rock.x = localPos.x;
					//_rock.y = localPos.y;
				//}
			}
			
			touch = event.getTouch(Game.current.stage, TouchPhase.HOVER);
			if (touch)
			{
				//localPos = touch.getLocation(this);
				//lastX = localPos.x;
				//lastY = localPos.y;
			}
		}
	}
}