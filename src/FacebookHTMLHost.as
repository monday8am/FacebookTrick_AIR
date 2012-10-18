package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.html.HTMLHost;
	import flash.html.HTMLLoader;
	import flash.html.HTMLWindowCreateOptions;
	import flash.system.Capabilities;
	import flash.system.System;
	
	public class FacebookHTMLHost extends HTMLHost
	{
		
		private static var SECURE_PERMISION_URL : String = "https://www.facebook.com/dialog/permissions.request";
		private static var PERMISION_URL : String = "http://www.facebook.com/dialog/permissions.request";
		
		
		private static var REQUEST_LOGIN : String = "http://www.facebook.com/login.php?api_key";
		private static var SECURE_REQUEST_LOGIN : String = "https://www.facebook.com/login.php?api_key";
		
		
		private static var CHECK_DEVICE : String = "https://www.facebook.com/checkpoint/";
		
		private static var BANNED_URLS :  Array = [ "http://www.facebook.com/login.php?login_attempt",
			"https://www.facebook.com/login.php?login_attempt",
			"http://www.facebook.com/connect/login_success.html?error_reason",
			"https://www.facebook.com/connect/login_success.html?error_reason",
			"http://www.facebook.com/dialog/report.application",
			"http://www.facebook.com/connect/login_success.html#access_token=",
			"https://www.facebook.com/connect/login_success.html#access_token=",
			"http://www.facebook.com/r.php",
			"http://www.facebook.com/register/fbconnect.php",
			"about:blank"
		];
		
		private var _html : HTMLLoader;
		private var _view : FacebookTrick_AIR;
		
		
		
		public function FacebookHTMLHost( view : FacebookTrick_AIR, defaultBehaviors:Boolean=true )
		{
			super( defaultBehaviors )
			
			_view = view;
		}
		
		
		override public function windowClose():void
		{
			log( "close window" );
			
			htmlLoader.stage.nativeWindow.close();
		}
		
		
		override public function createWindow( windowCreateOptions:HTMLWindowCreateOptions ): HTMLLoader
		{
			log( "create window - do nothing" );
			
			return null;
		}
		
		
		override public function updateLocation( locationURL:String):void
		{
			
			log( "location changed : " + locationURL );
			
			
			if( locationURL.indexOf( FacebookHTMLHost.PERMISION_URL 	   ) == 0 ||
				locationURL.indexOf( FacebookHTMLHost.SECURE_PERMISION_URL ) == 0 
			)
			{
				_html.addEventListener( Event.COMPLETE, disableDontAllowBtn );				
			}
			
			
			if( locationURL.indexOf( FacebookHTMLHost.REQUEST_LOGIN ) 		 == 0 ||
				locationURL.indexOf( FacebookHTMLHost.SECURE_REQUEST_LOGIN ) == 0 
			)
			{
				_html = htmlLoader;
			}				
			
			
			if( locationURL.indexOf( FacebookHTMLHost.CHECK_DEVICE ) 		== 0 )
			{
				var newSize : Rectangle = new Rectangle( (Capabilities.screenResolutionX - 800 )/2, 
					(Capabilities.screenResolutionY - 325 )/2, 
					800, 
					325 );
				htmlLoader.stage.nativeWindow.bounds = newSize;
				
				log( "Enlarge Windows!!" );
			}
			
			
			// check for banned URLs
			for (var i:int = 0; i < BANNED_URLS.length; i++) 
			{
				if( locationURL.indexOf( BANNED_URLS[i] ) == 0 )
				{			
					if( BANNED_URLS[i] == "http://www.facebook.com/register/fbconnect.php" )
					{
						log( "Go back!" );
						_html.historyBack();
					}
					else
					{
						log( "Do nothing" );
					}
					
				}
			}
			
			
		}   
		
		
		private function disableDontAllowBtn(event:Event):void
		{
			_html.removeEventListener( Event.COMPLETE, disableDontAllowBtn );	
			
			
			// disable Dont Allow btn
			
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
						log( "disable button : " + button.name );
					}
				}
			}
			
			
			// disable all links
			
			for (var j:int = 0; j <  htmlLoader.window.document.getElementsByTagName("a").length; j++) 
			{
				var anchor  : Object  = htmlLoader.window.document.getElementsByTagName("a")[j];
				log( "change anchor : " + anchor.href );
				anchor.href = "#";
			}
			
		}		
		
		
		override public function set windowRect( value:Rectangle ):void
		{
			htmlLoader.stage.nativeWindow.bounds = value;
			
			log( "window rect : " +  value.x + ", " + value.y + ", " + value.width + ", " + value.height );
		}
		
		
		override public function updateStatus(status:String):void
		{
			log( "update status : " + status );
		}
		
		
		override public function updateTitle(title:String):void
		{
			log( "update title : " + title );
		}
		
		
		override public function windowBlur():void
		{
			log( "window blur" );
		}
		
		
		override public function windowFocus():void
		{
			log( "window focus" );
		}
		
		
		private function log( str : String ):void
		{
			_view.log( str);
		}
		
	}
}