//
//  L_NewBikeThirdTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L_BikeListModel.h"

typedef void(^ButtonDidTouchBlock)();
typedef void(^TextFieldBlock)(NSString *string);
/**
 输入框
 */
@interface L_NewBikeThirdTVC : UITableViewCell

@property (nonatomic, copy) ButtonDidTouchBlock buttonDidTouchBlock;

@property (nonatomic, copy) TextFieldBlock textFieldBlock;

/**
 左边小红星图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

/**
 左边标题label
 */
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;

/**
 输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *textField;

/**
 右边选择按钮宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonLayoutConstraint;

@property (nonatomic, strong) L_BikeListModel *model;

/**
 类型，车辆品牌==1，车辆颜色==2
 */
@property (nonatomic, assign) NSInteger type;

@end
