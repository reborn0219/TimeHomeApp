//
//  PANewHomeResidenceRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeResidenceRequest.h"

@implementation PANewHomeResidenceRequest
- (NSString *)baseUrl{
    return SERVER_URL;
}
- (NSString *)requestUrl{
    return @"residence/getuserresidence";
}
- (id)requestArgument{
    AppDelegate * delegate = GetAppDelegates;
    return [self paramDicWithMethodName:@"" token:delegate.userData.token?:@"" originParams:@{}];
}
@end
