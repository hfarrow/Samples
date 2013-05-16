package samples.dynamicwater2d
{
	import nape.geom.Vec2;

	public class Spring
	{
		public var targetPosition:Number;
		public var position:Number;
		public var speed:Number;
		public var maxPosition:Number
		
		public function Spring(targetPosition:Number, maxPosition:Number = 0)
		{
			this.targetPosition = targetPosition;
			this.maxPosition = maxPosition;
			position = targetPosition;
			speed = 0;
		}
		
		public function update(dampening:Number, tension:Number, elaspedTime:Number):void
		{
			var x:Number = targetPosition - position;
			speed += (tension * x - speed * dampening) * elaspedTime;			
			var newPosition:Number = position + speed;// * elaspedTime;
			if (maxPosition > 0)
			{
				if (newPosition > maxPosition || newPosition < -maxPosition)
				{
					speed = 0;
					return;
				}	
			}
			
			position = newPosition;
		}
	}
}