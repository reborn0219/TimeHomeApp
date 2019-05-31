//
//  PraiseListVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/11/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PraiseListVC.h"
#import "PraiseListCell.h"
#import "BBSMainPresenters.h"
#import "WebViewVC.h"

#import "personListViewController.h"

@interface PraiseListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * table;
    NSMutableArray * praiseArr;
    NSString * page;
}
@end

@implementation PraiseListVC

/**
 返回按钮点击
 */
//- (void)backButtonClick {

//    if (_isFromPushMessage) {
    
//        AppDelegate *appDlgt = GetAppDelegates;
//        
//        NSString *tieziURLString = @"";
//        
//        if (![XYString isBlankString:_urlString]) {
//            if([_urlString hasSuffix:@".html"])
//            {
//                tieziURLString=[NSString stringWithFormat:@"%@?token=%@",_urlString,appDlgt.userData.token];
//            }
//            else
//            {
//                tieziURLString=[NSString stringWithFormat:@"%@&token=%@",_urlString,appDlgt.userData.token];
//            }
//            for (WebViewVC * webVc in self.navigationController.viewControllers) {
//                if ([webVc isKindOfClass:[WebViewVC class]]) {
//                    
//                    webVc.url = tieziURLString;
//                    webVc.isGetCurrentTitle = YES;
//                    webVc.isFromCommentPush = YES;
//                }
//            }
            
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }else {
//            [super backButtonClick];
//        }

//    }else {
//        [super backButtonClick];
//    }
    
//}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    praiseArr = [[NSMutableArray alloc]initWithCapacity:0];
    page = @"1";
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    [table registerNib:[UINib nibWithNibName:@"PraiseListCell" bundle:nil] forCellReuseIdentifier:@"PraiseListCell"];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view setBackgroundColor:BLACKGROUND_COLOR];
    [table setBackgroundColor:BLACKGROUND_COLOR];
    [self.view addSubview:table];
    
    @WeakObj(self);
    table.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        
        page = @"1";
        [selfWeak registPraiseData];
    }];
    
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        page = [NSString stringWithFormat:@"%ld",(page.integerValue+1)];
        
        [selfWeak registPraiseData];
    }];
    
    [table.mj_footer setAutomaticallyHidden:YES];

    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationItem.title =[NSString stringWithFormat:@"%@人点赞",_praisecount];
    
    [self registPraiseData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)registPraiseData
{
    @WeakObj(table);
    [BBSMainPresenters getPraiseList:_postid pagesize:@"20" page:page updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [tableWeak.mj_header endRefreshing];
            [tableWeak.mj_footer endRefreshing];
            
            if(resultCode==SucceedCode)
            {
                NSArray *arr = (NSArray *)data;

                
                if (page.integerValue==1) {
                    
                    [praiseArr removeAllObjects];
                    
                    if (arr.count > 0) {
                        
                        [praiseArr addObjectsFromArray: arr];
                    }
                    
                }else
                {
                    if (arr.count > 0) {
                        [praiseArr addObjectsFromArray: arr];
                    }else
                    {
                        if (page.integerValue>1) {
                            page = [NSString stringWithFormat:@"%ld",page.integerValue-1];
                        }
                    }

                }
                
                [tableWeak reloadData];
                
                
            }else{
                
                if (page.integerValue>1) {
                    page = [NSString stringWithFormat:@"%ld",page.integerValue-1];
                    
                    [self showToastMsg:@"该帖子没有更多的点赞数据！" Duration:3.0];

                }
                
            }
        });
        
        
        NSLog(@"%@",data);
        
    }];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PraiseListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PraiseListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = [praiseArr objectAtIndex:indexPath.row];

    [cell.headerImgV sd_setImageWithURL:[NSURL URLWithString:dic[@"userpicurl"]] placeholderImage:kHeaderPlaceHolder];

    
    [cell.nameLb setText:dic[@"nickname"]];

    if (indexPath.row==praiseArr.count-1) {
        
        [cell.lineV setHidden:YES];

    }else
    {
        [cell.lineV setHidden:NO];
    }
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return praiseArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.3f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dic = [praiseArr objectAtIndex:indexPath.row];

    if ([XYString isBlankString:dic[@"userid"]]) {
        return;
    }
    
    //点赞头像点击
    NSLog(@"userid==%@",dic);
    personListViewController *personList = [[personListViewController alloc]init];
    [personList getuserID:dic[@"userid"]];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personList animated:YES];
}

@end
