/*
 
 CoreStack v1.0 : CSTag.h
 
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
#import "CSUser.h"

@interface CSTag : CSObject
{
    NSString *name; // Not optional
    int count; // Not optional
    enum CSUserType restricted_to; // Optional
    BOOL fulfills_required; // Not optional
    int user_id; // Optional
}

+ (CSRequestParams*)requestParamsForAllTags;
+ (CSRequestParams*)requestParamsForTagsMatching:(NSString*)filter;

@property (readonly) NSString *name; // Not optional
@property (readonly) int count; // Not optional
@property (readonly) enum CSUserType restricted_to; // Optional
@property (readonly) BOOL fulfills_required; // Not optional
@property (readonly) int user_id; // Optional

@end
