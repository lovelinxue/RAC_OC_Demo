//
//  touivewViewController.m
//  RAC_OC_Demo
//
//  Created by ShangHaiYunYan on 2017/5/17.
//  Copyright © 2017年 ShangHaiYunYan. All rights reserved.
//

#import "touivewViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface touivewViewController ()
{
    CGFloat r,g,b;
}
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UITextField *redtext;
@property (weak, nonatomic) IBOutlet UITextField *bluetext;
@property (weak, nonatomic) IBOutlet UITextField *greentext;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end



@implementation touivewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _redtext.text = _bluetext.text = _greentext.text = @"0.5";
    
    [self bindingControlWithSlider:_redSlider text:_redtext];
    [self bindingControlWithSlider:_blueSlider text:_bluetext];
    [self bindingControlWithSlider:_greenSlider text:_greentext];
}


/**
 *  双向绑定滑块和输入值
 *
 *  @param slider 滑块
 *  @param text   textfiled
 */
-(void)bindingControlWithSlider:(UISlider *)slider text:(UITextField *)text
{
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *textSlider = [text rac_newTextChannel];
    
    [[signalSlider map:^id(id value) {
        return  [NSString stringWithFormat:@"%.02f",[value floatValue]];
    }] subscribe:textSlider];
    
    [textSlider subscribe:signalSlider];
    
    
}



@end
