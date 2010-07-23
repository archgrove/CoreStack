/*
 
 CoreStack v1.0 : CSSiteDescriptor.m
 
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

#import "CSSiteDescriptor.h"

#import "NSDictionary+JSONDecoder.h"

@implementation CSSiteDescriptor

@synthesize name;
@synthesize logo_url;
@synthesize api_endpoint;
@synthesize site_url;
@synthesize description;
@synthesize icon_url;
@synthesize aliases;
@synthesize state;
@synthesize styling_link_color;
@synthesize styling_tag_foreground_color;
@synthesize styling_tag_background_color;

- (id)initWithName:(NSString*)_name andEndPoint:(NSString*)_api_endpoint
{
    self = [super init];
    
    if (self)
    {
        name = [_name retain];
        api_endpoint = [_api_endpoint retain];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        name = [[aDecoder decodeObjectForKey:@"name"] retain];
        logo_url = [[aDecoder decodeObjectForKey:@"logo_url"] retain];
        api_endpoint = [[aDecoder decodeObjectForKey:@"api_endpoint"] retain];
        site_url = [[aDecoder decodeObjectForKey:@"site_url"] retain];
        description = [[aDecoder decodeObjectForKey:@"description"] retain];
        icon_url = [[aDecoder decodeObjectForKey:@"icon_url"] retain];
        aliases = [[aDecoder decodeObjectForKey:@"aliases"] retain];
        state = (enum CSSiteState)[aDecoder decodeIntForKey:@"state"];
        styling_link_color = [[aDecoder decodeObjectForKey:@"styling_link_color"] retain];
        styling_tag_foreground_color = [[aDecoder decodeObjectForKey:@"styling_tag_foreground_color"] retain];
        styling_tag_background_color = [[aDecoder decodeObjectForKey:@"styling_tag_background_color"] retain];
    }
    
    return self;
}

- (void)dealloc
{
    [name release];
    [logo_url release];
    [api_endpoint release];
    [site_url release];
    [description release];
    [icon_url release];
    [aliases release];
    [styling_link_color release];
    [styling_tag_foreground_color release];
    [styling_tag_background_color release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:logo_url forKey:@"logo_url"];
    [aCoder encodeObject:api_endpoint forKey:@"api_endpoint"];
    [aCoder encodeObject:site_url forKey:@"site_url"];
    [aCoder encodeObject:description forKey:@"description"];
    [aCoder encodeObject:icon_url forKey:@"icon_url"];
    [aCoder encodeObject:aliases forKey:@"aliases"];
    [aCoder encodeInt:(int)state forKey:@"state"];
    [aCoder encodeObject:styling_link_color forKey:@"styling_link_color"];
    [aCoder encodeObject:styling_tag_foreground_color forKey:@"styling_tag_foreground_color"];
    [aCoder encodeObject:styling_tag_background_color forKey:@"styling_tag_background_color"];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    if (![json extract:@"name" intoString:&name error:error])
        return FALSE;
    [json extract:@"logo_url" intoURL:&logo_url];
    [json extract:@"api_endpoint" intoString:&api_endpoint];
    [json extract:@"site_url" intoURL:&site_url];
    [json extract:@"description" intoString:&description];
    [json extract:@"icon_url" intoURL:&icon_url];
    [json extract:@"aliases" intoArray:&aliases];
        
    NSString *stateString = nil;
    if (![json extract:@"state" intoString:&stateString error:error])
        return FALSE;    
    if ([stateString isEqualToString:@"normal"])
        state = CSSiteStateNormal;
    else if ([stateString isEqualToString:@"closed_beta"])
        state = CSSiteStateClosedBeta;
    else if ([stateString isEqualToString:@"open_beta"])
        state = CSSiteStateOpenBeta;
    else if ([stateString isEqualToString:@"linked_meta"])
        state = CSSiteStateLinkedMeta;
    else
        state = CSSiteStateUnknown;
    [stateString release];
    
    NSDictionary *stylingJSON = nil;
    if (![json extract:@"styling" intoDictionary:&stylingJSON error:error])
        return FALSE;
    
    if (![stylingJSON extract:@"link_color" intoString:&styling_link_color error:error])
        return FALSE;
    if (![stylingJSON extract:@"tag_foreground_color" intoString:&styling_tag_foreground_color error:error])
        return FALSE;
    if (![stylingJSON extract:@"tag_background_color" intoString:&styling_tag_background_color error:error])
        return FALSE;
    
    [stylingJSON release];

    return TRUE;
}

@end
