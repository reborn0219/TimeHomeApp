//
//  L_NewBikeSecondTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeSecondTVC.h"

@interface L_NewBikeSecondTVC ()

@property (weak, nonatomic) IBOutlet UIView *firstRedView;
@property (weak, nonatomic) IBOutlet UIView *secondRedView;

@end

@implementation L_NewBikeSecondTVC

- (void)setModel:(L_BikeListModel *)model {
    _model = model;
    
    if ([model.devicetype isEqualToString:@"1"]) {
        
        _firstRedView.hidden = NO;
        _secondRedView.hidden = YES;
        
    }else {
        
        _firstRedView.hidden = YES;
        _secondRedView.hidden = NO;
    }
    
}

- (IBAction)twoButtonDidTouch:(UIButton *)sender {
    
    if (sender.tag == 1) {
        
        _firstRedView.hidden = NO;
        _secondRedView.hidden = YES;
        _model.devicetype = @"1";
        
    }else {
        
        _firstRedView.hidden = YES;
        _secondRedView.hidden = NO;
        _model.devicetype = @"0";

    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _firstRedView.hidden = NO;
    _secondRedView.hidden = NO;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
