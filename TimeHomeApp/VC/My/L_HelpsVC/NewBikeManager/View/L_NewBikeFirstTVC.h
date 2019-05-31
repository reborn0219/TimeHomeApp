//
//  L_NewBikeFirstTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BikeListModel.h"

/**
 选择社区样式
 */
@interface L_NewBikeFirstTVC : UITableViewCell

@property (nonatomic, assign) NSInteger type;

/**
 小区名称
 */
@property (weak, nonatomic) IBOutlet UILabel *communityName_Label;

/**
 左边标题label
 */
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;

/**
 右边箭头图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightArrowImageLayoutConstraint;

@property (nonatomic, strong) L_BikeListModel *model;

@end
