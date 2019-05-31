//
//  MyTopicPostVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "MyTopicPostVC.h"
///vcs
#import "PersonalDataVC.h"
#import "ActionSheetVC.h"
#import "PublishTopicVC.h"
#import "WebViewVC.h"
#import "MessageAlert.h"
#import "ReviewDetailVC.h"

///cells
#import "DynamicImgCell.h"
#import "MyTopicCell.h"
///views
#import "PostHeaderView.h"
#import "CircleFooterView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
///models
#import "PostPresenter.h"
#import "TopicPostModel.h"
#import "DateTimeUtils.h"
#import "SharePresenter.h"
#import "SDPhotoBrowser.h"



@interface MyTopicPostVC ()
<UICollectionViewDataSource,SDPhotoBrowserDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
{
    /**
     *  我的话题数组
     */
    NSMutableArray *myTopicArray;
    /**
     *  我的帖子数组
     */
    NSMutableArray *myTieziArray;
    /**
     *  话题页数
     */
    NSInteger topicPage;
    /**
     *  帖子页数
     */
    NSInteger tieziPage;
}
@property (strong, nonatomic)UICollectionView *collectionV;
@property (strong,nonatomic)UITableView * table;
@property (copy,nonatomic)NSArray * imageList;


@property (weak, nonatomic) IBOutlet UIButton *left_title_btn;
@property (weak, nonatomic) IBOutlet UIButton *right_title_btn;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@end

@implementation MyTopicPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    topicPage = 1;
    tieziPage = 1;
    
    myTopicArray = [[NSMutableArray alloc]init];
    myTieziArray = [[NSMutableArray alloc]init];
    self.type = 2;
    self.titleView.layer.borderWidth = 1;
    self.titleView.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    [self.left_title_btn setTitleColor:TABBAR_COLOR forState:UIControlStateNormal];
    [self.left_title_btn setSelected:YES];
    [self.left_title_btn setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self initCollectionView];
    [self initTableView];

    [self loadone];
    
}
#pragma mark - 创建帖子collectionview
-(void)initCollectionView
{
    UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(10,64, SCREEN_WIDTH-20, SCREEN_HEIGHT-64) collectionViewLayout:flowlayout];
    [self.collectionV setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    self.collectionV.delegate = self;
    self.collectionV.dataSource =self;
    
    [self.collectionV registerNib:[UINib nibWithNibName:@"DynamicImgCell" bundle:nil] forCellWithReuseIdentifier:@"imgCell"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"PostHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"CircleFooterView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerCell"];
    [self.view addSubview:self.collectionV];
    
    @WeakObj(self);
    /**
     *  刷新
     */
    _collectionV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        tieziPage = 1;
        [selfWeak getTieziArrayIsOrNotRefresh:YES];

    }];
    
    _collectionV.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        tieziPage = tieziPage + 1;
        [selfWeak getTieziArrayIsOrNotRefresh:NO];
    }];
    
}
#pragma mark - 创建话题tableview
-(void)initTableView
{

    self.table = [[UITableView alloc]initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH-20, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.table.delegate =self;
    self.table.dataSource=self;
    [self.view setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    [self.table setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    [self.table registerNib:[UINib nibWithNibName:@"MyTopicCell" bundle:nil] forCellReuseIdentifier:@"MyTopicCell"];
    
    self.navigationItem.title = @"背景图";
    
    @WeakObj(self);
    /**
     *  刷新
     */
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        topicPage = 1;
        [selfWeak getTopicArrayIsOrNotRefresh:YES];
    }];
    /**
        加载
     */
    _table.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        topicPage = topicPage + 1;
        [selfWeak getTopicArrayIsOrNotRefresh:NO];
    }];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    NSNumber * isPush = [[NSUserDefaults standardUserDefaults]objectForKey:@"isPush"];
    if (!isPush.boolValue) {
        [self loadone];
    }
    
}
/**
 *  话题刷新
 *
 *  @param refresh YES刷新 NO加载
 */
- (void)getTopicArrayIsOrNotRefresh:(BOOL)refresh {
    
    @WeakObj(self);

    [PostPresenter getUserTopic:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"我发布的话题----%@",data);
            
            
            if(resultCode==SucceedCode)
            {
                if (refresh) {
                    [selfWeak.table.mj_header endRefreshing];
                    [myTopicArray removeAllObjects];
                    [myTopicArray addObjectsFromArray:data];
                    [_table reloadData];
                }else {
                    [selfWeak.table.mj_footer endRefreshing];

                    [myTopicArray addObjectsFromArray:data];
                    [_table reloadData];
                }
                selfWeak.table.hidden = NO;

            }
            else
            {
                if (refresh) {
                    [selfWeak.table.mj_header endRefreshing];

                }else
                {
                    [selfWeak.table.mj_footer endRefreshing];


                }
                topicPage --;
                //[selfWeak showToastMsg:data Duration:2.0];
            }
            if (myTopicArray.count == 0) {
                selfWeak.table.hidden = YES;
                [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"您还没有创建圈子" SubMsg:@"" btnTitle:@"创建圈子" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                    
                    if (index == 1) {
                        return ;
                    }
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil];
                    PublishTopicVC * ptVC = [storyboard instantiateViewControllerWithIdentifier:@"PublishTopicVC"];
                    [selfWeak.navigationController pushViewController:ptVC animated:YES];
                    
                }];

                [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];


            }

        });
        
    } withPage:[NSString stringWithFormat:@"%ld",topicPage]];
    
}
/**
 *  帖子刷新
 *
 *  @param refresh YES刷新 NO加载
 */
- (void)getTieziArrayIsOrNotRefresh:(BOOL)refresh {
    
    @WeakObj(self);
    AppDelegate * appdelegate = GetAppDelegates;
    [PostPresenter getTopicUserPosts:^(id  _Nullable data, ResultCode resultCode) {

        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"我发布的帖子----%@",data);
            
            if(resultCode==SucceedCode)
            {
                if (refresh) {
                    [selfWeak.collectionV.mj_header endRefreshing];

                    [myTieziArray removeAllObjects];
                    [myTieziArray addObjectsFromArray:data];
                    [_collectionV reloadData];
                }else {
                    [selfWeak.collectionV.mj_footer endRefreshing];

                    [myTieziArray addObjectsFromArray:data];
                    [_collectionV reloadData];
                }
                selfWeak.collectionV.hidden = NO;
            }
            else
            {
                if (refresh) {
                    [selfWeak.collectionV.mj_header endRefreshing];

                }else
                {
                    [selfWeak.collectionV.mj_footer endRefreshing];

                }
                tieziPage --;
                //[selfWeak showToastMsg:data Duration:2.0];
            }
            if (myTieziArray.count == 0) {
                
                selfWeak.collectionV.hidden = YES;
                
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"您还没有发布帖子" eventCallBack:nil];
        
                [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
            }


        });

    } withPage:[NSString stringWithFormat:@"%ld",tieziPage] withUserID:appdelegate.userData.userID];
    
}
/**
 *  每次进界面
 */
-(void)loadone
{
    if (self.type == 2) {
        [self.table setHidden:YES];
        [self.collectionV setHidden:NO];

        [_collectionV.mj_header beginRefreshing];
        
    }else
    {
        [self.table setHidden:NO];
        [self.collectionV setHidden:YES];
        
        [_table.mj_header beginRefreshing];

    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults]setObject:@NO forKey:@"isPush"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)titleClickAction:(id)sender {
    
    UIButton * temp_btn = (UIButton *)sender;
    _table.hidden = YES;
    _collectionV.hidden = YES;
    if (temp_btn.tag == 1000) {

        self.type = 2;
     
        //点击话题
        [self.left_title_btn setTitleColor:TABBAR_COLOR forState:UIControlStateNormal];
        [self.left_title_btn setSelected:YES];
        [self.left_title_btn setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.right_title_btn setTitleColor:UIColorFromRGB(0x8e8e8e) forState:UIControlStateNormal];
        [self.right_title_btn setSelected:NO];
        [self.right_title_btn setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
        
        [_collectionV.mj_header beginRefreshing];
        
    }else if(temp_btn.tag == 1001)
    {
        self.type = 1;
        
        //点击帖子
        [self.right_title_btn setTitleColor:TABBAR_COLOR forState:UIControlStateNormal];
        [self.right_title_btn setSelected:YES];
        [self.right_title_btn setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.left_title_btn setTitleColor:UIColorFromRGB(0x8e8e8e) forState:UIControlStateNormal];
        [self.left_title_btn setSelected:NO];
        [self.left_title_btn setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
        
        [_table.mj_header beginRefreshing];

    }
//    [self loadone];

}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UICollectionViewDelgate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicImgCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    TopicPostModel * TPML = [myTieziArray objectAtIndex:indexPath.section];
    NSDictionary * piclistDic = [TPML.piclist objectAtIndex:indexPath.row];

    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[piclistDic objectForKey:@"fileurl"]] placeholderImage:PLACEHOLDER_IMAGE options:SDWebImageCacheMemoryOnly];

    
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
        return CGSizeMake(SCREEN_WIDTH,40);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    TopicPostModel * TPML = [myTieziArray objectAtIndex:section];

    return CGSizeMake(SCREEN_WIDTH, TPML.cellHight+85);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    TopicPostModel * TPML = [myTieziArray objectAtIndex:indexPath.section];
    
    switch (TPML.piclist.count) {
        case 0:
        {
            
            return CGSizeMake(0,0);
        }
            break;
        case 1:
        {
            return CGSizeMake(SCREEN_WIDTH-20,(SCREEN_WIDTH-20-15)/2.0f);
        }
            break;
        case 2:
        {
            return CGSizeMake((SCREEN_WIDTH-20-cell_interval*3)/2.0f,(SCREEN_WIDTH-20-cell_interval*3)/2.0f);
        }
            break;
        case 3:
        {
            return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);
            
        }
            break;
        case 4:
        {
            if (indexPath.row==3) {
                
                return CGSizeMake(SCREEN_WIDTH-20,(SCREEN_WIDTH-20-cell_interval*3)/2.0f);
                
            }else
            {
                return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);
            }
            
        }
            break;
        case 5:
        {
            if (indexPath.row==3||indexPath.row==4) {
                
                return CGSizeMake((SCREEN_WIDTH-20-cell_interval*3)/2.0f,(SCREEN_WIDTH-20-cell_interval*3)/2.0f);
                
            }else
            {
                return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);
            }
            
        }
            break;
            
        case 6:
        {
            return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);
            
        }
            break;
        case 7:
        {
            if (indexPath.row==6) {
                
                return CGSizeMake(SCREEN_WIDTH-20,(SCREEN_WIDTH-20-cell_interval*3)/2.0f);
                
            }else
            {
                return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);
            }
            
            
        }
            break;
        case 8:
        {
            if (indexPath.row==6||indexPath.row==7) {
                
                return CGSizeMake((SCREEN_WIDTH-20-cell_interval*3)/2.0f,(SCREEN_WIDTH-20-cell_interval*3)/2.0f);
                
            }else
            {
                return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);
            }
            
        }
            break;
        case 9:
        {
            return CGSizeMake((SCREEN_WIDTH-20-cell_interval*4)/3.0f,(SCREEN_WIDTH-20-cell_interval*4)/3.0f);
            
        }
            break;
        default:
        {
            return CGSizeMake(0,0);
            
        }
            break;
    }

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    TopicPostModel * TPML = [myTieziArray objectAtIndex:section];

    return TPML.piclist.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0,0);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return myTieziArray.count;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        @WeakObj(self)
        PostHeaderView * circleHeaderView  =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell"forIndexPath:indexPath];
        TopicPostModel * TPML = [myTieziArray objectAtIndex:indexPath.section];
        NSString * newSystime = [TPML.systime substringWithRange:NSMakeRange(0,19)];
        
        circleHeaderView.timeLb.text = [DateTimeUtils StringFromDateTime:[XYString  NSStringToDate:newSystime]];
        
        circleHeaderView.contentLb.attributedText = TPML.contentAttriStr;
        
        circleHeaderView.titleLb.text = TPML.title;
        
        circleHeaderView.indexPath = indexPath;
        
        circleHeaderView.contentBlock = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
            NSString * typeStr = data;
            
            
            TopicPostModel * TPML_1 = [myTieziArray objectAtIndex:index.section];
            
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
            NSString * urlStr;
            
            WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
            AppDelegate *appDlgt=GetAppDelegates;
            
            if (typeStr.integerValue == 1) {
                
                urlStr = TPML_1.topicgotourl;
                webVc.type = 1;
                webVc.topicid = TPML_1.topicid;
            }else if (typeStr.integerValue == 2) {
                
                urlStr = TPML_1.postsgotourl;
                webVc.type = 2;
                webVc.TPML = TPML_1;
            }
            

            webVc.isShowRightBtn=YES;
            webVc.shareTypes=4;
            webVc.shareUr=urlStr;
            if([urlStr hasSuffix:@".html"])
            {
                webVc.url=[NSString stringWithFormat:@"%@?token=%@",urlStr,appDlgt.userData.token];
            }
            else
            {
                webVc.url=[NSString stringWithFormat:@"%@&token=%@",urlStr,appDlgt.userData.token];
            }

            //                        webVc.url = TPML_1.gotourl;
            webVc.title = TPML_1.webtitle;
            [self.navigationController pushViewController:webVc animated:YES];
            
        };

        
        circleHeaderView.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
        {
            [[MessageAlert shareMessageAlert] showInVC:selfWeak withTitle:@"确定删除此条帖子吗？" andCancelBtnTitle:@"取消" andOtherBtnTitle:@"确定"];
            [MessageAlert shareMessageAlert].block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
            {
                    if (index==Ok_Type) {
                        NSLog(@"---点击删除");
                        
                        [PostPresenter removeTopicPosts:^(id  _Nullable data, ResultCode resultCode) {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                
                                if (resultCode == SucceedCode) {
                                    [myTieziArray removeObjectAtIndex:indexPath.row];

                                    [selfWeak showToastMsg:@"删除成功！" Duration:2.5f];
                                    [selfWeak.collectionV reloadData];
                                    
                                }
                            });
                            
                            
                            
                        } withTopicID:TPML.postsid withReason:@""];

                      
                    }
            };

            
        };
        
        return circleHeaderView;
        
    }else if([kind isEqual:UICollectionElementKindSectionFooter]){
        
        CircleFooterView *circleFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerCell"forIndexPath:indexPath];
        circleFooterView.indexPath = indexPath;
        @WeakObj(self)

        ///评论
        circleFooterView.replayBlock = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
        {
            TopicPostModel * TPML = [myTieziArray objectAtIndex:index.section];
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
            WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
            
            AppDelegate *appDlgt=GetAppDelegates;
            if([TPML.postsgotourl hasSuffix:@".html"])
            {
                webVc.url=[NSString stringWithFormat:@"%@?token=%@",TPML.postsgotourl,appDlgt.userData.token];
            }
            else
            {
                webVc.url=[NSString stringWithFormat:@"%@&token=%@",TPML.postsgotourl,appDlgt.userData.token];
            }
            //            webVc.url = TPML.postsgotourl;
            webVc.title = TPML.webtitle;
            [self.navigationController pushViewController:webVc animated:YES];

        };
        ///点赞
        circleFooterView.praiseBlock = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
        {
            TopicPostModel * TPML = [myTieziArray objectAtIndex:index.section];
            
            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
            [indicator startAnimating:self];
            if(TPML.ispraised.boolValue){
                [PostPresenter removeTopicPraise:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [indicator stopAnimating];
                        TPML.ispraised = @"0";
                        TPML.praisecount = [NSString stringWithFormat:@"%ld",(long)(TPML.praisecount.integerValue -1)];
                        [selfWeak.collectionV reloadData];
                        
                    });
                    
                } withTopicID:TPML.postsid];
                
            }else
            {
                [PostPresenter addTopicPraise:^(id  _Nullable data, ResultCode resultCode) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [indicator stopAnimating];
                        TPML.ispraised = @"1";
                        TPML.praisecount = [NSString stringWithFormat:@"%ld",(long)(TPML.praisecount.integerValue +1)];
                        
                        [selfWeak.collectionV reloadData];
                        
                    });
                    
                } withTopicID:TPML.postsid];
            }

        };
        
        TopicPostModel * TPML = [myTieziArray objectAtIndex:indexPath.section];
        circleFooterView.praiseCountLB.text = TPML.praisecount;
        circleFooterView.replayCountLB.text = TPML.commentcount;
        if(TPML.ispraised.boolValue){
            
            [circleFooterView.praiseBtn setImage:[UIImage imageNamed:@"邻圈_已点赞"] forState:UIControlStateNormal];
            
        }else
        {
            [circleFooterView.praiseBtn setImage:[UIImage imageNamed:@"邻圈_点赞"] forState:UIControlStateNormal];
            
        }

    
    
    
        circleFooterView.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
        {
            [ActionSheetVC shareActionSheet].data = @[@"转发",@"取消"];
            [[ActionSheetVC shareActionSheet] showInVC:self];
            
            [ActionSheetVC shareActionSheet].block = ^(id  data,UIView * view,NSIndexPath * index)
            {
                NSLog(@"----%ld----",index.row);
                if (index.row == 0) {
                    
                    //分享应用
                    ShareContentModel * SCML = [[ShareContentModel alloc]init];
                    SCML.shareTitle = TPML.content_ls;
                    SCML.shareImg=SHARE_LOGO_IMAGE;
                    if(TPML.piclist.count>0)
                    {
                        NSString * url = [[TPML.piclist firstObject] objectForKey:@"fileurl"];;
                        SCML.shareImg = url;
                        
                    }
                    
                    SCML.shareContext = @" ";
                    SCML.shareUrl= TPML.postsgotourl;
                    SCML.type = 4;
                    SCML.shareSuperView = self.view;
                    SCML.shareType = SSDKContentTypeWebPage;
//                    SCML.shareType = SSDKContentTypeAuto;
                    [SharePresenter creatShareSDKcontent:SCML];

                }else
                {
                    
                }
                [[ActionSheetVC shareActionSheet] dismiss];

            };
            
        };
        
        
        return circleFooterView;
        
    }else
    {
        return [UICollectionReusableView new];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicImgCell * cell = (DynamicImgCell * )[collectionView cellForItemAtIndexPath:indexPath];

    [self tapPicture:indexPath tapView:cell.imgV];

}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    
    return 0.1;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{

    
    return 0.1;
}

#pragma mark - tableviewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyTopicCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyTopicCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UserTopicModel *model = myTopicArray[indexPath.section];
    
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:PLACEHOLDER_IMAGE];
    if (![XYString isBlankString:model.remarks]) {
        cell.contentLb.text = model.remarks;
    }
    if (![XYString isBlankString:model.title]) {
        cell.nameLb.text = model.title;
    }
    //审核状态 0 审核中 1 审核通过 2 未审核通过
    switch (model.state.intValue) {
        case 0:
        {
            cell.unreadLb.text = @"审核中";

        }
            break;
        case 1:
        {
            cell.unreadLb.text = [NSString stringWithFormat:@"%@ 帖",model.usercount];
            cell.unreadLb.layer.cornerRadius = 10;
            cell.unreadLb.layer.masksToBounds = YES;
            cell.unreadLb.backgroundColor = BLACKGROUND_COLOR;
        }
            break;
        case 2:
        {
            cell.unreadLb.text = @"未审核通过";

        }
            break;
        default:
            break;
    }
    
    return cell;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return myTopicArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 90;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTopicModel *model = myTopicArray[indexPath.section];
    if (model.state.intValue != 1) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    @WeakObj(self);
    UserTopicModel *model = myTopicArray[indexPath.section];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (model.state.intValue != 1) {
            [[MessageAlert shareMessageAlert] showInVC:selfWeak withTitle:@"确定删除此条圈子吗？" andCancelBtnTitle:@"取消" andOtherBtnTitle:@"确定"];
            [MessageAlert shareMessageAlert].block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
            {
                if (index==Ok_Type) {
                    NSLog(@"---点击删除");
                    [PostPresenter removeTopic:^(id  _Nullable data, ResultCode resultCode) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                            if (resultCode == SucceedCode) {
                                [myTopicArray removeObjectAtIndex:indexPath.section];
                                [selfWeak.table deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                                [selfWeak showToastMsg:@"删除成功！" Duration:2.5f];
                                [selfWeak.table reloadData];
                                
                            }
                            if (myTopicArray.count == 0) {
                                selfWeak.table.hidden = YES;
                                
                                [selfWeak showNothingnessViewWithType:NoContentTypeData Msg:@"您还没有创建圈子" SubMsg:@"" btnTitle:@"创建圈子" eventCallBack:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
                                    
                                    if (index == 1) {
                                        return ;
                                    }
                                    
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil];
                                    PublishTopicVC * ptVC = [storyboard instantiateViewControllerWithIdentifier:@"PublishTopicVC"];
                                    [selfWeak.navigationController pushViewController:ptVC animated:YES];
                                    
                                }];

                                [selfWeak.view sendSubviewToBack:selfWeak.nothingnessView];
                                
                            }
                            
                            
                        });
                        
                        
                    } withTopicID:model.theID];
                    
                }
            };
        }else {
            [selfWeak showToastMsg:@"您不能删除此条圈子" Duration:2.5f];
        }
        


    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserTopicModel *model = myTopicArray[indexPath.section];

    switch (model.state.intValue) {
        case 0:
        {
           ReviewDetailVC * rdVC = [[UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil]instantiateViewControllerWithIdentifier:@"ReviewDetailVC"];
            rdVC.topicID = model.theID;
            [self.navigationController pushViewController:rdVC animated:YES];
            
//            [self showToastMsg:@"审核中，耐心等待！" Duration:2.5f];
            
        }
            break;
        case 1:
        {
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
            WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
            
            AppDelegate *appDlgt=GetAppDelegates;
            if([model.topicgotourl hasSuffix:@".html"])
            {
                webVc.url=[NSString stringWithFormat:@"%@?token=%@",model.topicgotourl,appDlgt.userData.token];
            }
            else
            {
                webVc.url=[NSString stringWithFormat:@"%@&token=%@",model.topicgotourl,appDlgt.userData.token];
            }
            
            webVc.isShowRightBtn=YES;
            webVc.shareTypes=4;
            webVc.shareUr=model.topicgotourl;
            
            webVc.type= 1;
            webVc.topicid = model.theID;

            
            webVc.title = model.title;
            [self.navigationController pushViewController:webVc animated:YES];
            

        }
            break;
        case 2:
        {
            ReviewDetailVC * rdVC = [[UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil]instantiateViewControllerWithIdentifier:@"ReviewDetailVC"];
            rdVC.topicID = model.theID;
            [self.navigationController pushViewController:rdVC animated:YES];
        }
            break;
        default:
            break;
    }

}
#pragma mark - 点击图片放大查看
//-(void)tapPicture :(NSIndexPath *)index
//          tapView :(UIImageView *)tapView
//{
//    
//    TopicPostModel * TPML = [myTieziArray objectAtIndex:index.section];
//    NSInteger count = TPML.piclist.count;
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i<count; i++) {
//        
//        NSString *url;
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        url = [[TPML.piclist objectAtIndex:i] objectForKey:@"fileurl"];;
//        photo.url = [NSURL URLWithString:url];
//        photo.srcImageView = tapView; // 来源于哪个UIImageView
//        [photos addObject:photo];
//        
//    }
//    
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = index.row; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
//    
//    
//}
-(void)tapPicture :(NSIndexPath *)index
          tapView :(UIImageView *)tapView
{
    
    TopicPostModel * TPML = [myTieziArray objectAtIndex:index.section];
    NSInteger count = TPML.piclist.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        
        NSString *url;
        //        MJPhoto *photo = [[MJPhoto alloc] init];
        url = [[TPML.piclist objectAtIndex:i] objectForKey:@"fileurl"];;
        //        photo.url = [NSURL URLWithString:url];
        //        photo.srcImageView = tapView; // 来源于哪个UIImageView
        [photos addObject:url];
        
    }
    self.imageList = photos;
    //
    //    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    //    browser.currentPhotoIndex = index.row; // 弹出相册时显示的第一张图片是？
    //    browser.photos = photos; // 设置所有的图片
    //    [browser show];
    
    
    SDPhotoBrowser *browser = [SDPhotoBrowser sharedInstanceSDPhotoBrower];
    browser.sourceImagesContainerView = tapView;
    browser.imageCount = count;
    browser.currentImageIndex = index.row;
    browser.delegate = self;
    [browser show]; // 展示图片浏览器
    
}

// 返回临时占位图片（即原来的小图）
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
//    return PLACEHOLDER_IMAGE;
//}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    return [NSURL URLWithString:self.imageList[index]];
}
@end
