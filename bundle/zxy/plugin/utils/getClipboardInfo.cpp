#include <windows.h>
#include <shlobj.h>
#include <stdio.h>
int main ()
{
    UINT CF_PREFERREDDROPEFFECT = RegisterClipboardFormat(CFSTR_PREFERREDDROPEFFECT);
    if(!IsClipboardFormatAvailable(CF_PREFERREDDROPEFFECT))
    {
        return 1;
    }

    if ( OpenClipboard(NULL) )
    {
        HDROP hDrop = HDROP(GetClipboardData(CF_HDROP));
        if (hDrop)
        {
            TCHAR szBuffer[MAX_PATH*4];
            szBuffer[0] = 0;
            HANDLE hglb = GetClipboardData(CF_PREFERREDDROPEFFECT);
            DWORD dwEffect=*(DWORD*)GlobalLock(hglb);
            if(dwEffect & DROPEFFECT_COPY)
            {
                strcat(szBuffer, "copy");
            }
            else if(dwEffect & DROPEFFECT_MOVE)
            {
                strcat(szBuffer, "cut");
            }
            else
            {
                strcat(szBuffer, "unknown");
            }
            GlobalUnlock(hglb);

            UINT cFiles = DragQueryFile(hDrop,(UINT)-1,NULL,0);
            TCHAR szFile[MAX_PATH];
            for (UINT count = 0; count < cFiles; count++)
            {
                DragQueryFile(hDrop,count,szFile,sizeof(szFile));
                strcat(szBuffer,TEXT("?"));
                strcat(szBuffer, szFile);
            }
            printf("%s", szBuffer);

            CloseClipboard();
        }

    }

    return 0 ;
}
