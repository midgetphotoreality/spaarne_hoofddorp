//nl.photoreality.map_editor.proxy.LoadPanoramaProxy
package nl.photoreality.map_editor.proxy {
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import nl.photoreality.map_editor.controller.Controller;
	
	
	public class LoadPanoramaProxy {
		
		private var _url		: String;
		private var _loader		: Loader;
		
		
		public function LoadPanoramaProxy(url:String) {
			_url = url;
		}
		
		public function execute():void {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteListener);
			_loader.load(new URLRequest(_url));
		}
		
		private function loaderCompleteListener(e:Event):void {
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteListener);
			Controller.getInstance().loadPanoramaDone(_loader);
		}
	}
}