/*
 
 CoreStack v1.0 : CSTag.m
 
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

#import "NSDictionary+JSONDecoder.h"

#import "CSTag.h"

@implementation CSTag

@synthesize name; // Not optional
@synthesize count; // Not optional
@synthesize restricted_to; // Optional
@synthesize fulfills_required; // Not optional
@synthesize user_id; // Optional

+ (CSRequestParams*)requestParamsForAllTags
{
    return [[[CSRequestParams alloc] initWithURLFragment:@"/tags" andResponseVectorKey:@"tags" andType:[CSTag class]] autorelease];
}

+ (CSRequestParams*)requestParamsForTagsMatching:(NSString*)filter
{
    CSRequestParams *params = [[[CSRequestParams alloc] initWithURLFragment:@"/tags" andResponseVectorKey:@"tags" andType:[CSTag class]] autorelease];
    
    [params setParam:@"filter" toValue:filter];
    
    return params;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self)
    {
        name = [[decoder decodeObjectForKey:@"name"] retain];
        count = [decoder decodeIntForKey:@"count"];
        restricted_to = (enum CSUserType)[decoder decodeIntForKey:@"restricted_to"];
        fulfills_required = [decoder decodeBoolForKey:@"fulfills_required"];
        user_id = [decoder decodeIntForKey:@"user_id"];        
    }
    
    return self;
}

- (void)dealloc
{
    [name release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeInt:count forKey:@"count"];
    [encoder encodeInt:restricted_to forKey:@"restricted_to"];
    [encoder encodeBool:fulfills_required forKey:@"fulfills_required"];
    [encoder encodeInt:user_id forKey:@"user_id"];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    if (![super updateFromJSON:json error:error])
        return FALSE;
    
    if (![json extract:@"name" intoString:&name error:error])
        return FALSE;
    if (![json extract:@"count" intoInt:&count error:error])
        return FALSE;
    
    NSString *userTypeStr = [json objectForKey:@"restricted_to"];
    if ([userTypeStr isEqualToString:@"anonymous"])
        restricted_to = CSUserTypeAnonymous;
    else if ([userTypeStr isEqualToString:@"moderator"])
        restricted_to = CSUserTypeModerator;
    else if ([userTypeStr isEqualToString:@"registered"])
        restricted_to = CSUserTypeRegistered;
    else if ([userTypeStr isEqualToString:@"unregistered"])
        restricted_to = CSUserTypeUnregistered;
    else
        restricted_to = CSUserTypeUnknown;
        
    if (![json extract:@"fulfills_required" intoBool:&fulfills_required error:error])
        return FALSE;
    
    if (![json extract:@"user_id" intoInt:&user_id])
        user_id = -1;
    
    return TRUE;
}

@end
