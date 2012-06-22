package pl.randori.ane.localytics;


import pl.randori.ane.LocalyticsExtensionContext;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

public class LocalyticsStartSessionFunction implements FREFunction {

	@Override
    public FREObject call(FREContext context, FREObject[] passedArgs)
    {
        try {
            LocalyticsExtensionContext localyticsContext = (LocalyticsExtensionContext)context;
            String appKey = passedArgs[0].getAsString();
            localyticsContext.startSession(appKey);
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (FRETypeMismatchException e) {
			e.printStackTrace();
		} catch (FREInvalidObjectException e) {
			e.printStackTrace();
		} catch (FREWrongThreadException e) {
			e.printStackTrace();
		}
        return null;
    }
}
