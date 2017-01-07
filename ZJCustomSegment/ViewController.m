//
//  ViewController.m
//  ZJCustomSegment
//
//  Created by pg on 2017/1/7.
//  Copyright © 2017年 DZHFCompany. All rights reserved.
//

#import "ViewController.h"
#import "ZJSegmentControl.h"
#import "iCarousel.h"

#define KRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface ViewController ()<iCarouselDelegate,iCarouselDataSource>

@property (strong,nonatomic)ZJSegmentControl *zjControl;

@property (strong,nonatomic)iCarousel *myCarousel;

@property (nonatomic,strong)NSArray *titlesArr;

@property (nonatomic,strong)NSArray *colorsArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titlesArr = @[@"直播",@"推荐",@"视频",@"精彩秀",@"图片",@"段子",@"社会新闻"];
    _colorsArr = @[KRGB(23, 200,0),KRGB(120, 0, 3),KRGB(0, 79, 100),KRGB(10, 200, 20),KRGB(100, 0, 200),KRGB(100, 18, 80),KRGB(200, 49, 1)];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.view.frame.size.height;
    _zjControl = [[ZJSegmentControl alloc]initWithFrame:CGRectMake(0, 64, width, 40) titles:_titlesArr action:^(NSInteger clickTag){
        [_myCarousel scrollToItemAtIndex:clickTag animated:YES];
    }];
    _zjControl.isShowLineLabel = NO;
    _zjControl.titleSelColor = [UIColor magentaColor];
    [self.view addSubview:_zjControl];
    
    _myCarousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 104, width, height-64-40)];
    _myCarousel.dataSource = self;
    _myCarousel.delegate = self;
    _myCarousel.backgroundColor = [UIColor whiteColor];
    _myCarousel.type = iCarouselTypeCoverFlow;
    _myCarousel.decelerationRate = 0.75;
    _myCarousel.pagingEnabled = YES;

    [self.view addSubview:_myCarousel];

}


#pragma mark -icarouse的代理方法
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _titlesArr.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    UIView *backView;
    if (backView == nil) {
        backView = [[UIView alloc]initWithFrame:carousel.bounds];
        backView.backgroundColor = _colorsArr[index];
        
        UILabel *bottomLabel = [[UILabel alloc]init];
        bottomLabel.center = backView.center;
        bottomLabel.bounds = backView.bounds;
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.text = [NSString stringWithFormat:@"%zd",index+1];
        bottomLabel.font = [UIFont systemFontOfSize:80];
        bottomLabel.textColor = [UIColor whiteColor];
        [backView addSubview:bottomLabel];
    }
    return backView;
    
}

//滑动carousel
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{

    NSLog(@"开始滑动了===%zd",carousel.currentItemIndex);
    [_zjControl setSegmentMoveToIndex:carousel.currentItemIndex];
}

@end
