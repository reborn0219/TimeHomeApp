//
//  L_ActivesViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "L_ActivesViewController.h"

//------------普通帖cell--------------
#import "BBSNormalTableViewCell.h"
#import "BBSNormal2TableViewCell.h"
#import "BBSNormal1TableViewCell.h"
#import "BBSNormal0TableViewCell.h"
//------------广告帖cell--------------
#import "BBSAdvertTableViewCell.h"
#import "BBSAdvert2TableViewCell.h"
#import "BBSAdvert1TableViewCell.h"
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
//------------商品帖cell--------------
#import "BBSCommodityTableViewCell.h"
#import "BBSCommodity2TableViewCell.h"
#import "BBSCommodity1TableViewCell.h"
//------------房产帖cell--------------
#import "BBSHouseTableViewCell.h"
#import "BBSHouse2TableViewCell.h"
#import "BBSHouse1TableViewCell.h"
#import "BBSHouse0TableViewCell.h"

#import "BBSMainPresenters.h"

#import "WebViewVC.h"

#import "L_NewMinePresenters.h"

#import "L_NormalDetailsViewController.h"
#import "L_HouseDetailsViewController.h"
#import "BBSQusetionViewController.h"
#import "CommunityListViewController.h"
#import "personListViewController.h"

#import "L_ShareActivityTVC.h"

@interface L_ActivesViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger page;
    
    NSInteger listType;
}
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation L_ActivesViewController

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

#pragma mark - 请求帖子列表

/**
 请求帖子列表
 
 @param isRefresh 是否为刷新
 */
- (void)httpRequestForGetdatalistRefresh:(BOOL)isRefresh {
    
    if (isRefresh) {
        page = 1;
    }else {
        page  = page + 1;
    }
    
    [BBSMainPresenters getPostList:@"0" userid:@"" sortkey:@"new" contype:@"0" posttype:@"-1" poststate:@"-999" iscollect:@"0" isuserfollow:@"1" tagsname:@"" pagesize:@"20" page:[NSString stringWithFormat:@"%ld",page] communityid:@"" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
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
                        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                        for (int i = 0; i < tmparr.count; i++) {
                            NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                            [insertIndexPaths addObject:newPath];
                        }
                        [_tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
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
                [self showNothingnessViewWithType:NoContentTypeAttentionFriends Msg:@"您最近没有新的关注" eventCallBack:nil];
                [self.view sendSubviewToBack:self.nothingnessView];
                
            }else {
                [self hiddenNothingnessView];
            }
            
        });
        
    }];
    
}

/**
 刷新数据
 */
- (void)refreshDataList {
    
    [_tableView.mj_header beginRefreshing];

//    [self httpRequestForGetdatalistRefresh:YES];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTICE_REFRESH_ATTENTION_DATA object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataList) name:NOTICE_REFRESH_ATTENTION_DATA object:nil];
    
    page = 1;
    listType = 2;
    _dataArray = [[NSMutableArray alloc] init];

    [self createTableView];

    [_tableView.mj_header beginRefreshing];
}

- (void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 16, SCREEN_HEIGHT - (44+statuBar_Height) - 55 - 16 ) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = CLEARCOLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    /////////////////普通帖/////////////////
    [_tableView registerNib:[UINib nibWithNibName:@"BBSNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormalTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSNormal2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal2TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSNormal1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal1TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSNormal0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal0TableViewCell"];
    
    /////////////////广告帖/////////////////
    [_tableView registerNib:[UINib nibWithNibName:@"BBSAdvertTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvertTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSAdvert2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvert2TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSAdvert1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvert1TableViewCell"];
    
    /////////////////投票帖/////////////////
    [_tableView registerNib:[UINib nibWithNibName:@"BBSVotePICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVotePICTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSVotePIC2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVotePIC2TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSVoteTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVoteTextTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSVoteText2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVoteText2TableViewCell"];
    
    /////////////////问答帖/////////////////
    [_tableView registerNib:[UINib nibWithNibName:@"BBSQuestionPICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPICTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSQuestionPIC2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPIC2TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSQuestionPIC1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPIC1TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSQuestionNoPICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionNoPICTableViewCell"];
    
    /////////////////商品帖/////////////////
    [_tableView registerNib:[UINib nibWithNibName:@"BBSCommodityTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodityTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSCommodity2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodity2TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSCommodity1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodity1TableViewCell"];
    
    /////////////////房产帖/////////////////
    [_tableView registerNib:[UINib nibWithNibName:@"BBSHouseTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouseTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSHouse2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse2TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSHouse1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse1TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BBSHouse0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse0TableViewCell"];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"L_ShareActivityTVC" bundle:nil] forCellReuseIdentifier:@"L_ShareActivityTVC"];
    
    @WeakObj(self);
    
    _tableView.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetdatalistRefresh:YES];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [selfWeak httpRequestForGetdatalistRefresh:NO];
    }];
    
    [_tableView.mj_footer setAutomaticallyHidden:YES];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
// 在控制器中实现tableView:estimatedHeightForRowAtIndexPath:方法，返回一个估计高度，比如100 下方法可以调节“创建cell”和“计算cell高度”两个方法的先后执行顺序
/**
 *  返回每一行的估计高度，只要返回了估计高度，就会先调用cellForRowAtIndexPath给model赋值，然后调用heightForRowAtIndexPath返回cell真实的高度
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBSModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    return model.height > 0 ? model.height : 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @WeakObj(self);
    if (_dataArray.count > 0) {
        
        BBSModel *model = _dataArray[indexPath.row];
        
        if ([model.posttype isEqualToString:@"0"]) {///////////////////普通帖
            
            if (model.piclist.count >= 3) {//3图普通帖
                
                BBSNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormalTableViewCell"];
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
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
                
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
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
                
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
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
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
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
            
            if (model.piclist.count >= 3) {//3图投票贴
                
                BBSVotePICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVotePICTableViewCell"];
                
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                
                return cell;
                
            }else if (model.piclist.count == 2){//2图投票贴
                
                BBSVotePIC2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVotePIC2TableViewCell"];
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                return cell;
                
            }else if (model.piclist.count == 0){//文字投票贴
                
                if(model.itemlist.count >= 3){
                    
                    BBSVoteTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVoteTextTableViewCell"];
                    cell.type = listType;
                    cell.model = model;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                        
                        [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                        
                    };
                    
                    
                    return cell;
                    
                }else if(model.itemlist.count == 2){
                    
                    BBSVoteText2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVoteText2TableViewCell"];
                    
                    cell.type = listType;
                    cell.model = model;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
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
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                };
                
                return cell;
                
            }else if (model.piclist.count == 2){//2图问答贴
                
                BBSQuestionPIC2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPIC2TableViewCell"];
                
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                };
                
                return cell;
                
            }else if (model.piclist.count == 1){//1图问答贴
                
                BBSQuestionPIC1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPIC1TableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                };
                
                return cell;
            }else if (model.piclist.count == 0){//文字问答贴
                
                BBSQuestionNoPICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionNoPICTableViewCell"];
                
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                };
                
                return cell;
            }
        }else if ([model.posttype isEqualToString:@"4"]) {///////////////////////房产贴
            if (model.piclist.count >= 3) {//3图房产贴
                
                BBSHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouseTableViewCell"];
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                };
                
                cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                    /** 0 房产 1 车位 */
                    
                    AppDelegate *appDlt = GetAppDelegates;
                    
                    if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                        return ;
                    }
                    
                    if (index == 0) {
                        
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
                        {
                            webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        else
                        {
                            webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        webVc.title = kHouseListTitle;
                        webVc.isGetCurrentTitle = YES;
                        [self.navigationController pushViewController:webVc animated:YES];
                        
                    }else if (index == 1) {
                        
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
                        {
                            webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        else
                        {
                            webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        webVc.title = kCarListTitle;
                        webVc.isGetCurrentTitle = YES;
                        [self.navigationController pushViewController:webVc animated:YES];
                        
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
                
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                };
                
                cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                    /** 0 房产 1 车位 */
                    
                    AppDelegate *appDlt = GetAppDelegates;
                    
                    if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                        return ;
                    }
                    
                    if (index == 0) {
                        
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
                        {
                            webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        else
                        {
                            webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        webVc.title = kHouseListTitle;
                        webVc.isGetCurrentTitle = YES;
                        [self.navigationController pushViewController:webVc animated:YES];
                        
                    }else if (index == 1) {
                        
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
                        {
                            webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        else
                        {
                            webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        webVc.title = kCarListTitle;
                        webVc.isGetCurrentTitle = YES;
                        [self.navigationController pushViewController:webVc animated:YES];
                        
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
                
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                };
                
                cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                    /** 0 房产 1 车位 */
                    
                    AppDelegate *appDlt = GetAppDelegates;
                    
                    if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                        return ;
                    }
                    
                    if (index == 0) {
                        
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
                        {
                            webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        else
                        {
                            webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        webVc.title = kHouseListTitle;
                        webVc.isGetCurrentTitle = YES;
                        [self.navigationController pushViewController:webVc animated:YES];
                        
                    }else if (index == 1) {
                        
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
                        {
                            webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        else
                        {
                            webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        webVc.title = kCarListTitle;
                        webVc.isGetCurrentTitle = YES;
                        [self.navigationController pushViewController:webVc animated:YES];
                        
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
                
                cell.type = listType;
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:0];
                    
                };
                
                cell.commButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                };
                
                cell.houseOrCarDidClickBlock = ^(NSInteger index) {
                    /** 0 房产 1 车位 */
                    
                    AppDelegate *appDlt = GetAppDelegates;
                    
                    if ([XYString isBlankString:appDlt.userData.url_postsearchhouse]) {
                        return ;
                    }
                    
                    if (index == 0) {
                        
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
                        {
                            webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        else
                        {
                            webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=41",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        webVc.title = kHouseListTitle;
                        webVc.isGetCurrentTitle = YES;
                        [self.navigationController pushViewController:webVc animated:YES];
                        
                    }else if (index == 1) {
                        
                        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
                        WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
                        if([appDlt.userData.url_postsearchhouse hasSuffix:@".html"])
                        {
                            webVc.url=[NSString stringWithFormat:@"%@?token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        else
                        {
                            webVc.url=[NSString stringWithFormat:@"%@&token=%@&posttype=42",appDlt.userData.url_postsearchhouse,appDlt.userData.token];
                        }
                        webVc.title = kCarListTitle;
                        webVc.isGetCurrentTitle = YES;
                        [self.navigationController pushViewController:webVc animated:YES];
                        
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
                
            }else {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
            
        }else if ([model.posttype isEqualToString:@"1"]) {///////////////////////商品贴
            
            if (model.piclist.count >= 3) {//3图商品贴
                
                BBSCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodityTableViewCell"];
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
                
            }else if (model.piclist.count == 2){//2图商品贴
                
                BBSCommodity2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodity2TableViewCell"];
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
                
            }else if (model.piclist.count == 1){//1图商品贴
                
                BBSCommodity1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodity1TableViewCell"];
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }else {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
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

    }

    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBSModel *model = _dataArray[indexPath.row];
    
    if (model.posttype.integerValue == 0) {//普通帖
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        L_NormalDetailsViewController *normalDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_NormalDetailsViewController"];
        normalDetailVC.postID = model.theid;
        
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
        
        normalDetailVC.deleteRefreshBlock = ^(){
            
            [_dataArray removeObject:model];
            [_tableView reloadData];
            
        };
        
        [self.navigationController pushViewController:normalDetailVC animated:YES];
        return;
    }
    
    if (model.posttype.integerValue == 4) {//房产车位帖
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        L_HouseDetailsViewController *houseDetailVC = [BBSStoryboard instantiateViewControllerWithIdentifier:@"L_HouseDetailsViewController"];
        houseDetailVC.postID = model.theid;
        houseDetailVC.bbsModel = model;
        
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
        
        houseDetailVC.deleteRefreshBlock = ^(){
            
            [_dataArray removeObject:model];
            [_tableView reloadData];
            
        };
        
        [self.navigationController pushViewController:houseDetailVC animated:YES];
        return;
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
        return;
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
