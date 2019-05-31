//
//  THCommitSuggestionsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THCommitSuggestionsViewController.h"
#import "SignsView.h"
/**
 *  网络请求
 */
#import "AppSystemSetPresenters.h"

@interface THCommitSuggestionsViewController () <UITextViewDelegate>

@property (nonatomic, strong) SignsView *signView;

@end

@implementation THCommitSuggestionsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":SheZhi}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:SheZhi];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    
    [self createSignView];
}
- (void)createSignView {
    
    _signView = [[SignsView alloc]initWithFrame:CGRectMake(7, 10, SCREEN_WIDTH-14, WidthSpace(328))];
//    _signView.masLimitCount = MAXFLOAT;
    _signView.countsLabel.hidden = YES;
    _signView.signTextView.delegate = self;
    _signView.signTextView.placeHolder.text = @"请填写功能建议，服务建议，软件bug等";
    [self.view addSubview:_signView];
    
    UIButton *tjButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tjButton.backgroundColor = kNewRedColor;
    tjButton.titleLabel.font = DEFAULT_FONT(14);
    [tjButton setTitle:@"提    交" forState:UIControlStateNormal];
    [tjButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tjButton addTarget:self action:@selector(tjButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tjButton];
    [tjButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_signView.mas_bottom).offset(20);
        make.width.equalTo(@(WidthSpace(584)));
        make.height.equalTo(@(WidthSpace(64)));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _signView.signTextView.placeHolder.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        _signView.signTextView.placeHolder.hidden = NO;
    }else {
        _signView.signTextView.placeHolder.hidden = YES;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView {
    
    UITextRange * selectedRange = textView.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(textView.text.length >= 200)
        {
            textView.text = [textView.text substringToIndex:200];
        }
    }
    
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    if (![text isEqualToString:@""]){
//        
//        _signView.signTextView.placeHolder.hidden = YES;
//        
//    }
//    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
//        
//        _signView.signTextView.placeHolder.hidden = NO;
//    }
//    
//    if (range.location >= 30)
//    {
//        return  NO;
//    }
//    else
//    {
//        _signView.countsLabel.text = [NSString stringWithFormat:@"%ld/30",range.location];
//        return YES;
//    }
//    
//}

- (void)tjButtonClick {
    
    @WeakObj(self);
    /**
     *  保存用户反馈
     */
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
    [indicator startAnimating:self.tabBarController];
    [AppSystemSetPresenters addFeedBackContent:_signView.signTextView.text UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
            
        });

    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
