//
//  SHPosPayManager.m
//  PAPark
//
//  Created by Evagrius on 2018/6/5.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import "SHPosPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SHPosPayVerifyService.h"

@implementation SHPosPayManager
/**
 发起支付
 
 @param channel 渠道类型
 @param posData 支付信息
 @param callback 支付回调
 */
+ (void)posPayWithChannel:(SHPosPayChannel)channel posData:(NSString *)posData callback:(PosPayResultBlock)callback{
    NSString * channelString;
    if (channel == SHAliPay) {
        channelString = CHANNEL_ALIPAY;
    } else if (channel == SHWeChatPay){
        channelString = CHANNEL_WEIXIN;
    }
    if (!posData) {
        [SVProgressHUD showErrorWithStatus:@"订单生成失败"];
        return;
    }
    [UMSPPPayUnifyPayPlugin payWithPayChannel:channelString payData:posData callbackBlock:^(NSString *resultCode, NSString *resultInfo) {
        NSLog(@"%@===%@",resultCode,resultInfo);
        if ([resultCode isEqualToString:@"1003"]) {
            callback(NO,@"1003",@"未安装支付宝");
        }
    }];
}
/**
 发起支付宝支付
 
 @param posData 支付信息
 @param callback 完成回调
 */
+ (void)aliPayWithPosData:(NSString *)posData callback:(PosPayResultBlock )callback{
    AlipaySDK * alipay = [AlipaySDK defaultService];
    [alipay payOrder:posData fromScheme:@"PAParkPasSchemes" callback:^(NSDictionary *resultDic) {
        NSLog(@"%@",resultDic);
    }];
}

/**
 支付宝支付成功后,后台校验结果
 
 @param payment 支付宝parameter
 */
+ (void)sendPaymentForAliPay:(NSDictionary *)payment{
    SHPosPayVerifyService * verifyService = [[SHPosPayVerifyService alloc]init];
    [verifyService posPayVerify:payment];
    
    verifyService.successBlock = ^(PABaseRequestService *service) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"POSPAYSUCCESS" object:nil];
    };
    verifyService.failedBlock = ^(PABaseRequestService *service, NSString *errorMsg) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"POSPAYERROR" object:nil];
    };
}

/**
 饮水机发起支付
 
 @param payType 支付类型 1支付宝 2微信
 @param deviceUuid deviceUuid description
 @param amount 金额
 @param waterNum 取水量
 @param callback 回调
 */
+ (void)sendPosPayWithPayType:(NSInteger)payType
                   deviceUuid:(NSString *)deviceUuid
                       amount:(double)amount
                     waterNum:(double)waterNum
                     callback:(PosPayResultBlock)callback{
    NSString *channelString;
    if (payType == 1) {
        channelString = CHANNEL_ALIPAY;
    } else if (payType == 2){
        channelString = CHANNEL_WEIXIN;
    }

  SHPosPayVerifyService * payService = [[SHPosPayVerifyService alloc]init];
    [payService sendPosPayWithPayType:payType deviceUuid:deviceUuid amount:amount waterNum:waterNum];
    payService.successBlock = ^(PABaseRequestService *service) {
        // 调起支付
//        NSString * posData = [payService.payResponse[@"data"][@"appPayRequest"].yy_modelToJSONString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * posData = [payService.payResponse[@"data"][@"appPayRequest"]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        SHPosPayChannel channel;
        if (payType == 1) {
            channel = SHAliPay;
        } else if (payType == 2){
            channel = SHWeChatPay;
        }
        [[self class] posPayWithChannel:channel posData:posData callback:callback];
    };
}


@end
