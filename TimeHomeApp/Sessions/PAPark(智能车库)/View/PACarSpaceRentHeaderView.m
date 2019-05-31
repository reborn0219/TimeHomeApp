//
//  PACarportRentHeaderView.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceRentHeaderView.h"

@implementation PACarSpaceRentHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}
- (void)createSubviews{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(14);
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).with.offset(8);
        make.centerY.equalTo(self);
    }];
}

#pragma mark Lazyload
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clcz_icon_p_n"]];
    }
    return _imageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = UIColorHex(0x4A4A4A);
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}
@end

@implementation PACarSpaceRentFooterView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}
- (void)createSubviews{
    [self addSubview:self.tipLabel];
    [self addSubview:self.rentButton];
 
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(6);
    }];
    
    [self.rentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.tipLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.equalTo(@44);
    }];
}


#pragma mark Lazyload

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.textColor = UIColorHex(0x9B9B9B);
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.text = @"在租期内您对该车位的管理权限将移交给被授权人";
    }
    return _tipLabel;
}

- (UIButton *)rentButton{
    if (!_rentButton) {
        _rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rentButton setTitle:@"出租" forState:UIControlStateNormal];
        [_rentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rentButton.backgroundColor = UIColorHex(0x2D82E3);
        _rentButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _rentButton.layer.cornerRadius = 4;
        _rentButton.layer.masksToBounds = YES;
        [_rentButton addTarget:self action:@selector(rentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rentButton;
}

#pragma mark Actions

- (void)rentAction{
    
    if (self.rentBlock) {
        self.rentBlock(nil, 0);
    }
}


@end
