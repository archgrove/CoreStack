/*
 
 CoreStack v1.0 : CSRequestParams.m
 
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

#import "CSQuestion.h"

@implementation CSRequestParams

+ (NSString*)sortOrderToSortString:(enum CSQuestionSortOrder)sortOrder
{
    switch (sortOrder)
    {
        case CSQuestionSortByActivity:
            return @"activity";
        case CSQuestionSortByVotes:
            return @"votes";
        case CSQuestionSortByCreation:
            return @"creation";
        case CSQuestionSortByFeatured:
            return @"featured";
        case CSQuestionSortByHot:
            return @"hot";
        case CSQuestionSortByWeek:
            return @"week";
        case CSQuestionSortByMonth:
            return @"month";
        default:
            assert(false);
    }
    return nil;
}

@synthesize pageSize;
@synthesize pageNumber;
@synthesize responseVectorKey;
@synthesize responseType;

- (id)initWithRawURL:(NSString*)url andResponseVectorKey:(NSString*)respVectKey andType:(Class)type;
{
    self = [super init];
    
    if (self)
    {        
        rawURL = [url retain];
        responseVectorKey = [respVectKey retain];
        responseType = type;
        pageSize = 50;
        pageNumber = 1;
        params = [[NSMutableDictionary alloc] init];        
    }
    
    return self;
}

- (id)initWithURLFragment:(NSString*)fragment andResponseVectorKey:(NSString*)respVectKey andType:(Class)type
{
    self = [super init];
    
    if (self)
    {
        urlFragment = [fragment retain];
        responseVectorKey = [respVectKey retain];
        responseType = type;
        pageSize = 50;
        pageNumber = 1;
        params = [[NSMutableDictionary alloc] init];        
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        rawURL = [[aDecoder decodeObjectForKey:@"rawURL"] retain];
        urlFragment = [[aDecoder decodeObjectForKey:@"urlFragment"] retain];
        responseVectorKey = [[aDecoder decodeObjectForKey:@"responseVectorKey"] retain];
        
        NSString *respString = [aDecoder decodeObjectForKey:@"responseType"];        
        responseType = objc_getClass([respString cStringUsingEncoding:NSASCIIStringEncoding]);
        params = [[aDecoder decodeObjectForKey:@"params"] retain];
        
        pageSize = [aDecoder decodeIntForKey:@"pageSize"];
        pageNumber = [aDecoder decodeIntForKey:@"pageNumber"];
    }
    
    return self;
}

- (void)dealloc
{
    [params release];
    [responseVectorKey release];
    [urlFragment release];
    [rawURL release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:rawURL forKey:@"rawURL"];
    [aCoder encodeObject:urlFragment forKey:@"urlFragment"];
    [aCoder encodeObject:responseVectorKey forKey:@"responseVectorKey"];
    [aCoder encodeObject:params forKey:@"params"];
    
    const char *clsName = class_getName(responseType);
    NSString *clsString = [NSString stringWithCString:clsName encoding:NSASCIIStringEncoding];
    [aCoder encodeObject:clsString forKey:@"responseType"];
    
    [aCoder encodeInt:pageSize forKey:@"pageSize"];
    [aCoder encodeInt:pageNumber forKey:@"pageNumber"];
}

- (void)setParam:(NSString*)param toValue:(NSString*)value
{
    [params setObject:value forKey:param];
}

- (NSString*)toRequestURL
{
    NSMutableString *requestURL = nil;
    if (rawURL)
    {
        requestURL = [NSMutableString stringWithString:rawURL];
    }
    else
    {
        requestURL = [NSMutableString stringWithString:urlFragment];
        [requestURL appendFormat:@"?page=%i&pagesize=%i", pageNumber, pageSize];
    }
    
    NSString *separator = [requestURL rangeOfString:@"?"].location == NSNotFound ? @"?" : @"&";
    for (NSString *key in params)
    {
        id param = [params objectForKey:key];
        [requestURL appendFormat:@"%@%@=%@", separator, key, [param stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        separator = @"&";
    }
    
    return requestURL;
}

@end
