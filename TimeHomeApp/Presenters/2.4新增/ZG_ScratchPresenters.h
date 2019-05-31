//
//  ZG_ScratchPresenters.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/7/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"

@interface ZG_ScratchPresenters : BasePresenters

/**
 获得抽奖页面中奖记录（/drawrecord/getsysrecordlist）
 */
+ (void)getSysrecordListWithUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 获得抽奖结果（/activitysign/draw）
 */
+ (void)getScratchWithReadyTime:(NSString *)readytime
                      frequency:(NSString *)frequency
                updataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
