//
//  PAWaterPayService.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAWaterPayService.h"
#import "PAWaterPosPayRequest.h"


@implementation PAWaterPayService
/**
 发起支付
 
 @param payType 支付类型
 @param deviceUuid deviceUuid
 @param amount 金额
 @param waterNum 取水量
 */
- (void)sendPosPayWithPayType:(NSInteger)payType
                   deviceUuid:(NSString *)deviceUuid
                       amount:(double)amount
                     waterNum:(double)waterNum{
    PAWaterPosPayRequest * req = [[PAWaterPosPayRequest alloc]initWithPayType:payType deviceUuid:deviceUuid amount:amount waterNum:waterNum];

    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        self.payment = [PAWaterPaymentModel yy_modelWithJSON:responseModel.data];
        if (self.successBlock) {
            self.successBlock(self);
        }
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        if (error.code == -1) {
            if (self.failedBlock) {
                self.failedBlock(self, @"-1");
            }
        }
    }];
    /*
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        self._payment
        if (self.successBlock) {
            self.successBlock(self);
        }
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        NSLog(@"error-%@",error);
    }];
     */
}

@end
