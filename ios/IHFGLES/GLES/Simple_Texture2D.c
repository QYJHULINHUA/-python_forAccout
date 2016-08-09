#include <stdlib.h>
#include "esCreateTexture.h"
#include "esSharpener.h"
#include "ihefeImageLUT.h"


///
// Create a frame buffer for render to texture
//
GLuint CreateFBO_fir (GLuint width, GLuint height)
{
    GLuint framebuffer;
    GLuint depthRenderBuffer;
    
    glGenTextures(1, &empty_textureID);
    glBindTexture(GL_TEXTURE_2D, empty_textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexImage2D ( GL_TEXTURE_2D, 0, GL_RGBA , width, height, 0, GL_RGBA
                  , GL_UNSIGNED_BYTE, 0);
    
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, empty_textureID, 0);
    
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    glRenderbufferStorage( GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    glFramebufferRenderbuffer( GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
    
    GLenum status = glCheckFramebufferStatus( GL_FRAMEBUFFER);
    
    if ( status != GL_FRAMEBUFFER_COMPLETE) {
        printf("failed to make complete framebuffer object %x", status);
        return FALSE;
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    return framebuffer;
}

GLuint CreateFBO_sec(GLuint width, GLuint height)
{
    GLuint frameBuffer;
    
    glGenTextures(1, &empty_textureID2);
    glBindTexture(GL_TEXTURE_2D, empty_textureID2);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexImage2D ( GL_TEXTURE_2D, 0, GL_RGBA , width, height, 0, GL_RGBA
                  , GL_UNSIGNED_BYTE, 0);
    
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, empty_textureID2, 0);
    
    // check FBO status
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(status != GL_FRAMEBUFFER_COMPLETE){
        printf("Framebuffer creation fails: %d", status);
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    
    return frameBuffer;
}

void initVAO(void)
{
    glGenBuffers(1, &vertPosID);
    glBindBuffer(GL_ARRAY_BUFFER, vertPosID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sbVertices), sbVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &texPosID);
    glBindBuffer(GL_ARRAY_BUFFER, texPosID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sbVTextures), sbVTextures, GL_STATIC_DRAW);
    
    glGenBuffers(1, &vertIndexID);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertIndexID);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glGenVertexArrays(1, &vaoID);
    glBindVertexArray(vaoID);
    
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, vertPosID);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid *)(0));
    
    glEnableVertexAttribArray(1);
    glBindBuffer(GL_ARRAY_BUFFER, texPosID);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, (GLvoid *)(0));
    //////
    glGenBuffers(1, &plane_vertPosID);
    glBindBuffer(GL_ARRAY_BUFFER, plane_vertPosID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vVertices), vVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &plane_texPosID);
    glBindBuffer(GL_ARRAY_BUFFER, plane_texPosID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vTextures), vTextures, GL_STATIC_DRAW);
    
    glGenBuffers(1, &plane_vertIndexID);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, plane_vertIndexID);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glGenVertexArrays(1, &plane_vaoID);
    glBindVertexArray(plane_vaoID);
    
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, plane_vertPosID);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid *)(0));
    
    glEnableVertexAttribArray(1);
    glBindBuffer(GL_ARRAY_BUFFER, plane_texPosID);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, (GLvoid *)(0));
    
}

void initHorizonalShader(UserData *userData,UserInfo info,GLuint width,GLuint height)
{
    userData->sbprogramObject = esLoadProgram(vSbShaderStr, fShaderHorizon);
    userData->hSamLoc = glGetUniformLocation(userData->sbprogramObject, "sb_texture");
    PIXELSIZE_HOR = glGetUniformLocation(userData->sbprogramObject, "pixelSize");
    PIXEL_OFFSET_HOR = glGetUniformLocation(userData->sbprogramObject, "PixOffset");
    GAUSSIAN_WEIGHT_HOR = glGetUniformLocation(userData->sbprogramObject, "Weight");
    
    glUseProgram(userData->sbprogramObject);
    
    glUniform2f(PIXELSIZE_HOR, 1.0/width, 1.0/height);
    float gWeight[info.region];
    gWeight[0] = GaussianEquation(0, info.sigma);
    float sum = gWeight[0];
    for (int i = 1; i<info.region; i++) {
        gWeight[i] = GaussianEquation(i, info.sigma);
        sum += 2 * gWeight[i];
    }
    for (int j = 0; j < info.region; j++) {
        gWeight[j] /= sum;
    }
    glUniform1fv(GAUSSIAN_WEIGHT_HOR, (int)(sizeof(gWeight)/sizeof(float)), gWeight);
    float pixOffset[info.region];
    for(int k = 0; k < info.region; k++){
        pixOffset[k] = (float)k;
    }
    glUniform1fv(PIXEL_OFFSET_HOR, (int)(sizeof(pixOffset)/sizeof(float)), pixOffset);
}

void initVerticalShader(UserData *userData,UserInfo info,GLuint width,GLuint height)
{
    userData->sxprogramObject = esLoadProgram(vSxShaderStr, fShaderVertical);
    userData->vSamLoc = glGetUniformLocation(userData->sxprogramObject, "sx_texture");
    userData->vOriginSamLoc = glGetUniformLocation(userData->sxprogramObject, "sb_texture");
    PIXELSIZE_VERT = glGetUniformLocation(userData->sxprogramObject, "pixelSize");
    PIXEL_OFFSET_VERT = glGetUniformLocation(userData->sxprogramObject, "PixOffset");
    GAUSSIAN_WEIGHT_VERT = glGetUniformLocation(userData->sxprogramObject, "Weight");
    userData->gauScaleLoc = glGetUniformLocation(userData->sxprogramObject, "gauss_scale");
    //userData->colorTableLoc = glGetUniformLocation(userData->sxprogramObject, "color_table");
    //userData->tableNumLoc = glGetUniformLocation(userData->sxprogramObject, "table_selected");
    
    glUseProgram(userData->sxprogramObject);
    
    glUniform2f(PIXELSIZE_VERT, 1.0/width, 1.0/height);
    float gWeight[info.region];
    gWeight[0] = GaussianEquation(0, info.sigma);
    float sum = gWeight[0];
    for (int i = 1; i < info.region; i++) {
        gWeight[i] = GaussianEquation(i, info.sigma);
        sum += 2*gWeight[i];
    }
    for (int j = 0; j<info.region; j++) {
        gWeight[j] /= sum;
    }
    glUniform1fv(GAUSSIAN_WEIGHT_VERT, (int)(sizeof(gWeight)/sizeof(float)), gWeight);
    float pixOffset[info.region];
    for(int k = 0; k < info.region; k++){
        pixOffset[k] = (float)k;
    }
    glUniform1fv(PIXEL_OFFSET_VERT, (int)(sizeof(pixOffset)/sizeof(float)), pixOffset);
    glUniform1f(userData->gauScaleLoc, info.gauScale);
}

///
// Initialize the shader and program object
//
int Init ( ESContext *esContext, void *data, GLuint width, GLuint height, UserInfo info)
{
    UserData *userData = esContext->userData;
    userData->firstInitFBO = 1;
    userData->zoomScale = 1.0;
    userData->rotateAngle = 0;
    
    ESMatrix spacingMat;
    esMatrixLoadIdentity(&spacingMat);
    
    float myAspect = info.aspect;
    if (myAspect > 1.0) {
        esScale(&spacingMat, 1.0, 1.0/myAspect, 1.0);
    }else if (myAspect < 1.0){
        esScale(&spacingMat, myAspect, 1.0, 1.0);
    }
    
    esMatrixLoadIdentity(&(userData->modelView));
    esMatrixMultiply(&userData->modelView, &userData->modelView, &spacingMat);
    esMatrixLoadIdentity(&(userData->projection));
    esMatrixLoadIdentity(&(userData->mvpMat));
    
    userData->originPrgObj = esLoadProgram(originVShaderStr, originFShaderStr);
    userData->originSamLoc = glGetUniformLocation(userData->originPrgObj, "s_texture");
    userData->originMvpLoc = glGetUniformLocation(userData->originPrgObj, "mvp");
    
    // Load the shaders and get a linked program object
    userData->programObject = esLoadProgram(vShaderStr, fShaderStr);
    // Get the uniform location in adjust
    userData->wwLoc = glGetUniformLocation(userData->programObject, "windowWidth");
    userData->wlLoc = glGetUniformLocation(userData->programObject, "windowLevel");
    userData->colorTableLoc = glGetUniformLocation(userData->programObject, "color_table");
    userData->tableNumLoc = glGetUniformLocation(userData->programObject, "table_selected");
    
    // Get the sampler location
    userData->samplerLoc = glGetUniformLocation ( userData->programObject, "s_texture" );
    userData->mvpLoc = glGetUniformLocation(userData->programObject, "mvp");
    initHorizonalShader(userData,info,width,height);
    initVerticalShader(userData,info,width,height);
    
    // Load the Color Table
    userData->colorTableId = CreatColorTableTexture(&ColorsTable2[0], 256, 14);
    // Load the texture
    userData->kTextureWidth = width;
    userData->kTextureHeight = height;
    userData->textureId = CreateSimpleTexture2D ( data, width, height, info.isLinear, info.isRGB, info.isUnsigned, info.is16F, info.passway);
    // Init VAO
    initVAO();
    
    glClearColor ( 1.0f, 1.0f, 1.0f, 0.0f );
    
    return TRUE;
}


void renderTexture( ESContext *esContext, UserInfo info, void *dataPointer)
{
    UserData *userData = esContext->userData;
    
    glActiveTexture ( GL_TEXTURE0 );
    glBindTexture ( GL_TEXTURE_2D, userData->textureId );
    
    if (dataPointer != NULL )
    {
        glClear(GL_COLOR_BUFFER_BIT);
        if (info.isRGB == GL_TRUE && info.is16F == GL_FALSE && info.isUnsigned == GL_TRUE)
        {
            unsigned char *pointer = (unsigned char *)dataPointer;
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, info.imgW, info.imgH, 0, GL_RGB, GL_UNSIGNED_BYTE, pointer);
            GLint rgb;
            if (info.passway == 3) {
                rgb = GL_RGB;
            }else
            {
                rgb = GL_RGBA;
            }
            glTexImage2D(GL_TEXTURE_2D, 0, rgb, info.imgW, info.imgH, 0, rgb, GL_UNSIGNED_BYTE, pointer);

            glUniform1i(userData->originSamLoc, 0);
        }else if(info.isRGB == GL_FALSE && info.is16F == GL_TRUE && info.isUnsigned == GL_FALSE)
        {
            float *pointer = (float *)dataPointer;
            glTexImage2D(GL_TEXTURE_2D, 0, GL_R16F, info.imgW, info.imgH, 0, GL_RED, GL_FLOAT, pointer);
            glUniform1i ( userData->samplerLoc, 0 );
        }else if(info.isRGB == GL_FALSE && info.is16F == GL_FALSE && info.isUnsigned == GL_TRUE)
        {
            unsigned char *pointer = (unsigned char *)dataPointer;
            glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, info.imgW, info.imgH, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, pointer);
            glUniform1i ( userData->originSamLoc, 0 );
        }else if(info.isRGB == GL_FALSE && info.is16F == GL_TRUE && info.isUnsigned == GL_TRUE)
        {
            float *pointer = (float *)dataPointer;
            glTexImage2D(GL_TEXTURE_2D, 0, GL_R16F, info.imgW, info.imgH, 0, GL_RED, GL_FLOAT, pointer);
            glUniform1i ( userData->samplerLoc, 0 );
        }
    }
    
    if (info.isLinear == GL_FALSE) {
        glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
        glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
    }else
    {
        glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
        glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    }
    
    // 只允许16位有符号的能调节窗宽窗位
    if (info.is16F == GL_TRUE) {
        glUniform1f(userData->wwLoc, info.windowWidth);
        glUniform1f(userData->wlLoc, info.windowLevel);
        esMatrixMultiply(&(userData->mvpMat), &(userData->modelView), &(userData->projection));
        glUniformMatrix4fv(userData->mvpLoc, 1, GL_FALSE, &(userData->mvpMat).m[0][0]);
        
        glUniform1f(userData->tableNumLoc, info.tableNum);
        
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, userData->colorTableId);
        glUniform1i(userData->colorTableLoc, 1);
        
    }else{
        esMatrixMultiply(&(userData->mvpMat), &(userData->modelView), &(userData->projection));
        glUniformMatrix4fv(userData->originMvpLoc, 1, GL_FALSE, &(userData->mvpMat).m[0][0]);
    }
    
    glBindVertexArray(vaoID);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertIndexID);
    glDrawElements ( GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (GLvoid *)(0));
}

///
// Set up a zoom matrix
//
void CalculateZoomMatrix(ESContext *esContext, UserInfo info, ESMatrix *destMatrix)
{
    
    ESMatrix tempMatrix;
    UserData *userData = esContext->userData;
    esMatrixLoadIdentity(&tempMatrix);
    if (info.isRGB == GL_TRUE) {
        esTranslate(&tempMatrix, info.x, info.y, 0.0f);
        if (info.isDefault == GL_TRUE)
        {
            userData->zoomScale *= info.scale;
            if (userData->zoomScale > 5.0 ) {
                info.scale = 5.0 * info.scale / userData->zoomScale;
                userData->zoomScale = 5.0;
            }else if(userData->zoomScale < 1.0){
                info.scale = 1.0 * info.scale / userData->zoomScale;
                userData->zoomScale = 1.0;
            }
            esScale(&tempMatrix, info.scale, info.scale, 1.0f);
            esTranslate(&tempMatrix, -info.x, -info.y, 0.0f);
        }
    }else{
        esTranslate(&tempMatrix, info.x, -info.y, 0.0f);
        if (info.isDefault == GL_TRUE)
        {
            userData->zoomScale *= info.scale;
            if (userData->zoomScale > 5.0 ) {
                info.scale = 5.0 * info.scale / userData->zoomScale;
                userData->zoomScale = 5.0;
            }else if(userData->zoomScale < 1.0){
                info.scale = 1.0 * info.scale / userData->zoomScale;
                userData->zoomScale = 1.0;
            }
            esScale(&tempMatrix, info.scale, info.scale, 1.0f);
            esTranslate(&tempMatrix, -info.x, info.y, 0.0f);
        }
    }

    
    if(info.rotateAngle != 0.0 && info.rotateAxis != 0) {
        if(info.rotateAxis == 3)
            userData->rotateAngle += info.rotateAngle;
        switch (info.rotateAxis) {
            case 1:
                esRotate(&tempMatrix, info.rotateAngle, 1.0f, 0.0f, 0.0f);
                break;
            case 2:
                esRotate(&tempMatrix, info.rotateAngle, 0.0f, 1.0f, 0.0f);
                break;
            case 3:
                esRotate(&tempMatrix, info.rotateAngle, 0.0f, 0.0f, 1.0f);
                break;
                
            default:
                break;
        }
    }
    

    if (info.newaspect > 0) {
        
        if (info.aspect > 1.0) {
            esScale(&tempMatrix, 1.0, info.aspect, 1.0);
        }else
        {
            esScale(&tempMatrix, 1.0/info.aspect, 1.0, 1.0);
        }
        
        if (info.newaspect > 1.0) {
            esScale(&tempMatrix, 1.0, 1.0/info.newaspect, 1.0);
        }else if (info.newaspect < 1.0){
            esScale(&tempMatrix, info.newaspect, 1.0, 1.0);
        }
    }
   

    esMatrixMultiply(destMatrix, destMatrix, &tempMatrix);
}

///
// Draw a triangle using the shader pair created in Init()
//
void Draw ( ESContext *esContext,UserInfo info, void *dataPointer)
{
    UserData *userData = esContext->userData;
    if (userData->firstInitFBO == 1)
    {
        // Load the frame buffer
        userData->frameBuffer = CreateFBO_fir(esContext->width,esContext->height);
        userData->frameBuffer2 = CreateFBO_sec(esContext->width,esContext->height);
        userData->firstInitFBO = 0;
        
        GLuint width = esContext->width; GLuint height = esContext->height;
        float aspectRatio=width>height?(float)width/(float)height:(float)height/(float)width;
        if(width>height){
            esOrtho(&(userData->projection), -aspectRatio, aspectRatio, -1.f, 1.f, -1.f, 1.f);
        }else{
            esOrtho(&(userData->projection), -1.f,1.f,-aspectRatio,aspectRatio,-1.f,1.f);
        }
    }
    
    CalculateZoomMatrix(esContext, info, &(userData->modelView));
    
    int CurrentFbo;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &CurrentFbo);
    ///////////////////////////////////////////////////////////////////////////////////
    // Render to Texture - empty texture
    ///////////////////////////////////////////////////////////////////////////////////
    if (info.isRGB == GL_TRUE || info.is16F == GL_FALSE)
    {
        glUseProgram ( userData->originPrgObj );
        glViewport ( 0, 0, esContext->width, esContext->height );
        glClearColor(0.0, 0.0, 0.0, 0.0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        renderTexture( esContext, info, dataPointer);
    }
    else if (info.isRGB == GL_FALSE)
    {
        glUseProgram ( userData->programObject );
        glBindFramebuffer(GL_FRAMEBUFFER, userData->frameBuffer);
        glViewport ( 0, 0, esContext->width, esContext->height );
        glClearColor(0.0, 0.0, 0.0, 0.0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        renderTexture( esContext, info, dataPointer);
        ///////////////////////////////////////////////////////////////////////////////////
        // Render to Texture  - horizon
        ///////////////////////////////////////////////////////////////////////////////////
        glUseProgram ( userData->sbprogramObject );
        glBindFramebuffer(GL_FRAMEBUFFER, userData->frameBuffer2);
        glViewport ( 0, 0, esContext->width, esContext->height );
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, empty_textureID);
        glUniform1i(userData->hSamLoc, 1);
        
        glBindVertexArray(plane_vaoID);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, plane_vertIndexID);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (GLvoid *)(0));
        ////////////////////////////////////////////////////////////////////////////////////
        // Render to Screen
        ////////////////////////////////////////////////////////////////////////////////////
        glUseProgram(userData->sxprogramObject);
        glBindFramebuffer(GL_FRAMEBUFFER, CurrentFbo);
        glViewport ( 0, 0, esContext->width, esContext->height );
        glClearColor(0.0, 0.0, 0.0, 0.0);
        glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
        
        glActiveTexture(GL_TEXTURE2);
        glBindTexture(GL_TEXTURE_2D, empty_textureID2);
        glUniform1i(userData->vSamLoc, 2);
        glActiveTexture(GL_TEXTURE3);
        glBindTexture(GL_TEXTURE_2D, empty_textureID);
        glUniform1i(userData->vOriginSamLoc, 3);
        
//        glUniform1f(userData->tableNumLoc, info.tableNum);
//        
//        glActiveTexture(GL_TEXTURE4);
//        glBindTexture(GL_TEXTURE_2D, userData->colorTableId);
//        glUniform1i(userData->colorTableLoc, 4);
        
        glUniform1f(userData->gauScaleLoc, info.gauScale);
        glBindVertexArray(plane_vaoID);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, plane_vertIndexID);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (GLvoid *)(0));
    }
}
///
// Cleanup
//
void ShutDown ( ESContext *esContext )
{
    UserData *userData = esContext->userData;
    // Delete texture object
    glDeleteTextures(1, &empty_textureID);
    glDeleteTextures(1, &empty_textureID2);
    glDeleteTextures(1, &userData->textureId );
    glDeleteTextures(1, &userData->colorTableId);
    // Delete Samples
    glDeleteSamplers(1, &userData->originSamLoc);
    glDeleteSamplers(1, &userData->samplerLoc);
    glDeleteSamplers(1, &userData->hSamLoc);
    glDeleteSamplers(1, &userData->vSamLoc);
    glDeleteSamplers(1, &userData->vOriginSamLoc);
    glDeleteSamplers(1, &userData->colorTableLoc);
    // Delete Frame Buffer Object
    glDeleteFramebuffers(1, &userData->frameBuffer);
    glDeleteFramebuffers(1, &userData->frameBuffer2);
    // Delete program object
    glDeleteProgram(userData->originPrgObj);
    glDeleteProgram(userData->programObject );
    glDeleteProgram(userData->sbprogramObject);
    glDeleteProgram(userData->sxprogramObject);
    // Delete Vertex Array Object
    glDeleteVertexArrays(1, &vaoID);
    glDeleteVertexArrays(1, &plane_vaoID);
}


int esMain (ESContext *esContext , void *data,GLuint width,GLuint height,UserInfo info)
{
    esContext->userData = malloc ( sizeof ( UserData ) );
    
    esCreateWindow ( esContext, "Simple Texture 2D", 320, 480, ES_WINDOW_RGB );
    
    if ( !Init ( esContext, data, width, height, info) )
    {
        return GL_FALSE;
    }
    
    esRegisterDrawFunc(esContext, Draw);
    
    esRegisterShutdownFunc ( esContext, ShutDown );
    return GL_TRUE;
}
