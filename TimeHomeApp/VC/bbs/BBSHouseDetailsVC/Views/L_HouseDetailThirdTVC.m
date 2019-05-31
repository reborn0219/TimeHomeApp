//
//  L_HouseDetailThirdTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/13.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseDetailThirdTVC.h"

@implementation L_HouseDetailThirdTVC

- (void)setModel:(L_HouseDetailModel *)model {
    
    _model = model;
    
    _contentLabel.text = [XYString IsNotNull:model.content];
    
    [self layoutIfNeeded];
    
    CGFloat rectY = CGRectGetMaxY(_contentLabel.frame);
    
    model.secondHeight = rectY + 8;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 16 - 20;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
