//
//  SHPosPayVerifyService.m
//  PAPark
//
//  Created by Evagrius on 2018/6/6.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import "SHPosPayVerifyService.h"
#import "SHPosPayVerifyRequet.h"
#import "SHPosPayOrderPayQueryRequest.h"
#import "SHPosPayRequest.h"
@implementation SHPosPayVerifyService
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
    SHPosPayRequest * req = [[SHPosPayRequest alloc]initWithPayType:payType deviceUuid:deviceUuid amount:amount waterNum:waterNum];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        self.payResponse = responseModel.data;
        if (self.successBlock) {
            self.successBlock(self);
        }
            
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        NSLog(@"error-%@",error);
    }];
}


- (void)posPayVerify:(NSDictionary *)parameter{
    SHPosPayVerifyRequet * req = [[SHPosPayVerifyRequet alloc]initWithParameter:parameter];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        if (self.successBlock) {
           // self.successBlock(self);
        }
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        if (self.failedBlock) {
           // self.failedBlock(self, error.userInfo[@"NSLocalizedDescription"]);
        }
    }];
}

- (void)podPayResultQueryWithOrderId:(NSString *)orderId{
    SHPosPayOrderPayQueryRequest * req = [[SHPosPayOrderPayQueryRequest alloc]initWithOrderId:orderId];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSLog(@"%@",responseModel.data);
        if (responseModel.code == 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"POSPAYSUCCESS" object:nil];
        }        // 发送 成功
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        NSLog(@"%@",error);
        if (error.code == -1000) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"POSPAYERROR" object:nil];
        } else if (error.code == -999){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"POSPAYERROR" object:nil];
        }
    }];
}

@end
