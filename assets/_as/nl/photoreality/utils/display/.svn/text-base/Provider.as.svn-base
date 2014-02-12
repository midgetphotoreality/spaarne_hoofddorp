package nl.photoreality.utils.display 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import nl.photoreality.map_editor.model.Model;
	import nl.photoreality.utils.debug.Debug;
	/**
	 * ...
	 * @author Miguel Fuentes // Triplebeam 2012
	 */
	public class Provider extends Sprite
	{
		
		public function Provider() {
		}
		
		protected function provideMc(linkage:String):DisplayObject {
			return provideAsset(linkage);
			/*
			Debug.log("Provider -> provideMc : " + linkage);
			var tMC:DisplayObject;
			var tCL:Class;
			try{
				//Debug.log("Provider -> provideMc, def: "+Model.getInstance().assets.contentLoaderInfo.applicationDomain.getDefinition(linkage))
				tCL = Model.getInstance().assets.contentLoaderInfo.applicationDomain.getDefinition(linkage)  as  Class;
				Debug.log("Provider -> provideMc, tCL: "+tCL)
				
				tMC = new tCL() as DisplayObject;
				//return(tMC);
			}catch (e:Error) {
				try{
					//Debug.log("Provider -> provideMc, def: "+Model.getInstance().assets.contentLoaderInfo.applicationDomain.getDefinition(linkage))
					tCL = Model.getInstance().panos.contentLoaderInfo.applicationDomain.getDefinition(linkage)  as  Class;
					Debug.log("Provider -> provideMc, tCL: "+tCL)
					
					tMC = new tCL() as DisplayObject;
					//return(tMC);
				}catch (e:Error) {
					
				}
			}
			return tMC
			*/
		}
		
		protected function provideAsset(linkage:String):DisplayObject {
			var tCL:Class = Model.getInstance().assets.contentLoaderInfo.applicationDomain.getDefinition(linkage)  as  Class;
			var tMC:DisplayObject = new tCL() as DisplayObject;
			return(tMC);
		}
		
		protected function providePanorama(linkage:String):DisplayObject {
			var tCL:Class = Model.getInstance().panos.contentLoaderInfo.applicationDomain.getDefinition(linkage)  as  Class;
			var tMC:DisplayObject = new tCL() as DisplayObject;
			return(tMC);
		}
		
		protected function provideMcInSwf(linkage:String):DisplayObject {
			var tCL:Class = getDefinitionByName(linkage) as Class;
			var tMC:DisplayObject = new tCL() as DisplayObject;
			return(tMC);
		}
		
		protected function isValidPanorama(linkage:String):Boolean {
			var mc:MovieClip;
			var exists:Boolean 	=	 true;
			try {
				mc = MovieClip(providePanorama(linkage));
				return true;
			}catch (err:Error){
				return false;
			}
			return false;
		}
		
		protected function isValidMc(linkage:String):Boolean {
			var mc:MovieClip;
			var exists:Boolean 	=	 true;
			try {
				mc = MovieClip(provideMcInSwf(linkage));
				return true;
			}catch (err:Error){
				return false;
			}
			return false;
		}
		
		protected function isValidAssetMc(linkage:String):Boolean {
			var mc:MovieClip;
			var exists:Boolean 	=	 true;
			try {
				mc = MovieClip(provideMc(linkage));
				return true;
			}catch (err:Error){
				return false;
			}
			return false;
		}
	}

}