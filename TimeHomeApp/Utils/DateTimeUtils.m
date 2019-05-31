//
//  DateTimeUtils.m
//  TimeHomeApp
//
//  Created by UIOS on 16/4/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "DateTimeUtils.h"
#import "DateUitls.h"
#import "XYString.h"

@implementation DateTimeUtils
+(BOOL)isfiveminutes:(NSDate *)newDate fromLastDate:(NSDate*)lastDate;
{
    if (newDate==nil||lastDate==nil) {
        NSLog(@"聊天消息时间为空");
        return NO;
    }
    float different = [newDate timeIntervalSinceDate:lastDate];
    NSLog(@"==时间间隔==%f====",different);
    if(different>300) {
        return YES;
    }else
    {
        return NO;
    }
}


+(NSString *)StringFromDateTime:(NSDate *)systime
{
    NSInteger days = [DateUitls calcDaysFromBegin:systime today:[NSDate date]];
    
    NSString * times = [XYString NSDateToString:systime withFormat:@"HH:mm"];
    NSString * riqi = [XYString NSDateToString:systime withFormat:@"yyyy-MM-dd"];
    
      if (days < 1) {
        
        return [NSString stringWithFormat:@"今天 %@",times];
    }else if(days < 2) {
        
        return [NSString stringWithFormat:@"昨天 %@",times];
        
    }else if(days < 3) {
        
        return [NSString stringWithFormat:@"前天 %@",times];
        
    }else{
        
        return [NSString stringWithFormat:@"%@ %@",riqi,times];
        
    }
    
    return @"";

}
/**
 *  消息列表页时间格式 hh：mm，昨天，前天，具体日期yyyy-mm-dd
 */
+(NSString *)StringToDateTimeWithTime:(NSString *)systime {
    NSLog(@"-----------%@",systime);
    NSString * newSystime = @"";
    if (![XYString isBlankString:systime]) {
        newSystime = [systime substringWithRange:NSMakeRange(0,19)];
    }
    
    NSLog(@"-----------2%@",[XYString  NSStringToDate:newSystime]);
    
    NSInteger days = [DateUitls calcDaysFromBegin:[XYString  NSStringToDate:newSystime] today:[NSDate date]];
    
    NSString * times = [XYString NSDateToString:[XYString  NSStringToDate:newSystime] withFormat:@"HH:mm"];

    NSString * riqi = [XYString NSDateToString:[XYString  NSStringToDate:newSystime] withFormat:@"yyyy-MM-dd"];
    
    if (days < 1) {
        
        return [NSString stringWithFormat:@"%@",times];
    }else if(days < 2) {
        
        return [NSString stringWithFormat:@"昨天"];
        
    }else if(days < 3) {
        
        return [NSString stringWithFormat:@"前天"];
        
    }else {
        
        return [NSString stringWithFormat:@"%@",riqi];
        
    }
    
    return @"";
}
/**
 *  个人通知时间格式 今天hh：mm，昨天hh：mm，前天hh：mm，具体日期yyyy-mm-dd hh：mm
 */
+(NSString *)StringToDateTime:(NSString *)systime
{
    NSLog(@"-----------%@",systime);
    NSString * newSystime = [systime substringWithRange:NSMakeRange(0,19)];
    
    NSLog(@"-----------2%@",[XYString  NSStringToDate:newSystime]);
    
    NSInteger days = [DateUitls calcDaysFromBegin:[XYString  NSStringToDate:newSystime] today:[NSDate date]];
    NSString * times = [XYString NSDateToString:[XYString  NSStringToDate:newSystime] withFormat:@"HH:mm"];
  // times = [systime substringWithRange:NSMakeRange(<#NSUInteger loc#>, <#NSUInteger len#>)]
    NSString * riqi = [XYString NSDateToString:[XYString  NSStringToDate:newSystime] withFormat:@"MM-dd"];

    if (days< 1) {
        
        return [NSString stringWithFormat:@"今天 %@",times];
    }else if(days < 2) {
        
        return [NSString stringWithFormat:@"昨天 %@",times];

    }else if(days < 3) {
        
        return [NSString stringWithFormat:@"前天 %@",times];
        
    }else{
        
        return [NSString stringWithFormat:@"%@ %@",riqi,times];
        
    }

    return @"";
}

+(NSString *)FriendsStringToDateTime:(NSString *)systime
{
    NSLog(@"-----------%@",systime);
    NSString * newSystime = [systime substringWithRange:NSMakeRange(0,19)];
    
    NSLog(@"-----------2%@",[XYString  NSStringToDate:newSystime]);
    return  [DateUitls prettyDateWithReference:[XYString  NSStringToDate:newSystime]];
    
}
@end
