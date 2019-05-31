//
//  L_NewCommunityVertifyListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/29.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface L_NewCommunityVertifyListTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightImg;

/**
 红点
 */
@property (weak, nonatomic) IBOutlet UIView *dotImg;

/**
 分割线
 */
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
