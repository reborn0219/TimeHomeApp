//
//  L_OrderTimeTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_ExchangeModel.h"

@interface L_OrderTimeTVC : UITableViewCell

@property (nonatomic, strong) L_ExchangeModel *model;

/**
 时间图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;

/**
 赠予时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickName;

@end
