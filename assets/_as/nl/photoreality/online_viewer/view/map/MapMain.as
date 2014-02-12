//nl.photoreality.online_viewer.view.map.MapMain
package nl.photoreality.online_viewer.view.map {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import nl.photoreality.map_editor.controller.RouteController;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.view.floors.FloorContainer;
	import nl.photoreality.map_editor.view.route.RouteContainer;
	import nl.photoreality.online_viewer.manager.MenuManager;
	import nl.photoreality.utils.debug.Debug;
	
	
	public class MapMain extends MovieClip {
		
		private var _controller				: RouteController;
		private var _model					: Model;
		private var _modelRoute				: RouteModel;
		private var _menuManager			: MenuManager;
		
		// stage instances
		public var floor1_container_mc		: FloorContainer;
		public var floor1_name				: TextField;
		public var floor2_container_mc		: FloorContainer;
		public var floor2_name				: TextField;
		public var route_container_mc		: RouteContainer;
		public var label_container_mc		: LabelContainer;
		public var bg						: MovieClip;
		
		
		public function MapMain()  {
			_controller = RouteController.getInstance();
			_model = Model.getInstance();
			_modelRoute = RouteModel.getInstance();
			_menuManager = MenuManager.getInstance();
			_menuManager.registerMap(this);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			bg.visible = false;
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			
			
			route_container_mc.isEditable = false;
			route_container_mc.floor2OffsetX = floor2_container_mc.x - route_container_mc.x;
			route_container_mc.floor2OffsetY = floor2_container_mc.y - route_container_mc.y;
			
			addListeners();
			
			/*if (_model.routes.length) {
				refresh();
			}*/
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			Debug.log("MapMain -> AddListeners");
			_menuManager.addEventListener(MenuManager.ROUTE_SELECTED, routeSelectedListener);
			init();
		}
		
		private function removeListeners():void {
			_menuManager.removeEventListener(MenuManager.ROUTE_SELECTED, routeSelectedListener);
		}
		
		
		//-- Listeners
		private function routeSelectedListener(e:Event):void {
			refresh();
		}
		
		//-- Init 
		private function init():void {
			bg.visible = false;
			trace("MapMain -> init()")
			var offsetX:int = floor2_container_mc.x - floor1_container_mc.x;
			var offsetY:int = floor2_container_mc.y - floor1_container_mc.y;
			label_container_mc.offSet = new Point(offsetX, offsetY);
			
			//route_container_mc.refresh();
			addFloor1(_model.floors[0]);
		}
		
		//-- Refresh
		private function refresh():void {
			
			trace("MapMain -> refresh()")
			
			if (MenuManager.getInstance().virtualTourIsOpen) {
				route_container_mc.arrowPlayFast = false;
			} else {
				route_container_mc.arrowPlayFast = true;
			}
			
			// route selected -> show
			//if (_modelRoute.routeIsSelected) {
				route_container_mc.refresh();
				addFloor1(_menuManager.route.floors[0]);
				
				// check if end floor is different
				if (_menuManager.route.floors[0] != _menuManager.route.floors[1]) {
					addFloor2(_menuManager.route.floors[1]);
				} else {
					floor2_container_mc.deinit();
					floor2_name.text = "";
				}
				
			// route not selected -> kill
			/*} else {
				floor1_container_mc.deinit();
				floor1_name.text = "";
				floor2_container_mc.deinit();
				floor2_name.text = "";
			}*/
		}
		
		
		public function getFloorOnePrintable():Bitmap{
			route_container_mc.isPrintable = true;
			var bmpData:BitmapData = new BitmapData(floor1_container_mc.width, floor1_container_mc.height);
			bmpData.draw(floor1_container_mc);// this, null, null, null, new Rectangle(floor1_container_mc.x, floor1_container_mc.y, floor1_container_mc.width, floor1_container_mc.height));
			bmpData.draw(route_container_mc);
			bmpData.draw(label_container_mc);
			return new Bitmap(bmpData);
		}
		
		public function getFloorTwoPrintable():Bitmap {
			if (RouteModel.getInstance().selectedRouteVO.floors[0].id != RouteModel.getInstance().selectedRouteVO.floors[1].id) {
				
				route_container_mc.isPrintable = true;
				var bmpData:BitmapData = new BitmapData(floor2_container_mc.width, floor2_container_mc.height);
				bmpData.draw(floor2_container_mc);// this, null, null, null, new Rectangle(floor2_container_mc.x, floor2_container_mc.y, floor2_container_mc.width, floor2_container_mc.height));
				bmpData.draw(label_container_mc);
				return new Bitmap(bmpData);
			}
			
			return new Bitmap();
		}
		
		private function addFloor1(floorVO:FloorVO):void {
			trace("MapMain -> addFloor1("+floorVO.name+")")
			floor1_container_mc.floor = floorVO;
			floor1_name.text = floorVO.name;
		}
		
		private function addFloor2(floorVO:FloorVO):void {
			trace("MapMain -> addFloor2("+floorVO.name+")")
			floor2_container_mc.floor = floorVO;
			floor2_name.text = floorVO.name;
		}
		
		public function printVersion():void {
			trace("MapMain -> printVersion")
			//label_container_mc.f1_label.visible = false;
			label_container_mc.printVersion();
			route_container_mc.isPrintable = true;
			
			scaleX = .62;
			scaleY = .62;
			/*try{
				this.parent.removeChild(this);
			}catch (err:Error){
				
			}*/
			
			refresh();
			trace("MapMain -> printVersion, bg.visible TRUE");
			floor1_container_mc.printable = true;
			floor2_container_mc.printable = true;
			bg.visible = true
			route_container_mc.prepareForPrint();
		}
		
		public function normalVersion():void {
			trace("MapMain -> normalVersion")
			label_container_mc.normalVersion();
			route_container_mc.isPrintable = false;
			floor1_container_mc.printable = false;
			floor2_container_mc.printable = false;
			scaleX = 1;
			scaleY = 1;
			
			refresh();
			bg.visible = false;
		}
	}
}