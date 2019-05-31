//
//  AllCircleListVC.m
//  TimeHomeApp
//
//  Created by 优思科技 on 16/7/22.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AllCircleListVC.h"
#import "QuanZiCell.h"
#import "PostPresenter.h"
#import "RecommendTopicModel.h"

#import "WebViewVC.h"

@interface AllCircleListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray * allList;
    int  currentPage;

}
@property (nonatomic,copy)NSString * searchStr;

@end

@implementation AllCircleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchStr = @"";
    
    allList = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.navigationItem.title = @"全部圈子";
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(10,0, SCREEN_WIDTH-20, SCREEN_HEIGHT-6) style:UITableViewStylePlain];
    self.table.backgroundColor = BLACKGROUND_COLOR;
    
    self.table.delegate =self;
    self.table.dataSource =self;
    [self.view addSubview:self.table];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.table registerNib:[UINib nibWithNibName:@"QuanZiCell" bundle:nil] forCellReuseIdentifier:@"QuanZiCell"];
    

    @WeakObj(self);
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadOne:selfWeak.searchStr];
    }];
    /**
     加载
     */
    self.table.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [selfWeak loadMore:selfWeak.searchStr];
    }];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.table.mj_header beginRefreshing];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadOne:(NSString *)name
{
    @WeakObj(self);
    NSLog(@"----%@",name);
    currentPage = 1;
    [PostPresenter getAllTopic:name withPage:[NSString stringWithFormat:@"%d",currentPage] withBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak.table.mj_header endRefreshing];

            if (resultCode == SucceedCode)
            {
                [allList removeAllObjects];
                allList = [data mutableCopy];
                [selfWeak.table reloadData];
            }else
            {
                [allList removeAllObjects];
            }
        });
        
        
    }];
}
-(void)loadMore:(NSString *)name
{
    @WeakObj(self);
    currentPage ++;
    [PostPresenter getAllTopic:name withPage:[NSString stringWithFormat:@"%d",currentPage] withBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak.table.mj_footer endRefreshing];

            if (resultCode == SucceedCode)
            {
                [allList addObjectsFromArray:data];
                [selfWeak.table reloadData];
            }else
            {
                currentPage--;
            }
        });
        
    }];
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendTopicModel * RTML = [allList objectAtIndex:indexPath.row];
    
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    AppDelegate *appDlgt=GetAppDelegates;
    if([RTML.topicgotourl hasSuffix:@".html"])
    {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@",RTML.topicgotourl,appDlgt.userData.token];
    }
    else
    {
        webVc.url=[NSString stringWithFormat:@"%@&token=%@",RTML.topicgotourl,appDlgt.userData.token];
    }
    //        webVc.url   = RTML.topicgotourl;
    
    webVc.type= 1;
    webVc.topicid = RTML.recommendTopicID;
    
    webVc.shareUr=RTML.topicgotourl;
    webVc.title = RTML.title;
    webVc.isShowRightBtn=YES;
    webVc.shareTypes=4;
    [self.navigationController pushViewController:webVc animated:YES];

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuanZiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QuanZiCell"];
    RecommendTopicModel * RTML = [allList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.titleLb.text = RTML.title;
    cell.contentLb.text = RTML.remarks;
    cell.numberLb.text = RTML.ctrcount;

    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:RTML.picurl] placeholderImage:PLACEHOLDER_IMAGE];
    if (RTML.isfollow.boolValue) {
        [cell.guanzhuBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_已注"] forState:UIControlStateNormal];
        [cell.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal] ;
    }else
    {
        [cell.guanzhuBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_注"] forState:UIControlStateNormal];
        [cell.guanzhuBtn setTitle:@"加关注" forState:UIControlStateNormal] ;

    }
    
    @WeakObj(self);
    cell.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
        

        if (!RTML.isfollow.boolValue) {
            
            NSLog(@"点击关注或取消关注");
            [PostPresenter addFollowTopic:RTML.recommendTopicID WithCallBack:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    if (resultCode == SucceedCode) {
                        RTML.isfollow = @"1";
                        [selfWeak.table reloadData];
                    }
                });
                
            }];
        }else
        {
            [PostPresenter removeFollowTopic:RTML.recommendTopicID WithCallBack:^(id  _Nullable data, ResultCode resultCode) {
                
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //[indicator stopAnimating];
                    
                    if (resultCode == SucceedCode) {
                        
                        RTML.isfollow = @"0";
                        [selfWeak.table reloadData];
                        
                    }
                });
            }];
            
        }
        
    };
    

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allList.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    lb.placeholder = @"输入关键字查找您喜欢的内容";
    lb.returnKeyType = UIReturnKeySearch;
    lb.delegate = self;
    lb.text = _searchStr;
    lb.font = [UIFont systemFontOfSize:12.0f];
    lb.textColor = UIColorFromRGB(0x8e8e8e);
    [backV addSubview:lb];
    [backV addSubview:imgLine];
    [backV addSubview:imgV];
    
    return v_0;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _searchStr = textField.text;
    
    [textField resignFirstResponder];
    [self.table.mj_header beginRefreshing];
    
    return YES;
    
}
@end
