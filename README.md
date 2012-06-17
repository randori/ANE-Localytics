ANE-Localytics
==============

Localytics (http://localytics.com) analytics for mobile Adobe AIR applications

by Piotr Kościerzyński


How to use
----------------
1. Sign up for a free / premium Localytics account and create and application key https://dashboard.localytics.com/localytics_applications
2. Add the ANE to you project (https://github.com/randori/ANE-Localytics/downloads)
   Start a Localytics session when the app finishes loading: 
   
   //Start Localytics session
   Localytics.startSession('APP-KEY');
   
 * When the session has been initialized you can log events and screens. Events can have attributes (optional).
 	//Example: location based sports app - finished run / walk
	Localytics.tagEvent("run_finished", {'distance':'1-2km', 'time':'6-10min', 'gps_accuracy':'10-20 meters'});
	Localytics.tagEvent("run_finished", {'distance':'>10km', 'time':'30-45min', 'gps_accuracy':'>100 meters'});
			
	//Example: button was pressed
	Localytics.tagEvent("button_pressed");
	Localytics.tagEvent("button_pressed", {'button_id':'login'});
	Localytics.tagEvent("button_pressed", {'button_id':'share', 'share_type':'facebook'});


	//Example screen flow: E-commerce app
	Localytics.tagScreen('home');
	Localytics.tagScreen('categories');
 
 * Check out the example projects (Flash CS6, Flash Builder 4.6)
 
 * Current version of this ANE supports iOS only. Android version is in development.
 
 * What's the differece between ANE_Localytics-debug and ANE_Localytics-release? Release builds are optimized builds and don't print logs to iOS console. 
 
# Changelog:

2012-06-18

- Version 1.0.0
- Supports Adobe AIR iOS