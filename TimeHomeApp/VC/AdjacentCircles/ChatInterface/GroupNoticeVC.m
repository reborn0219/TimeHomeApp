//
//  GroupNoticeVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "GroupNoticeVC.h"
#import "MyGroupCell.h"
#import "PopViewVC.h"
#import "GroupRequestVC.h"

@interface  GroupNoticeVC()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView * table;
}
@end

@implementation GroupNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
    
    self.navigationItem.rightBarButtonItem = rightBar;
    
    self.navigationItem.title = @"群通知";
    table = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    table.delegate =self;
    table.dataSource=self;
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    [table setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    [table registerNib:[UINib nibWithNibName:@"MyGroupCell" bundle:nil] forCellReuseIdentifier:@"myGroupCell"];
}
#pragma mark - 导航栏右侧按钮事件
-(void)rightAction:(id)sender
{
   ///清空群消息
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableviewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyGroupCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myGroupCell"];
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        cell.contentLb.text = @"申请加入 篮球俱乐部";
        
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone; //显示最右边的箭头
        cell.contentLb.text = @"已退出 金谈固篮球俱乐部";

    }

    return cell;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if(section == 1)
    {
        return 3;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MyGroupCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    GroupRequestVC * grVC = [[UIStoryboard  storyboardWithName:@"Chat" bundle:nil]instantiateViewControllerWithIdentifier:@"GroupRequestVC"];
    [self.navigationController pushViewController:grVC animated:YES];
    
}
@end
