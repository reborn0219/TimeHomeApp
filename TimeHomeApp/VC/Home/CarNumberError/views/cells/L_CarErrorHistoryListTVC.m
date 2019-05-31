//
//  L_CarErrorHistoryListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/6/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_CarErrorHistoryListTVC.h"



@implementation L_CarErrorHistoryListTVC

- (void)setListModel:(L_CarNumApplyListModel *)listModel {
    
    _listModel = listModel;
    
    _phoneNum_Label.text = [XYString IsNotNull:listModel.phone];
    
    _carNum_Label.text = [XYString IsNotNull:listModel.card];
    
    _gate_Label.text = [XYString IsNotNull:listModel.aislename];
    
    if (listModel.systime.length > 19) {
        _applyTime_Label.text = [listModel.systime substringToIndex:19];
    }else {
        _applyTime_Label.text = [XYString IsNotNull:listModel.systime];
    }
    
    /**
     状态 0 待审核 1 通过 2 未通过
     */
    if (listModel.flag.intValue == 0) {
        
        _state_Label.text = @"待审核";
        _state_Label.textColor = kNewRedColor;
        _state_ImageView.hidden = NO;
        _state_ImageView.image = [UIImage imageNamed:@"车牌纠错-待审核"];
        
    }else if (listModel.flag.intValue == 1) {
        
        _state_Label.text = @"通过";
        _state_Label.textColor = TEXT_COLOR;
        _state_ImageView.hidden = NO;
        _state_ImageView.image = [UIImage imageNamed:@"车牌纠错-通过图标"];
        
    }else if (listModel.flag.intValue == 2) {
        
        _state_Label.text = @"未通过";
        _state_Label.textColor = TEXT_COLOR;
        _state_ImageView.hidden = YES;
        
    }else {
        _state_Label.hidden = YES;
        _state_ImageView.hidden = YES;
    }
    
    [self layoutIfNeeded];
    
    CGFloat maxY = CGRectGetMaxY(_bottom_Label.frame);
    
    listModel.height = maxY + 15;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = BLACKGROUND_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
