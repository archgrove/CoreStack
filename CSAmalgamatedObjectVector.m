//
//  CSAmalgamatedObjectVector.m
//  SixToEight
//
//  Created by Adam Wright on 04/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CSAmalgamatedObjectVector.h"


@implementation CSAmalgamatedObjectVector

@synthesize filter;
@synthesize sortDescriptor;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        allObjects = [[NSMutableArray array] retain];
        filter = nil;
        sortDescriptor = nil;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        allObjects = [[aDecoder decodeObjectForKey:@"allObjects"] retain];
        filter = [[aDecoder decodeObjectForKey:@"filter"] retain];
        sortDescriptor = [[aDecoder decodeObjectForKey:@"sortDescriptor"] retain];
        
        [self filterAndSort];
    }
    
    return self;
}

- (void)dealloc
{
    [allObjects release];
    [filter release];
    [sortDescriptor release];    
    [filteredSortedObjects release];
    
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:allObjects forKey:@"allObjects"];
    [aCoder encodeObject:filter forKey:@"filter"];
    [aCoder encodeObject:sortDescriptor forKey:@"sortDescriptor"];
}

- (id)objectAtIndex:(int)index
{
    return [filteredSortedObjects objectAtIndex:index];
}

- (int)count
{
    return [filteredSortedObjects count];
}

- (int)unfilteredCount
{
    return [allObjects count];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len
{
    return [filteredSortedObjects countByEnumeratingWithState:state objects:stackbuf count:len];
}

- (void)addObjectVector:(CSObjectVector*)vector
{
    for (id obj in vector)
        [allObjects addObject:obj];
    
    [self filterAndSort];
}

- (void)filterAndSort
{
    [filteredSortedObjects release];
    
    if (filter)
    {
        filteredSortedObjects = [[NSMutableArray arrayWithCapacity:[allObjects count]] retain];
        
        for (id obj in allObjects)
        {
            if ([filter shouldIncludeObject:obj])
                [filteredSortedObjects addObject:obj];
        }
    }
    else
    {
        filteredSortedObjects = [[NSMutableArray arrayWithArray:allObjects] retain];
    }
    
    if (sortDescriptor)
        [filteredSortedObjects sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

@end
