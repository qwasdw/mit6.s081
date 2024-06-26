
user/_pgtbltest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:
}

char *testname = "???";

void err(char *why)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
   c:	84aa                	mv	s1,a0
    printf("pgtbltest: %s failed: %s, pid=%d\n", testname, why, getpid());
   e:	00001917          	auipc	s2,0x1
  12:	b3293903          	ld	s2,-1230(s2) # b40 <testname>
  16:	00000097          	auipc	ra,0x0
  1a:	4f0080e7          	jalr	1264(ra) # 506 <getpid>
  1e:	86aa                	mv	a3,a0
  20:	8626                	mv	a2,s1
  22:	85ca                	mv	a1,s2
  24:	00001517          	auipc	a0,0x1
  28:	99450513          	add	a0,a0,-1644 # 9b8 <malloc+0x102>
  2c:	00000097          	auipc	ra,0x0
  30:	7d2080e7          	jalr	2002(ra) # 7fe <printf>
    exit(1);
  34:	4505                	li	a0,1
  36:	00000097          	auipc	ra,0x0
  3a:	450080e7          	jalr	1104(ra) # 486 <exit>

000000000000003e <ugetpid_test>:
}

void ugetpid_test()
{
  3e:	7179                	add	sp,sp,-48
  40:	f406                	sd	ra,40(sp)
  42:	f022                	sd	s0,32(sp)
  44:	ec26                	sd	s1,24(sp)
  46:	1800                	add	s0,sp,48
    int i;

    printf("ugetpid_test starting\n");
  48:	00001517          	auipc	a0,0x1
  4c:	99850513          	add	a0,a0,-1640 # 9e0 <malloc+0x12a>
  50:	00000097          	auipc	ra,0x0
  54:	7ae080e7          	jalr	1966(ra) # 7fe <printf>
    testname = "ugetpid_test";
  58:	00001797          	auipc	a5,0x1
  5c:	9a078793          	add	a5,a5,-1632 # 9f8 <malloc+0x142>
  60:	00001717          	auipc	a4,0x1
  64:	aef73023          	sd	a5,-1312(a4) # b40 <testname>
  68:	04000493          	li	s1,64

    for (i = 0; i < 64; i++)
    {
        int ret = fork();
  6c:	00000097          	auipc	ra,0x0
  70:	412080e7          	jalr	1042(ra) # 47e <fork>
  74:	fca42e23          	sw	a0,-36(s0)
        if (ret != 0)
  78:	cd15                	beqz	a0,b4 <ugetpid_test+0x76>
        {
            wait(&ret);
  7a:	fdc40513          	add	a0,s0,-36
  7e:	00000097          	auipc	ra,0x0
  82:	410080e7          	jalr	1040(ra) # 48e <wait>
            if (ret != 0)
  86:	fdc42783          	lw	a5,-36(s0)
  8a:	e385                	bnez	a5,aa <ugetpid_test+0x6c>
    for (i = 0; i < 64; i++)
  8c:	34fd                	addw	s1,s1,-1
  8e:	fcf9                	bnez	s1,6c <ugetpid_test+0x2e>
        }
        if (getpid() != ugetpid())
            err("missmatched PID");
        exit(0);
    }
    printf("ugetpid_test: OK\n");
  90:	00001517          	auipc	a0,0x1
  94:	98850513          	add	a0,a0,-1656 # a18 <malloc+0x162>
  98:	00000097          	auipc	ra,0x0
  9c:	766080e7          	jalr	1894(ra) # 7fe <printf>
}
  a0:	70a2                	ld	ra,40(sp)
  a2:	7402                	ld	s0,32(sp)
  a4:	64e2                	ld	s1,24(sp)
  a6:	6145                	add	sp,sp,48
  a8:	8082                	ret
                exit(1);
  aa:	4505                	li	a0,1
  ac:	00000097          	auipc	ra,0x0
  b0:	3da080e7          	jalr	986(ra) # 486 <exit>
        if (getpid() != ugetpid())
  b4:	00000097          	auipc	ra,0x0
  b8:	452080e7          	jalr	1106(ra) # 506 <getpid>
  bc:	84aa                	mv	s1,a0
  be:	00000097          	auipc	ra,0x0
  c2:	3aa080e7          	jalr	938(ra) # 468 <ugetpid>
  c6:	00a48a63          	beq	s1,a0,da <ugetpid_test+0x9c>
            err("missmatched PID");
  ca:	00001517          	auipc	a0,0x1
  ce:	93e50513          	add	a0,a0,-1730 # a08 <malloc+0x152>
  d2:	00000097          	auipc	ra,0x0
  d6:	f2e080e7          	jalr	-210(ra) # 0 <err>
        exit(0);
  da:	4501                	li	a0,0
  dc:	00000097          	auipc	ra,0x0
  e0:	3aa080e7          	jalr	938(ra) # 486 <exit>

00000000000000e4 <pgaccess_test>:

void pgaccess_test()
{
  e4:	7179                	add	sp,sp,-48
  e6:	f406                	sd	ra,40(sp)
  e8:	f022                	sd	s0,32(sp)
  ea:	ec26                	sd	s1,24(sp)
  ec:	1800                	add	s0,sp,48
    char *buf;
    unsigned int abits;
    printf("pgaccess_test starting\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	94250513          	add	a0,a0,-1726 # a30 <malloc+0x17a>
  f6:	00000097          	auipc	ra,0x0
  fa:	708080e7          	jalr	1800(ra) # 7fe <printf>
    testname = "pgaccess_test";
  fe:	00001797          	auipc	a5,0x1
 102:	94a78793          	add	a5,a5,-1718 # a48 <malloc+0x192>
 106:	00001717          	auipc	a4,0x1
 10a:	a2f73d23          	sd	a5,-1478(a4) # b40 <testname>
    buf = malloc(32 * PGSIZE);
 10e:	00020537          	lui	a0,0x20
 112:	00000097          	auipc	ra,0x0
 116:	7a4080e7          	jalr	1956(ra) # 8b6 <malloc>
 11a:	84aa                	mv	s1,a0
    if (pgaccess(buf, 32, &abits) < 0)
 11c:	fdc40613          	add	a2,s0,-36
 120:	02000593          	li	a1,32
 124:	00000097          	auipc	ra,0x0
 128:	40a080e7          	jalr	1034(ra) # 52e <pgaccess>
 12c:	06054b63          	bltz	a0,1a2 <pgaccess_test+0xbe>
        err("pgaccess failed");
    buf[PGSIZE * 1] += 1;
 130:	6785                	lui	a5,0x1
 132:	97a6                	add	a5,a5,s1
 134:	0007c703          	lbu	a4,0(a5) # 1000 <__BSS_END__+0x4a0>
 138:	2705                	addw	a4,a4,1
 13a:	00e78023          	sb	a4,0(a5)
    buf[PGSIZE * 2] += 1;
 13e:	6789                	lui	a5,0x2
 140:	97a6                	add	a5,a5,s1
 142:	0007c703          	lbu	a4,0(a5) # 2000 <__global_pointer$+0xcc7>
 146:	2705                	addw	a4,a4,1
 148:	00e78023          	sb	a4,0(a5)
    buf[PGSIZE * 30] += 1;
 14c:	67f9                	lui	a5,0x1e
 14e:	97a6                	add	a5,a5,s1
 150:	0007c703          	lbu	a4,0(a5) # 1e000 <__global_pointer$+0x1ccc7>
 154:	2705                	addw	a4,a4,1
 156:	00e78023          	sb	a4,0(a5)
    if (pgaccess(buf, 32, &abits) < 0)
 15a:	fdc40613          	add	a2,s0,-36
 15e:	02000593          	li	a1,32
 162:	8526                	mv	a0,s1
 164:	00000097          	auipc	ra,0x0
 168:	3ca080e7          	jalr	970(ra) # 52e <pgaccess>
 16c:	04054363          	bltz	a0,1b2 <pgaccess_test+0xce>
        err("pgaccess failed");
    if (abits != ((1 << 1) | (1 << 2) | (1 << 30)))
 170:	fdc42703          	lw	a4,-36(s0)
 174:	400007b7          	lui	a5,0x40000
 178:	0799                	add	a5,a5,6 # 40000006 <__global_pointer$+0x3fffeccd>
 17a:	04f71463          	bne	a4,a5,1c2 <pgaccess_test+0xde>
        // printf("incorrect access bits set, abits=%d\n", abits);
        err("incorrect access bits set");
    free(buf);
 17e:	8526                	mv	a0,s1
 180:	00000097          	auipc	ra,0x0
 184:	6b4080e7          	jalr	1716(ra) # 834 <free>
    printf("pgaccess_test: OK\n");
 188:	00001517          	auipc	a0,0x1
 18c:	90050513          	add	a0,a0,-1792 # a88 <malloc+0x1d2>
 190:	00000097          	auipc	ra,0x0
 194:	66e080e7          	jalr	1646(ra) # 7fe <printf>
}
 198:	70a2                	ld	ra,40(sp)
 19a:	7402                	ld	s0,32(sp)
 19c:	64e2                	ld	s1,24(sp)
 19e:	6145                	add	sp,sp,48
 1a0:	8082                	ret
        err("pgaccess failed");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	8b650513          	add	a0,a0,-1866 # a58 <malloc+0x1a2>
 1aa:	00000097          	auipc	ra,0x0
 1ae:	e56080e7          	jalr	-426(ra) # 0 <err>
        err("pgaccess failed");
 1b2:	00001517          	auipc	a0,0x1
 1b6:	8a650513          	add	a0,a0,-1882 # a58 <malloc+0x1a2>
 1ba:	00000097          	auipc	ra,0x0
 1be:	e46080e7          	jalr	-442(ra) # 0 <err>
        err("incorrect access bits set");
 1c2:	00001517          	auipc	a0,0x1
 1c6:	8a650513          	add	a0,a0,-1882 # a68 <malloc+0x1b2>
 1ca:	00000097          	auipc	ra,0x0
 1ce:	e36080e7          	jalr	-458(ra) # 0 <err>

00000000000001d2 <main>:
{
 1d2:	1141                	add	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	add	s0,sp,16
    ugetpid_test();
 1da:	00000097          	auipc	ra,0x0
 1de:	e64080e7          	jalr	-412(ra) # 3e <ugetpid_test>
    pgaccess_test();
 1e2:	00000097          	auipc	ra,0x0
 1e6:	f02080e7          	jalr	-254(ra) # e4 <pgaccess_test>
    printf("pgtbltest: all tests succeeded\n");
 1ea:	00001517          	auipc	a0,0x1
 1ee:	8b650513          	add	a0,a0,-1866 # aa0 <malloc+0x1ea>
 1f2:	00000097          	auipc	ra,0x0
 1f6:	60c080e7          	jalr	1548(ra) # 7fe <printf>
    exit(0);
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	28a080e7          	jalr	650(ra) # 486 <exit>

0000000000000204 <strcpy>:



char*
strcpy(char *s, const char *t)
{
 204:	1141                	add	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 20a:	87aa                	mv	a5,a0
 20c:	0585                	add	a1,a1,1
 20e:	0785                	add	a5,a5,1
 210:	fff5c703          	lbu	a4,-1(a1)
 214:	fee78fa3          	sb	a4,-1(a5)
 218:	fb75                	bnez	a4,20c <strcpy+0x8>
    ;
  return os;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	add	sp,sp,16
 21e:	8082                	ret

0000000000000220 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 220:	1141                	add	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 226:	00054783          	lbu	a5,0(a0)
 22a:	cb91                	beqz	a5,23e <strcmp+0x1e>
 22c:	0005c703          	lbu	a4,0(a1)
 230:	00f71763          	bne	a4,a5,23e <strcmp+0x1e>
    p++, q++;
 234:	0505                	add	a0,a0,1
 236:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 238:	00054783          	lbu	a5,0(a0)
 23c:	fbe5                	bnez	a5,22c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 23e:	0005c503          	lbu	a0,0(a1)
}
 242:	40a7853b          	subw	a0,a5,a0
 246:	6422                	ld	s0,8(sp)
 248:	0141                	add	sp,sp,16
 24a:	8082                	ret

000000000000024c <strlen>:

uint
strlen(const char *s)
{
 24c:	1141                	add	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 252:	00054783          	lbu	a5,0(a0)
 256:	cf91                	beqz	a5,272 <strlen+0x26>
 258:	0505                	add	a0,a0,1
 25a:	87aa                	mv	a5,a0
 25c:	86be                	mv	a3,a5
 25e:	0785                	add	a5,a5,1
 260:	fff7c703          	lbu	a4,-1(a5)
 264:	ff65                	bnez	a4,25c <strlen+0x10>
 266:	40a6853b          	subw	a0,a3,a0
 26a:	2505                	addw	a0,a0,1
    ;
  return n;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	add	sp,sp,16
 270:	8082                	ret
  for(n = 0; s[n]; n++)
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <strlen+0x20>

0000000000000276 <memset>:

void*
memset(void *dst, int c, uint n)
{
 276:	1141                	add	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 27c:	ca19                	beqz	a2,292 <memset+0x1c>
 27e:	87aa                	mv	a5,a0
 280:	1602                	sll	a2,a2,0x20
 282:	9201                	srl	a2,a2,0x20
 284:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 288:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 28c:	0785                	add	a5,a5,1
 28e:	fee79de3          	bne	a5,a4,288 <memset+0x12>
  }
  return dst;
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	add	sp,sp,16
 296:	8082                	ret

0000000000000298 <strchr>:

char*
strchr(const char *s, char c)
{
 298:	1141                	add	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	add	s0,sp,16
  for(; *s; s++)
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	cb99                	beqz	a5,2b8 <strchr+0x20>
    if(*s == c)
 2a4:	00f58763          	beq	a1,a5,2b2 <strchr+0x1a>
  for(; *s; s++)
 2a8:	0505                	add	a0,a0,1
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	fbfd                	bnez	a5,2a4 <strchr+0xc>
      return (char*)s;
  return 0;
 2b0:	4501                	li	a0,0
}
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	add	sp,sp,16
 2b6:	8082                	ret
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	bfe5                	j	2b2 <strchr+0x1a>

00000000000002bc <gets>:

char*
gets(char *buf, int max)
{
 2bc:	711d                	add	sp,sp,-96
 2be:	ec86                	sd	ra,88(sp)
 2c0:	e8a2                	sd	s0,80(sp)
 2c2:	e4a6                	sd	s1,72(sp)
 2c4:	e0ca                	sd	s2,64(sp)
 2c6:	fc4e                	sd	s3,56(sp)
 2c8:	f852                	sd	s4,48(sp)
 2ca:	f456                	sd	s5,40(sp)
 2cc:	f05a                	sd	s6,32(sp)
 2ce:	ec5e                	sd	s7,24(sp)
 2d0:	1080                	add	s0,sp,96
 2d2:	8baa                	mv	s7,a0
 2d4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d6:	892a                	mv	s2,a0
 2d8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2da:	4aa9                	li	s5,10
 2dc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2de:	89a6                	mv	s3,s1
 2e0:	2485                	addw	s1,s1,1
 2e2:	0344d863          	bge	s1,s4,312 <gets+0x56>
    cc = read(0, &c, 1);
 2e6:	4605                	li	a2,1
 2e8:	faf40593          	add	a1,s0,-81
 2ec:	4501                	li	a0,0
 2ee:	00000097          	auipc	ra,0x0
 2f2:	1b0080e7          	jalr	432(ra) # 49e <read>
    if(cc < 1)
 2f6:	00a05e63          	blez	a0,312 <gets+0x56>
    buf[i++] = c;
 2fa:	faf44783          	lbu	a5,-81(s0)
 2fe:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 302:	01578763          	beq	a5,s5,310 <gets+0x54>
 306:	0905                	add	s2,s2,1
 308:	fd679be3          	bne	a5,s6,2de <gets+0x22>
    buf[i++] = c;
 30c:	89a6                	mv	s3,s1
 30e:	a011                	j	312 <gets+0x56>
 310:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 312:	99de                	add	s3,s3,s7
 314:	00098023          	sb	zero,0(s3)
  return buf;
}
 318:	855e                	mv	a0,s7
 31a:	60e6                	ld	ra,88(sp)
 31c:	6446                	ld	s0,80(sp)
 31e:	64a6                	ld	s1,72(sp)
 320:	6906                	ld	s2,64(sp)
 322:	79e2                	ld	s3,56(sp)
 324:	7a42                	ld	s4,48(sp)
 326:	7aa2                	ld	s5,40(sp)
 328:	7b02                	ld	s6,32(sp)
 32a:	6be2                	ld	s7,24(sp)
 32c:	6125                	add	sp,sp,96
 32e:	8082                	ret

0000000000000330 <stat>:

int
stat(const char *n, struct stat *st)
{
 330:	1101                	add	sp,sp,-32
 332:	ec06                	sd	ra,24(sp)
 334:	e822                	sd	s0,16(sp)
 336:	e04a                	sd	s2,0(sp)
 338:	1000                	add	s0,sp,32
 33a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33c:	4581                	li	a1,0
 33e:	00000097          	auipc	ra,0x0
 342:	188080e7          	jalr	392(ra) # 4c6 <open>
  if(fd < 0)
 346:	02054663          	bltz	a0,372 <stat+0x42>
 34a:	e426                	sd	s1,8(sp)
 34c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 34e:	85ca                	mv	a1,s2
 350:	00000097          	auipc	ra,0x0
 354:	18e080e7          	jalr	398(ra) # 4de <fstat>
 358:	892a                	mv	s2,a0
  close(fd);
 35a:	8526                	mv	a0,s1
 35c:	00000097          	auipc	ra,0x0
 360:	152080e7          	jalr	338(ra) # 4ae <close>
  return r;
 364:	64a2                	ld	s1,8(sp)
}
 366:	854a                	mv	a0,s2
 368:	60e2                	ld	ra,24(sp)
 36a:	6442                	ld	s0,16(sp)
 36c:	6902                	ld	s2,0(sp)
 36e:	6105                	add	sp,sp,32
 370:	8082                	ret
    return -1;
 372:	597d                	li	s2,-1
 374:	bfcd                	j	366 <stat+0x36>

0000000000000376 <atoi>:

int
atoi(const char *s)
{
 376:	1141                	add	sp,sp,-16
 378:	e422                	sd	s0,8(sp)
 37a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 37c:	00054683          	lbu	a3,0(a0)
 380:	fd06879b          	addw	a5,a3,-48
 384:	0ff7f793          	zext.b	a5,a5
 388:	4625                	li	a2,9
 38a:	02f66863          	bltu	a2,a5,3ba <atoi+0x44>
 38e:	872a                	mv	a4,a0
  n = 0;
 390:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 392:	0705                	add	a4,a4,1
 394:	0025179b          	sllw	a5,a0,0x2
 398:	9fa9                	addw	a5,a5,a0
 39a:	0017979b          	sllw	a5,a5,0x1
 39e:	9fb5                	addw	a5,a5,a3
 3a0:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3a4:	00074683          	lbu	a3,0(a4)
 3a8:	fd06879b          	addw	a5,a3,-48
 3ac:	0ff7f793          	zext.b	a5,a5
 3b0:	fef671e3          	bgeu	a2,a5,392 <atoi+0x1c>
  return n;
}
 3b4:	6422                	ld	s0,8(sp)
 3b6:	0141                	add	sp,sp,16
 3b8:	8082                	ret
  n = 0;
 3ba:	4501                	li	a0,0
 3bc:	bfe5                	j	3b4 <atoi+0x3e>

00000000000003be <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3be:	1141                	add	sp,sp,-16
 3c0:	e422                	sd	s0,8(sp)
 3c2:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c4:	02b57463          	bgeu	a0,a1,3ec <memmove+0x2e>
    while(n-- > 0)
 3c8:	00c05f63          	blez	a2,3e6 <memmove+0x28>
 3cc:	1602                	sll	a2,a2,0x20
 3ce:	9201                	srl	a2,a2,0x20
 3d0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d4:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d6:	0585                	add	a1,a1,1
 3d8:	0705                	add	a4,a4,1
 3da:	fff5c683          	lbu	a3,-1(a1)
 3de:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3e2:	fef71ae3          	bne	a4,a5,3d6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	add	sp,sp,16
 3ea:	8082                	ret
    dst += n;
 3ec:	00c50733          	add	a4,a0,a2
    src += n;
 3f0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3f2:	fec05ae3          	blez	a2,3e6 <memmove+0x28>
 3f6:	fff6079b          	addw	a5,a2,-1
 3fa:	1782                	sll	a5,a5,0x20
 3fc:	9381                	srl	a5,a5,0x20
 3fe:	fff7c793          	not	a5,a5
 402:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 404:	15fd                	add	a1,a1,-1
 406:	177d                	add	a4,a4,-1
 408:	0005c683          	lbu	a3,0(a1)
 40c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 410:	fee79ae3          	bne	a5,a4,404 <memmove+0x46>
 414:	bfc9                	j	3e6 <memmove+0x28>

0000000000000416 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 416:	1141                	add	sp,sp,-16
 418:	e422                	sd	s0,8(sp)
 41a:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 41c:	ca05                	beqz	a2,44c <memcmp+0x36>
 41e:	fff6069b          	addw	a3,a2,-1
 422:	1682                	sll	a3,a3,0x20
 424:	9281                	srl	a3,a3,0x20
 426:	0685                	add	a3,a3,1
 428:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 42a:	00054783          	lbu	a5,0(a0)
 42e:	0005c703          	lbu	a4,0(a1)
 432:	00e79863          	bne	a5,a4,442 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 436:	0505                	add	a0,a0,1
    p2++;
 438:	0585                	add	a1,a1,1
  while (n-- > 0) {
 43a:	fed518e3          	bne	a0,a3,42a <memcmp+0x14>
  }
  return 0;
 43e:	4501                	li	a0,0
 440:	a019                	j	446 <memcmp+0x30>
      return *p1 - *p2;
 442:	40e7853b          	subw	a0,a5,a4
}
 446:	6422                	ld	s0,8(sp)
 448:	0141                	add	sp,sp,16
 44a:	8082                	ret
  return 0;
 44c:	4501                	li	a0,0
 44e:	bfe5                	j	446 <memcmp+0x30>

0000000000000450 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 450:	1141                	add	sp,sp,-16
 452:	e406                	sd	ra,8(sp)
 454:	e022                	sd	s0,0(sp)
 456:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 458:	00000097          	auipc	ra,0x0
 45c:	f66080e7          	jalr	-154(ra) # 3be <memmove>
}
 460:	60a2                	ld	ra,8(sp)
 462:	6402                	ld	s0,0(sp)
 464:	0141                	add	sp,sp,16
 466:	8082                	ret

0000000000000468 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 468:	1141                	add	sp,sp,-16
 46a:	e422                	sd	s0,8(sp)
 46c:	0800                	add	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 46e:	040007b7          	lui	a5,0x4000
 472:	17f5                	add	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffecc4>
 474:	07b2                	sll	a5,a5,0xc
}
 476:	4388                	lw	a0,0(a5)
 478:	6422                	ld	s0,8(sp)
 47a:	0141                	add	sp,sp,16
 47c:	8082                	ret

000000000000047e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 47e:	4885                	li	a7,1
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <exit>:
.global exit
exit:
 li a7, SYS_exit
 486:	4889                	li	a7,2
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <wait>:
.global wait
wait:
 li a7, SYS_wait
 48e:	488d                	li	a7,3
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 496:	4891                	li	a7,4
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <read>:
.global read
read:
 li a7, SYS_read
 49e:	4895                	li	a7,5
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <write>:
.global write
write:
 li a7, SYS_write
 4a6:	48c1                	li	a7,16
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <close>:
.global close
close:
 li a7, SYS_close
 4ae:	48d5                	li	a7,21
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b6:	4899                	li	a7,6
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <exec>:
.global exec
exec:
 li a7, SYS_exec
 4be:	489d                	li	a7,7
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <open>:
.global open
open:
 li a7, SYS_open
 4c6:	48bd                	li	a7,15
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4ce:	48c5                	li	a7,17
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d6:	48c9                	li	a7,18
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4de:	48a1                	li	a7,8
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <link>:
.global link
link:
 li a7, SYS_link
 4e6:	48cd                	li	a7,19
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ee:	48d1                	li	a7,20
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f6:	48a5                	li	a7,9
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <dup>:
.global dup
dup:
 li a7, SYS_dup
 4fe:	48a9                	li	a7,10
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 506:	48ad                	li	a7,11
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 50e:	48b1                	li	a7,12
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 516:	48b5                	li	a7,13
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 51e:	48b9                	li	a7,14
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <connect>:
.global connect
connect:
 li a7, SYS_connect
 526:	48f5                	li	a7,29
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 52e:	48f9                	li	a7,30
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 536:	1101                	add	sp,sp,-32
 538:	ec06                	sd	ra,24(sp)
 53a:	e822                	sd	s0,16(sp)
 53c:	1000                	add	s0,sp,32
 53e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 542:	4605                	li	a2,1
 544:	fef40593          	add	a1,s0,-17
 548:	00000097          	auipc	ra,0x0
 54c:	f5e080e7          	jalr	-162(ra) # 4a6 <write>
}
 550:	60e2                	ld	ra,24(sp)
 552:	6442                	ld	s0,16(sp)
 554:	6105                	add	sp,sp,32
 556:	8082                	ret

0000000000000558 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 558:	7139                	add	sp,sp,-64
 55a:	fc06                	sd	ra,56(sp)
 55c:	f822                	sd	s0,48(sp)
 55e:	f426                	sd	s1,40(sp)
 560:	0080                	add	s0,sp,64
 562:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 564:	c299                	beqz	a3,56a <printint+0x12>
 566:	0805cb63          	bltz	a1,5fc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 56a:	2581                	sext.w	a1,a1
  neg = 0;
 56c:	4881                	li	a7,0
 56e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 572:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 574:	2601                	sext.w	a2,a2
 576:	00000517          	auipc	a0,0x0
 57a:	5b250513          	add	a0,a0,1458 # b28 <digits>
 57e:	883a                	mv	a6,a4
 580:	2705                	addw	a4,a4,1
 582:	02c5f7bb          	remuw	a5,a1,a2
 586:	1782                	sll	a5,a5,0x20
 588:	9381                	srl	a5,a5,0x20
 58a:	97aa                	add	a5,a5,a0
 58c:	0007c783          	lbu	a5,0(a5)
 590:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 594:	0005879b          	sext.w	a5,a1
 598:	02c5d5bb          	divuw	a1,a1,a2
 59c:	0685                	add	a3,a3,1
 59e:	fec7f0e3          	bgeu	a5,a2,57e <printint+0x26>
  if(neg)
 5a2:	00088c63          	beqz	a7,5ba <printint+0x62>
    buf[i++] = '-';
 5a6:	fd070793          	add	a5,a4,-48
 5aa:	00878733          	add	a4,a5,s0
 5ae:	02d00793          	li	a5,45
 5b2:	fef70823          	sb	a5,-16(a4)
 5b6:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 5ba:	02e05c63          	blez	a4,5f2 <printint+0x9a>
 5be:	f04a                	sd	s2,32(sp)
 5c0:	ec4e                	sd	s3,24(sp)
 5c2:	fc040793          	add	a5,s0,-64
 5c6:	00e78933          	add	s2,a5,a4
 5ca:	fff78993          	add	s3,a5,-1
 5ce:	99ba                	add	s3,s3,a4
 5d0:	377d                	addw	a4,a4,-1
 5d2:	1702                	sll	a4,a4,0x20
 5d4:	9301                	srl	a4,a4,0x20
 5d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5da:	fff94583          	lbu	a1,-1(s2)
 5de:	8526                	mv	a0,s1
 5e0:	00000097          	auipc	ra,0x0
 5e4:	f56080e7          	jalr	-170(ra) # 536 <putc>
  while(--i >= 0)
 5e8:	197d                	add	s2,s2,-1
 5ea:	ff3918e3          	bne	s2,s3,5da <printint+0x82>
 5ee:	7902                	ld	s2,32(sp)
 5f0:	69e2                	ld	s3,24(sp)
}
 5f2:	70e2                	ld	ra,56(sp)
 5f4:	7442                	ld	s0,48(sp)
 5f6:	74a2                	ld	s1,40(sp)
 5f8:	6121                	add	sp,sp,64
 5fa:	8082                	ret
    x = -xx;
 5fc:	40b005bb          	negw	a1,a1
    neg = 1;
 600:	4885                	li	a7,1
    x = -xx;
 602:	b7b5                	j	56e <printint+0x16>

0000000000000604 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 604:	715d                	add	sp,sp,-80
 606:	e486                	sd	ra,72(sp)
 608:	e0a2                	sd	s0,64(sp)
 60a:	f84a                	sd	s2,48(sp)
 60c:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 60e:	0005c903          	lbu	s2,0(a1)
 612:	1a090a63          	beqz	s2,7c6 <vprintf+0x1c2>
 616:	fc26                	sd	s1,56(sp)
 618:	f44e                	sd	s3,40(sp)
 61a:	f052                	sd	s4,32(sp)
 61c:	ec56                	sd	s5,24(sp)
 61e:	e85a                	sd	s6,16(sp)
 620:	e45e                	sd	s7,8(sp)
 622:	8aaa                	mv	s5,a0
 624:	8bb2                	mv	s7,a2
 626:	00158493          	add	s1,a1,1
  state = 0;
 62a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 62c:	02500a13          	li	s4,37
 630:	4b55                	li	s6,21
 632:	a839                	j	650 <vprintf+0x4c>
        putc(fd, c);
 634:	85ca                	mv	a1,s2
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	efe080e7          	jalr	-258(ra) # 536 <putc>
 640:	a019                	j	646 <vprintf+0x42>
    } else if(state == '%'){
 642:	01498d63          	beq	s3,s4,65c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 646:	0485                	add	s1,s1,1
 648:	fff4c903          	lbu	s2,-1(s1)
 64c:	16090763          	beqz	s2,7ba <vprintf+0x1b6>
    if(state == 0){
 650:	fe0999e3          	bnez	s3,642 <vprintf+0x3e>
      if(c == '%'){
 654:	ff4910e3          	bne	s2,s4,634 <vprintf+0x30>
        state = '%';
 658:	89d2                	mv	s3,s4
 65a:	b7f5                	j	646 <vprintf+0x42>
      if(c == 'd'){
 65c:	13490463          	beq	s2,s4,784 <vprintf+0x180>
 660:	f9d9079b          	addw	a5,s2,-99
 664:	0ff7f793          	zext.b	a5,a5
 668:	12fb6763          	bltu	s6,a5,796 <vprintf+0x192>
 66c:	f9d9079b          	addw	a5,s2,-99
 670:	0ff7f713          	zext.b	a4,a5
 674:	12eb6163          	bltu	s6,a4,796 <vprintf+0x192>
 678:	00271793          	sll	a5,a4,0x2
 67c:	00000717          	auipc	a4,0x0
 680:	45470713          	add	a4,a4,1108 # ad0 <malloc+0x21a>
 684:	97ba                	add	a5,a5,a4
 686:	439c                	lw	a5,0(a5)
 688:	97ba                	add	a5,a5,a4
 68a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 68c:	008b8913          	add	s2,s7,8
 690:	4685                	li	a3,1
 692:	4629                	li	a2,10
 694:	000ba583          	lw	a1,0(s7)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	ebe080e7          	jalr	-322(ra) # 558 <printint>
 6a2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b745                	j	646 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a8:	008b8913          	add	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4629                	li	a2,10
 6b0:	000ba583          	lw	a1,0(s7)
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	ea2080e7          	jalr	-350(ra) # 558 <printint>
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b751                	j	646 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6c4:	008b8913          	add	s2,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4641                	li	a2,16
 6cc:	000ba583          	lw	a1,0(s7)
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	e86080e7          	jalr	-378(ra) # 558 <printint>
 6da:	8bca                	mv	s7,s2
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	b7a5                	j	646 <vprintf+0x42>
 6e0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6e2:	008b8c13          	add	s8,s7,8
 6e6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ea:	03000593          	li	a1,48
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	e46080e7          	jalr	-442(ra) # 536 <putc>
  putc(fd, 'x');
 6f8:	07800593          	li	a1,120
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	e38080e7          	jalr	-456(ra) # 536 <putc>
 706:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 708:	00000b97          	auipc	s7,0x0
 70c:	420b8b93          	add	s7,s7,1056 # b28 <digits>
 710:	03c9d793          	srl	a5,s3,0x3c
 714:	97de                	add	a5,a5,s7
 716:	0007c583          	lbu	a1,0(a5)
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	e1a080e7          	jalr	-486(ra) # 536 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 724:	0992                	sll	s3,s3,0x4
 726:	397d                	addw	s2,s2,-1
 728:	fe0914e3          	bnez	s2,710 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 72c:	8be2                	mv	s7,s8
      state = 0;
 72e:	4981                	li	s3,0
 730:	6c02                	ld	s8,0(sp)
 732:	bf11                	j	646 <vprintf+0x42>
        s = va_arg(ap, char*);
 734:	008b8993          	add	s3,s7,8
 738:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 73c:	02090163          	beqz	s2,75e <vprintf+0x15a>
        while(*s != 0){
 740:	00094583          	lbu	a1,0(s2)
 744:	c9a5                	beqz	a1,7b4 <vprintf+0x1b0>
          putc(fd, *s);
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	dee080e7          	jalr	-530(ra) # 536 <putc>
          s++;
 750:	0905                	add	s2,s2,1
        while(*s != 0){
 752:	00094583          	lbu	a1,0(s2)
 756:	f9e5                	bnez	a1,746 <vprintf+0x142>
        s = va_arg(ap, char*);
 758:	8bce                	mv	s7,s3
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b5ed                	j	646 <vprintf+0x42>
          s = "(null)";
 75e:	00000917          	auipc	s2,0x0
 762:	36a90913          	add	s2,s2,874 # ac8 <malloc+0x212>
        while(*s != 0){
 766:	02800593          	li	a1,40
 76a:	bff1                	j	746 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 76c:	008b8913          	add	s2,s7,8
 770:	000bc583          	lbu	a1,0(s7)
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	dc0080e7          	jalr	-576(ra) # 536 <putc>
 77e:	8bca                	mv	s7,s2
      state = 0;
 780:	4981                	li	s3,0
 782:	b5d1                	j	646 <vprintf+0x42>
        putc(fd, c);
 784:	02500593          	li	a1,37
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	dac080e7          	jalr	-596(ra) # 536 <putc>
      state = 0;
 792:	4981                	li	s3,0
 794:	bd4d                	j	646 <vprintf+0x42>
        putc(fd, '%');
 796:	02500593          	li	a1,37
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	d9a080e7          	jalr	-614(ra) # 536 <putc>
        putc(fd, c);
 7a4:	85ca                	mv	a1,s2
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	d8e080e7          	jalr	-626(ra) # 536 <putc>
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	bd51                	j	646 <vprintf+0x42>
        s = va_arg(ap, char*);
 7b4:	8bce                	mv	s7,s3
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b579                	j	646 <vprintf+0x42>
 7ba:	74e2                	ld	s1,56(sp)
 7bc:	79a2                	ld	s3,40(sp)
 7be:	7a02                	ld	s4,32(sp)
 7c0:	6ae2                	ld	s5,24(sp)
 7c2:	6b42                	ld	s6,16(sp)
 7c4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7c6:	60a6                	ld	ra,72(sp)
 7c8:	6406                	ld	s0,64(sp)
 7ca:	7942                	ld	s2,48(sp)
 7cc:	6161                	add	sp,sp,80
 7ce:	8082                	ret

00000000000007d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d0:	715d                	add	sp,sp,-80
 7d2:	ec06                	sd	ra,24(sp)
 7d4:	e822                	sd	s0,16(sp)
 7d6:	1000                	add	s0,sp,32
 7d8:	e010                	sd	a2,0(s0)
 7da:	e414                	sd	a3,8(s0)
 7dc:	e818                	sd	a4,16(s0)
 7de:	ec1c                	sd	a5,24(s0)
 7e0:	03043023          	sd	a6,32(s0)
 7e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ec:	8622                	mv	a2,s0
 7ee:	00000097          	auipc	ra,0x0
 7f2:	e16080e7          	jalr	-490(ra) # 604 <vprintf>
}
 7f6:	60e2                	ld	ra,24(sp)
 7f8:	6442                	ld	s0,16(sp)
 7fa:	6161                	add	sp,sp,80
 7fc:	8082                	ret

00000000000007fe <printf>:

void
printf(const char *fmt, ...)
{
 7fe:	711d                	add	sp,sp,-96
 800:	ec06                	sd	ra,24(sp)
 802:	e822                	sd	s0,16(sp)
 804:	1000                	add	s0,sp,32
 806:	e40c                	sd	a1,8(s0)
 808:	e810                	sd	a2,16(s0)
 80a:	ec14                	sd	a3,24(s0)
 80c:	f018                	sd	a4,32(s0)
 80e:	f41c                	sd	a5,40(s0)
 810:	03043823          	sd	a6,48(s0)
 814:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 818:	00840613          	add	a2,s0,8
 81c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 820:	85aa                	mv	a1,a0
 822:	4505                	li	a0,1
 824:	00000097          	auipc	ra,0x0
 828:	de0080e7          	jalr	-544(ra) # 604 <vprintf>
}
 82c:	60e2                	ld	ra,24(sp)
 82e:	6442                	ld	s0,16(sp)
 830:	6125                	add	sp,sp,96
 832:	8082                	ret

0000000000000834 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 834:	1141                	add	sp,sp,-16
 836:	e422                	sd	s0,8(sp)
 838:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83e:	00000797          	auipc	a5,0x0
 842:	30a7b783          	ld	a5,778(a5) # b48 <freep>
 846:	a02d                	j	870 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 848:	4618                	lw	a4,8(a2)
 84a:	9f2d                	addw	a4,a4,a1
 84c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 850:	6398                	ld	a4,0(a5)
 852:	6310                	ld	a2,0(a4)
 854:	a83d                	j	892 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 856:	ff852703          	lw	a4,-8(a0)
 85a:	9f31                	addw	a4,a4,a2
 85c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 85e:	ff053683          	ld	a3,-16(a0)
 862:	a091                	j	8a6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	6398                	ld	a4,0(a5)
 866:	00e7e463          	bltu	a5,a4,86e <free+0x3a>
 86a:	00e6ea63          	bltu	a3,a4,87e <free+0x4a>
{
 86e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 870:	fed7fae3          	bgeu	a5,a3,864 <free+0x30>
 874:	6398                	ld	a4,0(a5)
 876:	00e6e463          	bltu	a3,a4,87e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87a:	fee7eae3          	bltu	a5,a4,86e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 87e:	ff852583          	lw	a1,-8(a0)
 882:	6390                	ld	a2,0(a5)
 884:	02059813          	sll	a6,a1,0x20
 888:	01c85713          	srl	a4,a6,0x1c
 88c:	9736                	add	a4,a4,a3
 88e:	fae60de3          	beq	a2,a4,848 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 892:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 896:	4790                	lw	a2,8(a5)
 898:	02061593          	sll	a1,a2,0x20
 89c:	01c5d713          	srl	a4,a1,0x1c
 8a0:	973e                	add	a4,a4,a5
 8a2:	fae68ae3          	beq	a3,a4,856 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8a6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8a8:	00000717          	auipc	a4,0x0
 8ac:	2af73023          	sd	a5,672(a4) # b48 <freep>
}
 8b0:	6422                	ld	s0,8(sp)
 8b2:	0141                	add	sp,sp,16
 8b4:	8082                	ret

00000000000008b6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8b6:	7139                	add	sp,sp,-64
 8b8:	fc06                	sd	ra,56(sp)
 8ba:	f822                	sd	s0,48(sp)
 8bc:	f426                	sd	s1,40(sp)
 8be:	ec4e                	sd	s3,24(sp)
 8c0:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c2:	02051493          	sll	s1,a0,0x20
 8c6:	9081                	srl	s1,s1,0x20
 8c8:	04bd                	add	s1,s1,15
 8ca:	8091                	srl	s1,s1,0x4
 8cc:	0014899b          	addw	s3,s1,1
 8d0:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8d2:	00000517          	auipc	a0,0x0
 8d6:	27653503          	ld	a0,630(a0) # b48 <freep>
 8da:	c915                	beqz	a0,90e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8de:	4798                	lw	a4,8(a5)
 8e0:	08977e63          	bgeu	a4,s1,97c <malloc+0xc6>
 8e4:	f04a                	sd	s2,32(sp)
 8e6:	e852                	sd	s4,16(sp)
 8e8:	e456                	sd	s5,8(sp)
 8ea:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8ec:	8a4e                	mv	s4,s3
 8ee:	0009871b          	sext.w	a4,s3
 8f2:	6685                	lui	a3,0x1
 8f4:	00d77363          	bgeu	a4,a3,8fa <malloc+0x44>
 8f8:	6a05                	lui	s4,0x1
 8fa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8fe:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 902:	00000917          	auipc	s2,0x0
 906:	24690913          	add	s2,s2,582 # b48 <freep>
  if(p == (char*)-1)
 90a:	5afd                	li	s5,-1
 90c:	a091                	j	950 <malloc+0x9a>
 90e:	f04a                	sd	s2,32(sp)
 910:	e852                	sd	s4,16(sp)
 912:	e456                	sd	s5,8(sp)
 914:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 916:	00000797          	auipc	a5,0x0
 91a:	23a78793          	add	a5,a5,570 # b50 <base>
 91e:	00000717          	auipc	a4,0x0
 922:	22f73523          	sd	a5,554(a4) # b48 <freep>
 926:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 928:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 92c:	b7c1                	j	8ec <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 92e:	6398                	ld	a4,0(a5)
 930:	e118                	sd	a4,0(a0)
 932:	a08d                	j	994 <malloc+0xde>
  hp->s.size = nu;
 934:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 938:	0541                	add	a0,a0,16
 93a:	00000097          	auipc	ra,0x0
 93e:	efa080e7          	jalr	-262(ra) # 834 <free>
  return freep;
 942:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 946:	c13d                	beqz	a0,9ac <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 948:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94a:	4798                	lw	a4,8(a5)
 94c:	02977463          	bgeu	a4,s1,974 <malloc+0xbe>
    if(p == freep)
 950:	00093703          	ld	a4,0(s2)
 954:	853e                	mv	a0,a5
 956:	fef719e3          	bne	a4,a5,948 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 95a:	8552                	mv	a0,s4
 95c:	00000097          	auipc	ra,0x0
 960:	bb2080e7          	jalr	-1102(ra) # 50e <sbrk>
  if(p == (char*)-1)
 964:	fd5518e3          	bne	a0,s5,934 <malloc+0x7e>
        return 0;
 968:	4501                	li	a0,0
 96a:	7902                	ld	s2,32(sp)
 96c:	6a42                	ld	s4,16(sp)
 96e:	6aa2                	ld	s5,8(sp)
 970:	6b02                	ld	s6,0(sp)
 972:	a03d                	j	9a0 <malloc+0xea>
 974:	7902                	ld	s2,32(sp)
 976:	6a42                	ld	s4,16(sp)
 978:	6aa2                	ld	s5,8(sp)
 97a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 97c:	fae489e3          	beq	s1,a4,92e <malloc+0x78>
        p->s.size -= nunits;
 980:	4137073b          	subw	a4,a4,s3
 984:	c798                	sw	a4,8(a5)
        p += p->s.size;
 986:	02071693          	sll	a3,a4,0x20
 98a:	01c6d713          	srl	a4,a3,0x1c
 98e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 990:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 994:	00000717          	auipc	a4,0x0
 998:	1aa73a23          	sd	a0,436(a4) # b48 <freep>
      return (void*)(p + 1);
 99c:	01078513          	add	a0,a5,16
  }
}
 9a0:	70e2                	ld	ra,56(sp)
 9a2:	7442                	ld	s0,48(sp)
 9a4:	74a2                	ld	s1,40(sp)
 9a6:	69e2                	ld	s3,24(sp)
 9a8:	6121                	add	sp,sp,64
 9aa:	8082                	ret
 9ac:	7902                	ld	s2,32(sp)
 9ae:	6a42                	ld	s4,16(sp)
 9b0:	6aa2                	ld	s5,8(sp)
 9b2:	6b02                	ld	s6,0(sp)
 9b4:	b7f5                	j	9a0 <malloc+0xea>
