//
//  GPUImageWhirlpoolFilter.m
//  GPUImage
//
//  Created by chivox on 2019/12/4.
//  Copyright © 2019 chivox. All rights reserved.
//

#import "GPUImageCircleFilter.h"



NSString *const kGPUImageCirlceFragmentShaderString = SHADER_STRING
(
 precision mediump float;
 
 const float PI = 3.14159265;
 uniform sampler2D inputImageTexture;
 varying highp vec2 textureCoordinate;
 const float uD = 80.0;
 const float uR = 0.5;
 
 
 void main()
{
    ivec2 ires = ivec2(512, 512);
    float Res = float(ires.s);
    
    vec2 st = textureCoordinate;
    float Radius = Res * uR;
    
    vec2 xy = Res * st;
    
    vec2 dxy = xy - vec2(Res/2., Res/2.);
    float r = length(dxy);
    
    //(1.0 - r/Radius);
    float beta = atan(dxy.y, dxy.x) + radians(uD) * 2.0 * (-(r/Radius)*(r/Radius) + 1.0);
    
    vec2 xy1 = xy;
    if(r<=Radius)
    {
        xy1 = Res/2. + r*vec2(cos(beta), sin(beta));
    }
    
    st = xy1/Res;
    
    vec3 irgb = texture2D(inputImageTexture, st).rgb;
    
    gl_FragColor = vec4( irgb, 1.0 );
}
 );

@implementation GPUImageCircleFilter




#pragma mark -
#pragma mark Initialization and teardown

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageCirlceFragmentShaderString]))
    {
        return nil;
    }
    return self;
}


@end


