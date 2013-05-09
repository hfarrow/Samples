package entityworldsample
{
	import quadra.world.Entity;
	import quadra.world.systems.GroupSystem;
	

	public class TestGroupSystem extends GroupSystem
	{
		public function TestGroupSystem()
		{
			super(5);
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elapsedTime:Number):void
		{
			for (var i:int = 0; i < entities.length; ++i)
			{
				//trace("TestGroupSystem processing " + entities[i].id);
			}
		}
	}
}