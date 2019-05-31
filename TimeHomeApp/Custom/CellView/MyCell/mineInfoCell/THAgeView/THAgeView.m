//
//  THAgeView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THAgeView.h"

@interface THAgeView ()

@property (nonatomic, strong) UILabel *ageLabel;

@end

@implementation THAgeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 14/2;
        
        _ageLabel = [[UILabel alloc]init];
        _ageLabel.font = [UIFont boldSystemFontOfSize:12];
        _ageLabel.textColor = [UIColor whiteColor];
        _ageLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_ageLabel];
        
        _ageImage = [[UIImageView alloc]init];
        [self addSubview:_ageImage];
        [_ageImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(8);
//            make.top.equalTo(self);
//            make.bottom.equalTo(self);
//            make.width.equalTo(@(WidthSpace(24)));
//            make.height.equalTo(@(WidthSpace(24)));
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@12);
            make.height.equalTo(@12);
        }];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

        
    }
    return self;
}

- (void)setAge:(NSString *)age {
    _age = age;
    _ageLabel.text = age;
//    _ageLabel.text = @"116";

    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(_ageImage.mas_right).offset(2);
        make.bottom.equalTo(self);
    }];
    
}


@end
