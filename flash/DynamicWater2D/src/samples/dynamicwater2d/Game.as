package samples.dynamicwater2d 
{
	import flash.ui.Keyboard;
	import quadra.core.QuadraSample;
	import quadra.input.KeyBinding;
	import quadra.scene.components.QuadComponent;
	import quadra.scene.Entity;
	
	public class Game extends QuadraSample
	{
		public static const NUM_SPRINGS:int = 50;
		public static const SPRING_SPACING:Number = 15;
		
		public static var current:Game;
		
		private var _springs:Vector.<Spring>;
		private var _tension:Number = 0.025;
		private var _dampening:Number = 0.025;
		private var _spread:Number = 0.25;
		
		private var _splashBinding:KeyBinding;
		
		public function Game()
		{
			Game.current = this;
			
			_splashBinding = new KeyBinding(Keyboard.SPACE);
		}
		
		protected override function init():void
		{
			initSprings();
		}
		
		private function initSprings():void
		{
			_springs = new Vector.<Spring>();
			for (var i:int = 0; i < NUM_SPRINGS; ++i)
			{
				var position:Number = 240;
				var spring:Spring = new Spring(position);
				
				var quad:QuadComponent = new QuadComponent(5, 5, 0x0000ff);
				var entity:Entity = scene.createEntity([quad]);
				entity.y = position;
				entity.x = i * SPRING_SPACING;
				spring.entity = entity;
				
				_springs.push(spring);
			}
		}
		
		protected override function update(elaspedTime:Number):void
		{
			if (_splashBinding.isButtonJustPressed())
			{
				splash(250, 200);
			}
			
			updateSprings();
		}
		
		public function getHeight(x:Number):Number
		{
			var index:int = int(x / SPRING_SPACING);
			var spring:Spring;
			if (index < 0 || index >= _springs.length)
			{
				return _springs[0].targetPosition;
			}
			
			spring = _springs[index];
			
			return spring.position;
		}
		
		public function splash(x:Number, speed:Number):void
		{
			var index:int = int(x / SPRING_SPACING);
			var spring:Spring;
			if (index >= 0 && index < _springs.length)
			{
				_springs[index].speed = speed;
			}
		}
		
		private var lDeltas:Array = new Array();
		private var rDeltas:Array = new Array();
		public function updateSprings():void
		{
			var i:int
			for (i = 0; i < _springs.length; ++i)
			{
				_springs[i].update(_dampening, _tension);
			}
			
			// do some passes where columns pull on their neighbours
			for (var j:int = 0; j < 8; ++j)
			{
				for (i = 0; i < _springs.length; ++i)
				{
					if (i > 0)
					{
						lDeltas[i] = _spread * (_springs[i].position - _springs[i - 1].position);
						_springs[i - 1].speed += lDeltas[i];
					}
					if (i < _springs.length - 1)
					{
						rDeltas[i] = _spread * (_springs[i].position - _springs[i + 1].position);
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