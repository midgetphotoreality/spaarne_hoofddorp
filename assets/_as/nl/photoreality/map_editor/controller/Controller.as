// nl.photoreality.map_editor.controller.Controller
package nl.photoreality.map_editor.controller {
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.system.Capabilities;
	import nl.photoreality.map_editor.constants.EditorConstants;
	import nl.photoreality.map_editor.constants.OverlayConstants;
	import nl.photoreality.map_editor.model.Model
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.map_editor.model.vo.FloorVO;
	import nl.photoreality.map_editor.model.vo.IconVO;
	import nl.photoreality.map_editor.model.vo.SettingsVO;
	import nl.photoreality.map_editor.proxy.LoadAssetsProxy;
	import nl.photoreality.map_editor.proxy.LoadPanoramaAssetsProxy;
	import nl.photoreality.map_editor.proxy.LoadPanoramaProxy;
	import nl.photoreality.map_editor.proxy.LoadXMLProxy;
	import nl.photoreality.map_editor.proxy.SaveXMLProxy;
	import nl.photoreality.map_editor.view.EditorMain;
	import nl.photoreality.map_editor.view.map.icons.ElevatorIcon;
	import nl.photoreality.map_editor.view.map.icons.EntranceIcon;
	import nl.photoreality.map_editor.view.map.icons.Icon;
	import nl.photoreality.map_editor.view.OverlayContainer;
	
	
	public class Controller  {
		
		private static var instance				: Controller;
		
		private var _model						: Model;
		private var _overlayContainer			: OverlayContainer;
		private var _rootMc						: EditorMain;
		
		
		public function Controller(enforcer:SingletonEnforcer) {
			trace("Controller -> constructor");
			_model		= Model.getInstance();
		}
		
		public static function getInstance():Controller {
			if (Controller.instance == null) Controller.instance = new Controller(new SingletonEnforcer());
			return Controller.instance;
		}
		
		//-- Register
		public function regOverlayContainer(overlayContainer:OverlayContainer):void {
			_overlayContainer = overlayContainer;
		}
		
		public function regRootMc(root:EditorMain):void {
			_rootMc = root;
		}
		
		
		//-- Show Editor
		public function showEditor(editorLabel:String):void {
			showOverlay( OverlayConstants.OFF );
			trace("Controller -> Show Editor: " + editorLabel);
			_rootMc.gotoAndStop(editorLabel);
		}
		
		
		
		//-- Show Overlay
		public function showOverlay(overlayLabel:String):void {
			trace("Controller -> Show Overlay: " + overlayLabel);
			if (runsInIDE()) {
				if (overlayLabel != OverlayConstants.PANORAMA_CONTAINER){
					_overlayContainer.gotoAndStop(overlayLabel);
				}
			}else {
				_overlayContainer.gotoAndStop(overlayLabel);
			}
			//if (overlayLabel != OverlayConstants.PANORAMA_CONTAINER){
				//_overlayContainer.gotoAndStop(overlayLabel);
			//}
		}
		
		public function closeOverlay():void {
			trace("Controller -> Close Overlay");
			_overlayContainer.gotoAndStop(OverlayConstants.OFF);
		}
		
		
		
		
		//-- Load the Project XML 
		public function loadXML(filename:String =""):void {
			_model.dispatch(Model.LOAD_XML_PENDING);
			_model.fileXML = filename;
			if (filename == "") {
				_model.fileXML = EditorConstants.XML_URL;
			}
			var proxy:LoadXMLProxy = new LoadXMLProxy(_model.fileXML);
			proxy.execute();
		}
		
		public function loadXMLDone(settings:SettingsVO,icons:Vector.<IconVO>,floors:Vector.<FloorVO>,routes:Vector.<RouteVO>){// lineColor:uint, lineThickness:Number):void {
			_model.settings = settings;
			_model.icons = icons;
			_model.floors = floors;
			_model.routes = routes;
			_model.lineColor = settings.lineColor;
			_model.lineThickness = settings.lineThickness;
			_model.dispatch(Model.LOAD_XML_COMPLETE);
		}
		
		public function saveXML():void {
			_model.dispatch(Model.SAVE_XML_PENDING);
			var proxy:SaveXMLProxy = new SaveXMLProxy(_model.settings,_model.icons, _model.floors, _model.routes);
		}
		
		public function loadAssets(filename:String = ""):void {
			_model.dispatch(Model.LOAD_ASSETS_PENDING);
			_model.fileAssets = filename;
			if (filename == "") {
				_model.fileAssets = EditorConstants.ASSETS_URL;
			}
			var proxy:LoadAssetsProxy = new LoadAssetsProxy(_model.fileAssets);
			proxy.execute();
		}
		
		public function loadAssetsDone(assets:Loader):void {
			_model.assets		 = assets;
			_model.dispatch(Model.LOAD_ASSETS_COMPLETE);
		}
		
		public function loadPanoramaAssets(filename:String = ""): void {
			_model.dispatch(Model.LOAD_PANORAMA_ASSETS_PENDING);
			_model.filePanoramaAssets = filename;
			if (filename == "") {
				_model.filePanoramaAssets = EditorConstants.PANORAMA_ASSETS_URL;
			}
			var proxy:LoadPanoramaAssetsProxy = new LoadPanoramaAssetsProxy(_model.filePanoramaAssets);
			proxy.execute();
		}
		
		public function loadPanoramaAssetsDone(panos:Loader): void {
			_model.panos = panos;
			_model.dispatch(Model.LOAD_PANORAMA_ASSETS_COMPLETE);
		}
		
		public function loadPanorama(filename:String = ""):void {
			_model.dispatch(Model.LOAD_PANORAMA_PENDING);
			_model.filePanoramaCore = filename;
			if (filename == "") {
				_model.filePanoramaCore = EditorConstants.PANORAMA_CORE_URL;
			}
			var proxy:LoadPanoramaProxy = new LoadPanoramaProxy(_model.filePanoramaCore);
			proxy.execute();
		}
		
		public function loadPanoramaDone(panorama:Loader):void {
			_model.panorama = panorama;
			_model.dispatch(Model.LOAD_PANORAMA_COMPLETE);
		}
		
		/////////////////
		public function addEntranceIcon(icon:EntranceIcon):void {
			_model.entranceIcons.push(icon);
			trace("Controller -> addEntranceIcon("+icon.name+") , _model.entranceIcons.length: "+_model.entranceIcons.length);
		}
		
		public function addElevatorIcon(icon:ElevatorIcon):void {
			_model.elevatorIcons.push(icon);
		}
		
		public function runsInIDE():Boolean {
			if (Capabilities.playerType == "External") {
				return true;
			}
			return false;
		}
	}
}

class SingletonEnforcer { }