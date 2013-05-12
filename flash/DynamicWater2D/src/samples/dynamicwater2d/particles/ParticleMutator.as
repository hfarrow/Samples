package samples.dynamicwater2d.particles
{

	public class ParticleMutator
	{
		public function ParticleMutator()
		{
			
		}
		
		// returns false if the particle should be released.
		public function mutate(particle:Particle, elapsedTime:Number):Boolean
		{
			// override this
			
			return true;
		}
	}
}