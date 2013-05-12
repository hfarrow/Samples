package samples.dynamicwater2d.components
{
	import quadra.world.IEntityComponent;
	import samples.dynamicwater2d.Spring;
	

	public class WaterBodyComponent implements IEntityComponent
	{
		public var splashSystem:ParticleSystemComponent;
		private var _springs:Vector.<Spring>
		private var _tension:Number;
		private var _dampening:Number;
		private var _spread:Number;
		private var _springSpacing:Number;
		private var _depth:Number;
		
		public function WaterBodyComponent(numSprings:int, springSpacing:Number, depth:Number, tension:Number=.025, dampening:Number=.025, spread:Number=.25)
		{
			_springSpacing = springSpacing;
			_depth = depth;
			_tension = tension;
			_dampening = dampening;
			_spread = spread;			
			
			_springs = new Vector.<Spring>(numSprings, true);
			for ( var i:int = 0; i < numSprings; ++i)
			{
				_springs[i] = new Spring(0);
			}
		}
		
		public function get springs():Vector.<Spring>
		{
			return _springs;
		}
		
		public function get tension():Number
		{
			return _tension;
		}
		
		public function get dampening():Number
		{
			return _dampening;
		}
		
		public function get spread():Number
		{
			return _spread;
		}
		
		public function get springSpacing():Number
		{
			return _springSpacing;
		}
		
		public function get depth():Number
		{
			return _depth;
		}
		
		public function getHeightAtSpring(x:Number):Number
		{
			var index:int = int(x / _springSpacing);
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
	}
}