//
//  L_HouseInfoModel.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseInfoModel.h"

@implementation L_HouseInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"theID":@"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"powerlist" : @"L_PowerListModel"
             };
}

@end
