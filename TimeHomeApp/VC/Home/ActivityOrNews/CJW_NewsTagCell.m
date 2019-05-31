//
//  CJW_NewsTagCell.m
//  TimeHomeApp
//
//  Created by cjw on 2018/1/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CJW_NewsTagCell.h"

@interface CJW_NewsTagCell ()

@end
@implementation CJW_NewsTagCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeUI];

    }
    return self;
}

#pragma mark - 初始化UI
- (void)initializeUI {
    
    self.label = [[UILabel alloc] init];
    _label.text = self.title;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = kNewRedColor;
    _label.layer.borderWidth = 1;
    _label.layer.borderColor = kNewRedColor.CGColor;
    _label.layer.cornerRadius = 15;
    _label.layer.masksToBounds = YES;
    [self.contentView addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.offset(0);
        make.width.offset(64);
        make.height.offset(30);
    }];
    
    self.deleteBtn = [[UIButton alloc] init];
    [_deleteBtn setBackgroundColor:kNewRedColor];
    [_deleteBtn setTitle:@"+" forState:UIControlStateNormal];
    _deleteBtn.layer.cornerRadius = 10;
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    _deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0,1, 2, 0);
    _deleteBtn.transform = CGAffineTransformRotate(_deleteBtn.transform,M_PI_4);
    [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.offset(-4);
        make.width.height.offset(20);
    }];
    
    _deleteBtn.hidden = YES;
    
    
}



//在set方法中给控件设置数据
-(void)setTitle:(NSString *)title{
    _title = title;
    _label.text = title;
    
}
@end
