package samples.dynamicwater2d.display
{
	import samples.dynamicwater2d.components.ParticleSystemComponent;
	import samples.dynamicwater2d.particles.Particle;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.textures.Texture;
	

	public class ParticleSystemDisplay extends QuadBatch
	{
		private var _system:ParticleSystemComponent
		private var _particleImage:Image
		
		public function ParticleSystemDisplay(system:ParticleSystemComponent, texture:Texture)
		{
			_system = system;
			_particleImage = new Image(texture);		
		}
		
		public function addParticle(particle:Particle):void
		{
			_particleImage.x = particle.position.x;
			_particleImage.y = particle.position.y;
			_particleImage.rotation = particle.rotation;
			_particleImage.color = particle.color & 0xffffff;
			_particleImage.alpha = ((particle.color >> 24) & 0xff) / 255;
			_particleImage.scaleX = _particleImage.scaleY = particle.scale;
			addImage(_particleImage);
		}
	}
}