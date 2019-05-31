//
//  PATimingLockCarInfo.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PATimingLockCarRequest.h"
#import "PAParkingSpaceUrl.h"

@implementation PATimingLockCarRequest
{
    NSString * _lockID;
}
-(instancetype)initWithId:(NSString*)lockID
{
    if (self = [super init]) {
        _lockID = lockID;
    }
    return self;
}
- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
   
    return  [self paramDicWithMethodName:@"appfixedparkingspace.lockCarInfo"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           @"id" : _lockID,
                                           }];
    
}
@end
