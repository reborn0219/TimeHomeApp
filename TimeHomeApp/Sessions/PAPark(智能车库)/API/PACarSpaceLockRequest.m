//
//  PAParkingSpaceLockRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceLockRequest.h"
#import "PAParkingSpaceUrl.h"

@implementation PACarSpaceLockRequest

{
    NSString * _parkingSpaceId;
    NSString * _carNo;
    NSNumber * _carLockState;
}


/**
 生成锁车/解锁request
 
 @param spaceId spaceId description
 @param carNo carNo description
 @param carlockState carlockState description
 @return return value description
 */
- (instancetype)initWithPrkingSpaceId:(NSString *)spaceId carNo:(NSString *)carNo carLockState:(NSInteger)carlockState{
    if (self = [super init]) {
        _parkingSpaceId = spaceId;
        _carNo = carNo;
        _carLockState = [NSNumber numberWithInteger:carlockState];
    }
    return self;
    
}

- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    return  [self paramDicWithMethodName:@"appfixedparkingspace.lockCar"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"parkingSpaceId":_parkingSpaceId,
                                           @"carNo":_carNo,
                                           @"carLockState":_carLockState
                                           }];
}


@end
