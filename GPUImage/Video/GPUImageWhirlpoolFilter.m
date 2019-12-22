//
//  GPUImageWhirlpoolFilter.m
//  GPUImage
//
//  Created by chivox on 2019/12/4.
//  Copyright © 2019 chivox. All rights reserved.
//

#import "GPUImageWhirlpoolFilter.h"



NSString *const kGPUImageWhirlpoolFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 
 void main() {
     vec2 uv = textureCoordinate.xy;
     float y;
     if (uv.y >= 0.0 && uv.y <= 0.5) {
         y = uv.y + 0.25;
     } else {
         y = uv.y - 0.25;
     }
     gl_FragColor = texture2D(inputImageTexture, vec2(uv.x, y));
 }
 );

@implementation GPUImageWhirlpoolFilter




#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageWhirlpoolFragmentShaderString]))
    {
        return nil;
    }
    
//    whirlpoolUniform = [filterProgram uniformIndex:@"whirlpool"];

    return self;
}


@end


