//
//  L_NewBikeFirstTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeFirstTVC.h"

@implementation L_NewBikeFirstTVC

- (void)setModel:(L_BikeListModel *)model {
    _model = model;
    
    if (_type == 1) {
        
        self.leftTitleLabel.text = @"选择社区";
        if ([XYString isBlankString:model.communityname]) {
            self.communityName_Label.text = @"选择社区";
        }else {
            self.communityName_Label.text = model.communityname;
        }
        
        self.rightArrowImageLayoutConstraint.constant = 18;

    }
    
    if (_type == 3) {
        
        self.leftTitleLabel.text = @"所属社区";
        if ([XYString isBlankString:model.communityname]) {
            self.communityName_Label.text = @"选择社区";
        }else {
            self.communityName_Label.text = model.communityname;
        }
        
        self.rightArrowImageLayoutConstraint.constant = 18;
        
    }
    
    if (_type == 2) {
        
        self.leftTitleLabel.text = @"车辆编码";
        self.communityName_Label.text = [XYString IsNotNull:model.bikeno];
        self.rightArrowImageLayoutConstraint.constant = 0;
        
        if ([XYString isBlankString:self.communityName_Label.text]) {
            model.motifyBikenoRowHeight = 50;
        }else {
            [self layoutIfNeeded];
            CGFloat rectY = CGRectGetHeight(_communityName_Label.frame);
            model.motifyBikenoRowHeight = rectY + 20;
        }
        
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.communityName_Label.preferredMaxLayoutWidth = 141;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
