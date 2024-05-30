
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char *fmtname(char *path)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	add	s0,sp,48
   a:	84aa                	mv	s1,a0
    static char buf[DIRSIZ + 1];
    char *p;

    // Find first character after last slash.
    for (p = path + strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	31c080e7          	jalr	796(ra) # 328 <strlen>
  14:	02051793          	sll	a5,a0,0x20
  18:	9381                	srl	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	add	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
        ;
    p++;
  32:	00178493          	add	s1,a5,1

    // Return blank-padded name.
    if (strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	00000097          	auipc	ra,0x0
  3c:	2f0080e7          	jalr	752(ra) # 328 <strlen>
  40:	2501                	sext.w	a0,a0
  42:	47b5                	li	a5,13
  44:	00a7f863          	bgeu	a5,a0,54 <fmtname+0x54>
        return p;
    memmove(buf, p, strlen(p));
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
    return buf;
}
  48:	8526                	mv	a0,s1
  4a:	70a2                	ld	ra,40(sp)
  4c:	7402                	ld	s0,32(sp)
  4e:	64e2                	ld	s1,24(sp)
  50:	6145                	add	sp,sp,48
  52:	8082                	ret
  54:	e84a                	sd	s2,16(sp)
  56:	e44e                	sd	s3,8(sp)
    memmove(buf, p, strlen(p));
  58:	8526                	mv	a0,s1
  5a:	00000097          	auipc	ra,0x0
  5e:	2ce080e7          	jalr	718(ra) # 328 <strlen>
  62:	00001997          	auipc	s3,0x1
  66:	b1698993          	add	s3,s3,-1258 # b78 <buf.0>
  6a:	0005061b          	sext.w	a2,a0
  6e:	85a6                	mv	a1,s1
  70:	854e                	mv	a0,s3
  72:	00000097          	auipc	ra,0x0
  76:	428080e7          	jalr	1064(ra) # 49a <memmove>
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  7a:	8526                	mv	a0,s1
  7c:	00000097          	auipc	ra,0x0
  80:	2ac080e7          	jalr	684(ra) # 328 <strlen>
  84:	0005091b          	sext.w	s2,a0
  88:	8526                	mv	a0,s1
  8a:	00000097          	auipc	ra,0x0
  8e:	29e080e7          	jalr	670(ra) # 328 <strlen>
  92:	1902                	sll	s2,s2,0x20
  94:	02095913          	srl	s2,s2,0x20
  98:	4639                	li	a2,14
  9a:	9e09                	subw	a2,a2,a0
  9c:	02000593          	li	a1,32
  a0:	01298533          	add	a0,s3,s2
  a4:	00000097          	auipc	ra,0x0
  a8:	2ae080e7          	jalr	686(ra) # 352 <memset>
    return buf;
  ac:	84ce                	mv	s1,s3
  ae:	6942                	ld	s2,16(sp)
  b0:	69a2                	ld	s3,8(sp)
  b2:	bf59                	j	48 <fmtname+0x48>

00000000000000b4 <find>:

void find(char *path, char *file_name)
{
  b4:	d9010113          	add	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	25213823          	sd	s2,592(sp)
  c4:	25313423          	sd	s3,584(sp)
  c8:	1c80                	add	s0,sp,624
  ca:	892a                	mv	s2,a0
  cc:	89ae                	mv	s3,a1
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0)
  ce:	4581                	li	a1,0
  d0:	00000097          	auipc	ra,0x0
  d4:	4bc080e7          	jalr	1212(ra) # 58c <open>
  d8:	04054463          	bltz	a0,120 <find+0x6c>
  dc:	24913c23          	sd	s1,600(sp)
  e0:	84aa                	mv	s1,a0
    {
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0)
  e2:	d9840593          	add	a1,s0,-616
  e6:	00000097          	auipc	ra,0x0
  ea:	4be080e7          	jalr	1214(ra) # 5a4 <fstat>
  ee:	04054463          	bltz	a0,136 <find+0x82>
    {
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }
    if (st.type != T_DIR)
  f2:	da041703          	lh	a4,-608(s0)
  f6:	4785                	li	a5,1
  f8:	06f70163          	beq	a4,a5,15a <find+0xa6>
    {
        close(fd);
  fc:	8526                	mv	a0,s1
  fe:	00000097          	auipc	ra,0x0
 102:	476080e7          	jalr	1142(ra) # 574 <close>
        return;
 106:	25813483          	ld	s1,600(sp)
        {
            find(buf, file_name);
        }
    }
    close(fd);
}
 10a:	26813083          	ld	ra,616(sp)
 10e:	26013403          	ld	s0,608(sp)
 112:	25013903          	ld	s2,592(sp)
 116:	24813983          	ld	s3,584(sp)
 11a:	27010113          	add	sp,sp,624
 11e:	8082                	ret
        fprintf(2, "find: cannot open %s\n", path);
 120:	864a                	mv	a2,s2
 122:	00001597          	auipc	a1,0x1
 126:	94e58593          	add	a1,a1,-1714 # a70 <malloc+0x104>
 12a:	4509                	li	a0,2
 12c:	00000097          	auipc	ra,0x0
 130:	75a080e7          	jalr	1882(ra) # 886 <fprintf>
        return;
 134:	bfd9                	j	10a <find+0x56>
        fprintf(2, "find: cannot stat %s\n", path);
 136:	864a                	mv	a2,s2
 138:	00001597          	auipc	a1,0x1
 13c:	95858593          	add	a1,a1,-1704 # a90 <malloc+0x124>
 140:	4509                	li	a0,2
 142:	00000097          	auipc	ra,0x0
 146:	744080e7          	jalr	1860(ra) # 886 <fprintf>
        close(fd);
 14a:	8526                	mv	a0,s1
 14c:	00000097          	auipc	ra,0x0
 150:	428080e7          	jalr	1064(ra) # 574 <close>
        return;
 154:	25813483          	ld	s1,600(sp)
 158:	bf4d                	j	10a <find+0x56>
    if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
 15a:	854a                	mv	a0,s2
 15c:	00000097          	auipc	ra,0x0
 160:	1cc080e7          	jalr	460(ra) # 328 <strlen>
 164:	2541                	addw	a0,a0,16
 166:	20000793          	li	a5,512
 16a:	0ca7e963          	bltu	a5,a0,23c <find+0x188>
 16e:	25413023          	sd	s4,576(sp)
 172:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 176:	85ca                	mv	a1,s2
 178:	dc040513          	add	a0,s0,-576
 17c:	00000097          	auipc	ra,0x0
 180:	164080e7          	jalr	356(ra) # 2e0 <strcpy>
    p = buf + strlen(buf);
 184:	dc040513          	add	a0,s0,-576
 188:	00000097          	auipc	ra,0x0
 18c:	1a0080e7          	jalr	416(ra) # 328 <strlen>
 190:	1502                	sll	a0,a0,0x20
 192:	9101                	srl	a0,a0,0x20
 194:	dc040793          	add	a5,s0,-576
 198:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 19c:	00190a13          	add	s4,s2,1
 1a0:	02f00793          	li	a5,47
 1a4:	00f90023          	sb	a5,0(s2)
        else if (st.type == T_DIR && strcmp(p, ".") != 0 && strcmp(p, "..") != 0)
 1a8:	4a85                	li	s5,1
    while (read(fd, &de, sizeof(de)) == sizeof(de))
 1aa:	4641                	li	a2,16
 1ac:	db040593          	add	a1,s0,-592
 1b0:	8526                	mv	a0,s1
 1b2:	00000097          	auipc	ra,0x0
 1b6:	3b2080e7          	jalr	946(ra) # 564 <read>
 1ba:	47c1                	li	a5,16
 1bc:	0cf51663          	bne	a0,a5,288 <find+0x1d4>
        if (de.inum == 0)
 1c0:	db045783          	lhu	a5,-592(s0)
 1c4:	d3fd                	beqz	a5,1aa <find+0xf6>
        memmove(p, de.name, DIRSIZ);
 1c6:	4639                	li	a2,14
 1c8:	db240593          	add	a1,s0,-590
 1cc:	8552                	mv	a0,s4
 1ce:	00000097          	auipc	ra,0x0
 1d2:	2cc080e7          	jalr	716(ra) # 49a <memmove>
        p[DIRSIZ] = 0;
 1d6:	000907a3          	sb	zero,15(s2)
        if (stat(buf, &st) < 0)
 1da:	d9840593          	add	a1,s0,-616
 1de:	dc040513          	add	a0,s0,-576
 1e2:	00000097          	auipc	ra,0x0
 1e6:	22a080e7          	jalr	554(ra) # 40c <stat>
 1ea:	06054963          	bltz	a0,25c <find+0x1a8>
        if (strcmp(p, file_name) == 0)
 1ee:	85ce                	mv	a1,s3
 1f0:	8552                	mv	a0,s4
 1f2:	00000097          	auipc	ra,0x0
 1f6:	10a080e7          	jalr	266(ra) # 2fc <strcmp>
 1fa:	cd25                	beqz	a0,272 <find+0x1be>
        else if (st.type == T_DIR && strcmp(p, ".") != 0 && strcmp(p, "..") != 0)
 1fc:	da041783          	lh	a5,-608(s0)
 200:	fb5795e3          	bne	a5,s5,1aa <find+0xf6>
 204:	00001597          	auipc	a1,0x1
 208:	8c458593          	add	a1,a1,-1852 # ac8 <malloc+0x15c>
 20c:	8552                	mv	a0,s4
 20e:	00000097          	auipc	ra,0x0
 212:	0ee080e7          	jalr	238(ra) # 2fc <strcmp>
 216:	d951                	beqz	a0,1aa <find+0xf6>
 218:	00001597          	auipc	a1,0x1
 21c:	8b858593          	add	a1,a1,-1864 # ad0 <malloc+0x164>
 220:	8552                	mv	a0,s4
 222:	00000097          	auipc	ra,0x0
 226:	0da080e7          	jalr	218(ra) # 2fc <strcmp>
 22a:	d141                	beqz	a0,1aa <find+0xf6>
            find(buf, file_name);
 22c:	85ce                	mv	a1,s3
 22e:	dc040513          	add	a0,s0,-576
 232:	00000097          	auipc	ra,0x0
 236:	e82080e7          	jalr	-382(ra) # b4 <find>
 23a:	bf85                	j	1aa <find+0xf6>
        printf("find: path too long\n");
 23c:	00001517          	auipc	a0,0x1
 240:	86c50513          	add	a0,a0,-1940 # aa8 <malloc+0x13c>
 244:	00000097          	auipc	ra,0x0
 248:	670080e7          	jalr	1648(ra) # 8b4 <printf>
        close(fd);
 24c:	8526                	mv	a0,s1
 24e:	00000097          	auipc	ra,0x0
 252:	326080e7          	jalr	806(ra) # 574 <close>
        return;
 256:	25813483          	ld	s1,600(sp)
 25a:	bd45                	j	10a <find+0x56>
            printf("find: cannot stat %s\n", buf);
 25c:	dc040593          	add	a1,s0,-576
 260:	00001517          	auipc	a0,0x1
 264:	83050513          	add	a0,a0,-2000 # a90 <malloc+0x124>
 268:	00000097          	auipc	ra,0x0
 26c:	64c080e7          	jalr	1612(ra) # 8b4 <printf>
            continue;
 270:	bf2d                	j	1aa <find+0xf6>
            printf("%s\n", buf);
 272:	dc040593          	add	a1,s0,-576
 276:	00001517          	auipc	a0,0x1
 27a:	84a50513          	add	a0,a0,-1974 # ac0 <malloc+0x154>
 27e:	00000097          	auipc	ra,0x0
 282:	636080e7          	jalr	1590(ra) # 8b4 <printf>
            continue;
 286:	b715                	j	1aa <find+0xf6>
    close(fd);
 288:	8526                	mv	a0,s1
 28a:	00000097          	auipc	ra,0x0
 28e:	2ea080e7          	jalr	746(ra) # 574 <close>
 292:	25813483          	ld	s1,600(sp)
 296:	24013a03          	ld	s4,576(sp)
 29a:	23813a83          	ld	s5,568(sp)
 29e:	b5b5                	j	10a <find+0x56>

00000000000002a0 <main>:

int main(int argc, char *argv[])
{
 2a0:	1141                	add	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	add	s0,sp,16
    int i;

    if (argc < 3)
 2a8:	4709                	li	a4,2
 2aa:	00a74f63          	blt	a4,a0,2c8 <main+0x28>
    {
        printf("Usage: find path filename\n");
 2ae:	00001517          	auipc	a0,0x1
 2b2:	82a50513          	add	a0,a0,-2006 # ad8 <malloc+0x16c>
 2b6:	00000097          	auipc	ra,0x0
 2ba:	5fe080e7          	jalr	1534(ra) # 8b4 <printf>
        exit(0);
 2be:	4501                	li	a0,0
 2c0:	00000097          	auipc	ra,0x0
 2c4:	28c080e7          	jalr	652(ra) # 54c <exit>
 2c8:	87ae                	mv	a5,a1
    }
    find(argv[1], argv[2]);
 2ca:	698c                	ld	a1,16(a1)
 2cc:	6788                	ld	a0,8(a5)
 2ce:	00000097          	auipc	ra,0x0
 2d2:	de6080e7          	jalr	-538(ra) # b4 <find>
    exit(0);
 2d6:	4501                	li	a0,0
 2d8:	00000097          	auipc	ra,0x0
 2dc:	274080e7          	jalr	628(ra) # 54c <exit>

00000000000002e0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2e0:	1141                	add	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2e6:	87aa                	mv	a5,a0
 2e8:	0585                	add	a1,a1,1
 2ea:	0785                	add	a5,a5,1
 2ec:	fff5c703          	lbu	a4,-1(a1)
 2f0:	fee78fa3          	sb	a4,-1(a5)
 2f4:	fb75                	bnez	a4,2e8 <strcpy+0x8>
    ;
  return os;
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	add	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2fc:	1141                	add	sp,sp,-16
 2fe:	e422                	sd	s0,8(sp)
 300:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 302:	00054783          	lbu	a5,0(a0)
 306:	cb91                	beqz	a5,31a <strcmp+0x1e>
 308:	0005c703          	lbu	a4,0(a1)
 30c:	00f71763          	bne	a4,a5,31a <strcmp+0x1e>
    p++, q++;
 310:	0505                	add	a0,a0,1
 312:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 314:	00054783          	lbu	a5,0(a0)
 318:	fbe5                	bnez	a5,308 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 31a:	0005c503          	lbu	a0,0(a1)
}
 31e:	40a7853b          	subw	a0,a5,a0
 322:	6422                	ld	s0,8(sp)
 324:	0141                	add	sp,sp,16
 326:	8082                	ret

0000000000000328 <strlen>:

uint
strlen(const char *s)
{
 328:	1141                	add	sp,sp,-16
 32a:	e422                	sd	s0,8(sp)
 32c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 32e:	00054783          	lbu	a5,0(a0)
 332:	cf91                	beqz	a5,34e <strlen+0x26>
 334:	0505                	add	a0,a0,1
 336:	87aa                	mv	a5,a0
 338:	86be                	mv	a3,a5
 33a:	0785                	add	a5,a5,1
 33c:	fff7c703          	lbu	a4,-1(a5)
 340:	ff65                	bnez	a4,338 <strlen+0x10>
 342:	40a6853b          	subw	a0,a3,a0
 346:	2505                	addw	a0,a0,1
    ;
  return n;
}
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	add	sp,sp,16
 34c:	8082                	ret
  for(n = 0; s[n]; n++)
 34e:	4501                	li	a0,0
 350:	bfe5                	j	348 <strlen+0x20>

0000000000000352 <memset>:

void*
memset(void *dst, int c, uint n)
{
 352:	1141                	add	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 358:	ca19                	beqz	a2,36e <memset+0x1c>
 35a:	87aa                	mv	a5,a0
 35c:	1602                	sll	a2,a2,0x20
 35e:	9201                	srl	a2,a2,0x20
 360:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 364:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 368:	0785                	add	a5,a5,1
 36a:	fee79de3          	bne	a5,a4,364 <memset+0x12>
  }
  return dst;
}
 36e:	6422                	ld	s0,8(sp)
 370:	0141                	add	sp,sp,16
 372:	8082                	ret

0000000000000374 <strchr>:

char*
strchr(const char *s, char c)
{
 374:	1141                	add	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	add	s0,sp,16
  for(; *s; s++)
 37a:	00054783          	lbu	a5,0(a0)
 37e:	cb99                	beqz	a5,394 <strchr+0x20>
    if(*s == c)
 380:	00f58763          	beq	a1,a5,38e <strchr+0x1a>
  for(; *s; s++)
 384:	0505                	add	a0,a0,1
 386:	00054783          	lbu	a5,0(a0)
 38a:	fbfd                	bnez	a5,380 <strchr+0xc>
      return (char*)s;
  return 0;
 38c:	4501                	li	a0,0
}
 38e:	6422                	ld	s0,8(sp)
 390:	0141                	add	sp,sp,16
 392:	8082                	ret
  return 0;
 394:	4501                	li	a0,0
 396:	bfe5                	j	38e <strchr+0x1a>

0000000000000398 <gets>:

char*
gets(char *buf, int max)
{
 398:	711d                	add	sp,sp,-96
 39a:	ec86                	sd	ra,88(sp)
 39c:	e8a2                	sd	s0,80(sp)
 39e:	e4a6                	sd	s1,72(sp)
 3a0:	e0ca                	sd	s2,64(sp)
 3a2:	fc4e                	sd	s3,56(sp)
 3a4:	f852                	sd	s4,48(sp)
 3a6:	f456                	sd	s5,40(sp)
 3a8:	f05a                	sd	s6,32(sp)
 3aa:	ec5e                	sd	s7,24(sp)
 3ac:	1080                	add	s0,sp,96
 3ae:	8baa                	mv	s7,a0
 3b0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b2:	892a                	mv	s2,a0
 3b4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3b6:	4aa9                	li	s5,10
 3b8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3ba:	89a6                	mv	s3,s1
 3bc:	2485                	addw	s1,s1,1
 3be:	0344d863          	bge	s1,s4,3ee <gets+0x56>
    cc = read(0, &c, 1);
 3c2:	4605                	li	a2,1
 3c4:	faf40593          	add	a1,s0,-81
 3c8:	4501                	li	a0,0
 3ca:	00000097          	auipc	ra,0x0
 3ce:	19a080e7          	jalr	410(ra) # 564 <read>
    if(cc < 1)
 3d2:	00a05e63          	blez	a0,3ee <gets+0x56>
    buf[i++] = c;
 3d6:	faf44783          	lbu	a5,-81(s0)
 3da:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3de:	01578763          	beq	a5,s5,3ec <gets+0x54>
 3e2:	0905                	add	s2,s2,1
 3e4:	fd679be3          	bne	a5,s6,3ba <gets+0x22>
    buf[i++] = c;
 3e8:	89a6                	mv	s3,s1
 3ea:	a011                	j	3ee <gets+0x56>
 3ec:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ee:	99de                	add	s3,s3,s7
 3f0:	00098023          	sb	zero,0(s3)
  return buf;
}
 3f4:	855e                	mv	a0,s7
 3f6:	60e6                	ld	ra,88(sp)
 3f8:	6446                	ld	s0,80(sp)
 3fa:	64a6                	ld	s1,72(sp)
 3fc:	6906                	ld	s2,64(sp)
 3fe:	79e2                	ld	s3,56(sp)
 400:	7a42                	ld	s4,48(sp)
 402:	7aa2                	ld	s5,40(sp)
 404:	7b02                	ld	s6,32(sp)
 406:	6be2                	ld	s7,24(sp)
 408:	6125                	add	sp,sp,96
 40a:	8082                	ret

000000000000040c <stat>:

int
stat(const char *n, struct stat *st)
{
 40c:	1101                	add	sp,sp,-32
 40e:	ec06                	sd	ra,24(sp)
 410:	e822                	sd	s0,16(sp)
 412:	e04a                	sd	s2,0(sp)
 414:	1000                	add	s0,sp,32
 416:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 418:	4581                	li	a1,0
 41a:	00000097          	auipc	ra,0x0
 41e:	172080e7          	jalr	370(ra) # 58c <open>
  if(fd < 0)
 422:	02054663          	bltz	a0,44e <stat+0x42>
 426:	e426                	sd	s1,8(sp)
 428:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 42a:	85ca                	mv	a1,s2
 42c:	00000097          	auipc	ra,0x0
 430:	178080e7          	jalr	376(ra) # 5a4 <fstat>
 434:	892a                	mv	s2,a0
  close(fd);
 436:	8526                	mv	a0,s1
 438:	00000097          	auipc	ra,0x0
 43c:	13c080e7          	jalr	316(ra) # 574 <close>
  return r;
 440:	64a2                	ld	s1,8(sp)
}
 442:	854a                	mv	a0,s2
 444:	60e2                	ld	ra,24(sp)
 446:	6442                	ld	s0,16(sp)
 448:	6902                	ld	s2,0(sp)
 44a:	6105                	add	sp,sp,32
 44c:	8082                	ret
    return -1;
 44e:	597d                	li	s2,-1
 450:	bfcd                	j	442 <stat+0x36>

0000000000000452 <atoi>:

int
atoi(const char *s)
{
 452:	1141                	add	sp,sp,-16
 454:	e422                	sd	s0,8(sp)
 456:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 458:	00054683          	lbu	a3,0(a0)
 45c:	fd06879b          	addw	a5,a3,-48
 460:	0ff7f793          	zext.b	a5,a5
 464:	4625                	li	a2,9
 466:	02f66863          	bltu	a2,a5,496 <atoi+0x44>
 46a:	872a                	mv	a4,a0
  n = 0;
 46c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 46e:	0705                	add	a4,a4,1
 470:	0025179b          	sllw	a5,a0,0x2
 474:	9fa9                	addw	a5,a5,a0
 476:	0017979b          	sllw	a5,a5,0x1
 47a:	9fb5                	addw	a5,a5,a3
 47c:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 480:	00074683          	lbu	a3,0(a4)
 484:	fd06879b          	addw	a5,a3,-48
 488:	0ff7f793          	zext.b	a5,a5
 48c:	fef671e3          	bgeu	a2,a5,46e <atoi+0x1c>
  return n;
}
 490:	6422                	ld	s0,8(sp)
 492:	0141                	add	sp,sp,16
 494:	8082                	ret
  n = 0;
 496:	4501                	li	a0,0
 498:	bfe5                	j	490 <atoi+0x3e>

000000000000049a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 49a:	1141                	add	sp,sp,-16
 49c:	e422                	sd	s0,8(sp)
 49e:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4a0:	02b57463          	bgeu	a0,a1,4c8 <memmove+0x2e>
    while(n-- > 0)
 4a4:	00c05f63          	blez	a2,4c2 <memmove+0x28>
 4a8:	1602                	sll	a2,a2,0x20
 4aa:	9201                	srl	a2,a2,0x20
 4ac:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4b0:	872a                	mv	a4,a0
      *dst++ = *src++;
 4b2:	0585                	add	a1,a1,1
 4b4:	0705                	add	a4,a4,1
 4b6:	fff5c683          	lbu	a3,-1(a1)
 4ba:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4be:	fef71ae3          	bne	a4,a5,4b2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4c2:	6422                	ld	s0,8(sp)
 4c4:	0141                	add	sp,sp,16
 4c6:	8082                	ret
    dst += n;
 4c8:	00c50733          	add	a4,a0,a2
    src += n;
 4cc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4ce:	fec05ae3          	blez	a2,4c2 <memmove+0x28>
 4d2:	fff6079b          	addw	a5,a2,-1
 4d6:	1782                	sll	a5,a5,0x20
 4d8:	9381                	srl	a5,a5,0x20
 4da:	fff7c793          	not	a5,a5
 4de:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4e0:	15fd                	add	a1,a1,-1
 4e2:	177d                	add	a4,a4,-1
 4e4:	0005c683          	lbu	a3,0(a1)
 4e8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4ec:	fee79ae3          	bne	a5,a4,4e0 <memmove+0x46>
 4f0:	bfc9                	j	4c2 <memmove+0x28>

00000000000004f2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4f2:	1141                	add	sp,sp,-16
 4f4:	e422                	sd	s0,8(sp)
 4f6:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4f8:	ca05                	beqz	a2,528 <memcmp+0x36>
 4fa:	fff6069b          	addw	a3,a2,-1
 4fe:	1682                	sll	a3,a3,0x20
 500:	9281                	srl	a3,a3,0x20
 502:	0685                	add	a3,a3,1
 504:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 506:	00054783          	lbu	a5,0(a0)
 50a:	0005c703          	lbu	a4,0(a1)
 50e:	00e79863          	bne	a5,a4,51e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 512:	0505                	add	a0,a0,1
    p2++;
 514:	0585                	add	a1,a1,1
  while (n-- > 0) {
 516:	fed518e3          	bne	a0,a3,506 <memcmp+0x14>
  }
  return 0;
 51a:	4501                	li	a0,0
 51c:	a019                	j	522 <memcmp+0x30>
      return *p1 - *p2;
 51e:	40e7853b          	subw	a0,a5,a4
}
 522:	6422                	ld	s0,8(sp)
 524:	0141                	add	sp,sp,16
 526:	8082                	ret
  return 0;
 528:	4501                	li	a0,0
 52a:	bfe5                	j	522 <memcmp+0x30>

000000000000052c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 52c:	1141                	add	sp,sp,-16
 52e:	e406                	sd	ra,8(sp)
 530:	e022                	sd	s0,0(sp)
 532:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 534:	00000097          	auipc	ra,0x0
 538:	f66080e7          	jalr	-154(ra) # 49a <memmove>
}
 53c:	60a2                	ld	ra,8(sp)
 53e:	6402                	ld	s0,0(sp)
 540:	0141                	add	sp,sp,16
 542:	8082                	ret

0000000000000544 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 544:	4885                	li	a7,1
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <exit>:
.global exit
exit:
 li a7, SYS_exit
 54c:	4889                	li	a7,2
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <wait>:
.global wait
wait:
 li a7, SYS_wait
 554:	488d                	li	a7,3
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 55c:	4891                	li	a7,4
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <read>:
.global read
read:
 li a7, SYS_read
 564:	4895                	li	a7,5
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <write>:
.global write
write:
 li a7, SYS_write
 56c:	48c1                	li	a7,16
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <close>:
.global close
close:
 li a7, SYS_close
 574:	48d5                	li	a7,21
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <kill>:
.global kill
kill:
 li a7, SYS_kill
 57c:	4899                	li	a7,6
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <exec>:
.global exec
exec:
 li a7, SYS_exec
 584:	489d                	li	a7,7
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <open>:
.global open
open:
 li a7, SYS_open
 58c:	48bd                	li	a7,15
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 594:	48c5                	li	a7,17
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 59c:	48c9                	li	a7,18
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5a4:	48a1                	li	a7,8
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <link>:
.global link
link:
 li a7, SYS_link
 5ac:	48cd                	li	a7,19
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5b4:	48d1                	li	a7,20
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5bc:	48a5                	li	a7,9
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5c4:	48a9                	li	a7,10
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5cc:	48ad                	li	a7,11
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5d4:	48b1                	li	a7,12
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5dc:	48b5                	li	a7,13
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5e4:	48b9                	li	a7,14
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ec:	1101                	add	sp,sp,-32
 5ee:	ec06                	sd	ra,24(sp)
 5f0:	e822                	sd	s0,16(sp)
 5f2:	1000                	add	s0,sp,32
 5f4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5f8:	4605                	li	a2,1
 5fa:	fef40593          	add	a1,s0,-17
 5fe:	00000097          	auipc	ra,0x0
 602:	f6e080e7          	jalr	-146(ra) # 56c <write>
}
 606:	60e2                	ld	ra,24(sp)
 608:	6442                	ld	s0,16(sp)
 60a:	6105                	add	sp,sp,32
 60c:	8082                	ret

000000000000060e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 60e:	7139                	add	sp,sp,-64
 610:	fc06                	sd	ra,56(sp)
 612:	f822                	sd	s0,48(sp)
 614:	f426                	sd	s1,40(sp)
 616:	0080                	add	s0,sp,64
 618:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 61a:	c299                	beqz	a3,620 <printint+0x12>
 61c:	0805cb63          	bltz	a1,6b2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 620:	2581                	sext.w	a1,a1
  neg = 0;
 622:	4881                	li	a7,0
 624:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 628:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 62a:	2601                	sext.w	a2,a2
 62c:	00000517          	auipc	a0,0x0
 630:	52c50513          	add	a0,a0,1324 # b58 <digits>
 634:	883a                	mv	a6,a4
 636:	2705                	addw	a4,a4,1
 638:	02c5f7bb          	remuw	a5,a1,a2
 63c:	1782                	sll	a5,a5,0x20
 63e:	9381                	srl	a5,a5,0x20
 640:	97aa                	add	a5,a5,a0
 642:	0007c783          	lbu	a5,0(a5)
 646:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 64a:	0005879b          	sext.w	a5,a1
 64e:	02c5d5bb          	divuw	a1,a1,a2
 652:	0685                	add	a3,a3,1
 654:	fec7f0e3          	bgeu	a5,a2,634 <printint+0x26>
  if(neg)
 658:	00088c63          	beqz	a7,670 <printint+0x62>
    buf[i++] = '-';
 65c:	fd070793          	add	a5,a4,-48
 660:	00878733          	add	a4,a5,s0
 664:	02d00793          	li	a5,45
 668:	fef70823          	sb	a5,-16(a4)
 66c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 670:	02e05c63          	blez	a4,6a8 <printint+0x9a>
 674:	f04a                	sd	s2,32(sp)
 676:	ec4e                	sd	s3,24(sp)
 678:	fc040793          	add	a5,s0,-64
 67c:	00e78933          	add	s2,a5,a4
 680:	fff78993          	add	s3,a5,-1
 684:	99ba                	add	s3,s3,a4
 686:	377d                	addw	a4,a4,-1
 688:	1702                	sll	a4,a4,0x20
 68a:	9301                	srl	a4,a4,0x20
 68c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 690:	fff94583          	lbu	a1,-1(s2)
 694:	8526                	mv	a0,s1
 696:	00000097          	auipc	ra,0x0
 69a:	f56080e7          	jalr	-170(ra) # 5ec <putc>
  while(--i >= 0)
 69e:	197d                	add	s2,s2,-1
 6a0:	ff3918e3          	bne	s2,s3,690 <printint+0x82>
 6a4:	7902                	ld	s2,32(sp)
 6a6:	69e2                	ld	s3,24(sp)
}
 6a8:	70e2                	ld	ra,56(sp)
 6aa:	7442                	ld	s0,48(sp)
 6ac:	74a2                	ld	s1,40(sp)
 6ae:	6121                	add	sp,sp,64
 6b0:	8082                	ret
    x = -xx;
 6b2:	40b005bb          	negw	a1,a1
    neg = 1;
 6b6:	4885                	li	a7,1
    x = -xx;
 6b8:	b7b5                	j	624 <printint+0x16>

00000000000006ba <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ba:	715d                	add	sp,sp,-80
 6bc:	e486                	sd	ra,72(sp)
 6be:	e0a2                	sd	s0,64(sp)
 6c0:	f84a                	sd	s2,48(sp)
 6c2:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6c4:	0005c903          	lbu	s2,0(a1)
 6c8:	1a090a63          	beqz	s2,87c <vprintf+0x1c2>
 6cc:	fc26                	sd	s1,56(sp)
 6ce:	f44e                	sd	s3,40(sp)
 6d0:	f052                	sd	s4,32(sp)
 6d2:	ec56                	sd	s5,24(sp)
 6d4:	e85a                	sd	s6,16(sp)
 6d6:	e45e                	sd	s7,8(sp)
 6d8:	8aaa                	mv	s5,a0
 6da:	8bb2                	mv	s7,a2
 6dc:	00158493          	add	s1,a1,1
  state = 0;
 6e0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6e2:	02500a13          	li	s4,37
 6e6:	4b55                	li	s6,21
 6e8:	a839                	j	706 <vprintf+0x4c>
        putc(fd, c);
 6ea:	85ca                	mv	a1,s2
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	efe080e7          	jalr	-258(ra) # 5ec <putc>
 6f6:	a019                	j	6fc <vprintf+0x42>
    } else if(state == '%'){
 6f8:	01498d63          	beq	s3,s4,712 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 6fc:	0485                	add	s1,s1,1
 6fe:	fff4c903          	lbu	s2,-1(s1)
 702:	16090763          	beqz	s2,870 <vprintf+0x1b6>
    if(state == 0){
 706:	fe0999e3          	bnez	s3,6f8 <vprintf+0x3e>
      if(c == '%'){
 70a:	ff4910e3          	bne	s2,s4,6ea <vprintf+0x30>
        state = '%';
 70e:	89d2                	mv	s3,s4
 710:	b7f5                	j	6fc <vprintf+0x42>
      if(c == 'd'){
 712:	13490463          	beq	s2,s4,83a <vprintf+0x180>
 716:	f9d9079b          	addw	a5,s2,-99
 71a:	0ff7f793          	zext.b	a5,a5
 71e:	12fb6763          	bltu	s6,a5,84c <vprintf+0x192>
 722:	f9d9079b          	addw	a5,s2,-99
 726:	0ff7f713          	zext.b	a4,a5
 72a:	12eb6163          	bltu	s6,a4,84c <vprintf+0x192>
 72e:	00271793          	sll	a5,a4,0x2
 732:	00000717          	auipc	a4,0x0
 736:	3ce70713          	add	a4,a4,974 # b00 <malloc+0x194>
 73a:	97ba                	add	a5,a5,a4
 73c:	439c                	lw	a5,0(a5)
 73e:	97ba                	add	a5,a5,a4
 740:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 742:	008b8913          	add	s2,s7,8
 746:	4685                	li	a3,1
 748:	4629                	li	a2,10
 74a:	000ba583          	lw	a1,0(s7)
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	ebe080e7          	jalr	-322(ra) # 60e <printint>
 758:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b745                	j	6fc <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 75e:	008b8913          	add	s2,s7,8
 762:	4681                	li	a3,0
 764:	4629                	li	a2,10
 766:	000ba583          	lw	a1,0(s7)
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	ea2080e7          	jalr	-350(ra) # 60e <printint>
 774:	8bca                	mv	s7,s2
      state = 0;
 776:	4981                	li	s3,0
 778:	b751                	j	6fc <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 77a:	008b8913          	add	s2,s7,8
 77e:	4681                	li	a3,0
 780:	4641                	li	a2,16
 782:	000ba583          	lw	a1,0(s7)
 786:	8556                	mv	a0,s5
 788:	00000097          	auipc	ra,0x0
 78c:	e86080e7          	jalr	-378(ra) # 60e <printint>
 790:	8bca                	mv	s7,s2
      state = 0;
 792:	4981                	li	s3,0
 794:	b7a5                	j	6fc <vprintf+0x42>
 796:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 798:	008b8c13          	add	s8,s7,8
 79c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7a0:	03000593          	li	a1,48
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e46080e7          	jalr	-442(ra) # 5ec <putc>
  putc(fd, 'x');
 7ae:	07800593          	li	a1,120
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	e38080e7          	jalr	-456(ra) # 5ec <putc>
 7bc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7be:	00000b97          	auipc	s7,0x0
 7c2:	39ab8b93          	add	s7,s7,922 # b58 <digits>
 7c6:	03c9d793          	srl	a5,s3,0x3c
 7ca:	97de                	add	a5,a5,s7
 7cc:	0007c583          	lbu	a1,0(a5)
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e1a080e7          	jalr	-486(ra) # 5ec <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7da:	0992                	sll	s3,s3,0x4
 7dc:	397d                	addw	s2,s2,-1
 7de:	fe0914e3          	bnez	s2,7c6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7e2:	8be2                	mv	s7,s8
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	6c02                	ld	s8,0(sp)
 7e8:	bf11                	j	6fc <vprintf+0x42>
        s = va_arg(ap, char*);
 7ea:	008b8993          	add	s3,s7,8
 7ee:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7f2:	02090163          	beqz	s2,814 <vprintf+0x15a>
        while(*s != 0){
 7f6:	00094583          	lbu	a1,0(s2)
 7fa:	c9a5                	beqz	a1,86a <vprintf+0x1b0>
          putc(fd, *s);
 7fc:	8556                	mv	a0,s5
 7fe:	00000097          	auipc	ra,0x0
 802:	dee080e7          	jalr	-530(ra) # 5ec <putc>
          s++;
 806:	0905                	add	s2,s2,1
        while(*s != 0){
 808:	00094583          	lbu	a1,0(s2)
 80c:	f9e5                	bnez	a1,7fc <vprintf+0x142>
        s = va_arg(ap, char*);
 80e:	8bce                	mv	s7,s3
      state = 0;
 810:	4981                	li	s3,0
 812:	b5ed                	j	6fc <vprintf+0x42>
          s = "(null)";
 814:	00000917          	auipc	s2,0x0
 818:	2e490913          	add	s2,s2,740 # af8 <malloc+0x18c>
        while(*s != 0){
 81c:	02800593          	li	a1,40
 820:	bff1                	j	7fc <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 822:	008b8913          	add	s2,s7,8
 826:	000bc583          	lbu	a1,0(s7)
 82a:	8556                	mv	a0,s5
 82c:	00000097          	auipc	ra,0x0
 830:	dc0080e7          	jalr	-576(ra) # 5ec <putc>
 834:	8bca                	mv	s7,s2
      state = 0;
 836:	4981                	li	s3,0
 838:	b5d1                	j	6fc <vprintf+0x42>
        putc(fd, c);
 83a:	02500593          	li	a1,37
 83e:	8556                	mv	a0,s5
 840:	00000097          	auipc	ra,0x0
 844:	dac080e7          	jalr	-596(ra) # 5ec <putc>
      state = 0;
 848:	4981                	li	s3,0
 84a:	bd4d                	j	6fc <vprintf+0x42>
        putc(fd, '%');
 84c:	02500593          	li	a1,37
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	d9a080e7          	jalr	-614(ra) # 5ec <putc>
        putc(fd, c);
 85a:	85ca                	mv	a1,s2
 85c:	8556                	mv	a0,s5
 85e:	00000097          	auipc	ra,0x0
 862:	d8e080e7          	jalr	-626(ra) # 5ec <putc>
      state = 0;
 866:	4981                	li	s3,0
 868:	bd51                	j	6fc <vprintf+0x42>
        s = va_arg(ap, char*);
 86a:	8bce                	mv	s7,s3
      state = 0;
 86c:	4981                	li	s3,0
 86e:	b579                	j	6fc <vprintf+0x42>
 870:	74e2                	ld	s1,56(sp)
 872:	79a2                	ld	s3,40(sp)
 874:	7a02                	ld	s4,32(sp)
 876:	6ae2                	ld	s5,24(sp)
 878:	6b42                	ld	s6,16(sp)
 87a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 87c:	60a6                	ld	ra,72(sp)
 87e:	6406                	ld	s0,64(sp)
 880:	7942                	ld	s2,48(sp)
 882:	6161                	add	sp,sp,80
 884:	8082                	ret

0000000000000886 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 886:	715d                	add	sp,sp,-80
 888:	ec06                	sd	ra,24(sp)
 88a:	e822                	sd	s0,16(sp)
 88c:	1000                	add	s0,sp,32
 88e:	e010                	sd	a2,0(s0)
 890:	e414                	sd	a3,8(s0)
 892:	e818                	sd	a4,16(s0)
 894:	ec1c                	sd	a5,24(s0)
 896:	03043023          	sd	a6,32(s0)
 89a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 89e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8a2:	8622                	mv	a2,s0
 8a4:	00000097          	auipc	ra,0x0
 8a8:	e16080e7          	jalr	-490(ra) # 6ba <vprintf>
}
 8ac:	60e2                	ld	ra,24(sp)
 8ae:	6442                	ld	s0,16(sp)
 8b0:	6161                	add	sp,sp,80
 8b2:	8082                	ret

00000000000008b4 <printf>:

void
printf(const char *fmt, ...)
{
 8b4:	711d                	add	sp,sp,-96
 8b6:	ec06                	sd	ra,24(sp)
 8b8:	e822                	sd	s0,16(sp)
 8ba:	1000                	add	s0,sp,32
 8bc:	e40c                	sd	a1,8(s0)
 8be:	e810                	sd	a2,16(s0)
 8c0:	ec14                	sd	a3,24(s0)
 8c2:	f018                	sd	a4,32(s0)
 8c4:	f41c                	sd	a5,40(s0)
 8c6:	03043823          	sd	a6,48(s0)
 8ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ce:	00840613          	add	a2,s0,8
 8d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8d6:	85aa                	mv	a1,a0
 8d8:	4505                	li	a0,1
 8da:	00000097          	auipc	ra,0x0
 8de:	de0080e7          	jalr	-544(ra) # 6ba <vprintf>
}
 8e2:	60e2                	ld	ra,24(sp)
 8e4:	6442                	ld	s0,16(sp)
 8e6:	6125                	add	sp,sp,96
 8e8:	8082                	ret

00000000000008ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ea:	1141                	add	sp,sp,-16
 8ec:	e422                	sd	s0,8(sp)
 8ee:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8f0:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f4:	00000797          	auipc	a5,0x0
 8f8:	27c7b783          	ld	a5,636(a5) # b70 <freep>
 8fc:	a02d                	j	926 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8fe:	4618                	lw	a4,8(a2)
 900:	9f2d                	addw	a4,a4,a1
 902:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 906:	6398                	ld	a4,0(a5)
 908:	6310                	ld	a2,0(a4)
 90a:	a83d                	j	948 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 90c:	ff852703          	lw	a4,-8(a0)
 910:	9f31                	addw	a4,a4,a2
 912:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 914:	ff053683          	ld	a3,-16(a0)
 918:	a091                	j	95c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 91a:	6398                	ld	a4,0(a5)
 91c:	00e7e463          	bltu	a5,a4,924 <free+0x3a>
 920:	00e6ea63          	bltu	a3,a4,934 <free+0x4a>
{
 924:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 926:	fed7fae3          	bgeu	a5,a3,91a <free+0x30>
 92a:	6398                	ld	a4,0(a5)
 92c:	00e6e463          	bltu	a3,a4,934 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 930:	fee7eae3          	bltu	a5,a4,924 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 934:	ff852583          	lw	a1,-8(a0)
 938:	6390                	ld	a2,0(a5)
 93a:	02059813          	sll	a6,a1,0x20
 93e:	01c85713          	srl	a4,a6,0x1c
 942:	9736                	add	a4,a4,a3
 944:	fae60de3          	beq	a2,a4,8fe <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 948:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 94c:	4790                	lw	a2,8(a5)
 94e:	02061593          	sll	a1,a2,0x20
 952:	01c5d713          	srl	a4,a1,0x1c
 956:	973e                	add	a4,a4,a5
 958:	fae68ae3          	beq	a3,a4,90c <free+0x22>
    p->s.ptr = bp->s.ptr;
 95c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 95e:	00000717          	auipc	a4,0x0
 962:	20f73923          	sd	a5,530(a4) # b70 <freep>
}
 966:	6422                	ld	s0,8(sp)
 968:	0141                	add	sp,sp,16
 96a:	8082                	ret

000000000000096c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 96c:	7139                	add	sp,sp,-64
 96e:	fc06                	sd	ra,56(sp)
 970:	f822                	sd	s0,48(sp)
 972:	f426                	sd	s1,40(sp)
 974:	ec4e                	sd	s3,24(sp)
 976:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 978:	02051493          	sll	s1,a0,0x20
 97c:	9081                	srl	s1,s1,0x20
 97e:	04bd                	add	s1,s1,15
 980:	8091                	srl	s1,s1,0x4
 982:	0014899b          	addw	s3,s1,1
 986:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 988:	00000517          	auipc	a0,0x0
 98c:	1e853503          	ld	a0,488(a0) # b70 <freep>
 990:	c915                	beqz	a0,9c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 992:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 994:	4798                	lw	a4,8(a5)
 996:	08977e63          	bgeu	a4,s1,a32 <malloc+0xc6>
 99a:	f04a                	sd	s2,32(sp)
 99c:	e852                	sd	s4,16(sp)
 99e:	e456                	sd	s5,8(sp)
 9a0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9a2:	8a4e                	mv	s4,s3
 9a4:	0009871b          	sext.w	a4,s3
 9a8:	6685                	lui	a3,0x1
 9aa:	00d77363          	bgeu	a4,a3,9b0 <malloc+0x44>
 9ae:	6a05                	lui	s4,0x1
 9b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9b4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b8:	00000917          	auipc	s2,0x0
 9bc:	1b890913          	add	s2,s2,440 # b70 <freep>
  if(p == (char*)-1)
 9c0:	5afd                	li	s5,-1
 9c2:	a091                	j	a06 <malloc+0x9a>
 9c4:	f04a                	sd	s2,32(sp)
 9c6:	e852                	sd	s4,16(sp)
 9c8:	e456                	sd	s5,8(sp)
 9ca:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9cc:	00000797          	auipc	a5,0x0
 9d0:	1bc78793          	add	a5,a5,444 # b88 <base>
 9d4:	00000717          	auipc	a4,0x0
 9d8:	18f73e23          	sd	a5,412(a4) # b70 <freep>
 9dc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9de:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9e2:	b7c1                	j	9a2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9e4:	6398                	ld	a4,0(a5)
 9e6:	e118                	sd	a4,0(a0)
 9e8:	a08d                	j	a4a <malloc+0xde>
  hp->s.size = nu;
 9ea:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9ee:	0541                	add	a0,a0,16
 9f0:	00000097          	auipc	ra,0x0
 9f4:	efa080e7          	jalr	-262(ra) # 8ea <free>
  return freep;
 9f8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9fc:	c13d                	beqz	a0,a62 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a00:	4798                	lw	a4,8(a5)
 a02:	02977463          	bgeu	a4,s1,a2a <malloc+0xbe>
    if(p == freep)
 a06:	00093703          	ld	a4,0(s2)
 a0a:	853e                	mv	a0,a5
 a0c:	fef719e3          	bne	a4,a5,9fe <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a10:	8552                	mv	a0,s4
 a12:	00000097          	auipc	ra,0x0
 a16:	bc2080e7          	jalr	-1086(ra) # 5d4 <sbrk>
  if(p == (char*)-1)
 a1a:	fd5518e3          	bne	a0,s5,9ea <malloc+0x7e>
        return 0;
 a1e:	4501                	li	a0,0
 a20:	7902                	ld	s2,32(sp)
 a22:	6a42                	ld	s4,16(sp)
 a24:	6aa2                	ld	s5,8(sp)
 a26:	6b02                	ld	s6,0(sp)
 a28:	a03d                	j	a56 <malloc+0xea>
 a2a:	7902                	ld	s2,32(sp)
 a2c:	6a42                	ld	s4,16(sp)
 a2e:	6aa2                	ld	s5,8(sp)
 a30:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a32:	fae489e3          	beq	s1,a4,9e4 <malloc+0x78>
        p->s.size -= nunits;
 a36:	4137073b          	subw	a4,a4,s3
 a3a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a3c:	02071693          	sll	a3,a4,0x20
 a40:	01c6d713          	srl	a4,a3,0x1c
 a44:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a46:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a4a:	00000717          	auipc	a4,0x0
 a4e:	12a73323          	sd	a0,294(a4) # b70 <freep>
      return (void*)(p + 1);
 a52:	01078513          	add	a0,a5,16
  }
}
 a56:	70e2                	ld	ra,56(sp)
 a58:	7442                	ld	s0,48(sp)
 a5a:	74a2                	ld	s1,40(sp)
 a5c:	69e2                	ld	s3,24(sp)
 a5e:	6121                	add	sp,sp,64
 a60:	8082                	ret
 a62:	7902                	ld	s2,32(sp)
 a64:	6a42                	ld	s4,16(sp)
 a66:	6aa2                	ld	s5,8(sp)
 a68:	6b02                	ld	s6,0(sp)
 a6a:	b7f5                	j	a56 <malloc+0xea>
