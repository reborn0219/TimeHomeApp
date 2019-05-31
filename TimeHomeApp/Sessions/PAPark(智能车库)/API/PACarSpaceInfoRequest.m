//
//  PAParkingSpaceInfoRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/10.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceInfoRequest.h"
#import "PAParkingSpaceUrl.h"

@implementation PACarSpaceInfoRequest {
    
    NSString * _parkingSpaceId;
}

/**
 根据车位ID查询车位详情信息
 
 @param parkingSpaceId parkingSpaceId description
 @return return value description
 */
- (instancetype)initWithParkingSpaceId:(NSString *)parkingSpaceId{
    if (self = [super init]) {
        _parkingSpaceId = parkingSpaceId;
    }
    return self;
}
- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    return  [self paramDicWithMethodName:@"appfixedparkingspace.parkingSpace.info"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"id":_parkingSpaceId
                                           }];
    
}

@end
