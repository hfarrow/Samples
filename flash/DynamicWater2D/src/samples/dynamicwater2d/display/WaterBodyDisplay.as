package samples.dynamicwater2d.display
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import quadra.core.QuadraGame;
	import quadra.display.TriangleBatch;
	import quadra.utils.Lerp;
	import quadra.world.Entity;
	import quadra.world.lib.components.StarlingDisplayComponent;
	import samples.dynamicwater2d.components.WaterBodyComponent;
	import samples.dynamicwater2d.Spring;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.utils.VertexData;
	

	public class WaterBodyDisplay extends Sprite
	{
		private var _bodyEntity:Entity;
		private var _waterBody:WaterBodyComponent;
		private var _waterBodyBatch:TriangleBatch;
		private var _waterSurfaceBatch:TriangleBatch;
		private var _vertexData:VertexData;
		private var _vertexDataSurface:VertexData;
		private var _indices:Vector.<uint>;
		
		private var _surfaceGroup:uint;
		private var _surfaceRenderTarget:String;
		private var _surfaceEntity:Entity;
		
		public function WaterBodyDisplay(bodyEntity:Entity, surfaceEntity:Entity, surfaceGroup:uint, surfaceRenderTarget:String)
		{
			_bodyEntity = bodyEntity;
			_waterBody = WaterBodyComponent(_bodyEntity.getComponent(WaterBodyComponent));
			
			_surfaceEntity = surfaceEntity;
			_surfaceGroup = surfaceGroup;
			_surfaceRenderTarget = surfaceRenderTarget;
			
			initWaterBody();
			initWaterSurface();
		}
		
		private function initWaterBody():void
		{
			_waterBodyBatch = new TriangleBatch();
			_waterSurfaceBatch = new TriangleBatch();
			addChild(_waterBodyBatch);
			
			_vertexData = new VertexData(_waterBody.springs.length * 4);
			_vertexData.setUniformColor(0x0000ff);
			_indices = new Vector.<uint>(_waterBody.springs.length * 6, true);
		}
		
		private function initWaterSurface():void
		{
			_waterSurfaceBatch = new TriangleBatch();
			_vertexDataSurface = new VertexData(_waterBody.springs.length * 4);
			_vertexDataSurface.setUniformColor(0xffffff);
			
			// Water surface must be separate entity so that it can be rendered to the metaball texture.
			_surfaceEntity.addToGroup(_surfaceGroup);
			_surfaceEntity.addComponent(new StarlingDisplayComponent(_waterSurfaceBatch, -1, _surfaceRenderTarget));
			_surfaceEntity.refresh();
		}
		
		public override function dispose():void
		{
			super.dispose();
		}
		
		public function update():void
		{
			updateWaterBody();
		}
		
		private function updateWaterBody():void
		{
			var springSpacing:Number = _waterBody.springSpacing;
			var springs:Vector.<Spring> = _waterBody.springs;
			var depth:Number = _waterBody.depth;
			
			var maxColor:uint = 0x337fcc;
			var minColor:uint = 0x000033;
			var midColor:uint = Lerp.color(minColor, maxColor, 0.95);
			
			var surfaceTransform:Matrix = getTransformationMatrix(QuadraGame.current);
			
			for (var i:int = 0; i < springs.length-1; ++i)
			{
				var left:Number = i * springSpacing;
				var right:Number = left + springSpacing;
				var bottom:Number = depth;
				var spring0:Number = springs[i].targetPosition - springs[i].position;
				var spring1:Number = springs[i+1].targetPosition - springs[i+1].position;
				
				var startIndex:int = i * 4;
				var indicesStartIndex:int = i * 6;
				_vertexData.setPosition(startIndex + 0, left, spring0);
				_vertexData.setPosition(startIndex + 1, right, spring1);
				_vertexData.setPosition(startIndex + 2, right, bottom);
				_vertexData.setPosition(startIndex + 3, left, bottom);
				_vertexData.setAlpha(startIndex + 0, this.alpha);
				_vertexData.setAlpha(startIndex + 1, this.alpha);
				_vertexData.setAlpha(startIndex + 2, this.alpha);
				_vertexData.setAlpha(startIndex + 3, this.alpha);
				
				_vertexDataSurface.setPosition(startIndex + 0, left, spring0 - 40);
				_vertexDataSurface.setPosition(startIndex + 1, right, spring1 - 40);
				_vertexDataSurface.setPosition(startIndex + 2, right, spring1);
				_vertexDataSurface.setPosition(startIndex + 3, left, spring0);
				_vertexDataSurface.transformVertex(startIndex, surfaceTransform, 4);
				
				
				// Top vertices (surface)
				_vertexData.setColor(startIndex + 0, Lerp.color(minColor, midColor, (1 - spring0 / depth)));
				_vertexData.setColor(startIndex + 1, Lerp.color(minColor, midColor, (1 - spring1 / depth)));
				
				_vertexDataSurface.setAlpha(startIndex + 0, 0);
				_vertexDataSurface.setAlpha(startIndex + 1, 0);
				
				// Bottom Vertices (water floor)
				_vertexData.setColor(startIndex + 2, minColor);
				_vertexData.setColor(startIndex + 3, minColor);
				
				// Build 2 triangles out of the four corner vertices.
				_indices[indicesStartIndex + 0] = startIndex + 0;
				_indices[indicesStartIndex + 1] = startIndex + 1;
				_indices[indicesStartIndex + 2] = startIndex + 3;
				_indices[indicesStartIndex + 3] = startIndex + 1;
				_indices[indicesStartIndex + 4] = startIndex + 2;
				_indices[indicesStartIndex + 5] = startIndex + 3;
			}
			
			_waterBodyBatch.clear();
			_waterBodyBatch.addVertices(_vertexData, _indices);
			
			_waterSurfaceBatch.clear();
			_waterSurfaceBatch.addVertices(_vertexDataSurface, _indices);
		}
	}
}