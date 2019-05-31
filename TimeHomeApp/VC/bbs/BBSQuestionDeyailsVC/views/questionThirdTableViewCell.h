//
//  questionThirdTableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

typedef void(^AllButtonDidTouchBlock)(NSInteger buttonIndex);

@interface questionThirdTableViewCell : UITableViewCell

@property (nonatomic, strong) QuestionModel *model;

@property (nonatomic, copy) AllButtonDidTouchBlock allButtonDidTouchBlock;

@property (weak, nonatomic) IBOutlet UILabel *answerLal;

@property (weak, nonatomic) IBOutlet UILabel *BrowseLal;

@end
