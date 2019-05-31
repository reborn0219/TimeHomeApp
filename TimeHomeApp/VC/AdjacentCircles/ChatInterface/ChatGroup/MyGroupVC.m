//
//  MyGroupVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MyGroupVC.h"
#import "MyGroupDataVC.h"
#import "PopViewVC.h"
#import "CreateGroupNameVC.h"
#import "SearchGroupVC.h"

#import "MyGroupCell.h"

@interface  MyGroupVC()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView * table;
}
@end

@implementation MyGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"邻圈_群_群设置_举报-退出"] style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    self.navigationItem.title = @"我的群";
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
    [PopViewVC sharePopView].data = @[@"创建群",@"查找群"];
    [PopViewVC sharePopView].picData = @[@"邻圈_群_群组列表创建群",@"邻圈_群_群组列表_查找群"];
    [[PopViewVC sharePopView] showInVC:self];
    [PopViewVC sharePopView].block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
        [[PopViewVC sharePopView]dismiss];

        if(index.row == 0 )
        {
            CreateGroupNameVC * cgnVC = [[UIStoryboard storyboardWithName:@"Chat" bundle:nil]instantiateViewControllerWithIdentifier:@"CreateGroupNameVC"];
            [self.navigationController pushViewController:cgnVC animated:YES];
        }else
        {
            SearchGroupVC * sgVC = [[SearchGroupVC alloc]init];
            [self.navigationController pushViewController:sgVC animated:YES];
            
        }
        
    };

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
    return cell;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyGroupCell * cell = [tableView cellForRowAtIndexPath:indexPath];

    MyGroupDataVC * mgdVC = [[MyGroupDataVC alloc]init];
    mgdVC.navigationItem.title = cell.nameLb.text;
    [self.navigationController pushViewController:mgdVC animated:YES];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * v_0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 50)];
    
    [v_0 setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(5,0,40,40)];
    [btn setImage:[UIImage imageNamed:@"群聊_群成员"] forState: UIControlStateNormal];
    
    UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(40,0,SCREEN_WIDTH-40-40,40)];
    lb.font = [UIFont systemFontOfSize:14.0f];
    lb.textColor = UIColorFromRGB(0x8e8e8e);

    if (section == 0) {
        lb.text = @"我创建的群";
    }else if (section == 1)
    {
        lb.text = @"我加入的群";

    }
    
    [v_0 addSubview:lb];
    [v_0 addSubview:btn];
    
    return v_0;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
