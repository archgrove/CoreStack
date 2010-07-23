/*
 
 CoreStack v1.0 : CSAuth.m
 
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

#import "JSON.h"

#import "HTTPRequest.h"

#import "CoreStackConstants.h"
#import "CSUserAssociation.h"
#import "CSSiteDescriptor.h"
#import "CSAuth.h"

@implementation CSAuth

@synthesize delegate;
@synthesize sites;

- (id)init
{
    self = [super init];
    
    if (self)
        sites = [[CSObjectVector alloc] initWithObjectClass:[CSSiteDescriptor class] forVectorKey:@"api_sites"];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
        sites = [[aDecoder decodeObjectForKey:@"sites"] retain];
    
    return self;
}

- (void)dealloc
{
    [sites release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:sites forKey:@"sites"];
}

- (void)updateSites
{
#ifdef TESTING
    [self updateSitesWorker];
#else
    [self performSelectorInBackground:@selector(updateSitesWorker) withObject:nil];
#endif
}

- (void)findAssociationsForUID:(NSString*)associationID
{
#ifdef TESTING
    [self findAssociationsForUIDWorker:associationID];
#else
    [self performSelectorInBackground:@selector(findAssociationsForUIDWorker:) withObject:associationID];
#endif
}

- (void)updateSitesWorker
{
#ifndef TESTING
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif
    
    // Ensure we get a retain/autorelease reference to the delegate, if it exists
    NSString *request = [NSString stringWithFormat:@"%@/%@/sites?key=%@", CS_AUTH_URL, CS_API_VERSION, CS_API_KEY];    
    NSError *error = nil;
    
    id jsonResp = [self dataFromRequest:request error:&error];
    
    if (!jsonResp)
    {
        if (!error)
            error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_FORMAT_ERROR userInfo:nil];
    }
    else        
    {
        [sites release];        
        sites = [[CSObjectVector alloc] initWithObjectClass:[CSSiteDescriptor class] forVectorKey:@"api_sites"];
        [sites fillWithJSON:jsonResp error:&error];
    }


#ifdef TESTING
    [self deliverUpdateMessage:error];
#else
    [self performSelectorOnMainThread:@selector(deliverUpdateMessage:) withObject:error waitUntilDone:NO];
#endif
    
#ifndef TESTING
    [pool release];
#endif
}

- (void)findAssociationsForUIDWorker:(NSString*)uid
{
#ifndef TESTING
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif
    
    // Ensure we get a retain/autorelease reference to the delegate, if it exists
    NSString *request = [NSString stringWithFormat:@"%@/%@/users/%@/associated?key=%@", CS_AUTH_URL, CS_API_VERSION, uid, CS_API_KEY];    
    NSError *error = nil;
    
    id jsonResp = [self dataFromRequest:request error:&error];
    CSObjectVector *associations = [[[CSObjectVector alloc] initWithObjectClass:[CSUserAssociation class] forVectorKey:@"associated_users"] autorelease];
    if (!jsonResp)
    {
        if (!error)
            error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_FORMAT_ERROR userInfo:nil];
    }
    else        
    {
        [associations fillWithJSON:jsonResp error:&error];
    }
    
    Pair *pair = [[[Pair alloc] initWithLeft:associations andRight:error] autorelease];
#ifdef TESTING
    [self deliverAssociations:pair];
#else
    [self performSelectorOnMainThread:@selector(deliverAssociations:) withObject:pair waitUntilDone:NO];
#endif
    
#ifndef TESTING
    [pool release];
#endif    
}

- (void)deliverUpdateMessage:(NSError*)error
{
    id target = self.delegate;
    
    if (target && [target respondsToSelector:@selector(siteListUpdated:error:)])
        [target siteListUpdated:self error:error];
}

- (void)deliverAssociations:(Pair*)p
{
    id target = self.delegate;
    
    if (target && [target respondsToSelector:@selector(siteListUpdated:error:)])
        [target associationsFound:p.left error:p.right];
}

- (id)dataFromRequest:(NSString*)request error:(NSError**)error
{
    NSData *data = nil;
    id jsonResp = nil;
    
    int respCode = [HTTPRequest makeRequest:request withData:&data error:error];
    
    if (respCode == HTTP_NO_NETWORK && error)
    {
        *error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_NETWORK_ERROR userInfo:nil];
    }
    else if (respCode == HTTP_SERVER_ERROR  && error)
    {
        *error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_SERVER_ERROR userInfo:nil];
    }
    else
    {
        NSString *responseString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        jsonResp = [responseString JSONValue];
        [responseString release];
    }
    
    return jsonResp;
}

@end
