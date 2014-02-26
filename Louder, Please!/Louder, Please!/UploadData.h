//
//  DownOrUpload.h
//  YouCai
//
//  Created by Cina on 10/26/12.
//  Copyright (c) 2012 Cina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadData : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSMutableData *receiveData;
    NSMutableDictionary* resultList;
    id delegate;
    SEL Selector;
    NSURLConnection *theConnection;
}

@property (nonatomic, retain) NSMutableData *mMimaString;
@property (nonatomic, retain) NSString *mDownloadFileName;

@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) SEL Selector;
@property (nonatomic, retain) NSMutableDictionary* resultList;

-(id) initWithUploadMima:(NSMutableData*) MimaString;
-(id) initWithDownloadFileName:(NSString*) FileName;

@end
