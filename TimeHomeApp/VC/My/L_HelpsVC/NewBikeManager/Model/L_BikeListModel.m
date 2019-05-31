//
//  L_BikeListModel.m
//  TimeHomeApp
//
//  Created by 世博 on 16/9/7.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BikeListModel.h"

@implementation L_BikeListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"theID":@"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"resource" : @"L_BikeImageResourceModel",@"device" : @"L_BikeDeviceModel",@"share" : @"L_BikeShareInfoModel"
             };
}

@end
