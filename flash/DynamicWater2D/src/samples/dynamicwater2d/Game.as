package samples.dynamicwater2d 
{
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import nape.geom.GeomPoly;
	import nape.geom.Vec2;
	import quadra.core.QuadraSample;
	import quadra.display.Polygon;
	import quadra.input.KeyBinding;
	import quadra.scene.components.ImageComponent;
	import quadra.scene.components.QuadComponent;
	import quadra.scene.Entity;
	import samples.dynamicwater2d.components.ParticleSystemComponent;
	import samples.dynamicwater2d.components.WaterComponent;
	import samples.dynamicwater2d.components.WaterDisplayComponent;
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class Game extends QuadraSample
	{
		public static const NUM_SPRINGS:int = 50;//50
		public static const SPRING_SPACING:Number = 16;//16
		public static const WATER_DEPTH:Number = 240;
		
		[Embed(source = "../../../content/rock.png")]
		private var RockTexture:Class;
		private var _rockTexture:Texture;
		
		public static var current:Game;
		
		private var _water:Entity;
		private var _rock:Entity;
		private var _isDroppingRock:Boolean = false;
		
		public var lastX:Number;
		public var lastY:Number;
		
		public function Game()
		{
			Game.current = this;
			Starling.current.enableErrorChecking = true;
		}
		
		protected override function init():void
		{			
			initRock();
			initWater();
			
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function initRock():void
		{
			_rockTexture = Texture.fromBitmap(new RockTexture());
			var rock:ImageComponent = new ImageComponent(_rockTexture);
			_rock = scene.createEntity([rock]);
			_rock.pivotX = _rock.width / 2;
			_rock.pivotY = _rock.height / 2;
			_rock.x = stage.stageWidth / 2;
			_isDroppingRock = true;
		}
		
		private function initWater():void
		{
			var particles:ParticleSystemComponent = new ParticleSystemComponent();
			var water:WaterComponent = new WaterComponent(NUM_SPRINGS, SPRING_SPACING, WATER_DEPTH, .2, .025, .025);
			var display:WaterDisplayComponent = new WaterDisplayComponent();
			_water = scene.createEntity([particles, water, display]);
			_water.y = stage.stageHeight / 2;
		}
		
		protected override function update(elaspedTime:Number):void
		{
			super.update(elaspedTime);
			
			var oldY:Number = _rock.y;
			_rock.y += 250 * elaspedTime
			if (_isDroppingRock)
			{
				var water:WaterComponent = _water.getComponent(WaterComponent) as WaterComponent;;
				if (_rock.y > _water.y + water.getHeightAtSpring(_rock.x))
				{
					_isDroppingRock = false;
					water.splash(_rock.x, -50);
					_rock.visible = false;
				}
			}
			
			var boundry:Number = stage.height + _rock.height / 2;
			if (_rock.y > boundry)
			{
				_rock.y = boundry;
			}
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN);
			if (touch)
			{
				var localPos:Point = touch.getLocation(this);
				
				trace("Touched object at position: " + localPos);
				if (!_isDroppingRock)
				{
					_rock.visible = true;
					_isDroppingRock = true;
					_rock.x = localPos.x;
					_rock.y = localPos.y;
				}
			}
			
			touch = event.getTouch(stage, TouchPhase.HOVER);
			if (touch)
			{
				localPos = touch.getLocation(this);
				lastX = localPos.x;
				lastY = localPos.y;
			}
		}
	}
}