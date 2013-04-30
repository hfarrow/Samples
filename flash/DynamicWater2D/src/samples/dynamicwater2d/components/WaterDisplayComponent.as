package samples.dynamicwater2d.components
{
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
		private var _waterBodyBatch:TriangleBatch;
		private var _particlesBatch:QuadBatch;
		private var _particlesRenderTexture:RenderTexture;
		private var _particleImage:Image;
		private var _particleTexture:Texture
		private var _particlesRenderImage:Image;
		private var _container:Sprite;
		
		public function WaterDisplayComponent()
		{
			
		}
		
		public function init():void 
		{
			_springs = _entity.getAttributeObject("waterSprings") as Vector.<Spring>;
			_particleSystem = _entity.getComponent(ParticleSystemComponent) as ParticleSystemComponent;
			_container = new Sprite();
			
			initParticles();
			initWaterBody();
		}
		
		private function initWaterBody():void
		{
			_waterBodyBatch = new TriangleBatch();
			_container.addChild(_waterBodyBatch);
			_vertexData = new VertexData(_springs.length * 4);
			_vertexData.setUniformColor(0x0000ff);
			_indices = new Vector.<uint>(_springs.length * 6, true);
		}
		
		private function initParticles():void
		{
			_particleTexture = Texture.fromBitmap(new DropletTexture());
			
			_particlesBatch = new QuadBatch();
			_particlesBatch.blendMode = BlendMode.ADD;
			_particlesBatch.filter = new AlphaTestFilter();
			_container.addChild(_particlesBatch);
			_particleImage = new Image(_particleTexture);
			_particleImage.color = 0x0000cc;
			_particleImage.scaleX = 1.5;
			_particleImage.scaleY = 1.5;
			
			_particlesRenderTexture = new RenderTexture(_entity.stage.stageWidth, _entity.stage.stageHeight, false);
			_particlesRenderImage = new Image(_particlesRenderTexture);
			//_container.addChild(_particlesRenderImage);
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
		
		private function updateWaterBody(elaspedTime:Number):void
		{
			var springSpacing:Number = _entity.getAttributeNumber("waterSpringSpacing");
			var depth:Number = _entity.getAttributeNumber("waterDepth");
			
			var maxColor:uint = 0x0000cc;
			var minColor:uint = 0x000055;
			
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
				
				// Top vertices (surface)
				_vertexData.setColor(startIndex + 0, (1 - spring0 / depth) * (maxColor - minColor) + minColor);
				_vertexData.setColor(startIndex + 1, (1 - spring1 / depth) * (maxColor - minColor) + minColor);
				
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
				_particlesRenderTexture.draw(_particlesBatch, _container.getTransformationMatrix(Game.current));
			});
			
			_particlesRenderImage.x = -_entity.x
			_particlesRenderImage.y = -_entity.y
		}
	}
}