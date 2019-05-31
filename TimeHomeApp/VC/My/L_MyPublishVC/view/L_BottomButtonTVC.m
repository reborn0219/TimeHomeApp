//
//  L_BottomButtonTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BottomButtonTVC.h"

@interface L_BottomButtonTVC ()
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation L_BottomButtonTVC

- (void)setType:(NSInteger)type {
    _type = type;
    
    if (type == 1) {
        
        _shareButton.hidden = NO;

        _lineView.hidden = YES;

        _secondButton.hidden = YES;
        
        [_editButton setTitle:@"下架" forState:UIControlStateNormal];
        
        _leadingConstraint.constant = 0.;
        _widthConstraint.constant = 0;
        
    }else if (type == 2) {
        
        _lineView.hidden = NO;

        _secondButton.hidden = NO;
        
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];

        [_secondButton setTitle:@"删除" forState:UIControlStateNormal];

        _leadingConstraint.constant = 0.;
        _widthConstraint.constant = 60.;

        _shareButton.hidden = YES;
        
    }else {
        _shareButton.hidden = NO;

        _lineView.hidden = YES;
        _secondButton.hidden = YES;
        
        [_editButton setTitle:@"删除" forState:UIControlStateNormal];
        
        _leadingConstraint.constant = 0.;
        _widthConstraint.constant = 0;
    }
}

- (IBAction)threeButtonDidTouch:(UIButton *)sender {
    
    if (self.threeButtonDidClickBlock) {
        self.threeButtonDidClickBlock(sender.tag);
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.clipsToBounds = YES;
    _secondButton.hidden = YES;

    _shareButton.layer.borderWidth = 1;
    _shareButton.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
