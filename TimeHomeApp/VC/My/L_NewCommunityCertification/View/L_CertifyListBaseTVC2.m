//
//  L_CertifyListBaseTVC2.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CertifyListBaseTVC2.h"

@implementation L_CertifyListBaseTVC2

- (void)setModel:(L_ResiCarListModel *)model {
    
    _model = model;
    
    _carNum_Label.text = [XYString IsNotNull:model.name];
    
    [self layoutIfNeeded];
    
    CGFloat rectY = CGRectGetMaxY(_carNum_Label.frame);
    model.height = rectY + 10;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _carNum_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 37 - 59 - 12;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
