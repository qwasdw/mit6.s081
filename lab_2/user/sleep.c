#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("Usage: sleep [seconds]\n");
        exit(0);
    }
    int seconds = atoi(argv[1]);
    int ret = sleep(seconds);
    exit(ret);
}
