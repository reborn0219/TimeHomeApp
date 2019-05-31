//
//  SHPosPayOrderPayQueryRequest.m
//  PAPark
//
//  Created by Evagrius on 2018/6/20.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import "SHPosPayOrderPayQueryRequest.h"

@implementation SHPosPayOrderPayQueryRequest
{
    NSString *_orderId;
}
- (instancetype)initWithOrderId:(NSString *)orderId{
    if (self = [super init]) {
        _orderId = orderId;
    }
    return self;
}
- (NSString *)requestUrl{
    return @"api_entrance";
}

- (NSString *)baseUrl{
    return PA_NEW_SEVER_URL;
}
- (id)requestArgument{
    AppDelegate * delegate = GetAppDelegates;
    NSDictionary * parameter = @{@"merOrderId":_orderId?:@""};
    return [self paramDicWithMethodName:@"account.parkingorder.app.orderQuery" token:delegate.userData.token originParams:parameter];
}

@end
