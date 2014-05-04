//
//  ASIRequestHttpController.h
//  LenovoProject
//
//  Created by Cina on 4/30/14.
//  Copyright (c) 2014 Lenovo. All rights reserved.
//

typedef void (^successBlock)(id responseObj);

typedef void (^failureBlock)(id responseObj);

#import <Foundation/Foundation.h>

@interface ASIRequestHttpController : NSObject
{
    successBlock responseSuccess;
    failureBlock responseFailur;
}

//通用Post Method
+ (void)postMethodPath:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void(^)(id responseObj))success failure:(void(^)(id responseObject))failure;

+ (void) registerUserId:(NSString *)userID password:(NSString *)password success:(void(^)(id responseObj))success failure:(void(^)(id responseObject))failure;


// 上传音频
+ (void)uploadPath:(NSString*) path userID:(NSString*) userID method:(NSString *)method success:(void(^)(id responseObj))success failure:(void(^)(id responseObject))failure;


@end
