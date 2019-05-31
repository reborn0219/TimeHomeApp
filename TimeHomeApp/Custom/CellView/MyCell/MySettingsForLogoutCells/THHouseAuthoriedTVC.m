//
//  THHouseAuthoriedTVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THHouseAuthoriedTVC.h"

@implementation THHouseAuthoriedTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    

    _arrowImage= [[UIImageView alloc]init];
    _arrowImage.image = [UIImage imageNamed:@"我的_右箭头"];
    [self.contentView addSubview:_arrowImage];
    [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    _rightLabel = [[UILabel alloc]init];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.font = DEFAULT_FONT(14);
    [self.contentView addSubview:_rightLabel];

    
    _leftLabel = [[UILabel alloc]init];
    _leftLabel.textColor = TITLE_TEXT_COLOR;
    _leftLabel.font = DEFAULT_FONT(16);
    [self.contentView addSubview:_leftLabel];
    
    _rightLabel.sd_resetLayout.heightIs(20).widthIs(70).centerYEqualToView(self.contentView).rightSpaceToView(self.contentView,15);
    _rightLabel.sd_cornerRadiusFromHeightRatio = @(0.5);
    _leftLabel.sd_resetLayout.leftSpaceToView(self.contentView,15).topEqualToView(self.contentView).bottomEqualToView(self.contentView).rightSpaceToView(_rightLabel,5);

    
}
- (void)setRightLabelStyle:(RightLabelStyle)rightLabelStyle {
    _rightLabelStyle = rightLabelStyle;
    switch (rightLabelStyle) {
        case RightLabelStyleDefault:
        {
            _rightLabel.backgroundColor = [UIColor clearColor];
//            [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(_arrowImage.mas_left).offset(-20);
//                make.width.equalTo(@80);
//                make.top.equalTo(self.contentView);
//                make.bottom.equalTo(self.contentView);
//            }];
            _rightLabel.sd_resetLayout.heightIs(20).widthIs(70).centerYEqualToView(self.contentView).rightSpaceToView(_arrowImage,15);
            
            [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(15);
                make.top.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView);
                make.right.equalTo(_rightLabel.mas_left).offset(-20);

            }];
        }
            break;
        case RightLabelStyleRedBackground:
        {
            _arrowImage.hidden = YES;
            _rightLabel.backgroundColor = kNewRedColor;
            _rightLabel.textColor = [UIColor whiteColor];
            _rightLabel.textAlignment = NSTextAlignmentCenter;

//            _leftLabel.sd_resetLayout.leftSpaceToView(self.contentView,15).topEqualToView(self.contentView).bottomEqualToView(self.contentView).rightSpaceToView(_rightLabel,10);
        }
            break;
        case RightLabelStyleCarBackground:
        {
            _rightLabel.textAlignment = NSTextAlignmentCenter;
            _rightLabel.backgroundColor = [UIColor clearColor];

        }
        default:
            break;
    }
}
- (void)setTextColor:(NSInteger)textColor {
    _textColor = textColor;
    switch (_textColor) {
        case TextColorRedColor:
        {
            _rightLabel.textColor = kNewRedColor;
        }
            break;
        case TextColorBlueColor:
        {
            _rightLabel.textColor = UIColorFromRGB(0x276DDC);
        }
            break;
        case TextColorGreenColor:
        {
            _rightLabel.textColor = UIColorFromRGB(0x7AC40F);
        }
            break;
        default:
            break;
    }
    
}

@end
