//
//  PAParkingSpaceLockService.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/19.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceLockService.h"
#import "PACarSpaceLockRequest.h"
@implementation PACarSpaceLockService


/**
 解锁/锁车事件
 
 @param spaceId spaceId 车位ID
 @param carNo carNo 入库车牌号
 @param lockState lockState 锁车状态1锁 0未锁
 */

- (void)lockCarWithParkingSpaceId:(NSString *)spaceId carNo:(NSString *)carNo lockState:(NSInteger)lockState{
    
    PACarSpaceLockRequest * req = [[PACarSpaceLockRequest alloc]initWithPrkingSpaceId:spaceId carNo:carNo carLockState:lockState];
    
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        NSLog(@"%@",responseModel.data);
        if ([self.delegate respondsToSelector:@selector(loadDataSuccess)]) {
            [self.delegate loadDataSuccess];
        }
        if (self.successBlock) {
            self.successBlock(self);
        }
        

    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        NSLog(@"%@",error);
        

    }];
}
@end
