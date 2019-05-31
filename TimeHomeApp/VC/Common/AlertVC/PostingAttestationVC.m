//
//  PostingAttestationVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PostingAttestationVC.h"

@interface PostingAttestationVC ()
{
    NSString * titleStr;
    NSString * buttonTitleStr;
    UIColor *topViewBgColor;
}
@end

@implementation PostingAttestationVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.text = titleStr;
    [self.goButton setTitle:buttonTitleStr forState:UIControlStateNormal];
    _topView.backgroundColor = topViewBgColor;
    _goButton.layer.borderWidth = 1.0;
    _goButton.layer.borderColor = kNewRedColor.CGColor;
}

+(PostingAttestationVC *)getInstance {
    PostingAttestationVC * posting= [[PostingAttestationVC alloc] initWithNibName:@"PostingAttestationVC" bundle:nil];
    return posting;
}

+(instancetype)sharePostingAttestationVC {
    static PostingAttestationVC * posting = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        posting = [[self alloc] initWithNibName:@"PostingAttestationVC" bundle:nil];
        
    });
    
    return posting;
}
-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andButtonTitle:(NSString *)title2 andTopViewColor:(UIColor *)topViewColor {
    titleStr = title;
    buttonTitleStr = title2;
//    [_goButton setTitle:title2 forState:UIControlStateNormal];
    topViewBgColor = topViewColor;
    
    
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
    
    
    [VC presentViewController:self animated:YES completion:^{
        
    }];

}
-(void)showInVC:(UIViewController *)VC {
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
    
    
    [VC presentViewController:self animated:YES completion:^{
        
    }];

}
//-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andButtonTitle:(NSString *)title2 andTopViewColor:(UIColor *)topViewColor andBlcok:(ViewsEventBlock)blcok {
//    _block = blcok;
//    _titleLabel.text = title;
//    [_goButton setTitle:title2 forState:UIControlStateNormal];
//    _topView.backgroundColor = topViewColor;
//    _goButton.layer.borderWidth = 1.0;
//    _goButton.layer.borderColor = kNewRedColor.CGColor;
//    
//    if (self.isBeingPresented) {
//        return;
//    }
//    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//    /**
//     *  根据系统版本设置显示样式
//     */
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
//        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
//    }
//    else{
//        self.modalPresentationStyle=UIModalPresentationCustom;
//    }
//    
//    
//    [VC presentViewController:self animated:YES completion:^{
//        
//    }];
//
//}
//

-(void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)goButtonClick:(id)sender {
    if(self.block)
    {
        self.block(nil,nil,1);
    }
    
    [self dismiss];

}

- (IBAction)closeButtonClick:(id)sender {
    [self dismiss];
}

@end
