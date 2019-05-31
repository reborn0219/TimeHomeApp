//
//  DateUitls.m
//  QYgaosu
//
//  Created by us on 15/7/24.
//  Copyright © 2015年 uskj. All rights reserved.
//

#import "DateUitls.h"

@implementation DateUitls


//计算两个日期之间的天数
+(NSInteger) calcDaysFromBegin:(NSDate *)inBegin today:(NSDate *)today
{
    NSInteger unitFlags = NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:inBegin];
    NSDate *newBegin  = [cal dateFromComponents:comps];
    
    
    NSCalendar *cal2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps2 = [cal2 components:unitFlags fromDate:today];
    NSDate *newtoday = [cal2 dateFromComponents:comps2];
    
    
    NSTimeInterval interval = [newtoday timeIntervalSinceDate:newBegin];
    NSInteger beginDays=((NSInteger)interval)/(3600*24);
    
    //    NSLog(@"-----days:%ld", (long)beginDays);
    return beginDays;
}

//计算两个日期之间的天数
+(NSInteger) calcDaysFromBeginForString:(NSString *)inBegin today:(NSString *)end
{
    NSDate * startDate=[self DateFromString:inBegin DateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * endDate=[self DateFromString:end DateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger beginDays=[self calcDaysFromBegin:startDate today:endDate];
    return beginDays;
}

//获取今天日期+星期
+(NSString *) getTodayWeekDate
{
    NSMutableString * tdatestr=[[NSMutableString alloc]init];
    //获取日期
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    [tdatestr appendFormat:@"%ld年%ld月%ld日 %@",(long)year,(long)month,(long)day,[arrWeek objectAtIndex:week-1]];
    //    NSLog(@"date====:%@",tdatestr);
    return tdatestr;
}
//获取日期中的天
+(NSString *)getDayForDate:(NSString *)date
{
    NSDate *ndate =[self DateFromString:date DateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:ndate];
    NSInteger day = [comps day];
    
    return [NSString stringWithFormat:@"%ld",(long)day];
}
//获取日期中的月
+(NSString *)getMonthForDate:(NSString *)date
{
    NSDate *ndate =[self DateFromString:date DateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:ndate];
    NSInteger month = [comps month];
    NSString *m;
    switch (month) {
        case 1:
            m=@"一月";
            break;
        case 2:
            m=@"二月";
            break;
        case 3:
            m=@"三月";
            break;
        case 4:
            m=@"四月";
            break;
        case 5:
            m=@"五月";
            break;
        case 6:
            m=@"六月";
            break;
        case 7:
            m=@"七月";
            break;
        case 8:
            m=@"八月";
            break;
        case 9:
            m=@"九月";
            break;
        case 10:
            m=@"十月";
            break;
        case 11:
            m=@"十一月";
            break;
        case 12:
            m=@"十二月";
            break;
            
        default:
            break;
    }
    
    return m;
}

//获取日期中的年
+(NSInteger)getYearForDate:(NSDate *)date
{
//    NSDate *ndate =[self DateFromString:date DateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger year=[comps year];
    return year;
}


//获取今天日期年-月-日
+(NSString *)getTodayDateFormatter:(NSString *)formatter;
{
    NSDate *  date=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:formatter];
    
    NSString *  locationString=[dateformatter stringFromDate:date];
    
//    NSLog(@"locationString:%@",locationString);
    
    return locationString;
}
//日期转NSString
+(NSString *)stringFromDateToStr:(NSString *)date DateFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dated = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:formatter];
    NSString *destDateString = [dateFormatter stringFromDate:dated];
    
    return destDateString;
}
//日期转NSString
+(NSString *)stringFromDate:(NSDate *)date DateFormatter:(NSString *)formatter{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}
//NSString转日期
+(NSDate *)DateFromString:(NSString *)datestr DateFormatter:(NSString *)formatter
{
    NSDateFormatter *formatters = [[NSDateFormatter alloc]init];
    [formatters setDateFormat:formatter];
    NSDate *date = [formatters dateFromString:datestr];
    
    return date;
}



+(NSDate *)tranfromStingToData:(NSString *)timeStr
{
    //    NSString * tStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:timeStr];
    return date;
}
+(NSString *)tranfromTime:(long long)ts
{
    NSDate *date=[[NSDate alloc]initWithTimeIntervalSince1970:ts/1000];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strTime=[formatter stringFromDate:date];
    return strTime;
}
+(NSString *)prettyDateWithReference:(NSDate *)reference {
    
    NSString *suffix = @"ago";
    float different = [reference timeIntervalSinceDate:[NSDate date]];
    if (different < 0) {
        different = -different;
        suffix = @"前";
    }
    // days = different / (24 * 60 * 60), take the floor value
    float dayDifferent = floor(different / 86400);
    
    int days   = (int)dayDifferent;
    int weeks  = (int)ceil(dayDifferent / 7);
    int months = (int)ceil(dayDifferent / 30);
    int years  = (int)ceil(dayDifferent / 365);
    
    // It belongs to today
    if (dayDifferent <= 0) {
        // lower than 60 seconds
        if (different < 60) {
            return @"刚刚";
        }
        
        // lower than 120 seconds => one minute and lower than 60 seconds
        if (different < 120) {
            return [NSString stringWithFormat:@"1 分钟%@", suffix];
        }
        
        // lower than 60 minutes
        if (different < 60 * 60) {
            return [NSString stringWithFormat:@"%d 分钟%@", (int)floor(different / 60), suffix];
        }
        
        // lower than 60 * 2 minutes => one hour and lower than 60 minutes
        if (different < 7200) {
            return [NSString stringWithFormat:@"1 小时%@", suffix];
        }
        
        // lower than one day
        if (different < 86400) {
            return [NSString stringWithFormat:@"%d 小时%@", (int)floor(different / 3600), suffix];
        }
    }
    // lower than one week
    else if (days < 7) {
        if (days ==1) {
            return [NSString stringWithFormat:@"昨天"];
            
        }else if(days == 2)
        {
            return [NSString stringWithFormat:@"前天"];
            
        }
        return [NSString stringWithFormat:@"%d 天%@%@", days, days == 1 ? @"" : @"", suffix];
    }
    // lager than one week but lower than a month
    else if (weeks < 4) {
        return [NSString stringWithFormat:@"%d 周%@%@", weeks, weeks == 1 ? @"" : @"", suffix];
    }
    // lager than a month and lower than a year
    else if (months < 12) {
        return [NSString stringWithFormat:@"%d 月%@%@", months, months == 1 ? @"" : @"", suffix];
    }
    // lager than a year
    else {
        return [NSString stringWithFormat:@"%d 年%@%@", years, years == 1 ? @"" : @"", suffix];
    }
    
    return self.description;
}

+(NSString *)prettyDateWithData:(NSDate *)reference {
    
    NSString *suffix = @"ago";
    float different = [reference timeIntervalSinceDate:[NSDate date]];
    if (different < 0) {
        different = -different;
        suffix = @"前";
    }
    // days = different / (24 * 60 * 60), take the floor value
    float dayDifferent = floor(different / 86400);
    
    int days   = (int)dayDifferent;
    
    // It belongs to today
    if (dayDifferent <= 0) {
        // lower than 60 seconds
        if (different < 60) {
            return @"刚刚";
        }
        
        // lower than 120 seconds => one minute and lower than 60 seconds
        if (different < 120) {
            return [NSString stringWithFormat:@"1 分钟%@", suffix];
        }
        
        // lower than 60 minutes
        if (different < 60 * 60) {
            return [NSString stringWithFormat:@"%d 分钟%@", (int)floor(different / 60), suffix];
        }
        
        // lower than 60 * 2 minutes => one hour and lower than 60 minutes
        if (different < 7200) {
            return [NSString stringWithFormat:@"1 小时%@", suffix];
        }
        
        // lower than one day
        if (different < 86400) {
            return [NSString stringWithFormat:@"%d 小时%@", (int)floor(different / 3600), suffix];
        }
    }
    // lower than one week
    else if (days ==1) {
        
        return [NSString stringWithFormat:@"昨天"];
        
    }else if(days == 2)
    {
        return [NSString stringWithFormat:@"前天"];
        
    }
    else
    {
        return [DateUitls stringFromDate:reference DateFormatter:@"yyyy-MM-dd HH:mm"];
    }
    return self.description;
}



+(NSString *)TimeDifference:(NSDate *)reference {
    
    NSInteger dayDifferent = [DateUitls calcDaysFromBegin:[NSDate date] today:reference];
    NSLog(@"距离现在多少天%ld",(long)dayDifferent);
    NSString *suffix = @"到期";
    if (dayDifferent <= 0) {
        return @"(已到期,请续费)";
    }else{
        return [NSString stringWithFormat:@"(还剩%ld天%@)", (long)dayDifferent, suffix];
        
    }
}
+(BOOL)FiveMinutesDifference:(NSString *)newStr :(NSString *)lastStr
{
    NSDate * newDate = [DateUitls tranfromStingToData:newStr];
    NSDate * lastDate = [DateUitls tranfromStingToData:lastStr];
    
    float different = [newDate timeIntervalSinceDate:lastDate];
    
    NSLog(@"==时间间隔==%f====",different);
    if(different>300) {
        return YES;
    }else
    {
        return NO;
    }
    
}

///今天hh：mm，昨天hh：mm，前天hh：mm，具体日期yyyy-mm-dd hh：mm
+(NSString *) formatDateForDayHHMM:(NSString *) dateStr
{
    
    NSDate * reference = [self DateFromString:dateStr DateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSString *suffix = @"ago";
    float different = [reference timeIntervalSinceDate:[NSDate date]];
    if (different < 0) {
        different = -different;
        suffix = @"前";
    }
    NSString * time = [DateUitls stringFromDate:reference DateFormatter:@"HH:mm"];
    // days = different / (24 * 60 * 60), take the floor value
    float dayDifferent = floor(different / 86400);
    
    int days   = (int)dayDifferent;
    
    // It belongs to today
    if (dayDifferent <= 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString * need_yMd = [dateFormatter stringFromDate:reference];
        NSString *now_yMd = [dateFormatter stringFromDate:[NSDate date]];
        
        [dateFormatter setDateFormat:@"HH:mm"];
        if ([need_yMd isEqualToString:now_yMd]) {
            //在同一天
            
            return [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:reference]];
        }else{
            //昨天
            return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:reference]];
        }
        
        
        
    }
    // lower than one week
    else if (days ==1) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        
        return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:reference]];
        
    }else if(days == 2)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"前天 %@",[dateFormatter stringFromDate:reference]];
        
    }
    else
    {
        return [DateUitls stringFromDate:reference DateFormatter:@"yyyy-MM-dd HH:mm"];
    }
    return @"";
    
}
/**
 *  hh：mm，昨天，前天，具体日期yyyy-mm-dd
 */
+ (NSString *)formateDateWithDateString:(NSString *)dateString {
    
    NSDate * reference=[self DateFromString:dateString DateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSString *suffix = @"ago";
    float different = [reference timeIntervalSinceDate:[NSDate date]];
    if (different < 0) {
        different = -different;
        suffix = @"前";
    }
    NSString * time=[DateUitls stringFromDate:reference DateFormatter:@"HH:mm"];
    // days = different / (24 * 60 * 60), take the floor value
    float dayDifferent = floor(different / 86400);
    
    int days   = (int)dayDifferent;
    
    // It belongs to today
    if (dayDifferent <= 0) {
        return [NSString stringWithFormat:@"%@",time];
    }
    // lower than one week
    else if (days ==1) {
        
        return [NSString stringWithFormat:@"昨天"];
        
    }else if(days == 2)
    {
        return [NSString stringWithFormat:@"前天"];
        
    }
    else
    {
        return [DateUitls stringFromDate:reference DateFormatter:@"yyyy-MM-dd"];
    }
    return @"";
}


///yyyy年MM月dd日_MM月dd日 跨年  yyyy年MM月dd日_yyyy年MM月dd日
+(NSString *) formatterForActivityDate:(NSString *)startDate end:(NSString *)endDate
{
    NSMutableString * dateStr=[NSMutableString new];
    NSDate * start=[self DateFromString:startDate DateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * end=[self DateFromString:endDate DateFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:start];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    
    comps = [calendar components:unitFlags fromDate:end];
    NSInteger yeard=[comps year];
    NSInteger monthd = [comps month];
    NSInteger dayd = [comps day];
    if(year<yeard)
    {
        [dateStr appendFormat:@"%ld年%ld月%ld日_%ld年%ld月%ld日",(long)year,(long)month,(long)day,(long)yeard,(long)monthd,(long)dayd];
    }
    else
    {
        [dateStr appendFormat:@"%ld年%ld月%ld日_%ld月%ld日",(long)year,(long)month,(long)day,(long)monthd,(long)dayd];
    }
    return dateStr;
}

/**
 判断当前时间是否在某个时间段内
 */
+ (BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime {
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

@end
