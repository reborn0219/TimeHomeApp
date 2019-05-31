//
//  PAParkingSpaceRevokeService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/20.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"

@interface PACarSpaceRevokeService : PABaseRequestService


/**
 撤销出租车位

 @param spaceId spaceId description
 @param success success description
 @param failure failure description
 */
+ (void)revokeParkingSpaceWithSpaceId:(NSString *)spaceId
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;
@end
