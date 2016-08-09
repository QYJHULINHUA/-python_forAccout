//
//  esCreateTexture.h
//  Simple_Texture2D
//
//  Created by v.q on 15/12/16.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#ifndef esCreateTexture_h
#define esCreateTexture_h
#include "esUtil.h"
#endif /* esCreateTexture_h */


typedef struct
{
    // Handle to a program object
    GLuint      originPrgObj;
    GLuint      programObject;
    GLuint      sbprogramObject;
    GLuint      sxprogramObject;
    // Sampler location
    // 彩图纹理显示采样器
    GLuint      originSamLoc;
    //窗宽窗位的纹理采样器
    GLuint       samplerLoc;
    //sharpen的纹理采样器
    GLuint      hSamLoc;
    GLuint      vSamLoc;
    GLuint      vOriginSamLoc;
    GLuint      colorTableLoc;
    // Uniform location
    GLint       wwLoc;
    GLint       wlLoc;
    GLint       gauScaleLoc;
    GLint       tableNumLoc;
    // mvp matrix location
    GLuint      originMvpLoc;
    GLuint      mvpLoc;
    // Texture handle
    GLuint      textureId;
    GLuint      colorTableId;
    // FrameBuffer handle
    GLuint      frameBuffer;
    GLuint      frameBuffer2;
    // scale and translate matrix
    ESMatrix    modelView;
    ESMatrix    projection;
    ESMatrix    mvpMat;
    // First init FBO
    int         firstInitFBO;
    // zoom Scale
    float       zoomScale;
    // rotate angle
    GLint       rotateAngle;
    // static value
    GLuint       kTextureWidth;
    GLuint       kTextureHeight;
} UserData;

GLuint empty_textureID;
GLuint empty_textureID2;

GLuint GAUSSIAN_WEIGHT_HOR;
GLuint PIXEL_OFFSET_HOR;
GLuint PIXELSIZE_HOR;
GLuint GAUSSIAN_WEIGHT_VERT;
GLuint PIXEL_OFFSET_VERT;
GLuint PIXELSIZE_VERT;

GLuint vaoID;
GLuint vertPosID;
GLuint texPosID;
GLuint vertIndexID;

GLuint plane_vaoID;
GLuint plane_vertPosID;
GLuint plane_texPosID;
GLuint plane_vertIndexID;

static GLushort indices[] = { 0, 1, 2, 0, 2, 3 };

static GLfloat originVertices[] =
{
    -1.0f, 1.0f, 0.0f,  // Position 0
    
    -1.0f,-1.0f, 0.0f,  // Position 1
    
    1.0f,-1.0f, 0.0f,  // Position 2
    
    1.0f, 1.0f, 0.0f,  // Position 3
};

static GLfloat vVertices[] =
{
    -1.0f, 1.0f, 0.0f,  // Position 0
    
    -1.0f,-1.0f, 0.0f,  // Position 1
    
    1.0f,-1.0f, 0.0f,  // Position 2
    
    1.0f, 1.0f, 0.0f,  // Position 3
};

static GLfloat sbVertices[] =
{
    -1.0f, 1.0f, 0.0f,  // Position 0
    
    -1.0f,-1.0f, 0.0f,  // Position 1
    
    1.0f,-1.0f, 0.0f,  // Position 2
    
    1.0f, 1.0f, 0.0f,  // Position 3
};

static GLfloat vTextures[] =
{
    0.0f,  0.0f,        // TexCoord 0
    0.0f,  1.0f,        // TexCoord 1
    1.0f,  1.0f,        // TexCoord 2
    1.0f,  0.0f         // TexCoord 3
};

static GLfloat sbVTextures[] =
{
    0.0f,  1.0f,        // TexCoord 3
    0.0f,  0.0f,        // TexCoord 2
    1.0f,  0.0f,        // TexCoord 1
    1.0f,  1.0f        // TexCoord 0
};

GLuint CreateSimpleTexture2D(void *data, GLuint width, GLuint height, GLboolean isLinear, GLboolean isRGB, GLboolean isUnsigned , GLboolean is16F, size_t passway);

GLuint CreatColorTableTexture(const unsigned char *data, GLuint width, GLuint height);