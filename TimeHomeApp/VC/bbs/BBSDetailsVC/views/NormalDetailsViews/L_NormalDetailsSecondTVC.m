//
//  L_NormalDetailsSecondTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NormalDetailsSecondTVC.h"

@interface L_NormalDetailsSecondTVC ()

/**
 间隔
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelAndRedButtonLayout;


@end

@implementation L_NormalDetailsSecondTVC

- (IBAction)redButtonDidTouch:(UIButton *)sender {
    
    if (self.redButtonDidTouchBlock) {
        self.redButtonDidTouchBlock();
    }
    
}


- (void)setModel:(L_NormalInfoModel *)model {
    _model = model;
    
    _contentLabel.text = model.content;
    
    if ([model.redtype isEqualToString:@"0"]) {
        
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 16 - 16 - 47 - 8;

        _redButton.hidden = NO;
        [_redButton setBackgroundImage:[UIImage imageNamed:@"邻趣-首页-红包图标"] forState:UIControlStateNormal];
        _redConstraint.constant = 47;
        _labelAndRedButtonLayout.constant = 8;

    }else if ([model.redtype isEqualToString:@"-1"]) {
        
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 16 - 16;

        _redButton.hidden = YES;
        [_redButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _redConstraint.constant = 0;
        _labelAndRedButtonLayout.constant = 0;

    }else {
        
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 16 - 16;

        _redButton.hidden = YES;
        [_redButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _redConstraint.constant = 0;
        _labelAndRedButtonLayout.constant = 0;

    }
    
    [self layoutIfNeeded];
    
    CGFloat rectY = CGRectGetMaxY(_contentLabel.frame);
    if (rectY > 47 + 5) {
        model.contentHeight = rectY + 8.;
    }else {
        
        if ([model.redtype isEqualToString:@"0"]) {
            
            model.contentHeight = 47 + 5 + 8.;
            
        }else {
            
            model.contentHeight = rectY + 8.;

        }
        
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 16 - 16;
    
    _contentLabel.text = @"";
    
    
    _redButton.hidden = YES;
    [_redButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    _redConstraint.constant = 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
