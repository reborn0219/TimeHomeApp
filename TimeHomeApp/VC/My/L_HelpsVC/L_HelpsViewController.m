//
//  L_HelpsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_HelpsViewController.h"
#import "L_QuestionDetailViewController.h"

#import "L_HelpListTVC.h"

#import "SysPresenter.h"

#import "L_NewMinePresenters.h"

@interface L_HelpsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *feedBackButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *callButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *callButtonRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;



@end

@implementation L_HelpsViewController


/**
 打电话
 */
- (IBAction)callButtonDidTouch:(UIButton *)sender {
    NSLog(@"打电话");
    
//    SysPresenter * sysPresenter=[SysPresenter new];
//    [sysPresenter callMobileNum:@"4006555110" superview:self.view];
    [SysPresenter callPhoneStr:@"4006555110" withVC:self];
}

#pragma mark - 帮助与反馈请求

/**
 帮助与反馈请求
 */
- (void)httpRequestForGethelptype {
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    [L_NewMinePresenters getHelpTypeUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                [dataArray addObjectsFromArray:data];
                
                [_tableView reloadData];
                
            }else {
               [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [[NSMutableArray alloc] init];
    
    _callButton.layer.borderWidth = 1;
    _callButton.layer.borderColor = kNewRedColor.CGColor;
    _callButton.layer.cornerRadius = 12;
    if (iPhone4And5) {

        _callButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _callButtonWidthConstraint.constant = 72;
        _callButtonRightConstraint.constant = 5;

    }
    
    if (kDevice_Is_iPhoneX) {
        _bottomLayout.constant = 8 + bottomSafeArea_Height;
    }
    
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"L_HelpListTVC" bundle:nil] forCellReuseIdentifier:@"L_HelpListTVC"];
    
    [self httpRequestForGethelptype];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64 + 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (dataArray.count > 0) {
        L_HelpListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_HelpListTVC"];
        
        L_HelpModel *model = dataArray[indexPath.section];
        cell.model = model;
        
        return cell;
        
    }else {
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_HelpModel *model = dataArray[indexPath.section];

    L_QuestionDetailViewController *questionDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_QuestionDetailViewController"];
    questionDetailVC.helpModel = model;
    [self.navigationController pushViewController:questionDetailVC animated:YES];
}

@end
