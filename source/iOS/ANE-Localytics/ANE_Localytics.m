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
//
//  ANE_Localytics.m
//  ANE-Localytics
//
//  Created by Piotr Kościerzyński on 12-06-07.
//  Copyright (c) randori 2012. All rights reserved.
//


#import "ANE_Localytics.h"
#import "LocalyticsSession.h"

@implementation ANE_Localytics

static BOOL extensionReady = NO;
static NSString *kNotificationDispose = @"RI_ANE_dispose";

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(void)RI_ANE_Localytics_willFinalize:(NSNotification *)notification {
    DLog(@"ANE will finalize - cleanup / removing observers");
    [[NSNotificationCenter defaultCenter] removeObserver:[self class]];    
}

+ (void)RI_ANE_Localytics_applicationWillEnterForeground:(NSNotification *)notification
{
    DLog(@"RI_ANE_Localytics_applicationWillEnterForeground");
    
    // Attempt to resume the existing session or create a new one.
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];    
}

+ (void)RI_ANE_Localytics_applicationDidEnterBackground:(NSNotification *)notification
{
    DLog(@"RI_ANE_Localytics_applicationDidEnterBackground");

    // close the session before entering the background
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];    
}

+ (void)RI_ANE_Localytics_applicationWillTerminate:(NSNotification *)notification
{
    DLog(@"RI_ANE_Localytics_applicationWillTerminate");

    // Close Localytics Session in the case where the OS terminates the app
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}




+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserver:[self class]
                                             selector:@selector(RI_ANE_Localytics_willFinalize:)
                                                 name:kNotificationDispose
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[self class]
                                             selector:@selector(RI_ANE_Localytics_applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[self class]
                                             selector:@selector(RI_ANE_Localytics_applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[self class]
                                             selector:@selector(RI_ANE_Localytics_applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}

//PK
FREObject RI_ANE_Localytics_StartSession(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    DLog(@"RI_ANE_Localytics_StartSession CALL");
    
    uint32_t length = 0;
    const uint8_t *value = NULL;
    if( FREGetObjectAsUTF8( argv[0], &length, &value ) == FRE_OK )
    {
        NSString* applicationID = [NSString stringWithUTF8String: (char*) value];
        [[LocalyticsSession sharedLocalyticsSession] startSession:applicationID];   
        
        DLog(@"RI_ANE_Localytics_StartSession: %@", applicationID);
        extensionReady = YES;
    }
    return NULL;
}

FREObject RI_ANE_Localytics_TagScreen(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    DLog(@"RI_ANE_Localytics_TagScreen CALL");

    uint32_t length = 0;
    const uint8_t *value = NULL;
    if( FREGetObjectAsUTF8( argv[0], &length, &value ) == FRE_OK )
    {
        NSString* screenName = [NSString stringWithUTF8String: (char*) value];
        DLog(@"RI_ANE_Localytics_TagScreen: %@", screenName);

        [[LocalyticsSession sharedLocalyticsSession] tagScreen:screenName];
    }
    return NULL;
}



FREObject RI_ANE_Localytics_TagEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    DLog(@"RI_ANE_Localytics_TagEvent CALL");
    uint32_t length = 0;
    const uint8_t *buffer = NULL;

    if( FREGetObjectAsUTF8( argv[0], &length, &buffer ) != FRE_OK ) 
        return NULL;
    
    NSString* eventName = [NSString stringWithUTF8String:(char*)buffer];
    NSMutableDictionary *eventParameters = nil;
    
    //event parameters
    if( argc == 2 ) {
        length = 0;
        buffer = NULL;
        FREObject parametersArray = argv[1];
        if( FREGetArrayLength( parametersArray, &length ) != FRE_OK ) 
            return NULL;
        uint32_t parametersCount = length / 2;
        
        if( parametersCount > 0 ) {
            eventParameters = [NSMutableDictionary dictionaryWithCapacity:parametersCount];
            uint32_t i;
            NSString* key;
            NSString* value;
            
			FREObject freArrayItem;//AS3 Array element
            for( i = 0; i < parametersCount; ++i ) {
                if (!(FREGetArrayElementAt( parametersArray, i * 2, &freArrayItem) == FRE_OK &&
					  FREGetObjectAsUTF8(freArrayItem, &length, &buffer) == FRE_OK)) continue;
					
                key = [NSString stringWithUTF8String: (char*) buffer];
                
                if (!(FREGetArrayElementAt( parametersArray, i * 2 + 1, &freArrayItem ) == FRE_OK &&
					  FREGetObjectAsUTF8( freArrayItem, &length, &buffer ) == FRE_OK)) continue;
              
				value = [NSString stringWithUTF8String:(char*)buffer];
                
                [eventParameters setValue:value forKey:key];
            }
			parametersArray = NULL;
			freArrayItem = NULL;
			length = 0;
			buffer = NULL;
        }
    }
  
    if (eventParameters) {
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:eventName attributes:eventParameters];
		DLog(@"RI_ANE_Localytics_TagEvent: %@, parameters: %@", eventName, eventParameters);
    }
    else {
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:eventName];
		DLog(@"RI_ANE_Localytics_TagEvent: %@", eventName);
    }
    

    return NULL;
}

//ANE Required methods

void RI_ANELocalyticsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
                                    uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) 
{
	*numFunctionsToTest = 3;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * 3);
	func[0].name = (const uint8_t*) "startSession";
	func[0].functionData = NULL;
    func[0].function = &RI_ANE_Localytics_StartSession;
    
	func[1].name = (const uint8_t*) "tagEvent";
	func[1].functionData = NULL;
    func[1].function = &RI_ANE_Localytics_TagEvent;
    
    func[2].name = (const uint8_t*) "tagScreen";
	func[2].functionData = NULL;
    func[2].function = &RI_ANE_Localytics_TagScreen;
        
	*functionsToSet = func;
	
}


void RI_ANELocalyticsContextFinalizer(FREContext ctx) { 
    DLog(@"RI_ANELocalyticsContextFinalizer");
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDispose object:nil];
    return;
}


void RIANELocalyticsExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                                           FREContextFinalizer* ctxFinalizerToSet) {    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &RI_ANELocalyticsContextInitializer;
    *ctxFinalizerToSet = &RI_ANELocalyticsContextFinalizer;
}

void RIANELocalyticsExtensionFinalizer(FREContext ctx) {
    return;
}

@end
