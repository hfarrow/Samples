package samples.dynamicwater2d.particles
{

	public class SplashLifeMutator extends ParticleMutator
	{
		private var _maxY:Number;
		public function SplashLifeMutator(maxY:Number)
		{
			_maxY = maxY;
		}
		
		public override function mutate(particle:Particle, elapsedTime:Number):Boolean
		{	
			return particle.position.y <= _maxY;
		}
	}
}