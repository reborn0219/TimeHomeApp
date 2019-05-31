//
//  ContactServiceCell.m
//  TimeHomeApp
//
//  Created by us on 16/3/3.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ContactServiceCell.h"

@implementation ContactServiceCell

- (void)setModel:(L_ContactPropertyModel *)model {
    
    _model = model;
    
    _lab_Name.text = [XYString IsNotNull:model.name];
    
    _lab_Phone.text = [XYString IsNotNull:model.telephone];
    
    _property_Label.text = [XYString IsNotNull:model.propertyname];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];

    _rightBtn.userInteractionEnabled = NO;
    
    _propertyBgView.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
    _propertyBgView.layer.borderWidth = 1.f;
    _propertyBgView.layer.cornerRadius = 9;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
