package samples.dynamicwater2d.systems
{
	import quadra.world.lib.components.StarlingDisplayComponent;
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import quadra.world.systems.EntitySystem;	
	import samples.dynamicwater2d.components.ParticleSystemComponent;
	import samples.dynamicwater2d.display.ParticleSystemDisplay;
	import samples.dynamicwater2d.particles.Particle;
	import samples.dynamicwater2d.particles.ParticleMutator;

	public class ParticleSystem extends EntitySystem
	{
		public function ParticleSystem()
		{
			super(EntityFilter.all([ParticleSystemComponent]));
		}
		
		protected override function onEntityAdded(entity:Entity):void 
		{
			
		}
		
		protected override function onEntityRemoved(entity:Entity):void
		{
			
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elaspedTime:Number):void
		{
			var entity:Entity;
			var system:ParticleSystemComponent;
			var particles:Vector.<Particle>;
			var mutators:Vector.<ParticleMutator>;
			var display:ParticleSystemDisplay;
			for (var i:int = 0; i < entities.length; ++i)
			{
				entity = entities[i];
				system = ParticleSystemComponent(entity.getComponent(ParticleSystemComponent));
				particles = system.particles;
				mutators = system.mutators;
				display = StarlingDisplayComponent(entity.getComponent(StarlingDisplayComponent)).displayObject as ParticleSystemDisplay;
				
				if (display != null)
				{
					display.reset();
				}
				
				for (var j:int = 0; j < system.numActiveParticles; ++j)
				{
					var removed:Boolean = false;
					for (var k:int = 0; k < mutators.length; ++k)
					{
						if (!mutators[k].mutate(particles[j], elaspedTime))
						{
							system.releaseParticle(j);
							
							// current index will be replaced with a new particle to process
							// and numActiveParticles will be decreased.
							j--;
							removed = true;
						}
					}
					
					if (!removed && display != null)
					{
						display.addParticle(particles[j]);
					}
				}
			}
		}
	}
}