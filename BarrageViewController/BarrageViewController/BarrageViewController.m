//
//  BarrageViewController.m
//  BarrageViewController
//
//  Created by 晓琳 on 16/12/9.
//  Copyright © 2016年 xiaolin.han. All rights reserved.
//

#import "BarrageViewController.h"
#import "BarrageManager.h"
#import "BarrageView.h"
@interface BarrageViewController ()

@property (nonatomic, strong) BarrageManager *manager;

@end

@implementation BarrageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.manager = [[BarrageManager alloc] init];
    __weak typeof (self) mySelf = self;
    self.manager.generateViewBlock = ^(BarrageView *view){
        [mySelf addBarrageView:view];
    };
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(100, 100, 100, 30);
    [startBtn setTitle:@"开始" forState:0];
    [startBtn setBackgroundColor:[UIColor greenColor]];
    [startBtn addTarget:self action:@selector(startBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.frame = CGRectMake(240, 100, 100, 30);
    [stopBtn setTitle:@"停止" forState:0];
    [stopBtn setBackgroundColor:[UIColor redColor]];
    [stopBtn addTarget:self action:@selector(stopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
}
- (void)startBtnAction:(UIButton *)btn{
    [self.manager barrageStart];
}

- (void) stopBtnAction:(UIButton *)btn{
    [self.manager barrageStop];
    
}

- (void)addBarrageView:(BarrageView *)view{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 200+view.trajectory * 70, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    NSLog(@"fram ===== %@", NSStringFromCGRect(view.frame));
    [view startAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
