package samples.dynamicwater2d 
{
	import flash.ui.Keyboard;
	import nape.geom.GeomPoly;
	import nape.geom.Vec2;
	import quadra.core.QuadraSample;
	import quadra.display.Polygon;
	import quadra.input.KeyBinding;
	import quadra.scene.components.QuadComponent;
	import quadra.scene.Entity;
	import samples.dynamicwater2d.components.WaterComponent;
	import samples.dynamicwater2d.components.WaterDisplayComponent;
	import starling.core.Starling;
	
	public class Game extends QuadraSample
	{
		public static const NUM_SPRINGS:int = 247;
		public static const SPRING_SPACING:Number = 3;
		public static const WATER_DEPTH:Number = 200;
		
		public static var current:Game;
		
		private var _water:Entity;
		
		public function Game()
		{
			Game.current = this;
			Starling.current.enableErrorChecking = true;
		}
		
		protected override function init():void
		{
			initWater();
		}
		
		private function initWater():void
		{
			var water:WaterComponent = new WaterComponent(NUM_SPRINGS, SPRING_SPACING, WATER_DEPTH, .025, .025, .25);
			var display:WaterDisplayComponent = new WaterDisplayComponent();
			_water = scene.createEntity([water, display]);
			_water.y = stage.stageHeight / 2;
		}
		
		protected override function update(elaspedTime:Number):void
		{
			super.update(elaspedTime);
		}
	}
}