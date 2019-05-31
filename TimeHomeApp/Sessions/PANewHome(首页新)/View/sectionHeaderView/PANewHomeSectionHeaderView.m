//
//  PANewHomeSectionHeaderView.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/8/2.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PANewHomeSectionHeaderView.h"

@interface PANewHomeSectionHeaderView ()
@property (nonatomic, strong)UIView * lineView;
@property (nonatomic, strong) UIView * redLineView;
@property (nonatomic, strong) UILabel * sectionTitle;
@property (nonatomic, strong) UIButton * moreButton;
@property (nonatomic, strong) UIImageView *sectionImageView;
@end

@implementation PANewHomeSectionHeaderView
- (instancetype)init{
    if (self = [super init]) {
        [self createSubviews];
    }
    return self;
}
- (void)createSubviews{
    
    self.backgroundColor = UIColorFromRGB(0XF1F1F1);
    [self addSubview:self.lineView];
    [self addSubview:self.redLineView];
    [self addSubview:self.sectionTitle];
    [self addSubview:self.sectionImageView];
    [self addSubview:self.moreButton];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(15);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.equalTo(@1);
    }];
    [self.redLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView);
        make.top.equalTo(self).with.offset(30);
        make.height.equalTo(@30);
        make.width.equalTo(@4);
    }];
    [self.sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.redLineView);
        make.left.equalTo(self.redLineView.mas_right).with.offset(4);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    [self.sectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sectionTitle.mas_right).with.offset(4);
        make.bottom.equalTo(self.sectionTitle);
        make.width.mas_equalTo(110*0.66);
        make.height.mas_equalTo(18*0.66);
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sectionTitle);
        make.right.equalTo(self).with.offset(-10);
    }];
    
 
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreHeaderClickAction)];
    [self addGestureRecognizer:tap];
    
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}
- (UIView *)redLineView{
    if (!_redLineView) {
        _redLineView = [[UIView alloc]init];
        _redLineView.backgroundColor = UIColorFromRGB(0xAB2121);
    }
    return _redLineView;
}
- (UILabel *)sectionTitle{
    if (!_sectionTitle) {
        _sectionTitle = [[UILabel alloc]init];
        _sectionTitle.font = [UIFont systemFontOfSize:18.0f];
        _sectionTitle.textColor = UIColorFromRGB(0x595353);
        _sectionTitle.text = @"热点新闻";
    }
    return _sectionTitle;
}
- (UIImageView *)sectionImageView{
    if (!_sectionImageView) {
        _sectionImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"首页_热门新闻"]];
    }
    return _sectionImageView;
}
- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setFrame:CGRectMake(SCREEN_WIDTH-10-70,28,60,30)];
        [_moreButton setTitleColor:UIColorFromRGB(0x595353) forState:UIControlStateNormal];
        [_moreButton setTitle:@"更多 >" forState:UIControlStateNormal];
        [_moreButton setEnabled:NO];
    }
    return _moreButton;
}

#pragma mark - Action

- (void)moreHeaderClickAction{
    if (self.callback) {
        self.callback(nil, SucceedCode);
    }
}

- (void)setShowActivity:(BOOL)showActivity{
    [self.sectionImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
    if (showActivity) {
        self.sectionTitle.text = @"社区活动";
        self.sectionImageView.image = [UIImage imageNamed:@"首页_社区活动e"];
        [self.sectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sectionTitle.mas_right).with.offset(4);
            make.bottom.equalTo(self.sectionTitle);
            make.width.equalTo(@120);
            make.height.equalTo(@12);

        }];

    } else{
        self.sectionTitle.text = @"热点新闻";
        self.sectionImageView.image =[UIImage imageNamed:@"首页_热门新闻"];
        
        [self.sectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sectionTitle.mas_right).with.offset(4);
            make.bottom.equalTo(self.sectionTitle);
            make.width.mas_equalTo(110*0.66);
            make.height.mas_equalTo(18*0.66);
        }];
        
    }
}
@end
