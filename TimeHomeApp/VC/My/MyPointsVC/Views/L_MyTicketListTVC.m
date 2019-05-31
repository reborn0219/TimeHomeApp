//
//  L_MyTicketListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyTicketListTVC.h"

@implementation L_MyTicketListTVC

- (void)setModel:(L_MyCertificateModel *)model {
    
    _model = model;
    
    if ([XYString isBlankString:model.number]) {
        _usedTicketLabel.text = @"可使用卡券：0";
    }else {
        _usedTicketLabel.text = [NSString stringWithFormat:@"可使用卡券：%@",model.number];
    }
    
    _leftGoodImageView.image = [UIImage imageNamed:@"赠予券图标"];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = BLACKGROUND_COLOR;
    self.contentView.backgroundColor = BLACKGROUND_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
