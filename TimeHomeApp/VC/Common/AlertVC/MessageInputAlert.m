//
//  MessageInputAlert.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/8/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MessageInputAlert.h"

@interface MessageInputAlert ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberLb;

@end

@implementation MessageInputAlert

+(instancetype)shareMessageInputAlert
{
    static MessageInputAlert * shareMessageInputAlert = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareMessageInputAlert = [[self alloc] initWithNibName:@"MessageInputAlert" bundle:nil];
        
    });
    return shareMessageInputAlert;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textV.text = @"";
    _numberLb.text = @"0/50";
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
    [self dismissViewControllerAnimated:NO completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textV.delegate = self;
    
    self.backV.layer.borderWidth = 1;
    self.backV.layer.borderColor = UIColorFromRGB(0x5A5656).CGColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeAction:(id)sender {
    
    
    if (_block) {
        _block(_textV.text,0);
    }
    
    [self dismiss];
}

- (IBAction)comfirmAction:(id)sender {
    
    if ([XYString isBlankString:_textV.text]) {
        
        [AppDelegate showToastMsg:@"请输入删除原因" Duration:2.5f];
        
        return;
    }
    if (_block) {
        _block(_textV.text,1);
    }
    
    [self dismiss];
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    
    UITextRange * selectedRange = textView.markedTextRange;
    
    if(selectedRange == nil || selectedRange.empty){
        
        _numberLb.text = [NSString stringWithFormat:@"%ld/50",textView.text.length>50?50:textView.text.length];
        if(textView.text.length>=50)
            
        {
            
            textView.text=[textView.text substringToIndex:50];
            
        }
        
    }
}
@end
