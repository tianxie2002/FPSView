//
//  MSFPSView.m
//  meishi
//
//  Created by Pan Lee on 2017/3/8.
//  Copyright © 2017年 Kangbo. All rights reserved.
//

#import "MSFPSView.h"
#define kSize CGSizeMake(55, 20)

static MSFPSView *_fpsView = nil;

@interface MSFPSView ()
{
    CADisplayLink *_link;
    NSTimeInterval _lastTime;
    NSUInteger _count;
}

@property (nonatomic, strong) UILabel *label;

@end

@implementation MSFPSView

+ (void)show
{
    if(!_fpsView){
        _fpsView = [[MSFPSView alloc] init];
    }
    if(_fpsView.superview){
        [_fpsView removeFromSuperview];
    }
    if(!_fpsView.superview){
        UINavigationController *nac = [[[UIApplication sharedApplication].delegate window] rootViewController];
        [[[[nac viewControllers] lastObject] view] addSubview:_fpsView];
    }
}

- (id)init
{
    if(self = [super init])
    {
        self.userInteractionEnabled = NO;
        self.frame = CGRectMake(0, 20, 50, 30);
        self.label.frame = self.bounds;
        [self addSubview:self.label];
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    self.label.attributedText = text;
}

- (UILabel *)label
{
    if(!_label){
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
