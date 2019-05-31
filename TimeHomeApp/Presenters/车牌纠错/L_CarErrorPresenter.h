//
//  L_CarErrorPresenter.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/6/21.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BasePresenters.h"
#import "L_CorrgateModel.h"
#import "L_CarNumApplyListModel.h"

@interface L_CarErrorPresenter : BasePresenters

/**
 1.获得车牌纠错需要的门口 parkinglot/getcorrgate
 
 @param card 车牌号
 @param updataViewBlock updataViewBlock
 */
+ (void)getcorrgateWithCard:(NSString *)card updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 2.保存车牌纠错申请 carcorrection/saveapply
 
 @param card 车牌号
 @param aisleid 门口进口id
 @param updataViewBlock updataViewBlock
 */
+ (void)saveApplyWithCard:(NSString *)card withAisleid:(NSString *)aisleid updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 3.获得用户车牌纠错历史纪录 carcorrection/getuserapplylist
 
 @param page 页码
 @param updataViewBlock updataViewBlock
 */
+ (void)getUserApplyListWithPage:(int)page updataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 4.获得当前用户关联车牌列表 /car/getcorrcard
 
 @param updataViewBlock updataViewBlock
 */
+ (void)getCorrardUpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

/**
 5.获得当前车牌的保存状态 /car/getcardstate
 
 @param updataViewBlock updataViewBlock
 */
+ (void)getCardStateWithCard:(NSString *)card UpdataViewBlock:(UpDateViewsBlock)updataViewBlock;

@end
