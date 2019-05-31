//
//  PAParkingSpaceInfoRequest.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/10.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"

@interface PACarSpaceInfoRequest : PABaseRequest

/**
 根据车位ID查询车位详情信息
 
 @param parkingSpaceId 车位ID
 @return return request
 */
- (instancetype)initWithParkingSpaceId:(NSString *)parkingSpaceId;

@end
