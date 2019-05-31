//
//  THSelectButton.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THSelectButton.h"

@implementation THSelectButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
//    CGFloat buttonWidth = (SCREEN_WIDTH-2*7-15*2)/3;
//
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, 60)];
//    [self addSubview:bgView];
    
    _dotImageView= [[UIImageView alloc]init];
    [self addSubview:_dotImageView];
    [_dotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WidthSpace(14));
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(WidthSpace(26)));
        make.height.equalTo(@(WidthSpace(26)));
    }];
//    _dotImageView.sd_layout.leftSpaceToView(self,WidthSpace(14)).centerYEqualToView(self).widthIs(WidthSpace(26)).heightEqualToWidth();
    
    _faceImageView= [[UIImageView alloc]init];
    [self addSubview:_faceImageView];
    [_faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dotImageView.mas_right).offset(WidthSpace(16));
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(WidthSpace(28)));
        make.height.equalTo(@(WidthSpace(28)));
    }];
//    _faceImageView.sd_layout.leftSpaceToView(_dotImageView,WidthSpace(16)).centerYEqualToView(self).widthIs(WidthSpace(28)).heightEqualToWidth();

    _rightLabel = [[UILabel alloc]init];
    _rightLabel.font = DEFAULT_FONT(15);
    _rightLabel.textColor = TITLE_TEXT_COLOR;
    [self addSubview:_rightLabel];
//    _rightLabel.sd_layout.leftSpaceToView(_faceImageView,5).centerYEqualToView(self).heightIs(20).widthIs(80);
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_faceImageView.mas_right).offset(5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    

}
- (void)setTitleViewAligment:(TitleViewAligment)titleViewAligment {
    _titleViewAligment = titleViewAligment;
    
    switch (titleViewAligment) {
        case TitleViewAligmentLeft:
        {
            [_dotImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(WidthSpace(14));
                make.centerY.equalTo(self.mas_centerY);
                make.width.equalTo(@(WidthSpace(26)));
                make.height.equalTo(@(WidthSpace(26)));
            }];
            [_faceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_dotImageView.mas_right).offset(WidthSpace(16));
                make.centerY.equalTo(self.mas_centerY);
                make.width.equalTo(@(WidthSpace(28)));
                make.height.equalTo(@(WidthSpace(28)));
            }];
            [_rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_faceImageView.mas_right).offset(5);
                make.centerY.equalTo(self.mas_centerY);
            }];
        }
            break;
        case TitleViewAligmentMiddle:
        {
            [_faceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.centerY.equalTo(self.mas_centerY);
                make.width.equalTo(@(WidthSpace(28)));
                make.height.equalTo(@(WidthSpace(28)));

            }];
            [_dotImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_faceImageView.mas_left).offset(-WidthSpace(16));
                make.centerY.equalTo(self.mas_centerY);
                make.width.equalTo(@(WidthSpace(26)));
                make.height.equalTo(@(WidthSpace(26)));
            }];
            [_rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_faceImageView.mas_right).offset(5);
                make.centerY.equalTo(self.mas_centerY);
            }];
        }
            break;
        case TitleViewAligmentRight:
        {
            [_rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-WidthSpace(14));
                make.centerY.equalTo(self.mas_centerY);
            }];
            [_faceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.rightLabel.mas_left).offset(-5);
                make.centerY.equalTo(self.mas_centerY);
                make.width.equalTo(@(WidthSpace(28)));
                make.height.equalTo(@(WidthSpace(28)));
            }];
            [_dotImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_faceImageView.mas_left).offset(-WidthSpace(16));
                make.centerY.equalTo(self.mas_centerY);
                make.width.equalTo(@(WidthSpace(26)));
                make.height.equalTo(@(WidthSpace(26)));
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
