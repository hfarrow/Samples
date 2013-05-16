package samples.dynamicwater2d.particles
{
	import quadra.world.lib.components.SpatialComponent;
	import quadra.world.Entity;
	import samples.dynamicwater2d.components.WaterBodyComponent;

	public class SplashLifeMutator extends ParticleMutator
	{
		private var _waterEntity:Entity
		private var _waterCmp:WaterBodyComponent;
		private var _spatialCmp:SpatialComponent;
		private var _yOffset:Number;
		public function SplashLifeMutator(waterEntity:Entity, yOffset:Number=0)
		{
			_waterEntity = waterEntity;
			_waterCmp = WaterBodyComponent(_waterEntity.getComponent(WaterBodyComponent));
			_spatialCmp = SpatialComponent(_waterEntity.getComponent(SpatialComponent));
			_yOffset = yOffset;
		}
		
		public override function mutate(particle:Particle, elapsedTime:Number):Boolean
		{
			
			return particle.position.y <= _spatialCmp.y - _waterCmp.getHeightAtSpring(particle.position.x) - _yOffset;
		}
	}
}