package samples.dynamicwater2d.components
{
	import quadra.scene.Entity;
	import quadra.scene.IDisplayComponent;
	import quadra.scene.IEntityComponent;
	import samples.dynamicwater2d.Spring;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	

	public class WaterDisplayComponent implements IEntityComponent, IDisplayComponent
	{
		private var _entity:Entity;
		
		private var _springs:Vector.<Spring>;
		private var _quads:Vector.<Quad>;
		private var _container:Sprite;
		
		public function WaterDisplayComponent()
		{
			
		}
		
		public function init():void 
		{
			_springs = _entity.getAttributeObject("waterSprings") as Vector.<Spring>;
			_quads = new Vector.<Quad>();
			_container = new Sprite();
			initWaterVisuals();
		}
		
		private function initWaterVisuals():void
		{
			for (var i:int = 0; i < _springs.length; ++i)
			{
				var springSpacing:Number = Number(_entity.getAttributeNumber("waterSpringSpacing"));
				var quad:Quad = new Quad(springSpacing, _springs[i].position, 0x0000ff);
				quad.x = i * springSpacing;
				_quads.push(quad);				
				_container.addChild(quad);
			}
		}
		
		public function destroy():void 
		{
			
		}
		
		public function get type():Class 
		{
			return WaterDisplayComponent;
		}
		
		public function get entity():Entity 
		{
			return _entity;
		}
		
		public function set entity(value:Entity):void 
		{
			_entity = value;
		}
		
		public function get displayObject():DisplayObject 
		{
			return _container;
		}
		
		public function update(elapsedTime:Number):void 
		{
			for (var i:int = 0; i < _springs.length; ++i)
			{
				_quads[i].y = _springs[i].position - _springs[i].targetPosition;
			}
		}
	}
}