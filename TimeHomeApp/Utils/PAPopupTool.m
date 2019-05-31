//
//  PAPopupTool.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/3.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAPopupTool.h"
#import "PAChooseLicensePlateNumberView.h"
#define Choose_View_H (SCREEN_WIDTH-20-9*2)/10*4+3*2+2*10

@interface PAPopupTool()
/**
 无网络弹框
 */
@property (nonatomic, strong) UIView * notNetworkView;
@property (nonatomic, strong) PAChooseLicensePlateNumberView *chooseLicenseView;

@end
@implementation PAPopupTool

#pragma mark - 单例
+ (instancetype)sharePAPopupTool{
    
    static PAPopupTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.popupNumbers = @1;
    });
    return instance;
}

#pragma mark - 键盘弹框UI
-(PAChooseLicensePlateNumberView *)chooseLicenseView
{
    if (_chooseLicenseView == nil) {
        
        _chooseLicenseView = [[[NSBundle mainBundle]loadNibNamed:@"PAChooseLicensePlateNumberView" owner:self options:nil] lastObject];
        _chooseLicenseView.popupAnimationDisplacement = Choose_View_H;
        
    }
    return _chooseLicenseView;
    
}
#pragma mark - 懒加载初始化无网络显示UI

-(UIView *)notNetworkView
{
    if (_notNetworkView==nil) {
        
        ///#FF5C5D
        _notNetworkView = [[UIView alloc] init];
        
        if (SCREEN_HEIGHT == 812) {
            //IphoneX 下移20像素
            _notNetworkView.frame = CGRectMake(0, 40,SCREEN_WIDTH, 40);
        }else{
            
            _notNetworkView.frame = CGRectMake(0, 20,SCREEN_WIDTH, 40);
            
        }
        _notNetworkView.backgroundColor = [UIColor colorWithRed:255/255 green:92/255 blue:93/255 alpha:1];
        UIImageView * imgView = [[UIImageView alloc]init];
        imgView.frame = CGRectMake(16, 11, 18, 18);
        [imgView setImage: [UIImage imageNamed:@"dl_icon_gth_n"]];
        [_notNetworkView addSubview:imgView];
        
        UIButton  * button = [[UIButton alloc]init];
        button.frame = CGRectMake(SCREEN_WIDTH-40, 0, 40, 40);
        [button setImage:[UIImage imageNamed:@"dl_icon_close_n"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dissmissButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_notNetworkView addSubview:button];
        
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(16+18+10, 14, SCREEN_WIDTH-(16+18+10-40), 13);
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.text = @"当前处于断网状态，断网也可以使用摇一摇通哦";
        [_notNetworkView addSubview:label];
        
    }
    return _notNetworkView;
    
}
-(void)dissmissButtonClick
{
    self.popupNumbers = @0;
    [self.notNetworkView removeFromSuperview];
}
#pragma mark - 显示无网络弹框
-(void)showNotNetworkView
{
    
#warning 如果需要控制显示次数 可以设置 popupNumbers
    if(self.popupNumbers.integerValue){
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview: self.notNetworkView];
    }
}
#pragma mark - 省份键盘
-(void)showProvincesKeyBoard:(UpDateViewsBlock)block
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview: self.chooseLicenseView];
    
    @WeakObj(window);
    [self.chooseLicenseView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(windowWeak.mas_left).offset(0);
        make.right.equalTo(windowWeak.mas_right).offset(0);
        make.top.equalTo(windowWeak.mas_bottom).offset(0);
        make.height.equalTo(@(Choose_View_H));

    }];
    self.chooseLicenseView.block = block;
    
}
-(void)popupKeyBoard:(BOOL)show
{
    [self.chooseLicenseView popupKeyBoard:show];
    
}
#pragma mark - 隐藏
-(void)dissmissView
{
    [self.notNetworkView removeFromSuperview];
    [self.chooseLicenseView removeFromSuperview];
}

@end
