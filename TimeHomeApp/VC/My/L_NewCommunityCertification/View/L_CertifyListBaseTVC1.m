//
//  L_CertifyListBaseTVC1.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CertifyListBaseTVC1.h"

@implementation L_CertifyListBaseTVC1

- (void)setModel:(L_ResiListModel *)model {
    
    _model = model;
    
    _name_Label.text = [XYString IsNotNull:model.householder];
    _phone_Label.text = [XYString IsNotNull:model.phone];
    _community_Label.text = [XYString IsNotNull:model.communityname];
    _house_Label.text = [XYString IsNotNull:model.resiname];
    
    [self layoutIfNeeded];
    
    CGFloat rectY = CGRectGetMaxY(_house_Label.frame);
    model.height = rectY + 15;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _community_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 37 - 59 - 12;
    _house_Label.preferredMaxLayoutWidth = SCREEN_WIDTH - 37 - 59 - 12;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
