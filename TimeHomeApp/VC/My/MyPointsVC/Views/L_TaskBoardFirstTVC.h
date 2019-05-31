//
//  L_TaskBoardFirstTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_TaskModel.h"

typedef void(^ButtonDidTouchBlock)();
@interface L_TaskBoardFirstTVC : UITableViewCell

@property (nonatomic, copy) ButtonDidTouchBlock buttonDidTouchBlock;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttonBottomLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonBgView;

@property (nonatomic, strong) L_TaskModel *model;

@end
