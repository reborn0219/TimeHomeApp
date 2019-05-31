//
//  L_ExchangeListTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/15.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_ExchangeListTVC.h"

@implementation L_ExchangeListTVC

- (void)setModel:(L_ExchangeModel *)model {
    
    _model = model;
    
    if (model.cancellstate.integerValue == -1) {
        /** 已过期 */
        _timeLabel.textColor = TEXT_COLOR;
        _orderLabel.textColor = TEXT_COLOR;
        _contentLabel.textColor = TEXT_COLOR;
        _outDateLabel.textColor = TITLE_TEXT_COLOR;
        _outDateLabel.hidden = NO;
        _lineView2.hidden = NO;
        _hasUseImageView.hidden = YES;

    }else {
        _timeLabel.textColor = TITLE_TEXT_COLOR;
        _orderLabel.textColor = NEW_BLUE_COLOR;
        _contentLabel.textColor = TITLE_TEXT_COLOR;
        _outDateLabel.textColor = CLEARCOLOR;
        _outDateLabel.hidden = YES;
        _lineView2.hidden = YES;
        _hasUseImageView.hidden = YES;
    }
    
    if (model.isused.integerValue == 0) {
        _hasUseImageView.hidden = YES;
    }else {
        _hasUseImageView.hidden = NO;
    }
    
    if ([XYString isBlankString:model.ordernum]) {
        _orderLabel.text = @"";
    }else {
        _orderLabel.text = [NSString stringWithFormat:@"订单编号:%@",model.ordernum];
    }
    
    _contentLabel.text = [XYString IsNotNull:model.goodsname];
    
    if ([XYString isBlankString:model.picurl]) {
        _infoImageWidthConstraint.constant = 0;
    }else {
        _infoImageWidthConstraint.constant = 60;
        [_infoImageView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:PLACEHOLDER_IMAGE];
    }
    
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
    
    NSString *forthTime = [startTime substringToIndex:4];
    if ([forthTime isEqualToString:@"1970"]) {
        _lineView1.hidden = YES;
        _bottomBgView.hidden = YES;
        model.height = 88;

    }else {
        _lineView1.hidden = NO;
        _bottomBgView.hidden = NO;
        model.height = 125;

    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _timeLabel.textColor = CLEARCOLOR;
    _orderLabel.textColor = CLEARCOLOR;
    _contentLabel.textColor = CLEARCOLOR;
    _outDateLabel.textColor = CLEARCOLOR;
    
    _outDateLabel.hidden = YES;
    _lineView2.hidden = YES;
    _hasUseImageView.hidden = YES;
    
    _infoImageView.layer.borderWidth = 1.f;
    _infoImageView.layer.borderColor = LINE_COLOR.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
