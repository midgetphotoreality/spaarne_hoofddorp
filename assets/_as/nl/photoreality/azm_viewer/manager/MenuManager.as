package nl.photoreality.azm_viewer.manager {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.azm_viewer.view.map.MapMain;
	import nl.photoreality.azm_viewer.view.menu.button.DepartmentLabelButton;
	/**
	 * ...
	 * @author Miguel Fuentes // DioVoiD
	 */
	public class MenuManager extends EventDispatcher {
		
		public static const	VIRTUAL_TOUR_STATE_CHANGED						: String = "virtual_tour_state_changed"
		
		public static const	MENU_ITEM_CLICKED								: String = "menu_item_clicked"
		public static const	ROUTE_SELECTED									: String = "route_selected"
		public static const	SHOW_MENU										: String = "show_menu"
		public static const	HIDE_MENU										: String = "hide_menu"
		public static const	TRANSPORTATION_CHANGED							: String = "transportation_changed"
		public static const	TRANSPORTATION_CAR								: int = 2;
		public static const	TRANSPORTATION_BUS								: int = 3;
		public static const	TRANSPORTATION_TRAIN							: int = 1;
		
		public static const	SHOW_AREA										: String = "show_area"
		public static const	HIDE_AREA										: String = "hide_area"
		public static const	SHOW_PRINT										: String = "show_print"
		public static const	HIDE_PRINT										: String = "hide_print"
		
		public static const	PRINT											: String = "print"
		public static const	PRINT_FROM_MENU											: String = "print_from_menu"
		public static const	PRINT_PANO_PENDING								: String = "print_pano_pending"
		public static const	PRINT_PANO_LOADED								: String = "print_pano_loaded"
		public static const	PRINT_CLOSE										: String = "print_close"
		
		private static var instance											: MenuManager;
		private var _route													: RouteVO;
		private var _map													: MapMain
		private var _floor1Bitmap											: Bitmap;
		private var _floor2Bitmap											: Bitmap;
		private var _selectedDepartmentButton								: DepartmentLabelButton
		private var _virtualTourIsOpen										: Boolean;
		private var _currentTransportation									: int = 2;
		
		private var _printPanoramaBitmap									: Bitmap;
		
		public function MenuManager(enforcer:SingletonEnforcer) {
			//trace("MenuManager -> constructor");
		}
		
		public static function getInstance():MenuManager {
			if (MenuManager.instance == null) MenuManager.instance = new MenuManager(new SingletonEnforcer());
			return MenuManager.instance;
		}
		
		public function dispatch(evtString:String):void {
			//trace("MenuManager -> dispatch(" + evtString + ")");
			dispatchEvent(new Event(evtString));
		}
		
		public function registerMap(map:MapMain):void {
			_map = map;
		}
		
		public function print():void {
		//	_floor1Bitmap = _map.getFloorOnePrintable();
		//	_floor2Bitmap = _map.getFloorTwoPrintable();
			dispatch(PRINT);
			
		}
		
		public function printFromMenu():void {
			dispatch(PRINT_FROM_MENU);
		}
		
		public function selectIndex():void {
			dispatch(MENU_ITEM_CLICKED);
		}
		
		public function selectRoute(departmentButton:DepartmentLabelButton):void {
			RouteModel.getInstance().selectedRouteVO = departmentButton.routeVO;
			_route = departmentButton.routeVO;
			_selectedDepartmentButton = departmentButton;
			dispatch(ROUTE_SELECTED);
			//trace("MenuManager -> selectRoute(" + _route.name + ")");
		}
		
		public function showMenu():void {
			dispatch(SHOW_MENU);
		}
		
		public function hideMenu():void {
			dispatch(HIDE_MENU);
		}
		
		public function get selectedDepartmentButton():DepartmentLabelButton { return _selectedDepartmentButton; }
		
		public function get route():RouteVO { return _route; }
		
		public function get floor2Bitmap():Bitmap { return _floor2Bitmap; }
		
		public function get floor1Bitmap():Bitmap { return _floor1Bitmap; }
		
		public function get map():MapMain { return _map; }
		public function set map(value:MapMain):void {
			_map = value;
		}
		
		public function get virtualTourIsOpen():Boolean { return _virtualTourIsOpen; }
		public function set virtualTourIsOpen(value:Boolean):void {
			_virtualTourIsOpen = value;
		}
		
		public function get printPanoramaBitmap():Bitmap { return _printPanoramaBitmap; }
		public function set printPanoramaBitmap(value:Bitmap):void {
			_printPanoramaBitmap = value;
		}
		
		public function get currentTransportation():int { return _currentTransportation; }
		
		public function set currentTransportation(value:int):void 
		{
			_currentTransportation = value;
		}
	}
}

class SingletonEnforcer { }