SHoofddorp.view.Menu = (function() {
	var _divAsset;

	/*__FUNCTIONS_____________________________________________________________________________________________________*/

	/*__CORE_FUNCTIONS________________________________________________________________________________________________*/
	var _init = function() {
		console.log("MENU");
		Core.debug.log("SHoofddorp.view.Menu -> _init()");
		document.getElementById("menuBtnOverzichtsplattegrond").onclick = onBtnOverzichtsplattegrond;

		//if (Core.dom.elementExists("Core31415926535897932384626433832preload")){
			document.getElementById("Core31415926535897932384626433832preload").innerHTML = "";
		//}
		
		SHoofddorp.Menu.buildMenu();
		_divAsset = document.getElementById("Menu");
		//SHoofddorp.AnimationManager.genContentInit(_divAsset);
		TweenLite.set(document.getElementById("menuTitle"),						{css:{autoAlpha:0}});
		TweenLite.set(document.getElementById("menuButtonsInline"),				{css:{autoAlpha:0}});
		TweenLite.set(document.getElementById("menuBtnOverzichtsplattegrond"),	{css:{autoAlpha:0}});
		TweenLite.set(document.getElementById("menuBtnPrintvoorbeeld"),			{css:{autoAlpha:0}});
		//alert("1")
		
		alert(document.getElementById("menuBtnOverzichtsplattegrond").onclick)
		//document.getElementById("menuBtnPrintvoorbeeld").onclick = onBtnPrintvooorbeeld;
	}
	
	var onBtnOverzichtsplattegrond = function(event) {
		
		Core.debug.log("SHoofddorp.view.Menu -> onBtnOverzichtsplattegrond()");
		Core.managers.NavigationManager.showAsset(SHoofddorp.Setup.content.Overzichtsplattegrond);
	}
	
	/*var onBtnPrintvooorbeeld = function(event) {
	
	}*/
	
	var _show = function() {
		Core.debug.log("SHoofddorp.view.Menu -> _show()");
		//SHoofddorp.AnimationManager.genContentShow(_divAsset);
		TweenLite.from(document.getElementById("menuTitle"),					0.3, {css:{left:"-10px"}, delay:0.0});
		TweenLite.to(document.getElementById("menuTitle"),						0.3, {css:{autoAlpha:1}, delay:0.0});
		
		TweenLite.from(document.getElementById("menuButtonsInline"),			0.3, {css:{left:"-10px"}, delay:0.1});
		TweenLite.to(document.getElementById("menuButtonsInline"),				0.3, {css:{autoAlpha:1}, delay:0.1});
		
		TweenLite.from(document.getElementById("menuBtnOverzichtsplattegrond"),	0.3, {css:{left:"-10px"}, delay:0.2});
		TweenLite.to(document.getElementById("menuBtnOverzichtsplattegrond"),	0.3, {css:{autoAlpha:1}, delay:0.2});
		
		TweenLite.from(document.getElementById("menuBtnPrintvoorbeeld"),		0.3, {css:{left:"-10px"}, delay:0.3});
		TweenLite.to(document.getElementById("menuBtnPrintvoorbeeld"),			0.3, {css:{autoAlpha:1}, delay:0.3});
	}

	var _hide = function(callback) {
		Core.debug.log("SHoofddorp.view.Menu -> _hide()");
		//SHoofddorp.AnimationManager.genContentHide(_divAsset, callback);
		TweenLite.to(document.getElementById("menuTitle"),						0.5, {css:{autoAlpha:0}});
		TweenLite.to(document.getElementById("menuButtonsInline"),				0.5, {css:{autoAlpha:0}});
		TweenLite.to(document.getElementById("menuBtnOverzichtsplattegrond"),	0.5, {css:{autoAlpha:0}});
		TweenLite.to(document.getElementById("menuBtnPrintvoorbeeld"),			0.5, {css:{autoAlpha:0}});
	}

	var _remove = function() {
		Core.debug.log("SHoofddorp.view.Menu -> _remove()");
		SHoofddorp.Setup.content.Menu.removeView(SHoofddorp.view.Menu);
		_divAsset = null;
	}


	/*__PUBLIC_FUNCTIONS______________________________________________________________________________________________*/
	var _public = {
		init: function() { _init(); },
		show: function() { _show(); },
		hide: function(callback) { _hide(callback); },
		remove: function() { _remove(); }
	}
	return _public;
})();
SHoofddorp.Setup.content.Menu.addView(SHoofddorp.view.Menu);