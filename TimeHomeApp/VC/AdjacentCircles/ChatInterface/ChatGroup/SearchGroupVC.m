//
//  SearchGroupVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "SearchGroupVC.h"
#import "FriendsCell.h"

@interface SearchGroupVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * table;
}
@end

@implementation SearchGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    table = [[UITableView alloc]initWithFrame:CGRectMake(10, 0,SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    table.delegate =self;
    table.dataSource =self;
    [self.view addSubview:table];
    [table registerNib:[UINib nibWithNibName:@"FriendsCell" bundle:nil] forCellReuseIdentifier:@"FriendsCell"];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.title = @"找群";
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableviewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        FriendsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsCell"];
        cell.timeLb.text  = @"100";
        cell.timeLb.textColor = UIColorFromRGB(0x127833);
        return cell;
        
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return 1;
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
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
        if (section == 0) {
            UIView * v_0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 50)];
            
            [v_0 setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
            
            UIView * backV = [[UIView alloc]initWithFrame:CGRectMake(10,5,SCREEN_WIDTH-20-20,40)];
            backV.layer.borderWidth = 1;
            backV.layer.borderColor = UIColorFromRGB(0xdadada).CGColor;
            
            [v_0 addSubview:backV];
            
            
            UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(6,7.5,25,25)];
            [imgV setImage:[UIImage imageNamed:@"邻圈_群_群组列表_查找群"]];
            UIImageView * imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(35,5,1,30)];
            [imgLine setBackgroundColor:UIColorFromRGB(0xdadada)];
            
            UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(40   , 0, SCREEN_WIDTH-40-40,40)];
            lb.text = @"昵称／手机号／门牌号";
            lb.font = [UIFont systemFontOfSize:12.0f];
            lb.textColor = UIColorFromRGB(0x8e8e8e);
            [backV addSubview:lb];
            [backV addSubview:imgLine];
            [backV addSubview:imgV];
            UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapGestAction:)];
            [v_0 addGestureRecognizer:gest];
       
            return v_0;
        }
            return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

#pragma mark - headerViewAction
-(void)headerTapGestAction:(UIGestureRecognizer *)gestInfo
{
    ///搜索好友
    
}
@end
