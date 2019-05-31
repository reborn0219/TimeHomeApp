//
//  BBSHouseTableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBSModel.h"

#import "bsstestbasemodel.h"

typedef void(^PraiseButtonDidClickBlock)(NSInteger index);

typedef void(^cityButtonDidClickBlock)(NSInteger index);

typedef void(^commButtonDidClickBlock)(NSInteger index);

typedef void(^HouseOrCarDidClickBlock)(NSInteger index);

@interface BBSHouseTableViewCell : UITableViewCell

@property (nonatomic, copy) HouseOrCarDidClickBlock houseOrCarDidClickBlock;

@property (nonatomic, copy) PraiseButtonDidClickBlock praiseButtonDidClickBlock;

@property (nonatomic, strong) BBSModel *model;

//房产帖包含三张图片的情况，高度305（文字少1行，高度减少18，若不是房产出售帖高度再减少15，屏幕宽度360）

@property (weak, nonatomic) IBOutlet UILabel *tag1Lal;

@property (weak, nonatomic) IBOutlet UILabel *tag2Lal;

@property (weak, nonatomic) IBOutlet UILabel *infoLal;

@property (weak, nonatomic) IBOutlet UIImageView *redPaper;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redPaperLayout;

@property (weak, nonatomic) IBOutlet UIImageView *image1;

@property (weak, nonatomic) IBOutlet UIImageView *image2;

@property (weak, nonatomic) IBOutlet UIImageView *image3;

@property (weak, nonatomic) IBOutlet UILabel *squareLal;

@property (weak, nonatomic) IBOutlet UILabel *roomNoLal;

@property (weak, nonatomic) IBOutlet UILabel *pointHide;

@property (weak, nonatomic) IBOutlet UILabel *otherLal;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherLalLayout;

@property (weak, nonatomic) IBOutlet UILabel *moneyLal;

@property (weak, nonatomic) IBOutlet UILabel *unitlal;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unitLayout;

@property (weak, nonatomic) IBOutlet UIImageView *headView;

@property (weak, nonatomic) IBOutlet UILabel *nameLal;

@property (weak, nonatomic) IBOutlet UILabel *commentLal;

@property (weak, nonatomic) IBOutlet UILabel *praiseLal;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@property (assign ,nonatomic) NSInteger type;
@property (assign ,nonatomic) NSInteger top;

@property (weak, nonatomic) IBOutlet UILabel *topTag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

/** 右上角样式 默认红包 1==红色字体label 2==灰色字体label */
@property (nonatomic, assign) NSInteger rightTopStyle;

@property (nonatomic, copy) cityButtonDidClickBlock cityButtonDidClickBlock;

/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *l_timeLabel;

/**
 点赞图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *l_praiseImageView;

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
