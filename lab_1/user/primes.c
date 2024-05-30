#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void prime(int fd)
{
    int num;
    int ret = read(fd, &num, sizeof(int));
    if (ret < 0)
    {
        printf("read failed\n");
        close(fd);
        exit(1);
    }
    else if (ret == 0)
    { // no more data
        close(fd);
        exit(0);
    }
    else
    {
        printf("prime %d\n", num);
    }
    int pipe_next[2];
    pipe(pipe_next);
    int pid = fork();
    int cur_num = num;
    if (pid < 0)
    {
        printf("fork failed\n");
        close(fd);
        close(pipe_next[0]);
        close(pipe_next[1]);
        exit(1);
    }
    else if (pid > 0)
    { // parent
        close(pipe_next[0]);
        while (read(fd, &num, sizeof(int)) > 0)
        {
            if (num % cur_num != 0)
            {
                write(pipe_next[1], &num, sizeof(int));
            }
        }
        close(fd);
        close(pipe_next[1]);
        wait(0);
        exit(0);
    }
    else
    { // child
        close(fd);
        close(pipe_next[1]);
        prime(pipe_next[0]);
        close(pipe_next[0]);
        exit(0);
    }
}

int main(int argc, char *argv[])
{
    int pipe_num[2];
    pipe(pipe_num);
    for (int i = 2; i <= 35; ++i)
    {
        write(pipe_num[1], &i, sizeof(i));
    }
    int pid = fork();
    if (pid < 0)
    {
        printf("fork failed\n");
        close(pipe_num[0]);
        close(pipe_num[1]);
        exit(1);
    }
    else if (pid > 0)
    { // parent
        close(pipe_num[0]);
        close(pipe_num[1]);
        wait(0);
        exit(0);
    }
    else
    { // child
        close(pipe_num[1]);
        prime(pipe_num[0]);
        close(pipe_num[0]);
        wait(0);
        exit(0);
    }
    exit(0);
}
