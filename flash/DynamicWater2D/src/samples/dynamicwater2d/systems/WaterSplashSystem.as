package samples.dynamicwater2d.systems
{
	import quadra.world.systems.GroupSystem;
	import samples.dynamicwater2d.Group;	

	public class WaterSplashSystem extends GroupSystem
	{
		public function WaterSplashSystem()
		{
			super(Group.SPLASHERS);
		}
		
		public override function processEntities(entities:Vector.<Entity>, elaspedTime:Number):void
		{
			for (var i:int = 0; i < entities.length; ++i)
			{
				
			}
		}
	}
}