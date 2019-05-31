//
//  L_NewBikeBottomViewTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeBottomViewTVC.h"

@implementation L_NewBikeBottomViewTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)titleButtonDidTouch:(UIButton *)sender {
    
    if (self.titleDidTouchBlock) {
        self.titleDidTouchBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
