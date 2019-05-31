//
//  questionImgTableViewCell.h
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/17.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

typedef void(^AllButtonDidTouchBlock)(NSInteger buttonIndex);

@interface questionImgTableViewCell : UITableViewCell

@property (nonatomic, strong) QuestionModel *model;

@property (nonatomic, copy) AllButtonDidTouchBlock allButtonDidTouchBlock;

@property (nonatomic, strong) NSArray *picList;

@property (weak, nonatomic) IBOutlet UIImageView *imgView1;

@property (weak, nonatomic) IBOutlet UIImageView *imgView2;

@property (weak, nonatomic) IBOutlet UIImageView *imgView3;

@end
