//
//  PANoticeService.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/24.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequestService.h"

@interface PANoticeService : PABaseRequestService

/**
 保存设备信息

 @param success success description
 @param failure failure description
 */
+ (void) saveDeviceInfoSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;


/**
 解绑设备信息

 @param success 成功
 @param failure 失败
 */
+ (void) unbindDeviceSuccess:(ServiceSuccessBlock)success failure:(ServiceFailedBlock)failure;
@end
