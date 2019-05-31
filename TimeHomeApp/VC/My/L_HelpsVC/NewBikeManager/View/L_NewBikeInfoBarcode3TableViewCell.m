//
//  L_NewBikeInfoBarcode3TableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/1/20.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_NewBikeInfoBarcode3TableViewCell.h"

@implementation L_NewBikeInfoBarcode3TableViewCell

- (void)setDeviceModel:(L_BikeDeviceModel *)deviceModel {
    
    _deviceModel = deviceModel;
    
    _codeNumLabel.text = deviceModel.deviceno;
    
    [self layoutIfNeeded];
    
    CGFloat bottomY = CGRectGetMaxY(_codeNumLabel.frame);
    
    deviceModel.rowHeight = bottomY + 10;
}


- (void)awakeFromNib {
    [super awakeFromNib];

    //114 + 30 + 5
    _codeNumLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - (114 + 30 + 5);

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
