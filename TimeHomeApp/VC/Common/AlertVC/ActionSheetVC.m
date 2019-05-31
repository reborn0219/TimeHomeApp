//
//  ActionSheetVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ActionSheetVC.h"

@interface ActionSheetVC ()<UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate>
{
}
@end
@implementation ActionSheetVC
#pragma mark - 单例初始化
+(instancetype)shareActionSheet {
    
    static ActionSheetVC * shareActionSheetVC = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareActionSheetVC = [[self alloc] initWithNibName:@"ActionSheetVC" bundle:nil];
        
    });
    return shareActionSheetVC;
    
}

#pragma mark - TableViewDataSource

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateTable];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 45;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld",(long)indexPath.row);
    self.block(self.data,nil,indexPath);

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,10,0,10)];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0,10)];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    self.table.delegate =self;
    self.table.dataSource =self;
    [self.view addSubview:self.table];
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.table]) {
        return NO;
    }
    return YES;
}

-(void)dismiss {
    [[ActionSheetVC shareActionSheet] dismissViewControllerAnimated:YES completion:nil];
}
-(void)showInVC:(UIViewController *)VC {
    
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }else {
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    [VC presentViewController:self animated:YES completion:nil];
    
}
-(void)updateTable {

    self.table.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    [self.table reloadData];

    [UIView animateWithDuration:0.3 animations:^{
        
        self.table.frame = CGRectMake(0, SCREEN_HEIGHT - self.data.count * 45, SCREEN_WIDTH, self.data.count * 45);

    }];
    
//    self.tableViewH.constant = self.data.count * 45;
//    [self.table reloadData];

}
@end
