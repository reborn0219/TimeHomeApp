//
//  L_ZJListsTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/7/19.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_ZJListsTVC.h"

@implementation L_ZJListsTVC

- (void)setModel:(L_RecordListModel *)model {
    
    _model = model;
    
    if (![XYString isBlankString:model.systime]) {
        
        if (model.systime.length >= 16) {
            self.rightDetail_Label.text = [model.systime substringToIndex:16];
        }else {
            self.rightDetail_Label.text = model.systime;
        }
        
    }else {
        self.rightDetail_Label.text = @"";
    }
    
    self.leftTitle_Label.text = [XYString IsNotNull:model.rewarddesc];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
