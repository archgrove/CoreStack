/*
 
 CoreStack v1.0 : CSSiteStatistics.m
 
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

#import "CSSiteStatistics.h"

#import "NSDictionary+JSONDecoder.h"

@implementation CSSiteStatistics

@synthesize total_questions;
@synthesize total_unanswered;
@synthesize total_accepted;
@synthesize total_answers;
@synthesize total_comments;
@synthesize total_votes;
@synthesize total_badges;
@synthesize total_users;
@synthesize questions_per_minute;
@synthesize answers_per_minute;
@synthesize badges_per_minute;
@synthesize views_per_day;
@synthesize api_version;
@synthesize api_revision;
@synthesize site;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    total_questions = [decoder decodeIntForKey:@"total_questions"];
    total_unanswered = [decoder decodeIntForKey:@"total_unanswered"];
    total_accepted = [decoder decodeIntForKey:@"total_accepted"];
    total_answers = [decoder decodeIntForKey:@"total_answers"];
    total_comments = [decoder decodeIntForKey:@"total_comments"];
    total_votes = [decoder decodeIntForKey:@"total_votes"];
    total_badges = [decoder decodeIntForKey:@"total_badges"];
    total_users = [decoder decodeIntForKey:@"total_users"];
    
    questions_per_minute = [decoder decodeDoubleForKey:@"questions_per_minute"];
    answers_per_minute = [decoder decodeDoubleForKey:@"answers_per_minute"];
    badges_per_minute = [decoder decodeDoubleForKey:@"badges_per_minute"];
    views_per_day = [decoder decodeDoubleForKey:@"views_per_day"];
    
    api_version = [[decoder decodeObjectForKey:@"api_version"] retain];
    api_revision = [[decoder decodeObjectForKey:@"api_revision"] retain];
    site = [[decoder decodeObjectForKey:@"site"] retain];
    
    return self;
}

- (void)dealloc
{
    [api_version release];
    [api_revision release];
    [site release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInt:total_questions forKey:@"total_questions"];
    [aCoder encodeInt:total_unanswered forKey:@"total_unanswered"];
    [aCoder encodeInt:total_accepted forKey:@"total_accepted"];
    [aCoder encodeInt:total_answers forKey:@"total_answers"];
    [aCoder encodeInt:total_comments forKey:@"total_comments"];
    [aCoder encodeInt:total_votes forKey:@"total_votes"];
    [aCoder encodeInt:total_badges forKey:@"total_badges"];
    [aCoder encodeInt:total_users forKey:@"total_users"];
    
    [aCoder encodeDouble:questions_per_minute forKey:@"questions_per_minute"];
    [aCoder encodeDouble:answers_per_minute forKey:@"answers_per_minute"];
    [aCoder encodeDouble:badges_per_minute forKey:@"badges_per_minute"];
    [aCoder encodeDouble:views_per_day forKey:@"views_per_day"];

    [aCoder encodeObject:api_version forKey:@"api_version"];
    [aCoder encodeObject:api_revision forKey:@"api_revision"];
    [aCoder encodeObject:site forKey:@"site"];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    if (![super updateFromJSON:json error:error])
        return FALSE;
    
    if (![json extract:@"total_questions" intoInt:&total_questions error:error])
        return FALSE;
    if (![json extract:@"total_unanswered" intoInt:&total_unanswered error:error])
        return FALSE;
    if (![json extract:@"total_accepted" intoInt:&total_accepted error:error])
        return FALSE;
    if (![json extract:@"total_answers" intoInt:&total_answers error:error])
        return FALSE;
    if (![json extract:@"total_comments" intoInt:&total_comments error:error])
        return FALSE;
    if (![json extract:@"total_votes" intoInt:&total_votes error:error])
        return FALSE;
    if (![json extract:@"total_badges" intoInt:&total_badges error:error])
        return FALSE;
    if (![json extract:@"total_users" intoInt:&total_users error:error])
        return FALSE;
    if (![json extract:@"questions_per_minute" intoDouble:&questions_per_minute error:error])
        return FALSE;
    if (![json extract:@"answers_per_minute" intoDouble:&answers_per_minute error:error])
        return FALSE;
    if (![json extract:@"badges_per_minute" intoDouble:&badges_per_minute error:error])
        return FALSE;
    if (![json extract:@"views_per_day" intoDouble:&views_per_day error:error])
        return FALSE;
    
    if (![json objectForKey:@"api_version"])
        return FALSE;
    id apiVersionJson = [json objectForKey:@"api_version"];
    if (![apiVersionJson extract:@"version" intoString:&api_version error:error])
        return FALSE;
    if (![apiVersionJson extract:@"revision" intoString:&api_revision error:error])
        return FALSE;
    
    if (![json objectForKey:@"site"])
        return FALSE;
    id siteJson = [json objectForKey:@"site"];
    site = [[CSSiteDescriptor alloc] init];
    
    if (![site updateFromJSON:siteJson error:error])
        return FALSE;
    
    return TRUE;    
}

@end
