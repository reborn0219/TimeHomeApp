//
//  MessageAlert.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/23.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MessageAlert.h"

@interface MessageAlert ()
{
    BlockEnumType type;
    NSString * msg;
    NSString * leftbtn;
    NSString * rightBtn;
    NSMutableAttributedString *attributedString;
}
@end

@implementation MessageAlert

#pragma mark - 单例初始化
+(instancetype)shareMessageAlert
{
    static MessageAlert * shareMessageAlert = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareMessageAlert = [[self alloc] initWithNibName:@"MessageAlert" bundle:nil];
        
    });

    return shareMessageAlert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.borderColor = TEXT_COLOR.CGColor;
   


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cancelBtn setHidden:NO];
    if(self.isHiddLeftBtn)
    {
        [self.cancelBtn setHidden:YES];
        [self.okBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
        }];
    }

    if (_isNull) {
        self.megLb.attributedText = attributedString;
    }else {
        self.megLb.text = msg;
    }

    if (_closeBtnIsShow) {
        [self.closeBtn setHidden:NO];
    }else {
        [self.closeBtn setHidden:YES];
    }
    
    [self.cancelBtn setTitle:leftbtn forState:UIControlStateNormal];
    [self.okBtn setTitle:rightBtn forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  获取实例
 *
 *  @return return value description
 */
+(MessageAlert *)getInstance{
    MessageAlert * alertVC= [[MessageAlert alloc] initWithNibName:@"MessageAlert" bundle:nil];
    return alertVC;
}



#pragma mark - buttonAction
- (IBAction)clickBtnAction:(id)sender {
    
    UIButton * btn = sender;

    if (btn.tag==1000) {
        type = Cancel_Type;
    }else if(btn.tag ==1001)
    {
        type = Ok_Type;
    }
    if(self.block)
    {
       self.block(nil,nil,type); 
    }
    
    [self dismiss];
}


/**closeButton  关闭按钮默认隐藏，需要时设为显示 */
- (IBAction)closeBtn:(id)sender {
    
    
    [self dismiss];

    
}



-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)showInVC:(UIViewController *)VC withTitle:(NSString *)title andCancelBtnTitle:(NSString *)cancelBtnTitle andOtherBtnTitle:(NSString *)otherBtnTitle
{
    msg=title;
    leftbtn=cancelBtnTitle;
    rightBtn=otherBtnTitle;
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

/** 富文本提示 */
- (void)newShowInVC:(UIViewController *)VC withTitle:(NSMutableAttributedString *)title andCancelBtnTitle:(NSString *)cancelBtnTitle andOtherBtnTitle:(NSString *)otherBtnTitle {
    
    
    attributedString = title;
    leftbtn=cancelBtnTitle;
    rightBtn=otherBtnTitle;
    
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

@end
