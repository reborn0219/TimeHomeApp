//
//  SHPosPayRequest.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/10.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"

@interface SHPosPayRequest : PABaseRequest
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
                        waterNum:(double)waterNum;

@end
