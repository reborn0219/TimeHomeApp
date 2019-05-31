//
//  THNickNameVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THNickNameVC.h"
#import "THNickNameTVC.h"
#import "THMyInfoPresenter.h"

@interface THNickNameVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
/**
 *  登录用户信息
 */
@property (nonatomic, strong) UserData *userData;

@end

@implementation THNickNameVC

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
    
    self.navigationItem.title = @"昵称";
    
    [self createRightBarBtn];
    
    AppDelegate *appDelegate = GetAppDelegates;
    _userData = appDelegate.userData;
    
    [self createTableView];
}

- (void)createRightBarBtn {
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completionClick)];
    [rightBtn setTintColor:kNewRedColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
/**
 *  完成
 */
- (void)completionClick {
    
    @WeakObj(self);
    [self resignResponder];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    THNickNameTVC *cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.nickNameTF.text isEqualToString:_userData.nickname]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([XYString isBlankString:cell.nickNameTF.text]) {
        [self showToastMsg:@"输入的昵称不能为空" Duration:3.0];
        return;
    }
    
    //保存我的昵称请求
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self];
    [THMyInfoPresenter perfectMyUserInfoDict:@{@"nickname":cell.nickNameTF.text} UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        [GCDQueue executeInGlobalQueue:^{
            [GCDQueue executeInMainQueue:^{
                [indicator stopAnimating];

                if(resultCode == SucceedCode)
                {
                    NSDictionary * remarkDic = @{_userData.userID:cell.nickNameTF.text};
                    
                    [[NSUserDefaults standardUserDefaults]setObject:remarkDic forKey:@"remarkName"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"remarkName" object:@"123"];
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                }
                
            }];
        }];

        
    }];
    
}

- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT-10) style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_tableView registerClass:[THNickNameTVC class] forCellReuseIdentifier:NSStringFromClass([THNickNameTVC class])];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THNickNameTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THNickNameTVC class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.nickNameTF.text = _userData.nickname;
    
    
    return cell;
}

- (void)resignResponder {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    THNickNameTVC *cell = (THNickNameTVC *)[_tableView cellForRowAtIndexPath:indexPath];
    [cell.nickNameTF resignFirstResponder];
}



@end
