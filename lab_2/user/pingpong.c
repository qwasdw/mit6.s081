#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    int pipe_ping[2], pipe_pong[2];
    pipe(pipe_ping);
    pipe(pipe_pong);
    char buf[] = {'p'};
    int pid;
    if (fork() == 0)
    {
        pid = getpid();
        close(pipe_ping[1]);
        close(pipe_pong[0]);
        read(pipe_ping[0], buf, 1);
        printf("%d: received ping\n", pid);
        write(pipe_pong[1], buf, 1);
        exit(0);
    }
    else
    {
        pid = getpid();
        close(pipe_ping[0]);
        close(pipe_pong[1]);
        write(pipe_ping[1], buf, 1);
        read(pipe_pong[0], buf, 1);
        printf("%d: received pong\n", pid);
        exit(0);
    }
    exit(0);
}
