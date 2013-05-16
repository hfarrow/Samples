package samples.dynamicwater2d.systems
{
	import quadra.world.Entity;
	import quadra.world.systems.GroupSystem;
	import samples.dynamicwater2d.Group;
	

	public class RockSystem extends GroupSystem
	{
		public function RockSystem()
		{
			super(Group.ROCK);
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elaspedTime:Number):void
		{			
			while (entities.length > 7)
			{
				entities[0].removeFromWorld();
			}
		}
	}
}