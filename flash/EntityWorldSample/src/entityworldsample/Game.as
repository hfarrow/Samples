package entityworldsample 
{
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import quadra.core.QuadraSample;
	import quadra.world.components.NapePhysicsComponent;
	import quadra.world.components.StarlingDisplayComponent;
	import quadra.world.components.SpatialComponent;
	import quadra.world.components.VelocityComponent;
	import quadra.world.Entity;
	import quadra.world.systems.display.StarlingRenderSystem;
	import quadra.world.systems.NapePhysicsSystem;
	import starling.core.Starling;
	import starling.display.Quad;
	
	public class Game extends QuadraSample
	{
		public static var current:Game;
		
		private var _entity:Entity;
		
		public function Game()
		{
			Game.current = this;
			Starling.current.enableErrorChecking = true;
		}
		
		protected override function init():void
		{						
			world.systemManager.addSystem(new NapePhysicsSystem(true));
			world.systemManager.addSystem(new StarlingRenderSystem(this));
			
			//var renderSystem:StarlingRenderSystem = world.systemManager.getSystem(StarlingRenderSystem) as StarlingRenderSystem;
			//renderSystem.addRenderLayer("blue", 0);
			//renderSystem.addRenderLayer("red", 1);
			
			var entity1:Entity = world.createEntity();
			var body1:Body = new Body(BodyType.DYNAMIC, new Vec2(200, 200));
			body1.velocity.x = 40;
			body1.shapes.add(new Circle(50));
			entity1.addComponent(new SpatialComponent());
			entity1.addComponent(new VelocityComponent());
			entity1.addComponent(new NapePhysicsComponent(body1));
			var quad1:Quad = new Quad(100, 100, 0x0000ff);
			quad1.pivotX = quad1.pivotY = 50;
			entity1.addComponent(new StarlingDisplayComponent(quad1, 1));
			entity1.refresh();
			
			var entity2:Entity = world.createEntity();
			var body2:Body = new Body(BodyType.DYNAMIC, new Vec2(400, 280));
			body2.velocity.x = -40;
			body2.shapes.add(new Circle(50));
			entity2.addComponent(new SpatialComponent());
			entity2.addComponent(new VelocityComponent());
			entity2.addComponent(new NapePhysicsComponent(body2));
			var quad2:Quad = new Quad(100, 100, 0xff0000);
			quad2.pivotX = quad2.pivotY = 50;
			entity2.addComponent(new StarlingDisplayComponent(quad2));
			entity2.refresh();
		}
		
		protected override function update(elaspedTime:Number):void
		{
			super.update(elaspedTime);
		}
	}
}