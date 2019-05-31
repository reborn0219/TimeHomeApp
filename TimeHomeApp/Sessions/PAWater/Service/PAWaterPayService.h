//
//  PAWaterPayService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"
#import "PAWaterPaymentModel.h"

@interface PAWaterPayService : PABaseRequestService

@property (nonatomic,strong)PAWaterPaymentModel * payment;

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

@end
