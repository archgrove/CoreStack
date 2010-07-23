/*
 
 CoreStack v1.0 : CSUserDescription.m
 
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

#import "CSUserDescription.h"
#import "NSDictionary+JSONDecoder.h"

@implementation CSUserDescription

@synthesize user_id;
@synthesize user_type;
@synthesize display_name;
@synthesize reputation;
@synthesize email_hash;

+ (NSString*)identifierKey
{
    // This is never used as a vector response
    assert(false);
    return nil;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    user_id = [decoder decodeIntForKey:@"user_id"];
    user_type = (enum CSUserType)[decoder decodeIntForKey:@"user_type"];
    display_name = [[decoder decodeObjectForKey:@"display_name"] retain];
    reputation = [decoder decodeIntForKey:@"reputation"];
    email_hash = [[decoder decodeObjectForKey:@"email_hash"] retain];
    
    return self;
}

- (void)dealloc
{
    [display_name release];
    [email_hash release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeInt:user_id forKey:@"user_id"];
    [encoder encodeInt:user_type forKey:@"user_type"];
    [encoder encodeObject:display_name forKey:@"display_name"];
    [encoder encodeInt:reputation forKey:@"reputation"];
    [encoder encodeObject:email_hash forKey:@"email_hash"];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    if (![super updateFromJSON:json error:error])
        return FALSE;

    if (![json extract:@"user_id" intoInt:&user_id error:error])
        return FALSE;
    if (![json extract:@"display_name" intoString:&display_name error:error])
        return FALSE;
    if (![json extract:@"reputation" intoInt:&reputation error:error])
        return FALSE;
    if (![json extract:@"email_hash" intoString:&email_hash error:error])
        return FALSE;

    NSString *userTypeStr = [json objectForKey:@"user_type"];
    if ([userTypeStr isEqualToString:@"anonymous"])
        user_type = CSUserTypeAnonymous;
    else if ([userTypeStr isEqualToString:@"moderator"])
        user_type = CSUserTypeModerator;
    else if ([userTypeStr isEqualToString:@"registered"])
        user_type = CSUserTypeRegistered;
    else if ([userTypeStr isEqualToString:@"unregistered"])
        user_type = CSUserTypeUnregistered;
    else
        user_type = CSUserTypeUnknown;

    return TRUE;
}

- (void)fillAsAnonymous
{
    display_name = @"Anonymous";
    user_id = -1;
    user_type = CSUserTypeAnonymous;
}

@end
