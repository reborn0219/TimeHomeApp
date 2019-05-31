//
//  PAParkingSpaceRenewRequet.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceRenewRequest.h"
#import "PAParkingSpaceUrl.h"

@implementation PACarSpaceRenewRequest
{
    NSString * _spaceId;
    NSString * _startDate;
    NSString * _endDate;
}
/**
 根据车位ID 出租开始时间/结束时间生成request
 
 @param spaceId spaceId description
 @param startTime startTime description
 @param endTime endTime description
 @return return value description
 */
- (instancetype)initWithPakringSpaceId:(NSString *)spaceId startTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    if (self = [super init]) {
        _spaceId = spaceId;
        _startDate = startTime;
        _endDate = endTime;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    return  [self paramDicWithMethodName:@"appfixedparkingspace.renewParkingSpace"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"id":_spaceId,
                                           @"useStartDate":_startDate,
                                           @"useEndDate":_endDate
                                           }];
    
    
}

@end
