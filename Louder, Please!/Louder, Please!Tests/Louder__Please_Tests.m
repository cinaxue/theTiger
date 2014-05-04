//
//  Louder__Please_Tests.m
//  Louder, Please!Tests
//
//  Created by Cina on 14-2-13.
//  Copyright (c) 2014年 Cina. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASIRequestHttpController.h"

@interface Louder__Please_Tests : XCTestCase

@end

@implementation Louder__Please_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

-(void)testUploadFile
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"EZAudioTest" ofType:@"caf"];

    [ASIRequestHttpController uploadPath:path userID:@"abc" method:KFunctionUpload success:^(id responseObj) {
        NSLog(@"123");
    } failure:^(id responseObject) {
        NSLog(@"32423");
    }];
}

-(void) testDateFormat
{
    NSDate *date = [NSDate date];
    NSString *stringDate = [Tools formatDate:date];
    NSDate *dateNew = [Tools dateFromString:stringDate];
    
    XCTAssertTrue([date isEqualToDate:dateNew], @"Success!");
}

-(void) testLoginUser
{
    NSDictionary *dictionry = [NSDictionary dictionaryWithObjectsAndKeys:@"cina1",@"username",@"cina1",@"password",nil];
    [ASIRequestHttpController postMethodPath:KFunctionLogin parameters:dictionry success:^(id responseObj) {
        
        [UserInfo setSharedUserInfo:[responseObj valueForKey:@"result"]];
        NSLog(@"124");
    } failure:^(id responseObject) {
        NSLog(@"ABC");
    }];
}

-(void) testRegisterUser
{
    NSDictionary *dictionry = [NSDictionary dictionaryWithObjectsAndKeys:@"cina",@"username",@"cina",@"password",@"cina@163.com",@"email",@"123123",@"date",[NSString stringWithFormat:@"%d", arc4random()%2],@"sex",nil];
    [ASIRequestHttpController postMethodPath:KFunctionRegister parameters:dictionry success:^(id responseObj) {
        NSLog(@"124");
    } failure:^(id responseObject) {
        NSLog(responseObject);
    }];
}

-(void)testNetworkSystem
{
    // 2014-05-02 07/50/58 +0000.caf
    NSDictionary *dictionry = [NSDictionary dictionaryWithObjectsAndKeys:@"cina",@"name",@"123",@"id", nil];
    [ASIRequestHttpController postMethodPath:@"postData.php" parameters:dictionry success:^(id responseObj) {
        NSLog(@"124");
    } failure:^(id responseObject) {
        NSLog(@"ABC");
    }];
}

-(void)testCheckUserDefault
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"ccccc" forKey:@"userName"];
    
    UIImage *image  = [UIImage imageNamed:@"Action_Female"];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Action_Female@2x" ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [userDefault setObject:data forKey:@"userIcon"];

    [userDefault synchronize];
    
    NSBundle *bundle = [NSBundle mainBundle];

    NSLog(@"123");
}
- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
