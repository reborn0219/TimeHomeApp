//
//  L_NormalDetailsSecondTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "L_NormalInfoModel.h"

typedef void(^RedButtonDidTouchBlock)();

@interface L_NormalDetailsSecondTVC : UITableViewCell

@property (nonatomic, copy) RedButtonDidTouchBlock redButtonDidTouchBlock;

/**
 内容
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) L_NormalInfoModel *model;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redConstraint;

@end
