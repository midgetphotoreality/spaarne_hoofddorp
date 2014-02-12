package nl.photoreality.map_editor.manager 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.map_editor.model.vo.RouteVO;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class PanoAssetsLoadManager extends EventDispatcher
	{
		
		public static const		LOAD_COMPLETE	: String	= "loadComplete";
		public static const		MODE_SWF		: String = "mode_swf"
		public static const		MODE_JPG		: String = "mode_jpg"
		
		public static const		PANO_EXISTS		:String = "pano_exists";
		public static const		PANO_FAIL		:String = "pano_fail";
		
		private static var instance				: PanoAssetsLoadManager;
		
		private var _panos						: Object;
		private var _minimumPanosLoaded			: int = 3;
		private var _currentRoute				: RouteVO;
		private var _currentPanoToLoad			: int = 0;
		private var _currentRouteLoaded			: Boolean = false;
		
		private var _panoLoader					: Loader;
		private var _panoRequest				: URLRequest;
		
		//private var _testPanoLoader				: Loader;
		//private var _testPanoRequest			: URLRequest;
		
		private var _mode						: String = MODE_JPG;
		
		public function PanoAssetsLoadManager(enforcer:SingletonEnforcer) {
			_panos							= new Object();
		}
		
		public static function getInstance():PanoAssetsLoadManager {
			if (PanoAssetsLoadManager.instance == null) PanoAssetsLoadManager.instance = new PanoAssetsLoadManager(new SingletonEnforcer());
			return PanoAssetsLoadManager.instance;
		}
		
		public function dispatch(evtString:String):void {
			trace("Model -> dispatch(" + evtString + ")");
			dispatchEvent(new Event(evtString));
		}
		
		
		public function loadRoute(route:RouteVO):void {
			Debug.log("PanoAssetsLoadManager -> loadRoute: " + route.name);
			if (_panoLoader) {
				removeLoaderListeners();
				
				if (!_currentRouteLoaded) {
					try {
						_panoLoader.close();
					} catch (e:Error) {
						
					}
				}
			}
			_currentRouteLoaded	= false;
			_currentRoute		= route;
			_currentPanoToLoad	= 0;
			startLoading();
		}
		
		private function startLoading():void {
			Debug.log("PanoAssetsLoadManager -> startLoading: " + _currentPanoToLoad + " / " + _currentRoute.points.length);
			
			if ( _currentPanoToLoad < _currentRoute.points.length - 1) {
				
				if ( (_currentRoute.points[_currentPanoToLoad].panorama)  &&  (_panos["pano_" + _currentRoute.points[_currentPanoToLoad].panorama.linkage])) {
					_currentPanoToLoad++;
					startLoading();
					
				} else {
					loadPano();
				}
				
			} else {
				Debug.log("PanoAssetsLoadManager -> startLoading DONE");
				_currentRouteLoaded	= true;
				dispatch(PanoAssetsLoadManager.LOAD_COMPLETE);
			}
		}
		
		private function loadPano():void {
			Debug.log("PanoAssetsLoadManager -> loadPano: "+_currentPanoToLoad + ", " + "assets/pano/" + _currentRoute.points[_currentPanoToLoad].panorama.linkage + ".jpg");
			_panoLoader			= new Loader();
			_panoLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onPanoProgress);
			_panoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPanoReady);
			_panoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			_panoRequest		= new URLRequest("assets/pano/" + _currentRoute.points[_currentPanoToLoad].panorama.linkage + ".jpg");
			_panoLoader.load(_panoRequest);
		}
		
		private function onIOError(e:IOErrorEvent):void {
			removeLoaderListeners();
		}
		
		private function onPanoReady(e:Event):void {
			removeLoaderListeners();
			
			if (_panoLoader.content) {
				var bmp:Bitmap = Bitmap(_panoLoader.content);
				//Debug.log("ON PANO READY GET PANO JPG YAAAY " + _currentRoute.points[_currentPanoToLoad].panorama.linkage);
				_panos["pano_" + _currentRoute.points[_currentPanoToLoad].panorama.linkage] = bmp.bitmapData;
				_currentPanoToLoad++;
				startLoading();
			}
		}
		
		private function onPanoProgress(e:ProgressEvent):void {
			
		}
		
		private function removeLoaderListeners():void {
			_panoLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onPanoProgress);
			_panoLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onPanoReady);
			_panoLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		
		//private var _testPanoLoader			: Loader;
		//private var _testPanoRequest			: URLRequest;
		public function jpgPanoExists(linkage:String):void {
			var testPanoLoader:Loader			= new Loader();
			//testPanoLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onTestPanoProgress);
			testPanoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTestPanoReady);
			testPanoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onTestIOError);
			testPanoLoader.load(new URLRequest("assets/pano/" + linkage + ".jpg"));
		}
		
		private function onTestIOError(e:IOErrorEvent):void {
			dispatch(PANO_FAIL);
		}
		
		private function onTestPanoReady(e:Event):void {
			dispatch(PANO_EXISTS);
		}
		
		
		public function getPano(linkage:String):BitmapData {
			if (_mode == MODE_JPG) {
				return getPanoJpg(linkage);
			}
			return getPanoSwf(linkage);
		}
		
		private function getPanoSwf(linkage:String):BitmapData {
			var linkageClass:Class = Model.getInstance().panos.contentLoaderInfo.applicationDomain.getDefinition(linkage) as Class;
			var bmpd:BitmapData = new linkageClass(0, 0) as BitmapData;
			return bmpd;
		}
		
		private function getPanoJpg(linkage:String):BitmapData {
			//Debug.log("GET PANO JPG YAAAY " + linkage);
			if ( _panos["pano_" + linkage] ) {
				//Debug.log("YAAAY");
				return BitmapData( _panos["pano_" + linkage] );
			}
			return new BitmapData(2, 2);
		}
		
		public function get currentRouteLoaded():Boolean { return _currentRouteLoaded; }
		
		public function set currentRouteLoaded(value:Boolean):void 
		{
			_currentRouteLoaded = value;
		}
	}

}
class SingletonEnforcer { }