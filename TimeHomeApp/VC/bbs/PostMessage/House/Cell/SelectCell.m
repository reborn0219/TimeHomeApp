//
//  SelectCell.m
//  Bessel
//
//  Created by 赵思雨 on 2016/11/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SelectCell.h"

@implementation SelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //  
}
- (void)setIsSelected:(BOOL)isSelected {
    isSelected = _isSelected;
    
    if (isSelected) {
        NSLog(@"1");
    }else {
        NSLog(@"2");
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
