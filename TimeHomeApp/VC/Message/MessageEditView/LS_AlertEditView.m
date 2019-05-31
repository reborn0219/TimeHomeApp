//
//  LS_AlertEditView.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/2/7.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_AlertEditView.h"

@interface LS_AlertEditView ()
{
    
    AlertBlock tempBlock;
}
@end

@implementation LS_AlertEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    _backView.layer.cornerRadius= 5;
    _okBtn.layer.cornerRadius = 3;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)showEditDetermine:(UIViewController *)parentVC andBlock:(AlertBlock)block
{
    tempBlock = block;
    
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
    [parentVC presentViewController:self animated:YES completion:^{
        
    }];
    
}


- (IBAction)okBtnAction:(id)sender {
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if (tempBlock) {
        tempBlock(1);
    }
}

- (IBAction)cancelBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];

    if (tempBlock) {
        tempBlock(0);
    }
}
@end
