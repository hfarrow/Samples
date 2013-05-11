package samples.dynamicwater2d.components_old
{
	import nape.geom.Vec2;
	import quadra.scene.Entity;
	import quadra.scene.IEntityComponent;
	import samples.dynamicwater2d.Particle;
	import starling.core.Starling;
	

	public class ParticleSystemComponent implements IEntityComponent
	{		
		private var _entity:Entity;
		private var _particles:Vector.<Particle>
		public var gravity:Number = .7;
		
		public function ParticleSystemComponent()
		{		
			
		}
		
		public function init():void 
		{
			_particles = new Vector.<Particle>
		}
		
		public function destroy():void 
		{
			_particles = null;
		}
		
		public function get type():Class 
		{
			return ParticleSystemComponent;
		}
		
		public function get entity():Entity 
		{
			return _entity;
		}
		
		public function set entity(value:Entity):void 
		{
			_entity = value;
		}
		
		public function get particles():Vector.<Particle>
		{
			return _particles;
		}
		
		public function addParticle(particle:Particle):void
		{
			_particles.push(particle);
		}
		
		public function update(elapsedTime:Number):void 
		{
			for (var i:int = 0; i < _particles.length; ++i)
			{
				var particle:Particle = _particles[i];
				particle.velocity.y += gravity;
				particle.position = particle.position.add(particle.velocity);
				//particle.rotation = getAngle(particle.velocity);
				
				if (particle.position.y > 20)
				{
					_particles.splice(i, 1);
					i--;
				}
			}
		}
		
		private function getAngle(velocity:Vec2):Number
		{
			return Math.atan2(velocity.y, velocity.x);
		}
	}
}