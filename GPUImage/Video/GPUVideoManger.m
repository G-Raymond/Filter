//
//  GPUVideoManger.m
//  GPUImage
//
//  Created by chivox on 2019/12/4.
//  Copyright © 2019 chivox. All rights reserved.
//

#import "GPUVideoManger.h"
#import "GPUImageWhirlpoolFilter.h"
#import "GPUImageCircleFilter.h"
@interface GPUVideoManger()<GPUImageVideoCameraDelegate>
//摄像头
@property(nonatomic,strong)GPUImageVideoCamera *camera;
//图像展示输出拍摄的视频
@property(nonatomic,strong)GPUImageView *displayView;
//视屏写入器
@property(nonatomic,strong)GPUImageMovieWriter *videoWriter;
@property(nonatomic,strong)NSString *videoFilePath;

@property(nonatomic,assign)CGRect displayViewFrame;

@property(nonatomic,strong)GPUImageSaturationFilter *saturationFilter;

@property(nonatomic,strong)GPUImageWhirlpoolFilter *whirlpoolFilter;
@property(nonatomic,strong)GPUImageCircleFilter *circleFilter;


//@property(nonatomic,strong)GPUImageCropFilter *cropFilter;
@end
@implementation GPUVideoManger
+ (instancetype)shareGPUVideoManger{
    static GPUVideoManger *manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manger) {
            manger = [[self alloc]init];
        }
    });
    return manger;
}

- (GPUImageCropFilter *)circleFilter{
    if (!_circleFilter) {
        _circleFilter = [[GPUImageCircleFilter alloc]init];
    }
    return _circleFilter;
}
- (GPUImageSaturationFilter *)saturationFilter{
    if (!_saturationFilter) {
        _saturationFilter = [[GPUImageSaturationFilter alloc]init];
        _saturationFilter.saturation = 2.0;
    }
    return _saturationFilter;
}


- (GPUImageWhirlpoolFilter *)whirlpoolFilter{
    if (!_whirlpoolFilter) {
        _whirlpoolFilter = [[GPUImageWhirlpoolFilter alloc]init];
    }
    return _whirlpoolFilter;
}





//d
-(GPUImageView *)displayView{
    if (!_displayView) {
        _displayView = [[GPUImageView alloc]initWithFrame:self.displayViewFrame];
        
        _displayView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        //m没有设置大小
    }
    return _displayView;
}

//
- (GPUImageVideoCamera *)camera{
    if (!_camera) {
        //初始化摄像头 设置摄像头捕获区域 和确定前摄像头还是后摄像头
        _camera = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPreset352x288 cameraPosition:AVCaptureDevicePositionBack];
        _camera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _camera.delegate = self;
        //设置声音输入输出 可以避免第一镇黑屏
        [_camera addAudioInputsAndOutputs];
    }
    return _camera;
}
//开始录制视频
- (void)startRecording{
    
    NSString *videoPath = [[self creatVideoDirectory] stringByAppendingString:@"/111.mp4"];
    //创建视频写入
    self.videoWriter =[[GPUImageMovieWriter alloc]initWithMovieURL:[NSURL fileURLWithPath:videoPath] size:CGSizeMake(480, 640)];
    self.videoWriter.encodingLiveVideo = YES;
    //设置是否使用原音源
    self.videoWriter.shouldPassthroughAudio = YES;
    
    
    unlink([videoPath UTF8String]);
    //添加滤镜 就是把滤镜的target添加到write上
    
//    [self.whirlpoolFilter addTarget:self.videoWriter];
//    [self.saturationFilter addTarget:self.videoWriter];
    [self.circleFilter addTarget:self.videoWriter];
    
    self.camera.audioEncodingTarget = self.videoWriter;
    [self.videoWriter startRecording];//启动录制
}
//创建录制录制视频保存的文件目录
- (NSString *)creatVideoDirectory{
    NSString *videoDirectoryPath = [NSTemporaryDirectory() stringByAppendingString:@"videos"];
    BOOL isDir = NO;
    NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL existed =  [fileManger fileExistsAtPath:videoDirectoryPath isDirectory:&isDir];
    if (!existed) {
        [fileManger createDirectoryAtPath:videoDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return videoDirectoryPath;
}


- (void)addDisplayViewToSuperView:(UIView *)superView withFrame:(CGRect)frame{
    self.displayViewFrame = frame;
    [self.circleFilter addTarget:self.displayView];
    [self.camera addTarget:self.circleFilter];
//    [self.whirlpoolFilter addTarget:self.displayView];
//    [self.camera addTarget:self.whirlpoolFilter];
//    [self.saturationFilter addTarget:self.displayView];
//    [self.camera addTarget:self.saturationFilter];
    [superView addSubview:self.displayView];
    
    [self.camera startCameraCapture];

}

#pragma mark ----GPUImageVideoCameraDelegate----
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    
}
@end
