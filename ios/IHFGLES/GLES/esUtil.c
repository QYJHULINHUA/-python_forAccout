///
//  Includes
//
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "esUtil.h"

#ifdef ANDROID
#include <android/log.h>
#include <android_native_app_glue.h>
#include <android/asset_manager.h>
typedef AAsset esFile;
#else
typedef FILE esFile;
#endif

#ifdef __APPLE__
#include "FileWrapper.h"
#endif

///
//  Macros
//
#define INVERTED_BIT            (1 << 5)

///
//  Types
//
#ifndef __APPLE__
#pragma pack(push,x1)                            // Byte alignment (8-bit)
#pragma pack(1)
#endif

typedef struct
#ifdef __APPLE__
__attribute__ ( ( packed ) )
#endif
{
   unsigned char  IdSize,
            MapType,
            ImageType;
   unsigned short PaletteStart,
            PaletteSize;
   unsigned char  PaletteEntryDepth;
   unsigned short X,
            Y,
            Width,
            Height;
   unsigned char  ColorDepth,
            Descriptor;

} TGA_HEADER;

#ifndef __APPLE__
#pragma pack(pop,x1)
#endif

#ifndef __APPLE__

///
// GetContextRenderableType()
//
//    Check whether EGL_KHR_create_context extension is supported.  If so,
//    return EGL_OPENGL_ES3_BIT_KHR instead of EGL_OPENGL_ES2_BIT
//
EGLint GetContextRenderableType ( EGLDisplay eglDisplay )
{
#ifdef EGL_KHR_create_context
   const char *extensions = eglQueryString ( eglDisplay, EGL_EXTENSIONS );

   // check whether EGL_KHR_create_context is in the extension string
   if ( extensions != NULL && strstr( extensions, "EGL_KHR_create_context" ) )
   {
      // extension is supported
      return EGL_OPENGL_ES3_BIT_KHR;
   }
#endif
   // extension is not supported
   return EGL_OPENGL_ES2_BIT;
}
#endif

//////////////////////////////////////////////////////////////////
//
//  Public Functions
//
//

///
//  esCreateWindow()
//
//      title - name for title bar of window
//      width - width of window to create
//      height - height of window to create
//      flags  - bitwise or of window creation flags
//          ES_WINDOW_ALPHA       - specifies that the framebuffer should have alpha
//          ES_WINDOW_DEPTH       - specifies that a depth buffer should be created
//          ES_WINDOW_STENCIL     - specifies that a stencil buffer should be created
//          ES_WINDOW_MULTISAMPLE - specifies that a multi-sample buffer should be created
//
GLboolean ESUTIL_API esCreateWindow ( ESContext *esContext, const char *title, GLint width, GLint height, GLuint flags )
{
#ifndef __APPLE__
   EGLConfig config;
   EGLint majorVersion;
   EGLint minorVersion;
   EGLint contextAttribs[] = { EGL_CONTEXT_CLIENT_VERSION, 3, EGL_NONE };

   if ( esContext == NULL )
   {
      return GL_FALSE;
   }

#ifdef ANDROID
   // For Android, get the width/height from the window rather than what the
   // application requested.
   esContext->width = ANativeWindow_getWidth ( esContext->eglNativeWindow );
   esContext->height = ANativeWindow_getHeight ( esContext->eglNativeWindow );
#else
   esContext->width = width;
   esContext->height = height;
#endif

   if ( !WinCreate ( esContext, title ) )
   {
      return GL_FALSE;
   }

   esContext->eglDisplay = eglGetDisplay( esContext->eglNativeDisplay );
   if ( esContext->eglDisplay == EGL_NO_DISPLAY )
   {
      return GL_FALSE;
   }

   // Initialize EGL
   if ( !eglInitialize ( esContext->eglDisplay, &majorVersion, &minorVersion ) )
   {
      return GL_FALSE;
   }

   {
      EGLint numConfigs = 0;
      EGLint attribList[] =
      {
         EGL_RED_SIZE,       5,
         EGL_GREEN_SIZE,     6,
         EGL_BLUE_SIZE,      5,
         EGL_ALPHA_SIZE,     ( flags & ES_WINDOW_ALPHA ) ? 8 : EGL_DONT_CARE,
         EGL_DEPTH_SIZE,     ( flags & ES_WINDOW_DEPTH ) ? 8 : EGL_DONT_CARE,
         EGL_STENCIL_SIZE,   ( flags & ES_WINDOW_STENCIL ) ? 8 : EGL_DONT_CARE,
         EGL_SAMPLE_BUFFERS, ( flags & ES_WINDOW_MULTISAMPLE ) ? 1 : 0,
         // if EGL_KHR_create_context extension is supported, then we will use
         // EGL_OPENGL_ES3_BIT_KHR instead of EGL_OPENGL_ES2_BIT in the attribute list
         EGL_RENDERABLE_TYPE, GetContextRenderableType ( esContext->eglDisplay ),
         EGL_NONE
      };

      // Choose config
      if ( !eglChooseConfig ( esContext->eglDisplay, attribList, &config, 1, &numConfigs ) )
      {
         return GL_FALSE;
      }

      if ( numConfigs < 1 )
      {
         return GL_FALSE;
      }
   }


#ifdef ANDROID
   // For Android, need to get the EGL_NATIVE_VISUAL_ID and set it using ANativeWindow_setBuffersGeometry
   {
      EGLint format = 0;
      eglGetConfigAttrib ( esContext->eglDisplay, config, EGL_NATIVE_VISUAL_ID, &format );
      ANativeWindow_setBuffersGeometry ( esContext->eglNativeWindow, 0, 0, format );
   }
#endif // ANDROID

   // Create a surface
   esContext->eglSurface = eglCreateWindowSurface ( esContext->eglDisplay, config, 
                                                    esContext->eglNativeWindow, NULL );

   if ( esContext->eglSurface == EGL_NO_SURFACE )
   {
      return GL_FALSE;
   }

   // Create a GL context
   esContext->eglContext = eglCreateContext ( esContext->eglDisplay, config, 
                                              EGL_NO_CONTEXT, contextAttribs );

   if ( esContext->eglContext == EGL_NO_CONTEXT )
   {
      return GL_FALSE;
   }

   // Make the context current
   if ( !eglMakeCurrent ( esContext->eglDisplay, esContext->eglSurface, 
                          esContext->eglSurface, esContext->eglContext ) )
   {
      return GL_FALSE;
   }

#endif // #ifndef __APPLE__

   return GL_TRUE;
}

///
//  esRegisterDrawFunc()
//
void ESUTIL_API esRegisterDrawFunc ( ESContext *esContext, void ( ESCALLBACK *drawFunc ) ( ESContext *, UserInfo, void *) )
{
   esContext->drawFunc = drawFunc;
}

///
//  esRegisterShutdownFunc()
//
void ESUTIL_API esRegisterShutdownFunc ( ESContext *esContext, void ( ESCALLBACK *shutdownFunc ) ( ESContext * ) )
{
   esContext->shutdownFunc = shutdownFunc;
}

///
//  esRegisterUpdateFunc()
//
void ESUTIL_API esRegisterUpdateFunc ( ESContext *esContext, void ( ESCALLBACK *updateFunc ) ( ESContext *, float ) )
{
   esContext->updateFunc = updateFunc;
}


///
//  esRegisterKeyFunc()
//
void ESUTIL_API esRegisterKeyFunc ( ESContext *esContext,
                                    void ( ESCALLBACK *keyFunc ) ( ESContext *, unsigned char, int, int ) )
{
   esContext->keyFunc = keyFunc;
}


///
// esLogMessage()
//
//    Log an error message to the debug output for the platform
//
void ESUTIL_API esLogMessage ( const char *formatStr, ... )
{
   va_list params;
   char buf[BUFSIZ];

   va_start ( params, formatStr );
   vsprintf ( buf, formatStr, params );

#ifdef ANDROID
   __android_log_print ( ANDROID_LOG_INFO, "esUtil" , "%s", buf );
#else
   printf ( "%s", buf );
#endif

   va_end ( params );
}

///
// esFileRead()
//
//    Wrapper for platform specific File open
//
static esFile *esFileOpen ( void *ioContext, const char *fileName )
{
   esFile *pFile = NULL;

#ifdef ANDROID

   if ( ioContext != NULL )
   {
      AAssetManager *assetManager = ( AAssetManager * ) ioContext;
      pFile = AAssetManager_open ( assetManager, fileName, AASSET_MODE_BUFFER );
   }

#else
#ifdef __APPLE__
   // iOS: Remap the filename to a path that can be opened from the bundle.
   fileName = GetBundleFileName ( fileName );
#endif

   pFile = fopen ( fileName, "rb" );
#endif

   return pFile;
}

///
// esFileRead()
//
//    Wrapper for platform specific File close
//
static void esFileClose ( esFile *pFile )
{
   if ( pFile != NULL )
   {
#ifdef ANDROID
      AAsset_close ( pFile );
#else
      fclose ( pFile );
      pFile = NULL;
#endif
   }
}

///
// esFileRead()
//
//    Wrapper for platform specific File read
//
static int esFileRead ( esFile *pFile, int bytesToRead, void *buffer )
{
   int bytesRead = 0;

   if ( pFile == NULL )
   {
      return bytesRead;
   }

#ifdef ANDROID
   bytesRead = AAsset_read ( pFile, buffer, bytesToRead );
#else
   bytesRead = (int)fread ( buffer, bytesToRead, 1, pFile );
#endif

   return bytesRead;
}

///
// esLoadTGA()
//
//    Loads a 8-bit, 24-bit or 32-bit TGA image from a file
//
char *ESUTIL_API esLoadTGA ( void *ioContext, const char *fileName, int *width, int *height )
{
   char        *buffer;
   esFile      *fp;
   TGA_HEADER   Header;
   int          bytesRead;

   // Open the file for reading
   fp = esFileOpen ( ioContext, fileName );

   if ( fp == NULL )
   {
      // Log error as 'error in opening the input file from apk'
      esLogMessage ( "esLoadTGA FAILED to load : { %s }\n", fileName );
      return NULL;
   }

   bytesRead = esFileRead ( fp, sizeof ( TGA_HEADER ), &Header );

   *width = Header.Width;
   *height = Header.Height;

   if ( Header.ColorDepth == 8 ||
         Header.ColorDepth == 24 || Header.ColorDepth == 32 )
   {
      int bytesToRead = sizeof ( char ) * ( *width ) * ( *height ) * Header.ColorDepth / 8;

      // Allocate the image data buffer
      buffer = ( char * ) malloc ( bytesToRead );

      if ( buffer )
      {
         bytesRead = esFileRead ( fp, bytesToRead, buffer );
         esFileClose ( fp );

         return ( buffer );
      }
   }

   return ( NULL );
}

int MatrixInverse(float a[], int n)     // **************** 矩阵求逆 ******************
{
    int *is,*js,i,j,k,l,u,v;
    float d,p;
    is = (int *)malloc(n*sizeof(int));
    js = (int *)malloc(n*sizeof(int));
    for (int index = 0; index < n; index++) {
        is[index] = -1;
        js[index] = -1;
    }
    for (k=0; k<=n-1; k++)
    {
        d=0.0;
        for (i=k; i<=n-1; i++)
        {
            for (j=k; j<=n-1; j++)
            {
                l=i*n+j;
                p=fabs(a[l]);
                if (p>d)    //记录绝对值最大的元素位置
                {
                    d=p;
                    is[k]=i;
                    js[k]=j;
                }
            }
        }
        if (d+1.0 == 1.0)   //矩阵元素合法性检查
        {
            free(is);
            free(js);
            printf("error: matrix is not inverse!\n");
            return(0);
        }
        if (is[k] != k)    //绝对值最大元素不在k行
        {
            for (j=0; j<=n-1; j++)
            {
                u=k*n+j;
                v=is[k]*n+j;
                p=a[u];    //行元素交换
                a[u]=a[v];
                a[v]=p;
            }
        }
        if (js[k]!=k)    //绝对值最大元素不在k列
        {
            for (i=0; i<=n-1; i++)
            {
                u=i*n+k;
                v=i*n+js[k];
                p=a[u];    //列元素交换
                a[u]=a[v];
                a[v]=p;
            }
        }
        
        l=k*n+k;      //对角线元素
        a[l]=1.0/a[l];
        for (j=0; j<=n-1; j++)
        {
            if (j != k)     //所在行操作
            {
                u = k*n+j;
                a[u] = a[u]*a[l];
            }
        }
        for (i=0; i<=n-1; i++)   //除去该对角线元素外其余元素的变换
        {
            if (i!=k)
            {
                for (j=0; j<=n-1; j++)
                {
                    if (j!=k)
                    {
                        u = i*n+j;
                        a[u] = a[u]-a[i*n+k]*a[k*n+j];
                    }
                }
            }
        }
        for (i=0; i<=n-1; i++)   //所在列操作
        {
            if (i != k)
            {
                u = i*n+k;
                a[u] = -a[u]*a[l];
            }
        }
    }
    
    for (k=n-1; k>=0; k--)   //恢复，先交换的行（列）后恢复
    {
        if (js[k]!=k)
        {
            for (j=0; j<=n-1; j++)
            {
                u=k*n+j;
                v=js[k]*n+j;
                p=a[u];
                a[u]=a[v];
                a[v]=p;
            }
        }
        if (is[k]!=k)
        {
            for (i=0; i<=n-1; i++)
            {
                u=i*n+k;
                v=i*n+is[k];
                p=a[u];
                a[u]=a[v];
                a[v]=p;
            }
        }
    }
    free(is);
    free(js);
    return(1);
}
