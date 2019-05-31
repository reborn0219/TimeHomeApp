//
//  GroupCreateSuccessVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "GroupCreateSuccessVC.h"
#import "DetailInfoCell.h"

@interface GroupCreateSuccessVC ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView * table;

}
@end

@implementation GroupCreateSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:BLACKGROUND_COLOR];
    table = [[UITableView alloc]initWithFrame :CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-40-55) style:(UITableViewStyleGrouped)];
    
    [table setBackgroundColor:BLACKGROUND_COLOR];
    table.delegate = self;
    table.dataSource =self;
    [self.view addSubview:table];
    
    [table registerNib:[UINib nibWithNibName:@"DetailInfoCell" bundle:nil]  forCellReuseIdentifier:@"DetailInfoCell"];
    self.navigationItem.title = @"创建成功";
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
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

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailInfoCell"];
    [cell.swithbar setHidden:YES];

    if (indexPath.section ==  0) {
        cell.titleLb.text = @"群名称";
        [cell.imgV setImage:[UIImage imageNamed:@"邻圈_群_群设置_消息免打扰"]];
        
    }else
    {
        [cell.swithbar setHidden:YES];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLb.text = @"添加群成员";
                [cell.imgV setImage:[UIImage imageNamed:@"邻圈_群_群设置_我在本群昵称"]];
                
            }
                break;
            case 1:
            {
                cell.titleLb.text = @"分享本群";
                [cell.imgV setImage:[UIImage imageNamed:@"邻圈_群_群设置_分享本群"]];
                
            }
                break;
            case 2:
            {
                cell.titleLb.text = @"完善资料";
                [cell.imgV setImage:[UIImage imageNamed:@"邻圈_群_群设置_聊天记录"]];
                
            }
                break;
          
            default:
                break;
        }
    }
    return cell;
    
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0&&indexPath.row == 0 ) {
        return 80;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return 3;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

@end

