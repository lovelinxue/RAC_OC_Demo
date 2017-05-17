//
//  touivewViewController.m
//  RAC_OC_Demo
//
//  Created by ShangHaiYunYan on 2017/5/17.
//  Copyright © 2017年 ShangHaiYunYan. All rights reserved.
//

#import "touivewViewController.h"

@interface touivewViewController ()
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
    // Do any additional setup after loading the view.
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
