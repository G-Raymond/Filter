//
//  VideoControllerViewController.m
//  GPUImage
//
//  Created by chivox on 2019/12/4.
//  Copyright © 2019 chivox. All rights reserved.
//

#import "VideoController.h"
#import "GPUVideoManger.h"
@interface VideoController ()
@property(nonatomic,strong)GPUVideoManger *manger;

@end

@implementation VideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视屏录制";
    self.view.backgroundColor = [UIColor blackColor];
    [self createMange];
}

- (void)createMange{
    _manger = [GPUVideoManger shareGPUVideoManger];
    [_manger addDisplayViewToSuperView:self.view withFrame:CGRectMake(0, 100,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[GPUVideoManger shareGPUVideoManger] startRecording];
}

@end
