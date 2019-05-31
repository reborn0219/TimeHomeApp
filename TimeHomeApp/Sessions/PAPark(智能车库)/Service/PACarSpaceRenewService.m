//
//  PAParkingSpaceRenewService.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/20.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceRenewService.h"
#import "PACarSpaceRenewRequest.h"
@implementation PACarSpaceRenewService

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
                       failure:(void (^)(NSError *error))failure{
    
    PACarSpaceRenewRequest * req = [[PACarSpaceRenewRequest alloc]initWithPakringSpaceId:spaceId startTime:startDate endTime:endDate];
    
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        success(responseModel);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(error);
    }] ;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"开始时间",@"结束时间"];
    }
    return _titleArray;
}

- (NSArray *)placeholderArray{
    if (!_placeholderArray) {
        _placeholderArray = @[@"请选择出租开始日期",@"请选择出租结束日期"];
    }
    return _placeholderArray;
}
@end
