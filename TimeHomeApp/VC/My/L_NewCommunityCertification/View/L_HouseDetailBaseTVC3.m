//
//  L_HouseDetailBaseTVC3.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HouseDetailBaseTVC3.h"

@implementation L_HouseDetailBaseTVC3

- (void)setModel:(L_PowerListModel *)model {
    
    _model = model;
    
    _leftTitle_Label.text = [XYString IsNotNull:model.remarkname];
    _detail_Label.text = [XYString IsNotNull:model.phone];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
