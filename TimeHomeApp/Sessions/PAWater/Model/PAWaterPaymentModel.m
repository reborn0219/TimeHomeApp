//
//  SHOrderPaymentModel.m
//  PAPark
//
//  Created by Evagrius on 2018/6/6.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import "PAWaterPaymentModel.h"

@implementation PAWaterPosPayRequestModel

@end

@implementation PAWaterPayData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"appPayRequest":[PAWaterPosPayRequestModel class]};
}

@end

@implementation PAWaterPaymentModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[PAWaterPayData class]};
}

@end
