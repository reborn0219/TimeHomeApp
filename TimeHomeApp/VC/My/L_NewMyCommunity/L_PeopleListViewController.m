//
//  L_PeopleListViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/29.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_PeopleListViewController.h"
#import "L_AddPeopleListTVC.h"
#import "L_AddFamilysViewController.h"

@interface L_PeopleListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *addPeopleButton;

@end

@implementation L_PeopleListViewController

/**
 添加家人
 */
- (IBAction)addPeopleButtonDidTouch:(UIButton *)sender {
    NSLog(@"添加家人");
    L_AddFamilysViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_AddFamilysViewController"];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"L_AddPeopleListTVC" bundle:nil] forCellReuseIdentifier:@"L_AddPeopleListTVC"];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 138;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    L_AddPeopleListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_AddPeopleListTVC"];
    
    
    return cell;
}
// MARK: - 兼容iOS 8方法需加上
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { }
// MARK: - Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// MARK: - 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
// MARK: - 自定义左滑显示编辑按钮
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"           " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        CommonAlertVC *alertVC = [CommonAlertVC getInstance];
        [alertVC ShowAlert:self Title:@"删除家人" Msg:@"是否确定删除家人?" oneBtn:@"取消" otherBtn:@"确定"];
        
        alertVC.eventCallBack = ^(id data, UIView *view , NSInteger index ){
            
            if (index == 1000) {
                //确定
                
            }
            
        };
        
    }];
    
    deleBtn.backgroundColor = NEW_RED_COLOR;
    NSArray *arr = @[deleBtn];
    
    return arr;
    
}


@end
