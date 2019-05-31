//
//  UserPublishCar.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/6.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UserPublishCar.h"

@implementation UserPublishCar

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"theID":@"id",@"descriptionString":@"description"
             };
}

@end
