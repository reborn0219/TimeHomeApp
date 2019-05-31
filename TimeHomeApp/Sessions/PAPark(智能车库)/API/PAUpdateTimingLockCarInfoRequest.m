//
//  PAUpdateTimingLockCarInfoRequest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/18.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAUpdateTimingLockCarInfoRequest.h"
#import "PAParkingSpaceUrl.h"

@implementation PAUpdateTimingLockCarInfoRequest{
    PALockCarModel * _lockModel;
}

-(instancetype)initWithDetails:(PALockCarModel*)lockModel{
    
    if (self = [super init]) {
        
        _lockModel = lockModel;
    }
    return self;
}
- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    
    return  [self paramDicWithMethodName:@"appfixedparkingspace.relationCarNoUpdate"
                                   token:appdelgate.userData.token?:@""
                            originParams:@{
                                           
                                   @"id" : _lockModel.carId,
                                   @"autoLockCarRule":_lockModel.autoLockCarRule?_lockModel.autoLockCarRule:@"",
                                   @"autoLockCarSwitch":_lockModel.autoLockCarSwitch?_lockModel.autoLockCarSwitch:@"0",
                                   @"autoLockCarTime":_lockModel.autoLockCarTime?_lockModel.autoLockCarTime:@"",
                                   @"autoUnlockCarRule":_lockModel.autoUnlockCarRule?_lockModel.autoUnlockCarRule:@"",
                                   @"autoUnlockCarSwitch":_lockModel.autoUnlockCarSwitch?_lockModel.autoUnlockCarSwitch:@"0",
                                   @"autoUnlockCarTime":_lockModel.autoUnlockCarTime?_lockModel.autoUnlockCarTime:@"",
                                       
                                           }];
    
    
}

@end
