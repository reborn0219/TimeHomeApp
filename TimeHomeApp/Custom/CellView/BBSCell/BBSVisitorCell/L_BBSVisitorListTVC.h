//
//  L_BBSVisitorListTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BBSVisitorsModel.h"

typedef void(^HeaderDidTouchBlock)();

/**
 访客列表cell
 */
@interface L_BBSVisitorListTVC : UITableViewCell

@property (nonatomic, strong) L_BBSVisitorsModel *model;

@property (nonatomic, copy) HeaderDidTouchBlock headerDidTouchBlock;

/**
 头像按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *headerButton;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
