//
//  PictureController.m
//  GPUImage
//
//  Created by chivox on 2019/11/12.
//  Copyright © 2019 chivox. All rights reserved.
//

#import "PictureController.h"
#import "GPUImage.h"
@interface PictureController ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic, strong)GPUImageExposureFilter *exposureFilter;
@property(nonatomic, strong)GPUImageSaturationFilter *saturationFilter;
@property(nonatomic, strong) GPUImagePicture *gpuPicture;
@property(nonatomic, strong) GPUImagePicture *gpuPicture2;

@property(nonatomic, assign) CGFloat exposure;
@property(nonatomic, assign) CGFloat saturation;


@property(nonatomic, strong) UIImage *processedImage;

@end

@implementation PictureController

- (void)viewDidLoad {
    
    
    //创建一个滤镜 GPUImageFilter -- 创建一个新的GPUImagepicture (处理的是CGPUImagePicture) ---> GpuiMagePicture  addtarger 添加滤镜 ----> GpuImagecture processImage  处理滤镜。---->  GpuImageFilter imagefromCurrentBuffer 拿出图片
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    _imageView.backgroundColor = [UIColor whiteColor];
    _processedImage = [UIImage imageNamed:@"timg.jpg"];
    _imageView.image = _processedImage;
    
  
    
    UISlider *silder = [[UISlider alloc]initWithFrame:CGRectMake(50, 500, [UIScreen mainScreen].bounds.size.width - 100, 20)];

    silder.value = 0;
    silder.minimumValue = -1.0;
    silder.maximumValue = 1.0;
    [silder addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:silder];
    UISlider *silder2 = [[UISlider alloc]initWithFrame:CGRectMake(50, 550, [UIScreen mainScreen].bounds.size.width - 100, 20)];
    silder2.minimumValue = 1.0;
    silder2.maximumValue = 2.0;
    silder2.value = 1.5;
    [silder2 addTarget:self action:@selector(slider2:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:silder2];
    
}


- (void)processedImageWithExposure{
    
    if (!_gpuPicture2) {
        
        _gpuPicture2 = [[GPUImagePicture alloc]initWithImage:_processedImage];
    }
 
    
    GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc]init];
    
    [exposureFilter forceProcessingAtSize:_imageView.bounds.size];
    exposureFilter.exposure = _exposure;
    
//    NSLog(@"%f",_exposure);
    [exposureFilter useNextFrameForImageCapture];
    [_gpuPicture2 addTarget:exposureFilter];
    [_gpuPicture2 processImage];
    UIImage *newImage = [exposureFilter imageFromCurrentFramebuffer];
    _imageView.image = newImage;
    _processedImage = newImage;
}

-(GPUImageExposureFilter *)exposureFilter{
    if (!_exposureFilter) {
        _exposureFilter = [[GPUImageExposureFilter alloc]init];
    }
    
    return _exposureFilter;
}
- (void)processImageWithSturation{
    if(!_gpuPicture){
        _gpuPicture = [[GPUImagePicture alloc]initWithImage:_processedImage];
    }
    
    
    [self.saturationFilter forceProcessingAtSize:_imageView.bounds.size];
    [self.saturationFilter useNextFrameForImageCapture];
    self.saturationFilter.saturation = _saturation;
    [_gpuPicture addTarget:self.saturationFilter];
    [_gpuPicture processImage];
    UIImage *newIamge = [self.saturationFilter imageFromCurrentFramebuffer];
    _imageView.image = newIamge;
    _processedImage = newIamge;
}
- (GPUImageSaturationFilter *)saturationFilter{
    if (!_saturationFilter) {
        
        _saturationFilter = [[GPUImageSaturationFilter alloc]init];
    }
    return _saturationFilter;
}
- (void)slider2:(UISlider *)s{
    
    NSLog(@"%f", s.value);
    
    self.saturation = s.value;
    [self processImageWithSturation];
}

- (void)slider:(UISlider *)s{
    
    NSLog(@"%f", s.value);
    self.exposure = s.value;
    [self processedImageWithExposure];
 
}

//- (UIImage *)processImageUseExproseeExposure:(float)exposure{
//
//
//   return <#expression#>
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
