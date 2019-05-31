//
//  PAParkingSpaceLockService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"

@interface PACarSpaceLockService : PABaseRequestService


/**
 解锁/锁车事件

 @param spaceId spaceId 车位ID
 @param carNo carNo 入库车牌号
 @param lockState lockState 锁车状态1关 0开
 */
- (void)lockCarWithParkingSpaceId:(NSString *)spaceId carNo:(NSString *)carNo lockState:(NSInteger)lockState;

@end
