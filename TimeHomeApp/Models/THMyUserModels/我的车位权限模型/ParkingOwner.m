//
//  ParkingOwner.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/1.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ParkingOwner.h"

@implementation ParkingOwner

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"theID":@"id"
             };
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"userlist" : @"OwnerResidenceUser",
             };
}

@end
