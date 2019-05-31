//
//  PAParkingSpaceRenewService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/20.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"

@interface PACarSpaceRenewService : PABaseRequestService
/**
 车位续租
 
 @param spaceId spaceId description
 @param startDate startDate description
 @param endDate endDate description
 @param success success description
 @param failure failure description
 */
+ (void)rentRequestWithSpaceId:(NSString *)spaceId
                     startDate:(NSString *)startDate
                       endDate:(NSString *)endDate
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
@end
