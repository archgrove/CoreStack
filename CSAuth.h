/*
 
 CoreStack v1.0 : CSAuth.h
 
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

#import <Foundation/Foundation.h>

#import "Pair.h"

#import "CSRequestToken.h"
#import "CSObjectVector.h"

@protocol CSAuthDelegate
@optional
- (void)siteListUpdated:(id)sites error:(NSError*)error;
- (void)associationsFound:(CSObjectVector*)associations error:(NSError*)error;
@end

@interface CSAuth : NSObject<NSCoding> {
    id<CSAuthDelegate> delegate;
    CSObjectVector *sites;
}

@property (assign) id<CSAuthDelegate> delegate;
@property (readonly) CSObjectVector *sites;

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)dealloc;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (void)updateSites;
- (void)findAssociationsForUID:(NSString*)associationID;


- (void)updateSitesWorker;
- (void)findAssociationsForUIDWorker:(NSString*)uid;
- (void)deliverUpdateMessage:(NSError*)error;
- (void)deliverAssociations:(Pair*)p;

- (id)dataFromRequest:(NSString*)request error:(NSError**)error;

@end
