/*
 
 CoreStack v1.0 : CSUser.h
 
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

#import <Foundation/Foundation.h>

#import "CSIdentifiedObject.h"

enum CSUserType
{
    CSUserTypeUnknown,    
    CSUserTypeAnonymous,
    CSUserTypeUnregistered,
    CSUserTypeRegistered,
    CSUserTypeModerator
};

typedef struct BadgeCounts
{
    int gold;
    int silver;
    int bronze;
} BadgeCounts_t;

@interface CSUser : CSIdentifiedObject {
    enum CSUserType user_type;
    NSDate *creation_date;
    NSString *display_name;
    int reputation;     
    NSString *email_hash;     
    int age;     
    NSDate *last_access_date;     
    NSURL *website_url;     
    NSString *location;
    NSString *about_me;     
    int question_count;
    int answer_count;     
    int view_count;
    int up_vote_count;     
    int down_vote_count;
    int accept_rate;
     
    NSString *association_id;
     
    NSString *user_questions_url;
    NSString *user_answers_url;     
    NSString *user_favorites_url;     
    NSString *user_tags_url;
    NSString *user_badges_url;
    NSString *user_timeline_url;
    NSString *user_mentioned_url;     
    NSString *user_comments_url;     
    NSString *user_reputation_url;
     
    struct BadgeCounts badge_counts;     
    NSDate *timed_penalty_date;
}

+ (CSRequestParams*)requestParamsForUsersMatchingFilter:(NSString*)filter;

@property (readonly) enum CSUserType user_type;
@property (readonly) NSDate *creation_date;
@property (readonly) NSString *display_name;
@property (readonly) int reputation;     
@property (readonly) NSString *email_hash;     
@property (readonly) int age;     
@property (readonly) NSDate *last_access_date;     
@property (readonly) NSURL *website_url;     
@property (readonly) NSString *location;
@property (readonly) NSString *about_me;     
@property (readonly) int question_count;
@property (readonly) int answer_count;     
@property (readonly) int view_count;
@property (readonly) int up_vote_count;     
@property (readonly) int down_vote_count;
@property (readonly) int accept_rate;

@property (readonly) NSString *association_id;

@property (readonly) NSString *user_questions_url;
@property (readonly) NSString *user_answers_url;     
@property (readonly) NSString *user_favorites_url;     
@property (readonly) NSString *user_tags_url;
@property (readonly) NSString *user_badges_url;
@property (readonly) NSString *user_timeline_url;
@property (readonly) NSString *user_mentioned_url;     
@property (readonly) NSString *user_comments_url;     
@property (readonly) NSString *user_reputation_url;

@property (readonly) struct BadgeCounts badge_counts;     
@property (readonly) NSDate *timed_penalty_date;

- (NSURL*)avatar_url;

- (CSRequestParams*)requestParamsForTimeline;
- (CSRequestParams*)requestParamsForMentions;
- (CSRequestParams*)requestParamsForReputationChanges;
- (CSRequestParams*)requestParamsForBadges;
- (CSRequestParams*)requestParamsForQuestions;
- (CSRequestParams*)requestParamsForAnswers;
- (CSRequestParams*)requestParamsForFavorites;
- (CSRequestParams*)requestParamsForTags;
- (CSRequestParams*)requestParamsForComments;

@end
