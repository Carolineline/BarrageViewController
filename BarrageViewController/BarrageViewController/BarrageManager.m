//
//  BarrageManager.m
//  BarrageViewController
//
//  Created by 晓琳 on 16/12/9.
//  Copyright © 2016年 xiaolin.han. All rights reserved.
//

#import "BarrageManager.h"
#import "BarrageView.h"


@interface BarrageManager ()
//弹幕的数据来源
@property (nonatomic, strong) NSMutableArray *dataSource;
//弹幕使用过程中的数组变量
@property (nonatomic, strong) NSMutableArray *barrageComments;
//存储弹幕view的数组变量
@property (nonatomic, strong) NSMutableArray *barrageViews;

@property (nonatomic, assign) BOOL barrageStoping;
@end

@implementation BarrageManager

- (instancetype)init{
    if (self = [super init]) {
        self.barrageStoping = YES;
    }
    return self;
}
- (void)barrageStart{
    if (!self.barrageStoping) {
        return;
    }
    self.barrageStoping = NO;
    [self.barrageComments removeAllObjects];
    [self.barrageComments addObjectsFromArray:self.dataSource];
    
    [self initBarrageComment];
}

//初始化弹幕，随机分配弹幕轨迹
- (void) initBarrageComment{
    
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    
    for (int i = 0; i < 3; i++) {
        if (self.barrageComments.count > 0) {
            //通过随机数获取到弹幕的轨迹
            NSInteger index = arc4random() % trajectorys.count;
            NSInteger trajectory = [[trajectorys objectAtIndex:index] integerValue];
            [trajectorys removeObjectAtIndex:index];
            //从弹幕数组中逐渐取出弹幕数据
            
            NSString *comment = [self.barrageComments firstObject];
            NSLog(@"comment = %@",comment);
            [self.barrageComments removeObjectAtIndex:0];
            
            //创建弹幕view
            [self createBarrageView:comment trajectory:trajectory];
        }
       
    }
}


- (void) createBarrageView:(NSString *)comment trajectory:(NSInteger)trajector{
    if (self.barrageStoping) {
        return;
    }
    BarrageView *view = [[BarrageView alloc] initWithComment:comment];
    view.trajectory = trajector;
//    [self.barrageViews addObject:view];
    NSLog(@"self.barrageViews = %@",self.barrageViews);
    
    __weak typeof (view) weakView = view;
    __weak typeof (self) weakSelf  = self;
    
    
    view.moveStatusBlock = ^(MoveStatus status){
        if (self.barrageStoping) {
            return ;
        }
        switch (status) {
            case Start:{
                //弹幕开始进入屏幕，将view加入弹幕管理的变量中barrageViews中
                [weakSelf.barrageViews addObject:weakView];

                break;

            }
            case Enter:{
                //弹幕完全进入屏幕，判断是否还有其他内容，如果有则在弹幕的轨道中创建一个弹幕
                NSString *comment  = [weakSelf nextComment];
                if (comment) {
                    [weakSelf createBarrageView:comment trajectory:trajector];
                }

                break;
                
            }

            case End:{
                //弹幕飞出屏幕后从braarage中删除，释放资源
                if ([weakSelf.barrageViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.barrageViews removeObject:weakView];
                }
                if (weakSelf.barrageViews.count == 0) {
                    //说明屏幕上已经没有弹幕了，需要循环使用
                    self.barrageStoping = YES;
                    [weakSelf barrageStart];
                }
                break;
                
            }
                
            default:
                break;
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}
-(NSString *)nextComment{
    if (self.barrageComments.count == 0) {
        return nil;
    }
    NSString *comment = [self.barrageComments firstObject];
    if (comment) {
        [self.barrageComments removeObjectAtIndex:0];
    }
    return comment;
}
- (void)barrageStop{
    if (self.barrageStoping) {
        return;
    }
    self.barrageStoping = YES;
    [self.barrageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BarrageView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.barrageViews removeAllObjects];
    
    
}
-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1~~~~~~~~~",@"弹幕2~~~~~~",@"弹幕3~~~~~~~~~~~~",@"弹幕1~~~~~~~~~",@"弹幕2~~~~~~",@"弹幕3~~~~~~~~~~~~"]];
    }
    return _dataSource;
}

- (NSMutableArray *)barrageViews{
    if (!_barrageViews) {
        _barrageViews = [NSMutableArray array];
    }
    return _barrageViews;
}

- (NSMutableArray *)barrageComments{
    if (!_barrageComments) {
        _barrageComments = [NSMutableArray array];
    }
    return _barrageComments;
}
@end
