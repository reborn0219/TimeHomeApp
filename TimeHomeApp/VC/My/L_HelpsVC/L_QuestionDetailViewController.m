//
//  L_QuestionDetailViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_QuestionDetailViewController.h"

#import "SysPresenter.h"
#import "L_NewPointPresenters.h"

@interface L_QuestionDetailViewController ()

/**
 问题标题
 */
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;

/**
 问题回答
 */
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UILabel *ALabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftLabel;

@end

@implementation L_QuestionDetailViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_answerTextView setContentOffset:CGPointZero animated:NO];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _questionTitleLabel.text = _helpModel.title;
    _answerTextView.text = _helpModel.content;

//    [_answerTextView scrollRangeToVisible:NSMakeRange(0, 1) ];
//    _answerTextView.layoutManager.allowsNonContiguousLayout = NO;
    
    /** 更新积分信息 */
    [L_NewPointPresenters updUserIntebyTypeWithType:13 content:@"查看新手使用指南" costinte:@"0" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
    }];

}


/**
 联系客服
 */
- (IBAction)callButtonDidTouch:(UIButton *)sender {
    
//    SysPresenter * sysPresenter=[SysPresenter new];
//    [sysPresenter callMobileNum:@"4006555110" superview:self.view];
    [SysPresenter callPhoneStr:@"4006555110" withVC:self];
    
}


@end
