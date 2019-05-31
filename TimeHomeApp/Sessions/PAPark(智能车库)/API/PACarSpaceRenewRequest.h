//
//  PAParkingSpaceRenewRequet.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"


/**
 续租车位
 */
@interface PACarSpaceRenewRequest : PABaseRequest

/**
 根据车位ID 出租开始时间/结束时间生成request
 
 @param spaceId spaceId 车位ID
 @param startTime startTime 出租开始时间
 @param endTime endTime 出租结束时间
 @return return request
 */
- (instancetype)initWithPakringSpaceId:(NSString *)spaceId startTime:(NSString *)startTime endTime:(NSString *)endTime;

@end
