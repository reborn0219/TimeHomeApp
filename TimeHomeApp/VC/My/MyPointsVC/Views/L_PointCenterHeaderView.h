//
//  L_PointCenterHeaderView.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AllButtonDidTouchBlock)(NSInteger buttonIndex);
@interface L_PointCenterHeaderView : UIView

@property (nonatomic, copy) AllButtonDidTouchBlock allButtonDidTouchBlock;

/**
 左边标题
 */
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;

/**
 积分
 */
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

/**
 兑换按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

+ (L_PointCenterHeaderView *)getInstance;

@end
