/*
 
 CoreStack v1.0 : CSSite.m
 
 Copyright (c) 2010 Adam Wright
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import <objc/runtime.h>
#import "JSON.h"

#import "CoreStackConstants.h"
#import "CSSite.h"
#import "CSObjectVector.h"
#import "CSIdentifiedObject.h"
#import "CSSiteStatistics.h"
#import "CSQuestion.h"
#import "HTTPRequest.h"

@implementation CSSite

@synthesize descriptor;

- (id)initWithDescriptor:(CSSiteDescriptor*)_descriptor
{
    self = [super init];
    
    if (self)
    {
        descriptor = [_descriptor retain];
        
        allRequests = [[NSMutableSet alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [descriptor release];
    [allRequests release];
    
    [super dealloc];
}

- (CSRequestParams*)requestParamsForStatistics
{
    return [[[CSRequestParams alloc] initWithRawURL:@"/stats" andResponseVectorKey:@"statistics" andType:[CSSiteStatistics class]] autorelease];
}

- (CSRequestParams*)requestParamsForSearchWithTitleMatch:(NSString*)titleMatch
{
    CSRequestParams *params = [[[CSRequestParams alloc] initWithRawURL:@"/search" andResponseVectorKey:@"questions" andType:[CSQuestion class]] autorelease];
    [params setParam:@"intitle" toValue:titleMatch];
    
    return params;
}

- (CSRequestToken*)requestObjects:(CSRequestParams*)params notify:(id<CSObjectRequestDelegate>)delegate
{
    CSRequestToken *token = [[[CSRequestToken alloc] initWithParams:params andDelegate:delegate] autorelease];
    
    @synchronized (allRequests)
    {
        [allRequests addObject:token];
    }
    
#ifdef TESTING
    [self performRequest:token];
#else
    [self performSelectorInBackground:@selector(performRequest:) withObject:token];
#endif
    
    return token;
}

- (void)cancelRequest:(CSRequestToken*)token
{
    @synchronized (allRequests)
    {
        [allRequests removeObject:token];
    }
}

- (void)performRequest:(CSRequestToken*)token
{
#ifndef TESTING
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif
    
    NSError *error = nil;
    CSObjectVector *objVect = nil;
    
    id json = [self makeRawAPIRequest:[token.params toRequestURL] error:&error];
    
    if (json)
    {
        if ([json objectForKey:@"error"])
        {
            if ([[[json objectForKey:@"error"] objectForKey:@"code"] intValue] == 4004)
            {
                error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_REQUESTS_EXHAUSTED
                                        userInfo:[NSDictionary dictionaryWithObject:@"message" forKey:[[json objectForKey:@"error"] objectForKey:@"message"]]];
            }
            else
            {
                error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_FORMAT_ERROR
                                        userInfo:[NSDictionary dictionaryWithObject:@"message" forKey:[[json objectForKey:@"error"] objectForKey:@"message"]]];
            }
        }
        else
        {
            objVect = [[[CSObjectVector alloc] initWithObjectClass:token.params.responseType forVectorKey:token.params.responseVectorKey] autorelease];
    
            [objVect fillWithJSON:json error:&error];
        }
    }
    
    token.results = objVect;
    token.error = error;
    
#ifdef TESTING
    [self deliverRequestResult:token];
#else
    [self performSelectorOnMainThread:@selector(deliverRequestResult:) withObject:token waitUntilDone:NO];
    [pool release];
#endif
}

- (void)deliverRequestResult:(CSRequestToken*)token
{
    @synchronized (allRequests)
    {
        if ([allRequests containsObject:token])
        {
            if (token.updatesDelegate)
                [token.updatesDelegate requestComplete:token.results forRequest:token error:token.error];
            
            [allRequests removeObject:token];
        }
    }
}

- (id)makeRawAPIRequest:(NSString*)requestPath error:(NSError**)error
{
    NSString *request = nil;
    NSData *data;
    
    if ([requestPath rangeOfString:@"?"].location == NSNotFound)
        request = [NSString stringWithFormat:@"%@/%@%@?key=%@", self.descriptor.api_endpoint, CS_API_VERSION, requestPath, CS_API_KEY];
    else
        request = [NSString stringWithFormat:@"%@/%@%@&key=%@", self.descriptor.api_endpoint, CS_API_VERSION, requestPath, CS_API_KEY];

    int respCode = [HTTPRequest makeRequest:request withData:&data error:error];
    
    // Random HTTP errors : (rand() % 5 == 0) || 
    
#ifdef RANDOM_ERROR_RATE
    if (rand() % RANDOM_ERROR_RATE == 0 || respCode == HTTP_NO_NETWORK || respCode == HTTP_SERVER_ERROR)
#else
    if (respCode == HTTP_NO_NETWORK || respCode == HTTP_SERVER_ERROR)
#endif
    {
        if (error)
            *error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_NETWORK_ERROR userInfo:nil];
        return nil;
    }
    
    NSString *responseString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    id jsonResp = [responseString JSONValue];
    
    [responseString release];
    
#ifdef RANDOM_ERROR_RATE
    if ((rand() % RANDOM_ERROR_RATE == 0 || !jsonResp) && error)
#else
    if (!jsonResp && error)
#endif
        *error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_FORMAT_ERROR userInfo:nil];
    
    return jsonResp;
}

@end
