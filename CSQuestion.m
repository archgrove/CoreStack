/*
 
 CoreStack v1.0 : CSQuestion.m
 
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

#import "CSObjectVector.h"
#import "CSQuestion.h"
#import "CSAnswer.h"
#import "CSComment.h"
#import "CSTimelineEntry.h"

@implementation CSQuestion

@synthesize tags;
@synthesize answer_count;
@synthesize answers;
@synthesize accepted_answer_id;
@synthesize favorite_count;
@synthesize bounty_closes_date;
@synthesize bounty_amount;
@synthesize closed_date;
@synthesize closed_reason;
@synthesize protected_date;
@synthesize migrated;
@synthesize question_timeline_url;
@synthesize question_comments_url;
@synthesize question_answers_url;

+ (CSRequestParams*)requestParamsForObjectsWithIdentifiers:(NSArray*)identifiers
{
    NSMutableString *urlString = [NSMutableString stringWithString:@"/questions/"];
    
    BOOL first = YES;
    for (NSNumber *numb in identifiers)
    {
        if (first)
        {
            [urlString appendFormat:@"%i", [numb intValue]];
            first = NO;
        }
        else
        {
            [urlString appendFormat:@";%i", [numb intValue]];
        }
    }
         
    return [[[CSRequestParams alloc] initWithRawURL:urlString andResponseVectorKey:@"questions" andType:[CSQuestion class]] autorelease];
}

+ (CSRequestParams*)requestParamsForObjectWithIdentifier:(int)ident
{
    return [[[CSRequestParams alloc] initWithRawURL:[NSString stringWithFormat:@"/questions/%i", ident] andResponseVectorKey:@"questions" andType:[CSQuestion class]] autorelease];
}

+ (CSRequestParams*)requestParamsForUserFavorites:(int)userID
{
    return [[[CSRequestParams alloc] initWithRawURL:[NSString stringWithFormat:@"/users/%i/favorites", userID] andResponseVectorKey:@"questions" andType:[CSQuestion class]] autorelease];
}

+ (CSRequestParams*)requestParamsForQuestionsWithSortOrder:(enum CSQuestionSortOrder)sortOrder
{
    NSString *sortString;
    
    switch (sortOrder)
    {
        case CSQuestionSortByActivity:
            sortString = @"activity";
            break;
        case CSQuestionSortByVotes:
            sortString = @"votes";
            break;
        case CSQuestionSortByCreation:
            sortString = @"creation";
            break;
        case CSQuestionSortByFeatured:
            sortString = @"featured";
            break;
        case CSQuestionSortByHot:
            sortString = @"hot";
            break;
        case CSQuestionSortByWeek:
            sortString = @"week";
            break;
        case CSQuestionSortByMonth:
            sortString = @"month";
            break;
        default:
            assert(false);
    }
    
    CSRequestParams *reqParams = [[[CSRequestParams alloc] initWithURLFragment:@"/questions" andResponseVectorKey:@"questions" andType:[CSQuestion class]] autorelease];
    
    [reqParams setParam:@"sort" toValue:sortString];
    
    return reqParams;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    tags = [[decoder decodeObjectForKey:@"tags"] retain];
    answer_count = [decoder decodeIntForKey:@"answer_count"];
    answers = [[decoder decodeObjectForKey:@"answers"] retain];
    accepted_answer_id = [decoder decodeIntForKey:@"accepted_answer_id"];
    favorite_count = [decoder decodeIntForKey:@"favorite_count"];
    bounty_closes_date = [[decoder decodeObjectForKey:@"bounty_closes_date"] retain];
    bounty_amount = [decoder decodeIntForKey:@"bounty_amount"];
    closed_date = [[decoder decodeObjectForKey:@"closed_date"] retain];
    closed_reason = [[decoder decodeObjectForKey:@"closed_reason"] retain];
    protected_date = [[decoder decodeObjectForKey:@"protected_date"] retain];
    migrated = [[decoder decodeObjectForKey:@"migrated"] retain];
    question_timeline_url = [[decoder decodeObjectForKey:@"question_timeline_url"] retain];
    question_comments_url = [[decoder decodeObjectForKey:@"question_comments_url"] retain];
    question_answers_url = [[decoder decodeObjectForKey:@"question_answers_url"] retain];
    
    return self;
}

- (void)dealloc
{
    [tags release];
    [answers release];
    [bounty_closes_date release];
    [closed_date release];
    [closed_reason release];
    [protected_date release];
    [migrated release];
    [question_timeline_url release];
    [question_comments_url release];
    [question_answers_url release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:tags forKey:@"tags"];
    [encoder encodeInt:answer_count forKey:@"answer_count"];
    [encoder encodeObject:answers forKey:@"answers"];
    [encoder encodeInt:accepted_answer_id forKey:@"accepted_answer_id"];
    [encoder encodeInt:favorite_count forKey:@"favorite_count"];
    [encoder encodeObject:bounty_closes_date forKey:@"bounty_closes_date"];
    [encoder encodeInt:bounty_amount forKey:@"bounty_amount"];
    [encoder encodeObject:closed_date forKey:@"closed_date"];
    [encoder encodeObject:closed_reason forKey:@"closed_reason"];
    [encoder encodeObject:protected_date forKey:@"protected_date"];
    [encoder encodeObject:migrated forKey:@"migrated"];
    [encoder encodeObject:question_timeline_url forKey:@"question_timeline_url"];
    [encoder encodeObject:question_comments_url forKey:@"question_comments_url"];
    [encoder encodeObject:question_answers_url forKey:@"question_answers_url"];
}

- (CSRequestParams*)requestParamsForAnswers
{
    return [[[CSRequestParams alloc] initWithRawURL:question_answers_url andResponseVectorKey:@"answers" andType:[CSAnswer class]] autorelease];
}

- (CSRequestParams*)requestParamsForComments
{
    return [[[CSRequestParams alloc] initWithRawURL:question_comments_url andResponseVectorKey:@"comments" andType:[CSComment class]] autorelease];
}

- (CSRequestParams*)requestParamsForTimeline
{    
    return [[[CSRequestParams alloc] initWithRawURL:question_timeline_url andResponseVectorKey:@"post_timelines" andType:[CSTimelineEntry class]] autorelease];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    /*
     tags                   [{value: String}]   False
     answer_count           Int                 False
     answers                Answer              True
     accepted_answer_id     Int                 True
     favorite_count         Int                 False
     bounty_closes_date     Date                True
     bounty_amount          Int                 True
     closed_date            Date                True
     closed_reason          String              True
     protected_date         Date                True
     migrated               MigrationData       True
     question_timeline_url  URL                 False
     question_comments_url  URL                 False
     question_answers_url   URL                 False
     
     */
    
    if (![json extract:@"question_id" intoInt:&identifier error:error])
        return FALSE;
    
    if (![super updateFromJSON:json error:error])
        return FALSE;
    
    if (![json extract:@"tags" intoArray:&tags error:error])
        return FALSE;
    
    if ([json objectForKey:@"answers"])
    {
        [answers release];

        answers = [[[CSObjectVector alloc] initWithObjectClass:[CSAnswer class] forVectorKey:@"answers"] autorelease];        
        if (![answers fillWithJSON:json error:error])
            return FALSE;
    }
    else
    {
        [answers release];
        answers = nil;
    }
    
    if (![json extract:@"answer_count" intoInt:&answer_count error:error])
        return FALSE;
    [json extract:@"accepted_answer_id" intoInt:&accepted_answer_id];
    if (![json extract:@"favorite_count" intoInt:&favorite_count error:error])
        return FALSE;
    [json extract:@"bounty_closes_date" intoDate:&bounty_closes_date];
    [json extract:@"bounty_amount" intoInt:&bounty_amount];
    [json extract:@"closed_date" intoDate:&closed_date];
    [json extract:@"closed_reason" intoString:&closed_reason];
    [json extract:@"protected_date" intoDate:&protected_date];
    
    if ([json objectForKey:@"migrated"] != nil)
    {
        [migrated release];
        
        migrated = [[CSPostMigrationInfo alloc] init];
        if (![migrated updateFromJSON:[json objectForKey:@"migrated"] error:error])
            return FALSE;
    }
    else
    {
        [migrated release];
        migrated = nil;
    }

    if (![json extract:@"question_timeline_url" intoString:&question_timeline_url error:error])
        return FALSE;
    if (![json extract:@"question_comments_url" intoString:&question_comments_url error:error])
        return FALSE;
    if (![json extract:@"question_answers_url" intoString:&question_answers_url error:error])
        return FALSE;
    
    return TRUE;
}

@end
