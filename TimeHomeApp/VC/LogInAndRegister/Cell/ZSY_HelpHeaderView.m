//
//  ZSY_HelpHeaderView.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_HelpHeaderView.h"

@implementation ZSY_HelpHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createTopUI];
        self.contentView.backgroundColor = COLOR(150, 150, 152, 1);
    }
    return self;
}


- (void)createTopUI {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height / 2)];
    [self.contentView addSubview:topView];
    
    ///联系客服
    _numberLabelChinese = [[UILabel alloc] init];
    _numberLabelChinese.text = @"联系客服";
    _numberLabelChinese.textColor = [UIColor whiteColor];
    _numberLabelChinese.backgroundColor = [UIColor clearColor];
    _numberLabelChinese.font = DEFAULT_FONT(15);
    [topView addSubview:_numberLabelChinese];
    _numberLabelChinese.sd_layout.leftSpaceToView(topView,16).centerYEqualToView(topView).heightIs(21).widthIs(topView.frame.size.width / 5);
    
    ///客服电话
    _numberLabelNumeral = [[UILabel alloc] init];
    _numberLabelNumeral.text = @"400-800-3541";
    _numberLabelNumeral.textColor = [UIColor whiteColor];
    _numberLabelNumeral.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20];
    _numberLabelNumeral.backgroundColor = [UIColor clearColor];
    [topView addSubview:_numberLabelNumeral];
    _numberLabelNumeral.sd_layout.leftSpaceToView(_numberLabelChinese,8).bottomEqualToView(_numberLabelChinese).heightIs(25).widthIs(topView.frame.size.width / 5 * 2.2).centerYEqualToView(_numberLabelChinese);
    
    ///拨号按钮
    _dialingButton = [[UIButton alloc] init];
    _dialingButton.backgroundColor = [UIColor clearColor];
    [_dialingButton setTitle:@"拨号......" forState:UIControlStateNormal];
    [_dialingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (SCREEN_HEIGHT > 568) {
        _dialingButton.titleLabel.font = DEFAULT_FONT(17);
    }else {
        _dialingButton.titleLabel.font = DEFAULT_FONT(14);
        [_dialingButton setTitle:@"拨号..." forState:UIControlStateNormal];
    }
    [topView addSubview:_dialingButton];
    
    _dialingButton.sd_layout.leftSpaceToView(_numberLabelNumeral,8).topEqualToView(_numberLabelChinese).heightIs(20).rightSpaceToView(topView,8);
    _dialingButton.backgroundColor = [UIColor clearColor];
    _dialingButton.layer.cornerRadius = 10;
    _dialingButton.layer.borderWidth = 1.5;
    _dialingButton.layer.borderColor = COLOR(203, 26, 28, 1).CGColor;
    [_dialingButton addTarget:self action:@selector(dialingClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), self.contentView.frame.size.width, self.contentView.frame.size.height / 2)];
    [self.contentView addSubview:bottomView];
    
    ///工作时间
    _timeLabelChinese = [[UILabel alloc] init];
    _timeLabelChinese.text = @"工作时间";
    _timeLabelChinese.textColor = [UIColor whiteColor];
    _timeLabelChinese.font = DEFAULT_FONT(15);
    [bottomView addSubview:_timeLabelChinese];
    _timeLabelChinese.sd_layout.leftSpaceToView(bottomView,16).centerYEqualToView(bottomView).heightIs(21).widthIs(bottomView.frame.size.width / 5);
    
    _timeLabelnamberLabelNumeral = [[UILabel alloc] init];
    _timeLabelnamberLabelNumeral.text = @"9:00——18:00";
    _timeLabelnamberLabelNumeral.textColor = [UIColor whiteColor];
    _timeLabelnamberLabelNumeral.font = [UIFont systemFontOfSize:14];
    _timeLabelnamberLabelNumeral.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:_timeLabelnamberLabelNumeral];
    _timeLabelnamberLabelNumeral.sd_layout.leftSpaceToView(_timeLabelChinese,8).bottomEqualToView(_timeLabelChinese).heightIs(21).widthIs(bottomView.frame.size.width / 3).centerYEqualToView(_timeLabelChinese);

    _timeLabelMark = [[UILabel alloc] init];
    _timeLabelMark.text = @"法定节假日除外";
    _timeLabelMark.textColor = TITLE_TEXT_COLOR;
    _timeLabelMark.font = DEFAULT_FONT(13);
    [bottomView addSubview:_timeLabelMark];
    _timeLabelMark.sd_layout.leftSpaceToView(_timeLabelnamberLabelNumeral,5).heightIs(21).widthIs(bottomView.frame.size.width / 3).bottomEqualToView(_timeLabelnamberLabelNumeral).centerYEqualToView(_timeLabelChinese);
}


- (void)dialingClick:(UIButton *)button {
    NSLog(@"拨号");
    
}

@end
