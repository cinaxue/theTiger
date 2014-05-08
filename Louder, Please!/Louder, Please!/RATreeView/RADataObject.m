//
//  RADataObject.m
//  RATreeView
//
//  Created by Bill on 5/7/14.
//  Copyright (c) 2014 Bill. All rights reserved.
//

#import "RADataObject.h"

@implementation RADataObject

- (id)initWithName:(NSString *)name children:(NSArray *)children
{
    self = [super init];
    if (self) {
        self.children = children;
        self.name = name;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children
{
    return [[self alloc] initWithName:name children:children];
}

@end
