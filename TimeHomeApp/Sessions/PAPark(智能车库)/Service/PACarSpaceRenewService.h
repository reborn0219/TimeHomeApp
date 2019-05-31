//
//  PAParkingSpaceRenewService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/20.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"

@interface PACarSpaceRenewService : PABaseRequestService
@property (nonatomic, strong) NSArray <NSString *>* titleArray;
@property (nonatomic, strong) NSArray <NSString *>* placeholderArray;

/**
 车位续租
 
 @param spaceId spaceId 车位ID
 @param startDate startDate 出租开始日期
 @param endDate endDate 出租结束日期
 @param success success 成功回调
 @param failure failure 失败回调
 */
+ (void)rentRequestWithSpaceId:(NSString *)spaceId
                     startDate:(NSString *)startDate
                       endDate:(NSString *)endDate
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
@end
