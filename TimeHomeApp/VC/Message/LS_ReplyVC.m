//
//  LS_ReplyVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 17/3/16.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "LS_ReplyVC.h"
#import "BBSMainPresenters.h"

@interface LS_ReplyVC ()<UITextViewDelegate>

@end

@implementation LS_ReplyVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"回复评论";
    [self.scrollView addSubview:self.textView];
    [self.view addSubview:self.scrollView];

    [self createRightBar];
    self.textView.delegate =self;
    
    
}
#pragma mark - 初始化右侧导航发送按钮
-(void)createRightBar
{
    [self.navigationController.navigationBar setBarTintColor:NABAR_COLOR];
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 70,30)];
    [bt setBackgroundColor:[UIColor whiteColor]];
    bt.layer.cornerRadius = 15;
    [bt setTitle:@"发  送" forState:UIControlStateNormal];
    [bt.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [bt setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBt = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.rightBarButtonItem = rightBarBt;
}
-(void)rightBtnAction:(id)sender
{
    
    [_textView resignFirstResponder];
    NSString * content = _textView.text;
    NSString *string = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
    if ([XYString isBlankString:string]||_textView.tag==0) {
        [self showToastMsg:@"回复内容不能为空" Duration:3.0];
        return;
    }
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    @WeakObj(self);
    [BBSMainPresenters addCommentWithID:_postID withContent:content withCommentID:_commentID updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
             
                [selfWeak showToastMsg:@"评论成功" Duration:3.0];
                [selfWeak.navigationController popViewControllerAnimated:YES];
              
            }else {
                [selfWeak showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -初始化scrollView
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height))];
        _scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = BLACKGROUND_COLOR;
        
    }
    return _scrollView;
}
#pragma mark -初始化TextView
-(UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-(44+statuBar_Height))/2)];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.text = [NSString stringWithFormat:@"回复%@：",_replyName];
        _textView.textColor = UIColorFromRGB(0xaaaaaa);
        
    }
    return _textView;
}
#pragma mark - TextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.tag == 0) {
        textView.text = @"";
        textView.textColor = TITLE_TEXT_COLOR;
        textView.tag = 1;
    }
    return YES;
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length==0) {
        
        textView.text = [NSString stringWithFormat:@"回复%@：",_replyName];
        textView.textColor = UIColorFromRGB(0xaaaaaa);
        textView.tag = 0;
    }
}
@end
