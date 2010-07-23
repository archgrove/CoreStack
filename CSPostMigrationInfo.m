/*
 
 CoreStack v1.0 : CSPostMigrationInfo.m
 
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

#import "CSPostMigrationInfo.h"
#import "NSDictionary+JSONDecoder.h"


@implementation CSPostMigrationInfo

@synthesize new_question_id;
@synthesize to_site;
@synthesize on_date;

+ (NSString*)identifierKey
{
    // This is never used as a vector response
    assert(false);
    return nil;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    new_question_id = [decoder decodeIntForKey:@"new_question_id"];    
    to_site = [[decoder decodeObjectForKey:@"to_site"] retain];
    on_date = [[decoder decodeObjectForKey:@"on_date"] retain];
    
    return self;
}

- (void)dealloc
{
    [to_site release];    
    [on_date release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeInt:new_question_id forKey:@"new_question_id"];    
    [encoder encodeObject:to_site forKey:@"to_site"];
    [encoder encodeObject:on_date forKey:@"on_date"];
}

- (BOOL)updateFromJSON:(id)json error:(NSError**)error
{
    if (![super updateFromJSON:json error:error])
        return FALSE;
    
    if (![json extract:@"new_question_id" intoInt:&new_question_id error:error])
        return FALSE;
    if (![json extract:@"on_date" intoDate:&on_date error:error])
        return FALSE;
    

    [to_site release];
    to_site = [[CSSiteDescriptor alloc] init];
    if (![to_site updateFromJSON:[json objectForKey:@"to_site"] error:error])
          return FALSE;
    
    return TRUE;
}

@end
