//nl.photoreality.panorama.model.PanoramaModel
package nl.photoreality.panorama.model {
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import nl.photoreality.map_editor.model.vo.PanoramaVO;
	import nl.photoreality.utils.debug.Debug;
	
	
	public class PanoramaModel extends EventDispatcher {
		
		public static const INIT				: String			= "init";
		public static const ROTATION			: String			= "rotation";
		public static const TRANSITION			: String			= "transition";
		public static const TRANSITION_DONE		: String			= "transition";
		
		public static const ARROW_CLICK_LEFT	: String			= "arrowClickLeft";
		public static const ARROW_CLICK_RIGHT	: String			= "arrowClickRight";
		
		public static const MANUAL_ROTATION		: String			= "manual_transition";
		
		private static var instance			: PanoramaModel;
		
		private var _durationRotation		: Number;
		private var _durationTransition		: Number;
		private var _panoramaBitmapData		: BitmapData;
		private var _panoramaVO				: PanoramaVO;
		private var _rotation				: Number;
		
		private var _panoramaViewBitmapData	: BitmapData;
		
		private var _currentRotationForAngleIn		: Number;
		private var _currentRotationForAngleOut		: Number;
		
		
		public function PanoramaModel(enforcer:SingletonEnforcer) {
			Debug.log("PanoramaModel -> constructor");
		}
		
		public static function getInstance():PanoramaModel {
			if (PanoramaModel.instance == null) PanoramaModel.instance = new PanoramaModel(new SingletonEnforcer());
			return PanoramaModel.instance;
		}
		
		public function dispatch(evtString:String):void {
			Debug.log("PanoramaModel -> dispatch(" + evtString + ")");
			dispatchEvent(new Event(evtString));
		}
		
		
		//-- Getters & Setters
		public function get durationRotation():Number { return _durationRotation; }
		public function set durationRotation(value:Number):void {
			_durationRotation = value;
		}
		
		public function get durationTransition():Number { return _durationTransition; }
		public function set durationTransition(value:Number):void {
			_durationTransition = value;
		}
		
		public function get panoramaVO():PanoramaVO { return _panoramaVO; }
		public function set panoramaVO(value:PanoramaVO):void {
			_panoramaVO = value;
		}
		
		public function get panoramaBitmapData():BitmapData { return _panoramaBitmapData; }
		public function set panoramaBitmapData(value:BitmapData):void {
			_panoramaBitmapData = value;
		}
		
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void {
			_rotation = value;
		}
		
		
		
		public function get currentRotationForAngleIn():Number 
		{
			return _currentRotationForAngleIn;
		}
		
		public function set currentRotationForAngleIn(value:Number):void 
		{
			_currentRotationForAngleIn = value;
		}
		
		public function get currentRotationForAngleOut():Number 
		{
			return _currentRotationForAngleOut;
		}
		
		public function set currentRotationForAngleOut(value:Number):void 
		{
			_currentRotationForAngleOut = value;
		}
		
		public function get panoramaViewBitmapData():BitmapData 
		{
			return _panoramaViewBitmapData;
		}
		
		public function set panoramaViewBitmapData(value:BitmapData):void 
		{
			_panoramaViewBitmapData = value;
		}
	}
}

class SingletonEnforcer { }