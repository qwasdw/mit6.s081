
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
  66:	b2698993          	add	s3,s3,-1242 # b88 <buf.0>
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
 126:	95e58593          	add	a1,a1,-1698 # a80 <malloc+0x104>
 12a:	4509                	li	a0,2
 12c:	00000097          	auipc	ra,0x0
 130:	76a080e7          	jalr	1898(ra) # 896 <fprintf>
        return;
 134:	bfd9                	j	10a <find+0x56>
        fprintf(2, "find: cannot stat %s\n", path);
 136:	864a                	mv	a2,s2
 138:	00001597          	auipc	a1,0x1
 13c:	96858593          	add	a1,a1,-1688 # aa0 <malloc+0x124>
 140:	4509                	li	a0,2
 142:	00000097          	auipc	ra,0x0
 146:	754080e7          	jalr	1876(ra) # 896 <fprintf>
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
 208:	8d458593          	add	a1,a1,-1836 # ad8 <malloc+0x15c>
 20c:	8552                	mv	a0,s4
 20e:	00000097          	auipc	ra,0x0
 212:	0ee080e7          	jalr	238(ra) # 2fc <strcmp>
 216:	d951                	beqz	a0,1aa <find+0xf6>
 218:	00001597          	auipc	a1,0x1
 21c:	8c858593          	add	a1,a1,-1848 # ae0 <malloc+0x164>
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
 240:	87c50513          	add	a0,a0,-1924 # ab8 <malloc+0x13c>
 244:	00000097          	auipc	ra,0x0
 248:	680080e7          	jalr	1664(ra) # 8c4 <printf>
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
 264:	84050513          	add	a0,a0,-1984 # aa0 <malloc+0x124>
 268:	00000097          	auipc	ra,0x0
 26c:	65c080e7          	jalr	1628(ra) # 8c4 <printf>
            continue;
 270:	bf2d                	j	1aa <find+0xf6>
            printf("%s\n", buf);
 272:	dc040593          	add	a1,s0,-576
 276:	00001517          	auipc	a0,0x1
 27a:	85a50513          	add	a0,a0,-1958 # ad0 <malloc+0x154>
 27e:	00000097          	auipc	ra,0x0
 282:	646080e7          	jalr	1606(ra) # 8c4 <printf>
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
 2b2:	83a50513          	add	a0,a0,-1990 # ae8 <malloc+0x16c>
 2b6:	00000097          	auipc	ra,0x0
 2ba:	60e080e7          	jalr	1550(ra) # 8c4 <printf>
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

00000000000005ec <trace>:
.global trace
trace:
 li a7, SYS_trace
 5ec:	48d9                	li	a7,22
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 5f4:	48dd                	li	a7,23
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5fc:	1101                	add	sp,sp,-32
 5fe:	ec06                	sd	ra,24(sp)
 600:	e822                	sd	s0,16(sp)
 602:	1000                	add	s0,sp,32
 604:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 608:	4605                	li	a2,1
 60a:	fef40593          	add	a1,s0,-17
 60e:	00000097          	auipc	ra,0x0
 612:	f5e080e7          	jalr	-162(ra) # 56c <write>
}
 616:	60e2                	ld	ra,24(sp)
 618:	6442                	ld	s0,16(sp)
 61a:	6105                	add	sp,sp,32
 61c:	8082                	ret

000000000000061e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 61e:	7139                	add	sp,sp,-64
 620:	fc06                	sd	ra,56(sp)
 622:	f822                	sd	s0,48(sp)
 624:	f426                	sd	s1,40(sp)
 626:	0080                	add	s0,sp,64
 628:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 62a:	c299                	beqz	a3,630 <printint+0x12>
 62c:	0805cb63          	bltz	a1,6c2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 630:	2581                	sext.w	a1,a1
  neg = 0;
 632:	4881                	li	a7,0
 634:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 638:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 63a:	2601                	sext.w	a2,a2
 63c:	00000517          	auipc	a0,0x0
 640:	52c50513          	add	a0,a0,1324 # b68 <digits>
 644:	883a                	mv	a6,a4
 646:	2705                	addw	a4,a4,1
 648:	02c5f7bb          	remuw	a5,a1,a2
 64c:	1782                	sll	a5,a5,0x20
 64e:	9381                	srl	a5,a5,0x20
 650:	97aa                	add	a5,a5,a0
 652:	0007c783          	lbu	a5,0(a5)
 656:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 65a:	0005879b          	sext.w	a5,a1
 65e:	02c5d5bb          	divuw	a1,a1,a2
 662:	0685                	add	a3,a3,1
 664:	fec7f0e3          	bgeu	a5,a2,644 <printint+0x26>
  if(neg)
 668:	00088c63          	beqz	a7,680 <printint+0x62>
    buf[i++] = '-';
 66c:	fd070793          	add	a5,a4,-48
 670:	00878733          	add	a4,a5,s0
 674:	02d00793          	li	a5,45
 678:	fef70823          	sb	a5,-16(a4)
 67c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 680:	02e05c63          	blez	a4,6b8 <printint+0x9a>
 684:	f04a                	sd	s2,32(sp)
 686:	ec4e                	sd	s3,24(sp)
 688:	fc040793          	add	a5,s0,-64
 68c:	00e78933          	add	s2,a5,a4
 690:	fff78993          	add	s3,a5,-1
 694:	99ba                	add	s3,s3,a4
 696:	377d                	addw	a4,a4,-1
 698:	1702                	sll	a4,a4,0x20
 69a:	9301                	srl	a4,a4,0x20
 69c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6a0:	fff94583          	lbu	a1,-1(s2)
 6a4:	8526                	mv	a0,s1
 6a6:	00000097          	auipc	ra,0x0
 6aa:	f56080e7          	jalr	-170(ra) # 5fc <putc>
  while(--i >= 0)
 6ae:	197d                	add	s2,s2,-1
 6b0:	ff3918e3          	bne	s2,s3,6a0 <printint+0x82>
 6b4:	7902                	ld	s2,32(sp)
 6b6:	69e2                	ld	s3,24(sp)
}
 6b8:	70e2                	ld	ra,56(sp)
 6ba:	7442                	ld	s0,48(sp)
 6bc:	74a2                	ld	s1,40(sp)
 6be:	6121                	add	sp,sp,64
 6c0:	8082                	ret
    x = -xx;
 6c2:	40b005bb          	negw	a1,a1
    neg = 1;
 6c6:	4885                	li	a7,1
    x = -xx;
 6c8:	b7b5                	j	634 <printint+0x16>

00000000000006ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ca:	715d                	add	sp,sp,-80
 6cc:	e486                	sd	ra,72(sp)
 6ce:	e0a2                	sd	s0,64(sp)
 6d0:	f84a                	sd	s2,48(sp)
 6d2:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6d4:	0005c903          	lbu	s2,0(a1)
 6d8:	1a090a63          	beqz	s2,88c <vprintf+0x1c2>
 6dc:	fc26                	sd	s1,56(sp)
 6de:	f44e                	sd	s3,40(sp)
 6e0:	f052                	sd	s4,32(sp)
 6e2:	ec56                	sd	s5,24(sp)
 6e4:	e85a                	sd	s6,16(sp)
 6e6:	e45e                	sd	s7,8(sp)
 6e8:	8aaa                	mv	s5,a0
 6ea:	8bb2                	mv	s7,a2
 6ec:	00158493          	add	s1,a1,1
  state = 0;
 6f0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6f2:	02500a13          	li	s4,37
 6f6:	4b55                	li	s6,21
 6f8:	a839                	j	716 <vprintf+0x4c>
        putc(fd, c);
 6fa:	85ca                	mv	a1,s2
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	efe080e7          	jalr	-258(ra) # 5fc <putc>
 706:	a019                	j	70c <vprintf+0x42>
    } else if(state == '%'){
 708:	01498d63          	beq	s3,s4,722 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 70c:	0485                	add	s1,s1,1
 70e:	fff4c903          	lbu	s2,-1(s1)
 712:	16090763          	beqz	s2,880 <vprintf+0x1b6>
    if(state == 0){
 716:	fe0999e3          	bnez	s3,708 <vprintf+0x3e>
      if(c == '%'){
 71a:	ff4910e3          	bne	s2,s4,6fa <vprintf+0x30>
        state = '%';
 71e:	89d2                	mv	s3,s4
 720:	b7f5                	j	70c <vprintf+0x42>
      if(c == 'd'){
 722:	13490463          	beq	s2,s4,84a <vprintf+0x180>
 726:	f9d9079b          	addw	a5,s2,-99
 72a:	0ff7f793          	zext.b	a5,a5
 72e:	12fb6763          	bltu	s6,a5,85c <vprintf+0x192>
 732:	f9d9079b          	addw	a5,s2,-99
 736:	0ff7f713          	zext.b	a4,a5
 73a:	12eb6163          	bltu	s6,a4,85c <vprintf+0x192>
 73e:	00271793          	sll	a5,a4,0x2
 742:	00000717          	auipc	a4,0x0
 746:	3ce70713          	add	a4,a4,974 # b10 <malloc+0x194>
 74a:	97ba                	add	a5,a5,a4
 74c:	439c                	lw	a5,0(a5)
 74e:	97ba                	add	a5,a5,a4
 750:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 752:	008b8913          	add	s2,s7,8
 756:	4685                	li	a3,1
 758:	4629                	li	a2,10
 75a:	000ba583          	lw	a1,0(s7)
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	ebe080e7          	jalr	-322(ra) # 61e <printint>
 768:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 76a:	4981                	li	s3,0
 76c:	b745                	j	70c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 76e:	008b8913          	add	s2,s7,8
 772:	4681                	li	a3,0
 774:	4629                	li	a2,10
 776:	000ba583          	lw	a1,0(s7)
 77a:	8556                	mv	a0,s5
 77c:	00000097          	auipc	ra,0x0
 780:	ea2080e7          	jalr	-350(ra) # 61e <printint>
 784:	8bca                	mv	s7,s2
      state = 0;
 786:	4981                	li	s3,0
 788:	b751                	j	70c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 78a:	008b8913          	add	s2,s7,8
 78e:	4681                	li	a3,0
 790:	4641                	li	a2,16
 792:	000ba583          	lw	a1,0(s7)
 796:	8556                	mv	a0,s5
 798:	00000097          	auipc	ra,0x0
 79c:	e86080e7          	jalr	-378(ra) # 61e <printint>
 7a0:	8bca                	mv	s7,s2
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	b7a5                	j	70c <vprintf+0x42>
 7a6:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7a8:	008b8c13          	add	s8,s7,8
 7ac:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7b0:	03000593          	li	a1,48
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	e46080e7          	jalr	-442(ra) # 5fc <putc>
  putc(fd, 'x');
 7be:	07800593          	li	a1,120
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	e38080e7          	jalr	-456(ra) # 5fc <putc>
 7cc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ce:	00000b97          	auipc	s7,0x0
 7d2:	39ab8b93          	add	s7,s7,922 # b68 <digits>
 7d6:	03c9d793          	srl	a5,s3,0x3c
 7da:	97de                	add	a5,a5,s7
 7dc:	0007c583          	lbu	a1,0(a5)
 7e0:	8556                	mv	a0,s5
 7e2:	00000097          	auipc	ra,0x0
 7e6:	e1a080e7          	jalr	-486(ra) # 5fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ea:	0992                	sll	s3,s3,0x4
 7ec:	397d                	addw	s2,s2,-1
 7ee:	fe0914e3          	bnez	s2,7d6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7f2:	8be2                	mv	s7,s8
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	6c02                	ld	s8,0(sp)
 7f8:	bf11                	j	70c <vprintf+0x42>
        s = va_arg(ap, char*);
 7fa:	008b8993          	add	s3,s7,8
 7fe:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 802:	02090163          	beqz	s2,824 <vprintf+0x15a>
        while(*s != 0){
 806:	00094583          	lbu	a1,0(s2)
 80a:	c9a5                	beqz	a1,87a <vprintf+0x1b0>
          putc(fd, *s);
 80c:	8556                	mv	a0,s5
 80e:	00000097          	auipc	ra,0x0
 812:	dee080e7          	jalr	-530(ra) # 5fc <putc>
          s++;
 816:	0905                	add	s2,s2,1
        while(*s != 0){
 818:	00094583          	lbu	a1,0(s2)
 81c:	f9e5                	bnez	a1,80c <vprintf+0x142>
        s = va_arg(ap, char*);
 81e:	8bce                	mv	s7,s3
      state = 0;
 820:	4981                	li	s3,0
 822:	b5ed                	j	70c <vprintf+0x42>
          s = "(null)";
 824:	00000917          	auipc	s2,0x0
 828:	2e490913          	add	s2,s2,740 # b08 <malloc+0x18c>
        while(*s != 0){
 82c:	02800593          	li	a1,40
 830:	bff1                	j	80c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 832:	008b8913          	add	s2,s7,8
 836:	000bc583          	lbu	a1,0(s7)
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	dc0080e7          	jalr	-576(ra) # 5fc <putc>
 844:	8bca                	mv	s7,s2
      state = 0;
 846:	4981                	li	s3,0
 848:	b5d1                	j	70c <vprintf+0x42>
        putc(fd, c);
 84a:	02500593          	li	a1,37
 84e:	8556                	mv	a0,s5
 850:	00000097          	auipc	ra,0x0
 854:	dac080e7          	jalr	-596(ra) # 5fc <putc>
      state = 0;
 858:	4981                	li	s3,0
 85a:	bd4d                	j	70c <vprintf+0x42>
        putc(fd, '%');
 85c:	02500593          	li	a1,37
 860:	8556                	mv	a0,s5
 862:	00000097          	auipc	ra,0x0
 866:	d9a080e7          	jalr	-614(ra) # 5fc <putc>
        putc(fd, c);
 86a:	85ca                	mv	a1,s2
 86c:	8556                	mv	a0,s5
 86e:	00000097          	auipc	ra,0x0
 872:	d8e080e7          	jalr	-626(ra) # 5fc <putc>
      state = 0;
 876:	4981                	li	s3,0
 878:	bd51                	j	70c <vprintf+0x42>
        s = va_arg(ap, char*);
 87a:	8bce                	mv	s7,s3
      state = 0;
 87c:	4981                	li	s3,0
 87e:	b579                	j	70c <vprintf+0x42>
 880:	74e2                	ld	s1,56(sp)
 882:	79a2                	ld	s3,40(sp)
 884:	7a02                	ld	s4,32(sp)
 886:	6ae2                	ld	s5,24(sp)
 888:	6b42                	ld	s6,16(sp)
 88a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 88c:	60a6                	ld	ra,72(sp)
 88e:	6406                	ld	s0,64(sp)
 890:	7942                	ld	s2,48(sp)
 892:	6161                	add	sp,sp,80
 894:	8082                	ret

0000000000000896 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 896:	715d                	add	sp,sp,-80
 898:	ec06                	sd	ra,24(sp)
 89a:	e822                	sd	s0,16(sp)
 89c:	1000                	add	s0,sp,32
 89e:	e010                	sd	a2,0(s0)
 8a0:	e414                	sd	a3,8(s0)
 8a2:	e818                	sd	a4,16(s0)
 8a4:	ec1c                	sd	a5,24(s0)
 8a6:	03043023          	sd	a6,32(s0)
 8aa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ae:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b2:	8622                	mv	a2,s0
 8b4:	00000097          	auipc	ra,0x0
 8b8:	e16080e7          	jalr	-490(ra) # 6ca <vprintf>
}
 8bc:	60e2                	ld	ra,24(sp)
 8be:	6442                	ld	s0,16(sp)
 8c0:	6161                	add	sp,sp,80
 8c2:	8082                	ret

00000000000008c4 <printf>:

void
printf(const char *fmt, ...)
{
 8c4:	711d                	add	sp,sp,-96
 8c6:	ec06                	sd	ra,24(sp)
 8c8:	e822                	sd	s0,16(sp)
 8ca:	1000                	add	s0,sp,32
 8cc:	e40c                	sd	a1,8(s0)
 8ce:	e810                	sd	a2,16(s0)
 8d0:	ec14                	sd	a3,24(s0)
 8d2:	f018                	sd	a4,32(s0)
 8d4:	f41c                	sd	a5,40(s0)
 8d6:	03043823          	sd	a6,48(s0)
 8da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8de:	00840613          	add	a2,s0,8
 8e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e6:	85aa                	mv	a1,a0
 8e8:	4505                	li	a0,1
 8ea:	00000097          	auipc	ra,0x0
 8ee:	de0080e7          	jalr	-544(ra) # 6ca <vprintf>
}
 8f2:	60e2                	ld	ra,24(sp)
 8f4:	6442                	ld	s0,16(sp)
 8f6:	6125                	add	sp,sp,96
 8f8:	8082                	ret

00000000000008fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fa:	1141                	add	sp,sp,-16
 8fc:	e422                	sd	s0,8(sp)
 8fe:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 900:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 904:	00000797          	auipc	a5,0x0
 908:	27c7b783          	ld	a5,636(a5) # b80 <freep>
 90c:	a02d                	j	936 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 90e:	4618                	lw	a4,8(a2)
 910:	9f2d                	addw	a4,a4,a1
 912:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 916:	6398                	ld	a4,0(a5)
 918:	6310                	ld	a2,0(a4)
 91a:	a83d                	j	958 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 91c:	ff852703          	lw	a4,-8(a0)
 920:	9f31                	addw	a4,a4,a2
 922:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 924:	ff053683          	ld	a3,-16(a0)
 928:	a091                	j	96c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92a:	6398                	ld	a4,0(a5)
 92c:	00e7e463          	bltu	a5,a4,934 <free+0x3a>
 930:	00e6ea63          	bltu	a3,a4,944 <free+0x4a>
{
 934:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 936:	fed7fae3          	bgeu	a5,a3,92a <free+0x30>
 93a:	6398                	ld	a4,0(a5)
 93c:	00e6e463          	bltu	a3,a4,944 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 940:	fee7eae3          	bltu	a5,a4,934 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 944:	ff852583          	lw	a1,-8(a0)
 948:	6390                	ld	a2,0(a5)
 94a:	02059813          	sll	a6,a1,0x20
 94e:	01c85713          	srl	a4,a6,0x1c
 952:	9736                	add	a4,a4,a3
 954:	fae60de3          	beq	a2,a4,90e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 958:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 95c:	4790                	lw	a2,8(a5)
 95e:	02061593          	sll	a1,a2,0x20
 962:	01c5d713          	srl	a4,a1,0x1c
 966:	973e                	add	a4,a4,a5
 968:	fae68ae3          	beq	a3,a4,91c <free+0x22>
    p->s.ptr = bp->s.ptr;
 96c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 96e:	00000717          	auipc	a4,0x0
 972:	20f73923          	sd	a5,530(a4) # b80 <freep>
}
 976:	6422                	ld	s0,8(sp)
 978:	0141                	add	sp,sp,16
 97a:	8082                	ret

000000000000097c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 97c:	7139                	add	sp,sp,-64
 97e:	fc06                	sd	ra,56(sp)
 980:	f822                	sd	s0,48(sp)
 982:	f426                	sd	s1,40(sp)
 984:	ec4e                	sd	s3,24(sp)
 986:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 988:	02051493          	sll	s1,a0,0x20
 98c:	9081                	srl	s1,s1,0x20
 98e:	04bd                	add	s1,s1,15
 990:	8091                	srl	s1,s1,0x4
 992:	0014899b          	addw	s3,s1,1
 996:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 998:	00000517          	auipc	a0,0x0
 99c:	1e853503          	ld	a0,488(a0) # b80 <freep>
 9a0:	c915                	beqz	a0,9d4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a4:	4798                	lw	a4,8(a5)
 9a6:	08977e63          	bgeu	a4,s1,a42 <malloc+0xc6>
 9aa:	f04a                	sd	s2,32(sp)
 9ac:	e852                	sd	s4,16(sp)
 9ae:	e456                	sd	s5,8(sp)
 9b0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9b2:	8a4e                	mv	s4,s3
 9b4:	0009871b          	sext.w	a4,s3
 9b8:	6685                	lui	a3,0x1
 9ba:	00d77363          	bgeu	a4,a3,9c0 <malloc+0x44>
 9be:	6a05                	lui	s4,0x1
 9c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9c4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9c8:	00000917          	auipc	s2,0x0
 9cc:	1b890913          	add	s2,s2,440 # b80 <freep>
  if(p == (char*)-1)
 9d0:	5afd                	li	s5,-1
 9d2:	a091                	j	a16 <malloc+0x9a>
 9d4:	f04a                	sd	s2,32(sp)
 9d6:	e852                	sd	s4,16(sp)
 9d8:	e456                	sd	s5,8(sp)
 9da:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9dc:	00000797          	auipc	a5,0x0
 9e0:	1bc78793          	add	a5,a5,444 # b98 <base>
 9e4:	00000717          	auipc	a4,0x0
 9e8:	18f73e23          	sd	a5,412(a4) # b80 <freep>
 9ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9f2:	b7c1                	j	9b2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9f4:	6398                	ld	a4,0(a5)
 9f6:	e118                	sd	a4,0(a0)
 9f8:	a08d                	j	a5a <malloc+0xde>
  hp->s.size = nu;
 9fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9fe:	0541                	add	a0,a0,16
 a00:	00000097          	auipc	ra,0x0
 a04:	efa080e7          	jalr	-262(ra) # 8fa <free>
  return freep;
 a08:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a0c:	c13d                	beqz	a0,a72 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a10:	4798                	lw	a4,8(a5)
 a12:	02977463          	bgeu	a4,s1,a3a <malloc+0xbe>
    if(p == freep)
 a16:	00093703          	ld	a4,0(s2)
 a1a:	853e                	mv	a0,a5
 a1c:	fef719e3          	bne	a4,a5,a0e <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a20:	8552                	mv	a0,s4
 a22:	00000097          	auipc	ra,0x0
 a26:	bb2080e7          	jalr	-1102(ra) # 5d4 <sbrk>
  if(p == (char*)-1)
 a2a:	fd5518e3          	bne	a0,s5,9fa <malloc+0x7e>
        return 0;
 a2e:	4501                	li	a0,0
 a30:	7902                	ld	s2,32(sp)
 a32:	6a42                	ld	s4,16(sp)
 a34:	6aa2                	ld	s5,8(sp)
 a36:	6b02                	ld	s6,0(sp)
 a38:	a03d                	j	a66 <malloc+0xea>
 a3a:	7902                	ld	s2,32(sp)
 a3c:	6a42                	ld	s4,16(sp)
 a3e:	6aa2                	ld	s5,8(sp)
 a40:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a42:	fae489e3          	beq	s1,a4,9f4 <malloc+0x78>
        p->s.size -= nunits;
 a46:	4137073b          	subw	a4,a4,s3
 a4a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a4c:	02071693          	sll	a3,a4,0x20
 a50:	01c6d713          	srl	a4,a3,0x1c
 a54:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a56:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a5a:	00000717          	auipc	a4,0x0
 a5e:	12a73323          	sd	a0,294(a4) # b80 <freep>
      return (void*)(p + 1);
 a62:	01078513          	add	a0,a5,16
  }
}
 a66:	70e2                	ld	ra,56(sp)
 a68:	7442                	ld	s0,48(sp)
 a6a:	74a2                	ld	s1,40(sp)
 a6c:	69e2                	ld	s3,24(sp)
 a6e:	6121                	add	sp,sp,64
 a70:	8082                	ret
 a72:	7902                	ld	s2,32(sp)
 a74:	6a42                	ld	s4,16(sp)
 a76:	6aa2                	ld	s5,8(sp)
 a78:	6b02                	ld	s6,0(sp)
 a7a:	b7f5                	j	a66 <malloc+0xea>
