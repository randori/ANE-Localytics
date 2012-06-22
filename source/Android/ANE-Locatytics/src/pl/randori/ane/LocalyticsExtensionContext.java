package pl.randori.ane;

import java.util.HashMap;
import java.util.Map;

import pl.randori.ane.localytics.LocalyticsCloseSessionFunction;
import pl.randori.ane.localytics.LocalyticsOpenSessionFunction;
import pl.randori.ane.localytics.LocalyticsStartSessionFunction;
import pl.randori.ane.localytics.LocalyticsTagEventFunction;
import pl.randori.ane.localytics.LocalyticsTagScreenFunction;
import pl.randori.ane.localytics.LocalyticsUploadSessionFunction;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.localytics.android.LocalyticsSession;

public class LocalyticsExtensionContext extends FREContext {
	
	public static LocalyticsSession localyticsSession = null;
	public static String LOCALYTICS_APP_KEY = "";

	@Override
	public void dispose() {
		Log.i("LocalyticsExtensionContext", "dispose");

		localyticsSession = null;
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		// TODO Auto-generated method stub
		Log.i("LocalyticsExtensionContext", "getFunctions");
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("startSession", new LocalyticsStartSessionFunction());
		functionMap.put("closeSession", new LocalyticsCloseSessionFunction());
		functionMap.put("openSession", new LocalyticsOpenSessionFunction());
		functionMap.put("tagEvent", new LocalyticsTagEventFunction());
		functionMap.put("tagScreen", new LocalyticsTagScreenFunction());
		functionMap.put("uploadSession", new LocalyticsUploadSessionFunction());
		return functionMap;
	}

	//Localytics methods
    public void startSession(String localyticsAppKey) {
		Log.i("LocalyticsExtensionContext", "startSession");

    	LOCALYTICS_APP_KEY = localyticsAppKey;
    	if (localyticsSession != null)
    		return;
    	
    	localyticsSession = new LocalyticsSession(
                this.getActivity().getApplicationContext(),
                LOCALYTICS_APP_KEY);
    	localyticsSession.open();
 		localyticsSession.upload();
    }
    
    public void localyticsResume()
    {
		Log.i("LocalyticsExtensionContext", "resume");

        localyticsSession.open();
    }
 
    public void localyticsPause()
    {
		Log.i("LocalyticsExtensionContext", "pause");

    	if (localyticsSession == null) {
 //   		Log.i(, msg)
    		return;
    	}
    	
        localyticsSession.close();
        localyticsSession.upload();
    }
    
    public void localyticsUpload()
    {
		Log.i("LocalyticsExtensionContext", "upload");

        localyticsSession.upload();
    }
    
    
    public void tagEvent(String event) {
		Log.i("LocalyticsExtensionContext", "tagEvent");

    	localyticsSession.tagEvent(event);
    }
        
    public void tagEvent(String event, Map<String, String> attributes) {
		Log.i("LocalyticsExtensionContext", "tagEvent with attributes");

    	localyticsSession.tagEvent(event, attributes);
    }
    
    public void tagScreen(String event) {
		Log.i("LocalyticsExtensionContext", "tagScreen");

    	localyticsSession.tagScreen(event);
    }

}
