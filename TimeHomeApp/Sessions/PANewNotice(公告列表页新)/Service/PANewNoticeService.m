//
//  PANewNoticeService.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/30.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewNoticeService.h"
#import "PANewNoticeListRequest.h"
#import "PANewNoticeTopRequest.h"
@implementation PANewNoticeService
/**
 加载新公告列表接口
 
 @param page page description
 @param success success description
 @param failed failed description
 */
- (void)loadNewNoticeListWithPage:(NSInteger)page
                          success:(ServiceSuccessBlock)success
                           failed:(ServiceFailedBlock)failed{
    PANewNoticeListRequest * req = [[PANewNoticeListRequest alloc]initWithPage:page];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSLog(@"%@",responseModel.data);
        if (page == 1) {
            self.noticeArray = [NSArray yy_modelArrayWithClass:[PANewNoticeModel class] json:responseModel.data[@"beanList"]].mutableCopy;
        } else {
            [self.noticeArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[PANewNoticeModel class] json:responseModel.data[@"beanList"]]];
        }
        success(self);
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failed(self,error.localizedDescription);
    }];
}

/**
 加载首页top公告接口
 
 @param success success description
 @param failed failed description
 */
- (void)loadNewTopNoticeSuccess:(ServiceSuccessBlock)success
                         failed:(ServiceFailedBlock)failed{
    PANewNoticeTopRequest * req = [[PANewNoticeTopRequest alloc]init];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
         self.topNoticeArray = [NSArray yy_modelArrayWithClass:[PANewNoticeModel class] json:responseModel.data[@"beanList"]].mutableCopy;
        success(self);
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        failed(self,error.localizedDescription);
    }];
}


@end
