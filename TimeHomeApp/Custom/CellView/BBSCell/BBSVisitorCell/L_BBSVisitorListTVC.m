//
//  L_BBSVisitorListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_BBSVisitorListTVC.h"

@implementation L_BBSVisitorListTVC

- (void)setModel:(L_BBSVisitorsModel *)model {
    
    _model = model;
    
    [_headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.picurl] forState:UIControlStateNormal placeholderImage:kHeaderPlaceHolder];
    
    _nickNameLabel.text = [XYString IsNotNull:model.nickname];
    _timeLabel.text = [XYString IsNotNull:model.accesstime];
    
}

- (IBAction)headerButtonDidTouch:(UIButton *)sender {
    
    if (self.headerDidTouchBlock) {
        self.headerDidTouchBlock();
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];

    _headerButton.clipsToBounds = YES;
    _headerButton.layer.cornerRadius = 27.;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
