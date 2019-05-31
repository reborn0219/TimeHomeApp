//
//  PATimingLockCarInfo.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/13.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"

@interface PATimingLockCarRequest : PABaseRequest
///定时锁车详情接口
-(instancetype)initWithId:(NSString*)lockID;
@end
