//
//  PMPresenter.h
//  TimeHomeApp
//
//  Created by us on 16/2/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  物业管理逻辑处理类
 */
#import "BasePresenters.h"
#import "PMDataModel.h"
@interface PMPresenter : BasePresenters
/**
 *  物业管理分类数据
 */
@property(nonatomic,strong) NSMutableArray * PMDataArray;

/**
 *  处理物业分类数据并更新View
 *
 *  @param updataViewBlock 更新回调
 */
-(void)getPMData:(UpDateViewsBlock)updataViewBlock;


//----------------访客通行---------------


@end
