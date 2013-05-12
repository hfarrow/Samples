package samples.dynamicwater2d.systems
{
	import flash.utils.getTimer;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.callbacks.Listener;
	import nape.phys.Body;
	import nape.shape.Polygon;
	import quadra.world.components.lib.NapePhysicsComponent;
	import quadra.world.components.lib.StarlingDisplayComponent;
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import quadra.world.systems.EntitySystem;
	import quadra.world.systems.lib.NapePhysicsSystem;
	import samples.dynamicwater2d.components.WaterBodyComponent;
	import samples.dynamicwater2d.display.WaterBodyDisplay;
	import samples.dynamicwater2d.events.Callbacks;
	import samples.dynamicwater2d.particles.SplashEmitter;
	import samples.dynamicwater2d.Spring;
	

	public class WaterBodySystem extends EntitySystem
	{
		private static const MIN_TIME_BETWEEN_SPLASHES:int = 500;
		
		private var _splashListener:Listener;
		private var _physicsSystem:NapePhysicsSystem;
		
		public function WaterBodySystem()
		{
			super(EntityFilter.all([WaterBodyComponent]));
		}
		
		public override function init():void
		{
			_physicsSystem = NapePhysicsSystem(_world.systemManager.getSystem(NapePhysicsSystem));
			_splashListener = new InteractionListener(CbEvent.BEGIN, InteractionType.FLUID, Callbacks.SPLASHER, Callbacks.SPLASHABLE, onSplash);
			_physicsSystem.space.listeners.add(_splashListener);
		}
		
		protected override function onEntityAdded(entity:Entity):void 
		{
			var body:Body = NapePhysicsComponent(entity.getComponent(NapePhysicsComponent)).body;
			var water:WaterBodyComponent = WaterBodyComponent(entity.getComponent(WaterBodyComponent));
			var waterHalfWidth:Number = water.springSpacing * water.springs.length / 2;
			
			for (var i:int = 0; i < water.springs.length - 1; ++i)
			{
				var poly:Polygon = new Polygon(Polygon.rect(i * water.springSpacing - waterHalfWidth + water.springSpacing / 2, -water.depth / 2, water.springSpacing, water.depth, true));
				poly.filter.collisionMask = 0;
				poly.fluidEnabled = true;
				poly.filter.fluidMask = 2;
				poly.fluidProperties.density = 4;
				poly.fluidProperties.viscosity = 5;
				body.shapes.add(poly);
			}
		}
		
		protected override function onEntityRemoved(entity:Entity):void
		{
			
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elaspedTime:Number):void
		{
			var entity:Entity;
			for (var i:int = 0; i < entities.length; ++i)
			{
				entity = entities[i];
				updateShapes(entity);
				updateSprings(entity);
				updateDisplay(entity);
			}
		}
		
		private function onSplash(cb:InteractionCallback):void
		{
			var splasher:Body = cb.int1.castBody;
			var splashable:Body = cb.int2.castBody;
			
			if (splashable.userData.entity != null && splasher.userData.entity != null)
			{
				splash(splashable.userData.entity, splasher, splasher.velocity.y);
			}
		}
		
		public function splash(splashable:Entity, splasher:Body, speed:Number):void
		{
			var body:Body = NapePhysicsComponent(splashable.getComponent(NapePhysicsComponent)).body;
			var water:WaterBodyComponent = WaterBodyComponent(splashable.getComponent(WaterBodyComponent));
			var startX:Number = splasher.position.x - body.position.x + body.bounds.width / 2; // relative to water coords
			
			// Prevent a body from splashing more than once within a time frame.
			// Since the surface of the water is animated, the animation can move
			// faster than the splasher causing multiple collisions.
			var currentTime:int = getTimer();
			if (splasher.userData.lastSplash != null && currentTime - splasher.userData.lastSplash < MIN_TIME_BETWEEN_SPLASHES)
			{
				return;
			}
			splasher.userData.lastSplash = getTimer();
			splasher.velocity.y /= 2;
			
			var index:int = int(splasher.position.x / water.springSpacing);
			splashAtSpring(index, -speed / 10, water);
			splashAtSpring(index + 1, -speed / 12, water);
			splashAtSpring(index - 1, -speed / 12, water);
			splashAtSpring(index + 2, -speed / 14, water);
			splashAtSpring(index - 2, -speed / 14, water);
			SplashEmitter.emitSlpash(water.splashSystem.createParticle, splasher.position.x, water.getHeightAtSpring(splasher.position.x) + splasher.position.y + splasher.bounds.height / 2, speed);
		}
		
		public function splashAtSpring(index:int, speed:Number, water:WaterBodyComponent):void
		{
			if (isValidIndex(index, water.springs))
			{
				water.springs[index].speed = speed;
			}
		}
		
		public function isValidIndex(index:int, springs:Vector.<Spring>):Boolean
		{
			return index >= 0 && index < springs.length;
		}
		
		private function updateShapes(entity:Entity):void
		{
			var body:Body = NapePhysicsComponent(entity.getComponent(NapePhysicsComponent)).body;
			var water:WaterBodyComponent = WaterBodyComponent(entity.getComponent(WaterBodyComponent));
			var waterHalfWidth:Number = water.springSpacing * (water.springs.length-1) / 2;
			
			for (var i:int = 0; i < water.springs.length - 1; ++i)
			{				
				var poly:Polygon = Polygon(body.shapes.at(water.springs.length - 2  - i));
				poly.localVerts.at(0).y = -(water.depth / 2) - water.springs[i].position;
				poly.localVerts.at(1).y = -(water.depth / 2) - water.springs[i+1].position;
			}
		}
		
		private var lDeltas:Array = new Array(); // Helper for updateSprings
		private var rDeltas:Array = new Array(); // Helper for updateSprings
		private function updateSprings(entity:Entity):void
		{
			var waterBody:WaterBodyComponent = WaterBodyComponent(entity.getComponent(WaterBodyComponent));
			var springs:Vector.<Spring> = waterBody.springs;
			
			var i:int
			for (i = 0; i < springs.length; ++i)
			{
				springs[i].update(waterBody.dampening, waterBody.tension);
			}
			
			// do some passes where columns pull on their neighbours
			for (var j:int = 0; j < 8; ++j)
			{
				for (i = 0; i < springs.length; ++i)
				{
					if (i > 0)
					{
						lDeltas[i] = waterBody.spread * (springs[i].position - springs[i - 1].position);
						springs[i - 1].speed += lDeltas[i];
					}
					if (i < springs.length - 1)
					{
						rDeltas[i] = waterBody.spread * (springs[i].position - springs[i + 1].position);
						springs[i + 1].speed += rDeltas[i];
					}
				}
				
				for (i = 0; i < springs.length; i++)
				{
					if (i > 0)
						springs[i - 1].position += lDeltas[i];
					if (i < springs.length - 1)
						springs[i + 1].position += rDeltas[i];
				}
			}			
		}
		
		private function updateDisplay(entity:Entity):void
		{
			var waterBody:StarlingDisplayComponent = StarlingDisplayComponent(entity.getComponent(StarlingDisplayComponent));
			if (waterBody != null)
			{
				var display:WaterBodyDisplay = WaterBodyDisplay(waterBody.displayObject);
				display.update();
			}
		}
	}
}