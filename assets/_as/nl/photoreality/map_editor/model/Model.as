//nl.photoreality.map_editor.model.Model
package nl.photoreality.map_editor.model {
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import nl.photoreality.map_editor.model.vo.RoutePointVO;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.map_editor.model.vo.SettingsVO;
	import nl.photoreality.map_editor.view.map.icons.EntranceIcon;
	import nl.photoreality.map_editor.view.map.icons.Icon;
	
	
	public class Model extends EventDispatcher {
		
		public static const	EDIT_MODE_CHANGE				: String 			= "edit_mode_change";
		public static const	DRAW_MODE_CHANGE				: String 			= "draw_mode_change";
		public static const	ROUTE_POINT_CREATED				: String 			= "route_point_created";
		
		public static const ROUTE_EDITOR_UPDATE				: String			= "route_editor_update";
		
		public static const LOAD_XML_PENDING				: String			= "load_xml_pending";
		public static const LOAD_XML_COMPLETE				: String			= "load_xml_complete";
		public static const LOAD_XML_ERROR					: String			= "load_xml_error";
		
		public static const LOAD_ASSETS_PENDING				: String			= "load_assets_pending";
		public static const LOAD_ASSETS_COMPLETE			: String			= "load_assets_complete";
		public static const LOAD_ASSETS_ERROR				: String			= "load_assets_error";
		
		public static const LOAD_PANORAMA_PENDING			: String			= "load_panorama_pending";
		public static const LOAD_PANORAMA_COMPLETE			: String			= "load_panorama_complete";
		public static const LOAD_PANORAMA_ERROR				: String			= "load_panorama_error";
		
		public static const LOAD_PANORAMA_ASSETS_PENDING	: String			= "load_panorama_assets_pending";
		public static const LOAD_PANORAMA_ASSETS_COMPLETE	: String			= "load_panorama_assets_complete";
		public static const LOAD_PANORAMA_ASSETS_ERROR		: String			= "load_panorama_assets_error";
		
		public static const SAVE_XML_PENDING				: String			= "save_xml_pending";
		public static const SAVE_XML_COMPLETE				: String			= "save_xml_complete";
		public static const SAVE_XML_ERROR					: String			= "save_xml_error";
		
		public static const FLOORS_CHANGE					: String			= "floors_change";
		public static const ICON_ADDED						: String			= "icon_added";
		public static const ICON_REMOVED					: String			= "icon_removed";
		
		private static var instance				: Model;
		private var _entranceIcons				: Array;
		private var _elevatorIcons				: Array;
		
		private var _assets						: Loader;
		private var _panos						: Loader;
		private var _panorama					: Loader;
		
		private var _settings					: SettingsVO;
		private var _routes						: Vector.<RouteVO>;
		private var _floors						: Vector.<FloorVO>
		private var _icons						: Vector.<IconVO>
		private var _iconHolderDimensions		: Rectangle;
		
		private var _fileXML					: String ;
		private var _fileAssets					: String ;
		private var _filePanoramaAssets		: String ;
		private var _filePanoramaCore	: String ;
		
		
		private var _lineColor					: uint;
		private var _lineThickness				: Number;
		
		private var _isEditor					: Boolean;
		
		
		public function Model(enforcer:SingletonEnforcer) {
			trace("Model -> constructor");
			_entranceIcons = new Array();
			_elevatorIcons = new Array();
		}
		
		public static function getInstance():Model {
			if (Model.instance == null) Model.instance = new Model(new SingletonEnforcer());
			return Model.instance;
		}
		
		public function dispatch(evtString:String):void {
			trace("Model -> dispatch(" + evtString + ")");
			dispatchEvent(new Event(evtString));
		}
		
		
		
		
		
		
		public function get entranceIcons():Array { return _entranceIcons; }
		public function set entranceIcons(value:Array):void {
			_entranceIcons = value;
		}
		
		public function get elevatorIcons():Array { return _elevatorIcons; }
		public function set elevatorIcons(value:Array):void {
			_elevatorIcons = value;
		}
		
		public function get routes():Vector.<RouteVO> { return _routes; }
		public function set routes(value:Vector.<RouteVO>):void {
			_routes = value;
		}
		
		public function get floors():Vector.<FloorVO> { return _floors; }
		public function set floors(value:Vector.<FloorVO>):void {
			_floors = value;
		}
		
		public function get icons():Vector.<IconVO> { return _icons; }
		public function set icons(value:Vector.<IconVO>):void {
			_icons = value;
			for (var i:int = 0; i < _icons.length; i++) {
				_iconHolderDimensions
			}
		}
		
		public function get assets():Loader { return _assets; }
		public function set assets(value:Loader):void {
			_assets = value;
		}
		
		public function get panorama():Loader { return _panorama; }
		public function set panorama(value:Loader):void {
			_panorama = value;
		}
		
		public function get panos():Loader { return _panos; }
		
		public function set panos(value:Loader):void 
		{
			_panos = value;
		}
		
		public function get lineColor():uint { return _lineColor; }		
		public function set lineColor(value:uint):void {
			_lineColor = value;
		}
		
		public function get lineThickness():Number { return _lineThickness; }
		public function set lineThickness(value:Number):void {
			_lineThickness = value;
		}
		
		public function get isEditor():Boolean { return _isEditor; }
		public function set isEditor(value:Boolean):void {
			_isEditor = value;
		}
		
		public function get settings():SettingsVO { return _settings; }
		
		public function set settings(value:SettingsVO):void 
		{
			_settings = value;
		}
		
		public function get fileXML():String { return _fileXML; }
		
		public function set fileXML(value:String):void 
		{
			_fileXML = value;
		}
		
		public function get fileAssets():String { return _fileAssets; }
		
		public function set fileAssets(value:String):void 
		{
			_fileAssets = value;
		}
		
		public function get filePanoramaAssets():String { return _filePanoramaAssets; }
		
		public function set filePanoramaAssets(value:String):void 
		{
			_filePanoramaAssets = value;
		}
		
		public function get filePanoramaCore():String { return _filePanoramaCore; }
		
		public function set filePanoramaCore(value:String):void 
		{
			_filePanoramaCore= value;
		}
	}
}

class SingletonEnforcer { }