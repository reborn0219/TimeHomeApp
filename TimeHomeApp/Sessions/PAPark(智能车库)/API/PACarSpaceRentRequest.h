//
//  PAParkingSpaceRentRequest.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"

@interface PACarSpaceRentRequest : PABaseRequest




/**
 车位出租 request

 @param spaceId spaceId description
 @param userName userName description
 @param userPhone userPhone description
 @param startTime startTime description
 @param endTime endTime description
 @return return value description
 */
- (instancetype)initWithParkingSpaceId:(NSString *)spaceId
                              userName:(NSString *)userName
                             userPhone:(NSString *)userPhone
                             startTime:(NSString *)startTime
                               endTime:(NSString *)endTime;
@end
