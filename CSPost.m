/*
 
 CoreStack v1.0 : CSPost.m
 
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

#import "CSPost.h"
#import "NSDictionary+JSONDecoder.h"

#import "CSQuestion.h"
#import "CSComment.h"

@implementation CSPost

@synthesize locked_date;
@synthesize owner;
@synthesize creation_date;
@synthesize last_edit_date;
@synthesize last_activity_date;
@synthesize up_vote_count;
@synthesize down_vote_count;
@synthesize view_count;
@synthesize score;
@synthesize community_owned;
@synthesize title;
@synthesize body;
@synthesize comments;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    locked_date = [[decoder decodeObjectForKey:@"locked_date"] retain];
    owner = [[decoder decodeObjectForKey:@"owner"] retain];
    creation_date = [[decoder decodeObjectForKey:@"creation_date"] retain];
    last_edit_date = [[decoder decodeObjectForKey:@"last_edit_date"] retain];
    last_activity_date = [[decoder decodeObjectForKey:@"last_activity_date"] retain];
    up_vote_count = [decoder decodeIntForKey:@"up_vote_count"];
    down_vote_count = [decoder decodeIntForKey:@"down_vote_count"];
    view_count = [decoder decodeIntForKey:@"view_count"];
    score = [decoder decodeIntForKey:@"score"];
    community_owned =[decoder decodeBoolForKey:@"community_owned"];
    title = [[decoder decodeObjectForKey:@"title"] retain];
    body = [[decoder decodeObjectForKey:@"body"] retain];
    comments = [[decoder decodeObjectForKey:@"comments"] retain];
    
    return self;
}

- (void)dealloc
{
    [locked_date release];
    [owner release];
    [creation_date release];
    [last_edit_date release];
    [last_activity_date release];
    [title release];
    [body release];
    [comments release];
     
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:locked_date forKey:@"locked_date"];
    [encoder encodeObject:owner forKey:@"owner"];
    [encoder encodeObject:creation_date forKey:@"creation_date"];
    [encoder encodeObject:last_edit_date forKey:@"last_edit_date"];
    [encoder encodeObject:last_activity_date forKey:@"last_activity_date"];
    [encoder encodeInt:up_vote_count forKey:@"up_vote_count"];
    [encoder encodeInt:down_vote_count forKey:@"down_vote_count"];
    [encoder encodeInt:view_count forKey:@"view_count"];
    [encoder encodeInt:score forKey:@"score"];
    [encoder encodeBool:community_owned forKey:@"community_owned"];
    [encoder encodeObject:title forKey:@"title"];
    [encoder encodeObject:body forKey:@"body"];
    [encoder encodeObject:comments forKey:@"comments"];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    /* 
     question_id            Int     False
     locked_date            Date    True
     owner                  User    False
     creation_date          Date    False
     last_edit_date         Date    True
     last_activity_date     Date    True
     up_vote_count          Int     False
     down_vote_count        Int     False
     view_count             Int     False
     score                  Int     False
     community_owned        Bool    False
     title                  String  False
     body                   String  True
     comments               Comment True
     */
    
    if (![super updateFromJSON:json error:error])
        return FALSE;
    
    [json extract:@"locked_date" intoDate:&locked_date];

    [owner release];
    owner = [[CSUserDescription alloc] init];
    
    if (![owner updateFromJSON:[json objectForKey:@"owner"] error:error])
        [owner fillAsAnonymous];
        
    if (![json extract:@"creation_date" intoDate:&creation_date error:error])
        return FALSE;
    [json extract:@"last_edit_date" intoDate:&last_edit_date];
    [json extract:@"last_activity_date" intoDate:&last_activity_date];
    if (![json extract:@"up_vote_count" intoInt:&up_vote_count error:error])
        return FALSE;        
    if (![json extract:@"down_vote_count" intoInt:&down_vote_count error:error])
        return FALSE;        
    if (![json extract:@"view_count" intoInt:&view_count error:error])
        return FALSE;        
    if (![json extract:@"score" intoInt:&score error:error])
        return FALSE;        
    if (![json extract:@"community_owned" intoBool:&community_owned error:error])
        return FALSE;            
    if (![json extract:@"title" intoString:&title error:error])
        return FALSE;        
    
    [json extract:@"body" intoString:&body];

    if ([json objectForKey:@"comments"])
    {
        comments = [[CSObjectVector alloc] initWithObjectClass:[CSComment class] forVectorKey:@"comments"];
        if (![comments fillWithJSON:json error:error])
            return FALSE;
    }
    else
    {
        [comments release];
        comments = nil;
    }
    
    return TRUE;
}

- (enum CSPostType)post_type
{
    // HACK: Don't like this one bit, but there's no common field
    if ([self isKindOfClass:[CSQuestion class]])
        return CSPostTypeQuestion;
    else
        return CSPostTypeAnswer;
    
    return CSPostTypeUnknown;
}

@end
