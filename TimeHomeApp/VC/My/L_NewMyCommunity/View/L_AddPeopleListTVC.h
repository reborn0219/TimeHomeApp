//
//  L_PeopleListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/29.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_AddPeopleListTVC : UITableViewCell

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 电话号
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;

/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
