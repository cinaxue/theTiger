//
//  Constants.h
//  XMLTest
//
//  Created by Xue Cina on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
enum {
    ScareDay=0,
    ScareWeek=1,
    ScareMonth=3,
    Scare3Month=4,
    Scare6Month=5,
    ScareYear=6,
    ScareAll=7,
};
typedef NSUInteger  ScrollType;

#define KAveragePower @"averagePower"
#define KPeakPower @"peakPower"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define KMIME_FORM_BOUNDARY @"----WebKitFormBoundary9axPyVn03lJVA0W1" // MIME FORM BOUNDARY

#define KTimeLevel_4_6 @"Second4_6"
#define KTimeLevel_6_8 @"Second6_8"
#define KTimeLevel_8_10 @"Second8_10"
#define KTimeLevel_10_max @"Second10_max"

#define KServerAddress @"http://172.16.40.237/louderplease"           // regular server

#define KAlertPowerRange_160_150 @"你确定是在用嘴发声么！！！"
#define KAlertPowerRange_150_120 @"你TMD的有病吧，这里是比谁嘶吼声大又不是比小！"
#define KAlertPowerRange_120_90 @"说悄悄话呢吧！大声点，老板没在"
#define KAlertPowerRange_90_60 @"知道为什么跟你分手么，因为你小"
#define KAlertPowerRange_60_30 @"大大大，再大，再大，再大点..."
#define KAlertPowerRange_30_10 @"有点意思，加油，使劲，嗯~嗯~嗯~"
#define KAlertPowerRange_10_5 @"还不错，但是这是你的极限么？我觉得不是！"
#define KAlertPowerRange_5_0 @"你对工作满意么？你对老婆满意么？发现吧，就用这样的声音！"
#define KAlertPowerRange_0 @"你，神一样的嗓子！"

