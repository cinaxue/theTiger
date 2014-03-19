//
//  DownOrUpload.m
//  YouCai
//
//  Created by Cina on 10/26/12.
//  Copyright (c) 2012 Cina. All rights reserved.
//

#import "UploadData.h"
#import "Tools.h"
#import "Constants.h"
#import "JSON.h"

@implementation UploadData
@synthesize delegate,Selector,resultList;
@synthesize mMimaString,mDownloadFileName;

- (void)httpPostRequest{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/upload_audio_file.php",KServerAddress]];

    //请求发送到的路径
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    NSFileHandle* handler = [NSFileHandle fileHandleForReadingAtPath:self.mMimaString.url.path];

    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"/zip" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"%d",[[NSData dataWithContentsOfURL:self.mMimaString.url] length]] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    [urlRequest setHTTPBody:[NSData dataWithContentsOfURL:self.mMimaString.url]];
    
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
        
        [Tools showAlert:@"请检查网络 :("];
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
        [Tools showAlert:@"请检查网络 :("];
        if (delegate && Selector) {
            [delegate performSelector:Selector withObject:nil];
        }
    }else {
        resultList = [[NSMutableDictionary alloc] initWithDictionary:[results JSONValue]];
        if (delegate && Selector) {
            [delegate performSelector:Selector withObject:self];
        }
    }
    
    if(results)
        [results release];
}

-(id)initWithUploadMima:(AVAudioRecorder*) MimaString
{
    self = [super init];
    if (self) {
        self.mMimaString = MimaString;
        [self httpPostRequest];
    }
    return self;
}

-(id)initWithDownloadFileName:(NSString *)FileName
{
    self = [super init];
    if (self) {
        self.mDownloadFileName =[FileName copy];
        [self httpPostRequest];
    }
    return self;
}

-(void)dealloc
{
    [self disconnect];
    
    if (mDownloadFileName) {
        [mDownloadFileName release];
        mDownloadFileName = nil;
    }
    if (resultList) {
        [resultList release];
        resultList = nil;
    }
    [super dealloc];
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
