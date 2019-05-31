//
//  PACarportService.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceService.h"
#import "PACarSpaceRequest.h"
#import "PACarSpaceModel.h"
@implementation PACarSpaceService

-(void)loadData{
    
    AppDelegate * appdelegate = GetAppDelegates;
    //发起请求
    PACarSpaceRequest *req = [[PACarSpaceRequest alloc]initWithCommunityId:appdelegate.userData.communityid phone:appdelegate.userData.phone];
    
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSDictionary * responseData = responseModel.data;
        NSLog(@"___车位车辆信息：%@__",responseData);
        
        self.limitapp = responseData[@"limitapp"];
        NSArray * parkingArray =[NSArray yy_modelArrayWithClass:[PACarSpaceModel class] json:responseData[@"parkingSpaceList"]];
        
        self.personalCarportArray = @[].mutableCopy;
        self.rentCarportArray = @[].mutableCopy;
        for (PACarSpaceModel * model in parkingArray) {
            
            if (model.type == 0 ||model.type == 3) {
                [self.personalCarportArray addObject:model];
            } else {
                [self.rentCarportArray addObject:model];
            }
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(loadDataSuccess)]) {
            [self.delegate loadDataSuccess];
        }
        
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        NSLog(@"%@",error);
        if (self.delegate && [self.delegate respondsToSelector:@selector(loadDataFailed:)]) {
            [self.delegate loadDataFailed:@""];
        }
    }];
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"自用车位",@"出租中"];
    }
    return _titleArray;
}
@end
