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

    //赋个初始值
    _redtext.text = _bluetext.text = _greentext.text = @"0.5";
    
    //将2个控件绑定后值的结果用信号接收
    RACSignal *redS = [self bindingControlWithSlider:_redSlider text:_redtext];
    RACSignal *blueS = [self bindingControlWithSlider:_blueSlider text:_bluetext];
    RACSignal *greenS = [self bindingControlWithSlider:_greenSlider text:_greentext];
    
    RACSignal *rgb = [[RACSignal combineLatest:@[redS,greenS,blueS]]map:^id(RACTuple *value) {
        return [UIColor colorWithRed:[value[0]floatValue] green:[value[2]floatValue] blue:[value[1]floatValue] alpha:1];
    }];
    
//    [rgb subscribeNext:^(id x) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _bgView.backgroundColor = x;
//        });
//    }];
    
    //以上代码可以直接简单这样写 RAC(__这里是要改变的对象__,__这里是对象要改变的属性__) = 改变的值
    RAC(_bgView,backgroundColor) = rgb;

    
    
    
//    //1.首先合并3个信号量   2.然后用map修改信号量为需要的值  3.直接订阅这个信号量的返回值
//    [[[RACSignal combineLatest:@[redS,blueS,greenS]]map:^id(RACTuple *value) {
//        return [UIColor colorWithRed:[value[0] floatValue] green:[value[2]floatValue] blue:[value[1]floatValue] alpha:1];
//    }] subscribeNext:^(id x) {
//        
//        //刷新UI的方法尽量放到主线程里,尽量避免一些不必要的Bug
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _bgView.backgroundColor = x;
//        });
//        
//    }];
    

}


/**
 *  双向绑定滑块和输入值
 *
 *  @param slider 滑块
 *  @param text   textfiled
 */
-(RACSignal *)bindingControlWithSlider:(UISlider *)slider text:(UITextField *)text
{
    
    RACSignal *textS = [[text rac_textSignal] take:1];
    
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *textSlider = [text rac_newTextChannel];
    
    [[signalSlider map:^id(id value) {
        return  [NSString stringWithFormat:@"%.02f",[value floatValue]];
    }] subscribe:textSlider];
    
    [textSlider subscribe:signalSlider];
    
    
    return [RACSignal merge:@[textSlider,signalSlider,textS]];
    
}


- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
