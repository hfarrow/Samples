package samples.dynamicwater2d.particles
{

	public class ParticleEmitter
	{
		public function ParticleEmitter()
		{
			
		}
		
		public function update(elapsedTime:Number):void
		{
			// override this
		}
		
		public function emit(createFunction:Function):void
		{
			// override this
		}
	}
}