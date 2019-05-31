//
//  PAParkingSpaceRentService.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceRentService.h"
#import "PACarSpaceRentRequest.h"
@implementation PACarSpaceRentService

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
- (void)rentRequestWithSpaceId:(NSString *)spaceId userName:(NSString *)userName userPhone:(NSString *)userPhone startDate:(NSString *)startDate endDate:(NSString *)endDate success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    PACarSpaceRentRequest * req = [[PACarSpaceRentRequest alloc]initWithParkingSpaceId:spaceId userName:userName userPhone:userPhone startTime:startDate endTime:endDate];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        success(responseModel);

    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failure(error);

    }];
    
}

- (NSArray *)placeholderArray{
    if (!_placeholderArray) {
        _placeholderArray = @[@"请输入被授权人手机号",@"请输入被授权人姓名",@"请选择出租开始日期",@"请选择出租结束日期"];
    }
    return _placeholderArray;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"手机号",@"姓名",@"开始时间",@"结束时间"];
    }
    return _titleArray;
}
@end
