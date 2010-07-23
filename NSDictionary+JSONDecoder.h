/*
 
 CoreStack v1.0 : NSDictionary+JSONDecoder.h
 
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


@interface NSDictionary (NSDictionary_JSONDecoder)

- (BOOL)extract:(NSString*)key intoInt:(int*)target;
- (BOOL)extract:(NSString*)key intoDouble:(double*)target;
- (BOOL)extract:(NSString*)key intoBool:(BOOL*)target;
- (BOOL)extract:(NSString*)key intoString:(NSString**)target;
- (BOOL)extract:(NSString*)key intoDate:(NSDate**)target;
- (BOOL)extract:(NSString*)key intoURL:(NSURL**)target;
- (BOOL)extract:(NSString*)key intoArray:(NSArray**)target;
- (BOOL)extract:(NSString*)key intoDictionary:(NSDictionary**)target;

- (BOOL)extract:(NSString*)key intoInt:(int*)target error:(NSError**)error;
- (BOOL)extract:(NSString*)key intoDouble:(double*)target error:(NSError**)error;
- (BOOL)extract:(NSString*)key intoBool:(BOOL*)target error:(NSError**)error;
- (BOOL)extract:(NSString*)key intoString:(NSString**)target error:(NSError**)error;
- (BOOL)extract:(NSString*)key intoDate:(NSDate**)target error:(NSError**)error;
- (BOOL)extract:(NSString*)key intoURL:(NSURL**)target error:(NSError**)error;
- (BOOL)extract:(NSString*)key intoArray:(NSArray**)target error:(NSError**)error;
- (BOOL)extract:(NSString*)key intoDictionary:(NSDictionary**)target error:(NSError**)error;

- (NSDictionary*)userInfoForMissingKey:(NSString*)key;

@end
