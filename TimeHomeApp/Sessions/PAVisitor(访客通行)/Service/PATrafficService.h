//
//  PATrafficService.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/5/17.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"

@interface PATrafficService : PABaseRequestService

- (void)saveData:(NSDictionary *)trafficInfo
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure;

@end
