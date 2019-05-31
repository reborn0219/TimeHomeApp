//
//  qusetionSecondTableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/17.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@interface qusetionSecondTableViewCell : UITableViewCell

@property (nonatomic, strong) QuestionModel *model;

@property (weak, nonatomic) IBOutlet UILabel *titleLal;

@property (weak, nonatomic) IBOutlet UILabel *infoLal;

@property (weak, nonatomic) IBOutlet UIImageView *backRight;

@property (weak, nonatomic) IBOutlet UIImageView *backLeft;

@property (weak, nonatomic) IBOutlet UILabel *moneyLal;

@end
