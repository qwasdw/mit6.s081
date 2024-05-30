
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
    if (argc < 2)
   8:	4785                	li	a5,1
   a:	00a7df63          	bge	a5,a0,28 <main+0x28>
    {
        printf("Usage: sleep [seconds]\n");
        exit(0);
    }
    int seconds = atoi(argv[1]);
   e:	6588                	ld	a0,8(a1)
  10:	00000097          	auipc	ra,0x0
  14:	1a4080e7          	jalr	420(ra) # 1b4 <atoi>
    int ret = sleep(seconds);
  18:	00000097          	auipc	ra,0x0
  1c:	326080e7          	jalr	806(ra) # 33e <sleep>
    exit(ret);
  20:	00000097          	auipc	ra,0x0
  24:	28e080e7          	jalr	654(ra) # 2ae <exit>
        printf("Usage: sleep [seconds]\n");
  28:	00000517          	auipc	a0,0x0
  2c:	7a850513          	add	a0,a0,1960 # 7d0 <malloc+0x102>
  30:	00000097          	auipc	ra,0x0
  34:	5e6080e7          	jalr	1510(ra) # 616 <printf>
        exit(0);
  38:	4501                	li	a0,0
  3a:	00000097          	auipc	ra,0x0
  3e:	274080e7          	jalr	628(ra) # 2ae <exit>

0000000000000042 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  42:	1141                	add	sp,sp,-16
  44:	e422                	sd	s0,8(sp)
  46:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  48:	87aa                	mv	a5,a0
  4a:	0585                	add	a1,a1,1
  4c:	0785                	add	a5,a5,1
  4e:	fff5c703          	lbu	a4,-1(a1)
  52:	fee78fa3          	sb	a4,-1(a5)
  56:	fb75                	bnez	a4,4a <strcpy+0x8>
    ;
  return os;
}
  58:	6422                	ld	s0,8(sp)
  5a:	0141                	add	sp,sp,16
  5c:	8082                	ret

000000000000005e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  5e:	1141                	add	sp,sp,-16
  60:	e422                	sd	s0,8(sp)
  62:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	cb91                	beqz	a5,7c <strcmp+0x1e>
  6a:	0005c703          	lbu	a4,0(a1)
  6e:	00f71763          	bne	a4,a5,7c <strcmp+0x1e>
    p++, q++;
  72:	0505                	add	a0,a0,1
  74:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  76:	00054783          	lbu	a5,0(a0)
  7a:	fbe5                	bnez	a5,6a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7c:	0005c503          	lbu	a0,0(a1)
}
  80:	40a7853b          	subw	a0,a5,a0
  84:	6422                	ld	s0,8(sp)
  86:	0141                	add	sp,sp,16
  88:	8082                	ret

000000000000008a <strlen>:

uint
strlen(const char *s)
{
  8a:	1141                	add	sp,sp,-16
  8c:	e422                	sd	s0,8(sp)
  8e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  90:	00054783          	lbu	a5,0(a0)
  94:	cf91                	beqz	a5,b0 <strlen+0x26>
  96:	0505                	add	a0,a0,1
  98:	87aa                	mv	a5,a0
  9a:	86be                	mv	a3,a5
  9c:	0785                	add	a5,a5,1
  9e:	fff7c703          	lbu	a4,-1(a5)
  a2:	ff65                	bnez	a4,9a <strlen+0x10>
  a4:	40a6853b          	subw	a0,a3,a0
  a8:	2505                	addw	a0,a0,1
    ;
  return n;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	add	sp,sp,16
  ae:	8082                	ret
  for(n = 0; s[n]; n++)
  b0:	4501                	li	a0,0
  b2:	bfe5                	j	aa <strlen+0x20>

00000000000000b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b4:	1141                	add	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ba:	ca19                	beqz	a2,d0 <memset+0x1c>
  bc:	87aa                	mv	a5,a0
  be:	1602                	sll	a2,a2,0x20
  c0:	9201                	srl	a2,a2,0x20
  c2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ca:	0785                	add	a5,a5,1
  cc:	fee79de3          	bne	a5,a4,c6 <memset+0x12>
  }
  return dst;
}
  d0:	6422                	ld	s0,8(sp)
  d2:	0141                	add	sp,sp,16
  d4:	8082                	ret

00000000000000d6 <strchr>:

char*
strchr(const char *s, char c)
{
  d6:	1141                	add	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	add	s0,sp,16
  for(; *s; s++)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cb99                	beqz	a5,f6 <strchr+0x20>
    if(*s == c)
  e2:	00f58763          	beq	a1,a5,f0 <strchr+0x1a>
  for(; *s; s++)
  e6:	0505                	add	a0,a0,1
  e8:	00054783          	lbu	a5,0(a0)
  ec:	fbfd                	bnez	a5,e2 <strchr+0xc>
      return (char*)s;
  return 0;
  ee:	4501                	li	a0,0
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	add	sp,sp,16
  f4:	8082                	ret
  return 0;
  f6:	4501                	li	a0,0
  f8:	bfe5                	j	f0 <strchr+0x1a>

00000000000000fa <gets>:

char*
gets(char *buf, int max)
{
  fa:	711d                	add	sp,sp,-96
  fc:	ec86                	sd	ra,88(sp)
  fe:	e8a2                	sd	s0,80(sp)
 100:	e4a6                	sd	s1,72(sp)
 102:	e0ca                	sd	s2,64(sp)
 104:	fc4e                	sd	s3,56(sp)
 106:	f852                	sd	s4,48(sp)
 108:	f456                	sd	s5,40(sp)
 10a:	f05a                	sd	s6,32(sp)
 10c:	ec5e                	sd	s7,24(sp)
 10e:	1080                	add	s0,sp,96
 110:	8baa                	mv	s7,a0
 112:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 114:	892a                	mv	s2,a0
 116:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 118:	4aa9                	li	s5,10
 11a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11c:	89a6                	mv	s3,s1
 11e:	2485                	addw	s1,s1,1
 120:	0344d863          	bge	s1,s4,150 <gets+0x56>
    cc = read(0, &c, 1);
 124:	4605                	li	a2,1
 126:	faf40593          	add	a1,s0,-81
 12a:	4501                	li	a0,0
 12c:	00000097          	auipc	ra,0x0
 130:	19a080e7          	jalr	410(ra) # 2c6 <read>
    if(cc < 1)
 134:	00a05e63          	blez	a0,150 <gets+0x56>
    buf[i++] = c;
 138:	faf44783          	lbu	a5,-81(s0)
 13c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 140:	01578763          	beq	a5,s5,14e <gets+0x54>
 144:	0905                	add	s2,s2,1
 146:	fd679be3          	bne	a5,s6,11c <gets+0x22>
    buf[i++] = c;
 14a:	89a6                	mv	s3,s1
 14c:	a011                	j	150 <gets+0x56>
 14e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 150:	99de                	add	s3,s3,s7
 152:	00098023          	sb	zero,0(s3)
  return buf;
}
 156:	855e                	mv	a0,s7
 158:	60e6                	ld	ra,88(sp)
 15a:	6446                	ld	s0,80(sp)
 15c:	64a6                	ld	s1,72(sp)
 15e:	6906                	ld	s2,64(sp)
 160:	79e2                	ld	s3,56(sp)
 162:	7a42                	ld	s4,48(sp)
 164:	7aa2                	ld	s5,40(sp)
 166:	7b02                	ld	s6,32(sp)
 168:	6be2                	ld	s7,24(sp)
 16a:	6125                	add	sp,sp,96
 16c:	8082                	ret

000000000000016e <stat>:

int
stat(const char *n, struct stat *st)
{
 16e:	1101                	add	sp,sp,-32
 170:	ec06                	sd	ra,24(sp)
 172:	e822                	sd	s0,16(sp)
 174:	e04a                	sd	s2,0(sp)
 176:	1000                	add	s0,sp,32
 178:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17a:	4581                	li	a1,0
 17c:	00000097          	auipc	ra,0x0
 180:	172080e7          	jalr	370(ra) # 2ee <open>
  if(fd < 0)
 184:	02054663          	bltz	a0,1b0 <stat+0x42>
 188:	e426                	sd	s1,8(sp)
 18a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18c:	85ca                	mv	a1,s2
 18e:	00000097          	auipc	ra,0x0
 192:	178080e7          	jalr	376(ra) # 306 <fstat>
 196:	892a                	mv	s2,a0
  close(fd);
 198:	8526                	mv	a0,s1
 19a:	00000097          	auipc	ra,0x0
 19e:	13c080e7          	jalr	316(ra) # 2d6 <close>
  return r;
 1a2:	64a2                	ld	s1,8(sp)
}
 1a4:	854a                	mv	a0,s2
 1a6:	60e2                	ld	ra,24(sp)
 1a8:	6442                	ld	s0,16(sp)
 1aa:	6902                	ld	s2,0(sp)
 1ac:	6105                	add	sp,sp,32
 1ae:	8082                	ret
    return -1;
 1b0:	597d                	li	s2,-1
 1b2:	bfcd                	j	1a4 <stat+0x36>

00000000000001b4 <atoi>:

int
atoi(const char *s)
{
 1b4:	1141                	add	sp,sp,-16
 1b6:	e422                	sd	s0,8(sp)
 1b8:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ba:	00054683          	lbu	a3,0(a0)
 1be:	fd06879b          	addw	a5,a3,-48
 1c2:	0ff7f793          	zext.b	a5,a5
 1c6:	4625                	li	a2,9
 1c8:	02f66863          	bltu	a2,a5,1f8 <atoi+0x44>
 1cc:	872a                	mv	a4,a0
  n = 0;
 1ce:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d0:	0705                	add	a4,a4,1
 1d2:	0025179b          	sllw	a5,a0,0x2
 1d6:	9fa9                	addw	a5,a5,a0
 1d8:	0017979b          	sllw	a5,a5,0x1
 1dc:	9fb5                	addw	a5,a5,a3
 1de:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e2:	00074683          	lbu	a3,0(a4)
 1e6:	fd06879b          	addw	a5,a3,-48
 1ea:	0ff7f793          	zext.b	a5,a5
 1ee:	fef671e3          	bgeu	a2,a5,1d0 <atoi+0x1c>
  return n;
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	add	sp,sp,16
 1f6:	8082                	ret
  n = 0;
 1f8:	4501                	li	a0,0
 1fa:	bfe5                	j	1f2 <atoi+0x3e>

00000000000001fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1fc:	1141                	add	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 202:	02b57463          	bgeu	a0,a1,22a <memmove+0x2e>
    while(n-- > 0)
 206:	00c05f63          	blez	a2,224 <memmove+0x28>
 20a:	1602                	sll	a2,a2,0x20
 20c:	9201                	srl	a2,a2,0x20
 20e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 212:	872a                	mv	a4,a0
      *dst++ = *src++;
 214:	0585                	add	a1,a1,1
 216:	0705                	add	a4,a4,1
 218:	fff5c683          	lbu	a3,-1(a1)
 21c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 220:	fef71ae3          	bne	a4,a5,214 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	add	sp,sp,16
 228:	8082                	ret
    dst += n;
 22a:	00c50733          	add	a4,a0,a2
    src += n;
 22e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 230:	fec05ae3          	blez	a2,224 <memmove+0x28>
 234:	fff6079b          	addw	a5,a2,-1
 238:	1782                	sll	a5,a5,0x20
 23a:	9381                	srl	a5,a5,0x20
 23c:	fff7c793          	not	a5,a5
 240:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 242:	15fd                	add	a1,a1,-1
 244:	177d                	add	a4,a4,-1
 246:	0005c683          	lbu	a3,0(a1)
 24a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 24e:	fee79ae3          	bne	a5,a4,242 <memmove+0x46>
 252:	bfc9                	j	224 <memmove+0x28>

0000000000000254 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 254:	1141                	add	sp,sp,-16
 256:	e422                	sd	s0,8(sp)
 258:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25a:	ca05                	beqz	a2,28a <memcmp+0x36>
 25c:	fff6069b          	addw	a3,a2,-1
 260:	1682                	sll	a3,a3,0x20
 262:	9281                	srl	a3,a3,0x20
 264:	0685                	add	a3,a3,1
 266:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 268:	00054783          	lbu	a5,0(a0)
 26c:	0005c703          	lbu	a4,0(a1)
 270:	00e79863          	bne	a5,a4,280 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 274:	0505                	add	a0,a0,1
    p2++;
 276:	0585                	add	a1,a1,1
  while (n-- > 0) {
 278:	fed518e3          	bne	a0,a3,268 <memcmp+0x14>
  }
  return 0;
 27c:	4501                	li	a0,0
 27e:	a019                	j	284 <memcmp+0x30>
      return *p1 - *p2;
 280:	40e7853b          	subw	a0,a5,a4
}
 284:	6422                	ld	s0,8(sp)
 286:	0141                	add	sp,sp,16
 288:	8082                	ret
  return 0;
 28a:	4501                	li	a0,0
 28c:	bfe5                	j	284 <memcmp+0x30>

000000000000028e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28e:	1141                	add	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 296:	00000097          	auipc	ra,0x0
 29a:	f66080e7          	jalr	-154(ra) # 1fc <memmove>
}
 29e:	60a2                	ld	ra,8(sp)
 2a0:	6402                	ld	s0,0(sp)
 2a2:	0141                	add	sp,sp,16
 2a4:	8082                	ret

00000000000002a6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a6:	4885                	li	a7,1
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ae:	4889                	li	a7,2
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b6:	488d                	li	a7,3
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2be:	4891                	li	a7,4
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <read>:
.global read
read:
 li a7, SYS_read
 2c6:	4895                	li	a7,5
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <write>:
.global write
write:
 li a7, SYS_write
 2ce:	48c1                	li	a7,16
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <close>:
.global close
close:
 li a7, SYS_close
 2d6:	48d5                	li	a7,21
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <kill>:
.global kill
kill:
 li a7, SYS_kill
 2de:	4899                	li	a7,6
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e6:	489d                	li	a7,7
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <open>:
.global open
open:
 li a7, SYS_open
 2ee:	48bd                	li	a7,15
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f6:	48c5                	li	a7,17
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2fe:	48c9                	li	a7,18
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 306:	48a1                	li	a7,8
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <link>:
.global link
link:
 li a7, SYS_link
 30e:	48cd                	li	a7,19
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 316:	48d1                	li	a7,20
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 31e:	48a5                	li	a7,9
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <dup>:
.global dup
dup:
 li a7, SYS_dup
 326:	48a9                	li	a7,10
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 32e:	48ad                	li	a7,11
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 336:	48b1                	li	a7,12
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 33e:	48b5                	li	a7,13
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 346:	48b9                	li	a7,14
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 34e:	1101                	add	sp,sp,-32
 350:	ec06                	sd	ra,24(sp)
 352:	e822                	sd	s0,16(sp)
 354:	1000                	add	s0,sp,32
 356:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 35a:	4605                	li	a2,1
 35c:	fef40593          	add	a1,s0,-17
 360:	00000097          	auipc	ra,0x0
 364:	f6e080e7          	jalr	-146(ra) # 2ce <write>
}
 368:	60e2                	ld	ra,24(sp)
 36a:	6442                	ld	s0,16(sp)
 36c:	6105                	add	sp,sp,32
 36e:	8082                	ret

0000000000000370 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 370:	7139                	add	sp,sp,-64
 372:	fc06                	sd	ra,56(sp)
 374:	f822                	sd	s0,48(sp)
 376:	f426                	sd	s1,40(sp)
 378:	0080                	add	s0,sp,64
 37a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37c:	c299                	beqz	a3,382 <printint+0x12>
 37e:	0805cb63          	bltz	a1,414 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 382:	2581                	sext.w	a1,a1
  neg = 0;
 384:	4881                	li	a7,0
 386:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 38a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 38c:	2601                	sext.w	a2,a2
 38e:	00000517          	auipc	a0,0x0
 392:	4ba50513          	add	a0,a0,1210 # 848 <digits>
 396:	883a                	mv	a6,a4
 398:	2705                	addw	a4,a4,1
 39a:	02c5f7bb          	remuw	a5,a1,a2
 39e:	1782                	sll	a5,a5,0x20
 3a0:	9381                	srl	a5,a5,0x20
 3a2:	97aa                	add	a5,a5,a0
 3a4:	0007c783          	lbu	a5,0(a5)
 3a8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ac:	0005879b          	sext.w	a5,a1
 3b0:	02c5d5bb          	divuw	a1,a1,a2
 3b4:	0685                	add	a3,a3,1
 3b6:	fec7f0e3          	bgeu	a5,a2,396 <printint+0x26>
  if(neg)
 3ba:	00088c63          	beqz	a7,3d2 <printint+0x62>
    buf[i++] = '-';
 3be:	fd070793          	add	a5,a4,-48
 3c2:	00878733          	add	a4,a5,s0
 3c6:	02d00793          	li	a5,45
 3ca:	fef70823          	sb	a5,-16(a4)
 3ce:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 3d2:	02e05c63          	blez	a4,40a <printint+0x9a>
 3d6:	f04a                	sd	s2,32(sp)
 3d8:	ec4e                	sd	s3,24(sp)
 3da:	fc040793          	add	a5,s0,-64
 3de:	00e78933          	add	s2,a5,a4
 3e2:	fff78993          	add	s3,a5,-1
 3e6:	99ba                	add	s3,s3,a4
 3e8:	377d                	addw	a4,a4,-1
 3ea:	1702                	sll	a4,a4,0x20
 3ec:	9301                	srl	a4,a4,0x20
 3ee:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3f2:	fff94583          	lbu	a1,-1(s2)
 3f6:	8526                	mv	a0,s1
 3f8:	00000097          	auipc	ra,0x0
 3fc:	f56080e7          	jalr	-170(ra) # 34e <putc>
  while(--i >= 0)
 400:	197d                	add	s2,s2,-1
 402:	ff3918e3          	bne	s2,s3,3f2 <printint+0x82>
 406:	7902                	ld	s2,32(sp)
 408:	69e2                	ld	s3,24(sp)
}
 40a:	70e2                	ld	ra,56(sp)
 40c:	7442                	ld	s0,48(sp)
 40e:	74a2                	ld	s1,40(sp)
 410:	6121                	add	sp,sp,64
 412:	8082                	ret
    x = -xx;
 414:	40b005bb          	negw	a1,a1
    neg = 1;
 418:	4885                	li	a7,1
    x = -xx;
 41a:	b7b5                	j	386 <printint+0x16>

000000000000041c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 41c:	715d                	add	sp,sp,-80
 41e:	e486                	sd	ra,72(sp)
 420:	e0a2                	sd	s0,64(sp)
 422:	f84a                	sd	s2,48(sp)
 424:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 426:	0005c903          	lbu	s2,0(a1)
 42a:	1a090a63          	beqz	s2,5de <vprintf+0x1c2>
 42e:	fc26                	sd	s1,56(sp)
 430:	f44e                	sd	s3,40(sp)
 432:	f052                	sd	s4,32(sp)
 434:	ec56                	sd	s5,24(sp)
 436:	e85a                	sd	s6,16(sp)
 438:	e45e                	sd	s7,8(sp)
 43a:	8aaa                	mv	s5,a0
 43c:	8bb2                	mv	s7,a2
 43e:	00158493          	add	s1,a1,1
  state = 0;
 442:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 444:	02500a13          	li	s4,37
 448:	4b55                	li	s6,21
 44a:	a839                	j	468 <vprintf+0x4c>
        putc(fd, c);
 44c:	85ca                	mv	a1,s2
 44e:	8556                	mv	a0,s5
 450:	00000097          	auipc	ra,0x0
 454:	efe080e7          	jalr	-258(ra) # 34e <putc>
 458:	a019                	j	45e <vprintf+0x42>
    } else if(state == '%'){
 45a:	01498d63          	beq	s3,s4,474 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 45e:	0485                	add	s1,s1,1
 460:	fff4c903          	lbu	s2,-1(s1)
 464:	16090763          	beqz	s2,5d2 <vprintf+0x1b6>
    if(state == 0){
 468:	fe0999e3          	bnez	s3,45a <vprintf+0x3e>
      if(c == '%'){
 46c:	ff4910e3          	bne	s2,s4,44c <vprintf+0x30>
        state = '%';
 470:	89d2                	mv	s3,s4
 472:	b7f5                	j	45e <vprintf+0x42>
      if(c == 'd'){
 474:	13490463          	beq	s2,s4,59c <vprintf+0x180>
 478:	f9d9079b          	addw	a5,s2,-99
 47c:	0ff7f793          	zext.b	a5,a5
 480:	12fb6763          	bltu	s6,a5,5ae <vprintf+0x192>
 484:	f9d9079b          	addw	a5,s2,-99
 488:	0ff7f713          	zext.b	a4,a5
 48c:	12eb6163          	bltu	s6,a4,5ae <vprintf+0x192>
 490:	00271793          	sll	a5,a4,0x2
 494:	00000717          	auipc	a4,0x0
 498:	35c70713          	add	a4,a4,860 # 7f0 <malloc+0x122>
 49c:	97ba                	add	a5,a5,a4
 49e:	439c                	lw	a5,0(a5)
 4a0:	97ba                	add	a5,a5,a4
 4a2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4a4:	008b8913          	add	s2,s7,8
 4a8:	4685                	li	a3,1
 4aa:	4629                	li	a2,10
 4ac:	000ba583          	lw	a1,0(s7)
 4b0:	8556                	mv	a0,s5
 4b2:	00000097          	auipc	ra,0x0
 4b6:	ebe080e7          	jalr	-322(ra) # 370 <printint>
 4ba:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4bc:	4981                	li	s3,0
 4be:	b745                	j	45e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4c0:	008b8913          	add	s2,s7,8
 4c4:	4681                	li	a3,0
 4c6:	4629                	li	a2,10
 4c8:	000ba583          	lw	a1,0(s7)
 4cc:	8556                	mv	a0,s5
 4ce:	00000097          	auipc	ra,0x0
 4d2:	ea2080e7          	jalr	-350(ra) # 370 <printint>
 4d6:	8bca                	mv	s7,s2
      state = 0;
 4d8:	4981                	li	s3,0
 4da:	b751                	j	45e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4dc:	008b8913          	add	s2,s7,8
 4e0:	4681                	li	a3,0
 4e2:	4641                	li	a2,16
 4e4:	000ba583          	lw	a1,0(s7)
 4e8:	8556                	mv	a0,s5
 4ea:	00000097          	auipc	ra,0x0
 4ee:	e86080e7          	jalr	-378(ra) # 370 <printint>
 4f2:	8bca                	mv	s7,s2
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	b7a5                	j	45e <vprintf+0x42>
 4f8:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 4fa:	008b8c13          	add	s8,s7,8
 4fe:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 502:	03000593          	li	a1,48
 506:	8556                	mv	a0,s5
 508:	00000097          	auipc	ra,0x0
 50c:	e46080e7          	jalr	-442(ra) # 34e <putc>
  putc(fd, 'x');
 510:	07800593          	li	a1,120
 514:	8556                	mv	a0,s5
 516:	00000097          	auipc	ra,0x0
 51a:	e38080e7          	jalr	-456(ra) # 34e <putc>
 51e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 520:	00000b97          	auipc	s7,0x0
 524:	328b8b93          	add	s7,s7,808 # 848 <digits>
 528:	03c9d793          	srl	a5,s3,0x3c
 52c:	97de                	add	a5,a5,s7
 52e:	0007c583          	lbu	a1,0(a5)
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	e1a080e7          	jalr	-486(ra) # 34e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 53c:	0992                	sll	s3,s3,0x4
 53e:	397d                	addw	s2,s2,-1
 540:	fe0914e3          	bnez	s2,528 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 544:	8be2                	mv	s7,s8
      state = 0;
 546:	4981                	li	s3,0
 548:	6c02                	ld	s8,0(sp)
 54a:	bf11                	j	45e <vprintf+0x42>
        s = va_arg(ap, char*);
 54c:	008b8993          	add	s3,s7,8
 550:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 554:	02090163          	beqz	s2,576 <vprintf+0x15a>
        while(*s != 0){
 558:	00094583          	lbu	a1,0(s2)
 55c:	c9a5                	beqz	a1,5cc <vprintf+0x1b0>
          putc(fd, *s);
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	dee080e7          	jalr	-530(ra) # 34e <putc>
          s++;
 568:	0905                	add	s2,s2,1
        while(*s != 0){
 56a:	00094583          	lbu	a1,0(s2)
 56e:	f9e5                	bnez	a1,55e <vprintf+0x142>
        s = va_arg(ap, char*);
 570:	8bce                	mv	s7,s3
      state = 0;
 572:	4981                	li	s3,0
 574:	b5ed                	j	45e <vprintf+0x42>
          s = "(null)";
 576:	00000917          	auipc	s2,0x0
 57a:	27290913          	add	s2,s2,626 # 7e8 <malloc+0x11a>
        while(*s != 0){
 57e:	02800593          	li	a1,40
 582:	bff1                	j	55e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 584:	008b8913          	add	s2,s7,8
 588:	000bc583          	lbu	a1,0(s7)
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	dc0080e7          	jalr	-576(ra) # 34e <putc>
 596:	8bca                	mv	s7,s2
      state = 0;
 598:	4981                	li	s3,0
 59a:	b5d1                	j	45e <vprintf+0x42>
        putc(fd, c);
 59c:	02500593          	li	a1,37
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	dac080e7          	jalr	-596(ra) # 34e <putc>
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bd4d                	j	45e <vprintf+0x42>
        putc(fd, '%');
 5ae:	02500593          	li	a1,37
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	d9a080e7          	jalr	-614(ra) # 34e <putc>
        putc(fd, c);
 5bc:	85ca                	mv	a1,s2
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	d8e080e7          	jalr	-626(ra) # 34e <putc>
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	bd51                	j	45e <vprintf+0x42>
        s = va_arg(ap, char*);
 5cc:	8bce                	mv	s7,s3
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b579                	j	45e <vprintf+0x42>
 5d2:	74e2                	ld	s1,56(sp)
 5d4:	79a2                	ld	s3,40(sp)
 5d6:	7a02                	ld	s4,32(sp)
 5d8:	6ae2                	ld	s5,24(sp)
 5da:	6b42                	ld	s6,16(sp)
 5dc:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5de:	60a6                	ld	ra,72(sp)
 5e0:	6406                	ld	s0,64(sp)
 5e2:	7942                	ld	s2,48(sp)
 5e4:	6161                	add	sp,sp,80
 5e6:	8082                	ret

00000000000005e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5e8:	715d                	add	sp,sp,-80
 5ea:	ec06                	sd	ra,24(sp)
 5ec:	e822                	sd	s0,16(sp)
 5ee:	1000                	add	s0,sp,32
 5f0:	e010                	sd	a2,0(s0)
 5f2:	e414                	sd	a3,8(s0)
 5f4:	e818                	sd	a4,16(s0)
 5f6:	ec1c                	sd	a5,24(s0)
 5f8:	03043023          	sd	a6,32(s0)
 5fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 600:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 604:	8622                	mv	a2,s0
 606:	00000097          	auipc	ra,0x0
 60a:	e16080e7          	jalr	-490(ra) # 41c <vprintf>
}
 60e:	60e2                	ld	ra,24(sp)
 610:	6442                	ld	s0,16(sp)
 612:	6161                	add	sp,sp,80
 614:	8082                	ret

0000000000000616 <printf>:

void
printf(const char *fmt, ...)
{
 616:	711d                	add	sp,sp,-96
 618:	ec06                	sd	ra,24(sp)
 61a:	e822                	sd	s0,16(sp)
 61c:	1000                	add	s0,sp,32
 61e:	e40c                	sd	a1,8(s0)
 620:	e810                	sd	a2,16(s0)
 622:	ec14                	sd	a3,24(s0)
 624:	f018                	sd	a4,32(s0)
 626:	f41c                	sd	a5,40(s0)
 628:	03043823          	sd	a6,48(s0)
 62c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 630:	00840613          	add	a2,s0,8
 634:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 638:	85aa                	mv	a1,a0
 63a:	4505                	li	a0,1
 63c:	00000097          	auipc	ra,0x0
 640:	de0080e7          	jalr	-544(ra) # 41c <vprintf>
}
 644:	60e2                	ld	ra,24(sp)
 646:	6442                	ld	s0,16(sp)
 648:	6125                	add	sp,sp,96
 64a:	8082                	ret

000000000000064c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64c:	1141                	add	sp,sp,-16
 64e:	e422                	sd	s0,8(sp)
 650:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 652:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 656:	00000797          	auipc	a5,0x0
 65a:	20a7b783          	ld	a5,522(a5) # 860 <freep>
 65e:	a02d                	j	688 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 660:	4618                	lw	a4,8(a2)
 662:	9f2d                	addw	a4,a4,a1
 664:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 668:	6398                	ld	a4,0(a5)
 66a:	6310                	ld	a2,0(a4)
 66c:	a83d                	j	6aa <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 66e:	ff852703          	lw	a4,-8(a0)
 672:	9f31                	addw	a4,a4,a2
 674:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 676:	ff053683          	ld	a3,-16(a0)
 67a:	a091                	j	6be <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67c:	6398                	ld	a4,0(a5)
 67e:	00e7e463          	bltu	a5,a4,686 <free+0x3a>
 682:	00e6ea63          	bltu	a3,a4,696 <free+0x4a>
{
 686:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 688:	fed7fae3          	bgeu	a5,a3,67c <free+0x30>
 68c:	6398                	ld	a4,0(a5)
 68e:	00e6e463          	bltu	a3,a4,696 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 692:	fee7eae3          	bltu	a5,a4,686 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 696:	ff852583          	lw	a1,-8(a0)
 69a:	6390                	ld	a2,0(a5)
 69c:	02059813          	sll	a6,a1,0x20
 6a0:	01c85713          	srl	a4,a6,0x1c
 6a4:	9736                	add	a4,a4,a3
 6a6:	fae60de3          	beq	a2,a4,660 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6aa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6ae:	4790                	lw	a2,8(a5)
 6b0:	02061593          	sll	a1,a2,0x20
 6b4:	01c5d713          	srl	a4,a1,0x1c
 6b8:	973e                	add	a4,a4,a5
 6ba:	fae68ae3          	beq	a3,a4,66e <free+0x22>
    p->s.ptr = bp->s.ptr;
 6be:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6c0:	00000717          	auipc	a4,0x0
 6c4:	1af73023          	sd	a5,416(a4) # 860 <freep>
}
 6c8:	6422                	ld	s0,8(sp)
 6ca:	0141                	add	sp,sp,16
 6cc:	8082                	ret

00000000000006ce <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6ce:	7139                	add	sp,sp,-64
 6d0:	fc06                	sd	ra,56(sp)
 6d2:	f822                	sd	s0,48(sp)
 6d4:	f426                	sd	s1,40(sp)
 6d6:	ec4e                	sd	s3,24(sp)
 6d8:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6da:	02051493          	sll	s1,a0,0x20
 6de:	9081                	srl	s1,s1,0x20
 6e0:	04bd                	add	s1,s1,15
 6e2:	8091                	srl	s1,s1,0x4
 6e4:	0014899b          	addw	s3,s1,1
 6e8:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 6ea:	00000517          	auipc	a0,0x0
 6ee:	17653503          	ld	a0,374(a0) # 860 <freep>
 6f2:	c915                	beqz	a0,726 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6f6:	4798                	lw	a4,8(a5)
 6f8:	08977e63          	bgeu	a4,s1,794 <malloc+0xc6>
 6fc:	f04a                	sd	s2,32(sp)
 6fe:	e852                	sd	s4,16(sp)
 700:	e456                	sd	s5,8(sp)
 702:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 704:	8a4e                	mv	s4,s3
 706:	0009871b          	sext.w	a4,s3
 70a:	6685                	lui	a3,0x1
 70c:	00d77363          	bgeu	a4,a3,712 <malloc+0x44>
 710:	6a05                	lui	s4,0x1
 712:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 716:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 71a:	00000917          	auipc	s2,0x0
 71e:	14690913          	add	s2,s2,326 # 860 <freep>
  if(p == (char*)-1)
 722:	5afd                	li	s5,-1
 724:	a091                	j	768 <malloc+0x9a>
 726:	f04a                	sd	s2,32(sp)
 728:	e852                	sd	s4,16(sp)
 72a:	e456                	sd	s5,8(sp)
 72c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 72e:	00000797          	auipc	a5,0x0
 732:	13a78793          	add	a5,a5,314 # 868 <base>
 736:	00000717          	auipc	a4,0x0
 73a:	12f73523          	sd	a5,298(a4) # 860 <freep>
 73e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 740:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 744:	b7c1                	j	704 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 746:	6398                	ld	a4,0(a5)
 748:	e118                	sd	a4,0(a0)
 74a:	a08d                	j	7ac <malloc+0xde>
  hp->s.size = nu;
 74c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 750:	0541                	add	a0,a0,16
 752:	00000097          	auipc	ra,0x0
 756:	efa080e7          	jalr	-262(ra) # 64c <free>
  return freep;
 75a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 75e:	c13d                	beqz	a0,7c4 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 760:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 762:	4798                	lw	a4,8(a5)
 764:	02977463          	bgeu	a4,s1,78c <malloc+0xbe>
    if(p == freep)
 768:	00093703          	ld	a4,0(s2)
 76c:	853e                	mv	a0,a5
 76e:	fef719e3          	bne	a4,a5,760 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 772:	8552                	mv	a0,s4
 774:	00000097          	auipc	ra,0x0
 778:	bc2080e7          	jalr	-1086(ra) # 336 <sbrk>
  if(p == (char*)-1)
 77c:	fd5518e3          	bne	a0,s5,74c <malloc+0x7e>
        return 0;
 780:	4501                	li	a0,0
 782:	7902                	ld	s2,32(sp)
 784:	6a42                	ld	s4,16(sp)
 786:	6aa2                	ld	s5,8(sp)
 788:	6b02                	ld	s6,0(sp)
 78a:	a03d                	j	7b8 <malloc+0xea>
 78c:	7902                	ld	s2,32(sp)
 78e:	6a42                	ld	s4,16(sp)
 790:	6aa2                	ld	s5,8(sp)
 792:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 794:	fae489e3          	beq	s1,a4,746 <malloc+0x78>
        p->s.size -= nunits;
 798:	4137073b          	subw	a4,a4,s3
 79c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 79e:	02071693          	sll	a3,a4,0x20
 7a2:	01c6d713          	srl	a4,a3,0x1c
 7a6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7a8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7ac:	00000717          	auipc	a4,0x0
 7b0:	0aa73a23          	sd	a0,180(a4) # 860 <freep>
      return (void*)(p + 1);
 7b4:	01078513          	add	a0,a5,16
  }
}
 7b8:	70e2                	ld	ra,56(sp)
 7ba:	7442                	ld	s0,48(sp)
 7bc:	74a2                	ld	s1,40(sp)
 7be:	69e2                	ld	s3,24(sp)
 7c0:	6121                	add	sp,sp,64
 7c2:	8082                	ret
 7c4:	7902                	ld	s2,32(sp)
 7c6:	6a42                	ld	s4,16(sp)
 7c8:	6aa2                	ld	s5,8(sp)
 7ca:	6b02                	ld	s6,0(sp)
 7cc:	b7f5                	j	7b8 <malloc+0xea>
