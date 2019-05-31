//
//  L_MyCurrentCommunityVC.m
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/29.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyCurrentCommunityVC.h"
#import "L_CurrentCommunityTVC.h"
#import "L_CommunityTitleTVC.h"

#import "L_VertifyStateViewController.h"

@interface L_MyCurrentCommunityVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 已认证列表数组
 */
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation L_MyCurrentCommunityVC



- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [[NSMutableArray alloc] init];
    _listArray = [[NSMutableArray alloc] init];

    UserCommunity *model = [[UserCommunity alloc] init];
    model.name = @"平安社区";
    model.address = @"维明大街43号，中京国际";
    
    [_dataArray addObject:model];
    [_dataArray addObject:_listArray];
    
    for (int i = 0; i < 5; i++) {
        UserCommunity *model = [[UserCommunity alloc] init];
        model.name = [NSString stringWithFormat:@"平安社区%d 平安社区%d 平安社区%d 平安社区%d 平安社区%d",i,i,i,i,i];
        model.address = @"维明大街43号，中京国际维明大街43号，中京国际维明大街43号，中京国际维明大街43号，中京国际";
        [_listArray addObject:model];
    }
    
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_CurrentCommunityTVC" bundle:nil] forCellReuseIdentifier:@"L_CurrentCommunityTVC"];
    [_tableView registerNib:[UINib nibWithNibName:@"L_CommunityTitleTVC" bundle:nil] forCellReuseIdentifier:@"L_CommunityTitleTVC"];

}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        return _listArray.count + 1;
    }
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 48;
        }else {
            UserCommunity *model = _dataArray[0];
            return model.height;
        }
    }else {
        if (indexPath.row == 0) {
            return 48;
        }else {
            UserCommunity *model = _listArray[indexPath.row-1];
            return model.height;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            L_CommunityTitleTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_CommunityTitleTVC"];
            cell.leftTitleLabel.text = @"当前社区";
            return cell;
            
        }else {
            
            L_CurrentCommunityTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_CurrentCommunityTVC"];
            cell.bottomLineView.hidden = YES;
            
            cell.userCommunityModel = _dataArray[0];
            
            return cell;
            
        }
        
    }else {
        
        if (indexPath.row == 0) {
            
            L_CommunityTitleTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_CommunityTitleTVC"];
            cell.leftTitleLabel.text = @"已认证社区";
            return cell;
            
        }else {
            
            L_CurrentCommunityTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_CurrentCommunityTVC"];
            cell.bottomLineView.hidden = YES;
            
            cell.userCommunityModel = _listArray[indexPath.row - 1];
            
            if (indexPath.row != _listArray.count) {
                cell.bottomLineView.hidden = NO;
            }
            
            return cell;
            
        }
        
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /** 认证状态 */
    L_VertifyStateViewController *vertifyStateVC = [self.storyboard instantiateViewControllerWithIdentifier:@"L_VertifyStateViewController"];
    
    if (indexPath.row == 1) {
        vertifyStateVC.stateImageName = @"业主认证-认证成功图标";
        vertifyStateVC.stateStr = @"业主认证成功";
        vertifyStateVC.content = @"您已获得门禁，电梯，二轮车共享权限；\r添加家人后，家人也将拥有门禁，电梯，二轮车的共享权限。";
        vertifyStateVC.state = 1;
    }
    if (indexPath.row == 2) {
        vertifyStateVC.stateImageName = @"业主认证-认证成功图标";
        vertifyStateVC.stateStr = @"业主认证成功";
        vertifyStateVC.content = @"您已获得门禁，电梯，二轮车共享权限；\r添加家人后，家人也将拥有门禁，电梯，二轮车的共享权限。";
        vertifyStateVC.state = 2;
    }
    if (indexPath.row == 3) {
        vertifyStateVC.stateImageName = @"业主认证-认证失败图标";
        vertifyStateVC.stateStr = @"业主认证失败";
        vertifyStateVC.content = @"失败原因：您提供的业主信息有误，房产信息和业主预留信息不一致。";
        vertifyStateVC.state = 3;
    }
    if (indexPath.row == 4) {
        vertifyStateVC.stateImageName = @"业主认证-认证成功图标";
        vertifyStateVC.stateStr = @"家人认证成功";
        vertifyStateVC.content = @"您已成功认证为小拉的家人，您将获得平安社区的门禁、电梯、二轮车的共享权限。";
        vertifyStateVC.state = 4;
    }
    if (indexPath.row == 5) {
        vertifyStateVC.state = 5;
    }
    
    [self.navigationController pushViewController:vertifyStateVC animated:YES];
    
}


@end
