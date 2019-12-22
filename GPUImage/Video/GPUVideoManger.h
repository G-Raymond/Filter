//
//  GPUVideoManger.h
//  GPUImage
//
//  Created by chivox on 2019/12/4.
//  Copyright © 2019 chivox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage.h>
NS_ASSUME_NONNULL_BEGIN

@interface GPUVideoManger : NSObject
//创建视频录制单例
+(instancetype)shareGPUVideoManger;
- (void)startRecording;
- (void)addDisplayViewToSuperView:(UIView *)superView withFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
