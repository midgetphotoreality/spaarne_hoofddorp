// nl.photoreality.online_viewer.view.print.PrintViewMc
package nl.photoreality.online_viewer.view.print 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.online_viewer.manager.MenuManager;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class PrintViewMc extends MovieClip{
		private var _menuManager		: MenuManager;
		
		public var printknop			: SimpleButton; 
		public var printknopterug		: SimpleButton; 
		public var printA4				: PrintA4; 
		
		
		public function PrintViewMc() {
			Debug.log("PrintViewMc -> constructor");
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_menuManager = MenuManager.getInstance();
			visible = false
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
			//_menuManager.addEventListener(MenuManager.ROUTE_SELECTED, routeSelectedListener);
			_menuManager.addEventListener(MenuManager.PRINT, printListener);
			
			printknop.addEventListener(MouseEvent.CLICK, handlePrint);
			printknopterug.addEventListener(MouseEvent.CLICK, handleBack);
			//init();
		}
		
		private function removeListeners():void {
			//_menuManager.removeEventListener(MenuManager.ROUTE_SELECTED, routeSelectedListener);
			_menuManager.removeEventListener(MenuManager.PRINT, printListener);
			printknop.removeEventListener(MouseEvent.CLICK, handlePrint);
			printknopterug.removeEventListener(MouseEvent.CLICK, handleBack);
		}
		
		private function printListener(e:Event):void 
		{
			Debug.log("PrintViewMc -> printListener");
			visible = true;
			//container_floor1.scaleX = container_floor1.scaleY = .6
			//container_floor2.scaleX = container_floor2.scaleY = .6
			//container_floor1.addChild(_menuManager.floor1Bitmap);
			//container_floor2.addChild(_menuManager.floor2Bitmap);
			printA4.init(RouteModel.getInstance().selectedRouteVO);
		}
		
		private function handleBack(e:MouseEvent):void 
		{
			visible = false;
			_menuManager.dispatch(MenuManager.PRINT_CLOSE);
		}
		
		private function handlePrint(e:MouseEvent):void 
		{
			printA4.print();
		}
		
	}

}