//
//  PAUpdateRelationService.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAUpdateRelationService.h"
#import "PAMyNotRelationCarsRequest.h"
#import "PAUpdateRelationCarNoRequest.h"
#import "PARelationCarNoRequest.h"
#import "PABatchUpdateRelationCarRequest.h"

@implementation PAUpdateRelationService
-(instancetype)init{
    self = [super init];
    if (self) {
        self.carDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return self;
}

#pragma mark ————— 拉取数据 —————
-(void)loadData:(NSString *)spaceID{
    
    AppDelegate * appdelegate = GetAppDelegates;
    PAMyNotRelationCarsRequest *req = [[PAMyNotRelationCarsRequest alloc]initWithCommunityId:appdelegate.userData.communityid spaceID:spaceID];
    @WeakObj(self);
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {

        NSArray * responseData = responseModel.data;
        NSLog(@"__未关联车辆列表_%@_",responseData);
        [selfWeak.carDataArray removeAllObjects];
        NSArray *tempArr = [NSArray yy_modelArrayWithClass:[PACarManagementModel class] json:responseData];
        [selfWeak.carDataArray addObjectsFromArray:tempArr];
        if (selfWeak.delegagte && [selfWeak.delegagte respondsToSelector:@selector(requestUnRelationCompleted)]) {
            [selfWeak.delegagte requestUnRelationCompleted];
        }


    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {

        NSLog(@"%@",error);
        if (selfWeak.delegagte && [selfWeak.delegagte respondsToSelector:@selector(requestUnRelationCompleted)]) {
            [selfWeak.delegagte requestUnRelationCompleted];
        }
        
//        if (errorBlock) {
//            
//        }
    }];
    
}

-(void)changeCarNo:(NSString *)carNo
         ownerName:(NSString *)ownerName
           spaceID:(NSString *)spaceID
             carID:(NSString *)carID{
    
    @WeakObj(self);
    PAUpdateRelationCarNoRequest *req = [[PAUpdateRelationCarNoRequest alloc]initWithCarNo:carNo ownerName:ownerName spaceID:spaceID ID:carID];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSDictionary * responseData = responseModel.data;
        NSLog(@"___%@_",responseData);
        if (selfWeak.delegagte && [selfWeak.delegagte respondsToSelector:@selector(requestUpdateCompleted:)]) {
            [selfWeak.delegagte requestUpdateCompleted:1];
        }
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
        if (selfWeak.delegagte && [selfWeak.delegagte respondsToSelector:@selector(requestUpdateCompleted:)]) {
            [selfWeak.delegagte requestUpdateCompleted:0];
        }
        
    }];
    
}
#pragma mark - 关联车牌
-(void)relationCar:(NSArray*)carInfoArr spaceID:(NSString *)spaceID{
    
    if (carInfoArr == nil||carInfoArr.count == 0) {
        
        [AppDelegate showToastMsg:@"您没有选择或添加车牌,不能提交" Duration:2.0f];
        return;
    }
    PARelationCarNoRequest *req = [[PARelationCarNoRequest alloc]initWithCarNoEntities:carInfoArr spaceID:spaceID];
    @WeakObj(self);
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSDictionary * responseData = responseModel.data;
        NSLog(@"___%@_",responseData);
        if (selfWeak.delegagte && [selfWeak.delegagte respondsToSelector:@selector(requestRelationCarCompleted:)]) {
            [selfWeak.delegagte requestRelationCarCompleted:1];
        }
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
        if (selfWeak.delegagte && [selfWeak.delegagte respondsToSelector:@selector(requestRelationCarCompleted:)]) {
            [selfWeak.delegagte requestRelationCarCompleted:0];
        }
        
    }];
    
}
-(void)batchChangeRelationCarNO:(NSString *)carNo updateCarNo:(NSString *)updateCarNo communityID:(NSString *)communityId {
    
    PABatchUpdateRelationCarRequest * req = [[PABatchUpdateRelationCarRequest alloc]initWithCarNo:carNo updateCarNo:updateCarNo  communityID:communityId];
    @WeakObj(self);
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSDictionary * responseData = responseModel.data;
        NSLog(@"___%@_",responseData);
        if (selfWeak.delegagte && [selfWeak.delegagte respondsToSelector:@selector(requestUpdateBatchCompleted)]) {
            [selfWeak.delegagte requestUpdateBatchCompleted];
        }
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
        if (selfWeak.delegagte && [selfWeak.delegagte respondsToSelector:@selector(requestUpdateBatchCompleted)]) {
            [selfWeak.delegagte requestUpdateBatchCompleted];
        }
        
    }];
}
@end
