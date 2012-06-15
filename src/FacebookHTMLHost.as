package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.html.HTMLHost;
	import flash.html.HTMLLoader;
	import flash.html.HTMLWindowCreateOptions;
	
	public class FacebookHTMLHost extends HTMLHost
	{
		private static var SECURE_PERMISION_URL : String = "https://www.facebook.com/dialog/permissions.request";
		private static var PERMISION_URL : String = "http://www.facebook.com/dialog/permissions.request";
		private static var REPORT_APP : String = "http://www.facebook.com/dialog/report.application";
		
		private static var REQUEST_LOGIN : String = "http://www.facebook.com/login.php?api_key";
		private static var SECURE_REQUEST_LOGIN : String = "https://www.facebook.com/login.php?api_key";
		
		private static var SEND_LOGIN : String = "http://www.facebook.com/login.php?login_attempt";
		private static var SECURE_SEND_LOGIN : String = "https://www.facebook.com/login.php?login_attempt";
		
		private static var ERROR : String = "http://www.facebook.com/connect/login_success.html?error_reason";
		private static var SECURE_ERROR : String = "https://www.facebook.com/connect/login_success.html?error_reason";
		
		private static var LOGIN_SUCCESS : String = "http://www.facebook.com/connect/login_success.html#access_token=";
		private static var SECURE_LOGIN_SUCCESS : String = "https://www.facebook.com/connect/login_success.html#access_token=";

		private var _html : HTMLLoader;
		private var _view : Sprite;
		private var _messages : MovieClip;
		
		
		public function FacebookHTMLHost( view : Sprite, defaultBehaviors:Boolean=true )
		{
			super( defaultBehaviors )
		}
		
		override public function windowClose():void
		{
			htmlLoader.stage.nativeWindow.close();
		}
		
		override public function createWindow( windowCreateOptions:HTMLWindowCreateOptions ): HTMLLoader
		{
			return null;
		}
		
		override public function updateLocation( locationURL:String):void
		{
			
			if( locationURL.indexOf( FacebookHTMLHost.PERMISION_URL 	   ) == 0 ||
				locationURL.indexOf( FacebookHTMLHost.SECURE_PERMISION_URL ) == 0 
			   )
			{
				_html = htmlLoader;
				_html.addEventListener( Event.COMPLETE, disableDontAllowBtn );				
			}
			
			
			if( locationURL.indexOf( FacebookHTMLHost.REQUEST_LOGIN ) 		 == 0 ||
				locationURL.indexOf( FacebookHTMLHost.SECURE_REQUEST_LOGIN ) == 0 
			)
			{

			}
			
			
			if( locationURL.indexOf( FacebookHTMLHost.SEND_LOGIN ) 		  == 0 ||
				locationURL.indexOf( FacebookHTMLHost.SECURE_SEND_LOGIN ) == 0 ||
				locationURL.indexOf( FacebookHTMLHost.ERROR ) 			  == 0 ||
				locationURL.indexOf( FacebookHTMLHost.SECURE_ERROR ) 	  == 0 
			)
			{
				
			}	
			
			
			if( locationURL.indexOf( FacebookHTMLHost.LOGIN_SUCCESS ) 	     == 0 ||
				locationURL.indexOf( FacebookHTMLHost.SECURE_LOGIN_SUCCESS ) == 0 
			)
			{

			}	
			
			
			if( locationURL.indexOf( "about:blank" ) == 0 )
			{

			}
			

		}   
		
		private function disableDontAllowBtn(event:Event):void
		{
			_html.removeEventListener( Event.COMPLETE, disableDontAllowBtn );	
			
			
			for (var i:int = 0; i < htmlLoader.window.document.getElementsByTagName("input").length; i++) 
			{
				if( htmlLoader.window.document.getElementsByTagName("input")[i].type == "submit" )
				{
					var button : Object = htmlLoader.window.document.getElementsByTagName("input")[i];
					
					if( button.value == "Don't Allow" || 
						button.id    == "uh5cmv_2"    ||
						button.name  == "cancel_clicked" )
					{
						button.disabled = true;
					}
				}
			}
			
			for (var j:int = 0; j <  htmlLoader.window.document.getElementsByTagName("a").length; j++) 
			{
				var anchor  : Object  = htmlLoader.window.document.getElementsByTagName("a")[j];
				anchor.href = "#";
			}
			
		}		
		
		override public function set windowRect(value:Rectangle):void
		{
			htmlLoader.stage.nativeWindow.bounds = value;
			_view.graphics.clear();
			_view.graphics.beginFill( 0x000000 );
			_view.graphics.drawRect( value.x + 15, value.y + 15, value.width, value.height );
			_view.graphics.endFill();
		}
		
		override public function updateStatus(status:String):void
		{

		}
			
		override public function updateTitle(title:String):void
		{
			
		}
		
		override public function windowBlur():void
		{
		}
		
		override public function windowFocus():void
		{
		}
		
	}
}