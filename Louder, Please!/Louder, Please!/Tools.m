//
//  Tools.m
//  youwa
//
//  Created by 薛 千 on 4/18/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import "Tools.h"
#import "Constants.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <sys/xattr.h>
#import <AVFoundation/AVFoundation.h>

static Tools *sharedTools;

@implementation Tools

@synthesize selector;
@synthesize fullLists;

-(id) init
{
    self = [super init];
    if (self) {
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

        // 从本地获取超市中的定制包 以及  本地用户的定制包
        NSString *path = [docPath stringByAppendingFormat:@"/History.plist"];
        // create words.plist if the local words plist does not exist
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"History" ofType:@"plist"];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:defaultPath]) {
                [[NSFileManager defaultManager] copyItemAtPath:defaultPath toPath:path error:nil];
                [Tools addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:docPath]];
                [Tools addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:path]];
            }else {
                [Tools showAlert:@"APP内的初始化列表没有找到！"];
            }
        }
        
        fullLists = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
//        NSDictionary *aDic = [NSDictionary dictionaryWithContentsOfFile:path];
//        mBackgroundImagePath = [[aDic objectForKey:@"BackgroundStyle"] intValue];
    }
    return self;
}

+(NSDate*) dateFromString:(NSString *) stringDate
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH'-'mm'-'ss'"];
    [formatter setLenient:YES];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate *date = [formatter dateFromString:stringDate];
    
    return date;
}

+(NSString *) formatDate:(NSDate*) date
{
    if (date==nil) {
        return nil;
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:date];
    NSString *theTimeStamp = [NSString stringWithFormat:@"%d-%d-%d %d-%d-%d", [components year], [components month], [components day], [components hour], [components minute], [components second]];
    return theTimeStamp;
}

+ (id)getJsonData:(id)obj
{
    NSError *error = nil;
    return [NSJSONSerialization JSONObjectWithData:obj options:noErr error:&error];
}

+(void)addPowerToHistoryAVAudioRecorder:(AVAudioRecorder *)audioRecorder Date:(NSDate *)date
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingFormat:@"/History.plist"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSNumber numberWithFloat:[audioRecorder averagePowerForChannel:0]] forKey:KAveragePower];
    [dic setValue:[NSNumber numberWithFloat:[audioRecorder peakPowerForChannel:0]] forKey:KPeakPower];
    
    [dic setValue:[Tools formatDate:date] forKey:@"date"];
    [dic setValue:audioRecorder.url.path forKey:@"path"];
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioRecorder.url error:Nil];
    NSLog(@"测试打印，录音总时间%f",audioPlayer.duration);
    
    if (audioPlayer.duration>4 && audioPlayer.duration<6) {
        [[[Tools sharedTools].fullLists objectForKey:KTimeLevel_4_6] addObject:dic];
    }else if(audioPlayer.duration>6 && audioPlayer.duration<8){
        [[[Tools sharedTools].fullLists objectForKey:KTimeLevel_6_8] addObject:dic];
    }else if(audioPlayer.duration>8 && audioPlayer.duration<10){
        [[[Tools sharedTools].fullLists objectForKey:KTimeLevel_8_10] addObject:dic];
    }else if(audioPlayer.duration>10){
        [[[Tools sharedTools].fullLists objectForKey:KTimeLevel_10_max] addObject:dic];
    }
    
    [[Tools sharedTools].fullLists writeToFile:path atomically:YES];
}


+(void) playNextSound
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"msgtoolong" ofType:@"wav"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:fileName];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [audioPlayer play];
}

+ (Tools *)sharedTools
{
    if (sharedTools) {
        return sharedTools;
    }else
    {
        sharedTools = [[Tools alloc] init];
        return sharedTools;
    }
}

+ (void) showAlert:(NSString*) aLog
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" 
                                                    message:aLog
                                                   delegate:nil 
                                          cancelButtonTitle:@"YES" 
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

+(NSString *)getDocumentFilePath{
	NSArray  *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [pathArray objectAtIndex:0];
	return documentPath;
}

+(NSString*) WeekOfDay: (NSInteger) weekOfDay
{
    switch (weekOfDay) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}
@end
