//
//  RaiN_NewRegisterAlert.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/8/4.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_NewRegisterAlert.h"

@interface RaiN_NewRegisterAlert ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RaiN_NewRegisterAlert

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    _cancelBtn.layer.borderColor = kNewRedColor.CGColor;
    _cancelBtn.layer.borderWidth = 1.0f;
}


#pragma mark - 初始化
+(instancetype)shareNewRegisterAlert {
    
    RaiN_NewRegisterAlert * newRegisterAlert= [[RaiN_NewRegisterAlert alloc] initWithNibName:@"RaiN_NewRegisterAlert" bundle:nil];
    return newRegisterAlert;
}
-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andCancelBtn:(NSString *)cancelBtn andRegisterBtn:(NSString *)registerBtn {
    
    if ([XYString isBlankString:title]) {
        _titleLabel.text = @"此手机号未注册，点击注册按钮可以注册新账户";
    }else {
        _titleLabel.text = title;
    }
    if ([XYString isBlankString:cancelBtn]) {
        _titleLabel.text = @"再等等";
    }else {
        _titleLabel.text = cancelBtn;
    }
    if ([XYString isBlankString:registerBtn]) {
        _titleLabel.text = @"注册";
    }else {
        _titleLabel.text = registerBtn;
    }
    
    
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
    
    
     self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [VC presentViewController:self animated:YES completion:^{
        
    }];
}

#pragma mark ---- 按钮点击事件
/**
 注册按钮点击
 */
- (IBAction)registerBtnClick:(id)sender {
    
    if (self.block) {
        [self dismiss];
        self.block(nil, nil, 0);
    }
}


/**
 取消按钮点击
 */
- (IBAction)cancelBtnClick:(id)sender {
    [self dismiss];
}

-(void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
