//
//  L_MyHeaderInfoTVC.h
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RandButtonDidClick)();
typedef void(^SignOnBlock)();
@interface L_MyHeaderInfoTVC : UITableViewCell


/**
 个人信息model
 */
@property (nonatomic, strong) UserData *model;
/**
 等级按钮点击
 */
@property (nonatomic, copy) RandButtonDidClick randButtonDidClick;
/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

/**
 昵称label
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 电话号码label
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

/**
 等级数label
 */
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

/**
 年龄背景view
 */
@property (weak, nonatomic) IBOutlet UIView *ageBackgroundView;

/**
 年龄label
 */
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

/**
 性别图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

//--------------业主认证or实名认证-------------------
/**
 第一个图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

/**
 第一个label
 */
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

/**
 第二个图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;

/**
 第二个label
 */
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

/**
 签到
 */
@property (weak, nonatomic) IBOutlet UIButton *signonButton;
@property (copy,nonatomic)SignOnBlock signOnBlock;
@end
