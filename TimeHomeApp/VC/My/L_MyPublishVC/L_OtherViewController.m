//
//  L_OtherViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_OtherViewController.h"

//------------普通帖cell--------------
#import "BBSNormalTableViewCell.h"
#import "BBSNormal2TableViewCell.h"
#import "BBSNormal1TableViewCell.h"
#import "BBSNormal0TableViewCell.h"
//------------投票贴cell--------------
#import "BBSVotePICTableViewCell.h"
#import "BBSVotePIC2TableViewCell.h"
#import "BBSVoteTextTableViewCell.h"
#import "BBSVoteText2TableViewCell.h"
//------------问答帖cell--------------
#import "BBSQuestionPICTableViewCell.h"
#import "BBSQuestionPIC2TableViewCell.h"
#import "BBSQuestionPIC1TableViewCell.h"
#import "BBSQuestionNoPICTableViewCell.h"

#import "L_BottomButtonTVC.h"

#import "BBSMainPresenters.h"

#import "SharePresenter.h"

#import "WebViewVC.h"

#import "NetworkUtils.h"

#import "L_NewMinePresenters.h"
#import "L_NormalDetailsViewController.h"
#import "BBSQusetionViewController.h"
#import "CommunityListViewController.h"
#import "personListViewController.h"

#import "L_ShareActivityTVC.h"

@interface L_OtherViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger page;
}
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation L_OtherViewController

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
                
                if ([model.posttype isEqualToString:@"0"]) {
                    [self showToastMsg:@"普通贴删除成功" Duration:3.0];
                }else if ([model.posttype isEqualToString:@"3"]) {
                    [self showToastMsg:@"问答贴删除成功" Duration:3.0];
                }else {
                    NSString *errmsg = [XYString isBlankString:data[@"errmsg"]] ? @"删除成功" : data[@"errmsg"];
                    [self showToastMsg:errmsg Duration:3.0];
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
- (void)httpRequestForGetOtherdatalistRefresh:(BOOL)isRefresh {
    
    if (isRefresh) {
        page = 1;
    }else {
        page  = page + 1;
    }
    
    [BBSMainPresenters getPostList:@"-99" userid:@"" sortkey:@"new" contype:@"0" posttype:@"0,2,3,9" poststate:@"-999" iscollect:@"0" isuserfollow:@"-1" tagsname:@"" pagesize:@"20" page:[NSString stringWithFormat:@"%ld",page] communityid:@"" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if (_tableView.mj_footer.isRefreshing) {
                [_tableView.mj_footer endRefreshing];
            }
            
            if (resultCode == SucceedCode) {
                
                if (isRefresh) {
                    
                    [_dataArray removeAllObjects];
                    [_dataArray addObjectsFromArray:data];
                    [_tableView reloadData];
                    
                }else {

                    if (((NSArray *)data).count == 0) {
                        page = page - 1;
                    }else {
                        NSArray * tmparr = (NSArray *)data;
                        NSInteger count = _dataArray.count;
                        [_dataArray addObjectsFromArray:tmparr];
                        [_tableView beginUpdates];
                        for (int i = 0; i < tmparr.count; i++) {
                            [_tableView insertSections:[NSIndexSet indexSetWithIndex:count + i] withRowAnimation:UITableViewRowAnimationFade];
                        }
                        [_tableView endUpdates];
                    }

                }
                
            }else {
                
                if (isRefresh) {
                }else {
                    page = page - 1;
                }

            }

            if (_dataArray.count == 0) {
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"您还没有发布相关邻圈互动贴，动动手指发起来，邻里互动走起来！" eventCallBack:nil];
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

- (void)viewDidLoad {
    [super viewDidLoad];

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

    [_tableView registerNib:[UINib nibWithNibName:@"BBSNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormalTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSNormal2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal2TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSNormal1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal1TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSNormal0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal0TableViewCell"];

    [_tableView registerNib:[UINib nibWithNibName:@"BBSVotePICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVotePICTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSVotePIC2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVotePIC2TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSVoteTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVoteTextTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSVoteText2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVoteText2TableViewCell"];

    [_tableView registerNib:[UINib nibWithNibName:@"BBSQuestionPICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPICTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSQuestionPIC2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPIC2TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSQuestionPIC1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPIC1TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSQuestionNoPICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionNoPICTableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_BottomButtonTVC" bundle:nil] forCellReuseIdentifier:@"L_BottomButtonTVC"];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_ShareActivityTVC" bundle:nil] forCellReuseIdentifier:@"L_ShareActivityTVC"];
    
    @WeakObj(self);

    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetOtherdatalistRefresh:YES];
        
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetOtherdatalistRefresh:NO];
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
            
            if ([model.posttype isEqualToString:@"0"]) {///////////////////普通帖
                
                if (model.piclist.count >= 3) {//3图普通帖
                    
                    BBSNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormalTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];
                    
                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    
                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:2];
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
                    
                }else if (model.piclist.count == 2){//2图普通帖
                    
                    BBSNormal2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormal2TableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];
                    
                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    
                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:2];
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
                    
                }else if (model.piclist.count == 1){//1图普通帖
                    
                    BBSNormal1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormal1TableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];
                    
                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    
                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:2];
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
                }else if (model.piclist.count == 0){//无图普通帖
                    
                    BBSNormal0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormal0TableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];
                    
                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    
                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:2];
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
                }
            }else if ([model.posttype isEqualToString:@"2"]) {///////////////////////投票贴
                
                if ([model.pictype isEqualToString:@"1"]) {
                    
                    if (model.itemlist.count >= 3) {//3图投票贴
                        
                        BBSVotePICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVotePICTableViewCell"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.bottomView.backgroundColor = [UIColor whiteColor];
                        
                        cell.bottomViewHeightConstraint.constant = 0;
                        cell.type = 2;
                        cell.model = model;
                        
                        cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                            
                            [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                            
                        };
                        
                        return cell;
                    }else if (model.itemlist.count == 2){//2图投票贴
                        
                        BBSVotePIC2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVotePIC2TableViewCell"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.bottomView.backgroundColor = [UIColor whiteColor];
                        
                        cell.bottomViewHeightConstraint.constant = 0;
                        cell.type = 2;
                        cell.model = model;
                        
                        cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                            
                            [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                            
                        };
                        
                        
                        return cell;
                        
                    }else {
                        
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        return cell;
                    }


                }else if ([model.pictype isEqualToString:@"0"]){//文字投票贴
                    
                    if(model.itemlist.count >= 3){
                        
                        BBSVoteTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVoteTextTableViewCell"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.bottomView.backgroundColor = [UIColor whiteColor];
                        
                        cell.bottomViewHeightConstraint.constant = 0;
                        cell.type = 2;
                        cell.model = model;
                        
                        cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                            
                            [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                            
                        };
                        
                        
                        
                        return cell;
                    }else if(model.itemlist.count == 2){
                        
                        BBSVoteText2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVoteText2TableViewCell"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.bottomView.backgroundColor = [UIColor whiteColor];
                        
                        cell.bottomViewHeightConstraint.constant = 0;
                        cell.type = 2;
                        cell.model = model;
                        
                        cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                            
                            [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                            
                        };
                        
                        return cell;
                    }else {
                        
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        return cell;
                    }
                    
                }else {
                    
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    return cell;
                }
                
            }else if ([model.posttype isEqualToString:@"3"]) {///////////////////////问答贴
                if (model.piclist.count >= 3) {//3图问答贴
                    
                    BBSQuestionPICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPICTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];
                    
                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    
                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:2];
                    };
                    
                    return cell;
                    
                }else if (model.piclist.count == 2){//2图问答贴
                    
                    BBSQuestionPIC2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPIC2TableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];
                    
                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    
                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:2];
                    };
                    
                    return cell;
                    
                }else if (model.piclist.count == 1){//1图问答贴
                    
                    BBSQuestionPIC1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPIC1TableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];
                    
                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    
                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:2];
                    };
                    return cell;
                }else if (model.piclist.count == 0){//文字问答贴
                    
                    BBSQuestionNoPICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionNoPICTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.bottomView.backgroundColor = [UIColor whiteColor];
                    
                    cell.bottomViewHeightConstraint.constant = 0;
                    cell.type = 2;
                    cell.model = model;
                    
                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:2];
                    };
                    
                    return cell;
                }
                
            }else if (model.posttype.integerValue == 9) {//活动分享
                
                //=========活动分享到邻趣======================
                L_ShareActivityTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_ShareActivityTVC"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.model = model;
                
                @WeakObj(cell);
                cell.cellBtnDidClickBlock = ^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    //1.头像 2.点赞 3.社区
                    if (index == 1) {
                        [self gotoCommunityWebviewWithModel:model withListType:1];
                    }
                    
                    if (index == 2) {
                        
                        NSInteger isPraise = 0;
                        if (model.ispraise.integerValue == 0) {
                            isPraise = 0;
                        }else {
                            isPraise = 1;
                        }
                        
                        [self httpRequestForPraiseOrNot:isPraise withPostid:model.theid callBack:^(NSInteger praiseCount) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (model.ispraise.integerValue == 0) {
                                    
                                    model.ispraise = @"1";
                                    
                                    cellWeak.praise_ImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-红-拷贝"];
                                    
                                }else {
                                    
                                    model.ispraise = @"0";
                                    
                                    cellWeak.praise_ImageView.image = [UIImage imageNamed:@"邻趣-详情页-点赞图标-灰-拷贝"];
                                    
                                }
                                
                                model.praisecount = [NSString stringWithFormat:@"%ld",praiseCount];
                                cellWeak.dianzan_Label.text = model.praisecount;
                                
                            });
                            
                        }];
                        
                    }
                    
                    if (index == 3) {
                        [self gotoCommunityWebviewWithModel:model withListType:2];
                    }
                    
                };
                
                return cell;
                
            }else {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }

            
        }else if (indexPath.row == 1) {
            
            if (model.height - 14 > 0) {
                L_BottomButtonTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"L_BottomButtonTVC"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.type = 3;

                cell.threeButtonDidClickBlock = ^(NSInteger buttonIndex) {
                    NSLog(@"sender===%ld",(long)buttonIndex);
                    if (buttonIndex == 1) {
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
                        

                    }else if (buttonIndex == 2) {
                        NSLog(@"第二个按钮");
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
        if (model.posttype.integerValue == 0) {//普通帖
            UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
            L_NormalDetailsViewController *normalDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_NormalDetailsViewController"];
            normalDetailVC.postID = model.theid;
            
            normalDetailVC.deleteRefreshBlock = ^(){
                
                [_dataArray removeObject:model];
                [_tableView reloadData];
                
            };
            
            normalDetailVC.praiseAndCommentCallBack = ^(NSString *praise,NSString *comment,NSString *PostID,NSString *type){
                
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
            
            [self.navigationController pushViewController:normalDetailVC animated:YES];
        }

        if (model.posttype.integerValue == 3) {//问答帖
            UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
            BBSQusetionViewController *qusetion = [BBSStoryboard instantiateViewControllerWithIdentifier:@"BBSQusetionViewController"];
            qusetion.postID = model.theid;
            qusetion.deleteRefreshBlock = ^(){
                
                [_dataArray removeObject:model];
                [_tableView reloadData];
                
            };
            [self.navigationController pushViewController:qusetion animated:YES];
        }
        
        if (model.posttype.integerValue == 9) {//活动分享
            
            AppDelegate *appDlgt = GetAppDelegates;

            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
            WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
            
            if([model.sharegotourl hasSuffix:@".html"]) {
                webVc.url=[NSString stringWithFormat:@"%@?token=%@&version=%@",model.sharegotourl,appDlgt.userData.token,kCurrentVersion];
            }else {
                webVc.url=[NSString stringWithFormat:@"%@&token=%@&version=%@",model.sharegotourl,appDlgt.userData.token,kCurrentVersion];
            }
            
            //        webVc.url = [NSString stringWithFormat:@"%@",model.sharegotourl];
            webVc.type = 5;
            webVc.shareTypes = 5;
            
            UserActivity *userModel = [[UserActivity alloc]init];
            userModel.gotourl = [NSString stringWithFormat:@"%@",model.sharegotourl];
            webVc.userActivityModel = userModel;
            
            if (![XYString isBlankString:model.title]) {
                webVc.title = model.title;
            }else {
                webVc.title = @"活动详情";
            }
            webVc.isGetCurrentTitle = YES;
            
            webVc.talkingName = @"shequhuodong";
            
            [self.navigationController pushViewController:webVc animated:YES];
        }
        
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
