package ui.windows
{
	import com.facebook.graph.Facebook;
	import com.facebook.graph.FacebookDesktop;
	
	import events.InternalEvent;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.html.HTMLHost;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import model.Model;
	
	import util.Constants;

	public class FacebookWindow extends MovieClip
	{
		protected static const APP_ID:String = "175732442516239"; //Place your application id here
		protected static const APP_KEY:String = "0f6c29187cf350121739af4abf51f970"; //Place your application id here
		protected static const APP_ORIGIN:String = "http://www.pullandbear.com"; //Place your specified site URL for your app here. 
																			     //This is needed for clearing cookies when logging out.  
		
		private var final_image : BitmapData;
		private var facebook_screen_msg : MovieClip;
		private var html_host : FacebookHTMLHost;
		private var facebook_windows_shadow : Sprite;
		
		public function FacebookWindow()
		{

			var bottom : Sprite = new Sprite();
			bottom.graphics.beginFill( 0xffffff );
			bottom.graphics.drawRect( 0, 0, 1920, 980 );
			bottom.graphics.endFill();
			bottom.alpha = 0;
			addChild( bottom );

			facebook_screen_msg = new facebook_messages_mc();
			addChild( facebook_screen_msg );
			
			facebook_windows_shadow = new Sprite();
			addChild( facebook_windows_shadow );

			FacebookDesktop.init( APP_ID, handleInit );
			FacebookDesktop.manageSession = false;
			
			visible = false;
		}
		
		
		public function init( _final_image : BitmapData ):void
		{
			final_image = _final_image;
			html_host = new FacebookHTMLHost( facebook_windows_shadow,  facebook_screen_msg, true );
			
			// show facebook login windows.
			FacebookDesktop.login( handleLogin, ['user_photos', 'publish_stream']);
			FacebookDesktop.getHTMLLoader().htmlHost = html_host;

			visible = true;
			
			dispatchEvent( new InternalEvent( InternalEvent.SHOW_ESPECIAL ) );
		}	
		
		
		public function release():void
		{
			if( FacebookDesktop.getHTMLLoader() != null ) FacebookDesktop.getHTMLLoader().htmlHost = null;
			FacebookDesktop.logout( handleLogout, APP_ORIGIN );
			FacebookDesktop.closeMainWindow();
			
			Model.instance.main_controller.hideKeyboard();
			dispatchEvent( new InternalEvent( InternalEvent.HIDE_ESPECIAL ) );
			this.visible = false;				
		}		
		
		
		private function handleLogin( response:Object, fail:Object ):void 
		{
			if( fail != null ) 
			{ 
				release();
				
			} else {
				
				upload();
			}
		}		
		
		
		private function upload():void 
		{
			var msg : String = Constants.facebook_msg[ Model.instance.current_language ];
			msg = msg.replace( "store_name", Model.instance.photoBooth.name );
			msg = msg.replace( "city_name", Model.instance.photoBooth.city_name );

			var values:Object = 
							{   message  : msg, 
								fileName : 'FILE_NAME',
								image    :  final_image 
							};
			
			FacebookDesktop.api('/me/photos', handleUploadComplete, values,'POST');
		}	

		
		private function handleUploadComplete(response:Object, fail:Object):void 
		{
			var status  : String = (response) ? 'Successfully uploaded' : 'Error uploading';
			dispatchEvent( new Event( InternalEvent.SHARE_OK ) );
			release();
		}			
		
		
		private function adjustWindowShadow( e : Event ):void
		{
			
		}
		
		
		
		/*
		* eventss..
		*/ 
		private function handleLogout( response:Object ):void 
		{
			trace( "handle logout...!!!" );
		}
		
		private function handleInit(response:Object, fail:Object):void 
		{
			trace( "handle init...!!!" );
		}
		

	}
}