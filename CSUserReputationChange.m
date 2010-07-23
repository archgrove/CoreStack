/*
 
 CoreStack v1.0 : CSUserReputationChange.m
 
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

#import "CSUserReputationChange.h"
#import "NSDictionary+JSONDecoder.h"


@implementation CSUserReputationChange

+ (NSString*)identifierKey
{
    return @"rep_changes";
}

@synthesize user_id;
@synthesize post_id;
@synthesize post_type;
@synthesize title;
@synthesize positive_rep;
@synthesize negative_rep;
@synthesize on_date;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    user_id = [decoder decodeIntForKey:@"user_id"];
    post_id = [decoder decodeIntForKey:@"post_id"];
    post_type = [decoder decodeIntForKey:@"post_type"];
    title = [[decoder decodeObjectForKey:@"title"] retain];
    positive_rep = [decoder decodeIntForKey:@"positive_rep"];
    negative_rep = [decoder decodeIntForKey:@"negative_rep"];
    on_date = [[decoder decodeObjectForKey:@"on_date"] retain];
    
    return self;
}

- (void)dealloc
{
    [title release];
    [on_date release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeInt:user_id forKey:@"user_id"];
    [encoder encodeInt:post_id forKey:@"post_id"];
    [encoder encodeInt:post_type forKey:@"post_type"];
    [encoder encodeObject:title forKey:@"title"];
    [encoder encodeInt:positive_rep forKey:@"positive_rep"];
    [encoder encodeInt:negative_rep forKey:@"negative_rep"];
    [encoder encodeObject:on_date forKey:@"on_date"];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    if (![super updateFromJSON:json error:error])
        return FALSE;
    
    if (![json extract:@"user_id" intoInt:&user_id error:error])
        return FALSE;
    if (![json extract:@"post_id" intoInt:&post_id error:error])
        return FALSE;
    if (![json extract:@"title" intoString:&title error:error])
        return FALSE;
    if (![json extract:@"positive_rep" intoInt:&positive_rep error:error])
        return FALSE;
    if (![json extract:@"negative_rep" intoInt:&negative_rep error:error])
        return FALSE;
    if (![json extract:@"on_date" intoDate:&on_date error:error])
        return FALSE;
    
    NSString *postTypeStr = [json objectForKey:@"post_type"];
    if ([postTypeStr isEqualToString:@"question"])
        post_type = CSPostTypeQuestion;
    else if ([postTypeStr isEqualToString:@"answer"])
        post_type = CSPostTypeAnswer;
    else
        post_type = CSPostTypeUnknown;
    
    return TRUE;
}

@end
