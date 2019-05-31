//
//  ZSY_tableViewSectionView.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 16/8/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_tableViewSectionView.h"

@implementation ZSY_tableViewSectionView

- (instancetype)initWithWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
        
        UILabel *label = [[UILabel alloc] init];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textColor = [UIColor blackColor];
        if (SCREEN_WIDTH <= 320) {
            _title.font = [UIFont boldSystemFontOfSize:12];
        }
        label.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:label];
        label.sd_layout.leftSpaceToView(self,8).topSpaceToView(self,8).heightIs(21).widthIs(50);
        self.title = label;

    }
    return self;
}


- (void)createView {
    
    
//    _title = [[UILabel alloc] init];
//    _title.textColor = [UIColor blackColor];
//    if (SCREEN_WIDTH <= 320) {
//        _title.font = [UIFont boldSystemFontOfSize:12];
//    }
//    _title.font = [UIFont boldSystemFontOfSize:14];
//    [self addSubview:_title];
//    _title.sd_layout.leftSpaceToView(self,8).topSpaceToView(self,8).heightIs(21).widthIs(50);
//    
//    
//    _lineView = [[UIView alloc] init];
//    _lineView.backgroundColor = BLACKGROUND_COLOR;
//    [self addSubview:_lineView];
//    _lineView.sd_layout.leftSpaceToView(self,5).rightSpaceToView(self,5).topSpaceToView(_title,5).heightIs(1);
    
}

- (void)setText:(NSString *)text {
    
    _text = [text copy];
    self.title.text = text;
}


@end
