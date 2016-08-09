//
//  esCreateTexture.c
//  Simple_Texture2D
//
//  Created by v.q on 15/12/16.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#include "esCreateTexture.h"

GLuint CreatColorTableTexture(const unsigned char *data, GLuint width, GLuint height)
{
    GLuint textureID = 0;
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    return textureID;
}

///
// Create a simple texture image with four different colors
//
GLuint CreateSimpleTexture2D(void *data, GLuint width, GLuint height, GLboolean isLinear, GLboolean isRGB, GLboolean isUnsigned , GLboolean is16F, size_t passway)
{
    // Texture object handle
    GLuint textureId;
    
    // Use tightly packed data
    glPixelStorei ( GL_UNPACK_ALIGNMENT, 1 );
    
    // Generate a texture object
    glGenTextures ( 1, &textureId );
    
    // Bind the texture object
    glBindTexture ( GL_TEXTURE_2D, textureId );
    
    // Load the texture
    if (GL_TRUE == isRGB && GL_TRUE == isUnsigned && GL_FALSE == is16F) {
        unsigned char *pointer = (unsigned char *)data;
        GLint rgb;
        if(passway == 3)
            rgb = GL_RGB;
        else
            rgb = GL_RGBA;
        glTexImage2D(GL_TEXTURE_2D, 0, rgb, width, height, 0, rgb, GL_UNSIGNED_BYTE, pointer);
    }else if(GL_FALSE == isRGB && GL_TRUE == isUnsigned && GL_FALSE == is16F){
        unsigned char *pointer = (unsigned char *)data;
        glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, width, height, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, pointer);
    }else if(GL_FALSE == isRGB && GL_FALSE == isUnsigned && GL_TRUE == is16F){
        float *pointer = (float *)data;
        glTexImage2D ( GL_TEXTURE_2D, 0, GL_R16F, width, height, 0, GL_RED, GL_FLOAT, pointer);
    }else if(GL_FALSE == isRGB && GL_TRUE == isUnsigned && GL_TRUE == is16F)
    {
        float *pointer = (float *)data;
        glTexImage2D(GL_TEXTURE_2D, 0, GL_R16F, width, height, 0, GL_RED, GL_FLOAT, pointer);
    }
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    // Set the filtering mode
    if (isLinear == GL_FALSE)
    {
        glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
        glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
    }else
    {
        glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
        glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    }
    return textureId;
}
