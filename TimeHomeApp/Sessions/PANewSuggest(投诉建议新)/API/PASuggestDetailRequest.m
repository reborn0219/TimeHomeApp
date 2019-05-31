
//
//  PASuggestDetailRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PASuggestDetailRequest.h"

@implementation PASuggestDetailRequest
{
    NSString *_orderId;
}
- (instancetype)initWithOrderId:(NSString *)orderId{
    if (self = [super init]) {
        _orderId = orderId;
    }
    return self;
}
- (NSString *)baseUrl{
    return PA_NEW_NOTICE_URL;
}
- (NSString *)requestUrl{
    return @"api_entrance";
}
- (id)requestArgument{
    AppDelegate * delegate= GetAppDelegates;
    NSDictionary * parameter = @{@"workOrderCode":_orderId};
    return [self paramDicWithMethodName:@"ICustomerPasqAppService.queryWorkOrderDetail" appid:@"APP_H5_WG" encrypt:@"APP_H5_WG_2018" token:delegate.userData.token?:@"" originParams:parameter];
}
@end
