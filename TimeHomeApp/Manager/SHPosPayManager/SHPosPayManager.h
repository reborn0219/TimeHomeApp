//
//  SHPosPayManager.h
//  PAPark
//
//  Created by Evagrius on 2018/6/5.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSPPPayUnifyPayPlugin.h"

typedef NS_ENUM(NSUInteger, SHPosPayChannel) {
    SHAliPay,
    SHWeChatPay
};
typedef void(^PosPayResultBlock)(BOOL isSuccess, NSString *resultCode,  NSString *resultInfo);

@interface SHPosPayManager : NSObject

/**
 发起支付

 @param channel 渠道类型
 @param posData 支付信息
 @param callback 支付回调
 */
+ (void)posPayWithChannel:(SHPosPayChannel)channel posData:(NSString *)posData callback:(PosPayResultBlock)callback;



/**
 发起支付宝支付

 @param posData 支付信息
 @param callback 完成回调
 */
+ (void)aliPayWithPosData:(NSString *)posData callback:(PosPayResultBlock )callback;

/**
 支付宝支付成功后,后台校验结果

 @param payment 支付宝parameter
 */
+ (void)sendPaymentForAliPay:(NSDictionary *)payment;

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
                     callback:(PosPayResultBlock)callback;

@end
