//
//  QuestionAddMoneyAlert.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/10.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "QuestionAddMoneyAlert.h"

@interface QuestionAddMoneyAlert ()<UITextFieldDelegate>

@end

@implementation QuestionAddMoneyAlert
+(instancetype)shareAddMoneyVC
{
    static QuestionAddMoneyAlert * shareProblemsLoggingVC = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareProblemsLoggingVC = [[self alloc] initWithNibName:@"QuestionAddMoneyAlert" bundle:nil];
        
    });
    return shareProblemsLoggingVC;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _textFieldBG.layer.cornerRadius = 17.5f;
    _moneyTf.keyboardType = UIKeyboardTypeDecimalPad;
    _moneyTf.delegate = self;
}

-(void)show:(UIViewController * )VC
{
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
-(void)dismiss
{
    _moneyTf.text = @"";
    [self dismissViewControllerAnimated:NO completion:nil];
}

///点击半透明区域结束
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    [self dismiss];
//}

- (IBAction)closeButtonClick:(id)sender {
    [self dismiss];
    
}
- (IBAction)okButtonClick:(id)sender {
    if ([_moneyTf.text floatValue] >200.00) {
        [self showToastMsg:@"现金奖励最多200" Duration:3.0f];
        return;
    }
    if(self.block)
    {
        self.block(_moneyTf.text,nil,0);
    }
    [self.view endEditing:YES];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 7) {
        //敲删除键
        if ([string length]==0) {
            return YES;
        }else {
            [self showToastMsg:@"最多只能输入7位" Duration:3.0f];
            return NO;
        }
    }
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag=0;
    const NSInteger limited = 2;
    for (NSInteger i = futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                
                [self showToastMsg:@"小数点后只能保留2位" Duration:3.0f];
                return NO;
            }
            
            break;
        }
        flag++;
    }
    
    return YES;
}



/**
 显示消息提示并自动消失
 */
-(void)showToastMsg:(NSString *)message Duration:(float)duration {
    
    if (![message isKindOfClass:[NSString class]]) {
        return;
    }
    
    if ([XYString isBlankString:message]) {
        return;
    }
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    
    CGSize LabelSize = [message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
    
    label.frame = CGRectMake(10, 10, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.numberOfLines = 0; //
    
    [showview addSubview:label];
    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width)/2-10, SCREEN_HEIGHT/2-50, LabelSize.width+20, LabelSize.height+20);
    [UIView animateWithDuration:duration animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

@end
