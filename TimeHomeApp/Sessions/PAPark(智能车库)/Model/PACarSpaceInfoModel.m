//
//  PAParkingSpaceInfo.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceInfoModel.h"

@implementation PACarSpaceInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"carNos":[PACarManagementModel class]};
}
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"parkingSpaceInfoId":@"id"};
}

@end
