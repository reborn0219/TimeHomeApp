//
//  MMDateView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/7/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMDateView.h"
#import "MMPopupItem.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"

@interface MMDateView()

//@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;


@end

@implementation MMDateView

#pragma mark - 单例初始化
+(instancetype)shareDateAlert
{
    static MMDateView * shareDateAlert = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareDateAlert = [[self alloc] init];
        
    });
    return shareDateAlert;
}
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(216+50);
        }];
        
        self.btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionHide)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.top.equalTo(self);
        }];
        self.btnCancel.titleLabel.font = DEFAULT_FONT(14);
        [self.btnCancel setTitle:@"取    消" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.top.equalTo(self);
        }];
        self.btnConfirm.titleLabel.font = DEFAULT_FONT(14);
        [self.btnConfirm setTitle:@"确    定" forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:kNewRedColor forState:UIControlStateNormal];
        
        self.datePicker = [[UIDatePicker alloc]init];
        [self addSubview:self.datePicker];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 0, 0, 0));
        }];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"生日";
        _titleLabel.textColor = TITLE_TEXT_COLOR;
        _titleLabel.font = DEFAULT_BOLDFONT(17);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.btnCancel.mas_centerY);
            make.height.equalTo(@20);
        }];
        
    }
    
    return self;
}
- (void)actionButton:(UIButton*)btn
{
    [self hide];
    if (self.confirm) {
        
        NSDateFormatter * df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy/MM/dd"];
        NSString * s1 = [df stringFromDate:_datePicker.date];
        
        self.confirm(s1);
    }
}
- (void)actionHide
{
    [self hide];
}

@end
