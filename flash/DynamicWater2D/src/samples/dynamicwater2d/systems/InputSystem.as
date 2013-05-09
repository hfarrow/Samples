package samples.dynamicwater2d.systems
{
	import quadra.core.EventManager;
	import quadra.core.QuadraGame;
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
			var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN);
			if (touch)
			{
				var localPos:Point = touch.getLocation(this);				
				trace("Touched object at position: " + localPos);
				
				EventManager.global.dispatchEventWith(GameEvent.DROP_ROCK, localPos);
				
				//if (!_isDroppingRock)
				//{
					//_rock.visible = true;
					//_isDroppingRock = true;
					//_rock.x = localPos.x;
					//_rock.y = localPos.y;
				//}
			}
			
			touch = event.getTouch(stage, TouchPhase.HOVER);
			if (touch)
			{
				//localPos = touch.getLocation(this);
				//lastX = localPos.x;
				//lastY = localPos.y;
			}
		}
	}
}