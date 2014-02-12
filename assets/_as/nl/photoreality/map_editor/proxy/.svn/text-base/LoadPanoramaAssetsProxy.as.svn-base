package nl.photoreality.map_editor.proxy 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import nl.photoreality.map_editor.controller.Controller;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2010
	 */
	public class LoadPanoramaAssetsProxy
	{
		private var _assetsFile		: String;
		private var _controller			: Controller;
		private var _loader				: Loader;
		private var _request			: URLRequest;
	
		
		public function LoadPanoramaAssetsProxy(assetsFile:String) {
			_assetsFile 		= assetsFile;
			_controller			= Controller.getInstance();
		}
		public function execute():void {
			_loader 			= new Loader();
			_request 			= new URLRequest(_assetsFile);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
			_loader.load(_request);
		}
		
		private function handleComplete(e:Event):void {
			//trace("LoadAssetsProxy -> handleComplete");
			_controller.loadPanoramaAssetsDone(_loader);
		}
		
	}

}

/*
 * import flash.net.URLRequest;
import flash.display.Loader;
import flash.events.Event;
import flash.events.ProgressEvent;

function startLoad()
{
var mLoader:Loader = new Loader();
var mRequest:URLRequest = new URLRequest(“MouseActions.swf”);
mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
mLoader.load(mRequest);
}

function onCompleteHandler(loadEvent:Event)
{
        addChild(loadEvent.currentTarget.content);
}
function onProgressHandler(mProgress:ProgressEvent)
{
var percent:Number = mProgress.bytesLoaded/mProgress.bytesTotal;
trace(percent);
}
startLoad();
*/