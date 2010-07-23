/*
 
 CoreStack v1.0 : CSTimelineEntry.m
 
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

#import "CSTimelineEntry.h"
#import "NSDictionary+JSONDecoder.h"


@implementation CSTimelineEntry

@synthesize user_id;
@synthesize timeline_type;
@synthesize post_id;
@synthesize post_type;
@synthesize comment_id;
@synthesize action;
@synthesize creation_date;
@synthesize description;
@synthesize detail;

+ (NSString*)identifierKey
{
    return @"user_timelines";
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    user_id = [decoder decodeIntForKey:@"user_id"];
    timeline_type = (enum CSTimelineType)[decoder decodeIntForKey:@"timeline_type"];
    post_id = [decoder decodeIntForKey:@"post_id"];
    post_type = [decoder decodeIntForKey:@"post_type"];
    comment_id = [decoder decodeIntForKey:@"comment_id"];
    action = [[decoder decodeObjectForKey:@"action"] retain];
    creation_date = [[decoder decodeObjectForKey:@"creation_date"] retain];
    description = [[decoder decodeObjectForKey:@"description"] retain];
    detail = [[decoder decodeObjectForKey:@"detail"] retain];
    
    return self;
}

- (void)dealloc
{
    [action release];
    [creation_date release];
    [description release];
    [detail release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeInt:user_id forKey:@"user_id"];
    [encoder encodeInt:timeline_type forKey:@"timeline_type"];
    [encoder encodeInt:post_id forKey:@"post_id"];
    [encoder encodeInt:post_type forKey:@"post_type"];
    [encoder encodeInt:comment_id forKey:@"comment_id"];
    [encoder encodeObject:action forKey:@"action"];
    [encoder encodeObject:creation_date forKey:@"creation_date"];
    [encoder encodeObject:description forKey:@"description"];
    [encoder encodeObject:detail forKey:@"detail"];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    if (![super updateFromJSON:json error:error])
        return FALSE;
    
    [json extract:@"user_id" intoInt:&user_id];
    [json extract:@"comment_id" intoInt:&comment_id];
    [json extract:@"post_id" intoInt:&post_id];
    [json extract:@"description" intoString:&description];
    [json extract:@"detail" intoString:&detail];
    [json extract:@"action" intoString:&action];
    
    NSString *timelineTypeStr = [json objectForKey:@"timeline_type"];
    if ([timelineTypeStr isEqualToString:@"comment"])
        timeline_type = CSTimelineTypeComment;
    else if ([timelineTypeStr isEqualToString:@"askoranswered"])
        timeline_type = CSTimelineTypeAskOrAnswered;
    else if ([timelineTypeStr isEqualToString:@"badge"])
        timeline_type = CSTimelineTypeBadge;
    else if ([timelineTypeStr isEqualToString:@"revision"])
        timeline_type = CSTimelineTypeRevision;
    else if ([timelineTypeStr isEqualToString:@"accepted"])
        timeline_type = CSTimelineTypeAccepted;
    else
        timeline_type = CSTimelineTypeUnknown;
    
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
