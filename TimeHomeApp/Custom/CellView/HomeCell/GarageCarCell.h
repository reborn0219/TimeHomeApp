//
//  GarageCarCell.h
//  TimeHomeApp
//
//  Created by us on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 *  车辆车牌Cell
 *
 */
#import <UIKit/UIKit.h>
#import "GarageCell.h"

@interface GarageCarCell : UICollectionViewCell
/**
 *  初始状态图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *img_InitIcon;
/**
 *  车牌
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_CarNum;
/**
 *  备注
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_DelCar;
/**
 *  删除按钮
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_Remarks;
/**
 *  协议声明，用于删除回调
 */
@property(weak,nonatomic) id <GarageCellDelegate> delegate;
/**
 *  所在索引
 */
@property(strong,nonatomic) NSIndexPath * indexPath;

@end
