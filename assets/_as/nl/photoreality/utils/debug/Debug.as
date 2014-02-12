package nl.photoreality.utils.debug 
{
	import flash.text.TextField;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2012
	 */
	public class Debug {
		
		private static var _txt:TextField;
		private static var _txtStatus:TextField;
		private static var _debugString:String = "";
		
		private static var _oldDebugString:String = "";
		public function Debug() {
			
		}
		
		public static function log(str:String,doTrace:Boolean = false):void {
			var _date:Date = new Date();
			if (doTrace) {
				trace( "Debug -> log: "+ _date.hours + ":" + _date.minutes + ":" + _date.seconds + " - " + str );
			}
			logString( _date.hours + ":" + _date.minutes + ":" + _date.seconds + " - " + str );
		}
		
		private static function logString(str:String):void {
			_debugString =str + "\n" + _debugString;
			try {
				// _txt.text = _debugString;
			}catch (err:Error){
				
			}
		}
		
		public static function status(str:String, doTrace:Boolean = true) {
			if (doTrace) {
				trace( "Debug -> STATUS: "+ str );
			}
			statusString(str);
		}
		
		private static function statusString(str:String):void {
			//_debugString =str + "\n" + _debugString;
			try {
				 _txtStatus.text = str;
			}catch (err:Error){
				
			}
		}
		
		public static function registerStatusTextfield(txtField:TextField):void {
			_txtStatus = txtField;
		}
		
		public static function registerTextfield(txtField:TextField):void {
			_txt = txtField;
		}
		
		public static function clear():void {
			_oldDebugString 	= _debugString;
			_debugString		= "";
			logString(_debugString);
		}
		
		public static function restore():void {
			_debugString 		= _debugString + "\n" + _oldDebugString;
			_oldDebugString 	= "";
			logString(_debugString);
		}
	}

}