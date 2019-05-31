//
//  OrdinaryAddMoneyAlert.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/2/10.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "OrdinaryAddMoneyAlert.h"

@interface OrdinaryAddMoneyAlert ()<UITextFieldDelegate>

@end

@implementation OrdinaryAddMoneyAlert
+(instancetype)shareAddMoneyVC
{
    /**
     OrdinaryAddMoneyAlert * shareProblemsLoggingVC= [[OrdinaryAddMoneyAlert alloc] initWithNibName:@"OrdinaryAddMoneyAlert" bundle:nil];
     
     return shareProblemsLoggingVC;
     */
    static OrdinaryAddMoneyAlert * shareProblemsLoggingVC = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareProblemsLoggingVC = [[self alloc] initWithNibName:@"OrdinaryAddMoneyAlert" bundle:nil];
        
    });
    return shareProblemsLoggingVC;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isRandom = @"0";
    [self setUpUI];
}

- (void) setUpUI {
    
    _theNumberBG.layer.cornerRadius = 15.f;
    _theMoneyBG.layer.cornerRadius = 15.f;
    
    _theMoneyTF.delegate = self;
    _theMoneyTF.tag = 101;
    _theNumberTF.delegate = self;
    _theNumberTF.tag = 102;
    
    _theMoneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    _theNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    
    if ([_isRandom isEqualToString:@"0"]) {
        _theNumberTF.placeholder = @"红包个数最少10个";
        _theMoneyTF.placeholder = @"红包总金额";
        _theMoneyTFToRight.constant = 63;
        _showMessageLabel.hidden = NO;
        [_randomBtn setTitle:@"  随机金额" forState:UIControlStateNormal];
        [_randomBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
        
        [_fixedBtn setTitle:@"  固定金额" forState:UIControlStateNormal];
        [_fixedBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
        
    }else {
        _theNumberTF.placeholder = @"红包个数最少10个";
        _theMoneyTF.placeholder = @"单个红包金额";
        _theMoneyTFToRight.constant = 8;
        _showMessageLabel.hidden = YES;
        
        [_fixedBtn setTitle:@"  固定金额" forState:UIControlStateNormal];
        [_fixedBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-勾选"] forState:UIControlStateNormal];
        [_randomBtn setTitle:@"  随机金额" forState:UIControlStateNormal];
        [_randomBtn setImage:[UIImage imageNamed:@"登陆注册-记住密码-不勾选"] forState:UIControlStateNormal];
    }
}

-(void)show:(UIViewController * )VC
{
    [self setUpUI];
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
    _theNumberTF.text = @"";
    _theMoneyTF.text = @"";
    _isRandom = @"0";
    [self dismissViewControllerAnimated:NO completion:nil];
}

///点击半透明区域结束
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    [self dismiss];
//}

/**
 固定金额
 */
- (IBAction)fixedBtnClick:(id)sender {
    if ([_isRandom isEqualToString:@"1"]) {
        return;
    }
    _isRandom = @"1";
    
    [self setUpUI];
}

/**
 随机金额
 */
- (IBAction)randomBtnClick:(id)sender {
    
    if ([_isRandom isEqualToString:@"0"]) {
        return;
    }
    _isRandom = @"0";
    [self setUpUI];
}

/**
 确定按钮
 */
- (IBAction)okBtn:(id)sender {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *dataStr = @"";
    if ([_theNumberTF.text floatValue] < 10) {
        [self showToastMsg:@"红包数量最少为10" Duration:3.0f];
        return;
    }
    if ([_isRandom isEqualToString:@"0"]) {
        if ([_theMoneyTF.text floatValue] > 200.00) {
            [self showToastMsg:@"红包金额不能超过200元" Duration:3.0f];
            return;
        }
    }else {
        if ([_theMoneyTF.text floatValue] * [_theNumberTF.text floatValue] > 200.00) {
            [self showToastMsg:@"红包金额不能超过200元" Duration:3.0f];
            return;
        }
    }
    
    if ([_isRandom floatValue] == 1) {
        //固定金额的红包 单个限额最少0.1元
        if ([_theMoneyTF.text floatValue] < 0.1) {
            [self showToastMsg:@"单个红包金额最少为0.1元" Duration:3.0f];
            return;
        }
        
        dataStr = [NSString stringWithFormat:@"%.2ld/%@",[_theMoneyTF.text integerValue]*[_theNumberTF.text integerValue],_theNumberTF.text];
        
    }else {
        //随机金额的红包 总金额最少为1元
        if ([_theMoneyTF.text floatValue] < 1) {
            [self showToastMsg:@"红包总金额最少为1元" Duration:3.0f];
            return;
        }
        dataStr = [NSString stringWithFormat:@"%.2ld/%@",[_theMoneyTF.text integerValue],_theNumberTF.text];
    }
    [data addObjectsFromArray:@[_theNumberTF.text,_theMoneyTF.text,_isRandom]];
    [self.view endEditing:YES];
    [self dismiss];
    if(self.block){
        self.block(data,nil,0);
    }
}


/**
 关闭按钮
 */
- (IBAction)closeBtnClick:(id)sender {
    [self.view endEditing:YES];
    [self dismiss];
}






#pragma mark -- textfield代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 102) {
        if (textField.text.length >= 7) {
            //敲删除键
            if ([string length]==0) {
                return YES;
            }else {
                [self showToastMsg:@"最多只能输入7位" Duration:3.0f];
                return NO;
            }
        }
    }else {
        
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



#pragma mark --- texdtField事件
- (IBAction)tfTextChange:(id)sender {
    
    UITextField *tf = sender;
    UITextRange * selectedRange = tf.markedTextRange;
    
    if(selectedRange == nil || selectedRange.empty) {
        
        switch (tf.tag) {
            case 101:
            {
                
            }
                break;
            case 102:
            {
                if (tf.text.length >= 7) {
                    [self showToastMsg:@"最多只能输入7位" Duration:3.0f];
                    tf.text=[tf.text substringToIndex:7];
                    return;
                }

            }
                break;
                
            default:
                break;
        }
    }
}

@end
