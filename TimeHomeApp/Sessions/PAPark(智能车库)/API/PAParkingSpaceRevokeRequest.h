//
//  PAParkingSpaceRevokeRequest.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/20.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"


/**
 撤租车位
 */
@interface PACarSpaceRevokeRequest : PABaseRequest

- (instancetype) initWithSpaceId:(NSString *)spaceId;
@end
