//
//  PAWaterOrderQueryRequest.m
//  TimeHomeApp
//
//  Created by ning on 2018/8/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterOrderQueryRequest.h"

@implementation PAWaterOrderQueryRequest{
    NSInteger _takeWaterStatus;
}

- (instancetype)initWithTakeWaterStatus:(NSInteger )takeWaterStatus{
    if (self = [super init]) {
        _takeWaterStatus = takeWaterStatus;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/api_entrance";
}

- (id)requestArgument{
    AppDelegate * appdelgate = GetAppDelegates;
    NSDictionary *paramDict = [NSDictionary dictionary];
    if (_takeWaterStatus>0) {
        paramDict = @{
                      @"takeWaterStatus":@(_takeWaterStatus),
                      };
    }
    return  [self paramDicWithMethodName:@"orderinfo.appOrderList"
                                   token:appdelgate.userData.token?:@""
                            originParams:paramDict];
}

@end
