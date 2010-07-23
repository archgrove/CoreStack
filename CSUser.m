/*
 
 CoreStack v1.0 : CSUser.m
 
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

#import "CSUser.h"
#import "NSDictionary+JSONDecoder.h"

#import "CSTimelineEntry.h"
#import "CSComment.h"
#import "CSUserReputationChange.h"
#import "CSBadge.h"

#import "CSQuestion.h"
#import "CSAnswer.h"

@implementation CSUser

@synthesize user_type;
@synthesize creation_date;
@synthesize display_name;
@synthesize reputation;     
@synthesize email_hash;     
@synthesize age;     
@synthesize last_access_date;     
@synthesize website_url;     
@synthesize location;
@synthesize about_me;     
@synthesize question_count;
@synthesize answer_count;     
@synthesize view_count;
@synthesize up_vote_count;     
@synthesize down_vote_count;
@synthesize accept_rate;
@synthesize association_id;
@synthesize user_questions_url;
@synthesize user_answers_url;     
@synthesize user_favorites_url;     
@synthesize user_tags_url;
@synthesize user_badges_url;
@synthesize user_timeline_url;
@synthesize user_mentioned_url;     
@synthesize user_comments_url;     
@synthesize user_reputation_url;
@synthesize badge_counts;     
@synthesize timed_penalty_date;

+ (CSRequestParams*)requestParamsForObjectWithIdentifier:(int)ident
{
    return [[[CSRequestParams alloc] initWithRawURL:[NSString stringWithFormat:@"/users/%i", ident] andResponseVectorKey:@"users" andType:[CSUser class]] autorelease];
}

+ (CSRequestParams*)requestParamsForUsersMatchingFilter:(NSString*)filter
{
    NSString *safeFilter = [filter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    return [[[CSRequestParams alloc] initWithRawURL:[NSString stringWithFormat:@"/users?filter=%@", safeFilter] andResponseVectorKey:@"users" andType:[CSUser class]] autorelease];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    user_type = (enum CSUserType)[decoder decodeIntForKey:@"user_type"];
    creation_date = [[decoder decodeObjectForKey:@"creation_date"] retain];
    display_name = [[decoder decodeObjectForKey:@"display_name"] retain];
    reputation = [decoder decodeIntForKey:@"reputation"];
    email_hash = [[decoder decodeObjectForKey:@"email_hash"] retain];
    age = [decoder decodeIntForKey:@"age"];
    last_access_date = [[decoder decodeObjectForKey:@"last_access_date"] retain];
    website_url = [[decoder decodeObjectForKey:@"website_url"] retain];
    location = [[decoder decodeObjectForKey:@"location"] retain];
    about_me = [[decoder decodeObjectForKey:@"about_me"] retain];
    question_count = [decoder decodeIntForKey:@"question_count"];
    answer_count = [decoder decodeIntForKey:@"answer_count"];
    view_count = [decoder decodeIntForKey:@"view_count"];
    up_vote_count = [decoder decodeIntForKey:@"up_vote_count"];
    down_vote_count = [decoder decodeIntForKey:@"down_vote_count"];
    accept_rate = [decoder decodeIntForKey:@"accept_rate"];
    association_id = [[decoder decodeObjectForKey:@"association_id"] retain];
    user_questions_url = [[decoder decodeObjectForKey:@"user_questions_url"] retain];
    user_answers_url = [[decoder decodeObjectForKey:@"user_answers_url"] retain];
    user_favorites_url = [[decoder decodeObjectForKey:@"user_favorites_url"] retain];
    user_tags_url = [[decoder decodeObjectForKey:@"user_tags_url"] retain];
    user_badges_url = [[decoder decodeObjectForKey:@"user_badges_url"] retain];
    user_timeline_url = [[decoder decodeObjectForKey:@"user_timeline_url"] retain];
    user_mentioned_url = [[decoder decodeObjectForKey:@"user_mentioned_url"] retain];
    user_comments_url = [[decoder decodeObjectForKey:@"user_comments_url"] retain];
    user_reputation_url = [[decoder decodeObjectForKey:@"user_reputation_url"] retain];
    badge_counts.gold = [decoder decodeIntForKey:@"badge_counts_gold"];
    badge_counts.silver = [decoder decodeIntForKey:@"badge_counts_silver"];
    badge_counts.bronze = [decoder decodeIntForKey:@"badge_counts_bronze"];
    timed_penalty_date = [[decoder decodeObjectForKey:@"timed_penalty_date"] retain];
    
    return self;
}

- (void)dealloc
{
    [creation_date release];
    [display_name release];
    [email_hash release];
 
    [last_access_date release];  
    [website_url release];
    [location release];
    [about_me release];

    [user_questions_url release];
    [user_answers_url release];
    [user_favorites_url release];
    [user_tags_url release];
    [user_badges_url release];
    [user_timeline_url release];
    [user_mentioned_url release];
    [user_comments_url release];
    [user_reputation_url release];
    [timed_penalty_date release];
    
    [super dealloc];
}

- (NSURL*)avatar_url
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@?s=128&d=identicon", email_hash]];
}

- (CSRequestParams*)requestParamsForTimeline
{
    return [[[CSRequestParams alloc] initWithRawURL:user_timeline_url andResponseVectorKey:@"user_timelines" andType:[CSTimelineEntry class]] autorelease];
}

- (CSRequestParams*)requestParamsForMentions
{
    return [[[CSRequestParams alloc] initWithRawURL:user_mentioned_url andResponseVectorKey:@"comments" andType:[CSComment class]] autorelease];
}

- (CSRequestParams*)requestParamsForReputationChanges
{
    return [[[CSRequestParams alloc] initWithRawURL:user_reputation_url andResponseVectorKey:@"rep_changes" andType:[CSUserReputationChange class]] autorelease];
}

- (CSRequestParams*)requestParamsForBadges
{
    return [[[CSRequestParams alloc] initWithRawURL:user_badges_url andResponseVectorKey:@"badges" andType:[CSBadge class]] autorelease];
}

- (CSRequestParams*)requestParamsForQuestions
{
    return [[[CSRequestParams alloc] initWithRawURL:user_questions_url andResponseVectorKey:@"questions" andType:[CSQuestion class]] autorelease];
}

- (CSRequestParams*)requestParamsForAnswers
{
    return [[[CSRequestParams alloc] initWithRawURL:user_answers_url andResponseVectorKey:@"answers" andType:[CSAnswer class]] autorelease];
}

- (CSRequestParams*)requestParamsForFavorites
{
    return [[[CSRequestParams alloc] initWithRawURL:user_favorites_url andResponseVectorKey:@"questions" andType:[CSAnswer class]] autorelease];
}

- (CSRequestParams*)requestParamsForTags
{
    return [[[CSRequestParams alloc] initWithRawURL:user_tags_url andResponseVectorKey:@"tags" andType:[CSAnswer class]] autorelease];
}

- (CSRequestParams*)requestParamsForComments
{
    return [[[CSRequestParams alloc] initWithRawURL:user_comments_url andResponseVectorKey:@"comments" andType:[CSAnswer class]] autorelease];
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeInt:user_type forKey:@"user_type"];
    [encoder encodeObject:creation_date forKey:@"creation_date"];
    [encoder encodeObject:display_name forKey:@"display_name"];
    [encoder encodeInt:reputation forKey:@"reputation"];
    [encoder encodeObject:email_hash forKey:@"email_hash"];
    [encoder encodeInt:age forKey:@"age"];
    [encoder encodeObject:last_access_date forKey:@"last_access_date"];
    [encoder encodeObject:website_url forKey:@"website_url"];
    [encoder encodeObject:location forKey:@"location"];
    [encoder encodeObject:about_me forKey:@"about_me"];
    [encoder encodeInt:question_count forKey:@"question_count"];
    [encoder encodeInt:answer_count forKey:@"answer_count"];
    [encoder encodeInt:view_count forKey:@"view_count"];
    [encoder encodeInt:up_vote_count forKey:@"up_vote_count"];
    [encoder encodeInt:down_vote_count forKey:@"down_vote_count"];
    [encoder encodeInt:accept_rate forKey:@"accept_rate"];
    [encoder encodeObject:association_id forKey:@"association_id"];
    [encoder encodeObject:user_questions_url forKey:@"user_questions_url"];
    [encoder encodeObject:user_answers_url forKey:@"user_answers_url"];
    [encoder encodeObject:user_favorites_url forKey:@"user_favorites_url"];
    [encoder encodeObject:user_tags_url forKey:@"user_tags_url"];
    [encoder encodeObject:user_badges_url forKey:@"user_badges_url"];
    [encoder encodeObject:user_timeline_url forKey:@"user_timeline_url"];
    [encoder encodeObject:user_mentioned_url forKey:@"user_mentioned_url"];
    [encoder encodeObject:user_comments_url forKey:@"user_comments_url"];
    [encoder encodeObject:user_reputation_url forKey:@"user_reputation_url"];
    [encoder encodeInt:badge_counts.gold forKey:@"badge_counts_gold"];
    [encoder encodeInt:badge_counts.silver forKey:@"badge_counts_silver"];
    [encoder encodeInt:badge_counts.bronze forKey:@"badge_counts_bronze"];
    [encoder encodeObject:timed_penalty_date forKey:@"timed_penalty_date"];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    /*
     user_id, Int, False
     user_type {anonymous, unregistered, registered, or moderator}, False 
     creation_date, String, False
     display_name, String, False
     reputation, Int, False
     email_hash, String, False
     age, Int, True
     last_access_date, Date, False
     website_url, String, True
     location, String, True
     about_me, String, True
     question_count, Int, False
     answer_count, Int, False
     view_count, Int, False
     up_vote_count, Int, False
     down_vote_count, Int, False
     accept_rate, int, True
     association_id, String, True
     user_questions_url, String, False
     user_answers_url, String, False
     user_favorites_url, String, False
     user_tags_url, String, False
     user_badges_url, String, False
     user_timeline_url, String, False
     user_mentioned_url, String, False
     user_comments_url, String, False
     user_reputation_url, String, False
     badge_counts, BadgeCounts, True
     timed_penalty_date, Date, True
    */
    
    if (![super updateFromJSON:json error:error])
        return FALSE;
    
    if (![json extract:@"user_id" intoInt:&identifier error:error])
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
    
    if (![json extract:@"creation_date" intoDate:&creation_date error:error])
        return FALSE;
    if (![json extract:@"display_name" intoString:&display_name error:error])
        return FALSE;
    if (![json extract:@"reputation" intoInt:&reputation error:error])
        return FALSE;
    if (![json extract:@"email_hash" intoString:&email_hash error:error])
        return FALSE;
    [json extract:@"age" intoInt:&age];
    if (![json extract:@"last_access_date" intoDate:&last_access_date error:error])
        return FALSE;
    [json extract:@"website_url" intoURL:&website_url];
    [json extract:@"location" intoString:&location];
    [json extract:@"about_me" intoString:&about_me];
    if (![json extract:@"question_count" intoInt:&question_count error:error])
        return FALSE;
    if (![json extract:@"answer_count" intoInt:&answer_count error:error])
        return FALSE;
    if (![json extract:@"view_count" intoInt:&view_count error:error])
        return FALSE;
    if (![json extract:@"up_vote_count" intoInt:&up_vote_count error:error])
        return FALSE;
    if (![json extract:@"down_vote_count" intoInt:&down_vote_count error:error])
        return FALSE;
    [json extract:@"accept_rate" intoInt:&accept_rate];
    [json extract:@"association_id" intoString:&association_id];    
    if (![json extract:@"user_questions_url" intoString:&user_questions_url error:error])
        return FALSE;
    if (![json extract:@"user_answers_url" intoString:&user_answers_url error:error])
        return FALSE;
    if (![json extract:@"user_favorites_url" intoString:&user_favorites_url error:error])
        return FALSE;
    if (![json extract:@"user_tags_url" intoString:&user_tags_url error:error])
        return FALSE;
    if (![json extract:@"user_badges_url" intoString:&user_badges_url error:error])
        return FALSE;
    if (![json extract:@"user_timeline_url" intoString:&user_timeline_url error:error])
        return FALSE;
    if (![json extract:@"user_mentioned_url" intoString:&user_mentioned_url error:error])
        return FALSE;
    if (![json extract:@"user_comments_url" intoString:&user_comments_url error:error])
        return FALSE;
    if (![json extract:@"user_reputation_url" intoString:&user_reputation_url error:error])
        return FALSE;
    NSDictionary *badgeCountsDict = nil;
    if ([json extract:@"badge_counts" intoDictionary:&badgeCountsDict])
    {
        [badgeCountsDict extract:@"gold" intoInt:&(badge_counts.gold)];
        [badgeCountsDict extract:@"silver" intoInt:&(badge_counts.silver)];
        [badgeCountsDict extract:@"bronze" intoInt:&(badge_counts.bronze)];
    }
    [badgeCountsDict release];
    [json extract:@"timed_penalty_date" intoDate:&timed_penalty_date];
    
    return TRUE;
}

@end
