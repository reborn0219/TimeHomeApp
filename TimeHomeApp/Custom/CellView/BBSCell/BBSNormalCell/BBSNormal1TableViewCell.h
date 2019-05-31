//
//  BBSNormal1TableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBSModel.h"

#import "bsstestbasemodel.h"

typedef void(^PraiseButtonDidClickBlock)(NSInteger index);

typedef void(^cityButtonDidClickBlock)(NSInteger index);

typedef void(^commButtonDidClickBlock)(NSInteger index);

@interface BBSNormal1TableViewCell : UITableViewCell

@property (nonatomic, copy) PraiseButtonDidClickBlock praiseButtonDidClickBlock;

//普通帖包含一张图片的情况，高度337（不管文字几行，屏幕宽度360）

@property (nonatomic, strong) BBSModel *model;

@property (weak, nonatomic) IBOutlet UILabel *infoLal;

@property (weak, nonatomic) IBOutlet UIImageView *redPaper;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redPaperLayout;

@property (weak, nonatomic) IBOutlet UIImageView *image1;

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
