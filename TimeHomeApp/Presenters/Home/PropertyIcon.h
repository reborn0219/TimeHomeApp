//
//  PropertyIcon.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"

@interface PropertyIcon : BasePresenters



/**
 *  获得首页物业图标
 */
+ (void)getPropertyIconUpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  保存首页物业图标
 */
+ (void)savePropertyIconWithKeys:(NSString *)keys UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;
@end
