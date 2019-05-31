//
//  ZSY_carWarnlistModel.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_carWarnlistModel.h"

@implementation ZSY_carWarnlistModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID":@"id",@"typeName":@"typename"
             };
}
@end
