//
//  CommunityListViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 2017/2/8.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "CommunityListViewController.h"

#import "BBSMainPresenters.h"

#import "WebViewVC.h"

#import "personListViewController.h"

#import "L_NewMinePresenters.h"

#import "personListViewController.h"
#import "L_HouseDetailsViewController.h"
#import "L_NormalDetailsViewController.h"
#import "BBSQusetionViewController.h"
#import "HouseOrCarViewController.h"

//------------普通帖cell--------------
#import "BBSNormalTableViewCell.h"
#import "BBSNormal2TableViewCell.h"
#import "BBSNormal1TableViewCell.h"
#import "BBSNormal0TableViewCell.h"
//------------广告帖cell--------------
#import "BBSAdvertTableViewCell.h"
#import "BBSAdvert2TableViewCell.h"
#import "BBSAdvert1TableViewCell.h"
#import "BBSAdvert0TableViewCell.h"
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

#import "L_ShareActivityTVC.h"

@interface CommunityListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    
    AppDelegate *appDlgt;
    
    NSInteger listType;
    
    NSString *communityID_;
    
    NSString *communityName_;
    
    NSDictionary *topDict;//顶部参与数，帖子数字典
    
    NSMutableArray *dataArray;//帖子列表数据源
    
    NSInteger pageNo;//分页记录
    
    UIView *holdView;//展示没有数据视图
    
    UITableView *tableView_;
    
    UILabel *postcount;//帖子数
    
    UILabel *postjoincount;//参与人数
}

@end

@implementation CommunityListViewController

#pragma mark - network method
///获取顶部帖子数量，参与数量数据
-(void)getHeaderData
{
    [BBSMainPresenters getCommPostStat:communityID_ updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                topDict = (NSDictionary *)data;
            }else
            {
                topDict = @{};
                //[self showToastMsg:data Duration:5.0];
            }
            
            //填写数据
            
            if (topDict[@"postcount"]) {
                postcount.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",topDict[@"postcount"]]];
            }else{
                
                postcount.text = @"0";
            }
            
            if (topDict[@"postjoincount"]) {
                
                postjoincount.text = [XYString IsNotNull:[NSString stringWithFormat:@"%@",topDict[@"postjoincount"]]];
            }else{
                
                postjoincount.text = @"0";
            }
        });
    }];
}
-(void)getListData{

    NSString *pageStr = [NSString stringWithFormat:@"%ld",pageNo];
    
    [BBSMainPresenters getPostList:@"0" userid:@"" sortkey:@"new" contype:@"0" posttype:@"-1" poststate:@"-999" iscollect:@"0" isuserfollow:@"-1" tagsname:@"" pagesize:@"20" page:pageStr communityid:communityID_ updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
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
        communityName:(NSString *)communityName{
    
    communityID_ = communityID;
    communityName_ = communityName;
}

-(void)configUI{
    
    tableView_= [[UITableView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 2 * 10, SCREEN_HEIGHT - (44+statuBar_Height)) style:UITableViewStylePlain];
    tableView_.backgroundColor = [UIColor clearColor];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:tableView_];
    // ---------------头部参加人数和发帖数量
    
    [self setHeader];

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
    
    /////////////////普通帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormalTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSNormal2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSNormal1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSNormal0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSNormal0TableViewCell"];
    
    /////////////////广告帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSAdvertTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvertTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSAdvert2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvert2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSAdvert1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvert1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSAdvert0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSAdvert0TableViewCell"];
    
    /////////////////投票帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSVotePICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVotePICTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSVotePIC2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVotePIC2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSVoteTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVoteTextTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSVoteText2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSVoteText2TableViewCell"];
    
    /////////////////问答帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSQuestionPICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPICTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSQuestionPIC2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPIC2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSQuestionPIC1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionPIC1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSQuestionNoPICTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSQuestionNoPICTableViewCell"];
    
    /////////////////商品帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSCommodityTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodityTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSCommodity2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodity2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSCommodity1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSCommodity1TableViewCell"];
    
    /////////////////房产帖/////////////////
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouseTableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouseTableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouse2TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse2TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouse1TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse1TableViewCell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BBSHouse0TableViewCell" bundle:nil] forCellReuseIdentifier:@"BBSHouse0TableViewCell"];
    
    [tableView_ registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [tableView_ registerNib:[UINib nibWithNibName:@"L_ShareActivityTVC" bundle:nil] forCellReuseIdentifier:@"L_ShareActivityTVC"];
    
}

-(void)configNavigation{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( 0, 0, SCREEN_WIDTH - 50 , 40);
    [button setImage:[UIImage imageNamed:@"邻趣-首页-顶部定位图标"] forState:UIControlStateNormal];
    [button setTitle:communityName_ forState:UIControlStateNormal];
    [button setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    button.titleLabel.font = DEFAULT_BOLDFONT(18);
    //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
    button.imageEdgeInsets = UIEdgeInsetsMake( 0, 0, 0, 50);
    //button标题的偏移量，这个偏移量是相对于图片的
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    button.userInteractionEnabled = NO;
    self.navigationItem.titleView = button;

}

-(void)setHeader{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView_.frame.size.width, 70)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *backWhite = [[UIView alloc]initWithFrame:CGRectMake(0, 10, headerView.frame.size.width, 50)];
    backWhite.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:backWhite];
    
    UIView *midLine = [[UIView alloc]initWithFrame:CGRectMake((tableView_.frame.size.width - 2) / 2, 10, 2, backWhite.frame.size.height - 20)];
    midLine.backgroundColor = LINE_COLOR;
    [backWhite addSubview:midLine];
    
    float imgHeight = 21;
    
    UIImageView *postcountImg = [[UIImageView alloc]initWithFrame:CGRectMake( 20, (backWhite.frame.size.height - imgHeight) / 2, imgHeight, imgHeight)];
    postcountImg.image = [UIImage imageNamed:@"邻趣-社区帖子-帖子数图标"];
    [backWhite addSubview:postcountImg];
    
    UILabel *left = [[UILabel alloc]initWithFrame:CGRectMake(postcountImg.frame.origin.x + postcountImg.frame.size.width + 5, postcountImg.frame.origin.y, midLine.frame.origin.x - (postcountImg.frame.origin.x + postcountImg.frame.size.width + 5) - 20, postcountImg.frame.size.height)];
    left.text = @"帖子数";
    left.textColor = [UIColor blackColor];
    left.textAlignment = NSTextAlignmentLeft;
    left.font = [UIFont systemFontOfSize:15];
    [backWhite addSubview:left];
    
    postcount = [[UILabel alloc]initWithFrame:left.frame];
    
    postcount.textColor = [UIColor blackColor];
    postcount.textAlignment = NSTextAlignmentRight;
    postcount.font = [UIFont systemFontOfSize:15];
    [backWhite addSubview:postcount];
    
    
    UIImageView *postjoincountImg = [[UIImageView alloc]initWithFrame:CGRectMake(20 + midLine.frame.origin.x + midLine.frame.size.width, (backWhite.frame.size.height - imgHeight) / 2, imgHeight, imgHeight)];
    postjoincountImg.image = [UIImage imageNamed:@"邻趣-社区帖子-参与数图标"];
    [backWhite addSubview:postjoincountImg];
    
    UILabel *right = [[UILabel alloc]initWithFrame:CGRectMake(postjoincountImg.frame.origin.x + postjoincountImg.frame.size.width + 5, postjoincountImg.frame.origin.y, backWhite.frame.size.width - (postjoincountImg.frame.origin.x + postjoincountImg.frame.size.width + 5) - 20, postjoincountImg.frame.size.height)];
    right.text = @"参与数";
    right.textColor = [UIColor blackColor];
    right.textAlignment = NSTextAlignmentLeft;
    right.font = [UIFont systemFontOfSize:15];
    [backWhite addSubview:right];
    
    postjoincount = [[UILabel alloc]initWithFrame:right.frame];
    
    postjoincount.textColor = [UIColor blackColor];
    postjoincount.textAlignment = NSTextAlignmentRight;
    postjoincount.font = [UIFont systemFontOfSize:15];
    [backWhite addSubview:postjoincount];
    
    tableView_.tableHeaderView = headerView;
}

#pragma mark - life cycle method

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getHeaderData];
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
        [selfWeak getHeaderData];
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
    
    if ([model.posttype isEqualToString:@"0"] || [model.posttype isEqualToString:@"9"]) {///////////////////普通帖
        
        if (model.piclist.count >= 3) {//3图普通帖
            
            BBSNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormalTableViewCell"];
            
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
            
        }else if (model.piclist.count == 2){//2图普通帖
            
            BBSNormal2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormal2TableViewCell"];
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
            
        }else if (model.piclist.count == 1){//1图普通帖
            
            BBSNormal1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormal1TableViewCell"];
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
        }else if (model.piclist.count == 0){//无图普通帖
            
            BBSNormal0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormal0TableViewCell"];
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
    }else if ([model.posttype isEqualToString:@"5"]) {///////////////////////广告贴
        
        if([model.advtype isEqualToString:@"100"]){
            
            BBSAdvert0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSAdvert0TableViewCell"];
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([model.advtype isEqualToString:@"101"]){
            
            if (model.piclist.count >= 3) {//3图广告贴
                
                BBSAdvertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSAdvertTableViewCell"];
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }else if (model.piclist.count == 2){//2图广告贴
                
                BBSAdvert2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSAdvert2TableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.model = model;
                
                return cell;
                
            }else if (model.piclist.count == 1){//1图广告贴
                
                BBSAdvert1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSAdvert1TableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.model = model;
                
                return cell;
            }
        }
    }else if ([model.posttype isEqualToString:@"2"]) {///////////////////////投票贴
        if ([model.pictype isEqualToString:@"1"]) {//3图投票贴
            
            if (model.itemlist.count >= 3) {
                
                BBSVotePICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVotePICTableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                    
                };
                
                return cell;
            }else if (model.itemlist.count == 2){//2图投票贴
                
                BBSVotePIC2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVotePIC2TableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                    
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
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                    
                };
                
                return cell;
            }else if(model.itemlist.count == 2){
                
                BBSVoteText2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVoteText2TableViewCell"];
                cell.type = listType;
                
                if (listType  == 0) {
                    cell.top = [model.istop integerValue];
                }
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model withListType:listType];
                    
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
            
            return cell;
            
        }else if (model.piclist.count == 2){//2图问答贴
            
            BBSQuestionPIC2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPIC2TableViewCell"];
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
            
            return cell;
            
        }else if (model.piclist.count == 1){//1图问答贴
            
            BBSQuestionPIC1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPIC1TableViewCell"];
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
            return cell;
            
        }else if (model.piclist.count == 0){//文字问答贴
            
            BBSQuestionNoPICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionNoPICTableViewCell"];
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
            
            return cell;
        }
    }else if ([model.posttype isEqualToString:@"4"]) {///////////////////////房产贴
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
        }else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if ([model.posttype isEqualToString:@"1"]) {///////////////////////商品贴
        
        if (model.piclist.count >= 3) {//3图商品贴
            
            BBSCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodityTableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }else if (model.piclist.count == 2){//2图商品贴
            
            BBSCommodity2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodity2TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }else if (model.piclist.count == 1){//1图商品贴
            
            BBSCommodity1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommodity1TableViewCell"];
            cell.type = listType;
            
            if (listType  == 0) {
                cell.top = [model.istop integerValue];
            }else{
                
                cell.top = 0;
            }
            
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
        
        cell.cellType = 2;

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
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    if (model.posttype.integerValue == 9) {//活动分享
        
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
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    
    if (listType == 2) {
        
        if([appDlgt.userData.url_gamcommindex hasSuffix:@".html"]) {
            
            webVc.url=[NSString stringWithFormat:@"%@?token=%@&communityid=%@",appDlgt.userData.url_gamcommindex,appDlgt.userData.token,model.communityid];
            webVc.isGetCurrentTitle = NO;
            webVc.isCommunityNavOrNot = YES;
            webVc.title = [XYString IsNotNull:model.communityname];
            
        }else {
            
            webVc.url=[NSString stringWithFormat:@"%@&token=%@&communityid=%@",appDlgt.userData.url_gamcommindex,appDlgt.userData.token,model.communityid];
            webVc.isGetCurrentTitle = NO;
            webVc.isCommunityNavOrNot = YES;
            webVc.title = [XYString IsNotNull:model.communityname];
            
        }
        [self.navigationController pushViewController:webVc animated:YES];
    }else {
        
        personListViewController *personList = [[personListViewController alloc]init];
        [personList getuserID:model.userid];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personList animated:YES];
    }
    
    
}

@end
