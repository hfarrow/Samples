package samples.dynamicwater2d.particles
{
	import nape.geom.Vec2;

	public class Particle
	{
		public var position:Vec2;
		public var velocity:Vec2;
		public var rotation:Number;
		
		public function Particle(position:Vec2, velocity:Vec2, rotation:Number)
		{
			this.rotation = rotation;
			this.velocity = velocity;
			this.position = position;
		}
	}
}