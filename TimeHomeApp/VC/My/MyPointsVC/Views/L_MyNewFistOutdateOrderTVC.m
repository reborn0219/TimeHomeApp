//
//  L_MyNewFistOutdateOrderTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyNewFistOutdateOrderTVC.h"

@implementation L_MyNewFistOutdateOrderTVC

- (void)setModel:(L_ExchangeModel *)model {
    
    _model = model;
    
    /** 是否有图片 */
    if ([XYString isBlankString:model.picurl]) {
        _leftImageViewWidthLayoutConstraint.constant = 0;
        
        _leftLayout1.constant = 0;
        _leftLayout2.constant = 0;
        _leftLayout3.constant = 0;

    }else {
        _leftImageViewWidthLayoutConstraint.constant = 68;
        [_leftGoodImageView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:PLACEHOLDER_IMAGE];
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
    
    /** 是否已过期 */
    if (model.cancellstate.integerValue == -1) {
        /** 已过期 */
        _outdateLabel.hidden = NO;
    }else {
        _outdateLabel.hidden = YES;
    }
    
    /** 是否已使用 */
    if (model.isused.integerValue == 0) {
        _hasUseImageView.hidden = YES;
    }else {
        _hasUseImageView.hidden = NO;
    }
    
    model.height = 96;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _outdateLabel.hidden = YES;
    _hasUseImageView.hidden = YES;

    _shopNameLabel.text = @"";
    _goodNameLabel.text = @"";
    _timeLabel.text = @"";
    
    _bottomLineView.hidden = YES;

    self.backgroundColor = BLACKGROUND_COLOR;
    self.contentView.backgroundColor = BLACKGROUND_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
