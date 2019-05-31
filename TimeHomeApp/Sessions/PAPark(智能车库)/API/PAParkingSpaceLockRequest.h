//
//  PAParkingSpaceLockRequest.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"

@interface PACSpaceLockRequest : PABaseRequest

/**
 生成锁车/解锁request
 
 @param spaceId spaceId 车位ID
 @param carNo carNo 入库车牌号
 @param carlockState carlockState 锁车状态 0开 1锁
 @return return value request
 */
- (instancetype)initWithPrkingSpaceId:(NSString *)spaceId
                                carNo:(NSString *)carNo
                         carLockState:(NSInteger)carlockState;
@end
