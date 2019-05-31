//
//  MyJFButton.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MyJFButton.h"

@interface MyJFButton ()

@property (nonatomic, strong) UILabel *jfCount;//积分或余额
@property (nonatomic, strong) UILabel *jfName;//积分或余额名称
@property (nonatomic, strong) UIImageView *leftPicImage;//积分或余额图片

@end

@implementation MyJFButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.leftPicImage];
    
        [_leftPicImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(WidthSpace(62.f));
            make.width.equalTo(@(WidthSpace(34)));
            make.height.equalTo(@(WidthSpace(34)));
            make.centerY.equalTo(self.mas_centerY);
        }];
    
        [self addSubview:self.jfName];
        [_jfName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.centerY.equalTo(self.mas_centerY);
            make.centerX.equalTo(self.mas_centerX);
    
        }];
    
    
        [self addSubview:self.jfCount];
        [_jfCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_jfName.mas_right);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self).offset(-5);
        }];
        
    }
    return self;
}

- (UILabel *)jfName {
    if (!_jfName) {
        _jfName = [[UILabel alloc]init];
        _jfName.font = [UIFont systemFontOfSize:14];
        _jfName.textAlignment = NSTextAlignmentCenter;
    }
    return _jfName;
}
- (UIImageView *)leftPicImage {
    if (!_leftPicImage) {
        _leftPicImage = [[UIImageView alloc]init];
    }
    return _leftPicImage;
}
- (UILabel *)jfCount {
    if (!_jfCount) {
        _jfCount = [[UILabel alloc]init];
        _jfCount.font = [UIFont systemFontOfSize:14];
        _jfCount.textAlignment = NSTextAlignmentCenter;
    }
    return _jfCount;
}
- (void)setImageType:(NSInteger)imageType {
    _imageType = imageType;
    
    if (imageType == 0) {

        _jfName.text = @"余  额";
//        _jfName.textColor = UIColorFromRGB(0xFE5B5E);
//        _jfCount.textColor = UIColorFromRGB(0XFE5B5E);
        _jfName.textColor = WOMEN_COLOR;
        _jfCount.textColor = WOMEN_COLOR;
        _leftPicImage.image = [UIImage imageNamed:@"余额"];

        
    }else {
        _jfName.text = @"积  分";
//        _jfName.textColor = UIColorFromRGB(0X63B6FC);
//        _jfCount.textColor = UIColorFromRGB(0X63B6FC);
        _jfName.textColor = MAN_COLOR;
        _jfCount.textColor = MAN_COLOR;
        _leftPicImage.image = [UIImage imageNamed:@"积分"];
    }
}

- (void)setJfCountString:(NSString *)jfCountString {
    _jfCountString = jfCountString;
    _jfCount.text = _jfCountString;
}

@end
