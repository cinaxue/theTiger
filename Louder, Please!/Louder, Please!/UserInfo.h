//
//  UserInfo.h
//  Louder, Please!
//
//  Created by Cina on 5/3/14.
//  Copyright (c) 2014 Cina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, copy)NSString *email;
@property (nonatomic, copy)NSString *location;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *mobileChk;
@property (nonatomic, copy)NSString *photo;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *loginTime;
@property (nonatomic, copy)NSString *userPassword;
@property (nonatomic, copy)NSString *sex;

- (id)initWithAttributes:(id)attributes;
+(UserInfo*) setSharedUserInfo:(id) attributes;
+(UserInfo*) sharedUserInfo;

@end
