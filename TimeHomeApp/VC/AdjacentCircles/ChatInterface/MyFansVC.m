//
//  MyFansVC.m
//  TimeHomeApp
//

//  Created by UIOS on 16/3/15.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.

#import "MyFansVC.h"
#import "FriendsCell.h"
#import "PersonalDataVC.h"

///models
#import "ChatPresenter.h"
///views
#import "UserInfoModel.h"
#import "ChatViewController.h"
#import "WebViewVC.h"
#import "personListViewController.h"

@interface MyFansVC ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView * table;
    NSMutableArray * fansArr;
    NSInteger page;
}
@end

@implementation MyFansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    // Do any additional setup after loading the view.
    fansArr = [[NSMutableArray alloc]initWithCapacity:0];

    table = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    table.delegate =self;
    table.dataSource=self;
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    [table setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
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
        self.navigationItem.title = @"我的粉丝";

    }else
    {
        self.navigationItem.title = [NSString stringWithFormat:@"%@的粉丝",_username];
    }
    [self loadone];

}
-(void)loadmore
{
    page ++;
    @WeakObj(table)
    [ChatPresenter getToFllowuser:^(id  _Nullable data, ResultCode resultCode) {
        
        NSLog(@"我的粉丝－－－%@",data);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [tableWeak.mj_footer endRefreshing];
            switch (resultCode) {
                case SucceedCode:
                {
                    [fansArr addObjectsFromArray:data];
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
        
    } withPage:[NSString stringWithFormat:@"%ld",(long)page] andName:@"" andUerID:_userid];
}
-(void)loadone
{
    
    page = 1;
    @WeakObj(table)
    @WeakObj(self)
    [ChatPresenter getToFllowuser:^(id  _Nullable data, ResultCode resultCode) {
        
        NSLog(@"我的粉丝－－－%@",data);
        dispatch_sync(dispatch_get_main_queue(), ^{
//            [tableWeak.pullToRefreshView stopAnimating];

            if (tableWeak.mj_header.isRefreshing) {
                [tableWeak.mj_header endRefreshing];
            }
            
            switch (resultCode) {
                case SucceedCode:
                {
                    [selfWeak.nothingnessView setHidden:YES];
                    [fansArr removeAllObjects];
                    [fansArr addObjectsFromArray:data];
                    [tableWeak reloadData];
                    
                }
                    break;
                case FailureCode:
                {
                    NSLog(@"没有数据");
                    [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"暂无粉丝记录" eventCallBack:nil];

                }
                    break;
                    
                default:
                    break;
            }
            
        });
        
    } withPage:[NSString stringWithFormat:@"%ld",(long)page] andName:@"" andUerID:_userid];
}

#pragma mark - tableviewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    FriendsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UserInfoModel * UIML = [fansArr objectAtIndex:indexPath.row];
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:UIML.userpic] placeholderImage:kHeaderPlaceHolder];
    cell.nameLb.text = UIML.nickname;
    cell.ageLb.text = UIML.age;
    cell.contentLb.text = UIML.signature;
    
    cell.indexPath = indexPath;
    [cell.rightBtn setHidden:NO];
    
    if([UIML.istoyou isEqualToString:@"1"])
    {
        [cell.rightBtn setTitle:@"互相关注" forState:UIControlStateNormal];
        cell.rightBtn.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
        [cell.rightBtn setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];

    }else if([UIML.istoyou isEqualToString:@"0"])
    {
        [cell.rightBtn setTitle:@"已关注" forState:UIControlStateNormal];
        cell.rightBtn.layer.borderColor = TITLE_TEXT_COLOR.CGColor;
        [cell.rightBtn setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        
    }else
    {
        [cell.rightBtn setTitleColor:PURPLE_COLOR forState:UIControlStateNormal];
        [cell.rightBtn setTitle:@"加关注" forState:UIControlStateNormal];
        cell.rightBtn.layer.borderColor = PURPLE_COLOR.CGColor;

    }
    @WeakObj(self)
    @WeakObj(table)
    cell.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
        if([XYString isBlankString:_userid])return ;
        
//        AppDelegate * appDegte = GetAppDelegates;
        UserInfoModel * UIML_temp = [fansArr objectAtIndex:index.row];
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];
        [indicator startAnimating:self.tabBarController];
       
        NSString * type = [UIML_temp.istoyou isEqualToString:@"-1"]?@"0":@"1";
            
        [ChatPresenter addUserFollow:UIML_temp.userID withBlock:^(id  _Nullable data, ResultCode resultCode) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                if (resultCode == SucceedCode) {
                    
                    NSString * isto = [NSString stringWithFormat:@"%@",[(NSDictionary *)data objectForKey:@"isto"]];
                    
                    UIML_temp.istoyou = isto;
                    [tableWeak reloadData];

                }else
                {
                    [selfWeak showToastMsg:data Duration:2.5f];
                    
                }
                
            });
            
            
            
        } withType:type];

    };
    

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

        return cell;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
       return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
      return fansArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
      return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
       return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserInfoModel * UIML = [fansArr objectAtIndex:indexPath.row];
    
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

}


@end
