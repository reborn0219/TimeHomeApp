//
//  SHPosPayVerifyService.h
//  PAPark
//
//  Created by Evagrius on 2018/6/6.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import "PABaseRequestService.h"

@interface SHPosPayVerifyService : PABaseRequestService

@property (nonatomic,strong)NSDictionary * payResponse;
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
                     waterNum:(double)waterNum;
/**
 发起支付校验

 @param parameter 支付宝成功后提交支付结果至后台(支付宝)
 */
- (void)posPayVerify:(NSDictionary *)parameter;

/**
 向后台发起支付结果校验(银联)

 @param orderId orderID
 */
- (void)podPayResultQueryWithOrderId:(NSString *)orderId;

@end
