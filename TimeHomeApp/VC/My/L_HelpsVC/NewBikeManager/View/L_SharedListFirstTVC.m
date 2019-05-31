//
//  L_SharedListFirstTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/1/22.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_SharedListFirstTVC.h"

@implementation L_SharedListFirstTVC

- (void)setShareModel:(L_BikeShareInfoModel *)shareModel {
    
    _shareModel = shareModel;
    
    self.sharedPeopleNameLabel.text = [XYString IsNotNull:shareModel.sharename];
    self.sharedPeoplePhoneLabel.text = [XYString IsNotNull:shareModel.mobilephone];
    
    NSString *dateString = shareModel.sharetime;
    if (![XYString isBlankString:dateString]) {

        if (dateString.length >= 10) {
            self.sendAuthTimeLabel.text = [dateString substringToIndex:10];
        }else {
            self.sendAuthTimeLabel.text = dateString;
        }
        
    }else {
        self.sendAuthTimeLabel.text = @"";
    }
    
}

/**
 删除
 */
- (IBAction)deleteButtonDidTouch:(UIButton *)sender {
    
    if (self.deleteButtonTouchBlock) {
        self.deleteButtonTouchBlock();
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
