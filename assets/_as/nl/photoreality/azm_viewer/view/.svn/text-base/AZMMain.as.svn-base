package nl.photoreality.azm_viewer.view 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import nl.photoreality.map_editor.controller.Controller;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.azm_viewer.manager.MenuManager;
	import nl.photoreality.azm_viewer.view.menu.Menu;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class AZMMain extends MovieClip
	{
		public static const VERSION			:String = "Version: 0.1";
		private var _menu					: Menu;
		private var _model					:Model;
		public var map						: MovieClip;
		public var version_txt				:TextField;
		public var txt_output				: TextField
		public var menuContainer			: MovieClip;
		public var overzichtsplattergrond_btn			: MovieClip;
		public var print_btn			: MovieClip;
		
		public var selectBtn_Bus			: MovieClip
		public var selectBtn_Car			: MovieClip
		public var selectBtn_Train			: MovieClip
		
		
		public function AZMMain() {
			_model = Model.getInstance();
			stop();
			txt_output.visible = false;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			loadXML();
			version_txt.text = VERSION;
		}
		
		private function removedFromStageListener(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			
		}
		
		private function removeListeners():void {
			
		}
		
		private function loadXML():void {
			version_txt.text = "Loading XML...";
			Controller.getInstance().loadXML();
			_model.addEventListener(Model.LOAD_XML_COMPLETE, loadXMLCompleteListener);
		}
		
		private function loadXMLCompleteListener(e:Event):void {
			_model.removeEventListener(Model.LOAD_XML_COMPLETE, loadXMLCompleteListener);
			_model.addEventListener(Model.LOAD_ASSETS_COMPLETE, loadAssetsCompleteListener);
			version_txt.text = "Loading Assets...";
			Controller.getInstance().loadAssets();
			//gotoAndStop(EditorConstants.IDLE);
		}
		
		private function loadAssetsCompleteListener(e:Event):void {
			_model.removeEventListener(Model.LOAD_ASSETS_COMPLETE, loadAssetsCompleteListener);
			init();
			
		}
		
		private function init():void {
			gotoAndStop("APPLICATION")
			handleSelectCar(null);
			version_txt.text = VERSION;
		}
		
		public function applicationCallback():void {
			Debug.log("AZMMain -> applicationCallback()", true);
			selectBtn_Bus.addEventListener(MouseEvent.CLICK, handleSelectBus);
			selectBtn_Car.addEventListener(MouseEvent.CLICK, handleSelectCar);
			selectBtn_Train.addEventListener(MouseEvent.CLICK, handleSelectTrain);
			overzichtsplattergrond_btn.addEventListener(MouseEvent.CLICK, handleShowArea);
			print_btn.addEventListener(MouseEvent.CLICK, handleShowPrint);
			MenuManager.getInstance().addEventListener(MenuManager.HIDE_PRINT, handleHidePrint);
			RouteModel.getInstance().addEventListener(RouteModel.ROUTE_FINISHED , handleRouteFinished);
		}
		
		private function handleHidePrint(e:Event):void {
			MenuManager.getInstance().map.normalVersion();
			map.addChild(MenuManager.getInstance().map);
		}
		
		private function handleShowPrint(e:MouseEvent):void {
			MenuManager.getInstance().dispatch(MenuManager.SHOW_PRINT);
		}
		
		private function handleShowArea(e:MouseEvent):void {
			MenuManager.getInstance().dispatch(MenuManager.SHOW_AREA);
		}
		
		private function handleRouteFinished(e:Event):void {
			MenuManager.getInstance().dispatch(MenuManager.ROUTE_SELECTED);
		}
		
		private function handleSelectTrain(e:MouseEvent):void {
			Debug.log("AZMMain -> handleSelectTrain()", true);
			while (menuContainer.numChildren) {
				menuContainer.removeChildAt(0);
			}
			_menu = new Menu(_model.routes,"_1");
			menuContainer.addChild(_menu);
			selectBtn_Car.gotoAndStop("OFF");
			selectBtn_Train.gotoAndStop("ON");
			selectBtn_Bus.gotoAndStop("OFF");
			MenuManager.getInstance().currentTransportation = 1;
			MenuManager.getInstance().dispatch(MenuManager.TRANSPORTATION_CHANGED);
		}
		
		private function handleSelectCar(e:MouseEvent):void {
			Debug.log("AZMMain -> handleSelectCar()", true);
			while (menuContainer.numChildren) {
				menuContainer.removeChildAt(0);
			}
			_menu = new Menu(_model.routes,"_2");
			menuContainer.addChild(_menu);
			selectBtn_Car.gotoAndStop("ON");
			selectBtn_Train.gotoAndStop("OFF");
			selectBtn_Bus.gotoAndStop("OFF");
			MenuManager.getInstance().currentTransportation = 2;
			MenuManager.getInstance().dispatch(MenuManager.TRANSPORTATION_CHANGED);
		}
		
		private function handleSelectBus(e:MouseEvent):void {	
			Debug.log("AZMMain -> handleSelectBus()", true);
			while (menuContainer.numChildren) {
				menuContainer.removeChildAt(0);
			}
			_menu = new Menu(_model.routes,"_3");
			menuContainer.addChild(_menu);
			selectBtn_Car.gotoAndStop("OFF");
			selectBtn_Train.gotoAndStop("OFF");
			selectBtn_Bus.gotoAndStop("ON");
			MenuManager.getInstance().currentTransportation = 3;
			MenuManager.getInstance().dispatch(MenuManager.TRANSPORTATION_CHANGED);
		}
		
	}

}