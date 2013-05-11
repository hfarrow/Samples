package samples.dynamicwater2d 
{
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import quadra.core.QuadraSample;
	import quadra.world.components.lib.NapePhysicsComponent;
	import quadra.world.components.lib.SpatialComponent;
	import quadra.world.components.lib.StarlingDisplayComponent;
	import quadra.world.components.lib.VelocityComponent;
	import quadra.world.Entity;
	import quadra.world.systems.lib.display.StarlingRenderSystem;
	import quadra.world.systems.lib.NapePhysicsSystem;
	import samples.dynamicwater2d.components.WaterBodyComponent;
	import samples.dynamicwater2d.display.WaterBodyDisplay;
	import samples.dynamicwater2d.events.Callbacks;
	import samples.dynamicwater2d.systems.InputSystem;
	import samples.dynamicwater2d.systems.ParticleSystem;
	import samples.dynamicwater2d.systems.WaterBodySystem;
	import samples.dynamicwater2d.systems.WaterSplashSystem;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	
	// TODO:
	// Splash system extends GroupSystem
	//		-Processes all "splashes" entities
	//		-Sets up collision detection between water and entities
	// Water needs a physics body for collision or just use spring height?
	
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
		
		public function Game()
		{
			Game.current = this;
			Starling.current.enableErrorChecking = true;
		}
		
		protected override function init():void
		{
			initWorld();
			initWater();
			initRock();
		}
		
		private function initWorld():void
		{
			world.systemManager.addSystem(new NapePhysicsSystem(true, new Vec2(0, 300)));
			world.systemManager.addSystem(new WaterBodySystem());
			world.systemManager.addSystem(new WaterSplashSystem());
			world.systemManager.addSystem(new InputSystem());
			world.systemManager.addSystem(new ParticleSystem());
			world.systemManager.addSystem(new StarlingRenderSystem(this));
		}
		
		private function initWater():void
		{
			var waterBody:Body = new Body(BodyType.KINEMATIC);
			var waterShape:Shape = new Polygon(Polygon.box(stage.stageWidth, stage.stageHeight / 2));
			waterShape.filter.collisionMask = 0;
			waterShape.fluidEnabled = true;
			waterShape.filter.fluidMask = 2;
			waterShape.fluidProperties.density = 3;
			waterShape.fluidProperties.viscosity = 2;
			waterBody.shapes.add(waterShape);
			waterBody.position.x = stage.stageWidth / 2;
			waterBody.position.y = stage.stageHeight - stage.stageHeight / 4;
			waterBody.cbTypes.add(Callbacks.SPLASHABLE);
			
			_water = world.createEntity();
			_water.addComponent(new WaterBodyComponent(NUM_SPRINGS, SPRING_SPACING, stage.stageHeight / 2, .2, .025, .025));
			_water.addComponent(new SpatialComponent());
			_water.addComponent(new VelocityComponent());
			_water.addComponent(new NapePhysicsComponent(waterBody));
			var display:StarlingDisplayComponent = new StarlingDisplayComponent(new WaterBodyDisplay(_water), 0);
			display.displayObject.pivotX = stage.stageWidth / 2;
			display.displayObject.pivotY = stage.stageHeight / 4;			
			_water.addComponent(display);
			_water.refresh();
		}
		
		
		private function initRock():void
		{
			_rockTexture = Texture.fromBitmap(new RockTexture());
			var rockImage:Image = new Image(_rockTexture);
			var rockBody:Body = new Body(BodyType.DYNAMIC);
			var shape:Shape = new Polygon(Polygon.box(rockImage.width, rockImage.height));
			shape.material.density = 10;
			shape.filter.fluidGroup = 2;
			rockBody.shapes.add(shape);
			rockBody.position.setxy(stage.stageWidth / 2, 100);
			rockBody.cbTypes.add(Callbacks.SPLASHER);
			
			_rock = world.createEntity();
			_rock.addComponent(new SpatialComponent());
			_rock.addComponent(new VelocityComponent());
			_rock.addComponent(new NapePhysicsComponent(rockBody));
			_rock.addComponent(new StarlingDisplayComponent(rockImage, -1, true));
			_rock.addToGroup(Group.SPLASHERS);
			_rock.tag = "rock";
			_rock.refresh();
		}
		
		protected override function update(elaspedTime:Number):void
		{
			super.update(elaspedTime);
			
			/*
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
			*/
		}
	}
}