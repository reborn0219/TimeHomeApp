//
//  Ls_ActiveCell.h
//  TimeHomeApp
//
//  Created by 优思科技 on 17/1/17.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserActivity;
@interface Ls_ActiveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *activeLb;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (strong, nonatomic) UserActivity * activity;

@end
