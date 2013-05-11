package samples.dynamicwater2d.systems
{
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.callbacks.Listener;
	import nape.phys.Body;
	import quadra.core.EventManager;
	import quadra.world.components.lib.NapePhysicsComponent;
	import quadra.world.Entity;
	import quadra.world.systems.GroupSystem;
	import quadra.world.systems.lib.NapePhysicsSystem;
	import samples.dynamicwater2d.components.WaterBodyComponent;
	import samples.dynamicwater2d.events.Callbacks;
	import samples.dynamicwater2d.events.GameEvent;
	import samples.dynamicwater2d.Group;	
	import samples.dynamicwater2d.Spring;

	public class WaterSplashSystem extends GroupSystem
	{
		private var _splashListener:Listener;
		private var _physicsSystem:NapePhysicsSystem;
		
		public function WaterSplashSystem()
		{
			super(Group.SPLASHERS);
		}
		
		public override function init():void
		{
			_physicsSystem = NapePhysicsSystem(_world.systemManager.getSystem(NapePhysicsSystem));
			_splashListener = new InteractionListener(CbEvent.BEGIN, InteractionType.FLUID, Callbacks.SPLASHER, Callbacks.SPLASHABLE, onSplash);
			_physicsSystem.space.listeners.add(_splashListener);
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elaspedTime:Number):void
		{
			//for (var i:int = 0; i < entities.length; ++i)
			//{
				
			//}
		}
		
		private function onSplash(cb:InteractionCallback):void
		{
			var splasher:Body = cb.int1.castBody;
			var splashable:Body = cb.int2.castBody;
			
			if (splashable.userData.entity != null && splasher.userData.entity != null)
			{
				splash(splashable.userData.entity, splasher.position.x, splasher.velocity.y);
			}
		}
		
		public function splash(splashable:Entity, x:Number, speed:Number):void
		{
			var body:Body = NapePhysicsComponent(splashable.getComponent(NapePhysicsComponent)).body;
			var water:WaterBodyComponent = WaterBodyComponent(splashable.getComponent(WaterBodyComponent));
			var startX:Number = x - body.position.x + body.bounds.width / 2; // relative to water coords
			
			var index:int = int(x / water.springSpacing);
			splashAtSpring(index, -speed / 8, water);
			splashAtSpring(index + 1, -speed / 8, water);
			splashAtSpring(index - 1, -speed / 8, water);			
			//createSplashParticles(x, speed);
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
	}
}