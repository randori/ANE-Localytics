package pl.randori.ane.localytics;

import pl.randori.ane.LocalyticsExtensionContext;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

public class LocalyticsTagScreenFunction implements FREFunction {

	@Override
    public FREObject call(FREContext context, FREObject[] args)
    {
		try {
	        if (args.length < 1 || args[0] == null) return null;
	        
		    String screenName = args[0].getAsString();
	        
		    if (screenName == null) return null;
		    
			LocalyticsExtensionContext localyticsContext = (LocalyticsExtensionContext)context;   
			localyticsContext.tagScreen(screenName);
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
