package samples.dynamicwater2d.systems
{
	import nape.phys.Body;
	import quadra.world.components.lib.NapePhysicsComponent;
	import quadra.world.components.lib.StarlingDisplayComponent;
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import quadra.world.systems.EntitySystem;
	import samples.dynamicwater2d.components.WaterBodyComponent;
	import samples.dynamicwater2d.display.WaterBodyDisplay;
	import samples.dynamicwater2d.events.GameEvent;
	import samples.dynamicwater2d.Game;
	import samples.dynamicwater2d.Spring;
	import starling.events.Event;
	

	public class WaterBodySystem extends EntitySystem
	{
		public function WaterBodySystem()
		{
			super(EntityFilter.all([WaterBodyComponent]));
		}
		
		protected override function onEntityAdded(entity:Entity):void 
		{
			
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
				updateSprings(entity);
				updateDisplay(entity);
			}
		}
		
		/*
		public override function update(elapsedTime:Number):void
		{			
			super.update(elapsedTime);
		}
		*/
		
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
			var display:WaterBodyDisplay = WaterBodyDisplay(waterBody.displayObject);
			display.update();
		}
	}
}