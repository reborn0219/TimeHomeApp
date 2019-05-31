//
//  PAParkingSpaceService.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAParkingSpaceService.h"
#import "PAParkingSpaceRequest.h"
#import "PAParkingNoInCarListRquest.h"

@implementation PAParkingSpaceService

-(instancetype)init{
    self = [super init];
    if (self) {
    
    }
    return self;
}

#pragma mark ————— 拉取数据 —————
-(void)loadNoInCarData{
    
    AppDelegate * appdelegate = GetAppDelegates;
    //发起请求
    self.isLimited = NO;
    PAParkingNoInCarListRquest *req = [[PAParkingNoInCarListRquest alloc]initWithCommunityId:appdelegate.userData.communityid];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        NSDictionary * responseData = responseModel.data;
        NSLog(@"___车位车辆信息：%@__",responseData);
        NSString * isapp = [responseData objectForKey:@"limitapp"];
        self.isLimited = isapp.intValue;
        _carDataArray = [NSMutableArray yy_modelArrayWithClass:[PACarManagementModel class] json:responseData[@"parkingSpacesCarNoList"]].mutableCopy;
        
        if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestDataCompleted)]) {
            [self.delegagte requestDataCompleted];
        }
        
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
        if (_carDataArray == nil) {
            _carDataArray = [[NSMutableArray alloc]init];
        }
        if (self.delegagte && [self.delegagte respondsToSelector:@selector(requestDataCompleted)]) {
            [self.delegagte requestDataCompleted];
        }
        NSLog(@"%@",error);
    }];
    
}
@end
