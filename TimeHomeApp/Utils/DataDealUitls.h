//
//  DataDealUitls.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/8/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDealUitls : NSObject


/**
 判断字符串是否在数组内

 @param str 字符串
 @param arr 数组
 @return 返回YES 表示字符串在字符串数组内
 */
+(BOOL)stringInArray:(NSString *)str :(NSArray *)arr;


/**
 按照UserID 存储

 @param 设置的KEY
 @return 返回按KEY_UserID
 
 */
+(NSString *)getSetingKey:(NSString * )key;

@end
