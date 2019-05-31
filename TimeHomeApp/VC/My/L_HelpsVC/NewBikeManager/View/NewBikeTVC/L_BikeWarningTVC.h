//
//  L_BikeWarningTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BikeAlermModel.h"

@interface L_BikeWarningTVC : UITableViewCell

/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *time_Label;

/**
 社区名称
 */
@property (weak, nonatomic) IBOutlet UILabel *communityName_Label;

/**
 详细信息
 */
@property (weak, nonatomic) IBOutlet UILabel *detail_Label;

@property (nonatomic, strong) L_BikeAlermModel *model;

@end
