//
//  esShaderStr.h
//  Simple_Texture2D
//
//  Created by v.q on 15/12/12.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#ifndef esShaderStr_h
#define esShaderStr_h
#endif /* esShaderStr_h */

#define SHADERSTRING(...) #__VA_ARGS__

static const char originVShaderStr[] = SHADERSTRING(#version 300 es
                                                    layout(location = 0) in vec4 a_position;
                                                    layout(location = 1) in vec2 a_texCoord;
                                                    uniform mat4 mvp;
                                                    out vec2 v_texCoord;
                                                    void main()
                                                    {
                                                        gl_Position = mvp * a_position;
                                                        v_texCoord = a_texCoord;
                                                    });

static const char originFShaderStr[] = SHADERSTRING(#version 300 es
                                                    precision mediump float;
                                                    layout(location = 0) out vec4 outColor;
                                                    uniform sampler2D s_texture;
                                                    in vec2 v_texCoord;
                                                    void main()
                                                    {
                                                        vec2 new_texCoord = vec2(v_texCoord.x,1.0 - v_texCoord.y);
                                                        outColor = texture(s_texture,new_texCoord);
                                                    });

static char vShaderStr[] = SHADERSTRING(#version 300 es
                                        uniform mat4 mvp;
                                        layout(location = 0) in vec4 a_position;
                                        layout(location = 1) in vec2 a_texCoord;
                                        out vec2 v_texCoord;
                                        void main()
                                        {
                                            gl_Position =  mvp * a_position;
                                            v_texCoord = a_texCoord;
                                        }                                          );

static char fShaderStr[] = SHADERSTRING(#version 300 es
                                        precision highp float;
                                        in vec2 v_texCoord;
                                        layout(location = 0) out vec4 outColor;
                                        uniform float windowWidth;
                                        uniform float windowLevel;
                                        uniform sampler2D s_texture;
                                        uniform sampler2D  color_table;
                                        uniform float table_selected;
                                        vec4 AdjustWW_WL(float ww,float wl);
                                        
                                        void main()
                                        {
                                            float p = AdjustWW_WL(windowWidth,windowLevel).x;
                                            outColor = texture(color_table,vec2(p,table_selected/13.0));
                                            //outColor = AdjustWW_WL(windowWidth,windowLevel);
                                        }
                                        
                                        vec4 AdjustWW_WL(float ww,float wl)
                                        {
                                            float delta = 32767.0 ;
                                            float Color = texture( s_texture, v_texCoord ).x;
                                            
                                            float ww0 = ww  ;
                                            float wl0 = wl  ;
                                            float pixel = 0.0;
                                            if (Color < (wl0-ww0*0.5)) {
                                                pixel = 0.0;
                                            }
                                            else if (Color > (wl0+ww0*0.5))
                                            {
                                                pixel = 1.0;
                                            }
                                            else
                                            {
                                                pixel = (Color-wl0+ww0*0.5) / ww0;
                                            }
                                            
                                            return vec4(pixel,pixel,pixel,0.0);
                                        }                                                  );


static char vSbShaderStr[] = SHADERSTRING(#version 300 es
                                          layout(location = 0) in vec4 a_position;
                                          layout(location = 1) in vec2 a_texCoord;
                                          out vec2 v_texCoord;
                                          void main()
                                          {
                                              gl_Position = a_position;
                                              v_texCoord =  a_texCoord;
                                          });


static char  fShaderHorizon[] = SHADERSTRING(#version 300 es
                                             precision highp float;
                                             in vec2 v_texCoord;
                                             layout(location = 0) out vec4 outColor;
                                             uniform sampler2D sb_texture;
                                             uniform vec2 pixelSize;
                                             uniform float PixOffset[5];
                                             uniform float Weight[5]; // Gaussian weights
                                             void main()
                                             {
                                                 float dx = pixelSize.x;
                                                 vec4 sum = texture(sb_texture,v_texCoord);
                                                 for (int i = 1;i < 5;i++)
                                                 {
                                                     sum += texture( sb_texture, v_texCoord + vec2(PixOffset[i],0.0) * dx ) * Weight[i];
                                                     sum += texture( sb_texture, v_texCoord - vec2(PixOffset[i],0.0) * dx ) * Weight[i];
                                                 }
                                                 outColor = sum;
                                             }                                                                                  );

static char vSxShaderStr[] = SHADERSTRING(#version 300 es
                                          layout(location = 0) in vec4 a_position;
                                          layout(location = 1) in vec2 a_texCoord;
                                          out vec2 v_texCoord;
                                          void main()
                                          {
                                              gl_Position = a_position;
                                              v_texCoord =  vec2( a_texCoord.x , 1.0 - a_texCoord.y);
                                          });

static char  fShaderVertical[] = SHADERSTRING(#version 300 es
                                              precision highp float;
                                              in vec2 v_texCoord;
                                              layout(location = 0) out vec4 outColor;
                                              uniform sampler2D sb_texture;
                                              uniform sampler2D sx_texture;
                                              //uniform sampler2D  color_table;
                                              uniform vec2 pixelSize;
                                              uniform float PixOffset[5];
                                              uniform float Weight[5];
                                              uniform float gauss_scale;
                                              //uniform float table_selected;
                                              vec4 VerticalBlur();
                                              vec4 USMSharpen();
                                              void main()
                                              {
                                                  outColor = USMSharpen();
                                                  //outColor = texture(color_table,vec2(shar,table_selected/13.0));
//                                                  outColor = USMSharpen();
                                                  //vec4 sum = texture(sx_texture,v_texCoord);
                                                  //                                                 for (int i = 1;i < 5;i++)
                                                  //                                                 {
                                                  //                                                     sum += texture( sb_texture, v_texCoord + vec2(PixOffset[i],0.0) * dx ) * Weight[i];
                                                  //                                                     sum += texture( sb_texture, v_texCoord - vec2(PixOffset[i],0.0) * dx ) * Weight[i];
                                                  //                                                 }
                                                  //outColor = sum;

                                              }
                                              vec4 VerticalBlur()
                                              {
                                                  float dy = pixelSize.y;
                                                  vec4 sum = texture(sx_texture, v_texCoord) * Weight[0];
                                                  for( int i = 1; i < 5; i++ ) // Loop 4 times
                                                  {
                                                      sum += texture( sx_texture, v_texCoord + vec2(0.0,PixOffset[i]) * dy ) * Weight[i];
                                                      sum += texture( sx_texture, v_texCoord - vec2(0.0,PixOffset[i]) * dy ) * Weight[i];
                                                  }
                                                  return sum;
                                              }
                                              vec4 USMSharpen()
                                              {
                                                  vec4 blurColor = VerticalBlur();
                                                  vec4 pre_color = texture( sb_texture, vec2(v_texCoord.x,1.0 - v_texCoord.y));
                                                  vec4 pre_sharpen = abs(pre_color - blurColor.x);
                                                  vec4 sharpen = pre_color + 5.0 * gauss_scale * pre_sharpen;
                                                  return sharpen;
                                              }                                                                         );