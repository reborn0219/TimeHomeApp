//
//  YYCollectionPresent.h
//  TimeHomeApp
//
//  Created by 世博 on 16/7/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "UserPublishRoom.h"
#import "UserPublishCar.h"

@interface YYCollectionPresent : BasePresenters

/**
 *  新增收藏--0 二手信息 1 二手房产 2 二手车位
 */
+ (void)addSerfollowWithID:(NSString *)theID type:(NSString *)type UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;


/**
 *  删除收藏
 */
+ (void)removeSerfollowWithID:(NSString *)theID type:(NSString *)type UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得用户收藏的二手置换信息
 */
+ (void)getUserUsedInfoWithPage:(NSString *)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得用户收藏的二手房产信息
 */
+ (void)getUserResidenceInfoWithPage:(NSString *)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 *  获得用户收藏的二手车位信息
 */
+ (void)getUserCarrentalInfoWithPage:(NSString *)page UpDataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
