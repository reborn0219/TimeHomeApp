//
//  L_DownSaleViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_DownSaleViewController.h"

//------------商品帖cell--------------
#import "BBSCommodityTableViewCell.h"
#import "BBSCommodity2TableViewCell.h"
#import "BBSCommodity1TableViewCell.h"
//------------房产帖cell--------------
#import "BBSHouseTableViewCell.h"
#import "BBSHouse2TableViewCell.h"
#import "BBSHouse1TableViewCell.h"
#import "BBSHouse0TableViewCell.h"


#import "L_BottomButtonTVC.h"

#import "BBSMainPresenters.h"

#import "SharePresenter.h"

#import "L_NewMinePresenters.h"

#import "WebViewVC.h"

#import "NetworkUtils.h"
#import "RaiN_HouseVC.h"
#import "L_HouseDetailsViewController.h"
#import "CommunityListViewController.h"
#import "personListViewController.h"
#import "HouseOrCarViewController.h"

@interface L_DownSaleViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger page;
}
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation L_DownSaleViewController

#pragma mark - 点赞、取消点赞请求
- (void)httpRequestForPraiseOrNot:(NSInteger)isPraise withPostid:(NSString *)postid callBack:(void(^)(NSInteger praiseCount))callBack {
    
    [L_NewMinePresenters addPraiseType:isPraise withPostid:postid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                NSString *count = [NSString stringWithFormat:@"%@",[[data objectForKey:@"map"] objectForKey:@"praisecount"]];
                
                [self showToastMsg:[data objectForKey:@"errmsg"] Duration:3.0];
                
                if ([count isKindOfClass:[NSString class]]) {
                    
                    NSInteger praiseNum = 0;
                    if (count.integerValue >= 0) {
                        praiseNum = count.integerValue;
                        if (callBack) {
                            callBack(praiseNum);
                        }
                    }
                    
                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
    
}

#pragma mark - 删除帖子
/**
 删除帖子

 @param model
 */
- (void)httpRequestForDeleteWithModel:(BBSModel *)model {
    
    if ([XYString isBlankString:model.theid]) {
        return;
    }
    
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    
    [L_NewMinePresenters deletePostWithPostid:model.theid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                
                [_dataArray removeObject:model];
                [self.tableView reloadData];
//                NSString *errmsg = [XYString isBlankString:data[@"errmsg"]] ? @"删除成功" : data[@"errmsg"];
                //10 房产出售 11 房产出租 30 车位出售 31 车位出租
                if (model.housetype.integerValue == 10 || model.housetype.integerValue == 11) {
                    [self showToastMsg:@"房产贴删除成功" Duration:3.0];
                }else if (model.housetype.integerValue == 30 || model.housetype.integerValue == 30) {
                    [self showToastMsg:@"车位贴删除成功" Duration:3.0];
                }else {
                    [self showToastMsg:@"删除成功" Duration:3.0];
                }
                
            }else {

                [self showToastMsg:data Duration:3.0];

            }
            
            if (_dataArray.count == 0) {
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"您的商品已下架，好货集市继续发！" eventCallBack:nil];

                [self.view sendSubviewToBack:self.nothingnessView];
            }else {
                [self hiddenNothingnessView];
            }
            
        });
        
    }];
    
}

#pragma mark - 请求帖子列表

/**
 请求帖子列表
 
 @param isRefresh 是否为刷新
 */
- (void)httpRequestForGetDownSaledatalistRefresh:(BOOL)isRefresh {
    
    if (isRefresh) {
        page = 1;
    }else {
        page  = page + 1;
    }

    [BBSMainPresenters getPostList:@"-99" userid:@"" sortkey:@"new" contype:@"0" posttype:@"1,4" poststate:@"-1" iscollect:@"0" isuserfollow:@"-1" tagsname:@"" pagesize:@"20" page:[NSString stringWithFormat:@"%ld",page] communityid:@"" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
                
                if (isRefresh) {
                    
                    [self.dataArray removeAllObjects];
                    [self.dataArray addObjectsFromArray:data];
                    [self.tableView reloadData];
                    
                }else {

                    if (((NSArray *)data).count == 0) {
                        page = page - 1;
                    }else {
                        NSArray * tmparr = (NSArray *)data;
                        NSInteger count = _dataArray.count;
                        [self.dataArray addObjectsFromArray:tmparr];
                        [self.tableView beginUpdates];
                        for (int i = 0; i < tmparr.count; i++) {
                            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:count + i] withRowAnimation:UITableViewRowAnimationFade];
                        }
                        [self.tableView endUpdates];
                    }

                }
                
            }else {
                
                if (isRefresh) {

                }else {
                    page = page - 1;

                }
                
            }

            if (self.dataArray.count == 0) {
                
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"您的商品已下架，好货集市继续发！" eventCallBack:nil];
                [self.view sendSubviewToBack:self.nothingnessView];
            }else {
                [self hiddenNothingnessView];

            }
            
        });
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

//- (void)dealloc {
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTICE_REFRESH_EDIT_DATA object:nil];
//
//}
//
//- (void)noticeReloadData {
//    
//    [_tableView.pullToRefreshView startAnimating];
//    [self httpRequestForGetDownSaledatalistRefresh:YES];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeReloadData) name:NOTICE_REFRESH_EDIT_DATA object:nil];

    page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    
    [self createTableView];

    [_tableView.mj_header beginRefreshing];

}

- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, SCREEN_HEIGHT - (44+statuBar_Height) - 70 ) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = CLEARCOLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [_tableView registerNib:[UINib nibWithNibName:@"BBSCommodityTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodityTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSCommodity2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodity2TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSCommodity1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodity1TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSHouseTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouseTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSHouse2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse2TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSHouse1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse1TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSHouse0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse0TableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_BottomButtonTVC" bundle:nil] forCellReuseIdentifier:@"L_BottomButtonTVC"];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    @WeakObj(self);
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetDownSaledatalistRefresh:YES];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetDownSaledatalistRefresh:NO];
    }];
    
    [_tableView.mj_footer setAutomaticallyHidden:YES];

}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// 在控制器中实现tableView:estimatedHeightForRowAtIndexPath:方法，返回一个估计高度，比如100 下方法可以调节“创建cell”和“计算cell高度”两个方法的先后执行顺序
/**
 *  返回每一行的估计高度，只要返回了估计高度，就会先调用cellForRowAtIndexPath给model赋值，然后调用heightForRowAtIndexPath返回cell真实的高度
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBSModel *model = [_dataArray objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        return model.height - 14 > 0 ? model.height - 14 : 0;
    }else {
        return model.height - 14 > 0 ? 50 : 0;
//        return 50;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    @WeakObj(self)
    if (_dataArray.count > 0) {
        
        BBSModel *model = _dataArray[indexPath.section];
        
        if (indexPath.row == 0) {
            
            if ([model.posttype isEqualToString:@"4"]) {///////////////////////房产贴
                if (model.piclist.count >= 3) {//3图房产贴
                    
                    BBSHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouseTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];

                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    cell.rightTopStyle = 2;

                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:2];
                    };
                    
                    cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                        /** 0 房产 1 车位 */
                        
                        AppDelegate *appDlt = GetAppDelegates;
                        
                        if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                            return ;
                        }
                        
                        if (index == 0) {
                            
                            HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                            [houseOrCar getCommunityID:model.communityid title:@"房产列表"];
                            self.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:houseOrCar animated:YES];
                        }else if (index == 1) {
                            
                            HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                            [houseOrCar getCommunityID:model.communityid title:@"车位列表"];
                            self.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:houseOrCar animated:YES];
                        }
                    };
                    
                    @WeakObj(cell);
                    cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                        
                        [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (model.ispraise.integerValue == 0) {
                                    
                                    model.ispraise = @"1";
                                    
                                    cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                                    
                                }else {
                                    
                                    model.ispraise = @"0";
                                    
                                    cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                                    
                                }
                                
                                model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                                cellWeak.praiseLal.text = model.praisecount;
                                
                            });
                            
                        }];
                    };
                    
                    return cell;
                    
                }else if (model.piclist.count == 2){//2图房产贴
                    
                    BBSHouse2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse2TableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];

                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    cell.rightTopStyle = 2;

                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:2];
                    };
                    
                    cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                        /** 0 房产 1 车位 */
                        
                        AppDelegate *appDlt = GetAppDelegates;
                        
                        if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                            return ;
                        }
                        
                        if (index == 0) {
                            
                            HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                            [houseOrCar getCommunityID:model.communityid title:@"房产列表"];
                            self.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:houseOrCar animated:YES];
                        }else if (index == 1) {
                            
                            HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                            [houseOrCar getCommunityID:model.communityid title:@"车位列表"];
                            self.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:houseOrCar animated:YES];
                        }
                    };
                    
                    @WeakObj(cell);
                    cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                        
                        [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (model.ispraise.integerValue == 0) {
                                    
                                    model.ispraise = @"1";
                                    
                                    cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                                    
                                }else {
                                    
                                    model.ispraise = @"0";
                                    
                                    cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                                    
                                }
                                
                                model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                                cellWeak.praiseLal.text = model.praisecount;
                                
                            });
                            
                        }];
                    };
                    
                    return cell;
                    
                }else if (model.piclist.count == 1){//1图房产贴
                    
                    BBSHouse1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse1TableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];

                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    cell.rightTopStyle = 2;

                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:2];
                    };
                    
                    cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                        /** 0 房产 1 车位 */
                        
                        AppDelegate *appDlt = GetAppDelegates;
                        
                        if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                            return ;
                        }
                        
                        if (index == 0) {
                            
                            HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                            [houseOrCar getCommunityID:model.communityid title:@"房产列表"];
                            self.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:houseOrCar animated:YES];
                        }else if (index == 1) {
                            
                            HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                            [houseOrCar getCommunityID:model.communityid title:@"车位列表"];
                            self.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:houseOrCar animated:YES];
                        }
                    };
                    
                    @WeakObj(cell);
                    cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                        
                        [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (model.ispraise.integerValue == 0) {
                                    
                                    model.ispraise = @"1";
                                    
                                    cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                                    
                                }else {
                                    
                                    model.ispraise = @"0";
                                    
                                    cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                                    
                                }
                                
                                model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                                cellWeak.praiseLal.text = model.praisecount;
                                
                            });
                            
                        }];
                    };
                    
                    return cell;
                }else if (model.piclist.count == 0){//0图房产贴
                    
                    BBSHouse1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse1TableViewCell"];
                    cell.bottomView.backgroundColor = [UIColor whiteColor];
                    
                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    cell.rightTopStyle = 2;
                    
                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:2];
                    };
                    
                    cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                        /** 0 房产 1 车位 */
                        
                        AppDelegate *appDlt = GetAppDelegates;
                        
                        if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                            return ;
                        }
                        
                        if (index == 0) {
                            
                            HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                            [houseOrCar getCommunityID:model.communityid title:@"房产列表"];
                            self.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:houseOrCar animated:YES];
                        }else if (index == 1) {
                            
                            HouseOrCarViewController *houseOrCar = [[HouseOrCarViewController alloc]init];
                            [houseOrCar getCommunityID:model.communityid title:@"车位列表"];
                            self.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:houseOrCar animated:YES];
                        }
                    };
                    
                    @WeakObj(cell);
                    cell.praiseButtonDidClickBlock = ^(NSInteger isPraise) {
                        
                        [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (model.ispraise.integerValue == 0) {
                                    
                                    model.ispraise = @"1";
                                    
                                    cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                                    
                                }else {
                                    
                                    model.ispraise = @"0";
                                    
                                    cellWeak.l_praiseImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                                    
                                }
                                
                                model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                                cellWeak.praiseLal.text = model.praisecount;
                                
                            });
                            
                        }];
                    };
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                    
                }else {
                    
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    return cell;
                }
            }else if ([model.posttype isEqualToString:@"1"]) {///////////////////////商品贴
                
                if (model.piclist.count >= 3) {//3图商品贴
                    
                    BBSCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodityTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];

                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    cell.rightTopStyle = 2;

                    return cell;
                    
                }else if (model.piclist.count == 2){//2图商品贴
                    
                    BBSCommodity2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodity2TableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];

                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    cell.rightTopStyle = 2;

                    return cell;
                    
                }else if (model.piclist.count == 1){//1图商品贴
                    
                    BBSCommodity1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodity1TableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];

                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    cell.rightTopStyle = 2;

                    return cell;
                }
                else {
                    
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    return cell;
                }
                
            }else {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }

        }else if (indexPath.row == 1) {
            
            if (model.height - 14 > 0) {
                
                L_BottomButtonTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_BottomButtonTVC"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.type = 2;
                
                cell.threeButtonDidClickBlock = ^(NSInteger buttonIndex) {
                NSLog(@"sender===%ld",(long)buttonIndex);
                    if (buttonIndex == 1) {
                        NSLog(@"编辑");

                        if ([model.housetype isEqualToString:@"10"] || [model.housetype isEqualToString:@"11"]) {
                            
                            RaiN_HouseVC *house = [[RaiN_HouseVC alloc] init];
                            house.isHouse = @"0";
                            house.isCompile = @"0";
                            house.postID = model.theid;
                            [self.navigationController pushViewController:house animated:YES];
                            
                        }
                        
                        if ([model.housetype isEqualToString:@"30"] || [model.housetype isEqualToString:@"31"]) {
                            
                            RaiN_HouseVC *house = [[RaiN_HouseVC alloc] init];
                            house.isHouse = @"1";
                            house.isCompile = @"0";
                            house.postID = model.theid;
                            [self.navigationController pushViewController:house animated:YES];
                            
                        }

                        
                    }else if (buttonIndex == 2) {
                        NSLog(@"删除");
                        
                        //提示框
                        
                        CommonAlertVC * alertVc=[CommonAlertVC sharedCommonAlertVC];
                        [alertVc setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                         {
                             if(index==ALERT_OK) {
                                 
                                 [self httpRequestForDeleteWithModel:model];
                                 
                             }
                             
                         }];
                        
                        [alertVc ShowAlert:self Title:@"提示" Msg:@"是否删除该帖子" oneBtn:@"取消" otherBtn:@"确定"];
                        
                        
                    }else {
                        NSLog(@"分享按钮");
                        
                        if ([XYString isBlankString:model.gotourl]) {
                            [self showToastMsg:@"该帖子链接暂未获取到" Duration:3.0];
                            return ;
                        }
                        
                        
                        /** 分享 */
                        ShareContentModel * SCML = [[ShareContentModel alloc]init];
                        SCML.sourceid            = model.theid;
                        SCML.shareTitle          = [XYString IsNotNull:model.title];
                        if (model.piclist.count > 0) {
                            SCML.shareImg = [XYString isBlankString:model.piclist[0]] ? SHARE_LOGO_IMAGE : model.piclist[0];
                        }else {
                            SCML.shareImg = SHARE_LOGO_IMAGE;
                        }
                        SCML.shareContext        = [XYString IsNotNull:model.content];
                        SCML.shareUrl            = model.sharegotourl;
                        SCML.type                = 4;
                        SCML.shareSuperView      = self.view;
                        SCML.shareType           = SSDKContentTypeAuto;
                        [SharePresenter creatShareSDKcontent:SCML];

                    }
                };
                
                return cell;
            }else {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }

        }
        
    }

    
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        BBSModel *model = _dataArray[indexPath.section];
        
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        L_HouseDetailsViewController *houseDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_HouseDetailsViewController"];
        houseDetailVC.postID = model.theid;
        houseDetailVC.bbsModel = model;
        
        houseDetailVC.deleteRefreshBlock = ^(){
            
            [_dataArray removeObject:model];
            [_tableView reloadData];
            
        };
        
        houseDetailVC.praiseAndCommentCallBack = ^(NSString *praise,NSString *comment,NSString *PostID,NSString *type){
            
            if (![XYString isBlankString:praise]) {
                
                model.praisecount = praise;
            }
            
            if (![XYString isBlankString:comment]) {
                
                model.commentcount = comment;
            }
            
            if (![XYString isBlankString:type]) {
                if (type.integerValue == 0) {
                    model.ispraise = @"1";
                }else {
                    model.ispraise = @"0";
                }
            }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        };
        
        [self.navigationController pushViewController:houseDetailVC animated:YES];
    }
}

/**
 进入社区帖子,进入个人中心 listtype==2为社区帖子
 */
- (void)gotoCommunityWebviewWithModel:(BBSModel *)model withListType:(NSInteger)listtype {
    
    if (listtype == 2) {
        
        CommunityListViewController *CommunityList = [[CommunityListViewController alloc]init];
        [CommunityList getCommunityID:model.communityid communityName:model.communityname];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:CommunityList animated:YES];
        
    }else {
        
        personListViewController *personList = [[personListViewController alloc]init];
        [personList getuserID:model.userid];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personList animated:YES];
    }
}

@end
