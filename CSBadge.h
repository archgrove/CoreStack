/*
 
 CoreStack v1.0 : CSBadge.h
 
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

#import "CSObject.h"
#import "CSUserDescription.h"

enum CSBadgeRank
{
    CSBadgeRankGold,
    CSBadgeRankSilver,
    CSBadgeRankBronze,
    CSBadgeRankUnknown
};

@interface CSBadge : CSIdentifiedObject
{
    enum CSBadgeRank rank; // Not optional
    NSString *name; // Not optional
    NSString *description; // Not optional
    int award_count; // Not optional
    BOOL tag_based; // Not optional
    CSUserDescription *user; // Not optional
    NSString *badges_recipients_url; // Not optional
}

@property (readonly) enum CSBadgeRank rank;
@property (readonly) NSString *name;
@property (readonly) NSString *description;
@property (readonly) int award_count;
@property (readonly) BOOL tag_based;
@property (readonly) CSUserDescription *user;
@property (readonly) NSString *badges_recipients_url;

@end
