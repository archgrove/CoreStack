/*
 
 CoreStack v1.0 : CSRequestParams.h
 
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


@interface CSRequestParams : NSObject<NSCoding> {
    NSString *rawURL;
    NSString *urlFragment;
    int pageSize;
    int pageNumber;
    NSMutableDictionary *params;
    NSString *responseVectorKey;
    Class responseType;
}

@property int pageSize;
@property int pageNumber;
@property (readonly) NSString *responseVectorKey;
@property (readonly) Class responseType;

- (id)initWithRawURL:(NSString*)url andResponseVectorKey:(NSString*)respVectKey andType:(Class)type;
- (id)initWithURLFragment:(NSString*)fragment andResponseVectorKey:(NSString*)respVectKey andType:(Class)type;

- (void)setParam:(NSString*)param toValue:(NSString*)value;
- (NSString*)toRequestURL;

@end
