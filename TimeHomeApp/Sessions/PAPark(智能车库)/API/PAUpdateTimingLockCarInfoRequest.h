//
//  PAUpdateTimingLockCarInfoRequest.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/18.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABaseRequest.h"
#import "PALockCarModel.h"

@interface PAUpdateTimingLockCarInfoRequest : PABaseRequest

///定时锁车保存
-(instancetype)initWithDetails:(PALockCarModel*)lockModel;

@end
