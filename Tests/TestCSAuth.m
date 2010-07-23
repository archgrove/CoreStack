/*
 
 CoreStack v1.0 : CSObjectVector.m
 
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


#import "TestCSAuth.h"

@implementation TestCSAuth

- (void)testAuthDownload
{
    CSAuth *auth = [[[CSAuth alloc] init] autorelease];
    
    GHAssertEquals((int)[auth.sites count], 0, @"Sites in StackAuth wrapper started non-empty!");
    [auth updateSites];    
    
    [self authIsWellFormed:auth];
}

- (void)testAuthCoding
{
    CSAuth *auth = [[[CSAuth alloc] init] autorelease];
    [auth updateSites];    
    [self authIsWellFormed:auth];
    
    NSMutableData *data = [NSMutableData dataWithCapacity:1000];    
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    
    [auth encodeWithCoder:archiver];
    [archiver finishEncoding];
    GHAssertGreaterThan((int)[data length], 0, @"Coding of CSAuth didn't produce any data!");
    
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    CSAuth *auth2 = [[[CSAuth alloc] initWithCoder:unarchiver] autorelease];
    [unarchiver finishDecoding];    
    
    GHAssertNotNil(auth, @"Unarchiving auth failed");
    GHAssertEquals([auth.sites count], [auth2.sites count], @"Unarchiving auth failed");
    [self authIsWellFormed:auth2];    
}

- (void)authIsWellFormed:(CSAuth*)auth
{
    GHAssertNotNil(auth.sites, @"Sites in StackAuth finished nil!");
    
    CSSiteDescriptor *desc = [auth.sites objectAtIndex:0];
    
    GHAssertNotNil(desc, @"There were no sites returned by StackAuth");
    GHAssertEqualObjects(desc.name, @"Stack Overflow", @"The first site wasn't Stack Overflow!");
}

@end
