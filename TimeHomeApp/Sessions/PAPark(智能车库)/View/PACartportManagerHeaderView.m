//
//  PACartportManagerHeaderView.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACartportManagerHeaderView.h"

@interface PACartportManagerHeaderView ()
@property (nonatomic, strong)UILabel * headNameLabel;
@property (nonatomic, strong)UIButton * addButton;

@end

@implementation PACartportManagerHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews{
    
    [self addSubview:self.headNameLabel];
    [self addSubview:self.addButton];
    
    [self.headNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(14);
        make.centerY.equalTo(self);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-14);
        make.centerY.equalTo(self);
    }];
}

#pragma mark Lazyload

- (UILabel *)headNameLabel{
    if (!_headNameLabel) {
        _headNameLabel = [[UILabel alloc]init];
        _headNameLabel.font = [UIFont systemFontOfSize:18];
        _headNameLabel.textColor = UIColorHex(0x4A4A4A);
    }
    return _headNameLabel;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"clsz_button_add_n"] forState:UIControlStateNormal];
    }
    return _addButton;
}


@end
