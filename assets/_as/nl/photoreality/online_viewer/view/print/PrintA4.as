// nl.photoreality.online_viewer.view.print.PrintA4
package nl.photoreality.online_viewer.view.print {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;
	import flash.text.TextField;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.vo.PanoramaVO;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.online_viewer.manager.MenuManager;
	import nl.photoreality.panorama.model.PanoramaModel;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class PrintA4 extends MovieClip	{
		private var _menuManager		: MenuManager;
		public var koptekst				: TextField;
		public var bgtekst				: TextField;
		public var verdtekst			: TextField;
		public var verdtekst1			: TextField;
		
		public var A4					: MovieClip; 
		public var container_floor1		: MovieClip; 
		public var container_floor2		: MovieClip; 
		public var pano_container		: MovieClip; 
		
		
		
		public function PrintA4() 
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_menuManager = MenuManager.getInstance();
			//visible = false
		}
		
		//-- Stage Listeners
		private function addedToStageListener(e:Event):void {
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			addListeners();
		}
		
		private function removedFromStageListener(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
			removeListeners();
		}
		
		private function addListeners():void {
			_menuManager.addEventListener(MenuManager.PRINT_PANO_PENDING, handlePanoPending);
			_menuManager.addEventListener(MenuManager.PRINT_PANO_LOADED, handlePanoLoaded);
		}
		
		private function removeListeners():void {
			_menuManager.removeEventListener(MenuManager.PRINT_PANO_PENDING, handlePanoPending);
			_menuManager.removeEventListener(MenuManager.PRINT_PANO_LOADED, handlePanoLoaded);
		}
		
		private function handlePanoPending(e:Event):void {
			while (pano_container.numChildren) {
				pano_container.removeChildAt(0);
			}
		}
		
		private function handlePanoLoaded(e:Event):void {
			pano_container.addChild(_menuManager.printPanoramaBitmap);
			//pano_container.scaleX = pano_container.scaleY = .3;
			var newW:Number 		= 158;
			var newH:Number 		= _menuManager.printPanoramaBitmap.height * newW / _menuManager.printPanoramaBitmap.width;
			pano_container.width 	= newW;
			pano_container.height 	= newH;
			
			Debug.log("PrintA4 -> handlePanoLoaded, newW: " + newW + ", newH: " + newH );
		}
		
		public function init(route:RouteVO):void {
			koptekst.text 		= route.name;
			bgtekst.text		= route.labels[0].label;
			verdtekst.text  	= "";
			verdtekst1.text  	= route.name;
			if (route.floors[0].id != route.floors[1].id){
				verdtekst.text  = route.labels[1].label;
			}
			
			Debug.log("PrintA4 -> init, adding ROUTE");
			container_floor1.addChild(_menuManager.map);
			_menuManager.map.printVersion();
			/*
			var panoVO:PanoramaVO = MenuManager.getInstance().route.points[MenuManager.getInstance().route.points.length - 1].panorama;
			PanoramaModel.getInstance().panoramaBitmapData = getPanoramaBitmapData(panoVO.linkage);
			PanoramaModel.getInstance().panoramaVO = panoVO;
			PanoramaModel.getInstance().dispatch(PanoramaModel.INIT);
			*/
		}
		
		private function getPanoramaBitmapData(linkage:String):BitmapData {
			var linkageClass:Class = Model.getInstance().panos.contentLoaderInfo.applicationDomain.getDefinition(linkage) as Class;
			var bmpd:BitmapData = new linkageClass(0, 0) as BitmapData;
			return bmpd;
		}
		
		public function print():void {
			var options:PrintJobOptions = new PrintJobOptions();
			options.printAsBitmap = true;
			
			var myPrintJob:PrintJob = new PrintJob(); 
			if (myPrintJob.start()){
				try {
					A4.print_lines_mc.visible = false;
					this.scaleX = this.scaleY = 1.37;
					myPrintJob.addPage(this,new Rectangle(A4.x+10,A4.y,A4.width,A4.height), options);
					A4.print_lines_mc.visible = true;
					this.scaleX = this.scaleY = 1;
				}
				catch (error:Error){
					//vang foutmelding op als printopdracht wordt gecancelled
				}
				myPrintJob.send(); 
			}
		}
	}
}