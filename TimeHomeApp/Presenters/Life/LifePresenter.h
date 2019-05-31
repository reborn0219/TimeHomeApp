//
//  LifePresenter.h
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "PMDataModel.h"

@interface LifePresenter : BasePresenters
/**
 *  物业管理分类数据
 */
@property(nonatomic,strong) NSMutableArray * LifeDataArray;

/**
 *  处理物业分类数据并更新View
 *
 *  @param updataViewBlock 更新回调
 */
-(void)getLifeData:(UpDateViewsBlock)updataViewBlock;
@end
