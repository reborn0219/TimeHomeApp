//
//  L_MyInfoBaseTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_MyInfoBaseTVC : UITableViewCell

/**
 左边图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

/**
 左边label
 */
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

/**
 右边小红点
 */
@property (weak, nonatomic) IBOutlet UIView *dotView;

/**
 右边箭头图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageTraingConstraint;

/**
 底部分割线
 */
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;


@end
