//
//  PAParkingSpaceCollectionViewCell.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceCollectionViewCell.h"
#import "PACarSpaceModel.h"
#import "PACarSwitch.h"
@interface PACarSpaceCollectionViewCell ()

@property (nonatomic, strong) UIView * background;
@property (nonatomic, strong) UILabel * parkingNameLabel;
@property (nonatomic, strong) UILabel * parkingCarNumberLabel;
@property (nonatomic, strong) UIImageView * parkingImageView;
@property (nonatomic, strong) UIImageView * leftLockImageView;
@property (nonatomic, strong) UIImageView * rightLockImageView;
@property (nonatomic, strong) PACarSwitch * lockSwitch;
@property (nonatomic, strong) UILabel  * nullLabel;

@end


@implementation PACarSpaceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        [self createSubviews];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    self.parkingImageView.highlighted = NO;
}



- (void)createSubviews{
    
    self.highlighted = NO;
    [self.contentView addSubview:self.background];
    [self.background addSubview:self.parkingNameLabel];
    [self.background addSubview:self.parkingImageView];
    [self.background addSubview:self.parkingCarNumberLabel];
    [self.background addSubview:self.leftLockImageView];
    [self.background addSubview:self.lockSwitch];
    [self.background addSubview:self.rightLockImageView];
    [self.background addSubview:self.nullLabel];
    
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.equalTo(@105);
        make.height.equalTo(@140);
    }];
    
    [self.parkingNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.background).with.offset(8);
        make.right.equalTo(self.background).with.offset(-8);
        make.top.equalTo(self.background).with.offset(5);
    }];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = UIColorHex(0xF0F0F0);
    
    [self.background addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.background);
        make.top.equalTo(self.parkingNameLabel.mas_bottom).with.offset(3);
        make.height.equalTo(@0.5);
    }];
    
    [self.lockSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.background);
        make.bottom.equalTo(self.background).with.offset(-7);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    
    [self.nullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.background);
        make.bottom.equalTo(self.background).with.offset(-7);
        make.height.equalTo(@30);
    }];
    
    [self.parkingCarNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.background);
        make.bottom.equalTo(self.lockSwitch.mas_top).with.offset(-5);
    }];
    
    [self.parkingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.background);
        make.bottom.equalTo(self.parkingCarNumberLabel.mas_top).with.offset(-1);
    }];
    
    [self.leftLockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lockSwitch);
        make.right.equalTo(self.lockSwitch.mas_left).with.offset(-1);
    }];
    
    [self.rightLockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lockSwitch);
        make.left.equalTo(self.lockSwitch.mas_right).with.offset(1);
    }];
}

- (UIView *)background{
    if (!_background) {
        _background= [[UIView alloc] init];
        _background.backgroundColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
        _background.layer.borderWidth = 1.0f;
        
        _background.layer.borderColor = UIColorHex(0xEEEEEE).CGColor;
        _background.layer.cornerRadius = 4;
        
        _background.layer.shadowColor = UIColor.blackColor.CGColor;
        _background.layer.shadowOffset = CGSizeMake(0, 2);
        _background.layer.shadowOpacity = 0.1;
        
//        _background.layer.masksToBounds = YES;

        
        //_background.backgroundColor = [UIColor cyanColor];
    }
    return _background;
}
- (UILabel *)parkingNameLabel{
    if (!_parkingNameLabel) {
        _parkingNameLabel = [[UILabel alloc]init];
        _parkingNameLabel.font = [UIFont systemFontOfSize:13];
        _parkingNameLabel.textColor = UIColorHex(000000);
        _parkingNameLabel.textAlignment = NSTextAlignmentCenter;
        _parkingNameLabel.text = @"电子城车位一";
    }
    return _parkingNameLabel;
}

- (UIImageView *)parkingImageView{
    if (!_parkingImageView) {
        _parkingImageView = [[UIImageView alloc]initWithImage:
                             [UIImage imageNamed:@"cwsz_button_cw_n"]
                             ];
    }
    return _parkingImageView;
}

- (UIImageView *)leftLockImageView{
    if (!_leftLockImageView) {
        
        _leftLockImageView =  [[UIImageView alloc]initWithImage:
                               [UIImage imageNamed:@"cwsz_icon_open_n"]
                                               highlightedImage:[UIImage imageNamed:@"cwsz_icon_open_s"]
                               ];
        
    }
    return _leftLockImageView;
}

- (UIImageView *)rightLockImageView{
    if (!_rightLockImageView) {
        _rightLockImageView = [[UIImageView alloc]initWithImage:
                               [UIImage imageNamed:@"cwsz_icon_close_n"]
                                               highlightedImage:
                               [UIImage imageNamed:@"cwsz_icon_close_s"]];
    }
    return _rightLockImageView;
}

- (UILabel *)parkingCarNumberLabel{
    if (!_parkingCarNumberLabel) {
        _parkingCarNumberLabel = [[UILabel alloc]init];
        _parkingCarNumberLabel.font = [UIFont systemFontOfSize:13];
        _parkingCarNumberLabel.textColor = UIColorHex(0x9B9B9B);
        _parkingCarNumberLabel.textAlignment = NSTextAlignmentCenter;
        _parkingCarNumberLabel.text = @"冀A221134";
    }
    return _parkingCarNumberLabel;
}

- (UILabel *)nullLabel{
    if (!_nullLabel) {
        _nullLabel = [[UILabel alloc]init];
        _nullLabel.font = [UIFont systemFontOfSize:13];
        _nullLabel.textColor = UIColorHex(0x9B9B9B);
        _nullLabel.textAlignment = NSTextAlignmentCenter;
        _nullLabel.text = @"暂无车辆";
    }
    return _nullLabel;
}

- (PACarSwitch *)lockSwitch{
    if (!_lockSwitch) {
        _lockSwitch = [[PACarSwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        //_lockSwitch.tintColor = UIColorHex(0x4A90E2);
        _lockSwitch.onTintColor = UIColorHex(0xD0021B);
        _lockSwitch.offTintColor =UIColorHex(0x4A90E2);
        [_lockSwitch addTarget:self action:@selector(lockCarAction) forControlEvents:UIControlEventValueChanged];
    }
    return _lockSwitch;
}

- (void)setSpaceModel:(PACarSpaceModel *)spaceModel{
    _spaceModel = spaceModel;
    if (_spaceModel.parkingSpaceState == 0) {
        self.lockSwitch.hidden = YES;
        self.leftLockImageView.hidden = YES;
        self.rightLockImageView.hidden = YES;
        self.parkingImageView.image = [UIImage imageNamed:@"cwsz_button_kcw_n"];
        self.nullLabel.hidden = NO;
    } else {
        self.lockSwitch.hidden = NO;
        self.leftLockImageView.hidden = NO;
        self.rightLockImageView.hidden = NO;
        
        self.nullLabel.hidden = YES;
        self.parkingImageView.image = [UIImage imageNamed:@"cwsz_button_cw_n"];
    }
    self.parkingNameLabel.text = spaceModel.parkingSpaceName;
    self.parkingCarNumberLabel.text = spaceModel.inLibCarNo?:@"— —";
    self.lockSwitch.on = spaceModel.carLockState;
    
    [self updateSwithLockImage];
}


/**
 更新swith左右锁车图片
 */
- (void)updateSwithLockImage{
    if (self.lockSwitch.isOn) {
        self.leftLockImageView.highlighted = NO;
        self.rightLockImageView.highlighted = YES;
    } else {
        self.leftLockImageView.highlighted = YES;
        self.rightLockImageView.highlighted = NO;
    }

}

- (void)lockCarAction{
    // 判断当前spaceModel的状态 是否与 lockSwitch保持一致, 如果不一致则 block返回并触发以下事件
    if (self.spaceModel.carLockState == self.lockSwitch.isOn) {
        return;
    }
    
    NSDictionary * parameter = @{
                                 @"parkingSpaceId":self.spaceModel.spaceId,
                                 @"carNo":self.spaceModel.inLibCarNo?:@"",
                                 @"carLockState":[NSNumber numberWithInteger:self.lockSwitch.isOn]
                                 };
    
    if (self.lockCarBlock) {
        self.lockCarBlock(parameter, 0);
    }
    [self updateSwithLockImage];
        
}

- (void)hideParkingSpaceInfo:(BOOL)hidden{
    
    if (hidden) {
        self.lockSwitch.hidden = YES;
        self.leftLockImageView.hidden = YES;
        self.rightLockImageView.hidden = YES;
        self.parkingImageView.highlighted = YES;
        self.nullLabel.hidden = NO;
        self.parkingCarNumberLabel.text =@"— —";
        self.nullLabel.text = @"查看详情";
        self.nullLabel.textColor = UIColorHex(0x4A90E2);
    } else {
        self.nullLabel.textColor = UIColorHex(0x9B9B9B);
        self.nullLabel.text = @"暂无车辆";
    }
}

@end


