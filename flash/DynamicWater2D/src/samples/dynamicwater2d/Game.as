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
	import samples.dynamicwater2d.components.ParticleSystemComponent;
	import samples.dynamicwater2d.components.WaterBodyComponent;
	import samples.dynamicwater2d.display.ParticleSystemDisplay;
	import samples.dynamicwater2d.display.WaterBodyDisplay;
	import samples.dynamicwater2d.events.Callbacks;
	import samples.dynamicwater2d.particles.PositionMutator;
	import samples.dynamicwater2d.particles.SplashLifeMutator;
	import samples.dynamicwater2d.particles.VelocityMutator;
	import samples.dynamicwater2d.systems.InputSystem;
	import samples.dynamicwater2d.systems.MetaballRendererSystem;
	import samples.dynamicwater2d.systems.ParticleSystem;
	import samples.dynamicwater2d.systems.WaterBodySystem;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Game extends QuadraSample
	{
		public static const NUM_SPRINGS:int = 51;
		public static const SPRING_SPACING:Number = 14.8;
		public static const WATER_DEPTH:Number = 240;
		
		[Embed(source = "../../../content/metaparticle.png")]
		private var DropletTexture:Class;
		private var _dropletTexture:Texture;
		
		[Embed(source = "../../../content/sky.png")]
		private var SkyTexture:Class;
		private var _skyTexture:Texture;
		
		public static var current:Game;
		
		private var _sky:Entity;
		private var _water:Entity;
		private var _waterSurface:Entity;
		private var _rock:Entity;
		private var _particleSystem:Entity;
		
		public function Game()
		{
			Game.current = this;
			Starling.current.enableErrorChecking = true;
		}
		
		protected override function init():void
		{
			initWorld();
			initSky();
			initParticleSystem();
			initWater();
		}
		
		private function initWorld():void
		{
			world.systemManager.addSystem(new NapePhysicsSystem(false, new Vec2(0, 300)));
			world.systemManager.addSystem(new WaterBodySystem());
			world.systemManager.addSystem(new InputSystem());
			world.systemManager.addSystem(new ParticleSystem());
			world.systemManager.addSystem(new StarlingRenderSystem(this));
			world.systemManager.addSystem(new MetaballRendererSystem()); // must be after StarlingrenderSystem
		}
		
		private function initSky():void
		{
			_skyTexture = Texture.fromBitmap(new SkyTexture());
			var skyImage:Image = new Image(_skyTexture);
			skyImage.scaleX = 2;
			skyImage.scaleY = 2;
			
			_sky = world.createEntity();
			_sky.addComponent(new SpatialComponent());
			_sky.addComponent(new StarlingDisplayComponent(skyImage, -1, true));
			_sky.refresh();
		}
		
		private function initParticleSystem():void
		{
			_dropletTexture = Texture.fromBitmap(new DropletTexture());
			
			_particleSystem = world.createEntity();
			var system:ParticleSystemComponent = new ParticleSystemComponent(1000);
			system.mutators.push(new VelocityMutator(new Vec2(0, 250)));
			system.mutators.push(new PositionMutator());
			system.mutators.push(new SplashLifeMutator(stage.stageHeight / 2 + 0));
			_particleSystem.addComponent(system);
			_particleSystem.addComponent(new StarlingDisplayComponent(new ParticleSystemDisplay(system, _dropletTexture)));
			_particleSystem.addToGroup(Group.METABALLS);
			_particleSystem.refresh();
		}
		
		private function initWater():void
		{
			var waterBody:Body = new Body(BodyType.KINEMATIC);
			waterBody.position.x = stage.stageWidth / 2;
			waterBody.position.y = stage.stageHeight - stage.stageHeight / 4;
			waterBody.cbTypes.add(Callbacks.SPLASHABLE);
			
			_water = world.createEntity();
			var waterBodyCmp:WaterBodyComponent = new WaterBodyComponent(NUM_SPRINGS, SPRING_SPACING, stage.stageHeight / 2, .2, .025, .025);
			waterBodyCmp.splashSystem = ParticleSystemComponent(_particleSystem.getComponent(ParticleSystemComponent));
			_water.addComponent(waterBodyCmp);
			_water.addComponent(new SpatialComponent());
			_water.addComponent(new VelocityComponent());
			_water.addComponent(new NapePhysicsComponent(waterBody));
			var waterBodyDisplay:WaterBodyDisplay = new WaterBodyDisplay(_water);
			waterBodyDisplay.alpha = 0.75;
			var display:StarlingDisplayComponent = new StarlingDisplayComponent(waterBodyDisplay, 10);
			display.displayObject.pivotX = stage.stageWidth / 2;
			display.displayObject.pivotY = stage.stageHeight / 4;			
			_water.addComponent(display);
			_water.refresh();
			
			// Water surface must be separate entity so that it can be rendered to the metaball texture.
			_waterSurface = world.createEntity();
			_waterSurface.addToGroup(Group.METABALLS);
			_waterSurface.addComponent(new StarlingDisplayComponent(waterBodyDisplay.waterSurfaceDisplay));
			_waterSurface.refresh();
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