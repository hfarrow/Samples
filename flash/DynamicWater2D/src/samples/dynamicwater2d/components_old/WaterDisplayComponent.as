package samples.dynamicwater2d.components_old
{
	import flash.geom.Matrix;
	import quadra.display.filters.AlphaTestFilter;
	import quadra.display.TriangleBatch;
	import quadra.scene.Entity;
	import quadra.scene.IDisplayComponent;
	import quadra.scene.IEntityComponent;
	import samples.dynamicwater2d.Game;
	import samples.dynamicwater2d.Particle;
	import samples.dynamicwater2d.Spring;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.filters.FragmentFilter;
	import starling.filters.FragmentFilterMode;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.utils.VertexData;
	

	public class WaterDisplayComponent implements IEntityComponent, IDisplayComponent
	{
		[Embed(source = "../../../../content/metaparticle.png")]
		private var DropletTexture:Class;
		
		private var _entity:Entity;
		
		private var _springs:Vector.<Spring>;
		private var _particleSystem:ParticleSystemComponent;
		private var _vertexData:VertexData;
		private var _indices:Vector.<uint>;
		private var _vertexDataSurface:VertexData;
		private var _waterBodyBatch:TriangleBatch;
		private var _waterSurfaceBatch:TriangleBatch;
		private var _particlesBatch:QuadBatch;
		private var _particlesRenderTexture:RenderTexture;
		private var _particleImage:Image;
		private var _particleTexture:Texture
		private var _particlesRenderImage:Image;
		private var _metaballSprite:Sprite;
		private var _container:Sprite;
		
		public function WaterDisplayComponent()
		{
			
		}
		
		public function init():void 
		{
			_springs = _entity.getAttributeObject("waterSprings") as Vector.<Spring>;
			_particleSystem = _entity.getComponent(ParticleSystemComponent) as ParticleSystemComponent;
			_container = new Sprite();
			
			_metaballSprite = new Sprite();
			initParticles();
			initWaterBody();
			initWaterSurface();
		}
		
		private function initWaterBody():void
		{
			_waterBodyBatch = new TriangleBatch();
			_container.addChild(_waterBodyBatch);
			_vertexData = new VertexData(_springs.length * 4);
			_vertexData.setUniformColor(0x0000ff);
			_indices = new Vector.<uint>(_springs.length * 6, true);
		}
		
		private function initWaterSurface():void
		{
			_waterSurfaceBatch = new TriangleBatch();
			_vertexDataSurface = new VertexData(_springs.length * 4);
			_vertexDataSurface.setUniformColor(0xffffff);
			
			_metaballSprite.blendMode = BlendMode.ADD;
			_metaballSprite.addChild(_waterSurfaceBatch);
		}
		
		private function initParticles():void
		{
			_particleTexture = Texture.fromBitmap(new DropletTexture());
			
			_particlesBatch = new QuadBatch();
			_metaballSprite.addChild(_particlesBatch);
			_particleImage = new Image(_particleTexture);
			//_particleImage.color = 0x0000cc;
			_particleImage.scaleX = 2.5;
			_particleImage.scaleY = 2.5;
			
			_particlesRenderTexture = new RenderTexture(_entity.stage.stageWidth, _entity.stage.stageHeight, false);
			_particlesRenderImage = new Image(_particlesRenderTexture);
			_particlesRenderImage.color = 0x337fcc;
			_container.addChild(_particlesRenderImage);
			_particlesRenderImage.filter = new AlphaTestFilter();
		}
		
		public function destroy():void 
		{
			_waterBodyBatch.removeFromParent();
			_waterBodyBatch.dispose();
			
			_particlesRenderImage.removeFromParent();
			_particlesRenderImage.dispose();
			_particlesRenderTexture.dispose();
			_particlesBatch.dispose();
			_particleImage = null;
			_particlesRenderImage = null;
			_particlesRenderTexture = null;
			_particlesBatch = null;
			
			_springs = null;
			_particleImage.dispose();
			_particleTexture.dispose();
			_vertexData = null;
			_vertexDataSurface = null;
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
			updateWaterBody(elapsedTime);
			updateWaterParticles(elapsedTime);
		}
		
		private function lerpColor(min:Number, max:Number, t:Number):Number
		{
			var minRed:Number = (0xff0000 & min) >> 16;
			var minGreen:Number = (0xff00 & min) >> 8;
			var minBlue:Number = (0xff & min);
			
			var maxRed:Number = (0xff0000 & max) >> 16;
			var maxGreen:Number = (0xff00 & max) >> 8;
			var maxBlue:Number = (0xff & max);
			
			var color:Number = 0;
			color |= lerp(minRed, maxRed, t) << 16;
			color |= lerp(minGreen, maxGreen, t) << 8;
			color |= lerp(minBlue, maxBlue, t);
			return color;
		}
		
		private function lerp(min:Number, max:Number, t:Number):Number
		{
			return (max - min) * t + min;
		}
		
		private function updateWaterBody(elaspedTime:Number):void
		{
			var springSpacing:Number = _entity.getAttributeNumber("waterSpringSpacing");
			var depth:Number = _entity.getAttributeNumber("waterDepth");
			
			var maxColor:uint = 0x337fcc;
			var minColor:uint = 0x000033;
			var midColor:uint = lerpColor(minColor, maxColor, 0.9);
			
			for (var i:int = 0; i < _springs.length-1; ++i)
			{
				var left:Number = i * springSpacing;
				var right:Number = left + springSpacing;
				var bottom:Number = depth;
				var spring0:Number = _springs[i].targetPosition - _springs[i].position;
				var spring1:Number = _springs[i+1].targetPosition - _springs[i+1].position;
				
				var startIndex:int = i * 4;
				var indicesStartIndex:int = i * 6;
				_vertexData.setPosition(startIndex + 0, left, spring0);
				_vertexData.setPosition(startIndex + 1, right, spring1);
				_vertexData.setPosition(startIndex + 2, right, bottom);
				_vertexData.setPosition(startIndex + 3, left, bottom);
				
				_vertexDataSurface.setPosition(startIndex + 0, left, spring0 - 40);
				_vertexDataSurface.setPosition(startIndex + 1, right, spring1 - 40);
				_vertexDataSurface.setPosition(startIndex + 2, right, spring1);
				_vertexDataSurface.setPosition(startIndex + 3, left, spring0);
				
				
				// Top vertices (surface)
				_vertexData.setColor(startIndex + 0, lerpColor(minColor, midColor, (1 - spring0 / depth)));
				_vertexData.setColor(startIndex + 1, lerpColor(minColor, midColor, (1 - spring1 / depth)));
				
				//_vertexDataSurface.setColor(startIndex + 0, (1 - spring0 - 10 / depth) * (maxColor - minColor) + minColor);
				//_vertexDataSurface.setColor(startIndex + 1, (1 - spring1 - 10 / depth) * (maxColor - minColor) + minColor);
				_vertexDataSurface.setAlpha(startIndex + 0, 0);
				_vertexDataSurface.setAlpha(startIndex + 1, 0);
				
				// Bottom Vertices (water floor)
				_vertexData.setColor(startIndex + 2, minColor);
				_vertexData.setColor(startIndex + 3, minColor);
				
				//_vertexDataSurface.setColor(startIndex + 2, (1 - spring1 / depth) * (maxColor - minColor) + minColor);
				//_vertexDataSurface.setColor(startIndex + 3, (1 - spring0 / depth) * (maxColor - minColor) + minColor);
				
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
		
		private function updateWaterParticles(elapsedTime:Number):void
		{
			var particles:Vector.<Particle> = _particleSystem.particles;			
			_particlesBatch.reset();
			
			for (var i:int = 0; i < particles.length; ++i)
			{
				var particle:Particle = particles[i];
				_particleImage.x = particle.position.x;
				_particleImage.y = particle.position.y;
				_particleImage.rotation = particle.rotation;
				_particlesBatch.addImage(_particleImage);
			}
			
			// Render water particles into texture.
			_particlesRenderTexture.drawBundled(function():void
			{
				var transform:Matrix = _container.getTransformationMatrix(Game.current);
				_particlesRenderTexture.draw(_metaballSprite, transform);
			});
			
			//_particlesRenderImage.texture = _particlesRenderTexture;
			_particlesRenderImage.x = -_entity.x
			_particlesRenderImage.y = -_entity.y
		}
	}
}