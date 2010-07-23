/*
 
 CoreStack v1.0 : CSComment.m
 
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

#import "CSComment.h"
#import "NSDictionary+JSONDecoder.h"


@implementation CSComment

@synthesize creation_date;
@synthesize owner;    
@synthesize reply_to_user;    
@synthesize post_id;
@synthesize post_type;
@synthesize score;
@synthesize edit_count;
@synthesize body;

+ (CSRequestParams*)requestParamsForObjectWithIdentifier:(int)ident
{
    return [[[CSRequestParams alloc] initWithRawURL:[NSString stringWithFormat:@"/comments/%i", ident] andResponseVectorKey:@"comments" andType:[CSComment class]] autorelease];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    creation_date = [[decoder decodeObjectForKey:@"creation_date"] retain];
    owner = [[decoder decodeObjectForKey:@"owner"] retain];
    reply_to_user = [[decoder decodeObjectForKey:@"reply_to_user"] retain];
    post_id = [decoder decodeIntForKey:@"post_id"];
    post_type = (enum CSPostType)[decoder decodeIntForKey:@"post_type"];
    score = [decoder decodeIntForKey:@"score"];
    edit_count = [decoder decodeIntForKey:@"edit_count"];
    body = [[decoder decodeObjectForKey:@"body"] retain];
    
    return self;
}

- (void)dealloc
{
    [creation_date release];
    [owner release];
    [reply_to_user release];
    [body release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:creation_date forKey:@"creation_date"];
    [encoder encodeObject:owner forKey:@"owner"];
    [encoder encodeObject:reply_to_user forKey:@"reply_to_user"];
    [encoder encodeInt:post_id forKey:@"post_id"];
    [encoder encodeInt:post_type forKey:@"post_type"];
    [encoder encodeInt:score forKey:@"score"];
    [encoder encodeInt:edit_count forKey:@"edit_count"];
    [encoder encodeObject:body forKey:@"body"];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    /*
     
     comment_id, Int, False
     creation_date, Date, False
     owner, UserDesc, False
     reply_to_user, UserDesc, True
     post_id, Int, False
     post_type, {question | answer}, False
     score, Int, False
     edit_count, Int, True
     body, String, False
     
     */
    
    if (![super updateFromJSON:json error:error])
        return FALSE;
    
    if (![json extract:@"comment_id" intoInt:&identifier error:error])
        return FALSE;
    
    if (![json extract:@"creation_date" intoDate:&creation_date error:error])
        return FALSE;
    
    if (owner)
        [owner release];
    owner = [[CSUserDescription alloc] init];
    if (![owner updateFromJSON:[json objectForKey:@"owner"] error:error])
        [owner fillAsAnonymous];

    if (reply_to_user)
        [reply_to_user release];
    reply_to_user = [[CSUserDescription alloc] init];
    [reply_to_user updateFromJSON:[json objectForKey:@"reply_to_user"] error:error];
    
    if (![json extract:@"post_id" intoInt:&post_id error:error])
        return FALSE;
    
    NSString *postTypeStr = [json objectForKey:@"post_type"];
    if ([postTypeStr isEqualToString:@"question"])
        post_type = CSPostTypeQuestion;
    else if ([postTypeStr isEqualToString:@"answer"])
        post_type = CSPostTypeAnswer;
    else
        post_type = CSPostTypeUnknown;
    
    if (![json extract:@"score" intoInt:&score error:error])
        return FALSE;
    [json extract:@"edit_count" intoInt:&edit_count];
    if (![json extract:@"body" intoString:&body error:error])
        return FALSE;
    
    return TRUE;
}

- (NSString*)body_without_entities
{
    NSMutableString *newBody = [NSMutableString stringWithString:body];
    
    [newBody replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newBody length])];
    [newBody replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newBody length])];
 
    // Kill all other entities
    while (true)
    {
        NSRange ampRange = [newBody rangeOfString:@"&"];        
        if (ampRange.location == NSNotFound)
            break;
    
        int toDelete = 1;
        
        NSRange entityRange = [newBody rangeOfString:@";" options:NSLiteralSearch range:NSMakeRange(ampRange.location, 6)];

        if (entityRange.location != NSNotFound)
            toDelete = (entityRange.location - ampRange.location) + 1;
        
        [newBody deleteCharactersInRange:NSMakeRange(ampRange.location, toDelete)];
    }
    
    return newBody;
}

@end
