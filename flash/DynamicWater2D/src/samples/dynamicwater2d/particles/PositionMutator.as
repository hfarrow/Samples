package samples.dynamicwater2d.particles
{
	// Applies acceleration and velocity to position.
	public class PositionMutator extends ParticleMutator
	{
		public function PositionMutator()
		{
			
		}
		
		public override function mutate(particle:Particle, elapsedTime:Number):Boolean
		{
			particle.velocity.x += particle.acceleration.x * elapsedTime;
			particle.velocity.y += particle.acceleration.y * elapsedTime;
			particle.position.x += particle.velocity.x * elapsedTime;
			particle.position.y += particle.velocity.y * elapsedTime;
			
			return true;
		}
	}
}