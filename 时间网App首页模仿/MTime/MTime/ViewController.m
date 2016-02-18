//
//  ViewController.m
//  MTime
//
//  Created by YangJingchao on 16/2/18.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import "ViewController.h"
#import "HOPageView.h"
#import "HOPageScrollView.h"
//#import "AFNetworking.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "JSONSerialization.h"
#import "NSString+MyString.h"
#import "ImageEffects.h"
#import "MovieModel.h"


#define URL @"http://api.meituan.com/show/v2/movies/shows.json?__skck=c8a86f38931f8d49dbaadc416db7b31e&__skcy=mfaxvpZRj4XLY8K%2FJ49M1DSi5Ls%3D&__skno=B7F7F5F6-228E-4636-9C84-DB34F8E4E10D&__skts=1444235555.176736&__skua=2d647e3cf6ce107ccbeb879dbd9e03ac&__vhost=api.maoyan.com&channelId=1&ci=280&cinema_id=302&client=iphone&clientType=ios&lat=23.11434260232458&lng=112.4944093384744&movieBundleVersion=100&msid=2279D427-23E4-4FBC-AB3C-6DA6FD2100BF2015-10-08-00-00756&net=255&utm_campaign=AmovieBmovie&utm_content=EEF74BE4130356D97AC0077A1ACAC1AE5DA3FBC7A995BBE22E774192EE727F8E&utm_medium=iphone&utm_source=AppStore&utm_term=6.0&uuid=EEF74BE4130356D97AC0077A1ACAC1AE5DA3FBC7A995BBE22E774192EE727F8E&version_name=6.0"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<HOPageScrollViewDataSource,UIScrollViewDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_AllArray;
}
@property(nonatomic,strong)HOPageView *pageView;
@property(nonatomic,assign)int myIndex;
//曲线
@property(nonatomic, strong) UIView *dotOne;    //这是个小点,向下滑动时改变其Point,从而绘制贝塞尔曲线
@property(nonatomic, assign) CGFloat dotOneX;   //dotOne的x坐标,当滑动时会改变
@property(nonatomic, assign) CGFloat dotOneY;   //dotOne的y坐标,当滑动时会改变
@property(nonatomic, strong) CAShapeLayer *dotOneShapeLayer;//这是滑动时出现的那个曲面

//文字按钮
@property(nonatomic, strong)UILabel *labelNm;
@property(nonatomic, strong)UIButton *btnBuy;
@property(nonatomic, strong)UILabel *labelDesc;
@property(nonatomic,strong)UILabel *labelHeadBG;
@property(nonatomic,strong)UILabel *labelLine;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _pageView = [[HOPageView alloc] initWithFrame:CGRectMake(0, 60, [[UIScreen mainScreen] bounds].size.width, 360) delegate:self];
    _pageView.padding = 10;
    _pageView.scale = .8;
    _pageView.cellSize = CGSizeMake(140, 200);
    [self.view addSubview:_pageView];

    _AllArray = [[NSMutableArray alloc]init];
    NSDictionary *jsonDic = [@"maoyan" objectFromJsonResource];
    NSArray *imgArray = jsonDic[@"data"][@"movies"];
    for (NSDictionary *dic in imgArray) {
        MovieModel *mm = [[MovieModel alloc]initWithDictionary:dic];
        [_AllArray addObject:mm];
    }
    [_pageView reloadData];
    
    
    //画贝塞尔曲线
    [self initShapeLayer];
    [self startDraw];
    
    _labelHeadBG =[[UILabel alloc]initWithFrame:CGRectMake(0,_dotOneShapeLayer.frame.origin.y, WIDTH, 100)];
    _labelHeadBG.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_labelHeadBG];
    
    //文字按钮信息
    _btnBuy  = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2 -50, _dotOneShapeLayer.frame.origin.y-35-15, 100, 30)];
    _btnBuy.backgroundColor = [UIColor orangeColor];
//    [_btnBuy setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
    [_btnBuy.titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
    [_btnBuy.layer setCornerRadius:15];
    [_btnBuy setTitle:@"选座购票" forState:UIControlStateNormal];
    [self.view addSubview:_btnBuy];
    
    _labelNm =[[UILabel alloc]initWithFrame:CGRectMake(0, _btnBuy.frame.origin.y - 25, WIDTH, 20)];
    _labelNm.textAlignment = NSTextAlignmentCenter;
    _labelNm.textColor = [UIColor whiteColor];
    [_labelNm setFont:[UIFont fontWithName:@"Avenir-Medium" size:20]];
    [self.view addSubview:_labelNm];
    
    _labelDesc =[[UILabel alloc]initWithFrame:CGRectMake(0, _btnBuy.frame.origin.y +_btnBuy.frame.size.height + 5, WIDTH, 30)];
    _labelDesc.textAlignment = NSTextAlignmentCenter;
    _labelDesc.textColor = [UIColor orangeColor];
    [_labelDesc setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
    [self.view addSubview:_labelDesc];
    
    

    
    _labelLine =[[UILabel alloc]initWithFrame:CGRectMake(10,_labelHeadBG.frame.origin.y +20, WIDTH-20, 1)];
    _labelLine.backgroundColor = [UIColor whiteColor];
    _labelLine.backgroundColor =[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    [self.view addSubview:_labelLine];
    
    //默认进来第一个
    MovieModel *mm =_AllArray[0];
    _labelNm.text = mm.nm;
    _labelDesc.text = mm.scm;
    
}


- (NSInteger)numberOfPageInPageScrollView:(HOPageScrollView*)pageScrollView{
    return 6;
}

- (UIView *)pageScrollView:(HOPageScrollView*)pageScrollView viewForRowAtIndex:(int)index{
    _myIndex = index;
    [pageScrollView returnIndex:^(NSInteger index) {
        MovieModel *mm =_AllArray[index];
        _labelNm.text = mm.nm;
        _labelDesc.text = mm.scm;
    }];
    
    //图片
    UIImageView *cell = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 120)];
    cell.tag = 10 + index;
    
    __weak UIImageView *weakCell = cell;
    NSString *imgUrl;
    MovieModel *mm =_AllArray[index];
    if(index<[_AllArray count]){
        imgUrl = [mm.img getNewUrl];
        
    }
    
    if (index == 0) {
        [cell sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            HOPageView *pageView = (HOPageView *)pageScrollView.superview;
            pageView.bgImageLayer.contents = (id)[image blurredImageWithSize:weakCell.frame.size].CGImage;
        }];
    }
    else{
        [cell sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        
    }
    

    
    return cell;
}


- (void)pageScrollView:(HOPageScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index{
    NSLog(@"click cell at %ld",index);
}



//画贝塞尔曲线

#pragma mark -初始化shapeLayer并将其颜色设置为灰色
-(void)initShapeLayer
{
    _dotOneShapeLayer = [CAShapeLayer layer];
    _dotOneShapeLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:_dotOneShapeLayer];
}


-(void)startDraw{
    CGPoint point = CGPointMake(0, -100);//y值大于零 向下弯曲  反之。
    
    // 这部分代码使dotOne跟着手势走
    CGFloat dotOneHeight = point.y * 0.7;
    _dotOneX = WIDTH / 2.0 + point.x;
    _dotOneY = dotOneHeight ;
    _dotOne.frame = CGRectMake(_dotOneX,_dotOneY,_dotOne.frame.size.width,_dotOne.frame.size.height);
    [self updateShapeLayerPath];//当小点point改变,各自的shaplayer也会跟着变
}

- (void)updateShapeLayerPath
{
    // 更新_shapeLayer形状,贝塞尔曲线其实就是根据一天直线和一个点描绘出一条曲线,以向下滑动为例,首先确定一条直线,这条直线就是从(0,0)到(WIDTH,0)这个线,然后就可以根据dotOne的point去描绘这条曲线了
    UIBezierPath *dotOnePath = [UIBezierPath bezierPath];
    [dotOnePath moveToPoint:CGPointMake(0, 0)];
    [dotOnePath addLineToPoint:CGPointMake(WIDTH, 0)];
    [dotOnePath addQuadCurveToPoint:CGPointMake(0, 0)
                       controlPoint:CGPointMake(_dotOneX, _dotOneY)];
    [dotOnePath closePath];
    _dotOneShapeLayer.path = dotOnePath.CGPath;
    [_dotOneShapeLayer setPosition:CGPointMake(0, 360+60)];
    

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
