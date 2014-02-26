//
//  DataPostURL.m
//  youwa
//
//  Created by 薛 千 on 4/25/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import "DataPostURL.h"
#import "Tools.h"
#import "JSON.h"

@implementation DataPostURL
@synthesize delegate,Selector,resultList;
@synthesize mServerURL;

#pragma -mark Http Request
- (void)httpPostRequest{
    
    //请求发送到的路径
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:self.mServerURL];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"1111111111" forHTTPHeaderField:@"udid"];
    [urlRequest addValue:@"1111111111" forHTTPHeaderField:@"deviceid"];
//    [urlRequest setHTTPBody: [mPostContent dataUsingEncoding:NSUTF8StringEncoding]];

    theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

//调用成功，获得soap信息
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!receiveData) {
        receiveData= [[NSMutableData alloc] init];
    }
    [receiveData appendData:data];
} 

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (delegate) {
        //异常处理
//        [Tools ErrorMessageForDelegate:nil Title:ErrorMessage_Error
//                               Message:@"请检查网络 :("];
    }
    if (delegate && Selector) {
        [delegate performSelector:Selector withObject:nil];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    NSString *results = [[NSString alloc]initWithData:receiveData
                                             encoding:NSUTF8StringEncoding];

    // 对搜索到的结果进行解析，删除多余的HTML标签对    
    if (![results JSONValue]) {
        // 异常处理
//        [Tools ErrorMessageForDelegate:delegate Title:ErrorMessage_Error
//                               Message:@"Json 包解析出错 :("];
        if (delegate && Selector) {
            [delegate performSelector:Selector withObject:nil];
        }
    }else {
        resultList = [[NSMutableDictionary alloc] initWithDictionary:[results JSONValue]];
        if (delegate && Selector) {
            [delegate performSelector:Selector withObject:self];
        }
    }
//    [resultList release];
    
    if(results)
        [results release];
}

-(void)dealloc
{
    [self disconnect];

    if (resultList) {
        [resultList release];
        resultList = nil;
    }
    if (mFunctionKeyword) {
        [mFunctionKeyword release];
        mFunctionKeyword = nil;
    }
    [super dealloc];
}

-(id) initWithURL:(NSURL*) url
{
    self = [super init];
    if (self) {
        //
        self.mServerURL = [url copy];
        [self httpPostRequest];
    }
    return self;
}

- (void)disconnect
{
    if (receiveData) {
        [receiveData release];
        receiveData = nil;
    }
    if (theConnection) {
        [theConnection cancel];
        [theConnection release];
        theConnection = nil;
    }
}

@end

