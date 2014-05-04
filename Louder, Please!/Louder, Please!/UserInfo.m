//
//  UserInfo.m
//  Louder, Please!
//
//  Created by Cina on 5/3/14.
//  Copyright (c) 2014 Cina. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *userInfo = nil;

@implementation UserInfo
@synthesize email = _email;
@synthesize location = _location;
@synthesize mobile = _mobile;
@synthesize mobileChk = _mobileChk;
@synthesize photo = _photo;
@synthesize uid = _uid;
@synthesize userName = _userName;
@synthesize loginTime = _loginTime;
@synthesize userPassword = _userPassword;
@synthesize sex = _sex;


-(id)initWithAttributes:(id)attributes
{
    self = [super init];
    if (self)
    {
        if ([attributes isKindOfClass:[NSDictionary class]])
        {
            _email = [[attributes objectForKey:@"email"] retain];
            _location = [[attributes objectForKey:@"location"] retain];
            _mobile = [[attributes objectForKey:@"mobile"] retain];
            _mobileChk = [[attributes objectForKey:@"mobile_chk"] retain];
            _photo = [[attributes objectForKey:@"photo"] retain];
            _uid = [[attributes objectForKey:@"id"] retain];
            _userName = [[attributes objectForKey:@"username"] retain];
            _userPassword = [[attributes objectForKey:@"password"] retain];
            _sex = [[attributes objectForKey:@"sex"] retain];
//            _loginTime = [Tools currentDateAndTime];
        }
    }
    return self;
}

+(UserInfo *)setSharedUserInfo:(id)attributes
{
    if (userInfo) {
        [userInfo release];
        userInfo = nil;
    }
    userInfo = [[UserInfo alloc]initWithAttributes:attributes];
    return userInfo;
}

+(UserInfo*) sharedUserInfo
{
    if (userInfo) {
        return userInfo;
    }else if(NO) // 本地数据库读取数据
    {
        return nil;
    }else
        return nil;
}

@end
