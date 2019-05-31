//
//  GarageCell.h
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  车位Cell
 */
#import <UIKit/UIKit.h>

@protocol GarageCellDelegate <NSObject>

/**
 *  锁车或联系车主回调
 *
 *  @param indexPath 点击的索引
 */
-(void)lockOrCallPhoneCarWithIndexPath:(NSIndexPath *) indexPath;

/**
 *  进车位详情回调
 *
 *  @param indexPath 点击的索引
 */
-(void)toGarageDetailWithIndexPath:(NSIndexPath *) indexPath;
/**
 *  删除车辆回调
 *
 *  @param indexPath 点击的索引
 */
-(void)delCarNumWithIndexPath:(NSIndexPath *) indexPath;
@end


@interface GarageCell : UICollectionViewCell
/**
 *  车牌号
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_CarNum;
/**
 *  车库名称
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_GarageName;
/**
 *  车位状态
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_CarState;
/**
 *  锁车
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_Lock;

/**
 *  协议声明，用于事件回调
 */
@property(weak,nonatomic) id <GarageCellDelegate> delegate;
/**
 *  所在索引
 */
@property(strong,nonatomic) NSIndexPath * indexPath;

@end
