//
//  PACarportInfoTableViewCell.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PACarSpaceDetailTableViewCell.h"

@interface PACarSpaceDetailTableViewCell ()

@property (nonatomic, strong)UILabel * carportInfoLabel;
@property (nonatomic, strong)UIButton * lockCarButton;

@end

@implementation PACarSpaceDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)createSubviews{
    [self.contentView addSubview:self.carportInfoLabel];
    [self.contentView addSubview:self.lockCarButton];
    
    [self.carportInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(14);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.lockCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-14);
        make.width.equalTo(@50);
        make.height.equalTo(@24);
    }];
}
- (UILabel *)carportInfoLabel{
    if (!_carportInfoLabel) {
        _carportInfoLabel = [[UILabel alloc]init];
        _carportInfoLabel.font = [UIFont systemFontOfSize:16];
        _carportInfoLabel.textColor = UIColorHex(0x4A4A4A);
        _carportInfoLabel.text = @"使用状态 : 业主自用";
    }
    return _carportInfoLabel;
}

- (UIButton *)lockCarButton{
    if (!_lockCarButton) {
        _lockCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockCarButton setTitleColor:UIColorHex(0xFFFFFF)
                             forState:UIControlStateNormal];
        [_lockCarButton setTitle:@"锁车" forState:UIControlStateNormal];
        _lockCarButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _lockCarButton.backgroundColor = UIColorHex(0x4A90E2);
        [_lockCarButton setTitle:@"开锁" forState:UIControlStateSelected];

        _lockCarButton.layer.cornerRadius = 12;
        _lockCarButton.layer.masksToBounds = YES;
        [_lockCarButton addTarget:self action:@selector(lockCarAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _lockCarButton;
}

- (void)lockCarAction{
    if (self.lockCarBlock) {
        self.lockCarBlock(nil, !self.lockCarButton.isSelected);
    }
}

- (void) setInfoString:(NSString *)infoString{
    _infoString = infoString;
    
    self.carportInfoLabel.text = _infoString;
}
- (void)showLockCar:(BOOL)show {
    
    self.lockCarButton.hidden = !show;
}


/**
 是否展示锁车按钮锁车状态

 @param show YES show
 */
- (void)showLockCarStateSelected:(BOOL)show{
    
    if (show) {
        self.lockCarButton.selected = YES;
        self.lockCarButton.backgroundColor = UIColorHex(0x6BB519);
    } else {
        self.lockCarButton.selected = NO;
        self.lockCarButton.backgroundColor = UIColorHex(0x4A90E2);
    }
    
}


@end
