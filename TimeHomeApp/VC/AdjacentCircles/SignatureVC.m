//
//  SignatureVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/4/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SignatureVC.h"

@interface SignatureVC ()
{
    UITextView * textView;
}
@end

@implementation SignatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 24,SCREEN_WIDTH-20,200)];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.textColor = TEXT_COLOR;
    textView.editable = NO;
    [self.view addSubview:textView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    textView.text = self.signatureStr;
    
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

@end
