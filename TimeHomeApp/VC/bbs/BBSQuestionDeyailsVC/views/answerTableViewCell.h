//
//  answerTableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionAnswerModel.h"

typedef void(^AllButtonDidTouchBlock)(NSInteger buttonIndex);

@interface answerTableViewCell : UITableViewCell

@property (nonatomic, strong) QuestionAnswerModel *model;

@property (nonatomic, copy) AllButtonDidTouchBlock allButtonDidTouchBlock;

@property (weak, nonatomic) IBOutlet UILabel *tagLal;

@property (weak, nonatomic) IBOutlet UIImageView *tagImg;

@property (weak, nonatomic) IBOutlet UIButton *headerBt;

@property (weak, nonatomic) IBOutlet UILabel *infoLal;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *timeLal;

@property (weak, nonatomic) IBOutlet UIImageView *commentImg;

@property (weak, nonatomic) IBOutlet UILabel *commentcount;

@property (weak, nonatomic) IBOutlet UIImageView *praiseImg;

@property (weak, nonatomic) IBOutlet UILabel *praisecount;

@property (weak, nonatomic) IBOutlet UIButton *acceptBt;

@property (weak, nonatomic) IBOutlet UIButton *questionBt;

@property (weak, nonatomic) IBOutlet UIView *line;

@end
