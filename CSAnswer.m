/*
 
 CoreStack v1.0 : CSAnswer.m
 
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

#import "CSAnswer.h"
#import "CSComment.h"

@implementation CSAnswer

@synthesize accepted;
@synthesize question_id;
@synthesize answer_comments_url;

+ (CSRequestParams*)requestParamsForObjectWithIdentifier:(int)ident
{
    return [[[CSRequestParams alloc] initWithRawURL:[NSString stringWithFormat:@"/answers/%i", ident] andResponseVectorKey:@"answers" andType:[CSAnswer class]] autorelease];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    accepted = [decoder decodeBoolForKey:@"accepted"];
    question_id = [decoder decodeIntForKey:@"question_id"];
    answer_comments_url = [[decoder decodeObjectForKey:@"answer_comments_url"] retain];
    
    return self;
}

- (void)dealloc
{
    [answer_comments_url release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeBool:accepted forKey:@"accepted"];
    [encoder encodeInt:question_id forKey:@"question_id"];
    [encoder encodeObject:answer_comments_url forKey:@"answer_comments_url"];    
}

- (CSRequestParams*)requestParamsForComments
{
    return [[[CSRequestParams alloc] initWithRawURL:answer_comments_url andResponseVectorKey:@"comments" andType:[CSComment class]] autorelease];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    /*
     answer_id              Int     False
     question_id              Int     False
     accepted               Bool    False 
     answer_comments_url    String  False
     */
    
    if (![json extract:@"answer_id" intoInt:&identifier error:error])
        return FALSE;
    
    if (![super updateFromJSON:json error:error])
        return FALSE;
    
    if (![json extract:@"accepted" intoBool:&accepted error:error])
        return FALSE;
    if (![json extract:@"question_id" intoInt:&question_id error:error])
        return FALSE;
    if (![json extract:@"answer_comments_url" intoURL:&answer_comments_url error:error])
        return FALSE;
    
    return TRUE;
}

@end
