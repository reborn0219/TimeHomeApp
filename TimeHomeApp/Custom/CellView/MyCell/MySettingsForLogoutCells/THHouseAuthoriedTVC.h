//
//  THHouseAuthoriedTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  在车位权限和房产权限界面使用过（暂时废弃）
 *
 *  @param NSInteger
 *  @param TextColor
 *
 *  @return 
 */
#import "THABaseTableViewCell.h"
typedef NS_ENUM(NSInteger, RightLabelStyle) {
    /**
     *  默认
     */
    RightLabelStyleDefault = 0,
    /**
     *  红色背景
     */
    RightLabelStyleRedBackground = 1,
    /**
     *  车位cell
     */
    RightLabelStyleCarBackground = 2,

};

typedef NS_ENUM(NSInteger, TextColor) {
    /**
     *  红色
     */
    TextColorRedColor = 0,
    /**
     *  蓝色
     */
    TextColorBlueColor = 1,
    /**
     *  绿色
     */
    TextColorGreenColor = 2,
};

@interface THHouseAuthoriedTVC : UITableViewCell
/**
 *  右边箭头图片
 */
@property (nonatomic, strong) UIImageView *arrowImage;
/**
 *  右边label
 */
@property (nonatomic, strong) UILabel *rightLabel;
/**
 *  左边label
 */
@property (nonatomic, strong) UILabel *leftLabel;
/**
 *  颜色枚举类型
 */
@property (nonatomic, assign) NSInteger textColor;
/**
 *  右边label枚举类型
 */
@property (nonatomic, assign) RightLabelStyle rightLabelStyle;
@end
