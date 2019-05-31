//
//  L_MyGivenPeopleListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_MyFollowersModel.h"

@interface L_MyGivenPeopleListTVC : UITableViewCell

@property (nonatomic, strong) L_MyFollowersModel *model;

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
