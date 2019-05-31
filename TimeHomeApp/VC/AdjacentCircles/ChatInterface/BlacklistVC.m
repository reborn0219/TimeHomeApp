//
//  BlacklistVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/15.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BlacklistVC.h"
#import "FriendsCell.h"
///models
#import "ChatPresenter.h"
#import "UserInfoModel.h"
#import "ChatViewController.h"
#import "PersonalDataVC.h"
#import "ChatPresenter.h"
#import "WebViewVC.h"
#import "personListViewController.h"

@interface  BlacklistVC()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    UITableView * table;
    NSMutableArray * blackArr;
    NSString * searchStr;
    NSInteger page;
    
}
@end

@implementation BlacklistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    page= 1;
    searchStr = @"";
    blackArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.navigationItem.title = @"黑名单";
    table = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    table.delegate =self;
    table.dataSource=self;
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    [table setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    [table registerNib:[UINib nibWithNibName:@"FriendsCell" bundle:nil] forCellReuseIdentifier:@"friendsCell"];
    @WeakObj(self)
    
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadone];
    }];
    table.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak loadmore];

    }];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self loadone];

}
-(void)loadmore
{
    page ++;
    @WeakObj(table)
    [ChatPresenter getUserBlackList:^(id  _Nullable data, ResultCode resultCode) {
        
        NSLog(@"黑名单－－－%@",data);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [tableWeak.mj_footer endRefreshing];

            switch (resultCode) {
                case SucceedCode:
                {
                    [blackArr addObjectsFromArray:data];
                    [tableWeak reloadData];
    
                }
                    break;
                case FailureCode:
                {
                    page --;
                    NSLog(@"没有数据");
                }
                    break;
                    
                default:
                    break;
            }
            
        });
        
        
    } withPage:[NSString stringWithFormat:@"%ld",(long)page] andName:searchStr];

}
-(void)loadone
{
    page = 1;
    @WeakObj(table)
    @WeakObj(self)
    [ChatPresenter getUserBlackList:^(id  _Nullable data, ResultCode resultCode) {
        
        NSLog(@"黑名单－－－%@",data);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [tableWeak.mj_header endRefreshing];

            switch (resultCode) {
                case SucceedCode:
                {
                    [selfWeak.nothingnessView setHidden:YES];
                    [blackArr removeAllObjects];
                    [blackArr addObjectsFromArray:data];
                    [tableWeak reloadData];
                    
                }
                    break;
                case FailureCode:
                {
                    NSLog(@"没有数据");
                    [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"暂无黑名单记录" eventCallBack:nil];

                }
                    break;
                    
                default:
                    break;
            }
            
        });

        
    } withPage:[NSString stringWithFormat:@"%ld",(long)page] andName:searchStr];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableviewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FriendsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UserInfoModel * UIML = [blackArr objectAtIndex:indexPath.row];
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:UIML.userpic] placeholderImage:kHeaderPlaceHolder];
    cell.nameLb.text = UIML.nickname;
    cell.ageLb.text = UIML.age;
    cell.contentLb.text = UIML.signature;
    if(UIML.sex.integerValue == 1)
    {
        [cell.sexV setBackgroundColor:BLUE_TEXT_COLOR];
        [cell.sexImg setImage:[UIImage imageNamed:@"邻圈_男"]];
        
    }else if(UIML.sex.integerValue == 2)
    {
        [cell.sexV setBackgroundColor:WOMEN_COLOR];
        [cell.sexImg setImage:[UIImage imageNamed:@"邻圈_女"]];
        
    }

    [cell.timeLb setHidden:YES];
    
    cell.indexPath = indexPath;
    [cell.rightBtn setHidden:NO];
    [cell.rightBtn setTitle:@"移除" forState:UIControlStateNormal];
    cell.rightBtn.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
    [cell.rightBtn setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];

    @WeakObj(self)
    @WeakObj(table)
    cell.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
        UserInfoModel * UIML_temp = [blackArr objectAtIndex:index.row];
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self.tabBarController];

        [ChatPresenter removeUserBlackList:^(id  _Nullable data, ResultCode resultCode){
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                if (resultCode == SucceedCode) {
                    [selfWeak showToastMsg:data Duration:2.5f];
                    [blackArr removeObjectAtIndex:index.row];
                    [tableWeak reloadData];
                }
            });
            
        } withUserID:UIML_temp.userID andType:@""];

    };
    
    return cell;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return blackArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoModel * UIML = [blackArr objectAtIndex:indexPath.row];

    if ([XYString isBlankString:UIML.userID]) {
        return;
    }
    
    //点赞头像点击
    personListViewController *personList = [[personListViewController alloc]init];
    [personList getuserID:UIML.userID];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personList animated:YES];
//
//    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
//    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
//    AppDelegate *appDlgt = GetAppDelegates;
//    
//    if([appDlgt.userData.url_gamuserindex hasSuffix:@".html"]) {
//        
//        webVc.url=[NSString stringWithFormat:@"%@?token=%@&userid=%@",appDlgt.userData.url_gamuserindex,appDlgt.userData.token,UIML.userID];
//        
//    }else {
//        
//        webVc.url=[NSString stringWithFormat:@"%@&token=%@&userid=%@",appDlgt.userData.url_gamuserindex,appDlgt.userData.token,UIML.userID];
//        
//    }
//    webVc.isGetCurrentTitle = YES;
//    webVc.title = @"个人主页";
//    [self.navigationController pushViewController:webVc animated:YES];
//
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    
    UITextField * lb = [[UITextField alloc]initWithFrame:CGRectMake(40   , 0, SCREEN_WIDTH-40-40,40)];
    lb.placeholder = @"昵称／手机号／门牌号";
    
    lb.text = searchStr;
    lb.returnKeyType = UIReturnKeySearch;
    lb.delegate = self;
    lb.font = [UIFont systemFontOfSize:12.0f];
    lb.textColor = UIColorFromRGB(0x8e8e8e);
    [backV addSubview:lb];
    [backV addSubview:imgLine];
    [backV addSubview:imgV];
    
    return v_0;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    searchStr = textField.text;
    [table.mj_header beginRefreshing];

    return YES;
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
