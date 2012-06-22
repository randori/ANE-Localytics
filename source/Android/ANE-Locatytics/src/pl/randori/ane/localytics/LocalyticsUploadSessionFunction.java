package pl.randori.ane.localytics;


import pl.randori.ane.LocalyticsExtensionContext;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class LocalyticsUploadSessionFunction implements FREFunction {

	@Override
    public FREObject call(FREContext context, FREObject[] passedArgs)
    {
        try {
    		context.getActivity();
            LocalyticsExtensionContext localyticsContext = (LocalyticsExtensionContext)context;
            localyticsContext.localyticsUpload();
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	    return null;
    }
}
