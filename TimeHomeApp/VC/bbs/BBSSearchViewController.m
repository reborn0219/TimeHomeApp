//
//  BBSSearchViewController.m
//  TimeHomeApp
//
//  Created by UIOS on 2016/10/26.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BBSSearchViewController.h"
#import "SKTagView.h"
#import "Masonry.h"
#import "UIColor+LXAddition.h"
#import "BBSModel.h"

#import "BBSMainPresenters.h"

#import "UserDefaultsStorage.h"

#import "WebViewVC.h"

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

#import "L_ShareActivityTVC.h"

#import "CommunityListViewController.h"

@interface BBSSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    AppDelegate *appDlgt;
    
    NSMutableArray *dataArray;//搜索结果数据源
    
    NSMutableArray *tagArr;//标签数组
    
    NSMutableArray *historyArr;//搜索历史数组
    
    UIScrollView *scroll_;
    
    UIButton *clearBt;
    
    UITextField *searchView;
    
    UIView *history;
    
    UILabel *timeLal;
    
    UIView *tagBack;
    
    //UIButton *clearBt;
    
    NSString *title_;
    
    UITableView *tableView_;
    
    NSInteger pageNo;
    
    NSString *search_;
    
}

@property (strong, nonatomic) SKTagView *tagView;

@end

@implementation BBSSearchViewController

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

#pragma mark - network method

-(void)getTag{
    [BBSMainPresenters gettagList:@"1" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                [tagArr removeAllObjects];
                NSArray *arr = (NSArray *)data;
                for (int i = 0; i < arr.count; i++) {
                    
                    [tagArr addObject:arr[i][@"name"]];
                }
                [self addInfo];
                
            }else
            {
                [self showToastMsg:data Duration:5.0];
            }
        });
    }];
}

-(void)getListData:(NSString *)tagsname{
    
    int i;
    int j = 99;
    for (i = 0; i < historyArr.count; i++) {
        
        NSString *str = historyArr[i];
        if ([title_ isEqualToString:str]) {
            j = i;
        }
    }
    if (j == 99) {
        
        if (historyArr.count >= 5) {
            
            [historyArr removeObjectAtIndex:historyArr.count - 1];
        }
        [historyArr insertObject:title_ atIndex:0];
        
        [UserDefaultsStorage saveData:historyArr forKey:@"searchTAG"];
    }else{
        
        [historyArr removeObjectAtIndex:j];
        [historyArr insertObject:title_ atIndex:0];
        [UserDefaultsStorage saveData:historyArr forKey:@"searchTAG"];
        
    }
    [history removeFromSuperview];
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld",pageNo];
    
    [BBSMainPresenters getPostList:@"0" userid:@"" sortkey:@"new" contype:@"0" posttype:@"-1" poststate:@"-999" iscollect:@"0" isuserfollow:@"-1" tagsname:title_ pagesize:@"20" page:pageStr communityid:@"" updataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode==SucceedCode)
            {
                [tableView_.mj_footer endRefreshing];
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
                [tableView_.mj_footer endRefreshing];
                if (pageNo != 1) {
                    
                    pageNo --;
                }
            }
            if (dataArray.count > 0) {
                
                [self hiddenNothingnessView];
            }else{
                
                [self showNothingnessViewWithType:NoContentTypeData Msg:@"没有找到您搜索的内容" eventCallBack:nil];
                [self.view sendSubviewToBack:self.nothingnessView];
            }
        });
    }];
}

#pragma mark - extend method

-(void)getTitle:(NSString *)title
         search:(NSString *)search{
    
    title_ = title;
    
    search_ = search;
}

-(void)configUI{
    
    self.title = @"搜索";
    
    UIView *searchBack = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 2 * 10, 35)];
    searchBack.backgroundColor = [UIColor clearColor];
    [searchBack.layer setBorderWidth:1];
    [searchBack.layer setBorderColor:CGColorRetain(TEXT_COLOR.CGColor)];
    
    [self.view addSubview:searchBack];

    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    searchImg.contentMode = UIViewContentModeCenter;
    searchImg.image = [UIImage imageNamed:@"搜索"];
    
    searchView = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 2 * 10 - 50, 35)];

    searchView.clearButtonMode = UITextFieldViewModeWhileEditing;//当写入内容的时候显示清除按钮
    searchView.backgroundColor = [UIColor clearColor];
//    UIColorFromRGB(0xdddddf);
//    searchView.layer.cornerRadius = searchView.frame.size.height / 2;
//    searchView.layer.masksToBounds = YES;
    
    searchView.returnKeyType = UIReturnKeySearch;
    searchView.leftView = searchImg;
    searchView.placeholder = @"输入关键词";
    
    if (title_.length > 0) {
        searchView.text = title_;
    }
    searchView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchView.textAlignment = NSTextAlignmentLeft;
    
    searchView.leftViewMode = UITextFieldViewModeAlways;
    searchView.delegate = self;

    searchView.textColor = TITLE_TEXT_COLOR;
    [searchView setFont:[UIFont systemFontOfSize:13]];
    searchView.userInteractionEnabled = YES;
    [self.view addSubview:searchView];
    
    UIButton *searchBt = [[UIButton alloc]initWithFrame:CGRectMake(searchBack.frame.size.width - 50, 0, 50, searchView.frame.size.height)];
    [searchBt setTitle:@"搜索" forState:UIControlStateNormal];
    searchBt.backgroundColor = [UIColor clearColor];
    searchBt.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchBt setTitleColor:NEW_RED_COLOR forState:UIControlStateNormal];
    [searchBt addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    
    [searchBack addSubview:searchBt];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(searchBt.frame.origin.x, 10, 1, searchView.frame.size.height - 20)];
    line.backgroundColor = TEXT_COLOR;
    
    [searchBack addSubview:line];
    
    [self addInfo];
    
    clearBt = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - self.navigationController.navigationBar.frame.size.height - 20 - 20 - 20, SCREEN_WIDTH, 20)];
    [clearBt setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    [clearBt setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    clearBt.titleLabel.font = [UIFont systemFontOfSize:13];
    [clearBt addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBt];
    
    tableView_ = [[UITableView alloc]initWithFrame:CGRectMake(10, searchView.frame.origin.y + searchView.frame.size.height + 5, SCREEN_WIDTH - 2 * 10, SCREEN_HEIGHT - (searchView.frame.origin.y + searchView.frame.size.height + 5)) style:UITableViewStylePlain];
    tableView_.backgroundColor = [UIColor clearColor];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_.hidden = YES;
    tableView_.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView_];
    
    if (title_.length > 0) {
        
        [self search:nil];
    }
}

-(void)addInfo{
    
    [scroll_ removeFromSuperview];
    
    scroll_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0, searchView.frame.origin.y + searchView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT- self.navigationController.navigationBar.frame.size.height - 20 - 20 - 20 - 5 - (searchView.frame.origin.y + searchView.frame.size.height))];
    scroll_.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroll_];
    
    if ([search_ isEqualToString:@"1"]) {
        
        scroll_.hidden = YES;
        clearBt.hidden = YES;
        [self hiddenNothingnessView];
    }
    
    UIImageView *hotImage = [[UIImageView alloc]initWithFrame:CGRectMake(searchView.frame.origin.x + (35 - 18) / 2, 25, 100 / 13, 10)];
    hotImage.image = [UIImage imageNamed:@"邻趣-搜索-热门推荐图标"];
    
    [scroll_ addSubview:hotImage];
    
    UILabel *hotLal = [[UILabel alloc]initWithFrame:CGRectMake(hotImage.frame.origin.x + hotImage.frame.size.width + 5, hotImage.frame.origin.y, SCREEN_WIDTH - 2 * 10 - hotImage.frame.size.width, hotImage.frame.size.height)];
    hotLal.text = @"平安精选";
    hotLal.textColor = TEXT_COLOR;
    hotLal.font = [UIFont systemFontOfSize:10];
    hotLal.textAlignment = NSTextAlignmentLeft;
    [scroll_ addSubview:hotLal];
    
    tagBack = [[UIView alloc]initWithFrame:CGRectMake( 0, hotLal.frame.origin.y + hotLal.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tagBack.backgroundColor = [UIColor clearColor];
    
    [scroll_ addSubview:tagBack];
    
    [self setupTagView];
    [self.view layoutIfNeeded];
    
    float tagHeight = [self.tagView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height + 1;
    NSLog(@"===========%f",tagHeight);
    
    tagBack.frame = CGRectMake(tagBack.frame.origin.x, tagBack.frame.origin.y, tagBack.frame.size.width, tagHeight);
    
    UIImageView *timeImage = [[UIImageView alloc]initWithFrame:CGRectMake(hotImage.frame.origin.x, tagBack.frame.origin.y + tagBack.frame.size.height + 20, 10, 10)];
    timeImage.image = [UIImage imageNamed:@"邻趣-搜索-搜索历史图标"];
    [scroll_ addSubview:timeImage];
    
    timeLal = [[UILabel alloc]initWithFrame:CGRectMake(timeImage.frame.origin.x + timeImage.frame.size.width + 2, timeImage.frame.origin.y, SCREEN_WIDTH - 2 * 10 - timeImage.frame.size.width, timeImage.frame.size.height)];
    timeLal.text = @"搜索历史";
    timeLal.textColor = TEXT_COLOR;
    timeLal.font = [UIFont systemFontOfSize:10];
    timeLal.textAlignment = NSTextAlignmentLeft;
    [scroll_ addSubview:timeLal];
    
    [self setHistory];
    
    scroll_.contentSize = CGSizeMake(SCREEN_WIDTH, timeLal.frame.origin.y + timeLal.frame.size.height + 15 + 5 * 35);
}

#pragma mark - textfield method

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    tableView_.hidden = YES;
    scroll_.hidden = NO;
    clearBt.hidden = NO;
    [self hiddenNothingnessView];
    [self setHistory];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length > 0) {
        
        title_ = textField.text;
        [self search:nil];
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    long a = textField.text.length;
    long b = range.location;
    if (a == 1 && b == 0) {
        tableView_.hidden = YES;
        [self hiddenNothingnessView];
        scroll_.hidden = NO;
        clearBt.hidden = NO;
        [self setHistory];
    }
    return YES;
}

#pragma mark - Private

-(void)setHistory{
    
    if (history) {
        
        [history removeFromSuperview];
    }
    
    history = [[UIView alloc]initWithFrame:CGRectMake(0, timeLal.frame.origin.y + timeLal.frame.size.height + 10, SCREEN_WIDTH, 35 * 5)];
    history.backgroundColor = [UIColor clearColor];
    [scroll_ addSubview:history];
    
    for (int i = 0; i < historyArr.count; i++) {
        
        UIView *historyBack = [[UIView alloc]initWithFrame:CGRectMake(0, i * 35, SCREEN_WIDTH, 35)];
        historyBack.tag = (i + 1) * 10;

        [history addSubview:historyBack];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(history:)];
        [historyBack addGestureRecognizer:tap];
        
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake( timeLal.frame.origin.x, 0, SCREEN_WIDTH - timeLal.frame.origin.x - 40, historyBack.frame.size.height)];
        name.text = [NSString stringWithFormat:@"%@",historyArr[i]];
        name.textColor = TITLE_TEXT_COLOR;
        name.font = [UIFont systemFontOfSize:13];
        [historyBack addSubview:name];
        
        UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 30, (historyBack.frame.size.height - 30) / 2, 30, 30)];
        [close setImage:[UIImage imageNamed:@"邻趣-搜索关闭图标"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [historyBack addSubview:close];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(name.frame.origin.x, historyBack.frame.size.height - 1, close.frame.origin.x + close.frame.size.width - name.frame.origin.x, 1)];
        line.backgroundColor = LINE_COLOR;
        [historyBack addSubview:line];
    }
}

- (void)setupTagView {
    
    self.tagView = ({
        SKTagView *view = [SKTagView new];
        view.backgroundColor = [UIColor clearColor];
        view.padding = UIEdgeInsetsMake(15, 15, 15, 15);
        view.interitemSpacing = 12;
        view.lineSpacing = 10;
        //__weak SKTagView *weakView = view;
        view.didTapTagAtIndex = ^(NSUInteger index){
            //[weakView removeTagAtIndex:index];
            
            NSString *searchText = [NSString stringWithFormat:@"%@",tagArr[index]];
            searchView.text = searchText;
            title_ = searchText;
            
            [self search:nil];
        };
        view;
    });
    [tagBack addSubview:self.tagView];
    
    [self.tagView mas_makeConstraints: ^(MASConstraintMaker *make) {
        UIView *superView = tagBack;
        make.top.equalTo(superView.mas_top).with.offset(0);
        make.leading.equalTo(superView.mas_leading).with.offset(15);
        make.trailing.equalTo(superView.mas_trailing).with.offset(-15);
    }];
    
    
    //NSLog(@"%f",[self.view systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height + 1);
    
    //Add Tags

    [tagArr enumerateObjectsUsingBlock: ^(NSString *text, NSUInteger idx, BOOL *stop) {
        SKTag *tag = [SKTag tagWithText: text];
        tag.textColor = TITLE_TEXT_COLOR;
        tag.fontSize = 12;
        tag.enable = YES;
        //tag.font = [UIFont fontWithName:@"Courier" size:15];
        tag.padding = UIEdgeInsetsMake(3, 20, 3, 20);
        tag.bgColor = [UIColor whiteColor];
        //[UIColor colorWithHexString: self.colors[idx % self.colors.count]];
        
        tag.cornerRadius = 10;
        [self.tagView addTag:tag];
    }];
    
    NSLog(@"%f" ,self.tagView.frame.size.height);
}

#pragma mark - button tap method

-(void)close:(id)sender{
    
    long closeTag = [sender superview].tag / 10 - 1;
    
    [historyArr removeObjectAtIndex:closeTag];
    [UserDefaultsStorage saveData:historyArr forKey:@"searchTAG"];
    [history removeFromSuperview];
    [self setHistory];
}

-(void)clear:(id)sender{
    
    [historyArr  removeAllObjects];
    [UserDefaultsStorage saveData:historyArr forKey:@"searchTAG"];
    [history removeFromSuperview];
}

-(void)search:(id)sender{
    
    NSLog(@"--------search--------");
    
    title_ = searchView.text;
    pageNo = 1;
    if (title_.length > 0) {
        
        scroll_.hidden = YES;
        clearBt.hidden = YES;
        [self.view endEditing:YES];
        [self hiddenNothingnessView];
        tableView_.hidden = NO;
        [self getListData:title_];
    }else{
     
        [self showToastMsg:@"请输入关键词" Duration:5.0];
    }
}

-(void)history:(id)sender{
    
    long historyNo = [sender view].tag / 10 - 1;
    NSString *historyStr = historyArr[historyNo];
    searchView.text = historyStr;
    title_ = historyStr;
    
    scroll_.hidden = YES;
    clearBt.hidden = YES;
    [self hiddenNothingnessView];
    [self.view endEditing:YES];
    tableView_.hidden = NO;
    [self getListData:title_];
}

#pragma mark - life cycle method

-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"===========%f",[self.tagView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height + 1);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDlgt = GetAppDelegates;
    
    pageNo = 1;
    
    [self getTag];

    tagArr = [NSMutableArray array];

    historyArr  = [NSMutableArray array];
    
    [historyArr addObjectsFromArray:[UserDefaultsStorage getDataforKey:@"searchTAG"]];
    
    self.tabBarController.tabBar.hidden = YES;

    dataArray = [NSMutableArray array];
    
    [self configUI];
    
    @WeakObj(self);
    tableView_.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        pageNo = pageNo + 1;
        [selfWeak getListData:nil];
    }];
    
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
    
    [tableView_ registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [tableView_ registerNib:[UINib nibWithNibName:@"L_ShareActivityTVC" bundle:nil] forCellReuseIdentifier:@"L_ShareActivityTVC"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ([model.posttype isEqualToString:@"0"]) {///////////////////普通帖
        
        if (model.piclist.count >= 3) {//3图普通帖
            
            BBSNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSNormalTableViewCell"];

            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model];
                
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
            
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model];
                
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

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model];
                
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

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model];
                
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

                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model];
                    
                };
                
                return cell;
            }else if (model.itemlist.count == 2){//2图投票贴
                
                BBSVotePIC2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVotePIC2TableViewCell"];

                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model];
                    
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
                
                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model];
                    
                };
                
                return cell;
            }else if(model.itemlist.count == 2){
                
                BBSVoteText2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSVoteText2TableViewCell"];

                cell.model = model;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                    
                    [selfWeak gotoCommunityWebviewWithModel:model];
                    
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

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model];
                
            };
            
            return cell;
            
        }else if (model.piclist.count == 2){//2图问答贴
            
            BBSQuestionPIC2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPIC2TableViewCell"];

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model];
                
            };
            
            return cell;
            
        }else if (model.piclist.count == 1){//1图问答贴
            
            BBSQuestionPIC1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionPIC1TableViewCell"];

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model];
                
            };
            return cell;
            
        }else if (model.piclist.count == 0){//文字问答贴
            
            BBSQuestionNoPICTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSQuestionNoPICTableViewCell"];

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model];
                
            };
            
            return cell;
        }
    }else if ([model.posttype isEqualToString:@"4"]) {///////////////////////房产贴
        if (model.piclist.count >= 3) {//3图房产贴
            
            BBSHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSHouseTableViewCell"];

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model];
                
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

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model];
                
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

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model];
                
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

            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cityButtonDidClickBlock = ^(NSInteger cityIndex){
                
                [selfWeak gotoCommunityWebviewWithModel:model];
                
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
- (void)gotoCommunityWebviewWithModel:(BBSModel *)model{
    

    personListViewController *personList = [[personListViewController alloc]init];
    [personList getuserID:model.userid];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personList animated:YES];
    
}

/**
 进入社区帖子,进入个人中心 listtype==2为社区帖子
 */
- (void)gotoCommunityWebviewWithModel:(BBSModel *)model withListType:(NSInteger)listtype {
    
    //    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    //    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    
    if (listtype == 2) {
        
        CommunityListViewController *CommunityList = [[CommunityListViewController alloc]init];
        [CommunityList getCommunityID:model.communityid communityName:model.communityname];
        CommunityList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:CommunityList animated:YES];
        
    }else {
        
        personListViewController *personList = [[personListViewController alloc]init];
        [personList getuserID:model.userid];
        personList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personList animated:YES];
        
    }
}

@end
