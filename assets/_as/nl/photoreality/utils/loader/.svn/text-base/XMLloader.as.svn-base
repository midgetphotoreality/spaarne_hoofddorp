package nl.photoreality.utils.loader {
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.errors.IOError;	
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLVariables;
	
	public class XMLLoader extends EventDispatcher{
		
		private var _loader				: URLLoader;
		private  var _xml					: XML;
		private var _urlRequest		: URLRequest;
		private var _url					:String;
		private var _method			:String;
		private var _urlVariables		:URLVariables;
		
		public function XMLLoader(url:String = "", method:String = URLRequestMethod.POST) {
			_method = method;
			_url = url;
		}
		
		public function execute():void {
			
			_loader = new URLLoader();
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
			_loader.addEventListener(Event.COMPLETE, doneListener);
			_loader.addEventListener(ProgressEvent.PROGRESS, progressListener);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatuslistener);
			
			
			try {
				_urlRequest = new URLRequest(_url);
				_urlRequest.method = _method;
				
				if (_urlVariables) {
					_urlRequest.data = _urlVariables;			
				}			
				
				_loader.load(_urlRequest);
			} catch (e:IOError) {
				
				_error = "XMLLoader [" + _id + "] -> IOError exception: " + e.message
				handleError();
				
			} catch(e:SecurityError) {				
				
				_error = "XMLLoader [" + _id + "] -> SecurityError error exception: " + e.message;
				handleError();
				
			} catch (e:Error) {
				
				_error = "XMLLoader [" + _id + "] -> General error exception: " + e.message;
				handleError();
				
			}
		}
		
		private function handleError():void {
			removeListeners();
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, _error));
		}
		
		
		public function destroy():void {
			if (_loader) {
				removeListeners();				
				try {
					_loader.close();
					_loader = null;
				} catch (err:Error)	{
					trace("XMLLoader [" + _id + "] -> Cannot cleanup the XMLLoader: " + err.message, this);
				}				
			}
			
		}
		
		
		//listeners
		
		private function doneListener(e:Event):void {
			try {				
				_xml = new XML(_loader.data);		
				
				dispatchEvent(new Event(Event.COMPLETE));
				
			} catch (err:Error)	{
				
				_error = "XMLLoader [" + _id + "] -> XML markup error: " + err.message + "(" + _loader.data + ")";
				handleError();
			}		
			
			removeListeners();
		}
		
		
		private function progressListener(e:ProgressEvent):void {
			if(!isNaN(e.bytesLoaded) && !isNaN(e.bytesTotal)) {
				_progress = Math.round((e.bytesLoaded / e.bytesTotal) * 100);
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, e.bytesLoaded, e.bytesTotal));
			}
		}
				
		
		private function removeListeners():void {
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
			_loader.removeEventListener(Event.COMPLETE, doneListener);
			_loader.removeEventListener(ProgressEvent.PROGRESS, progressListener);
			_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatuslistener);
		}
		
		private function ioErrorListener(e:IOErrorEvent):void {			
			_error = "XMLLoader [" + _id + "] -> IO error event: " + e;
			handleError();			
		}
		
		private function securityErrorListener(e:SecurityErrorEvent):void {
			_error = "XMLLoader [" + _id + "] -> security error event: " + e;
			handleError();
		}
		
		private function httpStatuslistener(e:HTTPStatusEvent):void {
			switch (e.status) {
				case 400:
					_error = "XMLLoader [" + _id + "] -> 400 Bad Request";
					handleError();
					break;
				
				case 401:
					_error = "XMLLoader [" + _id + "] -> 401 Unauthorized";
					handleError();
					break;
					
				case 402:
					_error = "XMLLoader [" + _id + "] -> client error: 402 Payment Required";
					handleError();
					break;
					
				case 403:
					_error = "XMLLoader [" + _id + "] -> client error: 403 Forbidden";
					handleError();
					break;
					
				case 404:
					_error = "XMLLoader [" + _id + "] -> client error: 404 Not Found";
					handleError();
					break;
					
				case 405:
					_error = "XMLLoader [" + _id + "] -> client error: 405 Method Not Allowed";
					handleError();
					break;
					
				case 406:
					_error = "XMLLoader [" + _id + "] -> client error: 406 Not Acceptable";
					handleError();
					break;
					
				case 407:
					_error = "XMLLoader [" + _id + "] -> client error: 407 Proxy Authentication Required";
					handleError();
					break;
					
				case 408:
					_error = "XMLLoader [" + _id + "] -> client error: 408 Request Timeout";
					handleError();
					break;
					
				case 409:
					_error = "XMLLoader [" + _id + "] -> client error: 409 Conflict";
					handleError();
					break;
					
				case 410:
					_error = "XMLLoader [" + _id + "] -> client error: 410 Gone";
					handleError();
					break;
					
				case 411:
					_error = "XMLLoader [" + _id + "] -> client error: 411 Length Required";
					handleError();
					break;
					
				case 412:
					_error = "XMLLoader [" + _id + "] -> client error: 412 Precondition Failed";
					handleError();
					break;
					
				case 413:
					_error = "XMLLoader [" + _id + "] -> client error: 413 Request Entity Too Large";
					handleError();
					break;
					
				case 414:
					_error = "XMLLoader [" + _id + "] -> client error: 414 Request-URI Too Long";
					handleError();
					break;
					
				case 415:
					_error = "XMLLoader [" + _id + "] -> client error: 415 Unsupported Media Type";
					handleError();
					break;
					
				case 416:
					_error = "XMLLoader [" + _id + "] -> client error: 416 Requested Range Not Satisfiable";
					handleError();
					break;
					
				case 417:
					_error = "XMLLoader [" + _id + "] -> client error: 417 Expectation Failed";
					handleError();
					break;				
			}
		}
		
		public function get xml():XML { 
			return _xml; 
		}
		
	}
}