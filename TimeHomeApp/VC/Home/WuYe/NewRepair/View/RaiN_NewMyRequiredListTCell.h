//
//  RaiN_NewMyRequiredListTCell.h
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserReserveInfo.h"
@interface RaiN_NewMyRequiredListTCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
/**
 *  报修model
 */
@property (nonatomic, strong) UserReserveInfo *model;
@end
