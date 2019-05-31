//
//  CarStewardCell2.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/7/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CarStewardCell2.h"

@implementation CarStewardCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    _grayBgView.backgroundColor = BLACKGROUND_COLOR;
    _leftlabel1.textColor = TITLE_TEXT_COLOR;
    _rightLabel1.textColor = TITLE_TEXT_COLOR;
    
    _leftLabel2.textColor = TEXT_COLOR;
    _rightLabel2.textColor = TEXT_COLOR;
}

//隐藏label
- (void)setLabelHidden {
    
   _leftShowLabel.hidden = YES;
    _rightShowLabel.hidden = YES;
}


//小号字体
- (void)setSmallLabelFontAndFrame {
    
    _leftlabel1.font = DEFAULT_FONT(12);
    _leftLabel2.font = DEFAULT_FONT(12);
    _leftImage.frame = CGRectMake(CGRectGetMaxX(self.leftLabel2.frame) + 9, CGRectGetMaxY(self.contentView.frame) + 3, 20, 20);
    _rightLabel1.font = DEFAULT_FONT(12);
    _rightLabel2.font = DEFAULT_FONT(12);
    _rightImage.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - 15, CGRectGetMinY(self.leftLabel2.frame), 15, 21);
}
//大号字体
- (void)setBigLabelFontAndFrame {
    
    _leftlabel1.font = DEFAULT_FONT(14);
    _leftLabel2.font = DEFAULT_FONT(14);
   _leftImage.frame = CGRectMake(CGRectGetMaxX(self.leftLabel2.frame) + 9, CGRectGetMaxY(self.contentView.frame) + 3, 30, 30);
    
    _rightLabel1.font = DEFAULT_FONT(14);
    _rightLabel2.font = DEFAULT_FONT(14);
    _rightImage.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame) - 30, CGRectGetMinY(self.leftLabel2.frame), 30, 30);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
