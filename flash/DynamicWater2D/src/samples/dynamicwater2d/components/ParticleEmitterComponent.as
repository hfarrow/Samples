package samples.dynamicwater2d.components
{
	import quadra.world.IEntityComponent;
	import samples.dynamicwater2d.particles.ParticleEmitter;
	

	public class ParticleEmitterComponent implements IEntityComponent
	{
		private var _emitters:Vector.<ParticleEmitter>;
		
		public function ParticleEmitterComponent(emitters:Vector.<ParticleEmitter>)
		{
			_emitters = emitters;
		}
		
		public function get emitters():Vector.<ParticleEmitter>
		{
			return _emitters;
		}
	}
}