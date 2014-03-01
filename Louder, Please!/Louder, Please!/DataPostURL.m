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
    
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&email=%@&date=%@&sex=%@",[NSString stringWithFormat:@"testname%d", arc4random()%100],@"testname",@"testname@163.com",@"",[NSString stringWithFormat:@"%d", arc4random()%2]];
    NSLog(@"post:%@",post);

    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSLog(@"postLength=%@",postLength);
    //定义NSMutableURLRequest

    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPBody:postData];

//    [urlRequest addValue:[NSString stringWithFormat:@"testname%d", arc4random()%100] forHTTPHeaderField:@"username"];
//    [urlRequest addValue:@"testname" forHTTPHeaderField:@"password"];
//    [urlRequest addValue:@"testname@163.com" forHTTPHeaderField:@"email"];
//    [urlRequest addValue:@"" forHTTPHeaderField:@"date"];
//    [urlRequest addValue:[NSString stringWithFormat:@"%d", arc4random()%2] forHTTPHeaderField:@"sex"];
//    [urlRequest addValue:@"1111111111" forHTTPHeaderField:@"deviceid"];
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

