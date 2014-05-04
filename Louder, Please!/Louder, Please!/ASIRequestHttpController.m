//
//  ASIRequestHttpController.m
//  LenovoProject
//
//  Created by Cina on 4/30/14.
//  Copyright (c) 2014 Lenovo. All rights reserved.
//

#import "ASIRequestHttpController.h"
#import "ASIFormDataRequest.h"

@implementation ASIRequestHttpController

+ (void)postMethodPath:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void(^)(id responseObj))success failure:(void(^)(id responseObject))failure
{
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[KServerAddress stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
    //
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myRequest.URL];
    for (NSString *key in parameters.allKeys) {
        [request setPostValue:[parameters valueForKey:key] forKey:key];
    }
    
    [request setTimeOutSeconds:5];
    [request startSynchronous];
    
    if ([request error]) {
        NSLog(@"ASI Request Error: %@",[request error]);
        failure([request error]);
	} else if ([request responseData])
    {
        NSLog(@"ASI Request Sucess: %@",[request responseString]);
        UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
        if (image)
        {
            success(image);
        }else
        {
            id response =[Tools getJsonData:[request responseData]];
            if (!response) {
                failure([request responseString]);
            }else
            {
                if ([response isKindOfClass:[NSDictionary class]]) {
                    if ([[response valueForKey:@"success"] intValue] == 0) {
                        failure(response);
                    }else
                        success(response);
                }else
                    success([Tools getJsonData:[request responseData]]);
            }
        }
    }
}

+(void)registerUserId:(NSString *)userID password:(NSString *)password success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&email=%@&date=%@&sex=%@",[NSString stringWithFormat:@"testname%d", arc4random()%100],@"testname",@"testname@163.com",@"",[NSString stringWithFormat:@"%d", arc4random()%2]];

//    NSDictionary *dictionry = [NSDictionary dictionaryWithObjectsAndKeys:@"cina",@"username",@"123",@"id", nil];

}
+(void)uploadPath:(NSString *)path userID:(NSString *)userID method:(NSString *)method success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[KServerAddress stringByAppendingString:method] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myRequest.URL];
    [request setFile:path
              forKey:@"file"];
    [request setPostValue:userID forKey:@"id"];
    [request setTimeOutSeconds:5];
    [request startSynchronous];
    
    if ([request error]) {
        NSLog(@"ASI Request Error: %@",[request error]);
        failure([request error]);
	} else if ([request responseData])
    {
        NSLog(@"ASI Request Sucess: %@",[request responseString]);
        UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
        if (image)
        {
            success(image);
        }
        
        id response =[Tools getJsonData:[request responseData]];
        if ([response isKindOfClass:[NSDictionary class]]) {
            if ([[response valueForKey:@"success"] intValue] == 0) {
                failure(response);
            }else
                success(response);
        }else
            success([Tools getJsonData:[request responseData]]);
    }
}

+(void)postMethodPath:(NSString *)urlString path:(NSString *)path success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[KServerAddress stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
    
    //
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myRequest.URL];
//    [request setPostValue: @"MyName" forKey: @"name"];
    [request setFile:path
                  forKey:@"file"];
    [request setPostValue:@"123123" forKey:@"id"];

    [request setTimeOutSeconds:5];
    [request startSynchronous];
    
    if ([request error]) {
        NSLog(@"ASI Request Error: %@",[request error]);
        failure([request error]);
	} else if ([request responseData])
    {
        NSLog(@"ASI Request Sucess: %@",[request responseString]);
        UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
        if (image)
        {
            success(image);
        }
        
        id response =[Tools getJsonData:[request responseData]];
        if ([response isKindOfClass:[NSDictionary class]]) {
            if ([[response valueForKey:@"success"] intValue] == 0) {
                failure(response);
            }else
                success(response);
        }else
            success([Tools getJsonData:[request responseData]]);
    }
}
@end
