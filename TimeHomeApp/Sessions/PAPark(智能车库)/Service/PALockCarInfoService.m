//
//  PALockCarInfoService.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PALockCarInfoService.h"
#import "PATimingLockCarRequest.h"
#import "PAUpdateTimingLockCarInfoRequest.h"

@implementation PALockCarInfoService

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark ————— 拉取数据 —————

-(void)loadData:(NSString *)carID{
    
    //发起请求
    PATimingLockCarRequest *req = [[PATimingLockCarRequest alloc]initWithId:carID];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSDictionary * responseData = responseModel.data;
        _lockModel = [PALockCarModel yy_modelWithJSON:responseData];
        
        if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestDataCompleted)]) {
            [self.delegagte requestDataCompleted];
        }
        
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
    }];
    
}
-(void)saveLockModel:(PALockCarModel *)lockModel
{
    PAUpdateTimingLockCarInfoRequest *req = [[PAUpdateTimingLockCarInfoRequest alloc]initWithDetails:lockModel];
    
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        [[THIndicatorVC sharedTHIndicatorVC]stopAnimating];

        NSDictionary * responseData = responseModel.data;
        
        NSLog(@"___保存成功：%@__",responseData);
        
        if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestSaveCompleted:)]) {
            [self.delegagte requestSaveCompleted:1];
        }
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
        [[THIndicatorVC sharedTHIndicatorVC]stopAnimating];
        if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestSaveCompleted:)]) {
            [self.delegagte requestSaveCompleted:0];
        }
        NSLog(@"%@",error);
    }];
}
@end
