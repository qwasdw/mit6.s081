
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001e117          	auipc	sp,0x1e
    80000004:	14010113          	add	sp,sp,320 # 8001e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1c9050ef          	jal	800059de <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	add	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	sll	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	add	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	sll	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	add	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	3cc080e7          	jalr	972(ra) # 80006426 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	46c080e7          	jalr	1132(ra) # 800064da <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	add	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	add	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	e22080e7          	jalr	-478(ra) # 80005eac <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	add	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	add	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	add	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	add	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	add	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	2a0080e7          	jalr	672(ra) # 80006396 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	sll	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	add	a0,a0,318 # 80026240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	add	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	add	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	add	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	2f8080e7          	jalr	760(ra) # 80006426 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	add	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	394080e7          	jalr	916(ra) # 800064da <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	add	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	add	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	36a080e7          	jalr	874(ra) # 800064da <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	add	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	sll	a2,a2,0x20
    80000186:	9201                	srl	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	add	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	add	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	add	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	sll	a3,a3,0x20
    800001aa:	9281                	srl	a3,a3,0x20
    800001ac:	0685                	add	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	add	a0,a0,1
    800001be:	0585                	add	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	add	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	add	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	sll	a2,a2,0x20
    800001e4:	9201                	srl	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	add	a1,a1,1
    800001ee:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	feb79ae3          	bne	a5,a1,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	add	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	sll	a3,a2,0x20
    80000206:	9281                	srl	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addw	a5,a2,-1
    80000216:	1782                	sll	a5,a5,0x20
    80000218:	9381                	srl	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	add	a4,a4,-1
    80000222:	16fd                	add	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fef71ae3          	bne	a4,a5,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	add	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	add	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	add	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addw	a2,a2,-1
    80000262:	0505                	add	a0,a0,1
    80000264:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a801                	j	8000027a <strncmp+0x30>
    8000026c:	4501                	li	a0,0
    8000026e:	a031                	j	8000027a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	add	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000280:	1141                	add	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000286:	87aa                	mv	a5,a0
    80000288:	86b2                	mv	a3,a2
    8000028a:	367d                	addw	a2,a2,-1
    8000028c:	02d05563          	blez	a3,800002b6 <strncpy+0x36>
    80000290:	0785                	add	a5,a5,1
    80000292:	0005c703          	lbu	a4,0(a1)
    80000296:	fee78fa3          	sb	a4,-1(a5)
    8000029a:	0585                	add	a1,a1,1
    8000029c:	f775                	bnez	a4,80000288 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000029e:	873e                	mv	a4,a5
    800002a0:	9fb5                	addw	a5,a5,a3
    800002a2:	37fd                	addw	a5,a5,-1
    800002a4:	00c05963          	blez	a2,800002b6 <strncpy+0x36>
    *s++ = 0;
    800002a8:	0705                	add	a4,a4,1
    800002aa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002ae:	40e786bb          	subw	a3,a5,a4
    800002b2:	fed04be3          	bgtz	a3,800002a8 <strncpy+0x28>
  return os;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	add	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002bc:	1141                	add	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c2:	02c05363          	blez	a2,800002e8 <safestrcpy+0x2c>
    800002c6:	fff6069b          	addw	a3,a2,-1
    800002ca:	1682                	sll	a3,a3,0x20
    800002cc:	9281                	srl	a3,a3,0x20
    800002ce:	96ae                	add	a3,a3,a1
    800002d0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d2:	00d58963          	beq	a1,a3,800002e4 <safestrcpy+0x28>
    800002d6:	0585                	add	a1,a1,1
    800002d8:	0785                	add	a5,a5,1
    800002da:	fff5c703          	lbu	a4,-1(a1)
    800002de:	fee78fa3          	sb	a4,-1(a5)
    800002e2:	fb65                	bnez	a4,800002d2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	add	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strlen>:

int
strlen(const char *s)
{
    800002ee:	1141                	add	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf91                	beqz	a5,80000314 <strlen+0x26>
    800002fa:	0505                	add	a0,a0,1
    800002fc:	87aa                	mv	a5,a0
    800002fe:	86be                	mv	a3,a5
    80000300:	0785                	add	a5,a5,1
    80000302:	fff7c703          	lbu	a4,-1(a5)
    80000306:	ff65                	bnez	a4,800002fe <strlen+0x10>
    80000308:	40a6853b          	subw	a0,a3,a0
    8000030c:	2505                	addw	a0,a0,1
    ;
  return n;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	add	sp,sp,16
    80000312:	8082                	ret
  for(n = 0; s[n]; n++)
    80000314:	4501                	li	a0,0
    80000316:	bfe5                	j	8000030e <strlen+0x20>

0000000080000318 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000318:	1141                	add	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000320:	00001097          	auipc	ra,0x1
    80000324:	bf2080e7          	jalr	-1038(ra) # 80000f12 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000328:	00009717          	auipc	a4,0x9
    8000032c:	cd870713          	add	a4,a4,-808 # 80009000 <started>
  if(cpuid() == 0){
    80000330:	c139                	beqz	a0,80000376 <main+0x5e>
    while(started == 0)
    80000332:	431c                	lw	a5,0(a4)
    80000334:	2781                	sext.w	a5,a5
    80000336:	dff5                	beqz	a5,80000332 <main+0x1a>
      ;
    __sync_synchronize();
    80000338:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	bd6080e7          	jalr	-1066(ra) # 80000f12 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	add	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	ba8080e7          	jalr	-1112(ra) # 80005ef6 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	8d4080e7          	jalr	-1836(ra) # 80001c32 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	02e080e7          	jalr	46(ra) # 80005394 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	180080e7          	jalr	384(ra) # 800014ee <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	a46080e7          	jalr	-1466(ra) # 80005dbc <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	d80080e7          	jalr	-640(ra) # 800060fe <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	add	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	b68080e7          	jalr	-1176(ra) # 80005ef6 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	add	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	b58080e7          	jalr	-1192(ra) # 80005ef6 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	add	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	b48080e7          	jalr	-1208(ra) # 80005ef6 <printf>
    kinit();         // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	322080e7          	jalr	802(ra) # 800006e0 <kvminit>
    kvminithart();   // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	068080e7          	jalr	104(ra) # 8000042e <kvminithart>
    procinit();      // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	a88080e7          	jalr	-1400(ra) # 80000e56 <procinit>
    trapinit();      // trap vectors
    800003d6:	00002097          	auipc	ra,0x2
    800003da:	834080e7          	jalr	-1996(ra) # 80001c0a <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	854080e7          	jalr	-1964(ra) # 80001c32 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	f94080e7          	jalr	-108(ra) # 8000537a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	fa6080e7          	jalr	-90(ra) # 80005394 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	0a6080e7          	jalr	166(ra) # 8000249c <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	732080e7          	jalr	1842(ra) # 80002b30 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	6d6080e7          	jalr	1750(ra) # 80003adc <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	0a6080e7          	jalr	166(ra) # 800054b4 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	e9c080e7          	jalr	-356(ra) # 800012b2 <userinit>
    __sync_synchronize();
    8000041e:	0ff0000f          	fence
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	00009717          	auipc	a4,0x9
    80000428:	bcf72e23          	sw	a5,-1060(a4) # 80009000 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    8000042e:	1141                	add	sp,sp,-16
    80000430:	e422                	sd	s0,8(sp)
    80000432:	0800                	add	s0,sp,16
    w_satp(MAKE_SATP(kernel_pagetable));
    80000434:	00009797          	auipc	a5,0x9
    80000438:	bd47b783          	ld	a5,-1068(a5) # 80009008 <kernel_pagetable>
    8000043c:	83b1                	srl	a5,a5,0xc
    8000043e:	577d                	li	a4,-1
    80000440:	177e                	sll	a4,a4,0x3f
    80000442:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void
w_satp(uint64 x)
{
    asm volatile("csrw satp, %0" : : "r"(x));
    80000444:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
    // the zero, zero means flush all TLB entries.
    asm volatile("sfence.vma zero, zero");
    80000448:	12000073          	sfence.vma
    sfence_vma();
}
    8000044c:	6422                	ld	s0,8(sp)
    8000044e:	0141                	add	sp,sp,16
    80000450:	8082                	ret

0000000080000452 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000452:	7139                	add	sp,sp,-64
    80000454:	fc06                	sd	ra,56(sp)
    80000456:	f822                	sd	s0,48(sp)
    80000458:	f426                	sd	s1,40(sp)
    8000045a:	f04a                	sd	s2,32(sp)
    8000045c:	ec4e                	sd	s3,24(sp)
    8000045e:	e852                	sd	s4,16(sp)
    80000460:	e456                	sd	s5,8(sp)
    80000462:	e05a                	sd	s6,0(sp)
    80000464:	0080                	add	s0,sp,64
    80000466:	84aa                	mv	s1,a0
    80000468:	89ae                	mv	s3,a1
    8000046a:	8ab2                	mv	s5,a2
    if (va >= MAXVA)
    8000046c:	57fd                	li	a5,-1
    8000046e:	83e9                	srl	a5,a5,0x1a
    80000470:	4a79                	li	s4,30
        panic("walk");

    for (int level = 2; level > 0; level--)
    80000472:	4b31                	li	s6,12
    if (va >= MAXVA)
    80000474:	04b7f263          	bgeu	a5,a1,800004b8 <walk+0x66>
        panic("walk");
    80000478:	00008517          	auipc	a0,0x8
    8000047c:	bd850513          	add	a0,a0,-1064 # 80008050 <etext+0x50>
    80000480:	00006097          	auipc	ra,0x6
    80000484:	a2c080e7          	jalr	-1492(ra) # 80005eac <panic>
        {
            pagetable = (pagetable_t)PTE2PA(*pte);
        }
        else
        {
            if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000488:	060a8663          	beqz	s5,800004f4 <walk+0xa2>
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	c8e080e7          	jalr	-882(ra) # 8000011a <kalloc>
    80000494:	84aa                	mv	s1,a0
    80000496:	c529                	beqz	a0,800004e0 <walk+0x8e>
                return 0;
            memset(pagetable, 0, PGSIZE);
    80000498:	6605                	lui	a2,0x1
    8000049a:	4581                	li	a1,0
    8000049c:	00000097          	auipc	ra,0x0
    800004a0:	cde080e7          	jalr	-802(ra) # 8000017a <memset>
            *pte = PA2PTE(pagetable) | PTE_V;
    800004a4:	00c4d793          	srl	a5,s1,0xc
    800004a8:	07aa                	sll	a5,a5,0xa
    800004aa:	0017e793          	or	a5,a5,1
    800004ae:	00f93023          	sd	a5,0(s2)
    for (int level = 2; level > 0; level--)
    800004b2:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004b4:	036a0063          	beq	s4,s6,800004d4 <walk+0x82>
        pte_t *pte = &pagetable[PX(level, va)];
    800004b8:	0149d933          	srl	s2,s3,s4
    800004bc:	1ff97913          	and	s2,s2,511
    800004c0:	090e                	sll	s2,s2,0x3
    800004c2:	9926                	add	s2,s2,s1
        if (*pte & PTE_V)
    800004c4:	00093483          	ld	s1,0(s2)
    800004c8:	0014f793          	and	a5,s1,1
    800004cc:	dfd5                	beqz	a5,80000488 <walk+0x36>
            pagetable = (pagetable_t)PTE2PA(*pte);
    800004ce:	80a9                	srl	s1,s1,0xa
    800004d0:	04b2                	sll	s1,s1,0xc
    800004d2:	b7c5                	j	800004b2 <walk+0x60>
        }
    }
    return &pagetable[PX(0, va)];
    800004d4:	00c9d513          	srl	a0,s3,0xc
    800004d8:	1ff57513          	and	a0,a0,511
    800004dc:	050e                	sll	a0,a0,0x3
    800004de:	9526                	add	a0,a0,s1
}
    800004e0:	70e2                	ld	ra,56(sp)
    800004e2:	7442                	ld	s0,48(sp)
    800004e4:	74a2                	ld	s1,40(sp)
    800004e6:	7902                	ld	s2,32(sp)
    800004e8:	69e2                	ld	s3,24(sp)
    800004ea:	6a42                	ld	s4,16(sp)
    800004ec:	6aa2                	ld	s5,8(sp)
    800004ee:	6b02                	ld	s6,0(sp)
    800004f0:	6121                	add	sp,sp,64
    800004f2:	8082                	ret
                return 0;
    800004f4:	4501                	li	a0,0
    800004f6:	b7ed                	j	800004e0 <walk+0x8e>

00000000800004f8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
    pte_t *pte;
    uint64 pa;

    if (va >= MAXVA)
    800004f8:	57fd                	li	a5,-1
    800004fa:	83e9                	srl	a5,a5,0x1a
    800004fc:	00b7f463          	bgeu	a5,a1,80000504 <walkaddr+0xc>
        return 0;
    80000500:	4501                	li	a0,0
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    pa = PTE2PA(*pte);
    return pa;
}
    80000502:	8082                	ret
{
    80000504:	1141                	add	sp,sp,-16
    80000506:	e406                	sd	ra,8(sp)
    80000508:	e022                	sd	s0,0(sp)
    8000050a:	0800                	add	s0,sp,16
    pte = walk(pagetable, va, 0);
    8000050c:	4601                	li	a2,0
    8000050e:	00000097          	auipc	ra,0x0
    80000512:	f44080e7          	jalr	-188(ra) # 80000452 <walk>
    if (pte == 0)
    80000516:	c105                	beqz	a0,80000536 <walkaddr+0x3e>
    if ((*pte & PTE_V) == 0)
    80000518:	611c                	ld	a5,0(a0)
    if ((*pte & PTE_U) == 0)
    8000051a:	0117f693          	and	a3,a5,17
    8000051e:	4745                	li	a4,17
        return 0;
    80000520:	4501                	li	a0,0
    if ((*pte & PTE_U) == 0)
    80000522:	00e68663          	beq	a3,a4,8000052e <walkaddr+0x36>
}
    80000526:	60a2                	ld	ra,8(sp)
    80000528:	6402                	ld	s0,0(sp)
    8000052a:	0141                	add	sp,sp,16
    8000052c:	8082                	ret
    pa = PTE2PA(*pte);
    8000052e:	83a9                	srl	a5,a5,0xa
    80000530:	00c79513          	sll	a0,a5,0xc
    return pa;
    80000534:	bfcd                	j	80000526 <walkaddr+0x2e>
        return 0;
    80000536:	4501                	li	a0,0
    80000538:	b7fd                	j	80000526 <walkaddr+0x2e>

000000008000053a <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000053a:	715d                	add	sp,sp,-80
    8000053c:	e486                	sd	ra,72(sp)
    8000053e:	e0a2                	sd	s0,64(sp)
    80000540:	fc26                	sd	s1,56(sp)
    80000542:	f84a                	sd	s2,48(sp)
    80000544:	f44e                	sd	s3,40(sp)
    80000546:	f052                	sd	s4,32(sp)
    80000548:	ec56                	sd	s5,24(sp)
    8000054a:	e85a                	sd	s6,16(sp)
    8000054c:	e45e                	sd	s7,8(sp)
    8000054e:	0880                	add	s0,sp,80
    uint64 a, last;
    pte_t *pte;

    if (size == 0)
    80000550:	c639                	beqz	a2,8000059e <mappages+0x64>
    80000552:	8aaa                	mv	s5,a0
    80000554:	8b3a                	mv	s6,a4
        panic("mappages: size");

    a = PGROUNDDOWN(va);
    80000556:	777d                	lui	a4,0xfffff
    80000558:	00e5f7b3          	and	a5,a1,a4
    last = PGROUNDDOWN(va + size - 1);
    8000055c:	fff58993          	add	s3,a1,-1
    80000560:	99b2                	add	s3,s3,a2
    80000562:	00e9f9b3          	and	s3,s3,a4
    a = PGROUNDDOWN(va);
    80000566:	893e                	mv	s2,a5
    80000568:	40f68a33          	sub	s4,a3,a5
        if (*pte & PTE_V)
            panic("mappages: remap");
        *pte = PA2PTE(pa) | perm | PTE_V;
        if (a == last)
            break;
        a += PGSIZE;
    8000056c:	6b85                	lui	s7,0x1
    8000056e:	014904b3          	add	s1,s2,s4
        if ((pte = walk(pagetable, a, 1)) == 0)
    80000572:	4605                	li	a2,1
    80000574:	85ca                	mv	a1,s2
    80000576:	8556                	mv	a0,s5
    80000578:	00000097          	auipc	ra,0x0
    8000057c:	eda080e7          	jalr	-294(ra) # 80000452 <walk>
    80000580:	cd1d                	beqz	a0,800005be <mappages+0x84>
        if (*pte & PTE_V)
    80000582:	611c                	ld	a5,0(a0)
    80000584:	8b85                	and	a5,a5,1
    80000586:	e785                	bnez	a5,800005ae <mappages+0x74>
        *pte = PA2PTE(pa) | perm | PTE_V;
    80000588:	80b1                	srl	s1,s1,0xc
    8000058a:	04aa                	sll	s1,s1,0xa
    8000058c:	0164e4b3          	or	s1,s1,s6
    80000590:	0014e493          	or	s1,s1,1
    80000594:	e104                	sd	s1,0(a0)
        if (a == last)
    80000596:	05390063          	beq	s2,s3,800005d6 <mappages+0x9c>
        a += PGSIZE;
    8000059a:	995e                	add	s2,s2,s7
        if ((pte = walk(pagetable, a, 1)) == 0)
    8000059c:	bfc9                	j	8000056e <mappages+0x34>
        panic("mappages: size");
    8000059e:	00008517          	auipc	a0,0x8
    800005a2:	aba50513          	add	a0,a0,-1350 # 80008058 <etext+0x58>
    800005a6:	00006097          	auipc	ra,0x6
    800005aa:	906080e7          	jalr	-1786(ra) # 80005eac <panic>
            panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	add	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	8f6080e7          	jalr	-1802(ra) # 80005eac <panic>
            return -1;
    800005be:	557d                	li	a0,-1
        pa += PGSIZE;
    }
    return 0;
}
    800005c0:	60a6                	ld	ra,72(sp)
    800005c2:	6406                	ld	s0,64(sp)
    800005c4:	74e2                	ld	s1,56(sp)
    800005c6:	7942                	ld	s2,48(sp)
    800005c8:	79a2                	ld	s3,40(sp)
    800005ca:	7a02                	ld	s4,32(sp)
    800005cc:	6ae2                	ld	s5,24(sp)
    800005ce:	6b42                	ld	s6,16(sp)
    800005d0:	6ba2                	ld	s7,8(sp)
    800005d2:	6161                	add	sp,sp,80
    800005d4:	8082                	ret
    return 0;
    800005d6:	4501                	li	a0,0
    800005d8:	b7e5                	j	800005c0 <mappages+0x86>

00000000800005da <kvmmap>:
{
    800005da:	1141                	add	sp,sp,-16
    800005dc:	e406                	sd	ra,8(sp)
    800005de:	e022                	sd	s0,0(sp)
    800005e0:	0800                	add	s0,sp,16
    800005e2:	87b6                	mv	a5,a3
    if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005e4:	86b2                	mv	a3,a2
    800005e6:	863e                	mv	a2,a5
    800005e8:	00000097          	auipc	ra,0x0
    800005ec:	f52080e7          	jalr	-174(ra) # 8000053a <mappages>
    800005f0:	e509                	bnez	a0,800005fa <kvmmap+0x20>
}
    800005f2:	60a2                	ld	ra,8(sp)
    800005f4:	6402                	ld	s0,0(sp)
    800005f6:	0141                	add	sp,sp,16
    800005f8:	8082                	ret
        panic("kvmmap");
    800005fa:	00008517          	auipc	a0,0x8
    800005fe:	a7e50513          	add	a0,a0,-1410 # 80008078 <etext+0x78>
    80000602:	00006097          	auipc	ra,0x6
    80000606:	8aa080e7          	jalr	-1878(ra) # 80005eac <panic>

000000008000060a <kvmmake>:
{
    8000060a:	1101                	add	sp,sp,-32
    8000060c:	ec06                	sd	ra,24(sp)
    8000060e:	e822                	sd	s0,16(sp)
    80000610:	e426                	sd	s1,8(sp)
    80000612:	e04a                	sd	s2,0(sp)
    80000614:	1000                	add	s0,sp,32
    kpgtbl = (pagetable_t)kalloc();
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	b04080e7          	jalr	-1276(ra) # 8000011a <kalloc>
    8000061e:	84aa                	mv	s1,a0
    memset(kpgtbl, 0, PGSIZE);
    80000620:	6605                	lui	a2,0x1
    80000622:	4581                	li	a1,0
    80000624:	00000097          	auipc	ra,0x0
    80000628:	b56080e7          	jalr	-1194(ra) # 8000017a <memset>
    kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000062c:	4719                	li	a4,6
    8000062e:	6685                	lui	a3,0x1
    80000630:	10000637          	lui	a2,0x10000
    80000634:	100005b7          	lui	a1,0x10000
    80000638:	8526                	mv	a0,s1
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	fa0080e7          	jalr	-96(ra) # 800005da <kvmmap>
    kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000642:	4719                	li	a4,6
    80000644:	6685                	lui	a3,0x1
    80000646:	10001637          	lui	a2,0x10001
    8000064a:	100015b7          	lui	a1,0x10001
    8000064e:	8526                	mv	a0,s1
    80000650:	00000097          	auipc	ra,0x0
    80000654:	f8a080e7          	jalr	-118(ra) # 800005da <kvmmap>
    kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000658:	4719                	li	a4,6
    8000065a:	004006b7          	lui	a3,0x400
    8000065e:	0c000637          	lui	a2,0xc000
    80000662:	0c0005b7          	lui	a1,0xc000
    80000666:	8526                	mv	a0,s1
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	f72080e7          	jalr	-142(ra) # 800005da <kvmmap>
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80000670:	00008917          	auipc	s2,0x8
    80000674:	99090913          	add	s2,s2,-1648 # 80008000 <etext>
    80000678:	4729                	li	a4,10
    8000067a:	80008697          	auipc	a3,0x80008
    8000067e:	98668693          	add	a3,a3,-1658 # 8000 <_entry-0x7fff8000>
    80000682:	4605                	li	a2,1
    80000684:	067e                	sll	a2,a2,0x1f
    80000686:	85b2                	mv	a1,a2
    80000688:	8526                	mv	a0,s1
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	f50080e7          	jalr	-176(ra) # 800005da <kvmmap>
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    80000692:	46c5                	li	a3,17
    80000694:	06ee                	sll	a3,a3,0x1b
    80000696:	4719                	li	a4,6
    80000698:	412686b3          	sub	a3,a3,s2
    8000069c:	864a                	mv	a2,s2
    8000069e:	85ca                	mv	a1,s2
    800006a0:	8526                	mv	a0,s1
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	f38080e7          	jalr	-200(ra) # 800005da <kvmmap>
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006aa:	4729                	li	a4,10
    800006ac:	6685                	lui	a3,0x1
    800006ae:	00007617          	auipc	a2,0x7
    800006b2:	95260613          	add	a2,a2,-1710 # 80007000 <_trampoline>
    800006b6:	040005b7          	lui	a1,0x4000
    800006ba:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006bc:	05b2                	sll	a1,a1,0xc
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f1a080e7          	jalr	-230(ra) # 800005da <kvmmap>
    proc_mapstacks(kpgtbl);
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	6ea080e7          	jalr	1770(ra) # 80000db4 <proc_mapstacks>
}
    800006d2:	8526                	mv	a0,s1
    800006d4:	60e2                	ld	ra,24(sp)
    800006d6:	6442                	ld	s0,16(sp)
    800006d8:	64a2                	ld	s1,8(sp)
    800006da:	6902                	ld	s2,0(sp)
    800006dc:	6105                	add	sp,sp,32
    800006de:	8082                	ret

00000000800006e0 <kvminit>:
{
    800006e0:	1141                	add	sp,sp,-16
    800006e2:	e406                	sd	ra,8(sp)
    800006e4:	e022                	sd	s0,0(sp)
    800006e6:	0800                	add	s0,sp,16
    kernel_pagetable = kvmmake();
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f22080e7          	jalr	-222(ra) # 8000060a <kvmmake>
    800006f0:	00009797          	auipc	a5,0x9
    800006f4:	90a7bc23          	sd	a0,-1768(a5) # 80009008 <kernel_pagetable>
}
    800006f8:	60a2                	ld	ra,8(sp)
    800006fa:	6402                	ld	s0,0(sp)
    800006fc:	0141                	add	sp,sp,16
    800006fe:	8082                	ret

0000000080000700 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000700:	715d                	add	sp,sp,-80
    80000702:	e486                	sd	ra,72(sp)
    80000704:	e0a2                	sd	s0,64(sp)
    80000706:	0880                	add	s0,sp,80
    uint64 a;
    pte_t *pte;

    if ((va % PGSIZE) != 0)
    80000708:	03459793          	sll	a5,a1,0x34
    8000070c:	e39d                	bnez	a5,80000732 <uvmunmap+0x32>
    8000070e:	f84a                	sd	s2,48(sp)
    80000710:	f44e                	sd	s3,40(sp)
    80000712:	f052                	sd	s4,32(sp)
    80000714:	ec56                	sd	s5,24(sp)
    80000716:	e85a                	sd	s6,16(sp)
    80000718:	e45e                	sd	s7,8(sp)
    8000071a:	8a2a                	mv	s4,a0
    8000071c:	892e                	mv	s2,a1
    8000071e:	8ab6                	mv	s5,a3
        panic("uvmunmap: not aligned");

    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000720:	0632                	sll	a2,a2,0xc
    80000722:	00b609b3          	add	s3,a2,a1
    {
        if ((pte = walk(pagetable, a, 0)) == 0)
            panic("uvmunmap: walk");
        if ((*pte & PTE_V) == 0)
            panic("uvmunmap: not mapped");
        if (PTE_FLAGS(*pte) == PTE_V)
    80000726:	4b85                	li	s7,1
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000728:	6b05                	lui	s6,0x1
    8000072a:	0935fb63          	bgeu	a1,s3,800007c0 <uvmunmap+0xc0>
    8000072e:	fc26                	sd	s1,56(sp)
    80000730:	a8a9                	j	8000078a <uvmunmap+0x8a>
    80000732:	fc26                	sd	s1,56(sp)
    80000734:	f84a                	sd	s2,48(sp)
    80000736:	f44e                	sd	s3,40(sp)
    80000738:	f052                	sd	s4,32(sp)
    8000073a:	ec56                	sd	s5,24(sp)
    8000073c:	e85a                	sd	s6,16(sp)
    8000073e:	e45e                	sd	s7,8(sp)
        panic("uvmunmap: not aligned");
    80000740:	00008517          	auipc	a0,0x8
    80000744:	94050513          	add	a0,a0,-1728 # 80008080 <etext+0x80>
    80000748:	00005097          	auipc	ra,0x5
    8000074c:	764080e7          	jalr	1892(ra) # 80005eac <panic>
            panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	add	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	754080e7          	jalr	1876(ra) # 80005eac <panic>
            panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	add	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	744080e7          	jalr	1860(ra) # 80005eac <panic>
            panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	add	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	734080e7          	jalr	1844(ra) # 80005eac <panic>
        if (do_free)
        {
            uint64 pa = PTE2PA(*pte);
            kfree((void *)pa);
        }
        *pte = 0;
    80000780:	0004b023          	sd	zero,0(s1)
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000784:	995a                	add	s2,s2,s6
    80000786:	03397c63          	bgeu	s2,s3,800007be <uvmunmap+0xbe>
        if ((pte = walk(pagetable, a, 0)) == 0)
    8000078a:	4601                	li	a2,0
    8000078c:	85ca                	mv	a1,s2
    8000078e:	8552                	mv	a0,s4
    80000790:	00000097          	auipc	ra,0x0
    80000794:	cc2080e7          	jalr	-830(ra) # 80000452 <walk>
    80000798:	84aa                	mv	s1,a0
    8000079a:	d95d                	beqz	a0,80000750 <uvmunmap+0x50>
        if ((*pte & PTE_V) == 0)
    8000079c:	6108                	ld	a0,0(a0)
    8000079e:	00157793          	and	a5,a0,1
    800007a2:	dfdd                	beqz	a5,80000760 <uvmunmap+0x60>
        if (PTE_FLAGS(*pte) == PTE_V)
    800007a4:	3ff57793          	and	a5,a0,1023
    800007a8:	fd7784e3          	beq	a5,s7,80000770 <uvmunmap+0x70>
        if (do_free)
    800007ac:	fc0a8ae3          	beqz	s5,80000780 <uvmunmap+0x80>
            uint64 pa = PTE2PA(*pte);
    800007b0:	8129                	srl	a0,a0,0xa
            kfree((void *)pa);
    800007b2:	0532                	sll	a0,a0,0xc
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	868080e7          	jalr	-1944(ra) # 8000001c <kfree>
    800007bc:	b7d1                	j	80000780 <uvmunmap+0x80>
    800007be:	74e2                	ld	s1,56(sp)
    800007c0:	7942                	ld	s2,48(sp)
    800007c2:	79a2                	ld	s3,40(sp)
    800007c4:	7a02                	ld	s4,32(sp)
    800007c6:	6ae2                	ld	s5,24(sp)
    800007c8:	6b42                	ld	s6,16(sp)
    800007ca:	6ba2                	ld	s7,8(sp)
    }
}
    800007cc:	60a6                	ld	ra,72(sp)
    800007ce:	6406                	ld	s0,64(sp)
    800007d0:	6161                	add	sp,sp,80
    800007d2:	8082                	ret

00000000800007d4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d4:	1101                	add	sp,sp,-32
    800007d6:	ec06                	sd	ra,24(sp)
    800007d8:	e822                	sd	s0,16(sp)
    800007da:	e426                	sd	s1,8(sp)
    800007dc:	1000                	add	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t)kalloc();
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	93c080e7          	jalr	-1732(ra) # 8000011a <kalloc>
    800007e6:	84aa                	mv	s1,a0
    if (pagetable == 0)
    800007e8:	c519                	beqz	a0,800007f6 <uvmcreate+0x22>
        return 0;
    memset(pagetable, 0, PGSIZE);
    800007ea:	6605                	lui	a2,0x1
    800007ec:	4581                	li	a1,0
    800007ee:	00000097          	auipc	ra,0x0
    800007f2:	98c080e7          	jalr	-1652(ra) # 8000017a <memset>
    return pagetable;
}
    800007f6:	8526                	mv	a0,s1
    800007f8:	60e2                	ld	ra,24(sp)
    800007fa:	6442                	ld	s0,16(sp)
    800007fc:	64a2                	ld	s1,8(sp)
    800007fe:	6105                	add	sp,sp,32
    80000800:	8082                	ret

0000000080000802 <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000802:	7179                	add	sp,sp,-48
    80000804:	f406                	sd	ra,40(sp)
    80000806:	f022                	sd	s0,32(sp)
    80000808:	ec26                	sd	s1,24(sp)
    8000080a:	e84a                	sd	s2,16(sp)
    8000080c:	e44e                	sd	s3,8(sp)
    8000080e:	e052                	sd	s4,0(sp)
    80000810:	1800                	add	s0,sp,48
    char *mem;

    if (sz >= PGSIZE)
    80000812:	6785                	lui	a5,0x1
    80000814:	04f67863          	bgeu	a2,a5,80000864 <uvminit+0x62>
    80000818:	8a2a                	mv	s4,a0
    8000081a:	89ae                	mv	s3,a1
    8000081c:	84b2                	mv	s1,a2
        panic("inituvm: more than a page");
    mem = kalloc();
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	8fc080e7          	jalr	-1796(ra) # 8000011a <kalloc>
    80000826:	892a                	mv	s2,a0
    memset(mem, 0, PGSIZE);
    80000828:	6605                	lui	a2,0x1
    8000082a:	4581                	li	a1,0
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	94e080e7          	jalr	-1714(ra) # 8000017a <memset>
    mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000834:	4779                	li	a4,30
    80000836:	86ca                	mv	a3,s2
    80000838:	6605                	lui	a2,0x1
    8000083a:	4581                	li	a1,0
    8000083c:	8552                	mv	a0,s4
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	cfc080e7          	jalr	-772(ra) # 8000053a <mappages>
    memmove(mem, src, sz);
    80000846:	8626                	mv	a2,s1
    80000848:	85ce                	mv	a1,s3
    8000084a:	854a                	mv	a0,s2
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	98a080e7          	jalr	-1654(ra) # 800001d6 <memmove>
}
    80000854:	70a2                	ld	ra,40(sp)
    80000856:	7402                	ld	s0,32(sp)
    80000858:	64e2                	ld	s1,24(sp)
    8000085a:	6942                	ld	s2,16(sp)
    8000085c:	69a2                	ld	s3,8(sp)
    8000085e:	6a02                	ld	s4,0(sp)
    80000860:	6145                	add	sp,sp,48
    80000862:	8082                	ret
        panic("inituvm: more than a page");
    80000864:	00008517          	auipc	a0,0x8
    80000868:	87450513          	add	a0,a0,-1932 # 800080d8 <etext+0xd8>
    8000086c:	00005097          	auipc	ra,0x5
    80000870:	640080e7          	jalr	1600(ra) # 80005eac <panic>

0000000080000874 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000874:	1101                	add	sp,sp,-32
    80000876:	ec06                	sd	ra,24(sp)
    80000878:	e822                	sd	s0,16(sp)
    8000087a:	e426                	sd	s1,8(sp)
    8000087c:	1000                	add	s0,sp,32
    if (newsz >= oldsz)
        return oldsz;
    8000087e:	84ae                	mv	s1,a1
    if (newsz >= oldsz)
    80000880:	00b67d63          	bgeu	a2,a1,8000089a <uvmdealloc+0x26>
    80000884:	84b2                	mv	s1,a2

    if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    80000886:	6785                	lui	a5,0x1
    80000888:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000088a:	00f60733          	add	a4,a2,a5
    8000088e:	76fd                	lui	a3,0xfffff
    80000890:	8f75                	and	a4,a4,a3
    80000892:	97ae                	add	a5,a5,a1
    80000894:	8ff5                	and	a5,a5,a3
    80000896:	00f76863          	bltu	a4,a5,800008a6 <uvmdealloc+0x32>
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }

    return newsz;
}
    8000089a:	8526                	mv	a0,s1
    8000089c:	60e2                	ld	ra,24(sp)
    8000089e:	6442                	ld	s0,16(sp)
    800008a0:	64a2                	ld	s1,8(sp)
    800008a2:	6105                	add	sp,sp,32
    800008a4:	8082                	ret
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a6:	8f99                	sub	a5,a5,a4
    800008a8:	83b1                	srl	a5,a5,0xc
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008aa:	4685                	li	a3,1
    800008ac:	0007861b          	sext.w	a2,a5
    800008b0:	85ba                	mv	a1,a4
    800008b2:	00000097          	auipc	ra,0x0
    800008b6:	e4e080e7          	jalr	-434(ra) # 80000700 <uvmunmap>
    800008ba:	b7c5                	j	8000089a <uvmdealloc+0x26>

00000000800008bc <uvmalloc>:
    if (newsz < oldsz)
    800008bc:	0ab66563          	bltu	a2,a1,80000966 <uvmalloc+0xaa>
{
    800008c0:	7139                	add	sp,sp,-64
    800008c2:	fc06                	sd	ra,56(sp)
    800008c4:	f822                	sd	s0,48(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	0080                	add	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
    oldsz = PGROUNDUP(oldsz);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	77fd                	lui	a5,0xfffff
    800008da:	00f5f9b3          	and	s3,a1,a5
    for (a = oldsz; a < newsz; a += PGSIZE)
    800008de:	08c9f663          	bgeu	s3,a2,8000096a <uvmalloc+0xae>
    800008e2:	f426                	sd	s1,40(sp)
    800008e4:	f04a                	sd	s2,32(sp)
    800008e6:	894e                	mv	s2,s3
        mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
        if (mem == 0)
    800008f2:	c90d                	beqz	a0,80000924 <uvmalloc+0x68>
        memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
        if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80000900:	4779                	li	a4,30
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c30080e7          	jalr	-976(ra) # 8000053a <mappages>
    80000912:	e915                	bnez	a0,80000946 <uvmalloc+0x8a>
    for (a = oldsz; a < newsz; a += PGSIZE)
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x2c>
    return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	a819                	j	80000938 <uvmalloc+0x7c>
            uvmdealloc(pagetable, a, oldsz);
    80000924:	864e                	mv	a2,s3
    80000926:	85ca                	mv	a1,s2
    80000928:	8556                	mv	a0,s5
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	f4a080e7          	jalr	-182(ra) # 80000874 <uvmdealloc>
            return 0;
    80000932:	4501                	li	a0,0
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
}
    80000938:	70e2                	ld	ra,56(sp)
    8000093a:	7442                	ld	s0,48(sp)
    8000093c:	69e2                	ld	s3,24(sp)
    8000093e:	6a42                	ld	s4,16(sp)
    80000940:	6aa2                	ld	s5,8(sp)
    80000942:	6121                	add	sp,sp,64
    80000944:	8082                	ret
            kfree(mem);
    80000946:	8526                	mv	a0,s1
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	6d4080e7          	jalr	1748(ra) # 8000001c <kfree>
            uvmdealloc(pagetable, a, oldsz);
    80000950:	864e                	mv	a2,s3
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f1e080e7          	jalr	-226(ra) # 80000874 <uvmdealloc>
            return 0;
    8000095e:	4501                	li	a0,0
    80000960:	74a2                	ld	s1,40(sp)
    80000962:	7902                	ld	s2,32(sp)
    80000964:	bfd1                	j	80000938 <uvmalloc+0x7c>
        return oldsz;
    80000966:	852e                	mv	a0,a1
}
    80000968:	8082                	ret
    return newsz;
    8000096a:	8532                	mv	a0,a2
    8000096c:	b7f1                	j	80000938 <uvmalloc+0x7c>

000000008000096e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    8000096e:	7179                	add	sp,sp,-48
    80000970:	f406                	sd	ra,40(sp)
    80000972:	f022                	sd	s0,32(sp)
    80000974:	ec26                	sd	s1,24(sp)
    80000976:	e84a                	sd	s2,16(sp)
    80000978:	e44e                	sd	s3,8(sp)
    8000097a:	e052                	sd	s4,0(sp)
    8000097c:	1800                	add	s0,sp,48
    8000097e:	8a2a                	mv	s4,a0
    // there are 2^9 = 512 PTEs in a page table.
    for (int i = 0; i < 512; i++)
    80000980:	84aa                	mv	s1,a0
    80000982:	6905                	lui	s2,0x1
    80000984:	992a                	add	s2,s2,a0
    {
        pte_t pte = pagetable[i];
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000986:	4985                	li	s3,1
    80000988:	a829                	j	800009a2 <freewalk+0x34>
        {
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
    8000098a:	83a9                	srl	a5,a5,0xa
            freewalk((pagetable_t)child);
    8000098c:	00c79513          	sll	a0,a5,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fde080e7          	jalr	-34(ra) # 8000096e <freewalk>
            pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
    for (int i = 0; i < 512; i++)
    8000099c:	04a1                	add	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x52>
        pte_t pte = pagetable[i];
    800009a2:	609c                	ld	a5,0(s1)
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800009a4:	00f7f713          	and	a4,a5,15
    800009a8:	ff3701e3          	beq	a4,s3,8000098a <freewalk+0x1c>
        }
        else if (pte & PTE_V)
    800009ac:	8b85                	and	a5,a5,1
    800009ae:	d7fd                	beqz	a5,8000099c <freewalk+0x2e>
        {
            panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	add	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	4f4080e7          	jalr	1268(ra) # 80005eac <panic>
        }
    }
    kfree((void *)pagetable);
    800009c0:	8552                	mv	a0,s4
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	65a080e7          	jalr	1626(ra) # 8000001c <kfree>
}
    800009ca:	70a2                	ld	ra,40(sp)
    800009cc:	7402                	ld	s0,32(sp)
    800009ce:	64e2                	ld	s1,24(sp)
    800009d0:	6942                	ld	s2,16(sp)
    800009d2:	69a2                	ld	s3,8(sp)
    800009d4:	6a02                	ld	s4,0(sp)
    800009d6:	6145                	add	sp,sp,48
    800009d8:	8082                	ret

00000000800009da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	add	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	add	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
    if (sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    freewalk(pagetable);
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f84080e7          	jalr	-124(ra) # 8000096e <freewalk>
}
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	add	sp,sp,32
    800009fa:	8082                	ret
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800009fc:	6785                	lui	a5,0x1
    800009fe:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a00:	95be                	add	a1,a1,a5
    80000a02:	4685                	li	a3,1
    80000a04:	00c5d613          	srl	a2,a1,0xc
    80000a08:	4581                	li	a1,0
    80000a0a:	00000097          	auipc	ra,0x0
    80000a0e:	cf6080e7          	jalr	-778(ra) # 80000700 <uvmunmap>
    80000a12:	bfd9                	j	800009e8 <uvmfree+0xe>

0000000080000a14 <uvmcopy>:
    pte_t *pte;
    uint64 pa, i;
    uint flags;
    char *mem;

    for (i = 0; i < sz; i += PGSIZE)
    80000a14:	c679                	beqz	a2,80000ae2 <uvmcopy+0xce>
{
    80000a16:	715d                	add	sp,sp,-80
    80000a18:	e486                	sd	ra,72(sp)
    80000a1a:	e0a2                	sd	s0,64(sp)
    80000a1c:	fc26                	sd	s1,56(sp)
    80000a1e:	f84a                	sd	s2,48(sp)
    80000a20:	f44e                	sd	s3,40(sp)
    80000a22:	f052                	sd	s4,32(sp)
    80000a24:	ec56                	sd	s5,24(sp)
    80000a26:	e85a                	sd	s6,16(sp)
    80000a28:	e45e                	sd	s7,8(sp)
    80000a2a:	0880                	add	s0,sp,80
    80000a2c:	8b2a                	mv	s6,a0
    80000a2e:	8aae                	mv	s5,a1
    80000a30:	8a32                	mv	s4,a2
    for (i = 0; i < sz; i += PGSIZE)
    80000a32:	4981                	li	s3,0
    {
        if ((pte = walk(old, i, 0)) == 0)
    80000a34:	4601                	li	a2,0
    80000a36:	85ce                	mv	a1,s3
    80000a38:	855a                	mv	a0,s6
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	a18080e7          	jalr	-1512(ra) # 80000452 <walk>
    80000a42:	c531                	beqz	a0,80000a8e <uvmcopy+0x7a>
            panic("uvmcopy: pte should exist");
        if ((*pte & PTE_V) == 0)
    80000a44:	6118                	ld	a4,0(a0)
    80000a46:	00177793          	and	a5,a4,1
    80000a4a:	cbb1                	beqz	a5,80000a9e <uvmcopy+0x8a>
            panic("uvmcopy: page not present");
        pa = PTE2PA(*pte);
    80000a4c:	00a75593          	srl	a1,a4,0xa
    80000a50:	00c59b93          	sll	s7,a1,0xc
        flags = PTE_FLAGS(*pte);
    80000a54:	3ff77493          	and	s1,a4,1023
        if ((mem = kalloc()) == 0)
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	6c2080e7          	jalr	1730(ra) # 8000011a <kalloc>
    80000a60:	892a                	mv	s2,a0
    80000a62:	c939                	beqz	a0,80000ab8 <uvmcopy+0xa4>
            goto err;
        memmove(mem, (char *)pa, PGSIZE);
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85de                	mv	a1,s7
    80000a68:	fffff097          	auipc	ra,0xfffff
    80000a6c:	76e080e7          	jalr	1902(ra) # 800001d6 <memmove>
        if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0)
    80000a70:	8726                	mv	a4,s1
    80000a72:	86ca                	mv	a3,s2
    80000a74:	6605                	lui	a2,0x1
    80000a76:	85ce                	mv	a1,s3
    80000a78:	8556                	mv	a0,s5
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	ac0080e7          	jalr	-1344(ra) # 8000053a <mappages>
    80000a82:	e515                	bnez	a0,80000aae <uvmcopy+0x9a>
    for (i = 0; i < sz; i += PGSIZE)
    80000a84:	6785                	lui	a5,0x1
    80000a86:	99be                	add	s3,s3,a5
    80000a88:	fb49e6e3          	bltu	s3,s4,80000a34 <uvmcopy+0x20>
    80000a8c:	a081                	j	80000acc <uvmcopy+0xb8>
            panic("uvmcopy: pte should exist");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	67a50513          	add	a0,a0,1658 # 80008108 <etext+0x108>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	416080e7          	jalr	1046(ra) # 80005eac <panic>
            panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	add	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	406080e7          	jalr	1030(ra) # 80005eac <panic>
        {
            kfree(mem);
    80000aae:	854a                	mv	a0,s2
    80000ab0:	fffff097          	auipc	ra,0xfffff
    80000ab4:	56c080e7          	jalr	1388(ra) # 8000001c <kfree>
        }
    }
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab8:	4685                	li	a3,1
    80000aba:	00c9d613          	srl	a2,s3,0xc
    80000abe:	4581                	li	a1,0
    80000ac0:	8556                	mv	a0,s5
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	c3e080e7          	jalr	-962(ra) # 80000700 <uvmunmap>
    return -1;
    80000aca:	557d                	li	a0,-1
}
    80000acc:	60a6                	ld	ra,72(sp)
    80000ace:	6406                	ld	s0,64(sp)
    80000ad0:	74e2                	ld	s1,56(sp)
    80000ad2:	7942                	ld	s2,48(sp)
    80000ad4:	79a2                	ld	s3,40(sp)
    80000ad6:	7a02                	ld	s4,32(sp)
    80000ad8:	6ae2                	ld	s5,24(sp)
    80000ada:	6b42                	ld	s6,16(sp)
    80000adc:	6ba2                	ld	s7,8(sp)
    80000ade:	6161                	add	sp,sp,80
    80000ae0:	8082                	ret
    return 0;
    80000ae2:	4501                	li	a0,0
}
    80000ae4:	8082                	ret

0000000080000ae6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae6:	1141                	add	sp,sp,-16
    80000ae8:	e406                	sd	ra,8(sp)
    80000aea:	e022                	sd	s0,0(sp)
    80000aec:	0800                	add	s0,sp,16
    pte_t *pte;

    pte = walk(pagetable, va, 0);
    80000aee:	4601                	li	a2,0
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	962080e7          	jalr	-1694(ra) # 80000452 <walk>
    if (pte == 0)
    80000af8:	c901                	beqz	a0,80000b08 <uvmclear+0x22>
        panic("uvmclear");
    *pte &= ~PTE_U;
    80000afa:	611c                	ld	a5,0(a0)
    80000afc:	9bbd                	and	a5,a5,-17
    80000afe:	e11c                	sd	a5,0(a0)
}
    80000b00:	60a2                	ld	ra,8(sp)
    80000b02:	6402                	ld	s0,0(sp)
    80000b04:	0141                	add	sp,sp,16
    80000b06:	8082                	ret
        panic("uvmclear");
    80000b08:	00007517          	auipc	a0,0x7
    80000b0c:	64050513          	add	a0,a0,1600 # 80008148 <etext+0x148>
    80000b10:	00005097          	auipc	ra,0x5
    80000b14:	39c080e7          	jalr	924(ra) # 80005eac <panic>

0000000080000b18 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0)
    80000b18:	c6bd                	beqz	a3,80000b86 <copyout+0x6e>
{
    80000b1a:	715d                	add	sp,sp,-80
    80000b1c:	e486                	sd	ra,72(sp)
    80000b1e:	e0a2                	sd	s0,64(sp)
    80000b20:	fc26                	sd	s1,56(sp)
    80000b22:	f84a                	sd	s2,48(sp)
    80000b24:	f44e                	sd	s3,40(sp)
    80000b26:	f052                	sd	s4,32(sp)
    80000b28:	ec56                	sd	s5,24(sp)
    80000b2a:	e85a                	sd	s6,16(sp)
    80000b2c:	e45e                	sd	s7,8(sp)
    80000b2e:	e062                	sd	s8,0(sp)
    80000b30:	0880                	add	s0,sp,80
    80000b32:	8b2a                	mv	s6,a0
    80000b34:	8c2e                	mv	s8,a1
    80000b36:	8a32                	mv	s4,a2
    80000b38:	89b6                	mv	s3,a3
    {
        va0 = PGROUNDDOWN(dstva);
    80000b3a:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (dstva - va0);
    80000b3c:	6a85                	lui	s5,0x1
    80000b3e:	a015                	j	80000b62 <copyout+0x4a>
        if (n > len)
            n = len;
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b40:	9562                	add	a0,a0,s8
    80000b42:	0004861b          	sext.w	a2,s1
    80000b46:	85d2                	mv	a1,s4
    80000b48:	41250533          	sub	a0,a0,s2
    80000b4c:	fffff097          	auipc	ra,0xfffff
    80000b50:	68a080e7          	jalr	1674(ra) # 800001d6 <memmove>

        len -= n;
    80000b54:	409989b3          	sub	s3,s3,s1
        src += n;
    80000b58:	9a26                	add	s4,s4,s1
        dstva = va0 + PGSIZE;
    80000b5a:	01590c33          	add	s8,s2,s5
    while (len > 0)
    80000b5e:	02098263          	beqz	s3,80000b82 <copyout+0x6a>
        va0 = PGROUNDDOWN(dstva);
    80000b62:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    80000b66:	85ca                	mv	a1,s2
    80000b68:	855a                	mv	a0,s6
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	98e080e7          	jalr	-1650(ra) # 800004f8 <walkaddr>
        if (pa0 == 0)
    80000b72:	cd01                	beqz	a0,80000b8a <copyout+0x72>
        n = PGSIZE - (dstva - va0);
    80000b74:	418904b3          	sub	s1,s2,s8
    80000b78:	94d6                	add	s1,s1,s5
        if (n > len)
    80000b7a:	fc99f3e3          	bgeu	s3,s1,80000b40 <copyout+0x28>
    80000b7e:	84ce                	mv	s1,s3
    80000b80:	b7c1                	j	80000b40 <copyout+0x28>
    }
    return 0;
    80000b82:	4501                	li	a0,0
    80000b84:	a021                	j	80000b8c <copyout+0x74>
    80000b86:	4501                	li	a0,0
}
    80000b88:	8082                	ret
            return -1;
    80000b8a:	557d                	li	a0,-1
}
    80000b8c:	60a6                	ld	ra,72(sp)
    80000b8e:	6406                	ld	s0,64(sp)
    80000b90:	74e2                	ld	s1,56(sp)
    80000b92:	7942                	ld	s2,48(sp)
    80000b94:	79a2                	ld	s3,40(sp)
    80000b96:	7a02                	ld	s4,32(sp)
    80000b98:	6ae2                	ld	s5,24(sp)
    80000b9a:	6b42                	ld	s6,16(sp)
    80000b9c:	6ba2                	ld	s7,8(sp)
    80000b9e:	6c02                	ld	s8,0(sp)
    80000ba0:	6161                	add	sp,sp,80
    80000ba2:	8082                	ret

0000000080000ba4 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0)
    80000ba4:	caa5                	beqz	a3,80000c14 <copyin+0x70>
{
    80000ba6:	715d                	add	sp,sp,-80
    80000ba8:	e486                	sd	ra,72(sp)
    80000baa:	e0a2                	sd	s0,64(sp)
    80000bac:	fc26                	sd	s1,56(sp)
    80000bae:	f84a                	sd	s2,48(sp)
    80000bb0:	f44e                	sd	s3,40(sp)
    80000bb2:	f052                	sd	s4,32(sp)
    80000bb4:	ec56                	sd	s5,24(sp)
    80000bb6:	e85a                	sd	s6,16(sp)
    80000bb8:	e45e                	sd	s7,8(sp)
    80000bba:	e062                	sd	s8,0(sp)
    80000bbc:	0880                	add	s0,sp,80
    80000bbe:	8b2a                	mv	s6,a0
    80000bc0:	8a2e                	mv	s4,a1
    80000bc2:	8c32                	mv	s8,a2
    80000bc4:	89b6                	mv	s3,a3
    {
        va0 = PGROUNDDOWN(srcva);
    80000bc6:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    80000bc8:	6a85                	lui	s5,0x1
    80000bca:	a01d                	j	80000bf0 <copyin+0x4c>
        if (n > len)
            n = len;
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bcc:	018505b3          	add	a1,a0,s8
    80000bd0:	0004861b          	sext.w	a2,s1
    80000bd4:	412585b3          	sub	a1,a1,s2
    80000bd8:	8552                	mv	a0,s4
    80000bda:	fffff097          	auipc	ra,0xfffff
    80000bde:	5fc080e7          	jalr	1532(ra) # 800001d6 <memmove>

        len -= n;
    80000be2:	409989b3          	sub	s3,s3,s1
        dst += n;
    80000be6:	9a26                	add	s4,s4,s1
        srcva = va0 + PGSIZE;
    80000be8:	01590c33          	add	s8,s2,s5
    while (len > 0)
    80000bec:	02098263          	beqz	s3,80000c10 <copyin+0x6c>
        va0 = PGROUNDDOWN(srcva);
    80000bf0:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    80000bf4:	85ca                	mv	a1,s2
    80000bf6:	855a                	mv	a0,s6
    80000bf8:	00000097          	auipc	ra,0x0
    80000bfc:	900080e7          	jalr	-1792(ra) # 800004f8 <walkaddr>
        if (pa0 == 0)
    80000c00:	cd01                	beqz	a0,80000c18 <copyin+0x74>
        n = PGSIZE - (srcva - va0);
    80000c02:	418904b3          	sub	s1,s2,s8
    80000c06:	94d6                	add	s1,s1,s5
        if (n > len)
    80000c08:	fc99f2e3          	bgeu	s3,s1,80000bcc <copyin+0x28>
    80000c0c:	84ce                	mv	s1,s3
    80000c0e:	bf7d                	j	80000bcc <copyin+0x28>
    }
    return 0;
    80000c10:	4501                	li	a0,0
    80000c12:	a021                	j	80000c1a <copyin+0x76>
    80000c14:	4501                	li	a0,0
}
    80000c16:	8082                	ret
            return -1;
    80000c18:	557d                	li	a0,-1
}
    80000c1a:	60a6                	ld	ra,72(sp)
    80000c1c:	6406                	ld	s0,64(sp)
    80000c1e:	74e2                	ld	s1,56(sp)
    80000c20:	7942                	ld	s2,48(sp)
    80000c22:	79a2                	ld	s3,40(sp)
    80000c24:	7a02                	ld	s4,32(sp)
    80000c26:	6ae2                	ld	s5,24(sp)
    80000c28:	6b42                	ld	s6,16(sp)
    80000c2a:	6ba2                	ld	s7,8(sp)
    80000c2c:	6c02                	ld	s8,0(sp)
    80000c2e:	6161                	add	sp,sp,80
    80000c30:	8082                	ret

0000000080000c32 <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    uint64 n, va0, pa0;
    int got_null = 0;

    while (got_null == 0 && max > 0)
    80000c32:	cacd                	beqz	a3,80000ce4 <copyinstr+0xb2>
{
    80000c34:	715d                	add	sp,sp,-80
    80000c36:	e486                	sd	ra,72(sp)
    80000c38:	e0a2                	sd	s0,64(sp)
    80000c3a:	fc26                	sd	s1,56(sp)
    80000c3c:	f84a                	sd	s2,48(sp)
    80000c3e:	f44e                	sd	s3,40(sp)
    80000c40:	f052                	sd	s4,32(sp)
    80000c42:	ec56                	sd	s5,24(sp)
    80000c44:	e85a                	sd	s6,16(sp)
    80000c46:	e45e                	sd	s7,8(sp)
    80000c48:	0880                	add	s0,sp,80
    80000c4a:	8a2a                	mv	s4,a0
    80000c4c:	8b2e                	mv	s6,a1
    80000c4e:	8bb2                	mv	s7,a2
    80000c50:	8936                	mv	s2,a3
    {
        va0 = PGROUNDDOWN(srcva);
    80000c52:	7afd                	lui	s5,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    80000c54:	6985                	lui	s3,0x1
    80000c56:	a825                	j	80000c8e <copyinstr+0x5c>
        char *p = (char *)(pa0 + (srcva - va0));
        while (n > 0)
        {
            if (*p == '\0')
            {
                *dst = '\0';
    80000c58:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c5c:	4785                	li	a5,1
            dst++;
        }

        srcva = va0 + PGSIZE;
    }
    if (got_null)
    80000c5e:	37fd                	addw	a5,a5,-1
    80000c60:	0007851b          	sext.w	a0,a5
    }
    else
    {
        return -1;
    }
}
    80000c64:	60a6                	ld	ra,72(sp)
    80000c66:	6406                	ld	s0,64(sp)
    80000c68:	74e2                	ld	s1,56(sp)
    80000c6a:	7942                	ld	s2,48(sp)
    80000c6c:	79a2                	ld	s3,40(sp)
    80000c6e:	7a02                	ld	s4,32(sp)
    80000c70:	6ae2                	ld	s5,24(sp)
    80000c72:	6b42                	ld	s6,16(sp)
    80000c74:	6ba2                	ld	s7,8(sp)
    80000c76:	6161                	add	sp,sp,80
    80000c78:	8082                	ret
    80000c7a:	fff90713          	add	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000c7e:	9742                	add	a4,a4,a6
            --max;
    80000c80:	40b70933          	sub	s2,a4,a1
        srcva = va0 + PGSIZE;
    80000c84:	01348bb3          	add	s7,s1,s3
    while (got_null == 0 && max > 0)
    80000c88:	04e58663          	beq	a1,a4,80000cd4 <copyinstr+0xa2>
{
    80000c8c:	8b3e                	mv	s6,a5
        va0 = PGROUNDDOWN(srcva);
    80000c8e:	015bf4b3          	and	s1,s7,s5
        pa0 = walkaddr(pagetable, va0);
    80000c92:	85a6                	mv	a1,s1
    80000c94:	8552                	mv	a0,s4
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	862080e7          	jalr	-1950(ra) # 800004f8 <walkaddr>
        if (pa0 == 0)
    80000c9e:	cd0d                	beqz	a0,80000cd8 <copyinstr+0xa6>
        n = PGSIZE - (srcva - va0);
    80000ca0:	417486b3          	sub	a3,s1,s7
    80000ca4:	96ce                	add	a3,a3,s3
        if (n > max)
    80000ca6:	00d97363          	bgeu	s2,a3,80000cac <copyinstr+0x7a>
    80000caa:	86ca                	mv	a3,s2
        char *p = (char *)(pa0 + (srcva - va0));
    80000cac:	955e                	add	a0,a0,s7
    80000cae:	8d05                	sub	a0,a0,s1
        while (n > 0)
    80000cb0:	c695                	beqz	a3,80000cdc <copyinstr+0xaa>
    80000cb2:	87da                	mv	a5,s6
    80000cb4:	885a                	mv	a6,s6
            if (*p == '\0')
    80000cb6:	41650633          	sub	a2,a0,s6
        while (n > 0)
    80000cba:	96da                	add	a3,a3,s6
    80000cbc:	85be                	mv	a1,a5
            if (*p == '\0')
    80000cbe:	00f60733          	add	a4,a2,a5
    80000cc2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cc6:	db49                	beqz	a4,80000c58 <copyinstr+0x26>
                *dst = *p;
    80000cc8:	00e78023          	sb	a4,0(a5)
            dst++;
    80000ccc:	0785                	add	a5,a5,1
        while (n > 0)
    80000cce:	fed797e3          	bne	a5,a3,80000cbc <copyinstr+0x8a>
    80000cd2:	b765                	j	80000c7a <copyinstr+0x48>
    80000cd4:	4781                	li	a5,0
    80000cd6:	b761                	j	80000c5e <copyinstr+0x2c>
            return -1;
    80000cd8:	557d                	li	a0,-1
    80000cda:	b769                	j	80000c64 <copyinstr+0x32>
        srcva = va0 + PGSIZE;
    80000cdc:	6b85                	lui	s7,0x1
    80000cde:	9ba6                	add	s7,s7,s1
    80000ce0:	87da                	mv	a5,s6
    80000ce2:	b76d                	j	80000c8c <copyinstr+0x5a>
    int got_null = 0;
    80000ce4:	4781                	li	a5,0
    if (got_null)
    80000ce6:	37fd                	addw	a5,a5,-1
    80000ce8:	0007851b          	sext.w	a0,a5
}
    80000cec:	8082                	ret

0000000080000cee <vmprint>:

// Look up a virtual address in the process page table.
void vmprint(pagetable_t pagetable, int depth)
{
    if (depth < 0 || depth > 2)
    80000cee:	4789                	li	a5,2
    80000cf0:	0cb7e163          	bltu	a5,a1,80000db2 <vmprint+0xc4>
{
    80000cf4:	7159                	add	sp,sp,-112
    80000cf6:	f486                	sd	ra,104(sp)
    80000cf8:	f0a2                	sd	s0,96(sp)
    80000cfa:	eca6                	sd	s1,88(sp)
    80000cfc:	e8ca                	sd	s2,80(sp)
    80000cfe:	e4ce                	sd	s3,72(sp)
    80000d00:	e0d2                	sd	s4,64(sp)
    80000d02:	fc56                	sd	s5,56(sp)
    80000d04:	f85a                	sd	s6,48(sp)
    80000d06:	f45e                	sd	s7,40(sp)
    80000d08:	1880                	add	s0,sp,112
    80000d0a:	84aa                	mv	s1,a0
    80000d0c:	8a2e                	mv	s4,a1
    {
        return;
    }
    char *prefix[] = {
    80000d0e:	00007797          	auipc	a5,0x7
    80000d12:	44a78793          	add	a5,a5,1098 # 80008158 <etext+0x158>
    80000d16:	f8f43c23          	sd	a5,-104(s0)
    80000d1a:	00007797          	auipc	a5,0x7
    80000d1e:	44678793          	add	a5,a5,1094 # 80008160 <etext+0x160>
    80000d22:	faf43023          	sd	a5,-96(s0)
    80000d26:	00007797          	auipc	a5,0x7
    80000d2a:	44278793          	add	a5,a5,1090 # 80008168 <etext+0x168>
    80000d2e:	faf43423          	sd	a5,-88(s0)
        " ..",
        " .. ..",
        " .. .. .."};
    if (!depth)
    80000d32:	c185                	beqz	a1,80000d52 <vmprint+0x64>
{
    80000d34:	4901                	li	s2,0
        pte_t pte = pagetable[i];
        if (pte & PTE_V)
        {
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
            printf("%s%d: pte %p pa %p\n", prefix[depth], i, pte, child);
    80000d36:	003a1b13          	sll	s6,s4,0x3
    80000d3a:	fb0b0793          	add	a5,s6,-80 # fb0 <_entry-0x7ffff050>
    80000d3e:	00878b33          	add	s6,a5,s0
    80000d42:	00007b97          	auipc	s7,0x7
    80000d46:	446b8b93          	add	s7,s7,1094 # 80008188 <etext+0x188>
            vmprint((pagetable_t)child, depth + 1);
    80000d4a:	2a05                	addw	s4,s4,1
    for (int i = 0; i < 512; ++i)
    80000d4c:	20000993          	li	s3,512
    80000d50:	a839                	j	80000d6e <vmprint+0x80>
        printf("page table %p\n", pagetable);
    80000d52:	85aa                	mv	a1,a0
    80000d54:	00007517          	auipc	a0,0x7
    80000d58:	42450513          	add	a0,a0,1060 # 80008178 <etext+0x178>
    80000d5c:	00005097          	auipc	ra,0x5
    80000d60:	19a080e7          	jalr	410(ra) # 80005ef6 <printf>
    80000d64:	bfc1                	j	80000d34 <vmprint+0x46>
    for (int i = 0; i < 512; ++i)
    80000d66:	2905                	addw	s2,s2,1
    80000d68:	04a1                	add	s1,s1,8
    80000d6a:	03390963          	beq	s2,s3,80000d9c <vmprint+0xae>
        pte_t pte = pagetable[i];
    80000d6e:	6094                	ld	a3,0(s1)
        if (pte & PTE_V)
    80000d70:	0016f793          	and	a5,a3,1
    80000d74:	dbed                	beqz	a5,80000d66 <vmprint+0x78>
            uint64 child = PTE2PA(pte);
    80000d76:	00a6da93          	srl	s5,a3,0xa
    80000d7a:	0ab2                	sll	s5,s5,0xc
            printf("%s%d: pte %p pa %p\n", prefix[depth], i, pte, child);
    80000d7c:	8756                	mv	a4,s5
    80000d7e:	864a                	mv	a2,s2
    80000d80:	fe8b3583          	ld	a1,-24(s6)
    80000d84:	855e                	mv	a0,s7
    80000d86:	00005097          	auipc	ra,0x5
    80000d8a:	170080e7          	jalr	368(ra) # 80005ef6 <printf>
            vmprint((pagetable_t)child, depth + 1);
    80000d8e:	85d2                	mv	a1,s4
    80000d90:	8556                	mv	a0,s5
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	f5c080e7          	jalr	-164(ra) # 80000cee <vmprint>
    80000d9a:	b7f1                	j	80000d66 <vmprint+0x78>
        }
    }
}
    80000d9c:	70a6                	ld	ra,104(sp)
    80000d9e:	7406                	ld	s0,96(sp)
    80000da0:	64e6                	ld	s1,88(sp)
    80000da2:	6946                	ld	s2,80(sp)
    80000da4:	69a6                	ld	s3,72(sp)
    80000da6:	6a06                	ld	s4,64(sp)
    80000da8:	7ae2                	ld	s5,56(sp)
    80000daa:	7b42                	ld	s6,48(sp)
    80000dac:	7ba2                	ld	s7,40(sp)
    80000dae:	6165                	add	sp,sp,112
    80000db0:	8082                	ret
    80000db2:	8082                	ret

0000000080000db4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000db4:	7139                	add	sp,sp,-64
    80000db6:	fc06                	sd	ra,56(sp)
    80000db8:	f822                	sd	s0,48(sp)
    80000dba:	f426                	sd	s1,40(sp)
    80000dbc:	f04a                	sd	s2,32(sp)
    80000dbe:	ec4e                	sd	s3,24(sp)
    80000dc0:	e852                	sd	s4,16(sp)
    80000dc2:	e456                	sd	s5,8(sp)
    80000dc4:	e05a                	sd	s6,0(sp)
    80000dc6:	0080                	add	s0,sp,64
    80000dc8:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80000dca:	00008497          	auipc	s1,0x8
    80000dce:	6b648493          	add	s1,s1,1718 # 80009480 <proc>
    {
        char *pa = kalloc();
        if (pa == 0)
            panic("kalloc");
        uint64 va = KSTACK((int)(p - proc));
    80000dd2:	8b26                	mv	s6,s1
    80000dd4:	ff4df937          	lui	s2,0xff4df
    80000dd8:	9bd90913          	add	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b877d>
    80000ddc:	0936                	sll	s2,s2,0xd
    80000dde:	6f590913          	add	s2,s2,1781
    80000de2:	0936                	sll	s2,s2,0xd
    80000de4:	bd390913          	add	s2,s2,-1069
    80000de8:	0932                	sll	s2,s2,0xc
    80000dea:	7a790913          	add	s2,s2,1959
    80000dee:	010009b7          	lui	s3,0x1000
    80000df2:	19fd                	add	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000df4:	09ba                	sll	s3,s3,0xe
    for (p = proc; p < &proc[NPROC]; p++)
    80000df6:	0000ea97          	auipc	s5,0xe
    80000dfa:	28aa8a93          	add	s5,s5,650 # 8000f080 <tickslock>
        char *pa = kalloc();
    80000dfe:	fffff097          	auipc	ra,0xfffff
    80000e02:	31c080e7          	jalr	796(ra) # 8000011a <kalloc>
    80000e06:	862a                	mv	a2,a0
        if (pa == 0)
    80000e08:	cd1d                	beqz	a0,80000e46 <proc_mapstacks+0x92>
        uint64 va = KSTACK((int)(p - proc));
    80000e0a:	416485b3          	sub	a1,s1,s6
    80000e0e:	8591                	sra	a1,a1,0x4
    80000e10:	032585b3          	mul	a1,a1,s2
    80000e14:	00d5959b          	sllw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e18:	4719                	li	a4,6
    80000e1a:	6685                	lui	a3,0x1
    80000e1c:	40b985b3          	sub	a1,s3,a1
    80000e20:	8552                	mv	a0,s4
    80000e22:	fffff097          	auipc	ra,0xfffff
    80000e26:	7b8080e7          	jalr	1976(ra) # 800005da <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80000e2a:	17048493          	add	s1,s1,368
    80000e2e:	fd5498e3          	bne	s1,s5,80000dfe <proc_mapstacks+0x4a>
    }
}
    80000e32:	70e2                	ld	ra,56(sp)
    80000e34:	7442                	ld	s0,48(sp)
    80000e36:	74a2                	ld	s1,40(sp)
    80000e38:	7902                	ld	s2,32(sp)
    80000e3a:	69e2                	ld	s3,24(sp)
    80000e3c:	6a42                	ld	s4,16(sp)
    80000e3e:	6aa2                	ld	s5,8(sp)
    80000e40:	6b02                	ld	s6,0(sp)
    80000e42:	6121                	add	sp,sp,64
    80000e44:	8082                	ret
            panic("kalloc");
    80000e46:	00007517          	auipc	a0,0x7
    80000e4a:	35a50513          	add	a0,a0,858 # 800081a0 <etext+0x1a0>
    80000e4e:	00005097          	auipc	ra,0x5
    80000e52:	05e080e7          	jalr	94(ra) # 80005eac <panic>

0000000080000e56 <procinit>:

// initialize the proc table at boot time.
void procinit(void)
{
    80000e56:	7139                	add	sp,sp,-64
    80000e58:	fc06                	sd	ra,56(sp)
    80000e5a:	f822                	sd	s0,48(sp)
    80000e5c:	f426                	sd	s1,40(sp)
    80000e5e:	f04a                	sd	s2,32(sp)
    80000e60:	ec4e                	sd	s3,24(sp)
    80000e62:	e852                	sd	s4,16(sp)
    80000e64:	e456                	sd	s5,8(sp)
    80000e66:	e05a                	sd	s6,0(sp)
    80000e68:	0080                	add	s0,sp,64
    struct proc *p;

    initlock(&pid_lock, "nextpid");
    80000e6a:	00007597          	auipc	a1,0x7
    80000e6e:	33e58593          	add	a1,a1,830 # 800081a8 <etext+0x1a8>
    80000e72:	00008517          	auipc	a0,0x8
    80000e76:	1de50513          	add	a0,a0,478 # 80009050 <pid_lock>
    80000e7a:	00005097          	auipc	ra,0x5
    80000e7e:	51c080e7          	jalr	1308(ra) # 80006396 <initlock>
    initlock(&wait_lock, "wait_lock");
    80000e82:	00007597          	auipc	a1,0x7
    80000e86:	32e58593          	add	a1,a1,814 # 800081b0 <etext+0x1b0>
    80000e8a:	00008517          	auipc	a0,0x8
    80000e8e:	1de50513          	add	a0,a0,478 # 80009068 <wait_lock>
    80000e92:	00005097          	auipc	ra,0x5
    80000e96:	504080e7          	jalr	1284(ra) # 80006396 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80000e9a:	00008497          	auipc	s1,0x8
    80000e9e:	5e648493          	add	s1,s1,1510 # 80009480 <proc>
    {
        initlock(&p->lock, "proc");
    80000ea2:	00007b17          	auipc	s6,0x7
    80000ea6:	31eb0b13          	add	s6,s6,798 # 800081c0 <etext+0x1c0>
        p->kstack = KSTACK((int)(p - proc));
    80000eaa:	8aa6                	mv	s5,s1
    80000eac:	ff4df937          	lui	s2,0xff4df
    80000eb0:	9bd90913          	add	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b877d>
    80000eb4:	0936                	sll	s2,s2,0xd
    80000eb6:	6f590913          	add	s2,s2,1781
    80000eba:	0936                	sll	s2,s2,0xd
    80000ebc:	bd390913          	add	s2,s2,-1069
    80000ec0:	0932                	sll	s2,s2,0xc
    80000ec2:	7a790913          	add	s2,s2,1959
    80000ec6:	010009b7          	lui	s3,0x1000
    80000eca:	19fd                	add	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000ecc:	09ba                	sll	s3,s3,0xe
    for (p = proc; p < &proc[NPROC]; p++)
    80000ece:	0000ea17          	auipc	s4,0xe
    80000ed2:	1b2a0a13          	add	s4,s4,434 # 8000f080 <tickslock>
        initlock(&p->lock, "proc");
    80000ed6:	85da                	mv	a1,s6
    80000ed8:	8526                	mv	a0,s1
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	4bc080e7          	jalr	1212(ra) # 80006396 <initlock>
        p->kstack = KSTACK((int)(p - proc));
    80000ee2:	415487b3          	sub	a5,s1,s5
    80000ee6:	8791                	sra	a5,a5,0x4
    80000ee8:	032787b3          	mul	a5,a5,s2
    80000eec:	00d7979b          	sllw	a5,a5,0xd
    80000ef0:	40f987b3          	sub	a5,s3,a5
    80000ef4:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80000ef6:	17048493          	add	s1,s1,368
    80000efa:	fd449ee3          	bne	s1,s4,80000ed6 <procinit+0x80>
    }
}
    80000efe:	70e2                	ld	ra,56(sp)
    80000f00:	7442                	ld	s0,48(sp)
    80000f02:	74a2                	ld	s1,40(sp)
    80000f04:	7902                	ld	s2,32(sp)
    80000f06:	69e2                	ld	s3,24(sp)
    80000f08:	6a42                	ld	s4,16(sp)
    80000f0a:	6aa2                	ld	s5,8(sp)
    80000f0c:	6b02                	ld	s6,0(sp)
    80000f0e:	6121                	add	sp,sp,64
    80000f10:	8082                	ret

0000000080000f12 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000f12:	1141                	add	sp,sp,-16
    80000f14:	e422                	sd	s0,8(sp)
    80000f16:	0800                	add	s0,sp,16
    asm volatile("mv %0, tp" : "=r"(x));
    80000f18:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80000f1a:	2501                	sext.w	a0,a0
    80000f1c:	6422                	ld	s0,8(sp)
    80000f1e:	0141                	add	sp,sp,16
    80000f20:	8082                	ret

0000000080000f22 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000f22:	1141                	add	sp,sp,-16
    80000f24:	e422                	sd	s0,8(sp)
    80000f26:	0800                	add	s0,sp,16
    80000f28:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu *c = &cpus[id];
    80000f2a:	2781                	sext.w	a5,a5
    80000f2c:	079e                	sll	a5,a5,0x7
    return c;
}
    80000f2e:	00008517          	auipc	a0,0x8
    80000f32:	15250513          	add	a0,a0,338 # 80009080 <cpus>
    80000f36:	953e                	add	a0,a0,a5
    80000f38:	6422                	ld	s0,8(sp)
    80000f3a:	0141                	add	sp,sp,16
    80000f3c:	8082                	ret

0000000080000f3e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000f3e:	1101                	add	sp,sp,-32
    80000f40:	ec06                	sd	ra,24(sp)
    80000f42:	e822                	sd	s0,16(sp)
    80000f44:	e426                	sd	s1,8(sp)
    80000f46:	1000                	add	s0,sp,32
    push_off();
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	492080e7          	jalr	1170(ra) # 800063da <push_off>
    80000f50:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000f52:	2781                	sext.w	a5,a5
    80000f54:	079e                	sll	a5,a5,0x7
    80000f56:	00008717          	auipc	a4,0x8
    80000f5a:	0fa70713          	add	a4,a4,250 # 80009050 <pid_lock>
    80000f5e:	97ba                	add	a5,a5,a4
    80000f60:	7b84                	ld	s1,48(a5)
    pop_off();
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	518080e7          	jalr	1304(ra) # 8000647a <pop_off>
    return p;
}
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	60e2                	ld	ra,24(sp)
    80000f6e:	6442                	ld	s0,16(sp)
    80000f70:	64a2                	ld	s1,8(sp)
    80000f72:	6105                	add	sp,sp,32
    80000f74:	8082                	ret

0000000080000f76 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000f76:	1141                	add	sp,sp,-16
    80000f78:	e406                	sd	ra,8(sp)
    80000f7a:	e022                	sd	s0,0(sp)
    80000f7c:	0800                	add	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80000f7e:	00000097          	auipc	ra,0x0
    80000f82:	fc0080e7          	jalr	-64(ra) # 80000f3e <myproc>
    80000f86:	00005097          	auipc	ra,0x5
    80000f8a:	554080e7          	jalr	1364(ra) # 800064da <release>

    if (first)
    80000f8e:	00008797          	auipc	a5,0x8
    80000f92:	9127a783          	lw	a5,-1774(a5) # 800088a0 <first.1>
    80000f96:	eb89                	bnez	a5,80000fa8 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80000f98:	00001097          	auipc	ra,0x1
    80000f9c:	cb2080e7          	jalr	-846(ra) # 80001c4a <usertrapret>
}
    80000fa0:	60a2                	ld	ra,8(sp)
    80000fa2:	6402                	ld	s0,0(sp)
    80000fa4:	0141                	add	sp,sp,16
    80000fa6:	8082                	ret
        first = 0;
    80000fa8:	00008797          	auipc	a5,0x8
    80000fac:	8e07ac23          	sw	zero,-1800(a5) # 800088a0 <first.1>
        fsinit(ROOTDEV);
    80000fb0:	4505                	li	a0,1
    80000fb2:	00002097          	auipc	ra,0x2
    80000fb6:	afe080e7          	jalr	-1282(ra) # 80002ab0 <fsinit>
    80000fba:	bff9                	j	80000f98 <forkret+0x22>

0000000080000fbc <allocpid>:
{
    80000fbc:	1101                	add	sp,sp,-32
    80000fbe:	ec06                	sd	ra,24(sp)
    80000fc0:	e822                	sd	s0,16(sp)
    80000fc2:	e426                	sd	s1,8(sp)
    80000fc4:	e04a                	sd	s2,0(sp)
    80000fc6:	1000                	add	s0,sp,32
    acquire(&pid_lock);
    80000fc8:	00008917          	auipc	s2,0x8
    80000fcc:	08890913          	add	s2,s2,136 # 80009050 <pid_lock>
    80000fd0:	854a                	mv	a0,s2
    80000fd2:	00005097          	auipc	ra,0x5
    80000fd6:	454080e7          	jalr	1108(ra) # 80006426 <acquire>
    pid = nextpid;
    80000fda:	00008797          	auipc	a5,0x8
    80000fde:	8ca78793          	add	a5,a5,-1846 # 800088a4 <nextpid>
    80000fe2:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000fe4:	0014871b          	addw	a4,s1,1
    80000fe8:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000fea:	854a                	mv	a0,s2
    80000fec:	00005097          	auipc	ra,0x5
    80000ff0:	4ee080e7          	jalr	1262(ra) # 800064da <release>
}
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	60e2                	ld	ra,24(sp)
    80000ff8:	6442                	ld	s0,16(sp)
    80000ffa:	64a2                	ld	s1,8(sp)
    80000ffc:	6902                	ld	s2,0(sp)
    80000ffe:	6105                	add	sp,sp,32
    80001000:	8082                	ret

0000000080001002 <proc_pagetable>:
{
    80001002:	1101                	add	sp,sp,-32
    80001004:	ec06                	sd	ra,24(sp)
    80001006:	e822                	sd	s0,16(sp)
    80001008:	e426                	sd	s1,8(sp)
    8000100a:	e04a                	sd	s2,0(sp)
    8000100c:	1000                	add	s0,sp,32
    8000100e:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001010:	fffff097          	auipc	ra,0xfffff
    80001014:	7c4080e7          	jalr	1988(ra) # 800007d4 <uvmcreate>
    80001018:	84aa                	mv	s1,a0
    if (pagetable == 0)
    8000101a:	cd39                	beqz	a0,80001078 <proc_pagetable+0x76>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000101c:	4729                	li	a4,10
    8000101e:	00006697          	auipc	a3,0x6
    80001022:	fe268693          	add	a3,a3,-30 # 80007000 <_trampoline>
    80001026:	6605                	lui	a2,0x1
    80001028:	040005b7          	lui	a1,0x4000
    8000102c:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000102e:	05b2                	sll	a1,a1,0xc
    80001030:	fffff097          	auipc	ra,0xfffff
    80001034:	50a080e7          	jalr	1290(ra) # 8000053a <mappages>
    80001038:	04054763          	bltz	a0,80001086 <proc_pagetable+0x84>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    8000103c:	4719                	li	a4,6
    8000103e:	05893683          	ld	a3,88(s2)
    80001042:	6605                	lui	a2,0x1
    80001044:	020005b7          	lui	a1,0x2000
    80001048:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000104a:	05b6                	sll	a1,a1,0xd
    8000104c:	8526                	mv	a0,s1
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	4ec080e7          	jalr	1260(ra) # 8000053a <mappages>
    80001056:	04054063          	bltz	a0,80001096 <proc_pagetable+0x94>
    if (mappages(pagetable, USYSCALL, PGSIZE,
    8000105a:	4749                	li	a4,18
    8000105c:	16893683          	ld	a3,360(s2)
    80001060:	6605                	lui	a2,0x1
    80001062:	040005b7          	lui	a1,0x4000
    80001066:	15f5                	add	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001068:	05b2                	sll	a1,a1,0xc
    8000106a:	8526                	mv	a0,s1
    8000106c:	fffff097          	auipc	ra,0xfffff
    80001070:	4ce080e7          	jalr	1230(ra) # 8000053a <mappages>
    80001074:	04054463          	bltz	a0,800010bc <proc_pagetable+0xba>
}
    80001078:	8526                	mv	a0,s1
    8000107a:	60e2                	ld	ra,24(sp)
    8000107c:	6442                	ld	s0,16(sp)
    8000107e:	64a2                	ld	s1,8(sp)
    80001080:	6902                	ld	s2,0(sp)
    80001082:	6105                	add	sp,sp,32
    80001084:	8082                	ret
        uvmfree(pagetable, 0);
    80001086:	4581                	li	a1,0
    80001088:	8526                	mv	a0,s1
    8000108a:	00000097          	auipc	ra,0x0
    8000108e:	950080e7          	jalr	-1712(ra) # 800009da <uvmfree>
        return 0;
    80001092:	4481                	li	s1,0
    80001094:	b7d5                	j	80001078 <proc_pagetable+0x76>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001096:	4681                	li	a3,0
    80001098:	4605                	li	a2,1
    8000109a:	040005b7          	lui	a1,0x4000
    8000109e:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010a0:	05b2                	sll	a1,a1,0xc
    800010a2:	8526                	mv	a0,s1
    800010a4:	fffff097          	auipc	ra,0xfffff
    800010a8:	65c080e7          	jalr	1628(ra) # 80000700 <uvmunmap>
        uvmfree(pagetable, 0);
    800010ac:	4581                	li	a1,0
    800010ae:	8526                	mv	a0,s1
    800010b0:	00000097          	auipc	ra,0x0
    800010b4:	92a080e7          	jalr	-1750(ra) # 800009da <uvmfree>
        return 0;
    800010b8:	4481                	li	s1,0
    800010ba:	bf7d                	j	80001078 <proc_pagetable+0x76>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010bc:	4681                	li	a3,0
    800010be:	4605                	li	a2,1
    800010c0:	040005b7          	lui	a1,0x4000
    800010c4:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010c6:	05b2                	sll	a1,a1,0xc
    800010c8:	8526                	mv	a0,s1
    800010ca:	fffff097          	auipc	ra,0xfffff
    800010ce:	636080e7          	jalr	1590(ra) # 80000700 <uvmunmap>
        uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010d2:	4681                	li	a3,0
    800010d4:	4605                	li	a2,1
    800010d6:	020005b7          	lui	a1,0x2000
    800010da:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010dc:	05b6                	sll	a1,a1,0xd
    800010de:	8526                	mv	a0,s1
    800010e0:	fffff097          	auipc	ra,0xfffff
    800010e4:	620080e7          	jalr	1568(ra) # 80000700 <uvmunmap>
        uvmfree(pagetable, 0);
    800010e8:	4581                	li	a1,0
    800010ea:	8526                	mv	a0,s1
    800010ec:	00000097          	auipc	ra,0x0
    800010f0:	8ee080e7          	jalr	-1810(ra) # 800009da <uvmfree>
        return 0;
    800010f4:	4481                	li	s1,0
    800010f6:	b749                	j	80001078 <proc_pagetable+0x76>

00000000800010f8 <proc_freepagetable>:
{
    800010f8:	1101                	add	sp,sp,-32
    800010fa:	ec06                	sd	ra,24(sp)
    800010fc:	e822                	sd	s0,16(sp)
    800010fe:	e426                	sd	s1,8(sp)
    80001100:	e04a                	sd	s2,0(sp)
    80001102:	1000                	add	s0,sp,32
    80001104:	84aa                	mv	s1,a0
    80001106:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001108:	4681                	li	a3,0
    8000110a:	4605                	li	a2,1
    8000110c:	040005b7          	lui	a1,0x4000
    80001110:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001112:	05b2                	sll	a1,a1,0xc
    80001114:	fffff097          	auipc	ra,0xfffff
    80001118:	5ec080e7          	jalr	1516(ra) # 80000700 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000111c:	4681                	li	a3,0
    8000111e:	4605                	li	a2,1
    80001120:	020005b7          	lui	a1,0x2000
    80001124:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001126:	05b6                	sll	a1,a1,0xd
    80001128:	8526                	mv	a0,s1
    8000112a:	fffff097          	auipc	ra,0xfffff
    8000112e:	5d6080e7          	jalr	1494(ra) # 80000700 <uvmunmap>
    uvmunmap(pagetable, USYSCALL, 1, 0);
    80001132:	4681                	li	a3,0
    80001134:	4605                	li	a2,1
    80001136:	040005b7          	lui	a1,0x4000
    8000113a:	15f5                	add	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    8000113c:	05b2                	sll	a1,a1,0xc
    8000113e:	8526                	mv	a0,s1
    80001140:	fffff097          	auipc	ra,0xfffff
    80001144:	5c0080e7          	jalr	1472(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, sz);
    80001148:	85ca                	mv	a1,s2
    8000114a:	8526                	mv	a0,s1
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	88e080e7          	jalr	-1906(ra) # 800009da <uvmfree>
}
    80001154:	60e2                	ld	ra,24(sp)
    80001156:	6442                	ld	s0,16(sp)
    80001158:	64a2                	ld	s1,8(sp)
    8000115a:	6902                	ld	s2,0(sp)
    8000115c:	6105                	add	sp,sp,32
    8000115e:	8082                	ret

0000000080001160 <freeproc>:
{
    80001160:	1101                	add	sp,sp,-32
    80001162:	ec06                	sd	ra,24(sp)
    80001164:	e822                	sd	s0,16(sp)
    80001166:	e426                	sd	s1,8(sp)
    80001168:	1000                	add	s0,sp,32
    8000116a:	84aa                	mv	s1,a0
    if (p->trapframe)
    8000116c:	6d28                	ld	a0,88(a0)
    8000116e:	c509                	beqz	a0,80001178 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001170:	fffff097          	auipc	ra,0xfffff
    80001174:	eac080e7          	jalr	-340(ra) # 8000001c <kfree>
    p->trapframe = 0;
    80001178:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    8000117c:	68a8                	ld	a0,80(s1)
    8000117e:	c511                	beqz	a0,8000118a <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001180:	64ac                	ld	a1,72(s1)
    80001182:	00000097          	auipc	ra,0x0
    80001186:	f76080e7          	jalr	-138(ra) # 800010f8 <proc_freepagetable>
    p->pagetable = 0;
    8000118a:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    8000118e:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001192:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001196:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    8000119a:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    8000119e:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    800011a2:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    800011a6:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    800011aa:	0004ac23          	sw	zero,24(s1)
}
    800011ae:	60e2                	ld	ra,24(sp)
    800011b0:	6442                	ld	s0,16(sp)
    800011b2:	64a2                	ld	s1,8(sp)
    800011b4:	6105                	add	sp,sp,32
    800011b6:	8082                	ret

00000000800011b8 <allocproc>:
{
    800011b8:	1101                	add	sp,sp,-32
    800011ba:	ec06                	sd	ra,24(sp)
    800011bc:	e822                	sd	s0,16(sp)
    800011be:	e426                	sd	s1,8(sp)
    800011c0:	e04a                	sd	s2,0(sp)
    800011c2:	1000                	add	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    800011c4:	00008497          	auipc	s1,0x8
    800011c8:	2bc48493          	add	s1,s1,700 # 80009480 <proc>
    800011cc:	0000e917          	auipc	s2,0xe
    800011d0:	eb490913          	add	s2,s2,-332 # 8000f080 <tickslock>
        acquire(&p->lock);
    800011d4:	8526                	mv	a0,s1
    800011d6:	00005097          	auipc	ra,0x5
    800011da:	250080e7          	jalr	592(ra) # 80006426 <acquire>
        if (p->state == UNUSED)
    800011de:	4c9c                	lw	a5,24(s1)
    800011e0:	cf81                	beqz	a5,800011f8 <allocproc+0x40>
            release(&p->lock);
    800011e2:	8526                	mv	a0,s1
    800011e4:	00005097          	auipc	ra,0x5
    800011e8:	2f6080e7          	jalr	758(ra) # 800064da <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800011ec:	17048493          	add	s1,s1,368
    800011f0:	ff2492e3          	bne	s1,s2,800011d4 <allocproc+0x1c>
    return 0;
    800011f4:	4481                	li	s1,0
    800011f6:	a09d                	j	8000125c <allocproc+0xa4>
    p->pid = allocpid();
    800011f8:	00000097          	auipc	ra,0x0
    800011fc:	dc4080e7          	jalr	-572(ra) # 80000fbc <allocpid>
    80001200:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001202:	4785                	li	a5,1
    80001204:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001206:	fffff097          	auipc	ra,0xfffff
    8000120a:	f14080e7          	jalr	-236(ra) # 8000011a <kalloc>
    8000120e:	892a                	mv	s2,a0
    80001210:	eca8                	sd	a0,88(s1)
    80001212:	cd21                	beqz	a0,8000126a <allocproc+0xb2>
    if ((p->usyscall = (struct usyscall *)kalloc()) == 0)
    80001214:	fffff097          	auipc	ra,0xfffff
    80001218:	f06080e7          	jalr	-250(ra) # 8000011a <kalloc>
    8000121c:	892a                	mv	s2,a0
    8000121e:	16a4b423          	sd	a0,360(s1)
    80001222:	c125                	beqz	a0,80001282 <allocproc+0xca>
    p->usyscall->pid = p->pid;
    80001224:	589c                	lw	a5,48(s1)
    80001226:	c11c                	sw	a5,0(a0)
    p->pagetable = proc_pagetable(p);
    80001228:	8526                	mv	a0,s1
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	dd8080e7          	jalr	-552(ra) # 80001002 <proc_pagetable>
    80001232:	892a                	mv	s2,a0
    80001234:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001236:	c135                	beqz	a0,8000129a <allocproc+0xe2>
    memset(&p->context, 0, sizeof(p->context));
    80001238:	07000613          	li	a2,112
    8000123c:	4581                	li	a1,0
    8000123e:	06048513          	add	a0,s1,96
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	f38080e7          	jalr	-200(ra) # 8000017a <memset>
    p->context.ra = (uint64)forkret;
    8000124a:	00000797          	auipc	a5,0x0
    8000124e:	d2c78793          	add	a5,a5,-724 # 80000f76 <forkret>
    80001252:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001254:	60bc                	ld	a5,64(s1)
    80001256:	6705                	lui	a4,0x1
    80001258:	97ba                	add	a5,a5,a4
    8000125a:	f4bc                	sd	a5,104(s1)
}
    8000125c:	8526                	mv	a0,s1
    8000125e:	60e2                	ld	ra,24(sp)
    80001260:	6442                	ld	s0,16(sp)
    80001262:	64a2                	ld	s1,8(sp)
    80001264:	6902                	ld	s2,0(sp)
    80001266:	6105                	add	sp,sp,32
    80001268:	8082                	ret
        freeproc(p);
    8000126a:	8526                	mv	a0,s1
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	ef4080e7          	jalr	-268(ra) # 80001160 <freeproc>
        release(&p->lock);
    80001274:	8526                	mv	a0,s1
    80001276:	00005097          	auipc	ra,0x5
    8000127a:	264080e7          	jalr	612(ra) # 800064da <release>
        return 0;
    8000127e:	84ca                	mv	s1,s2
    80001280:	bff1                	j	8000125c <allocproc+0xa4>
        freeproc(p);
    80001282:	8526                	mv	a0,s1
    80001284:	00000097          	auipc	ra,0x0
    80001288:	edc080e7          	jalr	-292(ra) # 80001160 <freeproc>
        release(&p->lock);
    8000128c:	8526                	mv	a0,s1
    8000128e:	00005097          	auipc	ra,0x5
    80001292:	24c080e7          	jalr	588(ra) # 800064da <release>
        return 0;
    80001296:	84ca                	mv	s1,s2
    80001298:	b7d1                	j	8000125c <allocproc+0xa4>
        freeproc(p);
    8000129a:	8526                	mv	a0,s1
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	ec4080e7          	jalr	-316(ra) # 80001160 <freeproc>
        release(&p->lock);
    800012a4:	8526                	mv	a0,s1
    800012a6:	00005097          	auipc	ra,0x5
    800012aa:	234080e7          	jalr	564(ra) # 800064da <release>
        return 0;
    800012ae:	84ca                	mv	s1,s2
    800012b0:	b775                	j	8000125c <allocproc+0xa4>

00000000800012b2 <userinit>:
{
    800012b2:	1101                	add	sp,sp,-32
    800012b4:	ec06                	sd	ra,24(sp)
    800012b6:	e822                	sd	s0,16(sp)
    800012b8:	e426                	sd	s1,8(sp)
    800012ba:	1000                	add	s0,sp,32
    p = allocproc();
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	efc080e7          	jalr	-260(ra) # 800011b8 <allocproc>
    800012c4:	84aa                	mv	s1,a0
    initproc = p;
    800012c6:	00008797          	auipc	a5,0x8
    800012ca:	d4a7b523          	sd	a0,-694(a5) # 80009010 <initproc>
    uvminit(p->pagetable, initcode, sizeof(initcode));
    800012ce:	03400613          	li	a2,52
    800012d2:	00007597          	auipc	a1,0x7
    800012d6:	5de58593          	add	a1,a1,1502 # 800088b0 <initcode>
    800012da:	6928                	ld	a0,80(a0)
    800012dc:	fffff097          	auipc	ra,0xfffff
    800012e0:	526080e7          	jalr	1318(ra) # 80000802 <uvminit>
    p->sz = PGSIZE;
    800012e4:	6785                	lui	a5,0x1
    800012e6:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    800012e8:	6cb8                	ld	a4,88(s1)
    800012ea:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    800012ee:	6cb8                	ld	a4,88(s1)
    800012f0:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    800012f2:	4641                	li	a2,16
    800012f4:	00007597          	auipc	a1,0x7
    800012f8:	ed458593          	add	a1,a1,-300 # 800081c8 <etext+0x1c8>
    800012fc:	15848513          	add	a0,s1,344
    80001300:	fffff097          	auipc	ra,0xfffff
    80001304:	fbc080e7          	jalr	-68(ra) # 800002bc <safestrcpy>
    p->cwd = namei("/");
    80001308:	00007517          	auipc	a0,0x7
    8000130c:	ed050513          	add	a0,a0,-304 # 800081d8 <etext+0x1d8>
    80001310:	00002097          	auipc	ra,0x2
    80001314:	1e6080e7          	jalr	486(ra) # 800034f6 <namei>
    80001318:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    8000131c:	478d                	li	a5,3
    8000131e:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001320:	8526                	mv	a0,s1
    80001322:	00005097          	auipc	ra,0x5
    80001326:	1b8080e7          	jalr	440(ra) # 800064da <release>
}
    8000132a:	60e2                	ld	ra,24(sp)
    8000132c:	6442                	ld	s0,16(sp)
    8000132e:	64a2                	ld	s1,8(sp)
    80001330:	6105                	add	sp,sp,32
    80001332:	8082                	ret

0000000080001334 <growproc>:
{
    80001334:	1101                	add	sp,sp,-32
    80001336:	ec06                	sd	ra,24(sp)
    80001338:	e822                	sd	s0,16(sp)
    8000133a:	e426                	sd	s1,8(sp)
    8000133c:	e04a                	sd	s2,0(sp)
    8000133e:	1000                	add	s0,sp,32
    80001340:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001342:	00000097          	auipc	ra,0x0
    80001346:	bfc080e7          	jalr	-1028(ra) # 80000f3e <myproc>
    8000134a:	892a                	mv	s2,a0
    sz = p->sz;
    8000134c:	652c                	ld	a1,72(a0)
    8000134e:	0005879b          	sext.w	a5,a1
    if (n > 0)
    80001352:	00904f63          	bgtz	s1,80001370 <growproc+0x3c>
    else if (n < 0)
    80001356:	0204cd63          	bltz	s1,80001390 <growproc+0x5c>
    p->sz = sz;
    8000135a:	1782                	sll	a5,a5,0x20
    8000135c:	9381                	srl	a5,a5,0x20
    8000135e:	04f93423          	sd	a5,72(s2)
    return 0;
    80001362:	4501                	li	a0,0
}
    80001364:	60e2                	ld	ra,24(sp)
    80001366:	6442                	ld	s0,16(sp)
    80001368:	64a2                	ld	s1,8(sp)
    8000136a:	6902                	ld	s2,0(sp)
    8000136c:	6105                	add	sp,sp,32
    8000136e:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0)
    80001370:	00f4863b          	addw	a2,s1,a5
    80001374:	1602                	sll	a2,a2,0x20
    80001376:	9201                	srl	a2,a2,0x20
    80001378:	1582                	sll	a1,a1,0x20
    8000137a:	9181                	srl	a1,a1,0x20
    8000137c:	6928                	ld	a0,80(a0)
    8000137e:	fffff097          	auipc	ra,0xfffff
    80001382:	53e080e7          	jalr	1342(ra) # 800008bc <uvmalloc>
    80001386:	0005079b          	sext.w	a5,a0
    8000138a:	fbe1                	bnez	a5,8000135a <growproc+0x26>
            return -1;
    8000138c:	557d                	li	a0,-1
    8000138e:	bfd9                	j	80001364 <growproc+0x30>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001390:	00f4863b          	addw	a2,s1,a5
    80001394:	1602                	sll	a2,a2,0x20
    80001396:	9201                	srl	a2,a2,0x20
    80001398:	1582                	sll	a1,a1,0x20
    8000139a:	9181                	srl	a1,a1,0x20
    8000139c:	6928                	ld	a0,80(a0)
    8000139e:	fffff097          	auipc	ra,0xfffff
    800013a2:	4d6080e7          	jalr	1238(ra) # 80000874 <uvmdealloc>
    800013a6:	0005079b          	sext.w	a5,a0
    800013aa:	bf45                	j	8000135a <growproc+0x26>

00000000800013ac <fork>:
{
    800013ac:	7139                	add	sp,sp,-64
    800013ae:	fc06                	sd	ra,56(sp)
    800013b0:	f822                	sd	s0,48(sp)
    800013b2:	f04a                	sd	s2,32(sp)
    800013b4:	e456                	sd	s5,8(sp)
    800013b6:	0080                	add	s0,sp,64
    struct proc *p = myproc();
    800013b8:	00000097          	auipc	ra,0x0
    800013bc:	b86080e7          	jalr	-1146(ra) # 80000f3e <myproc>
    800013c0:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    800013c2:	00000097          	auipc	ra,0x0
    800013c6:	df6080e7          	jalr	-522(ra) # 800011b8 <allocproc>
    800013ca:	12050063          	beqz	a0,800014ea <fork+0x13e>
    800013ce:	e852                	sd	s4,16(sp)
    800013d0:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    800013d2:	048ab603          	ld	a2,72(s5)
    800013d6:	692c                	ld	a1,80(a0)
    800013d8:	050ab503          	ld	a0,80(s5)
    800013dc:	fffff097          	auipc	ra,0xfffff
    800013e0:	638080e7          	jalr	1592(ra) # 80000a14 <uvmcopy>
    800013e4:	04054a63          	bltz	a0,80001438 <fork+0x8c>
    800013e8:	f426                	sd	s1,40(sp)
    800013ea:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    800013ec:	048ab783          	ld	a5,72(s5)
    800013f0:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    800013f4:	058ab683          	ld	a3,88(s5)
    800013f8:	87b6                	mv	a5,a3
    800013fa:	058a3703          	ld	a4,88(s4)
    800013fe:	12068693          	add	a3,a3,288
    80001402:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001406:	6788                	ld	a0,8(a5)
    80001408:	6b8c                	ld	a1,16(a5)
    8000140a:	6f90                	ld	a2,24(a5)
    8000140c:	01073023          	sd	a6,0(a4)
    80001410:	e708                	sd	a0,8(a4)
    80001412:	eb0c                	sd	a1,16(a4)
    80001414:	ef10                	sd	a2,24(a4)
    80001416:	02078793          	add	a5,a5,32
    8000141a:	02070713          	add	a4,a4,32
    8000141e:	fed792e3          	bne	a5,a3,80001402 <fork+0x56>
    np->trapframe->a0 = 0;
    80001422:	058a3783          	ld	a5,88(s4)
    80001426:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    8000142a:	0d0a8493          	add	s1,s5,208
    8000142e:	0d0a0913          	add	s2,s4,208
    80001432:	150a8993          	add	s3,s5,336
    80001436:	a015                	j	8000145a <fork+0xae>
        freeproc(np);
    80001438:	8552                	mv	a0,s4
    8000143a:	00000097          	auipc	ra,0x0
    8000143e:	d26080e7          	jalr	-730(ra) # 80001160 <freeproc>
        release(&np->lock);
    80001442:	8552                	mv	a0,s4
    80001444:	00005097          	auipc	ra,0x5
    80001448:	096080e7          	jalr	150(ra) # 800064da <release>
        return -1;
    8000144c:	597d                	li	s2,-1
    8000144e:	6a42                	ld	s4,16(sp)
    80001450:	a071                	j	800014dc <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    80001452:	04a1                	add	s1,s1,8
    80001454:	0921                	add	s2,s2,8
    80001456:	01348b63          	beq	s1,s3,8000146c <fork+0xc0>
        if (p->ofile[i])
    8000145a:	6088                	ld	a0,0(s1)
    8000145c:	d97d                	beqz	a0,80001452 <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    8000145e:	00002097          	auipc	ra,0x2
    80001462:	710080e7          	jalr	1808(ra) # 80003b6e <filedup>
    80001466:	00a93023          	sd	a0,0(s2)
    8000146a:	b7e5                	j	80001452 <fork+0xa6>
    np->cwd = idup(p->cwd);
    8000146c:	150ab503          	ld	a0,336(s5)
    80001470:	00002097          	auipc	ra,0x2
    80001474:	876080e7          	jalr	-1930(ra) # 80002ce6 <idup>
    80001478:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    8000147c:	4641                	li	a2,16
    8000147e:	158a8593          	add	a1,s5,344
    80001482:	158a0513          	add	a0,s4,344
    80001486:	fffff097          	auipc	ra,0xfffff
    8000148a:	e36080e7          	jalr	-458(ra) # 800002bc <safestrcpy>
    pid = np->pid;
    8000148e:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    80001492:	8552                	mv	a0,s4
    80001494:	00005097          	auipc	ra,0x5
    80001498:	046080e7          	jalr	70(ra) # 800064da <release>
    acquire(&wait_lock);
    8000149c:	00008497          	auipc	s1,0x8
    800014a0:	bcc48493          	add	s1,s1,-1076 # 80009068 <wait_lock>
    800014a4:	8526                	mv	a0,s1
    800014a6:	00005097          	auipc	ra,0x5
    800014aa:	f80080e7          	jalr	-128(ra) # 80006426 <acquire>
    np->parent = p;
    800014ae:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    800014b2:	8526                	mv	a0,s1
    800014b4:	00005097          	auipc	ra,0x5
    800014b8:	026080e7          	jalr	38(ra) # 800064da <release>
    acquire(&np->lock);
    800014bc:	8552                	mv	a0,s4
    800014be:	00005097          	auipc	ra,0x5
    800014c2:	f68080e7          	jalr	-152(ra) # 80006426 <acquire>
    np->state = RUNNABLE;
    800014c6:	478d                	li	a5,3
    800014c8:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    800014cc:	8552                	mv	a0,s4
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	00c080e7          	jalr	12(ra) # 800064da <release>
    return pid;
    800014d6:	74a2                	ld	s1,40(sp)
    800014d8:	69e2                	ld	s3,24(sp)
    800014da:	6a42                	ld	s4,16(sp)
}
    800014dc:	854a                	mv	a0,s2
    800014de:	70e2                	ld	ra,56(sp)
    800014e0:	7442                	ld	s0,48(sp)
    800014e2:	7902                	ld	s2,32(sp)
    800014e4:	6aa2                	ld	s5,8(sp)
    800014e6:	6121                	add	sp,sp,64
    800014e8:	8082                	ret
        return -1;
    800014ea:	597d                	li	s2,-1
    800014ec:	bfc5                	j	800014dc <fork+0x130>

00000000800014ee <scheduler>:
{
    800014ee:	7139                	add	sp,sp,-64
    800014f0:	fc06                	sd	ra,56(sp)
    800014f2:	f822                	sd	s0,48(sp)
    800014f4:	f426                	sd	s1,40(sp)
    800014f6:	f04a                	sd	s2,32(sp)
    800014f8:	ec4e                	sd	s3,24(sp)
    800014fa:	e852                	sd	s4,16(sp)
    800014fc:	e456                	sd	s5,8(sp)
    800014fe:	e05a                	sd	s6,0(sp)
    80001500:	0080                	add	s0,sp,64
    80001502:	8792                	mv	a5,tp
    int id = r_tp();
    80001504:	2781                	sext.w	a5,a5
    c->proc = 0;
    80001506:	00779a93          	sll	s5,a5,0x7
    8000150a:	00008717          	auipc	a4,0x8
    8000150e:	b4670713          	add	a4,a4,-1210 # 80009050 <pid_lock>
    80001512:	9756                	add	a4,a4,s5
    80001514:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    80001518:	00008717          	auipc	a4,0x8
    8000151c:	b7070713          	add	a4,a4,-1168 # 80009088 <cpus+0x8>
    80001520:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE)
    80001522:	498d                	li	s3,3
                p->state = RUNNING;
    80001524:	4b11                	li	s6,4
                c->proc = p;
    80001526:	079e                	sll	a5,a5,0x7
    80001528:	00008a17          	auipc	s4,0x8
    8000152c:	b28a0a13          	add	s4,s4,-1240 # 80009050 <pid_lock>
    80001530:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++)
    80001532:	0000e917          	auipc	s2,0xe
    80001536:	b4e90913          	add	s2,s2,-1202 # 8000f080 <tickslock>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    8000153a:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000153e:	0027e793          	or	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001542:	10079073          	csrw	sstatus,a5
    80001546:	00008497          	auipc	s1,0x8
    8000154a:	f3a48493          	add	s1,s1,-198 # 80009480 <proc>
    8000154e:	a811                	j	80001562 <scheduler+0x74>
            release(&p->lock);
    80001550:	8526                	mv	a0,s1
    80001552:	00005097          	auipc	ra,0x5
    80001556:	f88080e7          	jalr	-120(ra) # 800064da <release>
        for (p = proc; p < &proc[NPROC]; p++)
    8000155a:	17048493          	add	s1,s1,368
    8000155e:	fd248ee3          	beq	s1,s2,8000153a <scheduler+0x4c>
            acquire(&p->lock);
    80001562:	8526                	mv	a0,s1
    80001564:	00005097          	auipc	ra,0x5
    80001568:	ec2080e7          	jalr	-318(ra) # 80006426 <acquire>
            if (p->state == RUNNABLE)
    8000156c:	4c9c                	lw	a5,24(s1)
    8000156e:	ff3791e3          	bne	a5,s3,80001550 <scheduler+0x62>
                p->state = RUNNING;
    80001572:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    80001576:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    8000157a:	06048593          	add	a1,s1,96
    8000157e:	8556                	mv	a0,s5
    80001580:	00000097          	auipc	ra,0x0
    80001584:	620080e7          	jalr	1568(ra) # 80001ba0 <swtch>
                c->proc = 0;
    80001588:	020a3823          	sd	zero,48(s4)
    8000158c:	b7d1                	j	80001550 <scheduler+0x62>

000000008000158e <sched>:
{
    8000158e:	7179                	add	sp,sp,-48
    80001590:	f406                	sd	ra,40(sp)
    80001592:	f022                	sd	s0,32(sp)
    80001594:	ec26                	sd	s1,24(sp)
    80001596:	e84a                	sd	s2,16(sp)
    80001598:	e44e                	sd	s3,8(sp)
    8000159a:	1800                	add	s0,sp,48
    struct proc *p = myproc();
    8000159c:	00000097          	auipc	ra,0x0
    800015a0:	9a2080e7          	jalr	-1630(ra) # 80000f3e <myproc>
    800015a4:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    800015a6:	00005097          	auipc	ra,0x5
    800015aa:	e06080e7          	jalr	-506(ra) # 800063ac <holding>
    800015ae:	c93d                	beqz	a0,80001624 <sched+0x96>
    asm volatile("mv %0, tp" : "=r"(x));
    800015b0:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    800015b2:	2781                	sext.w	a5,a5
    800015b4:	079e                	sll	a5,a5,0x7
    800015b6:	00008717          	auipc	a4,0x8
    800015ba:	a9a70713          	add	a4,a4,-1382 # 80009050 <pid_lock>
    800015be:	97ba                	add	a5,a5,a4
    800015c0:	0a87a703          	lw	a4,168(a5)
    800015c4:	4785                	li	a5,1
    800015c6:	06f71763          	bne	a4,a5,80001634 <sched+0xa6>
    if (p->state == RUNNING)
    800015ca:	4c98                	lw	a4,24(s1)
    800015cc:	4791                	li	a5,4
    800015ce:	06f70b63          	beq	a4,a5,80001644 <sched+0xb6>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800015d2:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    800015d6:	8b89                	and	a5,a5,2
    if (intr_get())
    800015d8:	efb5                	bnez	a5,80001654 <sched+0xc6>
    asm volatile("mv %0, tp" : "=r"(x));
    800015da:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    800015dc:	00008917          	auipc	s2,0x8
    800015e0:	a7490913          	add	s2,s2,-1420 # 80009050 <pid_lock>
    800015e4:	2781                	sext.w	a5,a5
    800015e6:	079e                	sll	a5,a5,0x7
    800015e8:	97ca                	add	a5,a5,s2
    800015ea:	0ac7a983          	lw	s3,172(a5)
    800015ee:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    800015f0:	2781                	sext.w	a5,a5
    800015f2:	079e                	sll	a5,a5,0x7
    800015f4:	00008597          	auipc	a1,0x8
    800015f8:	a9458593          	add	a1,a1,-1388 # 80009088 <cpus+0x8>
    800015fc:	95be                	add	a1,a1,a5
    800015fe:	06048513          	add	a0,s1,96
    80001602:	00000097          	auipc	ra,0x0
    80001606:	59e080e7          	jalr	1438(ra) # 80001ba0 <swtch>
    8000160a:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    8000160c:	2781                	sext.w	a5,a5
    8000160e:	079e                	sll	a5,a5,0x7
    80001610:	993e                	add	s2,s2,a5
    80001612:	0b392623          	sw	s3,172(s2)
}
    80001616:	70a2                	ld	ra,40(sp)
    80001618:	7402                	ld	s0,32(sp)
    8000161a:	64e2                	ld	s1,24(sp)
    8000161c:	6942                	ld	s2,16(sp)
    8000161e:	69a2                	ld	s3,8(sp)
    80001620:	6145                	add	sp,sp,48
    80001622:	8082                	ret
        panic("sched p->lock");
    80001624:	00007517          	auipc	a0,0x7
    80001628:	bbc50513          	add	a0,a0,-1092 # 800081e0 <etext+0x1e0>
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	880080e7          	jalr	-1920(ra) # 80005eac <panic>
        panic("sched locks");
    80001634:	00007517          	auipc	a0,0x7
    80001638:	bbc50513          	add	a0,a0,-1092 # 800081f0 <etext+0x1f0>
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	870080e7          	jalr	-1936(ra) # 80005eac <panic>
        panic("sched running");
    80001644:	00007517          	auipc	a0,0x7
    80001648:	bbc50513          	add	a0,a0,-1092 # 80008200 <etext+0x200>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	860080e7          	jalr	-1952(ra) # 80005eac <panic>
        panic("sched interruptible");
    80001654:	00007517          	auipc	a0,0x7
    80001658:	bbc50513          	add	a0,a0,-1092 # 80008210 <etext+0x210>
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	850080e7          	jalr	-1968(ra) # 80005eac <panic>

0000000080001664 <yield>:
{
    80001664:	1101                	add	sp,sp,-32
    80001666:	ec06                	sd	ra,24(sp)
    80001668:	e822                	sd	s0,16(sp)
    8000166a:	e426                	sd	s1,8(sp)
    8000166c:	1000                	add	s0,sp,32
    struct proc *p = myproc();
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	8d0080e7          	jalr	-1840(ra) # 80000f3e <myproc>
    80001676:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	dae080e7          	jalr	-594(ra) # 80006426 <acquire>
    p->state = RUNNABLE;
    80001680:	478d                	li	a5,3
    80001682:	cc9c                	sw	a5,24(s1)
    sched();
    80001684:	00000097          	auipc	ra,0x0
    80001688:	f0a080e7          	jalr	-246(ra) # 8000158e <sched>
    release(&p->lock);
    8000168c:	8526                	mv	a0,s1
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	e4c080e7          	jalr	-436(ra) # 800064da <release>
}
    80001696:	60e2                	ld	ra,24(sp)
    80001698:	6442                	ld	s0,16(sp)
    8000169a:	64a2                	ld	s1,8(sp)
    8000169c:	6105                	add	sp,sp,32
    8000169e:	8082                	ret

00000000800016a0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800016a0:	7179                	add	sp,sp,-48
    800016a2:	f406                	sd	ra,40(sp)
    800016a4:	f022                	sd	s0,32(sp)
    800016a6:	ec26                	sd	s1,24(sp)
    800016a8:	e84a                	sd	s2,16(sp)
    800016aa:	e44e                	sd	s3,8(sp)
    800016ac:	1800                	add	s0,sp,48
    800016ae:	89aa                	mv	s3,a0
    800016b0:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800016b2:	00000097          	auipc	ra,0x0
    800016b6:	88c080e7          	jalr	-1908(ra) # 80000f3e <myproc>
    800016ba:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	d6a080e7          	jalr	-662(ra) # 80006426 <acquire>
    release(lk);
    800016c4:	854a                	mv	a0,s2
    800016c6:	00005097          	auipc	ra,0x5
    800016ca:	e14080e7          	jalr	-492(ra) # 800064da <release>

    // Go to sleep.
    p->chan = chan;
    800016ce:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    800016d2:	4789                	li	a5,2
    800016d4:	cc9c                	sw	a5,24(s1)

    sched();
    800016d6:	00000097          	auipc	ra,0x0
    800016da:	eb8080e7          	jalr	-328(ra) # 8000158e <sched>

    // Tidy up.
    p->chan = 0;
    800016de:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    800016e2:	8526                	mv	a0,s1
    800016e4:	00005097          	auipc	ra,0x5
    800016e8:	df6080e7          	jalr	-522(ra) # 800064da <release>
    acquire(lk);
    800016ec:	854a                	mv	a0,s2
    800016ee:	00005097          	auipc	ra,0x5
    800016f2:	d38080e7          	jalr	-712(ra) # 80006426 <acquire>
}
    800016f6:	70a2                	ld	ra,40(sp)
    800016f8:	7402                	ld	s0,32(sp)
    800016fa:	64e2                	ld	s1,24(sp)
    800016fc:	6942                	ld	s2,16(sp)
    800016fe:	69a2                	ld	s3,8(sp)
    80001700:	6145                	add	sp,sp,48
    80001702:	8082                	ret

0000000080001704 <wait>:
{
    80001704:	715d                	add	sp,sp,-80
    80001706:	e486                	sd	ra,72(sp)
    80001708:	e0a2                	sd	s0,64(sp)
    8000170a:	fc26                	sd	s1,56(sp)
    8000170c:	f84a                	sd	s2,48(sp)
    8000170e:	f44e                	sd	s3,40(sp)
    80001710:	f052                	sd	s4,32(sp)
    80001712:	ec56                	sd	s5,24(sp)
    80001714:	e85a                	sd	s6,16(sp)
    80001716:	e45e                	sd	s7,8(sp)
    80001718:	e062                	sd	s8,0(sp)
    8000171a:	0880                	add	s0,sp,80
    8000171c:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    8000171e:	00000097          	auipc	ra,0x0
    80001722:	820080e7          	jalr	-2016(ra) # 80000f3e <myproc>
    80001726:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80001728:	00008517          	auipc	a0,0x8
    8000172c:	94050513          	add	a0,a0,-1728 # 80009068 <wait_lock>
    80001730:	00005097          	auipc	ra,0x5
    80001734:	cf6080e7          	jalr	-778(ra) # 80006426 <acquire>
        havekids = 0;
    80001738:	4b81                	li	s7,0
                if (np->state == ZOMBIE)
    8000173a:	4a15                	li	s4,5
                havekids = 1;
    8000173c:	4a85                	li	s5,1
        for (np = proc; np < &proc[NPROC]; np++)
    8000173e:	0000e997          	auipc	s3,0xe
    80001742:	94298993          	add	s3,s3,-1726 # 8000f080 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001746:	00008c17          	auipc	s8,0x8
    8000174a:	922c0c13          	add	s8,s8,-1758 # 80009068 <wait_lock>
    8000174e:	a87d                	j	8000180c <wait+0x108>
                    pid = np->pid;
    80001750:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001754:	000b0e63          	beqz	s6,80001770 <wait+0x6c>
    80001758:	4691                	li	a3,4
    8000175a:	02c48613          	add	a2,s1,44
    8000175e:	85da                	mv	a1,s6
    80001760:	05093503          	ld	a0,80(s2)
    80001764:	fffff097          	auipc	ra,0xfffff
    80001768:	3b4080e7          	jalr	948(ra) # 80000b18 <copyout>
    8000176c:	04054163          	bltz	a0,800017ae <wait+0xaa>
                    freeproc(np);
    80001770:	8526                	mv	a0,s1
    80001772:	00000097          	auipc	ra,0x0
    80001776:	9ee080e7          	jalr	-1554(ra) # 80001160 <freeproc>
                    release(&np->lock);
    8000177a:	8526                	mv	a0,s1
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	d5e080e7          	jalr	-674(ra) # 800064da <release>
                    release(&wait_lock);
    80001784:	00008517          	auipc	a0,0x8
    80001788:	8e450513          	add	a0,a0,-1820 # 80009068 <wait_lock>
    8000178c:	00005097          	auipc	ra,0x5
    80001790:	d4e080e7          	jalr	-690(ra) # 800064da <release>
}
    80001794:	854e                	mv	a0,s3
    80001796:	60a6                	ld	ra,72(sp)
    80001798:	6406                	ld	s0,64(sp)
    8000179a:	74e2                	ld	s1,56(sp)
    8000179c:	7942                	ld	s2,48(sp)
    8000179e:	79a2                	ld	s3,40(sp)
    800017a0:	7a02                	ld	s4,32(sp)
    800017a2:	6ae2                	ld	s5,24(sp)
    800017a4:	6b42                	ld	s6,16(sp)
    800017a6:	6ba2                	ld	s7,8(sp)
    800017a8:	6c02                	ld	s8,0(sp)
    800017aa:	6161                	add	sp,sp,80
    800017ac:	8082                	ret
                        release(&np->lock);
    800017ae:	8526                	mv	a0,s1
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	d2a080e7          	jalr	-726(ra) # 800064da <release>
                        release(&wait_lock);
    800017b8:	00008517          	auipc	a0,0x8
    800017bc:	8b050513          	add	a0,a0,-1872 # 80009068 <wait_lock>
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	d1a080e7          	jalr	-742(ra) # 800064da <release>
                        return -1;
    800017c8:	59fd                	li	s3,-1
    800017ca:	b7e9                	j	80001794 <wait+0x90>
        for (np = proc; np < &proc[NPROC]; np++)
    800017cc:	17048493          	add	s1,s1,368
    800017d0:	03348463          	beq	s1,s3,800017f8 <wait+0xf4>
            if (np->parent == p)
    800017d4:	7c9c                	ld	a5,56(s1)
    800017d6:	ff279be3          	bne	a5,s2,800017cc <wait+0xc8>
                acquire(&np->lock);
    800017da:	8526                	mv	a0,s1
    800017dc:	00005097          	auipc	ra,0x5
    800017e0:	c4a080e7          	jalr	-950(ra) # 80006426 <acquire>
                if (np->state == ZOMBIE)
    800017e4:	4c9c                	lw	a5,24(s1)
    800017e6:	f74785e3          	beq	a5,s4,80001750 <wait+0x4c>
                release(&np->lock);
    800017ea:	8526                	mv	a0,s1
    800017ec:	00005097          	auipc	ra,0x5
    800017f0:	cee080e7          	jalr	-786(ra) # 800064da <release>
                havekids = 1;
    800017f4:	8756                	mv	a4,s5
    800017f6:	bfd9                	j	800017cc <wait+0xc8>
        if (!havekids || p->killed)
    800017f8:	c305                	beqz	a4,80001818 <wait+0x114>
    800017fa:	02892783          	lw	a5,40(s2)
    800017fe:	ef89                	bnez	a5,80001818 <wait+0x114>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001800:	85e2                	mv	a1,s8
    80001802:	854a                	mv	a0,s2
    80001804:	00000097          	auipc	ra,0x0
    80001808:	e9c080e7          	jalr	-356(ra) # 800016a0 <sleep>
        havekids = 0;
    8000180c:	875e                	mv	a4,s7
        for (np = proc; np < &proc[NPROC]; np++)
    8000180e:	00008497          	auipc	s1,0x8
    80001812:	c7248493          	add	s1,s1,-910 # 80009480 <proc>
    80001816:	bf7d                	j	800017d4 <wait+0xd0>
            release(&wait_lock);
    80001818:	00008517          	auipc	a0,0x8
    8000181c:	85050513          	add	a0,a0,-1968 # 80009068 <wait_lock>
    80001820:	00005097          	auipc	ra,0x5
    80001824:	cba080e7          	jalr	-838(ra) # 800064da <release>
            return -1;
    80001828:	59fd                	li	s3,-1
    8000182a:	b7ad                	j	80001794 <wait+0x90>

000000008000182c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000182c:	7139                	add	sp,sp,-64
    8000182e:	fc06                	sd	ra,56(sp)
    80001830:	f822                	sd	s0,48(sp)
    80001832:	f426                	sd	s1,40(sp)
    80001834:	f04a                	sd	s2,32(sp)
    80001836:	ec4e                	sd	s3,24(sp)
    80001838:	e852                	sd	s4,16(sp)
    8000183a:	e456                	sd	s5,8(sp)
    8000183c:	0080                	add	s0,sp,64
    8000183e:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80001840:	00008497          	auipc	s1,0x8
    80001844:	c4048493          	add	s1,s1,-960 # 80009480 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80001848:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    8000184a:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    8000184c:	0000e917          	auipc	s2,0xe
    80001850:	83490913          	add	s2,s2,-1996 # 8000f080 <tickslock>
    80001854:	a811                	j	80001868 <wakeup+0x3c>
            }
            release(&p->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	c82080e7          	jalr	-894(ra) # 800064da <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001860:	17048493          	add	s1,s1,368
    80001864:	03248663          	beq	s1,s2,80001890 <wakeup+0x64>
        if (p != myproc())
    80001868:	fffff097          	auipc	ra,0xfffff
    8000186c:	6d6080e7          	jalr	1750(ra) # 80000f3e <myproc>
    80001870:	fea488e3          	beq	s1,a0,80001860 <wakeup+0x34>
            acquire(&p->lock);
    80001874:	8526                	mv	a0,s1
    80001876:	00005097          	auipc	ra,0x5
    8000187a:	bb0080e7          	jalr	-1104(ra) # 80006426 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    8000187e:	4c9c                	lw	a5,24(s1)
    80001880:	fd379be3          	bne	a5,s3,80001856 <wakeup+0x2a>
    80001884:	709c                	ld	a5,32(s1)
    80001886:	fd4798e3          	bne	a5,s4,80001856 <wakeup+0x2a>
                p->state = RUNNABLE;
    8000188a:	0154ac23          	sw	s5,24(s1)
    8000188e:	b7e1                	j	80001856 <wakeup+0x2a>
        }
    }
}
    80001890:	70e2                	ld	ra,56(sp)
    80001892:	7442                	ld	s0,48(sp)
    80001894:	74a2                	ld	s1,40(sp)
    80001896:	7902                	ld	s2,32(sp)
    80001898:	69e2                	ld	s3,24(sp)
    8000189a:	6a42                	ld	s4,16(sp)
    8000189c:	6aa2                	ld	s5,8(sp)
    8000189e:	6121                	add	sp,sp,64
    800018a0:	8082                	ret

00000000800018a2 <reparent>:
{
    800018a2:	7179                	add	sp,sp,-48
    800018a4:	f406                	sd	ra,40(sp)
    800018a6:	f022                	sd	s0,32(sp)
    800018a8:	ec26                	sd	s1,24(sp)
    800018aa:	e84a                	sd	s2,16(sp)
    800018ac:	e44e                	sd	s3,8(sp)
    800018ae:	e052                	sd	s4,0(sp)
    800018b0:	1800                	add	s0,sp,48
    800018b2:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800018b4:	00008497          	auipc	s1,0x8
    800018b8:	bcc48493          	add	s1,s1,-1076 # 80009480 <proc>
            pp->parent = initproc;
    800018bc:	00007a17          	auipc	s4,0x7
    800018c0:	754a0a13          	add	s4,s4,1876 # 80009010 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800018c4:	0000d997          	auipc	s3,0xd
    800018c8:	7bc98993          	add	s3,s3,1980 # 8000f080 <tickslock>
    800018cc:	a029                	j	800018d6 <reparent+0x34>
    800018ce:	17048493          	add	s1,s1,368
    800018d2:	01348d63          	beq	s1,s3,800018ec <reparent+0x4a>
        if (pp->parent == p)
    800018d6:	7c9c                	ld	a5,56(s1)
    800018d8:	ff279be3          	bne	a5,s2,800018ce <reparent+0x2c>
            pp->parent = initproc;
    800018dc:	000a3503          	ld	a0,0(s4)
    800018e0:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    800018e2:	00000097          	auipc	ra,0x0
    800018e6:	f4a080e7          	jalr	-182(ra) # 8000182c <wakeup>
    800018ea:	b7d5                	j	800018ce <reparent+0x2c>
}
    800018ec:	70a2                	ld	ra,40(sp)
    800018ee:	7402                	ld	s0,32(sp)
    800018f0:	64e2                	ld	s1,24(sp)
    800018f2:	6942                	ld	s2,16(sp)
    800018f4:	69a2                	ld	s3,8(sp)
    800018f6:	6a02                	ld	s4,0(sp)
    800018f8:	6145                	add	sp,sp,48
    800018fa:	8082                	ret

00000000800018fc <exit>:
{
    800018fc:	7179                	add	sp,sp,-48
    800018fe:	f406                	sd	ra,40(sp)
    80001900:	f022                	sd	s0,32(sp)
    80001902:	ec26                	sd	s1,24(sp)
    80001904:	e84a                	sd	s2,16(sp)
    80001906:	e44e                	sd	s3,8(sp)
    80001908:	e052                	sd	s4,0(sp)
    8000190a:	1800                	add	s0,sp,48
    8000190c:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000190e:	fffff097          	auipc	ra,0xfffff
    80001912:	630080e7          	jalr	1584(ra) # 80000f3e <myproc>
    80001916:	89aa                	mv	s3,a0
    if (p == initproc)
    80001918:	00007797          	auipc	a5,0x7
    8000191c:	6f87b783          	ld	a5,1784(a5) # 80009010 <initproc>
    80001920:	0d050493          	add	s1,a0,208
    80001924:	15050913          	add	s2,a0,336
    80001928:	02a79363          	bne	a5,a0,8000194e <exit+0x52>
        panic("init exiting");
    8000192c:	00007517          	auipc	a0,0x7
    80001930:	8fc50513          	add	a0,a0,-1796 # 80008228 <etext+0x228>
    80001934:	00004097          	auipc	ra,0x4
    80001938:	578080e7          	jalr	1400(ra) # 80005eac <panic>
            fileclose(f);
    8000193c:	00002097          	auipc	ra,0x2
    80001940:	284080e7          	jalr	644(ra) # 80003bc0 <fileclose>
            p->ofile[fd] = 0;
    80001944:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    80001948:	04a1                	add	s1,s1,8
    8000194a:	01248563          	beq	s1,s2,80001954 <exit+0x58>
        if (p->ofile[fd])
    8000194e:	6088                	ld	a0,0(s1)
    80001950:	f575                	bnez	a0,8000193c <exit+0x40>
    80001952:	bfdd                	j	80001948 <exit+0x4c>
    begin_op();
    80001954:	00002097          	auipc	ra,0x2
    80001958:	da2080e7          	jalr	-606(ra) # 800036f6 <begin_op>
    iput(p->cwd);
    8000195c:	1509b503          	ld	a0,336(s3)
    80001960:	00001097          	auipc	ra,0x1
    80001964:	582080e7          	jalr	1410(ra) # 80002ee2 <iput>
    end_op();
    80001968:	00002097          	auipc	ra,0x2
    8000196c:	e08080e7          	jalr	-504(ra) # 80003770 <end_op>
    p->cwd = 0;
    80001970:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    80001974:	00007497          	auipc	s1,0x7
    80001978:	6f448493          	add	s1,s1,1780 # 80009068 <wait_lock>
    8000197c:	8526                	mv	a0,s1
    8000197e:	00005097          	auipc	ra,0x5
    80001982:	aa8080e7          	jalr	-1368(ra) # 80006426 <acquire>
    reparent(p);
    80001986:	854e                	mv	a0,s3
    80001988:	00000097          	auipc	ra,0x0
    8000198c:	f1a080e7          	jalr	-230(ra) # 800018a2 <reparent>
    wakeup(p->parent);
    80001990:	0389b503          	ld	a0,56(s3)
    80001994:	00000097          	auipc	ra,0x0
    80001998:	e98080e7          	jalr	-360(ra) # 8000182c <wakeup>
    acquire(&p->lock);
    8000199c:	854e                	mv	a0,s3
    8000199e:	00005097          	auipc	ra,0x5
    800019a2:	a88080e7          	jalr	-1400(ra) # 80006426 <acquire>
    p->xstate = status;
    800019a6:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800019aa:	4795                	li	a5,5
    800019ac:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800019b0:	8526                	mv	a0,s1
    800019b2:	00005097          	auipc	ra,0x5
    800019b6:	b28080e7          	jalr	-1240(ra) # 800064da <release>
    sched();
    800019ba:	00000097          	auipc	ra,0x0
    800019be:	bd4080e7          	jalr	-1068(ra) # 8000158e <sched>
    panic("zombie exit");
    800019c2:	00007517          	auipc	a0,0x7
    800019c6:	87650513          	add	a0,a0,-1930 # 80008238 <etext+0x238>
    800019ca:	00004097          	auipc	ra,0x4
    800019ce:	4e2080e7          	jalr	1250(ra) # 80005eac <panic>

00000000800019d2 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800019d2:	7179                	add	sp,sp,-48
    800019d4:	f406                	sd	ra,40(sp)
    800019d6:	f022                	sd	s0,32(sp)
    800019d8:	ec26                	sd	s1,24(sp)
    800019da:	e84a                	sd	s2,16(sp)
    800019dc:	e44e                	sd	s3,8(sp)
    800019de:	1800                	add	s0,sp,48
    800019e0:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800019e2:	00008497          	auipc	s1,0x8
    800019e6:	a9e48493          	add	s1,s1,-1378 # 80009480 <proc>
    800019ea:	0000d997          	auipc	s3,0xd
    800019ee:	69698993          	add	s3,s3,1686 # 8000f080 <tickslock>
    {
        acquire(&p->lock);
    800019f2:	8526                	mv	a0,s1
    800019f4:	00005097          	auipc	ra,0x5
    800019f8:	a32080e7          	jalr	-1486(ra) # 80006426 <acquire>
        if (p->pid == pid)
    800019fc:	589c                	lw	a5,48(s1)
    800019fe:	01278d63          	beq	a5,s2,80001a18 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80001a02:	8526                	mv	a0,s1
    80001a04:	00005097          	auipc	ra,0x5
    80001a08:	ad6080e7          	jalr	-1322(ra) # 800064da <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a0c:	17048493          	add	s1,s1,368
    80001a10:	ff3491e3          	bne	s1,s3,800019f2 <kill+0x20>
    }
    return -1;
    80001a14:	557d                	li	a0,-1
    80001a16:	a829                	j	80001a30 <kill+0x5e>
            p->killed = 1;
    80001a18:	4785                	li	a5,1
    80001a1a:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    80001a1c:	4c98                	lw	a4,24(s1)
    80001a1e:	4789                	li	a5,2
    80001a20:	00f70f63          	beq	a4,a5,80001a3e <kill+0x6c>
            release(&p->lock);
    80001a24:	8526                	mv	a0,s1
    80001a26:	00005097          	auipc	ra,0x5
    80001a2a:	ab4080e7          	jalr	-1356(ra) # 800064da <release>
            return 0;
    80001a2e:	4501                	li	a0,0
}
    80001a30:	70a2                	ld	ra,40(sp)
    80001a32:	7402                	ld	s0,32(sp)
    80001a34:	64e2                	ld	s1,24(sp)
    80001a36:	6942                	ld	s2,16(sp)
    80001a38:	69a2                	ld	s3,8(sp)
    80001a3a:	6145                	add	sp,sp,48
    80001a3c:	8082                	ret
                p->state = RUNNABLE;
    80001a3e:	478d                	li	a5,3
    80001a40:	cc9c                	sw	a5,24(s1)
    80001a42:	b7cd                	j	80001a24 <kill+0x52>

0000000080001a44 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a44:	7179                	add	sp,sp,-48
    80001a46:	f406                	sd	ra,40(sp)
    80001a48:	f022                	sd	s0,32(sp)
    80001a4a:	ec26                	sd	s1,24(sp)
    80001a4c:	e84a                	sd	s2,16(sp)
    80001a4e:	e44e                	sd	s3,8(sp)
    80001a50:	e052                	sd	s4,0(sp)
    80001a52:	1800                	add	s0,sp,48
    80001a54:	84aa                	mv	s1,a0
    80001a56:	892e                	mv	s2,a1
    80001a58:	89b2                	mv	s3,a2
    80001a5a:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001a5c:	fffff097          	auipc	ra,0xfffff
    80001a60:	4e2080e7          	jalr	1250(ra) # 80000f3e <myproc>
    if (user_dst)
    80001a64:	c08d                	beqz	s1,80001a86 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80001a66:	86d2                	mv	a3,s4
    80001a68:	864e                	mv	a2,s3
    80001a6a:	85ca                	mv	a1,s2
    80001a6c:	6928                	ld	a0,80(a0)
    80001a6e:	fffff097          	auipc	ra,0xfffff
    80001a72:	0aa080e7          	jalr	170(ra) # 80000b18 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80001a76:	70a2                	ld	ra,40(sp)
    80001a78:	7402                	ld	s0,32(sp)
    80001a7a:	64e2                	ld	s1,24(sp)
    80001a7c:	6942                	ld	s2,16(sp)
    80001a7e:	69a2                	ld	s3,8(sp)
    80001a80:	6a02                	ld	s4,0(sp)
    80001a82:	6145                	add	sp,sp,48
    80001a84:	8082                	ret
        memmove((char *)dst, src, len);
    80001a86:	000a061b          	sext.w	a2,s4
    80001a8a:	85ce                	mv	a1,s3
    80001a8c:	854a                	mv	a0,s2
    80001a8e:	ffffe097          	auipc	ra,0xffffe
    80001a92:	748080e7          	jalr	1864(ra) # 800001d6 <memmove>
        return 0;
    80001a96:	8526                	mv	a0,s1
    80001a98:	bff9                	j	80001a76 <either_copyout+0x32>

0000000080001a9a <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a9a:	7179                	add	sp,sp,-48
    80001a9c:	f406                	sd	ra,40(sp)
    80001a9e:	f022                	sd	s0,32(sp)
    80001aa0:	ec26                	sd	s1,24(sp)
    80001aa2:	e84a                	sd	s2,16(sp)
    80001aa4:	e44e                	sd	s3,8(sp)
    80001aa6:	e052                	sd	s4,0(sp)
    80001aa8:	1800                	add	s0,sp,48
    80001aaa:	892a                	mv	s2,a0
    80001aac:	84ae                	mv	s1,a1
    80001aae:	89b2                	mv	s3,a2
    80001ab0:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001ab2:	fffff097          	auipc	ra,0xfffff
    80001ab6:	48c080e7          	jalr	1164(ra) # 80000f3e <myproc>
    if (user_src)
    80001aba:	c08d                	beqz	s1,80001adc <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80001abc:	86d2                	mv	a3,s4
    80001abe:	864e                	mv	a2,s3
    80001ac0:	85ca                	mv	a1,s2
    80001ac2:	6928                	ld	a0,80(a0)
    80001ac4:	fffff097          	auipc	ra,0xfffff
    80001ac8:	0e0080e7          	jalr	224(ra) # 80000ba4 <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80001acc:	70a2                	ld	ra,40(sp)
    80001ace:	7402                	ld	s0,32(sp)
    80001ad0:	64e2                	ld	s1,24(sp)
    80001ad2:	6942                	ld	s2,16(sp)
    80001ad4:	69a2                	ld	s3,8(sp)
    80001ad6:	6a02                	ld	s4,0(sp)
    80001ad8:	6145                	add	sp,sp,48
    80001ada:	8082                	ret
        memmove(dst, (char *)src, len);
    80001adc:	000a061b          	sext.w	a2,s4
    80001ae0:	85ce                	mv	a1,s3
    80001ae2:	854a                	mv	a0,s2
    80001ae4:	ffffe097          	auipc	ra,0xffffe
    80001ae8:	6f2080e7          	jalr	1778(ra) # 800001d6 <memmove>
        return 0;
    80001aec:	8526                	mv	a0,s1
    80001aee:	bff9                	j	80001acc <either_copyin+0x32>

0000000080001af0 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80001af0:	715d                	add	sp,sp,-80
    80001af2:	e486                	sd	ra,72(sp)
    80001af4:	e0a2                	sd	s0,64(sp)
    80001af6:	fc26                	sd	s1,56(sp)
    80001af8:	f84a                	sd	s2,48(sp)
    80001afa:	f44e                	sd	s3,40(sp)
    80001afc:	f052                	sd	s4,32(sp)
    80001afe:	ec56                	sd	s5,24(sp)
    80001b00:	e85a                	sd	s6,16(sp)
    80001b02:	e45e                	sd	s7,8(sp)
    80001b04:	0880                	add	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80001b06:	00006517          	auipc	a0,0x6
    80001b0a:	51250513          	add	a0,a0,1298 # 80008018 <etext+0x18>
    80001b0e:	00004097          	auipc	ra,0x4
    80001b12:	3e8080e7          	jalr	1000(ra) # 80005ef6 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001b16:	00008497          	auipc	s1,0x8
    80001b1a:	ac248493          	add	s1,s1,-1342 # 800095d8 <proc+0x158>
    80001b1e:	0000d917          	auipc	s2,0xd
    80001b22:	6ba90913          	add	s2,s2,1722 # 8000f1d8 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b26:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80001b28:	00006997          	auipc	s3,0x6
    80001b2c:	72098993          	add	s3,s3,1824 # 80008248 <etext+0x248>
        printf("%d %s %s", p->pid, state, p->name);
    80001b30:	00006a97          	auipc	s5,0x6
    80001b34:	720a8a93          	add	s5,s5,1824 # 80008250 <etext+0x250>
        printf("\n");
    80001b38:	00006a17          	auipc	s4,0x6
    80001b3c:	4e0a0a13          	add	s4,s4,1248 # 80008018 <etext+0x18>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b40:	00007b97          	auipc	s7,0x7
    80001b44:	c08b8b93          	add	s7,s7,-1016 # 80008748 <states.0>
    80001b48:	a00d                	j	80001b6a <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001b4a:	ed86a583          	lw	a1,-296(a3)
    80001b4e:	8556                	mv	a0,s5
    80001b50:	00004097          	auipc	ra,0x4
    80001b54:	3a6080e7          	jalr	934(ra) # 80005ef6 <printf>
        printf("\n");
    80001b58:	8552                	mv	a0,s4
    80001b5a:	00004097          	auipc	ra,0x4
    80001b5e:	39c080e7          	jalr	924(ra) # 80005ef6 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001b62:	17048493          	add	s1,s1,368
    80001b66:	03248263          	beq	s1,s2,80001b8a <procdump+0x9a>
        if (p->state == UNUSED)
    80001b6a:	86a6                	mv	a3,s1
    80001b6c:	ec04a783          	lw	a5,-320(s1)
    80001b70:	dbed                	beqz	a5,80001b62 <procdump+0x72>
            state = "???";
    80001b72:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b74:	fcfb6be3          	bltu	s6,a5,80001b4a <procdump+0x5a>
    80001b78:	02079713          	sll	a4,a5,0x20
    80001b7c:	01d75793          	srl	a5,a4,0x1d
    80001b80:	97de                	add	a5,a5,s7
    80001b82:	6390                	ld	a2,0(a5)
    80001b84:	f279                	bnez	a2,80001b4a <procdump+0x5a>
            state = "???";
    80001b86:	864e                	mv	a2,s3
    80001b88:	b7c9                	j	80001b4a <procdump+0x5a>
    }
}
    80001b8a:	60a6                	ld	ra,72(sp)
    80001b8c:	6406                	ld	s0,64(sp)
    80001b8e:	74e2                	ld	s1,56(sp)
    80001b90:	7942                	ld	s2,48(sp)
    80001b92:	79a2                	ld	s3,40(sp)
    80001b94:	7a02                	ld	s4,32(sp)
    80001b96:	6ae2                	ld	s5,24(sp)
    80001b98:	6b42                	ld	s6,16(sp)
    80001b9a:	6ba2                	ld	s7,8(sp)
    80001b9c:	6161                	add	sp,sp,80
    80001b9e:	8082                	ret

0000000080001ba0 <swtch>:
    80001ba0:	00153023          	sd	ra,0(a0)
    80001ba4:	00253423          	sd	sp,8(a0)
    80001ba8:	e900                	sd	s0,16(a0)
    80001baa:	ed04                	sd	s1,24(a0)
    80001bac:	03253023          	sd	s2,32(a0)
    80001bb0:	03353423          	sd	s3,40(a0)
    80001bb4:	03453823          	sd	s4,48(a0)
    80001bb8:	03553c23          	sd	s5,56(a0)
    80001bbc:	05653023          	sd	s6,64(a0)
    80001bc0:	05753423          	sd	s7,72(a0)
    80001bc4:	05853823          	sd	s8,80(a0)
    80001bc8:	05953c23          	sd	s9,88(a0)
    80001bcc:	07a53023          	sd	s10,96(a0)
    80001bd0:	07b53423          	sd	s11,104(a0)
    80001bd4:	0005b083          	ld	ra,0(a1)
    80001bd8:	0085b103          	ld	sp,8(a1)
    80001bdc:	6980                	ld	s0,16(a1)
    80001bde:	6d84                	ld	s1,24(a1)
    80001be0:	0205b903          	ld	s2,32(a1)
    80001be4:	0285b983          	ld	s3,40(a1)
    80001be8:	0305ba03          	ld	s4,48(a1)
    80001bec:	0385ba83          	ld	s5,56(a1)
    80001bf0:	0405bb03          	ld	s6,64(a1)
    80001bf4:	0485bb83          	ld	s7,72(a1)
    80001bf8:	0505bc03          	ld	s8,80(a1)
    80001bfc:	0585bc83          	ld	s9,88(a1)
    80001c00:	0605bd03          	ld	s10,96(a1)
    80001c04:	0685bd83          	ld	s11,104(a1)
    80001c08:	8082                	ret

0000000080001c0a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c0a:	1141                	add	sp,sp,-16
    80001c0c:	e406                	sd	ra,8(sp)
    80001c0e:	e022                	sd	s0,0(sp)
    80001c10:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001c12:	00006597          	auipc	a1,0x6
    80001c16:	67658593          	add	a1,a1,1654 # 80008288 <etext+0x288>
    80001c1a:	0000d517          	auipc	a0,0xd
    80001c1e:	46650513          	add	a0,a0,1126 # 8000f080 <tickslock>
    80001c22:	00004097          	auipc	ra,0x4
    80001c26:	774080e7          	jalr	1908(ra) # 80006396 <initlock>
}
    80001c2a:	60a2                	ld	ra,8(sp)
    80001c2c:	6402                	ld	s0,0(sp)
    80001c2e:	0141                	add	sp,sp,16
    80001c30:	8082                	ret

0000000080001c32 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c32:	1141                	add	sp,sp,-16
    80001c34:	e422                	sd	s0,8(sp)
    80001c36:	0800                	add	s0,sp,16
    asm volatile("csrw stvec, %0" : : "r"(x));
    80001c38:	00003797          	auipc	a5,0x3
    80001c3c:	68878793          	add	a5,a5,1672 # 800052c0 <kernelvec>
    80001c40:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c44:	6422                	ld	s0,8(sp)
    80001c46:	0141                	add	sp,sp,16
    80001c48:	8082                	ret

0000000080001c4a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c4a:	1141                	add	sp,sp,-16
    80001c4c:	e406                	sd	ra,8(sp)
    80001c4e:	e022                	sd	s0,0(sp)
    80001c50:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001c52:	fffff097          	auipc	ra,0xfffff
    80001c56:	2ec080e7          	jalr	748(ra) # 80000f3e <myproc>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c5a:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c5e:	9bf5                	and	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001c60:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c64:	00005697          	auipc	a3,0x5
    80001c68:	39c68693          	add	a3,a3,924 # 80007000 <_trampoline>
    80001c6c:	00005717          	auipc	a4,0x5
    80001c70:	39470713          	add	a4,a4,916 # 80007000 <_trampoline>
    80001c74:	8f15                	sub	a4,a4,a3
    80001c76:	040007b7          	lui	a5,0x4000
    80001c7a:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c7c:	07b2                	sll	a5,a5,0xc
    80001c7e:	973e                	add	a4,a4,a5
    asm volatile("csrw stvec, %0" : : "r"(x));
    80001c80:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c84:	6d38                	ld	a4,88(a0)
    asm volatile("csrr %0, satp" : "=r"(x));
    80001c86:	18002673          	csrr	a2,satp
    80001c8a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c8c:	6d30                	ld	a2,88(a0)
    80001c8e:	6138                	ld	a4,64(a0)
    80001c90:	6585                	lui	a1,0x1
    80001c92:	972e                	add	a4,a4,a1
    80001c94:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c96:	6d38                	ld	a4,88(a0)
    80001c98:	00000617          	auipc	a2,0x0
    80001c9c:	14060613          	add	a2,a2,320 # 80001dd8 <usertrap>
    80001ca0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001ca2:	6d38                	ld	a4,88(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    80001ca4:	8612                	mv	a2,tp
    80001ca6:	f310                	sd	a2,32(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001ca8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cac:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cb0:	02076713          	or	a4,a4,32
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001cb4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cb8:	6d38                	ld	a4,88(a0)
    asm volatile("csrw sepc, %0" : : "r"(x));
    80001cba:	6f18                	ld	a4,24(a4)
    80001cbc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cc0:	692c                	ld	a1,80(a0)
    80001cc2:	81b1                	srl	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cc4:	00005717          	auipc	a4,0x5
    80001cc8:	3cc70713          	add	a4,a4,972 # 80007090 <userret>
    80001ccc:	8f15                	sub	a4,a4,a3
    80001cce:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cd0:	577d                	li	a4,-1
    80001cd2:	177e                	sll	a4,a4,0x3f
    80001cd4:	8dd9                	or	a1,a1,a4
    80001cd6:	02000537          	lui	a0,0x2000
    80001cda:	157d                	add	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001cdc:	0536                	sll	a0,a0,0xd
    80001cde:	9782                	jalr	a5
}
    80001ce0:	60a2                	ld	ra,8(sp)
    80001ce2:	6402                	ld	s0,0(sp)
    80001ce4:	0141                	add	sp,sp,16
    80001ce6:	8082                	ret

0000000080001ce8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ce8:	1101                	add	sp,sp,-32
    80001cea:	ec06                	sd	ra,24(sp)
    80001cec:	e822                	sd	s0,16(sp)
    80001cee:	e426                	sd	s1,8(sp)
    80001cf0:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001cf2:	0000d497          	auipc	s1,0xd
    80001cf6:	38e48493          	add	s1,s1,910 # 8000f080 <tickslock>
    80001cfa:	8526                	mv	a0,s1
    80001cfc:	00004097          	auipc	ra,0x4
    80001d00:	72a080e7          	jalr	1834(ra) # 80006426 <acquire>
  ticks++;
    80001d04:	00007517          	auipc	a0,0x7
    80001d08:	31450513          	add	a0,a0,788 # 80009018 <ticks>
    80001d0c:	411c                	lw	a5,0(a0)
    80001d0e:	2785                	addw	a5,a5,1
    80001d10:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d12:	00000097          	auipc	ra,0x0
    80001d16:	b1a080e7          	jalr	-1254(ra) # 8000182c <wakeup>
  release(&tickslock);
    80001d1a:	8526                	mv	a0,s1
    80001d1c:	00004097          	auipc	ra,0x4
    80001d20:	7be080e7          	jalr	1982(ra) # 800064da <release>
}
    80001d24:	60e2                	ld	ra,24(sp)
    80001d26:	6442                	ld	s0,16(sp)
    80001d28:	64a2                	ld	s1,8(sp)
    80001d2a:	6105                	add	sp,sp,32
    80001d2c:	8082                	ret

0000000080001d2e <devintr>:
    asm volatile("csrr %0, scause" : "=r"(x));
    80001d2e:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d32:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001d34:	0a07d163          	bgez	a5,80001dd6 <devintr+0xa8>
{
    80001d38:	1101                	add	sp,sp,-32
    80001d3a:	ec06                	sd	ra,24(sp)
    80001d3c:	e822                	sd	s0,16(sp)
    80001d3e:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001d40:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001d44:	46a5                	li	a3,9
    80001d46:	00d70c63          	beq	a4,a3,80001d5e <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001d4a:	577d                	li	a4,-1
    80001d4c:	177e                	sll	a4,a4,0x3f
    80001d4e:	0705                	add	a4,a4,1
    return 0;
    80001d50:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d52:	06e78163          	beq	a5,a4,80001db4 <devintr+0x86>
  }
}
    80001d56:	60e2                	ld	ra,24(sp)
    80001d58:	6442                	ld	s0,16(sp)
    80001d5a:	6105                	add	sp,sp,32
    80001d5c:	8082                	ret
    80001d5e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001d60:	00003097          	auipc	ra,0x3
    80001d64:	66c080e7          	jalr	1644(ra) # 800053cc <plic_claim>
    80001d68:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d6a:	47a9                	li	a5,10
    80001d6c:	00f50963          	beq	a0,a5,80001d7e <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001d70:	4785                	li	a5,1
    80001d72:	00f50b63          	beq	a0,a5,80001d88 <devintr+0x5a>
    return 1;
    80001d76:	4505                	li	a0,1
    } else if(irq){
    80001d78:	ec89                	bnez	s1,80001d92 <devintr+0x64>
    80001d7a:	64a2                	ld	s1,8(sp)
    80001d7c:	bfe9                	j	80001d56 <devintr+0x28>
      uartintr();
    80001d7e:	00004097          	auipc	ra,0x4
    80001d82:	5c8080e7          	jalr	1480(ra) # 80006346 <uartintr>
    if(irq)
    80001d86:	a839                	j	80001da4 <devintr+0x76>
      virtio_disk_intr();
    80001d88:	00004097          	auipc	ra,0x4
    80001d8c:	b18080e7          	jalr	-1256(ra) # 800058a0 <virtio_disk_intr>
    if(irq)
    80001d90:	a811                	j	80001da4 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d92:	85a6                	mv	a1,s1
    80001d94:	00006517          	auipc	a0,0x6
    80001d98:	4fc50513          	add	a0,a0,1276 # 80008290 <etext+0x290>
    80001d9c:	00004097          	auipc	ra,0x4
    80001da0:	15a080e7          	jalr	346(ra) # 80005ef6 <printf>
      plic_complete(irq);
    80001da4:	8526                	mv	a0,s1
    80001da6:	00003097          	auipc	ra,0x3
    80001daa:	64a080e7          	jalr	1610(ra) # 800053f0 <plic_complete>
    return 1;
    80001dae:	4505                	li	a0,1
    80001db0:	64a2                	ld	s1,8(sp)
    80001db2:	b755                	j	80001d56 <devintr+0x28>
    if(cpuid() == 0){
    80001db4:	fffff097          	auipc	ra,0xfffff
    80001db8:	15e080e7          	jalr	350(ra) # 80000f12 <cpuid>
    80001dbc:	c901                	beqz	a0,80001dcc <devintr+0x9e>
    asm volatile("csrr %0, sip" : "=r"(x));
    80001dbe:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001dc2:	9bf5                	and	a5,a5,-3
    asm volatile("csrw sip, %0" : : "r"(x));
    80001dc4:	14479073          	csrw	sip,a5
    return 2;
    80001dc8:	4509                	li	a0,2
    80001dca:	b771                	j	80001d56 <devintr+0x28>
      clockintr();
    80001dcc:	00000097          	auipc	ra,0x0
    80001dd0:	f1c080e7          	jalr	-228(ra) # 80001ce8 <clockintr>
    80001dd4:	b7ed                	j	80001dbe <devintr+0x90>
}
    80001dd6:	8082                	ret

0000000080001dd8 <usertrap>:
{
    80001dd8:	1101                	add	sp,sp,-32
    80001dda:	ec06                	sd	ra,24(sp)
    80001ddc:	e822                	sd	s0,16(sp)
    80001dde:	e426                	sd	s1,8(sp)
    80001de0:	e04a                	sd	s2,0(sp)
    80001de2:	1000                	add	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001de4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001de8:	1007f793          	and	a5,a5,256
    80001dec:	e3ad                	bnez	a5,80001e4e <usertrap+0x76>
    asm volatile("csrw stvec, %0" : : "r"(x));
    80001dee:	00003797          	auipc	a5,0x3
    80001df2:	4d278793          	add	a5,a5,1234 # 800052c0 <kernelvec>
    80001df6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001dfa:	fffff097          	auipc	ra,0xfffff
    80001dfe:	144080e7          	jalr	324(ra) # 80000f3e <myproc>
    80001e02:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e04:	6d3c                	ld	a5,88(a0)
    asm volatile("csrr %0, sepc" : "=r"(x));
    80001e06:	14102773          	csrr	a4,sepc
    80001e0a:	ef98                	sd	a4,24(a5)
    asm volatile("csrr %0, scause" : "=r"(x));
    80001e0c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e10:	47a1                	li	a5,8
    80001e12:	04f71c63          	bne	a4,a5,80001e6a <usertrap+0x92>
    if(p->killed)
    80001e16:	551c                	lw	a5,40(a0)
    80001e18:	e3b9                	bnez	a5,80001e5e <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e1a:	6cb8                	ld	a4,88(s1)
    80001e1c:	6f1c                	ld	a5,24(a4)
    80001e1e:	0791                	add	a5,a5,4
    80001e20:	ef1c                	sd	a5,24(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e22:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e26:	0027e793          	or	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e2a:	10079073          	csrw	sstatus,a5
    syscall();
    80001e2e:	00000097          	auipc	ra,0x0
    80001e32:	2e0080e7          	jalr	736(ra) # 8000210e <syscall>
  if(p->killed)
    80001e36:	549c                	lw	a5,40(s1)
    80001e38:	ebc1                	bnez	a5,80001ec8 <usertrap+0xf0>
  usertrapret();
    80001e3a:	00000097          	auipc	ra,0x0
    80001e3e:	e10080e7          	jalr	-496(ra) # 80001c4a <usertrapret>
}
    80001e42:	60e2                	ld	ra,24(sp)
    80001e44:	6442                	ld	s0,16(sp)
    80001e46:	64a2                	ld	s1,8(sp)
    80001e48:	6902                	ld	s2,0(sp)
    80001e4a:	6105                	add	sp,sp,32
    80001e4c:	8082                	ret
    panic("usertrap: not from user mode");
    80001e4e:	00006517          	auipc	a0,0x6
    80001e52:	46250513          	add	a0,a0,1122 # 800082b0 <etext+0x2b0>
    80001e56:	00004097          	auipc	ra,0x4
    80001e5a:	056080e7          	jalr	86(ra) # 80005eac <panic>
      exit(-1);
    80001e5e:	557d                	li	a0,-1
    80001e60:	00000097          	auipc	ra,0x0
    80001e64:	a9c080e7          	jalr	-1380(ra) # 800018fc <exit>
    80001e68:	bf4d                	j	80001e1a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e6a:	00000097          	auipc	ra,0x0
    80001e6e:	ec4080e7          	jalr	-316(ra) # 80001d2e <devintr>
    80001e72:	892a                	mv	s2,a0
    80001e74:	c501                	beqz	a0,80001e7c <usertrap+0xa4>
  if(p->killed)
    80001e76:	549c                	lw	a5,40(s1)
    80001e78:	c3a1                	beqz	a5,80001eb8 <usertrap+0xe0>
    80001e7a:	a815                	j	80001eae <usertrap+0xd6>
    asm volatile("csrr %0, scause" : "=r"(x));
    80001e7c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e80:	5890                	lw	a2,48(s1)
    80001e82:	00006517          	auipc	a0,0x6
    80001e86:	44e50513          	add	a0,a0,1102 # 800082d0 <etext+0x2d0>
    80001e8a:	00004097          	auipc	ra,0x4
    80001e8e:	06c080e7          	jalr	108(ra) # 80005ef6 <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80001e92:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80001e96:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e9a:	00006517          	auipc	a0,0x6
    80001e9e:	46650513          	add	a0,a0,1126 # 80008300 <etext+0x300>
    80001ea2:	00004097          	auipc	ra,0x4
    80001ea6:	054080e7          	jalr	84(ra) # 80005ef6 <printf>
    p->killed = 1;
    80001eaa:	4785                	li	a5,1
    80001eac:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001eae:	557d                	li	a0,-1
    80001eb0:	00000097          	auipc	ra,0x0
    80001eb4:	a4c080e7          	jalr	-1460(ra) # 800018fc <exit>
  if(which_dev == 2)
    80001eb8:	4789                	li	a5,2
    80001eba:	f8f910e3          	bne	s2,a5,80001e3a <usertrap+0x62>
    yield();
    80001ebe:	fffff097          	auipc	ra,0xfffff
    80001ec2:	7a6080e7          	jalr	1958(ra) # 80001664 <yield>
    80001ec6:	bf95                	j	80001e3a <usertrap+0x62>
  int which_dev = 0;
    80001ec8:	4901                	li	s2,0
    80001eca:	b7d5                	j	80001eae <usertrap+0xd6>

0000000080001ecc <kerneltrap>:
{
    80001ecc:	7179                	add	sp,sp,-48
    80001ece:	f406                	sd	ra,40(sp)
    80001ed0:	f022                	sd	s0,32(sp)
    80001ed2:	ec26                	sd	s1,24(sp)
    80001ed4:	e84a                	sd	s2,16(sp)
    80001ed6:	e44e                	sd	s3,8(sp)
    80001ed8:	1800                	add	s0,sp,48
    asm volatile("csrr %0, sepc" : "=r"(x));
    80001eda:	14102973          	csrr	s2,sepc
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001ede:	100024f3          	csrr	s1,sstatus
    asm volatile("csrr %0, scause" : "=r"(x));
    80001ee2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ee6:	1004f793          	and	a5,s1,256
    80001eea:	cb85                	beqz	a5,80001f1a <kerneltrap+0x4e>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001eec:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80001ef0:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80001ef2:	ef85                	bnez	a5,80001f2a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ef4:	00000097          	auipc	ra,0x0
    80001ef8:	e3a080e7          	jalr	-454(ra) # 80001d2e <devintr>
    80001efc:	cd1d                	beqz	a0,80001f3a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001efe:	4789                	li	a5,2
    80001f00:	06f50a63          	beq	a0,a5,80001f74 <kerneltrap+0xa8>
    asm volatile("csrw sepc, %0" : : "r"(x));
    80001f04:	14191073          	csrw	sepc,s2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001f08:	10049073          	csrw	sstatus,s1
}
    80001f0c:	70a2                	ld	ra,40(sp)
    80001f0e:	7402                	ld	s0,32(sp)
    80001f10:	64e2                	ld	s1,24(sp)
    80001f12:	6942                	ld	s2,16(sp)
    80001f14:	69a2                	ld	s3,8(sp)
    80001f16:	6145                	add	sp,sp,48
    80001f18:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f1a:	00006517          	auipc	a0,0x6
    80001f1e:	40650513          	add	a0,a0,1030 # 80008320 <etext+0x320>
    80001f22:	00004097          	auipc	ra,0x4
    80001f26:	f8a080e7          	jalr	-118(ra) # 80005eac <panic>
    panic("kerneltrap: interrupts enabled");
    80001f2a:	00006517          	auipc	a0,0x6
    80001f2e:	41e50513          	add	a0,a0,1054 # 80008348 <etext+0x348>
    80001f32:	00004097          	auipc	ra,0x4
    80001f36:	f7a080e7          	jalr	-134(ra) # 80005eac <panic>
    printf("scause %p\n", scause);
    80001f3a:	85ce                	mv	a1,s3
    80001f3c:	00006517          	auipc	a0,0x6
    80001f40:	42c50513          	add	a0,a0,1068 # 80008368 <etext+0x368>
    80001f44:	00004097          	auipc	ra,0x4
    80001f48:	fb2080e7          	jalr	-78(ra) # 80005ef6 <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80001f4c:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80001f50:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f54:	00006517          	auipc	a0,0x6
    80001f58:	42450513          	add	a0,a0,1060 # 80008378 <etext+0x378>
    80001f5c:	00004097          	auipc	ra,0x4
    80001f60:	f9a080e7          	jalr	-102(ra) # 80005ef6 <printf>
    panic("kerneltrap");
    80001f64:	00006517          	auipc	a0,0x6
    80001f68:	42c50513          	add	a0,a0,1068 # 80008390 <etext+0x390>
    80001f6c:	00004097          	auipc	ra,0x4
    80001f70:	f40080e7          	jalr	-192(ra) # 80005eac <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	fca080e7          	jalr	-54(ra) # 80000f3e <myproc>
    80001f7c:	d541                	beqz	a0,80001f04 <kerneltrap+0x38>
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	fc0080e7          	jalr	-64(ra) # 80000f3e <myproc>
    80001f86:	4d18                	lw	a4,24(a0)
    80001f88:	4791                	li	a5,4
    80001f8a:	f6f71de3          	bne	a4,a5,80001f04 <kerneltrap+0x38>
    yield();
    80001f8e:	fffff097          	auipc	ra,0xfffff
    80001f92:	6d6080e7          	jalr	1750(ra) # 80001664 <yield>
    80001f96:	b7bd                	j	80001f04 <kerneltrap+0x38>

0000000080001f98 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f98:	1101                	add	sp,sp,-32
    80001f9a:	ec06                	sd	ra,24(sp)
    80001f9c:	e822                	sd	s0,16(sp)
    80001f9e:	e426                	sd	s1,8(sp)
    80001fa0:	1000                	add	s0,sp,32
    80001fa2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	f9a080e7          	jalr	-102(ra) # 80000f3e <myproc>
  switch (n) {
    80001fac:	4795                	li	a5,5
    80001fae:	0497e163          	bltu	a5,s1,80001ff0 <argraw+0x58>
    80001fb2:	048a                	sll	s1,s1,0x2
    80001fb4:	00006717          	auipc	a4,0x6
    80001fb8:	7c470713          	add	a4,a4,1988 # 80008778 <states.0+0x30>
    80001fbc:	94ba                	add	s1,s1,a4
    80001fbe:	409c                	lw	a5,0(s1)
    80001fc0:	97ba                	add	a5,a5,a4
    80001fc2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fc4:	6d3c                	ld	a5,88(a0)
    80001fc6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fc8:	60e2                	ld	ra,24(sp)
    80001fca:	6442                	ld	s0,16(sp)
    80001fcc:	64a2                	ld	s1,8(sp)
    80001fce:	6105                	add	sp,sp,32
    80001fd0:	8082                	ret
    return p->trapframe->a1;
    80001fd2:	6d3c                	ld	a5,88(a0)
    80001fd4:	7fa8                	ld	a0,120(a5)
    80001fd6:	bfcd                	j	80001fc8 <argraw+0x30>
    return p->trapframe->a2;
    80001fd8:	6d3c                	ld	a5,88(a0)
    80001fda:	63c8                	ld	a0,128(a5)
    80001fdc:	b7f5                	j	80001fc8 <argraw+0x30>
    return p->trapframe->a3;
    80001fde:	6d3c                	ld	a5,88(a0)
    80001fe0:	67c8                	ld	a0,136(a5)
    80001fe2:	b7dd                	j	80001fc8 <argraw+0x30>
    return p->trapframe->a4;
    80001fe4:	6d3c                	ld	a5,88(a0)
    80001fe6:	6bc8                	ld	a0,144(a5)
    80001fe8:	b7c5                	j	80001fc8 <argraw+0x30>
    return p->trapframe->a5;
    80001fea:	6d3c                	ld	a5,88(a0)
    80001fec:	6fc8                	ld	a0,152(a5)
    80001fee:	bfe9                	j	80001fc8 <argraw+0x30>
  panic("argraw");
    80001ff0:	00006517          	auipc	a0,0x6
    80001ff4:	3b050513          	add	a0,a0,944 # 800083a0 <etext+0x3a0>
    80001ff8:	00004097          	auipc	ra,0x4
    80001ffc:	eb4080e7          	jalr	-332(ra) # 80005eac <panic>

0000000080002000 <fetchaddr>:
{
    80002000:	1101                	add	sp,sp,-32
    80002002:	ec06                	sd	ra,24(sp)
    80002004:	e822                	sd	s0,16(sp)
    80002006:	e426                	sd	s1,8(sp)
    80002008:	e04a                	sd	s2,0(sp)
    8000200a:	1000                	add	s0,sp,32
    8000200c:	84aa                	mv	s1,a0
    8000200e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	f2e080e7          	jalr	-210(ra) # 80000f3e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002018:	653c                	ld	a5,72(a0)
    8000201a:	02f4f863          	bgeu	s1,a5,8000204a <fetchaddr+0x4a>
    8000201e:	00848713          	add	a4,s1,8
    80002022:	02e7e663          	bltu	a5,a4,8000204e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002026:	46a1                	li	a3,8
    80002028:	8626                	mv	a2,s1
    8000202a:	85ca                	mv	a1,s2
    8000202c:	6928                	ld	a0,80(a0)
    8000202e:	fffff097          	auipc	ra,0xfffff
    80002032:	b76080e7          	jalr	-1162(ra) # 80000ba4 <copyin>
    80002036:	00a03533          	snez	a0,a0
    8000203a:	40a00533          	neg	a0,a0
}
    8000203e:	60e2                	ld	ra,24(sp)
    80002040:	6442                	ld	s0,16(sp)
    80002042:	64a2                	ld	s1,8(sp)
    80002044:	6902                	ld	s2,0(sp)
    80002046:	6105                	add	sp,sp,32
    80002048:	8082                	ret
    return -1;
    8000204a:	557d                	li	a0,-1
    8000204c:	bfcd                	j	8000203e <fetchaddr+0x3e>
    8000204e:	557d                	li	a0,-1
    80002050:	b7fd                	j	8000203e <fetchaddr+0x3e>

0000000080002052 <fetchstr>:
{
    80002052:	7179                	add	sp,sp,-48
    80002054:	f406                	sd	ra,40(sp)
    80002056:	f022                	sd	s0,32(sp)
    80002058:	ec26                	sd	s1,24(sp)
    8000205a:	e84a                	sd	s2,16(sp)
    8000205c:	e44e                	sd	s3,8(sp)
    8000205e:	1800                	add	s0,sp,48
    80002060:	892a                	mv	s2,a0
    80002062:	84ae                	mv	s1,a1
    80002064:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002066:	fffff097          	auipc	ra,0xfffff
    8000206a:	ed8080e7          	jalr	-296(ra) # 80000f3e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000206e:	86ce                	mv	a3,s3
    80002070:	864a                	mv	a2,s2
    80002072:	85a6                	mv	a1,s1
    80002074:	6928                	ld	a0,80(a0)
    80002076:	fffff097          	auipc	ra,0xfffff
    8000207a:	bbc080e7          	jalr	-1092(ra) # 80000c32 <copyinstr>
  if(err < 0)
    8000207e:	00054763          	bltz	a0,8000208c <fetchstr+0x3a>
  return strlen(buf);
    80002082:	8526                	mv	a0,s1
    80002084:	ffffe097          	auipc	ra,0xffffe
    80002088:	26a080e7          	jalr	618(ra) # 800002ee <strlen>
}
    8000208c:	70a2                	ld	ra,40(sp)
    8000208e:	7402                	ld	s0,32(sp)
    80002090:	64e2                	ld	s1,24(sp)
    80002092:	6942                	ld	s2,16(sp)
    80002094:	69a2                	ld	s3,8(sp)
    80002096:	6145                	add	sp,sp,48
    80002098:	8082                	ret

000000008000209a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000209a:	1101                	add	sp,sp,-32
    8000209c:	ec06                	sd	ra,24(sp)
    8000209e:	e822                	sd	s0,16(sp)
    800020a0:	e426                	sd	s1,8(sp)
    800020a2:	1000                	add	s0,sp,32
    800020a4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020a6:	00000097          	auipc	ra,0x0
    800020aa:	ef2080e7          	jalr	-270(ra) # 80001f98 <argraw>
    800020ae:	c088                	sw	a0,0(s1)
  return 0;
}
    800020b0:	4501                	li	a0,0
    800020b2:	60e2                	ld	ra,24(sp)
    800020b4:	6442                	ld	s0,16(sp)
    800020b6:	64a2                	ld	s1,8(sp)
    800020b8:	6105                	add	sp,sp,32
    800020ba:	8082                	ret

00000000800020bc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020bc:	1101                	add	sp,sp,-32
    800020be:	ec06                	sd	ra,24(sp)
    800020c0:	e822                	sd	s0,16(sp)
    800020c2:	e426                	sd	s1,8(sp)
    800020c4:	1000                	add	s0,sp,32
    800020c6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020c8:	00000097          	auipc	ra,0x0
    800020cc:	ed0080e7          	jalr	-304(ra) # 80001f98 <argraw>
    800020d0:	e088                	sd	a0,0(s1)
  return 0;
}
    800020d2:	4501                	li	a0,0
    800020d4:	60e2                	ld	ra,24(sp)
    800020d6:	6442                	ld	s0,16(sp)
    800020d8:	64a2                	ld	s1,8(sp)
    800020da:	6105                	add	sp,sp,32
    800020dc:	8082                	ret

00000000800020de <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020de:	1101                	add	sp,sp,-32
    800020e0:	ec06                	sd	ra,24(sp)
    800020e2:	e822                	sd	s0,16(sp)
    800020e4:	e426                	sd	s1,8(sp)
    800020e6:	e04a                	sd	s2,0(sp)
    800020e8:	1000                	add	s0,sp,32
    800020ea:	84ae                	mv	s1,a1
    800020ec:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020ee:	00000097          	auipc	ra,0x0
    800020f2:	eaa080e7          	jalr	-342(ra) # 80001f98 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020f6:	864a                	mv	a2,s2
    800020f8:	85a6                	mv	a1,s1
    800020fa:	00000097          	auipc	ra,0x0
    800020fe:	f58080e7          	jalr	-168(ra) # 80002052 <fetchstr>
}
    80002102:	60e2                	ld	ra,24(sp)
    80002104:	6442                	ld	s0,16(sp)
    80002106:	64a2                	ld	s1,8(sp)
    80002108:	6902                	ld	s2,0(sp)
    8000210a:	6105                	add	sp,sp,32
    8000210c:	8082                	ret

000000008000210e <syscall>:



void
syscall(void)
{
    8000210e:	1101                	add	sp,sp,-32
    80002110:	ec06                	sd	ra,24(sp)
    80002112:	e822                	sd	s0,16(sp)
    80002114:	e426                	sd	s1,8(sp)
    80002116:	e04a                	sd	s2,0(sp)
    80002118:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000211a:	fffff097          	auipc	ra,0xfffff
    8000211e:	e24080e7          	jalr	-476(ra) # 80000f3e <myproc>
    80002122:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002124:	05853903          	ld	s2,88(a0)
    80002128:	0a893783          	ld	a5,168(s2)
    8000212c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002130:	37fd                	addw	a5,a5,-1
    80002132:	4775                	li	a4,29
    80002134:	00f76f63          	bltu	a4,a5,80002152 <syscall+0x44>
    80002138:	00369713          	sll	a4,a3,0x3
    8000213c:	00006797          	auipc	a5,0x6
    80002140:	65478793          	add	a5,a5,1620 # 80008790 <syscalls>
    80002144:	97ba                	add	a5,a5,a4
    80002146:	639c                	ld	a5,0(a5)
    80002148:	c789                	beqz	a5,80002152 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000214a:	9782                	jalr	a5
    8000214c:	06a93823          	sd	a0,112(s2)
    80002150:	a839                	j	8000216e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002152:	15848613          	add	a2,s1,344
    80002156:	588c                	lw	a1,48(s1)
    80002158:	00006517          	auipc	a0,0x6
    8000215c:	25050513          	add	a0,a0,592 # 800083a8 <etext+0x3a8>
    80002160:	00004097          	auipc	ra,0x4
    80002164:	d96080e7          	jalr	-618(ra) # 80005ef6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002168:	6cbc                	ld	a5,88(s1)
    8000216a:	577d                	li	a4,-1
    8000216c:	fbb8                	sd	a4,112(a5)
  }
}
    8000216e:	60e2                	ld	ra,24(sp)
    80002170:	6442                	ld	s0,16(sp)
    80002172:	64a2                	ld	s1,8(sp)
    80002174:	6902                	ld	s2,0(sp)
    80002176:	6105                	add	sp,sp,32
    80002178:	8082                	ret

000000008000217a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000217a:	1101                	add	sp,sp,-32
    8000217c:	ec06                	sd	ra,24(sp)
    8000217e:	e822                	sd	s0,16(sp)
    80002180:	1000                	add	s0,sp,32
    int n;
    if (argint(0, &n) < 0)
    80002182:	fec40593          	add	a1,s0,-20
    80002186:	4501                	li	a0,0
    80002188:	00000097          	auipc	ra,0x0
    8000218c:	f12080e7          	jalr	-238(ra) # 8000209a <argint>
        return -1;
    80002190:	57fd                	li	a5,-1
    if (argint(0, &n) < 0)
    80002192:	00054963          	bltz	a0,800021a4 <sys_exit+0x2a>
    exit(n);
    80002196:	fec42503          	lw	a0,-20(s0)
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	762080e7          	jalr	1890(ra) # 800018fc <exit>
    return 0; // not reached
    800021a2:	4781                	li	a5,0
}
    800021a4:	853e                	mv	a0,a5
    800021a6:	60e2                	ld	ra,24(sp)
    800021a8:	6442                	ld	s0,16(sp)
    800021aa:	6105                	add	sp,sp,32
    800021ac:	8082                	ret

00000000800021ae <sys_getpid>:

uint64
sys_getpid(void)
{
    800021ae:	1141                	add	sp,sp,-16
    800021b0:	e406                	sd	ra,8(sp)
    800021b2:	e022                	sd	s0,0(sp)
    800021b4:	0800                	add	s0,sp,16
    return myproc()->pid;
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	d88080e7          	jalr	-632(ra) # 80000f3e <myproc>
}
    800021be:	5908                	lw	a0,48(a0)
    800021c0:	60a2                	ld	ra,8(sp)
    800021c2:	6402                	ld	s0,0(sp)
    800021c4:	0141                	add	sp,sp,16
    800021c6:	8082                	ret

00000000800021c8 <sys_fork>:

uint64
sys_fork(void)
{
    800021c8:	1141                	add	sp,sp,-16
    800021ca:	e406                	sd	ra,8(sp)
    800021cc:	e022                	sd	s0,0(sp)
    800021ce:	0800                	add	s0,sp,16
    return fork();
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	1dc080e7          	jalr	476(ra) # 800013ac <fork>
}
    800021d8:	60a2                	ld	ra,8(sp)
    800021da:	6402                	ld	s0,0(sp)
    800021dc:	0141                	add	sp,sp,16
    800021de:	8082                	ret

00000000800021e0 <sys_wait>:

uint64
sys_wait(void)
{
    800021e0:	1101                	add	sp,sp,-32
    800021e2:	ec06                	sd	ra,24(sp)
    800021e4:	e822                	sd	s0,16(sp)
    800021e6:	1000                	add	s0,sp,32
    uint64 p;
    if (argaddr(0, &p) < 0)
    800021e8:	fe840593          	add	a1,s0,-24
    800021ec:	4501                	li	a0,0
    800021ee:	00000097          	auipc	ra,0x0
    800021f2:	ece080e7          	jalr	-306(ra) # 800020bc <argaddr>
    800021f6:	87aa                	mv	a5,a0
        return -1;
    800021f8:	557d                	li	a0,-1
    if (argaddr(0, &p) < 0)
    800021fa:	0007c863          	bltz	a5,8000220a <sys_wait+0x2a>
    return wait(p);
    800021fe:	fe843503          	ld	a0,-24(s0)
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	502080e7          	jalr	1282(ra) # 80001704 <wait>
}
    8000220a:	60e2                	ld	ra,24(sp)
    8000220c:	6442                	ld	s0,16(sp)
    8000220e:	6105                	add	sp,sp,32
    80002210:	8082                	ret

0000000080002212 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002212:	7179                	add	sp,sp,-48
    80002214:	f406                	sd	ra,40(sp)
    80002216:	f022                	sd	s0,32(sp)
    80002218:	1800                	add	s0,sp,48
    int addr;
    int n;

    if (argint(0, &n) < 0)
    8000221a:	fdc40593          	add	a1,s0,-36
    8000221e:	4501                	li	a0,0
    80002220:	00000097          	auipc	ra,0x0
    80002224:	e7a080e7          	jalr	-390(ra) # 8000209a <argint>
    80002228:	87aa                	mv	a5,a0
        return -1;
    8000222a:	557d                	li	a0,-1
    if (argint(0, &n) < 0)
    8000222c:	0207c263          	bltz	a5,80002250 <sys_sbrk+0x3e>
    80002230:	ec26                	sd	s1,24(sp)

    addr = myproc()->sz;
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	d0c080e7          	jalr	-756(ra) # 80000f3e <myproc>
    8000223a:	4524                	lw	s1,72(a0)
    if (growproc(n) < 0)
    8000223c:	fdc42503          	lw	a0,-36(s0)
    80002240:	fffff097          	auipc	ra,0xfffff
    80002244:	0f4080e7          	jalr	244(ra) # 80001334 <growproc>
    80002248:	00054863          	bltz	a0,80002258 <sys_sbrk+0x46>
        return -1;
    return addr;
    8000224c:	8526                	mv	a0,s1
    8000224e:	64e2                	ld	s1,24(sp)
}
    80002250:	70a2                	ld	ra,40(sp)
    80002252:	7402                	ld	s0,32(sp)
    80002254:	6145                	add	sp,sp,48
    80002256:	8082                	ret
        return -1;
    80002258:	557d                	li	a0,-1
    8000225a:	64e2                	ld	s1,24(sp)
    8000225c:	bfd5                	j	80002250 <sys_sbrk+0x3e>

000000008000225e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000225e:	7139                	add	sp,sp,-64
    80002260:	fc06                	sd	ra,56(sp)
    80002262:	f822                	sd	s0,48(sp)
    80002264:	0080                	add	s0,sp,64
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
    80002266:	fcc40593          	add	a1,s0,-52
    8000226a:	4501                	li	a0,0
    8000226c:	00000097          	auipc	ra,0x0
    80002270:	e2e080e7          	jalr	-466(ra) # 8000209a <argint>
        return -1;
    80002274:	57fd                	li	a5,-1
    if (argint(0, &n) < 0)
    80002276:	06054b63          	bltz	a0,800022ec <sys_sleep+0x8e>
    8000227a:	f04a                	sd	s2,32(sp)
    acquire(&tickslock);
    8000227c:	0000d517          	auipc	a0,0xd
    80002280:	e0450513          	add	a0,a0,-508 # 8000f080 <tickslock>
    80002284:	00004097          	auipc	ra,0x4
    80002288:	1a2080e7          	jalr	418(ra) # 80006426 <acquire>
    ticks0 = ticks;
    8000228c:	00007917          	auipc	s2,0x7
    80002290:	d8c92903          	lw	s2,-628(s2) # 80009018 <ticks>
    while (ticks - ticks0 < n)
    80002294:	fcc42783          	lw	a5,-52(s0)
    80002298:	c3a1                	beqz	a5,800022d8 <sys_sleep+0x7a>
    8000229a:	f426                	sd	s1,40(sp)
    8000229c:	ec4e                	sd	s3,24(sp)
        if (myproc()->killed)
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    8000229e:	0000d997          	auipc	s3,0xd
    800022a2:	de298993          	add	s3,s3,-542 # 8000f080 <tickslock>
    800022a6:	00007497          	auipc	s1,0x7
    800022aa:	d7248493          	add	s1,s1,-654 # 80009018 <ticks>
        if (myproc()->killed)
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	c90080e7          	jalr	-880(ra) # 80000f3e <myproc>
    800022b6:	551c                	lw	a5,40(a0)
    800022b8:	ef9d                	bnez	a5,800022f6 <sys_sleep+0x98>
        sleep(&ticks, &tickslock);
    800022ba:	85ce                	mv	a1,s3
    800022bc:	8526                	mv	a0,s1
    800022be:	fffff097          	auipc	ra,0xfffff
    800022c2:	3e2080e7          	jalr	994(ra) # 800016a0 <sleep>
    while (ticks - ticks0 < n)
    800022c6:	409c                	lw	a5,0(s1)
    800022c8:	412787bb          	subw	a5,a5,s2
    800022cc:	fcc42703          	lw	a4,-52(s0)
    800022d0:	fce7efe3          	bltu	a5,a4,800022ae <sys_sleep+0x50>
    800022d4:	74a2                	ld	s1,40(sp)
    800022d6:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    800022d8:	0000d517          	auipc	a0,0xd
    800022dc:	da850513          	add	a0,a0,-600 # 8000f080 <tickslock>
    800022e0:	00004097          	auipc	ra,0x4
    800022e4:	1fa080e7          	jalr	506(ra) # 800064da <release>
    return 0;
    800022e8:	4781                	li	a5,0
    800022ea:	7902                	ld	s2,32(sp)
}
    800022ec:	853e                	mv	a0,a5
    800022ee:	70e2                	ld	ra,56(sp)
    800022f0:	7442                	ld	s0,48(sp)
    800022f2:	6121                	add	sp,sp,64
    800022f4:	8082                	ret
            release(&tickslock);
    800022f6:	0000d517          	auipc	a0,0xd
    800022fa:	d8a50513          	add	a0,a0,-630 # 8000f080 <tickslock>
    800022fe:	00004097          	auipc	ra,0x4
    80002302:	1dc080e7          	jalr	476(ra) # 800064da <release>
            return -1;
    80002306:	57fd                	li	a5,-1
    80002308:	74a2                	ld	s1,40(sp)
    8000230a:	7902                	ld	s2,32(sp)
    8000230c:	69e2                	ld	s3,24(sp)
    8000230e:	bff9                	j	800022ec <sys_sleep+0x8e>

0000000080002310 <sys_kill>:

uint64
sys_kill(void)
{
    80002310:	1101                	add	sp,sp,-32
    80002312:	ec06                	sd	ra,24(sp)
    80002314:	e822                	sd	s0,16(sp)
    80002316:	1000                	add	s0,sp,32
    int pid;

    if (argint(0, &pid) < 0)
    80002318:	fec40593          	add	a1,s0,-20
    8000231c:	4501                	li	a0,0
    8000231e:	00000097          	auipc	ra,0x0
    80002322:	d7c080e7          	jalr	-644(ra) # 8000209a <argint>
    80002326:	87aa                	mv	a5,a0
        return -1;
    80002328:	557d                	li	a0,-1
    if (argint(0, &pid) < 0)
    8000232a:	0007c863          	bltz	a5,8000233a <sys_kill+0x2a>
    return kill(pid);
    8000232e:	fec42503          	lw	a0,-20(s0)
    80002332:	fffff097          	auipc	ra,0xfffff
    80002336:	6a0080e7          	jalr	1696(ra) # 800019d2 <kill>
}
    8000233a:	60e2                	ld	ra,24(sp)
    8000233c:	6442                	ld	s0,16(sp)
    8000233e:	6105                	add	sp,sp,32
    80002340:	8082                	ret

0000000080002342 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002342:	1101                	add	sp,sp,-32
    80002344:	ec06                	sd	ra,24(sp)
    80002346:	e822                	sd	s0,16(sp)
    80002348:	e426                	sd	s1,8(sp)
    8000234a:	1000                	add	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    8000234c:	0000d517          	auipc	a0,0xd
    80002350:	d3450513          	add	a0,a0,-716 # 8000f080 <tickslock>
    80002354:	00004097          	auipc	ra,0x4
    80002358:	0d2080e7          	jalr	210(ra) # 80006426 <acquire>
    xticks = ticks;
    8000235c:	00007497          	auipc	s1,0x7
    80002360:	cbc4a483          	lw	s1,-836(s1) # 80009018 <ticks>
    release(&tickslock);
    80002364:	0000d517          	auipc	a0,0xd
    80002368:	d1c50513          	add	a0,a0,-740 # 8000f080 <tickslock>
    8000236c:	00004097          	auipc	ra,0x4
    80002370:	16e080e7          	jalr	366(ra) # 800064da <release>
    return xticks;
}
    80002374:	02049513          	sll	a0,s1,0x20
    80002378:	9101                	srl	a0,a0,0x20
    8000237a:	60e2                	ld	ra,24(sp)
    8000237c:	6442                	ld	s0,16(sp)
    8000237e:	64a2                	ld	s1,8(sp)
    80002380:	6105                	add	sp,sp,32
    80002382:	8082                	ret

0000000080002384 <sys_pgaccess>:

// get the pages have been accesed by the process
uint64 sys_pgaccess(void)
{
    80002384:	711d                	add	sp,sp,-96
    80002386:	ec86                	sd	ra,88(sp)
    80002388:	e8a2                	sd	s0,80(sp)
    8000238a:	1080                	add	s0,sp,96
    uint64 addr;
    int len;
    uint64 maskaddr;
    if (argaddr(0, &addr) < 0 || argint(1, &len) < 0 || argaddr(2, &maskaddr))
    8000238c:	fb840593          	add	a1,s0,-72
    80002390:	4501                	li	a0,0
    80002392:	00000097          	auipc	ra,0x0
    80002396:	d2a080e7          	jalr	-726(ra) # 800020bc <argaddr>
    {
        return -1;
    8000239a:	57fd                	li	a5,-1
    if (argaddr(0, &addr) < 0 || argint(1, &len) < 0 || argaddr(2, &maskaddr))
    8000239c:	0e054b63          	bltz	a0,80002492 <sys_pgaccess+0x10e>
    800023a0:	fb440593          	add	a1,s0,-76
    800023a4:	4505                	li	a0,1
    800023a6:	00000097          	auipc	ra,0x0
    800023aa:	cf4080e7          	jalr	-780(ra) # 8000209a <argint>
        return -1;
    800023ae:	57fd                	li	a5,-1
    if (argaddr(0, &addr) < 0 || argint(1, &len) < 0 || argaddr(2, &maskaddr))
    800023b0:	0e054163          	bltz	a0,80002492 <sys_pgaccess+0x10e>
    800023b4:	e4a6                	sd	s1,72(sp)
    800023b6:	fa840593          	add	a1,s0,-88
    800023ba:	4509                	li	a0,2
    800023bc:	00000097          	auipc	ra,0x0
    800023c0:	d00080e7          	jalr	-768(ra) # 800020bc <argaddr>
    800023c4:	84aa                	mv	s1,a0
        return -1;
    800023c6:	57fd                	li	a5,-1
    if (argaddr(0, &addr) < 0 || argint(1, &len) < 0 || argaddr(2, &maskaddr))
    800023c8:	e171                	bnez	a0,8000248c <sys_pgaccess+0x108>
    }
    if (len > 32)
    800023ca:	fb442683          	lw	a3,-76(s0)
    800023ce:	02000713          	li	a4,32
    800023d2:	0ad74f63          	blt	a4,a3,80002490 <sys_pgaccess+0x10c>
    800023d6:	e0ca                	sd	s2,64(sp)
    {
        return -1;
    }
    struct proc *p = myproc();
    800023d8:	fffff097          	auipc	ra,0xfffff
    800023dc:	b66080e7          	jalr	-1178(ra) # 80000f3e <myproc>
    800023e0:	892a                	mv	s2,a0
    uint32 res = 0;
    800023e2:	fa042223          	sw	zero,-92(s0)

    for (int i = 0; i < len; ++i)
    800023e6:	fb442783          	lw	a5,-76(s0)
    800023ea:	06f05363          	blez	a5,80002450 <sys_pgaccess+0xcc>
    800023ee:	fc4e                	sd	s3,56(sp)
    800023f0:	f852                	sd	s4,48(sp)
    800023f2:	f456                	sd	s5,40(sp)
    {
        if (addr >= MAXVA)
    800023f4:	59fd                	li	s3,-1
    800023f6:	01a9d993          	srl	s3,s3,0x1a
        }
        // check if the pte is accessed
        if (*pte & PTE_A)
        {
            *pte &= (~PTE_A); // clear the accessed bit
            res |= (1 << i);  // set the bit in the result
    800023fa:	4a85                	li	s5,1
        }
        addr += PGSIZE;
    800023fc:	6a05                	lui	s4,0x1
    800023fe:	a819                	j	80002414 <sys_pgaccess+0x90>
    80002400:	fb843783          	ld	a5,-72(s0)
    80002404:	97d2                	add	a5,a5,s4
    80002406:	faf43c23          	sd	a5,-72(s0)
    for (int i = 0; i < len; ++i)
    8000240a:	2485                	addw	s1,s1,1
    8000240c:	fb442783          	lw	a5,-76(s0)
    80002410:	02f4dd63          	bge	s1,a5,8000244a <sys_pgaccess+0xc6>
        if (addr >= MAXVA)
    80002414:	fb843583          	ld	a1,-72(s0)
    80002418:	04b9ec63          	bltu	s3,a1,80002470 <sys_pgaccess+0xec>
        pte_t *pte = walk(p->pagetable, addr, 0);
    8000241c:	4601                	li	a2,0
    8000241e:	05093503          	ld	a0,80(s2)
    80002422:	ffffe097          	auipc	ra,0xffffe
    80002426:	030080e7          	jalr	48(ra) # 80000452 <walk>
        if (pte == 0)
    8000242a:	c931                	beqz	a0,8000247e <sys_pgaccess+0xfa>
        if (*pte & PTE_A)
    8000242c:	611c                	ld	a5,0(a0)
    8000242e:	0407f713          	and	a4,a5,64
    80002432:	d779                	beqz	a4,80002400 <sys_pgaccess+0x7c>
            *pte &= (~PTE_A); // clear the accessed bit
    80002434:	fbf7f793          	and	a5,a5,-65
    80002438:	e11c                	sd	a5,0(a0)
            res |= (1 << i);  // set the bit in the result
    8000243a:	009a973b          	sllw	a4,s5,s1
    8000243e:	fa442783          	lw	a5,-92(s0)
    80002442:	8fd9                	or	a5,a5,a4
    80002444:	faf42223          	sw	a5,-92(s0)
    80002448:	bf65                	j	80002400 <sys_pgaccess+0x7c>
    8000244a:	79e2                	ld	s3,56(sp)
    8000244c:	7a42                	ld	s4,48(sp)
    8000244e:	7aa2                	ld	s5,40(sp)
    }
    // copyout the result to the user space
    if (copyout(p->pagetable, maskaddr, (char *)&res, sizeof(res)) < 0)
    80002450:	4691                	li	a3,4
    80002452:	fa440613          	add	a2,s0,-92
    80002456:	fa843583          	ld	a1,-88(s0)
    8000245a:	05093503          	ld	a0,80(s2)
    8000245e:	ffffe097          	auipc	ra,0xffffe
    80002462:	6ba080e7          	jalr	1722(ra) # 80000b18 <copyout>
    80002466:	43f55793          	sra	a5,a0,0x3f
    8000246a:	64a6                	ld	s1,72(sp)
    8000246c:	6906                	ld	s2,64(sp)
    8000246e:	a015                	j	80002492 <sys_pgaccess+0x10e>
            return -1;
    80002470:	57fd                	li	a5,-1
    80002472:	64a6                	ld	s1,72(sp)
    80002474:	6906                	ld	s2,64(sp)
    80002476:	79e2                	ld	s3,56(sp)
    80002478:	7a42                	ld	s4,48(sp)
    8000247a:	7aa2                	ld	s5,40(sp)
    8000247c:	a819                	j	80002492 <sys_pgaccess+0x10e>
            return -1;
    8000247e:	57fd                	li	a5,-1
    80002480:	64a6                	ld	s1,72(sp)
    80002482:	6906                	ld	s2,64(sp)
    80002484:	79e2                	ld	s3,56(sp)
    80002486:	7a42                	ld	s4,48(sp)
    80002488:	7aa2                	ld	s5,40(sp)
    8000248a:	a021                	j	80002492 <sys_pgaccess+0x10e>
    8000248c:	64a6                	ld	s1,72(sp)
    8000248e:	a011                	j	80002492 <sys_pgaccess+0x10e>
    80002490:	64a6                	ld	s1,72(sp)
    {
        return -1;
    }
    return 0;
    80002492:	853e                	mv	a0,a5
    80002494:	60e6                	ld	ra,88(sp)
    80002496:	6446                	ld	s0,80(sp)
    80002498:	6125                	add	sp,sp,96
    8000249a:	8082                	ret

000000008000249c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000249c:	7179                	add	sp,sp,-48
    8000249e:	f406                	sd	ra,40(sp)
    800024a0:	f022                	sd	s0,32(sp)
    800024a2:	ec26                	sd	s1,24(sp)
    800024a4:	e84a                	sd	s2,16(sp)
    800024a6:	e44e                	sd	s3,8(sp)
    800024a8:	e052                	sd	s4,0(sp)
    800024aa:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024ac:	00006597          	auipc	a1,0x6
    800024b0:	f1c58593          	add	a1,a1,-228 # 800083c8 <etext+0x3c8>
    800024b4:	0000d517          	auipc	a0,0xd
    800024b8:	be450513          	add	a0,a0,-1052 # 8000f098 <bcache>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	eda080e7          	jalr	-294(ra) # 80006396 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024c4:	00015797          	auipc	a5,0x15
    800024c8:	bd478793          	add	a5,a5,-1068 # 80017098 <bcache+0x8000>
    800024cc:	00015717          	auipc	a4,0x15
    800024d0:	e3470713          	add	a4,a4,-460 # 80017300 <bcache+0x8268>
    800024d4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024d8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024dc:	0000d497          	auipc	s1,0xd
    800024e0:	bd448493          	add	s1,s1,-1068 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024e4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024e6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024e8:	00006a17          	auipc	s4,0x6
    800024ec:	ee8a0a13          	add	s4,s4,-280 # 800083d0 <etext+0x3d0>
    b->next = bcache.head.next;
    800024f0:	2b893783          	ld	a5,696(s2)
    800024f4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024f6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024fa:	85d2                	mv	a1,s4
    800024fc:	01048513          	add	a0,s1,16
    80002500:	00001097          	auipc	ra,0x1
    80002504:	4b2080e7          	jalr	1202(ra) # 800039b2 <initsleeplock>
    bcache.head.next->prev = b;
    80002508:	2b893783          	ld	a5,696(s2)
    8000250c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000250e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002512:	45848493          	add	s1,s1,1112
    80002516:	fd349de3          	bne	s1,s3,800024f0 <binit+0x54>
  }
}
    8000251a:	70a2                	ld	ra,40(sp)
    8000251c:	7402                	ld	s0,32(sp)
    8000251e:	64e2                	ld	s1,24(sp)
    80002520:	6942                	ld	s2,16(sp)
    80002522:	69a2                	ld	s3,8(sp)
    80002524:	6a02                	ld	s4,0(sp)
    80002526:	6145                	add	sp,sp,48
    80002528:	8082                	ret

000000008000252a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000252a:	7179                	add	sp,sp,-48
    8000252c:	f406                	sd	ra,40(sp)
    8000252e:	f022                	sd	s0,32(sp)
    80002530:	ec26                	sd	s1,24(sp)
    80002532:	e84a                	sd	s2,16(sp)
    80002534:	e44e                	sd	s3,8(sp)
    80002536:	1800                	add	s0,sp,48
    80002538:	892a                	mv	s2,a0
    8000253a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000253c:	0000d517          	auipc	a0,0xd
    80002540:	b5c50513          	add	a0,a0,-1188 # 8000f098 <bcache>
    80002544:	00004097          	auipc	ra,0x4
    80002548:	ee2080e7          	jalr	-286(ra) # 80006426 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000254c:	00015497          	auipc	s1,0x15
    80002550:	e044b483          	ld	s1,-508(s1) # 80017350 <bcache+0x82b8>
    80002554:	00015797          	auipc	a5,0x15
    80002558:	dac78793          	add	a5,a5,-596 # 80017300 <bcache+0x8268>
    8000255c:	02f48f63          	beq	s1,a5,8000259a <bread+0x70>
    80002560:	873e                	mv	a4,a5
    80002562:	a021                	j	8000256a <bread+0x40>
    80002564:	68a4                	ld	s1,80(s1)
    80002566:	02e48a63          	beq	s1,a4,8000259a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000256a:	449c                	lw	a5,8(s1)
    8000256c:	ff279ce3          	bne	a5,s2,80002564 <bread+0x3a>
    80002570:	44dc                	lw	a5,12(s1)
    80002572:	ff3799e3          	bne	a5,s3,80002564 <bread+0x3a>
      b->refcnt++;
    80002576:	40bc                	lw	a5,64(s1)
    80002578:	2785                	addw	a5,a5,1
    8000257a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000257c:	0000d517          	auipc	a0,0xd
    80002580:	b1c50513          	add	a0,a0,-1252 # 8000f098 <bcache>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	f56080e7          	jalr	-170(ra) # 800064da <release>
      acquiresleep(&b->lock);
    8000258c:	01048513          	add	a0,s1,16
    80002590:	00001097          	auipc	ra,0x1
    80002594:	45c080e7          	jalr	1116(ra) # 800039ec <acquiresleep>
      return b;
    80002598:	a8b9                	j	800025f6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000259a:	00015497          	auipc	s1,0x15
    8000259e:	dae4b483          	ld	s1,-594(s1) # 80017348 <bcache+0x82b0>
    800025a2:	00015797          	auipc	a5,0x15
    800025a6:	d5e78793          	add	a5,a5,-674 # 80017300 <bcache+0x8268>
    800025aa:	00f48863          	beq	s1,a5,800025ba <bread+0x90>
    800025ae:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025b0:	40bc                	lw	a5,64(s1)
    800025b2:	cf81                	beqz	a5,800025ca <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025b4:	64a4                	ld	s1,72(s1)
    800025b6:	fee49de3          	bne	s1,a4,800025b0 <bread+0x86>
  panic("bget: no buffers");
    800025ba:	00006517          	auipc	a0,0x6
    800025be:	e1e50513          	add	a0,a0,-482 # 800083d8 <etext+0x3d8>
    800025c2:	00004097          	auipc	ra,0x4
    800025c6:	8ea080e7          	jalr	-1814(ra) # 80005eac <panic>
      b->dev = dev;
    800025ca:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025ce:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025d2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025d6:	4785                	li	a5,1
    800025d8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025da:	0000d517          	auipc	a0,0xd
    800025de:	abe50513          	add	a0,a0,-1346 # 8000f098 <bcache>
    800025e2:	00004097          	auipc	ra,0x4
    800025e6:	ef8080e7          	jalr	-264(ra) # 800064da <release>
      acquiresleep(&b->lock);
    800025ea:	01048513          	add	a0,s1,16
    800025ee:	00001097          	auipc	ra,0x1
    800025f2:	3fe080e7          	jalr	1022(ra) # 800039ec <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025f6:	409c                	lw	a5,0(s1)
    800025f8:	cb89                	beqz	a5,8000260a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025fa:	8526                	mv	a0,s1
    800025fc:	70a2                	ld	ra,40(sp)
    800025fe:	7402                	ld	s0,32(sp)
    80002600:	64e2                	ld	s1,24(sp)
    80002602:	6942                	ld	s2,16(sp)
    80002604:	69a2                	ld	s3,8(sp)
    80002606:	6145                	add	sp,sp,48
    80002608:	8082                	ret
    virtio_disk_rw(b, 0);
    8000260a:	4581                	li	a1,0
    8000260c:	8526                	mv	a0,s1
    8000260e:	00003097          	auipc	ra,0x3
    80002612:	004080e7          	jalr	4(ra) # 80005612 <virtio_disk_rw>
    b->valid = 1;
    80002616:	4785                	li	a5,1
    80002618:	c09c                	sw	a5,0(s1)
  return b;
    8000261a:	b7c5                	j	800025fa <bread+0xd0>

000000008000261c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000261c:	1101                	add	sp,sp,-32
    8000261e:	ec06                	sd	ra,24(sp)
    80002620:	e822                	sd	s0,16(sp)
    80002622:	e426                	sd	s1,8(sp)
    80002624:	1000                	add	s0,sp,32
    80002626:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002628:	0541                	add	a0,a0,16
    8000262a:	00001097          	auipc	ra,0x1
    8000262e:	45c080e7          	jalr	1116(ra) # 80003a86 <holdingsleep>
    80002632:	cd01                	beqz	a0,8000264a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002634:	4585                	li	a1,1
    80002636:	8526                	mv	a0,s1
    80002638:	00003097          	auipc	ra,0x3
    8000263c:	fda080e7          	jalr	-38(ra) # 80005612 <virtio_disk_rw>
}
    80002640:	60e2                	ld	ra,24(sp)
    80002642:	6442                	ld	s0,16(sp)
    80002644:	64a2                	ld	s1,8(sp)
    80002646:	6105                	add	sp,sp,32
    80002648:	8082                	ret
    panic("bwrite");
    8000264a:	00006517          	auipc	a0,0x6
    8000264e:	da650513          	add	a0,a0,-602 # 800083f0 <etext+0x3f0>
    80002652:	00004097          	auipc	ra,0x4
    80002656:	85a080e7          	jalr	-1958(ra) # 80005eac <panic>

000000008000265a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000265a:	1101                	add	sp,sp,-32
    8000265c:	ec06                	sd	ra,24(sp)
    8000265e:	e822                	sd	s0,16(sp)
    80002660:	e426                	sd	s1,8(sp)
    80002662:	e04a                	sd	s2,0(sp)
    80002664:	1000                	add	s0,sp,32
    80002666:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002668:	01050913          	add	s2,a0,16
    8000266c:	854a                	mv	a0,s2
    8000266e:	00001097          	auipc	ra,0x1
    80002672:	418080e7          	jalr	1048(ra) # 80003a86 <holdingsleep>
    80002676:	c925                	beqz	a0,800026e6 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002678:	854a                	mv	a0,s2
    8000267a:	00001097          	auipc	ra,0x1
    8000267e:	3c8080e7          	jalr	968(ra) # 80003a42 <releasesleep>

  acquire(&bcache.lock);
    80002682:	0000d517          	auipc	a0,0xd
    80002686:	a1650513          	add	a0,a0,-1514 # 8000f098 <bcache>
    8000268a:	00004097          	auipc	ra,0x4
    8000268e:	d9c080e7          	jalr	-612(ra) # 80006426 <acquire>
  b->refcnt--;
    80002692:	40bc                	lw	a5,64(s1)
    80002694:	37fd                	addw	a5,a5,-1
    80002696:	0007871b          	sext.w	a4,a5
    8000269a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000269c:	e71d                	bnez	a4,800026ca <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000269e:	68b8                	ld	a4,80(s1)
    800026a0:	64bc                	ld	a5,72(s1)
    800026a2:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800026a4:	68b8                	ld	a4,80(s1)
    800026a6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026a8:	00015797          	auipc	a5,0x15
    800026ac:	9f078793          	add	a5,a5,-1552 # 80017098 <bcache+0x8000>
    800026b0:	2b87b703          	ld	a4,696(a5)
    800026b4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026b6:	00015717          	auipc	a4,0x15
    800026ba:	c4a70713          	add	a4,a4,-950 # 80017300 <bcache+0x8268>
    800026be:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026c0:	2b87b703          	ld	a4,696(a5)
    800026c4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026c6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026ca:	0000d517          	auipc	a0,0xd
    800026ce:	9ce50513          	add	a0,a0,-1586 # 8000f098 <bcache>
    800026d2:	00004097          	auipc	ra,0x4
    800026d6:	e08080e7          	jalr	-504(ra) # 800064da <release>
}
    800026da:	60e2                	ld	ra,24(sp)
    800026dc:	6442                	ld	s0,16(sp)
    800026de:	64a2                	ld	s1,8(sp)
    800026e0:	6902                	ld	s2,0(sp)
    800026e2:	6105                	add	sp,sp,32
    800026e4:	8082                	ret
    panic("brelse");
    800026e6:	00006517          	auipc	a0,0x6
    800026ea:	d1250513          	add	a0,a0,-750 # 800083f8 <etext+0x3f8>
    800026ee:	00003097          	auipc	ra,0x3
    800026f2:	7be080e7          	jalr	1982(ra) # 80005eac <panic>

00000000800026f6 <bpin>:

void
bpin(struct buf *b) {
    800026f6:	1101                	add	sp,sp,-32
    800026f8:	ec06                	sd	ra,24(sp)
    800026fa:	e822                	sd	s0,16(sp)
    800026fc:	e426                	sd	s1,8(sp)
    800026fe:	1000                	add	s0,sp,32
    80002700:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002702:	0000d517          	auipc	a0,0xd
    80002706:	99650513          	add	a0,a0,-1642 # 8000f098 <bcache>
    8000270a:	00004097          	auipc	ra,0x4
    8000270e:	d1c080e7          	jalr	-740(ra) # 80006426 <acquire>
  b->refcnt++;
    80002712:	40bc                	lw	a5,64(s1)
    80002714:	2785                	addw	a5,a5,1
    80002716:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002718:	0000d517          	auipc	a0,0xd
    8000271c:	98050513          	add	a0,a0,-1664 # 8000f098 <bcache>
    80002720:	00004097          	auipc	ra,0x4
    80002724:	dba080e7          	jalr	-582(ra) # 800064da <release>
}
    80002728:	60e2                	ld	ra,24(sp)
    8000272a:	6442                	ld	s0,16(sp)
    8000272c:	64a2                	ld	s1,8(sp)
    8000272e:	6105                	add	sp,sp,32
    80002730:	8082                	ret

0000000080002732 <bunpin>:

void
bunpin(struct buf *b) {
    80002732:	1101                	add	sp,sp,-32
    80002734:	ec06                	sd	ra,24(sp)
    80002736:	e822                	sd	s0,16(sp)
    80002738:	e426                	sd	s1,8(sp)
    8000273a:	1000                	add	s0,sp,32
    8000273c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000273e:	0000d517          	auipc	a0,0xd
    80002742:	95a50513          	add	a0,a0,-1702 # 8000f098 <bcache>
    80002746:	00004097          	auipc	ra,0x4
    8000274a:	ce0080e7          	jalr	-800(ra) # 80006426 <acquire>
  b->refcnt--;
    8000274e:	40bc                	lw	a5,64(s1)
    80002750:	37fd                	addw	a5,a5,-1
    80002752:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002754:	0000d517          	auipc	a0,0xd
    80002758:	94450513          	add	a0,a0,-1724 # 8000f098 <bcache>
    8000275c:	00004097          	auipc	ra,0x4
    80002760:	d7e080e7          	jalr	-642(ra) # 800064da <release>
}
    80002764:	60e2                	ld	ra,24(sp)
    80002766:	6442                	ld	s0,16(sp)
    80002768:	64a2                	ld	s1,8(sp)
    8000276a:	6105                	add	sp,sp,32
    8000276c:	8082                	ret

000000008000276e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000276e:	1101                	add	sp,sp,-32
    80002770:	ec06                	sd	ra,24(sp)
    80002772:	e822                	sd	s0,16(sp)
    80002774:	e426                	sd	s1,8(sp)
    80002776:	e04a                	sd	s2,0(sp)
    80002778:	1000                	add	s0,sp,32
    8000277a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000277c:	00d5d59b          	srlw	a1,a1,0xd
    80002780:	00015797          	auipc	a5,0x15
    80002784:	ff47a783          	lw	a5,-12(a5) # 80017774 <sb+0x1c>
    80002788:	9dbd                	addw	a1,a1,a5
    8000278a:	00000097          	auipc	ra,0x0
    8000278e:	da0080e7          	jalr	-608(ra) # 8000252a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002792:	0074f713          	and	a4,s1,7
    80002796:	4785                	li	a5,1
    80002798:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000279c:	14ce                	sll	s1,s1,0x33
    8000279e:	90d9                	srl	s1,s1,0x36
    800027a0:	00950733          	add	a4,a0,s1
    800027a4:	05874703          	lbu	a4,88(a4)
    800027a8:	00e7f6b3          	and	a3,a5,a4
    800027ac:	c69d                	beqz	a3,800027da <bfree+0x6c>
    800027ae:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027b0:	94aa                	add	s1,s1,a0
    800027b2:	fff7c793          	not	a5,a5
    800027b6:	8f7d                	and	a4,a4,a5
    800027b8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800027bc:	00001097          	auipc	ra,0x1
    800027c0:	112080e7          	jalr	274(ra) # 800038ce <log_write>
  brelse(bp);
    800027c4:	854a                	mv	a0,s2
    800027c6:	00000097          	auipc	ra,0x0
    800027ca:	e94080e7          	jalr	-364(ra) # 8000265a <brelse>
}
    800027ce:	60e2                	ld	ra,24(sp)
    800027d0:	6442                	ld	s0,16(sp)
    800027d2:	64a2                	ld	s1,8(sp)
    800027d4:	6902                	ld	s2,0(sp)
    800027d6:	6105                	add	sp,sp,32
    800027d8:	8082                	ret
    panic("freeing free block");
    800027da:	00006517          	auipc	a0,0x6
    800027de:	c2650513          	add	a0,a0,-986 # 80008400 <etext+0x400>
    800027e2:	00003097          	auipc	ra,0x3
    800027e6:	6ca080e7          	jalr	1738(ra) # 80005eac <panic>

00000000800027ea <balloc>:
{
    800027ea:	711d                	add	sp,sp,-96
    800027ec:	ec86                	sd	ra,88(sp)
    800027ee:	e8a2                	sd	s0,80(sp)
    800027f0:	e4a6                	sd	s1,72(sp)
    800027f2:	e0ca                	sd	s2,64(sp)
    800027f4:	fc4e                	sd	s3,56(sp)
    800027f6:	f852                	sd	s4,48(sp)
    800027f8:	f456                	sd	s5,40(sp)
    800027fa:	f05a                	sd	s6,32(sp)
    800027fc:	ec5e                	sd	s7,24(sp)
    800027fe:	e862                	sd	s8,16(sp)
    80002800:	e466                	sd	s9,8(sp)
    80002802:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002804:	00015797          	auipc	a5,0x15
    80002808:	f587a783          	lw	a5,-168(a5) # 8001775c <sb+0x4>
    8000280c:	cbc1                	beqz	a5,8000289c <balloc+0xb2>
    8000280e:	8baa                	mv	s7,a0
    80002810:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002812:	00015b17          	auipc	s6,0x15
    80002816:	f46b0b13          	add	s6,s6,-186 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000281a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000281c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000281e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002820:	6c89                	lui	s9,0x2
    80002822:	a831                	j	8000283e <balloc+0x54>
    brelse(bp);
    80002824:	854a                	mv	a0,s2
    80002826:	00000097          	auipc	ra,0x0
    8000282a:	e34080e7          	jalr	-460(ra) # 8000265a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000282e:	015c87bb          	addw	a5,s9,s5
    80002832:	00078a9b          	sext.w	s5,a5
    80002836:	004b2703          	lw	a4,4(s6)
    8000283a:	06eaf163          	bgeu	s5,a4,8000289c <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000283e:	41fad79b          	sraw	a5,s5,0x1f
    80002842:	0137d79b          	srlw	a5,a5,0x13
    80002846:	015787bb          	addw	a5,a5,s5
    8000284a:	40d7d79b          	sraw	a5,a5,0xd
    8000284e:	01cb2583          	lw	a1,28(s6)
    80002852:	9dbd                	addw	a1,a1,a5
    80002854:	855e                	mv	a0,s7
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	cd4080e7          	jalr	-812(ra) # 8000252a <bread>
    8000285e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002860:	004b2503          	lw	a0,4(s6)
    80002864:	000a849b          	sext.w	s1,s5
    80002868:	8762                	mv	a4,s8
    8000286a:	faa4fde3          	bgeu	s1,a0,80002824 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000286e:	00777693          	and	a3,a4,7
    80002872:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002876:	41f7579b          	sraw	a5,a4,0x1f
    8000287a:	01d7d79b          	srlw	a5,a5,0x1d
    8000287e:	9fb9                	addw	a5,a5,a4
    80002880:	4037d79b          	sraw	a5,a5,0x3
    80002884:	00f90633          	add	a2,s2,a5
    80002888:	05864603          	lbu	a2,88(a2)
    8000288c:	00c6f5b3          	and	a1,a3,a2
    80002890:	cd91                	beqz	a1,800028ac <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002892:	2705                	addw	a4,a4,1
    80002894:	2485                	addw	s1,s1,1
    80002896:	fd471ae3          	bne	a4,s4,8000286a <balloc+0x80>
    8000289a:	b769                	j	80002824 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000289c:	00006517          	auipc	a0,0x6
    800028a0:	b7c50513          	add	a0,a0,-1156 # 80008418 <etext+0x418>
    800028a4:	00003097          	auipc	ra,0x3
    800028a8:	608080e7          	jalr	1544(ra) # 80005eac <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028ac:	97ca                	add	a5,a5,s2
    800028ae:	8e55                	or	a2,a2,a3
    800028b0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800028b4:	854a                	mv	a0,s2
    800028b6:	00001097          	auipc	ra,0x1
    800028ba:	018080e7          	jalr	24(ra) # 800038ce <log_write>
        brelse(bp);
    800028be:	854a                	mv	a0,s2
    800028c0:	00000097          	auipc	ra,0x0
    800028c4:	d9a080e7          	jalr	-614(ra) # 8000265a <brelse>
  bp = bread(dev, bno);
    800028c8:	85a6                	mv	a1,s1
    800028ca:	855e                	mv	a0,s7
    800028cc:	00000097          	auipc	ra,0x0
    800028d0:	c5e080e7          	jalr	-930(ra) # 8000252a <bread>
    800028d4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028d6:	40000613          	li	a2,1024
    800028da:	4581                	li	a1,0
    800028dc:	05850513          	add	a0,a0,88
    800028e0:	ffffe097          	auipc	ra,0xffffe
    800028e4:	89a080e7          	jalr	-1894(ra) # 8000017a <memset>
  log_write(bp);
    800028e8:	854a                	mv	a0,s2
    800028ea:	00001097          	auipc	ra,0x1
    800028ee:	fe4080e7          	jalr	-28(ra) # 800038ce <log_write>
  brelse(bp);
    800028f2:	854a                	mv	a0,s2
    800028f4:	00000097          	auipc	ra,0x0
    800028f8:	d66080e7          	jalr	-666(ra) # 8000265a <brelse>
}
    800028fc:	8526                	mv	a0,s1
    800028fe:	60e6                	ld	ra,88(sp)
    80002900:	6446                	ld	s0,80(sp)
    80002902:	64a6                	ld	s1,72(sp)
    80002904:	6906                	ld	s2,64(sp)
    80002906:	79e2                	ld	s3,56(sp)
    80002908:	7a42                	ld	s4,48(sp)
    8000290a:	7aa2                	ld	s5,40(sp)
    8000290c:	7b02                	ld	s6,32(sp)
    8000290e:	6be2                	ld	s7,24(sp)
    80002910:	6c42                	ld	s8,16(sp)
    80002912:	6ca2                	ld	s9,8(sp)
    80002914:	6125                	add	sp,sp,96
    80002916:	8082                	ret

0000000080002918 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002918:	7179                	add	sp,sp,-48
    8000291a:	f406                	sd	ra,40(sp)
    8000291c:	f022                	sd	s0,32(sp)
    8000291e:	ec26                	sd	s1,24(sp)
    80002920:	e84a                	sd	s2,16(sp)
    80002922:	e44e                	sd	s3,8(sp)
    80002924:	1800                	add	s0,sp,48
    80002926:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002928:	47ad                	li	a5,11
    8000292a:	04b7ff63          	bgeu	a5,a1,80002988 <bmap+0x70>
    8000292e:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002930:	ff45849b          	addw	s1,a1,-12
    80002934:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002938:	0ff00793          	li	a5,255
    8000293c:	0ae7e463          	bltu	a5,a4,800029e4 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002940:	08052583          	lw	a1,128(a0)
    80002944:	c5b5                	beqz	a1,800029b0 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002946:	00092503          	lw	a0,0(s2)
    8000294a:	00000097          	auipc	ra,0x0
    8000294e:	be0080e7          	jalr	-1056(ra) # 8000252a <bread>
    80002952:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002954:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002958:	02049713          	sll	a4,s1,0x20
    8000295c:	01e75593          	srl	a1,a4,0x1e
    80002960:	00b784b3          	add	s1,a5,a1
    80002964:	0004a983          	lw	s3,0(s1)
    80002968:	04098e63          	beqz	s3,800029c4 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000296c:	8552                	mv	a0,s4
    8000296e:	00000097          	auipc	ra,0x0
    80002972:	cec080e7          	jalr	-788(ra) # 8000265a <brelse>
    return addr;
    80002976:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002978:	854e                	mv	a0,s3
    8000297a:	70a2                	ld	ra,40(sp)
    8000297c:	7402                	ld	s0,32(sp)
    8000297e:	64e2                	ld	s1,24(sp)
    80002980:	6942                	ld	s2,16(sp)
    80002982:	69a2                	ld	s3,8(sp)
    80002984:	6145                	add	sp,sp,48
    80002986:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002988:	02059793          	sll	a5,a1,0x20
    8000298c:	01e7d593          	srl	a1,a5,0x1e
    80002990:	00b504b3          	add	s1,a0,a1
    80002994:	0504a983          	lw	s3,80(s1)
    80002998:	fe0990e3          	bnez	s3,80002978 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000299c:	4108                	lw	a0,0(a0)
    8000299e:	00000097          	auipc	ra,0x0
    800029a2:	e4c080e7          	jalr	-436(ra) # 800027ea <balloc>
    800029a6:	0005099b          	sext.w	s3,a0
    800029aa:	0534a823          	sw	s3,80(s1)
    800029ae:	b7e9                	j	80002978 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029b0:	4108                	lw	a0,0(a0)
    800029b2:	00000097          	auipc	ra,0x0
    800029b6:	e38080e7          	jalr	-456(ra) # 800027ea <balloc>
    800029ba:	0005059b          	sext.w	a1,a0
    800029be:	08b92023          	sw	a1,128(s2)
    800029c2:	b751                	j	80002946 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029c4:	00092503          	lw	a0,0(s2)
    800029c8:	00000097          	auipc	ra,0x0
    800029cc:	e22080e7          	jalr	-478(ra) # 800027ea <balloc>
    800029d0:	0005099b          	sext.w	s3,a0
    800029d4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029d8:	8552                	mv	a0,s4
    800029da:	00001097          	auipc	ra,0x1
    800029de:	ef4080e7          	jalr	-268(ra) # 800038ce <log_write>
    800029e2:	b769                	j	8000296c <bmap+0x54>
  panic("bmap: out of range");
    800029e4:	00006517          	auipc	a0,0x6
    800029e8:	a4c50513          	add	a0,a0,-1460 # 80008430 <etext+0x430>
    800029ec:	00003097          	auipc	ra,0x3
    800029f0:	4c0080e7          	jalr	1216(ra) # 80005eac <panic>

00000000800029f4 <iget>:
{
    800029f4:	7179                	add	sp,sp,-48
    800029f6:	f406                	sd	ra,40(sp)
    800029f8:	f022                	sd	s0,32(sp)
    800029fa:	ec26                	sd	s1,24(sp)
    800029fc:	e84a                	sd	s2,16(sp)
    800029fe:	e44e                	sd	s3,8(sp)
    80002a00:	e052                	sd	s4,0(sp)
    80002a02:	1800                	add	s0,sp,48
    80002a04:	89aa                	mv	s3,a0
    80002a06:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a08:	00015517          	auipc	a0,0x15
    80002a0c:	d7050513          	add	a0,a0,-656 # 80017778 <itable>
    80002a10:	00004097          	auipc	ra,0x4
    80002a14:	a16080e7          	jalr	-1514(ra) # 80006426 <acquire>
  empty = 0;
    80002a18:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a1a:	00015497          	auipc	s1,0x15
    80002a1e:	d7648493          	add	s1,s1,-650 # 80017790 <itable+0x18>
    80002a22:	00016697          	auipc	a3,0x16
    80002a26:	7fe68693          	add	a3,a3,2046 # 80019220 <log>
    80002a2a:	a039                	j	80002a38 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a2c:	02090b63          	beqz	s2,80002a62 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a30:	08848493          	add	s1,s1,136
    80002a34:	02d48a63          	beq	s1,a3,80002a68 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a38:	449c                	lw	a5,8(s1)
    80002a3a:	fef059e3          	blez	a5,80002a2c <iget+0x38>
    80002a3e:	4098                	lw	a4,0(s1)
    80002a40:	ff3716e3          	bne	a4,s3,80002a2c <iget+0x38>
    80002a44:	40d8                	lw	a4,4(s1)
    80002a46:	ff4713e3          	bne	a4,s4,80002a2c <iget+0x38>
      ip->ref++;
    80002a4a:	2785                	addw	a5,a5,1
    80002a4c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a4e:	00015517          	auipc	a0,0x15
    80002a52:	d2a50513          	add	a0,a0,-726 # 80017778 <itable>
    80002a56:	00004097          	auipc	ra,0x4
    80002a5a:	a84080e7          	jalr	-1404(ra) # 800064da <release>
      return ip;
    80002a5e:	8926                	mv	s2,s1
    80002a60:	a03d                	j	80002a8e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a62:	f7f9                	bnez	a5,80002a30 <iget+0x3c>
      empty = ip;
    80002a64:	8926                	mv	s2,s1
    80002a66:	b7e9                	j	80002a30 <iget+0x3c>
  if(empty == 0)
    80002a68:	02090c63          	beqz	s2,80002aa0 <iget+0xac>
  ip->dev = dev;
    80002a6c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a70:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a74:	4785                	li	a5,1
    80002a76:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a7a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a7e:	00015517          	auipc	a0,0x15
    80002a82:	cfa50513          	add	a0,a0,-774 # 80017778 <itable>
    80002a86:	00004097          	auipc	ra,0x4
    80002a8a:	a54080e7          	jalr	-1452(ra) # 800064da <release>
}
    80002a8e:	854a                	mv	a0,s2
    80002a90:	70a2                	ld	ra,40(sp)
    80002a92:	7402                	ld	s0,32(sp)
    80002a94:	64e2                	ld	s1,24(sp)
    80002a96:	6942                	ld	s2,16(sp)
    80002a98:	69a2                	ld	s3,8(sp)
    80002a9a:	6a02                	ld	s4,0(sp)
    80002a9c:	6145                	add	sp,sp,48
    80002a9e:	8082                	ret
    panic("iget: no inodes");
    80002aa0:	00006517          	auipc	a0,0x6
    80002aa4:	9a850513          	add	a0,a0,-1624 # 80008448 <etext+0x448>
    80002aa8:	00003097          	auipc	ra,0x3
    80002aac:	404080e7          	jalr	1028(ra) # 80005eac <panic>

0000000080002ab0 <fsinit>:
fsinit(int dev) {
    80002ab0:	7179                	add	sp,sp,-48
    80002ab2:	f406                	sd	ra,40(sp)
    80002ab4:	f022                	sd	s0,32(sp)
    80002ab6:	ec26                	sd	s1,24(sp)
    80002ab8:	e84a                	sd	s2,16(sp)
    80002aba:	e44e                	sd	s3,8(sp)
    80002abc:	1800                	add	s0,sp,48
    80002abe:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002ac0:	4585                	li	a1,1
    80002ac2:	00000097          	auipc	ra,0x0
    80002ac6:	a68080e7          	jalr	-1432(ra) # 8000252a <bread>
    80002aca:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002acc:	00015997          	auipc	s3,0x15
    80002ad0:	c8c98993          	add	s3,s3,-884 # 80017758 <sb>
    80002ad4:	02000613          	li	a2,32
    80002ad8:	05850593          	add	a1,a0,88
    80002adc:	854e                	mv	a0,s3
    80002ade:	ffffd097          	auipc	ra,0xffffd
    80002ae2:	6f8080e7          	jalr	1784(ra) # 800001d6 <memmove>
  brelse(bp);
    80002ae6:	8526                	mv	a0,s1
    80002ae8:	00000097          	auipc	ra,0x0
    80002aec:	b72080e7          	jalr	-1166(ra) # 8000265a <brelse>
  if(sb.magic != FSMAGIC)
    80002af0:	0009a703          	lw	a4,0(s3)
    80002af4:	102037b7          	lui	a5,0x10203
    80002af8:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002afc:	02f71263          	bne	a4,a5,80002b20 <fsinit+0x70>
  initlog(dev, &sb);
    80002b00:	00015597          	auipc	a1,0x15
    80002b04:	c5858593          	add	a1,a1,-936 # 80017758 <sb>
    80002b08:	854a                	mv	a0,s2
    80002b0a:	00001097          	auipc	ra,0x1
    80002b0e:	b54080e7          	jalr	-1196(ra) # 8000365e <initlog>
}
    80002b12:	70a2                	ld	ra,40(sp)
    80002b14:	7402                	ld	s0,32(sp)
    80002b16:	64e2                	ld	s1,24(sp)
    80002b18:	6942                	ld	s2,16(sp)
    80002b1a:	69a2                	ld	s3,8(sp)
    80002b1c:	6145                	add	sp,sp,48
    80002b1e:	8082                	ret
    panic("invalid file system");
    80002b20:	00006517          	auipc	a0,0x6
    80002b24:	93850513          	add	a0,a0,-1736 # 80008458 <etext+0x458>
    80002b28:	00003097          	auipc	ra,0x3
    80002b2c:	384080e7          	jalr	900(ra) # 80005eac <panic>

0000000080002b30 <iinit>:
{
    80002b30:	7179                	add	sp,sp,-48
    80002b32:	f406                	sd	ra,40(sp)
    80002b34:	f022                	sd	s0,32(sp)
    80002b36:	ec26                	sd	s1,24(sp)
    80002b38:	e84a                	sd	s2,16(sp)
    80002b3a:	e44e                	sd	s3,8(sp)
    80002b3c:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b3e:	00006597          	auipc	a1,0x6
    80002b42:	93258593          	add	a1,a1,-1742 # 80008470 <etext+0x470>
    80002b46:	00015517          	auipc	a0,0x15
    80002b4a:	c3250513          	add	a0,a0,-974 # 80017778 <itable>
    80002b4e:	00004097          	auipc	ra,0x4
    80002b52:	848080e7          	jalr	-1976(ra) # 80006396 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b56:	00015497          	auipc	s1,0x15
    80002b5a:	c4a48493          	add	s1,s1,-950 # 800177a0 <itable+0x28>
    80002b5e:	00016997          	auipc	s3,0x16
    80002b62:	6d298993          	add	s3,s3,1746 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b66:	00006917          	auipc	s2,0x6
    80002b6a:	91290913          	add	s2,s2,-1774 # 80008478 <etext+0x478>
    80002b6e:	85ca                	mv	a1,s2
    80002b70:	8526                	mv	a0,s1
    80002b72:	00001097          	auipc	ra,0x1
    80002b76:	e40080e7          	jalr	-448(ra) # 800039b2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b7a:	08848493          	add	s1,s1,136
    80002b7e:	ff3498e3          	bne	s1,s3,80002b6e <iinit+0x3e>
}
    80002b82:	70a2                	ld	ra,40(sp)
    80002b84:	7402                	ld	s0,32(sp)
    80002b86:	64e2                	ld	s1,24(sp)
    80002b88:	6942                	ld	s2,16(sp)
    80002b8a:	69a2                	ld	s3,8(sp)
    80002b8c:	6145                	add	sp,sp,48
    80002b8e:	8082                	ret

0000000080002b90 <ialloc>:
{
    80002b90:	7139                	add	sp,sp,-64
    80002b92:	fc06                	sd	ra,56(sp)
    80002b94:	f822                	sd	s0,48(sp)
    80002b96:	f426                	sd	s1,40(sp)
    80002b98:	f04a                	sd	s2,32(sp)
    80002b9a:	ec4e                	sd	s3,24(sp)
    80002b9c:	e852                	sd	s4,16(sp)
    80002b9e:	e456                	sd	s5,8(sp)
    80002ba0:	e05a                	sd	s6,0(sp)
    80002ba2:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ba4:	00015717          	auipc	a4,0x15
    80002ba8:	bc072703          	lw	a4,-1088(a4) # 80017764 <sb+0xc>
    80002bac:	4785                	li	a5,1
    80002bae:	04e7f863          	bgeu	a5,a4,80002bfe <ialloc+0x6e>
    80002bb2:	8aaa                	mv	s5,a0
    80002bb4:	8b2e                	mv	s6,a1
    80002bb6:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bb8:	00015a17          	auipc	s4,0x15
    80002bbc:	ba0a0a13          	add	s4,s4,-1120 # 80017758 <sb>
    80002bc0:	00495593          	srl	a1,s2,0x4
    80002bc4:	018a2783          	lw	a5,24(s4)
    80002bc8:	9dbd                	addw	a1,a1,a5
    80002bca:	8556                	mv	a0,s5
    80002bcc:	00000097          	auipc	ra,0x0
    80002bd0:	95e080e7          	jalr	-1698(ra) # 8000252a <bread>
    80002bd4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bd6:	05850993          	add	s3,a0,88
    80002bda:	00f97793          	and	a5,s2,15
    80002bde:	079a                	sll	a5,a5,0x6
    80002be0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002be2:	00099783          	lh	a5,0(s3)
    80002be6:	c785                	beqz	a5,80002c0e <ialloc+0x7e>
    brelse(bp);
    80002be8:	00000097          	auipc	ra,0x0
    80002bec:	a72080e7          	jalr	-1422(ra) # 8000265a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bf0:	0905                	add	s2,s2,1
    80002bf2:	00ca2703          	lw	a4,12(s4)
    80002bf6:	0009079b          	sext.w	a5,s2
    80002bfa:	fce7e3e3          	bltu	a5,a4,80002bc0 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002bfe:	00006517          	auipc	a0,0x6
    80002c02:	88250513          	add	a0,a0,-1918 # 80008480 <etext+0x480>
    80002c06:	00003097          	auipc	ra,0x3
    80002c0a:	2a6080e7          	jalr	678(ra) # 80005eac <panic>
      memset(dip, 0, sizeof(*dip));
    80002c0e:	04000613          	li	a2,64
    80002c12:	4581                	li	a1,0
    80002c14:	854e                	mv	a0,s3
    80002c16:	ffffd097          	auipc	ra,0xffffd
    80002c1a:	564080e7          	jalr	1380(ra) # 8000017a <memset>
      dip->type = type;
    80002c1e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c22:	8526                	mv	a0,s1
    80002c24:	00001097          	auipc	ra,0x1
    80002c28:	caa080e7          	jalr	-854(ra) # 800038ce <log_write>
      brelse(bp);
    80002c2c:	8526                	mv	a0,s1
    80002c2e:	00000097          	auipc	ra,0x0
    80002c32:	a2c080e7          	jalr	-1492(ra) # 8000265a <brelse>
      return iget(dev, inum);
    80002c36:	0009059b          	sext.w	a1,s2
    80002c3a:	8556                	mv	a0,s5
    80002c3c:	00000097          	auipc	ra,0x0
    80002c40:	db8080e7          	jalr	-584(ra) # 800029f4 <iget>
}
    80002c44:	70e2                	ld	ra,56(sp)
    80002c46:	7442                	ld	s0,48(sp)
    80002c48:	74a2                	ld	s1,40(sp)
    80002c4a:	7902                	ld	s2,32(sp)
    80002c4c:	69e2                	ld	s3,24(sp)
    80002c4e:	6a42                	ld	s4,16(sp)
    80002c50:	6aa2                	ld	s5,8(sp)
    80002c52:	6b02                	ld	s6,0(sp)
    80002c54:	6121                	add	sp,sp,64
    80002c56:	8082                	ret

0000000080002c58 <iupdate>:
{
    80002c58:	1101                	add	sp,sp,-32
    80002c5a:	ec06                	sd	ra,24(sp)
    80002c5c:	e822                	sd	s0,16(sp)
    80002c5e:	e426                	sd	s1,8(sp)
    80002c60:	e04a                	sd	s2,0(sp)
    80002c62:	1000                	add	s0,sp,32
    80002c64:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c66:	415c                	lw	a5,4(a0)
    80002c68:	0047d79b          	srlw	a5,a5,0x4
    80002c6c:	00015597          	auipc	a1,0x15
    80002c70:	b045a583          	lw	a1,-1276(a1) # 80017770 <sb+0x18>
    80002c74:	9dbd                	addw	a1,a1,a5
    80002c76:	4108                	lw	a0,0(a0)
    80002c78:	00000097          	auipc	ra,0x0
    80002c7c:	8b2080e7          	jalr	-1870(ra) # 8000252a <bread>
    80002c80:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c82:	05850793          	add	a5,a0,88
    80002c86:	40d8                	lw	a4,4(s1)
    80002c88:	8b3d                	and	a4,a4,15
    80002c8a:	071a                	sll	a4,a4,0x6
    80002c8c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c8e:	04449703          	lh	a4,68(s1)
    80002c92:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c96:	04649703          	lh	a4,70(s1)
    80002c9a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c9e:	04849703          	lh	a4,72(s1)
    80002ca2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002ca6:	04a49703          	lh	a4,74(s1)
    80002caa:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002cae:	44f8                	lw	a4,76(s1)
    80002cb0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cb2:	03400613          	li	a2,52
    80002cb6:	05048593          	add	a1,s1,80
    80002cba:	00c78513          	add	a0,a5,12
    80002cbe:	ffffd097          	auipc	ra,0xffffd
    80002cc2:	518080e7          	jalr	1304(ra) # 800001d6 <memmove>
  log_write(bp);
    80002cc6:	854a                	mv	a0,s2
    80002cc8:	00001097          	auipc	ra,0x1
    80002ccc:	c06080e7          	jalr	-1018(ra) # 800038ce <log_write>
  brelse(bp);
    80002cd0:	854a                	mv	a0,s2
    80002cd2:	00000097          	auipc	ra,0x0
    80002cd6:	988080e7          	jalr	-1656(ra) # 8000265a <brelse>
}
    80002cda:	60e2                	ld	ra,24(sp)
    80002cdc:	6442                	ld	s0,16(sp)
    80002cde:	64a2                	ld	s1,8(sp)
    80002ce0:	6902                	ld	s2,0(sp)
    80002ce2:	6105                	add	sp,sp,32
    80002ce4:	8082                	ret

0000000080002ce6 <idup>:
{
    80002ce6:	1101                	add	sp,sp,-32
    80002ce8:	ec06                	sd	ra,24(sp)
    80002cea:	e822                	sd	s0,16(sp)
    80002cec:	e426                	sd	s1,8(sp)
    80002cee:	1000                	add	s0,sp,32
    80002cf0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cf2:	00015517          	auipc	a0,0x15
    80002cf6:	a8650513          	add	a0,a0,-1402 # 80017778 <itable>
    80002cfa:	00003097          	auipc	ra,0x3
    80002cfe:	72c080e7          	jalr	1836(ra) # 80006426 <acquire>
  ip->ref++;
    80002d02:	449c                	lw	a5,8(s1)
    80002d04:	2785                	addw	a5,a5,1
    80002d06:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d08:	00015517          	auipc	a0,0x15
    80002d0c:	a7050513          	add	a0,a0,-1424 # 80017778 <itable>
    80002d10:	00003097          	auipc	ra,0x3
    80002d14:	7ca080e7          	jalr	1994(ra) # 800064da <release>
}
    80002d18:	8526                	mv	a0,s1
    80002d1a:	60e2                	ld	ra,24(sp)
    80002d1c:	6442                	ld	s0,16(sp)
    80002d1e:	64a2                	ld	s1,8(sp)
    80002d20:	6105                	add	sp,sp,32
    80002d22:	8082                	ret

0000000080002d24 <ilock>:
{
    80002d24:	1101                	add	sp,sp,-32
    80002d26:	ec06                	sd	ra,24(sp)
    80002d28:	e822                	sd	s0,16(sp)
    80002d2a:	e426                	sd	s1,8(sp)
    80002d2c:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d2e:	c10d                	beqz	a0,80002d50 <ilock+0x2c>
    80002d30:	84aa                	mv	s1,a0
    80002d32:	451c                	lw	a5,8(a0)
    80002d34:	00f05e63          	blez	a5,80002d50 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002d38:	0541                	add	a0,a0,16
    80002d3a:	00001097          	auipc	ra,0x1
    80002d3e:	cb2080e7          	jalr	-846(ra) # 800039ec <acquiresleep>
  if(ip->valid == 0){
    80002d42:	40bc                	lw	a5,64(s1)
    80002d44:	cf99                	beqz	a5,80002d62 <ilock+0x3e>
}
    80002d46:	60e2                	ld	ra,24(sp)
    80002d48:	6442                	ld	s0,16(sp)
    80002d4a:	64a2                	ld	s1,8(sp)
    80002d4c:	6105                	add	sp,sp,32
    80002d4e:	8082                	ret
    80002d50:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002d52:	00005517          	auipc	a0,0x5
    80002d56:	74650513          	add	a0,a0,1862 # 80008498 <etext+0x498>
    80002d5a:	00003097          	auipc	ra,0x3
    80002d5e:	152080e7          	jalr	338(ra) # 80005eac <panic>
    80002d62:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d64:	40dc                	lw	a5,4(s1)
    80002d66:	0047d79b          	srlw	a5,a5,0x4
    80002d6a:	00015597          	auipc	a1,0x15
    80002d6e:	a065a583          	lw	a1,-1530(a1) # 80017770 <sb+0x18>
    80002d72:	9dbd                	addw	a1,a1,a5
    80002d74:	4088                	lw	a0,0(s1)
    80002d76:	fffff097          	auipc	ra,0xfffff
    80002d7a:	7b4080e7          	jalr	1972(ra) # 8000252a <bread>
    80002d7e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d80:	05850593          	add	a1,a0,88
    80002d84:	40dc                	lw	a5,4(s1)
    80002d86:	8bbd                	and	a5,a5,15
    80002d88:	079a                	sll	a5,a5,0x6
    80002d8a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d8c:	00059783          	lh	a5,0(a1)
    80002d90:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d94:	00259783          	lh	a5,2(a1)
    80002d98:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d9c:	00459783          	lh	a5,4(a1)
    80002da0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002da4:	00659783          	lh	a5,6(a1)
    80002da8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002dac:	459c                	lw	a5,8(a1)
    80002dae:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002db0:	03400613          	li	a2,52
    80002db4:	05b1                	add	a1,a1,12
    80002db6:	05048513          	add	a0,s1,80
    80002dba:	ffffd097          	auipc	ra,0xffffd
    80002dbe:	41c080e7          	jalr	1052(ra) # 800001d6 <memmove>
    brelse(bp);
    80002dc2:	854a                	mv	a0,s2
    80002dc4:	00000097          	auipc	ra,0x0
    80002dc8:	896080e7          	jalr	-1898(ra) # 8000265a <brelse>
    ip->valid = 1;
    80002dcc:	4785                	li	a5,1
    80002dce:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002dd0:	04449783          	lh	a5,68(s1)
    80002dd4:	c399                	beqz	a5,80002dda <ilock+0xb6>
    80002dd6:	6902                	ld	s2,0(sp)
    80002dd8:	b7bd                	j	80002d46 <ilock+0x22>
      panic("ilock: no type");
    80002dda:	00005517          	auipc	a0,0x5
    80002dde:	6c650513          	add	a0,a0,1734 # 800084a0 <etext+0x4a0>
    80002de2:	00003097          	auipc	ra,0x3
    80002de6:	0ca080e7          	jalr	202(ra) # 80005eac <panic>

0000000080002dea <iunlock>:
{
    80002dea:	1101                	add	sp,sp,-32
    80002dec:	ec06                	sd	ra,24(sp)
    80002dee:	e822                	sd	s0,16(sp)
    80002df0:	e426                	sd	s1,8(sp)
    80002df2:	e04a                	sd	s2,0(sp)
    80002df4:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002df6:	c905                	beqz	a0,80002e26 <iunlock+0x3c>
    80002df8:	84aa                	mv	s1,a0
    80002dfa:	01050913          	add	s2,a0,16
    80002dfe:	854a                	mv	a0,s2
    80002e00:	00001097          	auipc	ra,0x1
    80002e04:	c86080e7          	jalr	-890(ra) # 80003a86 <holdingsleep>
    80002e08:	cd19                	beqz	a0,80002e26 <iunlock+0x3c>
    80002e0a:	449c                	lw	a5,8(s1)
    80002e0c:	00f05d63          	blez	a5,80002e26 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e10:	854a                	mv	a0,s2
    80002e12:	00001097          	auipc	ra,0x1
    80002e16:	c30080e7          	jalr	-976(ra) # 80003a42 <releasesleep>
}
    80002e1a:	60e2                	ld	ra,24(sp)
    80002e1c:	6442                	ld	s0,16(sp)
    80002e1e:	64a2                	ld	s1,8(sp)
    80002e20:	6902                	ld	s2,0(sp)
    80002e22:	6105                	add	sp,sp,32
    80002e24:	8082                	ret
    panic("iunlock");
    80002e26:	00005517          	auipc	a0,0x5
    80002e2a:	68a50513          	add	a0,a0,1674 # 800084b0 <etext+0x4b0>
    80002e2e:	00003097          	auipc	ra,0x3
    80002e32:	07e080e7          	jalr	126(ra) # 80005eac <panic>

0000000080002e36 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e36:	7179                	add	sp,sp,-48
    80002e38:	f406                	sd	ra,40(sp)
    80002e3a:	f022                	sd	s0,32(sp)
    80002e3c:	ec26                	sd	s1,24(sp)
    80002e3e:	e84a                	sd	s2,16(sp)
    80002e40:	e44e                	sd	s3,8(sp)
    80002e42:	1800                	add	s0,sp,48
    80002e44:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e46:	05050493          	add	s1,a0,80
    80002e4a:	08050913          	add	s2,a0,128
    80002e4e:	a021                	j	80002e56 <itrunc+0x20>
    80002e50:	0491                	add	s1,s1,4
    80002e52:	01248d63          	beq	s1,s2,80002e6c <itrunc+0x36>
    if(ip->addrs[i]){
    80002e56:	408c                	lw	a1,0(s1)
    80002e58:	dde5                	beqz	a1,80002e50 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002e5a:	0009a503          	lw	a0,0(s3)
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	910080e7          	jalr	-1776(ra) # 8000276e <bfree>
      ip->addrs[i] = 0;
    80002e66:	0004a023          	sw	zero,0(s1)
    80002e6a:	b7dd                	j	80002e50 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e6c:	0809a583          	lw	a1,128(s3)
    80002e70:	ed99                	bnez	a1,80002e8e <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e72:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e76:	854e                	mv	a0,s3
    80002e78:	00000097          	auipc	ra,0x0
    80002e7c:	de0080e7          	jalr	-544(ra) # 80002c58 <iupdate>
}
    80002e80:	70a2                	ld	ra,40(sp)
    80002e82:	7402                	ld	s0,32(sp)
    80002e84:	64e2                	ld	s1,24(sp)
    80002e86:	6942                	ld	s2,16(sp)
    80002e88:	69a2                	ld	s3,8(sp)
    80002e8a:	6145                	add	sp,sp,48
    80002e8c:	8082                	ret
    80002e8e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e90:	0009a503          	lw	a0,0(s3)
    80002e94:	fffff097          	auipc	ra,0xfffff
    80002e98:	696080e7          	jalr	1686(ra) # 8000252a <bread>
    80002e9c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e9e:	05850493          	add	s1,a0,88
    80002ea2:	45850913          	add	s2,a0,1112
    80002ea6:	a021                	j	80002eae <itrunc+0x78>
    80002ea8:	0491                	add	s1,s1,4
    80002eaa:	01248b63          	beq	s1,s2,80002ec0 <itrunc+0x8a>
      if(a[j])
    80002eae:	408c                	lw	a1,0(s1)
    80002eb0:	dde5                	beqz	a1,80002ea8 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002eb2:	0009a503          	lw	a0,0(s3)
    80002eb6:	00000097          	auipc	ra,0x0
    80002eba:	8b8080e7          	jalr	-1864(ra) # 8000276e <bfree>
    80002ebe:	b7ed                	j	80002ea8 <itrunc+0x72>
    brelse(bp);
    80002ec0:	8552                	mv	a0,s4
    80002ec2:	fffff097          	auipc	ra,0xfffff
    80002ec6:	798080e7          	jalr	1944(ra) # 8000265a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002eca:	0809a583          	lw	a1,128(s3)
    80002ece:	0009a503          	lw	a0,0(s3)
    80002ed2:	00000097          	auipc	ra,0x0
    80002ed6:	89c080e7          	jalr	-1892(ra) # 8000276e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002eda:	0809a023          	sw	zero,128(s3)
    80002ede:	6a02                	ld	s4,0(sp)
    80002ee0:	bf49                	j	80002e72 <itrunc+0x3c>

0000000080002ee2 <iput>:
{
    80002ee2:	1101                	add	sp,sp,-32
    80002ee4:	ec06                	sd	ra,24(sp)
    80002ee6:	e822                	sd	s0,16(sp)
    80002ee8:	e426                	sd	s1,8(sp)
    80002eea:	1000                	add	s0,sp,32
    80002eec:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002eee:	00015517          	auipc	a0,0x15
    80002ef2:	88a50513          	add	a0,a0,-1910 # 80017778 <itable>
    80002ef6:	00003097          	auipc	ra,0x3
    80002efa:	530080e7          	jalr	1328(ra) # 80006426 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002efe:	4498                	lw	a4,8(s1)
    80002f00:	4785                	li	a5,1
    80002f02:	02f70263          	beq	a4,a5,80002f26 <iput+0x44>
  ip->ref--;
    80002f06:	449c                	lw	a5,8(s1)
    80002f08:	37fd                	addw	a5,a5,-1
    80002f0a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f0c:	00015517          	auipc	a0,0x15
    80002f10:	86c50513          	add	a0,a0,-1940 # 80017778 <itable>
    80002f14:	00003097          	auipc	ra,0x3
    80002f18:	5c6080e7          	jalr	1478(ra) # 800064da <release>
}
    80002f1c:	60e2                	ld	ra,24(sp)
    80002f1e:	6442                	ld	s0,16(sp)
    80002f20:	64a2                	ld	s1,8(sp)
    80002f22:	6105                	add	sp,sp,32
    80002f24:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f26:	40bc                	lw	a5,64(s1)
    80002f28:	dff9                	beqz	a5,80002f06 <iput+0x24>
    80002f2a:	04a49783          	lh	a5,74(s1)
    80002f2e:	ffe1                	bnez	a5,80002f06 <iput+0x24>
    80002f30:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002f32:	01048913          	add	s2,s1,16
    80002f36:	854a                	mv	a0,s2
    80002f38:	00001097          	auipc	ra,0x1
    80002f3c:	ab4080e7          	jalr	-1356(ra) # 800039ec <acquiresleep>
    release(&itable.lock);
    80002f40:	00015517          	auipc	a0,0x15
    80002f44:	83850513          	add	a0,a0,-1992 # 80017778 <itable>
    80002f48:	00003097          	auipc	ra,0x3
    80002f4c:	592080e7          	jalr	1426(ra) # 800064da <release>
    itrunc(ip);
    80002f50:	8526                	mv	a0,s1
    80002f52:	00000097          	auipc	ra,0x0
    80002f56:	ee4080e7          	jalr	-284(ra) # 80002e36 <itrunc>
    ip->type = 0;
    80002f5a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f5e:	8526                	mv	a0,s1
    80002f60:	00000097          	auipc	ra,0x0
    80002f64:	cf8080e7          	jalr	-776(ra) # 80002c58 <iupdate>
    ip->valid = 0;
    80002f68:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f6c:	854a                	mv	a0,s2
    80002f6e:	00001097          	auipc	ra,0x1
    80002f72:	ad4080e7          	jalr	-1324(ra) # 80003a42 <releasesleep>
    acquire(&itable.lock);
    80002f76:	00015517          	auipc	a0,0x15
    80002f7a:	80250513          	add	a0,a0,-2046 # 80017778 <itable>
    80002f7e:	00003097          	auipc	ra,0x3
    80002f82:	4a8080e7          	jalr	1192(ra) # 80006426 <acquire>
    80002f86:	6902                	ld	s2,0(sp)
    80002f88:	bfbd                	j	80002f06 <iput+0x24>

0000000080002f8a <iunlockput>:
{
    80002f8a:	1101                	add	sp,sp,-32
    80002f8c:	ec06                	sd	ra,24(sp)
    80002f8e:	e822                	sd	s0,16(sp)
    80002f90:	e426                	sd	s1,8(sp)
    80002f92:	1000                	add	s0,sp,32
    80002f94:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f96:	00000097          	auipc	ra,0x0
    80002f9a:	e54080e7          	jalr	-428(ra) # 80002dea <iunlock>
  iput(ip);
    80002f9e:	8526                	mv	a0,s1
    80002fa0:	00000097          	auipc	ra,0x0
    80002fa4:	f42080e7          	jalr	-190(ra) # 80002ee2 <iput>
}
    80002fa8:	60e2                	ld	ra,24(sp)
    80002faa:	6442                	ld	s0,16(sp)
    80002fac:	64a2                	ld	s1,8(sp)
    80002fae:	6105                	add	sp,sp,32
    80002fb0:	8082                	ret

0000000080002fb2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fb2:	1141                	add	sp,sp,-16
    80002fb4:	e422                	sd	s0,8(sp)
    80002fb6:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80002fb8:	411c                	lw	a5,0(a0)
    80002fba:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fbc:	415c                	lw	a5,4(a0)
    80002fbe:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fc0:	04451783          	lh	a5,68(a0)
    80002fc4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fc8:	04a51783          	lh	a5,74(a0)
    80002fcc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fd0:	04c56783          	lwu	a5,76(a0)
    80002fd4:	e99c                	sd	a5,16(a1)
}
    80002fd6:	6422                	ld	s0,8(sp)
    80002fd8:	0141                	add	sp,sp,16
    80002fda:	8082                	ret

0000000080002fdc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fdc:	457c                	lw	a5,76(a0)
    80002fde:	0ed7ef63          	bltu	a5,a3,800030dc <readi+0x100>
{
    80002fe2:	7159                	add	sp,sp,-112
    80002fe4:	f486                	sd	ra,104(sp)
    80002fe6:	f0a2                	sd	s0,96(sp)
    80002fe8:	eca6                	sd	s1,88(sp)
    80002fea:	fc56                	sd	s5,56(sp)
    80002fec:	f85a                	sd	s6,48(sp)
    80002fee:	f45e                	sd	s7,40(sp)
    80002ff0:	f062                	sd	s8,32(sp)
    80002ff2:	1880                	add	s0,sp,112
    80002ff4:	8baa                	mv	s7,a0
    80002ff6:	8c2e                	mv	s8,a1
    80002ff8:	8ab2                	mv	s5,a2
    80002ffa:	84b6                	mv	s1,a3
    80002ffc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ffe:	9f35                	addw	a4,a4,a3
    return 0;
    80003000:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003002:	0ad76c63          	bltu	a4,a3,800030ba <readi+0xde>
    80003006:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003008:	00e7f463          	bgeu	a5,a4,80003010 <readi+0x34>
    n = ip->size - off;
    8000300c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003010:	0c0b0463          	beqz	s6,800030d8 <readi+0xfc>
    80003014:	e8ca                	sd	s2,80(sp)
    80003016:	e0d2                	sd	s4,64(sp)
    80003018:	ec66                	sd	s9,24(sp)
    8000301a:	e86a                	sd	s10,16(sp)
    8000301c:	e46e                	sd	s11,8(sp)
    8000301e:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003020:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003024:	5cfd                	li	s9,-1
    80003026:	a82d                	j	80003060 <readi+0x84>
    80003028:	020a1d93          	sll	s11,s4,0x20
    8000302c:	020ddd93          	srl	s11,s11,0x20
    80003030:	05890613          	add	a2,s2,88
    80003034:	86ee                	mv	a3,s11
    80003036:	963a                	add	a2,a2,a4
    80003038:	85d6                	mv	a1,s5
    8000303a:	8562                	mv	a0,s8
    8000303c:	fffff097          	auipc	ra,0xfffff
    80003040:	a08080e7          	jalr	-1528(ra) # 80001a44 <either_copyout>
    80003044:	05950d63          	beq	a0,s9,8000309e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003048:	854a                	mv	a0,s2
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	610080e7          	jalr	1552(ra) # 8000265a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003052:	013a09bb          	addw	s3,s4,s3
    80003056:	009a04bb          	addw	s1,s4,s1
    8000305a:	9aee                	add	s5,s5,s11
    8000305c:	0769f863          	bgeu	s3,s6,800030cc <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003060:	000ba903          	lw	s2,0(s7)
    80003064:	00a4d59b          	srlw	a1,s1,0xa
    80003068:	855e                	mv	a0,s7
    8000306a:	00000097          	auipc	ra,0x0
    8000306e:	8ae080e7          	jalr	-1874(ra) # 80002918 <bmap>
    80003072:	0005059b          	sext.w	a1,a0
    80003076:	854a                	mv	a0,s2
    80003078:	fffff097          	auipc	ra,0xfffff
    8000307c:	4b2080e7          	jalr	1202(ra) # 8000252a <bread>
    80003080:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003082:	3ff4f713          	and	a4,s1,1023
    80003086:	40ed07bb          	subw	a5,s10,a4
    8000308a:	413b06bb          	subw	a3,s6,s3
    8000308e:	8a3e                	mv	s4,a5
    80003090:	2781                	sext.w	a5,a5
    80003092:	0006861b          	sext.w	a2,a3
    80003096:	f8f679e3          	bgeu	a2,a5,80003028 <readi+0x4c>
    8000309a:	8a36                	mv	s4,a3
    8000309c:	b771                	j	80003028 <readi+0x4c>
      brelse(bp);
    8000309e:	854a                	mv	a0,s2
    800030a0:	fffff097          	auipc	ra,0xfffff
    800030a4:	5ba080e7          	jalr	1466(ra) # 8000265a <brelse>
      tot = -1;
    800030a8:	59fd                	li	s3,-1
      break;
    800030aa:	6946                	ld	s2,80(sp)
    800030ac:	6a06                	ld	s4,64(sp)
    800030ae:	6ce2                	ld	s9,24(sp)
    800030b0:	6d42                	ld	s10,16(sp)
    800030b2:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800030b4:	0009851b          	sext.w	a0,s3
    800030b8:	69a6                	ld	s3,72(sp)
}
    800030ba:	70a6                	ld	ra,104(sp)
    800030bc:	7406                	ld	s0,96(sp)
    800030be:	64e6                	ld	s1,88(sp)
    800030c0:	7ae2                	ld	s5,56(sp)
    800030c2:	7b42                	ld	s6,48(sp)
    800030c4:	7ba2                	ld	s7,40(sp)
    800030c6:	7c02                	ld	s8,32(sp)
    800030c8:	6165                	add	sp,sp,112
    800030ca:	8082                	ret
    800030cc:	6946                	ld	s2,80(sp)
    800030ce:	6a06                	ld	s4,64(sp)
    800030d0:	6ce2                	ld	s9,24(sp)
    800030d2:	6d42                	ld	s10,16(sp)
    800030d4:	6da2                	ld	s11,8(sp)
    800030d6:	bff9                	j	800030b4 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030d8:	89da                	mv	s3,s6
    800030da:	bfe9                	j	800030b4 <readi+0xd8>
    return 0;
    800030dc:	4501                	li	a0,0
}
    800030de:	8082                	ret

00000000800030e0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030e0:	457c                	lw	a5,76(a0)
    800030e2:	10d7ee63          	bltu	a5,a3,800031fe <writei+0x11e>
{
    800030e6:	7159                	add	sp,sp,-112
    800030e8:	f486                	sd	ra,104(sp)
    800030ea:	f0a2                	sd	s0,96(sp)
    800030ec:	e8ca                	sd	s2,80(sp)
    800030ee:	fc56                	sd	s5,56(sp)
    800030f0:	f85a                	sd	s6,48(sp)
    800030f2:	f45e                	sd	s7,40(sp)
    800030f4:	f062                	sd	s8,32(sp)
    800030f6:	1880                	add	s0,sp,112
    800030f8:	8b2a                	mv	s6,a0
    800030fa:	8c2e                	mv	s8,a1
    800030fc:	8ab2                	mv	s5,a2
    800030fe:	8936                	mv	s2,a3
    80003100:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003102:	00e687bb          	addw	a5,a3,a4
    80003106:	0ed7ee63          	bltu	a5,a3,80003202 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000310a:	00043737          	lui	a4,0x43
    8000310e:	0ef76c63          	bltu	a4,a5,80003206 <writei+0x126>
    80003112:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003114:	0c0b8d63          	beqz	s7,800031ee <writei+0x10e>
    80003118:	eca6                	sd	s1,88(sp)
    8000311a:	e4ce                	sd	s3,72(sp)
    8000311c:	ec66                	sd	s9,24(sp)
    8000311e:	e86a                	sd	s10,16(sp)
    80003120:	e46e                	sd	s11,8(sp)
    80003122:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003124:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003128:	5cfd                	li	s9,-1
    8000312a:	a091                	j	8000316e <writei+0x8e>
    8000312c:	02099d93          	sll	s11,s3,0x20
    80003130:	020ddd93          	srl	s11,s11,0x20
    80003134:	05848513          	add	a0,s1,88
    80003138:	86ee                	mv	a3,s11
    8000313a:	8656                	mv	a2,s5
    8000313c:	85e2                	mv	a1,s8
    8000313e:	953a                	add	a0,a0,a4
    80003140:	fffff097          	auipc	ra,0xfffff
    80003144:	95a080e7          	jalr	-1702(ra) # 80001a9a <either_copyin>
    80003148:	07950263          	beq	a0,s9,800031ac <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000314c:	8526                	mv	a0,s1
    8000314e:	00000097          	auipc	ra,0x0
    80003152:	780080e7          	jalr	1920(ra) # 800038ce <log_write>
    brelse(bp);
    80003156:	8526                	mv	a0,s1
    80003158:	fffff097          	auipc	ra,0xfffff
    8000315c:	502080e7          	jalr	1282(ra) # 8000265a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003160:	01498a3b          	addw	s4,s3,s4
    80003164:	0129893b          	addw	s2,s3,s2
    80003168:	9aee                	add	s5,s5,s11
    8000316a:	057a7663          	bgeu	s4,s7,800031b6 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000316e:	000b2483          	lw	s1,0(s6)
    80003172:	00a9559b          	srlw	a1,s2,0xa
    80003176:	855a                	mv	a0,s6
    80003178:	fffff097          	auipc	ra,0xfffff
    8000317c:	7a0080e7          	jalr	1952(ra) # 80002918 <bmap>
    80003180:	0005059b          	sext.w	a1,a0
    80003184:	8526                	mv	a0,s1
    80003186:	fffff097          	auipc	ra,0xfffff
    8000318a:	3a4080e7          	jalr	932(ra) # 8000252a <bread>
    8000318e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003190:	3ff97713          	and	a4,s2,1023
    80003194:	40ed07bb          	subw	a5,s10,a4
    80003198:	414b86bb          	subw	a3,s7,s4
    8000319c:	89be                	mv	s3,a5
    8000319e:	2781                	sext.w	a5,a5
    800031a0:	0006861b          	sext.w	a2,a3
    800031a4:	f8f674e3          	bgeu	a2,a5,8000312c <writei+0x4c>
    800031a8:	89b6                	mv	s3,a3
    800031aa:	b749                	j	8000312c <writei+0x4c>
      brelse(bp);
    800031ac:	8526                	mv	a0,s1
    800031ae:	fffff097          	auipc	ra,0xfffff
    800031b2:	4ac080e7          	jalr	1196(ra) # 8000265a <brelse>
  }

  if(off > ip->size)
    800031b6:	04cb2783          	lw	a5,76(s6)
    800031ba:	0327fc63          	bgeu	a5,s2,800031f2 <writei+0x112>
    ip->size = off;
    800031be:	052b2623          	sw	s2,76(s6)
    800031c2:	64e6                	ld	s1,88(sp)
    800031c4:	69a6                	ld	s3,72(sp)
    800031c6:	6ce2                	ld	s9,24(sp)
    800031c8:	6d42                	ld	s10,16(sp)
    800031ca:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031cc:	855a                	mv	a0,s6
    800031ce:	00000097          	auipc	ra,0x0
    800031d2:	a8a080e7          	jalr	-1398(ra) # 80002c58 <iupdate>

  return tot;
    800031d6:	000a051b          	sext.w	a0,s4
    800031da:	6a06                	ld	s4,64(sp)
}
    800031dc:	70a6                	ld	ra,104(sp)
    800031de:	7406                	ld	s0,96(sp)
    800031e0:	6946                	ld	s2,80(sp)
    800031e2:	7ae2                	ld	s5,56(sp)
    800031e4:	7b42                	ld	s6,48(sp)
    800031e6:	7ba2                	ld	s7,40(sp)
    800031e8:	7c02                	ld	s8,32(sp)
    800031ea:	6165                	add	sp,sp,112
    800031ec:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031ee:	8a5e                	mv	s4,s7
    800031f0:	bff1                	j	800031cc <writei+0xec>
    800031f2:	64e6                	ld	s1,88(sp)
    800031f4:	69a6                	ld	s3,72(sp)
    800031f6:	6ce2                	ld	s9,24(sp)
    800031f8:	6d42                	ld	s10,16(sp)
    800031fa:	6da2                	ld	s11,8(sp)
    800031fc:	bfc1                	j	800031cc <writei+0xec>
    return -1;
    800031fe:	557d                	li	a0,-1
}
    80003200:	8082                	ret
    return -1;
    80003202:	557d                	li	a0,-1
    80003204:	bfe1                	j	800031dc <writei+0xfc>
    return -1;
    80003206:	557d                	li	a0,-1
    80003208:	bfd1                	j	800031dc <writei+0xfc>

000000008000320a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000320a:	1141                	add	sp,sp,-16
    8000320c:	e406                	sd	ra,8(sp)
    8000320e:	e022                	sd	s0,0(sp)
    80003210:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003212:	4639                	li	a2,14
    80003214:	ffffd097          	auipc	ra,0xffffd
    80003218:	036080e7          	jalr	54(ra) # 8000024a <strncmp>
}
    8000321c:	60a2                	ld	ra,8(sp)
    8000321e:	6402                	ld	s0,0(sp)
    80003220:	0141                	add	sp,sp,16
    80003222:	8082                	ret

0000000080003224 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003224:	7139                	add	sp,sp,-64
    80003226:	fc06                	sd	ra,56(sp)
    80003228:	f822                	sd	s0,48(sp)
    8000322a:	f426                	sd	s1,40(sp)
    8000322c:	f04a                	sd	s2,32(sp)
    8000322e:	ec4e                	sd	s3,24(sp)
    80003230:	e852                	sd	s4,16(sp)
    80003232:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003234:	04451703          	lh	a4,68(a0)
    80003238:	4785                	li	a5,1
    8000323a:	00f71a63          	bne	a4,a5,8000324e <dirlookup+0x2a>
    8000323e:	892a                	mv	s2,a0
    80003240:	89ae                	mv	s3,a1
    80003242:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003244:	457c                	lw	a5,76(a0)
    80003246:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003248:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000324a:	e79d                	bnez	a5,80003278 <dirlookup+0x54>
    8000324c:	a8a5                	j	800032c4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000324e:	00005517          	auipc	a0,0x5
    80003252:	26a50513          	add	a0,a0,618 # 800084b8 <etext+0x4b8>
    80003256:	00003097          	auipc	ra,0x3
    8000325a:	c56080e7          	jalr	-938(ra) # 80005eac <panic>
      panic("dirlookup read");
    8000325e:	00005517          	auipc	a0,0x5
    80003262:	27250513          	add	a0,a0,626 # 800084d0 <etext+0x4d0>
    80003266:	00003097          	auipc	ra,0x3
    8000326a:	c46080e7          	jalr	-954(ra) # 80005eac <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000326e:	24c1                	addw	s1,s1,16
    80003270:	04c92783          	lw	a5,76(s2)
    80003274:	04f4f763          	bgeu	s1,a5,800032c2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003278:	4741                	li	a4,16
    8000327a:	86a6                	mv	a3,s1
    8000327c:	fc040613          	add	a2,s0,-64
    80003280:	4581                	li	a1,0
    80003282:	854a                	mv	a0,s2
    80003284:	00000097          	auipc	ra,0x0
    80003288:	d58080e7          	jalr	-680(ra) # 80002fdc <readi>
    8000328c:	47c1                	li	a5,16
    8000328e:	fcf518e3          	bne	a0,a5,8000325e <dirlookup+0x3a>
    if(de.inum == 0)
    80003292:	fc045783          	lhu	a5,-64(s0)
    80003296:	dfe1                	beqz	a5,8000326e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003298:	fc240593          	add	a1,s0,-62
    8000329c:	854e                	mv	a0,s3
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	f6c080e7          	jalr	-148(ra) # 8000320a <namecmp>
    800032a6:	f561                	bnez	a0,8000326e <dirlookup+0x4a>
      if(poff)
    800032a8:	000a0463          	beqz	s4,800032b0 <dirlookup+0x8c>
        *poff = off;
    800032ac:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032b0:	fc045583          	lhu	a1,-64(s0)
    800032b4:	00092503          	lw	a0,0(s2)
    800032b8:	fffff097          	auipc	ra,0xfffff
    800032bc:	73c080e7          	jalr	1852(ra) # 800029f4 <iget>
    800032c0:	a011                	j	800032c4 <dirlookup+0xa0>
  return 0;
    800032c2:	4501                	li	a0,0
}
    800032c4:	70e2                	ld	ra,56(sp)
    800032c6:	7442                	ld	s0,48(sp)
    800032c8:	74a2                	ld	s1,40(sp)
    800032ca:	7902                	ld	s2,32(sp)
    800032cc:	69e2                	ld	s3,24(sp)
    800032ce:	6a42                	ld	s4,16(sp)
    800032d0:	6121                	add	sp,sp,64
    800032d2:	8082                	ret

00000000800032d4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032d4:	711d                	add	sp,sp,-96
    800032d6:	ec86                	sd	ra,88(sp)
    800032d8:	e8a2                	sd	s0,80(sp)
    800032da:	e4a6                	sd	s1,72(sp)
    800032dc:	e0ca                	sd	s2,64(sp)
    800032de:	fc4e                	sd	s3,56(sp)
    800032e0:	f852                	sd	s4,48(sp)
    800032e2:	f456                	sd	s5,40(sp)
    800032e4:	f05a                	sd	s6,32(sp)
    800032e6:	ec5e                	sd	s7,24(sp)
    800032e8:	e862                	sd	s8,16(sp)
    800032ea:	e466                	sd	s9,8(sp)
    800032ec:	1080                	add	s0,sp,96
    800032ee:	84aa                	mv	s1,a0
    800032f0:	8b2e                	mv	s6,a1
    800032f2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032f4:	00054703          	lbu	a4,0(a0)
    800032f8:	02f00793          	li	a5,47
    800032fc:	02f70263          	beq	a4,a5,80003320 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003300:	ffffe097          	auipc	ra,0xffffe
    80003304:	c3e080e7          	jalr	-962(ra) # 80000f3e <myproc>
    80003308:	15053503          	ld	a0,336(a0)
    8000330c:	00000097          	auipc	ra,0x0
    80003310:	9da080e7          	jalr	-1574(ra) # 80002ce6 <idup>
    80003314:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003316:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000331a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000331c:	4b85                	li	s7,1
    8000331e:	a875                	j	800033da <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003320:	4585                	li	a1,1
    80003322:	4505                	li	a0,1
    80003324:	fffff097          	auipc	ra,0xfffff
    80003328:	6d0080e7          	jalr	1744(ra) # 800029f4 <iget>
    8000332c:	8a2a                	mv	s4,a0
    8000332e:	b7e5                	j	80003316 <namex+0x42>
      iunlockput(ip);
    80003330:	8552                	mv	a0,s4
    80003332:	00000097          	auipc	ra,0x0
    80003336:	c58080e7          	jalr	-936(ra) # 80002f8a <iunlockput>
      return 0;
    8000333a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000333c:	8552                	mv	a0,s4
    8000333e:	60e6                	ld	ra,88(sp)
    80003340:	6446                	ld	s0,80(sp)
    80003342:	64a6                	ld	s1,72(sp)
    80003344:	6906                	ld	s2,64(sp)
    80003346:	79e2                	ld	s3,56(sp)
    80003348:	7a42                	ld	s4,48(sp)
    8000334a:	7aa2                	ld	s5,40(sp)
    8000334c:	7b02                	ld	s6,32(sp)
    8000334e:	6be2                	ld	s7,24(sp)
    80003350:	6c42                	ld	s8,16(sp)
    80003352:	6ca2                	ld	s9,8(sp)
    80003354:	6125                	add	sp,sp,96
    80003356:	8082                	ret
      iunlock(ip);
    80003358:	8552                	mv	a0,s4
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	a90080e7          	jalr	-1392(ra) # 80002dea <iunlock>
      return ip;
    80003362:	bfe9                	j	8000333c <namex+0x68>
      iunlockput(ip);
    80003364:	8552                	mv	a0,s4
    80003366:	00000097          	auipc	ra,0x0
    8000336a:	c24080e7          	jalr	-988(ra) # 80002f8a <iunlockput>
      return 0;
    8000336e:	8a4e                	mv	s4,s3
    80003370:	b7f1                	j	8000333c <namex+0x68>
  len = path - s;
    80003372:	40998633          	sub	a2,s3,s1
    80003376:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000337a:	099c5863          	bge	s8,s9,8000340a <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000337e:	4639                	li	a2,14
    80003380:	85a6                	mv	a1,s1
    80003382:	8556                	mv	a0,s5
    80003384:	ffffd097          	auipc	ra,0xffffd
    80003388:	e52080e7          	jalr	-430(ra) # 800001d6 <memmove>
    8000338c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000338e:	0004c783          	lbu	a5,0(s1)
    80003392:	01279763          	bne	a5,s2,800033a0 <namex+0xcc>
    path++;
    80003396:	0485                	add	s1,s1,1
  while(*path == '/')
    80003398:	0004c783          	lbu	a5,0(s1)
    8000339c:	ff278de3          	beq	a5,s2,80003396 <namex+0xc2>
    ilock(ip);
    800033a0:	8552                	mv	a0,s4
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	982080e7          	jalr	-1662(ra) # 80002d24 <ilock>
    if(ip->type != T_DIR){
    800033aa:	044a1783          	lh	a5,68(s4)
    800033ae:	f97791e3          	bne	a5,s7,80003330 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800033b2:	000b0563          	beqz	s6,800033bc <namex+0xe8>
    800033b6:	0004c783          	lbu	a5,0(s1)
    800033ba:	dfd9                	beqz	a5,80003358 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033bc:	4601                	li	a2,0
    800033be:	85d6                	mv	a1,s5
    800033c0:	8552                	mv	a0,s4
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	e62080e7          	jalr	-414(ra) # 80003224 <dirlookup>
    800033ca:	89aa                	mv	s3,a0
    800033cc:	dd41                	beqz	a0,80003364 <namex+0x90>
    iunlockput(ip);
    800033ce:	8552                	mv	a0,s4
    800033d0:	00000097          	auipc	ra,0x0
    800033d4:	bba080e7          	jalr	-1094(ra) # 80002f8a <iunlockput>
    ip = next;
    800033d8:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033da:	0004c783          	lbu	a5,0(s1)
    800033de:	01279763          	bne	a5,s2,800033ec <namex+0x118>
    path++;
    800033e2:	0485                	add	s1,s1,1
  while(*path == '/')
    800033e4:	0004c783          	lbu	a5,0(s1)
    800033e8:	ff278de3          	beq	a5,s2,800033e2 <namex+0x10e>
  if(*path == 0)
    800033ec:	cb9d                	beqz	a5,80003422 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800033ee:	0004c783          	lbu	a5,0(s1)
    800033f2:	89a6                	mv	s3,s1
  len = path - s;
    800033f4:	4c81                	li	s9,0
    800033f6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800033f8:	01278963          	beq	a5,s2,8000340a <namex+0x136>
    800033fc:	dbbd                	beqz	a5,80003372 <namex+0x9e>
    path++;
    800033fe:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003400:	0009c783          	lbu	a5,0(s3)
    80003404:	ff279ce3          	bne	a5,s2,800033fc <namex+0x128>
    80003408:	b7ad                	j	80003372 <namex+0x9e>
    memmove(name, s, len);
    8000340a:	2601                	sext.w	a2,a2
    8000340c:	85a6                	mv	a1,s1
    8000340e:	8556                	mv	a0,s5
    80003410:	ffffd097          	auipc	ra,0xffffd
    80003414:	dc6080e7          	jalr	-570(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003418:	9cd6                	add	s9,s9,s5
    8000341a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000341e:	84ce                	mv	s1,s3
    80003420:	b7bd                	j	8000338e <namex+0xba>
  if(nameiparent){
    80003422:	f00b0de3          	beqz	s6,8000333c <namex+0x68>
    iput(ip);
    80003426:	8552                	mv	a0,s4
    80003428:	00000097          	auipc	ra,0x0
    8000342c:	aba080e7          	jalr	-1350(ra) # 80002ee2 <iput>
    return 0;
    80003430:	4a01                	li	s4,0
    80003432:	b729                	j	8000333c <namex+0x68>

0000000080003434 <dirlink>:
{
    80003434:	7139                	add	sp,sp,-64
    80003436:	fc06                	sd	ra,56(sp)
    80003438:	f822                	sd	s0,48(sp)
    8000343a:	f04a                	sd	s2,32(sp)
    8000343c:	ec4e                	sd	s3,24(sp)
    8000343e:	e852                	sd	s4,16(sp)
    80003440:	0080                	add	s0,sp,64
    80003442:	892a                	mv	s2,a0
    80003444:	8a2e                	mv	s4,a1
    80003446:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003448:	4601                	li	a2,0
    8000344a:	00000097          	auipc	ra,0x0
    8000344e:	dda080e7          	jalr	-550(ra) # 80003224 <dirlookup>
    80003452:	ed25                	bnez	a0,800034ca <dirlink+0x96>
    80003454:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003456:	04c92483          	lw	s1,76(s2)
    8000345a:	c49d                	beqz	s1,80003488 <dirlink+0x54>
    8000345c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000345e:	4741                	li	a4,16
    80003460:	86a6                	mv	a3,s1
    80003462:	fc040613          	add	a2,s0,-64
    80003466:	4581                	li	a1,0
    80003468:	854a                	mv	a0,s2
    8000346a:	00000097          	auipc	ra,0x0
    8000346e:	b72080e7          	jalr	-1166(ra) # 80002fdc <readi>
    80003472:	47c1                	li	a5,16
    80003474:	06f51163          	bne	a0,a5,800034d6 <dirlink+0xa2>
    if(de.inum == 0)
    80003478:	fc045783          	lhu	a5,-64(s0)
    8000347c:	c791                	beqz	a5,80003488 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000347e:	24c1                	addw	s1,s1,16
    80003480:	04c92783          	lw	a5,76(s2)
    80003484:	fcf4ede3          	bltu	s1,a5,8000345e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003488:	4639                	li	a2,14
    8000348a:	85d2                	mv	a1,s4
    8000348c:	fc240513          	add	a0,s0,-62
    80003490:	ffffd097          	auipc	ra,0xffffd
    80003494:	df0080e7          	jalr	-528(ra) # 80000280 <strncpy>
  de.inum = inum;
    80003498:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000349c:	4741                	li	a4,16
    8000349e:	86a6                	mv	a3,s1
    800034a0:	fc040613          	add	a2,s0,-64
    800034a4:	4581                	li	a1,0
    800034a6:	854a                	mv	a0,s2
    800034a8:	00000097          	auipc	ra,0x0
    800034ac:	c38080e7          	jalr	-968(ra) # 800030e0 <writei>
    800034b0:	872a                	mv	a4,a0
    800034b2:	47c1                	li	a5,16
  return 0;
    800034b4:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034b6:	02f71863          	bne	a4,a5,800034e6 <dirlink+0xb2>
    800034ba:	74a2                	ld	s1,40(sp)
}
    800034bc:	70e2                	ld	ra,56(sp)
    800034be:	7442                	ld	s0,48(sp)
    800034c0:	7902                	ld	s2,32(sp)
    800034c2:	69e2                	ld	s3,24(sp)
    800034c4:	6a42                	ld	s4,16(sp)
    800034c6:	6121                	add	sp,sp,64
    800034c8:	8082                	ret
    iput(ip);
    800034ca:	00000097          	auipc	ra,0x0
    800034ce:	a18080e7          	jalr	-1512(ra) # 80002ee2 <iput>
    return -1;
    800034d2:	557d                	li	a0,-1
    800034d4:	b7e5                	j	800034bc <dirlink+0x88>
      panic("dirlink read");
    800034d6:	00005517          	auipc	a0,0x5
    800034da:	00a50513          	add	a0,a0,10 # 800084e0 <etext+0x4e0>
    800034de:	00003097          	auipc	ra,0x3
    800034e2:	9ce080e7          	jalr	-1586(ra) # 80005eac <panic>
    panic("dirlink");
    800034e6:	00005517          	auipc	a0,0x5
    800034ea:	10a50513          	add	a0,a0,266 # 800085f0 <etext+0x5f0>
    800034ee:	00003097          	auipc	ra,0x3
    800034f2:	9be080e7          	jalr	-1602(ra) # 80005eac <panic>

00000000800034f6 <namei>:

struct inode*
namei(char *path)
{
    800034f6:	1101                	add	sp,sp,-32
    800034f8:	ec06                	sd	ra,24(sp)
    800034fa:	e822                	sd	s0,16(sp)
    800034fc:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034fe:	fe040613          	add	a2,s0,-32
    80003502:	4581                	li	a1,0
    80003504:	00000097          	auipc	ra,0x0
    80003508:	dd0080e7          	jalr	-560(ra) # 800032d4 <namex>
}
    8000350c:	60e2                	ld	ra,24(sp)
    8000350e:	6442                	ld	s0,16(sp)
    80003510:	6105                	add	sp,sp,32
    80003512:	8082                	ret

0000000080003514 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003514:	1141                	add	sp,sp,-16
    80003516:	e406                	sd	ra,8(sp)
    80003518:	e022                	sd	s0,0(sp)
    8000351a:	0800                	add	s0,sp,16
    8000351c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000351e:	4585                	li	a1,1
    80003520:	00000097          	auipc	ra,0x0
    80003524:	db4080e7          	jalr	-588(ra) # 800032d4 <namex>
}
    80003528:	60a2                	ld	ra,8(sp)
    8000352a:	6402                	ld	s0,0(sp)
    8000352c:	0141                	add	sp,sp,16
    8000352e:	8082                	ret

0000000080003530 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003530:	1101                	add	sp,sp,-32
    80003532:	ec06                	sd	ra,24(sp)
    80003534:	e822                	sd	s0,16(sp)
    80003536:	e426                	sd	s1,8(sp)
    80003538:	e04a                	sd	s2,0(sp)
    8000353a:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000353c:	00016917          	auipc	s2,0x16
    80003540:	ce490913          	add	s2,s2,-796 # 80019220 <log>
    80003544:	01892583          	lw	a1,24(s2)
    80003548:	02892503          	lw	a0,40(s2)
    8000354c:	fffff097          	auipc	ra,0xfffff
    80003550:	fde080e7          	jalr	-34(ra) # 8000252a <bread>
    80003554:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003556:	02c92603          	lw	a2,44(s2)
    8000355a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000355c:	00c05f63          	blez	a2,8000357a <write_head+0x4a>
    80003560:	00016717          	auipc	a4,0x16
    80003564:	cf070713          	add	a4,a4,-784 # 80019250 <log+0x30>
    80003568:	87aa                	mv	a5,a0
    8000356a:	060a                	sll	a2,a2,0x2
    8000356c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000356e:	4314                	lw	a3,0(a4)
    80003570:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003572:	0711                	add	a4,a4,4
    80003574:	0791                	add	a5,a5,4
    80003576:	fec79ce3          	bne	a5,a2,8000356e <write_head+0x3e>
  }
  bwrite(buf);
    8000357a:	8526                	mv	a0,s1
    8000357c:	fffff097          	auipc	ra,0xfffff
    80003580:	0a0080e7          	jalr	160(ra) # 8000261c <bwrite>
  brelse(buf);
    80003584:	8526                	mv	a0,s1
    80003586:	fffff097          	auipc	ra,0xfffff
    8000358a:	0d4080e7          	jalr	212(ra) # 8000265a <brelse>
}
    8000358e:	60e2                	ld	ra,24(sp)
    80003590:	6442                	ld	s0,16(sp)
    80003592:	64a2                	ld	s1,8(sp)
    80003594:	6902                	ld	s2,0(sp)
    80003596:	6105                	add	sp,sp,32
    80003598:	8082                	ret

000000008000359a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000359a:	00016797          	auipc	a5,0x16
    8000359e:	cb27a783          	lw	a5,-846(a5) # 8001924c <log+0x2c>
    800035a2:	0af05d63          	blez	a5,8000365c <install_trans+0xc2>
{
    800035a6:	7139                	add	sp,sp,-64
    800035a8:	fc06                	sd	ra,56(sp)
    800035aa:	f822                	sd	s0,48(sp)
    800035ac:	f426                	sd	s1,40(sp)
    800035ae:	f04a                	sd	s2,32(sp)
    800035b0:	ec4e                	sd	s3,24(sp)
    800035b2:	e852                	sd	s4,16(sp)
    800035b4:	e456                	sd	s5,8(sp)
    800035b6:	e05a                	sd	s6,0(sp)
    800035b8:	0080                	add	s0,sp,64
    800035ba:	8b2a                	mv	s6,a0
    800035bc:	00016a97          	auipc	s5,0x16
    800035c0:	c94a8a93          	add	s5,s5,-876 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035c4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035c6:	00016997          	auipc	s3,0x16
    800035ca:	c5a98993          	add	s3,s3,-934 # 80019220 <log>
    800035ce:	a00d                	j	800035f0 <install_trans+0x56>
    brelse(lbuf);
    800035d0:	854a                	mv	a0,s2
    800035d2:	fffff097          	auipc	ra,0xfffff
    800035d6:	088080e7          	jalr	136(ra) # 8000265a <brelse>
    brelse(dbuf);
    800035da:	8526                	mv	a0,s1
    800035dc:	fffff097          	auipc	ra,0xfffff
    800035e0:	07e080e7          	jalr	126(ra) # 8000265a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035e4:	2a05                	addw	s4,s4,1
    800035e6:	0a91                	add	s5,s5,4
    800035e8:	02c9a783          	lw	a5,44(s3)
    800035ec:	04fa5e63          	bge	s4,a5,80003648 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035f0:	0189a583          	lw	a1,24(s3)
    800035f4:	014585bb          	addw	a1,a1,s4
    800035f8:	2585                	addw	a1,a1,1
    800035fa:	0289a503          	lw	a0,40(s3)
    800035fe:	fffff097          	auipc	ra,0xfffff
    80003602:	f2c080e7          	jalr	-212(ra) # 8000252a <bread>
    80003606:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003608:	000aa583          	lw	a1,0(s5)
    8000360c:	0289a503          	lw	a0,40(s3)
    80003610:	fffff097          	auipc	ra,0xfffff
    80003614:	f1a080e7          	jalr	-230(ra) # 8000252a <bread>
    80003618:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000361a:	40000613          	li	a2,1024
    8000361e:	05890593          	add	a1,s2,88
    80003622:	05850513          	add	a0,a0,88
    80003626:	ffffd097          	auipc	ra,0xffffd
    8000362a:	bb0080e7          	jalr	-1104(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000362e:	8526                	mv	a0,s1
    80003630:	fffff097          	auipc	ra,0xfffff
    80003634:	fec080e7          	jalr	-20(ra) # 8000261c <bwrite>
    if(recovering == 0)
    80003638:	f80b1ce3          	bnez	s6,800035d0 <install_trans+0x36>
      bunpin(dbuf);
    8000363c:	8526                	mv	a0,s1
    8000363e:	fffff097          	auipc	ra,0xfffff
    80003642:	0f4080e7          	jalr	244(ra) # 80002732 <bunpin>
    80003646:	b769                	j	800035d0 <install_trans+0x36>
}
    80003648:	70e2                	ld	ra,56(sp)
    8000364a:	7442                	ld	s0,48(sp)
    8000364c:	74a2                	ld	s1,40(sp)
    8000364e:	7902                	ld	s2,32(sp)
    80003650:	69e2                	ld	s3,24(sp)
    80003652:	6a42                	ld	s4,16(sp)
    80003654:	6aa2                	ld	s5,8(sp)
    80003656:	6b02                	ld	s6,0(sp)
    80003658:	6121                	add	sp,sp,64
    8000365a:	8082                	ret
    8000365c:	8082                	ret

000000008000365e <initlog>:
{
    8000365e:	7179                	add	sp,sp,-48
    80003660:	f406                	sd	ra,40(sp)
    80003662:	f022                	sd	s0,32(sp)
    80003664:	ec26                	sd	s1,24(sp)
    80003666:	e84a                	sd	s2,16(sp)
    80003668:	e44e                	sd	s3,8(sp)
    8000366a:	1800                	add	s0,sp,48
    8000366c:	892a                	mv	s2,a0
    8000366e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003670:	00016497          	auipc	s1,0x16
    80003674:	bb048493          	add	s1,s1,-1104 # 80019220 <log>
    80003678:	00005597          	auipc	a1,0x5
    8000367c:	e7858593          	add	a1,a1,-392 # 800084f0 <etext+0x4f0>
    80003680:	8526                	mv	a0,s1
    80003682:	00003097          	auipc	ra,0x3
    80003686:	d14080e7          	jalr	-748(ra) # 80006396 <initlock>
  log.start = sb->logstart;
    8000368a:	0149a583          	lw	a1,20(s3)
    8000368e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003690:	0109a783          	lw	a5,16(s3)
    80003694:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003696:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000369a:	854a                	mv	a0,s2
    8000369c:	fffff097          	auipc	ra,0xfffff
    800036a0:	e8e080e7          	jalr	-370(ra) # 8000252a <bread>
  log.lh.n = lh->n;
    800036a4:	4d30                	lw	a2,88(a0)
    800036a6:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036a8:	00c05f63          	blez	a2,800036c6 <initlog+0x68>
    800036ac:	87aa                	mv	a5,a0
    800036ae:	00016717          	auipc	a4,0x16
    800036b2:	ba270713          	add	a4,a4,-1118 # 80019250 <log+0x30>
    800036b6:	060a                	sll	a2,a2,0x2
    800036b8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800036ba:	4ff4                	lw	a3,92(a5)
    800036bc:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036be:	0791                	add	a5,a5,4
    800036c0:	0711                	add	a4,a4,4
    800036c2:	fec79ce3          	bne	a5,a2,800036ba <initlog+0x5c>
  brelse(buf);
    800036c6:	fffff097          	auipc	ra,0xfffff
    800036ca:	f94080e7          	jalr	-108(ra) # 8000265a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036ce:	4505                	li	a0,1
    800036d0:	00000097          	auipc	ra,0x0
    800036d4:	eca080e7          	jalr	-310(ra) # 8000359a <install_trans>
  log.lh.n = 0;
    800036d8:	00016797          	auipc	a5,0x16
    800036dc:	b607aa23          	sw	zero,-1164(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800036e0:	00000097          	auipc	ra,0x0
    800036e4:	e50080e7          	jalr	-432(ra) # 80003530 <write_head>
}
    800036e8:	70a2                	ld	ra,40(sp)
    800036ea:	7402                	ld	s0,32(sp)
    800036ec:	64e2                	ld	s1,24(sp)
    800036ee:	6942                	ld	s2,16(sp)
    800036f0:	69a2                	ld	s3,8(sp)
    800036f2:	6145                	add	sp,sp,48
    800036f4:	8082                	ret

00000000800036f6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036f6:	1101                	add	sp,sp,-32
    800036f8:	ec06                	sd	ra,24(sp)
    800036fa:	e822                	sd	s0,16(sp)
    800036fc:	e426                	sd	s1,8(sp)
    800036fe:	e04a                	sd	s2,0(sp)
    80003700:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003702:	00016517          	auipc	a0,0x16
    80003706:	b1e50513          	add	a0,a0,-1250 # 80019220 <log>
    8000370a:	00003097          	auipc	ra,0x3
    8000370e:	d1c080e7          	jalr	-740(ra) # 80006426 <acquire>
  while(1){
    if(log.committing){
    80003712:	00016497          	auipc	s1,0x16
    80003716:	b0e48493          	add	s1,s1,-1266 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000371a:	4979                	li	s2,30
    8000371c:	a039                	j	8000372a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000371e:	85a6                	mv	a1,s1
    80003720:	8526                	mv	a0,s1
    80003722:	ffffe097          	auipc	ra,0xffffe
    80003726:	f7e080e7          	jalr	-130(ra) # 800016a0 <sleep>
    if(log.committing){
    8000372a:	50dc                	lw	a5,36(s1)
    8000372c:	fbed                	bnez	a5,8000371e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000372e:	5098                	lw	a4,32(s1)
    80003730:	2705                	addw	a4,a4,1
    80003732:	0027179b          	sllw	a5,a4,0x2
    80003736:	9fb9                	addw	a5,a5,a4
    80003738:	0017979b          	sllw	a5,a5,0x1
    8000373c:	54d4                	lw	a3,44(s1)
    8000373e:	9fb5                	addw	a5,a5,a3
    80003740:	00f95963          	bge	s2,a5,80003752 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003744:	85a6                	mv	a1,s1
    80003746:	8526                	mv	a0,s1
    80003748:	ffffe097          	auipc	ra,0xffffe
    8000374c:	f58080e7          	jalr	-168(ra) # 800016a0 <sleep>
    80003750:	bfe9                	j	8000372a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003752:	00016517          	auipc	a0,0x16
    80003756:	ace50513          	add	a0,a0,-1330 # 80019220 <log>
    8000375a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000375c:	00003097          	auipc	ra,0x3
    80003760:	d7e080e7          	jalr	-642(ra) # 800064da <release>
      break;
    }
  }
}
    80003764:	60e2                	ld	ra,24(sp)
    80003766:	6442                	ld	s0,16(sp)
    80003768:	64a2                	ld	s1,8(sp)
    8000376a:	6902                	ld	s2,0(sp)
    8000376c:	6105                	add	sp,sp,32
    8000376e:	8082                	ret

0000000080003770 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003770:	7139                	add	sp,sp,-64
    80003772:	fc06                	sd	ra,56(sp)
    80003774:	f822                	sd	s0,48(sp)
    80003776:	f426                	sd	s1,40(sp)
    80003778:	f04a                	sd	s2,32(sp)
    8000377a:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000377c:	00016497          	auipc	s1,0x16
    80003780:	aa448493          	add	s1,s1,-1372 # 80019220 <log>
    80003784:	8526                	mv	a0,s1
    80003786:	00003097          	auipc	ra,0x3
    8000378a:	ca0080e7          	jalr	-864(ra) # 80006426 <acquire>
  log.outstanding -= 1;
    8000378e:	509c                	lw	a5,32(s1)
    80003790:	37fd                	addw	a5,a5,-1
    80003792:	0007891b          	sext.w	s2,a5
    80003796:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003798:	50dc                	lw	a5,36(s1)
    8000379a:	e7b9                	bnez	a5,800037e8 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000379c:	06091163          	bnez	s2,800037fe <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037a0:	00016497          	auipc	s1,0x16
    800037a4:	a8048493          	add	s1,s1,-1408 # 80019220 <log>
    800037a8:	4785                	li	a5,1
    800037aa:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037ac:	8526                	mv	a0,s1
    800037ae:	00003097          	auipc	ra,0x3
    800037b2:	d2c080e7          	jalr	-724(ra) # 800064da <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037b6:	54dc                	lw	a5,44(s1)
    800037b8:	06f04763          	bgtz	a5,80003826 <end_op+0xb6>
    acquire(&log.lock);
    800037bc:	00016497          	auipc	s1,0x16
    800037c0:	a6448493          	add	s1,s1,-1436 # 80019220 <log>
    800037c4:	8526                	mv	a0,s1
    800037c6:	00003097          	auipc	ra,0x3
    800037ca:	c60080e7          	jalr	-928(ra) # 80006426 <acquire>
    log.committing = 0;
    800037ce:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037d2:	8526                	mv	a0,s1
    800037d4:	ffffe097          	auipc	ra,0xffffe
    800037d8:	058080e7          	jalr	88(ra) # 8000182c <wakeup>
    release(&log.lock);
    800037dc:	8526                	mv	a0,s1
    800037de:	00003097          	auipc	ra,0x3
    800037e2:	cfc080e7          	jalr	-772(ra) # 800064da <release>
}
    800037e6:	a815                	j	8000381a <end_op+0xaa>
    800037e8:	ec4e                	sd	s3,24(sp)
    800037ea:	e852                	sd	s4,16(sp)
    800037ec:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800037ee:	00005517          	auipc	a0,0x5
    800037f2:	d0a50513          	add	a0,a0,-758 # 800084f8 <etext+0x4f8>
    800037f6:	00002097          	auipc	ra,0x2
    800037fa:	6b6080e7          	jalr	1718(ra) # 80005eac <panic>
    wakeup(&log);
    800037fe:	00016497          	auipc	s1,0x16
    80003802:	a2248493          	add	s1,s1,-1502 # 80019220 <log>
    80003806:	8526                	mv	a0,s1
    80003808:	ffffe097          	auipc	ra,0xffffe
    8000380c:	024080e7          	jalr	36(ra) # 8000182c <wakeup>
  release(&log.lock);
    80003810:	8526                	mv	a0,s1
    80003812:	00003097          	auipc	ra,0x3
    80003816:	cc8080e7          	jalr	-824(ra) # 800064da <release>
}
    8000381a:	70e2                	ld	ra,56(sp)
    8000381c:	7442                	ld	s0,48(sp)
    8000381e:	74a2                	ld	s1,40(sp)
    80003820:	7902                	ld	s2,32(sp)
    80003822:	6121                	add	sp,sp,64
    80003824:	8082                	ret
    80003826:	ec4e                	sd	s3,24(sp)
    80003828:	e852                	sd	s4,16(sp)
    8000382a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000382c:	00016a97          	auipc	s5,0x16
    80003830:	a24a8a93          	add	s5,s5,-1500 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003834:	00016a17          	auipc	s4,0x16
    80003838:	9eca0a13          	add	s4,s4,-1556 # 80019220 <log>
    8000383c:	018a2583          	lw	a1,24(s4)
    80003840:	012585bb          	addw	a1,a1,s2
    80003844:	2585                	addw	a1,a1,1
    80003846:	028a2503          	lw	a0,40(s4)
    8000384a:	fffff097          	auipc	ra,0xfffff
    8000384e:	ce0080e7          	jalr	-800(ra) # 8000252a <bread>
    80003852:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003854:	000aa583          	lw	a1,0(s5)
    80003858:	028a2503          	lw	a0,40(s4)
    8000385c:	fffff097          	auipc	ra,0xfffff
    80003860:	cce080e7          	jalr	-818(ra) # 8000252a <bread>
    80003864:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003866:	40000613          	li	a2,1024
    8000386a:	05850593          	add	a1,a0,88
    8000386e:	05848513          	add	a0,s1,88
    80003872:	ffffd097          	auipc	ra,0xffffd
    80003876:	964080e7          	jalr	-1692(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000387a:	8526                	mv	a0,s1
    8000387c:	fffff097          	auipc	ra,0xfffff
    80003880:	da0080e7          	jalr	-608(ra) # 8000261c <bwrite>
    brelse(from);
    80003884:	854e                	mv	a0,s3
    80003886:	fffff097          	auipc	ra,0xfffff
    8000388a:	dd4080e7          	jalr	-556(ra) # 8000265a <brelse>
    brelse(to);
    8000388e:	8526                	mv	a0,s1
    80003890:	fffff097          	auipc	ra,0xfffff
    80003894:	dca080e7          	jalr	-566(ra) # 8000265a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003898:	2905                	addw	s2,s2,1
    8000389a:	0a91                	add	s5,s5,4
    8000389c:	02ca2783          	lw	a5,44(s4)
    800038a0:	f8f94ee3          	blt	s2,a5,8000383c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038a4:	00000097          	auipc	ra,0x0
    800038a8:	c8c080e7          	jalr	-884(ra) # 80003530 <write_head>
    install_trans(0); // Now install writes to home locations
    800038ac:	4501                	li	a0,0
    800038ae:	00000097          	auipc	ra,0x0
    800038b2:	cec080e7          	jalr	-788(ra) # 8000359a <install_trans>
    log.lh.n = 0;
    800038b6:	00016797          	auipc	a5,0x16
    800038ba:	9807ab23          	sw	zero,-1642(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038be:	00000097          	auipc	ra,0x0
    800038c2:	c72080e7          	jalr	-910(ra) # 80003530 <write_head>
    800038c6:	69e2                	ld	s3,24(sp)
    800038c8:	6a42                	ld	s4,16(sp)
    800038ca:	6aa2                	ld	s5,8(sp)
    800038cc:	bdc5                	j	800037bc <end_op+0x4c>

00000000800038ce <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038ce:	1101                	add	sp,sp,-32
    800038d0:	ec06                	sd	ra,24(sp)
    800038d2:	e822                	sd	s0,16(sp)
    800038d4:	e426                	sd	s1,8(sp)
    800038d6:	e04a                	sd	s2,0(sp)
    800038d8:	1000                	add	s0,sp,32
    800038da:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038dc:	00016917          	auipc	s2,0x16
    800038e0:	94490913          	add	s2,s2,-1724 # 80019220 <log>
    800038e4:	854a                	mv	a0,s2
    800038e6:	00003097          	auipc	ra,0x3
    800038ea:	b40080e7          	jalr	-1216(ra) # 80006426 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038ee:	02c92603          	lw	a2,44(s2)
    800038f2:	47f5                	li	a5,29
    800038f4:	06c7c563          	blt	a5,a2,8000395e <log_write+0x90>
    800038f8:	00016797          	auipc	a5,0x16
    800038fc:	9447a783          	lw	a5,-1724(a5) # 8001923c <log+0x1c>
    80003900:	37fd                	addw	a5,a5,-1
    80003902:	04f65e63          	bge	a2,a5,8000395e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003906:	00016797          	auipc	a5,0x16
    8000390a:	93a7a783          	lw	a5,-1734(a5) # 80019240 <log+0x20>
    8000390e:	06f05063          	blez	a5,8000396e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003912:	4781                	li	a5,0
    80003914:	06c05563          	blez	a2,8000397e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003918:	44cc                	lw	a1,12(s1)
    8000391a:	00016717          	auipc	a4,0x16
    8000391e:	93670713          	add	a4,a4,-1738 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003922:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003924:	4314                	lw	a3,0(a4)
    80003926:	04b68c63          	beq	a3,a1,8000397e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000392a:	2785                	addw	a5,a5,1
    8000392c:	0711                	add	a4,a4,4
    8000392e:	fef61be3          	bne	a2,a5,80003924 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003932:	0621                	add	a2,a2,8
    80003934:	060a                	sll	a2,a2,0x2
    80003936:	00016797          	auipc	a5,0x16
    8000393a:	8ea78793          	add	a5,a5,-1814 # 80019220 <log>
    8000393e:	97b2                	add	a5,a5,a2
    80003940:	44d8                	lw	a4,12(s1)
    80003942:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003944:	8526                	mv	a0,s1
    80003946:	fffff097          	auipc	ra,0xfffff
    8000394a:	db0080e7          	jalr	-592(ra) # 800026f6 <bpin>
    log.lh.n++;
    8000394e:	00016717          	auipc	a4,0x16
    80003952:	8d270713          	add	a4,a4,-1838 # 80019220 <log>
    80003956:	575c                	lw	a5,44(a4)
    80003958:	2785                	addw	a5,a5,1
    8000395a:	d75c                	sw	a5,44(a4)
    8000395c:	a82d                	j	80003996 <log_write+0xc8>
    panic("too big a transaction");
    8000395e:	00005517          	auipc	a0,0x5
    80003962:	baa50513          	add	a0,a0,-1110 # 80008508 <etext+0x508>
    80003966:	00002097          	auipc	ra,0x2
    8000396a:	546080e7          	jalr	1350(ra) # 80005eac <panic>
    panic("log_write outside of trans");
    8000396e:	00005517          	auipc	a0,0x5
    80003972:	bb250513          	add	a0,a0,-1102 # 80008520 <etext+0x520>
    80003976:	00002097          	auipc	ra,0x2
    8000397a:	536080e7          	jalr	1334(ra) # 80005eac <panic>
  log.lh.block[i] = b->blockno;
    8000397e:	00878693          	add	a3,a5,8
    80003982:	068a                	sll	a3,a3,0x2
    80003984:	00016717          	auipc	a4,0x16
    80003988:	89c70713          	add	a4,a4,-1892 # 80019220 <log>
    8000398c:	9736                	add	a4,a4,a3
    8000398e:	44d4                	lw	a3,12(s1)
    80003990:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003992:	faf609e3          	beq	a2,a5,80003944 <log_write+0x76>
  }
  release(&log.lock);
    80003996:	00016517          	auipc	a0,0x16
    8000399a:	88a50513          	add	a0,a0,-1910 # 80019220 <log>
    8000399e:	00003097          	auipc	ra,0x3
    800039a2:	b3c080e7          	jalr	-1220(ra) # 800064da <release>
}
    800039a6:	60e2                	ld	ra,24(sp)
    800039a8:	6442                	ld	s0,16(sp)
    800039aa:	64a2                	ld	s1,8(sp)
    800039ac:	6902                	ld	s2,0(sp)
    800039ae:	6105                	add	sp,sp,32
    800039b0:	8082                	ret

00000000800039b2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039b2:	1101                	add	sp,sp,-32
    800039b4:	ec06                	sd	ra,24(sp)
    800039b6:	e822                	sd	s0,16(sp)
    800039b8:	e426                	sd	s1,8(sp)
    800039ba:	e04a                	sd	s2,0(sp)
    800039bc:	1000                	add	s0,sp,32
    800039be:	84aa                	mv	s1,a0
    800039c0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039c2:	00005597          	auipc	a1,0x5
    800039c6:	b7e58593          	add	a1,a1,-1154 # 80008540 <etext+0x540>
    800039ca:	0521                	add	a0,a0,8
    800039cc:	00003097          	auipc	ra,0x3
    800039d0:	9ca080e7          	jalr	-1590(ra) # 80006396 <initlock>
  lk->name = name;
    800039d4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039d8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039dc:	0204a423          	sw	zero,40(s1)
}
    800039e0:	60e2                	ld	ra,24(sp)
    800039e2:	6442                	ld	s0,16(sp)
    800039e4:	64a2                	ld	s1,8(sp)
    800039e6:	6902                	ld	s2,0(sp)
    800039e8:	6105                	add	sp,sp,32
    800039ea:	8082                	ret

00000000800039ec <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039ec:	1101                	add	sp,sp,-32
    800039ee:	ec06                	sd	ra,24(sp)
    800039f0:	e822                	sd	s0,16(sp)
    800039f2:	e426                	sd	s1,8(sp)
    800039f4:	e04a                	sd	s2,0(sp)
    800039f6:	1000                	add	s0,sp,32
    800039f8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039fa:	00850913          	add	s2,a0,8
    800039fe:	854a                	mv	a0,s2
    80003a00:	00003097          	auipc	ra,0x3
    80003a04:	a26080e7          	jalr	-1498(ra) # 80006426 <acquire>
  while (lk->locked) {
    80003a08:	409c                	lw	a5,0(s1)
    80003a0a:	cb89                	beqz	a5,80003a1c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a0c:	85ca                	mv	a1,s2
    80003a0e:	8526                	mv	a0,s1
    80003a10:	ffffe097          	auipc	ra,0xffffe
    80003a14:	c90080e7          	jalr	-880(ra) # 800016a0 <sleep>
  while (lk->locked) {
    80003a18:	409c                	lw	a5,0(s1)
    80003a1a:	fbed                	bnez	a5,80003a0c <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a1c:	4785                	li	a5,1
    80003a1e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a20:	ffffd097          	auipc	ra,0xffffd
    80003a24:	51e080e7          	jalr	1310(ra) # 80000f3e <myproc>
    80003a28:	591c                	lw	a5,48(a0)
    80003a2a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a2c:	854a                	mv	a0,s2
    80003a2e:	00003097          	auipc	ra,0x3
    80003a32:	aac080e7          	jalr	-1364(ra) # 800064da <release>
}
    80003a36:	60e2                	ld	ra,24(sp)
    80003a38:	6442                	ld	s0,16(sp)
    80003a3a:	64a2                	ld	s1,8(sp)
    80003a3c:	6902                	ld	s2,0(sp)
    80003a3e:	6105                	add	sp,sp,32
    80003a40:	8082                	ret

0000000080003a42 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a42:	1101                	add	sp,sp,-32
    80003a44:	ec06                	sd	ra,24(sp)
    80003a46:	e822                	sd	s0,16(sp)
    80003a48:	e426                	sd	s1,8(sp)
    80003a4a:	e04a                	sd	s2,0(sp)
    80003a4c:	1000                	add	s0,sp,32
    80003a4e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a50:	00850913          	add	s2,a0,8
    80003a54:	854a                	mv	a0,s2
    80003a56:	00003097          	auipc	ra,0x3
    80003a5a:	9d0080e7          	jalr	-1584(ra) # 80006426 <acquire>
  lk->locked = 0;
    80003a5e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a62:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a66:	8526                	mv	a0,s1
    80003a68:	ffffe097          	auipc	ra,0xffffe
    80003a6c:	dc4080e7          	jalr	-572(ra) # 8000182c <wakeup>
  release(&lk->lk);
    80003a70:	854a                	mv	a0,s2
    80003a72:	00003097          	auipc	ra,0x3
    80003a76:	a68080e7          	jalr	-1432(ra) # 800064da <release>
}
    80003a7a:	60e2                	ld	ra,24(sp)
    80003a7c:	6442                	ld	s0,16(sp)
    80003a7e:	64a2                	ld	s1,8(sp)
    80003a80:	6902                	ld	s2,0(sp)
    80003a82:	6105                	add	sp,sp,32
    80003a84:	8082                	ret

0000000080003a86 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a86:	7179                	add	sp,sp,-48
    80003a88:	f406                	sd	ra,40(sp)
    80003a8a:	f022                	sd	s0,32(sp)
    80003a8c:	ec26                	sd	s1,24(sp)
    80003a8e:	e84a                	sd	s2,16(sp)
    80003a90:	1800                	add	s0,sp,48
    80003a92:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a94:	00850913          	add	s2,a0,8
    80003a98:	854a                	mv	a0,s2
    80003a9a:	00003097          	auipc	ra,0x3
    80003a9e:	98c080e7          	jalr	-1652(ra) # 80006426 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aa2:	409c                	lw	a5,0(s1)
    80003aa4:	ef91                	bnez	a5,80003ac0 <holdingsleep+0x3a>
    80003aa6:	4481                	li	s1,0
  release(&lk->lk);
    80003aa8:	854a                	mv	a0,s2
    80003aaa:	00003097          	auipc	ra,0x3
    80003aae:	a30080e7          	jalr	-1488(ra) # 800064da <release>
  return r;
}
    80003ab2:	8526                	mv	a0,s1
    80003ab4:	70a2                	ld	ra,40(sp)
    80003ab6:	7402                	ld	s0,32(sp)
    80003ab8:	64e2                	ld	s1,24(sp)
    80003aba:	6942                	ld	s2,16(sp)
    80003abc:	6145                	add	sp,sp,48
    80003abe:	8082                	ret
    80003ac0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ac2:	0284a983          	lw	s3,40(s1)
    80003ac6:	ffffd097          	auipc	ra,0xffffd
    80003aca:	478080e7          	jalr	1144(ra) # 80000f3e <myproc>
    80003ace:	5904                	lw	s1,48(a0)
    80003ad0:	413484b3          	sub	s1,s1,s3
    80003ad4:	0014b493          	seqz	s1,s1
    80003ad8:	69a2                	ld	s3,8(sp)
    80003ada:	b7f9                	j	80003aa8 <holdingsleep+0x22>

0000000080003adc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003adc:	1141                	add	sp,sp,-16
    80003ade:	e406                	sd	ra,8(sp)
    80003ae0:	e022                	sd	s0,0(sp)
    80003ae2:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ae4:	00005597          	auipc	a1,0x5
    80003ae8:	a6c58593          	add	a1,a1,-1428 # 80008550 <etext+0x550>
    80003aec:	00016517          	auipc	a0,0x16
    80003af0:	87c50513          	add	a0,a0,-1924 # 80019368 <ftable>
    80003af4:	00003097          	auipc	ra,0x3
    80003af8:	8a2080e7          	jalr	-1886(ra) # 80006396 <initlock>
}
    80003afc:	60a2                	ld	ra,8(sp)
    80003afe:	6402                	ld	s0,0(sp)
    80003b00:	0141                	add	sp,sp,16
    80003b02:	8082                	ret

0000000080003b04 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b04:	1101                	add	sp,sp,-32
    80003b06:	ec06                	sd	ra,24(sp)
    80003b08:	e822                	sd	s0,16(sp)
    80003b0a:	e426                	sd	s1,8(sp)
    80003b0c:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b0e:	00016517          	auipc	a0,0x16
    80003b12:	85a50513          	add	a0,a0,-1958 # 80019368 <ftable>
    80003b16:	00003097          	auipc	ra,0x3
    80003b1a:	910080e7          	jalr	-1776(ra) # 80006426 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b1e:	00016497          	auipc	s1,0x16
    80003b22:	86248493          	add	s1,s1,-1950 # 80019380 <ftable+0x18>
    80003b26:	00016717          	auipc	a4,0x16
    80003b2a:	7fa70713          	add	a4,a4,2042 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b2e:	40dc                	lw	a5,4(s1)
    80003b30:	cf99                	beqz	a5,80003b4e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b32:	02848493          	add	s1,s1,40
    80003b36:	fee49ce3          	bne	s1,a4,80003b2e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b3a:	00016517          	auipc	a0,0x16
    80003b3e:	82e50513          	add	a0,a0,-2002 # 80019368 <ftable>
    80003b42:	00003097          	auipc	ra,0x3
    80003b46:	998080e7          	jalr	-1640(ra) # 800064da <release>
  return 0;
    80003b4a:	4481                	li	s1,0
    80003b4c:	a819                	j	80003b62 <filealloc+0x5e>
      f->ref = 1;
    80003b4e:	4785                	li	a5,1
    80003b50:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b52:	00016517          	auipc	a0,0x16
    80003b56:	81650513          	add	a0,a0,-2026 # 80019368 <ftable>
    80003b5a:	00003097          	auipc	ra,0x3
    80003b5e:	980080e7          	jalr	-1664(ra) # 800064da <release>
}
    80003b62:	8526                	mv	a0,s1
    80003b64:	60e2                	ld	ra,24(sp)
    80003b66:	6442                	ld	s0,16(sp)
    80003b68:	64a2                	ld	s1,8(sp)
    80003b6a:	6105                	add	sp,sp,32
    80003b6c:	8082                	ret

0000000080003b6e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b6e:	1101                	add	sp,sp,-32
    80003b70:	ec06                	sd	ra,24(sp)
    80003b72:	e822                	sd	s0,16(sp)
    80003b74:	e426                	sd	s1,8(sp)
    80003b76:	1000                	add	s0,sp,32
    80003b78:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b7a:	00015517          	auipc	a0,0x15
    80003b7e:	7ee50513          	add	a0,a0,2030 # 80019368 <ftable>
    80003b82:	00003097          	auipc	ra,0x3
    80003b86:	8a4080e7          	jalr	-1884(ra) # 80006426 <acquire>
  if(f->ref < 1)
    80003b8a:	40dc                	lw	a5,4(s1)
    80003b8c:	02f05263          	blez	a5,80003bb0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b90:	2785                	addw	a5,a5,1
    80003b92:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b94:	00015517          	auipc	a0,0x15
    80003b98:	7d450513          	add	a0,a0,2004 # 80019368 <ftable>
    80003b9c:	00003097          	auipc	ra,0x3
    80003ba0:	93e080e7          	jalr	-1730(ra) # 800064da <release>
  return f;
}
    80003ba4:	8526                	mv	a0,s1
    80003ba6:	60e2                	ld	ra,24(sp)
    80003ba8:	6442                	ld	s0,16(sp)
    80003baa:	64a2                	ld	s1,8(sp)
    80003bac:	6105                	add	sp,sp,32
    80003bae:	8082                	ret
    panic("filedup");
    80003bb0:	00005517          	auipc	a0,0x5
    80003bb4:	9a850513          	add	a0,a0,-1624 # 80008558 <etext+0x558>
    80003bb8:	00002097          	auipc	ra,0x2
    80003bbc:	2f4080e7          	jalr	756(ra) # 80005eac <panic>

0000000080003bc0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bc0:	7139                	add	sp,sp,-64
    80003bc2:	fc06                	sd	ra,56(sp)
    80003bc4:	f822                	sd	s0,48(sp)
    80003bc6:	f426                	sd	s1,40(sp)
    80003bc8:	0080                	add	s0,sp,64
    80003bca:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bcc:	00015517          	auipc	a0,0x15
    80003bd0:	79c50513          	add	a0,a0,1948 # 80019368 <ftable>
    80003bd4:	00003097          	auipc	ra,0x3
    80003bd8:	852080e7          	jalr	-1966(ra) # 80006426 <acquire>
  if(f->ref < 1)
    80003bdc:	40dc                	lw	a5,4(s1)
    80003bde:	04f05c63          	blez	a5,80003c36 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003be2:	37fd                	addw	a5,a5,-1
    80003be4:	0007871b          	sext.w	a4,a5
    80003be8:	c0dc                	sw	a5,4(s1)
    80003bea:	06e04263          	bgtz	a4,80003c4e <fileclose+0x8e>
    80003bee:	f04a                	sd	s2,32(sp)
    80003bf0:	ec4e                	sd	s3,24(sp)
    80003bf2:	e852                	sd	s4,16(sp)
    80003bf4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bf6:	0004a903          	lw	s2,0(s1)
    80003bfa:	0094ca83          	lbu	s5,9(s1)
    80003bfe:	0104ba03          	ld	s4,16(s1)
    80003c02:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c06:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c0a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c0e:	00015517          	auipc	a0,0x15
    80003c12:	75a50513          	add	a0,a0,1882 # 80019368 <ftable>
    80003c16:	00003097          	auipc	ra,0x3
    80003c1a:	8c4080e7          	jalr	-1852(ra) # 800064da <release>

  if(ff.type == FD_PIPE){
    80003c1e:	4785                	li	a5,1
    80003c20:	04f90463          	beq	s2,a5,80003c68 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c24:	3979                	addw	s2,s2,-2
    80003c26:	4785                	li	a5,1
    80003c28:	0527fb63          	bgeu	a5,s2,80003c7e <fileclose+0xbe>
    80003c2c:	7902                	ld	s2,32(sp)
    80003c2e:	69e2                	ld	s3,24(sp)
    80003c30:	6a42                	ld	s4,16(sp)
    80003c32:	6aa2                	ld	s5,8(sp)
    80003c34:	a02d                	j	80003c5e <fileclose+0x9e>
    80003c36:	f04a                	sd	s2,32(sp)
    80003c38:	ec4e                	sd	s3,24(sp)
    80003c3a:	e852                	sd	s4,16(sp)
    80003c3c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003c3e:	00005517          	auipc	a0,0x5
    80003c42:	92250513          	add	a0,a0,-1758 # 80008560 <etext+0x560>
    80003c46:	00002097          	auipc	ra,0x2
    80003c4a:	266080e7          	jalr	614(ra) # 80005eac <panic>
    release(&ftable.lock);
    80003c4e:	00015517          	auipc	a0,0x15
    80003c52:	71a50513          	add	a0,a0,1818 # 80019368 <ftable>
    80003c56:	00003097          	auipc	ra,0x3
    80003c5a:	884080e7          	jalr	-1916(ra) # 800064da <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003c5e:	70e2                	ld	ra,56(sp)
    80003c60:	7442                	ld	s0,48(sp)
    80003c62:	74a2                	ld	s1,40(sp)
    80003c64:	6121                	add	sp,sp,64
    80003c66:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c68:	85d6                	mv	a1,s5
    80003c6a:	8552                	mv	a0,s4
    80003c6c:	00000097          	auipc	ra,0x0
    80003c70:	3a2080e7          	jalr	930(ra) # 8000400e <pipeclose>
    80003c74:	7902                	ld	s2,32(sp)
    80003c76:	69e2                	ld	s3,24(sp)
    80003c78:	6a42                	ld	s4,16(sp)
    80003c7a:	6aa2                	ld	s5,8(sp)
    80003c7c:	b7cd                	j	80003c5e <fileclose+0x9e>
    begin_op();
    80003c7e:	00000097          	auipc	ra,0x0
    80003c82:	a78080e7          	jalr	-1416(ra) # 800036f6 <begin_op>
    iput(ff.ip);
    80003c86:	854e                	mv	a0,s3
    80003c88:	fffff097          	auipc	ra,0xfffff
    80003c8c:	25a080e7          	jalr	602(ra) # 80002ee2 <iput>
    end_op();
    80003c90:	00000097          	auipc	ra,0x0
    80003c94:	ae0080e7          	jalr	-1312(ra) # 80003770 <end_op>
    80003c98:	7902                	ld	s2,32(sp)
    80003c9a:	69e2                	ld	s3,24(sp)
    80003c9c:	6a42                	ld	s4,16(sp)
    80003c9e:	6aa2                	ld	s5,8(sp)
    80003ca0:	bf7d                	j	80003c5e <fileclose+0x9e>

0000000080003ca2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ca2:	715d                	add	sp,sp,-80
    80003ca4:	e486                	sd	ra,72(sp)
    80003ca6:	e0a2                	sd	s0,64(sp)
    80003ca8:	fc26                	sd	s1,56(sp)
    80003caa:	f44e                	sd	s3,40(sp)
    80003cac:	0880                	add	s0,sp,80
    80003cae:	84aa                	mv	s1,a0
    80003cb0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cb2:	ffffd097          	auipc	ra,0xffffd
    80003cb6:	28c080e7          	jalr	652(ra) # 80000f3e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cba:	409c                	lw	a5,0(s1)
    80003cbc:	37f9                	addw	a5,a5,-2
    80003cbe:	4705                	li	a4,1
    80003cc0:	04f76863          	bltu	a4,a5,80003d10 <filestat+0x6e>
    80003cc4:	f84a                	sd	s2,48(sp)
    80003cc6:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cc8:	6c88                	ld	a0,24(s1)
    80003cca:	fffff097          	auipc	ra,0xfffff
    80003cce:	05a080e7          	jalr	90(ra) # 80002d24 <ilock>
    stati(f->ip, &st);
    80003cd2:	fb840593          	add	a1,s0,-72
    80003cd6:	6c88                	ld	a0,24(s1)
    80003cd8:	fffff097          	auipc	ra,0xfffff
    80003cdc:	2da080e7          	jalr	730(ra) # 80002fb2 <stati>
    iunlock(f->ip);
    80003ce0:	6c88                	ld	a0,24(s1)
    80003ce2:	fffff097          	auipc	ra,0xfffff
    80003ce6:	108080e7          	jalr	264(ra) # 80002dea <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cea:	46e1                	li	a3,24
    80003cec:	fb840613          	add	a2,s0,-72
    80003cf0:	85ce                	mv	a1,s3
    80003cf2:	05093503          	ld	a0,80(s2)
    80003cf6:	ffffd097          	auipc	ra,0xffffd
    80003cfa:	e22080e7          	jalr	-478(ra) # 80000b18 <copyout>
    80003cfe:	41f5551b          	sraw	a0,a0,0x1f
    80003d02:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003d04:	60a6                	ld	ra,72(sp)
    80003d06:	6406                	ld	s0,64(sp)
    80003d08:	74e2                	ld	s1,56(sp)
    80003d0a:	79a2                	ld	s3,40(sp)
    80003d0c:	6161                	add	sp,sp,80
    80003d0e:	8082                	ret
  return -1;
    80003d10:	557d                	li	a0,-1
    80003d12:	bfcd                	j	80003d04 <filestat+0x62>

0000000080003d14 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d14:	7179                	add	sp,sp,-48
    80003d16:	f406                	sd	ra,40(sp)
    80003d18:	f022                	sd	s0,32(sp)
    80003d1a:	e84a                	sd	s2,16(sp)
    80003d1c:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d1e:	00854783          	lbu	a5,8(a0)
    80003d22:	cbc5                	beqz	a5,80003dd2 <fileread+0xbe>
    80003d24:	ec26                	sd	s1,24(sp)
    80003d26:	e44e                	sd	s3,8(sp)
    80003d28:	84aa                	mv	s1,a0
    80003d2a:	89ae                	mv	s3,a1
    80003d2c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d2e:	411c                	lw	a5,0(a0)
    80003d30:	4705                	li	a4,1
    80003d32:	04e78963          	beq	a5,a4,80003d84 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d36:	470d                	li	a4,3
    80003d38:	04e78f63          	beq	a5,a4,80003d96 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d3c:	4709                	li	a4,2
    80003d3e:	08e79263          	bne	a5,a4,80003dc2 <fileread+0xae>
    ilock(f->ip);
    80003d42:	6d08                	ld	a0,24(a0)
    80003d44:	fffff097          	auipc	ra,0xfffff
    80003d48:	fe0080e7          	jalr	-32(ra) # 80002d24 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d4c:	874a                	mv	a4,s2
    80003d4e:	5094                	lw	a3,32(s1)
    80003d50:	864e                	mv	a2,s3
    80003d52:	4585                	li	a1,1
    80003d54:	6c88                	ld	a0,24(s1)
    80003d56:	fffff097          	auipc	ra,0xfffff
    80003d5a:	286080e7          	jalr	646(ra) # 80002fdc <readi>
    80003d5e:	892a                	mv	s2,a0
    80003d60:	00a05563          	blez	a0,80003d6a <fileread+0x56>
      f->off += r;
    80003d64:	509c                	lw	a5,32(s1)
    80003d66:	9fa9                	addw	a5,a5,a0
    80003d68:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d6a:	6c88                	ld	a0,24(s1)
    80003d6c:	fffff097          	auipc	ra,0xfffff
    80003d70:	07e080e7          	jalr	126(ra) # 80002dea <iunlock>
    80003d74:	64e2                	ld	s1,24(sp)
    80003d76:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003d78:	854a                	mv	a0,s2
    80003d7a:	70a2                	ld	ra,40(sp)
    80003d7c:	7402                	ld	s0,32(sp)
    80003d7e:	6942                	ld	s2,16(sp)
    80003d80:	6145                	add	sp,sp,48
    80003d82:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d84:	6908                	ld	a0,16(a0)
    80003d86:	00000097          	auipc	ra,0x0
    80003d8a:	3fa080e7          	jalr	1018(ra) # 80004180 <piperead>
    80003d8e:	892a                	mv	s2,a0
    80003d90:	64e2                	ld	s1,24(sp)
    80003d92:	69a2                	ld	s3,8(sp)
    80003d94:	b7d5                	j	80003d78 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d96:	02451783          	lh	a5,36(a0)
    80003d9a:	03079693          	sll	a3,a5,0x30
    80003d9e:	92c1                	srl	a3,a3,0x30
    80003da0:	4725                	li	a4,9
    80003da2:	02d76a63          	bltu	a4,a3,80003dd6 <fileread+0xc2>
    80003da6:	0792                	sll	a5,a5,0x4
    80003da8:	00015717          	auipc	a4,0x15
    80003dac:	52070713          	add	a4,a4,1312 # 800192c8 <devsw>
    80003db0:	97ba                	add	a5,a5,a4
    80003db2:	639c                	ld	a5,0(a5)
    80003db4:	c78d                	beqz	a5,80003dde <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003db6:	4505                	li	a0,1
    80003db8:	9782                	jalr	a5
    80003dba:	892a                	mv	s2,a0
    80003dbc:	64e2                	ld	s1,24(sp)
    80003dbe:	69a2                	ld	s3,8(sp)
    80003dc0:	bf65                	j	80003d78 <fileread+0x64>
    panic("fileread");
    80003dc2:	00004517          	auipc	a0,0x4
    80003dc6:	7ae50513          	add	a0,a0,1966 # 80008570 <etext+0x570>
    80003dca:	00002097          	auipc	ra,0x2
    80003dce:	0e2080e7          	jalr	226(ra) # 80005eac <panic>
    return -1;
    80003dd2:	597d                	li	s2,-1
    80003dd4:	b755                	j	80003d78 <fileread+0x64>
      return -1;
    80003dd6:	597d                	li	s2,-1
    80003dd8:	64e2                	ld	s1,24(sp)
    80003dda:	69a2                	ld	s3,8(sp)
    80003ddc:	bf71                	j	80003d78 <fileread+0x64>
    80003dde:	597d                	li	s2,-1
    80003de0:	64e2                	ld	s1,24(sp)
    80003de2:	69a2                	ld	s3,8(sp)
    80003de4:	bf51                	j	80003d78 <fileread+0x64>

0000000080003de6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003de6:	00954783          	lbu	a5,9(a0)
    80003dea:	12078963          	beqz	a5,80003f1c <filewrite+0x136>
{
    80003dee:	715d                	add	sp,sp,-80
    80003df0:	e486                	sd	ra,72(sp)
    80003df2:	e0a2                	sd	s0,64(sp)
    80003df4:	f84a                	sd	s2,48(sp)
    80003df6:	f052                	sd	s4,32(sp)
    80003df8:	e85a                	sd	s6,16(sp)
    80003dfa:	0880                	add	s0,sp,80
    80003dfc:	892a                	mv	s2,a0
    80003dfe:	8b2e                	mv	s6,a1
    80003e00:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e02:	411c                	lw	a5,0(a0)
    80003e04:	4705                	li	a4,1
    80003e06:	02e78763          	beq	a5,a4,80003e34 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e0a:	470d                	li	a4,3
    80003e0c:	02e78a63          	beq	a5,a4,80003e40 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e10:	4709                	li	a4,2
    80003e12:	0ee79863          	bne	a5,a4,80003f02 <filewrite+0x11c>
    80003e16:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e18:	0cc05463          	blez	a2,80003ee0 <filewrite+0xfa>
    80003e1c:	fc26                	sd	s1,56(sp)
    80003e1e:	ec56                	sd	s5,24(sp)
    80003e20:	e45e                	sd	s7,8(sp)
    80003e22:	e062                	sd	s8,0(sp)
    int i = 0;
    80003e24:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003e26:	6b85                	lui	s7,0x1
    80003e28:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e2c:	6c05                	lui	s8,0x1
    80003e2e:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e32:	a851                	j	80003ec6 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003e34:	6908                	ld	a0,16(a0)
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	248080e7          	jalr	584(ra) # 8000407e <pipewrite>
    80003e3e:	a85d                	j	80003ef4 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e40:	02451783          	lh	a5,36(a0)
    80003e44:	03079693          	sll	a3,a5,0x30
    80003e48:	92c1                	srl	a3,a3,0x30
    80003e4a:	4725                	li	a4,9
    80003e4c:	0cd76a63          	bltu	a4,a3,80003f20 <filewrite+0x13a>
    80003e50:	0792                	sll	a5,a5,0x4
    80003e52:	00015717          	auipc	a4,0x15
    80003e56:	47670713          	add	a4,a4,1142 # 800192c8 <devsw>
    80003e5a:	97ba                	add	a5,a5,a4
    80003e5c:	679c                	ld	a5,8(a5)
    80003e5e:	c3f9                	beqz	a5,80003f24 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003e60:	4505                	li	a0,1
    80003e62:	9782                	jalr	a5
    80003e64:	a841                	j	80003ef4 <filewrite+0x10e>
      if(n1 > max)
    80003e66:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003e6a:	00000097          	auipc	ra,0x0
    80003e6e:	88c080e7          	jalr	-1908(ra) # 800036f6 <begin_op>
      ilock(f->ip);
    80003e72:	01893503          	ld	a0,24(s2)
    80003e76:	fffff097          	auipc	ra,0xfffff
    80003e7a:	eae080e7          	jalr	-338(ra) # 80002d24 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e7e:	8756                	mv	a4,s5
    80003e80:	02092683          	lw	a3,32(s2)
    80003e84:	01698633          	add	a2,s3,s6
    80003e88:	4585                	li	a1,1
    80003e8a:	01893503          	ld	a0,24(s2)
    80003e8e:	fffff097          	auipc	ra,0xfffff
    80003e92:	252080e7          	jalr	594(ra) # 800030e0 <writei>
    80003e96:	84aa                	mv	s1,a0
    80003e98:	00a05763          	blez	a0,80003ea6 <filewrite+0xc0>
        f->off += r;
    80003e9c:	02092783          	lw	a5,32(s2)
    80003ea0:	9fa9                	addw	a5,a5,a0
    80003ea2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ea6:	01893503          	ld	a0,24(s2)
    80003eaa:	fffff097          	auipc	ra,0xfffff
    80003eae:	f40080e7          	jalr	-192(ra) # 80002dea <iunlock>
      end_op();
    80003eb2:	00000097          	auipc	ra,0x0
    80003eb6:	8be080e7          	jalr	-1858(ra) # 80003770 <end_op>

      if(r != n1){
    80003eba:	029a9563          	bne	s5,s1,80003ee4 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003ebe:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ec2:	0149da63          	bge	s3,s4,80003ed6 <filewrite+0xf0>
      int n1 = n - i;
    80003ec6:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003eca:	0004879b          	sext.w	a5,s1
    80003ece:	f8fbdce3          	bge	s7,a5,80003e66 <filewrite+0x80>
    80003ed2:	84e2                	mv	s1,s8
    80003ed4:	bf49                	j	80003e66 <filewrite+0x80>
    80003ed6:	74e2                	ld	s1,56(sp)
    80003ed8:	6ae2                	ld	s5,24(sp)
    80003eda:	6ba2                	ld	s7,8(sp)
    80003edc:	6c02                	ld	s8,0(sp)
    80003ede:	a039                	j	80003eec <filewrite+0x106>
    int i = 0;
    80003ee0:	4981                	li	s3,0
    80003ee2:	a029                	j	80003eec <filewrite+0x106>
    80003ee4:	74e2                	ld	s1,56(sp)
    80003ee6:	6ae2                	ld	s5,24(sp)
    80003ee8:	6ba2                	ld	s7,8(sp)
    80003eea:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003eec:	033a1e63          	bne	s4,s3,80003f28 <filewrite+0x142>
    80003ef0:	8552                	mv	a0,s4
    80003ef2:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ef4:	60a6                	ld	ra,72(sp)
    80003ef6:	6406                	ld	s0,64(sp)
    80003ef8:	7942                	ld	s2,48(sp)
    80003efa:	7a02                	ld	s4,32(sp)
    80003efc:	6b42                	ld	s6,16(sp)
    80003efe:	6161                	add	sp,sp,80
    80003f00:	8082                	ret
    80003f02:	fc26                	sd	s1,56(sp)
    80003f04:	f44e                	sd	s3,40(sp)
    80003f06:	ec56                	sd	s5,24(sp)
    80003f08:	e45e                	sd	s7,8(sp)
    80003f0a:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003f0c:	00004517          	auipc	a0,0x4
    80003f10:	67450513          	add	a0,a0,1652 # 80008580 <etext+0x580>
    80003f14:	00002097          	auipc	ra,0x2
    80003f18:	f98080e7          	jalr	-104(ra) # 80005eac <panic>
    return -1;
    80003f1c:	557d                	li	a0,-1
}
    80003f1e:	8082                	ret
      return -1;
    80003f20:	557d                	li	a0,-1
    80003f22:	bfc9                	j	80003ef4 <filewrite+0x10e>
    80003f24:	557d                	li	a0,-1
    80003f26:	b7f9                	j	80003ef4 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003f28:	557d                	li	a0,-1
    80003f2a:	79a2                	ld	s3,40(sp)
    80003f2c:	b7e1                	j	80003ef4 <filewrite+0x10e>

0000000080003f2e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f2e:	7179                	add	sp,sp,-48
    80003f30:	f406                	sd	ra,40(sp)
    80003f32:	f022                	sd	s0,32(sp)
    80003f34:	ec26                	sd	s1,24(sp)
    80003f36:	e052                	sd	s4,0(sp)
    80003f38:	1800                	add	s0,sp,48
    80003f3a:	84aa                	mv	s1,a0
    80003f3c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f3e:	0005b023          	sd	zero,0(a1)
    80003f42:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f46:	00000097          	auipc	ra,0x0
    80003f4a:	bbe080e7          	jalr	-1090(ra) # 80003b04 <filealloc>
    80003f4e:	e088                	sd	a0,0(s1)
    80003f50:	cd49                	beqz	a0,80003fea <pipealloc+0xbc>
    80003f52:	00000097          	auipc	ra,0x0
    80003f56:	bb2080e7          	jalr	-1102(ra) # 80003b04 <filealloc>
    80003f5a:	00aa3023          	sd	a0,0(s4)
    80003f5e:	c141                	beqz	a0,80003fde <pipealloc+0xb0>
    80003f60:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f62:	ffffc097          	auipc	ra,0xffffc
    80003f66:	1b8080e7          	jalr	440(ra) # 8000011a <kalloc>
    80003f6a:	892a                	mv	s2,a0
    80003f6c:	c13d                	beqz	a0,80003fd2 <pipealloc+0xa4>
    80003f6e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003f70:	4985                	li	s3,1
    80003f72:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f76:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f7a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f7e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f82:	00004597          	auipc	a1,0x4
    80003f86:	60e58593          	add	a1,a1,1550 # 80008590 <etext+0x590>
    80003f8a:	00002097          	auipc	ra,0x2
    80003f8e:	40c080e7          	jalr	1036(ra) # 80006396 <initlock>
  (*f0)->type = FD_PIPE;
    80003f92:	609c                	ld	a5,0(s1)
    80003f94:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f98:	609c                	ld	a5,0(s1)
    80003f9a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f9e:	609c                	ld	a5,0(s1)
    80003fa0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fa4:	609c                	ld	a5,0(s1)
    80003fa6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003faa:	000a3783          	ld	a5,0(s4)
    80003fae:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fb2:	000a3783          	ld	a5,0(s4)
    80003fb6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fba:	000a3783          	ld	a5,0(s4)
    80003fbe:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fc2:	000a3783          	ld	a5,0(s4)
    80003fc6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fca:	4501                	li	a0,0
    80003fcc:	6942                	ld	s2,16(sp)
    80003fce:	69a2                	ld	s3,8(sp)
    80003fd0:	a03d                	j	80003ffe <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fd2:	6088                	ld	a0,0(s1)
    80003fd4:	c119                	beqz	a0,80003fda <pipealloc+0xac>
    80003fd6:	6942                	ld	s2,16(sp)
    80003fd8:	a029                	j	80003fe2 <pipealloc+0xb4>
    80003fda:	6942                	ld	s2,16(sp)
    80003fdc:	a039                	j	80003fea <pipealloc+0xbc>
    80003fde:	6088                	ld	a0,0(s1)
    80003fe0:	c50d                	beqz	a0,8000400a <pipealloc+0xdc>
    fileclose(*f0);
    80003fe2:	00000097          	auipc	ra,0x0
    80003fe6:	bde080e7          	jalr	-1058(ra) # 80003bc0 <fileclose>
  if(*f1)
    80003fea:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fee:	557d                	li	a0,-1
  if(*f1)
    80003ff0:	c799                	beqz	a5,80003ffe <pipealloc+0xd0>
    fileclose(*f1);
    80003ff2:	853e                	mv	a0,a5
    80003ff4:	00000097          	auipc	ra,0x0
    80003ff8:	bcc080e7          	jalr	-1076(ra) # 80003bc0 <fileclose>
  return -1;
    80003ffc:	557d                	li	a0,-1
}
    80003ffe:	70a2                	ld	ra,40(sp)
    80004000:	7402                	ld	s0,32(sp)
    80004002:	64e2                	ld	s1,24(sp)
    80004004:	6a02                	ld	s4,0(sp)
    80004006:	6145                	add	sp,sp,48
    80004008:	8082                	ret
  return -1;
    8000400a:	557d                	li	a0,-1
    8000400c:	bfcd                	j	80003ffe <pipealloc+0xd0>

000000008000400e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000400e:	1101                	add	sp,sp,-32
    80004010:	ec06                	sd	ra,24(sp)
    80004012:	e822                	sd	s0,16(sp)
    80004014:	e426                	sd	s1,8(sp)
    80004016:	e04a                	sd	s2,0(sp)
    80004018:	1000                	add	s0,sp,32
    8000401a:	84aa                	mv	s1,a0
    8000401c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000401e:	00002097          	auipc	ra,0x2
    80004022:	408080e7          	jalr	1032(ra) # 80006426 <acquire>
  if(writable){
    80004026:	02090d63          	beqz	s2,80004060 <pipeclose+0x52>
    pi->writeopen = 0;
    8000402a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000402e:	21848513          	add	a0,s1,536
    80004032:	ffffd097          	auipc	ra,0xffffd
    80004036:	7fa080e7          	jalr	2042(ra) # 8000182c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000403a:	2204b783          	ld	a5,544(s1)
    8000403e:	eb95                	bnez	a5,80004072 <pipeclose+0x64>
    release(&pi->lock);
    80004040:	8526                	mv	a0,s1
    80004042:	00002097          	auipc	ra,0x2
    80004046:	498080e7          	jalr	1176(ra) # 800064da <release>
    kfree((char*)pi);
    8000404a:	8526                	mv	a0,s1
    8000404c:	ffffc097          	auipc	ra,0xffffc
    80004050:	fd0080e7          	jalr	-48(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004054:	60e2                	ld	ra,24(sp)
    80004056:	6442                	ld	s0,16(sp)
    80004058:	64a2                	ld	s1,8(sp)
    8000405a:	6902                	ld	s2,0(sp)
    8000405c:	6105                	add	sp,sp,32
    8000405e:	8082                	ret
    pi->readopen = 0;
    80004060:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004064:	21c48513          	add	a0,s1,540
    80004068:	ffffd097          	auipc	ra,0xffffd
    8000406c:	7c4080e7          	jalr	1988(ra) # 8000182c <wakeup>
    80004070:	b7e9                	j	8000403a <pipeclose+0x2c>
    release(&pi->lock);
    80004072:	8526                	mv	a0,s1
    80004074:	00002097          	auipc	ra,0x2
    80004078:	466080e7          	jalr	1126(ra) # 800064da <release>
}
    8000407c:	bfe1                	j	80004054 <pipeclose+0x46>

000000008000407e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000407e:	711d                	add	sp,sp,-96
    80004080:	ec86                	sd	ra,88(sp)
    80004082:	e8a2                	sd	s0,80(sp)
    80004084:	e4a6                	sd	s1,72(sp)
    80004086:	e0ca                	sd	s2,64(sp)
    80004088:	fc4e                	sd	s3,56(sp)
    8000408a:	f852                	sd	s4,48(sp)
    8000408c:	f456                	sd	s5,40(sp)
    8000408e:	1080                	add	s0,sp,96
    80004090:	84aa                	mv	s1,a0
    80004092:	8aae                	mv	s5,a1
    80004094:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	ea8080e7          	jalr	-344(ra) # 80000f3e <myproc>
    8000409e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040a0:	8526                	mv	a0,s1
    800040a2:	00002097          	auipc	ra,0x2
    800040a6:	384080e7          	jalr	900(ra) # 80006426 <acquire>
  while(i < n){
    800040aa:	0d405563          	blez	s4,80004174 <pipewrite+0xf6>
    800040ae:	f05a                	sd	s6,32(sp)
    800040b0:	ec5e                	sd	s7,24(sp)
    800040b2:	e862                	sd	s8,16(sp)
  int i = 0;
    800040b4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040b6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040b8:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040bc:	21c48b93          	add	s7,s1,540
    800040c0:	a089                	j	80004102 <pipewrite+0x84>
      release(&pi->lock);
    800040c2:	8526                	mv	a0,s1
    800040c4:	00002097          	auipc	ra,0x2
    800040c8:	416080e7          	jalr	1046(ra) # 800064da <release>
      return -1;
    800040cc:	597d                	li	s2,-1
    800040ce:	7b02                	ld	s6,32(sp)
    800040d0:	6be2                	ld	s7,24(sp)
    800040d2:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040d4:	854a                	mv	a0,s2
    800040d6:	60e6                	ld	ra,88(sp)
    800040d8:	6446                	ld	s0,80(sp)
    800040da:	64a6                	ld	s1,72(sp)
    800040dc:	6906                	ld	s2,64(sp)
    800040de:	79e2                	ld	s3,56(sp)
    800040e0:	7a42                	ld	s4,48(sp)
    800040e2:	7aa2                	ld	s5,40(sp)
    800040e4:	6125                	add	sp,sp,96
    800040e6:	8082                	ret
      wakeup(&pi->nread);
    800040e8:	8562                	mv	a0,s8
    800040ea:	ffffd097          	auipc	ra,0xffffd
    800040ee:	742080e7          	jalr	1858(ra) # 8000182c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040f2:	85a6                	mv	a1,s1
    800040f4:	855e                	mv	a0,s7
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	5aa080e7          	jalr	1450(ra) # 800016a0 <sleep>
  while(i < n){
    800040fe:	05495c63          	bge	s2,s4,80004156 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80004102:	2204a783          	lw	a5,544(s1)
    80004106:	dfd5                	beqz	a5,800040c2 <pipewrite+0x44>
    80004108:	0289a783          	lw	a5,40(s3)
    8000410c:	fbdd                	bnez	a5,800040c2 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000410e:	2184a783          	lw	a5,536(s1)
    80004112:	21c4a703          	lw	a4,540(s1)
    80004116:	2007879b          	addw	a5,a5,512
    8000411a:	fcf707e3          	beq	a4,a5,800040e8 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000411e:	4685                	li	a3,1
    80004120:	01590633          	add	a2,s2,s5
    80004124:	faf40593          	add	a1,s0,-81
    80004128:	0509b503          	ld	a0,80(s3)
    8000412c:	ffffd097          	auipc	ra,0xffffd
    80004130:	a78080e7          	jalr	-1416(ra) # 80000ba4 <copyin>
    80004134:	05650263          	beq	a0,s6,80004178 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004138:	21c4a783          	lw	a5,540(s1)
    8000413c:	0017871b          	addw	a4,a5,1
    80004140:	20e4ae23          	sw	a4,540(s1)
    80004144:	1ff7f793          	and	a5,a5,511
    80004148:	97a6                	add	a5,a5,s1
    8000414a:	faf44703          	lbu	a4,-81(s0)
    8000414e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004152:	2905                	addw	s2,s2,1
    80004154:	b76d                	j	800040fe <pipewrite+0x80>
    80004156:	7b02                	ld	s6,32(sp)
    80004158:	6be2                	ld	s7,24(sp)
    8000415a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000415c:	21848513          	add	a0,s1,536
    80004160:	ffffd097          	auipc	ra,0xffffd
    80004164:	6cc080e7          	jalr	1740(ra) # 8000182c <wakeup>
  release(&pi->lock);
    80004168:	8526                	mv	a0,s1
    8000416a:	00002097          	auipc	ra,0x2
    8000416e:	370080e7          	jalr	880(ra) # 800064da <release>
  return i;
    80004172:	b78d                	j	800040d4 <pipewrite+0x56>
  int i = 0;
    80004174:	4901                	li	s2,0
    80004176:	b7dd                	j	8000415c <pipewrite+0xde>
    80004178:	7b02                	ld	s6,32(sp)
    8000417a:	6be2                	ld	s7,24(sp)
    8000417c:	6c42                	ld	s8,16(sp)
    8000417e:	bff9                	j	8000415c <pipewrite+0xde>

0000000080004180 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004180:	715d                	add	sp,sp,-80
    80004182:	e486                	sd	ra,72(sp)
    80004184:	e0a2                	sd	s0,64(sp)
    80004186:	fc26                	sd	s1,56(sp)
    80004188:	f84a                	sd	s2,48(sp)
    8000418a:	f44e                	sd	s3,40(sp)
    8000418c:	f052                	sd	s4,32(sp)
    8000418e:	ec56                	sd	s5,24(sp)
    80004190:	0880                	add	s0,sp,80
    80004192:	84aa                	mv	s1,a0
    80004194:	892e                	mv	s2,a1
    80004196:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	da6080e7          	jalr	-602(ra) # 80000f3e <myproc>
    800041a0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041a2:	8526                	mv	a0,s1
    800041a4:	00002097          	auipc	ra,0x2
    800041a8:	282080e7          	jalr	642(ra) # 80006426 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ac:	2184a703          	lw	a4,536(s1)
    800041b0:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041b4:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041b8:	02f71663          	bne	a4,a5,800041e4 <piperead+0x64>
    800041bc:	2244a783          	lw	a5,548(s1)
    800041c0:	cb9d                	beqz	a5,800041f6 <piperead+0x76>
    if(pr->killed){
    800041c2:	028a2783          	lw	a5,40(s4)
    800041c6:	e38d                	bnez	a5,800041e8 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041c8:	85a6                	mv	a1,s1
    800041ca:	854e                	mv	a0,s3
    800041cc:	ffffd097          	auipc	ra,0xffffd
    800041d0:	4d4080e7          	jalr	1236(ra) # 800016a0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041d4:	2184a703          	lw	a4,536(s1)
    800041d8:	21c4a783          	lw	a5,540(s1)
    800041dc:	fef700e3          	beq	a4,a5,800041bc <piperead+0x3c>
    800041e0:	e85a                	sd	s6,16(sp)
    800041e2:	a819                	j	800041f8 <piperead+0x78>
    800041e4:	e85a                	sd	s6,16(sp)
    800041e6:	a809                	j	800041f8 <piperead+0x78>
      release(&pi->lock);
    800041e8:	8526                	mv	a0,s1
    800041ea:	00002097          	auipc	ra,0x2
    800041ee:	2f0080e7          	jalr	752(ra) # 800064da <release>
      return -1;
    800041f2:	59fd                	li	s3,-1
    800041f4:	a0a5                	j	8000425c <piperead+0xdc>
    800041f6:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041f8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041fa:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041fc:	05505463          	blez	s5,80004244 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004200:	2184a783          	lw	a5,536(s1)
    80004204:	21c4a703          	lw	a4,540(s1)
    80004208:	02f70e63          	beq	a4,a5,80004244 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000420c:	0017871b          	addw	a4,a5,1
    80004210:	20e4ac23          	sw	a4,536(s1)
    80004214:	1ff7f793          	and	a5,a5,511
    80004218:	97a6                	add	a5,a5,s1
    8000421a:	0187c783          	lbu	a5,24(a5)
    8000421e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004222:	4685                	li	a3,1
    80004224:	fbf40613          	add	a2,s0,-65
    80004228:	85ca                	mv	a1,s2
    8000422a:	050a3503          	ld	a0,80(s4)
    8000422e:	ffffd097          	auipc	ra,0xffffd
    80004232:	8ea080e7          	jalr	-1814(ra) # 80000b18 <copyout>
    80004236:	01650763          	beq	a0,s6,80004244 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000423a:	2985                	addw	s3,s3,1
    8000423c:	0905                	add	s2,s2,1
    8000423e:	fd3a91e3          	bne	s5,s3,80004200 <piperead+0x80>
    80004242:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004244:	21c48513          	add	a0,s1,540
    80004248:	ffffd097          	auipc	ra,0xffffd
    8000424c:	5e4080e7          	jalr	1508(ra) # 8000182c <wakeup>
  release(&pi->lock);
    80004250:	8526                	mv	a0,s1
    80004252:	00002097          	auipc	ra,0x2
    80004256:	288080e7          	jalr	648(ra) # 800064da <release>
    8000425a:	6b42                	ld	s6,16(sp)
  return i;
}
    8000425c:	854e                	mv	a0,s3
    8000425e:	60a6                	ld	ra,72(sp)
    80004260:	6406                	ld	s0,64(sp)
    80004262:	74e2                	ld	s1,56(sp)
    80004264:	7942                	ld	s2,48(sp)
    80004266:	79a2                	ld	s3,40(sp)
    80004268:	7a02                	ld	s4,32(sp)
    8000426a:	6ae2                	ld	s5,24(sp)
    8000426c:	6161                	add	sp,sp,80
    8000426e:	8082                	ret

0000000080004270 <exec>:
#include "elf.h"

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int exec(char *path, char **argv)
{
    80004270:	df010113          	add	sp,sp,-528
    80004274:	20113423          	sd	ra,520(sp)
    80004278:	20813023          	sd	s0,512(sp)
    8000427c:	ffa6                	sd	s1,504(sp)
    8000427e:	fbca                	sd	s2,496(sp)
    80004280:	0c00                	add	s0,sp,528
    80004282:	892a                	mv	s2,a0
    80004284:	dea43c23          	sd	a0,-520(s0)
    80004288:	e0b43023          	sd	a1,-512(s0)
    uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pagetable_t pagetable = 0, oldpagetable;
    struct proc *p = myproc();
    8000428c:	ffffd097          	auipc	ra,0xffffd
    80004290:	cb2080e7          	jalr	-846(ra) # 80000f3e <myproc>
    80004294:	84aa                	mv	s1,a0

    begin_op();
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	460080e7          	jalr	1120(ra) # 800036f6 <begin_op>

    if ((ip = namei(path)) == 0)
    8000429e:	854a                	mv	a0,s2
    800042a0:	fffff097          	auipc	ra,0xfffff
    800042a4:	256080e7          	jalr	598(ra) # 800034f6 <namei>
    800042a8:	c135                	beqz	a0,8000430c <exec+0x9c>
    800042aa:	f3d2                	sd	s4,480(sp)
    800042ac:	8a2a                	mv	s4,a0
    {
        end_op();
        return -1;
    }
    ilock(ip);
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	a76080e7          	jalr	-1418(ra) # 80002d24 <ilock>

    // Check ELF header
    if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042b6:	04000713          	li	a4,64
    800042ba:	4681                	li	a3,0
    800042bc:	e5040613          	add	a2,s0,-432
    800042c0:	4581                	li	a1,0
    800042c2:	8552                	mv	a0,s4
    800042c4:	fffff097          	auipc	ra,0xfffff
    800042c8:	d18080e7          	jalr	-744(ra) # 80002fdc <readi>
    800042cc:	04000793          	li	a5,64
    800042d0:	00f51a63          	bne	a0,a5,800042e4 <exec+0x74>
        goto bad;
    if (elf.magic != ELF_MAGIC)
    800042d4:	e5042703          	lw	a4,-432(s0)
    800042d8:	464c47b7          	lui	a5,0x464c4
    800042dc:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042e0:	02f70c63          	beq	a4,a5,80004318 <exec+0xa8>
bad:
    if (pagetable)
        proc_freepagetable(pagetable, sz);
    if (ip)
    {
        iunlockput(ip);
    800042e4:	8552                	mv	a0,s4
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	ca4080e7          	jalr	-860(ra) # 80002f8a <iunlockput>
        end_op();
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	482080e7          	jalr	1154(ra) # 80003770 <end_op>
    }
    return -1;
    800042f6:	557d                	li	a0,-1
    800042f8:	7a1e                	ld	s4,480(sp)
}
    800042fa:	20813083          	ld	ra,520(sp)
    800042fe:	20013403          	ld	s0,512(sp)
    80004302:	74fe                	ld	s1,504(sp)
    80004304:	795e                	ld	s2,496(sp)
    80004306:	21010113          	add	sp,sp,528
    8000430a:	8082                	ret
        end_op();
    8000430c:	fffff097          	auipc	ra,0xfffff
    80004310:	464080e7          	jalr	1124(ra) # 80003770 <end_op>
        return -1;
    80004314:	557d                	li	a0,-1
    80004316:	b7d5                	j	800042fa <exec+0x8a>
    80004318:	ebda                	sd	s6,464(sp)
    if ((pagetable = proc_pagetable(p)) == 0)
    8000431a:	8526                	mv	a0,s1
    8000431c:	ffffd097          	auipc	ra,0xffffd
    80004320:	ce6080e7          	jalr	-794(ra) # 80001002 <proc_pagetable>
    80004324:	8b2a                	mv	s6,a0
    80004326:	32050163          	beqz	a0,80004648 <exec+0x3d8>
    8000432a:	f7ce                	sd	s3,488(sp)
    8000432c:	efd6                	sd	s5,472(sp)
    8000432e:	e7de                	sd	s7,456(sp)
    80004330:	e3e2                	sd	s8,448(sp)
    80004332:	ff66                	sd	s9,440(sp)
    80004334:	fb6a                	sd	s10,432(sp)
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    80004336:	e7042d03          	lw	s10,-400(s0)
    8000433a:	e8845783          	lhu	a5,-376(s0)
    8000433e:	14078563          	beqz	a5,80004488 <exec+0x218>
    80004342:	f76e                	sd	s11,424(sp)
    uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004344:	4481                	li	s1,0
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    80004346:	4d81                	li	s11,0
        if ((ph.vaddr % PGSIZE) != 0)
    80004348:	6c85                	lui	s9,0x1
    8000434a:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000434e:	def43823          	sd	a5,-528(s0)
    for (i = 0; i < sz; i += PGSIZE)
    {
        pa = walkaddr(pagetable, va + i);
        if (pa == 0)
            panic("loadseg: address should exist");
        if (sz - i < PGSIZE)
    80004352:	6a85                	lui	s5,0x1
    80004354:	a0b5                	j	800043c0 <exec+0x150>
            panic("loadseg: address should exist");
    80004356:	00004517          	auipc	a0,0x4
    8000435a:	24250513          	add	a0,a0,578 # 80008598 <etext+0x598>
    8000435e:	00002097          	auipc	ra,0x2
    80004362:	b4e080e7          	jalr	-1202(ra) # 80005eac <panic>
        if (sz - i < PGSIZE)
    80004366:	2481                	sext.w	s1,s1
            n = sz - i;
        else
            n = PGSIZE;
        if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004368:	8726                	mv	a4,s1
    8000436a:	012c06bb          	addw	a3,s8,s2
    8000436e:	4581                	li	a1,0
    80004370:	8552                	mv	a0,s4
    80004372:	fffff097          	auipc	ra,0xfffff
    80004376:	c6a080e7          	jalr	-918(ra) # 80002fdc <readi>
    8000437a:	2501                	sext.w	a0,a0
    8000437c:	28a49a63          	bne	s1,a0,80004610 <exec+0x3a0>
    for (i = 0; i < sz; i += PGSIZE)
    80004380:	012a893b          	addw	s2,s5,s2
    80004384:	03397563          	bgeu	s2,s3,800043ae <exec+0x13e>
        pa = walkaddr(pagetable, va + i);
    80004388:	02091593          	sll	a1,s2,0x20
    8000438c:	9181                	srl	a1,a1,0x20
    8000438e:	95de                	add	a1,a1,s7
    80004390:	855a                	mv	a0,s6
    80004392:	ffffc097          	auipc	ra,0xffffc
    80004396:	166080e7          	jalr	358(ra) # 800004f8 <walkaddr>
    8000439a:	862a                	mv	a2,a0
        if (pa == 0)
    8000439c:	dd4d                	beqz	a0,80004356 <exec+0xe6>
        if (sz - i < PGSIZE)
    8000439e:	412984bb          	subw	s1,s3,s2
    800043a2:	0004879b          	sext.w	a5,s1
    800043a6:	fcfcf0e3          	bgeu	s9,a5,80004366 <exec+0xf6>
    800043aa:	84d6                	mv	s1,s5
    800043ac:	bf6d                	j	80004366 <exec+0xf6>
        sz = sz1;
    800043ae:	e0843483          	ld	s1,-504(s0)
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
    800043b2:	2d85                	addw	s11,s11,1
    800043b4:	038d0d1b          	addw	s10,s10,56
    800043b8:	e8845783          	lhu	a5,-376(s0)
    800043bc:	06fddf63          	bge	s11,a5,8000443a <exec+0x1ca>
        if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043c0:	2d01                	sext.w	s10,s10
    800043c2:	03800713          	li	a4,56
    800043c6:	86ea                	mv	a3,s10
    800043c8:	e1840613          	add	a2,s0,-488
    800043cc:	4581                	li	a1,0
    800043ce:	8552                	mv	a0,s4
    800043d0:	fffff097          	auipc	ra,0xfffff
    800043d4:	c0c080e7          	jalr	-1012(ra) # 80002fdc <readi>
    800043d8:	03800793          	li	a5,56
    800043dc:	20f51463          	bne	a0,a5,800045e4 <exec+0x374>
        if (ph.type != ELF_PROG_LOAD)
    800043e0:	e1842783          	lw	a5,-488(s0)
    800043e4:	4705                	li	a4,1
    800043e6:	fce796e3          	bne	a5,a4,800043b2 <exec+0x142>
        if (ph.memsz < ph.filesz)
    800043ea:	e4043603          	ld	a2,-448(s0)
    800043ee:	e3843783          	ld	a5,-456(s0)
    800043f2:	1ef66d63          	bltu	a2,a5,800045ec <exec+0x37c>
        if (ph.vaddr + ph.memsz < ph.vaddr)
    800043f6:	e2843783          	ld	a5,-472(s0)
    800043fa:	963e                	add	a2,a2,a5
    800043fc:	1ef66c63          	bltu	a2,a5,800045f4 <exec+0x384>
        if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004400:	85a6                	mv	a1,s1
    80004402:	855a                	mv	a0,s6
    80004404:	ffffc097          	auipc	ra,0xffffc
    80004408:	4b8080e7          	jalr	1208(ra) # 800008bc <uvmalloc>
    8000440c:	e0a43423          	sd	a0,-504(s0)
    80004410:	1e050663          	beqz	a0,800045fc <exec+0x38c>
        if ((ph.vaddr % PGSIZE) != 0)
    80004414:	e2843b83          	ld	s7,-472(s0)
    80004418:	df043783          	ld	a5,-528(s0)
    8000441c:	00fbf7b3          	and	a5,s7,a5
    80004420:	1e079663          	bnez	a5,8000460c <exec+0x39c>
        if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004424:	e2042c03          	lw	s8,-480(s0)
    80004428:	e3842983          	lw	s3,-456(s0)
    for (i = 0; i < sz; i += PGSIZE)
    8000442c:	00098463          	beqz	s3,80004434 <exec+0x1c4>
    80004430:	4901                	li	s2,0
    80004432:	bf99                	j	80004388 <exec+0x118>
        sz = sz1;
    80004434:	e0843483          	ld	s1,-504(s0)
    80004438:	bfad                	j	800043b2 <exec+0x142>
    8000443a:	7dba                	ld	s11,424(sp)
    iunlockput(ip);
    8000443c:	8552                	mv	a0,s4
    8000443e:	fffff097          	auipc	ra,0xfffff
    80004442:	b4c080e7          	jalr	-1204(ra) # 80002f8a <iunlockput>
    end_op();
    80004446:	fffff097          	auipc	ra,0xfffff
    8000444a:	32a080e7          	jalr	810(ra) # 80003770 <end_op>
    p = myproc();
    8000444e:	ffffd097          	auipc	ra,0xffffd
    80004452:	af0080e7          	jalr	-1296(ra) # 80000f3e <myproc>
    80004456:	8aaa                	mv	s5,a0
    uint64 oldsz = p->sz;
    80004458:	04853c83          	ld	s9,72(a0)
    sz = PGROUNDUP(sz);
    8000445c:	6985                	lui	s3,0x1
    8000445e:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004460:	99a6                	add	s3,s3,s1
    80004462:	77fd                	lui	a5,0xfffff
    80004464:	00f9f9b3          	and	s3,s3,a5
    if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    80004468:	6609                	lui	a2,0x2
    8000446a:	964e                	add	a2,a2,s3
    8000446c:	85ce                	mv	a1,s3
    8000446e:	855a                	mv	a0,s6
    80004470:	ffffc097          	auipc	ra,0xffffc
    80004474:	44c080e7          	jalr	1100(ra) # 800008bc <uvmalloc>
    80004478:	892a                	mv	s2,a0
    8000447a:	e0a43423          	sd	a0,-504(s0)
    8000447e:	e519                	bnez	a0,8000448c <exec+0x21c>
    if (pagetable)
    80004480:	e1343423          	sd	s3,-504(s0)
    80004484:	4a01                	li	s4,0
    80004486:	a271                	j	80004612 <exec+0x3a2>
    uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004488:	4481                	li	s1,0
    8000448a:	bf4d                	j	8000443c <exec+0x1cc>
    uvmclear(pagetable, sz - 2 * PGSIZE);
    8000448c:	75f9                	lui	a1,0xffffe
    8000448e:	95aa                	add	a1,a1,a0
    80004490:	855a                	mv	a0,s6
    80004492:	ffffc097          	auipc	ra,0xffffc
    80004496:	654080e7          	jalr	1620(ra) # 80000ae6 <uvmclear>
    stackbase = sp - PGSIZE;
    8000449a:	7bfd                	lui	s7,0xfffff
    8000449c:	9bca                	add	s7,s7,s2
    for (argc = 0; argv[argc]; argc++)
    8000449e:	e0043783          	ld	a5,-512(s0)
    800044a2:	6388                	ld	a0,0(a5)
    800044a4:	c52d                	beqz	a0,8000450e <exec+0x29e>
    800044a6:	e9040993          	add	s3,s0,-368
    800044aa:	f9040c13          	add	s8,s0,-112
    800044ae:	4481                	li	s1,0
        sp -= strlen(argv[argc]) + 1;
    800044b0:	ffffc097          	auipc	ra,0xffffc
    800044b4:	e3e080e7          	jalr	-450(ra) # 800002ee <strlen>
    800044b8:	0015079b          	addw	a5,a0,1
    800044bc:	40f907b3          	sub	a5,s2,a5
        sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044c0:	ff07f913          	and	s2,a5,-16
        if (sp < stackbase)
    800044c4:	15796063          	bltu	s2,s7,80004604 <exec+0x394>
        if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044c8:	e0043d03          	ld	s10,-512(s0)
    800044cc:	000d3a03          	ld	s4,0(s10)
    800044d0:	8552                	mv	a0,s4
    800044d2:	ffffc097          	auipc	ra,0xffffc
    800044d6:	e1c080e7          	jalr	-484(ra) # 800002ee <strlen>
    800044da:	0015069b          	addw	a3,a0,1
    800044de:	8652                	mv	a2,s4
    800044e0:	85ca                	mv	a1,s2
    800044e2:	855a                	mv	a0,s6
    800044e4:	ffffc097          	auipc	ra,0xffffc
    800044e8:	634080e7          	jalr	1588(ra) # 80000b18 <copyout>
    800044ec:	10054e63          	bltz	a0,80004608 <exec+0x398>
        ustack[argc] = sp;
    800044f0:	0129b023          	sd	s2,0(s3)
    for (argc = 0; argv[argc]; argc++)
    800044f4:	0485                	add	s1,s1,1
    800044f6:	008d0793          	add	a5,s10,8
    800044fa:	e0f43023          	sd	a5,-512(s0)
    800044fe:	008d3503          	ld	a0,8(s10)
    80004502:	c909                	beqz	a0,80004514 <exec+0x2a4>
        if (argc >= MAXARG)
    80004504:	09a1                	add	s3,s3,8
    80004506:	fb8995e3          	bne	s3,s8,800044b0 <exec+0x240>
    ip = 0;
    8000450a:	4a01                	li	s4,0
    8000450c:	a219                	j	80004612 <exec+0x3a2>
    sp = sz;
    8000450e:	e0843903          	ld	s2,-504(s0)
    for (argc = 0; argv[argc]; argc++)
    80004512:	4481                	li	s1,0
    ustack[argc] = 0;
    80004514:	00349793          	sll	a5,s1,0x3
    80004518:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    8000451c:	97a2                	add	a5,a5,s0
    8000451e:	f007b023          	sd	zero,-256(a5)
    sp -= (argc + 1) * sizeof(uint64);
    80004522:	00148693          	add	a3,s1,1
    80004526:	068e                	sll	a3,a3,0x3
    80004528:	40d90933          	sub	s2,s2,a3
    sp -= sp % 16;
    8000452c:	ff097913          	and	s2,s2,-16
    sz = sz1;
    80004530:	e0843983          	ld	s3,-504(s0)
    if (sp < stackbase)
    80004534:	f57966e3          	bltu	s2,s7,80004480 <exec+0x210>
    if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80004538:	e9040613          	add	a2,s0,-368
    8000453c:	85ca                	mv	a1,s2
    8000453e:	855a                	mv	a0,s6
    80004540:	ffffc097          	auipc	ra,0xffffc
    80004544:	5d8080e7          	jalr	1496(ra) # 80000b18 <copyout>
    80004548:	10054263          	bltz	a0,8000464c <exec+0x3dc>
    p->trapframe->a1 = sp;
    8000454c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004550:	0727bc23          	sd	s2,120(a5)
    for (last = s = path; *s; s++)
    80004554:	df843783          	ld	a5,-520(s0)
    80004558:	0007c703          	lbu	a4,0(a5)
    8000455c:	cf11                	beqz	a4,80004578 <exec+0x308>
    8000455e:	0785                	add	a5,a5,1
        if (*s == '/')
    80004560:	02f00693          	li	a3,47
    80004564:	a039                	j	80004572 <exec+0x302>
            last = s + 1;
    80004566:	def43c23          	sd	a5,-520(s0)
    for (last = s = path; *s; s++)
    8000456a:	0785                	add	a5,a5,1
    8000456c:	fff7c703          	lbu	a4,-1(a5)
    80004570:	c701                	beqz	a4,80004578 <exec+0x308>
        if (*s == '/')
    80004572:	fed71ce3          	bne	a4,a3,8000456a <exec+0x2fa>
    80004576:	bfc5                	j	80004566 <exec+0x2f6>
    safestrcpy(p->name, last, sizeof(p->name));
    80004578:	4641                	li	a2,16
    8000457a:	df843583          	ld	a1,-520(s0)
    8000457e:	158a8513          	add	a0,s5,344
    80004582:	ffffc097          	auipc	ra,0xffffc
    80004586:	d3a080e7          	jalr	-710(ra) # 800002bc <safestrcpy>
    oldpagetable = p->pagetable;
    8000458a:	050ab503          	ld	a0,80(s5)
    p->pagetable = pagetable;
    8000458e:	056ab823          	sd	s6,80(s5)
    p->sz = sz;
    80004592:	e0843783          	ld	a5,-504(s0)
    80004596:	04fab423          	sd	a5,72(s5)
    p->trapframe->epc = elf.entry; // initial program counter = main
    8000459a:	058ab783          	ld	a5,88(s5)
    8000459e:	e6843703          	ld	a4,-408(s0)
    800045a2:	ef98                	sd	a4,24(a5)
    p->trapframe->sp = sp;         // initial stack pointer
    800045a4:	058ab783          	ld	a5,88(s5)
    800045a8:	0327b823          	sd	s2,48(a5)
    proc_freepagetable(oldpagetable, oldsz);
    800045ac:	85e6                	mv	a1,s9
    800045ae:	ffffd097          	auipc	ra,0xffffd
    800045b2:	b4a080e7          	jalr	-1206(ra) # 800010f8 <proc_freepagetable>
    if (p->pid == 1)
    800045b6:	030aa703          	lw	a4,48(s5)
    800045ba:	4785                	li	a5,1
    800045bc:	00f70d63          	beq	a4,a5,800045d6 <exec+0x366>
    return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045c0:	0004851b          	sext.w	a0,s1
    800045c4:	79be                	ld	s3,488(sp)
    800045c6:	7a1e                	ld	s4,480(sp)
    800045c8:	6afe                	ld	s5,472(sp)
    800045ca:	6b5e                	ld	s6,464(sp)
    800045cc:	6bbe                	ld	s7,456(sp)
    800045ce:	6c1e                	ld	s8,448(sp)
    800045d0:	7cfa                	ld	s9,440(sp)
    800045d2:	7d5a                	ld	s10,432(sp)
    800045d4:	b31d                	j	800042fa <exec+0x8a>
        vmprint(pagetable, 0);
    800045d6:	4581                	li	a1,0
    800045d8:	855a                	mv	a0,s6
    800045da:	ffffc097          	auipc	ra,0xffffc
    800045de:	714080e7          	jalr	1812(ra) # 80000cee <vmprint>
    800045e2:	bff9                	j	800045c0 <exec+0x350>
    800045e4:	e0943423          	sd	s1,-504(s0)
    800045e8:	7dba                	ld	s11,424(sp)
    800045ea:	a025                	j	80004612 <exec+0x3a2>
    800045ec:	e0943423          	sd	s1,-504(s0)
    800045f0:	7dba                	ld	s11,424(sp)
    800045f2:	a005                	j	80004612 <exec+0x3a2>
    800045f4:	e0943423          	sd	s1,-504(s0)
    800045f8:	7dba                	ld	s11,424(sp)
    800045fa:	a821                	j	80004612 <exec+0x3a2>
    800045fc:	e0943423          	sd	s1,-504(s0)
    80004600:	7dba                	ld	s11,424(sp)
    80004602:	a801                	j	80004612 <exec+0x3a2>
    ip = 0;
    80004604:	4a01                	li	s4,0
    80004606:	a031                	j	80004612 <exec+0x3a2>
    80004608:	4a01                	li	s4,0
    if (pagetable)
    8000460a:	a021                	j	80004612 <exec+0x3a2>
    8000460c:	7dba                	ld	s11,424(sp)
    8000460e:	a011                	j	80004612 <exec+0x3a2>
    80004610:	7dba                	ld	s11,424(sp)
        proc_freepagetable(pagetable, sz);
    80004612:	e0843583          	ld	a1,-504(s0)
    80004616:	855a                	mv	a0,s6
    80004618:	ffffd097          	auipc	ra,0xffffd
    8000461c:	ae0080e7          	jalr	-1312(ra) # 800010f8 <proc_freepagetable>
    return -1;
    80004620:	557d                	li	a0,-1
    if (ip)
    80004622:	000a1b63          	bnez	s4,80004638 <exec+0x3c8>
    80004626:	79be                	ld	s3,488(sp)
    80004628:	7a1e                	ld	s4,480(sp)
    8000462a:	6afe                	ld	s5,472(sp)
    8000462c:	6b5e                	ld	s6,464(sp)
    8000462e:	6bbe                	ld	s7,456(sp)
    80004630:	6c1e                	ld	s8,448(sp)
    80004632:	7cfa                	ld	s9,440(sp)
    80004634:	7d5a                	ld	s10,432(sp)
    80004636:	b1d1                	j	800042fa <exec+0x8a>
    80004638:	79be                	ld	s3,488(sp)
    8000463a:	6afe                	ld	s5,472(sp)
    8000463c:	6b5e                	ld	s6,464(sp)
    8000463e:	6bbe                	ld	s7,456(sp)
    80004640:	6c1e                	ld	s8,448(sp)
    80004642:	7cfa                	ld	s9,440(sp)
    80004644:	7d5a                	ld	s10,432(sp)
    80004646:	b979                	j	800042e4 <exec+0x74>
    80004648:	6b5e                	ld	s6,464(sp)
    8000464a:	b969                	j	800042e4 <exec+0x74>
    sz = sz1;
    8000464c:	e0843983          	ld	s3,-504(s0)
    80004650:	bd05                	j	80004480 <exec+0x210>

0000000080004652 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004652:	7179                	add	sp,sp,-48
    80004654:	f406                	sd	ra,40(sp)
    80004656:	f022                	sd	s0,32(sp)
    80004658:	ec26                	sd	s1,24(sp)
    8000465a:	e84a                	sd	s2,16(sp)
    8000465c:	1800                	add	s0,sp,48
    8000465e:	892e                	mv	s2,a1
    80004660:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004662:	fdc40593          	add	a1,s0,-36
    80004666:	ffffe097          	auipc	ra,0xffffe
    8000466a:	a34080e7          	jalr	-1484(ra) # 8000209a <argint>
    8000466e:	04054063          	bltz	a0,800046ae <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004672:	fdc42703          	lw	a4,-36(s0)
    80004676:	47bd                	li	a5,15
    80004678:	02e7ed63          	bltu	a5,a4,800046b2 <argfd+0x60>
    8000467c:	ffffd097          	auipc	ra,0xffffd
    80004680:	8c2080e7          	jalr	-1854(ra) # 80000f3e <myproc>
    80004684:	fdc42703          	lw	a4,-36(s0)
    80004688:	01a70793          	add	a5,a4,26
    8000468c:	078e                	sll	a5,a5,0x3
    8000468e:	953e                	add	a0,a0,a5
    80004690:	611c                	ld	a5,0(a0)
    80004692:	c395                	beqz	a5,800046b6 <argfd+0x64>
    return -1;
  if(pfd)
    80004694:	00090463          	beqz	s2,8000469c <argfd+0x4a>
    *pfd = fd;
    80004698:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000469c:	4501                	li	a0,0
  if(pf)
    8000469e:	c091                	beqz	s1,800046a2 <argfd+0x50>
    *pf = f;
    800046a0:	e09c                	sd	a5,0(s1)
}
    800046a2:	70a2                	ld	ra,40(sp)
    800046a4:	7402                	ld	s0,32(sp)
    800046a6:	64e2                	ld	s1,24(sp)
    800046a8:	6942                	ld	s2,16(sp)
    800046aa:	6145                	add	sp,sp,48
    800046ac:	8082                	ret
    return -1;
    800046ae:	557d                	li	a0,-1
    800046b0:	bfcd                	j	800046a2 <argfd+0x50>
    return -1;
    800046b2:	557d                	li	a0,-1
    800046b4:	b7fd                	j	800046a2 <argfd+0x50>
    800046b6:	557d                	li	a0,-1
    800046b8:	b7ed                	j	800046a2 <argfd+0x50>

00000000800046ba <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046ba:	1101                	add	sp,sp,-32
    800046bc:	ec06                	sd	ra,24(sp)
    800046be:	e822                	sd	s0,16(sp)
    800046c0:	e426                	sd	s1,8(sp)
    800046c2:	1000                	add	s0,sp,32
    800046c4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046c6:	ffffd097          	auipc	ra,0xffffd
    800046ca:	878080e7          	jalr	-1928(ra) # 80000f3e <myproc>
    800046ce:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046d0:	0d050793          	add	a5,a0,208
    800046d4:	4501                	li	a0,0
    800046d6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046d8:	6398                	ld	a4,0(a5)
    800046da:	cb19                	beqz	a4,800046f0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046dc:	2505                	addw	a0,a0,1
    800046de:	07a1                	add	a5,a5,8
    800046e0:	fed51ce3          	bne	a0,a3,800046d8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046e4:	557d                	li	a0,-1
}
    800046e6:	60e2                	ld	ra,24(sp)
    800046e8:	6442                	ld	s0,16(sp)
    800046ea:	64a2                	ld	s1,8(sp)
    800046ec:	6105                	add	sp,sp,32
    800046ee:	8082                	ret
      p->ofile[fd] = f;
    800046f0:	01a50793          	add	a5,a0,26
    800046f4:	078e                	sll	a5,a5,0x3
    800046f6:	963e                	add	a2,a2,a5
    800046f8:	e204                	sd	s1,0(a2)
      return fd;
    800046fa:	b7f5                	j	800046e6 <fdalloc+0x2c>

00000000800046fc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046fc:	715d                	add	sp,sp,-80
    800046fe:	e486                	sd	ra,72(sp)
    80004700:	e0a2                	sd	s0,64(sp)
    80004702:	fc26                	sd	s1,56(sp)
    80004704:	f84a                	sd	s2,48(sp)
    80004706:	f44e                	sd	s3,40(sp)
    80004708:	f052                	sd	s4,32(sp)
    8000470a:	ec56                	sd	s5,24(sp)
    8000470c:	0880                	add	s0,sp,80
    8000470e:	8aae                	mv	s5,a1
    80004710:	8a32                	mv	s4,a2
    80004712:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004714:	fb040593          	add	a1,s0,-80
    80004718:	fffff097          	auipc	ra,0xfffff
    8000471c:	dfc080e7          	jalr	-516(ra) # 80003514 <nameiparent>
    80004720:	892a                	mv	s2,a0
    80004722:	12050c63          	beqz	a0,8000485a <create+0x15e>
    return 0;

  ilock(dp);
    80004726:	ffffe097          	auipc	ra,0xffffe
    8000472a:	5fe080e7          	jalr	1534(ra) # 80002d24 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000472e:	4601                	li	a2,0
    80004730:	fb040593          	add	a1,s0,-80
    80004734:	854a                	mv	a0,s2
    80004736:	fffff097          	auipc	ra,0xfffff
    8000473a:	aee080e7          	jalr	-1298(ra) # 80003224 <dirlookup>
    8000473e:	84aa                	mv	s1,a0
    80004740:	c539                	beqz	a0,8000478e <create+0x92>
    iunlockput(dp);
    80004742:	854a                	mv	a0,s2
    80004744:	fffff097          	auipc	ra,0xfffff
    80004748:	846080e7          	jalr	-1978(ra) # 80002f8a <iunlockput>
    ilock(ip);
    8000474c:	8526                	mv	a0,s1
    8000474e:	ffffe097          	auipc	ra,0xffffe
    80004752:	5d6080e7          	jalr	1494(ra) # 80002d24 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004756:	4789                	li	a5,2
    80004758:	02fa9463          	bne	s5,a5,80004780 <create+0x84>
    8000475c:	0444d783          	lhu	a5,68(s1)
    80004760:	37f9                	addw	a5,a5,-2
    80004762:	17c2                	sll	a5,a5,0x30
    80004764:	93c1                	srl	a5,a5,0x30
    80004766:	4705                	li	a4,1
    80004768:	00f76c63          	bltu	a4,a5,80004780 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000476c:	8526                	mv	a0,s1
    8000476e:	60a6                	ld	ra,72(sp)
    80004770:	6406                	ld	s0,64(sp)
    80004772:	74e2                	ld	s1,56(sp)
    80004774:	7942                	ld	s2,48(sp)
    80004776:	79a2                	ld	s3,40(sp)
    80004778:	7a02                	ld	s4,32(sp)
    8000477a:	6ae2                	ld	s5,24(sp)
    8000477c:	6161                	add	sp,sp,80
    8000477e:	8082                	ret
    iunlockput(ip);
    80004780:	8526                	mv	a0,s1
    80004782:	fffff097          	auipc	ra,0xfffff
    80004786:	808080e7          	jalr	-2040(ra) # 80002f8a <iunlockput>
    return 0;
    8000478a:	4481                	li	s1,0
    8000478c:	b7c5                	j	8000476c <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000478e:	85d6                	mv	a1,s5
    80004790:	00092503          	lw	a0,0(s2)
    80004794:	ffffe097          	auipc	ra,0xffffe
    80004798:	3fc080e7          	jalr	1020(ra) # 80002b90 <ialloc>
    8000479c:	84aa                	mv	s1,a0
    8000479e:	c139                	beqz	a0,800047e4 <create+0xe8>
  ilock(ip);
    800047a0:	ffffe097          	auipc	ra,0xffffe
    800047a4:	584080e7          	jalr	1412(ra) # 80002d24 <ilock>
  ip->major = major;
    800047a8:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800047ac:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800047b0:	4985                	li	s3,1
    800047b2:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800047b6:	8526                	mv	a0,s1
    800047b8:	ffffe097          	auipc	ra,0xffffe
    800047bc:	4a0080e7          	jalr	1184(ra) # 80002c58 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047c0:	033a8a63          	beq	s5,s3,800047f4 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800047c4:	40d0                	lw	a2,4(s1)
    800047c6:	fb040593          	add	a1,s0,-80
    800047ca:	854a                	mv	a0,s2
    800047cc:	fffff097          	auipc	ra,0xfffff
    800047d0:	c68080e7          	jalr	-920(ra) # 80003434 <dirlink>
    800047d4:	06054b63          	bltz	a0,8000484a <create+0x14e>
  iunlockput(dp);
    800047d8:	854a                	mv	a0,s2
    800047da:	ffffe097          	auipc	ra,0xffffe
    800047de:	7b0080e7          	jalr	1968(ra) # 80002f8a <iunlockput>
  return ip;
    800047e2:	b769                	j	8000476c <create+0x70>
    panic("create: ialloc");
    800047e4:	00004517          	auipc	a0,0x4
    800047e8:	dd450513          	add	a0,a0,-556 # 800085b8 <etext+0x5b8>
    800047ec:	00001097          	auipc	ra,0x1
    800047f0:	6c0080e7          	jalr	1728(ra) # 80005eac <panic>
    dp->nlink++;  // for ".."
    800047f4:	04a95783          	lhu	a5,74(s2)
    800047f8:	2785                	addw	a5,a5,1
    800047fa:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800047fe:	854a                	mv	a0,s2
    80004800:	ffffe097          	auipc	ra,0xffffe
    80004804:	458080e7          	jalr	1112(ra) # 80002c58 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004808:	40d0                	lw	a2,4(s1)
    8000480a:	00004597          	auipc	a1,0x4
    8000480e:	dbe58593          	add	a1,a1,-578 # 800085c8 <etext+0x5c8>
    80004812:	8526                	mv	a0,s1
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	c20080e7          	jalr	-992(ra) # 80003434 <dirlink>
    8000481c:	00054f63          	bltz	a0,8000483a <create+0x13e>
    80004820:	00492603          	lw	a2,4(s2)
    80004824:	00004597          	auipc	a1,0x4
    80004828:	dac58593          	add	a1,a1,-596 # 800085d0 <etext+0x5d0>
    8000482c:	8526                	mv	a0,s1
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	c06080e7          	jalr	-1018(ra) # 80003434 <dirlink>
    80004836:	f80557e3          	bgez	a0,800047c4 <create+0xc8>
      panic("create dots");
    8000483a:	00004517          	auipc	a0,0x4
    8000483e:	d9e50513          	add	a0,a0,-610 # 800085d8 <etext+0x5d8>
    80004842:	00001097          	auipc	ra,0x1
    80004846:	66a080e7          	jalr	1642(ra) # 80005eac <panic>
    panic("create: dirlink");
    8000484a:	00004517          	auipc	a0,0x4
    8000484e:	d9e50513          	add	a0,a0,-610 # 800085e8 <etext+0x5e8>
    80004852:	00001097          	auipc	ra,0x1
    80004856:	65a080e7          	jalr	1626(ra) # 80005eac <panic>
    return 0;
    8000485a:	84aa                	mv	s1,a0
    8000485c:	bf01                	j	8000476c <create+0x70>

000000008000485e <sys_dup>:
{
    8000485e:	7179                	add	sp,sp,-48
    80004860:	f406                	sd	ra,40(sp)
    80004862:	f022                	sd	s0,32(sp)
    80004864:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004866:	fd840613          	add	a2,s0,-40
    8000486a:	4581                	li	a1,0
    8000486c:	4501                	li	a0,0
    8000486e:	00000097          	auipc	ra,0x0
    80004872:	de4080e7          	jalr	-540(ra) # 80004652 <argfd>
    return -1;
    80004876:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004878:	02054763          	bltz	a0,800048a6 <sys_dup+0x48>
    8000487c:	ec26                	sd	s1,24(sp)
    8000487e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004880:	fd843903          	ld	s2,-40(s0)
    80004884:	854a                	mv	a0,s2
    80004886:	00000097          	auipc	ra,0x0
    8000488a:	e34080e7          	jalr	-460(ra) # 800046ba <fdalloc>
    8000488e:	84aa                	mv	s1,a0
    return -1;
    80004890:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004892:	00054f63          	bltz	a0,800048b0 <sys_dup+0x52>
  filedup(f);
    80004896:	854a                	mv	a0,s2
    80004898:	fffff097          	auipc	ra,0xfffff
    8000489c:	2d6080e7          	jalr	726(ra) # 80003b6e <filedup>
  return fd;
    800048a0:	87a6                	mv	a5,s1
    800048a2:	64e2                	ld	s1,24(sp)
    800048a4:	6942                	ld	s2,16(sp)
}
    800048a6:	853e                	mv	a0,a5
    800048a8:	70a2                	ld	ra,40(sp)
    800048aa:	7402                	ld	s0,32(sp)
    800048ac:	6145                	add	sp,sp,48
    800048ae:	8082                	ret
    800048b0:	64e2                	ld	s1,24(sp)
    800048b2:	6942                	ld	s2,16(sp)
    800048b4:	bfcd                	j	800048a6 <sys_dup+0x48>

00000000800048b6 <sys_read>:
{
    800048b6:	7179                	add	sp,sp,-48
    800048b8:	f406                	sd	ra,40(sp)
    800048ba:	f022                	sd	s0,32(sp)
    800048bc:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048be:	fe840613          	add	a2,s0,-24
    800048c2:	4581                	li	a1,0
    800048c4:	4501                	li	a0,0
    800048c6:	00000097          	auipc	ra,0x0
    800048ca:	d8c080e7          	jalr	-628(ra) # 80004652 <argfd>
    return -1;
    800048ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d0:	04054163          	bltz	a0,80004912 <sys_read+0x5c>
    800048d4:	fe440593          	add	a1,s0,-28
    800048d8:	4509                	li	a0,2
    800048da:	ffffd097          	auipc	ra,0xffffd
    800048de:	7c0080e7          	jalr	1984(ra) # 8000209a <argint>
    return -1;
    800048e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048e4:	02054763          	bltz	a0,80004912 <sys_read+0x5c>
    800048e8:	fd840593          	add	a1,s0,-40
    800048ec:	4505                	li	a0,1
    800048ee:	ffffd097          	auipc	ra,0xffffd
    800048f2:	7ce080e7          	jalr	1998(ra) # 800020bc <argaddr>
    return -1;
    800048f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048f8:	00054d63          	bltz	a0,80004912 <sys_read+0x5c>
  return fileread(f, p, n);
    800048fc:	fe442603          	lw	a2,-28(s0)
    80004900:	fd843583          	ld	a1,-40(s0)
    80004904:	fe843503          	ld	a0,-24(s0)
    80004908:	fffff097          	auipc	ra,0xfffff
    8000490c:	40c080e7          	jalr	1036(ra) # 80003d14 <fileread>
    80004910:	87aa                	mv	a5,a0
}
    80004912:	853e                	mv	a0,a5
    80004914:	70a2                	ld	ra,40(sp)
    80004916:	7402                	ld	s0,32(sp)
    80004918:	6145                	add	sp,sp,48
    8000491a:	8082                	ret

000000008000491c <sys_write>:
{
    8000491c:	7179                	add	sp,sp,-48
    8000491e:	f406                	sd	ra,40(sp)
    80004920:	f022                	sd	s0,32(sp)
    80004922:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004924:	fe840613          	add	a2,s0,-24
    80004928:	4581                	li	a1,0
    8000492a:	4501                	li	a0,0
    8000492c:	00000097          	auipc	ra,0x0
    80004930:	d26080e7          	jalr	-730(ra) # 80004652 <argfd>
    return -1;
    80004934:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004936:	04054163          	bltz	a0,80004978 <sys_write+0x5c>
    8000493a:	fe440593          	add	a1,s0,-28
    8000493e:	4509                	li	a0,2
    80004940:	ffffd097          	auipc	ra,0xffffd
    80004944:	75a080e7          	jalr	1882(ra) # 8000209a <argint>
    return -1;
    80004948:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000494a:	02054763          	bltz	a0,80004978 <sys_write+0x5c>
    8000494e:	fd840593          	add	a1,s0,-40
    80004952:	4505                	li	a0,1
    80004954:	ffffd097          	auipc	ra,0xffffd
    80004958:	768080e7          	jalr	1896(ra) # 800020bc <argaddr>
    return -1;
    8000495c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000495e:	00054d63          	bltz	a0,80004978 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004962:	fe442603          	lw	a2,-28(s0)
    80004966:	fd843583          	ld	a1,-40(s0)
    8000496a:	fe843503          	ld	a0,-24(s0)
    8000496e:	fffff097          	auipc	ra,0xfffff
    80004972:	478080e7          	jalr	1144(ra) # 80003de6 <filewrite>
    80004976:	87aa                	mv	a5,a0
}
    80004978:	853e                	mv	a0,a5
    8000497a:	70a2                	ld	ra,40(sp)
    8000497c:	7402                	ld	s0,32(sp)
    8000497e:	6145                	add	sp,sp,48
    80004980:	8082                	ret

0000000080004982 <sys_close>:
{
    80004982:	1101                	add	sp,sp,-32
    80004984:	ec06                	sd	ra,24(sp)
    80004986:	e822                	sd	s0,16(sp)
    80004988:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000498a:	fe040613          	add	a2,s0,-32
    8000498e:	fec40593          	add	a1,s0,-20
    80004992:	4501                	li	a0,0
    80004994:	00000097          	auipc	ra,0x0
    80004998:	cbe080e7          	jalr	-834(ra) # 80004652 <argfd>
    return -1;
    8000499c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000499e:	02054463          	bltz	a0,800049c6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049a2:	ffffc097          	auipc	ra,0xffffc
    800049a6:	59c080e7          	jalr	1436(ra) # 80000f3e <myproc>
    800049aa:	fec42783          	lw	a5,-20(s0)
    800049ae:	07e9                	add	a5,a5,26
    800049b0:	078e                	sll	a5,a5,0x3
    800049b2:	953e                	add	a0,a0,a5
    800049b4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800049b8:	fe043503          	ld	a0,-32(s0)
    800049bc:	fffff097          	auipc	ra,0xfffff
    800049c0:	204080e7          	jalr	516(ra) # 80003bc0 <fileclose>
  return 0;
    800049c4:	4781                	li	a5,0
}
    800049c6:	853e                	mv	a0,a5
    800049c8:	60e2                	ld	ra,24(sp)
    800049ca:	6442                	ld	s0,16(sp)
    800049cc:	6105                	add	sp,sp,32
    800049ce:	8082                	ret

00000000800049d0 <sys_fstat>:
{
    800049d0:	1101                	add	sp,sp,-32
    800049d2:	ec06                	sd	ra,24(sp)
    800049d4:	e822                	sd	s0,16(sp)
    800049d6:	1000                	add	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049d8:	fe840613          	add	a2,s0,-24
    800049dc:	4581                	li	a1,0
    800049de:	4501                	li	a0,0
    800049e0:	00000097          	auipc	ra,0x0
    800049e4:	c72080e7          	jalr	-910(ra) # 80004652 <argfd>
    return -1;
    800049e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049ea:	02054563          	bltz	a0,80004a14 <sys_fstat+0x44>
    800049ee:	fe040593          	add	a1,s0,-32
    800049f2:	4505                	li	a0,1
    800049f4:	ffffd097          	auipc	ra,0xffffd
    800049f8:	6c8080e7          	jalr	1736(ra) # 800020bc <argaddr>
    return -1;
    800049fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049fe:	00054b63          	bltz	a0,80004a14 <sys_fstat+0x44>
  return filestat(f, st);
    80004a02:	fe043583          	ld	a1,-32(s0)
    80004a06:	fe843503          	ld	a0,-24(s0)
    80004a0a:	fffff097          	auipc	ra,0xfffff
    80004a0e:	298080e7          	jalr	664(ra) # 80003ca2 <filestat>
    80004a12:	87aa                	mv	a5,a0
}
    80004a14:	853e                	mv	a0,a5
    80004a16:	60e2                	ld	ra,24(sp)
    80004a18:	6442                	ld	s0,16(sp)
    80004a1a:	6105                	add	sp,sp,32
    80004a1c:	8082                	ret

0000000080004a1e <sys_link>:
{
    80004a1e:	7169                	add	sp,sp,-304
    80004a20:	f606                	sd	ra,296(sp)
    80004a22:	f222                	sd	s0,288(sp)
    80004a24:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a26:	08000613          	li	a2,128
    80004a2a:	ed040593          	add	a1,s0,-304
    80004a2e:	4501                	li	a0,0
    80004a30:	ffffd097          	auipc	ra,0xffffd
    80004a34:	6ae080e7          	jalr	1710(ra) # 800020de <argstr>
    return -1;
    80004a38:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a3a:	12054663          	bltz	a0,80004b66 <sys_link+0x148>
    80004a3e:	08000613          	li	a2,128
    80004a42:	f5040593          	add	a1,s0,-176
    80004a46:	4505                	li	a0,1
    80004a48:	ffffd097          	auipc	ra,0xffffd
    80004a4c:	696080e7          	jalr	1686(ra) # 800020de <argstr>
    return -1;
    80004a50:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a52:	10054a63          	bltz	a0,80004b66 <sys_link+0x148>
    80004a56:	ee26                	sd	s1,280(sp)
  begin_op();
    80004a58:	fffff097          	auipc	ra,0xfffff
    80004a5c:	c9e080e7          	jalr	-866(ra) # 800036f6 <begin_op>
  if((ip = namei(old)) == 0){
    80004a60:	ed040513          	add	a0,s0,-304
    80004a64:	fffff097          	auipc	ra,0xfffff
    80004a68:	a92080e7          	jalr	-1390(ra) # 800034f6 <namei>
    80004a6c:	84aa                	mv	s1,a0
    80004a6e:	c949                	beqz	a0,80004b00 <sys_link+0xe2>
  ilock(ip);
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	2b4080e7          	jalr	692(ra) # 80002d24 <ilock>
  if(ip->type == T_DIR){
    80004a78:	04449703          	lh	a4,68(s1)
    80004a7c:	4785                	li	a5,1
    80004a7e:	08f70863          	beq	a4,a5,80004b0e <sys_link+0xf0>
    80004a82:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004a84:	04a4d783          	lhu	a5,74(s1)
    80004a88:	2785                	addw	a5,a5,1
    80004a8a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a8e:	8526                	mv	a0,s1
    80004a90:	ffffe097          	auipc	ra,0xffffe
    80004a94:	1c8080e7          	jalr	456(ra) # 80002c58 <iupdate>
  iunlock(ip);
    80004a98:	8526                	mv	a0,s1
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	350080e7          	jalr	848(ra) # 80002dea <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004aa2:	fd040593          	add	a1,s0,-48
    80004aa6:	f5040513          	add	a0,s0,-176
    80004aaa:	fffff097          	auipc	ra,0xfffff
    80004aae:	a6a080e7          	jalr	-1430(ra) # 80003514 <nameiparent>
    80004ab2:	892a                	mv	s2,a0
    80004ab4:	cd35                	beqz	a0,80004b30 <sys_link+0x112>
  ilock(dp);
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	26e080e7          	jalr	622(ra) # 80002d24 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004abe:	00092703          	lw	a4,0(s2)
    80004ac2:	409c                	lw	a5,0(s1)
    80004ac4:	06f71163          	bne	a4,a5,80004b26 <sys_link+0x108>
    80004ac8:	40d0                	lw	a2,4(s1)
    80004aca:	fd040593          	add	a1,s0,-48
    80004ace:	854a                	mv	a0,s2
    80004ad0:	fffff097          	auipc	ra,0xfffff
    80004ad4:	964080e7          	jalr	-1692(ra) # 80003434 <dirlink>
    80004ad8:	04054763          	bltz	a0,80004b26 <sys_link+0x108>
  iunlockput(dp);
    80004adc:	854a                	mv	a0,s2
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	4ac080e7          	jalr	1196(ra) # 80002f8a <iunlockput>
  iput(ip);
    80004ae6:	8526                	mv	a0,s1
    80004ae8:	ffffe097          	auipc	ra,0xffffe
    80004aec:	3fa080e7          	jalr	1018(ra) # 80002ee2 <iput>
  end_op();
    80004af0:	fffff097          	auipc	ra,0xfffff
    80004af4:	c80080e7          	jalr	-896(ra) # 80003770 <end_op>
  return 0;
    80004af8:	4781                	li	a5,0
    80004afa:	64f2                	ld	s1,280(sp)
    80004afc:	6952                	ld	s2,272(sp)
    80004afe:	a0a5                	j	80004b66 <sys_link+0x148>
    end_op();
    80004b00:	fffff097          	auipc	ra,0xfffff
    80004b04:	c70080e7          	jalr	-912(ra) # 80003770 <end_op>
    return -1;
    80004b08:	57fd                	li	a5,-1
    80004b0a:	64f2                	ld	s1,280(sp)
    80004b0c:	a8a9                	j	80004b66 <sys_link+0x148>
    iunlockput(ip);
    80004b0e:	8526                	mv	a0,s1
    80004b10:	ffffe097          	auipc	ra,0xffffe
    80004b14:	47a080e7          	jalr	1146(ra) # 80002f8a <iunlockput>
    end_op();
    80004b18:	fffff097          	auipc	ra,0xfffff
    80004b1c:	c58080e7          	jalr	-936(ra) # 80003770 <end_op>
    return -1;
    80004b20:	57fd                	li	a5,-1
    80004b22:	64f2                	ld	s1,280(sp)
    80004b24:	a089                	j	80004b66 <sys_link+0x148>
    iunlockput(dp);
    80004b26:	854a                	mv	a0,s2
    80004b28:	ffffe097          	auipc	ra,0xffffe
    80004b2c:	462080e7          	jalr	1122(ra) # 80002f8a <iunlockput>
  ilock(ip);
    80004b30:	8526                	mv	a0,s1
    80004b32:	ffffe097          	auipc	ra,0xffffe
    80004b36:	1f2080e7          	jalr	498(ra) # 80002d24 <ilock>
  ip->nlink--;
    80004b3a:	04a4d783          	lhu	a5,74(s1)
    80004b3e:	37fd                	addw	a5,a5,-1
    80004b40:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b44:	8526                	mv	a0,s1
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	112080e7          	jalr	274(ra) # 80002c58 <iupdate>
  iunlockput(ip);
    80004b4e:	8526                	mv	a0,s1
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	43a080e7          	jalr	1082(ra) # 80002f8a <iunlockput>
  end_op();
    80004b58:	fffff097          	auipc	ra,0xfffff
    80004b5c:	c18080e7          	jalr	-1000(ra) # 80003770 <end_op>
  return -1;
    80004b60:	57fd                	li	a5,-1
    80004b62:	64f2                	ld	s1,280(sp)
    80004b64:	6952                	ld	s2,272(sp)
}
    80004b66:	853e                	mv	a0,a5
    80004b68:	70b2                	ld	ra,296(sp)
    80004b6a:	7412                	ld	s0,288(sp)
    80004b6c:	6155                	add	sp,sp,304
    80004b6e:	8082                	ret

0000000080004b70 <sys_unlink>:
{
    80004b70:	7151                	add	sp,sp,-240
    80004b72:	f586                	sd	ra,232(sp)
    80004b74:	f1a2                	sd	s0,224(sp)
    80004b76:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b78:	08000613          	li	a2,128
    80004b7c:	f3040593          	add	a1,s0,-208
    80004b80:	4501                	li	a0,0
    80004b82:	ffffd097          	auipc	ra,0xffffd
    80004b86:	55c080e7          	jalr	1372(ra) # 800020de <argstr>
    80004b8a:	1a054a63          	bltz	a0,80004d3e <sys_unlink+0x1ce>
    80004b8e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004b90:	fffff097          	auipc	ra,0xfffff
    80004b94:	b66080e7          	jalr	-1178(ra) # 800036f6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b98:	fb040593          	add	a1,s0,-80
    80004b9c:	f3040513          	add	a0,s0,-208
    80004ba0:	fffff097          	auipc	ra,0xfffff
    80004ba4:	974080e7          	jalr	-1676(ra) # 80003514 <nameiparent>
    80004ba8:	84aa                	mv	s1,a0
    80004baa:	cd71                	beqz	a0,80004c86 <sys_unlink+0x116>
  ilock(dp);
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	178080e7          	jalr	376(ra) # 80002d24 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bb4:	00004597          	auipc	a1,0x4
    80004bb8:	a1458593          	add	a1,a1,-1516 # 800085c8 <etext+0x5c8>
    80004bbc:	fb040513          	add	a0,s0,-80
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	64a080e7          	jalr	1610(ra) # 8000320a <namecmp>
    80004bc8:	14050c63          	beqz	a0,80004d20 <sys_unlink+0x1b0>
    80004bcc:	00004597          	auipc	a1,0x4
    80004bd0:	a0458593          	add	a1,a1,-1532 # 800085d0 <etext+0x5d0>
    80004bd4:	fb040513          	add	a0,s0,-80
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	632080e7          	jalr	1586(ra) # 8000320a <namecmp>
    80004be0:	14050063          	beqz	a0,80004d20 <sys_unlink+0x1b0>
    80004be4:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004be6:	f2c40613          	add	a2,s0,-212
    80004bea:	fb040593          	add	a1,s0,-80
    80004bee:	8526                	mv	a0,s1
    80004bf0:	ffffe097          	auipc	ra,0xffffe
    80004bf4:	634080e7          	jalr	1588(ra) # 80003224 <dirlookup>
    80004bf8:	892a                	mv	s2,a0
    80004bfa:	12050263          	beqz	a0,80004d1e <sys_unlink+0x1ae>
  ilock(ip);
    80004bfe:	ffffe097          	auipc	ra,0xffffe
    80004c02:	126080e7          	jalr	294(ra) # 80002d24 <ilock>
  if(ip->nlink < 1)
    80004c06:	04a91783          	lh	a5,74(s2)
    80004c0a:	08f05563          	blez	a5,80004c94 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c0e:	04491703          	lh	a4,68(s2)
    80004c12:	4785                	li	a5,1
    80004c14:	08f70963          	beq	a4,a5,80004ca6 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004c18:	4641                	li	a2,16
    80004c1a:	4581                	li	a1,0
    80004c1c:	fc040513          	add	a0,s0,-64
    80004c20:	ffffb097          	auipc	ra,0xffffb
    80004c24:	55a080e7          	jalr	1370(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c28:	4741                	li	a4,16
    80004c2a:	f2c42683          	lw	a3,-212(s0)
    80004c2e:	fc040613          	add	a2,s0,-64
    80004c32:	4581                	li	a1,0
    80004c34:	8526                	mv	a0,s1
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	4aa080e7          	jalr	1194(ra) # 800030e0 <writei>
    80004c3e:	47c1                	li	a5,16
    80004c40:	0af51b63          	bne	a0,a5,80004cf6 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004c44:	04491703          	lh	a4,68(s2)
    80004c48:	4785                	li	a5,1
    80004c4a:	0af70f63          	beq	a4,a5,80004d08 <sys_unlink+0x198>
  iunlockput(dp);
    80004c4e:	8526                	mv	a0,s1
    80004c50:	ffffe097          	auipc	ra,0xffffe
    80004c54:	33a080e7          	jalr	826(ra) # 80002f8a <iunlockput>
  ip->nlink--;
    80004c58:	04a95783          	lhu	a5,74(s2)
    80004c5c:	37fd                	addw	a5,a5,-1
    80004c5e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c62:	854a                	mv	a0,s2
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	ff4080e7          	jalr	-12(ra) # 80002c58 <iupdate>
  iunlockput(ip);
    80004c6c:	854a                	mv	a0,s2
    80004c6e:	ffffe097          	auipc	ra,0xffffe
    80004c72:	31c080e7          	jalr	796(ra) # 80002f8a <iunlockput>
  end_op();
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	afa080e7          	jalr	-1286(ra) # 80003770 <end_op>
  return 0;
    80004c7e:	4501                	li	a0,0
    80004c80:	64ee                	ld	s1,216(sp)
    80004c82:	694e                	ld	s2,208(sp)
    80004c84:	a84d                	j	80004d36 <sys_unlink+0x1c6>
    end_op();
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	aea080e7          	jalr	-1302(ra) # 80003770 <end_op>
    return -1;
    80004c8e:	557d                	li	a0,-1
    80004c90:	64ee                	ld	s1,216(sp)
    80004c92:	a055                	j	80004d36 <sys_unlink+0x1c6>
    80004c94:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004c96:	00004517          	auipc	a0,0x4
    80004c9a:	96250513          	add	a0,a0,-1694 # 800085f8 <etext+0x5f8>
    80004c9e:	00001097          	auipc	ra,0x1
    80004ca2:	20e080e7          	jalr	526(ra) # 80005eac <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ca6:	04c92703          	lw	a4,76(s2)
    80004caa:	02000793          	li	a5,32
    80004cae:	f6e7f5e3          	bgeu	a5,a4,80004c18 <sys_unlink+0xa8>
    80004cb2:	e5ce                	sd	s3,200(sp)
    80004cb4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cb8:	4741                	li	a4,16
    80004cba:	86ce                	mv	a3,s3
    80004cbc:	f1840613          	add	a2,s0,-232
    80004cc0:	4581                	li	a1,0
    80004cc2:	854a                	mv	a0,s2
    80004cc4:	ffffe097          	auipc	ra,0xffffe
    80004cc8:	318080e7          	jalr	792(ra) # 80002fdc <readi>
    80004ccc:	47c1                	li	a5,16
    80004cce:	00f51c63          	bne	a0,a5,80004ce6 <sys_unlink+0x176>
    if(de.inum != 0)
    80004cd2:	f1845783          	lhu	a5,-232(s0)
    80004cd6:	e7b5                	bnez	a5,80004d42 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cd8:	29c1                	addw	s3,s3,16
    80004cda:	04c92783          	lw	a5,76(s2)
    80004cde:	fcf9ede3          	bltu	s3,a5,80004cb8 <sys_unlink+0x148>
    80004ce2:	69ae                	ld	s3,200(sp)
    80004ce4:	bf15                	j	80004c18 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004ce6:	00004517          	auipc	a0,0x4
    80004cea:	92a50513          	add	a0,a0,-1750 # 80008610 <etext+0x610>
    80004cee:	00001097          	auipc	ra,0x1
    80004cf2:	1be080e7          	jalr	446(ra) # 80005eac <panic>
    80004cf6:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004cf8:	00004517          	auipc	a0,0x4
    80004cfc:	93050513          	add	a0,a0,-1744 # 80008628 <etext+0x628>
    80004d00:	00001097          	auipc	ra,0x1
    80004d04:	1ac080e7          	jalr	428(ra) # 80005eac <panic>
    dp->nlink--;
    80004d08:	04a4d783          	lhu	a5,74(s1)
    80004d0c:	37fd                	addw	a5,a5,-1
    80004d0e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d12:	8526                	mv	a0,s1
    80004d14:	ffffe097          	auipc	ra,0xffffe
    80004d18:	f44080e7          	jalr	-188(ra) # 80002c58 <iupdate>
    80004d1c:	bf0d                	j	80004c4e <sys_unlink+0xde>
    80004d1e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004d20:	8526                	mv	a0,s1
    80004d22:	ffffe097          	auipc	ra,0xffffe
    80004d26:	268080e7          	jalr	616(ra) # 80002f8a <iunlockput>
  end_op();
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	a46080e7          	jalr	-1466(ra) # 80003770 <end_op>
  return -1;
    80004d32:	557d                	li	a0,-1
    80004d34:	64ee                	ld	s1,216(sp)
}
    80004d36:	70ae                	ld	ra,232(sp)
    80004d38:	740e                	ld	s0,224(sp)
    80004d3a:	616d                	add	sp,sp,240
    80004d3c:	8082                	ret
    return -1;
    80004d3e:	557d                	li	a0,-1
    80004d40:	bfdd                	j	80004d36 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004d42:	854a                	mv	a0,s2
    80004d44:	ffffe097          	auipc	ra,0xffffe
    80004d48:	246080e7          	jalr	582(ra) # 80002f8a <iunlockput>
    goto bad;
    80004d4c:	694e                	ld	s2,208(sp)
    80004d4e:	69ae                	ld	s3,200(sp)
    80004d50:	bfc1                	j	80004d20 <sys_unlink+0x1b0>

0000000080004d52 <sys_open>:

uint64
sys_open(void)
{
    80004d52:	7131                	add	sp,sp,-192
    80004d54:	fd06                	sd	ra,184(sp)
    80004d56:	f922                	sd	s0,176(sp)
    80004d58:	f526                	sd	s1,168(sp)
    80004d5a:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d5c:	08000613          	li	a2,128
    80004d60:	f5040593          	add	a1,s0,-176
    80004d64:	4501                	li	a0,0
    80004d66:	ffffd097          	auipc	ra,0xffffd
    80004d6a:	378080e7          	jalr	888(ra) # 800020de <argstr>
    return -1;
    80004d6e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d70:	0c054463          	bltz	a0,80004e38 <sys_open+0xe6>
    80004d74:	f4c40593          	add	a1,s0,-180
    80004d78:	4505                	li	a0,1
    80004d7a:	ffffd097          	auipc	ra,0xffffd
    80004d7e:	320080e7          	jalr	800(ra) # 8000209a <argint>
    80004d82:	0a054b63          	bltz	a0,80004e38 <sys_open+0xe6>
    80004d86:	f14a                	sd	s2,160(sp)

  begin_op();
    80004d88:	fffff097          	auipc	ra,0xfffff
    80004d8c:	96e080e7          	jalr	-1682(ra) # 800036f6 <begin_op>

  if(omode & O_CREATE){
    80004d90:	f4c42783          	lw	a5,-180(s0)
    80004d94:	2007f793          	and	a5,a5,512
    80004d98:	cfc5                	beqz	a5,80004e50 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d9a:	4681                	li	a3,0
    80004d9c:	4601                	li	a2,0
    80004d9e:	4589                	li	a1,2
    80004da0:	f5040513          	add	a0,s0,-176
    80004da4:	00000097          	auipc	ra,0x0
    80004da8:	958080e7          	jalr	-1704(ra) # 800046fc <create>
    80004dac:	892a                	mv	s2,a0
    if(ip == 0){
    80004dae:	c959                	beqz	a0,80004e44 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004db0:	04491703          	lh	a4,68(s2)
    80004db4:	478d                	li	a5,3
    80004db6:	00f71763          	bne	a4,a5,80004dc4 <sys_open+0x72>
    80004dba:	04695703          	lhu	a4,70(s2)
    80004dbe:	47a5                	li	a5,9
    80004dc0:	0ce7ef63          	bltu	a5,a4,80004e9e <sys_open+0x14c>
    80004dc4:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	d3e080e7          	jalr	-706(ra) # 80003b04 <filealloc>
    80004dce:	89aa                	mv	s3,a0
    80004dd0:	c965                	beqz	a0,80004ec0 <sys_open+0x16e>
    80004dd2:	00000097          	auipc	ra,0x0
    80004dd6:	8e8080e7          	jalr	-1816(ra) # 800046ba <fdalloc>
    80004dda:	84aa                	mv	s1,a0
    80004ddc:	0c054d63          	bltz	a0,80004eb6 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004de0:	04491703          	lh	a4,68(s2)
    80004de4:	478d                	li	a5,3
    80004de6:	0ef70a63          	beq	a4,a5,80004eda <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dea:	4789                	li	a5,2
    80004dec:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004df0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004df4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004df8:	f4c42783          	lw	a5,-180(s0)
    80004dfc:	0017c713          	xor	a4,a5,1
    80004e00:	8b05                	and	a4,a4,1
    80004e02:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e06:	0037f713          	and	a4,a5,3
    80004e0a:	00e03733          	snez	a4,a4
    80004e0e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e12:	4007f793          	and	a5,a5,1024
    80004e16:	c791                	beqz	a5,80004e22 <sys_open+0xd0>
    80004e18:	04491703          	lh	a4,68(s2)
    80004e1c:	4789                	li	a5,2
    80004e1e:	0cf70563          	beq	a4,a5,80004ee8 <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004e22:	854a                	mv	a0,s2
    80004e24:	ffffe097          	auipc	ra,0xffffe
    80004e28:	fc6080e7          	jalr	-58(ra) # 80002dea <iunlock>
  end_op();
    80004e2c:	fffff097          	auipc	ra,0xfffff
    80004e30:	944080e7          	jalr	-1724(ra) # 80003770 <end_op>
    80004e34:	790a                	ld	s2,160(sp)
    80004e36:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004e38:	8526                	mv	a0,s1
    80004e3a:	70ea                	ld	ra,184(sp)
    80004e3c:	744a                	ld	s0,176(sp)
    80004e3e:	74aa                	ld	s1,168(sp)
    80004e40:	6129                	add	sp,sp,192
    80004e42:	8082                	ret
      end_op();
    80004e44:	fffff097          	auipc	ra,0xfffff
    80004e48:	92c080e7          	jalr	-1748(ra) # 80003770 <end_op>
      return -1;
    80004e4c:	790a                	ld	s2,160(sp)
    80004e4e:	b7ed                	j	80004e38 <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004e50:	f5040513          	add	a0,s0,-176
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	6a2080e7          	jalr	1698(ra) # 800034f6 <namei>
    80004e5c:	892a                	mv	s2,a0
    80004e5e:	c90d                	beqz	a0,80004e90 <sys_open+0x13e>
    ilock(ip);
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	ec4080e7          	jalr	-316(ra) # 80002d24 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e68:	04491703          	lh	a4,68(s2)
    80004e6c:	4785                	li	a5,1
    80004e6e:	f4f711e3          	bne	a4,a5,80004db0 <sys_open+0x5e>
    80004e72:	f4c42783          	lw	a5,-180(s0)
    80004e76:	d7b9                	beqz	a5,80004dc4 <sys_open+0x72>
      iunlockput(ip);
    80004e78:	854a                	mv	a0,s2
    80004e7a:	ffffe097          	auipc	ra,0xffffe
    80004e7e:	110080e7          	jalr	272(ra) # 80002f8a <iunlockput>
      end_op();
    80004e82:	fffff097          	auipc	ra,0xfffff
    80004e86:	8ee080e7          	jalr	-1810(ra) # 80003770 <end_op>
      return -1;
    80004e8a:	54fd                	li	s1,-1
    80004e8c:	790a                	ld	s2,160(sp)
    80004e8e:	b76d                	j	80004e38 <sys_open+0xe6>
      end_op();
    80004e90:	fffff097          	auipc	ra,0xfffff
    80004e94:	8e0080e7          	jalr	-1824(ra) # 80003770 <end_op>
      return -1;
    80004e98:	54fd                	li	s1,-1
    80004e9a:	790a                	ld	s2,160(sp)
    80004e9c:	bf71                	j	80004e38 <sys_open+0xe6>
    iunlockput(ip);
    80004e9e:	854a                	mv	a0,s2
    80004ea0:	ffffe097          	auipc	ra,0xffffe
    80004ea4:	0ea080e7          	jalr	234(ra) # 80002f8a <iunlockput>
    end_op();
    80004ea8:	fffff097          	auipc	ra,0xfffff
    80004eac:	8c8080e7          	jalr	-1848(ra) # 80003770 <end_op>
    return -1;
    80004eb0:	54fd                	li	s1,-1
    80004eb2:	790a                	ld	s2,160(sp)
    80004eb4:	b751                	j	80004e38 <sys_open+0xe6>
      fileclose(f);
    80004eb6:	854e                	mv	a0,s3
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	d08080e7          	jalr	-760(ra) # 80003bc0 <fileclose>
    iunlockput(ip);
    80004ec0:	854a                	mv	a0,s2
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	0c8080e7          	jalr	200(ra) # 80002f8a <iunlockput>
    end_op();
    80004eca:	fffff097          	auipc	ra,0xfffff
    80004ece:	8a6080e7          	jalr	-1882(ra) # 80003770 <end_op>
    return -1;
    80004ed2:	54fd                	li	s1,-1
    80004ed4:	790a                	ld	s2,160(sp)
    80004ed6:	69ea                	ld	s3,152(sp)
    80004ed8:	b785                	j	80004e38 <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004eda:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ede:	04691783          	lh	a5,70(s2)
    80004ee2:	02f99223          	sh	a5,36(s3)
    80004ee6:	b739                	j	80004df4 <sys_open+0xa2>
    itrunc(ip);
    80004ee8:	854a                	mv	a0,s2
    80004eea:	ffffe097          	auipc	ra,0xffffe
    80004eee:	f4c080e7          	jalr	-180(ra) # 80002e36 <itrunc>
    80004ef2:	bf05                	j	80004e22 <sys_open+0xd0>

0000000080004ef4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ef4:	7175                	add	sp,sp,-144
    80004ef6:	e506                	sd	ra,136(sp)
    80004ef8:	e122                	sd	s0,128(sp)
    80004efa:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004efc:	ffffe097          	auipc	ra,0xffffe
    80004f00:	7fa080e7          	jalr	2042(ra) # 800036f6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f04:	08000613          	li	a2,128
    80004f08:	f7040593          	add	a1,s0,-144
    80004f0c:	4501                	li	a0,0
    80004f0e:	ffffd097          	auipc	ra,0xffffd
    80004f12:	1d0080e7          	jalr	464(ra) # 800020de <argstr>
    80004f16:	02054963          	bltz	a0,80004f48 <sys_mkdir+0x54>
    80004f1a:	4681                	li	a3,0
    80004f1c:	4601                	li	a2,0
    80004f1e:	4585                	li	a1,1
    80004f20:	f7040513          	add	a0,s0,-144
    80004f24:	fffff097          	auipc	ra,0xfffff
    80004f28:	7d8080e7          	jalr	2008(ra) # 800046fc <create>
    80004f2c:	cd11                	beqz	a0,80004f48 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f2e:	ffffe097          	auipc	ra,0xffffe
    80004f32:	05c080e7          	jalr	92(ra) # 80002f8a <iunlockput>
  end_op();
    80004f36:	fffff097          	auipc	ra,0xfffff
    80004f3a:	83a080e7          	jalr	-1990(ra) # 80003770 <end_op>
  return 0;
    80004f3e:	4501                	li	a0,0
}
    80004f40:	60aa                	ld	ra,136(sp)
    80004f42:	640a                	ld	s0,128(sp)
    80004f44:	6149                	add	sp,sp,144
    80004f46:	8082                	ret
    end_op();
    80004f48:	fffff097          	auipc	ra,0xfffff
    80004f4c:	828080e7          	jalr	-2008(ra) # 80003770 <end_op>
    return -1;
    80004f50:	557d                	li	a0,-1
    80004f52:	b7fd                	j	80004f40 <sys_mkdir+0x4c>

0000000080004f54 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f54:	7135                	add	sp,sp,-160
    80004f56:	ed06                	sd	ra,152(sp)
    80004f58:	e922                	sd	s0,144(sp)
    80004f5a:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f5c:	ffffe097          	auipc	ra,0xffffe
    80004f60:	79a080e7          	jalr	1946(ra) # 800036f6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f64:	08000613          	li	a2,128
    80004f68:	f7040593          	add	a1,s0,-144
    80004f6c:	4501                	li	a0,0
    80004f6e:	ffffd097          	auipc	ra,0xffffd
    80004f72:	170080e7          	jalr	368(ra) # 800020de <argstr>
    80004f76:	04054a63          	bltz	a0,80004fca <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f7a:	f6c40593          	add	a1,s0,-148
    80004f7e:	4505                	li	a0,1
    80004f80:	ffffd097          	auipc	ra,0xffffd
    80004f84:	11a080e7          	jalr	282(ra) # 8000209a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f88:	04054163          	bltz	a0,80004fca <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f8c:	f6840593          	add	a1,s0,-152
    80004f90:	4509                	li	a0,2
    80004f92:	ffffd097          	auipc	ra,0xffffd
    80004f96:	108080e7          	jalr	264(ra) # 8000209a <argint>
     argint(1, &major) < 0 ||
    80004f9a:	02054863          	bltz	a0,80004fca <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f9e:	f6841683          	lh	a3,-152(s0)
    80004fa2:	f6c41603          	lh	a2,-148(s0)
    80004fa6:	458d                	li	a1,3
    80004fa8:	f7040513          	add	a0,s0,-144
    80004fac:	fffff097          	auipc	ra,0xfffff
    80004fb0:	750080e7          	jalr	1872(ra) # 800046fc <create>
     argint(2, &minor) < 0 ||
    80004fb4:	c919                	beqz	a0,80004fca <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fb6:	ffffe097          	auipc	ra,0xffffe
    80004fba:	fd4080e7          	jalr	-44(ra) # 80002f8a <iunlockput>
  end_op();
    80004fbe:	ffffe097          	auipc	ra,0xffffe
    80004fc2:	7b2080e7          	jalr	1970(ra) # 80003770 <end_op>
  return 0;
    80004fc6:	4501                	li	a0,0
    80004fc8:	a031                	j	80004fd4 <sys_mknod+0x80>
    end_op();
    80004fca:	ffffe097          	auipc	ra,0xffffe
    80004fce:	7a6080e7          	jalr	1958(ra) # 80003770 <end_op>
    return -1;
    80004fd2:	557d                	li	a0,-1
}
    80004fd4:	60ea                	ld	ra,152(sp)
    80004fd6:	644a                	ld	s0,144(sp)
    80004fd8:	610d                	add	sp,sp,160
    80004fda:	8082                	ret

0000000080004fdc <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fdc:	7135                	add	sp,sp,-160
    80004fde:	ed06                	sd	ra,152(sp)
    80004fe0:	e922                	sd	s0,144(sp)
    80004fe2:	e14a                	sd	s2,128(sp)
    80004fe4:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fe6:	ffffc097          	auipc	ra,0xffffc
    80004fea:	f58080e7          	jalr	-168(ra) # 80000f3e <myproc>
    80004fee:	892a                	mv	s2,a0
  
  begin_op();
    80004ff0:	ffffe097          	auipc	ra,0xffffe
    80004ff4:	706080e7          	jalr	1798(ra) # 800036f6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ff8:	08000613          	li	a2,128
    80004ffc:	f6040593          	add	a1,s0,-160
    80005000:	4501                	li	a0,0
    80005002:	ffffd097          	auipc	ra,0xffffd
    80005006:	0dc080e7          	jalr	220(ra) # 800020de <argstr>
    8000500a:	04054d63          	bltz	a0,80005064 <sys_chdir+0x88>
    8000500e:	e526                	sd	s1,136(sp)
    80005010:	f6040513          	add	a0,s0,-160
    80005014:	ffffe097          	auipc	ra,0xffffe
    80005018:	4e2080e7          	jalr	1250(ra) # 800034f6 <namei>
    8000501c:	84aa                	mv	s1,a0
    8000501e:	c131                	beqz	a0,80005062 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005020:	ffffe097          	auipc	ra,0xffffe
    80005024:	d04080e7          	jalr	-764(ra) # 80002d24 <ilock>
  if(ip->type != T_DIR){
    80005028:	04449703          	lh	a4,68(s1)
    8000502c:	4785                	li	a5,1
    8000502e:	04f71163          	bne	a4,a5,80005070 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005032:	8526                	mv	a0,s1
    80005034:	ffffe097          	auipc	ra,0xffffe
    80005038:	db6080e7          	jalr	-586(ra) # 80002dea <iunlock>
  iput(p->cwd);
    8000503c:	15093503          	ld	a0,336(s2)
    80005040:	ffffe097          	auipc	ra,0xffffe
    80005044:	ea2080e7          	jalr	-350(ra) # 80002ee2 <iput>
  end_op();
    80005048:	ffffe097          	auipc	ra,0xffffe
    8000504c:	728080e7          	jalr	1832(ra) # 80003770 <end_op>
  p->cwd = ip;
    80005050:	14993823          	sd	s1,336(s2)
  return 0;
    80005054:	4501                	li	a0,0
    80005056:	64aa                	ld	s1,136(sp)
}
    80005058:	60ea                	ld	ra,152(sp)
    8000505a:	644a                	ld	s0,144(sp)
    8000505c:	690a                	ld	s2,128(sp)
    8000505e:	610d                	add	sp,sp,160
    80005060:	8082                	ret
    80005062:	64aa                	ld	s1,136(sp)
    end_op();
    80005064:	ffffe097          	auipc	ra,0xffffe
    80005068:	70c080e7          	jalr	1804(ra) # 80003770 <end_op>
    return -1;
    8000506c:	557d                	li	a0,-1
    8000506e:	b7ed                	j	80005058 <sys_chdir+0x7c>
    iunlockput(ip);
    80005070:	8526                	mv	a0,s1
    80005072:	ffffe097          	auipc	ra,0xffffe
    80005076:	f18080e7          	jalr	-232(ra) # 80002f8a <iunlockput>
    end_op();
    8000507a:	ffffe097          	auipc	ra,0xffffe
    8000507e:	6f6080e7          	jalr	1782(ra) # 80003770 <end_op>
    return -1;
    80005082:	557d                	li	a0,-1
    80005084:	64aa                	ld	s1,136(sp)
    80005086:	bfc9                	j	80005058 <sys_chdir+0x7c>

0000000080005088 <sys_exec>:

uint64
sys_exec(void)
{
    80005088:	7121                	add	sp,sp,-448
    8000508a:	ff06                	sd	ra,440(sp)
    8000508c:	fb22                	sd	s0,432(sp)
    8000508e:	f34a                	sd	s2,416(sp)
    80005090:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005092:	08000613          	li	a2,128
    80005096:	f5040593          	add	a1,s0,-176
    8000509a:	4501                	li	a0,0
    8000509c:	ffffd097          	auipc	ra,0xffffd
    800050a0:	042080e7          	jalr	66(ra) # 800020de <argstr>
    return -1;
    800050a4:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050a6:	0e054a63          	bltz	a0,8000519a <sys_exec+0x112>
    800050aa:	e4840593          	add	a1,s0,-440
    800050ae:	4505                	li	a0,1
    800050b0:	ffffd097          	auipc	ra,0xffffd
    800050b4:	00c080e7          	jalr	12(ra) # 800020bc <argaddr>
    800050b8:	0e054163          	bltz	a0,8000519a <sys_exec+0x112>
    800050bc:	f726                	sd	s1,424(sp)
    800050be:	ef4e                	sd	s3,408(sp)
    800050c0:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800050c2:	10000613          	li	a2,256
    800050c6:	4581                	li	a1,0
    800050c8:	e5040513          	add	a0,s0,-432
    800050cc:	ffffb097          	auipc	ra,0xffffb
    800050d0:	0ae080e7          	jalr	174(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050d4:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800050d8:	89a6                	mv	s3,s1
    800050da:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050dc:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050e0:	00391513          	sll	a0,s2,0x3
    800050e4:	e4040593          	add	a1,s0,-448
    800050e8:	e4843783          	ld	a5,-440(s0)
    800050ec:	953e                	add	a0,a0,a5
    800050ee:	ffffd097          	auipc	ra,0xffffd
    800050f2:	f12080e7          	jalr	-238(ra) # 80002000 <fetchaddr>
    800050f6:	02054a63          	bltz	a0,8000512a <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    800050fa:	e4043783          	ld	a5,-448(s0)
    800050fe:	c7b1                	beqz	a5,8000514a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005100:	ffffb097          	auipc	ra,0xffffb
    80005104:	01a080e7          	jalr	26(ra) # 8000011a <kalloc>
    80005108:	85aa                	mv	a1,a0
    8000510a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000510e:	cd11                	beqz	a0,8000512a <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005110:	6605                	lui	a2,0x1
    80005112:	e4043503          	ld	a0,-448(s0)
    80005116:	ffffd097          	auipc	ra,0xffffd
    8000511a:	f3c080e7          	jalr	-196(ra) # 80002052 <fetchstr>
    8000511e:	00054663          	bltz	a0,8000512a <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005122:	0905                	add	s2,s2,1
    80005124:	09a1                	add	s3,s3,8
    80005126:	fb491de3          	bne	s2,s4,800050e0 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000512a:	f5040913          	add	s2,s0,-176
    8000512e:	6088                	ld	a0,0(s1)
    80005130:	c12d                	beqz	a0,80005192 <sys_exec+0x10a>
    kfree(argv[i]);
    80005132:	ffffb097          	auipc	ra,0xffffb
    80005136:	eea080e7          	jalr	-278(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000513a:	04a1                	add	s1,s1,8
    8000513c:	ff2499e3          	bne	s1,s2,8000512e <sys_exec+0xa6>
  return -1;
    80005140:	597d                	li	s2,-1
    80005142:	74ba                	ld	s1,424(sp)
    80005144:	69fa                	ld	s3,408(sp)
    80005146:	6a5a                	ld	s4,400(sp)
    80005148:	a889                	j	8000519a <sys_exec+0x112>
      argv[i] = 0;
    8000514a:	0009079b          	sext.w	a5,s2
    8000514e:	078e                	sll	a5,a5,0x3
    80005150:	fd078793          	add	a5,a5,-48
    80005154:	97a2                	add	a5,a5,s0
    80005156:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000515a:	e5040593          	add	a1,s0,-432
    8000515e:	f5040513          	add	a0,s0,-176
    80005162:	fffff097          	auipc	ra,0xfffff
    80005166:	10e080e7          	jalr	270(ra) # 80004270 <exec>
    8000516a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000516c:	f5040993          	add	s3,s0,-176
    80005170:	6088                	ld	a0,0(s1)
    80005172:	cd01                	beqz	a0,8000518a <sys_exec+0x102>
    kfree(argv[i]);
    80005174:	ffffb097          	auipc	ra,0xffffb
    80005178:	ea8080e7          	jalr	-344(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000517c:	04a1                	add	s1,s1,8
    8000517e:	ff3499e3          	bne	s1,s3,80005170 <sys_exec+0xe8>
    80005182:	74ba                	ld	s1,424(sp)
    80005184:	69fa                	ld	s3,408(sp)
    80005186:	6a5a                	ld	s4,400(sp)
    80005188:	a809                	j	8000519a <sys_exec+0x112>
  return ret;
    8000518a:	74ba                	ld	s1,424(sp)
    8000518c:	69fa                	ld	s3,408(sp)
    8000518e:	6a5a                	ld	s4,400(sp)
    80005190:	a029                	j	8000519a <sys_exec+0x112>
  return -1;
    80005192:	597d                	li	s2,-1
    80005194:	74ba                	ld	s1,424(sp)
    80005196:	69fa                	ld	s3,408(sp)
    80005198:	6a5a                	ld	s4,400(sp)
}
    8000519a:	854a                	mv	a0,s2
    8000519c:	70fa                	ld	ra,440(sp)
    8000519e:	745a                	ld	s0,432(sp)
    800051a0:	791a                	ld	s2,416(sp)
    800051a2:	6139                	add	sp,sp,448
    800051a4:	8082                	ret

00000000800051a6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800051a6:	7139                	add	sp,sp,-64
    800051a8:	fc06                	sd	ra,56(sp)
    800051aa:	f822                	sd	s0,48(sp)
    800051ac:	f426                	sd	s1,40(sp)
    800051ae:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051b0:	ffffc097          	auipc	ra,0xffffc
    800051b4:	d8e080e7          	jalr	-626(ra) # 80000f3e <myproc>
    800051b8:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800051ba:	fd840593          	add	a1,s0,-40
    800051be:	4501                	li	a0,0
    800051c0:	ffffd097          	auipc	ra,0xffffd
    800051c4:	efc080e7          	jalr	-260(ra) # 800020bc <argaddr>
    return -1;
    800051c8:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800051ca:	0e054063          	bltz	a0,800052aa <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800051ce:	fc840593          	add	a1,s0,-56
    800051d2:	fd040513          	add	a0,s0,-48
    800051d6:	fffff097          	auipc	ra,0xfffff
    800051da:	d58080e7          	jalr	-680(ra) # 80003f2e <pipealloc>
    return -1;
    800051de:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051e0:	0c054563          	bltz	a0,800052aa <sys_pipe+0x104>
  fd0 = -1;
    800051e4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051e8:	fd043503          	ld	a0,-48(s0)
    800051ec:	fffff097          	auipc	ra,0xfffff
    800051f0:	4ce080e7          	jalr	1230(ra) # 800046ba <fdalloc>
    800051f4:	fca42223          	sw	a0,-60(s0)
    800051f8:	08054c63          	bltz	a0,80005290 <sys_pipe+0xea>
    800051fc:	fc843503          	ld	a0,-56(s0)
    80005200:	fffff097          	auipc	ra,0xfffff
    80005204:	4ba080e7          	jalr	1210(ra) # 800046ba <fdalloc>
    80005208:	fca42023          	sw	a0,-64(s0)
    8000520c:	06054963          	bltz	a0,8000527e <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005210:	4691                	li	a3,4
    80005212:	fc440613          	add	a2,s0,-60
    80005216:	fd843583          	ld	a1,-40(s0)
    8000521a:	68a8                	ld	a0,80(s1)
    8000521c:	ffffc097          	auipc	ra,0xffffc
    80005220:	8fc080e7          	jalr	-1796(ra) # 80000b18 <copyout>
    80005224:	02054063          	bltz	a0,80005244 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005228:	4691                	li	a3,4
    8000522a:	fc040613          	add	a2,s0,-64
    8000522e:	fd843583          	ld	a1,-40(s0)
    80005232:	0591                	add	a1,a1,4
    80005234:	68a8                	ld	a0,80(s1)
    80005236:	ffffc097          	auipc	ra,0xffffc
    8000523a:	8e2080e7          	jalr	-1822(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000523e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005240:	06055563          	bgez	a0,800052aa <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005244:	fc442783          	lw	a5,-60(s0)
    80005248:	07e9                	add	a5,a5,26
    8000524a:	078e                	sll	a5,a5,0x3
    8000524c:	97a6                	add	a5,a5,s1
    8000524e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005252:	fc042783          	lw	a5,-64(s0)
    80005256:	07e9                	add	a5,a5,26
    80005258:	078e                	sll	a5,a5,0x3
    8000525a:	00f48533          	add	a0,s1,a5
    8000525e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005262:	fd043503          	ld	a0,-48(s0)
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	95a080e7          	jalr	-1702(ra) # 80003bc0 <fileclose>
    fileclose(wf);
    8000526e:	fc843503          	ld	a0,-56(s0)
    80005272:	fffff097          	auipc	ra,0xfffff
    80005276:	94e080e7          	jalr	-1714(ra) # 80003bc0 <fileclose>
    return -1;
    8000527a:	57fd                	li	a5,-1
    8000527c:	a03d                	j	800052aa <sys_pipe+0x104>
    if(fd0 >= 0)
    8000527e:	fc442783          	lw	a5,-60(s0)
    80005282:	0007c763          	bltz	a5,80005290 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005286:	07e9                	add	a5,a5,26
    80005288:	078e                	sll	a5,a5,0x3
    8000528a:	97a6                	add	a5,a5,s1
    8000528c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005290:	fd043503          	ld	a0,-48(s0)
    80005294:	fffff097          	auipc	ra,0xfffff
    80005298:	92c080e7          	jalr	-1748(ra) # 80003bc0 <fileclose>
    fileclose(wf);
    8000529c:	fc843503          	ld	a0,-56(s0)
    800052a0:	fffff097          	auipc	ra,0xfffff
    800052a4:	920080e7          	jalr	-1760(ra) # 80003bc0 <fileclose>
    return -1;
    800052a8:	57fd                	li	a5,-1
}
    800052aa:	853e                	mv	a0,a5
    800052ac:	70e2                	ld	ra,56(sp)
    800052ae:	7442                	ld	s0,48(sp)
    800052b0:	74a2                	ld	s1,40(sp)
    800052b2:	6121                	add	sp,sp,64
    800052b4:	8082                	ret
	...

00000000800052c0 <kernelvec>:
    800052c0:	7111                	add	sp,sp,-256
    800052c2:	e006                	sd	ra,0(sp)
    800052c4:	e40a                	sd	sp,8(sp)
    800052c6:	e80e                	sd	gp,16(sp)
    800052c8:	ec12                	sd	tp,24(sp)
    800052ca:	f016                	sd	t0,32(sp)
    800052cc:	f41a                	sd	t1,40(sp)
    800052ce:	f81e                	sd	t2,48(sp)
    800052d0:	fc22                	sd	s0,56(sp)
    800052d2:	e0a6                	sd	s1,64(sp)
    800052d4:	e4aa                	sd	a0,72(sp)
    800052d6:	e8ae                	sd	a1,80(sp)
    800052d8:	ecb2                	sd	a2,88(sp)
    800052da:	f0b6                	sd	a3,96(sp)
    800052dc:	f4ba                	sd	a4,104(sp)
    800052de:	f8be                	sd	a5,112(sp)
    800052e0:	fcc2                	sd	a6,120(sp)
    800052e2:	e146                	sd	a7,128(sp)
    800052e4:	e54a                	sd	s2,136(sp)
    800052e6:	e94e                	sd	s3,144(sp)
    800052e8:	ed52                	sd	s4,152(sp)
    800052ea:	f156                	sd	s5,160(sp)
    800052ec:	f55a                	sd	s6,168(sp)
    800052ee:	f95e                	sd	s7,176(sp)
    800052f0:	fd62                	sd	s8,184(sp)
    800052f2:	e1e6                	sd	s9,192(sp)
    800052f4:	e5ea                	sd	s10,200(sp)
    800052f6:	e9ee                	sd	s11,208(sp)
    800052f8:	edf2                	sd	t3,216(sp)
    800052fa:	f1f6                	sd	t4,224(sp)
    800052fc:	f5fa                	sd	t5,232(sp)
    800052fe:	f9fe                	sd	t6,240(sp)
    80005300:	bcdfc0ef          	jal	80001ecc <kerneltrap>
    80005304:	6082                	ld	ra,0(sp)
    80005306:	6122                	ld	sp,8(sp)
    80005308:	61c2                	ld	gp,16(sp)
    8000530a:	7282                	ld	t0,32(sp)
    8000530c:	7322                	ld	t1,40(sp)
    8000530e:	73c2                	ld	t2,48(sp)
    80005310:	7462                	ld	s0,56(sp)
    80005312:	6486                	ld	s1,64(sp)
    80005314:	6526                	ld	a0,72(sp)
    80005316:	65c6                	ld	a1,80(sp)
    80005318:	6666                	ld	a2,88(sp)
    8000531a:	7686                	ld	a3,96(sp)
    8000531c:	7726                	ld	a4,104(sp)
    8000531e:	77c6                	ld	a5,112(sp)
    80005320:	7866                	ld	a6,120(sp)
    80005322:	688a                	ld	a7,128(sp)
    80005324:	692a                	ld	s2,136(sp)
    80005326:	69ca                	ld	s3,144(sp)
    80005328:	6a6a                	ld	s4,152(sp)
    8000532a:	7a8a                	ld	s5,160(sp)
    8000532c:	7b2a                	ld	s6,168(sp)
    8000532e:	7bca                	ld	s7,176(sp)
    80005330:	7c6a                	ld	s8,184(sp)
    80005332:	6c8e                	ld	s9,192(sp)
    80005334:	6d2e                	ld	s10,200(sp)
    80005336:	6dce                	ld	s11,208(sp)
    80005338:	6e6e                	ld	t3,216(sp)
    8000533a:	7e8e                	ld	t4,224(sp)
    8000533c:	7f2e                	ld	t5,232(sp)
    8000533e:	7fce                	ld	t6,240(sp)
    80005340:	6111                	add	sp,sp,256
    80005342:	10200073          	sret
    80005346:	00000013          	nop
    8000534a:	00000013          	nop
    8000534e:	0001                	nop

0000000080005350 <timervec>:
    80005350:	34051573          	csrrw	a0,mscratch,a0
    80005354:	e10c                	sd	a1,0(a0)
    80005356:	e510                	sd	a2,8(a0)
    80005358:	e914                	sd	a3,16(a0)
    8000535a:	6d0c                	ld	a1,24(a0)
    8000535c:	7110                	ld	a2,32(a0)
    8000535e:	6194                	ld	a3,0(a1)
    80005360:	96b2                	add	a3,a3,a2
    80005362:	e194                	sd	a3,0(a1)
    80005364:	4589                	li	a1,2
    80005366:	14459073          	csrw	sip,a1
    8000536a:	6914                	ld	a3,16(a0)
    8000536c:	6510                	ld	a2,8(a0)
    8000536e:	610c                	ld	a1,0(a0)
    80005370:	34051573          	csrrw	a0,mscratch,a0
    80005374:	30200073          	mret
	...

000000008000537a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000537a:	1141                	add	sp,sp,-16
    8000537c:	e422                	sd	s0,8(sp)
    8000537e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005380:	0c0007b7          	lui	a5,0xc000
    80005384:	4705                	li	a4,1
    80005386:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005388:	0c0007b7          	lui	a5,0xc000
    8000538c:	c3d8                	sw	a4,4(a5)
}
    8000538e:	6422                	ld	s0,8(sp)
    80005390:	0141                	add	sp,sp,16
    80005392:	8082                	ret

0000000080005394 <plicinithart>:

void
plicinithart(void)
{
    80005394:	1141                	add	sp,sp,-16
    80005396:	e406                	sd	ra,8(sp)
    80005398:	e022                	sd	s0,0(sp)
    8000539a:	0800                	add	s0,sp,16
  int hart = cpuid();
    8000539c:	ffffc097          	auipc	ra,0xffffc
    800053a0:	b76080e7          	jalr	-1162(ra) # 80000f12 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053a4:	0085171b          	sllw	a4,a0,0x8
    800053a8:	0c0027b7          	lui	a5,0xc002
    800053ac:	97ba                	add	a5,a5,a4
    800053ae:	40200713          	li	a4,1026
    800053b2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053b6:	00d5151b          	sllw	a0,a0,0xd
    800053ba:	0c2017b7          	lui	a5,0xc201
    800053be:	97aa                	add	a5,a5,a0
    800053c0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053c4:	60a2                	ld	ra,8(sp)
    800053c6:	6402                	ld	s0,0(sp)
    800053c8:	0141                	add	sp,sp,16
    800053ca:	8082                	ret

00000000800053cc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053cc:	1141                	add	sp,sp,-16
    800053ce:	e406                	sd	ra,8(sp)
    800053d0:	e022                	sd	s0,0(sp)
    800053d2:	0800                	add	s0,sp,16
  int hart = cpuid();
    800053d4:	ffffc097          	auipc	ra,0xffffc
    800053d8:	b3e080e7          	jalr	-1218(ra) # 80000f12 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053dc:	00d5151b          	sllw	a0,a0,0xd
    800053e0:	0c2017b7          	lui	a5,0xc201
    800053e4:	97aa                	add	a5,a5,a0
  return irq;
}
    800053e6:	43c8                	lw	a0,4(a5)
    800053e8:	60a2                	ld	ra,8(sp)
    800053ea:	6402                	ld	s0,0(sp)
    800053ec:	0141                	add	sp,sp,16
    800053ee:	8082                	ret

00000000800053f0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053f0:	1101                	add	sp,sp,-32
    800053f2:	ec06                	sd	ra,24(sp)
    800053f4:	e822                	sd	s0,16(sp)
    800053f6:	e426                	sd	s1,8(sp)
    800053f8:	1000                	add	s0,sp,32
    800053fa:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053fc:	ffffc097          	auipc	ra,0xffffc
    80005400:	b16080e7          	jalr	-1258(ra) # 80000f12 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005404:	00d5151b          	sllw	a0,a0,0xd
    80005408:	0c2017b7          	lui	a5,0xc201
    8000540c:	97aa                	add	a5,a5,a0
    8000540e:	c3c4                	sw	s1,4(a5)
}
    80005410:	60e2                	ld	ra,24(sp)
    80005412:	6442                	ld	s0,16(sp)
    80005414:	64a2                	ld	s1,8(sp)
    80005416:	6105                	add	sp,sp,32
    80005418:	8082                	ret

000000008000541a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000541a:	1141                	add	sp,sp,-16
    8000541c:	e406                	sd	ra,8(sp)
    8000541e:	e022                	sd	s0,0(sp)
    80005420:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005422:	479d                	li	a5,7
    80005424:	06a7c863          	blt	a5,a0,80005494 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005428:	00016717          	auipc	a4,0x16
    8000542c:	bd870713          	add	a4,a4,-1064 # 8001b000 <disk>
    80005430:	972a                	add	a4,a4,a0
    80005432:	6789                	lui	a5,0x2
    80005434:	97ba                	add	a5,a5,a4
    80005436:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000543a:	e7ad                	bnez	a5,800054a4 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000543c:	00451793          	sll	a5,a0,0x4
    80005440:	00018717          	auipc	a4,0x18
    80005444:	bc070713          	add	a4,a4,-1088 # 8001d000 <disk+0x2000>
    80005448:	6314                	ld	a3,0(a4)
    8000544a:	96be                	add	a3,a3,a5
    8000544c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005450:	6314                	ld	a3,0(a4)
    80005452:	96be                	add	a3,a3,a5
    80005454:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005458:	6314                	ld	a3,0(a4)
    8000545a:	96be                	add	a3,a3,a5
    8000545c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005460:	6318                	ld	a4,0(a4)
    80005462:	97ba                	add	a5,a5,a4
    80005464:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005468:	00016717          	auipc	a4,0x16
    8000546c:	b9870713          	add	a4,a4,-1128 # 8001b000 <disk>
    80005470:	972a                	add	a4,a4,a0
    80005472:	6789                	lui	a5,0x2
    80005474:	97ba                	add	a5,a5,a4
    80005476:	4705                	li	a4,1
    80005478:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000547c:	00018517          	auipc	a0,0x18
    80005480:	b9c50513          	add	a0,a0,-1124 # 8001d018 <disk+0x2018>
    80005484:	ffffc097          	auipc	ra,0xffffc
    80005488:	3a8080e7          	jalr	936(ra) # 8000182c <wakeup>
}
    8000548c:	60a2                	ld	ra,8(sp)
    8000548e:	6402                	ld	s0,0(sp)
    80005490:	0141                	add	sp,sp,16
    80005492:	8082                	ret
    panic("free_desc 1");
    80005494:	00003517          	auipc	a0,0x3
    80005498:	1a450513          	add	a0,a0,420 # 80008638 <etext+0x638>
    8000549c:	00001097          	auipc	ra,0x1
    800054a0:	a10080e7          	jalr	-1520(ra) # 80005eac <panic>
    panic("free_desc 2");
    800054a4:	00003517          	auipc	a0,0x3
    800054a8:	1a450513          	add	a0,a0,420 # 80008648 <etext+0x648>
    800054ac:	00001097          	auipc	ra,0x1
    800054b0:	a00080e7          	jalr	-1536(ra) # 80005eac <panic>

00000000800054b4 <virtio_disk_init>:
{
    800054b4:	1141                	add	sp,sp,-16
    800054b6:	e406                	sd	ra,8(sp)
    800054b8:	e022                	sd	s0,0(sp)
    800054ba:	0800                	add	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054bc:	00003597          	auipc	a1,0x3
    800054c0:	19c58593          	add	a1,a1,412 # 80008658 <etext+0x658>
    800054c4:	00018517          	auipc	a0,0x18
    800054c8:	c6450513          	add	a0,a0,-924 # 8001d128 <disk+0x2128>
    800054cc:	00001097          	auipc	ra,0x1
    800054d0:	eca080e7          	jalr	-310(ra) # 80006396 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054d4:	100017b7          	lui	a5,0x10001
    800054d8:	4398                	lw	a4,0(a5)
    800054da:	2701                	sext.w	a4,a4
    800054dc:	747277b7          	lui	a5,0x74727
    800054e0:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054e4:	0ef71f63          	bne	a4,a5,800055e2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054e8:	100017b7          	lui	a5,0x10001
    800054ec:	0791                	add	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800054ee:	439c                	lw	a5,0(a5)
    800054f0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054f2:	4705                	li	a4,1
    800054f4:	0ee79763          	bne	a5,a4,800055e2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054f8:	100017b7          	lui	a5,0x10001
    800054fc:	07a1                	add	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800054fe:	439c                	lw	a5,0(a5)
    80005500:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005502:	4709                	li	a4,2
    80005504:	0ce79f63          	bne	a5,a4,800055e2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005508:	100017b7          	lui	a5,0x10001
    8000550c:	47d8                	lw	a4,12(a5)
    8000550e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005510:	554d47b7          	lui	a5,0x554d4
    80005514:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005518:	0cf71563          	bne	a4,a5,800055e2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000551c:	100017b7          	lui	a5,0x10001
    80005520:	4705                	li	a4,1
    80005522:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005524:	470d                	li	a4,3
    80005526:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005528:	10001737          	lui	a4,0x10001
    8000552c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000552e:	c7ffe737          	lui	a4,0xc7ffe
    80005532:	75f70713          	add	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005536:	8ef9                	and	a3,a3,a4
    80005538:	10001737          	lui	a4,0x10001
    8000553c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000553e:	472d                	li	a4,11
    80005540:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005542:	473d                	li	a4,15
    80005544:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005546:	100017b7          	lui	a5,0x10001
    8000554a:	6705                	lui	a4,0x1
    8000554c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000554e:	100017b7          	lui	a5,0x10001
    80005552:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005556:	100017b7          	lui	a5,0x10001
    8000555a:	03478793          	add	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000555e:	439c                	lw	a5,0(a5)
    80005560:	2781                	sext.w	a5,a5
  if(max == 0)
    80005562:	cbc1                	beqz	a5,800055f2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005564:	471d                	li	a4,7
    80005566:	08f77e63          	bgeu	a4,a5,80005602 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000556a:	100017b7          	lui	a5,0x10001
    8000556e:	4721                	li	a4,8
    80005570:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005572:	6609                	lui	a2,0x2
    80005574:	4581                	li	a1,0
    80005576:	00016517          	auipc	a0,0x16
    8000557a:	a8a50513          	add	a0,a0,-1398 # 8001b000 <disk>
    8000557e:	ffffb097          	auipc	ra,0xffffb
    80005582:	bfc080e7          	jalr	-1028(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005586:	00016697          	auipc	a3,0x16
    8000558a:	a7a68693          	add	a3,a3,-1414 # 8001b000 <disk>
    8000558e:	00c6d713          	srl	a4,a3,0xc
    80005592:	2701                	sext.w	a4,a4
    80005594:	100017b7          	lui	a5,0x10001
    80005598:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000559a:	00018797          	auipc	a5,0x18
    8000559e:	a6678793          	add	a5,a5,-1434 # 8001d000 <disk+0x2000>
    800055a2:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800055a4:	00016717          	auipc	a4,0x16
    800055a8:	adc70713          	add	a4,a4,-1316 # 8001b080 <disk+0x80>
    800055ac:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800055ae:	00017717          	auipc	a4,0x17
    800055b2:	a5270713          	add	a4,a4,-1454 # 8001c000 <disk+0x1000>
    800055b6:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800055b8:	4705                	li	a4,1
    800055ba:	00e78c23          	sb	a4,24(a5)
    800055be:	00e78ca3          	sb	a4,25(a5)
    800055c2:	00e78d23          	sb	a4,26(a5)
    800055c6:	00e78da3          	sb	a4,27(a5)
    800055ca:	00e78e23          	sb	a4,28(a5)
    800055ce:	00e78ea3          	sb	a4,29(a5)
    800055d2:	00e78f23          	sb	a4,30(a5)
    800055d6:	00e78fa3          	sb	a4,31(a5)
}
    800055da:	60a2                	ld	ra,8(sp)
    800055dc:	6402                	ld	s0,0(sp)
    800055de:	0141                	add	sp,sp,16
    800055e0:	8082                	ret
    panic("could not find virtio disk");
    800055e2:	00003517          	auipc	a0,0x3
    800055e6:	08650513          	add	a0,a0,134 # 80008668 <etext+0x668>
    800055ea:	00001097          	auipc	ra,0x1
    800055ee:	8c2080e7          	jalr	-1854(ra) # 80005eac <panic>
    panic("virtio disk has no queue 0");
    800055f2:	00003517          	auipc	a0,0x3
    800055f6:	09650513          	add	a0,a0,150 # 80008688 <etext+0x688>
    800055fa:	00001097          	auipc	ra,0x1
    800055fe:	8b2080e7          	jalr	-1870(ra) # 80005eac <panic>
    panic("virtio disk max queue too short");
    80005602:	00003517          	auipc	a0,0x3
    80005606:	0a650513          	add	a0,a0,166 # 800086a8 <etext+0x6a8>
    8000560a:	00001097          	auipc	ra,0x1
    8000560e:	8a2080e7          	jalr	-1886(ra) # 80005eac <panic>

0000000080005612 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005612:	7159                	add	sp,sp,-112
    80005614:	f486                	sd	ra,104(sp)
    80005616:	f0a2                	sd	s0,96(sp)
    80005618:	eca6                	sd	s1,88(sp)
    8000561a:	e8ca                	sd	s2,80(sp)
    8000561c:	e4ce                	sd	s3,72(sp)
    8000561e:	e0d2                	sd	s4,64(sp)
    80005620:	fc56                	sd	s5,56(sp)
    80005622:	f85a                	sd	s6,48(sp)
    80005624:	f45e                	sd	s7,40(sp)
    80005626:	f062                	sd	s8,32(sp)
    80005628:	ec66                	sd	s9,24(sp)
    8000562a:	1880                	add	s0,sp,112
    8000562c:	8a2a                	mv	s4,a0
    8000562e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005630:	00c52c03          	lw	s8,12(a0)
    80005634:	001c1c1b          	sllw	s8,s8,0x1
    80005638:	1c02                	sll	s8,s8,0x20
    8000563a:	020c5c13          	srl	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000563e:	00018517          	auipc	a0,0x18
    80005642:	aea50513          	add	a0,a0,-1302 # 8001d128 <disk+0x2128>
    80005646:	00001097          	auipc	ra,0x1
    8000564a:	de0080e7          	jalr	-544(ra) # 80006426 <acquire>
  for(int i = 0; i < 3; i++){
    8000564e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005650:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005652:	00016b97          	auipc	s7,0x16
    80005656:	9aeb8b93          	add	s7,s7,-1618 # 8001b000 <disk>
    8000565a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000565c:	4a8d                	li	s5,3
    8000565e:	a88d                	j	800056d0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005660:	00fb8733          	add	a4,s7,a5
    80005664:	975a                	add	a4,a4,s6
    80005666:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000566a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000566c:	0207c563          	bltz	a5,80005696 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005670:	2905                	addw	s2,s2,1
    80005672:	0611                	add	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005674:	1b590163          	beq	s2,s5,80005816 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005678:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000567a:	00018717          	auipc	a4,0x18
    8000567e:	99e70713          	add	a4,a4,-1634 # 8001d018 <disk+0x2018>
    80005682:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005684:	00074683          	lbu	a3,0(a4)
    80005688:	fee1                	bnez	a3,80005660 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000568a:	2785                	addw	a5,a5,1
    8000568c:	0705                	add	a4,a4,1
    8000568e:	fe979be3          	bne	a5,s1,80005684 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005692:	57fd                	li	a5,-1
    80005694:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005696:	03205163          	blez	s2,800056b8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000569a:	f9042503          	lw	a0,-112(s0)
    8000569e:	00000097          	auipc	ra,0x0
    800056a2:	d7c080e7          	jalr	-644(ra) # 8000541a <free_desc>
      for(int j = 0; j < i; j++)
    800056a6:	4785                	li	a5,1
    800056a8:	0127d863          	bge	a5,s2,800056b8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800056ac:	f9442503          	lw	a0,-108(s0)
    800056b0:	00000097          	auipc	ra,0x0
    800056b4:	d6a080e7          	jalr	-662(ra) # 8000541a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056b8:	00018597          	auipc	a1,0x18
    800056bc:	a7058593          	add	a1,a1,-1424 # 8001d128 <disk+0x2128>
    800056c0:	00018517          	auipc	a0,0x18
    800056c4:	95850513          	add	a0,a0,-1704 # 8001d018 <disk+0x2018>
    800056c8:	ffffc097          	auipc	ra,0xffffc
    800056cc:	fd8080e7          	jalr	-40(ra) # 800016a0 <sleep>
  for(int i = 0; i < 3; i++){
    800056d0:	f9040613          	add	a2,s0,-112
    800056d4:	894e                	mv	s2,s3
    800056d6:	b74d                	j	80005678 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056d8:	00018717          	auipc	a4,0x18
    800056dc:	92873703          	ld	a4,-1752(a4) # 8001d000 <disk+0x2000>
    800056e0:	973e                	add	a4,a4,a5
    800056e2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056e6:	00016897          	auipc	a7,0x16
    800056ea:	91a88893          	add	a7,a7,-1766 # 8001b000 <disk>
    800056ee:	00018717          	auipc	a4,0x18
    800056f2:	91270713          	add	a4,a4,-1774 # 8001d000 <disk+0x2000>
    800056f6:	6314                	ld	a3,0(a4)
    800056f8:	96be                	add	a3,a3,a5
    800056fa:	00c6d583          	lhu	a1,12(a3)
    800056fe:	0015e593          	or	a1,a1,1
    80005702:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005706:	f9842683          	lw	a3,-104(s0)
    8000570a:	630c                	ld	a1,0(a4)
    8000570c:	97ae                	add	a5,a5,a1
    8000570e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005712:	20050593          	add	a1,a0,512
    80005716:	0592                	sll	a1,a1,0x4
    80005718:	95c6                	add	a1,a1,a7
    8000571a:	57fd                	li	a5,-1
    8000571c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005720:	00469793          	sll	a5,a3,0x4
    80005724:	00073803          	ld	a6,0(a4)
    80005728:	983e                	add	a6,a6,a5
    8000572a:	6689                	lui	a3,0x2
    8000572c:	03068693          	add	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005730:	96b2                	add	a3,a3,a2
    80005732:	96c6                	add	a3,a3,a7
    80005734:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005738:	6314                	ld	a3,0(a4)
    8000573a:	96be                	add	a3,a3,a5
    8000573c:	4605                	li	a2,1
    8000573e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005740:	6314                	ld	a3,0(a4)
    80005742:	96be                	add	a3,a3,a5
    80005744:	4809                	li	a6,2
    80005746:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000574a:	6314                	ld	a3,0(a4)
    8000574c:	97b6                	add	a5,a5,a3
    8000574e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005752:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005756:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000575a:	6714                	ld	a3,8(a4)
    8000575c:	0026d783          	lhu	a5,2(a3)
    80005760:	8b9d                	and	a5,a5,7
    80005762:	0786                	sll	a5,a5,0x1
    80005764:	96be                	add	a3,a3,a5
    80005766:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000576a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000576e:	6718                	ld	a4,8(a4)
    80005770:	00275783          	lhu	a5,2(a4)
    80005774:	2785                	addw	a5,a5,1
    80005776:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000577a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000577e:	100017b7          	lui	a5,0x10001
    80005782:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005786:	004a2783          	lw	a5,4(s4)
    8000578a:	02c79163          	bne	a5,a2,800057ac <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000578e:	00018917          	auipc	s2,0x18
    80005792:	99a90913          	add	s2,s2,-1638 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005796:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005798:	85ca                	mv	a1,s2
    8000579a:	8552                	mv	a0,s4
    8000579c:	ffffc097          	auipc	ra,0xffffc
    800057a0:	f04080e7          	jalr	-252(ra) # 800016a0 <sleep>
  while(b->disk == 1) {
    800057a4:	004a2783          	lw	a5,4(s4)
    800057a8:	fe9788e3          	beq	a5,s1,80005798 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    800057ac:	f9042903          	lw	s2,-112(s0)
    800057b0:	20090713          	add	a4,s2,512
    800057b4:	0712                	sll	a4,a4,0x4
    800057b6:	00016797          	auipc	a5,0x16
    800057ba:	84a78793          	add	a5,a5,-1974 # 8001b000 <disk>
    800057be:	97ba                	add	a5,a5,a4
    800057c0:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800057c4:	00018997          	auipc	s3,0x18
    800057c8:	83c98993          	add	s3,s3,-1988 # 8001d000 <disk+0x2000>
    800057cc:	00491713          	sll	a4,s2,0x4
    800057d0:	0009b783          	ld	a5,0(s3)
    800057d4:	97ba                	add	a5,a5,a4
    800057d6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057da:	854a                	mv	a0,s2
    800057dc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057e0:	00000097          	auipc	ra,0x0
    800057e4:	c3a080e7          	jalr	-966(ra) # 8000541a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057e8:	8885                	and	s1,s1,1
    800057ea:	f0ed                	bnez	s1,800057cc <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057ec:	00018517          	auipc	a0,0x18
    800057f0:	93c50513          	add	a0,a0,-1732 # 8001d128 <disk+0x2128>
    800057f4:	00001097          	auipc	ra,0x1
    800057f8:	ce6080e7          	jalr	-794(ra) # 800064da <release>
}
    800057fc:	70a6                	ld	ra,104(sp)
    800057fe:	7406                	ld	s0,96(sp)
    80005800:	64e6                	ld	s1,88(sp)
    80005802:	6946                	ld	s2,80(sp)
    80005804:	69a6                	ld	s3,72(sp)
    80005806:	6a06                	ld	s4,64(sp)
    80005808:	7ae2                	ld	s5,56(sp)
    8000580a:	7b42                	ld	s6,48(sp)
    8000580c:	7ba2                	ld	s7,40(sp)
    8000580e:	7c02                	ld	s8,32(sp)
    80005810:	6ce2                	ld	s9,24(sp)
    80005812:	6165                	add	sp,sp,112
    80005814:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005816:	f9042503          	lw	a0,-112(s0)
    8000581a:	00451613          	sll	a2,a0,0x4
  if(write)
    8000581e:	00015597          	auipc	a1,0x15
    80005822:	7e258593          	add	a1,a1,2018 # 8001b000 <disk>
    80005826:	20050793          	add	a5,a0,512
    8000582a:	0792                	sll	a5,a5,0x4
    8000582c:	97ae                	add	a5,a5,a1
    8000582e:	01903733          	snez	a4,s9
    80005832:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005836:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000583a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000583e:	00017717          	auipc	a4,0x17
    80005842:	7c270713          	add	a4,a4,1986 # 8001d000 <disk+0x2000>
    80005846:	6314                	ld	a3,0(a4)
    80005848:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000584a:	6789                	lui	a5,0x2
    8000584c:	0a878793          	add	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005850:	97b2                	add	a5,a5,a2
    80005852:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005854:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005856:	631c                	ld	a5,0(a4)
    80005858:	97b2                	add	a5,a5,a2
    8000585a:	46c1                	li	a3,16
    8000585c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000585e:	631c                	ld	a5,0(a4)
    80005860:	97b2                	add	a5,a5,a2
    80005862:	4685                	li	a3,1
    80005864:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005868:	f9442783          	lw	a5,-108(s0)
    8000586c:	6314                	ld	a3,0(a4)
    8000586e:	96b2                	add	a3,a3,a2
    80005870:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005874:	0792                	sll	a5,a5,0x4
    80005876:	6314                	ld	a3,0(a4)
    80005878:	96be                	add	a3,a3,a5
    8000587a:	058a0593          	add	a1,s4,88
    8000587e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005880:	6318                	ld	a4,0(a4)
    80005882:	973e                	add	a4,a4,a5
    80005884:	40000693          	li	a3,1024
    80005888:	c714                	sw	a3,8(a4)
  if(write)
    8000588a:	e40c97e3          	bnez	s9,800056d8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000588e:	00017717          	auipc	a4,0x17
    80005892:	77273703          	ld	a4,1906(a4) # 8001d000 <disk+0x2000>
    80005896:	973e                	add	a4,a4,a5
    80005898:	4689                	li	a3,2
    8000589a:	00d71623          	sh	a3,12(a4)
    8000589e:	b5a1                	j	800056e6 <virtio_disk_rw+0xd4>

00000000800058a0 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058a0:	1101                	add	sp,sp,-32
    800058a2:	ec06                	sd	ra,24(sp)
    800058a4:	e822                	sd	s0,16(sp)
    800058a6:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058a8:	00018517          	auipc	a0,0x18
    800058ac:	88050513          	add	a0,a0,-1920 # 8001d128 <disk+0x2128>
    800058b0:	00001097          	auipc	ra,0x1
    800058b4:	b76080e7          	jalr	-1162(ra) # 80006426 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058b8:	100017b7          	lui	a5,0x10001
    800058bc:	53b8                	lw	a4,96(a5)
    800058be:	8b0d                	and	a4,a4,3
    800058c0:	100017b7          	lui	a5,0x10001
    800058c4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800058c6:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058ca:	00017797          	auipc	a5,0x17
    800058ce:	73678793          	add	a5,a5,1846 # 8001d000 <disk+0x2000>
    800058d2:	6b94                	ld	a3,16(a5)
    800058d4:	0207d703          	lhu	a4,32(a5)
    800058d8:	0026d783          	lhu	a5,2(a3)
    800058dc:	06f70563          	beq	a4,a5,80005946 <virtio_disk_intr+0xa6>
    800058e0:	e426                	sd	s1,8(sp)
    800058e2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058e4:	00015917          	auipc	s2,0x15
    800058e8:	71c90913          	add	s2,s2,1820 # 8001b000 <disk>
    800058ec:	00017497          	auipc	s1,0x17
    800058f0:	71448493          	add	s1,s1,1812 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800058f4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058f8:	6898                	ld	a4,16(s1)
    800058fa:	0204d783          	lhu	a5,32(s1)
    800058fe:	8b9d                	and	a5,a5,7
    80005900:	078e                	sll	a5,a5,0x3
    80005902:	97ba                	add	a5,a5,a4
    80005904:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005906:	20078713          	add	a4,a5,512
    8000590a:	0712                	sll	a4,a4,0x4
    8000590c:	974a                	add	a4,a4,s2
    8000590e:	03074703          	lbu	a4,48(a4)
    80005912:	e731                	bnez	a4,8000595e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005914:	20078793          	add	a5,a5,512
    80005918:	0792                	sll	a5,a5,0x4
    8000591a:	97ca                	add	a5,a5,s2
    8000591c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000591e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005922:	ffffc097          	auipc	ra,0xffffc
    80005926:	f0a080e7          	jalr	-246(ra) # 8000182c <wakeup>

    disk.used_idx += 1;
    8000592a:	0204d783          	lhu	a5,32(s1)
    8000592e:	2785                	addw	a5,a5,1
    80005930:	17c2                	sll	a5,a5,0x30
    80005932:	93c1                	srl	a5,a5,0x30
    80005934:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005938:	6898                	ld	a4,16(s1)
    8000593a:	00275703          	lhu	a4,2(a4)
    8000593e:	faf71be3          	bne	a4,a5,800058f4 <virtio_disk_intr+0x54>
    80005942:	64a2                	ld	s1,8(sp)
    80005944:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005946:	00017517          	auipc	a0,0x17
    8000594a:	7e250513          	add	a0,a0,2018 # 8001d128 <disk+0x2128>
    8000594e:	00001097          	auipc	ra,0x1
    80005952:	b8c080e7          	jalr	-1140(ra) # 800064da <release>
}
    80005956:	60e2                	ld	ra,24(sp)
    80005958:	6442                	ld	s0,16(sp)
    8000595a:	6105                	add	sp,sp,32
    8000595c:	8082                	ret
      panic("virtio_disk_intr status");
    8000595e:	00003517          	auipc	a0,0x3
    80005962:	d6a50513          	add	a0,a0,-662 # 800086c8 <etext+0x6c8>
    80005966:	00000097          	auipc	ra,0x0
    8000596a:	546080e7          	jalr	1350(ra) # 80005eac <panic>

000000008000596e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000596e:	1141                	add	sp,sp,-16
    80005970:	e422                	sd	s0,8(sp)
    80005972:	0800                	add	s0,sp,16
    asm volatile("csrr %0, mhartid" : "=r"(x));
    80005974:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005978:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000597c:	0037979b          	sllw	a5,a5,0x3
    80005980:	02004737          	lui	a4,0x2004
    80005984:	97ba                	add	a5,a5,a4
    80005986:	0200c737          	lui	a4,0x200c
    8000598a:	1761                	add	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000598c:	6318                	ld	a4,0(a4)
    8000598e:	000f4637          	lui	a2,0xf4
    80005992:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005996:	9732                	add	a4,a4,a2
    80005998:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000599a:	00259693          	sll	a3,a1,0x2
    8000599e:	96ae                	add	a3,a3,a1
    800059a0:	068e                	sll	a3,a3,0x3
    800059a2:	00018717          	auipc	a4,0x18
    800059a6:	65e70713          	add	a4,a4,1630 # 8001e000 <timer_scratch>
    800059aa:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059ac:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059ae:	f310                	sd	a2,32(a4)
    asm volatile("csrw mscratch, %0" : : "r"(x));
    800059b0:	34071073          	csrw	mscratch,a4
    asm volatile("csrw mtvec, %0" : : "r"(x));
    800059b4:	00000797          	auipc	a5,0x0
    800059b8:	99c78793          	add	a5,a5,-1636 # 80005350 <timervec>
    800059bc:	30579073          	csrw	mtvec,a5
    asm volatile("csrr %0, mstatus" : "=r"(x));
    800059c0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059c4:	0087e793          	or	a5,a5,8
    asm volatile("csrw mstatus, %0" : : "r"(x));
    800059c8:	30079073          	csrw	mstatus,a5
    asm volatile("csrr %0, mie" : "=r"(x));
    800059cc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059d0:	0807e793          	or	a5,a5,128
    asm volatile("csrw mie, %0" : : "r"(x));
    800059d4:	30479073          	csrw	mie,a5
}
    800059d8:	6422                	ld	s0,8(sp)
    800059da:	0141                	add	sp,sp,16
    800059dc:	8082                	ret

00000000800059de <start>:
{
    800059de:	1141                	add	sp,sp,-16
    800059e0:	e406                	sd	ra,8(sp)
    800059e2:	e022                	sd	s0,0(sp)
    800059e4:	0800                	add	s0,sp,16
    asm volatile("csrr %0, mstatus" : "=r"(x));
    800059e6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059ea:	7779                	lui	a4,0xffffe
    800059ec:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800059f0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059f2:	6705                	lui	a4,0x1
    800059f4:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059f8:	8fd9                	or	a5,a5,a4
    asm volatile("csrw mstatus, %0" : : "r"(x));
    800059fa:	30079073          	csrw	mstatus,a5
    asm volatile("csrw mepc, %0" : : "r"(x));
    800059fe:	ffffb797          	auipc	a5,0xffffb
    80005a02:	91a78793          	add	a5,a5,-1766 # 80000318 <main>
    80005a06:	34179073          	csrw	mepc,a5
    asm volatile("csrw satp, %0" : : "r"(x));
    80005a0a:	4781                	li	a5,0
    80005a0c:	18079073          	csrw	satp,a5
    asm volatile("csrw medeleg, %0" : : "r"(x));
    80005a10:	67c1                	lui	a5,0x10
    80005a12:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a14:	30279073          	csrw	medeleg,a5
    asm volatile("csrw mideleg, %0" : : "r"(x));
    80005a18:	30379073          	csrw	mideleg,a5
    asm volatile("csrr %0, sie" : "=r"(x));
    80005a1c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a20:	2227e793          	or	a5,a5,546
    asm volatile("csrw sie, %0" : : "r"(x));
    80005a24:	10479073          	csrw	sie,a5
    asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80005a28:	57fd                	li	a5,-1
    80005a2a:	83a9                	srl	a5,a5,0xa
    80005a2c:	3b079073          	csrw	pmpaddr0,a5
    asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    80005a30:	47bd                	li	a5,15
    80005a32:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a36:	00000097          	auipc	ra,0x0
    80005a3a:	f38080e7          	jalr	-200(ra) # 8000596e <timerinit>
    asm volatile("csrr %0, mhartid" : "=r"(x));
    80005a3e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a42:	2781                	sext.w	a5,a5
    asm volatile("mv tp, %0" : : "r"(x));
    80005a44:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a46:	30200073          	mret
}
    80005a4a:	60a2                	ld	ra,8(sp)
    80005a4c:	6402                	ld	s0,0(sp)
    80005a4e:	0141                	add	sp,sp,16
    80005a50:	8082                	ret

0000000080005a52 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a52:	715d                	add	sp,sp,-80
    80005a54:	e486                	sd	ra,72(sp)
    80005a56:	e0a2                	sd	s0,64(sp)
    80005a58:	f84a                	sd	s2,48(sp)
    80005a5a:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a5c:	04c05663          	blez	a2,80005aa8 <consolewrite+0x56>
    80005a60:	fc26                	sd	s1,56(sp)
    80005a62:	f44e                	sd	s3,40(sp)
    80005a64:	f052                	sd	s4,32(sp)
    80005a66:	ec56                	sd	s5,24(sp)
    80005a68:	8a2a                	mv	s4,a0
    80005a6a:	84ae                	mv	s1,a1
    80005a6c:	89b2                	mv	s3,a2
    80005a6e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a70:	5afd                	li	s5,-1
    80005a72:	4685                	li	a3,1
    80005a74:	8626                	mv	a2,s1
    80005a76:	85d2                	mv	a1,s4
    80005a78:	fbf40513          	add	a0,s0,-65
    80005a7c:	ffffc097          	auipc	ra,0xffffc
    80005a80:	01e080e7          	jalr	30(ra) # 80001a9a <either_copyin>
    80005a84:	03550463          	beq	a0,s5,80005aac <consolewrite+0x5a>
      break;
    uartputc(c);
    80005a88:	fbf44503          	lbu	a0,-65(s0)
    80005a8c:	00000097          	auipc	ra,0x0
    80005a90:	7de080e7          	jalr	2014(ra) # 8000626a <uartputc>
  for(i = 0; i < n; i++){
    80005a94:	2905                	addw	s2,s2,1
    80005a96:	0485                	add	s1,s1,1
    80005a98:	fd299de3          	bne	s3,s2,80005a72 <consolewrite+0x20>
    80005a9c:	894e                	mv	s2,s3
    80005a9e:	74e2                	ld	s1,56(sp)
    80005aa0:	79a2                	ld	s3,40(sp)
    80005aa2:	7a02                	ld	s4,32(sp)
    80005aa4:	6ae2                	ld	s5,24(sp)
    80005aa6:	a039                	j	80005ab4 <consolewrite+0x62>
    80005aa8:	4901                	li	s2,0
    80005aaa:	a029                	j	80005ab4 <consolewrite+0x62>
    80005aac:	74e2                	ld	s1,56(sp)
    80005aae:	79a2                	ld	s3,40(sp)
    80005ab0:	7a02                	ld	s4,32(sp)
    80005ab2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005ab4:	854a                	mv	a0,s2
    80005ab6:	60a6                	ld	ra,72(sp)
    80005ab8:	6406                	ld	s0,64(sp)
    80005aba:	7942                	ld	s2,48(sp)
    80005abc:	6161                	add	sp,sp,80
    80005abe:	8082                	ret

0000000080005ac0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005ac0:	711d                	add	sp,sp,-96
    80005ac2:	ec86                	sd	ra,88(sp)
    80005ac4:	e8a2                	sd	s0,80(sp)
    80005ac6:	e4a6                	sd	s1,72(sp)
    80005ac8:	e0ca                	sd	s2,64(sp)
    80005aca:	fc4e                	sd	s3,56(sp)
    80005acc:	f852                	sd	s4,48(sp)
    80005ace:	f456                	sd	s5,40(sp)
    80005ad0:	f05a                	sd	s6,32(sp)
    80005ad2:	1080                	add	s0,sp,96
    80005ad4:	8aaa                	mv	s5,a0
    80005ad6:	8a2e                	mv	s4,a1
    80005ad8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ada:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005ade:	00020517          	auipc	a0,0x20
    80005ae2:	66250513          	add	a0,a0,1634 # 80026140 <cons>
    80005ae6:	00001097          	auipc	ra,0x1
    80005aea:	940080e7          	jalr	-1728(ra) # 80006426 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005aee:	00020497          	auipc	s1,0x20
    80005af2:	65248493          	add	s1,s1,1618 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005af6:	00020917          	auipc	s2,0x20
    80005afa:	6e290913          	add	s2,s2,1762 # 800261d8 <cons+0x98>
  while(n > 0){
    80005afe:	0d305463          	blez	s3,80005bc6 <consoleread+0x106>
    while(cons.r == cons.w){
    80005b02:	0984a783          	lw	a5,152(s1)
    80005b06:	09c4a703          	lw	a4,156(s1)
    80005b0a:	0af71963          	bne	a4,a5,80005bbc <consoleread+0xfc>
      if(myproc()->killed){
    80005b0e:	ffffb097          	auipc	ra,0xffffb
    80005b12:	430080e7          	jalr	1072(ra) # 80000f3e <myproc>
    80005b16:	551c                	lw	a5,40(a0)
    80005b18:	e7ad                	bnez	a5,80005b82 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005b1a:	85a6                	mv	a1,s1
    80005b1c:	854a                	mv	a0,s2
    80005b1e:	ffffc097          	auipc	ra,0xffffc
    80005b22:	b82080e7          	jalr	-1150(ra) # 800016a0 <sleep>
    while(cons.r == cons.w){
    80005b26:	0984a783          	lw	a5,152(s1)
    80005b2a:	09c4a703          	lw	a4,156(s1)
    80005b2e:	fef700e3          	beq	a4,a5,80005b0e <consoleread+0x4e>
    80005b32:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005b34:	00020717          	auipc	a4,0x20
    80005b38:	60c70713          	add	a4,a4,1548 # 80026140 <cons>
    80005b3c:	0017869b          	addw	a3,a5,1
    80005b40:	08d72c23          	sw	a3,152(a4)
    80005b44:	07f7f693          	and	a3,a5,127
    80005b48:	9736                	add	a4,a4,a3
    80005b4a:	01874703          	lbu	a4,24(a4)
    80005b4e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005b52:	4691                	li	a3,4
    80005b54:	04db8a63          	beq	s7,a3,80005ba8 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005b58:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b5c:	4685                	li	a3,1
    80005b5e:	faf40613          	add	a2,s0,-81
    80005b62:	85d2                	mv	a1,s4
    80005b64:	8556                	mv	a0,s5
    80005b66:	ffffc097          	auipc	ra,0xffffc
    80005b6a:	ede080e7          	jalr	-290(ra) # 80001a44 <either_copyout>
    80005b6e:	57fd                	li	a5,-1
    80005b70:	04f50a63          	beq	a0,a5,80005bc4 <consoleread+0x104>
      break;

    dst++;
    80005b74:	0a05                	add	s4,s4,1
    --n;
    80005b76:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80005b78:	47a9                	li	a5,10
    80005b7a:	06fb8163          	beq	s7,a5,80005bdc <consoleread+0x11c>
    80005b7e:	6be2                	ld	s7,24(sp)
    80005b80:	bfbd                	j	80005afe <consoleread+0x3e>
        release(&cons.lock);
    80005b82:	00020517          	auipc	a0,0x20
    80005b86:	5be50513          	add	a0,a0,1470 # 80026140 <cons>
    80005b8a:	00001097          	auipc	ra,0x1
    80005b8e:	950080e7          	jalr	-1712(ra) # 800064da <release>
        return -1;
    80005b92:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005b94:	60e6                	ld	ra,88(sp)
    80005b96:	6446                	ld	s0,80(sp)
    80005b98:	64a6                	ld	s1,72(sp)
    80005b9a:	6906                	ld	s2,64(sp)
    80005b9c:	79e2                	ld	s3,56(sp)
    80005b9e:	7a42                	ld	s4,48(sp)
    80005ba0:	7aa2                	ld	s5,40(sp)
    80005ba2:	7b02                	ld	s6,32(sp)
    80005ba4:	6125                	add	sp,sp,96
    80005ba6:	8082                	ret
      if(n < target){
    80005ba8:	0009871b          	sext.w	a4,s3
    80005bac:	01677a63          	bgeu	a4,s6,80005bc0 <consoleread+0x100>
        cons.r--;
    80005bb0:	00020717          	auipc	a4,0x20
    80005bb4:	62f72423          	sw	a5,1576(a4) # 800261d8 <cons+0x98>
    80005bb8:	6be2                	ld	s7,24(sp)
    80005bba:	a031                	j	80005bc6 <consoleread+0x106>
    80005bbc:	ec5e                	sd	s7,24(sp)
    80005bbe:	bf9d                	j	80005b34 <consoleread+0x74>
    80005bc0:	6be2                	ld	s7,24(sp)
    80005bc2:	a011                	j	80005bc6 <consoleread+0x106>
    80005bc4:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005bc6:	00020517          	auipc	a0,0x20
    80005bca:	57a50513          	add	a0,a0,1402 # 80026140 <cons>
    80005bce:	00001097          	auipc	ra,0x1
    80005bd2:	90c080e7          	jalr	-1780(ra) # 800064da <release>
  return target - n;
    80005bd6:	413b053b          	subw	a0,s6,s3
    80005bda:	bf6d                	j	80005b94 <consoleread+0xd4>
    80005bdc:	6be2                	ld	s7,24(sp)
    80005bde:	b7e5                	j	80005bc6 <consoleread+0x106>

0000000080005be0 <consputc>:
{
    80005be0:	1141                	add	sp,sp,-16
    80005be2:	e406                	sd	ra,8(sp)
    80005be4:	e022                	sd	s0,0(sp)
    80005be6:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80005be8:	10000793          	li	a5,256
    80005bec:	00f50a63          	beq	a0,a5,80005c00 <consputc+0x20>
    uartputc_sync(c);
    80005bf0:	00000097          	auipc	ra,0x0
    80005bf4:	59c080e7          	jalr	1436(ra) # 8000618c <uartputc_sync>
}
    80005bf8:	60a2                	ld	ra,8(sp)
    80005bfa:	6402                	ld	s0,0(sp)
    80005bfc:	0141                	add	sp,sp,16
    80005bfe:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c00:	4521                	li	a0,8
    80005c02:	00000097          	auipc	ra,0x0
    80005c06:	58a080e7          	jalr	1418(ra) # 8000618c <uartputc_sync>
    80005c0a:	02000513          	li	a0,32
    80005c0e:	00000097          	auipc	ra,0x0
    80005c12:	57e080e7          	jalr	1406(ra) # 8000618c <uartputc_sync>
    80005c16:	4521                	li	a0,8
    80005c18:	00000097          	auipc	ra,0x0
    80005c1c:	574080e7          	jalr	1396(ra) # 8000618c <uartputc_sync>
    80005c20:	bfe1                	j	80005bf8 <consputc+0x18>

0000000080005c22 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c22:	1101                	add	sp,sp,-32
    80005c24:	ec06                	sd	ra,24(sp)
    80005c26:	e822                	sd	s0,16(sp)
    80005c28:	e426                	sd	s1,8(sp)
    80005c2a:	1000                	add	s0,sp,32
    80005c2c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c2e:	00020517          	auipc	a0,0x20
    80005c32:	51250513          	add	a0,a0,1298 # 80026140 <cons>
    80005c36:	00000097          	auipc	ra,0x0
    80005c3a:	7f0080e7          	jalr	2032(ra) # 80006426 <acquire>

  switch(c){
    80005c3e:	47d5                	li	a5,21
    80005c40:	0af48563          	beq	s1,a5,80005cea <consoleintr+0xc8>
    80005c44:	0297c963          	blt	a5,s1,80005c76 <consoleintr+0x54>
    80005c48:	47a1                	li	a5,8
    80005c4a:	0ef48c63          	beq	s1,a5,80005d42 <consoleintr+0x120>
    80005c4e:	47c1                	li	a5,16
    80005c50:	10f49f63          	bne	s1,a5,80005d6e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005c54:	ffffc097          	auipc	ra,0xffffc
    80005c58:	e9c080e7          	jalr	-356(ra) # 80001af0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c5c:	00020517          	auipc	a0,0x20
    80005c60:	4e450513          	add	a0,a0,1252 # 80026140 <cons>
    80005c64:	00001097          	auipc	ra,0x1
    80005c68:	876080e7          	jalr	-1930(ra) # 800064da <release>
}
    80005c6c:	60e2                	ld	ra,24(sp)
    80005c6e:	6442                	ld	s0,16(sp)
    80005c70:	64a2                	ld	s1,8(sp)
    80005c72:	6105                	add	sp,sp,32
    80005c74:	8082                	ret
  switch(c){
    80005c76:	07f00793          	li	a5,127
    80005c7a:	0cf48463          	beq	s1,a5,80005d42 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c7e:	00020717          	auipc	a4,0x20
    80005c82:	4c270713          	add	a4,a4,1218 # 80026140 <cons>
    80005c86:	0a072783          	lw	a5,160(a4)
    80005c8a:	09872703          	lw	a4,152(a4)
    80005c8e:	9f99                	subw	a5,a5,a4
    80005c90:	07f00713          	li	a4,127
    80005c94:	fcf764e3          	bltu	a4,a5,80005c5c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005c98:	47b5                	li	a5,13
    80005c9a:	0cf48d63          	beq	s1,a5,80005d74 <consoleintr+0x152>
      consputc(c);
    80005c9e:	8526                	mv	a0,s1
    80005ca0:	00000097          	auipc	ra,0x0
    80005ca4:	f40080e7          	jalr	-192(ra) # 80005be0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ca8:	00020797          	auipc	a5,0x20
    80005cac:	49878793          	add	a5,a5,1176 # 80026140 <cons>
    80005cb0:	0a07a703          	lw	a4,160(a5)
    80005cb4:	0017069b          	addw	a3,a4,1
    80005cb8:	0006861b          	sext.w	a2,a3
    80005cbc:	0ad7a023          	sw	a3,160(a5)
    80005cc0:	07f77713          	and	a4,a4,127
    80005cc4:	97ba                	add	a5,a5,a4
    80005cc6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005cca:	47a9                	li	a5,10
    80005ccc:	0cf48b63          	beq	s1,a5,80005da2 <consoleintr+0x180>
    80005cd0:	4791                	li	a5,4
    80005cd2:	0cf48863          	beq	s1,a5,80005da2 <consoleintr+0x180>
    80005cd6:	00020797          	auipc	a5,0x20
    80005cda:	5027a783          	lw	a5,1282(a5) # 800261d8 <cons+0x98>
    80005cde:	0807879b          	addw	a5,a5,128
    80005ce2:	f6f61de3          	bne	a2,a5,80005c5c <consoleintr+0x3a>
    80005ce6:	863e                	mv	a2,a5
    80005ce8:	a86d                	j	80005da2 <consoleintr+0x180>
    80005cea:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005cec:	00020717          	auipc	a4,0x20
    80005cf0:	45470713          	add	a4,a4,1108 # 80026140 <cons>
    80005cf4:	0a072783          	lw	a5,160(a4)
    80005cf8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005cfc:	00020497          	auipc	s1,0x20
    80005d00:	44448493          	add	s1,s1,1092 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005d04:	4929                	li	s2,10
    80005d06:	02f70a63          	beq	a4,a5,80005d3a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d0a:	37fd                	addw	a5,a5,-1
    80005d0c:	07f7f713          	and	a4,a5,127
    80005d10:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d12:	01874703          	lbu	a4,24(a4)
    80005d16:	03270463          	beq	a4,s2,80005d3e <consoleintr+0x11c>
      cons.e--;
    80005d1a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d1e:	10000513          	li	a0,256
    80005d22:	00000097          	auipc	ra,0x0
    80005d26:	ebe080e7          	jalr	-322(ra) # 80005be0 <consputc>
    while(cons.e != cons.w &&
    80005d2a:	0a04a783          	lw	a5,160(s1)
    80005d2e:	09c4a703          	lw	a4,156(s1)
    80005d32:	fcf71ce3          	bne	a4,a5,80005d0a <consoleintr+0xe8>
    80005d36:	6902                	ld	s2,0(sp)
    80005d38:	b715                	j	80005c5c <consoleintr+0x3a>
    80005d3a:	6902                	ld	s2,0(sp)
    80005d3c:	b705                	j	80005c5c <consoleintr+0x3a>
    80005d3e:	6902                	ld	s2,0(sp)
    80005d40:	bf31                	j	80005c5c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005d42:	00020717          	auipc	a4,0x20
    80005d46:	3fe70713          	add	a4,a4,1022 # 80026140 <cons>
    80005d4a:	0a072783          	lw	a5,160(a4)
    80005d4e:	09c72703          	lw	a4,156(a4)
    80005d52:	f0f705e3          	beq	a4,a5,80005c5c <consoleintr+0x3a>
      cons.e--;
    80005d56:	37fd                	addw	a5,a5,-1
    80005d58:	00020717          	auipc	a4,0x20
    80005d5c:	48f72423          	sw	a5,1160(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d60:	10000513          	li	a0,256
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	e7c080e7          	jalr	-388(ra) # 80005be0 <consputc>
    80005d6c:	bdc5                	j	80005c5c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d6e:	ee0487e3          	beqz	s1,80005c5c <consoleintr+0x3a>
    80005d72:	b731                	j	80005c7e <consoleintr+0x5c>
      consputc(c);
    80005d74:	4529                	li	a0,10
    80005d76:	00000097          	auipc	ra,0x0
    80005d7a:	e6a080e7          	jalr	-406(ra) # 80005be0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d7e:	00020797          	auipc	a5,0x20
    80005d82:	3c278793          	add	a5,a5,962 # 80026140 <cons>
    80005d86:	0a07a703          	lw	a4,160(a5)
    80005d8a:	0017069b          	addw	a3,a4,1
    80005d8e:	0006861b          	sext.w	a2,a3
    80005d92:	0ad7a023          	sw	a3,160(a5)
    80005d96:	07f77713          	and	a4,a4,127
    80005d9a:	97ba                	add	a5,a5,a4
    80005d9c:	4729                	li	a4,10
    80005d9e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005da2:	00020797          	auipc	a5,0x20
    80005da6:	42c7ad23          	sw	a2,1082(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005daa:	00020517          	auipc	a0,0x20
    80005dae:	42e50513          	add	a0,a0,1070 # 800261d8 <cons+0x98>
    80005db2:	ffffc097          	auipc	ra,0xffffc
    80005db6:	a7a080e7          	jalr	-1414(ra) # 8000182c <wakeup>
    80005dba:	b54d                	j	80005c5c <consoleintr+0x3a>

0000000080005dbc <consoleinit>:

void
consoleinit(void)
{
    80005dbc:	1141                	add	sp,sp,-16
    80005dbe:	e406                	sd	ra,8(sp)
    80005dc0:	e022                	sd	s0,0(sp)
    80005dc2:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005dc4:	00003597          	auipc	a1,0x3
    80005dc8:	91c58593          	add	a1,a1,-1764 # 800086e0 <etext+0x6e0>
    80005dcc:	00020517          	auipc	a0,0x20
    80005dd0:	37450513          	add	a0,a0,884 # 80026140 <cons>
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	5c2080e7          	jalr	1474(ra) # 80006396 <initlock>

  uartinit();
    80005ddc:	00000097          	auipc	ra,0x0
    80005de0:	354080e7          	jalr	852(ra) # 80006130 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005de4:	00013797          	auipc	a5,0x13
    80005de8:	4e478793          	add	a5,a5,1252 # 800192c8 <devsw>
    80005dec:	00000717          	auipc	a4,0x0
    80005df0:	cd470713          	add	a4,a4,-812 # 80005ac0 <consoleread>
    80005df4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005df6:	00000717          	auipc	a4,0x0
    80005dfa:	c5c70713          	add	a4,a4,-932 # 80005a52 <consolewrite>
    80005dfe:	ef98                	sd	a4,24(a5)
}
    80005e00:	60a2                	ld	ra,8(sp)
    80005e02:	6402                	ld	s0,0(sp)
    80005e04:	0141                	add	sp,sp,16
    80005e06:	8082                	ret

0000000080005e08 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e08:	7179                	add	sp,sp,-48
    80005e0a:	f406                	sd	ra,40(sp)
    80005e0c:	f022                	sd	s0,32(sp)
    80005e0e:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e10:	c219                	beqz	a2,80005e16 <printint+0xe>
    80005e12:	08054963          	bltz	a0,80005ea4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e16:	2501                	sext.w	a0,a0
    80005e18:	4881                	li	a7,0
    80005e1a:	fd040693          	add	a3,s0,-48

  i = 0;
    80005e1e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e20:	2581                	sext.w	a1,a1
    80005e22:	00003617          	auipc	a2,0x3
    80005e26:	a6660613          	add	a2,a2,-1434 # 80008888 <digits>
    80005e2a:	883a                	mv	a6,a4
    80005e2c:	2705                	addw	a4,a4,1
    80005e2e:	02b577bb          	remuw	a5,a0,a1
    80005e32:	1782                	sll	a5,a5,0x20
    80005e34:	9381                	srl	a5,a5,0x20
    80005e36:	97b2                	add	a5,a5,a2
    80005e38:	0007c783          	lbu	a5,0(a5)
    80005e3c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e40:	0005079b          	sext.w	a5,a0
    80005e44:	02b5553b          	divuw	a0,a0,a1
    80005e48:	0685                	add	a3,a3,1
    80005e4a:	feb7f0e3          	bgeu	a5,a1,80005e2a <printint+0x22>

  if(sign)
    80005e4e:	00088c63          	beqz	a7,80005e66 <printint+0x5e>
    buf[i++] = '-';
    80005e52:	fe070793          	add	a5,a4,-32
    80005e56:	00878733          	add	a4,a5,s0
    80005e5a:	02d00793          	li	a5,45
    80005e5e:	fef70823          	sb	a5,-16(a4)
    80005e62:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005e66:	02e05b63          	blez	a4,80005e9c <printint+0x94>
    80005e6a:	ec26                	sd	s1,24(sp)
    80005e6c:	e84a                	sd	s2,16(sp)
    80005e6e:	fd040793          	add	a5,s0,-48
    80005e72:	00e784b3          	add	s1,a5,a4
    80005e76:	fff78913          	add	s2,a5,-1
    80005e7a:	993a                	add	s2,s2,a4
    80005e7c:	377d                	addw	a4,a4,-1
    80005e7e:	1702                	sll	a4,a4,0x20
    80005e80:	9301                	srl	a4,a4,0x20
    80005e82:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e86:	fff4c503          	lbu	a0,-1(s1)
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	d56080e7          	jalr	-682(ra) # 80005be0 <consputc>
  while(--i >= 0)
    80005e92:	14fd                	add	s1,s1,-1
    80005e94:	ff2499e3          	bne	s1,s2,80005e86 <printint+0x7e>
    80005e98:	64e2                	ld	s1,24(sp)
    80005e9a:	6942                	ld	s2,16(sp)
}
    80005e9c:	70a2                	ld	ra,40(sp)
    80005e9e:	7402                	ld	s0,32(sp)
    80005ea0:	6145                	add	sp,sp,48
    80005ea2:	8082                	ret
    x = -xx;
    80005ea4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ea8:	4885                	li	a7,1
    x = -xx;
    80005eaa:	bf85                	j	80005e1a <printint+0x12>

0000000080005eac <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005eac:	1101                	add	sp,sp,-32
    80005eae:	ec06                	sd	ra,24(sp)
    80005eb0:	e822                	sd	s0,16(sp)
    80005eb2:	e426                	sd	s1,8(sp)
    80005eb4:	1000                	add	s0,sp,32
    80005eb6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005eb8:	00020797          	auipc	a5,0x20
    80005ebc:	3407a423          	sw	zero,840(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005ec0:	00003517          	auipc	a0,0x3
    80005ec4:	82850513          	add	a0,a0,-2008 # 800086e8 <etext+0x6e8>
    80005ec8:	00000097          	auipc	ra,0x0
    80005ecc:	02e080e7          	jalr	46(ra) # 80005ef6 <printf>
  printf(s);
    80005ed0:	8526                	mv	a0,s1
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	024080e7          	jalr	36(ra) # 80005ef6 <printf>
  printf("\n");
    80005eda:	00002517          	auipc	a0,0x2
    80005ede:	13e50513          	add	a0,a0,318 # 80008018 <etext+0x18>
    80005ee2:	00000097          	auipc	ra,0x0
    80005ee6:	014080e7          	jalr	20(ra) # 80005ef6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005eea:	4785                	li	a5,1
    80005eec:	00003717          	auipc	a4,0x3
    80005ef0:	12f72823          	sw	a5,304(a4) # 8000901c <panicked>
  for(;;)
    80005ef4:	a001                	j	80005ef4 <panic+0x48>

0000000080005ef6 <printf>:
{
    80005ef6:	7131                	add	sp,sp,-192
    80005ef8:	fc86                	sd	ra,120(sp)
    80005efa:	f8a2                	sd	s0,112(sp)
    80005efc:	e8d2                	sd	s4,80(sp)
    80005efe:	f06a                	sd	s10,32(sp)
    80005f00:	0100                	add	s0,sp,128
    80005f02:	8a2a                	mv	s4,a0
    80005f04:	e40c                	sd	a1,8(s0)
    80005f06:	e810                	sd	a2,16(s0)
    80005f08:	ec14                	sd	a3,24(s0)
    80005f0a:	f018                	sd	a4,32(s0)
    80005f0c:	f41c                	sd	a5,40(s0)
    80005f0e:	03043823          	sd	a6,48(s0)
    80005f12:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f16:	00020d17          	auipc	s10,0x20
    80005f1a:	2ead2d03          	lw	s10,746(s10) # 80026200 <pr+0x18>
  if(locking)
    80005f1e:	040d1463          	bnez	s10,80005f66 <printf+0x70>
  if (fmt == 0)
    80005f22:	040a0b63          	beqz	s4,80005f78 <printf+0x82>
  va_start(ap, fmt);
    80005f26:	00840793          	add	a5,s0,8
    80005f2a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f2e:	000a4503          	lbu	a0,0(s4)
    80005f32:	18050b63          	beqz	a0,800060c8 <printf+0x1d2>
    80005f36:	f4a6                	sd	s1,104(sp)
    80005f38:	f0ca                	sd	s2,96(sp)
    80005f3a:	ecce                	sd	s3,88(sp)
    80005f3c:	e4d6                	sd	s5,72(sp)
    80005f3e:	e0da                	sd	s6,64(sp)
    80005f40:	fc5e                	sd	s7,56(sp)
    80005f42:	f862                	sd	s8,48(sp)
    80005f44:	f466                	sd	s9,40(sp)
    80005f46:	ec6e                	sd	s11,24(sp)
    80005f48:	4981                	li	s3,0
    if(c != '%'){
    80005f4a:	02500b13          	li	s6,37
    switch(c){
    80005f4e:	07000b93          	li	s7,112
  consputc('x');
    80005f52:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f54:	00003a97          	auipc	s5,0x3
    80005f58:	934a8a93          	add	s5,s5,-1740 # 80008888 <digits>
    switch(c){
    80005f5c:	07300c13          	li	s8,115
    80005f60:	06400d93          	li	s11,100
    80005f64:	a0b1                	j	80005fb0 <printf+0xba>
    acquire(&pr.lock);
    80005f66:	00020517          	auipc	a0,0x20
    80005f6a:	28250513          	add	a0,a0,642 # 800261e8 <pr>
    80005f6e:	00000097          	auipc	ra,0x0
    80005f72:	4b8080e7          	jalr	1208(ra) # 80006426 <acquire>
    80005f76:	b775                	j	80005f22 <printf+0x2c>
    80005f78:	f4a6                	sd	s1,104(sp)
    80005f7a:	f0ca                	sd	s2,96(sp)
    80005f7c:	ecce                	sd	s3,88(sp)
    80005f7e:	e4d6                	sd	s5,72(sp)
    80005f80:	e0da                	sd	s6,64(sp)
    80005f82:	fc5e                	sd	s7,56(sp)
    80005f84:	f862                	sd	s8,48(sp)
    80005f86:	f466                	sd	s9,40(sp)
    80005f88:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005f8a:	00002517          	auipc	a0,0x2
    80005f8e:	76e50513          	add	a0,a0,1902 # 800086f8 <etext+0x6f8>
    80005f92:	00000097          	auipc	ra,0x0
    80005f96:	f1a080e7          	jalr	-230(ra) # 80005eac <panic>
      consputc(c);
    80005f9a:	00000097          	auipc	ra,0x0
    80005f9e:	c46080e7          	jalr	-954(ra) # 80005be0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005fa2:	2985                	addw	s3,s3,1
    80005fa4:	013a07b3          	add	a5,s4,s3
    80005fa8:	0007c503          	lbu	a0,0(a5)
    80005fac:	10050563          	beqz	a0,800060b6 <printf+0x1c0>
    if(c != '%'){
    80005fb0:	ff6515e3          	bne	a0,s6,80005f9a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005fb4:	2985                	addw	s3,s3,1
    80005fb6:	013a07b3          	add	a5,s4,s3
    80005fba:	0007c783          	lbu	a5,0(a5)
    80005fbe:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005fc2:	10078b63          	beqz	a5,800060d8 <printf+0x1e2>
    switch(c){
    80005fc6:	05778a63          	beq	a5,s7,8000601a <printf+0x124>
    80005fca:	02fbf663          	bgeu	s7,a5,80005ff6 <printf+0x100>
    80005fce:	09878863          	beq	a5,s8,8000605e <printf+0x168>
    80005fd2:	07800713          	li	a4,120
    80005fd6:	0ce79563          	bne	a5,a4,800060a0 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005fda:	f8843783          	ld	a5,-120(s0)
    80005fde:	00878713          	add	a4,a5,8
    80005fe2:	f8e43423          	sd	a4,-120(s0)
    80005fe6:	4605                	li	a2,1
    80005fe8:	85e6                	mv	a1,s9
    80005fea:	4388                	lw	a0,0(a5)
    80005fec:	00000097          	auipc	ra,0x0
    80005ff0:	e1c080e7          	jalr	-484(ra) # 80005e08 <printint>
      break;
    80005ff4:	b77d                	j	80005fa2 <printf+0xac>
    switch(c){
    80005ff6:	09678f63          	beq	a5,s6,80006094 <printf+0x19e>
    80005ffa:	0bb79363          	bne	a5,s11,800060a0 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005ffe:	f8843783          	ld	a5,-120(s0)
    80006002:	00878713          	add	a4,a5,8
    80006006:	f8e43423          	sd	a4,-120(s0)
    8000600a:	4605                	li	a2,1
    8000600c:	45a9                	li	a1,10
    8000600e:	4388                	lw	a0,0(a5)
    80006010:	00000097          	auipc	ra,0x0
    80006014:	df8080e7          	jalr	-520(ra) # 80005e08 <printint>
      break;
    80006018:	b769                	j	80005fa2 <printf+0xac>
      printptr(va_arg(ap, uint64));
    8000601a:	f8843783          	ld	a5,-120(s0)
    8000601e:	00878713          	add	a4,a5,8
    80006022:	f8e43423          	sd	a4,-120(s0)
    80006026:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000602a:	03000513          	li	a0,48
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	bb2080e7          	jalr	-1102(ra) # 80005be0 <consputc>
  consputc('x');
    80006036:	07800513          	li	a0,120
    8000603a:	00000097          	auipc	ra,0x0
    8000603e:	ba6080e7          	jalr	-1114(ra) # 80005be0 <consputc>
    80006042:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006044:	03c95793          	srl	a5,s2,0x3c
    80006048:	97d6                	add	a5,a5,s5
    8000604a:	0007c503          	lbu	a0,0(a5)
    8000604e:	00000097          	auipc	ra,0x0
    80006052:	b92080e7          	jalr	-1134(ra) # 80005be0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006056:	0912                	sll	s2,s2,0x4
    80006058:	34fd                	addw	s1,s1,-1
    8000605a:	f4ed                	bnez	s1,80006044 <printf+0x14e>
    8000605c:	b799                	j	80005fa2 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    8000605e:	f8843783          	ld	a5,-120(s0)
    80006062:	00878713          	add	a4,a5,8
    80006066:	f8e43423          	sd	a4,-120(s0)
    8000606a:	6384                	ld	s1,0(a5)
    8000606c:	cc89                	beqz	s1,80006086 <printf+0x190>
      for(; *s; s++)
    8000606e:	0004c503          	lbu	a0,0(s1)
    80006072:	d905                	beqz	a0,80005fa2 <printf+0xac>
        consputc(*s);
    80006074:	00000097          	auipc	ra,0x0
    80006078:	b6c080e7          	jalr	-1172(ra) # 80005be0 <consputc>
      for(; *s; s++)
    8000607c:	0485                	add	s1,s1,1
    8000607e:	0004c503          	lbu	a0,0(s1)
    80006082:	f96d                	bnez	a0,80006074 <printf+0x17e>
    80006084:	bf39                	j	80005fa2 <printf+0xac>
        s = "(null)";
    80006086:	00002497          	auipc	s1,0x2
    8000608a:	66a48493          	add	s1,s1,1642 # 800086f0 <etext+0x6f0>
      for(; *s; s++)
    8000608e:	02800513          	li	a0,40
    80006092:	b7cd                	j	80006074 <printf+0x17e>
      consputc('%');
    80006094:	855a                	mv	a0,s6
    80006096:	00000097          	auipc	ra,0x0
    8000609a:	b4a080e7          	jalr	-1206(ra) # 80005be0 <consputc>
      break;
    8000609e:	b711                	j	80005fa2 <printf+0xac>
      consputc('%');
    800060a0:	855a                	mv	a0,s6
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	b3e080e7          	jalr	-1218(ra) # 80005be0 <consputc>
      consputc(c);
    800060aa:	8526                	mv	a0,s1
    800060ac:	00000097          	auipc	ra,0x0
    800060b0:	b34080e7          	jalr	-1228(ra) # 80005be0 <consputc>
      break;
    800060b4:	b5fd                	j	80005fa2 <printf+0xac>
    800060b6:	74a6                	ld	s1,104(sp)
    800060b8:	7906                	ld	s2,96(sp)
    800060ba:	69e6                	ld	s3,88(sp)
    800060bc:	6aa6                	ld	s5,72(sp)
    800060be:	6b06                	ld	s6,64(sp)
    800060c0:	7be2                	ld	s7,56(sp)
    800060c2:	7c42                	ld	s8,48(sp)
    800060c4:	7ca2                	ld	s9,40(sp)
    800060c6:	6de2                	ld	s11,24(sp)
  if(locking)
    800060c8:	020d1263          	bnez	s10,800060ec <printf+0x1f6>
}
    800060cc:	70e6                	ld	ra,120(sp)
    800060ce:	7446                	ld	s0,112(sp)
    800060d0:	6a46                	ld	s4,80(sp)
    800060d2:	7d02                	ld	s10,32(sp)
    800060d4:	6129                	add	sp,sp,192
    800060d6:	8082                	ret
    800060d8:	74a6                	ld	s1,104(sp)
    800060da:	7906                	ld	s2,96(sp)
    800060dc:	69e6                	ld	s3,88(sp)
    800060de:	6aa6                	ld	s5,72(sp)
    800060e0:	6b06                	ld	s6,64(sp)
    800060e2:	7be2                	ld	s7,56(sp)
    800060e4:	7c42                	ld	s8,48(sp)
    800060e6:	7ca2                	ld	s9,40(sp)
    800060e8:	6de2                	ld	s11,24(sp)
    800060ea:	bff9                	j	800060c8 <printf+0x1d2>
    release(&pr.lock);
    800060ec:	00020517          	auipc	a0,0x20
    800060f0:	0fc50513          	add	a0,a0,252 # 800261e8 <pr>
    800060f4:	00000097          	auipc	ra,0x0
    800060f8:	3e6080e7          	jalr	998(ra) # 800064da <release>
}
    800060fc:	bfc1                	j	800060cc <printf+0x1d6>

00000000800060fe <printfinit>:
    ;
}

void
printfinit(void)
{
    800060fe:	1101                	add	sp,sp,-32
    80006100:	ec06                	sd	ra,24(sp)
    80006102:	e822                	sd	s0,16(sp)
    80006104:	e426                	sd	s1,8(sp)
    80006106:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    80006108:	00020497          	auipc	s1,0x20
    8000610c:	0e048493          	add	s1,s1,224 # 800261e8 <pr>
    80006110:	00002597          	auipc	a1,0x2
    80006114:	5f858593          	add	a1,a1,1528 # 80008708 <etext+0x708>
    80006118:	8526                	mv	a0,s1
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	27c080e7          	jalr	636(ra) # 80006396 <initlock>
  pr.locking = 1;
    80006122:	4785                	li	a5,1
    80006124:	cc9c                	sw	a5,24(s1)
}
    80006126:	60e2                	ld	ra,24(sp)
    80006128:	6442                	ld	s0,16(sp)
    8000612a:	64a2                	ld	s1,8(sp)
    8000612c:	6105                	add	sp,sp,32
    8000612e:	8082                	ret

0000000080006130 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006130:	1141                	add	sp,sp,-16
    80006132:	e406                	sd	ra,8(sp)
    80006134:	e022                	sd	s0,0(sp)
    80006136:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006138:	100007b7          	lui	a5,0x10000
    8000613c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006140:	10000737          	lui	a4,0x10000
    80006144:	f8000693          	li	a3,-128
    80006148:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000614c:	468d                	li	a3,3
    8000614e:	10000637          	lui	a2,0x10000
    80006152:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006156:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000615a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000615e:	10000737          	lui	a4,0x10000
    80006162:	461d                	li	a2,7
    80006164:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006168:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000616c:	00002597          	auipc	a1,0x2
    80006170:	5a458593          	add	a1,a1,1444 # 80008710 <etext+0x710>
    80006174:	00020517          	auipc	a0,0x20
    80006178:	09450513          	add	a0,a0,148 # 80026208 <uart_tx_lock>
    8000617c:	00000097          	auipc	ra,0x0
    80006180:	21a080e7          	jalr	538(ra) # 80006396 <initlock>
}
    80006184:	60a2                	ld	ra,8(sp)
    80006186:	6402                	ld	s0,0(sp)
    80006188:	0141                	add	sp,sp,16
    8000618a:	8082                	ret

000000008000618c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000618c:	1101                	add	sp,sp,-32
    8000618e:	ec06                	sd	ra,24(sp)
    80006190:	e822                	sd	s0,16(sp)
    80006192:	e426                	sd	s1,8(sp)
    80006194:	1000                	add	s0,sp,32
    80006196:	84aa                	mv	s1,a0
  push_off();
    80006198:	00000097          	auipc	ra,0x0
    8000619c:	242080e7          	jalr	578(ra) # 800063da <push_off>

  if(panicked){
    800061a0:	00003797          	auipc	a5,0x3
    800061a4:	e7c7a783          	lw	a5,-388(a5) # 8000901c <panicked>
    800061a8:	eb85                	bnez	a5,800061d8 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061aa:	10000737          	lui	a4,0x10000
    800061ae:	0715                	add	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800061b0:	00074783          	lbu	a5,0(a4)
    800061b4:	0207f793          	and	a5,a5,32
    800061b8:	dfe5                	beqz	a5,800061b0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800061ba:	0ff4f513          	zext.b	a0,s1
    800061be:	100007b7          	lui	a5,0x10000
    800061c2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800061c6:	00000097          	auipc	ra,0x0
    800061ca:	2b4080e7          	jalr	692(ra) # 8000647a <pop_off>
}
    800061ce:	60e2                	ld	ra,24(sp)
    800061d0:	6442                	ld	s0,16(sp)
    800061d2:	64a2                	ld	s1,8(sp)
    800061d4:	6105                	add	sp,sp,32
    800061d6:	8082                	ret
    for(;;)
    800061d8:	a001                	j	800061d8 <uartputc_sync+0x4c>

00000000800061da <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800061da:	00003797          	auipc	a5,0x3
    800061de:	e467b783          	ld	a5,-442(a5) # 80009020 <uart_tx_r>
    800061e2:	00003717          	auipc	a4,0x3
    800061e6:	e4673703          	ld	a4,-442(a4) # 80009028 <uart_tx_w>
    800061ea:	06f70f63          	beq	a4,a5,80006268 <uartstart+0x8e>
{
    800061ee:	7139                	add	sp,sp,-64
    800061f0:	fc06                	sd	ra,56(sp)
    800061f2:	f822                	sd	s0,48(sp)
    800061f4:	f426                	sd	s1,40(sp)
    800061f6:	f04a                	sd	s2,32(sp)
    800061f8:	ec4e                	sd	s3,24(sp)
    800061fa:	e852                	sd	s4,16(sp)
    800061fc:	e456                	sd	s5,8(sp)
    800061fe:	e05a                	sd	s6,0(sp)
    80006200:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006202:	10000937          	lui	s2,0x10000
    80006206:	0915                	add	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006208:	00020a97          	auipc	s5,0x20
    8000620c:	000a8a93          	mv	s5,s5
    uart_tx_r += 1;
    80006210:	00003497          	auipc	s1,0x3
    80006214:	e1048493          	add	s1,s1,-496 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006218:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000621c:	00003997          	auipc	s3,0x3
    80006220:	e0c98993          	add	s3,s3,-500 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006224:	00094703          	lbu	a4,0(s2)
    80006228:	02077713          	and	a4,a4,32
    8000622c:	c705                	beqz	a4,80006254 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000622e:	01f7f713          	and	a4,a5,31
    80006232:	9756                	add	a4,a4,s5
    80006234:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006238:	0785                	add	a5,a5,1
    8000623a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000623c:	8526                	mv	a0,s1
    8000623e:	ffffb097          	auipc	ra,0xffffb
    80006242:	5ee080e7          	jalr	1518(ra) # 8000182c <wakeup>
    WriteReg(THR, c);
    80006246:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000624a:	609c                	ld	a5,0(s1)
    8000624c:	0009b703          	ld	a4,0(s3)
    80006250:	fcf71ae3          	bne	a4,a5,80006224 <uartstart+0x4a>
  }
}
    80006254:	70e2                	ld	ra,56(sp)
    80006256:	7442                	ld	s0,48(sp)
    80006258:	74a2                	ld	s1,40(sp)
    8000625a:	7902                	ld	s2,32(sp)
    8000625c:	69e2                	ld	s3,24(sp)
    8000625e:	6a42                	ld	s4,16(sp)
    80006260:	6aa2                	ld	s5,8(sp)
    80006262:	6b02                	ld	s6,0(sp)
    80006264:	6121                	add	sp,sp,64
    80006266:	8082                	ret
    80006268:	8082                	ret

000000008000626a <uartputc>:
{
    8000626a:	7179                	add	sp,sp,-48
    8000626c:	f406                	sd	ra,40(sp)
    8000626e:	f022                	sd	s0,32(sp)
    80006270:	e052                	sd	s4,0(sp)
    80006272:	1800                	add	s0,sp,48
    80006274:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006276:	00020517          	auipc	a0,0x20
    8000627a:	f9250513          	add	a0,a0,-110 # 80026208 <uart_tx_lock>
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	1a8080e7          	jalr	424(ra) # 80006426 <acquire>
  if(panicked){
    80006286:	00003797          	auipc	a5,0x3
    8000628a:	d967a783          	lw	a5,-618(a5) # 8000901c <panicked>
    8000628e:	c391                	beqz	a5,80006292 <uartputc+0x28>
    for(;;)
    80006290:	a001                	j	80006290 <uartputc+0x26>
    80006292:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006294:	00003717          	auipc	a4,0x3
    80006298:	d9473703          	ld	a4,-620(a4) # 80009028 <uart_tx_w>
    8000629c:	00003797          	auipc	a5,0x3
    800062a0:	d847b783          	ld	a5,-636(a5) # 80009020 <uart_tx_r>
    800062a4:	02078793          	add	a5,a5,32
    800062a8:	02e79f63          	bne	a5,a4,800062e6 <uartputc+0x7c>
    800062ac:	e84a                	sd	s2,16(sp)
    800062ae:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800062b0:	00020997          	auipc	s3,0x20
    800062b4:	f5898993          	add	s3,s3,-168 # 80026208 <uart_tx_lock>
    800062b8:	00003497          	auipc	s1,0x3
    800062bc:	d6848493          	add	s1,s1,-664 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062c0:	00003917          	auipc	s2,0x3
    800062c4:	d6890913          	add	s2,s2,-664 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800062c8:	85ce                	mv	a1,s3
    800062ca:	8526                	mv	a0,s1
    800062cc:	ffffb097          	auipc	ra,0xffffb
    800062d0:	3d4080e7          	jalr	980(ra) # 800016a0 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062d4:	00093703          	ld	a4,0(s2)
    800062d8:	609c                	ld	a5,0(s1)
    800062da:	02078793          	add	a5,a5,32
    800062de:	fee785e3          	beq	a5,a4,800062c8 <uartputc+0x5e>
    800062e2:	6942                	ld	s2,16(sp)
    800062e4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062e6:	00020497          	auipc	s1,0x20
    800062ea:	f2248493          	add	s1,s1,-222 # 80026208 <uart_tx_lock>
    800062ee:	01f77793          	and	a5,a4,31
    800062f2:	97a6                	add	a5,a5,s1
    800062f4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800062f8:	0705                	add	a4,a4,1
    800062fa:	00003797          	auipc	a5,0x3
    800062fe:	d2e7b723          	sd	a4,-722(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006302:	00000097          	auipc	ra,0x0
    80006306:	ed8080e7          	jalr	-296(ra) # 800061da <uartstart>
      release(&uart_tx_lock);
    8000630a:	8526                	mv	a0,s1
    8000630c:	00000097          	auipc	ra,0x0
    80006310:	1ce080e7          	jalr	462(ra) # 800064da <release>
    80006314:	64e2                	ld	s1,24(sp)
}
    80006316:	70a2                	ld	ra,40(sp)
    80006318:	7402                	ld	s0,32(sp)
    8000631a:	6a02                	ld	s4,0(sp)
    8000631c:	6145                	add	sp,sp,48
    8000631e:	8082                	ret

0000000080006320 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006320:	1141                	add	sp,sp,-16
    80006322:	e422                	sd	s0,8(sp)
    80006324:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006326:	100007b7          	lui	a5,0x10000
    8000632a:	0795                	add	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000632c:	0007c783          	lbu	a5,0(a5)
    80006330:	8b85                	and	a5,a5,1
    80006332:	cb81                	beqz	a5,80006342 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006334:	100007b7          	lui	a5,0x10000
    80006338:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000633c:	6422                	ld	s0,8(sp)
    8000633e:	0141                	add	sp,sp,16
    80006340:	8082                	ret
    return -1;
    80006342:	557d                	li	a0,-1
    80006344:	bfe5                	j	8000633c <uartgetc+0x1c>

0000000080006346 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006346:	1101                	add	sp,sp,-32
    80006348:	ec06                	sd	ra,24(sp)
    8000634a:	e822                	sd	s0,16(sp)
    8000634c:	e426                	sd	s1,8(sp)
    8000634e:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006350:	54fd                	li	s1,-1
    80006352:	a029                	j	8000635c <uartintr+0x16>
      break;
    consoleintr(c);
    80006354:	00000097          	auipc	ra,0x0
    80006358:	8ce080e7          	jalr	-1842(ra) # 80005c22 <consoleintr>
    int c = uartgetc();
    8000635c:	00000097          	auipc	ra,0x0
    80006360:	fc4080e7          	jalr	-60(ra) # 80006320 <uartgetc>
    if(c == -1)
    80006364:	fe9518e3          	bne	a0,s1,80006354 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006368:	00020497          	auipc	s1,0x20
    8000636c:	ea048493          	add	s1,s1,-352 # 80026208 <uart_tx_lock>
    80006370:	8526                	mv	a0,s1
    80006372:	00000097          	auipc	ra,0x0
    80006376:	0b4080e7          	jalr	180(ra) # 80006426 <acquire>
  uartstart();
    8000637a:	00000097          	auipc	ra,0x0
    8000637e:	e60080e7          	jalr	-416(ra) # 800061da <uartstart>
  release(&uart_tx_lock);
    80006382:	8526                	mv	a0,s1
    80006384:	00000097          	auipc	ra,0x0
    80006388:	156080e7          	jalr	342(ra) # 800064da <release>
}
    8000638c:	60e2                	ld	ra,24(sp)
    8000638e:	6442                	ld	s0,16(sp)
    80006390:	64a2                	ld	s1,8(sp)
    80006392:	6105                	add	sp,sp,32
    80006394:	8082                	ret

0000000080006396 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006396:	1141                	add	sp,sp,-16
    80006398:	e422                	sd	s0,8(sp)
    8000639a:	0800                	add	s0,sp,16
  lk->name = name;
    8000639c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000639e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800063a2:	00053823          	sd	zero,16(a0)
}
    800063a6:	6422                	ld	s0,8(sp)
    800063a8:	0141                	add	sp,sp,16
    800063aa:	8082                	ret

00000000800063ac <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800063ac:	411c                	lw	a5,0(a0)
    800063ae:	e399                	bnez	a5,800063b4 <holding+0x8>
    800063b0:	4501                	li	a0,0
  return r;
}
    800063b2:	8082                	ret
{
    800063b4:	1101                	add	sp,sp,-32
    800063b6:	ec06                	sd	ra,24(sp)
    800063b8:	e822                	sd	s0,16(sp)
    800063ba:	e426                	sd	s1,8(sp)
    800063bc:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800063be:	6904                	ld	s1,16(a0)
    800063c0:	ffffb097          	auipc	ra,0xffffb
    800063c4:	b62080e7          	jalr	-1182(ra) # 80000f22 <mycpu>
    800063c8:	40a48533          	sub	a0,s1,a0
    800063cc:	00153513          	seqz	a0,a0
}
    800063d0:	60e2                	ld	ra,24(sp)
    800063d2:	6442                	ld	s0,16(sp)
    800063d4:	64a2                	ld	s1,8(sp)
    800063d6:	6105                	add	sp,sp,32
    800063d8:	8082                	ret

00000000800063da <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800063da:	1101                	add	sp,sp,-32
    800063dc:	ec06                	sd	ra,24(sp)
    800063de:	e822                	sd	s0,16(sp)
    800063e0:	e426                	sd	s1,8(sp)
    800063e2:	1000                	add	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800063e4:	100024f3          	csrr	s1,sstatus
    800063e8:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800063ec:	9bf5                	and	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    800063ee:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800063f2:	ffffb097          	auipc	ra,0xffffb
    800063f6:	b30080e7          	jalr	-1232(ra) # 80000f22 <mycpu>
    800063fa:	5d3c                	lw	a5,120(a0)
    800063fc:	cf89                	beqz	a5,80006416 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063fe:	ffffb097          	auipc	ra,0xffffb
    80006402:	b24080e7          	jalr	-1244(ra) # 80000f22 <mycpu>
    80006406:	5d3c                	lw	a5,120(a0)
    80006408:	2785                	addw	a5,a5,1
    8000640a:	dd3c                	sw	a5,120(a0)
}
    8000640c:	60e2                	ld	ra,24(sp)
    8000640e:	6442                	ld	s0,16(sp)
    80006410:	64a2                	ld	s1,8(sp)
    80006412:	6105                	add	sp,sp,32
    80006414:	8082                	ret
    mycpu()->intena = old;
    80006416:	ffffb097          	auipc	ra,0xffffb
    8000641a:	b0c080e7          	jalr	-1268(ra) # 80000f22 <mycpu>
    return (x & SSTATUS_SIE) != 0;
    8000641e:	8085                	srl	s1,s1,0x1
    80006420:	8885                	and	s1,s1,1
    80006422:	dd64                	sw	s1,124(a0)
    80006424:	bfe9                	j	800063fe <push_off+0x24>

0000000080006426 <acquire>:
{
    80006426:	1101                	add	sp,sp,-32
    80006428:	ec06                	sd	ra,24(sp)
    8000642a:	e822                	sd	s0,16(sp)
    8000642c:	e426                	sd	s1,8(sp)
    8000642e:	1000                	add	s0,sp,32
    80006430:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006432:	00000097          	auipc	ra,0x0
    80006436:	fa8080e7          	jalr	-88(ra) # 800063da <push_off>
  if(holding(lk))
    8000643a:	8526                	mv	a0,s1
    8000643c:	00000097          	auipc	ra,0x0
    80006440:	f70080e7          	jalr	-144(ra) # 800063ac <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006444:	4705                	li	a4,1
  if(holding(lk))
    80006446:	e115                	bnez	a0,8000646a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006448:	87ba                	mv	a5,a4
    8000644a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000644e:	2781                	sext.w	a5,a5
    80006450:	ffe5                	bnez	a5,80006448 <acquire+0x22>
  __sync_synchronize();
    80006452:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006456:	ffffb097          	auipc	ra,0xffffb
    8000645a:	acc080e7          	jalr	-1332(ra) # 80000f22 <mycpu>
    8000645e:	e888                	sd	a0,16(s1)
}
    80006460:	60e2                	ld	ra,24(sp)
    80006462:	6442                	ld	s0,16(sp)
    80006464:	64a2                	ld	s1,8(sp)
    80006466:	6105                	add	sp,sp,32
    80006468:	8082                	ret
    panic("acquire");
    8000646a:	00002517          	auipc	a0,0x2
    8000646e:	2ae50513          	add	a0,a0,686 # 80008718 <etext+0x718>
    80006472:	00000097          	auipc	ra,0x0
    80006476:	a3a080e7          	jalr	-1478(ra) # 80005eac <panic>

000000008000647a <pop_off>:

void
pop_off(void)
{
    8000647a:	1141                	add	sp,sp,-16
    8000647c:	e406                	sd	ra,8(sp)
    8000647e:	e022                	sd	s0,0(sp)
    80006480:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80006482:	ffffb097          	auipc	ra,0xffffb
    80006486:	aa0080e7          	jalr	-1376(ra) # 80000f22 <mycpu>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    8000648a:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    8000648e:	8b89                	and	a5,a5,2
  if(intr_get())
    80006490:	e78d                	bnez	a5,800064ba <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006492:	5d3c                	lw	a5,120(a0)
    80006494:	02f05b63          	blez	a5,800064ca <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006498:	37fd                	addw	a5,a5,-1
    8000649a:	0007871b          	sext.w	a4,a5
    8000649e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800064a0:	eb09                	bnez	a4,800064b2 <pop_off+0x38>
    800064a2:	5d7c                	lw	a5,124(a0)
    800064a4:	c799                	beqz	a5,800064b2 <pop_off+0x38>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800064a6:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    800064aa:	0027e793          	or	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    800064ae:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800064b2:	60a2                	ld	ra,8(sp)
    800064b4:	6402                	ld	s0,0(sp)
    800064b6:	0141                	add	sp,sp,16
    800064b8:	8082                	ret
    panic("pop_off - interruptible");
    800064ba:	00002517          	auipc	a0,0x2
    800064be:	26650513          	add	a0,a0,614 # 80008720 <etext+0x720>
    800064c2:	00000097          	auipc	ra,0x0
    800064c6:	9ea080e7          	jalr	-1558(ra) # 80005eac <panic>
    panic("pop_off");
    800064ca:	00002517          	auipc	a0,0x2
    800064ce:	26e50513          	add	a0,a0,622 # 80008738 <etext+0x738>
    800064d2:	00000097          	auipc	ra,0x0
    800064d6:	9da080e7          	jalr	-1574(ra) # 80005eac <panic>

00000000800064da <release>:
{
    800064da:	1101                	add	sp,sp,-32
    800064dc:	ec06                	sd	ra,24(sp)
    800064de:	e822                	sd	s0,16(sp)
    800064e0:	e426                	sd	s1,8(sp)
    800064e2:	1000                	add	s0,sp,32
    800064e4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800064e6:	00000097          	auipc	ra,0x0
    800064ea:	ec6080e7          	jalr	-314(ra) # 800063ac <holding>
    800064ee:	c115                	beqz	a0,80006512 <release+0x38>
  lk->cpu = 0;
    800064f0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064f4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064f8:	0f50000f          	fence	iorw,ow
    800064fc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006500:	00000097          	auipc	ra,0x0
    80006504:	f7a080e7          	jalr	-134(ra) # 8000647a <pop_off>
}
    80006508:	60e2                	ld	ra,24(sp)
    8000650a:	6442                	ld	s0,16(sp)
    8000650c:	64a2                	ld	s1,8(sp)
    8000650e:	6105                	add	sp,sp,32
    80006510:	8082                	ret
    panic("release");
    80006512:	00002517          	auipc	a0,0x2
    80006516:	22e50513          	add	a0,a0,558 # 80008740 <etext+0x740>
    8000651a:	00000097          	auipc	ra,0x0
    8000651e:	992080e7          	jalr	-1646(ra) # 80005eac <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
