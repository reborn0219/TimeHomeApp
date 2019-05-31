//
//  CJW_NewsTagHeaderView.m
//  TimeHomeApp
//
//  Created by cjw on 2018/1/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CJW_NewsTagHeaderView.h"

@interface CJW_NewsTagHeaderView ()
@property (nonatomic,strong) UILabel *label;


@end
@implementation CJW_NewsTagHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeUI];
}

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
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.textColor = TITLE_TEXT_COLOR;
    _label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(90);
        make.height.offset(30);
        make.centerY.offset(0);
        make.left.offset(0);
    }];
    
    self.editLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _editLabel.text = @"拖拽排序/点击删除";
    _editLabel.textColor = TEXT_COLOR;
    _editLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self addSubview:_editLabel];
    [_editLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_label.mas_right).offset(0);
        make.centerY.offset(0);
    }];
    _editLabel.hidden = YES;
    
    self.btn = [[UIButton alloc] init];
    [_btn setTitle:_btnTitle forState:UIControlStateNormal];
    [_btn setTitleColor:kNewRedColor forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [_btn sizeToFit];
    [self addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(0);
    }];
    
    
}

-(void)setTitle:(NSString *)title {
    _title = title;
    _label.text = title;
}

-(void)setBtnTitle:(NSString *)btnTitle {
    _btnTitle = btnTitle;
    [_btn setTitle:btnTitle forState:UIControlStateNormal];
}

@end
