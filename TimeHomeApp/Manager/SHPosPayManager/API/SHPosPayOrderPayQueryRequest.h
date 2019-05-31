//
//  SHPosPayOrderPayQueryRequest.h
//  PAPark
//
//  Created by Evagrius on 2018/6/20.
//  Copyright © 2018年 SafeHome. All rights reserved.
//

#import "PABaseRequest.h"

@interface SHPosPayOrderPayQueryRequest : PABaseRequest
- (instancetype)initWithOrderId:(NSString *)orderId;
@end
