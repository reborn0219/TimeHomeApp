//
//  Ls_DataStatisticsPresenter.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2017/7/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"

@interface Ls_DataStatisticsPresenter : BasePresenters

/**
 运营自定义推送统计接口

 @param pushid 推送ID
 @param updataViewBlock 回调
 */

+ (void)addPushStatistics:(NSString *)pushid updataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 推送点击统计

 @param theID 推送消息ID
 @param updataViewBlock 回调
 */
+ (void)addPushClickStatistics:(NSString *)theID updataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
