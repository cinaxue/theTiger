//
//  Tools.h
//  youwa
//
//  Created by 薛 千 on 4/18/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"
#import <AVFoundation/AVFoundation.h>

@interface Tools : NSObject 
{
    NSInteger mBackgroundImagePath;
}

@property(nonatomic,retain) NSMutableDictionary *fullLists;
@property(nonatomic, assign) SEL selector;

+(NSDate*) dateFromString:(NSString *) stringDate;
+(NSString *) formatDate:(NSDate*) date;
+(void) addPowerToHistoryAVAudioRecorder:(AVAudioRecorder*) audioRecorder Date:(NSDate*) date;
+ (id)getJsonData:(id)obj;
+(NSString *)getDocumentFilePath;
+ (Tools*) sharedTools;
+ (void) playNextSound;
+ (void) showAlert:(NSString*) aLog;
@end
