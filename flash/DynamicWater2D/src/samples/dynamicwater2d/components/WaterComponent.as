package samples.dynamicwater2d.components
{
	import flash.ui.Keyboard;
	import quadra.input.KeyBinding;
	import quadra.scene.Entity;
	import quadra.scene.EntityAttributeNumber;
	import quadra.scene.EntityAttributeObject;
	import quadra.scene.IEntityComponent;
	import samples.dynamicwater2d.Game;
	import samples.dynamicwater2d.Spring;
	

	public class WaterComponent implements IEntityComponent
	{
		private var _entity:Entity;
		
		private var _springs:Vector.<Spring>
		private var _springsAttribute:EntityAttributeObject;
		private var _tension:EntityAttributeNumber;
		private var _dampening:EntityAttributeNumber;
		private var _spread:EntityAttributeNumber;
		private var _springSpacing:EntityAttributeNumber;
		private var _depth:Number;
		private var _numSprings:int;
		
		private var _splashBinding:KeyBinding;
		
		public function WaterComponent(numSprings:int, springSpacing:Number, depth:Number, tension:Number=.025, dampening:Number=.025, spread:Number=.25)
		{
			_numSprings = numSprings;
			_depth = depth;
			_tension = new EntityAttributeNumber("waterTension", tension, this, true);
			_dampening = new EntityAttributeNumber("waterDampening", dampening, this, true);
			_spread = new EntityAttributeNumber("waterSpread", spread, this, true);
			_springSpacing = new EntityAttributeNumber("waterSpringSpacing", springSpacing, this, true);
		}
		
		public function init():void 
		{
			_splashBinding = new KeyBinding(Keyboard.SPACE);
			
			initSprings(_numSprings);
			_springsAttribute = _entity.createAttributeObject("waterSprings", _springs, this, true);
			_entity.addAttribute(_tension);
			_entity.addAttribute(_dampening);
			_entity.addAttribute(_spread);
			_entity.addAttribute(_springSpacing);
		}
		
		private function initSprings(numSprings:int):void
		{
			_springs = new Vector.<Spring>();
			for (var i:int = 0; i < numSprings; ++i)
			{
				var position:Number = _depth;
				var spring:Spring = new Spring(position);				
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
			var spring:Spring;
			if (index >= 0 && index < _springs.length)
			{
				_springs[index].speed = speed;
			}
		}
		
		public function update(elapsedTime:Number):void 
		{
			if (_splashBinding.isButtonPressed())
			{
				splash(740/2, -30);
			}
			
			updateSprings();
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