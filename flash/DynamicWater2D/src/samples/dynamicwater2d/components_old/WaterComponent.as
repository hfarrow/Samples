package samples.dynamicwater2d.components_old
{
	import flash.ui.Keyboard;
	import nape.geom.Vec2;
	import quadra.input.KeyBinding;
	import quadra.scene.Entity;
	import quadra.scene.EntityAttributeNumber;
	import quadra.scene.EntityAttributeObject;
	import quadra.scene.IEntityComponent;
	import samples.dynamicwater2d.Game;
	import samples.dynamicwater2d.Particle;
	import samples.dynamicwater2d.Spring;
	

	public class WaterComponent implements IEntityComponent
	{
		private var _entity:Entity;
		private var _particleSystem:ParticleSystemComponent;
		
		private var _springs:Vector.<Spring>
		private var _springsAttribute:EntityAttributeObject;
		private var _tension:EntityAttributeNumber;
		private var _dampening:EntityAttributeNumber;
		private var _spread:EntityAttributeNumber;
		private var _springSpacing:EntityAttributeNumber;
		private var _depth:EntityAttributeNumber;
		private var _numSprings:int;
		private var _timeCounter:Number = 0;
		
		private var _splashBinding:KeyBinding;
		
		public function WaterComponent(numSprings:int, springSpacing:Number, depth:Number, tension:Number=.025, dampening:Number=.025, spread:Number=.25)
		{
			_numSprings = numSprings;
			
			_tension = new EntityAttributeNumber("waterTension", tension, this, true);
			_dampening = new EntityAttributeNumber("waterDampening", dampening, this, true);
			_spread = new EntityAttributeNumber("waterSpread", spread, this, true);
			_springSpacing = new EntityAttributeNumber("waterSpringSpacing", springSpacing, this, true);
			_depth = new EntityAttributeNumber("waterDepth", depth, this, true);
		}
		
		public function init():void 
		{
			_particleSystem = _entity.getComponent(ParticleSystemComponent) as ParticleSystemComponent;
			
			_splashBinding = new KeyBinding(Keyboard.SPACE);
			
			initSprings(_numSprings);
			_springsAttribute = _entity.createAttributeObject("waterSprings", _springs, this, true);
			_entity.addAttribute(_tension);
			_entity.addAttribute(_dampening);
			_entity.addAttribute(_spread);
			_entity.addAttribute(_springSpacing);
			_entity.addAttribute(_depth);
		}
		
		private function initSprings(numSprings:int):void
		{
			_springs = new Vector.<Spring>();
			for (var i:int = 0; i < numSprings; ++i)
			{
				var spring:Spring = new Spring(0);				
				_springs.push(spring);
			}
		}
		
		public function destroy():void 
		{
			_splashBinding = null;
			_springs = null;
			_entity.removeAttribute(_springsAttribute);
			_entity.removeAttribute(_tension);
			_entity.removeAttribute(_dampening);
			_entity.removeAttribute(_spread);
			_entity.removeAttribute(_springSpacing);
			_entity.removeAttribute(_depth);
		}
		
		public function get type():Class 
		{
			return WaterComponent;
		}
		
		public function get entity():Entity 
		{
			return _entity;
		}
		
		public function set entity(value:Entity):void 
		{
			_entity = value;
		}
		
		public function splash(x:Number, speed:Number):void
		{
			var index:int = int(x / Game.SPRING_SPACING);
			splashAtSpring(index, speed);
			splashAtSpring(index + 1, speed);
			splashAtSpring(index - 1, speed);			
			createSplashParticles(x, speed);
		}
		
		public function splashAtSpring(index:int, speed:Number):void
		{
			if (isValidIndex(index))
			{
				_springs[index].speed = speed;
			}
		}
		
		public function createSplashParticles(x:Number, speed:Number):void
		{
			var y:Number = getHeightAtSpring(x);
			if (speed < 0)
			{
				for (var i:int = 0; i < int(Math.abs(speed)) / 2; ++i)
				{
					var randomX:Number = Math.random() * 20 - 10;
					var randomY:Number = -Math.random() * 20 - 10;
					var velX:Number = Math.random() * 10 - 5;
					var velY:Number = -Math.sqrt(Math.abs(speed))-4;
					_particleSystem.addParticle(new Particle(new Vec2(x + randomX, y + randomY), new Vec2(velX, velY), 0));
				}
			}
		}
		
		public function getHeightAtSpring(x:Number):Number
		{
			var index:int = int(x / Game.SPRING_SPACING);
			if (isValidIndex(index))
			{
				return _springs[index].position;
			}
			else
			{
				return 0;
			}
		}
		
		public function isValidIndex(index:int):Boolean
		{
			return index >= 0 && index < _springs.length;
		}
		
		public function update(elapsedTime:Number):void 
		{
			if (_splashBinding.isButtonJustPressed())
			{
				splash(740/2, -50);
			}
			
			spawnFallingWater(elapsedTime);
			updateSprings();
		}
		
		private function spawnFallingWater(elapsedTime:Number):void
		{
			var y:Number;
			var x:Number;
			x = Game.current.lastX;
			y = Game.current.lastY - 250;
			if (isNaN(x))
			{
				x = 760 / 2;
				y = -100;
			}
			_timeCounter += elapsedTime;
			
			if (_timeCounter > 0.02)
			{
				_timeCounter = 0;
				for (var i:int = 0; i < 1; ++i)
				{
					var randomX:Number = Math.random() * 10 - 5;
					var randomY:Number = -Math.random() * 10 - 5;
					var velX:Number = Math.random() * 5 - 2.5;
					var velY:Number = Math.random() * -10;
					_particleSystem.addParticle(new Particle(new Vec2(x + randomX, y + randomY), new Vec2(velX, velY), 0));
				}
			}
		}
		
		private var lDeltas:Array = new Array();
		private var rDeltas:Array = new Array();
		private function updateSprings():void
		{
			var i:int
			for (i = 0; i < _springs.length; ++i)
			{
				_springs[i].update(_dampening.value, _tension.value);
			}
			
			// do some passes where columns pull on their neighbours
			for (var j:int = 0; j < 8; ++j)
			{
				for (i = 0; i < _springs.length; ++i)
				{
					if (i > 0)
					{
						lDeltas[i] = _spread.value * (_springs[i].position - _springs[i - 1].position);
						_springs[i - 1].speed += lDeltas[i];
					}
					if (i < _springs.length - 1)
					{
						rDeltas[i] = _spread.value * (_springs[i].position - _springs[i + 1].position);
						_springs[i + 1].speed += rDeltas[i];
					}
				}

				for (i = 0; i < _springs.length; i++)
				{
					if (i > 0)
						_springs[i - 1].position += lDeltas[i];
					if (i < _springs.length - 1)
						_springs[i + 1].position += rDeltas[i];
				}
			}
		}
	}
}