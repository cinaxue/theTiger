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
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Action_Female@2x" ofType:@"png"];

    [ASIRequestHttpController postMethodPath:@"upload_file.php"
                                        path:path success:^(id responseObj) {
                                            NSLog(@"123");
                                        } failure:^(id responseObject) {
                                            NSLog(@"32423");
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
