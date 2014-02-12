// nl.photoreality.map_editor.view.EditorMain
package nl.photoreality.map_editor.view {
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import nl.photoreality.map_editor.constants.EditorConstants;
	import nl.photoreality.map_editor.controller.Controller;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.panorama.model.PanoramaModel;
	import nl.photoreality.utils.debug.Debug;
	
	
	public class EditorMain extends MovieClip {
		
		private var _controller		: Controller;
		private var _model			: Model;
		
		private var _hasVars		: Boolean;
		private var _project			: String;
		private var _overrideXML			: String;
		public var debug_txt		: TextField;
		private var hasPano:int;
		
		
		public function EditorMain() {
			trace("PhotoReality - Map Editor V" + EditorConstants.VERSION);
			_controller = Controller.getInstance();
			_model = Model.getInstance();
			_model.isEditor = true;
			
			PanoramaModel.getInstance();
			
			Debug.registerTextfield(debug_txt);
			Debug.log("PhotoReality - Map Editor V" + EditorConstants.VERSION+" , Capabilities.playerType: "+Capabilities.playerType);
			// Stage setup
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			// Reg
			_controller.regRootMc(this);
			
			stop();
			readFlashVars();
			//loadXML();
		}
		
		private function readFlashVars():void {
			try {
				var _leVars:Object = LoaderInfo(this.root.loaderInfo).parameters;
				_hasVars = false;
				if (_leVars["project"]){
					_project = _leVars["project"];
					_hasVars = true;
				}else {
					_project = "AZM";
				}
				if (_leVars["xml"]){
					_overrideXML = _leVars["xml"];
				}
				hasPano = 0;
				if (_leVars["pano"]){
					hasPano = int(_leVars["pano"]);
				}
				
				
			} catch (error:Error) {
				_project = "AZM";
				_hasVars = false;
			}
			loadXML();
		}
		
		private function loadXML():void {
			Debug.log("loadXML: " + "../" + _project + "/" + EditorConstants.XML_URL)
			if (runsInIDE()) {
				_controller.loadXML("../" + _project + "/" + EditorConstants.XML_URL);
			}else {
				_controller.loadXML("./" + _project + "/" + EditorConstants.XML_URL);
			}
			_model.addEventListener(Model.LOAD_XML_COMPLETE, loadXMLCompleteListener);
		}
		
		private function loadXMLCompleteListener(e:Event):void {
			Debug.log("loadXMLCompleteListener")
			_model.removeEventListener(Model.LOAD_XML_COMPLETE, loadXMLCompleteListener);
			_model.addEventListener(Model.LOAD_ASSETS_COMPLETE, loadAssetsCompleteListener);
			if (runsInIDE()) {
				_controller.loadAssets("../" + _project + "/" + EditorConstants.ASSETS_URL);
			}else {
				_controller.loadAssets("./" + _project + "/" + EditorConstants.ASSETS_URL);
			}
		}
		
		private function loadAssetsCompleteListener(e:Event):void {
			Debug.log("loadAssetsCompleteListener")
			_model.removeEventListener(Model.LOAD_ASSETS_COMPLETE, loadAssetsCompleteListener);
			if (runsInIDE()) {
				startApplication();
			}else {
				//_model.addEventListener(Model.LOAD_PANORAMA_ASSETS_COMPLETE, loadPanoramaAssetsDone);
				//Controller.getInstance().loadPanoramaAssets();
				if (hasPano ==1){
				_model.addEventListener(Model.LOAD_PANORAMA_COMPLETE, loadPanoramaCompleteListener);
				Controller.getInstance().loadPanorama("./" + _project + "/" + EditorConstants.PANORAMA_CORE_URL);
				}else {
					startApplication();
				}
			}
		}
		
		/*private function loadPanoramaAssetsDone(e:Event):void {
			Debug.log("EditorMain -> loadPanoramaAssetsDone");
			_model.removeEventListener(Model.LOAD_PANORAMA_ASSETS_COMPLETE, loadPanoramaAssetsDone);
			_model.addEventListener(Model.LOAD_PANORAMA_COMPLETE, loadPanoramaCompleteListener);
			Controller.getInstance().loadPanorama();
		}*/
		
		private function loadPanoramaCompleteListener(e:Event):void {
			_model.removeEventListener(Model.LOAD_PANORAMA_COMPLETE, loadPanoramaCompleteListener);
			startApplication();
		}
		
		
		
		//-- Start Application
		private function startApplication():void {
			Debug.log("startApplication")
			gotoAndStop(EditorConstants.IDLE);
		}
		
		private function runsInIDE():Boolean {
			if (Capabilities.playerType == "External") {
				return true;
			}
			return false;
		}
	}
}