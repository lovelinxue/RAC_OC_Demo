//
//  ViewController.m
//  RAC_OC_Demo
//
//  Created by ShangHaiYunYan on 2017/5/17.
//  Copyright © 2017年 ShangHaiYunYan. All rights reserved.
//

#import "ViewController.h"

//导入RAC框架
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface ViewController ()

@end

//一个合格的信号量,至少调用0次或者多次next,会调用一次error(出错)和一次completed(完成),这2个是互斥的.


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    RACSignal *t1 = [_user rac_textSignal];
    RACSignal *t2 = [_psd rac_textSignal];
    
//    [[RACSignal merge:@[t1,t2]] subscribeNext:^(id x) {
//        NSLog(@"-----------%@----------",x);
//    }];
//    
    
    [[RACSignal combineLatest:@[t1,t2]] subscribeNext:^(id x) {
        NSLog(@"*********%@**********",x);
    }];
    
    
    
    
//    //定义错误
//    NSError *error;
//    
//    NSURL *ipURL = [NSURL URLWithString:@"http://ipof.in/txt"];
//    
//    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
//    
//    NSString *ipStr = [NSString stringWithFormat:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=%@",ip];
    
//    [[self signalForJson:ipStr] subscribeNext:^(id x) {
//        
//        NSLog(@"\n您的外网IP号为:%@\n您的IP地址为:%@-%@-%@",ip,x[@"country"],x[@"province"],x[@"city"]);
//        
//    }error:^(NSError *error) {
//        
//        NSLog(@"错误状态------%@",error);
//        
//    }completed:^{
//        
//        NSLog(@"完成之后状态------需要释放的东西");
//        
//    }];
    
    
    
//    RACSignal *s = [self signalForJson:ipStr];
//    RACSignal *s1 = [self signalForJson:ipStr];
//    RACSignal *s2 = [self signalForJson:ipStr];
//    
//    
//    //类似于GCD中的同步并行,等都执行完毕在执行结果
//    [[RACSignal combineLatest:@[s,s1,s2]] subscribeNext:^(id x) {
//        //等3个都执行完毕再执行结果
//    }];
//    
//    
//    //依次执行
//    [[[s then:^RACSignal *{
//        return s1;
//    }] then:^RACSignal *{
//        return s2;
//    }] subscribeNext:^(id x) {
//        //s执行之后会执行s1执行之后会返回s2来执行,之后会执行结果
//    }];
//    
//    
//    //
//    [[RACSignal merge:@[s,s1,s2]] subscribeNext:^(id x) {
//        //执行结果
//    }];
    
    


}





- (RACSignal *)signalForJson:(NSString *)url
{
    //实例化一个信号
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //先实例化
        NSURLSessionConfiguration *c = [NSURLSessionConfiguration defaultSessionConfiguration];
        //
        NSURLSession *sess = [NSURLSession sessionWithConfiguration:c];

        //创建一个数据流
        NSURLSessionDataTask *data = [sess dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            //先判断是否有错误,有错误就传错误
            if (error){
                [subscriber sendError:error];
            }else{
                
                NSError *err;//用来记录错误值
                
                //使用系统的json解析
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                
                //json解析是否有错误
                if(err){
                    [subscriber sendError:err];
                }else{
                    [subscriber sendNext:jsonDic];
                    [subscriber sendCompleted];
                }
                
            }
            
        }];
        [data resume];
        
        //释放之后要执行的,必须写
        return [RACDisposable disposableWithBlock:^{
            
        }];
        
    }];
    
    
    
}




-(void)demo
{
    //    [self foo];
    
    //自指针
    //    [[self class]classFuncation];
    
    //    [ViewController classFuncation];
    
    //使用RAC监听text
    //    [self RACMonitoringTextValue];
    
    //block
    //    void (^ blockcc)() = ^{};
    //    //调用block
    //    blockcc();
    
    
    //使用RAC监听viewDidAppear事件
    //    [self RACMonitoringViewDidAppear];
    
    
    
    // 按钮绑定事件
    //    [self RACButtonAction];
}



/**
 *  text绑定按钮状态
 */
- (void)RACTextButtonBinding{

    //创建text信号
    RACSignal *userSignal = self.user.rac_textSignal;
    RACSignal *psdSignal = self.psd.rac_textSignal;
    
    //合并2个信号
    RACSignal *textCombinSignal = [RACSignal combineLatest:@[userSignal,psdSignal]];
    
    
    //判断text数据来返回按钮是否可点
    RACSignal *btnEnableSignal = [textCombinSignal map:^id(id value) {
        return @([value[0] length] > 0 && [value[1] length] > 6);
    }];
    
    
    
    
    //    RACSignal *enableBtn = [[RACSignal combineLatest:@[self.user.rac_textSignal,self.psd.rac_textSignal]]map:^id(id value) {
    //        return @([value[0] length] > 0 && [value[1] length] > 6);
    //    }];
    
    
    //给登陆按钮添加事件
    [self.login setRac_command:[[RACCommand alloc] initWithEnabled:btnEnableSignal signalBlock:^RACSignal *(id input) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [textCombinSignal subscribeNext:^(id x) {
                [subscriber sendNext:x];
                [subscriber sendCompleted];
            }];
            
            //释放
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
        
    }]];
    
    
    //调用点击事件
    [[[self.login rac_command] executionSignals]subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            NSLog(@"--------账号:%@---------密码:%@",x[0],x[1]);
        }];
    }];

}



/**
 *  按钮绑定事件
 */
-(void)RACButtonAction
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    btn.bounds = CGRectMake(0, 0, 100, 50);
    btn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:btn];
    
    //给按钮绑定事件
    [btn setRac_command:[[RACCommand alloc]initWithEnabled:nil signalBlock:^RACSignal *(id input) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSLog(@"\n--click--%s",__func__);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t) (3.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [subscriber sendNext:[[NSDate date] description]];
                
                [subscriber sendCompleted];
            });
            
            //在释放的时候调用
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"\n_________释放对象_________");
            }];
        }];
        
    }]];
    
    //调用信号
    [[[btn rac_command]executionSignals] subscribeNext:^(id x) {
        NSLog(@"\n===================%@",x);
        [x subscribeNext:^(id x) {
            NSLog(@"\n%@",x);
        }];
    }];

}


/**
 *  使用RAC监听viewDidAppear事件
 */
- (void)RACMonitoringViewDidAppear
{
    
    
    
    //创建viewDidAppear的信号量
    RACSignal *viewDidAppearSignal = [self rac_signalForSelector:@selector(viewDidAppear:)];
    
    
    //调用viewDidAppear信号
    [viewDidAppearSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
        NSLog(@"%s",__func__);
    }];
    
    //监听viewDidAppear错误信息
    [viewDidAppearSignal subscribeError:^(NSError *error) {
        
    }];
    
    //监听viewDidAppear完成状态
    [viewDidAppearSignal subscribeCompleted:^{
        
    }];

}


/**
 *  使用RAC监测text
 */
- (void)RACMonitoringTextValue
{
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(0, 300, 400, 80)];
    text.backgroundColor = [UIColor redColor];
    [self.view addSubview:text];
    
    //监听text的代理方法UIControlEventEditingChanged
    [[text rac_signalForControlEvents:UIControlEventEditingChanged]subscribeNext:^(id x) {
        NSLog(@"UIControlEventEditingChanged--:%@",x);
    }];
    
    //监听text的输入内容
    [[text rac_textSignal]subscribeNext:^(id x) {
        NSLog(@"text--输入内容为:-- %@",x);
    }];
    
}


/**
 *  类方法
 */
+ (void)classFuncation{
    NSLog(@"这是类方法,调用类方法.前边需要调用类");
}


/**
 *  实例方法
 */
- foo{
    NSLog(@"实例方法");
    return nil;
}

@end
