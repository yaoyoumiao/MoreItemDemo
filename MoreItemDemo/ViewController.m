//
//  ViewController.m
//  MoreItemDemo
//
//  Created by yaoyoumiao on 16/8/25.
//  Copyright © 2016年 ZTE. All rights reserved.
//

#import "ViewController.h"
#import "FirstMoreView.h"

@interface ViewController ()

@property (nonatomic, strong) FirstMoreView *firstMoreView;
@property (nonatomic, assign) BOOL isShowing;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self _setClearColor];
    
    if(_firstMoreView) {
        [_firstMoreView removeFromSuperview];
        _firstMoreView = nil;
        _isShowing = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"IMG_5817.PNG"];
    [self.view addSubview:imageView];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0, 0, 64, 64)];
    [addBtn addTarget:self action:@selector(handleFirstMoreView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    _isShowing = NO;
}

- (FirstMoreView *)firstMoreView
{
    if(!_firstMoreView) {
        _firstMoreView = [[FirstMoreView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        __weak typeof(self) _weakself = self;
        _firstMoreView.dismissBlock = ^(){
            [_weakself handleFirstMoreView];
        };
        _firstMoreView.selectedItemBlock = ^(NSInteger index, NSString *itemString){
            NSLog(@"index = %ld, itemString = %@",index, itemString);
        };
    }
    return _firstMoreView;
}


- (void)handleFirstMoreView
{
    if(!_isShowing) {
        [self.view addSubview:self.firstMoreView];
        _isShowing = YES;
    } else {
        [self.firstMoreView dismissMoreView];
        _firstMoreView = nil;
        _isShowing = NO;
    }
}

- (void)_setClearColor
{
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
}

#pragma mark - 绘制图片
- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
