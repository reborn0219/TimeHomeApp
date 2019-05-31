//
//  DataDealUitls.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/8/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "DataDealUitls.h"

@implementation DataDealUitls

+(BOOL)stringInArray:(NSString *)str :(NSArray *)arr
{
    
    for (NSString * tempStr in arr) {
        if ([tempStr isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}
+(NSString *)getSetingKey:(NSString * )key
{
    AppDelegate * appDelegate = GetAppDelegates;
    return [NSString stringWithFormat:@"%@_%@",key,appDelegate.userData.userID];
    
}
@end
