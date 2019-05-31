//
//  L_PopAlertView2.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/8/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_PopAlertView2.h"

@interface L_PopAlertView2 ()

@property (weak, nonatomic) IBOutlet UILabel *message_Label;



@property (nonatomic, strong) NSString *content;

@end

@implementation L_PopAlertView2

- (IBAction)allButtonsDidClick:(UIButton *)sender {
    //1.确定 2.取消
    if (self.selectButtonCallBack) {
        self.selectButtonCallBack(nil, nil, sender.tag);
    }
    [self dismissVC];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    _cancel_Btn.layer.borderColor = kNewRedColor.CGColor;
    _cancel_Btn.layer.borderWidth = 1.;
    
    _msg_Label.text = [XYString IsNotNull:_content];
    
}

/**
 *  返回实例
 */
+ (L_PopAlertView2 *)getInstance {
    L_PopAlertView2 * givenPopVC = [[L_PopAlertView2 alloc] initWithNibName:@"L_PopAlertView2" bundle:nil];
    return givenPopVC;
}

/**
 显示
 */
- (void)showVC:(UIViewController *)parent withMsg:(NSString *)msg cellEvent:(ViewsEventBlock)eventCallBack {
    
    self.selectButtonCallBack = eventCallBack;
    
    _content = [XYString IsNotNull:msg];
    
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
