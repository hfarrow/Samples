package samples.dynamicwater2d.particles
{
	import nape.geom.Vec2;

	public class VelocityMutator extends ParticleMutator
	{
		private var _acceleration:Vec2;
		
		public function VelocityMutator(acceleration:Vec2)
		{
			_acceleration = acceleration;
		}
		
		public override function mutate(particle:Particle, elapsedTime:Number):Boolean
		{
			particle.velocity.x += _acceleration.x * elapsedTime;
			particle.velocity.y += _acceleration.y * elapsedTime;
			
			return true;
		}
	}
}