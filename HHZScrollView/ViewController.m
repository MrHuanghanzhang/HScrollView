//
//  ViewController.m
//  HHZScrollView
//
//  Created by 黄含章 on 15/7/27.
//  Copyright (c) 2015年 HHZ. All rights reserved.
//

#import "ViewController.h"
#import "HScrollView.h"

@interface ViewController ()<HScrollViewClickedDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSArray *picArray = [NSArray arrayWithObjects:@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg", nil];
    
    HScrollView *hscrollView = [[HScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) WithPictures:picArray];
    hscrollView.Hdelegate = self;
    [self.view addSubview:hscrollView];
    //这里把PageControl加在这里是因为在View里不好处理,暂时加在外面。
    [self.view addSubview:hscrollView.pageControl];
}

-(void)HScrollViewClickedAtPic:(NSUInteger)picIndex {
    NSLog(@"~点击了第%d个图片~",picIndex);
}


@end
