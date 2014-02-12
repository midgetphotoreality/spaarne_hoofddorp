// nl.photoreality.online_viewer.view.ViewerMain 
package nl.photoreality.online_viewer.view 
{
	import com.greensock.TweenLite;
	import fl.controls.Slider;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import nl.photoreality.map_editor.controller.Controller;
	import nl.photoreality.map_editor.controller.RouteController;
	import nl.photoreality.map_editor.manager.PanoAssetsLoadManager;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.map_editor.model.vo.RoutePointVO;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.online_viewer.manager.MenuManager;
	import nl.photoreality.online_viewer.view.menu.Menu;
	import nl.photoreality.panorama.model.PanoramaModel;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // DioVoiD 2012
	 */
	public class ViewerMain extends MovieClip
	{
		public static const VERSION			:String = "Laatst gewijzigd: 25 juli 2012";
		
		private var _menu					: Menu;
		private var _routes					: Vector.<RouteVO>;
		public var version_txt				: TextField
		public var txt_output				: TextField
		public var txt_status				: TextField
		private var _model					: Model;
		public var virtual_btn				: SimpleButton;
		public var printvoorbeeldknop		: SimpleButton;
		
		public var print_container			: MovieClip;
		public var area_container			: MovieClip;
		public var bg						: MovieClip;
		public var pano						: MovieClip;
		public var map						: MovieClip;
		public var logo						: MovieClip;
		public var pano_arrow_left_btn		: SimpleButton;
		public var pano_arrow_right_btn		: SimpleButton;
		public var pano_close_btn			: MovieClip;
		public var pano_next_btn			: SimpleButton;
		public var pano_slider				: Slider;
		
		private var _currentRoute			: RouteVO;
		
		private var _panosLoaded			: Boolean = false;
		
		public function ViewerMain() {
			_model = Model.getInstance();
			stop();
			//trace("ViewerMain -> constructor", this);
			//Debug.registerStatusTextfield(txt_status);
			txt_status.visible = false;
			//Debug.status("Starting app")
			//Debug.registerTextfield(txt_output);
			txt_output.visible = false;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
			loadXML();
			
			//if (initVars()) {
				//trace("ViewerMain -> addedToStageListener -> calling init()", this);
				//init();
			//}
			//version_txt.text = VERSION;
			
			//init();
			
			pano_slider.minimum = 0;
			pano_slider.maximum = 100;
			pano_slider.value = 20;
			pano_slider.visible = false;
			pano_slider.addEventListener(Event.CHANGE, sliderChangeListener);
			sliderChangeListener(null);
		}
		
		private function sliderChangeListener(e:Event):void {
			RouteController.getInstance().setArrowSpeedPercentage(pano_slider.value / 100);
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
			//destroy();
		}
		
		private function addListeners():void {
			
		}
		
		private function removeListeners():void {
			MenuManager.getInstance().removeEventListener(MenuManager.ROUTE_SELECTED , handleRoute);
			MenuManager.getInstance().removeEventListener(MenuManager.SHOW_AREA , handleShowArea);
			MenuManager.getInstance().removeEventListener(MenuManager.HIDE_AREA , handleHideArea);
			RouteModel.getInstance().removeEventListener(RouteModel.ROUTE_FINISHED , handleRouteFinished);
			//RouteModel.getInstance().removeEventListener(RouteModel.ROUTE_SELECTED, handleRoute);
			virtual_btn.removeEventListener(MouseEvent.CLICK, handleVirtualTour);
			pano_arrow_left_btn.removeEventListener(MouseEvent.CLICK, handlePanoArrowLeft);
			pano_arrow_right_btn.removeEventListener(MouseEvent.CLICK, handlePanoArrowRight);
			pano_close_btn.removeEventListener(MouseEvent.CLICK, handlePanoClose);
			pano_next_btn.removeEventListener(MouseEvent.CLICK, handlePanoNext);
			
			PanoramaModel.getInstance().removeEventListener(PanoramaModel.INIT, panoInitListener);
			PanoramaModel.getInstance().removeEventListener(PanoramaModel.MANUAL_ROTATION, panoManualRotationListener);
		}
		
		private function panoInitListener(e:Event):void {
			hidePanoNext();
		}
		
		private function panoManualRotationListener(e:Event):void {
			showPanoNext();
		}
		
		private function handleRouteFinished(e:Event):void {
			MenuManager.getInstance().dispatch(MenuManager.ROUTE_SELECTED);
		}
		
		private function handleRoute(e:Event):void {
			if (_currentRoute != MenuManager.getInstance().route) {
				_currentRoute = MenuManager.getInstance().route
				PanoAssetsLoadManager.getInstance().loadRoute(MenuManager.getInstance().route);
			}
			
			Debug.log( "ViewerMain -> handleRoute", true );
			if (!pano.visible){
				virtual_btn.visible 	= true;
				if (PanoAssetsLoadManager.getInstance().currentRouteLoaded) {
					Debug.log( "ViewerMain -> handleRoute, Current route loaded!", true );
					virtual_btn.alpha = 1
				}else {
					Debug.log( "ViewerMain -> handleRoute, Current route NOT loaded!", true );
					virtual_btn.alpha = .5;
					PanoAssetsLoadManager.getInstance().addEventListener(PanoAssetsLoadManager.LOAD_COMPLETE, handleRoutePanosLoad);
				}
				
			//	print_container.visible 	= true;
				area_container.visible 		= true;
				logo.visible 				= true;
				printvoorbeeldknop.visible 	= true;
			}
			
			MenuManager.getInstance().dispatch(MenuManager.VIRTUAL_TOUR_STATE_CHANGED);
		}
		
		private function handleRoutePanosLoad(e:Event):void 
		{
			virtual_btn.alpha = 1;
			Debug.log( "ViewerMain -> handleRoutePanosLoad", true );
		}
		
		private function handleVirtualTour(e:MouseEvent):void {
			trace("ViewerMain -> handleVirtualTour");
			if (virtual_btn.alpha == 1) {
				initVirtualTour();
				MenuManager.getInstance().virtualTourIsOpen = true;
				MenuManager.getInstance().dispatch(MenuManager.ROUTE_SELECTED);
				MenuManager.getInstance().dispatch(MenuManager.VIRTUAL_TOUR_STATE_CHANGED);
				virtual_btn.visible 	= false;
				printvoorbeeldknop.visible = false;
				//print_container.visible = false;
				area_container.visible 	= false;
				logo.visible 	= false;
				//area_container.visible 	= false;
				
				pano.visible = true; // can go
				pano_arrow_left_btn.visible = true;
				pano_arrow_right_btn.visible = true;
				pano_slider.visible = true;
				bg.gotoAndStop("BG_PANO");
				MenuManager.getInstance().hideMenu();
			}
		}
		
		private function handlePanoClose(e:MouseEvent):void {
			deinitVirtualToue();
			MenuManager.getInstance().virtualTourIsOpen = false;
			MenuManager.getInstance().dispatch(MenuManager.ROUTE_SELECTED);
			MenuManager.getInstance().dispatch(MenuManager.VIRTUAL_TOUR_STATE_CHANGED);
			virtual_btn.visible 	= true;
			printvoorbeeldknop.visible = true;
			//print_container.visible = true;
			area_container.visible 	= true;
			logo.visible 	= true;
			//area_container.visible 	= false;
			
			pano.visible = false; // can go
			pano_arrow_left_btn.visible = false;
			pano_arrow_right_btn.visible = false;
			pano_slider.visible = false;
			bg.gotoAndStop("BG_NORMAL");
			MenuManager.getInstance().showMenu();
		}
		
		private function handlePanoNext(e:MouseEvent):void {
			RouteController.getInstance().playRouteNextPoint();
			hidePanoNext();
		}
		
		private function showPanoNext():void {
			pano_next_btn.visible = true;
			pano_next_btn.enabled = true;
		}
		
		private function hidePanoNext():void {
			pano_next_btn.visible = false;
			pano_next_btn.enabled = false;
		}
		
		public function applicationCallback():void {
			trace("ViewerMain -> applicationCallback")
			virtual_btn.visible 	= false;
			print_container.visible = false;
			area_container.visible 	= true;
			pano.visible 			= false;
			pano_arrow_left_btn.visible = false;
			pano_arrow_right_btn.visible = false;
			pano_slider.visible = false;
			print_container.visible 	= false;
			printvoorbeeldknop.visible 	= false;
		//	map.visible 			= false;
			bg.gotoAndStop("BG_NORMAL");
			//bg.visible 				= false;
			MenuManager.getInstance().addEventListener(MenuManager.SHOW_AREA , handleShowArea);
			MenuManager.getInstance().addEventListener(MenuManager.HIDE_AREA , handleHideArea);
			MenuManager.getInstance().addEventListener(MenuManager.ROUTE_SELECTED , handleRoute);
			MenuManager.getInstance().addEventListener(MenuManager.PRINT_CLOSE , handlePrintClose);
			RouteModel.getInstance().addEventListener(RouteModel.ROUTE_FINISHED , handleRouteFinished);
			MenuManager.getInstance().addEventListener(MenuManager.PRINT_FROM_MENU, handlePrintFromMenu);
			// RouteModel.getInstance().addEventListener(RouteModel.ROUTE_SELECTED, handleRoute);
			virtual_btn.addEventListener(MouseEvent.CLICK, handleVirtualTour);
			pano_arrow_left_btn.addEventListener(MouseEvent.CLICK, handlePanoArrowLeft);
			pano_arrow_right_btn.addEventListener(MouseEvent.CLICK, handlePanoArrowRight);
			pano_close_btn.addEventListener(MouseEvent.CLICK, handlePanoClose);
			pano_next_btn.addEventListener(MouseEvent.CLICK, handlePanoNext);
			printvoorbeeldknop.addEventListener(MouseEvent.CLICK, handlePrint);
			version_txt.text = _model.settings.version;
			PanoramaModel.getInstance().addEventListener(PanoramaModel.INIT, panoInitListener);
			PanoramaModel.getInstance().addEventListener(PanoramaModel.MANUAL_ROTATION, panoManualRotationListener);
		}
		
		private function handlePanoArrowLeft(e:Event):void {
			PanoramaModel.getInstance().dispatch(PanoramaModel.ARROW_CLICK_LEFT);
		}
		
		private function handlePanoArrowRight(e:Event):void {
			PanoramaModel.getInstance().dispatch(PanoramaModel.ARROW_CLICK_RIGHT);
		}
		
		private function handlePrintFromMenu(e:Event):void 
		{
			handlePrint(null);
		}
		
		private function handlePrintClose(e:Event):void 
		{
			pano.visible 			= false;
			map.addChild(MenuManager.getInstance().map);
			MenuManager.getInstance().map.normalVersion();
			MenuManager.getInstance().showMenu();
		}
		
		private function handlePrint(e:MouseEvent):void 
		{
			initVirtualTour();
			
			if (MenuManager.getInstance().route.points.length > 2) {
				MenuManager.getInstance().dispatch(MenuManager.PRINT_PANO_PENDING);
				var point: RoutePointVO = MenuManager.getInstance().route.points[MenuManager.getInstance().route.points.length - 2];
				PanoramaModel.getInstance().panoramaBitmapData = getPanoramaBitmapData(point.panorama.linkage);
				PanoramaModel.getInstance().panoramaVO = point.panorama;
				//TweenLite.delayedCall(0.5, handlePrintForReal);
				pano.visible 			= true;
				//bg.gotoAndStop("BG_PANO");
				
				TweenLite.delayedCall(0.5, handlePrintForReal);
			}
			MenuManager.getInstance().hideMenu();
			MenuManager.getInstance().print();
			
			//TweenLite.delayedCall(1, MenuManager.getInstance().print);
		}
		
		private function handlePrintForReal():void {
			PanoramaModel.getInstance().dispatch(PanoramaModel.INIT);
			//MenuManager.getInstance().printPanoramaDone(bmp:B);
			TweenLite.delayedCall(5, handlePrintBitmapDone);
		}
		
		private function handlePrintBitmapDone():void {
			// 560 x 340
			var bmpData:BitmapData = new BitmapData(560, 340);
			bmpData.draw(PanoramaModel.getInstance().panoramaViewBitmapData);
			//bmpData.draw( stage );
			//stage.stage3Ds[0].context3D.drawToBitmapData(bmpData);
			Debug.log("ViewerMain -> handlePrintBitmapDone()");
			var bitmap:Bitmap = new Bitmap(bmpData);
			bitmap.x = 0;
			bitmap.y = 0;
			MenuManager.getInstance().printPanoramaBitmap = bitmap;
			MenuManager.getInstance().dispatch(MenuManager.PRINT_PANO_LOADED);
			
			//addChild(bitmap);
		}
		
		private function getPanoramaBitmapData(linkage:String):BitmapData {
			return PanoAssetsLoadManager.getInstance().getPano(linkage);
			/*var linkageClass:Class = Model.getInstance().panos.contentLoaderInfo.applicationDomain.getDefinition(linkage) as Class;
			var bmpd:BitmapData = new linkageClass(0, 0) as BitmapData;
			return bmpd;
			*/
		}
		
		
		private function handleShowArea(e:Event):void {
			printvoorbeeldknop.visible = false;
			virtual_btn.visible 	= false;
			map.visible 			= false;
		}
		
		private function handleHideArea(e:Event):void {
			if (_currentRoute){
				printvoorbeeldknop.visible = true;
				virtual_btn.visible 	= true;
			}
			map.visible 			= true;;
		}
		
		
		private function init():void {
			gotoAndStop("APPLICATION")
			_menu = new Menu(_model.routes);
			addChild(_menu);
			//version_txt.text = VERSION;
		}
		
		private function loadXML():void {
			//version_txt.text = "Loading XML...";
			Controller.getInstance().loadXML();
			_model.addEventListener(Model.LOAD_XML_COMPLETE, loadXMLCompleteListener);
		}
		
		private function loadXMLCompleteListener(e:Event):void {
			_model.removeEventListener(Model.LOAD_XML_COMPLETE, loadXMLCompleteListener);
			_model.addEventListener(Model.LOAD_ASSETS_COMPLETE, loadAssetsCompleteListener);
			//version_txt.text = "Loading Assets...";
			Controller.getInstance().loadAssets();
			//gotoAndStop(EditorConstants.IDLE);
		}
		
		private function loadAssetsCompleteListener(e:Event):void {
			_model.removeEventListener(Model.LOAD_ASSETS_COMPLETE, loadAssetsCompleteListener);
			init();
			
			//version_txt.text = "Loading Panorama...";
			//version_txt.text = VERSION;// "Loading Panorama...";
			
			_model.addEventListener(Model.LOAD_PANORAMA_ASSETS_COMPLETE, loadPanoramaAssetsDone);
			if(!runsInIDE()){
				Controller.getInstance().loadPanorama();
				//Controller.getInstance().loadPanoramaAssets();
			}
		}
		
		private function loadPanoramaAssetsDone(e:Event):void {
			_model.removeEventListener(Model.LOAD_PANORAMA_ASSETS_COMPLETE, loadPanoramaAssetsDone);
			
			_model.addEventListener(Model.LOAD_PANORAMA_COMPLETE, loadPanoramaDone);
			Controller.getInstance().loadPanorama();
		}
		
		private function loadPanoramaDone(e:Event):void {
			//version_txt.text = "Initing...";
			_model.removeEventListener(Model.LOAD_PANORAMA_COMPLETE, loadPanoramaDone);
			_panosLoaded = true;
			//initVirtualTour();
		}
		
		private function initVirtualTour():void {
			deinitVirtualToue();
			pano.addChild(_model.panorama.content);
			//version_txt.text = VERSION;
		}
		
		private function deinitVirtualToue():void {
			while (pano.numChildren) {
				pano.removeChildAt(0);
			}
			//pano.addChild(_model.panorama.content);
			//version_txt.text = VERSION;
		}
		
		
		
		
		private function initVars():Boolean {
			_routes = new Vector.<RouteVO>();
			_routes.push(new RouteVO("aRoute1", null, null));
			_routes.push(new RouteVO("aRoute2", null, null));
			_routes.push(new RouteVO("aRoute3", null, null));
			_routes.push(new RouteVO("aRoute4", null, null));
			_routes.push(new RouteVO("bRoute1", null, null));
			_routes.push(new RouteVO("cRoute1", null, null));
			_routes.push(new RouteVO("dRoute1", null, null));
			_routes.push(new RouteVO("eRoute1", null, null));
			_routes.push(new RouteVO("fRoute1", null, null));
			_routes.push(new RouteVO("gRoute1", null, null));
			_routes.push(new RouteVO("hRoute1", null, null));
			_routes.push(new RouteVO("iRoute1", null, null));
			_routes.push(new RouteVO("jRoute1", null, null));
			_routes.push(new RouteVO("kRoute1", null, null));
			_routes.push(new RouteVO("lRoute1", null, null));
			_routes.push(new RouteVO("mRoute1", null, null));
			_routes.push(new RouteVO("nRoute1", null, null));
			_routes.push(new RouteVO("oRoute1", null, null));
			_routes.push(new RouteVO("pRoute1", null, null));
			_routes.push(new RouteVO("qRoute1", null, null));
			_routes.push(new RouteVO("rRoute1", null, null));
			_routes.push(new RouteVO("sRoute1", null, null));
			_routes.push(new RouteVO("tRoute1", null, null));
			_routes.push(new RouteVO("uRoute1", null, null));
			_routes.push(new RouteVO("vRoute1", null, null));
			_routes.push(new RouteVO("wRoute1", null, null));
			_routes.push(new RouteVO("xRoute1", null, null));
			_routes.push(new RouteVO("yRoute1", null, null));
			_routes.push(new RouteVO("zRoute1", null, null));
			
			return true;
		}
		
		public function runsInIDE():Boolean {
			if (Capabilities.playerType == "External") {
				return true;
			}
			return false;
		}
	}

}