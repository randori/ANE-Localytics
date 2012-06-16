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
//  ANE_Localytics.h
//  ANE-Localytics
//
//  Created by Piotr Kościerzyński on 12-06-07.
//  Copyright (c) randori 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

@interface ANE_Localytics : NSObject {
    
}

//Custom extension methods
FREObject RI_ANE_Localytics_StartSession(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject RI_ANE_Localytics_TagEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject RI_ANE_Localytics_TagScreen(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
FREObject RI_ANE_Localytics_Upload(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

//Required methods
void RI_ANELocalyticsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
                                    uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void RI_ANELocalyticsContextFinalizer(FREContext ctx);
void RIANELocalyticsExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                                           FREContextFinalizer* ctxFinalizerToSet);
void RIANELocalyticsExtensionFinalizer(void* extData);

@end
