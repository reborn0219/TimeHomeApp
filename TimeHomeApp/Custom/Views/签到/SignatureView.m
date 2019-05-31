//
//  SignatureView.m
//  TimeHomeApp
//
//  Created by us on 16/4/14.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SignatureView.h"

@implementation SignatureView
{
    ///图片背景
    UIImageView * img_BG;
    ///显示提示文字
    UILabel * lab_Text;
    ///积分
    UILabel * lab_Integral;
    BOOL isShengji;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=RGBAFrom0X(0x000000,0.0);
        [self initViews];

    }
    return self;
}
///添加视图
-(void)initViews
{
    isShengji = NO;
    img_BG=[[UIImageView alloc]init];
    img_BG.contentMode=UIViewContentModeScaleAspectFill;
    [self addSubview:img_BG];
    [img_BG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.65);
        make.height.mas_equalTo(self.mas_width).multipliedBy(0.8);
    }];
    lab_Integral=[[UILabel alloc]init];
    [self addSubview:lab_Integral];
    lab_Integral.textAlignment=NSTextAlignmentCenter;
    lab_Integral.font=DEFAULT_FONT(20);
    lab_Integral.textColor=UIColorFromRGB(0xffffff);
    [lab_Integral mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(img_BG);
        make.width.equalTo(img_BG);
        make.height.equalTo(@30);
        
    }];

    lab_Text=[[UILabel alloc]init];
    [self addSubview:lab_Text];
    [lab_Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(img_BG).offset(-10);
        make.bottom.equalTo(img_BG).offset(-10);
        make.left.equalTo(img_BG).offset(10);
        make.height.equalTo(@30);
        
    }];
    lab_Text.textAlignment=NSTextAlignmentRight;
    lab_Text.font=DEFAULT_FONT(15);
    lab_Text.textColor=UIColorFromRGB(0xffffff);
}
-(void)showShengJi
{
    
    AppDelegate *appDlgt =  GetAppDelegates;
    NSString * tmp=[NSString stringWithFormat:@"LV%@",appDlgt.userData.level];
    lab_Text.text=@"";
    lab_Integral.text=tmp;
    [img_BG setImage:[UIImage imageNamed:@"升级"]];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    self.frame=window.frame;
    [window addSubview:self];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(dismissView) userInfo:nil repeats:NO];
    

}
-(void)dismissThisView {
    [self removeFromSuperview];
}

///显示视图
-(void)showViewForText:(NSString *)text  Integral:(NSString *)integral flag:(int )flag
{
    
    lab_Text.text=text;
    lab_Integral.text=integral;
    [img_BG setImage:[UIImage imageNamed:@"签到"]];
    
    if(flag==1)
    {
        isShengji = YES;
    }else if(flag == 0)
    {
        isShengji = NO;
    }
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    self.frame=window.frame;
    [window addSubview:self];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(waiting) userInfo:nil repeats:NO];
}


-(void)dismissView
{
    
    [UIView animateWithDuration:1 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

        if (self.firstCallBack) {
            self.firstCallBack();
        }
        if(self.delegate)
        {
            [self.delegate finshedView];
        }
    }];
}

-(void)waiting
{
    
    if(isShengji)
    {
        
        AppDelegate *appDlgt =  GetAppDelegates;
        NSString * tmp=[NSString stringWithFormat:@"LV%@",appDlgt.userData.level];
        lab_Text.text=@"";
        lab_Integral.text=tmp;
        [img_BG setImage:[UIImage imageNamed:@"升级"]];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(waitingTwo) userInfo:nil repeats:NO];
        isShengji = NO;
        
    }else
    {
        [self dismissView];
 
    }
}

-(void)waitingTwo
{
    [self dismissView];
}


@end
