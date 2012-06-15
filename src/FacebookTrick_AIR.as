package
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.facebook.graph.FacebookDesktop;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	

	[ SWF(backgroundColor="#ffffff", frameRate="24", width="700", height="300")]	
	public class FacebookTrick_AIR extends Sprite
	{

		// facebook related
		
		protected static const APP_ID:String = "175732442516239"; 					//Place your application id here
		protected static const APP_KEY:String = "0f6c29187cf350121739af4abf51f970"; //Place your application key here
		protected static const APP_ORIGIN:String = "http://www.google.com"; 		//Place your specified site URL for your app here. 
		
		
		private var html_host : FacebookHTMLHost;
		
		// interface
		
		private var label				: Label;
		private var login_btn	 		: PushButton;
		private var logout_btn	 		: PushButton;
		private var label_events    	: TextArea;
		
		
		
		public function FacebookTrick_AIR()
		{
			
			// interface 
			
			label 			= new Label		( this, 30, 30,  " Testing upload service " );
			login_btn       = new PushButton( this, 30, 60,  " Login ", onPressBtn );
			logout_btn      = new PushButton( this, 30, 90, " Logout ", onPressBtn );
			label_events	= new TextArea( this, 150, 60,   " logs...\n" ); label_events.width = 400; label_events.height = 211;
			
			// init api
			
			FacebookDesktop.init( APP_ID, handleInit );
			FacebookDesktop.manageSession = false;			
			
			
		}
		
		
		public function login():void
		{
			//html_host = new FacebookHTMLHost( this, true );
			// show facebook login windows.
			FacebookDesktop.login( handleLogin, ['user_photos', 'publish_stream']);
		}	
		
		
		public function logout():void
		{
			//if( FacebookDesktop. != null ) FacebookDesktop.getHTMLLoader().htmlHost = null;
			FacebookDesktop.logout( handleLogout, APP_ORIGIN );
			//FacebookDesktop.closeMainWindow();
		}
		
		
		/**
		 * 
		 * Event handlers
		 * 
		 */ 
		
		private function handleLogin( response:Object, fail:Object ):void 
		{
			if( fail != null ) 
			{ 
				logout();
				
			} else {
				
				
			}
		}	
		
		
		private function handleInit(response:Object, fail:Object):void 
		{
			trace( "handle init...!!!" );
		}		
				
		
		private function handleLogout( response:Object ):void 
		{
			trace( "handle logout...!!!" );
		}
		
		
		private function onPressBtn( e : MouseEvent ):void
		{
			if( e.currentTarget == login_btn )
			{
				login();
				
			}
			
			if( e.currentTarget == logout_btn )
			{
				logout();
			}				
		}
		
		
		
		/**
		 * 
		 *  Utils
		 * 
		 */
		
		private function log( str : String ):void
		{
			label_events.text += str + "\n";
		}		
	}
}