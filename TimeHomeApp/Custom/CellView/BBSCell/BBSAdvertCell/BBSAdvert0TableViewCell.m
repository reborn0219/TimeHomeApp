//
//  BBSAdvert0TableViewCell.m
//  TimeHomeApp
//
//  Created by UIOS on 2016/11/10.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BBSAdvert0TableViewCell.h"

#import "ImageUitls.h"

@implementation BBSAdvert0TableViewCell

- (void)setModel:(BBSModel *)model {
    _model = model;
    
    NSString *url = [NSString stringWithFormat:@"%@",model.picurl];
    [ImageUitls saveAndShowImage:self.backImg withName:url];
    
    // 在cell的模型属性set方法中调用[self layoutIfNeed]方法强制布局，然后计算出模型的cell height属性值
    
    [self layoutIfNeeded];
    
    float height = 10 + (SCREEN_WIDTH - 20) / 360 * 80;
    
    model.height = height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
