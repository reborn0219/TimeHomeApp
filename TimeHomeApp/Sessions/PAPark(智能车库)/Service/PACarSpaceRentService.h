//
//  PAParkingSpaceRentService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PACarSpaceServiceRentType) {
    PACarSpaceServiceRent, // 出租
    PACarSpaceServiceRenew // 续租
};
@interface PACarSpaceRentService : NSObject

@property (nonatomic, strong) NSArray <NSString *>* titleArray;
@property (nonatomic, strong) NSArray <NSString *>* placeholderArray;

/**
 车位出租

 @param spaceId spaceId 车库ID
 @param userName userName 租户名称
 @param userPhone userPhone 租户手机号
 @param startDate startDate 出租日期
 @param endDate endDate 出租结束日期
 @param success success 成功回调
 @param failure failure 失败回调
 */
- (void)rentRequestWithSpaceId:(NSString *)spaceId userName:(NSString *)userName userPhone:(NSString *)userPhone startDate:(NSString *)startDate endDate:(NSString *)endDate success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
@end
