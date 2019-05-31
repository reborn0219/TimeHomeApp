//
//  L_NewPointTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserIntergralLog.h"

@interface L_NewPointTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

/**
 *  传递的model
 */
@property (nonatomic, strong) UserIntergralLog *model;

@end
