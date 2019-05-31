//
//  HouseOrCarViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "HouseOrCarViewController.h"

#import "BBSMainPresenters.h"

#import "WebViewVC.h"

#import "personListViewController.h"

#import "L_NewMinePresenters.h"

#import "personListViewController.h"
#import "L_HouseDetailsViewController.h"
#import "L_NormalDetailsViewController.h"
#import "BBSQusetionViewController.h"
#import "HouseOrCarViewController.h"

//------------房产帖cell--------------
#import "BBSHouseTableViewCell.h"
#import "BBSHouse2TableViewCell.h"
#import "BBSHouse1TableViewCell.h"
#import "BBSHouse0TableViewCell.h"

@interface HouseOrCarViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    
    AppDelegate *appDlgt;
    
    NSInteger listType;
    
    NSString *communityID_;
    
    NSString *title_;
    
    NSMutableArray *dataArray;//帖子列表数据源
    
    NSInteger pageNo;//分页记录
    
    UIView *holdView;//展示没有数据视图
    
    UITableView *tableView_;
}

@end

@implementation HouseOrCarViewController

#pragma mark - network method

-(void)getListData{
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld",pageNo];
    
    [BBSMainPresenters getPostList:@"0" userid:@"" sortkey:@"new" contype:@"0" posttype:@"4" poststate:@"-999" iscollect:@"0" isuserfollow:@"-1" tagsname:@"" pagesize:@"20" page:pageStr communityid:communityID_ updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            
            if (tableView_.mj_header.isRefreshing) {
                [tableView_.mj_header endRefreshing];
            }
            if (tableView_.mj_footer.isRefreshing) {
                [tableView_.mj_footer endRefreshing];
            }
            
            if(resultCode==SucceedCode)
            {

                if (pageNo == 1){
                    
                    [dataArray removeAllObjects];
                    [dataArray addObjectsFromArray:data];
                    
                    [tableView_ reloadData];
                }else{
                    
                    NSArray * tmparr = (NSArray *)data;
                    
                    if (tmparr.count == 0) {
                        
                        pageNo = pageNo - 1;
                    }else{
                        
                        NSInteger count = dataArray.count;
                        [dataArray addObjectsFromArray:tmparr];
                        
                        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc]init];
                        for (int i = 0; i < tmparr.count; i++) {
                            NSIndexPath *newPath = [NSIndexPath indexPathForRow:(count+i) inSection:0];
                            [insertIndexPaths addObject:newPath];
                        }
                        [tableView_ beginUpdates];
                        [tableView_ insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [tableView_ endUpdates];
                        if (insertIndexPaths.count > 0) {
                            
                            [tableView_ scrollToRowAtIndexPath:insertIndexPaths[0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                        }
                    }
                }
            }else
            {

                if (pageNo != 1) {
                    pageNo --;
                }else{
                    
                }
            }
            if (dataArray.count > 0) {
                
                holdView.hidden = YES;
                holdView.alpha = 0;
            }else{
                
                holdView.hidden = NO;
                holdView.alpha = 1;
            }
        });
    }];
}

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

#pragma mark - extend method

-(void)getCommunityID:(NSString *)communityID
                title:(NSString *)title{
    
    communityID_ = communityID;
    title_ = title;
}

-(void)configUI{
    
    tableView_= [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 2 * 10, SCREEN_HEIGHT - (44+statuBar_Height)) style:UITableViewStylePlain];
    tableView_.backgroundColor = [UIColor clearColor];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:tableView_];
    
    UIView *white = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView_.frame.size.width, 5)];
    white.backgroundColor = [UIColor clearColor];
    
    tableView_.tableHeaderView = white;
    
    holdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView_.frame.size.width, tableView_.frame.size.height)];
    holdView.backgroundColor = [UIColor clearColor];
    holdView.userInteractionEnabled = YES;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake( 30, (holdView.frame.size.height - 80 ) / 2 - 120, holdView.frame.size.width - 30 * 2, 80)];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.contentMode = UIViewContentModeCenter;
    imgView.image = [UIImage imageNamed:@"新版-无帖子"];
    [holdView addSubview:imgView];
    
    UILabel *errLal = [[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y + imgView.frame.size.height + 30, imgView.frame.size.width, 20)];
    errLal.text = @"当前社区还没有人发帖，赶快点击发帖，和大家打个招呼吧！";
    errLal.font = [UIFont systemFontOfSize:15];
    errLal.textColor = [UIColor blackColor];
    errLal.textAlignment = NSTextAlignmentCenter;
    [errLal setNumberOfLines:0];
    [errLal sizeToFit];
    [holdView addSubview:errLal];
    
    holdView.hidden = YES;
    holdView.alpha = 0;
    
    [tableView_ addSubview:holdView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView_ reloadData];
    });
    [self getListData];
    
    /////////////////房产帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouseTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouseTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouse2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouse1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouse0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse0TableViewCell"];
    
    [tableView_ registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

-(void)configNavigation{
    
    self.title = [NSString stringWithFormat:@"%@",title_];
}

#pragma mark - life cycle method

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    appDlgt = GetAppDelegates;
    pageNo = 1;
    dataArray = [[NSMutableArray alloc]init];
    
    [self configNavigation];
    [self configUI];
    
    @WeakObj(self);
    
    tableView_.mj_header = [MJTimeHomeGifHeader headerWithRefreshingBlock:^{
        pageNo = 1;
        [selfWeak getListData];
        
    }];
    
    tableView_.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pageNo = pageNo + 1;
        [selfWeak getListData];
        
    }];
    
    [tableView_.mj_footer setAutomaticallyHidden:YES];
    
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
// 在控制器中实现tableView:estimatedHeightForRowAtIndexPath:方法，返回一个估计高度，比如100 下方法可以调节“创建cell”和“计算cell高度”两个方法的先后执行顺序
/**
 *  返回每一行的估计高度，只要返回了估计高度，就会先调用cellForRowAtIndexPath给model赋值，然后调用heightForRowAtIndexPath返回cell真实的高度
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBSModel *model = [dataArray objectAtIndex:indexPath.row];
    
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBSModel *model = dataArray[indexPath.row];
    NSLog(@"%@-----%@",model.redtype,model.content);
    //    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", [indexPath section],[indexPath row]];//以indexPath来唯一确定cell
    
    @WeakObj(self);
    
    if ([title_ isEqualToString:@"房产列表"]) {
        
        if ([model.posttype isEqualToString:@"4"] && ([model.housetype isEqualToString:@"10"] || [model.housetype isEqualToString:@"11"])) {///////////////////////房产贴
            if (model.piclist.count >= 3) {//3图房产贴
                
                BBSHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouseTableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }else{
                    
                    cell.top = 0;
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
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
                
            }else if (model.piclist.count == 2){//2图房产贴
                
                BBSHouse2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse2TableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }else{
                    
                    cell.top = 0;
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
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
                
            }else if (model.piclist.count == 1){//1图房产贴
                
                BBSHouse1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse1TableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }else{
                    
                    cell.top = 0;
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
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
            }else if (model.piclist.count == 0){//0图房产贴
                
                BBSHouse1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse1TableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }else{
                    
                    cell.top = 0;
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
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

    }else if ([title_ isEqualToString:@"车位列表"]) {
        
        if ([model.posttype isEqualToString:@"4"] && ([model.housetype isEqualToString:@"30"] || [model.housetype isEqualToString:@"31"])) {///////////////////////房产贴
            if (model.piclist.count >= 3) {//3图房产贴
                
                BBSHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouseTableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }else{
                    
                    cell.top = 0;
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
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
                
            }else if (model.piclist.count == 2){//2图房产贴
                
                BBSHouse2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse2TableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }else{
                    
                    cell.top = 0;
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
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
                
            }else if (model.piclist.count == 1){//1图房产贴
                
                BBSHouse1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse1TableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }else{
                    
                    cell.top = 0;
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
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
            }else if (model.piclist.count == 0){//0图房产贴
                
                BBSHouse1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouse1TableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }else{
                    
                    cell.top = 0;
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
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
    }else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BBSModel *model = dataArray[indexPath.row];
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
        
        [self.navigationController pushViewController:houseDetailVC animated:YES];
        return;
    }
    
    if (model.posttype.integerValue == 3) {//问答帖
        UIStoryboard * BBSStoryboard = [UIStoryboard storyboardWithName:@"BBS" bundle:nil];
        BBSQusetionViewController *qusetion = [BBSStoryboard instantiateViewControllerWithIdentifier:@"BBSQusetionViewController"];
        qusetion.postID = model.theid;
        
        qusetion.praiseAndCommentCallBack = ^(NSString *praise,NSString *comment,NSString *PostID,NSString *type){
            
            
            if (![XYString isBlankString:comment]) {
                
                model.commentcount = comment;
            }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        };
        
        [self.navigationController pushViewController:qusetion animated:YES];
        return;
    }
}

/**
 进入社区帖子,进入个人中心 listtype==2为社区帖子
 */
- (void)gotoCommunityWebviewWithModel:(BBSModel *)model withListType:(NSInteger)listtype {
    
    personListViewController *personList = [[personListViewController alloc]init];
    [personList getuserID:model.userid];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personList animated:YES];
}

@end
