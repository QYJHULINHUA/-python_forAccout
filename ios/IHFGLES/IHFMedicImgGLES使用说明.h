/*
//
//  IHFMedicImgGLES使用说明.h
//
//  Created by ihefe－hulinhua on 16/3/8.
//  Copyright © 2016年 ihefe_hlh. All rights reserved.
//
 
#param mark ---------------------------------------------------------------
*  Build Settings 中 No Common Blocks 选项设置为 NO
*  加入CoreGraphics.framework                                    gles设置配置
*  加入GLKit.framework
*  加入OpenGLES.framework
#param mark ---------------------------------------------------------------

* ihefeImageLUT.h
   该头文件是伪彩的编码表。表ColorsTable为三维数组，表ColorsTable2为一维数组，两者等效。该头文件会Simple_Texture2D.c中被引用，表ColorsTable2被视为一个纹理传入GPU中，具体实现之后会有解释。表ColorsTable在该模块中未使用
* esShaderStr.h
   该头文件包含绘制图像所需的shader语句。宏定义SHADERSTRING(...) #__VA_ARGS__使得在char数组中写shader语句不需要每行加上双引号以及结尾时加上\n作为换行标识
* esUtil.h和esUtil.c
   一种实用的OpenGL ES的工具库，该库中提供了GLES 3.0中使用到的基本共用框架
* esCreateTexture.h和esCreateTexture.c
   主要包括GLES的用户数据和各种顶点坐标、纹理坐标等。
* esSharpener.h和esSharpener.c
  包含3个函数，第一个函数实现生成一个gauWidth * gauHeight大小的二维高斯核，第二个函数实现生成一个宽度为gauWidth的一维高斯核，第三个函数生成单个高斯权值
* esShader.c、esShapes.c和esTransform.c
  esShader.c中包含加载shader和加载program的方法。esShapes.c包含了创建各种几何形状的方法。esTransform.c中包含矩阵变换的函数实现。这三个文件是封装好的，没有修改的必要
* Simple_Texture2D.c
  GLES的核心实现文件。所有的渲染都在该文件中
* IHFGLESTools.h和IHFGLESTools.m
  该类为MyGLKViewController的工具类，包含各种坐标转换工具函数和图像转换数据指针的函数
* FileWrapper.h和FileWrapper.m
  给定一个文件名，将其转换为mainBundle中可以打开的文件路径。已经弃用
* IHFLinearMeasureView.h和IHFLinearMeasureView.m
  直线测量工具的视图，已经弃用。
* IHFMyGLKViewController+instance.h和IHFMyGLKViewController+instance.m
  从storyboard中加载MyGLKViewController的方法，已经弃用
* UIView+HierarchySupport.h和UIView+HierarchySupport.h
  UIViewController+selfManager.h和UIViewController+selfManager.m
  这两个类拓展实现GLKViewController像View一样添加到别的ViewController子视图中的功能
* IHFMyGLKViewController.h和IHFMyGLKViewController.m
  GLES在iOS上的唯一实现，通过这个特殊的ViewController实现渲染，代码中有较为详细的注释
*/




