//
//  IntelligentGaragePresenter.h
//  TimeHomeApp
//
//  Created by us on 16/2/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  智能车库逻辑处理类
 */
#import "BasePresenters.h"
#import "IntelligentGarageModel.h"

@interface IntelligentGaragePresenter : BasePresenters
/**
 *  车位数据
 */
@property(strong,nonatomic)NSMutableArray * arrGarages;

/**
 *  车位详情数据封装
 */
@property(strong,nonatomic)NSMutableArray * arrGarageDetail;

/**
 *  获取车库数据和车辆数据
 *
 *  @param updataViewBlock 更新视图回调
 */
-(void)getGaragesAndCarsData:(UpDateViewsBlock)updataViewBlock;


/**
 *  获取车库详情数据
 *
 *  @param updataViewBlock 更新视图回调
 */
-(void)getGaragesDetailData:(IntelligentGarageModel *)garageData callBack:(UpDateViewsBlock)updataViewBlock;


@end
