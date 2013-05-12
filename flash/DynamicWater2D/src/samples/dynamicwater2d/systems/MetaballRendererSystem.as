package samples.dynamicwater2d.systems
{
	import flash.geom.Matrix;
	import quadra.core.QuadraGame;
	import quadra.display.filters.AlphaTestFilter;
	import quadra.world.components.lib.SpatialComponent;
	import quadra.world.components.lib.StarlingDisplayComponent;
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import quadra.world.systems.GroupSystem;
	import samples.dynamicwater2d.Group;
	import starling.display.BlendMode;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.RenderTexture;
	

	public class MetaballRendererSystem extends GroupSystem
	{
		private var _globalRenderTexture:RenderTexture;
		private var _globalImage:Image;
		private var _globalEntity:Entity;
		
		public function MetaballRendererSystem()
		{
			super(Group.METABALLS, EntityFilter.all([StarlingDisplayComponent]));
		}
		
		public override function init():void
		{
			_globalRenderTexture = new RenderTexture(QuadraGame.current.stage.stageWidth, QuadraGame.current.stage.stageHeight, true);
			_globalImage = new Image(_globalRenderTexture);
			_globalImage.color = 0x337fcc;
			_globalImage.filter = new AlphaTestFilter(0.8, 0.75);
			_globalEntity = world.createEntity();
			_globalEntity.addComponent(new SpatialComponent());
			_globalEntity.addComponent(new StarlingDisplayComponent(_globalImage, 10));
			_globalEntity.tag = "globalMetaball";
			_globalEntity.refresh();
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elaspedTime:Number):void
		{
			_globalRenderTexture.clear();
			
			var entity:Entity;
			var display:StarlingDisplayComponent;
			for (var i:int = 0; i < entities.length; ++i)
			{
				entity = entities[i];
				display = StarlingDisplayComponent(entity.getComponent(StarlingDisplayComponent));
				var doc:DisplayObjectContainer = display.displayObject as DisplayObjectContainer;
				var transform:Matrix = null;
				if (doc != null)
				{
					transform = doc.getTransformationMatrix(QuadraGame.current);
				}
				else if (display.displayObject.parent != null)
				{
					transform = display.displayObject.parent.getTransformationMatrix(QuadraGame.current);
				}
				
				//var oldBlendMode:BlendMode = display.displayObject.blendMode;
				display.displayObject.blendMode = BlendMode.ADD;
				_globalRenderTexture.drawBundled(function():void
				{
					_globalRenderTexture.draw(display.displayObject, transform);
				});
				//display.displayObject.blendMode = oldBlendMode;
			}
		}
	}
}