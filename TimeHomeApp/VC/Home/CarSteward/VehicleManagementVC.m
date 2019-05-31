//
//  VehicleManagementVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/8/16.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "VehicleManagementVC.h"
#import "VehicleCell.h"
#import "VehicleAlertVC.h"
#import "AddCarController.h"

#import "ModifyVehicleVC.h"
#import "ModifyVehicleBindingVC.h"
#import "CarManagerPresenter.h"
#import "LS_CarInfoModel.h"

@interface VehicleManagementVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * table;
    UIView * addView;
    NSArray * carList;
    
    
}
@end

@implementation VehicleManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"车辆管理";
    [self creatTable];
    
    [self creatAddView];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":QiCheGuanJia}];
}
-(void)creatTable
{
    table = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-64-50) style:(UITableViewStylePlain)];
    [self.view addSubview:table];
    table.dataSource = self;
    table.delegate =self;
    table.backgroundColor = UIColorFromRGB(0xf1f1f1);
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [table registerNib:[UINib nibWithNibName:@"VehicleCell" bundle:nil] forCellReuseIdentifier:@"VehicleCell"];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[UITableViewHeaderFooterView appearance] setTintColor:UIColorFromRGB(0xf1f1f1)];

}
-(void)creatAddView
{
    
    addView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-120, SCREEN_WIDTH,60)];
    addView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    UIView * middleView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 0, 60,50)];
    
    
    UIButton * addBtn = [[UIButton alloc]initWithFrame:middleView.bounds];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(15,0,30,30)];
    [imgV setImage:[UIImage imageNamed:@"汽车管家-车辆管理-添加车辆"]];
    [middleView addSubview:imgV];
    
    UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(0,30,60,20)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = @"添加车辆";
    lb.font = [UIFont systemFontOfSize:12.0f];
    lb.textColor = UIColorFromRGB(0x888888);
    [middleView addSubview:lb];
    
    
    [addView addSubview:middleView];
    [middleView addSubview:addBtn];
    [self.view addSubview:addView];
    [self.view bringSubviewToFront:addView];
    
}
/**
 *  添加车辆
 */
-(void)addAction:(UIButton *)btn
{
    AddCarController * addVC = [[AddCarController alloc]init];
    addVC.from = add;
    [self.navigationController pushViewController:addVC animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.nothingnessView.hidden = YES;
    @WeakObj(table);
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:QiCheGuanJia];
    
    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    
    [CarManagerPresenter getCarlist:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [indicator stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                carList = [LS_CarInfoModel mj_objectArrayWithKeyValuesArray:data];
                [tableWeak reloadData];
                
            }else
            {
                
                
                if(self.nothingnessView==nil)
                {
                    self.nothingnessView=[NothingnessView getInstanceView];
                    self.nothingnessView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50);
                    [self.view addSubview:self.nothingnessView];
                    [self.view bringSubviewToFront:self.nothingnessView];

                }
                self.nothingnessView.hidden = NO;
                
                self.nothingnessView.view_SubBg.hidden=YES;
                [self.nothingnessView.img_ErrorIcon setImage:[UIImage imageNamed:@"暂无数据"]];
                self.nothingnessView.lab_Clues.text = @"暂无车辆信息" ;

             
            }
            
            
        });
        
        
    }];
    
    [addView bringSubviewToFront:self.view];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VehicleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LS_CarInfoModel * LCIML = [carList objectAtIndex:indexPath.section];
    cell.titleLb.text = LCIML.alias;
    cell.contentLb.text = LCIML.card;
    [cell binding:LCIML.isbinding.boolValue];

    
  
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return carList.count;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LS_CarInfoModel * LCIML = [carList objectAtIndex:indexPath.section];
    
    
    ModifyVehicleBindingVC * vc = [[ModifyVehicleBindingVC alloc]init];
    vc.LS_CIFML = LCIML;
    
    [self.navigationController pushViewController:vc animated:YES];
    
//    if (!LCIML.isbinding.boolValue) {
//        
//        ModifyVehicleVC * vc = [[ModifyVehicleVC alloc]init];
//        vc.LS_CIFML = LCIML;
//        
//        [self.navigationController pushViewController:vc animated:YES];
//    }else
//    {
//        ModifyVehicleBindingVC * vc = [[ModifyVehicleBindingVC alloc]init];
//        vc.LS_CIFML = LCIML;
//
//        [self.navigationController pushViewController:vc animated:YES];
//    }
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
