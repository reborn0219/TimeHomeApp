//
//  MyGroupDataVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//



///vcs
#import "MyGroupDataVC.h"
#import "EditingGroupVC.h"
///views
#import "PopViewVC.h"
#import "MessageAlert.h"
///cells
#import "DetailInfoCell.h"
#import "GroupDetailCell.h"


@interface MyGroupDataVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * table;
    
}

@end

@implementation MyGroupDataVC

-(void)rightAction:(id)sender
{
//    [PopViewVC sharePopView].data = @[@"退出",@"取消"];
//    [[PopViewVC sharePopView] showInVC:self];
//    [PopViewVC sharePopView].block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
//    {
//        [[PopViewVC sharePopView]dismiss];
//        
//    };
    [[MessageAlert shareMessageAlert]showInVC:self withTitle:@"确定要退出群组吗？" andCancelBtnTitle:@"取消" andOtherBtnTitle:@"确定"];
    
    [MessageAlert shareMessageAlert].block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index){
        switch (index) {
            case Ok_Type:
            {
            
            }
                break;
            case Cancel_Type:
            {
                
            }
                break;
            default:
                break;
        }
        
    };


}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"邻圈_群_群设置_举报-退出"] style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    table = [[UITableView alloc]initWithFrame :CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-40-55) style:(UITableViewStyleGrouped)];
    
    [table setBackgroundColor:BLACKGROUND_COLOR];
    table.delegate = self;
    table.dataSource =self;
    [self.view addSubview:table];
    
    [table registerNib:[UINib nibWithNibName:@"GroupDetailCell" bundle:nil]  forCellReuseIdentifier:@"GroupDetailCell"];

    [table registerNib:[UINib nibWithNibName:@"DetailInfoCell" bundle:nil]  forCellReuseIdentifier:@"DetailInfoCell"];
    self.navigationItem.title = @"群名称";
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
    if (indexPath.section == 0) {
        GroupDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GroupDetailCell"];
        [cell.itemBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        return cell;
        
    }
    
    DetailInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailInfoCell"];
    if (indexPath.section ==  1) {
        [cell.swithbar setHidden:NO];
        cell.titleLb.text = @"消息免打扰";
        [cell.imgV setImage:[UIImage imageNamed:@"邻圈_群_群设置_消息免打扰"]];
        
    }else
    {
        [cell.swithbar setHidden:YES];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLb.text = @"我在本群的昵称";
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
                cell.titleLb.text = @"聊天记录";
                [cell.imgV setImage:[UIImage imageNamed:@"邻圈_群_群设置_聊天记录"]];

            }
                break;
            case 3:
            {
                cell.titleLb.text = @"编辑群资料";
                [cell.imgV setImage:[UIImage imageNamed:@"邻圈_群_群设置_编辑群资料"]];

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
        return 180;
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
    if (indexPath.section == 2) {
        
        if (indexPath.row==3) {
            
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return 1;
    }else if(section == 2)
    {
        return 4;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

@end
