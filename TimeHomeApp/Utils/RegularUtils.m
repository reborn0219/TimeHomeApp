//
//  RegularUtils.m
//  TimeHomeApp
//
//  Created by us on 16/3/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RegularUtils.h"

@implementation RegularUtils

/** 判断全数字 */
//+ (BOOL)isAllNumber:(NSString *)number {
//    
//    NSString *regex = @"^([1-9]+(\.[0-9]{2})?|0\.[1-9][0-9]|0\.0[1-9])$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isMatch = [pred evaluateWithObject:number];
//    if (!isMatch) {
//        return NO;
//    }
//    return YES;
//}

/**
 邮箱地址的正则表达式
 */
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

///判断QQ号
+(BOOL)isQQ:(NSString *)QQ {
    BOOL isValid=NO;
    NSString *regex = @"[1-9][0-9]{4,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    isValid = [predicate evaluateWithObject:QQ];
    return isValid;
}
///判断邮编
+(BOOL)iszipCode:(NSString *)code {
    BOOL isValid=NO;
    NSString *regex = @"^[0-9][0-9]{5}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    isValid = [predicate evaluateWithObject:code];
    return isValid;
}
///判断手机号格式是否正确
+(BOOL)isPhoneNum:(NSString *)phoneNum
{
    BOOL isValid=NO;
    NSString *regex = @"^0?(13[0-9]|15[0-9]|17[0-9]|18[0-9]|19[0-9]|16[0-9]|14[0-9])[0-9]{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    isValid = [predicate evaluateWithObject:phoneNum];
    return isValid;
}

///判断车牌格式是否正确
+(BOOL)isCarNum:(NSString *)carNum
{
    
      BOOL isValid=NO;
    if (carNum.length == 8) {
        
        
        ///开头有字母的用^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$|^[a-zA-Z]{2}\d{7}$
        NSString *regex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{5}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        isValid = [predicate evaluateWithObject:carNum];
        
    }else
    {
      
        ///开头有字母的用^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$|^[a-zA-Z]{2}\d{7}$
        NSString *regex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        isValid = [predicate evaluateWithObject:carNum];
    }
    return isValid;
}

///判断是否是字串或数字
+(BOOL)isNumOrCharacter:(NSString *)text
{
    BOOL isValid=NO;
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    isValid = [predicate evaluateWithObject:text];
    
    return isValid;
}


///判断只能是数字，字母和中文
+(BOOL)addCarIsNumberOrCharOrChinese:(NSString *)text {
    // /[\w\u4e00-\u9fa5]/.test(String.fromCharCode(window.event.keyCode))
    BOOL isValid=NO;
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    isValid = [predicate evaluateWithObject:text];
    return isValid;
}

/**
 正则判断电话号码地址格式（包含固话）
 */
//+ (BOOL)isMobileNumber:(NSString *)mobileNum
//{
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
//
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES)
//        || ([regextestPHS evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}

@end
