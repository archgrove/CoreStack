/*
 
 CoreStack v1.0 : CSPostRevision.m
 
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

#import "CSPostRevision.h"

#import "NSDictionary+JSONDecoder.h"

@implementation CSPostRevision

@synthesize body; // Optional
@synthesize comment; // Not optional
@synthesize creation_date; // Not optional
@synthesize is_question; // Not optional    
@synthesize is_rollback; // Not optional
@synthesize last_body; // Optional
@synthesize last_title; // Optional
@synthesize last_tags; // Optional
@synthesize revision_guid; // Not optional
@synthesize revision_number; // Optional
@synthesize tags; // Optional
@synthesize title; // Optional
@synthesize revision_type; // Not optional
@synthesize set_community_wiki; // Not optional
@synthesize user; // Optional
@synthesize post_id; // Not optional

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self)
    {
        body = [[decoder decodeObjectForKey:@"body"] retain];
        comment = [[decoder decodeObjectForKey:@"comment"] retain];
        creation_date = [[decoder decodeObjectForKey:@"creation_date"] retain];
        is_question = [decoder decodeBoolForKey:@"is_question"];
        is_rollback = [decoder decodeBoolForKey:@"is_rollback"];
        last_body = [[decoder decodeObjectForKey:@"last_body"] retain];
        last_title = [[decoder decodeObjectForKey:@"last_title"] retain];
        last_tags = [[decoder decodeObjectForKey:@"last_tags"] retain];
        revision_guid = [[decoder decodeObjectForKey:@"revision_guid"] retain];
        revision_number = [decoder decodeIntForKey:@"revision_number"];
        tags = [[decoder decodeObjectForKey:@"tags"] retain];
        title = [[decoder decodeObjectForKey:@"title"] retain];
        revision_type = [decoder decodeIntForKey:@"revision_type"];
        set_community_wiki = [decoder decodeBoolForKey:@"set_community_wiki"];
        user = [[decoder decodeObjectForKey:@"user"] retain];
        post_id = [decoder decodeIntForKey:@"post_id"];
    }
    
    return self;
}

- (void)dealloc
{
    [body release];
    [comment release];
    [creation_date release];
    [last_body release];
    [last_title release];
    [last_tags release];
    [revision_guid release];
    [tags release];
    [title release];
    [user release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:body forKey:@"body"];
    [encoder encodeObject:comment forKey:@"comment"];
    [encoder encodeObject:creation_date forKey:@"creation_date"];
    [encoder encodeBool:is_question forKey:@"is_question"];
    [encoder encodeBool:is_rollback forKey:@"is_rollback"];
    [encoder encodeObject:last_body forKey:@"last_body"];
    [encoder encodeObject:last_title forKey:@"last_title"];
    [encoder encodeObject:last_tags forKey:@"last_tags"];
    [encoder encodeObject:revision_guid forKey:@"revision_guid"];
    [encoder encodeInt:revision_number forKey:@"revision_number"];
    [encoder encodeObject:tags forKey:@"tags"];
    [encoder encodeObject:title forKey:@"title"];
    [encoder encodeInt:revision_type forKey:@"revision_type"];
    [encoder encodeBool:set_community_wiki forKey:@"set_community_wiki"];
    [encoder encodeObject:user forKey:@"user"];
    [encoder encodeInt:post_id forKey:@"post_id"];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    if (![super updateFromJSON:json error:error])
        return FALSE;
    
    [json extract:@"body" intoString:&body];
    if (![json extract:@"comment" intoString:&body error:error])
        return FALSE;
    if (![json extract:@"creation_date" intoDate:&creation_date error:error])
        return FALSE;
    if (![json extract:@"is_question" intoBool:&is_question error:error])
        return FALSE;
    if (![json extract:@"is_rollback" intoBool:&is_rollback error:error])
        return FALSE;
    [json extract:@"last_body" intoString:&last_body];
    [json extract:@"last_title" intoString:&last_title];
    [json extract:@"last_tags" intoArray:&last_tags];
    if (![json extract:@"revision_guid" intoString:&revision_guid error:error])
        return FALSE;    
    [json extract:@"revision_number" intoInt:&revision_number];
    [json extract:@"tags" intoArray:&tags];
    [json extract:@"title" intoString:&title];
    if (![json extract:@"set_community_wiki" intoBool:&set_community_wiki error:error])
        return FALSE;
    
    NSString *revTypeString;
    if (![json extract:@"revision_type" intoString:&revTypeString error:error])
        return FALSE;
    
    if ([revTypeString isEqual:@"single_user"])
        revision_type = CSPostRevisionSingleUser;
    else if ([revTypeString isEqual:@"vote_based"])
        revision_type = CSPostRevisionVoteBased;
    else
        revision_type = CSPostRevisionUnknown;

    user = [[CSUserDescription alloc] init];
    if (![json objectForKey:@"user"] || ![user updateFromJSON:[json objectForKey:@"user"] error:error])
        [user fillAsAnonymous];

    if (![json extract:@"post_id" intoInt:&post_id error:error])
        return FALSE;
    
    return TRUE;
}

@end
