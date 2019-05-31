//
//  BBSAdvertTableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBSModel.h"

#import "bsstestbasemodel.h"

typedef void(^cityButtonDidClickBlock)(NSInteger index);

@interface BBSAdvertTableViewCell : UITableViewCell

@property (nonatomic, strong) BBSModel *model;

//广告帖包含三张图片的情况，高度235（文字少1行，高度减少18，屏幕宽度360）

@property (weak, nonatomic) IBOutlet UILabel *titleLal;

@property (weak, nonatomic) IBOutlet UILabel *infoLal;

@property (weak, nonatomic) IBOutlet UIImageView *redPaper;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redPaperLayout;

@property (weak, nonatomic) IBOutlet UIImageView *image1;

@property (weak, nonatomic) IBOutlet UIImageView *image2;

@property (weak, nonatomic) IBOutlet UIImageView *image3;

@property (weak, nonatomic) IBOutlet UILabel *tag1Lal;

@property (weak, nonatomic) IBOutlet UILabel *tag2Lal;

@property (weak, nonatomic) IBOutlet UILabel *commentLal;

@property (weak, nonatomic) IBOutlet UILabel *praiseLal;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@property (nonatomic, copy) cityButtonDidClickBlock cityButtonDidClickBlock;

@end
