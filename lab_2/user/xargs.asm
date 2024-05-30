
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/param.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	710d                	add	sp,sp,-352
   2:	ee86                	sd	ra,344(sp)
   4:	eaa2                	sd	s0,336(sp)
   6:	e6a6                	sd	s1,328(sp)
   8:	e2ca                	sd	s2,320(sp)
   a:	fe4e                	sd	s3,312(sp)
   c:	fa52                	sd	s4,304(sp)
   e:	f656                	sd	s5,296(sp)
  10:	f25a                	sd	s6,288(sp)
  12:	ee5e                	sd	s7,280(sp)
  14:	ea62                	sd	s8,272(sp)
  16:	e666                	sd	s9,264(sp)
  18:	e26a                	sd	s10,256(sp)
  1a:	1280                	add	s0,sp,352
    if (argc < 2)
  1c:	4785                	li	a5,1
  1e:	06a7d063          	bge	a5,a0,7e <main+0x7e>
  22:	8bae                	mv	s7,a1
    {
        printf("usage: xargs command\n");
        exit(1);
    }
    int buf_size = 512;
    char buf[buf_size];
  24:	7101                	add	sp,sp,-512
  26:	890a                	mv	s2,sp
    int used = 0;
    int end = 0;
    char *xargs[MAXARG];
    for (int i = 1; i < argc; ++i)
  28:	00858713          	add	a4,a1,8
  2c:	ea040793          	add	a5,s0,-352
  30:	ffe5069b          	addw	a3,a0,-2
  34:	02069613          	sll	a2,a3,0x20
  38:	01d65693          	srl	a3,a2,0x1d
  3c:	ea840613          	add	a2,s0,-344
  40:	96b2                	add	a3,a3,a2
    {
        xargs[i - 1] = argv[i];
  42:	6310                	ld	a2,0(a4)
  44:	e390                	sd	a2,0(a5)
    for (int i = 1; i < argc; ++i)
  46:	0721                	add	a4,a4,8
  48:	07a1                	add	a5,a5,8
  4a:	fed79ce3          	bne	a5,a3,42 <main+0x42>
    int end = 0;
  4e:	4c81                	li	s9,0
    int used = 0;
  50:	4a01                	li	s4,0
        while (line_end)
        {
            char child_buf[buf_size];
            memcpy(child_buf, buf, line_end - buf);
            child_buf[line_end - buf] = 0;//set end of string
            xargs[argc - 1] = child_buf;
  52:	fff50b1b          	addw	s6,a0,-1
  56:	0b0e                	sll	s6,s6,0x3
  58:	fa0b0793          	add	a5,s6,-96
  5c:	00878b33          	add	s6,a5,s0
            }
            else
            { // parent
                used -= line_end - buf + 1;
                memmove(buf, line_end + 1, used);
                memset(buf + used, 0, buf_size - used);
  60:	20000c13          	li	s8,512
    while (!end || used != 0)
  64:	020c8a63          	beqz	s9,98 <main+0x98>
  68:	160a0263          	beqz	s4,1cc <main+0x1cc>
        char *line_end = strchr(buf, '\n');
  6c:	45a9                	li	a1,10
  6e:	854a                	mv	a0,s2
  70:	00000097          	auipc	ra,0x0
  74:	204080e7          	jalr	516(ra) # 274 <strchr>
  78:	84aa                	mv	s1,a0
        while (line_end)
  7a:	e17d                	bnez	a0,160 <main+0x160>
  7c:	b7e5                	j	64 <main+0x64>
        printf("usage: xargs command\n");
  7e:	00001517          	auipc	a0,0x1
  82:	90250513          	add	a0,a0,-1790 # 980 <malloc+0x104>
  86:	00000097          	auipc	ra,0x0
  8a:	73e080e7          	jalr	1854(ra) # 7c4 <printf>
        exit(1);
  8e:	4505                	li	a0,1
  90:	00000097          	auipc	ra,0x0
  94:	3bc080e7          	jalr	956(ra) # 44c <exit>
            int n = read(0, buf + used, remain);
  98:	20000613          	li	a2,512
  9c:	4146063b          	subw	a2,a2,s4
  a0:	014905b3          	add	a1,s2,s4
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	3be080e7          	jalr	958(ra) # 464 <read>
  ae:	84aa                	mv	s1,a0
            if (n < 0)
  b0:	00054663          	bltz	a0,bc <main+0xbc>
            if (!n)
  b4:	c51d                	beqz	a0,e2 <main+0xe2>
            used += n;
  b6:	009a0a3b          	addw	s4,s4,s1
  ba:	bf4d                	j	6c <main+0x6c>
                printf("xargs: read error, return:%d\n", n);
  bc:	85aa                	mv	a1,a0
  be:	00001517          	auipc	a0,0x1
  c2:	8da50513          	add	a0,a0,-1830 # 998 <malloc+0x11c>
  c6:	00000097          	auipc	ra,0x0
  ca:	6fe080e7          	jalr	1790(ra) # 7c4 <printf>
                close(0);
  ce:	4501                	li	a0,0
  d0:	00000097          	auipc	ra,0x0
  d4:	3a4080e7          	jalr	932(ra) # 474 <close>
                exit(1);
  d8:	4505                	li	a0,1
  da:	00000097          	auipc	ra,0x0
  de:	372080e7          	jalr	882(ra) # 44c <exit>
                close(0);
  e2:	4501                	li	a0,0
  e4:	00000097          	auipc	ra,0x0
  e8:	390080e7          	jalr	912(ra) # 474 <close>
                end = 1;
  ec:	4c85                	li	s9,1
  ee:	b7e1                	j	b6 <main+0xb6>
                printf("xargs: fork error, return:%d\n", pid);
  f0:	85aa                	mv	a1,a0
  f2:	00001517          	auipc	a0,0x1
  f6:	8c650513          	add	a0,a0,-1850 # 9b8 <malloc+0x13c>
  fa:	00000097          	auipc	ra,0x0
  fe:	6ca080e7          	jalr	1738(ra) # 7c4 <printf>
                close(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	370080e7          	jalr	880(ra) # 474 <close>
                exit(1);
 10c:	4505                	li	a0,1
 10e:	00000097          	auipc	ra,0x0
 112:	33e080e7          	jalr	830(ra) # 44c <exit>
                used -= line_end - buf + 1;
 116:	fffa079b          	addw	a5,s4,-1
 11a:	413789bb          	subw	s3,a5,s3
 11e:	00098a1b          	sext.w	s4,s3
                memmove(buf, line_end + 1, used);
 122:	8652                	mv	a2,s4
 124:	00148593          	add	a1,s1,1
 128:	854a                	mv	a0,s2
 12a:	00000097          	auipc	ra,0x0
 12e:	270080e7          	jalr	624(ra) # 39a <memmove>
                memset(buf + used, 0, buf_size - used);
 132:	413c063b          	subw	a2,s8,s3
 136:	4581                	li	a1,0
 138:	01490533          	add	a0,s2,s4
 13c:	00000097          	auipc	ra,0x0
 140:	116080e7          	jalr	278(ra) # 252 <memset>
                wait(0);
 144:	4501                	li	a0,0
 146:	00000097          	auipc	ra,0x0
 14a:	30e080e7          	jalr	782(ra) # 454 <wait>
            }
            line_end = strchr(buf, '\n');
 14e:	45a9                	li	a1,10
 150:	854a                	mv	a0,s2
 152:	00000097          	auipc	ra,0x0
 156:	122080e7          	jalr	290(ra) # 274 <strchr>
 15a:	84aa                	mv	s1,a0
 15c:	8156                	mv	sp,s5
        while (line_end)
 15e:	d119                	beqz	a0,64 <main+0x64>
        {
 160:	8a8a                	mv	s5,sp
            char child_buf[buf_size];
 162:	7101                	add	sp,sp,-512
            memcpy(child_buf, buf, line_end - buf);
 164:	41248d33          	sub	s10,s1,s2
 168:	000d099b          	sext.w	s3,s10
 16c:	864e                	mv	a2,s3
 16e:	85ca                	mv	a1,s2
 170:	850a                	mv	a0,sp
 172:	00000097          	auipc	ra,0x0
 176:	2ba080e7          	jalr	698(ra) # 42c <memcpy>
            child_buf[line_end - buf] = 0;//set end of string
 17a:	9d0a                	add	s10,s10,sp
 17c:	000d0023          	sb	zero,0(s10)
            xargs[argc - 1] = child_buf;
 180:	f02b3023          	sd	sp,-256(s6)
            int pid = fork();
 184:	00000097          	auipc	ra,0x0
 188:	2c0080e7          	jalr	704(ra) # 444 <fork>
            if (pid < 0)
 18c:	f60542e3          	bltz	a0,f0 <main+0xf0>
            else if (pid == 0)
 190:	f159                	bnez	a0,116 <main+0x116>
                if (exec(argv[1], xargs) < 0)
 192:	ea040593          	add	a1,s0,-352
 196:	008bb503          	ld	a0,8(s7)
 19a:	00000097          	auipc	ra,0x0
 19e:	2ea080e7          	jalr	746(ra) # 484 <exec>
 1a2:	fa0556e3          	bgez	a0,14e <main+0x14e>
                    printf("xargs: exec error, return:%d\n", pid);
 1a6:	4581                	li	a1,0
 1a8:	00001517          	auipc	a0,0x1
 1ac:	83050513          	add	a0,a0,-2000 # 9d8 <malloc+0x15c>
 1b0:	00000097          	auipc	ra,0x0
 1b4:	614080e7          	jalr	1556(ra) # 7c4 <printf>
                    close(0);
 1b8:	4501                	li	a0,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	2ba080e7          	jalr	698(ra) # 474 <close>
                    exit(1);
 1c2:	4505                	li	a0,1
 1c4:	00000097          	auipc	ra,0x0
 1c8:	288080e7          	jalr	648(ra) # 44c <exit>
        }
    }
    close(0);
 1cc:	4501                	li	a0,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	2a6080e7          	jalr	678(ra) # 474 <close>
    exit(0);
 1d6:	4501                	li	a0,0
 1d8:	00000097          	auipc	ra,0x0
 1dc:	274080e7          	jalr	628(ra) # 44c <exit>

00000000000001e0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1e0:	1141                	add	sp,sp,-16
 1e2:	e422                	sd	s0,8(sp)
 1e4:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1e6:	87aa                	mv	a5,a0
 1e8:	0585                	add	a1,a1,1
 1ea:	0785                	add	a5,a5,1
 1ec:	fff5c703          	lbu	a4,-1(a1)
 1f0:	fee78fa3          	sb	a4,-1(a5)
 1f4:	fb75                	bnez	a4,1e8 <strcpy+0x8>
    ;
  return os;
}
 1f6:	6422                	ld	s0,8(sp)
 1f8:	0141                	add	sp,sp,16
 1fa:	8082                	ret

00000000000001fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1fc:	1141                	add	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 202:	00054783          	lbu	a5,0(a0)
 206:	cb91                	beqz	a5,21a <strcmp+0x1e>
 208:	0005c703          	lbu	a4,0(a1)
 20c:	00f71763          	bne	a4,a5,21a <strcmp+0x1e>
    p++, q++;
 210:	0505                	add	a0,a0,1
 212:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 214:	00054783          	lbu	a5,0(a0)
 218:	fbe5                	bnez	a5,208 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 21a:	0005c503          	lbu	a0,0(a1)
}
 21e:	40a7853b          	subw	a0,a5,a0
 222:	6422                	ld	s0,8(sp)
 224:	0141                	add	sp,sp,16
 226:	8082                	ret

0000000000000228 <strlen>:

uint
strlen(const char *s)
{
 228:	1141                	add	sp,sp,-16
 22a:	e422                	sd	s0,8(sp)
 22c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 22e:	00054783          	lbu	a5,0(a0)
 232:	cf91                	beqz	a5,24e <strlen+0x26>
 234:	0505                	add	a0,a0,1
 236:	87aa                	mv	a5,a0
 238:	86be                	mv	a3,a5
 23a:	0785                	add	a5,a5,1
 23c:	fff7c703          	lbu	a4,-1(a5)
 240:	ff65                	bnez	a4,238 <strlen+0x10>
 242:	40a6853b          	subw	a0,a3,a0
 246:	2505                	addw	a0,a0,1
    ;
  return n;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	add	sp,sp,16
 24c:	8082                	ret
  for(n = 0; s[n]; n++)
 24e:	4501                	li	a0,0
 250:	bfe5                	j	248 <strlen+0x20>

0000000000000252 <memset>:

void*
memset(void *dst, int c, uint n)
{
 252:	1141                	add	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 258:	ca19                	beqz	a2,26e <memset+0x1c>
 25a:	87aa                	mv	a5,a0
 25c:	1602                	sll	a2,a2,0x20
 25e:	9201                	srl	a2,a2,0x20
 260:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 264:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 268:	0785                	add	a5,a5,1
 26a:	fee79de3          	bne	a5,a4,264 <memset+0x12>
  }
  return dst;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	add	sp,sp,16
 272:	8082                	ret

0000000000000274 <strchr>:

char*
strchr(const char *s, char c)
{
 274:	1141                	add	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	add	s0,sp,16
  for(; *s; s++)
 27a:	00054783          	lbu	a5,0(a0)
 27e:	cb99                	beqz	a5,294 <strchr+0x20>
    if(*s == c)
 280:	00f58763          	beq	a1,a5,28e <strchr+0x1a>
  for(; *s; s++)
 284:	0505                	add	a0,a0,1
 286:	00054783          	lbu	a5,0(a0)
 28a:	fbfd                	bnez	a5,280 <strchr+0xc>
      return (char*)s;
  return 0;
 28c:	4501                	li	a0,0
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	add	sp,sp,16
 292:	8082                	ret
  return 0;
 294:	4501                	li	a0,0
 296:	bfe5                	j	28e <strchr+0x1a>

0000000000000298 <gets>:

char*
gets(char *buf, int max)
{
 298:	711d                	add	sp,sp,-96
 29a:	ec86                	sd	ra,88(sp)
 29c:	e8a2                	sd	s0,80(sp)
 29e:	e4a6                	sd	s1,72(sp)
 2a0:	e0ca                	sd	s2,64(sp)
 2a2:	fc4e                	sd	s3,56(sp)
 2a4:	f852                	sd	s4,48(sp)
 2a6:	f456                	sd	s5,40(sp)
 2a8:	f05a                	sd	s6,32(sp)
 2aa:	ec5e                	sd	s7,24(sp)
 2ac:	1080                	add	s0,sp,96
 2ae:	8baa                	mv	s7,a0
 2b0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b2:	892a                	mv	s2,a0
 2b4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2b6:	4aa9                	li	s5,10
 2b8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2ba:	89a6                	mv	s3,s1
 2bc:	2485                	addw	s1,s1,1
 2be:	0344d863          	bge	s1,s4,2ee <gets+0x56>
    cc = read(0, &c, 1);
 2c2:	4605                	li	a2,1
 2c4:	faf40593          	add	a1,s0,-81
 2c8:	4501                	li	a0,0
 2ca:	00000097          	auipc	ra,0x0
 2ce:	19a080e7          	jalr	410(ra) # 464 <read>
    if(cc < 1)
 2d2:	00a05e63          	blez	a0,2ee <gets+0x56>
    buf[i++] = c;
 2d6:	faf44783          	lbu	a5,-81(s0)
 2da:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2de:	01578763          	beq	a5,s5,2ec <gets+0x54>
 2e2:	0905                	add	s2,s2,1
 2e4:	fd679be3          	bne	a5,s6,2ba <gets+0x22>
    buf[i++] = c;
 2e8:	89a6                	mv	s3,s1
 2ea:	a011                	j	2ee <gets+0x56>
 2ec:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ee:	99de                	add	s3,s3,s7
 2f0:	00098023          	sb	zero,0(s3)
  return buf;
}
 2f4:	855e                	mv	a0,s7
 2f6:	60e6                	ld	ra,88(sp)
 2f8:	6446                	ld	s0,80(sp)
 2fa:	64a6                	ld	s1,72(sp)
 2fc:	6906                	ld	s2,64(sp)
 2fe:	79e2                	ld	s3,56(sp)
 300:	7a42                	ld	s4,48(sp)
 302:	7aa2                	ld	s5,40(sp)
 304:	7b02                	ld	s6,32(sp)
 306:	6be2                	ld	s7,24(sp)
 308:	6125                	add	sp,sp,96
 30a:	8082                	ret

000000000000030c <stat>:

int
stat(const char *n, struct stat *st)
{
 30c:	1101                	add	sp,sp,-32
 30e:	ec06                	sd	ra,24(sp)
 310:	e822                	sd	s0,16(sp)
 312:	e04a                	sd	s2,0(sp)
 314:	1000                	add	s0,sp,32
 316:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 318:	4581                	li	a1,0
 31a:	00000097          	auipc	ra,0x0
 31e:	172080e7          	jalr	370(ra) # 48c <open>
  if(fd < 0)
 322:	02054663          	bltz	a0,34e <stat+0x42>
 326:	e426                	sd	s1,8(sp)
 328:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 32a:	85ca                	mv	a1,s2
 32c:	00000097          	auipc	ra,0x0
 330:	178080e7          	jalr	376(ra) # 4a4 <fstat>
 334:	892a                	mv	s2,a0
  close(fd);
 336:	8526                	mv	a0,s1
 338:	00000097          	auipc	ra,0x0
 33c:	13c080e7          	jalr	316(ra) # 474 <close>
  return r;
 340:	64a2                	ld	s1,8(sp)
}
 342:	854a                	mv	a0,s2
 344:	60e2                	ld	ra,24(sp)
 346:	6442                	ld	s0,16(sp)
 348:	6902                	ld	s2,0(sp)
 34a:	6105                	add	sp,sp,32
 34c:	8082                	ret
    return -1;
 34e:	597d                	li	s2,-1
 350:	bfcd                	j	342 <stat+0x36>

0000000000000352 <atoi>:

int
atoi(const char *s)
{
 352:	1141                	add	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 358:	00054683          	lbu	a3,0(a0)
 35c:	fd06879b          	addw	a5,a3,-48
 360:	0ff7f793          	zext.b	a5,a5
 364:	4625                	li	a2,9
 366:	02f66863          	bltu	a2,a5,396 <atoi+0x44>
 36a:	872a                	mv	a4,a0
  n = 0;
 36c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 36e:	0705                	add	a4,a4,1
 370:	0025179b          	sllw	a5,a0,0x2
 374:	9fa9                	addw	a5,a5,a0
 376:	0017979b          	sllw	a5,a5,0x1
 37a:	9fb5                	addw	a5,a5,a3
 37c:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 380:	00074683          	lbu	a3,0(a4)
 384:	fd06879b          	addw	a5,a3,-48
 388:	0ff7f793          	zext.b	a5,a5
 38c:	fef671e3          	bgeu	a2,a5,36e <atoi+0x1c>
  return n;
}
 390:	6422                	ld	s0,8(sp)
 392:	0141                	add	sp,sp,16
 394:	8082                	ret
  n = 0;
 396:	4501                	li	a0,0
 398:	bfe5                	j	390 <atoi+0x3e>

000000000000039a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 39a:	1141                	add	sp,sp,-16
 39c:	e422                	sd	s0,8(sp)
 39e:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3a0:	02b57463          	bgeu	a0,a1,3c8 <memmove+0x2e>
    while(n-- > 0)
 3a4:	00c05f63          	blez	a2,3c2 <memmove+0x28>
 3a8:	1602                	sll	a2,a2,0x20
 3aa:	9201                	srl	a2,a2,0x20
 3ac:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3b0:	872a                	mv	a4,a0
      *dst++ = *src++;
 3b2:	0585                	add	a1,a1,1
 3b4:	0705                	add	a4,a4,1
 3b6:	fff5c683          	lbu	a3,-1(a1)
 3ba:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3be:	fef71ae3          	bne	a4,a5,3b2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3c2:	6422                	ld	s0,8(sp)
 3c4:	0141                	add	sp,sp,16
 3c6:	8082                	ret
    dst += n;
 3c8:	00c50733          	add	a4,a0,a2
    src += n;
 3cc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ce:	fec05ae3          	blez	a2,3c2 <memmove+0x28>
 3d2:	fff6079b          	addw	a5,a2,-1
 3d6:	1782                	sll	a5,a5,0x20
 3d8:	9381                	srl	a5,a5,0x20
 3da:	fff7c793          	not	a5,a5
 3de:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3e0:	15fd                	add	a1,a1,-1
 3e2:	177d                	add	a4,a4,-1
 3e4:	0005c683          	lbu	a3,0(a1)
 3e8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ec:	fee79ae3          	bne	a5,a4,3e0 <memmove+0x46>
 3f0:	bfc9                	j	3c2 <memmove+0x28>

00000000000003f2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3f2:	1141                	add	sp,sp,-16
 3f4:	e422                	sd	s0,8(sp)
 3f6:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f8:	ca05                	beqz	a2,428 <memcmp+0x36>
 3fa:	fff6069b          	addw	a3,a2,-1
 3fe:	1682                	sll	a3,a3,0x20
 400:	9281                	srl	a3,a3,0x20
 402:	0685                	add	a3,a3,1
 404:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 406:	00054783          	lbu	a5,0(a0)
 40a:	0005c703          	lbu	a4,0(a1)
 40e:	00e79863          	bne	a5,a4,41e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 412:	0505                	add	a0,a0,1
    p2++;
 414:	0585                	add	a1,a1,1
  while (n-- > 0) {
 416:	fed518e3          	bne	a0,a3,406 <memcmp+0x14>
  }
  return 0;
 41a:	4501                	li	a0,0
 41c:	a019                	j	422 <memcmp+0x30>
      return *p1 - *p2;
 41e:	40e7853b          	subw	a0,a5,a4
}
 422:	6422                	ld	s0,8(sp)
 424:	0141                	add	sp,sp,16
 426:	8082                	ret
  return 0;
 428:	4501                	li	a0,0
 42a:	bfe5                	j	422 <memcmp+0x30>

000000000000042c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 42c:	1141                	add	sp,sp,-16
 42e:	e406                	sd	ra,8(sp)
 430:	e022                	sd	s0,0(sp)
 432:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 434:	00000097          	auipc	ra,0x0
 438:	f66080e7          	jalr	-154(ra) # 39a <memmove>
}
 43c:	60a2                	ld	ra,8(sp)
 43e:	6402                	ld	s0,0(sp)
 440:	0141                	add	sp,sp,16
 442:	8082                	ret

0000000000000444 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 444:	4885                	li	a7,1
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <exit>:
.global exit
exit:
 li a7, SYS_exit
 44c:	4889                	li	a7,2
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <wait>:
.global wait
wait:
 li a7, SYS_wait
 454:	488d                	li	a7,3
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 45c:	4891                	li	a7,4
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <read>:
.global read
read:
 li a7, SYS_read
 464:	4895                	li	a7,5
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <write>:
.global write
write:
 li a7, SYS_write
 46c:	48c1                	li	a7,16
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <close>:
.global close
close:
 li a7, SYS_close
 474:	48d5                	li	a7,21
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <kill>:
.global kill
kill:
 li a7, SYS_kill
 47c:	4899                	li	a7,6
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <exec>:
.global exec
exec:
 li a7, SYS_exec
 484:	489d                	li	a7,7
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <open>:
.global open
open:
 li a7, SYS_open
 48c:	48bd                	li	a7,15
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 494:	48c5                	li	a7,17
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 49c:	48c9                	li	a7,18
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a4:	48a1                	li	a7,8
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <link>:
.global link
link:
 li a7, SYS_link
 4ac:	48cd                	li	a7,19
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b4:	48d1                	li	a7,20
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4bc:	48a5                	li	a7,9
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c4:	48a9                	li	a7,10
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4cc:	48ad                	li	a7,11
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4d4:	48b1                	li	a7,12
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4dc:	48b5                	li	a7,13
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e4:	48b9                	li	a7,14
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <trace>:
.global trace
trace:
 li a7, SYS_trace
 4ec:	48d9                	li	a7,22
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 4f4:	48dd                	li	a7,23
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fc:	1101                	add	sp,sp,-32
 4fe:	ec06                	sd	ra,24(sp)
 500:	e822                	sd	s0,16(sp)
 502:	1000                	add	s0,sp,32
 504:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 508:	4605                	li	a2,1
 50a:	fef40593          	add	a1,s0,-17
 50e:	00000097          	auipc	ra,0x0
 512:	f5e080e7          	jalr	-162(ra) # 46c <write>
}
 516:	60e2                	ld	ra,24(sp)
 518:	6442                	ld	s0,16(sp)
 51a:	6105                	add	sp,sp,32
 51c:	8082                	ret

000000000000051e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51e:	7139                	add	sp,sp,-64
 520:	fc06                	sd	ra,56(sp)
 522:	f822                	sd	s0,48(sp)
 524:	f426                	sd	s1,40(sp)
 526:	0080                	add	s0,sp,64
 528:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 52a:	c299                	beqz	a3,530 <printint+0x12>
 52c:	0805cb63          	bltz	a1,5c2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 530:	2581                	sext.w	a1,a1
  neg = 0;
 532:	4881                	li	a7,0
 534:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 538:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 53a:	2601                	sext.w	a2,a2
 53c:	00000517          	auipc	a0,0x0
 540:	51c50513          	add	a0,a0,1308 # a58 <digits>
 544:	883a                	mv	a6,a4
 546:	2705                	addw	a4,a4,1
 548:	02c5f7bb          	remuw	a5,a1,a2
 54c:	1782                	sll	a5,a5,0x20
 54e:	9381                	srl	a5,a5,0x20
 550:	97aa                	add	a5,a5,a0
 552:	0007c783          	lbu	a5,0(a5)
 556:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 55a:	0005879b          	sext.w	a5,a1
 55e:	02c5d5bb          	divuw	a1,a1,a2
 562:	0685                	add	a3,a3,1
 564:	fec7f0e3          	bgeu	a5,a2,544 <printint+0x26>
  if(neg)
 568:	00088c63          	beqz	a7,580 <printint+0x62>
    buf[i++] = '-';
 56c:	fd070793          	add	a5,a4,-48
 570:	00878733          	add	a4,a5,s0
 574:	02d00793          	li	a5,45
 578:	fef70823          	sb	a5,-16(a4)
 57c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 580:	02e05c63          	blez	a4,5b8 <printint+0x9a>
 584:	f04a                	sd	s2,32(sp)
 586:	ec4e                	sd	s3,24(sp)
 588:	fc040793          	add	a5,s0,-64
 58c:	00e78933          	add	s2,a5,a4
 590:	fff78993          	add	s3,a5,-1
 594:	99ba                	add	s3,s3,a4
 596:	377d                	addw	a4,a4,-1
 598:	1702                	sll	a4,a4,0x20
 59a:	9301                	srl	a4,a4,0x20
 59c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5a0:	fff94583          	lbu	a1,-1(s2)
 5a4:	8526                	mv	a0,s1
 5a6:	00000097          	auipc	ra,0x0
 5aa:	f56080e7          	jalr	-170(ra) # 4fc <putc>
  while(--i >= 0)
 5ae:	197d                	add	s2,s2,-1
 5b0:	ff3918e3          	bne	s2,s3,5a0 <printint+0x82>
 5b4:	7902                	ld	s2,32(sp)
 5b6:	69e2                	ld	s3,24(sp)
}
 5b8:	70e2                	ld	ra,56(sp)
 5ba:	7442                	ld	s0,48(sp)
 5bc:	74a2                	ld	s1,40(sp)
 5be:	6121                	add	sp,sp,64
 5c0:	8082                	ret
    x = -xx;
 5c2:	40b005bb          	negw	a1,a1
    neg = 1;
 5c6:	4885                	li	a7,1
    x = -xx;
 5c8:	b7b5                	j	534 <printint+0x16>

00000000000005ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ca:	715d                	add	sp,sp,-80
 5cc:	e486                	sd	ra,72(sp)
 5ce:	e0a2                	sd	s0,64(sp)
 5d0:	f84a                	sd	s2,48(sp)
 5d2:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5d4:	0005c903          	lbu	s2,0(a1)
 5d8:	1a090a63          	beqz	s2,78c <vprintf+0x1c2>
 5dc:	fc26                	sd	s1,56(sp)
 5de:	f44e                	sd	s3,40(sp)
 5e0:	f052                	sd	s4,32(sp)
 5e2:	ec56                	sd	s5,24(sp)
 5e4:	e85a                	sd	s6,16(sp)
 5e6:	e45e                	sd	s7,8(sp)
 5e8:	8aaa                	mv	s5,a0
 5ea:	8bb2                	mv	s7,a2
 5ec:	00158493          	add	s1,a1,1
  state = 0;
 5f0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5f2:	02500a13          	li	s4,37
 5f6:	4b55                	li	s6,21
 5f8:	a839                	j	616 <vprintf+0x4c>
        putc(fd, c);
 5fa:	85ca                	mv	a1,s2
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	efe080e7          	jalr	-258(ra) # 4fc <putc>
 606:	a019                	j	60c <vprintf+0x42>
    } else if(state == '%'){
 608:	01498d63          	beq	s3,s4,622 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 60c:	0485                	add	s1,s1,1
 60e:	fff4c903          	lbu	s2,-1(s1)
 612:	16090763          	beqz	s2,780 <vprintf+0x1b6>
    if(state == 0){
 616:	fe0999e3          	bnez	s3,608 <vprintf+0x3e>
      if(c == '%'){
 61a:	ff4910e3          	bne	s2,s4,5fa <vprintf+0x30>
        state = '%';
 61e:	89d2                	mv	s3,s4
 620:	b7f5                	j	60c <vprintf+0x42>
      if(c == 'd'){
 622:	13490463          	beq	s2,s4,74a <vprintf+0x180>
 626:	f9d9079b          	addw	a5,s2,-99
 62a:	0ff7f793          	zext.b	a5,a5
 62e:	12fb6763          	bltu	s6,a5,75c <vprintf+0x192>
 632:	f9d9079b          	addw	a5,s2,-99
 636:	0ff7f713          	zext.b	a4,a5
 63a:	12eb6163          	bltu	s6,a4,75c <vprintf+0x192>
 63e:	00271793          	sll	a5,a4,0x2
 642:	00000717          	auipc	a4,0x0
 646:	3be70713          	add	a4,a4,958 # a00 <malloc+0x184>
 64a:	97ba                	add	a5,a5,a4
 64c:	439c                	lw	a5,0(a5)
 64e:	97ba                	add	a5,a5,a4
 650:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 652:	008b8913          	add	s2,s7,8
 656:	4685                	li	a3,1
 658:	4629                	li	a2,10
 65a:	000ba583          	lw	a1,0(s7)
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	ebe080e7          	jalr	-322(ra) # 51e <printint>
 668:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b745                	j	60c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	008b8913          	add	s2,s7,8
 672:	4681                	li	a3,0
 674:	4629                	li	a2,10
 676:	000ba583          	lw	a1,0(s7)
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	ea2080e7          	jalr	-350(ra) # 51e <printint>
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
 688:	b751                	j	60c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 68a:	008b8913          	add	s2,s7,8
 68e:	4681                	li	a3,0
 690:	4641                	li	a2,16
 692:	000ba583          	lw	a1,0(s7)
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	e86080e7          	jalr	-378(ra) # 51e <printint>
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b7a5                	j	60c <vprintf+0x42>
 6a6:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6a8:	008b8c13          	add	s8,s7,8
 6ac:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b0:	03000593          	li	a1,48
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e46080e7          	jalr	-442(ra) # 4fc <putc>
  putc(fd, 'x');
 6be:	07800593          	li	a1,120
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	e38080e7          	jalr	-456(ra) # 4fc <putc>
 6cc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ce:	00000b97          	auipc	s7,0x0
 6d2:	38ab8b93          	add	s7,s7,906 # a58 <digits>
 6d6:	03c9d793          	srl	a5,s3,0x3c
 6da:	97de                	add	a5,a5,s7
 6dc:	0007c583          	lbu	a1,0(a5)
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	e1a080e7          	jalr	-486(ra) # 4fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ea:	0992                	sll	s3,s3,0x4
 6ec:	397d                	addw	s2,s2,-1
 6ee:	fe0914e3          	bnez	s2,6d6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6f2:	8be2                	mv	s7,s8
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	6c02                	ld	s8,0(sp)
 6f8:	bf11                	j	60c <vprintf+0x42>
        s = va_arg(ap, char*);
 6fa:	008b8993          	add	s3,s7,8
 6fe:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 702:	02090163          	beqz	s2,724 <vprintf+0x15a>
        while(*s != 0){
 706:	00094583          	lbu	a1,0(s2)
 70a:	c9a5                	beqz	a1,77a <vprintf+0x1b0>
          putc(fd, *s);
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	dee080e7          	jalr	-530(ra) # 4fc <putc>
          s++;
 716:	0905                	add	s2,s2,1
        while(*s != 0){
 718:	00094583          	lbu	a1,0(s2)
 71c:	f9e5                	bnez	a1,70c <vprintf+0x142>
        s = va_arg(ap, char*);
 71e:	8bce                	mv	s7,s3
      state = 0;
 720:	4981                	li	s3,0
 722:	b5ed                	j	60c <vprintf+0x42>
          s = "(null)";
 724:	00000917          	auipc	s2,0x0
 728:	2d490913          	add	s2,s2,724 # 9f8 <malloc+0x17c>
        while(*s != 0){
 72c:	02800593          	li	a1,40
 730:	bff1                	j	70c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 732:	008b8913          	add	s2,s7,8
 736:	000bc583          	lbu	a1,0(s7)
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	dc0080e7          	jalr	-576(ra) # 4fc <putc>
 744:	8bca                	mv	s7,s2
      state = 0;
 746:	4981                	li	s3,0
 748:	b5d1                	j	60c <vprintf+0x42>
        putc(fd, c);
 74a:	02500593          	li	a1,37
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	dac080e7          	jalr	-596(ra) # 4fc <putc>
      state = 0;
 758:	4981                	li	s3,0
 75a:	bd4d                	j	60c <vprintf+0x42>
        putc(fd, '%');
 75c:	02500593          	li	a1,37
 760:	8556                	mv	a0,s5
 762:	00000097          	auipc	ra,0x0
 766:	d9a080e7          	jalr	-614(ra) # 4fc <putc>
        putc(fd, c);
 76a:	85ca                	mv	a1,s2
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	d8e080e7          	jalr	-626(ra) # 4fc <putc>
      state = 0;
 776:	4981                	li	s3,0
 778:	bd51                	j	60c <vprintf+0x42>
        s = va_arg(ap, char*);
 77a:	8bce                	mv	s7,s3
      state = 0;
 77c:	4981                	li	s3,0
 77e:	b579                	j	60c <vprintf+0x42>
 780:	74e2                	ld	s1,56(sp)
 782:	79a2                	ld	s3,40(sp)
 784:	7a02                	ld	s4,32(sp)
 786:	6ae2                	ld	s5,24(sp)
 788:	6b42                	ld	s6,16(sp)
 78a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 78c:	60a6                	ld	ra,72(sp)
 78e:	6406                	ld	s0,64(sp)
 790:	7942                	ld	s2,48(sp)
 792:	6161                	add	sp,sp,80
 794:	8082                	ret

0000000000000796 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 796:	715d                	add	sp,sp,-80
 798:	ec06                	sd	ra,24(sp)
 79a:	e822                	sd	s0,16(sp)
 79c:	1000                	add	s0,sp,32
 79e:	e010                	sd	a2,0(s0)
 7a0:	e414                	sd	a3,8(s0)
 7a2:	e818                	sd	a4,16(s0)
 7a4:	ec1c                	sd	a5,24(s0)
 7a6:	03043023          	sd	a6,32(s0)
 7aa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ae:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b2:	8622                	mv	a2,s0
 7b4:	00000097          	auipc	ra,0x0
 7b8:	e16080e7          	jalr	-490(ra) # 5ca <vprintf>
}
 7bc:	60e2                	ld	ra,24(sp)
 7be:	6442                	ld	s0,16(sp)
 7c0:	6161                	add	sp,sp,80
 7c2:	8082                	ret

00000000000007c4 <printf>:

void
printf(const char *fmt, ...)
{
 7c4:	711d                	add	sp,sp,-96
 7c6:	ec06                	sd	ra,24(sp)
 7c8:	e822                	sd	s0,16(sp)
 7ca:	1000                	add	s0,sp,32
 7cc:	e40c                	sd	a1,8(s0)
 7ce:	e810                	sd	a2,16(s0)
 7d0:	ec14                	sd	a3,24(s0)
 7d2:	f018                	sd	a4,32(s0)
 7d4:	f41c                	sd	a5,40(s0)
 7d6:	03043823          	sd	a6,48(s0)
 7da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7de:	00840613          	add	a2,s0,8
 7e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7e6:	85aa                	mv	a1,a0
 7e8:	4505                	li	a0,1
 7ea:	00000097          	auipc	ra,0x0
 7ee:	de0080e7          	jalr	-544(ra) # 5ca <vprintf>
}
 7f2:	60e2                	ld	ra,24(sp)
 7f4:	6442                	ld	s0,16(sp)
 7f6:	6125                	add	sp,sp,96
 7f8:	8082                	ret

00000000000007fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fa:	1141                	add	sp,sp,-16
 7fc:	e422                	sd	s0,8(sp)
 7fe:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 800:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 804:	00000797          	auipc	a5,0x0
 808:	26c7b783          	ld	a5,620(a5) # a70 <freep>
 80c:	a02d                	j	836 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 80e:	4618                	lw	a4,8(a2)
 810:	9f2d                	addw	a4,a4,a1
 812:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	6398                	ld	a4,0(a5)
 818:	6310                	ld	a2,0(a4)
 81a:	a83d                	j	858 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 81c:	ff852703          	lw	a4,-8(a0)
 820:	9f31                	addw	a4,a4,a2
 822:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 824:	ff053683          	ld	a3,-16(a0)
 828:	a091                	j	86c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82a:	6398                	ld	a4,0(a5)
 82c:	00e7e463          	bltu	a5,a4,834 <free+0x3a>
 830:	00e6ea63          	bltu	a3,a4,844 <free+0x4a>
{
 834:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 836:	fed7fae3          	bgeu	a5,a3,82a <free+0x30>
 83a:	6398                	ld	a4,0(a5)
 83c:	00e6e463          	bltu	a3,a4,844 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	fee7eae3          	bltu	a5,a4,834 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 844:	ff852583          	lw	a1,-8(a0)
 848:	6390                	ld	a2,0(a5)
 84a:	02059813          	sll	a6,a1,0x20
 84e:	01c85713          	srl	a4,a6,0x1c
 852:	9736                	add	a4,a4,a3
 854:	fae60de3          	beq	a2,a4,80e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 858:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 85c:	4790                	lw	a2,8(a5)
 85e:	02061593          	sll	a1,a2,0x20
 862:	01c5d713          	srl	a4,a1,0x1c
 866:	973e                	add	a4,a4,a5
 868:	fae68ae3          	beq	a3,a4,81c <free+0x22>
    p->s.ptr = bp->s.ptr;
 86c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 86e:	00000717          	auipc	a4,0x0
 872:	20f73123          	sd	a5,514(a4) # a70 <freep>
}
 876:	6422                	ld	s0,8(sp)
 878:	0141                	add	sp,sp,16
 87a:	8082                	ret

000000000000087c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 87c:	7139                	add	sp,sp,-64
 87e:	fc06                	sd	ra,56(sp)
 880:	f822                	sd	s0,48(sp)
 882:	f426                	sd	s1,40(sp)
 884:	ec4e                	sd	s3,24(sp)
 886:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 888:	02051493          	sll	s1,a0,0x20
 88c:	9081                	srl	s1,s1,0x20
 88e:	04bd                	add	s1,s1,15
 890:	8091                	srl	s1,s1,0x4
 892:	0014899b          	addw	s3,s1,1
 896:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 898:	00000517          	auipc	a0,0x0
 89c:	1d853503          	ld	a0,472(a0) # a70 <freep>
 8a0:	c915                	beqz	a0,8d4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a4:	4798                	lw	a4,8(a5)
 8a6:	08977e63          	bgeu	a4,s1,942 <malloc+0xc6>
 8aa:	f04a                	sd	s2,32(sp)
 8ac:	e852                	sd	s4,16(sp)
 8ae:	e456                	sd	s5,8(sp)
 8b0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8b2:	8a4e                	mv	s4,s3
 8b4:	0009871b          	sext.w	a4,s3
 8b8:	6685                	lui	a3,0x1
 8ba:	00d77363          	bgeu	a4,a3,8c0 <malloc+0x44>
 8be:	6a05                	lui	s4,0x1
 8c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c8:	00000917          	auipc	s2,0x0
 8cc:	1a890913          	add	s2,s2,424 # a70 <freep>
  if(p == (char*)-1)
 8d0:	5afd                	li	s5,-1
 8d2:	a091                	j	916 <malloc+0x9a>
 8d4:	f04a                	sd	s2,32(sp)
 8d6:	e852                	sd	s4,16(sp)
 8d8:	e456                	sd	s5,8(sp)
 8da:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8dc:	00000797          	auipc	a5,0x0
 8e0:	19c78793          	add	a5,a5,412 # a78 <base>
 8e4:	00000717          	auipc	a4,0x0
 8e8:	18f73623          	sd	a5,396(a4) # a70 <freep>
 8ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8f2:	b7c1                	j	8b2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8f4:	6398                	ld	a4,0(a5)
 8f6:	e118                	sd	a4,0(a0)
 8f8:	a08d                	j	95a <malloc+0xde>
  hp->s.size = nu;
 8fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8fe:	0541                	add	a0,a0,16
 900:	00000097          	auipc	ra,0x0
 904:	efa080e7          	jalr	-262(ra) # 7fa <free>
  return freep;
 908:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 90c:	c13d                	beqz	a0,972 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 910:	4798                	lw	a4,8(a5)
 912:	02977463          	bgeu	a4,s1,93a <malloc+0xbe>
    if(p == freep)
 916:	00093703          	ld	a4,0(s2)
 91a:	853e                	mv	a0,a5
 91c:	fef719e3          	bne	a4,a5,90e <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 920:	8552                	mv	a0,s4
 922:	00000097          	auipc	ra,0x0
 926:	bb2080e7          	jalr	-1102(ra) # 4d4 <sbrk>
  if(p == (char*)-1)
 92a:	fd5518e3          	bne	a0,s5,8fa <malloc+0x7e>
        return 0;
 92e:	4501                	li	a0,0
 930:	7902                	ld	s2,32(sp)
 932:	6a42                	ld	s4,16(sp)
 934:	6aa2                	ld	s5,8(sp)
 936:	6b02                	ld	s6,0(sp)
 938:	a03d                	j	966 <malloc+0xea>
 93a:	7902                	ld	s2,32(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 942:	fae489e3          	beq	s1,a4,8f4 <malloc+0x78>
        p->s.size -= nunits;
 946:	4137073b          	subw	a4,a4,s3
 94a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 94c:	02071693          	sll	a3,a4,0x20
 950:	01c6d713          	srl	a4,a3,0x1c
 954:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 956:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 95a:	00000717          	auipc	a4,0x0
 95e:	10a73b23          	sd	a0,278(a4) # a70 <freep>
      return (void*)(p + 1);
 962:	01078513          	add	a0,a5,16
  }
}
 966:	70e2                	ld	ra,56(sp)
 968:	7442                	ld	s0,48(sp)
 96a:	74a2                	ld	s1,40(sp)
 96c:	69e2                	ld	s3,24(sp)
 96e:	6121                	add	sp,sp,64
 970:	8082                	ret
 972:	7902                	ld	s2,32(sp)
 974:	6a42                	ld	s4,16(sp)
 976:	6aa2                	ld	s5,8(sp)
 978:	6b02                	ld	s6,0(sp)
 97a:	b7f5                	j	966 <malloc+0xea>
