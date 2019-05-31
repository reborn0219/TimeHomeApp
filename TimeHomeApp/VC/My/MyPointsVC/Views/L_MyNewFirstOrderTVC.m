//
//  L_MyNewFirstOrderTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyNewFirstOrderTVC.h"

@implementation L_MyNewFirstOrderTVC

- (void)setModel:(L_ExchangeModel *)model {
    
    _model = model;

    /** 是否有图片 */
    if ([XYString isBlankString:model.picurl]) {
        _leftImageWidthLayoutConstraint.constant = 0;
        
        _leftLayout1.constant = 0;
        _leftLayout2.constant = 0;
        _leftLayout3.constant = 0;

    }else {
        _leftImageWidthLayoutConstraint.constant = 63;
        [_leftShopImageView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:PLACEHOLDER_IMAGE];
        
        _leftLayout1.constant = 8;
        _leftLayout2.constant = 8;
        _leftLayout3.constant = 8;
    }
    
    /** 店家名称 */
    _shopNameLabel.text = [XYString IsNotNull:model.merchantname];
    
    /** 商品名称 */
    _goodNameLabel.text = [XYString IsNotNull:model.goodsname];

    /** 有效期 */
    NSString *startTime = @"";
    if (model.starttime.length > 10) {
        startTime = [model.starttime substringToIndex:10];
    }else {
        startTime = model.starttime;
    }
    NSString *endTime = @"";
    if (model.endtime.length > 10) {
        endTime = [model.endtime substringToIndex:10];
    }else {
        endTime = model.endtime;
    }
    _timeLabel.text = [NSString stringWithFormat:@"有效期 %@ — %@",startTime,endTime];
    if ([XYString isBlankString:startTime] && [XYString isBlankString:endTime]) {
        _timeLabel.hidden = YES;
        _timeImageView.hidden = YES;
    }else {
        _timeLabel.hidden = NO;
        _timeImageView.hidden = NO;
    }
    
    /** 是否即将过期，0否1是 */
    if (model.istodate.integerValue == 0) {
        _willOutdateLabel.hidden = YES;
        model.height = 86;
    }else {
        _willOutdateLabel.hidden = NO;
        model.height = 120;
    }
    
    /** 是否可赠予，0否1是 */
    if (model.ispresent.integerValue == 0) {
        _givenButton.hidden = YES;

    }else {
        _givenButton.hidden = NO;

    }
    
}

/**
 赠予按钮点击
 */
- (IBAction)givenButtonDidTouch:(UIButton *)sender {
    if (self.givenButtonDidTouchBlock) {
        self.givenButtonDidTouchBlock();
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    _willOutdateLabel.hidden = YES;
    _shopNameLabel.text = @"";
    _goodNameLabel.text = @"";
    _timeLabel.text = @"";

    _bottomLineView.hidden = YES;
    
    _givenButton.hidden = YES;
    
    self.backgroundColor = BLACKGROUND_COLOR;
    self.contentView.backgroundColor = BLACKGROUND_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
