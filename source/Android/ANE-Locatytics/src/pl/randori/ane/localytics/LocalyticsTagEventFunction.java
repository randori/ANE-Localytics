package pl.randori.ane.localytics;

import java.util.HashMap;

import pl.randori.ane.LocalyticsExtensionContext;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

public class LocalyticsTagEventFunction implements FREFunction {

	@Override
    public FREObject call(FREContext context, FREObject[] args)
    {
		try {
	        if (args.length < 1 || args[0] == null) return null;
	        
		    String eventName = args[0].getAsString();
	        
		    if (eventName == null) return null;
		    
			LocalyticsExtensionContext localyticsContext = (LocalyticsExtensionContext)context;   
		    
			FREArray eventAttributes = null;
			if(args.length > 1 && args[1] != null) {
				 eventAttributes = (FREArray)args[1];
			}

			if(eventAttributes != null) {
				int length = (int) eventAttributes.getLength() / 2; // key value pairs
				HashMap<String, String> attributesMap = new HashMap<String, String>();
				for(int i = 0 ; i < length; i++) {
					attributesMap.put(eventAttributes.getObjectAt(i*2).getAsString(), eventAttributes.getObjectAt(i * 2 + 1).getAsString());
				}
				localyticsContext.tagEvent(eventName, attributesMap);
			}
			else {
				localyticsContext.tagEvent(eventName);
			}

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
