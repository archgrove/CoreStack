/*
 
 CoreStack v1.0 : CSObjectVector.h
 
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

#define CS_OBJECT_VECTOR_UNKNOWN_TOTAL -1
#define CS_OBJECT_VECTOR_UNKNOWN_PAGE -1
#define CS_OBJECT_VECTOR_UNKNOWN_PAGESIZE -1

@interface CSObjectVector : NSObject<NSFastEnumeration, NSCoding> {
    Class objectClass;
    NSString *vectorKey;
    
    NSMutableArray *contents;
    
    NSInteger total;    
    NSInteger page;    
    NSInteger pageSize;
}

@property (readonly) NSInteger page;
@property (readonly) NSInteger pageSize;
@property (readonly) NSInteger total;

- (id)initWithObjectClass:(Class)clss forVectorKey:(NSString*)key;
- (id)initWithObjectVector:(CSObjectVector*)other throughFilterObject:(id)filterObject withFilter:(SEL)filterSelector;
- (id)initAsEmpty;

- (BOOL)fillWithJSON:(id)json error:(NSError**)error;

- (id)first;
- (id)objectAtIndex:(int)index;
- (int)count;
- (void)sortUsingDescriptor:(NSSortDescriptor*)desc;
- (void)sortUsingDescriptors:(NSArray*)descs;

@end
