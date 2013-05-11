package samples.dynamicwater2d.systems
{
	import quadra.world.EntityFilter;
	import quadra.world.systems.EntitySystem;	
	import samples.dynamicwater2d.components.ParticleSystemComponent;

	public class ParticleSystem extends EntitySystem
	{
		public function ParticleSystem()
		{
			super(EntityFilter.all([ParticleSystemComponent]));
		}
	}
}