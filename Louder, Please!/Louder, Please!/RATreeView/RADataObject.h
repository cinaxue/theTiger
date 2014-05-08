//
//  RADataObject.h
//  RATreeView
//
//  Created by Bill on 5/7/14.
//  Copyright (c) 2014 Bill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RADataObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *children;


- (id)initWithName:(NSString *)name children:(NSArray *)array;

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children;

@end
