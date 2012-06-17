/*
Example application
Adobe AIR Native Extension for Localytics on iOS
.................................................

author: Piotr Kościerzyński, @pkoscierzynski
http://flashsimulations.com
*/
package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import pl.randori.ane.Localytics;

	public class LocalyticsApp extends MovieClip
	{		
		[Embed(source="assets/header.png")]
		private static const HeaderAsset:Class;
		
		[Embed(source="assets/button.png")]
		private static const ButtonAsset:Class;
		
		[Embed(source="assets/logo.png")]
		private static const LogoAsset:Class;
		
		//retina iPhones and iPad
		private var contentScale:Number = 1.0;
		private var button_mc:Sprite;
		private var header_mc:Bitmap;
		private var logo_mc:Bitmap;
		
		public function LocalyticsApp()
		{
			super();
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function getScaledBitmap(bitmapData:BitmapData, destScale:Number = 1.0):BitmapData {
			if (destScale == 1.0)
				return bitmapData;
			
			var m:Matrix = new Matrix();
			m.scale(destScale, destScale);
			
			var result:BitmapData = new BitmapData(destScale*bitmapData.width, destScale*bitmapData.height, true, 0x00000000);
			result.draw(bitmapData.clone(), m, null, null, null, true);
			return result;
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			stage.addEventListener(Event.RESIZE, onResize);
			
			if (stage.stageWidth <= 320.0)
				contentScale = 0.5;
			
			this.header_mc = new Bitmap(getScaledBitmap((new HeaderAsset() as Bitmap).bitmapData, contentScale));
			addChild(header_mc);
			this.button_mc = new Sprite();
			this.button_mc.addChild(new Bitmap(getScaledBitmap((new ButtonAsset() as Bitmap).bitmapData, contentScale)));
			addChild(this.button_mc);
			this.logo_mc = new Bitmap(getScaledBitmap((new LogoAsset() as Bitmap).bitmapData, contentScale));
			addChild(logo_mc);
			
			//Create an app here: https://dashboard.localytics.com/localytics_applications
			//Start Localytics session
			Localytics.startSession('APP-KEY');

			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			button_mc.addEventListener(TouchEvent.TOUCH_TAP, logSampleData);			
			
			onResize();
		}
		
		/**
		 * Log some events and screen flow
		 * 
		 */
		private function logSampleData(e:TouchEvent):void
		{
			//Example screen flow: E-commerce app
			Localytics.tagScreen('home');
			Localytics.tagScreen('categories');
			Localytics.tagScreen('product-list');
			Localytics.tagScreen('product-details');
			Localytics.tagScreen('product-list');
			Localytics.tagScreen('checkout');
			Localytics.tagScreen('registration');
			Localytics.tagScreen('order-confirm');
			Localytics.tagScreen('sign-out-info');

			
			//Example: location based sports app - finished run / walk
			Localytics.tagEvent("run_finished");
			Localytics.tagEvent("run_finished", {'distance':'unknown', 'time':'0-30s', 'gps_accuracy':'off'});
			Localytics.tagEvent("run_finished", {'distance':'unknown', 'time':'10-15min', 'gps_accuracy':'off'});
			Localytics.tagEvent("run_finished", {'distance':'0-100m', 'time':'0-30s', 'gps_accuracy':'0-5 meters'});
			Localytics.tagEvent("run_finished", {'distance':'100-500m', 'time':'1-5min', 'gps_accuracy':'0-5 meters'});
			Localytics.tagEvent("run_finished", {'distance':'100-500m', 'time':'1-5min', 'gps_accuracy':'0-5 meters'});
			Localytics.tagEvent("run_finished", {'distance':'500m-1km', 'time':'1-6min', 'gps_accuracy':'0-5 meters'});
			Localytics.tagEvent("run_finished", {'distance':'500m-1km', 'time':'1-6min', 'gps_accuracy':'5-10 meters'});
			Localytics.tagEvent("run_finished", {'distance':'500m-1km', 'time':'1-6min', 'gps_accuracy':'5-10 meters'});
			Localytics.tagEvent("run_finished", {'distance':'500m-1km', 'time':'6-10min', 'gps_accuracy':'5-10 meters'});
			Localytics.tagEvent("run_finished", {'distance':'500m-1km', 'time':'6-10min', 'gps_accuracy':'5-10 meters'});
			Localytics.tagEvent("run_finished", {'distance':'1-2km', 'time':'6-10min', 'gps_accuracy':'10-20 meters'});
			Localytics.tagEvent("run_finished", {'distance':'1-2km', 'time':'10-15min', 'gps_accuracy':'10-20 meters'});
			Localytics.tagEvent("run_finished", {'distance':'1-2km', 'time':'10-15min', 'gps_accuracy':'10-20 meters'});
			Localytics.tagEvent("run_finished", {'distance':'1-2km', 'time':'10-15min', 'gps_accuracy':'10-20 meters'});
			Localytics.tagEvent("run_finished", {'distance':'2-5km', 'time':'15-30min', 'gps_accuracy':'20-100 meters'});
			Localytics.tagEvent("run_finished", {'distance':'2-5km', 'time':'15-30min', 'gps_accuracy':'20-100 meters'});
			Localytics.tagEvent("run_finished", {'distance':'2-5km', 'time':'15-30min', 'gps_accuracy':'20-100 meters'});
			Localytics.tagEvent("run_finished", {'distance':'2-5km', 'time':'15-30min', 'gps_accuracy':'20-100 meters'});
			Localytics.tagEvent("run_finished", {'distance':'2-5km', 'time':'15-30min', 'gps_accuracy':'>100 meters'});
			Localytics.tagEvent("run_finished", {'distance':'>10km', 'time':'30-45min', 'gps_accuracy':'>100 meters'});
			
			//Button pressed
			Localytics.tagEvent("button_pressed");
			Localytics.tagEvent("button_pressed", {'button_id':'login'});
			Localytics.tagEvent("button_pressed", {'button_id':'share', 'share_type':'facebook'});
			Localytics.tagEvent("button_pressed", {'button_id':'share', 'share_type':'google plus'});
			Localytics.tagEvent("button_pressed", {'button_id':'share', 'share_type':'twitter'});
			
			//Ad clicked
			Localytics.tagEvent("Ad Clicked", {'ad_network':'iAd', 'orientation':'landscape', 'ad_type':'banner', 'device':'iPhone'});
			Localytics.tagEvent("Ad Clicked", {'ad_network':'iAd', 'orientation':'portrait', 'ad_type':'interstitial', 'device':'iPhone'});
			Localytics.tagEvent("Ad Clicked", {'ad_network':'iAd', 'orientation':'landscape', 'ad_type':'interstitial', 'device':'iPad'});
			Localytics.tagEvent("Ad Clicked", {'ad_network':'AdMob', 'orientation':'portrait', 'ad_type':'banner', 'device':'iPhone'});
			Localytics.tagEvent("Ad Clicked", {'ad_network':'Greystripe', 'orientation':'portrait', 'ad_type':'interstitial', 'device':'iPhone'});
		}
		
		private function onResize(e:Event = null):void
		{
			header_mc.x = (stage.stageWidth-header_mc.width) >> 1
			header_mc.y = 40*contentScale;
			
			button_mc.x = (stage.stageWidth-button_mc.width) >> 1;
			button_mc.y = (stage.stageHeight-button_mc.height) >> 1;
			
			logo_mc.x = (stage.stageWidth-logo_mc.width) - 20*contentScale;
			logo_mc.y = (stage.stageHeight-logo_mc.height) - 20*contentScale;
		}
		
	}
}