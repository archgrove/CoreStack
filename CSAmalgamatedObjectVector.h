//
//  CSAmalgamatedObjectVector.h
//  SixToEight
//
//  Created by Adam Wright on 04/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CSObjectVector.h"

@protocol CSObjectVectorFilter
- (BOOL)shouldIncludeObject:(id)obj;
@end

@interface CSAmalgamatedObjectVector : NSObject<NSFastEnumeration, NSCoding> {
    NSMutableArray *allObjects;
    NSMutableArray *filteredSortedObjects;
    
    id<CSObjectVectorFilter, NSObject, NSCoding> filter;
    NSSortDescriptor *sortDescriptor;
}

@property (retain) id<CSObjectVectorFilter> filter;
@property (retain) NSSortDescriptor *sortDescriptor;

- (int)count;
- (int)unfilteredCount;
- (id)objectAtIndex:(int)index;
- (void)addObjectVector:(CSObjectVector*)vector;

- (void)filterAndSort;

@end
