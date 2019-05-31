//
//  THPlaceHolderTextView.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THPlaceHolderTextView.h"

@interface THPlaceHolderTextView ()



@end

@implementation THPlaceHolderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(5, 6, self.frame.size.width, 20)];
        _placeHolder.textColor = TEXT_COLOR;
        _placeHolder.font = DEFAULT_FONT(13);
        [self addSubview:_placeHolder];
        
    }
    return self;
}

@end
