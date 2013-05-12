package samples.dynamicwater2d.particles
{
	import nape.geom.Vec2;

	public class Particle
	{
		public var position:Vec2;
		public var velocity:Vec2;
		public var acceleration:Vec2;
		public var rotation:Number;
		public var color:uint;
		public var scale:int;
		
		public function Particle(position:Vec2 = null, velocity:Vec2 = null, acceleration:Vec2 = null, rotation:Number = 0, color:uint = 0xffffffff, scale:int = 1)
		{
			this.rotation = rotation;
			this.velocity = velocity;
			this.acceleration = acceleration;
			this.position = position;
			this.color = color;
			
			if (this.position == null)
			{
				this.position = new Vec2();
			}
			
			if (this.velocity == null)
			{
				this.velocity = new Vec2();
			}
			
			if (this.acceleration == null)
			{
				this.acceleration = new Vec2();
			}
		}
		
		public function reset():void
		{
			position.setxy(0, 0);
			velocity.setxy(0, 0);
			acceleration.setxy(0, 0);
			rotation = 0;
			color = 0xffffffff;
			scale = 1;
		}
	}
}