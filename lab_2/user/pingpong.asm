
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	7139                	add	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	add	s0,sp,64
    int pipe_ping[2], pipe_pong[2];
    pipe(pipe_ping);
   8:	fd840513          	add	a0,s0,-40
   c:	00000097          	auipc	ra,0x0
  10:	36a080e7          	jalr	874(ra) # 376 <pipe>
    pipe(pipe_pong);
  14:	fd040513          	add	a0,s0,-48
  18:	00000097          	auipc	ra,0x0
  1c:	35e080e7          	jalr	862(ra) # 376 <pipe>
    char buf[] = {'p'};
  20:	07000793          	li	a5,112
  24:	fcf40423          	sb	a5,-56(s0)
    int pid;
    if (fork() == 0)
  28:	00000097          	auipc	ra,0x0
  2c:	336080e7          	jalr	822(ra) # 35e <fork>
  30:	e13d                	bnez	a0,96 <main+0x96>
  32:	f426                	sd	s1,40(sp)
    {
        pid = getpid();
  34:	00000097          	auipc	ra,0x0
  38:	3b2080e7          	jalr	946(ra) # 3e6 <getpid>
  3c:	84aa                	mv	s1,a0
        close(pipe_ping[1]);
  3e:	fdc42503          	lw	a0,-36(s0)
  42:	00000097          	auipc	ra,0x0
  46:	34c080e7          	jalr	844(ra) # 38e <close>
        close(pipe_pong[0]);
  4a:	fd042503          	lw	a0,-48(s0)
  4e:	00000097          	auipc	ra,0x0
  52:	340080e7          	jalr	832(ra) # 38e <close>
        read(pipe_ping[0], buf, 1);
  56:	4605                	li	a2,1
  58:	fc840593          	add	a1,s0,-56
  5c:	fd842503          	lw	a0,-40(s0)
  60:	00000097          	auipc	ra,0x0
  64:	31e080e7          	jalr	798(ra) # 37e <read>
        printf("%d: received ping\n", pid);
  68:	85a6                	mv	a1,s1
  6a:	00001517          	auipc	a0,0x1
  6e:	82e50513          	add	a0,a0,-2002 # 898 <malloc+0x102>
  72:	00000097          	auipc	ra,0x0
  76:	66c080e7          	jalr	1644(ra) # 6de <printf>
        write(pipe_pong[1], buf, 1);
  7a:	4605                	li	a2,1
  7c:	fc840593          	add	a1,s0,-56
  80:	fd442503          	lw	a0,-44(s0)
  84:	00000097          	auipc	ra,0x0
  88:	302080e7          	jalr	770(ra) # 386 <write>
        exit(0);
  8c:	4501                	li	a0,0
  8e:	00000097          	auipc	ra,0x0
  92:	2d8080e7          	jalr	728(ra) # 366 <exit>
  96:	f426                	sd	s1,40(sp)
    }
    else
    {
        pid = getpid();
  98:	00000097          	auipc	ra,0x0
  9c:	34e080e7          	jalr	846(ra) # 3e6 <getpid>
  a0:	84aa                	mv	s1,a0
        close(pipe_ping[0]);
  a2:	fd842503          	lw	a0,-40(s0)
  a6:	00000097          	auipc	ra,0x0
  aa:	2e8080e7          	jalr	744(ra) # 38e <close>
        close(pipe_pong[1]);
  ae:	fd442503          	lw	a0,-44(s0)
  b2:	00000097          	auipc	ra,0x0
  b6:	2dc080e7          	jalr	732(ra) # 38e <close>
        write(pipe_ping[1], buf, 1);
  ba:	4605                	li	a2,1
  bc:	fc840593          	add	a1,s0,-56
  c0:	fdc42503          	lw	a0,-36(s0)
  c4:	00000097          	auipc	ra,0x0
  c8:	2c2080e7          	jalr	706(ra) # 386 <write>
        read(pipe_pong[0], buf, 1);
  cc:	4605                	li	a2,1
  ce:	fc840593          	add	a1,s0,-56
  d2:	fd042503          	lw	a0,-48(s0)
  d6:	00000097          	auipc	ra,0x0
  da:	2a8080e7          	jalr	680(ra) # 37e <read>
        printf("%d: received pong\n", pid);
  de:	85a6                	mv	a1,s1
  e0:	00000517          	auipc	a0,0x0
  e4:	7d050513          	add	a0,a0,2000 # 8b0 <malloc+0x11a>
  e8:	00000097          	auipc	ra,0x0
  ec:	5f6080e7          	jalr	1526(ra) # 6de <printf>
        exit(0);
  f0:	4501                	li	a0,0
  f2:	00000097          	auipc	ra,0x0
  f6:	274080e7          	jalr	628(ra) # 366 <exit>

00000000000000fa <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  fa:	1141                	add	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 100:	87aa                	mv	a5,a0
 102:	0585                	add	a1,a1,1
 104:	0785                	add	a5,a5,1
 106:	fff5c703          	lbu	a4,-1(a1)
 10a:	fee78fa3          	sb	a4,-1(a5)
 10e:	fb75                	bnez	a4,102 <strcpy+0x8>
    ;
  return os;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	add	sp,sp,16
 114:	8082                	ret

0000000000000116 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 116:	1141                	add	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cb91                	beqz	a5,134 <strcmp+0x1e>
 122:	0005c703          	lbu	a4,0(a1)
 126:	00f71763          	bne	a4,a5,134 <strcmp+0x1e>
    p++, q++;
 12a:	0505                	add	a0,a0,1
 12c:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	fbe5                	bnez	a5,122 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 134:	0005c503          	lbu	a0,0(a1)
}
 138:	40a7853b          	subw	a0,a5,a0
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	add	sp,sp,16
 140:	8082                	ret

0000000000000142 <strlen>:

uint
strlen(const char *s)
{
 142:	1141                	add	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cf91                	beqz	a5,168 <strlen+0x26>
 14e:	0505                	add	a0,a0,1
 150:	87aa                	mv	a5,a0
 152:	86be                	mv	a3,a5
 154:	0785                	add	a5,a5,1
 156:	fff7c703          	lbu	a4,-1(a5)
 15a:	ff65                	bnez	a4,152 <strlen+0x10>
 15c:	40a6853b          	subw	a0,a3,a0
 160:	2505                	addw	a0,a0,1
    ;
  return n;
}
 162:	6422                	ld	s0,8(sp)
 164:	0141                	add	sp,sp,16
 166:	8082                	ret
  for(n = 0; s[n]; n++)
 168:	4501                	li	a0,0
 16a:	bfe5                	j	162 <strlen+0x20>

000000000000016c <memset>:

void*
memset(void *dst, int c, uint n)
{
 16c:	1141                	add	sp,sp,-16
 16e:	e422                	sd	s0,8(sp)
 170:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 172:	ca19                	beqz	a2,188 <memset+0x1c>
 174:	87aa                	mv	a5,a0
 176:	1602                	sll	a2,a2,0x20
 178:	9201                	srl	a2,a2,0x20
 17a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 182:	0785                	add	a5,a5,1
 184:	fee79de3          	bne	a5,a4,17e <memset+0x12>
  }
  return dst;
}
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	add	sp,sp,16
 18c:	8082                	ret

000000000000018e <strchr>:

char*
strchr(const char *s, char c)
{
 18e:	1141                	add	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	add	s0,sp,16
  for(; *s; s++)
 194:	00054783          	lbu	a5,0(a0)
 198:	cb99                	beqz	a5,1ae <strchr+0x20>
    if(*s == c)
 19a:	00f58763          	beq	a1,a5,1a8 <strchr+0x1a>
  for(; *s; s++)
 19e:	0505                	add	a0,a0,1
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	fbfd                	bnez	a5,19a <strchr+0xc>
      return (char*)s;
  return 0;
 1a6:	4501                	li	a0,0
}
 1a8:	6422                	ld	s0,8(sp)
 1aa:	0141                	add	sp,sp,16
 1ac:	8082                	ret
  return 0;
 1ae:	4501                	li	a0,0
 1b0:	bfe5                	j	1a8 <strchr+0x1a>

00000000000001b2 <gets>:

char*
gets(char *buf, int max)
{
 1b2:	711d                	add	sp,sp,-96
 1b4:	ec86                	sd	ra,88(sp)
 1b6:	e8a2                	sd	s0,80(sp)
 1b8:	e4a6                	sd	s1,72(sp)
 1ba:	e0ca                	sd	s2,64(sp)
 1bc:	fc4e                	sd	s3,56(sp)
 1be:	f852                	sd	s4,48(sp)
 1c0:	f456                	sd	s5,40(sp)
 1c2:	f05a                	sd	s6,32(sp)
 1c4:	ec5e                	sd	s7,24(sp)
 1c6:	1080                	add	s0,sp,96
 1c8:	8baa                	mv	s7,a0
 1ca:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cc:	892a                	mv	s2,a0
 1ce:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d0:	4aa9                	li	s5,10
 1d2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d4:	89a6                	mv	s3,s1
 1d6:	2485                	addw	s1,s1,1
 1d8:	0344d863          	bge	s1,s4,208 <gets+0x56>
    cc = read(0, &c, 1);
 1dc:	4605                	li	a2,1
 1de:	faf40593          	add	a1,s0,-81
 1e2:	4501                	li	a0,0
 1e4:	00000097          	auipc	ra,0x0
 1e8:	19a080e7          	jalr	410(ra) # 37e <read>
    if(cc < 1)
 1ec:	00a05e63          	blez	a0,208 <gets+0x56>
    buf[i++] = c;
 1f0:	faf44783          	lbu	a5,-81(s0)
 1f4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f8:	01578763          	beq	a5,s5,206 <gets+0x54>
 1fc:	0905                	add	s2,s2,1
 1fe:	fd679be3          	bne	a5,s6,1d4 <gets+0x22>
    buf[i++] = c;
 202:	89a6                	mv	s3,s1
 204:	a011                	j	208 <gets+0x56>
 206:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 208:	99de                	add	s3,s3,s7
 20a:	00098023          	sb	zero,0(s3)
  return buf;
}
 20e:	855e                	mv	a0,s7
 210:	60e6                	ld	ra,88(sp)
 212:	6446                	ld	s0,80(sp)
 214:	64a6                	ld	s1,72(sp)
 216:	6906                	ld	s2,64(sp)
 218:	79e2                	ld	s3,56(sp)
 21a:	7a42                	ld	s4,48(sp)
 21c:	7aa2                	ld	s5,40(sp)
 21e:	7b02                	ld	s6,32(sp)
 220:	6be2                	ld	s7,24(sp)
 222:	6125                	add	sp,sp,96
 224:	8082                	ret

0000000000000226 <stat>:

int
stat(const char *n, struct stat *st)
{
 226:	1101                	add	sp,sp,-32
 228:	ec06                	sd	ra,24(sp)
 22a:	e822                	sd	s0,16(sp)
 22c:	e04a                	sd	s2,0(sp)
 22e:	1000                	add	s0,sp,32
 230:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 232:	4581                	li	a1,0
 234:	00000097          	auipc	ra,0x0
 238:	172080e7          	jalr	370(ra) # 3a6 <open>
  if(fd < 0)
 23c:	02054663          	bltz	a0,268 <stat+0x42>
 240:	e426                	sd	s1,8(sp)
 242:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 244:	85ca                	mv	a1,s2
 246:	00000097          	auipc	ra,0x0
 24a:	178080e7          	jalr	376(ra) # 3be <fstat>
 24e:	892a                	mv	s2,a0
  close(fd);
 250:	8526                	mv	a0,s1
 252:	00000097          	auipc	ra,0x0
 256:	13c080e7          	jalr	316(ra) # 38e <close>
  return r;
 25a:	64a2                	ld	s1,8(sp)
}
 25c:	854a                	mv	a0,s2
 25e:	60e2                	ld	ra,24(sp)
 260:	6442                	ld	s0,16(sp)
 262:	6902                	ld	s2,0(sp)
 264:	6105                	add	sp,sp,32
 266:	8082                	ret
    return -1;
 268:	597d                	li	s2,-1
 26a:	bfcd                	j	25c <stat+0x36>

000000000000026c <atoi>:

int
atoi(const char *s)
{
 26c:	1141                	add	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 272:	00054683          	lbu	a3,0(a0)
 276:	fd06879b          	addw	a5,a3,-48
 27a:	0ff7f793          	zext.b	a5,a5
 27e:	4625                	li	a2,9
 280:	02f66863          	bltu	a2,a5,2b0 <atoi+0x44>
 284:	872a                	mv	a4,a0
  n = 0;
 286:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 288:	0705                	add	a4,a4,1
 28a:	0025179b          	sllw	a5,a0,0x2
 28e:	9fa9                	addw	a5,a5,a0
 290:	0017979b          	sllw	a5,a5,0x1
 294:	9fb5                	addw	a5,a5,a3
 296:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 29a:	00074683          	lbu	a3,0(a4)
 29e:	fd06879b          	addw	a5,a3,-48
 2a2:	0ff7f793          	zext.b	a5,a5
 2a6:	fef671e3          	bgeu	a2,a5,288 <atoi+0x1c>
  return n;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	add	sp,sp,16
 2ae:	8082                	ret
  n = 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <atoi+0x3e>

00000000000002b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b4:	1141                	add	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ba:	02b57463          	bgeu	a0,a1,2e2 <memmove+0x2e>
    while(n-- > 0)
 2be:	00c05f63          	blez	a2,2dc <memmove+0x28>
 2c2:	1602                	sll	a2,a2,0x20
 2c4:	9201                	srl	a2,a2,0x20
 2c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 2cc:	0585                	add	a1,a1,1
 2ce:	0705                	add	a4,a4,1
 2d0:	fff5c683          	lbu	a3,-1(a1)
 2d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d8:	fef71ae3          	bne	a4,a5,2cc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	add	sp,sp,16
 2e0:	8082                	ret
    dst += n;
 2e2:	00c50733          	add	a4,a0,a2
    src += n;
 2e6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e8:	fec05ae3          	blez	a2,2dc <memmove+0x28>
 2ec:	fff6079b          	addw	a5,a2,-1
 2f0:	1782                	sll	a5,a5,0x20
 2f2:	9381                	srl	a5,a5,0x20
 2f4:	fff7c793          	not	a5,a5
 2f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2fa:	15fd                	add	a1,a1,-1
 2fc:	177d                	add	a4,a4,-1
 2fe:	0005c683          	lbu	a3,0(a1)
 302:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 306:	fee79ae3          	bne	a5,a4,2fa <memmove+0x46>
 30a:	bfc9                	j	2dc <memmove+0x28>

000000000000030c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30c:	1141                	add	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 312:	ca05                	beqz	a2,342 <memcmp+0x36>
 314:	fff6069b          	addw	a3,a2,-1
 318:	1682                	sll	a3,a3,0x20
 31a:	9281                	srl	a3,a3,0x20
 31c:	0685                	add	a3,a3,1
 31e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 320:	00054783          	lbu	a5,0(a0)
 324:	0005c703          	lbu	a4,0(a1)
 328:	00e79863          	bne	a5,a4,338 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 32c:	0505                	add	a0,a0,1
    p2++;
 32e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 330:	fed518e3          	bne	a0,a3,320 <memcmp+0x14>
  }
  return 0;
 334:	4501                	li	a0,0
 336:	a019                	j	33c <memcmp+0x30>
      return *p1 - *p2;
 338:	40e7853b          	subw	a0,a5,a4
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	add	sp,sp,16
 340:	8082                	ret
  return 0;
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <memcmp+0x30>

0000000000000346 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 346:	1141                	add	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 34e:	00000097          	auipc	ra,0x0
 352:	f66080e7          	jalr	-154(ra) # 2b4 <memmove>
}
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	add	sp,sp,16
 35c:	8082                	ret

000000000000035e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 35e:	4885                	li	a7,1
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <exit>:
.global exit
exit:
 li a7, SYS_exit
 366:	4889                	li	a7,2
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <wait>:
.global wait
wait:
 li a7, SYS_wait
 36e:	488d                	li	a7,3
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 376:	4891                	li	a7,4
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <read>:
.global read
read:
 li a7, SYS_read
 37e:	4895                	li	a7,5
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <write>:
.global write
write:
 li a7, SYS_write
 386:	48c1                	li	a7,16
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <close>:
.global close
close:
 li a7, SYS_close
 38e:	48d5                	li	a7,21
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <kill>:
.global kill
kill:
 li a7, SYS_kill
 396:	4899                	li	a7,6
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <exec>:
.global exec
exec:
 li a7, SYS_exec
 39e:	489d                	li	a7,7
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <open>:
.global open
open:
 li a7, SYS_open
 3a6:	48bd                	li	a7,15
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ae:	48c5                	li	a7,17
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b6:	48c9                	li	a7,18
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3be:	48a1                	li	a7,8
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <link>:
.global link
link:
 li a7, SYS_link
 3c6:	48cd                	li	a7,19
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ce:	48d1                	li	a7,20
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d6:	48a5                	li	a7,9
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <dup>:
.global dup
dup:
 li a7, SYS_dup
 3de:	48a9                	li	a7,10
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e6:	48ad                	li	a7,11
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ee:	48b1                	li	a7,12
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f6:	48b5                	li	a7,13
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3fe:	48b9                	li	a7,14
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <trace>:
.global trace
trace:
 li a7, SYS_trace
 406:	48d9                	li	a7,22
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 40e:	48dd                	li	a7,23
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 416:	1101                	add	sp,sp,-32
 418:	ec06                	sd	ra,24(sp)
 41a:	e822                	sd	s0,16(sp)
 41c:	1000                	add	s0,sp,32
 41e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 422:	4605                	li	a2,1
 424:	fef40593          	add	a1,s0,-17
 428:	00000097          	auipc	ra,0x0
 42c:	f5e080e7          	jalr	-162(ra) # 386 <write>
}
 430:	60e2                	ld	ra,24(sp)
 432:	6442                	ld	s0,16(sp)
 434:	6105                	add	sp,sp,32
 436:	8082                	ret

0000000000000438 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 438:	7139                	add	sp,sp,-64
 43a:	fc06                	sd	ra,56(sp)
 43c:	f822                	sd	s0,48(sp)
 43e:	f426                	sd	s1,40(sp)
 440:	0080                	add	s0,sp,64
 442:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 444:	c299                	beqz	a3,44a <printint+0x12>
 446:	0805cb63          	bltz	a1,4dc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 44a:	2581                	sext.w	a1,a1
  neg = 0;
 44c:	4881                	li	a7,0
 44e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 452:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 454:	2601                	sext.w	a2,a2
 456:	00000517          	auipc	a0,0x0
 45a:	4d250513          	add	a0,a0,1234 # 928 <digits>
 45e:	883a                	mv	a6,a4
 460:	2705                	addw	a4,a4,1
 462:	02c5f7bb          	remuw	a5,a1,a2
 466:	1782                	sll	a5,a5,0x20
 468:	9381                	srl	a5,a5,0x20
 46a:	97aa                	add	a5,a5,a0
 46c:	0007c783          	lbu	a5,0(a5)
 470:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 474:	0005879b          	sext.w	a5,a1
 478:	02c5d5bb          	divuw	a1,a1,a2
 47c:	0685                	add	a3,a3,1
 47e:	fec7f0e3          	bgeu	a5,a2,45e <printint+0x26>
  if(neg)
 482:	00088c63          	beqz	a7,49a <printint+0x62>
    buf[i++] = '-';
 486:	fd070793          	add	a5,a4,-48
 48a:	00878733          	add	a4,a5,s0
 48e:	02d00793          	li	a5,45
 492:	fef70823          	sb	a5,-16(a4)
 496:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 49a:	02e05c63          	blez	a4,4d2 <printint+0x9a>
 49e:	f04a                	sd	s2,32(sp)
 4a0:	ec4e                	sd	s3,24(sp)
 4a2:	fc040793          	add	a5,s0,-64
 4a6:	00e78933          	add	s2,a5,a4
 4aa:	fff78993          	add	s3,a5,-1
 4ae:	99ba                	add	s3,s3,a4
 4b0:	377d                	addw	a4,a4,-1
 4b2:	1702                	sll	a4,a4,0x20
 4b4:	9301                	srl	a4,a4,0x20
 4b6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ba:	fff94583          	lbu	a1,-1(s2)
 4be:	8526                	mv	a0,s1
 4c0:	00000097          	auipc	ra,0x0
 4c4:	f56080e7          	jalr	-170(ra) # 416 <putc>
  while(--i >= 0)
 4c8:	197d                	add	s2,s2,-1
 4ca:	ff3918e3          	bne	s2,s3,4ba <printint+0x82>
 4ce:	7902                	ld	s2,32(sp)
 4d0:	69e2                	ld	s3,24(sp)
}
 4d2:	70e2                	ld	ra,56(sp)
 4d4:	7442                	ld	s0,48(sp)
 4d6:	74a2                	ld	s1,40(sp)
 4d8:	6121                	add	sp,sp,64
 4da:	8082                	ret
    x = -xx;
 4dc:	40b005bb          	negw	a1,a1
    neg = 1;
 4e0:	4885                	li	a7,1
    x = -xx;
 4e2:	b7b5                	j	44e <printint+0x16>

00000000000004e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e4:	715d                	add	sp,sp,-80
 4e6:	e486                	sd	ra,72(sp)
 4e8:	e0a2                	sd	s0,64(sp)
 4ea:	f84a                	sd	s2,48(sp)
 4ec:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ee:	0005c903          	lbu	s2,0(a1)
 4f2:	1a090a63          	beqz	s2,6a6 <vprintf+0x1c2>
 4f6:	fc26                	sd	s1,56(sp)
 4f8:	f44e                	sd	s3,40(sp)
 4fa:	f052                	sd	s4,32(sp)
 4fc:	ec56                	sd	s5,24(sp)
 4fe:	e85a                	sd	s6,16(sp)
 500:	e45e                	sd	s7,8(sp)
 502:	8aaa                	mv	s5,a0
 504:	8bb2                	mv	s7,a2
 506:	00158493          	add	s1,a1,1
  state = 0;
 50a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 50c:	02500a13          	li	s4,37
 510:	4b55                	li	s6,21
 512:	a839                	j	530 <vprintf+0x4c>
        putc(fd, c);
 514:	85ca                	mv	a1,s2
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	efe080e7          	jalr	-258(ra) # 416 <putc>
 520:	a019                	j	526 <vprintf+0x42>
    } else if(state == '%'){
 522:	01498d63          	beq	s3,s4,53c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 526:	0485                	add	s1,s1,1
 528:	fff4c903          	lbu	s2,-1(s1)
 52c:	16090763          	beqz	s2,69a <vprintf+0x1b6>
    if(state == 0){
 530:	fe0999e3          	bnez	s3,522 <vprintf+0x3e>
      if(c == '%'){
 534:	ff4910e3          	bne	s2,s4,514 <vprintf+0x30>
        state = '%';
 538:	89d2                	mv	s3,s4
 53a:	b7f5                	j	526 <vprintf+0x42>
      if(c == 'd'){
 53c:	13490463          	beq	s2,s4,664 <vprintf+0x180>
 540:	f9d9079b          	addw	a5,s2,-99
 544:	0ff7f793          	zext.b	a5,a5
 548:	12fb6763          	bltu	s6,a5,676 <vprintf+0x192>
 54c:	f9d9079b          	addw	a5,s2,-99
 550:	0ff7f713          	zext.b	a4,a5
 554:	12eb6163          	bltu	s6,a4,676 <vprintf+0x192>
 558:	00271793          	sll	a5,a4,0x2
 55c:	00000717          	auipc	a4,0x0
 560:	37470713          	add	a4,a4,884 # 8d0 <malloc+0x13a>
 564:	97ba                	add	a5,a5,a4
 566:	439c                	lw	a5,0(a5)
 568:	97ba                	add	a5,a5,a4
 56a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 56c:	008b8913          	add	s2,s7,8
 570:	4685                	li	a3,1
 572:	4629                	li	a2,10
 574:	000ba583          	lw	a1,0(s7)
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	ebe080e7          	jalr	-322(ra) # 438 <printint>
 582:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 584:	4981                	li	s3,0
 586:	b745                	j	526 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 588:	008b8913          	add	s2,s7,8
 58c:	4681                	li	a3,0
 58e:	4629                	li	a2,10
 590:	000ba583          	lw	a1,0(s7)
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	ea2080e7          	jalr	-350(ra) # 438 <printint>
 59e:	8bca                	mv	s7,s2
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b751                	j	526 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5a4:	008b8913          	add	s2,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4641                	li	a2,16
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	e86080e7          	jalr	-378(ra) # 438 <printint>
 5ba:	8bca                	mv	s7,s2
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b7a5                	j	526 <vprintf+0x42>
 5c0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5c2:	008b8c13          	add	s8,s7,8
 5c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ca:	03000593          	li	a1,48
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	e46080e7          	jalr	-442(ra) # 416 <putc>
  putc(fd, 'x');
 5d8:	07800593          	li	a1,120
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	e38080e7          	jalr	-456(ra) # 416 <putc>
 5e6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e8:	00000b97          	auipc	s7,0x0
 5ec:	340b8b93          	add	s7,s7,832 # 928 <digits>
 5f0:	03c9d793          	srl	a5,s3,0x3c
 5f4:	97de                	add	a5,a5,s7
 5f6:	0007c583          	lbu	a1,0(a5)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	e1a080e7          	jalr	-486(ra) # 416 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 604:	0992                	sll	s3,s3,0x4
 606:	397d                	addw	s2,s2,-1
 608:	fe0914e3          	bnez	s2,5f0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 60c:	8be2                	mv	s7,s8
      state = 0;
 60e:	4981                	li	s3,0
 610:	6c02                	ld	s8,0(sp)
 612:	bf11                	j	526 <vprintf+0x42>
        s = va_arg(ap, char*);
 614:	008b8993          	add	s3,s7,8
 618:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 61c:	02090163          	beqz	s2,63e <vprintf+0x15a>
        while(*s != 0){
 620:	00094583          	lbu	a1,0(s2)
 624:	c9a5                	beqz	a1,694 <vprintf+0x1b0>
          putc(fd, *s);
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	dee080e7          	jalr	-530(ra) # 416 <putc>
          s++;
 630:	0905                	add	s2,s2,1
        while(*s != 0){
 632:	00094583          	lbu	a1,0(s2)
 636:	f9e5                	bnez	a1,626 <vprintf+0x142>
        s = va_arg(ap, char*);
 638:	8bce                	mv	s7,s3
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b5ed                	j	526 <vprintf+0x42>
          s = "(null)";
 63e:	00000917          	auipc	s2,0x0
 642:	28a90913          	add	s2,s2,650 # 8c8 <malloc+0x132>
        while(*s != 0){
 646:	02800593          	li	a1,40
 64a:	bff1                	j	626 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 64c:	008b8913          	add	s2,s7,8
 650:	000bc583          	lbu	a1,0(s7)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	dc0080e7          	jalr	-576(ra) # 416 <putc>
 65e:	8bca                	mv	s7,s2
      state = 0;
 660:	4981                	li	s3,0
 662:	b5d1                	j	526 <vprintf+0x42>
        putc(fd, c);
 664:	02500593          	li	a1,37
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	dac080e7          	jalr	-596(ra) # 416 <putc>
      state = 0;
 672:	4981                	li	s3,0
 674:	bd4d                	j	526 <vprintf+0x42>
        putc(fd, '%');
 676:	02500593          	li	a1,37
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	d9a080e7          	jalr	-614(ra) # 416 <putc>
        putc(fd, c);
 684:	85ca                	mv	a1,s2
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	d8e080e7          	jalr	-626(ra) # 416 <putc>
      state = 0;
 690:	4981                	li	s3,0
 692:	bd51                	j	526 <vprintf+0x42>
        s = va_arg(ap, char*);
 694:	8bce                	mv	s7,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	b579                	j	526 <vprintf+0x42>
 69a:	74e2                	ld	s1,56(sp)
 69c:	79a2                	ld	s3,40(sp)
 69e:	7a02                	ld	s4,32(sp)
 6a0:	6ae2                	ld	s5,24(sp)
 6a2:	6b42                	ld	s6,16(sp)
 6a4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6a6:	60a6                	ld	ra,72(sp)
 6a8:	6406                	ld	s0,64(sp)
 6aa:	7942                	ld	s2,48(sp)
 6ac:	6161                	add	sp,sp,80
 6ae:	8082                	ret

00000000000006b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b0:	715d                	add	sp,sp,-80
 6b2:	ec06                	sd	ra,24(sp)
 6b4:	e822                	sd	s0,16(sp)
 6b6:	1000                	add	s0,sp,32
 6b8:	e010                	sd	a2,0(s0)
 6ba:	e414                	sd	a3,8(s0)
 6bc:	e818                	sd	a4,16(s0)
 6be:	ec1c                	sd	a5,24(s0)
 6c0:	03043023          	sd	a6,32(s0)
 6c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6cc:	8622                	mv	a2,s0
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e16080e7          	jalr	-490(ra) # 4e4 <vprintf>
}
 6d6:	60e2                	ld	ra,24(sp)
 6d8:	6442                	ld	s0,16(sp)
 6da:	6161                	add	sp,sp,80
 6dc:	8082                	ret

00000000000006de <printf>:

void
printf(const char *fmt, ...)
{
 6de:	711d                	add	sp,sp,-96
 6e0:	ec06                	sd	ra,24(sp)
 6e2:	e822                	sd	s0,16(sp)
 6e4:	1000                	add	s0,sp,32
 6e6:	e40c                	sd	a1,8(s0)
 6e8:	e810                	sd	a2,16(s0)
 6ea:	ec14                	sd	a3,24(s0)
 6ec:	f018                	sd	a4,32(s0)
 6ee:	f41c                	sd	a5,40(s0)
 6f0:	03043823          	sd	a6,48(s0)
 6f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f8:	00840613          	add	a2,s0,8
 6fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 700:	85aa                	mv	a1,a0
 702:	4505                	li	a0,1
 704:	00000097          	auipc	ra,0x0
 708:	de0080e7          	jalr	-544(ra) # 4e4 <vprintf>
}
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6125                	add	sp,sp,96
 712:	8082                	ret

0000000000000714 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 714:	1141                	add	sp,sp,-16
 716:	e422                	sd	s0,8(sp)
 718:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	00000797          	auipc	a5,0x0
 722:	2227b783          	ld	a5,546(a5) # 940 <freep>
 726:	a02d                	j	750 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 728:	4618                	lw	a4,8(a2)
 72a:	9f2d                	addw	a4,a4,a1
 72c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 730:	6398                	ld	a4,0(a5)
 732:	6310                	ld	a2,0(a4)
 734:	a83d                	j	772 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 736:	ff852703          	lw	a4,-8(a0)
 73a:	9f31                	addw	a4,a4,a2
 73c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 73e:	ff053683          	ld	a3,-16(a0)
 742:	a091                	j	786 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	6398                	ld	a4,0(a5)
 746:	00e7e463          	bltu	a5,a4,74e <free+0x3a>
 74a:	00e6ea63          	bltu	a3,a4,75e <free+0x4a>
{
 74e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 750:	fed7fae3          	bgeu	a5,a3,744 <free+0x30>
 754:	6398                	ld	a4,0(a5)
 756:	00e6e463          	bltu	a3,a4,75e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75a:	fee7eae3          	bltu	a5,a4,74e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 75e:	ff852583          	lw	a1,-8(a0)
 762:	6390                	ld	a2,0(a5)
 764:	02059813          	sll	a6,a1,0x20
 768:	01c85713          	srl	a4,a6,0x1c
 76c:	9736                	add	a4,a4,a3
 76e:	fae60de3          	beq	a2,a4,728 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 772:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 776:	4790                	lw	a2,8(a5)
 778:	02061593          	sll	a1,a2,0x20
 77c:	01c5d713          	srl	a4,a1,0x1c
 780:	973e                	add	a4,a4,a5
 782:	fae68ae3          	beq	a3,a4,736 <free+0x22>
    p->s.ptr = bp->s.ptr;
 786:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 788:	00000717          	auipc	a4,0x0
 78c:	1af73c23          	sd	a5,440(a4) # 940 <freep>
}
 790:	6422                	ld	s0,8(sp)
 792:	0141                	add	sp,sp,16
 794:	8082                	ret

0000000000000796 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 796:	7139                	add	sp,sp,-64
 798:	fc06                	sd	ra,56(sp)
 79a:	f822                	sd	s0,48(sp)
 79c:	f426                	sd	s1,40(sp)
 79e:	ec4e                	sd	s3,24(sp)
 7a0:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a2:	02051493          	sll	s1,a0,0x20
 7a6:	9081                	srl	s1,s1,0x20
 7a8:	04bd                	add	s1,s1,15
 7aa:	8091                	srl	s1,s1,0x4
 7ac:	0014899b          	addw	s3,s1,1
 7b0:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7b2:	00000517          	auipc	a0,0x0
 7b6:	18e53503          	ld	a0,398(a0) # 940 <freep>
 7ba:	c915                	beqz	a0,7ee <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7be:	4798                	lw	a4,8(a5)
 7c0:	08977e63          	bgeu	a4,s1,85c <malloc+0xc6>
 7c4:	f04a                	sd	s2,32(sp)
 7c6:	e852                	sd	s4,16(sp)
 7c8:	e456                	sd	s5,8(sp)
 7ca:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7cc:	8a4e                	mv	s4,s3
 7ce:	0009871b          	sext.w	a4,s3
 7d2:	6685                	lui	a3,0x1
 7d4:	00d77363          	bgeu	a4,a3,7da <malloc+0x44>
 7d8:	6a05                	lui	s4,0x1
 7da:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7de:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e2:	00000917          	auipc	s2,0x0
 7e6:	15e90913          	add	s2,s2,350 # 940 <freep>
  if(p == (char*)-1)
 7ea:	5afd                	li	s5,-1
 7ec:	a091                	j	830 <malloc+0x9a>
 7ee:	f04a                	sd	s2,32(sp)
 7f0:	e852                	sd	s4,16(sp)
 7f2:	e456                	sd	s5,8(sp)
 7f4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7f6:	00000797          	auipc	a5,0x0
 7fa:	15278793          	add	a5,a5,338 # 948 <base>
 7fe:	00000717          	auipc	a4,0x0
 802:	14f73123          	sd	a5,322(a4) # 940 <freep>
 806:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 808:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 80c:	b7c1                	j	7cc <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 80e:	6398                	ld	a4,0(a5)
 810:	e118                	sd	a4,0(a0)
 812:	a08d                	j	874 <malloc+0xde>
  hp->s.size = nu;
 814:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 818:	0541                	add	a0,a0,16
 81a:	00000097          	auipc	ra,0x0
 81e:	efa080e7          	jalr	-262(ra) # 714 <free>
  return freep;
 822:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 826:	c13d                	beqz	a0,88c <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82a:	4798                	lw	a4,8(a5)
 82c:	02977463          	bgeu	a4,s1,854 <malloc+0xbe>
    if(p == freep)
 830:	00093703          	ld	a4,0(s2)
 834:	853e                	mv	a0,a5
 836:	fef719e3          	bne	a4,a5,828 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 83a:	8552                	mv	a0,s4
 83c:	00000097          	auipc	ra,0x0
 840:	bb2080e7          	jalr	-1102(ra) # 3ee <sbrk>
  if(p == (char*)-1)
 844:	fd5518e3          	bne	a0,s5,814 <malloc+0x7e>
        return 0;
 848:	4501                	li	a0,0
 84a:	7902                	ld	s2,32(sp)
 84c:	6a42                	ld	s4,16(sp)
 84e:	6aa2                	ld	s5,8(sp)
 850:	6b02                	ld	s6,0(sp)
 852:	a03d                	j	880 <malloc+0xea>
 854:	7902                	ld	s2,32(sp)
 856:	6a42                	ld	s4,16(sp)
 858:	6aa2                	ld	s5,8(sp)
 85a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 85c:	fae489e3          	beq	s1,a4,80e <malloc+0x78>
        p->s.size -= nunits;
 860:	4137073b          	subw	a4,a4,s3
 864:	c798                	sw	a4,8(a5)
        p += p->s.size;
 866:	02071693          	sll	a3,a4,0x20
 86a:	01c6d713          	srl	a4,a3,0x1c
 86e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 870:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 874:	00000717          	auipc	a4,0x0
 878:	0ca73623          	sd	a0,204(a4) # 940 <freep>
      return (void*)(p + 1);
 87c:	01078513          	add	a0,a5,16
  }
}
 880:	70e2                	ld	ra,56(sp)
 882:	7442                	ld	s0,48(sp)
 884:	74a2                	ld	s1,40(sp)
 886:	69e2                	ld	s3,24(sp)
 888:	6121                	add	sp,sp,64
 88a:	8082                	ret
 88c:	7902                	ld	s2,32(sp)
 88e:	6a42                	ld	s4,16(sp)
 890:	6aa2                	ld	s5,8(sp)
 892:	6b02                	ld	s6,0(sp)
 894:	b7f5                	j	880 <malloc+0xea>
