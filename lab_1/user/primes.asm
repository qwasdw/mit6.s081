
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <prime>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void prime(int fd)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	add	s0,sp,48
   a:	84aa                	mv	s1,a0
    int num;
    int ret = read(fd, &num, sizeof(int));
   c:	4611                	li	a2,4
   e:	fdc40593          	add	a1,s0,-36
  12:	00000097          	auipc	ra,0x0
  16:	494080e7          	jalr	1172(ra) # 4a6 <read>
    if (ret < 0)
  1a:	00054e63          	bltz	a0,36 <prime+0x36>
    {
        printf("read failed\n");
        close(fd);
        exit(1);
    }
    else if (ret == 0)
  1e:	ed1d                	bnez	a0,5c <prime+0x5c>
  20:	e84a                	sd	s2,16(sp)
    { // no more data
        close(fd);
  22:	8526                	mv	a0,s1
  24:	00000097          	auipc	ra,0x0
  28:	492080e7          	jalr	1170(ra) # 4b6 <close>
        exit(0);
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	460080e7          	jalr	1120(ra) # 48e <exit>
  36:	e84a                	sd	s2,16(sp)
        printf("read failed\n");
  38:	00001517          	auipc	a0,0x1
  3c:	97850513          	add	a0,a0,-1672 # 9b0 <malloc+0x102>
  40:	00000097          	auipc	ra,0x0
  44:	7b6080e7          	jalr	1974(ra) # 7f6 <printf>
        close(fd);
  48:	8526                	mv	a0,s1
  4a:	00000097          	auipc	ra,0x0
  4e:	46c080e7          	jalr	1132(ra) # 4b6 <close>
        exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	43a080e7          	jalr	1082(ra) # 48e <exit>
  5c:	e84a                	sd	s2,16(sp)
    }
    else
    {
        printf("prime %d\n", num);
  5e:	fdc42583          	lw	a1,-36(s0)
  62:	00001517          	auipc	a0,0x1
  66:	96650513          	add	a0,a0,-1690 # 9c8 <malloc+0x11a>
  6a:	00000097          	auipc	ra,0x0
  6e:	78c080e7          	jalr	1932(ra) # 7f6 <printf>
    }
    int pipe_next[2];
    pipe(pipe_next);
  72:	fd040513          	add	a0,s0,-48
  76:	00000097          	auipc	ra,0x0
  7a:	428080e7          	jalr	1064(ra) # 49e <pipe>
    int pid = fork();
  7e:	00000097          	auipc	ra,0x0
  82:	408080e7          	jalr	1032(ra) # 486 <fork>
    int cur_num = num;
  86:	fdc42903          	lw	s2,-36(s0)
    if (pid < 0)
  8a:	04054363          	bltz	a0,d0 <prime+0xd0>
        close(fd);
        close(pipe_next[0]);
        close(pipe_next[1]);
        exit(1);
    }
    else if (pid > 0)
  8e:	0aa05463          	blez	a0,136 <prime+0x136>
    { // parent
        close(pipe_next[0]);
  92:	fd042503          	lw	a0,-48(s0)
  96:	00000097          	auipc	ra,0x0
  9a:	420080e7          	jalr	1056(ra) # 4b6 <close>
        while (read(fd, &num, sizeof(int)) > 0)
  9e:	4611                	li	a2,4
  a0:	fdc40593          	add	a1,s0,-36
  a4:	8526                	mv	a0,s1
  a6:	00000097          	auipc	ra,0x0
  aa:	400080e7          	jalr	1024(ra) # 4a6 <read>
  ae:	04a05f63          	blez	a0,10c <prime+0x10c>
        {
            if (num % cur_num != 0)
  b2:	fdc42783          	lw	a5,-36(s0)
  b6:	0327e7bb          	remw	a5,a5,s2
  ba:	d3f5                	beqz	a5,9e <prime+0x9e>
            {
                write(pipe_next[1], &num, sizeof(int));
  bc:	4611                	li	a2,4
  be:	fdc40593          	add	a1,s0,-36
  c2:	fd442503          	lw	a0,-44(s0)
  c6:	00000097          	auipc	ra,0x0
  ca:	3e8080e7          	jalr	1000(ra) # 4ae <write>
  ce:	bfc1                	j	9e <prime+0x9e>
        printf("fork failed\n");
  d0:	00001517          	auipc	a0,0x1
  d4:	90850513          	add	a0,a0,-1784 # 9d8 <malloc+0x12a>
  d8:	00000097          	auipc	ra,0x0
  dc:	71e080e7          	jalr	1822(ra) # 7f6 <printf>
        close(fd);
  e0:	8526                	mv	a0,s1
  e2:	00000097          	auipc	ra,0x0
  e6:	3d4080e7          	jalr	980(ra) # 4b6 <close>
        close(pipe_next[0]);
  ea:	fd042503          	lw	a0,-48(s0)
  ee:	00000097          	auipc	ra,0x0
  f2:	3c8080e7          	jalr	968(ra) # 4b6 <close>
        close(pipe_next[1]);
  f6:	fd442503          	lw	a0,-44(s0)
  fa:	00000097          	auipc	ra,0x0
  fe:	3bc080e7          	jalr	956(ra) # 4b6 <close>
        exit(1);
 102:	4505                	li	a0,1
 104:	00000097          	auipc	ra,0x0
 108:	38a080e7          	jalr	906(ra) # 48e <exit>
            }
        }
        close(fd);
 10c:	8526                	mv	a0,s1
 10e:	00000097          	auipc	ra,0x0
 112:	3a8080e7          	jalr	936(ra) # 4b6 <close>
        close(pipe_next[1]);
 116:	fd442503          	lw	a0,-44(s0)
 11a:	00000097          	auipc	ra,0x0
 11e:	39c080e7          	jalr	924(ra) # 4b6 <close>
        wait(0);
 122:	4501                	li	a0,0
 124:	00000097          	auipc	ra,0x0
 128:	372080e7          	jalr	882(ra) # 496 <wait>
        exit(0);
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	360080e7          	jalr	864(ra) # 48e <exit>
    }
    else
    { // child
        close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	37e080e7          	jalr	894(ra) # 4b6 <close>
        close(pipe_next[1]);
 140:	fd442503          	lw	a0,-44(s0)
 144:	00000097          	auipc	ra,0x0
 148:	372080e7          	jalr	882(ra) # 4b6 <close>
        prime(pipe_next[0]);
 14c:	fd042503          	lw	a0,-48(s0)
 150:	00000097          	auipc	ra,0x0
 154:	eb0080e7          	jalr	-336(ra) # 0 <prime>

0000000000000158 <main>:
        exit(0);
    }
}

int main(int argc, char *argv[])
{
 158:	7179                	add	sp,sp,-48
 15a:	f406                	sd	ra,40(sp)
 15c:	f022                	sd	s0,32(sp)
 15e:	ec26                	sd	s1,24(sp)
 160:	1800                	add	s0,sp,48
    int pipe_num[2];
    pipe(pipe_num);
 162:	fd840513          	add	a0,s0,-40
 166:	00000097          	auipc	ra,0x0
 16a:	338080e7          	jalr	824(ra) # 49e <pipe>
    for (int i = 2; i <= 35; ++i)
 16e:	4789                	li	a5,2
 170:	fcf42a23          	sw	a5,-44(s0)
 174:	02300493          	li	s1,35
    {
        write(pipe_num[1], &i, sizeof(i));
 178:	4611                	li	a2,4
 17a:	fd440593          	add	a1,s0,-44
 17e:	fdc42503          	lw	a0,-36(s0)
 182:	00000097          	auipc	ra,0x0
 186:	32c080e7          	jalr	812(ra) # 4ae <write>
    for (int i = 2; i <= 35; ++i)
 18a:	fd442783          	lw	a5,-44(s0)
 18e:	2785                	addw	a5,a5,1
 190:	0007871b          	sext.w	a4,a5
 194:	fcf42a23          	sw	a5,-44(s0)
 198:	fee4d0e3          	bge	s1,a4,178 <main+0x20>
    }
    int pid = fork();
 19c:	00000097          	auipc	ra,0x0
 1a0:	2ea080e7          	jalr	746(ra) # 486 <fork>
    if (pid < 0)
 1a4:	02054a63          	bltz	a0,1d8 <main+0x80>
        printf("fork failed\n");
        close(pipe_num[0]);
        close(pipe_num[1]);
        exit(1);
    }
    else if (pid > 0)
 1a8:	06a05163          	blez	a0,20a <main+0xb2>
    { // parent
        close(pipe_num[0]);
 1ac:	fd842503          	lw	a0,-40(s0)
 1b0:	00000097          	auipc	ra,0x0
 1b4:	306080e7          	jalr	774(ra) # 4b6 <close>
        close(pipe_num[1]);
 1b8:	fdc42503          	lw	a0,-36(s0)
 1bc:	00000097          	auipc	ra,0x0
 1c0:	2fa080e7          	jalr	762(ra) # 4b6 <close>
        wait(0);
 1c4:	4501                	li	a0,0
 1c6:	00000097          	auipc	ra,0x0
 1ca:	2d0080e7          	jalr	720(ra) # 496 <wait>
        exit(0);
 1ce:	4501                	li	a0,0
 1d0:	00000097          	auipc	ra,0x0
 1d4:	2be080e7          	jalr	702(ra) # 48e <exit>
        printf("fork failed\n");
 1d8:	00001517          	auipc	a0,0x1
 1dc:	80050513          	add	a0,a0,-2048 # 9d8 <malloc+0x12a>
 1e0:	00000097          	auipc	ra,0x0
 1e4:	616080e7          	jalr	1558(ra) # 7f6 <printf>
        close(pipe_num[0]);
 1e8:	fd842503          	lw	a0,-40(s0)
 1ec:	00000097          	auipc	ra,0x0
 1f0:	2ca080e7          	jalr	714(ra) # 4b6 <close>
        close(pipe_num[1]);
 1f4:	fdc42503          	lw	a0,-36(s0)
 1f8:	00000097          	auipc	ra,0x0
 1fc:	2be080e7          	jalr	702(ra) # 4b6 <close>
        exit(1);
 200:	4505                	li	a0,1
 202:	00000097          	auipc	ra,0x0
 206:	28c080e7          	jalr	652(ra) # 48e <exit>
    }
    else
    { // child
        close(pipe_num[1]);
 20a:	fdc42503          	lw	a0,-36(s0)
 20e:	00000097          	auipc	ra,0x0
 212:	2a8080e7          	jalr	680(ra) # 4b6 <close>
        prime(pipe_num[0]);
 216:	fd842503          	lw	a0,-40(s0)
 21a:	00000097          	auipc	ra,0x0
 21e:	de6080e7          	jalr	-538(ra) # 0 <prime>

0000000000000222 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 222:	1141                	add	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 228:	87aa                	mv	a5,a0
 22a:	0585                	add	a1,a1,1
 22c:	0785                	add	a5,a5,1
 22e:	fff5c703          	lbu	a4,-1(a1)
 232:	fee78fa3          	sb	a4,-1(a5)
 236:	fb75                	bnez	a4,22a <strcpy+0x8>
    ;
  return os;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	add	sp,sp,16
 23c:	8082                	ret

000000000000023e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 23e:	1141                	add	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 244:	00054783          	lbu	a5,0(a0)
 248:	cb91                	beqz	a5,25c <strcmp+0x1e>
 24a:	0005c703          	lbu	a4,0(a1)
 24e:	00f71763          	bne	a4,a5,25c <strcmp+0x1e>
    p++, q++;
 252:	0505                	add	a0,a0,1
 254:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 256:	00054783          	lbu	a5,0(a0)
 25a:	fbe5                	bnez	a5,24a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 25c:	0005c503          	lbu	a0,0(a1)
}
 260:	40a7853b          	subw	a0,a5,a0
 264:	6422                	ld	s0,8(sp)
 266:	0141                	add	sp,sp,16
 268:	8082                	ret

000000000000026a <strlen>:

uint
strlen(const char *s)
{
 26a:	1141                	add	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 270:	00054783          	lbu	a5,0(a0)
 274:	cf91                	beqz	a5,290 <strlen+0x26>
 276:	0505                	add	a0,a0,1
 278:	87aa                	mv	a5,a0
 27a:	86be                	mv	a3,a5
 27c:	0785                	add	a5,a5,1
 27e:	fff7c703          	lbu	a4,-1(a5)
 282:	ff65                	bnez	a4,27a <strlen+0x10>
 284:	40a6853b          	subw	a0,a3,a0
 288:	2505                	addw	a0,a0,1
    ;
  return n;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	add	sp,sp,16
 28e:	8082                	ret
  for(n = 0; s[n]; n++)
 290:	4501                	li	a0,0
 292:	bfe5                	j	28a <strlen+0x20>

0000000000000294 <memset>:

void*
memset(void *dst, int c, uint n)
{
 294:	1141                	add	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 29a:	ca19                	beqz	a2,2b0 <memset+0x1c>
 29c:	87aa                	mv	a5,a0
 29e:	1602                	sll	a2,a2,0x20
 2a0:	9201                	srl	a2,a2,0x20
 2a2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2aa:	0785                	add	a5,a5,1
 2ac:	fee79de3          	bne	a5,a4,2a6 <memset+0x12>
  }
  return dst;
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	add	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <strchr>:

char*
strchr(const char *s, char c)
{
 2b6:	1141                	add	sp,sp,-16
 2b8:	e422                	sd	s0,8(sp)
 2ba:	0800                	add	s0,sp,16
  for(; *s; s++)
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	cb99                	beqz	a5,2d6 <strchr+0x20>
    if(*s == c)
 2c2:	00f58763          	beq	a1,a5,2d0 <strchr+0x1a>
  for(; *s; s++)
 2c6:	0505                	add	a0,a0,1
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	fbfd                	bnez	a5,2c2 <strchr+0xc>
      return (char*)s;
  return 0;
 2ce:	4501                	li	a0,0
}
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	add	sp,sp,16
 2d4:	8082                	ret
  return 0;
 2d6:	4501                	li	a0,0
 2d8:	bfe5                	j	2d0 <strchr+0x1a>

00000000000002da <gets>:

char*
gets(char *buf, int max)
{
 2da:	711d                	add	sp,sp,-96
 2dc:	ec86                	sd	ra,88(sp)
 2de:	e8a2                	sd	s0,80(sp)
 2e0:	e4a6                	sd	s1,72(sp)
 2e2:	e0ca                	sd	s2,64(sp)
 2e4:	fc4e                	sd	s3,56(sp)
 2e6:	f852                	sd	s4,48(sp)
 2e8:	f456                	sd	s5,40(sp)
 2ea:	f05a                	sd	s6,32(sp)
 2ec:	ec5e                	sd	s7,24(sp)
 2ee:	1080                	add	s0,sp,96
 2f0:	8baa                	mv	s7,a0
 2f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f4:	892a                	mv	s2,a0
 2f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2f8:	4aa9                	li	s5,10
 2fa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2fc:	89a6                	mv	s3,s1
 2fe:	2485                	addw	s1,s1,1
 300:	0344d863          	bge	s1,s4,330 <gets+0x56>
    cc = read(0, &c, 1);
 304:	4605                	li	a2,1
 306:	faf40593          	add	a1,s0,-81
 30a:	4501                	li	a0,0
 30c:	00000097          	auipc	ra,0x0
 310:	19a080e7          	jalr	410(ra) # 4a6 <read>
    if(cc < 1)
 314:	00a05e63          	blez	a0,330 <gets+0x56>
    buf[i++] = c;
 318:	faf44783          	lbu	a5,-81(s0)
 31c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 320:	01578763          	beq	a5,s5,32e <gets+0x54>
 324:	0905                	add	s2,s2,1
 326:	fd679be3          	bne	a5,s6,2fc <gets+0x22>
    buf[i++] = c;
 32a:	89a6                	mv	s3,s1
 32c:	a011                	j	330 <gets+0x56>
 32e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 330:	99de                	add	s3,s3,s7
 332:	00098023          	sb	zero,0(s3)
  return buf;
}
 336:	855e                	mv	a0,s7
 338:	60e6                	ld	ra,88(sp)
 33a:	6446                	ld	s0,80(sp)
 33c:	64a6                	ld	s1,72(sp)
 33e:	6906                	ld	s2,64(sp)
 340:	79e2                	ld	s3,56(sp)
 342:	7a42                	ld	s4,48(sp)
 344:	7aa2                	ld	s5,40(sp)
 346:	7b02                	ld	s6,32(sp)
 348:	6be2                	ld	s7,24(sp)
 34a:	6125                	add	sp,sp,96
 34c:	8082                	ret

000000000000034e <stat>:

int
stat(const char *n, struct stat *st)
{
 34e:	1101                	add	sp,sp,-32
 350:	ec06                	sd	ra,24(sp)
 352:	e822                	sd	s0,16(sp)
 354:	e04a                	sd	s2,0(sp)
 356:	1000                	add	s0,sp,32
 358:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35a:	4581                	li	a1,0
 35c:	00000097          	auipc	ra,0x0
 360:	172080e7          	jalr	370(ra) # 4ce <open>
  if(fd < 0)
 364:	02054663          	bltz	a0,390 <stat+0x42>
 368:	e426                	sd	s1,8(sp)
 36a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 36c:	85ca                	mv	a1,s2
 36e:	00000097          	auipc	ra,0x0
 372:	178080e7          	jalr	376(ra) # 4e6 <fstat>
 376:	892a                	mv	s2,a0
  close(fd);
 378:	8526                	mv	a0,s1
 37a:	00000097          	auipc	ra,0x0
 37e:	13c080e7          	jalr	316(ra) # 4b6 <close>
  return r;
 382:	64a2                	ld	s1,8(sp)
}
 384:	854a                	mv	a0,s2
 386:	60e2                	ld	ra,24(sp)
 388:	6442                	ld	s0,16(sp)
 38a:	6902                	ld	s2,0(sp)
 38c:	6105                	add	sp,sp,32
 38e:	8082                	ret
    return -1;
 390:	597d                	li	s2,-1
 392:	bfcd                	j	384 <stat+0x36>

0000000000000394 <atoi>:

int
atoi(const char *s)
{
 394:	1141                	add	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 39a:	00054683          	lbu	a3,0(a0)
 39e:	fd06879b          	addw	a5,a3,-48
 3a2:	0ff7f793          	zext.b	a5,a5
 3a6:	4625                	li	a2,9
 3a8:	02f66863          	bltu	a2,a5,3d8 <atoi+0x44>
 3ac:	872a                	mv	a4,a0
  n = 0;
 3ae:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3b0:	0705                	add	a4,a4,1
 3b2:	0025179b          	sllw	a5,a0,0x2
 3b6:	9fa9                	addw	a5,a5,a0
 3b8:	0017979b          	sllw	a5,a5,0x1
 3bc:	9fb5                	addw	a5,a5,a3
 3be:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3c2:	00074683          	lbu	a3,0(a4)
 3c6:	fd06879b          	addw	a5,a3,-48
 3ca:	0ff7f793          	zext.b	a5,a5
 3ce:	fef671e3          	bgeu	a2,a5,3b0 <atoi+0x1c>
  return n;
}
 3d2:	6422                	ld	s0,8(sp)
 3d4:	0141                	add	sp,sp,16
 3d6:	8082                	ret
  n = 0;
 3d8:	4501                	li	a0,0
 3da:	bfe5                	j	3d2 <atoi+0x3e>

00000000000003dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3dc:	1141                	add	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3e2:	02b57463          	bgeu	a0,a1,40a <memmove+0x2e>
    while(n-- > 0)
 3e6:	00c05f63          	blez	a2,404 <memmove+0x28>
 3ea:	1602                	sll	a2,a2,0x20
 3ec:	9201                	srl	a2,a2,0x20
 3ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 3f4:	0585                	add	a1,a1,1
 3f6:	0705                	add	a4,a4,1
 3f8:	fff5c683          	lbu	a3,-1(a1)
 3fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 400:	fef71ae3          	bne	a4,a5,3f4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 404:	6422                	ld	s0,8(sp)
 406:	0141                	add	sp,sp,16
 408:	8082                	ret
    dst += n;
 40a:	00c50733          	add	a4,a0,a2
    src += n;
 40e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 410:	fec05ae3          	blez	a2,404 <memmove+0x28>
 414:	fff6079b          	addw	a5,a2,-1
 418:	1782                	sll	a5,a5,0x20
 41a:	9381                	srl	a5,a5,0x20
 41c:	fff7c793          	not	a5,a5
 420:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 422:	15fd                	add	a1,a1,-1
 424:	177d                	add	a4,a4,-1
 426:	0005c683          	lbu	a3,0(a1)
 42a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 42e:	fee79ae3          	bne	a5,a4,422 <memmove+0x46>
 432:	bfc9                	j	404 <memmove+0x28>

0000000000000434 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 434:	1141                	add	sp,sp,-16
 436:	e422                	sd	s0,8(sp)
 438:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 43a:	ca05                	beqz	a2,46a <memcmp+0x36>
 43c:	fff6069b          	addw	a3,a2,-1
 440:	1682                	sll	a3,a3,0x20
 442:	9281                	srl	a3,a3,0x20
 444:	0685                	add	a3,a3,1
 446:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 448:	00054783          	lbu	a5,0(a0)
 44c:	0005c703          	lbu	a4,0(a1)
 450:	00e79863          	bne	a5,a4,460 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 454:	0505                	add	a0,a0,1
    p2++;
 456:	0585                	add	a1,a1,1
  while (n-- > 0) {
 458:	fed518e3          	bne	a0,a3,448 <memcmp+0x14>
  }
  return 0;
 45c:	4501                	li	a0,0
 45e:	a019                	j	464 <memcmp+0x30>
      return *p1 - *p2;
 460:	40e7853b          	subw	a0,a5,a4
}
 464:	6422                	ld	s0,8(sp)
 466:	0141                	add	sp,sp,16
 468:	8082                	ret
  return 0;
 46a:	4501                	li	a0,0
 46c:	bfe5                	j	464 <memcmp+0x30>

000000000000046e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 46e:	1141                	add	sp,sp,-16
 470:	e406                	sd	ra,8(sp)
 472:	e022                	sd	s0,0(sp)
 474:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 476:	00000097          	auipc	ra,0x0
 47a:	f66080e7          	jalr	-154(ra) # 3dc <memmove>
}
 47e:	60a2                	ld	ra,8(sp)
 480:	6402                	ld	s0,0(sp)
 482:	0141                	add	sp,sp,16
 484:	8082                	ret

0000000000000486 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 486:	4885                	li	a7,1
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <exit>:
.global exit
exit:
 li a7, SYS_exit
 48e:	4889                	li	a7,2
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <wait>:
.global wait
wait:
 li a7, SYS_wait
 496:	488d                	li	a7,3
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 49e:	4891                	li	a7,4
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <read>:
.global read
read:
 li a7, SYS_read
 4a6:	4895                	li	a7,5
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <write>:
.global write
write:
 li a7, SYS_write
 4ae:	48c1                	li	a7,16
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <close>:
.global close
close:
 li a7, SYS_close
 4b6:	48d5                	li	a7,21
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <kill>:
.global kill
kill:
 li a7, SYS_kill
 4be:	4899                	li	a7,6
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c6:	489d                	li	a7,7
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <open>:
.global open
open:
 li a7, SYS_open
 4ce:	48bd                	li	a7,15
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d6:	48c5                	li	a7,17
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4de:	48c9                	li	a7,18
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e6:	48a1                	li	a7,8
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <link>:
.global link
link:
 li a7, SYS_link
 4ee:	48cd                	li	a7,19
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f6:	48d1                	li	a7,20
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4fe:	48a5                	li	a7,9
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <dup>:
.global dup
dup:
 li a7, SYS_dup
 506:	48a9                	li	a7,10
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 50e:	48ad                	li	a7,11
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 516:	48b1                	li	a7,12
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 51e:	48b5                	li	a7,13
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 526:	48b9                	li	a7,14
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 52e:	1101                	add	sp,sp,-32
 530:	ec06                	sd	ra,24(sp)
 532:	e822                	sd	s0,16(sp)
 534:	1000                	add	s0,sp,32
 536:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 53a:	4605                	li	a2,1
 53c:	fef40593          	add	a1,s0,-17
 540:	00000097          	auipc	ra,0x0
 544:	f6e080e7          	jalr	-146(ra) # 4ae <write>
}
 548:	60e2                	ld	ra,24(sp)
 54a:	6442                	ld	s0,16(sp)
 54c:	6105                	add	sp,sp,32
 54e:	8082                	ret

0000000000000550 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 550:	7139                	add	sp,sp,-64
 552:	fc06                	sd	ra,56(sp)
 554:	f822                	sd	s0,48(sp)
 556:	f426                	sd	s1,40(sp)
 558:	0080                	add	s0,sp,64
 55a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 55c:	c299                	beqz	a3,562 <printint+0x12>
 55e:	0805cb63          	bltz	a1,5f4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 562:	2581                	sext.w	a1,a1
  neg = 0;
 564:	4881                	li	a7,0
 566:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 56a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 56c:	2601                	sext.w	a2,a2
 56e:	00000517          	auipc	a0,0x0
 572:	4da50513          	add	a0,a0,1242 # a48 <digits>
 576:	883a                	mv	a6,a4
 578:	2705                	addw	a4,a4,1
 57a:	02c5f7bb          	remuw	a5,a1,a2
 57e:	1782                	sll	a5,a5,0x20
 580:	9381                	srl	a5,a5,0x20
 582:	97aa                	add	a5,a5,a0
 584:	0007c783          	lbu	a5,0(a5)
 588:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 58c:	0005879b          	sext.w	a5,a1
 590:	02c5d5bb          	divuw	a1,a1,a2
 594:	0685                	add	a3,a3,1
 596:	fec7f0e3          	bgeu	a5,a2,576 <printint+0x26>
  if(neg)
 59a:	00088c63          	beqz	a7,5b2 <printint+0x62>
    buf[i++] = '-';
 59e:	fd070793          	add	a5,a4,-48
 5a2:	00878733          	add	a4,a5,s0
 5a6:	02d00793          	li	a5,45
 5aa:	fef70823          	sb	a5,-16(a4)
 5ae:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 5b2:	02e05c63          	blez	a4,5ea <printint+0x9a>
 5b6:	f04a                	sd	s2,32(sp)
 5b8:	ec4e                	sd	s3,24(sp)
 5ba:	fc040793          	add	a5,s0,-64
 5be:	00e78933          	add	s2,a5,a4
 5c2:	fff78993          	add	s3,a5,-1
 5c6:	99ba                	add	s3,s3,a4
 5c8:	377d                	addw	a4,a4,-1
 5ca:	1702                	sll	a4,a4,0x20
 5cc:	9301                	srl	a4,a4,0x20
 5ce:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5d2:	fff94583          	lbu	a1,-1(s2)
 5d6:	8526                	mv	a0,s1
 5d8:	00000097          	auipc	ra,0x0
 5dc:	f56080e7          	jalr	-170(ra) # 52e <putc>
  while(--i >= 0)
 5e0:	197d                	add	s2,s2,-1
 5e2:	ff3918e3          	bne	s2,s3,5d2 <printint+0x82>
 5e6:	7902                	ld	s2,32(sp)
 5e8:	69e2                	ld	s3,24(sp)
}
 5ea:	70e2                	ld	ra,56(sp)
 5ec:	7442                	ld	s0,48(sp)
 5ee:	74a2                	ld	s1,40(sp)
 5f0:	6121                	add	sp,sp,64
 5f2:	8082                	ret
    x = -xx;
 5f4:	40b005bb          	negw	a1,a1
    neg = 1;
 5f8:	4885                	li	a7,1
    x = -xx;
 5fa:	b7b5                	j	566 <printint+0x16>

00000000000005fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5fc:	715d                	add	sp,sp,-80
 5fe:	e486                	sd	ra,72(sp)
 600:	e0a2                	sd	s0,64(sp)
 602:	f84a                	sd	s2,48(sp)
 604:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 606:	0005c903          	lbu	s2,0(a1)
 60a:	1a090a63          	beqz	s2,7be <vprintf+0x1c2>
 60e:	fc26                	sd	s1,56(sp)
 610:	f44e                	sd	s3,40(sp)
 612:	f052                	sd	s4,32(sp)
 614:	ec56                	sd	s5,24(sp)
 616:	e85a                	sd	s6,16(sp)
 618:	e45e                	sd	s7,8(sp)
 61a:	8aaa                	mv	s5,a0
 61c:	8bb2                	mv	s7,a2
 61e:	00158493          	add	s1,a1,1
  state = 0;
 622:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 624:	02500a13          	li	s4,37
 628:	4b55                	li	s6,21
 62a:	a839                	j	648 <vprintf+0x4c>
        putc(fd, c);
 62c:	85ca                	mv	a1,s2
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	efe080e7          	jalr	-258(ra) # 52e <putc>
 638:	a019                	j	63e <vprintf+0x42>
    } else if(state == '%'){
 63a:	01498d63          	beq	s3,s4,654 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 63e:	0485                	add	s1,s1,1
 640:	fff4c903          	lbu	s2,-1(s1)
 644:	16090763          	beqz	s2,7b2 <vprintf+0x1b6>
    if(state == 0){
 648:	fe0999e3          	bnez	s3,63a <vprintf+0x3e>
      if(c == '%'){
 64c:	ff4910e3          	bne	s2,s4,62c <vprintf+0x30>
        state = '%';
 650:	89d2                	mv	s3,s4
 652:	b7f5                	j	63e <vprintf+0x42>
      if(c == 'd'){
 654:	13490463          	beq	s2,s4,77c <vprintf+0x180>
 658:	f9d9079b          	addw	a5,s2,-99
 65c:	0ff7f793          	zext.b	a5,a5
 660:	12fb6763          	bltu	s6,a5,78e <vprintf+0x192>
 664:	f9d9079b          	addw	a5,s2,-99
 668:	0ff7f713          	zext.b	a4,a5
 66c:	12eb6163          	bltu	s6,a4,78e <vprintf+0x192>
 670:	00271793          	sll	a5,a4,0x2
 674:	00000717          	auipc	a4,0x0
 678:	37c70713          	add	a4,a4,892 # 9f0 <malloc+0x142>
 67c:	97ba                	add	a5,a5,a4
 67e:	439c                	lw	a5,0(a5)
 680:	97ba                	add	a5,a5,a4
 682:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 684:	008b8913          	add	s2,s7,8
 688:	4685                	li	a3,1
 68a:	4629                	li	a2,10
 68c:	000ba583          	lw	a1,0(s7)
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	ebe080e7          	jalr	-322(ra) # 550 <printint>
 69a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b745                	j	63e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	008b8913          	add	s2,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4629                	li	a2,10
 6a8:	000ba583          	lw	a1,0(s7)
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	ea2080e7          	jalr	-350(ra) # 550 <printint>
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b751                	j	63e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6bc:	008b8913          	add	s2,s7,8
 6c0:	4681                	li	a3,0
 6c2:	4641                	li	a2,16
 6c4:	000ba583          	lw	a1,0(s7)
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	e86080e7          	jalr	-378(ra) # 550 <printint>
 6d2:	8bca                	mv	s7,s2
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b7a5                	j	63e <vprintf+0x42>
 6d8:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6da:	008b8c13          	add	s8,s7,8
 6de:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e2:	03000593          	li	a1,48
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e46080e7          	jalr	-442(ra) # 52e <putc>
  putc(fd, 'x');
 6f0:	07800593          	li	a1,120
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e38080e7          	jalr	-456(ra) # 52e <putc>
 6fe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 700:	00000b97          	auipc	s7,0x0
 704:	348b8b93          	add	s7,s7,840 # a48 <digits>
 708:	03c9d793          	srl	a5,s3,0x3c
 70c:	97de                	add	a5,a5,s7
 70e:	0007c583          	lbu	a1,0(a5)
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	e1a080e7          	jalr	-486(ra) # 52e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71c:	0992                	sll	s3,s3,0x4
 71e:	397d                	addw	s2,s2,-1
 720:	fe0914e3          	bnez	s2,708 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 724:	8be2                	mv	s7,s8
      state = 0;
 726:	4981                	li	s3,0
 728:	6c02                	ld	s8,0(sp)
 72a:	bf11                	j	63e <vprintf+0x42>
        s = va_arg(ap, char*);
 72c:	008b8993          	add	s3,s7,8
 730:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 734:	02090163          	beqz	s2,756 <vprintf+0x15a>
        while(*s != 0){
 738:	00094583          	lbu	a1,0(s2)
 73c:	c9a5                	beqz	a1,7ac <vprintf+0x1b0>
          putc(fd, *s);
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	dee080e7          	jalr	-530(ra) # 52e <putc>
          s++;
 748:	0905                	add	s2,s2,1
        while(*s != 0){
 74a:	00094583          	lbu	a1,0(s2)
 74e:	f9e5                	bnez	a1,73e <vprintf+0x142>
        s = va_arg(ap, char*);
 750:	8bce                	mv	s7,s3
      state = 0;
 752:	4981                	li	s3,0
 754:	b5ed                	j	63e <vprintf+0x42>
          s = "(null)";
 756:	00000917          	auipc	s2,0x0
 75a:	29290913          	add	s2,s2,658 # 9e8 <malloc+0x13a>
        while(*s != 0){
 75e:	02800593          	li	a1,40
 762:	bff1                	j	73e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 764:	008b8913          	add	s2,s7,8
 768:	000bc583          	lbu	a1,0(s7)
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	dc0080e7          	jalr	-576(ra) # 52e <putc>
 776:	8bca                	mv	s7,s2
      state = 0;
 778:	4981                	li	s3,0
 77a:	b5d1                	j	63e <vprintf+0x42>
        putc(fd, c);
 77c:	02500593          	li	a1,37
 780:	8556                	mv	a0,s5
 782:	00000097          	auipc	ra,0x0
 786:	dac080e7          	jalr	-596(ra) # 52e <putc>
      state = 0;
 78a:	4981                	li	s3,0
 78c:	bd4d                	j	63e <vprintf+0x42>
        putc(fd, '%');
 78e:	02500593          	li	a1,37
 792:	8556                	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	d9a080e7          	jalr	-614(ra) # 52e <putc>
        putc(fd, c);
 79c:	85ca                	mv	a1,s2
 79e:	8556                	mv	a0,s5
 7a0:	00000097          	auipc	ra,0x0
 7a4:	d8e080e7          	jalr	-626(ra) # 52e <putc>
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bd51                	j	63e <vprintf+0x42>
        s = va_arg(ap, char*);
 7ac:	8bce                	mv	s7,s3
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b579                	j	63e <vprintf+0x42>
 7b2:	74e2                	ld	s1,56(sp)
 7b4:	79a2                	ld	s3,40(sp)
 7b6:	7a02                	ld	s4,32(sp)
 7b8:	6ae2                	ld	s5,24(sp)
 7ba:	6b42                	ld	s6,16(sp)
 7bc:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7be:	60a6                	ld	ra,72(sp)
 7c0:	6406                	ld	s0,64(sp)
 7c2:	7942                	ld	s2,48(sp)
 7c4:	6161                	add	sp,sp,80
 7c6:	8082                	ret

00000000000007c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c8:	715d                	add	sp,sp,-80
 7ca:	ec06                	sd	ra,24(sp)
 7cc:	e822                	sd	s0,16(sp)
 7ce:	1000                	add	s0,sp,32
 7d0:	e010                	sd	a2,0(s0)
 7d2:	e414                	sd	a3,8(s0)
 7d4:	e818                	sd	a4,16(s0)
 7d6:	ec1c                	sd	a5,24(s0)
 7d8:	03043023          	sd	a6,32(s0)
 7dc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e4:	8622                	mv	a2,s0
 7e6:	00000097          	auipc	ra,0x0
 7ea:	e16080e7          	jalr	-490(ra) # 5fc <vprintf>
}
 7ee:	60e2                	ld	ra,24(sp)
 7f0:	6442                	ld	s0,16(sp)
 7f2:	6161                	add	sp,sp,80
 7f4:	8082                	ret

00000000000007f6 <printf>:

void
printf(const char *fmt, ...)
{
 7f6:	711d                	add	sp,sp,-96
 7f8:	ec06                	sd	ra,24(sp)
 7fa:	e822                	sd	s0,16(sp)
 7fc:	1000                	add	s0,sp,32
 7fe:	e40c                	sd	a1,8(s0)
 800:	e810                	sd	a2,16(s0)
 802:	ec14                	sd	a3,24(s0)
 804:	f018                	sd	a4,32(s0)
 806:	f41c                	sd	a5,40(s0)
 808:	03043823          	sd	a6,48(s0)
 80c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 810:	00840613          	add	a2,s0,8
 814:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 818:	85aa                	mv	a1,a0
 81a:	4505                	li	a0,1
 81c:	00000097          	auipc	ra,0x0
 820:	de0080e7          	jalr	-544(ra) # 5fc <vprintf>
}
 824:	60e2                	ld	ra,24(sp)
 826:	6442                	ld	s0,16(sp)
 828:	6125                	add	sp,sp,96
 82a:	8082                	ret

000000000000082c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 82c:	1141                	add	sp,sp,-16
 82e:	e422                	sd	s0,8(sp)
 830:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 832:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 836:	00000797          	auipc	a5,0x0
 83a:	22a7b783          	ld	a5,554(a5) # a60 <freep>
 83e:	a02d                	j	868 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 840:	4618                	lw	a4,8(a2)
 842:	9f2d                	addw	a4,a4,a1
 844:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 848:	6398                	ld	a4,0(a5)
 84a:	6310                	ld	a2,0(a4)
 84c:	a83d                	j	88a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 84e:	ff852703          	lw	a4,-8(a0)
 852:	9f31                	addw	a4,a4,a2
 854:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 856:	ff053683          	ld	a3,-16(a0)
 85a:	a091                	j	89e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85c:	6398                	ld	a4,0(a5)
 85e:	00e7e463          	bltu	a5,a4,866 <free+0x3a>
 862:	00e6ea63          	bltu	a3,a4,876 <free+0x4a>
{
 866:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 868:	fed7fae3          	bgeu	a5,a3,85c <free+0x30>
 86c:	6398                	ld	a4,0(a5)
 86e:	00e6e463          	bltu	a3,a4,876 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 872:	fee7eae3          	bltu	a5,a4,866 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 876:	ff852583          	lw	a1,-8(a0)
 87a:	6390                	ld	a2,0(a5)
 87c:	02059813          	sll	a6,a1,0x20
 880:	01c85713          	srl	a4,a6,0x1c
 884:	9736                	add	a4,a4,a3
 886:	fae60de3          	beq	a2,a4,840 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 88a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 88e:	4790                	lw	a2,8(a5)
 890:	02061593          	sll	a1,a2,0x20
 894:	01c5d713          	srl	a4,a1,0x1c
 898:	973e                	add	a4,a4,a5
 89a:	fae68ae3          	beq	a3,a4,84e <free+0x22>
    p->s.ptr = bp->s.ptr;
 89e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8a0:	00000717          	auipc	a4,0x0
 8a4:	1cf73023          	sd	a5,448(a4) # a60 <freep>
}
 8a8:	6422                	ld	s0,8(sp)
 8aa:	0141                	add	sp,sp,16
 8ac:	8082                	ret

00000000000008ae <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ae:	7139                	add	sp,sp,-64
 8b0:	fc06                	sd	ra,56(sp)
 8b2:	f822                	sd	s0,48(sp)
 8b4:	f426                	sd	s1,40(sp)
 8b6:	ec4e                	sd	s3,24(sp)
 8b8:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ba:	02051493          	sll	s1,a0,0x20
 8be:	9081                	srl	s1,s1,0x20
 8c0:	04bd                	add	s1,s1,15
 8c2:	8091                	srl	s1,s1,0x4
 8c4:	0014899b          	addw	s3,s1,1
 8c8:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8ca:	00000517          	auipc	a0,0x0
 8ce:	19653503          	ld	a0,406(a0) # a60 <freep>
 8d2:	c915                	beqz	a0,906 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d6:	4798                	lw	a4,8(a5)
 8d8:	08977e63          	bgeu	a4,s1,974 <malloc+0xc6>
 8dc:	f04a                	sd	s2,32(sp)
 8de:	e852                	sd	s4,16(sp)
 8e0:	e456                	sd	s5,8(sp)
 8e2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8e4:	8a4e                	mv	s4,s3
 8e6:	0009871b          	sext.w	a4,s3
 8ea:	6685                	lui	a3,0x1
 8ec:	00d77363          	bgeu	a4,a3,8f2 <malloc+0x44>
 8f0:	6a05                	lui	s4,0x1
 8f2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f6:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8fa:	00000917          	auipc	s2,0x0
 8fe:	16690913          	add	s2,s2,358 # a60 <freep>
  if(p == (char*)-1)
 902:	5afd                	li	s5,-1
 904:	a091                	j	948 <malloc+0x9a>
 906:	f04a                	sd	s2,32(sp)
 908:	e852                	sd	s4,16(sp)
 90a:	e456                	sd	s5,8(sp)
 90c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 90e:	00000797          	auipc	a5,0x0
 912:	15a78793          	add	a5,a5,346 # a68 <base>
 916:	00000717          	auipc	a4,0x0
 91a:	14f73523          	sd	a5,330(a4) # a60 <freep>
 91e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 920:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 924:	b7c1                	j	8e4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 926:	6398                	ld	a4,0(a5)
 928:	e118                	sd	a4,0(a0)
 92a:	a08d                	j	98c <malloc+0xde>
  hp->s.size = nu;
 92c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 930:	0541                	add	a0,a0,16
 932:	00000097          	auipc	ra,0x0
 936:	efa080e7          	jalr	-262(ra) # 82c <free>
  return freep;
 93a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 93e:	c13d                	beqz	a0,9a4 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 940:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 942:	4798                	lw	a4,8(a5)
 944:	02977463          	bgeu	a4,s1,96c <malloc+0xbe>
    if(p == freep)
 948:	00093703          	ld	a4,0(s2)
 94c:	853e                	mv	a0,a5
 94e:	fef719e3          	bne	a4,a5,940 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 952:	8552                	mv	a0,s4
 954:	00000097          	auipc	ra,0x0
 958:	bc2080e7          	jalr	-1086(ra) # 516 <sbrk>
  if(p == (char*)-1)
 95c:	fd5518e3          	bne	a0,s5,92c <malloc+0x7e>
        return 0;
 960:	4501                	li	a0,0
 962:	7902                	ld	s2,32(sp)
 964:	6a42                	ld	s4,16(sp)
 966:	6aa2                	ld	s5,8(sp)
 968:	6b02                	ld	s6,0(sp)
 96a:	a03d                	j	998 <malloc+0xea>
 96c:	7902                	ld	s2,32(sp)
 96e:	6a42                	ld	s4,16(sp)
 970:	6aa2                	ld	s5,8(sp)
 972:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 974:	fae489e3          	beq	s1,a4,926 <malloc+0x78>
        p->s.size -= nunits;
 978:	4137073b          	subw	a4,a4,s3
 97c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 97e:	02071693          	sll	a3,a4,0x20
 982:	01c6d713          	srl	a4,a3,0x1c
 986:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 988:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 98c:	00000717          	auipc	a4,0x0
 990:	0ca73a23          	sd	a0,212(a4) # a60 <freep>
      return (void*)(p + 1);
 994:	01078513          	add	a0,a5,16
  }
}
 998:	70e2                	ld	ra,56(sp)
 99a:	7442                	ld	s0,48(sp)
 99c:	74a2                	ld	s1,40(sp)
 99e:	69e2                	ld	s3,24(sp)
 9a0:	6121                	add	sp,sp,64
 9a2:	8082                	ret
 9a4:	7902                	ld	s2,32(sp)
 9a6:	6a42                	ld	s4,16(sp)
 9a8:	6aa2                	ld	s5,8(sp)
 9aa:	6b02                	ld	s6,0(sp)
 9ac:	b7f5                	j	998 <malloc+0xea>
