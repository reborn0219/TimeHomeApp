//
//  PAParkingRentDetailView.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/20.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceRentDetailView.h"
#import "PACarSpaceModel.h"
@interface PACarSpaceRentDetailView ()
@property (nonatomic, strong)UILabel * userName;
@property (nonatomic, strong)UILabel * userPhone;
@property (nonatomic, strong)UIButton * renewButton;
@property (nonatomic, strong)UIButton * revokeButton;


@end

@implementation PACarSpaceRentDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self crateSubviews];
    }
    return self;
}

- (void)crateSubviews{
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.userName];
    [self addSubview:self.userPhone];
    [self addSubview:self.renewButton];
    [self addSubview:self.revokeButton];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(14);
        make.top.equalTo(self).with.offset(9);
    }];
    
    [self.userPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-14);
        make.top.equalTo(self).with.offset(9);
    }];
    
    [self.revokeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userPhone.mas_bottom).with.offset(10);
        make.right.equalTo(self.userPhone);
        make.width.equalTo(@92);
        make.height.equalTo(@32);
    }];
    
    [self.renewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.revokeButton);
        make.right.equalTo(self.revokeButton.mas_left).with.offset(-16);
    }];
}

- (UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc]init];
        _userName.textColor = UIColorHex(0x4B4B4B);
        _userName.font = [UIFont systemFontOfSize:14];
    }
    return _userName;
}

- (UILabel *)userPhone{
    if (!_userPhone) {
        _userPhone = [[UILabel alloc]init];
        _userPhone.textColor = UIColorHex(0x4B4B4B);
        _userPhone.font = [UIFont systemFontOfSize:14];
    }
    return _userPhone;
}

- (UIButton *)renewButton{
    if (!_renewButton) {
        _renewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_renewButton setTitle:@"续租" forState:UIControlStateNormal];
        [_renewButton setTitleColor:UIColorHex(0x4288DA) forState:UIControlStateNormal];
        _renewButton.layer.borderColor = UIColorHex(0x4288DA).CGColor;
        _renewButton.layer.borderWidth = 1.0f;
        _renewButton.layer.cornerRadius = 4;
        _renewButton.layer.masksToBounds = YES;
        _renewButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_renewButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _renewButton;
}

- (UIButton *)revokeButton{
    if (!_revokeButton) {
        _revokeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_revokeButton setTitle:@"撤销" forState:UIControlStateNormal];
        [_revokeButton setTitleColor:UIColorHex(0xCF2136) forState:UIControlStateNormal];
        _revokeButton.layer.borderColor = UIColorHex(0xCF2136).CGColor;
        _revokeButton.layer.borderWidth = 1.0f;
        _revokeButton.layer.cornerRadius = 4;
        _revokeButton.layer.masksToBounds = YES;
        _revokeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_revokeButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _revokeButton;

}

- (void)buttonClickAction:(UIButton *)sender{
    
    if (sender == self.revokeButton) {
        if (self.eventBlock) {
            self.eventBlock(@"1", 0);
        }
    } else {
        if (self.eventBlock) {
            self.eventBlock(@"2", 0);
        }

        
    }
}

- (void)setSpaceModel:(PACarSpaceModel *)spaceModel{
    _spaceModel = spaceModel;
    
    self.userName.text = [@"用户姓名:" stringByAppendingString:spaceModel.userName?:@""];
    self.userPhone.text = [@"用户电话:" stringByAppendingString:spaceModel.userPhone?:@""];
}
@end
