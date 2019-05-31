//
//  RegularUtils.h
//  TimeHomeApp
//
//  Created by us on 16/3/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
///通用正则表达式
#import <Foundation/Foundation.h>

@interface RegularUtils : NSObject
/** 判断全数字 */
//+ (BOOL)isAllNumber:(NSString *)number;
/**
 邮箱地址的正则表达式
 */
+ (BOOL)isValidateEmail:(NSString *)email;
///判断QQ号
+(BOOL)isQQ:(NSString *)QQ;
///判断邮编
+(BOOL)iszipCode:(NSString *)code;
///判断手机号格式是否正确
+(BOOL)isPhoneNum:(NSString *)phoneNum;

///判断车牌格式是否正确
+(BOOL)isCarNum:(NSString *)carNum;

///判断是否是字串或数字
+(BOOL)isNumOrCharacter:(NSString *)text;

///判断只能是数字，字母和中文
+(BOOL)addCarIsNumberOrCharOrChinese:(NSString *)text;

/**
 正则判断电话号码地址格式（包含固话）
 */
//+ (BOOL)isMobileNumber:(NSString *)mobileNum;

@end
