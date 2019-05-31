//
//  PANewHouseService.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHouseService.h"
#import "PANewHouseListRequest.h"
@implementation PANewHouseService
/**
 加载新房产列表
 
 @param success success description
 @param failed failed description
 */
- (void)loadMyHouseListSuccess:(ServiceSuccessBlock)success
                        failed:(ServiceFailedBlock)failed{
    PANewHouseListRequest *req = [[PANewHouseListRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        self.houseArray = [NSArray yy_modelArrayWithClass:[PANewHouseModel class] json:responseModel.data[@"beanList"]];
        success(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failed(self,error.localizedDescription);
    }];
}
@end
