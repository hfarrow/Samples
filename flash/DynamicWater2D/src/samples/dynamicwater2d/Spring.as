package samples.dynamicwater2d
{
	import nape.geom.Vec2;
	import quadra.scene.Entity;

	public class Spring
	{
		public var entity:Entity;
		public var targetPosition:Number;
		public var position:Number;
		public var speed:Number;
		
		public function Spring(targetPosition:Number)
		{
			this.targetPosition = targetPosition;
			position = targetPosition;
			speed = 0;
		}
		
		public function update(dampening:Number, tension:Number):void
		{
			var x:Number = targetPosition - position;
			speed += tension * x - speed * dampening;
			position += speed;
			entity.y = position;
		}
	}
}