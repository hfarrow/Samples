package samples.dynamicwater2d.components
{
	import quadra.world.IEntityComponent;
	import samples.dynamicwater2d.display.ParticleSystemDisplay;
	import samples.dynamicwater2d.particles.Particle;
	import samples.dynamicwater2d.particles.ParticleMutator;
	import starling.textures.Texture;

	public class ParticleSystemComponent implements IEntityComponent
	{
		private var _mutators:Vector.<ParticleMutator>;
		private var _particles:Vector.<Particle>
		private var _maxParticles:uint;
		private var _numActiveParticles:uint;
		private var _display:ParticleSystemDisplay;
		
		public function ParticleSystemComponent(maxParticles:uint, texture:Texture)
		{
			_mutators = new Vector.<ParticleMutator>();
			_maxParticles = maxParticles;
			_particles = new Vector.<Particle>(_maxParticles);
			_numActiveParticles = 0;
			_display = new ParticleSystemDisplay(this, texture);
		}
		
		public function get mutators():Vector.<ParticleMutator>
		{
			return _mutators;
		}
		
		public function get particles():Vector.<Particle>
		{
			return _particles;
		}
		
		public function get numActiveParticles():uint
		{
			return _numActiveParticles;
		}
		
		public function get maxParticles():uint
		{
			return _maxParticles;
		}
		
		public function get display():ParticleSystemDisplay
		{
			return _display;
		}
		
		public function createParticle():Particle
		{
			if (_particles[_numActiveParticles] == null)
			{
				_particles[_numActiveParticles] = new Particle();
			}
			
			return _particles[_numActiveParticles++];
		}
		
		public function releaseParticle(index:uint):void
		{
			if (index >= 0 && index < _numActiveParticles)
			{
				// swap released particle with last active particle.
				var temp:Particle = _particles[index];
				_particles[index] = _particles[--_numActiveParticles];
				_particles[_numActiveParticles] = temp;
				temp.reset();
			}
		}
	}
}