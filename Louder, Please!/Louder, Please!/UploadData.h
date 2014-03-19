//
//  DownOrUpload.h
//  YouCai
//
//  Created by Cina on 10/26/12.
//  Copyright (c) 2012 Cina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface UploadData : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSMutableData *receiveData;
    NSMutableDictionary* resultList;
    id delegate;
    SEL Selector;
    NSURLConnection *theConnection;
}

@property (nonatomic, retain) AVAudioRecorder *mMimaString;
@property (nonatomic, retain) NSString *mDownloadFileName;

@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) SEL Selector;
@property (nonatomic, retain) NSMutableDictionary* resultList;

-(id) initWithUploadMima:(AVAudioRecorder*) MimaString;
-(id) initWithDownloadFileName:(NSString*) FileName;

@end
