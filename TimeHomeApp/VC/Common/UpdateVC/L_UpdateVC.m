//
//  L_UpdateVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/7.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_UpdateVC.h"

@interface L_UpdateVC ()

@property (nonatomic, strong) NSString *content;

@property (weak, nonatomic) IBOutlet UIView *lsBackView;
@property (weak, nonatomic) IBOutlet UIButton *ls_newUnUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *ls_newUpBtn;

/**
 版本号 距上距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionTopConstraint;
/**
 版本号 距中间距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionCenterXConstraint;

/**
 版本号 宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionWidthConstraint;

/**
 内容距上距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopConstraint;

/**
 内容
 */
@property (weak, nonatomic) IBOutlet UITextView *content_TextView;

/**
 关闭按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *close_Button;

/**
 版本号
 */
@property (nonatomic, strong) NSString *versionStr;

@end

@implementation L_UpdateVC

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_content_TextView setContentOffset:CGPointZero animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lsBackView.layer.cornerRadius = 15;
    _ls_newUpBtn.layer.cornerRadius = 18;
    _ls_newUnUpBtn.layer.cornerRadius = 18;
    _ls_newUnUpBtn.layer.borderColor = kNewRedColor.CGColor;
    _ls_newUnUpBtn.layer.borderWidth = 1;
    //544:628 宽高比 左右35 (或38之间微调) 144 100 305 352
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    CGFloat marginWidth = 35.;
    
    _versionTopConstraint.constant = (SCREEN_WIDTH - marginWidth*2) * 628. / 544. * 144. / 352.;
    
    _versionCenterXConstraint.constant = 100. / 305. * (SCREEN_WIDTH - marginWidth*2);
    
//    NSString *str = @"V2.5.2";
    _versionStr = [NSString stringWithFormat:@"V%@",_versionStr];
  
    CGSize size = [_versionStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 18.) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.]} context:nil].size;
    
    _versionWidthConstraint.constant = size.width + 10.;
    
    _contentTopConstraint.constant = (SCREEN_WIDTH - marginWidth*2) * 628. / 544. * 170. / 352.;
    
    _version_Label.text = _versionStr;
    
    _version_Label.clipsToBounds = YES;
    _version_Label.layer.cornerRadius = 7.;
    
    _update_Button.layer.cornerRadius = 17.;
    _update_Button.clipsToBounds = YES;
    
    _content_TextView.editable = NO;
    _content_TextView.selectable = NO;

//    _content_TextView.text = @"1.【新增】每日签到可以抽奖啦，活动期间多种大奖等你来领\n2.【优化】我们优化了意见反馈的渠道，有问题您尽管提\n3.修复了一些BUG";
    _content_TextView.text = [XYString IsNotNull:_content];
//    _content_TextView.text = @"1.【新增】每日签到可以抽奖啦，活动期间多种大奖等你来领\n2.【优化】我们优化了意见反馈的渠道，有问题您尽管提\n3.修复了一些BUG\n1.【新增】每日签到可以抽奖啦，活动期间多种大奖等你来领\n2.【优化】我们优化了意见反馈的渠道，有问题您尽管提\n3.修复了一些BUG";

    if (_type == 1) {

        _close_Button.hidden = YES;
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_type == 1) {
        
        [self.ls_newUnUpBtn setHidden:YES];
        [self.ls_newUpBtn setHidden:YES];
        [self.update_Button setHidden:NO];
    }
}
#pragma mark - 按钮点击
- (IBAction)allBtnsDidTouch:(UIButton *)sender {
    
    [self dismissVC];
    //1.立即更新 2.关闭
    if (self.selectButtonCallBack) {
        self.selectButtonCallBack(nil, nil, sender.tag);
    }
    
}


/**
 *  返回实例
 */
+ (L_UpdateVC *)getInstance {
    L_UpdateVC * givenPopVC = [[L_UpdateVC alloc] initWithNibName:@"L_UpdateVC" bundle:nil];
    return givenPopVC;
}

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withMsg:(NSString *)msg withVersion:(NSString *)version cellEvent:(ViewsEventBlock)eventCallBack {
    
    self.selectButtonCallBack = eventCallBack;
    
    _content = [XYString IsNotNull:msg];
    _versionStr = [XYString IsNotNull:version];
    
//    _content= @"苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274苹果商店版本号： 274";
    
    
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }
    else{
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    [parent presentViewController:self animated:NO completion:^{
        
    }];
    
}

#pragma mark - 隐藏显示

-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
