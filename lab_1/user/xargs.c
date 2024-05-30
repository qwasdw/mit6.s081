#include "kernel/types.h"
#include "kernel/param.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("usage: xargs command\n");
        exit(1);
    }
    int buf_size = 512;
    char buf[buf_size];
    int used = 0;
    int end = 0;
    char *xargs[MAXARG];
    for (int i = 1; i < argc; ++i)
    {
        xargs[i - 1] = argv[i];
    }
    while (!end || used != 0)
    {
        if (!end)
        {
            int remain = buf_size - used;
            int n = read(0, buf + used, remain);
            if (n < 0)
            {
                printf("xargs: read error, return:%d\n", n);
                close(0);
                exit(1);
            }
            if (!n)
            {
                close(0);
                end = 1;
            }
            used += n;
        }
        char *line_end = strchr(buf, '\n');
        while (line_end)
        {
            char child_buf[buf_size];
            memcpy(child_buf, buf, line_end - buf);
            child_buf[line_end - buf] = 0;//set end of string
            xargs[argc - 1] = child_buf;
            int pid = fork();
            if (pid < 0)
            {
                printf("xargs: fork error, return:%d\n", pid);
                close(0);
                exit(1);
            }
            else if (pid == 0)
            { // child
                if (exec(argv[1], xargs) < 0)
                {
                    printf("xargs: exec error, return:%d\n", pid);
                    close(0);
                    exit(1);
                }
            }
            else
            { // parent
                used -= line_end - buf + 1;
                memmove(buf, line_end + 1, used);
                memset(buf + used, 0, buf_size - used);
                wait(0);
            }
            line_end = strchr(buf, '\n');
        }
    }
    close(0);
    exit(0);
}
