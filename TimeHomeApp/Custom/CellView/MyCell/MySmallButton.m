//
//  MySmallButton.m
//  TimeHomeApp
//
//  Created by 世博 on 16/4/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MySmallButton.h"

@implementation MySmallButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    
    _top_Label = [[UILabel alloc]init];
    _top_Label.font = DEFAULT_FONT(13);
    _top_Label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_top_Label];
    [_top_Label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.mas_centerY).offset(-5);
        make.height.equalTo(@20);
        make.left.equalTo(self);
        make.right.equalTo(self);
        
    }];
    
    _bottom_Image = [[UIImageView alloc]init];
    [self addSubview:_bottom_Image];
    [_bottom_Image mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_centerX).offset(-10);
        make.top.equalTo(self.mas_centerY).offset(5);
        make.width.height.equalTo(@20);
        
    }];
    
    _bottom_Label = [[UILabel alloc]init];
    _bottom_Label.font = DEFAULT_BOLDFONT(15);
    _bottom_Label.textAlignment = NSTextAlignmentLeft;
    _bottom_Label.textColor = TITLE_TEXT_COLOR;
    [self addSubview:_bottom_Label];
    [_bottom_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_centerX).offset(-5);
        make.top.equalTo(self.mas_centerY).offset(5);
        make.height.equalTo(@20);
        make.right.equalTo(self);
    }];
    
    
}

@end
