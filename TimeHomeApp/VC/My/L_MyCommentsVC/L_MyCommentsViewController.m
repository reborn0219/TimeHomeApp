//
//  L_MyCommentsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/18.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_MyCommentsViewController.h"

#import "L_myCommentsTVC.h"
//#import "LXModel.h"

#import "L_NewMinePresenters.h"

#import "WebViewVC.h"

#import "L_NormalDetailsViewController.h"
#import "L_HouseDetailsViewController.h"
#import "BBSQusetionViewController.h"

@interface L_MyCommentsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArray;
    NSInteger page;
    NSInteger pagesize;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation L_MyCommentsViewController

#pragma mark - 请求评论列表数据
/**
 网络请求

 @param isRefresh 是否是刷新
 */
- (void)httpRequestForDataRefresh:(BOOL)isRefresh {
    
    if (isRefresh) {
        page = 1;
    }else {
        page  = page + 1;
    }
    
    @WeakObj(self);
    [L_NewMinePresenters getUserCommentWithPage:page pagesize:pagesize UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
                
                if (isRefresh) {
                    
                    [dataArray removeAllObjects];
                    [dataArray addObjectsFromArray:data];
                    [selfWeak.tableView reloadData];
                }else {
                    if (((NSArray *)data).count == 0) {
                        page = page - 1;
                    }
                    
                    NSArray * tmparr = (NSArray *)data;
                    NSInteger count = dataArray.count;
                    [dataArray addObjectsFromArray:tmparr];
                    [_tableView beginUpdates];
                    for (int i = 0; i < tmparr.count; i++) {
                        [_tableView insertSections:[NSIndexSet indexSetWithIndex:count + i] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    [_tableView endUpdates];
                }
                
            }else {
                if (isRefresh) {
                }else {
                    page = page - 1;
                }
            }
            
            if (dataArray.count == 0) {
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"您还没有发布过评论" eventCallBack:nil];
                [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
            }else {
                [selfWeak hiddenNothingnessView];
            }
            
        });
        
    }];

}

#pragma mark - 删除评论请求

- (void)httpRequestForDeleteCommentWithPostid:(NSString *)postid commentid:(NSString *)commentid model:(L_UserCommentModel *)model {
    
    @WeakObj(self);
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [L_NewMinePresenters deleteCommentWithPostid:postid commentid:commentid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if (resultCode == SucceedCode) {
                
                [dataArray removeObject:model];
                [selfWeak.tableView reloadData];
                
            }else {
                
                [selfWeak showToastMsg:data Duration:3.0];

            }
            
            if (dataArray.count == 0) {
                
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"您还没有发布过评论" eventCallBack:nil];
                [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
                
            }else {
                
                [selfWeak hiddenNothingnessView];
                
            }
            
        });
        
    }];
    
}

#pragma mark - viewDidLoad

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt markStatistics:WoDePingLun];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDlgt = GetAppDelegates;
    [appDlgt addStatistics:@{@"viewkey":WoDePingLun}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BLACKGROUND_COLOR;
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_myCommentsTVC" bundle:nil] forCellReuseIdentifier:@"L_myCommentsTVC"];
    page = 1;
    pagesize = 20;
    dataArray = [[NSMutableArray alloc] init];
    
    @WeakObj(self);
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForDataRefresh:YES];
        
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestForDataRefresh:NO];
    }];
    
    [_tableView.mj_footer setAutomaticallyHidden:YES];
    
    [_tableView.mj_header beginRefreshing];

}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BLACKGROUND_COLOR;
    return view;
}
// 在控制器中实现tableView:estimatedHeightForRowAtIndexPath:方法，返回一个估计高度，比如100 下方法可以调节“创建cell”和“计算cell高度”两个方法的先后执行顺序
/**
 *  返回每一行的估计高度，只要返回了估计高度，就会先调用cellForRowAtIndexPath给model赋值，然后调用heightForRowAtIndexPath返回cell真实的高度
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_UserCommentModel *model = [dataArray objectAtIndex:indexPath.section];
    return model.height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (dataArray.count > 0) {
        
        L_myCommentsTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_myCommentsTVC"];
        
        L_UserCommentModel *model = dataArray[indexPath.section];
        
        cell.model = model;
        cell.reloadIndexPathBlock = ^() {
          
            [tableView reloadData];
        };
        
        @WeakObj(self);
        cell.deleteButtonTouchBlock = ^() {
            NSLog(@"删除");
            
            //提示框
            CommonAlertVC * alertVc=[CommonAlertVC sharedCommonAlertVC];
            [alertVc setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index)
             {
                 @StrongObj(self);
                 if(index==ALERT_OK) {
                     
                     [self httpRequestForDeleteCommentWithPostid:model.postid commentid:model.theID model:model];

                 }

             }];
            
            [alertVc ShowAlert:selfWeak Title:@"提示" Msg:@"是否删除该评论" oneBtn:@"取消" otherBtn:@"确定"];
            
        };
    
    return cell;
        
    }else {
        return nil;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    L_UserCommentModel *model = dataArray[indexPath.section];
    
    NSString *poststate = [NSString stringWithFormat:@"%@",model.poststate];
    if ([poststate isEqualToString:@"0"]) {
        
        if (model.posttype.integerValue == 0) {//普通帖
            UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
            L_NormalDetailsViewController *normalDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_NormalDetailsViewController"];
            normalDetailVC.postID = model.postid;
            
            normalDetailVC.deleteRefreshBlock = ^(){
              
                [dataArray removeObject:model];
                [_tableView reloadData];
                
            };
            
            [self.navigationController pushViewController:normalDetailVC animated:YES];
            return;
        }
        
        if (model.posttype.integerValue == 4) {//房产车位帖
            UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
            L_HouseDetailsViewController *houseDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_HouseDetailsViewController"];
            houseDetailVC.postID = model.postid;
            
            houseDetailVC.deleteRefreshBlock = ^(){
                
                [dataArray removeObject:model];
                [_tableView reloadData];
                
            };
            
            [self.navigationController pushViewController:houseDetailVC animated:YES];
            return;
        }
        
        if (model.posttype.integerValue == 3) {//问答帖
            UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
            BBSQusetionViewController *qusetion = [BBSStoryboard instantiateViewControllerWithIdentifier:@"BBSQusetionViewController"];
            qusetion.postID = model.postid;
            qusetion.deleteRefreshBlock = ^(){
                
                [dataArray removeObject:model];
                [_tableView reloadData];
                
            };
            [self.navigationController pushViewController:qusetion animated:YES];
            return;
        }

    }else if ([poststate isEqualToString:@"-1"]) {
        
        [self showToastMsg:@"该帖已下架" Duration:3.0];
        
    }else if ([poststate isEqualToString:@"-99"]) {
        
        [self showToastMsg:@"该帖已被删除" Duration:3.0];
        
    }else if ([poststate isEqualToString:@"-2"]) {
        
        [self showToastMsg:@"该帖审核未通过" Duration:3.0];
        
    }
    
    
}

@end
