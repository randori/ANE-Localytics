package pl.randori.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class LocalyticsExtension implements FREExtension {

	@Override
	public FREContext createContext(String contextType) {
		return new LocalyticsExtensionContext();
	}

	@Override
	public void dispose() {
		// TODO Auto-generated method stub

	}

	@Override
	public void initialize() {
		// TODO Auto-generated method stub

	}

}
