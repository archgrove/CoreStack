/*
 
 CoreStack v1.0 : CSBadge.m
 
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

#import "CSBadge.h"


@implementation CSBadge

@synthesize rank;
@synthesize name;
@synthesize description;
@synthesize award_count;
@synthesize tag_based;
@synthesize user;
@synthesize badges_recipients_url;

+ (CSRequestParams*)requestParamsForObjectWithIdentifier:(int)ident
{
    return [[[CSRequestParams alloc] initWithRawURL:[NSString stringWithFormat:@"/badges/%i", ident] andResponseVectorKey:@"badges" andType:[CSBadge class]] autorelease];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    rank = (enum CSBadgeRank)[decoder decodeIntForKey:@"rank"];
    name = [[decoder decodeObjectForKey:@"name"] retain];
    description = [[decoder decodeObjectForKey:@"description"] retain];
    award_count = [decoder decodeIntForKey:@"award_count"];
    tag_based = [decoder decodeBoolForKey:@"tag_based"];
    user = [[decoder decodeObjectForKey:@"user"] retain];
    badges_recipients_url = [[decoder decodeObjectForKey:@"badges_recipients_url"] retain];
    
    return self;
}

- (void)dealloc
{
    [name release];
    [description release];
    [badges_recipients_url release];
    [user release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeInt:rank forKey:@"rank"];
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:description forKey:@"description"];
    [encoder encodeInt:award_count forKey:@"award_count"];
    [encoder encodeBool:tag_based forKey:@"tag_based"];
    [encoder encodeObject:user forKey:@"user"];
    [encoder encodeObject:badges_recipients_url forKey:@"badges_recipients_url"];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    if (![json extract:@"badge_id" intoInt:&identifier error:error])
        return FALSE;
    
    if (![super updateFromJSON:json error:error])
        return FALSE;
    
    if (![json extract:@"name" intoString:&name error:error])
        return FALSE;
    if (![json extract:@"description" intoString:&description error:error])
        return FALSE;
    if (![json extract:@"award_count" intoInt:&award_count error:error])
        return FALSE;
    if (![json extract:@"tag_based" intoBool:&tag_based error:error])
        return FALSE;
    if (![json extract:@"badges_recipients_url" intoString:&badges_recipients_url error:error])
        return FALSE;

    NSString *rankStr = nil;
    if (![json extract:@"rank" intoString:&rankStr error:error])
        return FALSE;
    if ([rankStr isEqual:@"gold"])
        rank = CSBadgeRankGold;
    else if ([rankStr isEqual:@"silver"])
        rank = CSBadgeRankSilver;
    else if ([rankStr isEqual:@"bronze"])
        rank = CSBadgeRankBronze;
    else
        rank = CSBadgeRankUnknown;
    [rankStr release];
    
    if (![json objectForKey:@"user"])
        return FALSE;
    user = [[CSUserDescription alloc] init];
    if (![user updateFromJSON:[json objectForKey:@"user"] error:error])
        return FALSE;
    
    return TRUE;
}
    

@end
