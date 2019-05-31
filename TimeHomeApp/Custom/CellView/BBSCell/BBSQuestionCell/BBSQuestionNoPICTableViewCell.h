//
//  BBSQuestionNoPICTableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBSModel.h"

#import "bsstestbasemodel.h"

typedef void(^cityButtonDidClickBlock)(NSInteger index);

typedef void(^commButtonDidClickBlock)(NSInteger index);

@interface BBSQuestionNoPICTableViewCell : UITableViewCell

@property (nonatomic, strong) BBSModel *model;

//问答帖不包含图片的情况，高度203（文字少1行，高度减少18，若文字显示完全高度再减少15，屏幕宽度360）

@property (weak, nonatomic) IBOutlet UILabel *titleLal;

@property (weak, nonatomic) IBOutlet UILabel *infoLal;

@property (weak, nonatomic) IBOutlet UIImageView *backRight;

@property (weak, nonatomic) IBOutlet UIImageView *backLeft;

@property (weak, nonatomic) IBOutlet UILabel *moneyLal;

@property (weak, nonatomic) IBOutlet UIImageView *headView;

@property (weak, nonatomic) IBOutlet UILabel *nameLal;

@property (weak, nonatomic) IBOutlet UILabel *commentLal;

@property (weak, nonatomic) IBOutlet UILabel *praiseLal;

@property (weak, nonatomic) IBOutlet UILabel *allTextLal;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allTextLayout;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@property (assign ,nonatomic) NSInteger type;
@property (assign ,nonatomic) NSInteger top;

@property (weak, nonatomic) IBOutlet UILabel *topTag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@property (nonatomic, copy) cityButtonDidClickBlock cityButtonDidClickBlock;

/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *l_timeLabel;

@property (nonatomic, copy) commButtonDidClickBlock commButtonDidClickBlock;
/**
 时间可隐藏
 */
@property (weak, nonatomic) IBOutlet UILabel *timeHideLal;
/**
 城市图标宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityImgWidth;
/**
 小区列表跳转
 */
@property (weak, nonatomic) IBOutlet UIButton *cityList;
/**
 小区图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *commImg;

@end
