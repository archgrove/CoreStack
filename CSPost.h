/*
 
 CoreStack v1.0 : CSPost.h
 
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
#import "CSUserDescription.h"
#import "CSObjectVector.h"

enum CSPostType
{
    CSPostTypeUnknown,
    CSPostTypeQuestion,
    CSPostTypeAnswer
};

@interface CSPost : CSIdentifiedObject
{
    NSDate *locked_date;
    CSUserDescription *owner;
    NSDate *creation_date;
    NSDate *last_edit_date;
    NSDate *last_activity_date;
    int up_vote_count;
    int down_vote_count;
    int view_count;
    int score;
    BOOL community_owned;
    NSString *title;
    NSString *body;
    CSObjectVector *comments;
}

@property (readonly) NSDate *locked_date;
@property (readonly) CSUserDescription *owner;
@property (readonly) NSDate *creation_date;
@property (readonly) NSDate *last_edit_date;
@property (readonly) NSDate *last_activity_date;
@property (readonly) int up_vote_count;
@property (readonly) int down_vote_count;
@property (readonly) int view_count;
@property (readonly) int score;
@property (readonly) BOOL community_owned;
@property (readonly) NSString *title;
@property (readonly) NSString *body;
@property (readonly) CSObjectVector *comments;

- (enum CSPostType)post_type;

@end
