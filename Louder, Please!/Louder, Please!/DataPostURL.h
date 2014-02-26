//
//  DataPostURL.h
//  youwa
//
//  Created by 薛 千 on 4/25/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPostURL : NSObject< NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSMutableData *receiveData;
    NSMutableDictionary* resultList;
    id delegate;
    SEL Selector;
    NSString *mFunctionKeyword;
    NSURLConnection *theConnection;
}
@property (nonatomic, retain) NSURL *mServerURL;
@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) SEL Selector;
@property (nonatomic, retain) NSMutableDictionary* resultList;

-(id) initWithURL:(NSURL*) url;
-(id) initWithCity:(NSString*) City;
@end
