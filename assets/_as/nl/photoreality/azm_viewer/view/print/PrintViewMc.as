// nl.photoreality.online_viewer.view.print.PrintViewMc
package nl.photoreality.azm_viewer.view.print 
{
	import fl.transitions.easing.Strong;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;
	import nl.photoreality.map_editor.model.RouteModel;
	import nl.photoreality.azm_viewer.manager.MenuManager;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class PrintViewMc extends MovieClip{
		private var _menuMan		: MenuManager;
		public var print_btn			: MovieClip;
		public var close_btn			: MovieClip;
		public var printA4			: MovieClip;
		public var container			: MovieClip;
		
		public function PrintViewMc() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			_menuMan = MenuManager.getInstance();
			visible = false;
			alpha = 0;
			
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
			_menuMan.addEventListener(MenuManager.SHOW_PRINT, handleShowArea);
			_menuMan.addEventListener(MenuManager.HIDE_PRINT, handleHideArea);
			close_btn.addEventListener(MouseEvent.CLICK, handleClose);
			print_btn.addEventListener(MouseEvent.CLICK, printListener);
		}
		
		private function removeListeners():void {
			_menuMan.removeEventListener(MenuManager.SHOW_PRINT, handleShowArea);
			_menuMan.removeEventListener(MenuManager.HIDE_PRINT, handleHideArea);
			close_btn.removeEventListener(MouseEvent.CLICK, handleClose);
			print_btn.removeEventListener(MouseEvent.CLICK, printListener);
		}
		
		private function handleShowArea(e:Event):void {
			visible = true;
			var myTween:Tween = new Tween(this, "alpha", Strong.easeOut, 0, 1, 10, true);
			container.addChild(_menuMan.map);
			_menuMan.map.printVersion();
		}
		
		private function handleFinished(e:TweenEvent):void 
		{
			visible = false;
			alpha = 0;
		}
		
		private function handleHideArea(e:Event):void {
			trace("handleHideArea")
			var myTween:Tween = new Tween(this, "alpha", Strong.easeOut, 1, 0, 10, true);
			myTween.addEventListener(TweenEvent.MOTION_FINISH, handleFinished);
		}
		
		private function handleClose(e:MouseEvent):void 
		{
			trace("handleClose")
			_menuMan.dispatch(MenuManager.HIDE_PRINT);
		}
		
		private function printListener(e:Event):void {
			print();
		}
		
		private function handlePrint(e:MouseEvent):void {
			
		}
		
		public function print():void {
			var options:PrintJobOptions = new PrintJobOptions();
			options.printAsBitmap = true;
			
			var myPrintJob:PrintJob = new PrintJob(); 
			if (myPrintJob.start()){
				try{
					
					myPrintJob.addPage(this, new Rectangle(printA4.x,printA4.y,printA4.width,printA4.height), options);
					
				}
				catch (error:Error){
					//vang foutmelding op als printopdracht wordt gecancelled
				}
				myPrintJob.send(); 
			}
		}
	}

}