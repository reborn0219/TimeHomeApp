//
//  MyFollowVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/4/8.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MyFollowVC.h"
#import "FriendsCell.h"
///models
#import "ChatPresenter.h"
#import "UserInfoModel.h"
#import "DateTimeUtils.h"
#import "ChatViewController.h"
#import "PersonalDataVC.h"
#import "WebViewVC.h"

#import "personListViewController.h"

@interface MyFollowVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    UITableView * table;
    NSMutableArray * followArr;
    NSString * searchStr;
    NSInteger page;
}
@end

@implementation MyFollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    searchStr = @"";
    followArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    table.delegate =self;
    table.dataSource=self;
    table.showsVerticalScrollIndicator = NO;
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    [table setBackgroundColor:CLEARCOLOR];
    table.tableFooterView = [UIView new];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    [table registerNib:[UINib nibWithNibName:@"FriendsCell" bundle:nil] forCellReuseIdentifier:@"friendsCell"];
    @WeakObj(self)

    table.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
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
    
    AppDelegate * appDelegate = GetAppDelegates;
    
    if ([XYString isBlankString:_userid]) {
        _userid = appDelegate.userData.userID;
        
    }
    if([_userid isEqualToString:appDelegate.userData.userID])
    {
        self.navigationItem.title = @"我的关注";
        
    }else
    {
        self.navigationItem.title = [NSString stringWithFormat:@"%@的关注",_username];
    }
    [self loadone];


}
-(void)loadmore
{
    page ++;
    @WeakObj(table)
    [ChatPresenter getFllowUser:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [tableWeak.mj_footer endRefreshing];

            switch (resultCode) {
                case SucceedCode:
                {
                    [followArr addObjectsFromArray:data];
                    [tableWeak reloadData];
                    
                }
                    break;
                case FailureCode:
                {
                    page--;
                    NSLog(@"没有数据");
                }
                    break;
                    
                default:
                    break;
            }
            
        });
        
    } withPage:[NSString stringWithFormat:@"%ld",(long)page] andName:searchStr andUerID:_userid];

}
-(void)loadone
{
    page = 1;
    @WeakObj(table)
    @WeakObj(self)
    
    [ChatPresenter getFllowUser:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
//            [tableWeak.pullToRefreshView stopAnimating];

            if (tableWeak.mj_header.isRefreshing) {
                [tableWeak.mj_header endRefreshing];
            }
            
            switch (resultCode) {
                case SucceedCode:
                {
                    [selfWeak.nothingnessView setHidden:YES];
                    [followArr removeAllObjects];
                    [followArr addObjectsFromArray:data];
                    [tableWeak reloadData];
                    
                }
                    break;
                case FailureCode:
                {
                    NSLog(@"没有数据");
                    [self showNothingnessViewWithType:NoContentTypeData Msg:@"暂无关注记录" eventCallBack:nil];
                    [self.view sendSubviewToBack:self.nothingnessView];
                    [followArr removeAllObjects];
                    [tableWeak reloadData];

                }
                    break;
                    
                default:
                    break;
            }

        });
        
    } withPage:[NSString stringWithFormat:@"%ld",(long)page] andName:searchStr andUerID:_userid];
    
}

#pragma mark - tableviewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FriendsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UserInfoModel * UIML = [followArr objectAtIndex:indexPath.row];
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
    
    if([UIML.istomy  isEqualToString:@"1"])
    {
        [cell.rightBtn setTitle:@"互相关注" forState:UIControlStateNormal];
        cell.rightBtn.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
        [cell.rightBtn setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        
    }else if([UIML.istomy  isEqualToString:@"0"])
    {
        
        cell.rightBtn.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
        [cell.rightBtn setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        [cell.rightBtn setTitle:@"已关注" forState:UIControlStateNormal];
        
    }else
    {
        [cell.rightBtn setTitleColor:PURPLE_COLOR forState:UIControlStateNormal];
        [cell.rightBtn setTitle:@"加关注" forState:UIControlStateNormal];
        cell.rightBtn.layer.borderColor = PURPLE_COLOR.CGColor;

    }
    AppDelegate * appDegte = GetAppDelegates;
    
    @WeakObj(self)
    @WeakObj(table)
    cell.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
       
        if([XYString isBlankString:_userid])return ;
        
        UserInfoModel * UIML_temp = [followArr objectAtIndex:index.row];
            ///取消关注
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self.tabBarController];
        
        BOOL b = [_userid isEqualToString:appDegte.userData.userID];
        
        NSString * type;
        
        if (b) {
            
            type = @"1";
        }else
        {
            type = [UIML_temp.istomy isEqualToString:@"-1"]?@"0":@"1";

        }
        [ChatPresenter addUserFollow:UIML_temp.userID withBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [indicator stopAnimating];
                if (resultCode == SucceedCode) {

                    NSString * isto = [NSString stringWithFormat:@"%@",[(NSDictionary *)data objectForKey:@"isto"]];
                    if (b) {
                        [followArr removeObject:UIML_temp];
                        
                    }else
                    {
                        UIML_temp.istomy = isto;
                        
                    }
                    [tableWeak reloadData];
                    
                }else
                {
                    [selfWeak showToastMsg:data Duration:2.5f];
                }
                
            });
            
            
            
        } withType:type];
        
        
    };

    return cell;
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return followArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;

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
    lb.returnKeyType = UIReturnKeySearch;
    lb.delegate = self;
    lb.text = searchStr;
    lb.font = [UIFont systemFontOfSize:12.0f];
    lb.textColor = UIColorFromRGB(0x8e8e8e);
    [backV addSubview:lb];
    [backV addSubview:imgLine];
    [backV addSubview:imgV];
    
    return v_0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoModel * UIML = [followArr objectAtIndex:indexPath.row];

    if ([XYString isBlankString:UIML.userID]) {
        return;
    }
    
    //点赞头像点击
    personListViewController *personList = [[personListViewController alloc]init];
    [personList getuserID:UIML.userID];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personList animated:YES];
    
//    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
//    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
//    AppDelegate *appDlgt = GetAppDelegates;
//    
//    UserInfoModel * UIML = [followArr objectAtIndex:indexPath.row];
//
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

//    PersonalDataVC * pdVC = [[UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalDataVC"];
//    UserInfoModel * UIML = [followArr objectAtIndex:indexPath.row];
//    
//    pdVC.userID = UIML.userID;
//    [self.navigationController pushViewController:pdVC animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    searchStr = textField.text;

    [textField resignFirstResponder];
//    [table triggerPullToRefresh];
    [table.mj_header beginRefreshing];

    return YES;
    
}

@end
