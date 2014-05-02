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
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[KServerAddressTest stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
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
            success([Tools getJsonData:[request responseData]]);
    }
}

+(void)postMethodPath:(NSString *)urlString path:(NSString *)path success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[KServerAddressTest stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
    
    //
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myRequest.URL];
//    [request setPostValue: @"MyName" forKey: @"name"];
    [request setFile:path
                  forKey:@"file"];

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
            success([Tools getJsonData:[request responseData]]);
    }
}
@end
