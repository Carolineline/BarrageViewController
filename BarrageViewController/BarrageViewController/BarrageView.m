//
//  BarrageView.m
//  BarrageViewController
//
//  Created by 晓琳 on 16/12/9.
//  Copyright © 2016年 xiaolin.han. All rights reserved.
//

#import "BarrageView.h"

#define Padding 10
#define headWidth 30


@interface BarrageView ()
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@end

@implementation BarrageView

- (instancetype) initWithComment:(NSString *)comment{
    if (self = [super init]) {
        NSLog(@"self = %@",self);
        self.backgroundColor = [UIColor yellowColor];
        self.layer.cornerRadius = 15;

        //计算宽度
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat width = [comment sizeWithAttributes:attr].width;

        self.bounds = CGRectMake(0, 0, width + 2*Padding + headWidth, 30);
        self.commentLabel.frame = CGRectMake(Padding + headWidth, 0, width, 30);
        self.commentLabel.text = comment;
        
        self.headImageView.frame = CGRectMake(-Padding, -Padding, headWidth + Padding, headWidth + Padding);
        self.headImageView.layer.borderColor = [UIColor blueColor].CGColor;
        self.headImageView.layer.borderWidth = 1.0f;
        self.headImageView.layer.cornerRadius = (Padding + headWidth)/2;
    }
    return self;
}

//开始动画
- (void) startAnimation{
    
    //根据屏幕长度执行动画
    //v = s/t
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    
    CGFloat speed = wholeWidth/duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds)/speed;
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    
    __block CGRect frame = self.frame;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        frame.origin.x  -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (self.moveStatusBlock) {
            self.moveStatusBlock(End);
        }
        [self removeFromSuperview];
        
    }];
   
    
}

- (void) enterScreen{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }
}
//结束动画
- (void) stopAnimation{
    //取消延迟加载
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (UILabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel = [UILabel new];
        _commentLabel.textAlignment = 1;
        _commentLabel.textColor = [UIColor lightGrayColor];
        _commentLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_commentLabel];
    }
    return _commentLabel;
}

- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.image = [UIImage imageNamed:@"head"];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_headImageView];
    }
    return _headImageView;
}
@end
