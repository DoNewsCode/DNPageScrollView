//
//  DNChildViewController.m
//  DNPageScrollView_Example
//
//  Created by donews on 2018/9/10.
//  Copyright © 2018年 540563689@qq.com. All rights reserved.
//

#import "DNChildViewController.h"

@interface DNChildViewController ()<CAAnimationDelegate>{
    UILabel *lable;
    UIButton *button;
    UIView *vview;
}

@end

@implementation DNChildViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 40);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    vview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
    vview.backgroundColor = [UIColor greenColor];
    vview.center = self.view.center;
    vview.layer.cornerRadius = vview.frame.size.height/2;
    [self.view addSubview:vview];
    
    lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
    lable.text = @"动画已经准备好";
    lable.font = [UIFont systemFontOfSize:30];
    lable.layer.borderWidth = 3;
    lable.layer.borderColor = [UIColor whiteColor].CGColor;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.layer.cornerRadius = lable.frame.size.height/2;
    [vview addSubview:lable];

//    self.v
    //    lable.hidden = YES;
}

- (void)buttonClick
{
    [UIView animateWithDuration:3 animations:^{
        
        CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        aniScale.fromValue = [NSNumber numberWithFloat:0.5];
        aniScale.toValue = [NSNumber numberWithFloat:4.0];
        aniScale.duration = 3;
        aniScale.delegate = self;
        aniScale.removedOnCompletion = NO;
        aniScale.repeatCount = 1;
        [vview.layer addAnimation:aniScale forKey:@"babyCoin_scale"];
        
    } completion:^(BOOL finished) {
        [self babyCoinFadeAway];
    }];
}

-(void)babyCoinFadeAway
{
    
    //相当与两个动画  合成
    //位置改变
    CABasicAnimation * aniMove = [CABasicAnimation animationWithKeyPath:@"position"];
    aniMove.fromValue = [NSValue valueWithCGPoint:vview.layer.position];
    aniMove.toValue = [NSValue valueWithCGPoint:CGPointMake(500, 300)];
    //大小改变
    CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    aniScale.fromValue = [NSNumber numberWithFloat:3.0];
    aniScale.toValue = [NSNumber numberWithFloat:0.5];
    
    CAAnimationGroup * aniGroup = [CAAnimationGroup animation];
    aniGroup.duration = 3.0;//设置动画持续时间
    aniGroup.repeatCount = 1;//设置动画执行次数
    aniGroup.delegate = self;
    aniGroup.animations = @[aniMove,aniScale];
    aniGroup.removedOnCompletion = NO;
    aniGroup.fillMode = kCAFillModeForwards;  //防止动画结束后回到原位
    //    [lable.layer removeAllAnimations];
    [vview.layer addAnimation:aniGroup forKey:@"aniMove_aniScale_groupAnimation"];
    
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
