/*
 Adobe AIR Native Extension for Localytics on iOS
 .................................................

 author: Piotr Kościerzyński, @pkoscierzynski
 http://flashsimulations.com
 http://randori.pl
 
 Copyright (c) 2012 Piotr Koscierzynski
 All rights reserved.

* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package pl.randori.ane
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	/**
	 * 
	 * @author Piotr Kościerzyński, @pkoscierzynski
	 * http://flashsimulations.com
	 * http://www.randori.pl
	 * 
	 * */
	public class Localytics extends EventDispatcher
	{		
		private static const EXTENSION_ID : String = "pl.randori.ane.Localytics";
		private static var extensionContext : ExtensionContext = null;
		

		private static function get isIOS():Boolean {
			return (Capabilities.os.toLowerCase().indexOf('iphone') != -1);
		}
		
		private static function get isAndroid():Boolean {
			return (Capabilities.manufacturer.toLowerCase().indexOf("android") != -1);
		}
		
		private static function initExtension():void {
		
			//iOS only
			if (!isIOS) {
				trace('ANE Localytics extension is not supported for this platform.');
				return;
			}
			
			if (!extensionContext) {
				extensionContext = ExtensionContext.createExtensionContext( EXTENSION_ID, null );
				trace('ANE Localytics initialized!');
			}
		}
		
		public static function get isSupported() : Boolean {
			initExtension();
			return (extensionContext != null);
		}
		
		/**
		 * Start Localytics session
		 */
		public static function startSession( localyticsAppId : String ) : void {
			initExtension();
			extensionContext.call( "startSession", localyticsAppId );
		}
		
		/**
		 * Tag an event.
		 */
		public static function tagEvent( eventName : String, eventParameters : Object = null ) : void {
			initExtension();

			if(!eventParameters) {
				extensionContext.call( "tagEvent", eventName );
			}
			else {
				var array : Array = [];
				for(var key : String in eventParameters) {
					array.push( key );
					array.push( String( eventParameters[key] ));
				}
				extensionContext.call("tagEvent", eventName, array);
			}
		}
		
		/**
		* Tag screen.
		*/
		public static function tagScreen( eventName : String) : void {
			initExtension();
			extensionContext.call( "tagScreen", eventName );
		}
				
		/**
		 * Clean up
		 */	
		public static function dispose():void {
			extensionContext.dispose();
			extensionContext = null;
		}		
		
	}
}