//
//  THMySignsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMySignsViewController.h"
#import "SignsView.h"
#import "THMyInfoPresenter.h"

@interface THMySignsViewController () <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SignsView *signView;
/**
 *  登录用户信息
 */
@property (nonatomic, strong) UserData *userData;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THMySignsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:GeRenSheZhi];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":GeRenSheZhi}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个性签名";
    
    [self createRightBarBtn];
    
    AppDelegate *appDelegate = GetAppDelegates;
    _userData = appDelegate.userData;
    
    [self createTableView];

}
- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(7, 0, SCREEN_WIDTH-14, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return WidthSpace(328);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _signView = [[SignsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-14, WidthSpace(328))];
    _signView.signTextView.delegate = self;
    if (![XYString isBlankString:_userData.signature]) {
        _signView.signTextView.text = _userData.signature;
        _signView.signTextView.placeHolder.text = @"";
        
    }else {
        _signView.signTextView.placeHolder.text = @"我在平安社区，你在哪？";
    }
    [cell.contentView addSubview:_signView];
    
    NSString *signString = [XYString IsNotNull:_userData.signature];
    
    _signView.countsLabel.text = [NSString stringWithFormat:@"%ld/30",(unsigned long)signString.length];
    _signView.cancel_Button.hidden = NO;
    @WeakObj(_signView);
    _signView.callBack = ^{
        
        _signViewWeak.signTextView.text = @"";
        _signViewWeak.signTextView.placeHolder.text = @"我在平安社区，你在哪？";
        _signViewWeak.signTextView.placeHolder.hidden = NO;
        _signViewWeak.countsLabel.text = [NSString stringWithFormat:@"0/30"];
        
    };
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = SCREEN_WIDTH/2-7;

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, width, 0, width)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, width, 0, width)];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _signView.signTextView.placeHolder.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    UITextRange * selectedRange = textView.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        
        if(textView.text.length>=30)
        {
            textView.text=[textView.text substringToIndex:30];
        }
        _signView.countsLabel.text = [NSString stringWithFormat:@"%ld/30",(unsigned long)textView.text.length];

    }

}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//
//    if (![text isEqualToString:@""]){
//        
//        _signView.signTextView.placeHolder.hidden = YES;
//        
//    }
//    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
//        
//        _signView.signTextView.placeHolder.hidden = NO;
//
//    }
//
//    NSString * toBeString = [ _signView.signTextView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
//    _signView.countsLabel.text = [NSString stringWithFormat:@"%ld/30",(unsigned long)toBeString.length];
//    
//    if (toBeString.length != 0) {
//        _signView.signTextView.placeHolder.hidden = YES;
//    }
//
//    if (_signView.signTextView == textView)  //判断是否时我们想要限定的那个输入框
//    {
//        if ([toBeString length] > 30) { //如果输入框内容大于30则弹出警告
//            textView.text = [toBeString substringToIndex:30];
//            _signView.countsLabel.text = [NSString stringWithFormat:@"%ld/30",(unsigned long)textView.text.length];
//            return NO;
//        }
//    }
//    return YES;
//
//}
- (void)createRightBarBtn {
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completionClick)];
    [rightBtn setTintColor:kNewRedColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
- (void)completionClick {
    
    @WeakObj(self);
    
    [_signView resignFirstResponder];

    if ([XYString isBlankString:_signView.signTextView.text]) {
        [self showToastMsg:@"输入的内容不能为空" Duration:2.0];
        return;
    }
    
    if ([_signView.signTextView.text isEqualToString:_userData.signature]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //保存我的签名请求
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self];
    [THMyInfoPresenter perfectMyUserInfoDict:@{@"signature":_signView.signTextView.text} UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicator stopAnimating];
            
            if(resultCode == SucceedCode)
            {
                
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
            }
        });
        
    }];
}




@end
