//
//  PACartportManagerHeaderView.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceDetialHeaderView.h"

@interface PACarSpaceDetialHeaderView ()
@property (nonatomic, strong)UILabel * headNameLabel;
@property (nonatomic, strong)UIButton * addButton;

@end

@implementation PACarSpaceDetialHeaderView

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
    
    self.backgroundColor = [UIColor whiteColor];
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
    
    UIView * style = [[UIView alloc]init];
    style.backgroundColor = UIColorHex(0xF5F5F5);
;
    [self addSubview:style];
    [style mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    
}

#pragma mark Lazyload

- (UILabel *)headNameLabel{
    if (!_headNameLabel) {
        _headNameLabel = [[UILabel alloc]init];
        _headNameLabel.font = [UIFont systemFontOfSize:18];
        _headNameLabel.textColor = UIColorHex(0x4A4A4A);
        _headNameLabel.text = @"已关联车辆";
    }
    return _headNameLabel;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"clsz_button_add_n"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addCarAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (void)addCarAction:(UIButton *)sender{
    if (self.interrelatedCarBlock) {
        self.interrelatedCarBlock(nil, SucceedCode);
    }
}

/**
 是否显示添加车牌号
 
 @param show YES
 */
- (void)showAddCarNo:(BOOL)show{
    self.addButton.hidden = !show;
}

@end
