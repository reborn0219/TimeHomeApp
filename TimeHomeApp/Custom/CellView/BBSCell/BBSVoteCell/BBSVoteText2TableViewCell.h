//
//  BBSVoteText2TableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bsstestbasemodel.h"

#import "BBSModel.h"

typedef void(^cityButtonDidClickBlock)(NSInteger index);

@interface BBSVoteText2TableViewCell : UITableViewCell

@property (nonatomic, strong) BBSModel *model;

@property (weak, nonatomic) IBOutlet UILabel *infoLal;

@property (weak, nonatomic) IBOutlet UIImageView *redPaper;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redPaperLayout;

@property (weak, nonatomic) IBOutlet UILabel *voteNumber1Lal;

@property (weak, nonatomic) IBOutlet UILabel *voteInfo1Lal;

@property (weak, nonatomic) IBOutlet UIView *back1View;

@property (weak, nonatomic) IBOutlet UIView *red1View;

@property (weak, nonatomic) IBOutlet UIImageView *whitePoint1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voteNoWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *red1ViewLayout;

@property (weak, nonatomic) IBOutlet UILabel *voteNumber2Lal;

@property (weak, nonatomic) IBOutlet UILabel *voteInfo2Lal;

@property (weak, nonatomic) IBOutlet UIView *back2View;

@property (weak, nonatomic) IBOutlet UIView *red2View;

@property (weak, nonatomic) IBOutlet UIImageView *whitePoint2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *red2ViewLayout;

@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UILabel *tagLal;

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

@end
