package samples.dynamicwater2d.systems
{
	import flash.geom.Point;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import quadra.core.QuadraGame;
	import quadra.world.components.lib.NapePhysicsComponent;
	import quadra.world.components.lib.SpatialComponent;
	import quadra.world.components.lib.StarlingDisplayComponent;
	import quadra.world.components.lib.VelocityComponent;
	import quadra.world.Entity;
	import quadra.world.systems.ProcessingSystem;
	import samples.dynamicwater2d.events.Callbacks;
	import samples.dynamicwater2d.Game;
	import samples.dynamicwater2d.Group;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class InputSystem extends ProcessingSystem
	{
		[Embed(source="../../../../content/rock.png")]
		private var RockTexture:Class;
		private var _rockTexture:Texture;
		
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
				//trace("Touched object at position: " + localPos);
				initRock(localPos);
			}
			
			touch = event.getTouch(Game.current.stage, TouchPhase.HOVER);
			if (touch)
			{
				//localPos = touch.getLocation(this);
				//lastX = localPos.x;
				//lastY = localPos.y;
			}
		}
		
		private function initRock(localPos:Point):void
		{
			_rockTexture = Texture.fromBitmap(new RockTexture());
			var rockImage:Image = new Image(_rockTexture);
			var rockBody:Body = new Body(BodyType.DYNAMIC);
			var shape:Shape = new Polygon(Polygon.box(rockImage.width, rockImage.height));
			shape.material.density = 2;
			shape.filter.fluidGroup = 2;
			rockBody.shapes.add(shape);
			rockBody.position.setxy(QuadraGame.current.stage.stageWidth / 2, 100);
			rockBody.cbTypes.add(Callbacks.SPLASHER);
			rockBody.position.setxy(localPos.x, localPos.y);
			rockBody.velocity.setxy(0, 0);
			
			var rock:Entity = world.createEntity();
			rock.addComponent(new SpatialComponent());
			rock.addComponent(new VelocityComponent());
			rock.addComponent(new NapePhysicsComponent(rockBody));
			rock.addComponent(new StarlingDisplayComponent(rockImage, 0, true));
			rock.addToGroup(Group.SPLASHERS);
			rock.addToGroup(Group.ROCK);
			rock.refresh();
		}
	}
}