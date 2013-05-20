package samples.dynamicwater2d.systems
{
	import flash.geom.Matrix;
	import quadra.core.QuadraGame;
	import quadra.display.filters.AlphaTestFilter;
	import quadra.world.lib.components.SpatialComponent;
	import quadra.world.lib.components.StarlingDisplayComponent;
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import quadra.world.lib.systems.starling.StarlingRenderSystem;
	import quadra.world.systems.GroupSystem;
	import samples.dynamicwater2d.Game;
	import samples.dynamicwater2d.Group;
	import starling.display.BlendMode;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.RenderTexture;
	

	public class MetaballRendererSystem extends GroupSystem
	{
		private var _metaballRenderTexture:RenderTexture;
		private var _metaballImage:Image;
		private var _metaballEntity:Entity;
		
		public function MetaballRendererSystem()
		{
			super(Group.METABALLS, EntityFilter.all([StarlingDisplayComponent]));
		}
		
		public override function init():void
		{
			_metaballRenderTexture = new RenderTexture(Game.current.stage.stageWidth, Game.current.stage.stageHeight, false);
			var renderSystem:StarlingRenderSystem = StarlingRenderSystem(world.systemManager.getSystem(StarlingRenderSystem));
			renderSystem.addRenderTarget(Game.META_BALL_TEXTURE, _metaballRenderTexture);
			
			_metaballImage = new Image(_metaballRenderTexture);
			_metaballImage.color = 0x337fcc;
			_metaballImage.filter = new AlphaTestFilter(0.8, 0.75);
			_metaballEntity = world.createEntity();
			_metaballEntity.addComponent(new SpatialComponent());
			_metaballEntity.addComponent(new StarlingDisplayComponent(_metaballImage, 10));
			_metaballEntity.tag = "globalMetaball";
			_metaballEntity.refresh();
		}
		
		protected override function onEntityAdded(entity:Entity):void
		{
			var display:StarlingDisplayComponent = StarlingDisplayComponent(entity.getComponent(StarlingDisplayComponent));
			display.displayObject.blendMode = BlendMode.ADD;			
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elaspedTime:Number):void
		{
			
		}
	}
}