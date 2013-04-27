package samples.dynamicwater2d.components
{
	import flash.geom.Point;
	import nape.geom.GeomPoly;
	import nape.geom.Vec2;
	import quadra.display.Polygon;
	import quadra.display.TriangleBatch;
	import quadra.scene.Entity;
	import quadra.scene.IDisplayComponent;
	import quadra.scene.IEntityComponent;
	import samples.dynamicwater2d.Spring;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.VertexData;
	

	public class WaterDisplayComponent implements IEntityComponent, IDisplayComponent
	{
		private var _entity:Entity;
		
		private var _springs:Vector.<Spring>;
		private var _vertexData:VertexData;
		private var _batch:TriangleBatch;
		private var _container:Sprite;
		
		public function WaterDisplayComponent()
		{
			
		}
		
		public function init():void 
		{
			_springs = _entity.getAttributeObject("waterSprings") as Vector.<Spring>;
			_container = new Sprite();
			
			initWaterVisuals();
		}
		
		private function initWaterVisuals():void
		{
			_batch = new TriangleBatch();
			_container.addChild(_batch);
			_vertexData = new VertexData(_springs.length * 6);
			_vertexData.setUniformColor(0x0000ff);
		}
		
		public function destroy():void 
		{
			_batch.dispose();
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
		
		private static var topLeft:Point;
		private static var topRight:Point;
		private static var bottomLeft:Point;
		private static var bottomRight:Point;
		public function update(elapsedTime:Number):void 
		{
			var springSpacing:Number = Number(_entity.getAttributeNumber("waterSpringSpacing"));
			
			var maxColor:uint = 0x0000dd;
			var minColor:uint = 0x000055;
			
			for (var i:int = 0; i < _springs.length-1; ++i)
			{
				var left:Number = i * springSpacing;
				var right:Number = left + springSpacing;
				var bottom:Number = _springs[i].targetPosition;
				var spring0:Number = _springs[i].targetPosition - _springs[i].position;
				var spring1:Number = _springs[i+1].targetPosition - _springs[i+1].position;
				
				topLeft = new Point(left, spring0);
				topRight = new Point(right, spring1);
				bottomLeft = new Point(left, bottom);
				bottomRight = new Point(right, bottom);
				
				var startIndex:int = i * 6;
				// Triangle A
				_vertexData.setPosition(startIndex + 0, topLeft.x, topLeft.y);
				_vertexData.setPosition(startIndex + 1, topRight.x, topRight.y);
				_vertexData.setPosition(startIndex + 2, bottomLeft.x, bottomLeft.y);
				
				// Triangle B
				_vertexData.setPosition(startIndex + 3, topRight.x, topRight.y);
				_vertexData.setPosition(startIndex + 4, bottomRight.x, bottomRight.y);
				_vertexData.setPosition(startIndex + 5, bottomLeft.x, bottomLeft.y);
				
				// Top vertices (surface)
				_vertexData.setColor(startIndex + 0, (1 - spring0 / _springs[i].targetPosition) * (maxColor - minColor) + minColor);
				_vertexData.setColor(startIndex + 1, (1 - spring1 / _springs[i].targetPosition) * (maxColor - minColor) + minColor);
				_vertexData.setColor(startIndex + 3, (1 - spring1 / _springs[i].targetPosition) * (maxColor - minColor) + minColor);
				
				// Bottom Vertices (water floor)
				_vertexData.setColor(startIndex + 2, minColor);
				_vertexData.setColor(startIndex + 4, minColor);
				_vertexData.setColor(startIndex + 5, minColor);
			}
			
			_batch.clear();
			_batch.addVertices(_vertexData);
		}
	}
}