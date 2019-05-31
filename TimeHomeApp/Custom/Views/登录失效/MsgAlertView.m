//
//  MsgAlertView.m
//  TimeHomeApp
//
//  Created by us on 16/4/20.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MsgAlertView.h"

@implementation MsgAlertView
{
    ///背景
    UIView * v_BG;
    ///消息展示
    UILabel * lab_MSG;
    ///横线
    UIView * v_Line;
    ///确认按钮
    UIButton * btn_Ok;
    ///取消按钮
    UIButton * btn_Cancel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

///添加视图
-(void)initViews
{
    self.backgroundColor=RGBAFrom0X(0x000000, 0.3);
    v_BG=[UIView new];
    v_BG.backgroundColor=UIColorFromRGB(0xffffff);
    [self addSubview:v_BG];
    
    lab_MSG=[UILabel new];
    lab_MSG.textColor=UIColorFromRGB(0x595353);
    lab_MSG.font=DEFAULT_FONT(16);
    lab_MSG.numberOfLines=0;
    lab_MSG.textAlignment=NSTextAlignmentCenter;
    [self addSubview:lab_MSG];
    
    v_Line=[UIView new];
    v_Line.backgroundColor=UIColorFromRGB(0xf1f1f1);
    [self addSubview:v_Line];
    
    btn_Cancel=[UIButton new];
    [self addSubview:btn_Cancel];
    btn_Cancel.backgroundColor=UIColorFromRGB(0xffffff);
    btn_Cancel.titleLabel.font=DEFAULT_FONT(16);
    [btn_Cancel setTitleColor:UIColorFromRGB(0x595353)forState:UIControlStateNormal];
    btn_Cancel.layer.borderWidth = 1;
    btn_Cancel.layer.borderColor = TEXT_COLOR.CGColor;
    
    btn_Ok=[UIButton new];
    [self addSubview:btn_Ok];
    btn_Ok.backgroundColor=UIColorFromRGB(0xab2121);
    btn_Ok.titleLabel.font=DEFAULT_FONT(16);
    [btn_Ok setTitleColor:UIColorFromRGB(0xffffff)forState:UIControlStateNormal];
    
    [v_BG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.8);
        make.height.greaterThanOrEqualTo(@150);
    }];
    
    [lab_MSG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v_BG).offset(10);
        make.left.equalTo(v_BG).offset(10);
        make.right.equalTo(v_BG).offset(-10);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    
    
    [v_Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab_MSG.mas_bottom).offset(10);
        make.left.equalTo(v_BG).offset(10);
        make.right.equalTo(v_BG).offset(-10);
        make.height.mas_equalTo(@1);
    }];
    
    
    
    [btn_Cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v_Line.mas_bottom).offset(10);
        make.left.equalTo(v_Line);
        make.right.equalTo(btn_Ok.mas_left).offset(-20);
        make.width.equalTo(btn_Ok.mas_width);
        make.height.greaterThanOrEqualTo(@40);
        make.bottom.equalTo(v_BG).offset(-10);
    }];
    btn_Cancel.tag=101;
    [btn_Cancel addTarget:self action:@selector(btn_Event:) forControlEvents:UIControlEventTouchUpInside];
    

    [btn_Ok mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v_Line.mas_bottom).offset(10);
        make.left.equalTo(btn_Cancel.mas_right).offset(20);
        make.right.equalTo(v_Line);
        make.width.equalTo(btn_Cancel.mas_width);
        make.height.greaterThanOrEqualTo(@40);
        make.bottom.equalTo(v_BG).offset(-10);
    }];
    btn_Ok.tag=100;
    [btn_Ok addTarget:self action:@selector(btn_Event:) forControlEvents:UIControlEventTouchUpInside];
}
///点击事件
-(void)btn_Event:(UIButton *)sender
{
    if(self.eventBlock)
    {
        self.eventBlock(nil,sender,sender.tag);
    }
    [self dismissAlert];
}


/**
 *  单例方法
 *
 *  @return return value  返回类实例
 */
+ (MsgAlertView *)sharedMsgAlertView {
    static MsgAlertView * sharedMsgAlertView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMsgAlertView = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    });
    return sharedMsgAlertView;
}

////显示对话框
-(void)showMsgViewForMsg:(NSString *)msg btnOk:(NSString *)btnOkText btnCancel:(NSString *)btnCancelText blok:(ViewsEventBlock)blok
{
 
    self.eventBlock=blok;
    lab_MSG.text=msg;
    if([btnCancelText isEqualToString:@""])
    {
        btn_Cancel.hidden=YES;
        [btn_Ok mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(v_Line.mas_bottom).offset(10);
            make.left.equalTo(v_Line).offset(10);
            make.right.equalTo(v_Line).offset(-10);
            make.height.greaterThanOrEqualTo(@40);
            make.bottom.equalTo(v_BG).offset(-10);
        }];
    }
    [btn_Cancel setTitle:btnCancelText forState:UIControlStateNormal];
    [btn_Ok setTitle:btnOkText forState:UIControlStateNormal];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    self.frame=window.frame;
    self.backgroundColor=RGBAFrom0X(0x000000, 0.3);
    [window addSubview:self];
}

-(void) dismissAlert
{
    [self removeFromSuperview];
}


@end
