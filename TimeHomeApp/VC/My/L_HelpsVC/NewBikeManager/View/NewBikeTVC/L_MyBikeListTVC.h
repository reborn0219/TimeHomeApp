//
//  L_MyBikeListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BikeListModel.h"

@interface L_MyBikeListTVC : UITableViewCell

/**
 二轮车品牌
 */
@property (weak, nonatomic) IBOutlet UILabel *bikeBrand_Label;

/**
 二轮车类型
 */
@property (weak, nonatomic) IBOutlet UILabel *bikeType_Label;

/**
 社区名称
 */
@property (weak, nonatomic) IBOutlet UILabel *communityName_Label;

@property (weak, nonatomic) IBOutlet UIImageView *bottomLeft_ImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeft_Label;

@property (weak, nonatomic) IBOutlet UILabel *bottomMiddle_Label;
@property (weak, nonatomic) IBOutlet UIImageView *bottomMiddle_ImageView;

@property (weak, nonatomic) IBOutlet UILabel *bottomRight_Label;
@property (weak, nonatomic) IBOutlet UIImageView *bottomRight_ImageView;

@property (nonatomic, strong) L_BikeListModel *model;

@property (nonatomic, copy) ViewsEventBlock btnDidClickBlock;

@end
