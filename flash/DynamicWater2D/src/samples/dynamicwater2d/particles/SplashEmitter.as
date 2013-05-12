package samples.dynamicwater2d.particles
{
	import nape.geom.Vec2;

	public class SplashEmitter
	{		
		public static function emitSlpash(createFunction:Function, x:Number, y:Number, speed:Number):void
		{
			if (speed > 0)
			{
				for (var i:int = 0; i < int(Math.abs(speed)) / 8; ++i)
				{
					var randomX:Number = Math.random() * 20 - 10;
					var randomY:Number = -Math.random() * 20 - 10;
					var velX:Number = Math.random() * 100 - 50;
					var velY:Number = -speed / 1.5;
					var particle:Particle = createFunction();
					particle.position.setxy(x + randomX, y + randomY);
					particle.velocity.setxy(velX, velY);
					particle.scale = 1.5;
				}
			}
		}
	}
}