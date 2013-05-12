package samples.dynamicwater2d
{
	import nape.geom.Vec2;

	public class Spring
	{
		public var targetPosition:Number;
		public var position:Number;
		public var speed:Number;
		
		public function Spring(targetPosition:Number)
		{
			this.targetPosition = targetPosition;
			position = targetPosition;
			speed = 0;
		}
		
		public function update(dampening:Number, tension:Number, elaspedTime:Number):void
		{
			var x:Number = targetPosition - position;
			speed += (tension * x - speed * dampening) * elaspedTime;
			position += speed * elaspedTime;
		}
	}
}