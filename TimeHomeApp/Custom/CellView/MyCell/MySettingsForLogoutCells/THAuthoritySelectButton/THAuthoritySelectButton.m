//
//  THAuthoritySelectButton.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THAuthoritySelectButton.h"

@implementation THAuthoritySelectButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _leftImageView = [[UIImageView alloc]init];
    [self addSubview:_leftImageView];
//    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(WidthSpace(36)));
//        make.width.equalTo(@(WidthSpace(36)));
//        make.left.equalTo(self).offset(WidthSpace(22));
//        make.centerY.equalTo(self.mas_centerY);
//    }];
    _leftImageView.sd_layout.heightIs(WidthSpace(36)).widthEqualToHeight().leftSpaceToView(self,WidthSpace(22)).centerYEqualToView(self);
    
    _leftLabel = [[UILabel alloc]init];
    _leftLabel.textColor = TITLE_TEXT_COLOR;
    _leftLabel.font = DEFAULT_FONT(16);
    [self addSubview:_leftLabel];
    _leftLabel.sd_layout.leftSpaceToView(_leftImageView,10).centerYEqualToView(self).widthIs(60).heightIs(20);
    
    _rightImageView = [[UIImageView alloc]init];
    [self addSubview:_rightImageView];
    _rightImageView.sd_layout.rightSpaceToView(self,10).centerYEqualToView(self).widthIs(WidthSpace(28)).heightEqualToWidth();
    
}
- (void)setLeftLabel:(UILabel *)leftLabel {
    _leftLabel = leftLabel;

}

@end
