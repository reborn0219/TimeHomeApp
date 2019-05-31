//
//  PATrafficRequest.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/5/17.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PATrafficSaveRequest.h"
#import "PAParkingSpaceUrl.h"

@implementation PATrafficSaveRequest
{
    NSDictionary * _trafficInfo;
}
-(instancetype)initSaveTrafficInfo:(NSDictionary *)trafficInfo{

    if (self = [super init]) {
        _trafficInfo = trafficInfo;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    
    AppDelegate * appdelgate = GetAppDelegates;
    
    return  [self paramDicWithMethodName:@"visitorlogs.save"
                                   token:appdelgate.userData.token?:@""
                            originParams:_trafficInfo];
}
@end
