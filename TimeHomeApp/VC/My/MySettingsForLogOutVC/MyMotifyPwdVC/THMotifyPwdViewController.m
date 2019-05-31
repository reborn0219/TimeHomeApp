//
//  THMotifyPwdViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMotifyPwdViewController.h"
#import "THMotifyPwdTVC.h"
#import "EncryptUtils.h"
#import "LogInPresenter.h"

@interface THMotifyPwdViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSArray *leftImages;
    LogInPresenter * logInPresenter;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THMotifyPwdViewController

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
    
    self.navigationItem.title = @"修改密码";
    
    leftImages = @[@"我的_设置_修改密码_手机号",@"我的_设置_修改密码_原密码",@"我的_设置_修改密码_新密码"];
    logInPresenter=[LogInPresenter new];

    [self createTableView];
    
}
- (void)createTableView {
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[THMotifyPwdTVC class] forCellReuseIdentifier:NSStringFromClass([THMotifyPwdTVC class])];
    
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    
    UIButton *qdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qdButton setBackgroundColor:kNewRedColor];
    [qdButton setTitle:@"确  定" forState:UIControlStateNormal];
    qdButton.titleLabel.font = DEFAULT_BOLDFONT(16);
    [qdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:qdButton];
    [qdButton addTarget:self action:@selector(qdButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [qdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(20);
        make.width.equalTo(@(WidthSpace(584)));
        make.height.equalTo(@(WidthSpace(80)));
        make.centerX.equalTo(view.mas_centerX);
    }];
    
    return view;
}
/**
 *  确定
 */
- (void)qdButtonClick {
    
    @WeakObj(self);
    THMotifyPwdTVC *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    THMotifyPwdTVC *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    [cell.rightTextField resignFirstResponder];
    [cell1.rightTextField resignFirstResponder];
    
    AppDelegate *appDelegate = GetAppDelegates;
    if (![appDelegate.userData.passWord isEqualToString:cell.rightTextField.text]) {
        [self showToastMsg:@"原密码输入错误" Duration:3.0];
        return;
    }
    NSString * regex  = @"[A-Z0-9a-z!@#$%^&*.~/\\{\\}|()'\"?><,.`\\+-=_\\[\\]:;]+";
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL b = [predicte evaluateWithObject:cell1.rightTextField.text];
    if (!b||(cell1.rightTextField.text.length!=6)) {
        [self showToastMsg:@"密码为6位字母数字或特殊字符！" Duration:3.0];
        return;
    }
  
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
    [indicator startAnimating:self.tabBarController];
    
    [logInPresenter changePassword:cell1.rightTextField.text upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [indicator stopAnimating];
            if(resultCode==SucceedCode)
            {
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
            }

            
        });
        
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THMotifyPwdTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THMotifyPwdTVC class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftImage.image = [UIImage imageNamed:leftImages[indexPath.row]];
    switch (indexPath.row) {
        case 0:
        {
            cell.rightControlStyle = RightControlStyleLabel;
            
            AppDelegate *appDelegate = GetAppDelegates;
            
            cell.rightLabel.text = appDelegate.userData.phone;
        }
            break;
        case 1:
        {
            cell.rightControlStyle = RightControlStyleTextField;
            cell.rightTextField.placeholder = @"输入原密码";
            cell.rightTextField.delegate = self;
            cell.rightTextField.enablesReturnKeyAutomatically = YES;
            cell.rightTextField.secureTextEntry = YES;
            [cell.rightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
            break;
        case 2:
        {
            cell.rightControlStyle = RightControlStyleTextField;
            cell.rightTextField.placeholder = @"输入新密码";
            cell.rightTextField.delegate = self;
            cell.rightTextField.enablesReturnKeyAutomatically = YES;
            cell.rightTextField.secureTextEntry = YES;
            [cell.rightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
            break;
            
        default:
            break;
    }
    
    
    
    
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


///输入改变事件
- (void) textFieldDidChange:(UITextField *) TextField{
    UITextRange * selectedRange = TextField.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(TextField.text.length>=6)
        {
            TextField.text=[TextField.text substringToIndex:6];
        }
    }
}


@end
