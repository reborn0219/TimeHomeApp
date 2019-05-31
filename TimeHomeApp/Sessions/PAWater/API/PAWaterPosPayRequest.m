//
//  PAWaterPayRequest.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterPosPayRequest.h"

@implementation PAWaterPosPayRequest
{
    NSDictionary *_parameter;
}

/**
 request生成
 
 @param payType 支付类型 1：银联 支付宝 2：银联 微信
 @param deviceUuid 设备ID
 @param amount 支付金额
 @param waterNum 取水量
 @return request
 */
- (instancetype) initWithPayType:(NSInteger)payType
                      deviceUuid:(NSString *)deviceUuid
                          amount:(double)amount
                        waterNum:(double)waterNum{
    if (self = [super init]) {
        _parameter = @{
                       @"client":@"1",
                       @"payType":@(payType),
                       @"deviceUuid":deviceUuid,
                       @"amount":@(amount),
                       @"waterNum":@(waterNum)
                       };
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
    return [self paramDicWithMethodName:@"orderinfo.InitiatePayment" token:delegate.userData.token originParams:_parameter];
}

@end
