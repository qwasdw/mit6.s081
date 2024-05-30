
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
    80000016:	0a9050ef          	jal	800058be <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    8000001c:	1101                	add	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	add	s0,sp,32
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
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
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>

    r = (struct run *)pa;

    acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	add	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	2ac080e7          	jalr	684(ra) # 80006306 <acquire>
    r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
    release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	34c080e7          	jalr	844(ra) # 800063ba <release>
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
    8000008e:	d02080e7          	jalr	-766(ra) # 80005d8c <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	add	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	add	s0,sp,48
    p = (char *)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
        kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
        kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
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
    800000fa:	180080e7          	jalr	384(ra) # 80006276 <initlock>
    freerange(end, (void *)PHYSTOP);
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
    80000132:	1d8080e7          	jalr	472(ra) # 80006306 <acquire>
    r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
    if (r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
        kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	add	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
    release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	274080e7          	jalr	628(ra) # 800063ba <release>

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	070080e7          	jalr	112(ra) # 800001c4 <memset>
    return (void *)r;
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
    80000174:	24a080e7          	jalr	586(ra) # 800063ba <release>
    if (r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <kfreemem>:

// Return the number of physical pages unallocated.
uint64 kfreemem(void)
{
    8000017a:	1101                	add	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	add	s0,sp,32
    struct run *r;
    uint64 total = 0;
    acquire(&kmem.lock);
    80000184:	00009497          	auipc	s1,0x9
    80000188:	eac48493          	add	s1,s1,-340 # 80009030 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	178080e7          	jalr	376(ra) # 80006306 <acquire>
    r = kmem.freelist;
    80000196:	6c9c                	ld	a5,24(s1)
    while (r)
    80000198:	c785                	beqz	a5,800001c0 <kfreemem+0x46>
    uint64 total = 0;
    8000019a:	4481                	li	s1,0
    {
        total += PGSIZE;
    8000019c:	6705                	lui	a4,0x1
    8000019e:	94ba                	add	s1,s1,a4
        r = r->next;
    800001a0:	639c                	ld	a5,0(a5)
    while (r)
    800001a2:	fff5                	bnez	a5,8000019e <kfreemem+0x24>
    }
    release(&kmem.lock);
    800001a4:	00009517          	auipc	a0,0x9
    800001a8:	e8c50513          	add	a0,a0,-372 # 80009030 <kmem>
    800001ac:	00006097          	auipc	ra,0x6
    800001b0:	20e080e7          	jalr	526(ra) # 800063ba <release>
    return total;
}
    800001b4:	8526                	mv	a0,s1
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	add	sp,sp,32
    800001be:	8082                	ret
    uint64 total = 0;
    800001c0:	4481                	li	s1,0
    800001c2:	b7cd                	j	800001a4 <kfreemem+0x2a>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	add	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001ca:	ca19                	beqz	a2,800001e0 <memset+0x1c>
    800001cc:	87aa                	mv	a5,a0
    800001ce:	1602                	sll	a2,a2,0x20
    800001d0:	9201                	srl	a2,a2,0x20
    800001d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001da:	0785                	add	a5,a5,1
    800001dc:	fee79de3          	bne	a5,a4,800001d6 <memset+0x12>
  }
  return dst;
}
    800001e0:	6422                	ld	s0,8(sp)
    800001e2:	0141                	add	sp,sp,16
    800001e4:	8082                	ret

00000000800001e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e6:	1141                	add	sp,sp,-16
    800001e8:	e422                	sd	s0,8(sp)
    800001ea:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ec:	ca05                	beqz	a2,8000021c <memcmp+0x36>
    800001ee:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f2:	1682                	sll	a3,a3,0x20
    800001f4:	9281                	srl	a3,a3,0x20
    800001f6:	0685                	add	a3,a3,1
    800001f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fa:	00054783          	lbu	a5,0(a0)
    800001fe:	0005c703          	lbu	a4,0(a1)
    80000202:	00e79863          	bne	a5,a4,80000212 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000206:	0505                	add	a0,a0,1
    80000208:	0585                	add	a1,a1,1
  while(n-- > 0){
    8000020a:	fed518e3          	bne	a0,a3,800001fa <memcmp+0x14>
  }

  return 0;
    8000020e:	4501                	li	a0,0
    80000210:	a019                	j	80000216 <memcmp+0x30>
      return *s1 - *s2;
    80000212:	40e7853b          	subw	a0,a5,a4
}
    80000216:	6422                	ld	s0,8(sp)
    80000218:	0141                	add	sp,sp,16
    8000021a:	8082                	ret
  return 0;
    8000021c:	4501                	li	a0,0
    8000021e:	bfe5                	j	80000216 <memcmp+0x30>

0000000080000220 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000220:	1141                	add	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000226:	c205                	beqz	a2,80000246 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000228:	02a5e263          	bltu	a1,a0,8000024c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022c:	1602                	sll	a2,a2,0x20
    8000022e:	9201                	srl	a2,a2,0x20
    80000230:	00c587b3          	add	a5,a1,a2
{
    80000234:	872a                	mv	a4,a0
      *d++ = *s++;
    80000236:	0585                	add	a1,a1,1
    80000238:	0705                	add	a4,a4,1 # 1001 <_entry-0x7fffefff>
    8000023a:	fff5c683          	lbu	a3,-1(a1)
    8000023e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000242:	feb79ae3          	bne	a5,a1,80000236 <memmove+0x16>

  return dst;
}
    80000246:	6422                	ld	s0,8(sp)
    80000248:	0141                	add	sp,sp,16
    8000024a:	8082                	ret
  if(s < d && s + n > d){
    8000024c:	02061693          	sll	a3,a2,0x20
    80000250:	9281                	srl	a3,a3,0x20
    80000252:	00d58733          	add	a4,a1,a3
    80000256:	fce57be3          	bgeu	a0,a4,8000022c <memmove+0xc>
    d += n;
    8000025a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025c:	fff6079b          	addw	a5,a2,-1
    80000260:	1782                	sll	a5,a5,0x20
    80000262:	9381                	srl	a5,a5,0x20
    80000264:	fff7c793          	not	a5,a5
    80000268:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000026a:	177d                	add	a4,a4,-1
    8000026c:	16fd                	add	a3,a3,-1
    8000026e:	00074603          	lbu	a2,0(a4)
    80000272:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000276:	fef71ae3          	bne	a4,a5,8000026a <memmove+0x4a>
    8000027a:	b7f1                	j	80000246 <memmove+0x26>

000000008000027c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027c:	1141                	add	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000284:	00000097          	auipc	ra,0x0
    80000288:	f9c080e7          	jalr	-100(ra) # 80000220 <memmove>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	add	sp,sp,16
    80000292:	8082                	ret

0000000080000294 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000294:	1141                	add	sp,sp,-16
    80000296:	e422                	sd	s0,8(sp)
    80000298:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000029a:	ce11                	beqz	a2,800002b6 <strncmp+0x22>
    8000029c:	00054783          	lbu	a5,0(a0)
    800002a0:	cf89                	beqz	a5,800002ba <strncmp+0x26>
    800002a2:	0005c703          	lbu	a4,0(a1)
    800002a6:	00f71a63          	bne	a4,a5,800002ba <strncmp+0x26>
    n--, p++, q++;
    800002aa:	367d                	addw	a2,a2,-1
    800002ac:	0505                	add	a0,a0,1
    800002ae:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b0:	f675                	bnez	a2,8000029c <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b2:	4501                	li	a0,0
    800002b4:	a801                	j	800002c4 <strncmp+0x30>
    800002b6:	4501                	li	a0,0
    800002b8:	a031                	j	800002c4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800002ba:	00054503          	lbu	a0,0(a0)
    800002be:	0005c783          	lbu	a5,0(a1)
    800002c2:	9d1d                	subw	a0,a0,a5
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	add	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002ca:	1141                	add	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d0:	87aa                	mv	a5,a0
    800002d2:	86b2                	mv	a3,a2
    800002d4:	367d                	addw	a2,a2,-1
    800002d6:	02d05563          	blez	a3,80000300 <strncpy+0x36>
    800002da:	0785                	add	a5,a5,1
    800002dc:	0005c703          	lbu	a4,0(a1)
    800002e0:	fee78fa3          	sb	a4,-1(a5)
    800002e4:	0585                	add	a1,a1,1
    800002e6:	f775                	bnez	a4,800002d2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002e8:	873e                	mv	a4,a5
    800002ea:	9fb5                	addw	a5,a5,a3
    800002ec:	37fd                	addw	a5,a5,-1
    800002ee:	00c05963          	blez	a2,80000300 <strncpy+0x36>
    *s++ = 0;
    800002f2:	0705                	add	a4,a4,1
    800002f4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002f8:	40e786bb          	subw	a3,a5,a4
    800002fc:	fed04be3          	bgtz	a3,800002f2 <strncpy+0x28>
  return os;
}
    80000300:	6422                	ld	s0,8(sp)
    80000302:	0141                	add	sp,sp,16
    80000304:	8082                	ret

0000000080000306 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000306:	1141                	add	sp,sp,-16
    80000308:	e422                	sd	s0,8(sp)
    8000030a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000030c:	02c05363          	blez	a2,80000332 <safestrcpy+0x2c>
    80000310:	fff6069b          	addw	a3,a2,-1
    80000314:	1682                	sll	a3,a3,0x20
    80000316:	9281                	srl	a3,a3,0x20
    80000318:	96ae                	add	a3,a3,a1
    8000031a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000031c:	00d58963          	beq	a1,a3,8000032e <safestrcpy+0x28>
    80000320:	0585                	add	a1,a1,1
    80000322:	0785                	add	a5,a5,1
    80000324:	fff5c703          	lbu	a4,-1(a1)
    80000328:	fee78fa3          	sb	a4,-1(a5)
    8000032c:	fb65                	bnez	a4,8000031c <safestrcpy+0x16>
    ;
  *s = 0;
    8000032e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000332:	6422                	ld	s0,8(sp)
    80000334:	0141                	add	sp,sp,16
    80000336:	8082                	ret

0000000080000338 <strlen>:

int
strlen(const char *s)
{
    80000338:	1141                	add	sp,sp,-16
    8000033a:	e422                	sd	s0,8(sp)
    8000033c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000033e:	00054783          	lbu	a5,0(a0)
    80000342:	cf91                	beqz	a5,8000035e <strlen+0x26>
    80000344:	0505                	add	a0,a0,1
    80000346:	87aa                	mv	a5,a0
    80000348:	86be                	mv	a3,a5
    8000034a:	0785                	add	a5,a5,1
    8000034c:	fff7c703          	lbu	a4,-1(a5)
    80000350:	ff65                	bnez	a4,80000348 <strlen+0x10>
    80000352:	40a6853b          	subw	a0,a3,a0
    80000356:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000358:	6422                	ld	s0,8(sp)
    8000035a:	0141                	add	sp,sp,16
    8000035c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000035e:	4501                	li	a0,0
    80000360:	bfe5                	j	80000358 <strlen+0x20>

0000000080000362 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000362:	1141                	add	sp,sp,-16
    80000364:	e406                	sd	ra,8(sp)
    80000366:	e022                	sd	s0,0(sp)
    80000368:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    8000036a:	00001097          	auipc	ra,0x1
    8000036e:	b30080e7          	jalr	-1232(ra) # 80000e9a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000372:	00009717          	auipc	a4,0x9
    80000376:	c8e70713          	add	a4,a4,-882 # 80009000 <started>
  if(cpuid() == 0){
    8000037a:	c139                	beqz	a0,800003c0 <main+0x5e>
    while(started == 0)
    8000037c:	431c                	lw	a5,0(a4)
    8000037e:	2781                	sext.w	a5,a5
    80000380:	dff5                	beqz	a5,8000037c <main+0x1a>
      ;
    __sync_synchronize();
    80000382:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000386:	00001097          	auipc	ra,0x1
    8000038a:	b14080e7          	jalr	-1260(ra) # 80000e9a <cpuid>
    8000038e:	85aa                	mv	a1,a0
    80000390:	00008517          	auipc	a0,0x8
    80000394:	ca850513          	add	a0,a0,-856 # 80008038 <etext+0x38>
    80000398:	00006097          	auipc	ra,0x6
    8000039c:	a3e080e7          	jalr	-1474(ra) # 80005dd6 <printf>
    kvminithart();    // turn on paging
    800003a0:	00000097          	auipc	ra,0x0
    800003a4:	0d8080e7          	jalr	216(ra) # 80000478 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003a8:	00001097          	auipc	ra,0x1
    800003ac:	7d2080e7          	jalr	2002(ra) # 80001b7a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b0:	00005097          	auipc	ra,0x5
    800003b4:	ec4080e7          	jalr	-316(ra) # 80005274 <plicinithart>
  }

  scheduler();        
    800003b8:	00001097          	auipc	ra,0x1
    800003bc:	02a080e7          	jalr	42(ra) # 800013e2 <scheduler>
    consoleinit();
    800003c0:	00006097          	auipc	ra,0x6
    800003c4:	8dc080e7          	jalr	-1828(ra) # 80005c9c <consoleinit>
    printfinit();
    800003c8:	00006097          	auipc	ra,0x6
    800003cc:	c16080e7          	jalr	-1002(ra) # 80005fde <printfinit>
    printf("\n");
    800003d0:	00008517          	auipc	a0,0x8
    800003d4:	c4850513          	add	a0,a0,-952 # 80008018 <etext+0x18>
    800003d8:	00006097          	auipc	ra,0x6
    800003dc:	9fe080e7          	jalr	-1538(ra) # 80005dd6 <printf>
    printf("xv6 kernel is booting\n");
    800003e0:	00008517          	auipc	a0,0x8
    800003e4:	c4050513          	add	a0,a0,-960 # 80008020 <etext+0x20>
    800003e8:	00006097          	auipc	ra,0x6
    800003ec:	9ee080e7          	jalr	-1554(ra) # 80005dd6 <printf>
    printf("\n");
    800003f0:	00008517          	auipc	a0,0x8
    800003f4:	c2850513          	add	a0,a0,-984 # 80008018 <etext+0x18>
    800003f8:	00006097          	auipc	ra,0x6
    800003fc:	9de080e7          	jalr	-1570(ra) # 80005dd6 <printf>
    kinit();         // physical page allocator
    80000400:	00000097          	auipc	ra,0x0
    80000404:	cde080e7          	jalr	-802(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	322080e7          	jalr	802(ra) # 8000072a <kvminit>
    kvminithart();   // turn on paging
    80000410:	00000097          	auipc	ra,0x0
    80000414:	068080e7          	jalr	104(ra) # 80000478 <kvminithart>
    procinit();      // process table
    80000418:	00001097          	auipc	ra,0x1
    8000041c:	9c4080e7          	jalr	-1596(ra) # 80000ddc <procinit>
    trapinit();      // trap vectors
    80000420:	00001097          	auipc	ra,0x1
    80000424:	732080e7          	jalr	1842(ra) # 80001b52 <trapinit>
    trapinithart();  // install kernel trap vector
    80000428:	00001097          	auipc	ra,0x1
    8000042c:	752080e7          	jalr	1874(ra) # 80001b7a <trapinithart>
    plicinit();      // set up interrupt controller
    80000430:	00005097          	auipc	ra,0x5
    80000434:	e2a080e7          	jalr	-470(ra) # 8000525a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000438:	00005097          	auipc	ra,0x5
    8000043c:	e3c080e7          	jalr	-452(ra) # 80005274 <plicinithart>
    binit();         // buffer cache
    80000440:	00002097          	auipc	ra,0x2
    80000444:	f5c080e7          	jalr	-164(ra) # 8000239c <binit>
    iinit();         // inode table
    80000448:	00002097          	auipc	ra,0x2
    8000044c:	5e8080e7          	jalr	1512(ra) # 80002a30 <iinit>
    fileinit();      // file table
    80000450:	00003097          	auipc	ra,0x3
    80000454:	58c080e7          	jalr	1420(ra) # 800039dc <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000458:	00005097          	auipc	ra,0x5
    8000045c:	f3c080e7          	jalr	-196(ra) # 80005394 <virtio_disk_init>
    userinit();      // first user process
    80000460:	00001097          	auipc	ra,0x1
    80000464:	d3e080e7          	jalr	-706(ra) # 8000119e <userinit>
    __sync_synchronize();
    80000468:	0ff0000f          	fence
    started = 1;
    8000046c:	4785                	li	a5,1
    8000046e:	00009717          	auipc	a4,0x9
    80000472:	b8f72923          	sw	a5,-1134(a4) # 80009000 <started>
    80000476:	b789                	j	800003b8 <main+0x56>

0000000080000478 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000478:	1141                	add	sp,sp,-16
    8000047a:	e422                	sd	s0,8(sp)
    8000047c:	0800                	add	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000047e:	00009797          	auipc	a5,0x9
    80000482:	b8a7b783          	ld	a5,-1142(a5) # 80009008 <kernel_pagetable>
    80000486:	83b1                	srl	a5,a5,0xc
    80000488:	577d                	li	a4,-1
    8000048a:	177e                	sll	a4,a4,0x3f
    8000048c:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000048e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000492:	12000073          	sfence.vma
  sfence_vma();
}
    80000496:	6422                	ld	s0,8(sp)
    80000498:	0141                	add	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000049c:	7139                	add	sp,sp,-64
    8000049e:	fc06                	sd	ra,56(sp)
    800004a0:	f822                	sd	s0,48(sp)
    800004a2:	f426                	sd	s1,40(sp)
    800004a4:	f04a                	sd	s2,32(sp)
    800004a6:	ec4e                	sd	s3,24(sp)
    800004a8:	e852                	sd	s4,16(sp)
    800004aa:	e456                	sd	s5,8(sp)
    800004ac:	e05a                	sd	s6,0(sp)
    800004ae:	0080                	add	s0,sp,64
    800004b0:	84aa                	mv	s1,a0
    800004b2:	89ae                	mv	s3,a1
    800004b4:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004b6:	57fd                	li	a5,-1
    800004b8:	83e9                	srl	a5,a5,0x1a
    800004ba:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004bc:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004be:	04b7f263          	bgeu	a5,a1,80000502 <walk+0x66>
    panic("walk");
    800004c2:	00008517          	auipc	a0,0x8
    800004c6:	b8e50513          	add	a0,a0,-1138 # 80008050 <etext+0x50>
    800004ca:	00006097          	auipc	ra,0x6
    800004ce:	8c2080e7          	jalr	-1854(ra) # 80005d8c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004d2:	060a8663          	beqz	s5,8000053e <walk+0xa2>
    800004d6:	00000097          	auipc	ra,0x0
    800004da:	c44080e7          	jalr	-956(ra) # 8000011a <kalloc>
    800004de:	84aa                	mv	s1,a0
    800004e0:	c529                	beqz	a0,8000052a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004e2:	6605                	lui	a2,0x1
    800004e4:	4581                	li	a1,0
    800004e6:	00000097          	auipc	ra,0x0
    800004ea:	cde080e7          	jalr	-802(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ee:	00c4d793          	srl	a5,s1,0xc
    800004f2:	07aa                	sll	a5,a5,0xa
    800004f4:	0017e793          	or	a5,a5,1
    800004f8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004fc:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004fe:	036a0063          	beq	s4,s6,8000051e <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000502:	0149d933          	srl	s2,s3,s4
    80000506:	1ff97913          	and	s2,s2,511
    8000050a:	090e                	sll	s2,s2,0x3
    8000050c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000050e:	00093483          	ld	s1,0(s2)
    80000512:	0014f793          	and	a5,s1,1
    80000516:	dfd5                	beqz	a5,800004d2 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000518:	80a9                	srl	s1,s1,0xa
    8000051a:	04b2                	sll	s1,s1,0xc
    8000051c:	b7c5                	j	800004fc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000051e:	00c9d513          	srl	a0,s3,0xc
    80000522:	1ff57513          	and	a0,a0,511
    80000526:	050e                	sll	a0,a0,0x3
    80000528:	9526                	add	a0,a0,s1
}
    8000052a:	70e2                	ld	ra,56(sp)
    8000052c:	7442                	ld	s0,48(sp)
    8000052e:	74a2                	ld	s1,40(sp)
    80000530:	7902                	ld	s2,32(sp)
    80000532:	69e2                	ld	s3,24(sp)
    80000534:	6a42                	ld	s4,16(sp)
    80000536:	6aa2                	ld	s5,8(sp)
    80000538:	6b02                	ld	s6,0(sp)
    8000053a:	6121                	add	sp,sp,64
    8000053c:	8082                	ret
        return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7ed                	j	8000052a <walk+0x8e>

0000000080000542 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000542:	57fd                	li	a5,-1
    80000544:	83e9                	srl	a5,a5,0x1a
    80000546:	00b7f463          	bgeu	a5,a1,8000054e <walkaddr+0xc>
    return 0;
    8000054a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000054c:	8082                	ret
{
    8000054e:	1141                	add	sp,sp,-16
    80000550:	e406                	sd	ra,8(sp)
    80000552:	e022                	sd	s0,0(sp)
    80000554:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000556:	4601                	li	a2,0
    80000558:	00000097          	auipc	ra,0x0
    8000055c:	f44080e7          	jalr	-188(ra) # 8000049c <walk>
  if(pte == 0)
    80000560:	c105                	beqz	a0,80000580 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000562:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000564:	0117f693          	and	a3,a5,17
    80000568:	4745                	li	a4,17
    return 0;
    8000056a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000056c:	00e68663          	beq	a3,a4,80000578 <walkaddr+0x36>
}
    80000570:	60a2                	ld	ra,8(sp)
    80000572:	6402                	ld	s0,0(sp)
    80000574:	0141                	add	sp,sp,16
    80000576:	8082                	ret
  pa = PTE2PA(*pte);
    80000578:	83a9                	srl	a5,a5,0xa
    8000057a:	00c79513          	sll	a0,a5,0xc
  return pa;
    8000057e:	bfcd                	j	80000570 <walkaddr+0x2e>
    return 0;
    80000580:	4501                	li	a0,0
    80000582:	b7fd                	j	80000570 <walkaddr+0x2e>

0000000080000584 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000584:	715d                	add	sp,sp,-80
    80000586:	e486                	sd	ra,72(sp)
    80000588:	e0a2                	sd	s0,64(sp)
    8000058a:	fc26                	sd	s1,56(sp)
    8000058c:	f84a                	sd	s2,48(sp)
    8000058e:	f44e                	sd	s3,40(sp)
    80000590:	f052                	sd	s4,32(sp)
    80000592:	ec56                	sd	s5,24(sp)
    80000594:	e85a                	sd	s6,16(sp)
    80000596:	e45e                	sd	s7,8(sp)
    80000598:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000059a:	c639                	beqz	a2,800005e8 <mappages+0x64>
    8000059c:	8aaa                	mv	s5,a0
    8000059e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005a0:	777d                	lui	a4,0xfffff
    800005a2:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800005a6:	fff58993          	add	s3,a1,-1
    800005aa:	99b2                	add	s3,s3,a2
    800005ac:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005b0:	893e                	mv	s2,a5
    800005b2:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005b6:	6b85                	lui	s7,0x1
    800005b8:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800005bc:	4605                	li	a2,1
    800005be:	85ca                	mv	a1,s2
    800005c0:	8556                	mv	a0,s5
    800005c2:	00000097          	auipc	ra,0x0
    800005c6:	eda080e7          	jalr	-294(ra) # 8000049c <walk>
    800005ca:	cd1d                	beqz	a0,80000608 <mappages+0x84>
    if(*pte & PTE_V)
    800005cc:	611c                	ld	a5,0(a0)
    800005ce:	8b85                	and	a5,a5,1
    800005d0:	e785                	bnez	a5,800005f8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005d2:	80b1                	srl	s1,s1,0xc
    800005d4:	04aa                	sll	s1,s1,0xa
    800005d6:	0164e4b3          	or	s1,s1,s6
    800005da:	0014e493          	or	s1,s1,1
    800005de:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e0:	05390063          	beq	s2,s3,80000620 <mappages+0x9c>
    a += PGSIZE;
    800005e4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005e6:	bfc9                	j	800005b8 <mappages+0x34>
    panic("mappages: size");
    800005e8:	00008517          	auipc	a0,0x8
    800005ec:	a7050513          	add	a0,a0,-1424 # 80008058 <etext+0x58>
    800005f0:	00005097          	auipc	ra,0x5
    800005f4:	79c080e7          	jalr	1948(ra) # 80005d8c <panic>
      panic("mappages: remap");
    800005f8:	00008517          	auipc	a0,0x8
    800005fc:	a7050513          	add	a0,a0,-1424 # 80008068 <etext+0x68>
    80000600:	00005097          	auipc	ra,0x5
    80000604:	78c080e7          	jalr	1932(ra) # 80005d8c <panic>
      return -1;
    80000608:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000060a:	60a6                	ld	ra,72(sp)
    8000060c:	6406                	ld	s0,64(sp)
    8000060e:	74e2                	ld	s1,56(sp)
    80000610:	7942                	ld	s2,48(sp)
    80000612:	79a2                	ld	s3,40(sp)
    80000614:	7a02                	ld	s4,32(sp)
    80000616:	6ae2                	ld	s5,24(sp)
    80000618:	6b42                	ld	s6,16(sp)
    8000061a:	6ba2                	ld	s7,8(sp)
    8000061c:	6161                	add	sp,sp,80
    8000061e:	8082                	ret
  return 0;
    80000620:	4501                	li	a0,0
    80000622:	b7e5                	j	8000060a <mappages+0x86>

0000000080000624 <kvmmap>:
{
    80000624:	1141                	add	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	add	s0,sp,16
    8000062c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000062e:	86b2                	mv	a3,a2
    80000630:	863e                	mv	a2,a5
    80000632:	00000097          	auipc	ra,0x0
    80000636:	f52080e7          	jalr	-174(ra) # 80000584 <mappages>
    8000063a:	e509                	bnez	a0,80000644 <kvmmap+0x20>
}
    8000063c:	60a2                	ld	ra,8(sp)
    8000063e:	6402                	ld	s0,0(sp)
    80000640:	0141                	add	sp,sp,16
    80000642:	8082                	ret
    panic("kvmmap");
    80000644:	00008517          	auipc	a0,0x8
    80000648:	a3450513          	add	a0,a0,-1484 # 80008078 <etext+0x78>
    8000064c:	00005097          	auipc	ra,0x5
    80000650:	740080e7          	jalr	1856(ra) # 80005d8c <panic>

0000000080000654 <kvmmake>:
{
    80000654:	1101                	add	sp,sp,-32
    80000656:	ec06                	sd	ra,24(sp)
    80000658:	e822                	sd	s0,16(sp)
    8000065a:	e426                	sd	s1,8(sp)
    8000065c:	e04a                	sd	s2,0(sp)
    8000065e:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000660:	00000097          	auipc	ra,0x0
    80000664:	aba080e7          	jalr	-1350(ra) # 8000011a <kalloc>
    80000668:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000066a:	6605                	lui	a2,0x1
    8000066c:	4581                	li	a1,0
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	b56080e7          	jalr	-1194(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000676:	4719                	li	a4,6
    80000678:	6685                	lui	a3,0x1
    8000067a:	10000637          	lui	a2,0x10000
    8000067e:	100005b7          	lui	a1,0x10000
    80000682:	8526                	mv	a0,s1
    80000684:	00000097          	auipc	ra,0x0
    80000688:	fa0080e7          	jalr	-96(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000068c:	4719                	li	a4,6
    8000068e:	6685                	lui	a3,0x1
    80000690:	10001637          	lui	a2,0x10001
    80000694:	100015b7          	lui	a1,0x10001
    80000698:	8526                	mv	a0,s1
    8000069a:	00000097          	auipc	ra,0x0
    8000069e:	f8a080e7          	jalr	-118(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006a2:	4719                	li	a4,6
    800006a4:	004006b7          	lui	a3,0x400
    800006a8:	0c000637          	lui	a2,0xc000
    800006ac:	0c0005b7          	lui	a1,0xc000
    800006b0:	8526                	mv	a0,s1
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	f72080e7          	jalr	-142(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006ba:	00008917          	auipc	s2,0x8
    800006be:	94690913          	add	s2,s2,-1722 # 80008000 <etext>
    800006c2:	4729                	li	a4,10
    800006c4:	80008697          	auipc	a3,0x80008
    800006c8:	93c68693          	add	a3,a3,-1732 # 8000 <_entry-0x7fff8000>
    800006cc:	4605                	li	a2,1
    800006ce:	067e                	sll	a2,a2,0x1f
    800006d0:	85b2                	mv	a1,a2
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	f50080e7          	jalr	-176(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006dc:	46c5                	li	a3,17
    800006de:	06ee                	sll	a3,a3,0x1b
    800006e0:	4719                	li	a4,6
    800006e2:	412686b3          	sub	a3,a3,s2
    800006e6:	864a                	mv	a2,s2
    800006e8:	85ca                	mv	a1,s2
    800006ea:	8526                	mv	a0,s1
    800006ec:	00000097          	auipc	ra,0x0
    800006f0:	f38080e7          	jalr	-200(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006f4:	4729                	li	a4,10
    800006f6:	6685                	lui	a3,0x1
    800006f8:	00007617          	auipc	a2,0x7
    800006fc:	90860613          	add	a2,a2,-1784 # 80007000 <_trampoline>
    80000700:	040005b7          	lui	a1,0x4000
    80000704:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000706:	05b2                	sll	a1,a1,0xc
    80000708:	8526                	mv	a0,s1
    8000070a:	00000097          	auipc	ra,0x0
    8000070e:	f1a080e7          	jalr	-230(ra) # 80000624 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000712:	8526                	mv	a0,s1
    80000714:	00000097          	auipc	ra,0x0
    80000718:	624080e7          	jalr	1572(ra) # 80000d38 <proc_mapstacks>
}
    8000071c:	8526                	mv	a0,s1
    8000071e:	60e2                	ld	ra,24(sp)
    80000720:	6442                	ld	s0,16(sp)
    80000722:	64a2                	ld	s1,8(sp)
    80000724:	6902                	ld	s2,0(sp)
    80000726:	6105                	add	sp,sp,32
    80000728:	8082                	ret

000000008000072a <kvminit>:
{
    8000072a:	1141                	add	sp,sp,-16
    8000072c:	e406                	sd	ra,8(sp)
    8000072e:	e022                	sd	s0,0(sp)
    80000730:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80000732:	00000097          	auipc	ra,0x0
    80000736:	f22080e7          	jalr	-222(ra) # 80000654 <kvmmake>
    8000073a:	00009797          	auipc	a5,0x9
    8000073e:	8ca7b723          	sd	a0,-1842(a5) # 80009008 <kernel_pagetable>
}
    80000742:	60a2                	ld	ra,8(sp)
    80000744:	6402                	ld	s0,0(sp)
    80000746:	0141                	add	sp,sp,16
    80000748:	8082                	ret

000000008000074a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000074a:	715d                	add	sp,sp,-80
    8000074c:	e486                	sd	ra,72(sp)
    8000074e:	e0a2                	sd	s0,64(sp)
    80000750:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000752:	03459793          	sll	a5,a1,0x34
    80000756:	e39d                	bnez	a5,8000077c <uvmunmap+0x32>
    80000758:	f84a                	sd	s2,48(sp)
    8000075a:	f44e                	sd	s3,40(sp)
    8000075c:	f052                	sd	s4,32(sp)
    8000075e:	ec56                	sd	s5,24(sp)
    80000760:	e85a                	sd	s6,16(sp)
    80000762:	e45e                	sd	s7,8(sp)
    80000764:	8a2a                	mv	s4,a0
    80000766:	892e                	mv	s2,a1
    80000768:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000076a:	0632                	sll	a2,a2,0xc
    8000076c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000770:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000772:	6b05                	lui	s6,0x1
    80000774:	0935fb63          	bgeu	a1,s3,8000080a <uvmunmap+0xc0>
    80000778:	fc26                	sd	s1,56(sp)
    8000077a:	a8a9                	j	800007d4 <uvmunmap+0x8a>
    8000077c:	fc26                	sd	s1,56(sp)
    8000077e:	f84a                	sd	s2,48(sp)
    80000780:	f44e                	sd	s3,40(sp)
    80000782:	f052                	sd	s4,32(sp)
    80000784:	ec56                	sd	s5,24(sp)
    80000786:	e85a                	sd	s6,16(sp)
    80000788:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000078a:	00008517          	auipc	a0,0x8
    8000078e:	8f650513          	add	a0,a0,-1802 # 80008080 <etext+0x80>
    80000792:	00005097          	auipc	ra,0x5
    80000796:	5fa080e7          	jalr	1530(ra) # 80005d8c <panic>
      panic("uvmunmap: walk");
    8000079a:	00008517          	auipc	a0,0x8
    8000079e:	8fe50513          	add	a0,a0,-1794 # 80008098 <etext+0x98>
    800007a2:	00005097          	auipc	ra,0x5
    800007a6:	5ea080e7          	jalr	1514(ra) # 80005d8c <panic>
      panic("uvmunmap: not mapped");
    800007aa:	00008517          	auipc	a0,0x8
    800007ae:	8fe50513          	add	a0,a0,-1794 # 800080a8 <etext+0xa8>
    800007b2:	00005097          	auipc	ra,0x5
    800007b6:	5da080e7          	jalr	1498(ra) # 80005d8c <panic>
      panic("uvmunmap: not a leaf");
    800007ba:	00008517          	auipc	a0,0x8
    800007be:	90650513          	add	a0,a0,-1786 # 800080c0 <etext+0xc0>
    800007c2:	00005097          	auipc	ra,0x5
    800007c6:	5ca080e7          	jalr	1482(ra) # 80005d8c <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007ca:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ce:	995a                	add	s2,s2,s6
    800007d0:	03397c63          	bgeu	s2,s3,80000808 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d4:	4601                	li	a2,0
    800007d6:	85ca                	mv	a1,s2
    800007d8:	8552                	mv	a0,s4
    800007da:	00000097          	auipc	ra,0x0
    800007de:	cc2080e7          	jalr	-830(ra) # 8000049c <walk>
    800007e2:	84aa                	mv	s1,a0
    800007e4:	d95d                	beqz	a0,8000079a <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800007e6:	6108                	ld	a0,0(a0)
    800007e8:	00157793          	and	a5,a0,1
    800007ec:	dfdd                	beqz	a5,800007aa <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ee:	3ff57793          	and	a5,a0,1023
    800007f2:	fd7784e3          	beq	a5,s7,800007ba <uvmunmap+0x70>
    if(do_free){
    800007f6:	fc0a8ae3          	beqz	s5,800007ca <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007fa:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    800007fc:	0532                	sll	a0,a0,0xc
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	81e080e7          	jalr	-2018(ra) # 8000001c <kfree>
    80000806:	b7d1                	j	800007ca <uvmunmap+0x80>
    80000808:	74e2                	ld	s1,56(sp)
    8000080a:	7942                	ld	s2,48(sp)
    8000080c:	79a2                	ld	s3,40(sp)
    8000080e:	7a02                	ld	s4,32(sp)
    80000810:	6ae2                	ld	s5,24(sp)
    80000812:	6b42                	ld	s6,16(sp)
    80000814:	6ba2                	ld	s7,8(sp)
  }
}
    80000816:	60a6                	ld	ra,72(sp)
    80000818:	6406                	ld	s0,64(sp)
    8000081a:	6161                	add	sp,sp,80
    8000081c:	8082                	ret

000000008000081e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081e:	1101                	add	sp,sp,-32
    80000820:	ec06                	sd	ra,24(sp)
    80000822:	e822                	sd	s0,16(sp)
    80000824:	e426                	sd	s1,8(sp)
    80000826:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	8f2080e7          	jalr	-1806(ra) # 8000011a <kalloc>
    80000830:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000832:	c519                	beqz	a0,80000840 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000834:	6605                	lui	a2,0x1
    80000836:	4581                	li	a1,0
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	98c080e7          	jalr	-1652(ra) # 800001c4 <memset>
  return pagetable;
}
    80000840:	8526                	mv	a0,s1
    80000842:	60e2                	ld	ra,24(sp)
    80000844:	6442                	ld	s0,16(sp)
    80000846:	64a2                	ld	s1,8(sp)
    80000848:	6105                	add	sp,sp,32
    8000084a:	8082                	ret

000000008000084c <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084c:	7179                	add	sp,sp,-48
    8000084e:	f406                	sd	ra,40(sp)
    80000850:	f022                	sd	s0,32(sp)
    80000852:	ec26                	sd	s1,24(sp)
    80000854:	e84a                	sd	s2,16(sp)
    80000856:	e44e                	sd	s3,8(sp)
    80000858:	e052                	sd	s4,0(sp)
    8000085a:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085c:	6785                	lui	a5,0x1
    8000085e:	04f67863          	bgeu	a2,a5,800008ae <uvminit+0x62>
    80000862:	8a2a                	mv	s4,a0
    80000864:	89ae                	mv	s3,a1
    80000866:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000868:	00000097          	auipc	ra,0x0
    8000086c:	8b2080e7          	jalr	-1870(ra) # 8000011a <kalloc>
    80000870:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000872:	6605                	lui	a2,0x1
    80000874:	4581                	li	a1,0
    80000876:	00000097          	auipc	ra,0x0
    8000087a:	94e080e7          	jalr	-1714(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087e:	4779                	li	a4,30
    80000880:	86ca                	mv	a3,s2
    80000882:	6605                	lui	a2,0x1
    80000884:	4581                	li	a1,0
    80000886:	8552                	mv	a0,s4
    80000888:	00000097          	auipc	ra,0x0
    8000088c:	cfc080e7          	jalr	-772(ra) # 80000584 <mappages>
  memmove(mem, src, sz);
    80000890:	8626                	mv	a2,s1
    80000892:	85ce                	mv	a1,s3
    80000894:	854a                	mv	a0,s2
    80000896:	00000097          	auipc	ra,0x0
    8000089a:	98a080e7          	jalr	-1654(ra) # 80000220 <memmove>
}
    8000089e:	70a2                	ld	ra,40(sp)
    800008a0:	7402                	ld	s0,32(sp)
    800008a2:	64e2                	ld	s1,24(sp)
    800008a4:	6942                	ld	s2,16(sp)
    800008a6:	69a2                	ld	s3,8(sp)
    800008a8:	6a02                	ld	s4,0(sp)
    800008aa:	6145                	add	sp,sp,48
    800008ac:	8082                	ret
    panic("inituvm: more than a page");
    800008ae:	00008517          	auipc	a0,0x8
    800008b2:	82a50513          	add	a0,a0,-2006 # 800080d8 <etext+0xd8>
    800008b6:	00005097          	auipc	ra,0x5
    800008ba:	4d6080e7          	jalr	1238(ra) # 80005d8c <panic>

00000000800008be <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008be:	1101                	add	sp,sp,-32
    800008c0:	ec06                	sd	ra,24(sp)
    800008c2:	e822                	sd	s0,16(sp)
    800008c4:	e426                	sd	s1,8(sp)
    800008c6:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008ca:	00b67d63          	bgeu	a2,a1,800008e4 <uvmdealloc+0x26>
    800008ce:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008d0:	6785                	lui	a5,0x1
    800008d2:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d4:	00f60733          	add	a4,a2,a5
    800008d8:	76fd                	lui	a3,0xfffff
    800008da:	8f75                	and	a4,a4,a3
    800008dc:	97ae                	add	a5,a5,a1
    800008de:	8ff5                	and	a5,a5,a3
    800008e0:	00f76863          	bltu	a4,a5,800008f0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e4:	8526                	mv	a0,s1
    800008e6:	60e2                	ld	ra,24(sp)
    800008e8:	6442                	ld	s0,16(sp)
    800008ea:	64a2                	ld	s1,8(sp)
    800008ec:	6105                	add	sp,sp,32
    800008ee:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008f0:	8f99                	sub	a5,a5,a4
    800008f2:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f4:	4685                	li	a3,1
    800008f6:	0007861b          	sext.w	a2,a5
    800008fa:	85ba                	mv	a1,a4
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	e4e080e7          	jalr	-434(ra) # 8000074a <uvmunmap>
    80000904:	b7c5                	j	800008e4 <uvmdealloc+0x26>

0000000080000906 <uvmalloc>:
  if(newsz < oldsz)
    80000906:	0ab66563          	bltu	a2,a1,800009b0 <uvmalloc+0xaa>
{
    8000090a:	7139                	add	sp,sp,-64
    8000090c:	fc06                	sd	ra,56(sp)
    8000090e:	f822                	sd	s0,48(sp)
    80000910:	ec4e                	sd	s3,24(sp)
    80000912:	e852                	sd	s4,16(sp)
    80000914:	e456                	sd	s5,8(sp)
    80000916:	0080                	add	s0,sp,64
    80000918:	8aaa                	mv	s5,a0
    8000091a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091c:	6785                	lui	a5,0x1
    8000091e:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000920:	95be                	add	a1,a1,a5
    80000922:	77fd                	lui	a5,0xfffff
    80000924:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000928:	08c9f663          	bgeu	s3,a2,800009b4 <uvmalloc+0xae>
    8000092c:	f426                	sd	s1,40(sp)
    8000092e:	f04a                	sd	s2,32(sp)
    80000930:	894e                	mv	s2,s3
    mem = kalloc();
    80000932:	fffff097          	auipc	ra,0xfffff
    80000936:	7e8080e7          	jalr	2024(ra) # 8000011a <kalloc>
    8000093a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093c:	c90d                	beqz	a0,8000096e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    8000093e:	6605                	lui	a2,0x1
    80000940:	4581                	li	a1,0
    80000942:	00000097          	auipc	ra,0x0
    80000946:	882080e7          	jalr	-1918(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000094a:	4779                	li	a4,30
    8000094c:	86a6                	mv	a3,s1
    8000094e:	6605                	lui	a2,0x1
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	c30080e7          	jalr	-976(ra) # 80000584 <mappages>
    8000095c:	e915                	bnez	a0,80000990 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095e:	6785                	lui	a5,0x1
    80000960:	993e                	add	s2,s2,a5
    80000962:	fd4968e3          	bltu	s2,s4,80000932 <uvmalloc+0x2c>
  return newsz;
    80000966:	8552                	mv	a0,s4
    80000968:	74a2                	ld	s1,40(sp)
    8000096a:	7902                	ld	s2,32(sp)
    8000096c:	a819                	j	80000982 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000096e:	864e                	mv	a2,s3
    80000970:	85ca                	mv	a1,s2
    80000972:	8556                	mv	a0,s5
    80000974:	00000097          	auipc	ra,0x0
    80000978:	f4a080e7          	jalr	-182(ra) # 800008be <uvmdealloc>
      return 0;
    8000097c:	4501                	li	a0,0
    8000097e:	74a2                	ld	s1,40(sp)
    80000980:	7902                	ld	s2,32(sp)
}
    80000982:	70e2                	ld	ra,56(sp)
    80000984:	7442                	ld	s0,48(sp)
    80000986:	69e2                	ld	s3,24(sp)
    80000988:	6a42                	ld	s4,16(sp)
    8000098a:	6aa2                	ld	s5,8(sp)
    8000098c:	6121                	add	sp,sp,64
    8000098e:	8082                	ret
      kfree(mem);
    80000990:	8526                	mv	a0,s1
    80000992:	fffff097          	auipc	ra,0xfffff
    80000996:	68a080e7          	jalr	1674(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000099a:	864e                	mv	a2,s3
    8000099c:	85ca                	mv	a1,s2
    8000099e:	8556                	mv	a0,s5
    800009a0:	00000097          	auipc	ra,0x0
    800009a4:	f1e080e7          	jalr	-226(ra) # 800008be <uvmdealloc>
      return 0;
    800009a8:	4501                	li	a0,0
    800009aa:	74a2                	ld	s1,40(sp)
    800009ac:	7902                	ld	s2,32(sp)
    800009ae:	bfd1                	j	80000982 <uvmalloc+0x7c>
    return oldsz;
    800009b0:	852e                	mv	a0,a1
}
    800009b2:	8082                	ret
  return newsz;
    800009b4:	8532                	mv	a0,a2
    800009b6:	b7f1                	j	80000982 <uvmalloc+0x7c>

00000000800009b8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009b8:	7179                	add	sp,sp,-48
    800009ba:	f406                	sd	ra,40(sp)
    800009bc:	f022                	sd	s0,32(sp)
    800009be:	ec26                	sd	s1,24(sp)
    800009c0:	e84a                	sd	s2,16(sp)
    800009c2:	e44e                	sd	s3,8(sp)
    800009c4:	e052                	sd	s4,0(sp)
    800009c6:	1800                	add	s0,sp,48
    800009c8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009ca:	84aa                	mv	s1,a0
    800009cc:	6905                	lui	s2,0x1
    800009ce:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d0:	4985                	li	s3,1
    800009d2:	a829                	j	800009ec <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009d4:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009d6:	00c79513          	sll	a0,a5,0xc
    800009da:	00000097          	auipc	ra,0x0
    800009de:	fde080e7          	jalr	-34(ra) # 800009b8 <freewalk>
      pagetable[i] = 0;
    800009e2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009e6:	04a1                	add	s1,s1,8
    800009e8:	03248163          	beq	s1,s2,80000a0a <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009ec:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ee:	00f7f713          	and	a4,a5,15
    800009f2:	ff3701e3          	beq	a4,s3,800009d4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009f6:	8b85                	and	a5,a5,1
    800009f8:	d7fd                	beqz	a5,800009e6 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009fa:	00007517          	auipc	a0,0x7
    800009fe:	6fe50513          	add	a0,a0,1790 # 800080f8 <etext+0xf8>
    80000a02:	00005097          	auipc	ra,0x5
    80000a06:	38a080e7          	jalr	906(ra) # 80005d8c <panic>
    }
  }
  kfree((void*)pagetable);
    80000a0a:	8552                	mv	a0,s4
    80000a0c:	fffff097          	auipc	ra,0xfffff
    80000a10:	610080e7          	jalr	1552(ra) # 8000001c <kfree>
}
    80000a14:	70a2                	ld	ra,40(sp)
    80000a16:	7402                	ld	s0,32(sp)
    80000a18:	64e2                	ld	s1,24(sp)
    80000a1a:	6942                	ld	s2,16(sp)
    80000a1c:	69a2                	ld	s3,8(sp)
    80000a1e:	6a02                	ld	s4,0(sp)
    80000a20:	6145                	add	sp,sp,48
    80000a22:	8082                	ret

0000000080000a24 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a24:	1101                	add	sp,sp,-32
    80000a26:	ec06                	sd	ra,24(sp)
    80000a28:	e822                	sd	s0,16(sp)
    80000a2a:	e426                	sd	s1,8(sp)
    80000a2c:	1000                	add	s0,sp,32
    80000a2e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a30:	e999                	bnez	a1,80000a46 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a32:	8526                	mv	a0,s1
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	f84080e7          	jalr	-124(ra) # 800009b8 <freewalk>
}
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6105                	add	sp,sp,32
    80000a44:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a46:	6785                	lui	a5,0x1
    80000a48:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a4a:	95be                	add	a1,a1,a5
    80000a4c:	4685                	li	a3,1
    80000a4e:	00c5d613          	srl	a2,a1,0xc
    80000a52:	4581                	li	a1,0
    80000a54:	00000097          	auipc	ra,0x0
    80000a58:	cf6080e7          	jalr	-778(ra) # 8000074a <uvmunmap>
    80000a5c:	bfd9                	j	80000a32 <uvmfree+0xe>

0000000080000a5e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a5e:	c679                	beqz	a2,80000b2c <uvmcopy+0xce>
{
    80000a60:	715d                	add	sp,sp,-80
    80000a62:	e486                	sd	ra,72(sp)
    80000a64:	e0a2                	sd	s0,64(sp)
    80000a66:	fc26                	sd	s1,56(sp)
    80000a68:	f84a                	sd	s2,48(sp)
    80000a6a:	f44e                	sd	s3,40(sp)
    80000a6c:	f052                	sd	s4,32(sp)
    80000a6e:	ec56                	sd	s5,24(sp)
    80000a70:	e85a                	sd	s6,16(sp)
    80000a72:	e45e                	sd	s7,8(sp)
    80000a74:	0880                	add	s0,sp,80
    80000a76:	8b2a                	mv	s6,a0
    80000a78:	8aae                	mv	s5,a1
    80000a7a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a7c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a7e:	4601                	li	a2,0
    80000a80:	85ce                	mv	a1,s3
    80000a82:	855a                	mv	a0,s6
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	a18080e7          	jalr	-1512(ra) # 8000049c <walk>
    80000a8c:	c531                	beqz	a0,80000ad8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a8e:	6118                	ld	a4,0(a0)
    80000a90:	00177793          	and	a5,a4,1
    80000a94:	cbb1                	beqz	a5,80000ae8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a96:	00a75593          	srl	a1,a4,0xa
    80000a9a:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a9e:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	678080e7          	jalr	1656(ra) # 8000011a <kalloc>
    80000aaa:	892a                	mv	s2,a0
    80000aac:	c939                	beqz	a0,80000b02 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aae:	6605                	lui	a2,0x1
    80000ab0:	85de                	mv	a1,s7
    80000ab2:	fffff097          	auipc	ra,0xfffff
    80000ab6:	76e080e7          	jalr	1902(ra) # 80000220 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aba:	8726                	mv	a4,s1
    80000abc:	86ca                	mv	a3,s2
    80000abe:	6605                	lui	a2,0x1
    80000ac0:	85ce                	mv	a1,s3
    80000ac2:	8556                	mv	a0,s5
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	ac0080e7          	jalr	-1344(ra) # 80000584 <mappages>
    80000acc:	e515                	bnez	a0,80000af8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ace:	6785                	lui	a5,0x1
    80000ad0:	99be                	add	s3,s3,a5
    80000ad2:	fb49e6e3          	bltu	s3,s4,80000a7e <uvmcopy+0x20>
    80000ad6:	a081                	j	80000b16 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ad8:	00007517          	auipc	a0,0x7
    80000adc:	63050513          	add	a0,a0,1584 # 80008108 <etext+0x108>
    80000ae0:	00005097          	auipc	ra,0x5
    80000ae4:	2ac080e7          	jalr	684(ra) # 80005d8c <panic>
      panic("uvmcopy: page not present");
    80000ae8:	00007517          	auipc	a0,0x7
    80000aec:	64050513          	add	a0,a0,1600 # 80008128 <etext+0x128>
    80000af0:	00005097          	auipc	ra,0x5
    80000af4:	29c080e7          	jalr	668(ra) # 80005d8c <panic>
      kfree(mem);
    80000af8:	854a                	mv	a0,s2
    80000afa:	fffff097          	auipc	ra,0xfffff
    80000afe:	522080e7          	jalr	1314(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b02:	4685                	li	a3,1
    80000b04:	00c9d613          	srl	a2,s3,0xc
    80000b08:	4581                	li	a1,0
    80000b0a:	8556                	mv	a0,s5
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	c3e080e7          	jalr	-962(ra) # 8000074a <uvmunmap>
  return -1;
    80000b14:	557d                	li	a0,-1
}
    80000b16:	60a6                	ld	ra,72(sp)
    80000b18:	6406                	ld	s0,64(sp)
    80000b1a:	74e2                	ld	s1,56(sp)
    80000b1c:	7942                	ld	s2,48(sp)
    80000b1e:	79a2                	ld	s3,40(sp)
    80000b20:	7a02                	ld	s4,32(sp)
    80000b22:	6ae2                	ld	s5,24(sp)
    80000b24:	6b42                	ld	s6,16(sp)
    80000b26:	6ba2                	ld	s7,8(sp)
    80000b28:	6161                	add	sp,sp,80
    80000b2a:	8082                	ret
  return 0;
    80000b2c:	4501                	li	a0,0
}
    80000b2e:	8082                	ret

0000000080000b30 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b30:	1141                	add	sp,sp,-16
    80000b32:	e406                	sd	ra,8(sp)
    80000b34:	e022                	sd	s0,0(sp)
    80000b36:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b38:	4601                	li	a2,0
    80000b3a:	00000097          	auipc	ra,0x0
    80000b3e:	962080e7          	jalr	-1694(ra) # 8000049c <walk>
  if(pte == 0)
    80000b42:	c901                	beqz	a0,80000b52 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b44:	611c                	ld	a5,0(a0)
    80000b46:	9bbd                	and	a5,a5,-17
    80000b48:	e11c                	sd	a5,0(a0)
}
    80000b4a:	60a2                	ld	ra,8(sp)
    80000b4c:	6402                	ld	s0,0(sp)
    80000b4e:	0141                	add	sp,sp,16
    80000b50:	8082                	ret
    panic("uvmclear");
    80000b52:	00007517          	auipc	a0,0x7
    80000b56:	5f650513          	add	a0,a0,1526 # 80008148 <etext+0x148>
    80000b5a:	00005097          	auipc	ra,0x5
    80000b5e:	232080e7          	jalr	562(ra) # 80005d8c <panic>

0000000080000b62 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b62:	c6bd                	beqz	a3,80000bd0 <copyout+0x6e>
{
    80000b64:	715d                	add	sp,sp,-80
    80000b66:	e486                	sd	ra,72(sp)
    80000b68:	e0a2                	sd	s0,64(sp)
    80000b6a:	fc26                	sd	s1,56(sp)
    80000b6c:	f84a                	sd	s2,48(sp)
    80000b6e:	f44e                	sd	s3,40(sp)
    80000b70:	f052                	sd	s4,32(sp)
    80000b72:	ec56                	sd	s5,24(sp)
    80000b74:	e85a                	sd	s6,16(sp)
    80000b76:	e45e                	sd	s7,8(sp)
    80000b78:	e062                	sd	s8,0(sp)
    80000b7a:	0880                	add	s0,sp,80
    80000b7c:	8b2a                	mv	s6,a0
    80000b7e:	8c2e                	mv	s8,a1
    80000b80:	8a32                	mv	s4,a2
    80000b82:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b84:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b86:	6a85                	lui	s5,0x1
    80000b88:	a015                	j	80000bac <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8a:	9562                	add	a0,a0,s8
    80000b8c:	0004861b          	sext.w	a2,s1
    80000b90:	85d2                	mv	a1,s4
    80000b92:	41250533          	sub	a0,a0,s2
    80000b96:	fffff097          	auipc	ra,0xfffff
    80000b9a:	68a080e7          	jalr	1674(ra) # 80000220 <memmove>

    len -= n;
    80000b9e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000ba2:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000ba4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ba8:	02098263          	beqz	s3,80000bcc <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bac:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bb0:	85ca                	mv	a1,s2
    80000bb2:	855a                	mv	a0,s6
    80000bb4:	00000097          	auipc	ra,0x0
    80000bb8:	98e080e7          	jalr	-1650(ra) # 80000542 <walkaddr>
    if(pa0 == 0)
    80000bbc:	cd01                	beqz	a0,80000bd4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bbe:	418904b3          	sub	s1,s2,s8
    80000bc2:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bc4:	fc99f3e3          	bgeu	s3,s1,80000b8a <copyout+0x28>
    80000bc8:	84ce                	mv	s1,s3
    80000bca:	b7c1                	j	80000b8a <copyout+0x28>
  }
  return 0;
    80000bcc:	4501                	li	a0,0
    80000bce:	a021                	j	80000bd6 <copyout+0x74>
    80000bd0:	4501                	li	a0,0
}
    80000bd2:	8082                	ret
      return -1;
    80000bd4:	557d                	li	a0,-1
}
    80000bd6:	60a6                	ld	ra,72(sp)
    80000bd8:	6406                	ld	s0,64(sp)
    80000bda:	74e2                	ld	s1,56(sp)
    80000bdc:	7942                	ld	s2,48(sp)
    80000bde:	79a2                	ld	s3,40(sp)
    80000be0:	7a02                	ld	s4,32(sp)
    80000be2:	6ae2                	ld	s5,24(sp)
    80000be4:	6b42                	ld	s6,16(sp)
    80000be6:	6ba2                	ld	s7,8(sp)
    80000be8:	6c02                	ld	s8,0(sp)
    80000bea:	6161                	add	sp,sp,80
    80000bec:	8082                	ret

0000000080000bee <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bee:	caa5                	beqz	a3,80000c5e <copyin+0x70>
{
    80000bf0:	715d                	add	sp,sp,-80
    80000bf2:	e486                	sd	ra,72(sp)
    80000bf4:	e0a2                	sd	s0,64(sp)
    80000bf6:	fc26                	sd	s1,56(sp)
    80000bf8:	f84a                	sd	s2,48(sp)
    80000bfa:	f44e                	sd	s3,40(sp)
    80000bfc:	f052                	sd	s4,32(sp)
    80000bfe:	ec56                	sd	s5,24(sp)
    80000c00:	e85a                	sd	s6,16(sp)
    80000c02:	e45e                	sd	s7,8(sp)
    80000c04:	e062                	sd	s8,0(sp)
    80000c06:	0880                	add	s0,sp,80
    80000c08:	8b2a                	mv	s6,a0
    80000c0a:	8a2e                	mv	s4,a1
    80000c0c:	8c32                	mv	s8,a2
    80000c0e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c10:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c12:	6a85                	lui	s5,0x1
    80000c14:	a01d                	j	80000c3a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c16:	018505b3          	add	a1,a0,s8
    80000c1a:	0004861b          	sext.w	a2,s1
    80000c1e:	412585b3          	sub	a1,a1,s2
    80000c22:	8552                	mv	a0,s4
    80000c24:	fffff097          	auipc	ra,0xfffff
    80000c28:	5fc080e7          	jalr	1532(ra) # 80000220 <memmove>

    len -= n;
    80000c2c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c30:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c32:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c36:	02098263          	beqz	s3,80000c5a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c3a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c3e:	85ca                	mv	a1,s2
    80000c40:	855a                	mv	a0,s6
    80000c42:	00000097          	auipc	ra,0x0
    80000c46:	900080e7          	jalr	-1792(ra) # 80000542 <walkaddr>
    if(pa0 == 0)
    80000c4a:	cd01                	beqz	a0,80000c62 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c4c:	418904b3          	sub	s1,s2,s8
    80000c50:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c52:	fc99f2e3          	bgeu	s3,s1,80000c16 <copyin+0x28>
    80000c56:	84ce                	mv	s1,s3
    80000c58:	bf7d                	j	80000c16 <copyin+0x28>
  }
  return 0;
    80000c5a:	4501                	li	a0,0
    80000c5c:	a021                	j	80000c64 <copyin+0x76>
    80000c5e:	4501                	li	a0,0
}
    80000c60:	8082                	ret
      return -1;
    80000c62:	557d                	li	a0,-1
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
    80000c76:	6c02                	ld	s8,0(sp)
    80000c78:	6161                	add	sp,sp,80
    80000c7a:	8082                	ret

0000000080000c7c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c7c:	cacd                	beqz	a3,80000d2e <copyinstr+0xb2>
{
    80000c7e:	715d                	add	sp,sp,-80
    80000c80:	e486                	sd	ra,72(sp)
    80000c82:	e0a2                	sd	s0,64(sp)
    80000c84:	fc26                	sd	s1,56(sp)
    80000c86:	f84a                	sd	s2,48(sp)
    80000c88:	f44e                	sd	s3,40(sp)
    80000c8a:	f052                	sd	s4,32(sp)
    80000c8c:	ec56                	sd	s5,24(sp)
    80000c8e:	e85a                	sd	s6,16(sp)
    80000c90:	e45e                	sd	s7,8(sp)
    80000c92:	0880                	add	s0,sp,80
    80000c94:	8a2a                	mv	s4,a0
    80000c96:	8b2e                	mv	s6,a1
    80000c98:	8bb2                	mv	s7,a2
    80000c9a:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000c9c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c9e:	6985                	lui	s3,0x1
    80000ca0:	a825                	j	80000cd8 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ca2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ca6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ca8:	37fd                	addw	a5,a5,-1
    80000caa:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cae:	60a6                	ld	ra,72(sp)
    80000cb0:	6406                	ld	s0,64(sp)
    80000cb2:	74e2                	ld	s1,56(sp)
    80000cb4:	7942                	ld	s2,48(sp)
    80000cb6:	79a2                	ld	s3,40(sp)
    80000cb8:	7a02                	ld	s4,32(sp)
    80000cba:	6ae2                	ld	s5,24(sp)
    80000cbc:	6b42                	ld	s6,16(sp)
    80000cbe:	6ba2                	ld	s7,8(sp)
    80000cc0:	6161                	add	sp,sp,80
    80000cc2:	8082                	ret
    80000cc4:	fff90713          	add	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000cc8:	9742                	add	a4,a4,a6
      --max;
    80000cca:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000cce:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000cd2:	04e58663          	beq	a1,a4,80000d1e <copyinstr+0xa2>
{
    80000cd6:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000cd8:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cdc:	85a6                	mv	a1,s1
    80000cde:	8552                	mv	a0,s4
    80000ce0:	00000097          	auipc	ra,0x0
    80000ce4:	862080e7          	jalr	-1950(ra) # 80000542 <walkaddr>
    if(pa0 == 0)
    80000ce8:	cd0d                	beqz	a0,80000d22 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000cea:	417486b3          	sub	a3,s1,s7
    80000cee:	96ce                	add	a3,a3,s3
    if(n > max)
    80000cf0:	00d97363          	bgeu	s2,a3,80000cf6 <copyinstr+0x7a>
    80000cf4:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000cf6:	955e                	add	a0,a0,s7
    80000cf8:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000cfa:	c695                	beqz	a3,80000d26 <copyinstr+0xaa>
    80000cfc:	87da                	mv	a5,s6
    80000cfe:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d00:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d04:	96da                	add	a3,a3,s6
    80000d06:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d08:	00f60733          	add	a4,a2,a5
    80000d0c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000d10:	db49                	beqz	a4,80000ca2 <copyinstr+0x26>
        *dst = *p;
    80000d12:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d16:	0785                	add	a5,a5,1
    while(n > 0){
    80000d18:	fed797e3          	bne	a5,a3,80000d06 <copyinstr+0x8a>
    80000d1c:	b765                	j	80000cc4 <copyinstr+0x48>
    80000d1e:	4781                	li	a5,0
    80000d20:	b761                	j	80000ca8 <copyinstr+0x2c>
      return -1;
    80000d22:	557d                	li	a0,-1
    80000d24:	b769                	j	80000cae <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000d26:	6b85                	lui	s7,0x1
    80000d28:	9ba6                	add	s7,s7,s1
    80000d2a:	87da                	mv	a5,s6
    80000d2c:	b76d                	j	80000cd6 <copyinstr+0x5a>
  int got_null = 0;
    80000d2e:	4781                	li	a5,0
  if(got_null){
    80000d30:	37fd                	addw	a5,a5,-1
    80000d32:	0007851b          	sext.w	a0,a5
}
    80000d36:	8082                	ret

0000000080000d38 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000d38:	7139                	add	sp,sp,-64
    80000d3a:	fc06                	sd	ra,56(sp)
    80000d3c:	f822                	sd	s0,48(sp)
    80000d3e:	f426                	sd	s1,40(sp)
    80000d40:	f04a                	sd	s2,32(sp)
    80000d42:	ec4e                	sd	s3,24(sp)
    80000d44:	e852                	sd	s4,16(sp)
    80000d46:	e456                	sd	s5,8(sp)
    80000d48:	e05a                	sd	s6,0(sp)
    80000d4a:	0080                	add	s0,sp,64
    80000d4c:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80000d4e:	00008497          	auipc	s1,0x8
    80000d52:	73248493          	add	s1,s1,1842 # 80009480 <proc>
    {
        char *pa = kalloc();
        if (pa == 0)
            panic("kalloc");
        uint64 va = KSTACK((int)(p - proc));
    80000d56:	8b26                	mv	s6,s1
    80000d58:	ff4df937          	lui	s2,0xff4df
    80000d5c:	9bd90913          	add	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b877d>
    80000d60:	0936                	sll	s2,s2,0xd
    80000d62:	6f590913          	add	s2,s2,1781
    80000d66:	0936                	sll	s2,s2,0xd
    80000d68:	bd390913          	add	s2,s2,-1069
    80000d6c:	0932                	sll	s2,s2,0xc
    80000d6e:	7a790913          	add	s2,s2,1959
    80000d72:	040009b7          	lui	s3,0x4000
    80000d76:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d78:	09b2                	sll	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80000d7a:	0000ea97          	auipc	s5,0xe
    80000d7e:	306a8a93          	add	s5,s5,774 # 8000f080 <tickslock>
        char *pa = kalloc();
    80000d82:	fffff097          	auipc	ra,0xfffff
    80000d86:	398080e7          	jalr	920(ra) # 8000011a <kalloc>
    80000d8a:	862a                	mv	a2,a0
        if (pa == 0)
    80000d8c:	c121                	beqz	a0,80000dcc <proc_mapstacks+0x94>
        uint64 va = KSTACK((int)(p - proc));
    80000d8e:	416485b3          	sub	a1,s1,s6
    80000d92:	8591                	sra	a1,a1,0x4
    80000d94:	032585b3          	mul	a1,a1,s2
    80000d98:	2585                	addw	a1,a1,1
    80000d9a:	00d5959b          	sllw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d9e:	4719                	li	a4,6
    80000da0:	6685                	lui	a3,0x1
    80000da2:	40b985b3          	sub	a1,s3,a1
    80000da6:	8552                	mv	a0,s4
    80000da8:	00000097          	auipc	ra,0x0
    80000dac:	87c080e7          	jalr	-1924(ra) # 80000624 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80000db0:	17048493          	add	s1,s1,368
    80000db4:	fd5497e3          	bne	s1,s5,80000d82 <proc_mapstacks+0x4a>
    }
}
    80000db8:	70e2                	ld	ra,56(sp)
    80000dba:	7442                	ld	s0,48(sp)
    80000dbc:	74a2                	ld	s1,40(sp)
    80000dbe:	7902                	ld	s2,32(sp)
    80000dc0:	69e2                	ld	s3,24(sp)
    80000dc2:	6a42                	ld	s4,16(sp)
    80000dc4:	6aa2                	ld	s5,8(sp)
    80000dc6:	6b02                	ld	s6,0(sp)
    80000dc8:	6121                	add	sp,sp,64
    80000dca:	8082                	ret
            panic("kalloc");
    80000dcc:	00007517          	auipc	a0,0x7
    80000dd0:	38c50513          	add	a0,a0,908 # 80008158 <etext+0x158>
    80000dd4:	00005097          	auipc	ra,0x5
    80000dd8:	fb8080e7          	jalr	-72(ra) # 80005d8c <panic>

0000000080000ddc <procinit>:

// initialize the proc table at boot time.
void procinit(void)
{
    80000ddc:	7139                	add	sp,sp,-64
    80000dde:	fc06                	sd	ra,56(sp)
    80000de0:	f822                	sd	s0,48(sp)
    80000de2:	f426                	sd	s1,40(sp)
    80000de4:	f04a                	sd	s2,32(sp)
    80000de6:	ec4e                	sd	s3,24(sp)
    80000de8:	e852                	sd	s4,16(sp)
    80000dea:	e456                	sd	s5,8(sp)
    80000dec:	e05a                	sd	s6,0(sp)
    80000dee:	0080                	add	s0,sp,64
    struct proc *p;

    initlock(&pid_lock, "nextpid");
    80000df0:	00007597          	auipc	a1,0x7
    80000df4:	37058593          	add	a1,a1,880 # 80008160 <etext+0x160>
    80000df8:	00008517          	auipc	a0,0x8
    80000dfc:	25850513          	add	a0,a0,600 # 80009050 <pid_lock>
    80000e00:	00005097          	auipc	ra,0x5
    80000e04:	476080e7          	jalr	1142(ra) # 80006276 <initlock>
    initlock(&wait_lock, "wait_lock");
    80000e08:	00007597          	auipc	a1,0x7
    80000e0c:	36058593          	add	a1,a1,864 # 80008168 <etext+0x168>
    80000e10:	00008517          	auipc	a0,0x8
    80000e14:	25850513          	add	a0,a0,600 # 80009068 <wait_lock>
    80000e18:	00005097          	auipc	ra,0x5
    80000e1c:	45e080e7          	jalr	1118(ra) # 80006276 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80000e20:	00008497          	auipc	s1,0x8
    80000e24:	66048493          	add	s1,s1,1632 # 80009480 <proc>
    {
        initlock(&p->lock, "proc");
    80000e28:	00007b17          	auipc	s6,0x7
    80000e2c:	350b0b13          	add	s6,s6,848 # 80008178 <etext+0x178>
        p->kstack = KSTACK((int)(p - proc));
    80000e30:	8aa6                	mv	s5,s1
    80000e32:	ff4df937          	lui	s2,0xff4df
    80000e36:	9bd90913          	add	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b877d>
    80000e3a:	0936                	sll	s2,s2,0xd
    80000e3c:	6f590913          	add	s2,s2,1781
    80000e40:	0936                	sll	s2,s2,0xd
    80000e42:	bd390913          	add	s2,s2,-1069
    80000e46:	0932                	sll	s2,s2,0xc
    80000e48:	7a790913          	add	s2,s2,1959
    80000e4c:	040009b7          	lui	s3,0x4000
    80000e50:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e52:	09b2                	sll	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80000e54:	0000ea17          	auipc	s4,0xe
    80000e58:	22ca0a13          	add	s4,s4,556 # 8000f080 <tickslock>
        initlock(&p->lock, "proc");
    80000e5c:	85da                	mv	a1,s6
    80000e5e:	8526                	mv	a0,s1
    80000e60:	00005097          	auipc	ra,0x5
    80000e64:	416080e7          	jalr	1046(ra) # 80006276 <initlock>
        p->kstack = KSTACK((int)(p - proc));
    80000e68:	415487b3          	sub	a5,s1,s5
    80000e6c:	8791                	sra	a5,a5,0x4
    80000e6e:	032787b3          	mul	a5,a5,s2
    80000e72:	2785                	addw	a5,a5,1
    80000e74:	00d7979b          	sllw	a5,a5,0xd
    80000e78:	40f987b3          	sub	a5,s3,a5
    80000e7c:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80000e7e:	17048493          	add	s1,s1,368
    80000e82:	fd449de3          	bne	s1,s4,80000e5c <procinit+0x80>
    }
}
    80000e86:	70e2                	ld	ra,56(sp)
    80000e88:	7442                	ld	s0,48(sp)
    80000e8a:	74a2                	ld	s1,40(sp)
    80000e8c:	7902                	ld	s2,32(sp)
    80000e8e:	69e2                	ld	s3,24(sp)
    80000e90:	6a42                	ld	s4,16(sp)
    80000e92:	6aa2                	ld	s5,8(sp)
    80000e94:	6b02                	ld	s6,0(sp)
    80000e96:	6121                	add	sp,sp,64
    80000e98:	8082                	ret

0000000080000e9a <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000e9a:	1141                	add	sp,sp,-16
    80000e9c:	e422                	sd	s0,8(sp)
    80000e9e:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000ea0:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80000ea2:	2501                	sext.w	a0,a0
    80000ea4:	6422                	ld	s0,8(sp)
    80000ea6:	0141                	add	sp,sp,16
    80000ea8:	8082                	ret

0000000080000eaa <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000eaa:	1141                	add	sp,sp,-16
    80000eac:	e422                	sd	s0,8(sp)
    80000eae:	0800                	add	s0,sp,16
    80000eb0:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu *c = &cpus[id];
    80000eb2:	2781                	sext.w	a5,a5
    80000eb4:	079e                	sll	a5,a5,0x7
    return c;
}
    80000eb6:	00008517          	auipc	a0,0x8
    80000eba:	1ca50513          	add	a0,a0,458 # 80009080 <cpus>
    80000ebe:	953e                	add	a0,a0,a5
    80000ec0:	6422                	ld	s0,8(sp)
    80000ec2:	0141                	add	sp,sp,16
    80000ec4:	8082                	ret

0000000080000ec6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000ec6:	1101                	add	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	1000                	add	s0,sp,32
    push_off();
    80000ed0:	00005097          	auipc	ra,0x5
    80000ed4:	3ea080e7          	jalr	1002(ra) # 800062ba <push_off>
    80000ed8:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000eda:	2781                	sext.w	a5,a5
    80000edc:	079e                	sll	a5,a5,0x7
    80000ede:	00008717          	auipc	a4,0x8
    80000ee2:	17270713          	add	a4,a4,370 # 80009050 <pid_lock>
    80000ee6:	97ba                	add	a5,a5,a4
    80000ee8:	7b84                	ld	s1,48(a5)
    pop_off();
    80000eea:	00005097          	auipc	ra,0x5
    80000eee:	470080e7          	jalr	1136(ra) # 8000635a <pop_off>
    return p;
}
    80000ef2:	8526                	mv	a0,s1
    80000ef4:	60e2                	ld	ra,24(sp)
    80000ef6:	6442                	ld	s0,16(sp)
    80000ef8:	64a2                	ld	s1,8(sp)
    80000efa:	6105                	add	sp,sp,32
    80000efc:	8082                	ret

0000000080000efe <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000efe:	1141                	add	sp,sp,-16
    80000f00:	e406                	sd	ra,8(sp)
    80000f02:	e022                	sd	s0,0(sp)
    80000f04:	0800                	add	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80000f06:	00000097          	auipc	ra,0x0
    80000f0a:	fc0080e7          	jalr	-64(ra) # 80000ec6 <myproc>
    80000f0e:	00005097          	auipc	ra,0x5
    80000f12:	4ac080e7          	jalr	1196(ra) # 800063ba <release>

    if (first)
    80000f16:	00008797          	auipc	a5,0x8
    80000f1a:	a8a7a783          	lw	a5,-1398(a5) # 800089a0 <first.1>
    80000f1e:	eb89                	bnez	a5,80000f30 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80000f20:	00001097          	auipc	ra,0x1
    80000f24:	c72080e7          	jalr	-910(ra) # 80001b92 <usertrapret>
}
    80000f28:	60a2                	ld	ra,8(sp)
    80000f2a:	6402                	ld	s0,0(sp)
    80000f2c:	0141                	add	sp,sp,16
    80000f2e:	8082                	ret
        first = 0;
    80000f30:	00008797          	auipc	a5,0x8
    80000f34:	a607a823          	sw	zero,-1424(a5) # 800089a0 <first.1>
        fsinit(ROOTDEV);
    80000f38:	4505                	li	a0,1
    80000f3a:	00002097          	auipc	ra,0x2
    80000f3e:	a76080e7          	jalr	-1418(ra) # 800029b0 <fsinit>
    80000f42:	bff9                	j	80000f20 <forkret+0x22>

0000000080000f44 <allocpid>:
{
    80000f44:	1101                	add	sp,sp,-32
    80000f46:	ec06                	sd	ra,24(sp)
    80000f48:	e822                	sd	s0,16(sp)
    80000f4a:	e426                	sd	s1,8(sp)
    80000f4c:	e04a                	sd	s2,0(sp)
    80000f4e:	1000                	add	s0,sp,32
    acquire(&pid_lock);
    80000f50:	00008917          	auipc	s2,0x8
    80000f54:	10090913          	add	s2,s2,256 # 80009050 <pid_lock>
    80000f58:	854a                	mv	a0,s2
    80000f5a:	00005097          	auipc	ra,0x5
    80000f5e:	3ac080e7          	jalr	940(ra) # 80006306 <acquire>
    pid = nextpid;
    80000f62:	00008797          	auipc	a5,0x8
    80000f66:	a4278793          	add	a5,a5,-1470 # 800089a4 <nextpid>
    80000f6a:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000f6c:	0014871b          	addw	a4,s1,1
    80000f70:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000f72:	854a                	mv	a0,s2
    80000f74:	00005097          	auipc	ra,0x5
    80000f78:	446080e7          	jalr	1094(ra) # 800063ba <release>
}
    80000f7c:	8526                	mv	a0,s1
    80000f7e:	60e2                	ld	ra,24(sp)
    80000f80:	6442                	ld	s0,16(sp)
    80000f82:	64a2                	ld	s1,8(sp)
    80000f84:	6902                	ld	s2,0(sp)
    80000f86:	6105                	add	sp,sp,32
    80000f88:	8082                	ret

0000000080000f8a <proc_pagetable>:
{
    80000f8a:	1101                	add	sp,sp,-32
    80000f8c:	ec06                	sd	ra,24(sp)
    80000f8e:	e822                	sd	s0,16(sp)
    80000f90:	e426                	sd	s1,8(sp)
    80000f92:	e04a                	sd	s2,0(sp)
    80000f94:	1000                	add	s0,sp,32
    80000f96:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	886080e7          	jalr	-1914(ra) # 8000081e <uvmcreate>
    80000fa0:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80000fa2:	c121                	beqz	a0,80000fe2 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fa4:	4729                	li	a4,10
    80000fa6:	00006697          	auipc	a3,0x6
    80000faa:	05a68693          	add	a3,a3,90 # 80007000 <_trampoline>
    80000fae:	6605                	lui	a2,0x1
    80000fb0:	040005b7          	lui	a1,0x4000
    80000fb4:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fb6:	05b2                	sll	a1,a1,0xc
    80000fb8:	fffff097          	auipc	ra,0xfffff
    80000fbc:	5cc080e7          	jalr	1484(ra) # 80000584 <mappages>
    80000fc0:	02054863          	bltz	a0,80000ff0 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fc4:	4719                	li	a4,6
    80000fc6:	05893683          	ld	a3,88(s2)
    80000fca:	6605                	lui	a2,0x1
    80000fcc:	020005b7          	lui	a1,0x2000
    80000fd0:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fd2:	05b6                	sll	a1,a1,0xd
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	5ae080e7          	jalr	1454(ra) # 80000584 <mappages>
    80000fde:	02054163          	bltz	a0,80001000 <proc_pagetable+0x76>
}
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	60e2                	ld	ra,24(sp)
    80000fe6:	6442                	ld	s0,16(sp)
    80000fe8:	64a2                	ld	s1,8(sp)
    80000fea:	6902                	ld	s2,0(sp)
    80000fec:	6105                	add	sp,sp,32
    80000fee:	8082                	ret
        uvmfree(pagetable, 0);
    80000ff0:	4581                	li	a1,0
    80000ff2:	8526                	mv	a0,s1
    80000ff4:	00000097          	auipc	ra,0x0
    80000ff8:	a30080e7          	jalr	-1488(ra) # 80000a24 <uvmfree>
        return 0;
    80000ffc:	4481                	li	s1,0
    80000ffe:	b7d5                	j	80000fe2 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001000:	4681                	li	a3,0
    80001002:	4605                	li	a2,1
    80001004:	040005b7          	lui	a1,0x4000
    80001008:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000100a:	05b2                	sll	a1,a1,0xc
    8000100c:	8526                	mv	a0,s1
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	73c080e7          	jalr	1852(ra) # 8000074a <uvmunmap>
        uvmfree(pagetable, 0);
    80001016:	4581                	li	a1,0
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	a0a080e7          	jalr	-1526(ra) # 80000a24 <uvmfree>
        return 0;
    80001022:	4481                	li	s1,0
    80001024:	bf7d                	j	80000fe2 <proc_pagetable+0x58>

0000000080001026 <proc_freepagetable>:
{
    80001026:	1101                	add	sp,sp,-32
    80001028:	ec06                	sd	ra,24(sp)
    8000102a:	e822                	sd	s0,16(sp)
    8000102c:	e426                	sd	s1,8(sp)
    8000102e:	e04a                	sd	s2,0(sp)
    80001030:	1000                	add	s0,sp,32
    80001032:	84aa                	mv	s1,a0
    80001034:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001036:	4681                	li	a3,0
    80001038:	4605                	li	a2,1
    8000103a:	040005b7          	lui	a1,0x4000
    8000103e:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001040:	05b2                	sll	a1,a1,0xc
    80001042:	fffff097          	auipc	ra,0xfffff
    80001046:	708080e7          	jalr	1800(ra) # 8000074a <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000104a:	4681                	li	a3,0
    8000104c:	4605                	li	a2,1
    8000104e:	020005b7          	lui	a1,0x2000
    80001052:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001054:	05b6                	sll	a1,a1,0xd
    80001056:	8526                	mv	a0,s1
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	6f2080e7          	jalr	1778(ra) # 8000074a <uvmunmap>
    uvmfree(pagetable, sz);
    80001060:	85ca                	mv	a1,s2
    80001062:	8526                	mv	a0,s1
    80001064:	00000097          	auipc	ra,0x0
    80001068:	9c0080e7          	jalr	-1600(ra) # 80000a24 <uvmfree>
}
    8000106c:	60e2                	ld	ra,24(sp)
    8000106e:	6442                	ld	s0,16(sp)
    80001070:	64a2                	ld	s1,8(sp)
    80001072:	6902                	ld	s2,0(sp)
    80001074:	6105                	add	sp,sp,32
    80001076:	8082                	ret

0000000080001078 <freeproc>:
{
    80001078:	1101                	add	sp,sp,-32
    8000107a:	ec06                	sd	ra,24(sp)
    8000107c:	e822                	sd	s0,16(sp)
    8000107e:	e426                	sd	s1,8(sp)
    80001080:	1000                	add	s0,sp,32
    80001082:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001084:	6d28                	ld	a0,88(a0)
    80001086:	c509                	beqz	a0,80001090 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001088:	fffff097          	auipc	ra,0xfffff
    8000108c:	f94080e7          	jalr	-108(ra) # 8000001c <kfree>
    p->trapframe = 0;
    80001090:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001094:	68a8                	ld	a0,80(s1)
    80001096:	c511                	beqz	a0,800010a2 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001098:	64ac                	ld	a1,72(s1)
    8000109a:	00000097          	auipc	ra,0x0
    8000109e:	f8c080e7          	jalr	-116(ra) # 80001026 <proc_freepagetable>
    p->pagetable = 0;
    800010a2:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    800010a6:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    800010aa:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    800010ae:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    800010b2:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    800010b6:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    800010ba:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    800010be:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    800010c2:	0004ac23          	sw	zero,24(s1)
}
    800010c6:	60e2                	ld	ra,24(sp)
    800010c8:	6442                	ld	s0,16(sp)
    800010ca:	64a2                	ld	s1,8(sp)
    800010cc:	6105                	add	sp,sp,32
    800010ce:	8082                	ret

00000000800010d0 <allocproc>:
{
    800010d0:	1101                	add	sp,sp,-32
    800010d2:	ec06                	sd	ra,24(sp)
    800010d4:	e822                	sd	s0,16(sp)
    800010d6:	e426                	sd	s1,8(sp)
    800010d8:	e04a                	sd	s2,0(sp)
    800010da:	1000                	add	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    800010dc:	00008497          	auipc	s1,0x8
    800010e0:	3a448493          	add	s1,s1,932 # 80009480 <proc>
    800010e4:	0000e917          	auipc	s2,0xe
    800010e8:	f9c90913          	add	s2,s2,-100 # 8000f080 <tickslock>
        acquire(&p->lock);
    800010ec:	8526                	mv	a0,s1
    800010ee:	00005097          	auipc	ra,0x5
    800010f2:	218080e7          	jalr	536(ra) # 80006306 <acquire>
        if (p->state == UNUSED)
    800010f6:	4c9c                	lw	a5,24(s1)
    800010f8:	cf81                	beqz	a5,80001110 <allocproc+0x40>
            release(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	2be080e7          	jalr	702(ra) # 800063ba <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001104:	17048493          	add	s1,s1,368
    80001108:	ff2492e3          	bne	s1,s2,800010ec <allocproc+0x1c>
    return 0;
    8000110c:	4481                	li	s1,0
    8000110e:	a889                	j	80001160 <allocproc+0x90>
    p->pid = allocpid();
    80001110:	00000097          	auipc	ra,0x0
    80001114:	e34080e7          	jalr	-460(ra) # 80000f44 <allocpid>
    80001118:	d888                	sw	a0,48(s1)
    p->state = USED;
    8000111a:	4785                	li	a5,1
    8000111c:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    8000111e:	fffff097          	auipc	ra,0xfffff
    80001122:	ffc080e7          	jalr	-4(ra) # 8000011a <kalloc>
    80001126:	892a                	mv	s2,a0
    80001128:	eca8                	sd	a0,88(s1)
    8000112a:	c131                	beqz	a0,8000116e <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    8000112c:	8526                	mv	a0,s1
    8000112e:	00000097          	auipc	ra,0x0
    80001132:	e5c080e7          	jalr	-420(ra) # 80000f8a <proc_pagetable>
    80001136:	892a                	mv	s2,a0
    80001138:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    8000113a:	c531                	beqz	a0,80001186 <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    8000113c:	07000613          	li	a2,112
    80001140:	4581                	li	a1,0
    80001142:	06048513          	add	a0,s1,96
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	07e080e7          	jalr	126(ra) # 800001c4 <memset>
    p->context.ra = (uint64)forkret;
    8000114e:	00000797          	auipc	a5,0x0
    80001152:	db078793          	add	a5,a5,-592 # 80000efe <forkret>
    80001156:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001158:	60bc                	ld	a5,64(s1)
    8000115a:	6705                	lui	a4,0x1
    8000115c:	97ba                	add	a5,a5,a4
    8000115e:	f4bc                	sd	a5,104(s1)
}
    80001160:	8526                	mv	a0,s1
    80001162:	60e2                	ld	ra,24(sp)
    80001164:	6442                	ld	s0,16(sp)
    80001166:	64a2                	ld	s1,8(sp)
    80001168:	6902                	ld	s2,0(sp)
    8000116a:	6105                	add	sp,sp,32
    8000116c:	8082                	ret
        freeproc(p);
    8000116e:	8526                	mv	a0,s1
    80001170:	00000097          	auipc	ra,0x0
    80001174:	f08080e7          	jalr	-248(ra) # 80001078 <freeproc>
        release(&p->lock);
    80001178:	8526                	mv	a0,s1
    8000117a:	00005097          	auipc	ra,0x5
    8000117e:	240080e7          	jalr	576(ra) # 800063ba <release>
        return 0;
    80001182:	84ca                	mv	s1,s2
    80001184:	bff1                	j	80001160 <allocproc+0x90>
        freeproc(p);
    80001186:	8526                	mv	a0,s1
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	ef0080e7          	jalr	-272(ra) # 80001078 <freeproc>
        release(&p->lock);
    80001190:	8526                	mv	a0,s1
    80001192:	00005097          	auipc	ra,0x5
    80001196:	228080e7          	jalr	552(ra) # 800063ba <release>
        return 0;
    8000119a:	84ca                	mv	s1,s2
    8000119c:	b7d1                	j	80001160 <allocproc+0x90>

000000008000119e <userinit>:
{
    8000119e:	1101                	add	sp,sp,-32
    800011a0:	ec06                	sd	ra,24(sp)
    800011a2:	e822                	sd	s0,16(sp)
    800011a4:	e426                	sd	s1,8(sp)
    800011a6:	1000                	add	s0,sp,32
    p = allocproc();
    800011a8:	00000097          	auipc	ra,0x0
    800011ac:	f28080e7          	jalr	-216(ra) # 800010d0 <allocproc>
    800011b0:	84aa                	mv	s1,a0
    initproc = p;
    800011b2:	00008797          	auipc	a5,0x8
    800011b6:	e4a7bf23          	sd	a0,-418(a5) # 80009010 <initproc>
    uvminit(p->pagetable, initcode, sizeof(initcode));
    800011ba:	03400613          	li	a2,52
    800011be:	00007597          	auipc	a1,0x7
    800011c2:	7f258593          	add	a1,a1,2034 # 800089b0 <initcode>
    800011c6:	6928                	ld	a0,80(a0)
    800011c8:	fffff097          	auipc	ra,0xfffff
    800011cc:	684080e7          	jalr	1668(ra) # 8000084c <uvminit>
    p->sz = PGSIZE;
    800011d0:	6785                	lui	a5,0x1
    800011d2:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    800011d4:	6cb8                	ld	a4,88(s1)
    800011d6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    800011da:	6cb8                	ld	a4,88(s1)
    800011dc:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    800011de:	4641                	li	a2,16
    800011e0:	00007597          	auipc	a1,0x7
    800011e4:	fa058593          	add	a1,a1,-96 # 80008180 <etext+0x180>
    800011e8:	15848513          	add	a0,s1,344
    800011ec:	fffff097          	auipc	ra,0xfffff
    800011f0:	11a080e7          	jalr	282(ra) # 80000306 <safestrcpy>
    p->cwd = namei("/");
    800011f4:	00007517          	auipc	a0,0x7
    800011f8:	f9c50513          	add	a0,a0,-100 # 80008190 <etext+0x190>
    800011fc:	00002097          	auipc	ra,0x2
    80001200:	1fa080e7          	jalr	506(ra) # 800033f6 <namei>
    80001204:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001208:	478d                	li	a5,3
    8000120a:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    8000120c:	8526                	mv	a0,s1
    8000120e:	00005097          	auipc	ra,0x5
    80001212:	1ac080e7          	jalr	428(ra) # 800063ba <release>
}
    80001216:	60e2                	ld	ra,24(sp)
    80001218:	6442                	ld	s0,16(sp)
    8000121a:	64a2                	ld	s1,8(sp)
    8000121c:	6105                	add	sp,sp,32
    8000121e:	8082                	ret

0000000080001220 <growproc>:
{
    80001220:	1101                	add	sp,sp,-32
    80001222:	ec06                	sd	ra,24(sp)
    80001224:	e822                	sd	s0,16(sp)
    80001226:	e426                	sd	s1,8(sp)
    80001228:	e04a                	sd	s2,0(sp)
    8000122a:	1000                	add	s0,sp,32
    8000122c:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	c98080e7          	jalr	-872(ra) # 80000ec6 <myproc>
    80001236:	892a                	mv	s2,a0
    sz = p->sz;
    80001238:	652c                	ld	a1,72(a0)
    8000123a:	0005879b          	sext.w	a5,a1
    if (n > 0)
    8000123e:	00904f63          	bgtz	s1,8000125c <growproc+0x3c>
    else if (n < 0)
    80001242:	0204cd63          	bltz	s1,8000127c <growproc+0x5c>
    p->sz = sz;
    80001246:	1782                	sll	a5,a5,0x20
    80001248:	9381                	srl	a5,a5,0x20
    8000124a:	04f93423          	sd	a5,72(s2)
    return 0;
    8000124e:	4501                	li	a0,0
}
    80001250:	60e2                	ld	ra,24(sp)
    80001252:	6442                	ld	s0,16(sp)
    80001254:	64a2                	ld	s1,8(sp)
    80001256:	6902                	ld	s2,0(sp)
    80001258:	6105                	add	sp,sp,32
    8000125a:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0)
    8000125c:	00f4863b          	addw	a2,s1,a5
    80001260:	1602                	sll	a2,a2,0x20
    80001262:	9201                	srl	a2,a2,0x20
    80001264:	1582                	sll	a1,a1,0x20
    80001266:	9181                	srl	a1,a1,0x20
    80001268:	6928                	ld	a0,80(a0)
    8000126a:	fffff097          	auipc	ra,0xfffff
    8000126e:	69c080e7          	jalr	1692(ra) # 80000906 <uvmalloc>
    80001272:	0005079b          	sext.w	a5,a0
    80001276:	fbe1                	bnez	a5,80001246 <growproc+0x26>
            return -1;
    80001278:	557d                	li	a0,-1
    8000127a:	bfd9                	j	80001250 <growproc+0x30>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000127c:	00f4863b          	addw	a2,s1,a5
    80001280:	1602                	sll	a2,a2,0x20
    80001282:	9201                	srl	a2,a2,0x20
    80001284:	1582                	sll	a1,a1,0x20
    80001286:	9181                	srl	a1,a1,0x20
    80001288:	6928                	ld	a0,80(a0)
    8000128a:	fffff097          	auipc	ra,0xfffff
    8000128e:	634080e7          	jalr	1588(ra) # 800008be <uvmdealloc>
    80001292:	0005079b          	sext.w	a5,a0
    80001296:	bf45                	j	80001246 <growproc+0x26>

0000000080001298 <fork>:
{
    80001298:	7139                	add	sp,sp,-64
    8000129a:	fc06                	sd	ra,56(sp)
    8000129c:	f822                	sd	s0,48(sp)
    8000129e:	f04a                	sd	s2,32(sp)
    800012a0:	e456                	sd	s5,8(sp)
    800012a2:	0080                	add	s0,sp,64
    struct proc *p = myproc();
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	c22080e7          	jalr	-990(ra) # 80000ec6 <myproc>
    800012ac:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	e22080e7          	jalr	-478(ra) # 800010d0 <allocproc>
    800012b6:	12050463          	beqz	a0,800013de <fork+0x146>
    800012ba:	ec4e                	sd	s3,24(sp)
    800012bc:	89aa                	mv	s3,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    800012be:	048ab603          	ld	a2,72(s5)
    800012c2:	692c                	ld	a1,80(a0)
    800012c4:	050ab503          	ld	a0,80(s5)
    800012c8:	fffff097          	auipc	ra,0xfffff
    800012cc:	796080e7          	jalr	1942(ra) # 80000a5e <uvmcopy>
    800012d0:	04054e63          	bltz	a0,8000132c <fork+0x94>
    800012d4:	f426                	sd	s1,40(sp)
    800012d6:	e852                	sd	s4,16(sp)
    np->sz = p->sz;
    800012d8:	048ab783          	ld	a5,72(s5)
    800012dc:	04f9b423          	sd	a5,72(s3)
    np->trace_mask = p->trace_mask;
    800012e0:	168aa783          	lw	a5,360(s5)
    800012e4:	16f9a423          	sw	a5,360(s3)
    *(np->trapframe) = *(p->trapframe);
    800012e8:	058ab683          	ld	a3,88(s5)
    800012ec:	87b6                	mv	a5,a3
    800012ee:	0589b703          	ld	a4,88(s3)
    800012f2:	12068693          	add	a3,a3,288
    800012f6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012fa:	6788                	ld	a0,8(a5)
    800012fc:	6b8c                	ld	a1,16(a5)
    800012fe:	6f90                	ld	a2,24(a5)
    80001300:	01073023          	sd	a6,0(a4)
    80001304:	e708                	sd	a0,8(a4)
    80001306:	eb0c                	sd	a1,16(a4)
    80001308:	ef10                	sd	a2,24(a4)
    8000130a:	02078793          	add	a5,a5,32
    8000130e:	02070713          	add	a4,a4,32
    80001312:	fed792e3          	bne	a5,a3,800012f6 <fork+0x5e>
    np->trapframe->a0 = 0;
    80001316:	0589b783          	ld	a5,88(s3)
    8000131a:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    8000131e:	0d0a8493          	add	s1,s5,208
    80001322:	0d098913          	add	s2,s3,208
    80001326:	150a8a13          	add	s4,s5,336
    8000132a:	a015                	j	8000134e <fork+0xb6>
        freeproc(np);
    8000132c:	854e                	mv	a0,s3
    8000132e:	00000097          	auipc	ra,0x0
    80001332:	d4a080e7          	jalr	-694(ra) # 80001078 <freeproc>
        release(&np->lock);
    80001336:	854e                	mv	a0,s3
    80001338:	00005097          	auipc	ra,0x5
    8000133c:	082080e7          	jalr	130(ra) # 800063ba <release>
        return -1;
    80001340:	597d                	li	s2,-1
    80001342:	69e2                	ld	s3,24(sp)
    80001344:	a071                	j	800013d0 <fork+0x138>
    for (i = 0; i < NOFILE; i++)
    80001346:	04a1                	add	s1,s1,8
    80001348:	0921                	add	s2,s2,8
    8000134a:	01448b63          	beq	s1,s4,80001360 <fork+0xc8>
        if (p->ofile[i])
    8000134e:	6088                	ld	a0,0(s1)
    80001350:	d97d                	beqz	a0,80001346 <fork+0xae>
            np->ofile[i] = filedup(p->ofile[i]);
    80001352:	00002097          	auipc	ra,0x2
    80001356:	71c080e7          	jalr	1820(ra) # 80003a6e <filedup>
    8000135a:	00a93023          	sd	a0,0(s2)
    8000135e:	b7e5                	j	80001346 <fork+0xae>
    np->cwd = idup(p->cwd);
    80001360:	150ab503          	ld	a0,336(s5)
    80001364:	00002097          	auipc	ra,0x2
    80001368:	882080e7          	jalr	-1918(ra) # 80002be6 <idup>
    8000136c:	14a9b823          	sd	a0,336(s3)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80001370:	4641                	li	a2,16
    80001372:	158a8593          	add	a1,s5,344
    80001376:	15898513          	add	a0,s3,344
    8000137a:	fffff097          	auipc	ra,0xfffff
    8000137e:	f8c080e7          	jalr	-116(ra) # 80000306 <safestrcpy>
    pid = np->pid;
    80001382:	0309a903          	lw	s2,48(s3)
    release(&np->lock);
    80001386:	854e                	mv	a0,s3
    80001388:	00005097          	auipc	ra,0x5
    8000138c:	032080e7          	jalr	50(ra) # 800063ba <release>
    acquire(&wait_lock);
    80001390:	00008497          	auipc	s1,0x8
    80001394:	cd848493          	add	s1,s1,-808 # 80009068 <wait_lock>
    80001398:	8526                	mv	a0,s1
    8000139a:	00005097          	auipc	ra,0x5
    8000139e:	f6c080e7          	jalr	-148(ra) # 80006306 <acquire>
    np->parent = p;
    800013a2:	0359bc23          	sd	s5,56(s3)
    release(&wait_lock);
    800013a6:	8526                	mv	a0,s1
    800013a8:	00005097          	auipc	ra,0x5
    800013ac:	012080e7          	jalr	18(ra) # 800063ba <release>
    acquire(&np->lock);
    800013b0:	854e                	mv	a0,s3
    800013b2:	00005097          	auipc	ra,0x5
    800013b6:	f54080e7          	jalr	-172(ra) # 80006306 <acquire>
    np->state = RUNNABLE;
    800013ba:	478d                	li	a5,3
    800013bc:	00f9ac23          	sw	a5,24(s3)
    release(&np->lock);
    800013c0:	854e                	mv	a0,s3
    800013c2:	00005097          	auipc	ra,0x5
    800013c6:	ff8080e7          	jalr	-8(ra) # 800063ba <release>
    return pid;
    800013ca:	74a2                	ld	s1,40(sp)
    800013cc:	69e2                	ld	s3,24(sp)
    800013ce:	6a42                	ld	s4,16(sp)
}
    800013d0:	854a                	mv	a0,s2
    800013d2:	70e2                	ld	ra,56(sp)
    800013d4:	7442                	ld	s0,48(sp)
    800013d6:	7902                	ld	s2,32(sp)
    800013d8:	6aa2                	ld	s5,8(sp)
    800013da:	6121                	add	sp,sp,64
    800013dc:	8082                	ret
        return -1;
    800013de:	597d                	li	s2,-1
    800013e0:	bfc5                	j	800013d0 <fork+0x138>

00000000800013e2 <scheduler>:
{
    800013e2:	7139                	add	sp,sp,-64
    800013e4:	fc06                	sd	ra,56(sp)
    800013e6:	f822                	sd	s0,48(sp)
    800013e8:	f426                	sd	s1,40(sp)
    800013ea:	f04a                	sd	s2,32(sp)
    800013ec:	ec4e                	sd	s3,24(sp)
    800013ee:	e852                	sd	s4,16(sp)
    800013f0:	e456                	sd	s5,8(sp)
    800013f2:	e05a                	sd	s6,0(sp)
    800013f4:	0080                	add	s0,sp,64
    800013f6:	8792                	mv	a5,tp
    int id = r_tp();
    800013f8:	2781                	sext.w	a5,a5
    c->proc = 0;
    800013fa:	00779a93          	sll	s5,a5,0x7
    800013fe:	00008717          	auipc	a4,0x8
    80001402:	c5270713          	add	a4,a4,-942 # 80009050 <pid_lock>
    80001406:	9756                	add	a4,a4,s5
    80001408:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    8000140c:	00008717          	auipc	a4,0x8
    80001410:	c7c70713          	add	a4,a4,-900 # 80009088 <cpus+0x8>
    80001414:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE)
    80001416:	498d                	li	s3,3
                p->state = RUNNING;
    80001418:	4b11                	li	s6,4
                c->proc = p;
    8000141a:	079e                	sll	a5,a5,0x7
    8000141c:	00008a17          	auipc	s4,0x8
    80001420:	c34a0a13          	add	s4,s4,-972 # 80009050 <pid_lock>
    80001424:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++)
    80001426:	0000e917          	auipc	s2,0xe
    8000142a:	c5a90913          	add	s2,s2,-934 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001432:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001436:	10079073          	csrw	sstatus,a5
    8000143a:	00008497          	auipc	s1,0x8
    8000143e:	04648493          	add	s1,s1,70 # 80009480 <proc>
    80001442:	a811                	j	80001456 <scheduler+0x74>
            release(&p->lock);
    80001444:	8526                	mv	a0,s1
    80001446:	00005097          	auipc	ra,0x5
    8000144a:	f74080e7          	jalr	-140(ra) # 800063ba <release>
        for (p = proc; p < &proc[NPROC]; p++)
    8000144e:	17048493          	add	s1,s1,368
    80001452:	fd248ee3          	beq	s1,s2,8000142e <scheduler+0x4c>
            acquire(&p->lock);
    80001456:	8526                	mv	a0,s1
    80001458:	00005097          	auipc	ra,0x5
    8000145c:	eae080e7          	jalr	-338(ra) # 80006306 <acquire>
            if (p->state == RUNNABLE)
    80001460:	4c9c                	lw	a5,24(s1)
    80001462:	ff3791e3          	bne	a5,s3,80001444 <scheduler+0x62>
                p->state = RUNNING;
    80001466:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    8000146a:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    8000146e:	06048593          	add	a1,s1,96
    80001472:	8556                	mv	a0,s5
    80001474:	00000097          	auipc	ra,0x0
    80001478:	674080e7          	jalr	1652(ra) # 80001ae8 <swtch>
                c->proc = 0;
    8000147c:	020a3823          	sd	zero,48(s4)
    80001480:	b7d1                	j	80001444 <scheduler+0x62>

0000000080001482 <sched>:
{
    80001482:	7179                	add	sp,sp,-48
    80001484:	f406                	sd	ra,40(sp)
    80001486:	f022                	sd	s0,32(sp)
    80001488:	ec26                	sd	s1,24(sp)
    8000148a:	e84a                	sd	s2,16(sp)
    8000148c:	e44e                	sd	s3,8(sp)
    8000148e:	1800                	add	s0,sp,48
    struct proc *p = myproc();
    80001490:	00000097          	auipc	ra,0x0
    80001494:	a36080e7          	jalr	-1482(ra) # 80000ec6 <myproc>
    80001498:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    8000149a:	00005097          	auipc	ra,0x5
    8000149e:	df2080e7          	jalr	-526(ra) # 8000628c <holding>
    800014a2:	c93d                	beqz	a0,80001518 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014a4:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	sll	a5,a5,0x7
    800014aa:	00008717          	auipc	a4,0x8
    800014ae:	ba670713          	add	a4,a4,-1114 # 80009050 <pid_lock>
    800014b2:	97ba                	add	a5,a5,a4
    800014b4:	0a87a703          	lw	a4,168(a5)
    800014b8:	4785                	li	a5,1
    800014ba:	06f71763          	bne	a4,a5,80001528 <sched+0xa6>
    if (p->state == RUNNING)
    800014be:	4c98                	lw	a4,24(s1)
    800014c0:	4791                	li	a5,4
    800014c2:	06f70b63          	beq	a4,a5,80001538 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014c6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ca:	8b89                	and	a5,a5,2
    if (intr_get())
    800014cc:	efb5                	bnez	a5,80001548 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014ce:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    800014d0:	00008917          	auipc	s2,0x8
    800014d4:	b8090913          	add	s2,s2,-1152 # 80009050 <pid_lock>
    800014d8:	2781                	sext.w	a5,a5
    800014da:	079e                	sll	a5,a5,0x7
    800014dc:	97ca                	add	a5,a5,s2
    800014de:	0ac7a983          	lw	s3,172(a5)
    800014e2:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    800014e4:	2781                	sext.w	a5,a5
    800014e6:	079e                	sll	a5,a5,0x7
    800014e8:	00008597          	auipc	a1,0x8
    800014ec:	ba058593          	add	a1,a1,-1120 # 80009088 <cpus+0x8>
    800014f0:	95be                	add	a1,a1,a5
    800014f2:	06048513          	add	a0,s1,96
    800014f6:	00000097          	auipc	ra,0x0
    800014fa:	5f2080e7          	jalr	1522(ra) # 80001ae8 <swtch>
    800014fe:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80001500:	2781                	sext.w	a5,a5
    80001502:	079e                	sll	a5,a5,0x7
    80001504:	993e                	add	s2,s2,a5
    80001506:	0b392623          	sw	s3,172(s2)
}
    8000150a:	70a2                	ld	ra,40(sp)
    8000150c:	7402                	ld	s0,32(sp)
    8000150e:	64e2                	ld	s1,24(sp)
    80001510:	6942                	ld	s2,16(sp)
    80001512:	69a2                	ld	s3,8(sp)
    80001514:	6145                	add	sp,sp,48
    80001516:	8082                	ret
        panic("sched p->lock");
    80001518:	00007517          	auipc	a0,0x7
    8000151c:	c8050513          	add	a0,a0,-896 # 80008198 <etext+0x198>
    80001520:	00005097          	auipc	ra,0x5
    80001524:	86c080e7          	jalr	-1940(ra) # 80005d8c <panic>
        panic("sched locks");
    80001528:	00007517          	auipc	a0,0x7
    8000152c:	c8050513          	add	a0,a0,-896 # 800081a8 <etext+0x1a8>
    80001530:	00005097          	auipc	ra,0x5
    80001534:	85c080e7          	jalr	-1956(ra) # 80005d8c <panic>
        panic("sched running");
    80001538:	00007517          	auipc	a0,0x7
    8000153c:	c8050513          	add	a0,a0,-896 # 800081b8 <etext+0x1b8>
    80001540:	00005097          	auipc	ra,0x5
    80001544:	84c080e7          	jalr	-1972(ra) # 80005d8c <panic>
        panic("sched interruptible");
    80001548:	00007517          	auipc	a0,0x7
    8000154c:	c8050513          	add	a0,a0,-896 # 800081c8 <etext+0x1c8>
    80001550:	00005097          	auipc	ra,0x5
    80001554:	83c080e7          	jalr	-1988(ra) # 80005d8c <panic>

0000000080001558 <yield>:
{
    80001558:	1101                	add	sp,sp,-32
    8000155a:	ec06                	sd	ra,24(sp)
    8000155c:	e822                	sd	s0,16(sp)
    8000155e:	e426                	sd	s1,8(sp)
    80001560:	1000                	add	s0,sp,32
    struct proc *p = myproc();
    80001562:	00000097          	auipc	ra,0x0
    80001566:	964080e7          	jalr	-1692(ra) # 80000ec6 <myproc>
    8000156a:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000156c:	00005097          	auipc	ra,0x5
    80001570:	d9a080e7          	jalr	-614(ra) # 80006306 <acquire>
    p->state = RUNNABLE;
    80001574:	478d                	li	a5,3
    80001576:	cc9c                	sw	a5,24(s1)
    sched();
    80001578:	00000097          	auipc	ra,0x0
    8000157c:	f0a080e7          	jalr	-246(ra) # 80001482 <sched>
    release(&p->lock);
    80001580:	8526                	mv	a0,s1
    80001582:	00005097          	auipc	ra,0x5
    80001586:	e38080e7          	jalr	-456(ra) # 800063ba <release>
}
    8000158a:	60e2                	ld	ra,24(sp)
    8000158c:	6442                	ld	s0,16(sp)
    8000158e:	64a2                	ld	s1,8(sp)
    80001590:	6105                	add	sp,sp,32
    80001592:	8082                	ret

0000000080001594 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001594:	7179                	add	sp,sp,-48
    80001596:	f406                	sd	ra,40(sp)
    80001598:	f022                	sd	s0,32(sp)
    8000159a:	ec26                	sd	s1,24(sp)
    8000159c:	e84a                	sd	s2,16(sp)
    8000159e:	e44e                	sd	s3,8(sp)
    800015a0:	1800                	add	s0,sp,48
    800015a2:	89aa                	mv	s3,a0
    800015a4:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	920080e7          	jalr	-1760(ra) # 80000ec6 <myproc>
    800015ae:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    800015b0:	00005097          	auipc	ra,0x5
    800015b4:	d56080e7          	jalr	-682(ra) # 80006306 <acquire>
    release(lk);
    800015b8:	854a                	mv	a0,s2
    800015ba:	00005097          	auipc	ra,0x5
    800015be:	e00080e7          	jalr	-512(ra) # 800063ba <release>

    // Go to sleep.
    p->chan = chan;
    800015c2:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    800015c6:	4789                	li	a5,2
    800015c8:	cc9c                	sw	a5,24(s1)

    sched();
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	eb8080e7          	jalr	-328(ra) # 80001482 <sched>

    // Tidy up.
    p->chan = 0;
    800015d2:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    800015d6:	8526                	mv	a0,s1
    800015d8:	00005097          	auipc	ra,0x5
    800015dc:	de2080e7          	jalr	-542(ra) # 800063ba <release>
    acquire(lk);
    800015e0:	854a                	mv	a0,s2
    800015e2:	00005097          	auipc	ra,0x5
    800015e6:	d24080e7          	jalr	-732(ra) # 80006306 <acquire>
}
    800015ea:	70a2                	ld	ra,40(sp)
    800015ec:	7402                	ld	s0,32(sp)
    800015ee:	64e2                	ld	s1,24(sp)
    800015f0:	6942                	ld	s2,16(sp)
    800015f2:	69a2                	ld	s3,8(sp)
    800015f4:	6145                	add	sp,sp,48
    800015f6:	8082                	ret

00000000800015f8 <wait>:
{
    800015f8:	715d                	add	sp,sp,-80
    800015fa:	e486                	sd	ra,72(sp)
    800015fc:	e0a2                	sd	s0,64(sp)
    800015fe:	fc26                	sd	s1,56(sp)
    80001600:	f84a                	sd	s2,48(sp)
    80001602:	f44e                	sd	s3,40(sp)
    80001604:	f052                	sd	s4,32(sp)
    80001606:	ec56                	sd	s5,24(sp)
    80001608:	e85a                	sd	s6,16(sp)
    8000160a:	e45e                	sd	s7,8(sp)
    8000160c:	e062                	sd	s8,0(sp)
    8000160e:	0880                	add	s0,sp,80
    80001610:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    80001612:	00000097          	auipc	ra,0x0
    80001616:	8b4080e7          	jalr	-1868(ra) # 80000ec6 <myproc>
    8000161a:	892a                	mv	s2,a0
    acquire(&wait_lock);
    8000161c:	00008517          	auipc	a0,0x8
    80001620:	a4c50513          	add	a0,a0,-1460 # 80009068 <wait_lock>
    80001624:	00005097          	auipc	ra,0x5
    80001628:	ce2080e7          	jalr	-798(ra) # 80006306 <acquire>
        havekids = 0;
    8000162c:	4b81                	li	s7,0
                if (np->state == ZOMBIE)
    8000162e:	4a15                	li	s4,5
                havekids = 1;
    80001630:	4a85                	li	s5,1
        for (np = proc; np < &proc[NPROC]; np++)
    80001632:	0000e997          	auipc	s3,0xe
    80001636:	a4e98993          	add	s3,s3,-1458 # 8000f080 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    8000163a:	00008c17          	auipc	s8,0x8
    8000163e:	a2ec0c13          	add	s8,s8,-1490 # 80009068 <wait_lock>
    80001642:	a87d                	j	80001700 <wait+0x108>
                    pid = np->pid;
    80001644:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001648:	000b0e63          	beqz	s6,80001664 <wait+0x6c>
    8000164c:	4691                	li	a3,4
    8000164e:	02c48613          	add	a2,s1,44
    80001652:	85da                	mv	a1,s6
    80001654:	05093503          	ld	a0,80(s2)
    80001658:	fffff097          	auipc	ra,0xfffff
    8000165c:	50a080e7          	jalr	1290(ra) # 80000b62 <copyout>
    80001660:	04054163          	bltz	a0,800016a2 <wait+0xaa>
                    freeproc(np);
    80001664:	8526                	mv	a0,s1
    80001666:	00000097          	auipc	ra,0x0
    8000166a:	a12080e7          	jalr	-1518(ra) # 80001078 <freeproc>
                    release(&np->lock);
    8000166e:	8526                	mv	a0,s1
    80001670:	00005097          	auipc	ra,0x5
    80001674:	d4a080e7          	jalr	-694(ra) # 800063ba <release>
                    release(&wait_lock);
    80001678:	00008517          	auipc	a0,0x8
    8000167c:	9f050513          	add	a0,a0,-1552 # 80009068 <wait_lock>
    80001680:	00005097          	auipc	ra,0x5
    80001684:	d3a080e7          	jalr	-710(ra) # 800063ba <release>
}
    80001688:	854e                	mv	a0,s3
    8000168a:	60a6                	ld	ra,72(sp)
    8000168c:	6406                	ld	s0,64(sp)
    8000168e:	74e2                	ld	s1,56(sp)
    80001690:	7942                	ld	s2,48(sp)
    80001692:	79a2                	ld	s3,40(sp)
    80001694:	7a02                	ld	s4,32(sp)
    80001696:	6ae2                	ld	s5,24(sp)
    80001698:	6b42                	ld	s6,16(sp)
    8000169a:	6ba2                	ld	s7,8(sp)
    8000169c:	6c02                	ld	s8,0(sp)
    8000169e:	6161                	add	sp,sp,80
    800016a0:	8082                	ret
                        release(&np->lock);
    800016a2:	8526                	mv	a0,s1
    800016a4:	00005097          	auipc	ra,0x5
    800016a8:	d16080e7          	jalr	-746(ra) # 800063ba <release>
                        release(&wait_lock);
    800016ac:	00008517          	auipc	a0,0x8
    800016b0:	9bc50513          	add	a0,a0,-1604 # 80009068 <wait_lock>
    800016b4:	00005097          	auipc	ra,0x5
    800016b8:	d06080e7          	jalr	-762(ra) # 800063ba <release>
                        return -1;
    800016bc:	59fd                	li	s3,-1
    800016be:	b7e9                	j	80001688 <wait+0x90>
        for (np = proc; np < &proc[NPROC]; np++)
    800016c0:	17048493          	add	s1,s1,368
    800016c4:	03348463          	beq	s1,s3,800016ec <wait+0xf4>
            if (np->parent == p)
    800016c8:	7c9c                	ld	a5,56(s1)
    800016ca:	ff279be3          	bne	a5,s2,800016c0 <wait+0xc8>
                acquire(&np->lock);
    800016ce:	8526                	mv	a0,s1
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	c36080e7          	jalr	-970(ra) # 80006306 <acquire>
                if (np->state == ZOMBIE)
    800016d8:	4c9c                	lw	a5,24(s1)
    800016da:	f74785e3          	beq	a5,s4,80001644 <wait+0x4c>
                release(&np->lock);
    800016de:	8526                	mv	a0,s1
    800016e0:	00005097          	auipc	ra,0x5
    800016e4:	cda080e7          	jalr	-806(ra) # 800063ba <release>
                havekids = 1;
    800016e8:	8756                	mv	a4,s5
    800016ea:	bfd9                	j	800016c0 <wait+0xc8>
        if (!havekids || p->killed)
    800016ec:	c305                	beqz	a4,8000170c <wait+0x114>
    800016ee:	02892783          	lw	a5,40(s2)
    800016f2:	ef89                	bnez	a5,8000170c <wait+0x114>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800016f4:	85e2                	mv	a1,s8
    800016f6:	854a                	mv	a0,s2
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	e9c080e7          	jalr	-356(ra) # 80001594 <sleep>
        havekids = 0;
    80001700:	875e                	mv	a4,s7
        for (np = proc; np < &proc[NPROC]; np++)
    80001702:	00008497          	auipc	s1,0x8
    80001706:	d7e48493          	add	s1,s1,-642 # 80009480 <proc>
    8000170a:	bf7d                	j	800016c8 <wait+0xd0>
            release(&wait_lock);
    8000170c:	00008517          	auipc	a0,0x8
    80001710:	95c50513          	add	a0,a0,-1700 # 80009068 <wait_lock>
    80001714:	00005097          	auipc	ra,0x5
    80001718:	ca6080e7          	jalr	-858(ra) # 800063ba <release>
            return -1;
    8000171c:	59fd                	li	s3,-1
    8000171e:	b7ad                	j	80001688 <wait+0x90>

0000000080001720 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80001720:	7139                	add	sp,sp,-64
    80001722:	fc06                	sd	ra,56(sp)
    80001724:	f822                	sd	s0,48(sp)
    80001726:	f426                	sd	s1,40(sp)
    80001728:	f04a                	sd	s2,32(sp)
    8000172a:	ec4e                	sd	s3,24(sp)
    8000172c:	e852                	sd	s4,16(sp)
    8000172e:	e456                	sd	s5,8(sp)
    80001730:	0080                	add	s0,sp,64
    80001732:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80001734:	00008497          	auipc	s1,0x8
    80001738:	d4c48493          	add	s1,s1,-692 # 80009480 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    8000173c:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    8000173e:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    80001740:	0000e917          	auipc	s2,0xe
    80001744:	94090913          	add	s2,s2,-1728 # 8000f080 <tickslock>
    80001748:	a811                	j	8000175c <wakeup+0x3c>
            }
            release(&p->lock);
    8000174a:	8526                	mv	a0,s1
    8000174c:	00005097          	auipc	ra,0x5
    80001750:	c6e080e7          	jalr	-914(ra) # 800063ba <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001754:	17048493          	add	s1,s1,368
    80001758:	03248663          	beq	s1,s2,80001784 <wakeup+0x64>
        if (p != myproc())
    8000175c:	fffff097          	auipc	ra,0xfffff
    80001760:	76a080e7          	jalr	1898(ra) # 80000ec6 <myproc>
    80001764:	fea488e3          	beq	s1,a0,80001754 <wakeup+0x34>
            acquire(&p->lock);
    80001768:	8526                	mv	a0,s1
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	b9c080e7          	jalr	-1124(ra) # 80006306 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    80001772:	4c9c                	lw	a5,24(s1)
    80001774:	fd379be3          	bne	a5,s3,8000174a <wakeup+0x2a>
    80001778:	709c                	ld	a5,32(s1)
    8000177a:	fd4798e3          	bne	a5,s4,8000174a <wakeup+0x2a>
                p->state = RUNNABLE;
    8000177e:	0154ac23          	sw	s5,24(s1)
    80001782:	b7e1                	j	8000174a <wakeup+0x2a>
        }
    }
}
    80001784:	70e2                	ld	ra,56(sp)
    80001786:	7442                	ld	s0,48(sp)
    80001788:	74a2                	ld	s1,40(sp)
    8000178a:	7902                	ld	s2,32(sp)
    8000178c:	69e2                	ld	s3,24(sp)
    8000178e:	6a42                	ld	s4,16(sp)
    80001790:	6aa2                	ld	s5,8(sp)
    80001792:	6121                	add	sp,sp,64
    80001794:	8082                	ret

0000000080001796 <reparent>:
{
    80001796:	7179                	add	sp,sp,-48
    80001798:	f406                	sd	ra,40(sp)
    8000179a:	f022                	sd	s0,32(sp)
    8000179c:	ec26                	sd	s1,24(sp)
    8000179e:	e84a                	sd	s2,16(sp)
    800017a0:	e44e                	sd	s3,8(sp)
    800017a2:	e052                	sd	s4,0(sp)
    800017a4:	1800                	add	s0,sp,48
    800017a6:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800017a8:	00008497          	auipc	s1,0x8
    800017ac:	cd848493          	add	s1,s1,-808 # 80009480 <proc>
            pp->parent = initproc;
    800017b0:	00008a17          	auipc	s4,0x8
    800017b4:	860a0a13          	add	s4,s4,-1952 # 80009010 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800017b8:	0000e997          	auipc	s3,0xe
    800017bc:	8c898993          	add	s3,s3,-1848 # 8000f080 <tickslock>
    800017c0:	a029                	j	800017ca <reparent+0x34>
    800017c2:	17048493          	add	s1,s1,368
    800017c6:	01348d63          	beq	s1,s3,800017e0 <reparent+0x4a>
        if (pp->parent == p)
    800017ca:	7c9c                	ld	a5,56(s1)
    800017cc:	ff279be3          	bne	a5,s2,800017c2 <reparent+0x2c>
            pp->parent = initproc;
    800017d0:	000a3503          	ld	a0,0(s4)
    800017d4:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    800017d6:	00000097          	auipc	ra,0x0
    800017da:	f4a080e7          	jalr	-182(ra) # 80001720 <wakeup>
    800017de:	b7d5                	j	800017c2 <reparent+0x2c>
}
    800017e0:	70a2                	ld	ra,40(sp)
    800017e2:	7402                	ld	s0,32(sp)
    800017e4:	64e2                	ld	s1,24(sp)
    800017e6:	6942                	ld	s2,16(sp)
    800017e8:	69a2                	ld	s3,8(sp)
    800017ea:	6a02                	ld	s4,0(sp)
    800017ec:	6145                	add	sp,sp,48
    800017ee:	8082                	ret

00000000800017f0 <exit>:
{
    800017f0:	7179                	add	sp,sp,-48
    800017f2:	f406                	sd	ra,40(sp)
    800017f4:	f022                	sd	s0,32(sp)
    800017f6:	ec26                	sd	s1,24(sp)
    800017f8:	e84a                	sd	s2,16(sp)
    800017fa:	e44e                	sd	s3,8(sp)
    800017fc:	e052                	sd	s4,0(sp)
    800017fe:	1800                	add	s0,sp,48
    80001800:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    80001802:	fffff097          	auipc	ra,0xfffff
    80001806:	6c4080e7          	jalr	1732(ra) # 80000ec6 <myproc>
    8000180a:	89aa                	mv	s3,a0
    if (p == initproc)
    8000180c:	00008797          	auipc	a5,0x8
    80001810:	8047b783          	ld	a5,-2044(a5) # 80009010 <initproc>
    80001814:	0d050493          	add	s1,a0,208
    80001818:	15050913          	add	s2,a0,336
    8000181c:	02a79363          	bne	a5,a0,80001842 <exit+0x52>
        panic("init exiting");
    80001820:	00007517          	auipc	a0,0x7
    80001824:	9c050513          	add	a0,a0,-1600 # 800081e0 <etext+0x1e0>
    80001828:	00004097          	auipc	ra,0x4
    8000182c:	564080e7          	jalr	1380(ra) # 80005d8c <panic>
            fileclose(f);
    80001830:	00002097          	auipc	ra,0x2
    80001834:	290080e7          	jalr	656(ra) # 80003ac0 <fileclose>
            p->ofile[fd] = 0;
    80001838:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    8000183c:	04a1                	add	s1,s1,8
    8000183e:	01248563          	beq	s1,s2,80001848 <exit+0x58>
        if (p->ofile[fd])
    80001842:	6088                	ld	a0,0(s1)
    80001844:	f575                	bnez	a0,80001830 <exit+0x40>
    80001846:	bfdd                	j	8000183c <exit+0x4c>
    begin_op();
    80001848:	00002097          	auipc	ra,0x2
    8000184c:	dae080e7          	jalr	-594(ra) # 800035f6 <begin_op>
    iput(p->cwd);
    80001850:	1509b503          	ld	a0,336(s3)
    80001854:	00001097          	auipc	ra,0x1
    80001858:	58e080e7          	jalr	1422(ra) # 80002de2 <iput>
    end_op();
    8000185c:	00002097          	auipc	ra,0x2
    80001860:	e14080e7          	jalr	-492(ra) # 80003670 <end_op>
    p->cwd = 0;
    80001864:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    80001868:	00008497          	auipc	s1,0x8
    8000186c:	80048493          	add	s1,s1,-2048 # 80009068 <wait_lock>
    80001870:	8526                	mv	a0,s1
    80001872:	00005097          	auipc	ra,0x5
    80001876:	a94080e7          	jalr	-1388(ra) # 80006306 <acquire>
    reparent(p);
    8000187a:	854e                	mv	a0,s3
    8000187c:	00000097          	auipc	ra,0x0
    80001880:	f1a080e7          	jalr	-230(ra) # 80001796 <reparent>
    wakeup(p->parent);
    80001884:	0389b503          	ld	a0,56(s3)
    80001888:	00000097          	auipc	ra,0x0
    8000188c:	e98080e7          	jalr	-360(ra) # 80001720 <wakeup>
    acquire(&p->lock);
    80001890:	854e                	mv	a0,s3
    80001892:	00005097          	auipc	ra,0x5
    80001896:	a74080e7          	jalr	-1420(ra) # 80006306 <acquire>
    p->xstate = status;
    8000189a:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    8000189e:	4795                	li	a5,5
    800018a0:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	b14080e7          	jalr	-1260(ra) # 800063ba <release>
    sched();
    800018ae:	00000097          	auipc	ra,0x0
    800018b2:	bd4080e7          	jalr	-1068(ra) # 80001482 <sched>
    panic("zombie exit");
    800018b6:	00007517          	auipc	a0,0x7
    800018ba:	93a50513          	add	a0,a0,-1734 # 800081f0 <etext+0x1f0>
    800018be:	00004097          	auipc	ra,0x4
    800018c2:	4ce080e7          	jalr	1230(ra) # 80005d8c <panic>

00000000800018c6 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800018c6:	7179                	add	sp,sp,-48
    800018c8:	f406                	sd	ra,40(sp)
    800018ca:	f022                	sd	s0,32(sp)
    800018cc:	ec26                	sd	s1,24(sp)
    800018ce:	e84a                	sd	s2,16(sp)
    800018d0:	e44e                	sd	s3,8(sp)
    800018d2:	1800                	add	s0,sp,48
    800018d4:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800018d6:	00008497          	auipc	s1,0x8
    800018da:	baa48493          	add	s1,s1,-1110 # 80009480 <proc>
    800018de:	0000d997          	auipc	s3,0xd
    800018e2:	7a298993          	add	s3,s3,1954 # 8000f080 <tickslock>
    {
        acquire(&p->lock);
    800018e6:	8526                	mv	a0,s1
    800018e8:	00005097          	auipc	ra,0x5
    800018ec:	a1e080e7          	jalr	-1506(ra) # 80006306 <acquire>
        if (p->pid == pid)
    800018f0:	589c                	lw	a5,48(s1)
    800018f2:	01278d63          	beq	a5,s2,8000190c <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    800018f6:	8526                	mv	a0,s1
    800018f8:	00005097          	auipc	ra,0x5
    800018fc:	ac2080e7          	jalr	-1342(ra) # 800063ba <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001900:	17048493          	add	s1,s1,368
    80001904:	ff3491e3          	bne	s1,s3,800018e6 <kill+0x20>
    }
    return -1;
    80001908:	557d                	li	a0,-1
    8000190a:	a829                	j	80001924 <kill+0x5e>
            p->killed = 1;
    8000190c:	4785                	li	a5,1
    8000190e:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    80001910:	4c98                	lw	a4,24(s1)
    80001912:	4789                	li	a5,2
    80001914:	00f70f63          	beq	a4,a5,80001932 <kill+0x6c>
            release(&p->lock);
    80001918:	8526                	mv	a0,s1
    8000191a:	00005097          	auipc	ra,0x5
    8000191e:	aa0080e7          	jalr	-1376(ra) # 800063ba <release>
            return 0;
    80001922:	4501                	li	a0,0
}
    80001924:	70a2                	ld	ra,40(sp)
    80001926:	7402                	ld	s0,32(sp)
    80001928:	64e2                	ld	s1,24(sp)
    8000192a:	6942                	ld	s2,16(sp)
    8000192c:	69a2                	ld	s3,8(sp)
    8000192e:	6145                	add	sp,sp,48
    80001930:	8082                	ret
                p->state = RUNNABLE;
    80001932:	478d                	li	a5,3
    80001934:	cc9c                	sw	a5,24(s1)
    80001936:	b7cd                	j	80001918 <kill+0x52>

0000000080001938 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001938:	7179                	add	sp,sp,-48
    8000193a:	f406                	sd	ra,40(sp)
    8000193c:	f022                	sd	s0,32(sp)
    8000193e:	ec26                	sd	s1,24(sp)
    80001940:	e84a                	sd	s2,16(sp)
    80001942:	e44e                	sd	s3,8(sp)
    80001944:	e052                	sd	s4,0(sp)
    80001946:	1800                	add	s0,sp,48
    80001948:	84aa                	mv	s1,a0
    8000194a:	892e                	mv	s2,a1
    8000194c:	89b2                	mv	s3,a2
    8000194e:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001950:	fffff097          	auipc	ra,0xfffff
    80001954:	576080e7          	jalr	1398(ra) # 80000ec6 <myproc>
    if (user_dst)
    80001958:	c08d                	beqz	s1,8000197a <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    8000195a:	86d2                	mv	a3,s4
    8000195c:	864e                	mv	a2,s3
    8000195e:	85ca                	mv	a1,s2
    80001960:	6928                	ld	a0,80(a0)
    80001962:	fffff097          	auipc	ra,0xfffff
    80001966:	200080e7          	jalr	512(ra) # 80000b62 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    8000196a:	70a2                	ld	ra,40(sp)
    8000196c:	7402                	ld	s0,32(sp)
    8000196e:	64e2                	ld	s1,24(sp)
    80001970:	6942                	ld	s2,16(sp)
    80001972:	69a2                	ld	s3,8(sp)
    80001974:	6a02                	ld	s4,0(sp)
    80001976:	6145                	add	sp,sp,48
    80001978:	8082                	ret
        memmove((char *)dst, src, len);
    8000197a:	000a061b          	sext.w	a2,s4
    8000197e:	85ce                	mv	a1,s3
    80001980:	854a                	mv	a0,s2
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	89e080e7          	jalr	-1890(ra) # 80000220 <memmove>
        return 0;
    8000198a:	8526                	mv	a0,s1
    8000198c:	bff9                	j	8000196a <either_copyout+0x32>

000000008000198e <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000198e:	7179                	add	sp,sp,-48
    80001990:	f406                	sd	ra,40(sp)
    80001992:	f022                	sd	s0,32(sp)
    80001994:	ec26                	sd	s1,24(sp)
    80001996:	e84a                	sd	s2,16(sp)
    80001998:	e44e                	sd	s3,8(sp)
    8000199a:	e052                	sd	s4,0(sp)
    8000199c:	1800                	add	s0,sp,48
    8000199e:	892a                	mv	s2,a0
    800019a0:	84ae                	mv	s1,a1
    800019a2:	89b2                	mv	s3,a2
    800019a4:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800019a6:	fffff097          	auipc	ra,0xfffff
    800019aa:	520080e7          	jalr	1312(ra) # 80000ec6 <myproc>
    if (user_src)
    800019ae:	c08d                	beqz	s1,800019d0 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    800019b0:	86d2                	mv	a3,s4
    800019b2:	864e                	mv	a2,s3
    800019b4:	85ca                	mv	a1,s2
    800019b6:	6928                	ld	a0,80(a0)
    800019b8:	fffff097          	auipc	ra,0xfffff
    800019bc:	236080e7          	jalr	566(ra) # 80000bee <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800019c0:	70a2                	ld	ra,40(sp)
    800019c2:	7402                	ld	s0,32(sp)
    800019c4:	64e2                	ld	s1,24(sp)
    800019c6:	6942                	ld	s2,16(sp)
    800019c8:	69a2                	ld	s3,8(sp)
    800019ca:	6a02                	ld	s4,0(sp)
    800019cc:	6145                	add	sp,sp,48
    800019ce:	8082                	ret
        memmove(dst, (char *)src, len);
    800019d0:	000a061b          	sext.w	a2,s4
    800019d4:	85ce                	mv	a1,s3
    800019d6:	854a                	mv	a0,s2
    800019d8:	fffff097          	auipc	ra,0xfffff
    800019dc:	848080e7          	jalr	-1976(ra) # 80000220 <memmove>
        return 0;
    800019e0:	8526                	mv	a0,s1
    800019e2:	bff9                	j	800019c0 <either_copyin+0x32>

00000000800019e4 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800019e4:	715d                	add	sp,sp,-80
    800019e6:	e486                	sd	ra,72(sp)
    800019e8:	e0a2                	sd	s0,64(sp)
    800019ea:	fc26                	sd	s1,56(sp)
    800019ec:	f84a                	sd	s2,48(sp)
    800019ee:	f44e                	sd	s3,40(sp)
    800019f0:	f052                	sd	s4,32(sp)
    800019f2:	ec56                	sd	s5,24(sp)
    800019f4:	e85a                	sd	s6,16(sp)
    800019f6:	e45e                	sd	s7,8(sp)
    800019f8:	0880                	add	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800019fa:	00006517          	auipc	a0,0x6
    800019fe:	61e50513          	add	a0,a0,1566 # 80008018 <etext+0x18>
    80001a02:	00004097          	auipc	ra,0x4
    80001a06:	3d4080e7          	jalr	980(ra) # 80005dd6 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a0a:	00008497          	auipc	s1,0x8
    80001a0e:	bce48493          	add	s1,s1,-1074 # 800095d8 <proc+0x158>
    80001a12:	0000d917          	auipc	s2,0xd
    80001a16:	7c690913          	add	s2,s2,1990 # 8000f1d8 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a1a:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80001a1c:	00006997          	auipc	s3,0x6
    80001a20:	7e498993          	add	s3,s3,2020 # 80008200 <etext+0x200>
        printf("%d %s %s", p->pid, state, p->name);
    80001a24:	00006a97          	auipc	s5,0x6
    80001a28:	7e4a8a93          	add	s5,s5,2020 # 80008208 <etext+0x208>
        printf("\n");
    80001a2c:	00006a17          	auipc	s4,0x6
    80001a30:	5eca0a13          	add	s4,s4,1516 # 80008018 <etext+0x18>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a34:	00007b97          	auipc	s7,0x7
    80001a38:	d8cb8b93          	add	s7,s7,-628 # 800087c0 <states.0>
    80001a3c:	a00d                	j	80001a5e <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001a3e:	ed86a583          	lw	a1,-296(a3)
    80001a42:	8556                	mv	a0,s5
    80001a44:	00004097          	auipc	ra,0x4
    80001a48:	392080e7          	jalr	914(ra) # 80005dd6 <printf>
        printf("\n");
    80001a4c:	8552                	mv	a0,s4
    80001a4e:	00004097          	auipc	ra,0x4
    80001a52:	388080e7          	jalr	904(ra) # 80005dd6 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a56:	17048493          	add	s1,s1,368
    80001a5a:	03248263          	beq	s1,s2,80001a7e <procdump+0x9a>
        if (p->state == UNUSED)
    80001a5e:	86a6                	mv	a3,s1
    80001a60:	ec04a783          	lw	a5,-320(s1)
    80001a64:	dbed                	beqz	a5,80001a56 <procdump+0x72>
            state = "???";
    80001a66:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a68:	fcfb6be3          	bltu	s6,a5,80001a3e <procdump+0x5a>
    80001a6c:	02079713          	sll	a4,a5,0x20
    80001a70:	01d75793          	srl	a5,a4,0x1d
    80001a74:	97de                	add	a5,a5,s7
    80001a76:	6390                	ld	a2,0(a5)
    80001a78:	f279                	bnez	a2,80001a3e <procdump+0x5a>
            state = "???";
    80001a7a:	864e                	mv	a2,s3
    80001a7c:	b7c9                	j	80001a3e <procdump+0x5a>
    }
}
    80001a7e:	60a6                	ld	ra,72(sp)
    80001a80:	6406                	ld	s0,64(sp)
    80001a82:	74e2                	ld	s1,56(sp)
    80001a84:	7942                	ld	s2,48(sp)
    80001a86:	79a2                	ld	s3,40(sp)
    80001a88:	7a02                	ld	s4,32(sp)
    80001a8a:	6ae2                	ld	s5,24(sp)
    80001a8c:	6b42                	ld	s6,16(sp)
    80001a8e:	6ba2                	ld	s7,8(sp)
    80001a90:	6161                	add	sp,sp,80
    80001a92:	8082                	ret

0000000080001a94 <nproc>:

// get num of running process
uint64 nproc(void)
{
    80001a94:	7179                	add	sp,sp,-48
    80001a96:	f406                	sd	ra,40(sp)
    80001a98:	f022                	sd	s0,32(sp)
    80001a9a:	ec26                	sd	s1,24(sp)
    80001a9c:	e84a                	sd	s2,16(sp)
    80001a9e:	e44e                	sd	s3,8(sp)
    80001aa0:	1800                	add	s0,sp,48
    struct proc *p;
    uint64 n = 0;
    80001aa2:	4901                	li	s2,0
    for (p = proc; p < &proc[NPROC]; p++)
    80001aa4:	00008497          	auipc	s1,0x8
    80001aa8:	9dc48493          	add	s1,s1,-1572 # 80009480 <proc>
    80001aac:	0000d997          	auipc	s3,0xd
    80001ab0:	5d498993          	add	s3,s3,1492 # 8000f080 <tickslock>
    {
        acquire(&p->lock);
    80001ab4:	8526                	mv	a0,s1
    80001ab6:	00005097          	auipc	ra,0x5
    80001aba:	850080e7          	jalr	-1968(ra) # 80006306 <acquire>
        if (p->state != UNUSED)
    80001abe:	4c9c                	lw	a5,24(s1)
        {
            ++n;
    80001ac0:	00f037b3          	snez	a5,a5
    80001ac4:	993e                	add	s2,s2,a5
        }
        release(&p->lock);
    80001ac6:	8526                	mv	a0,s1
    80001ac8:	00005097          	auipc	ra,0x5
    80001acc:	8f2080e7          	jalr	-1806(ra) # 800063ba <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001ad0:	17048493          	add	s1,s1,368
    80001ad4:	ff3490e3          	bne	s1,s3,80001ab4 <nproc+0x20>
    }
    return n;
    80001ad8:	854a                	mv	a0,s2
    80001ada:	70a2                	ld	ra,40(sp)
    80001adc:	7402                	ld	s0,32(sp)
    80001ade:	64e2                	ld	s1,24(sp)
    80001ae0:	6942                	ld	s2,16(sp)
    80001ae2:	69a2                	ld	s3,8(sp)
    80001ae4:	6145                	add	sp,sp,48
    80001ae6:	8082                	ret

0000000080001ae8 <swtch>:
    80001ae8:	00153023          	sd	ra,0(a0)
    80001aec:	00253423          	sd	sp,8(a0)
    80001af0:	e900                	sd	s0,16(a0)
    80001af2:	ed04                	sd	s1,24(a0)
    80001af4:	03253023          	sd	s2,32(a0)
    80001af8:	03353423          	sd	s3,40(a0)
    80001afc:	03453823          	sd	s4,48(a0)
    80001b00:	03553c23          	sd	s5,56(a0)
    80001b04:	05653023          	sd	s6,64(a0)
    80001b08:	05753423          	sd	s7,72(a0)
    80001b0c:	05853823          	sd	s8,80(a0)
    80001b10:	05953c23          	sd	s9,88(a0)
    80001b14:	07a53023          	sd	s10,96(a0)
    80001b18:	07b53423          	sd	s11,104(a0)
    80001b1c:	0005b083          	ld	ra,0(a1)
    80001b20:	0085b103          	ld	sp,8(a1)
    80001b24:	6980                	ld	s0,16(a1)
    80001b26:	6d84                	ld	s1,24(a1)
    80001b28:	0205b903          	ld	s2,32(a1)
    80001b2c:	0285b983          	ld	s3,40(a1)
    80001b30:	0305ba03          	ld	s4,48(a1)
    80001b34:	0385ba83          	ld	s5,56(a1)
    80001b38:	0405bb03          	ld	s6,64(a1)
    80001b3c:	0485bb83          	ld	s7,72(a1)
    80001b40:	0505bc03          	ld	s8,80(a1)
    80001b44:	0585bc83          	ld	s9,88(a1)
    80001b48:	0605bd03          	ld	s10,96(a1)
    80001b4c:	0685bd83          	ld	s11,104(a1)
    80001b50:	8082                	ret

0000000080001b52 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b52:	1141                	add	sp,sp,-16
    80001b54:	e406                	sd	ra,8(sp)
    80001b56:	e022                	sd	s0,0(sp)
    80001b58:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001b5a:	00006597          	auipc	a1,0x6
    80001b5e:	6e658593          	add	a1,a1,1766 # 80008240 <etext+0x240>
    80001b62:	0000d517          	auipc	a0,0xd
    80001b66:	51e50513          	add	a0,a0,1310 # 8000f080 <tickslock>
    80001b6a:	00004097          	auipc	ra,0x4
    80001b6e:	70c080e7          	jalr	1804(ra) # 80006276 <initlock>
}
    80001b72:	60a2                	ld	ra,8(sp)
    80001b74:	6402                	ld	s0,0(sp)
    80001b76:	0141                	add	sp,sp,16
    80001b78:	8082                	ret

0000000080001b7a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b7a:	1141                	add	sp,sp,-16
    80001b7c:	e422                	sd	s0,8(sp)
    80001b7e:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b80:	00003797          	auipc	a5,0x3
    80001b84:	62078793          	add	a5,a5,1568 # 800051a0 <kernelvec>
    80001b88:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b8c:	6422                	ld	s0,8(sp)
    80001b8e:	0141                	add	sp,sp,16
    80001b90:	8082                	ret

0000000080001b92 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b92:	1141                	add	sp,sp,-16
    80001b94:	e406                	sd	ra,8(sp)
    80001b96:	e022                	sd	s0,0(sp)
    80001b98:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001b9a:	fffff097          	auipc	ra,0xfffff
    80001b9e:	32c080e7          	jalr	812(ra) # 80000ec6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ba2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ba6:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001bac:	00005697          	auipc	a3,0x5
    80001bb0:	45468693          	add	a3,a3,1108 # 80007000 <_trampoline>
    80001bb4:	00005717          	auipc	a4,0x5
    80001bb8:	44c70713          	add	a4,a4,1100 # 80007000 <_trampoline>
    80001bbc:	8f15                	sub	a4,a4,a3
    80001bbe:	040007b7          	lui	a5,0x4000
    80001bc2:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bc4:	07b2                	sll	a5,a5,0xc
    80001bc6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bc8:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bcc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bce:	18002673          	csrr	a2,satp
    80001bd2:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bd4:	6d30                	ld	a2,88(a0)
    80001bd6:	6138                	ld	a4,64(a0)
    80001bd8:	6585                	lui	a1,0x1
    80001bda:	972e                	add	a4,a4,a1
    80001bdc:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bde:	6d38                	ld	a4,88(a0)
    80001be0:	00000617          	auipc	a2,0x0
    80001be4:	14060613          	add	a2,a2,320 # 80001d20 <usertrap>
    80001be8:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bea:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bec:	8612                	mv	a2,tp
    80001bee:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bf0:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bf4:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bf8:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bfc:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c00:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c02:	6f18                	ld	a4,24(a4)
    80001c04:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c08:	692c                	ld	a1,80(a0)
    80001c0a:	81b1                	srl	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c0c:	00005717          	auipc	a4,0x5
    80001c10:	48470713          	add	a4,a4,1156 # 80007090 <userret>
    80001c14:	8f15                	sub	a4,a4,a3
    80001c16:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c18:	577d                	li	a4,-1
    80001c1a:	177e                	sll	a4,a4,0x3f
    80001c1c:	8dd9                	or	a1,a1,a4
    80001c1e:	02000537          	lui	a0,0x2000
    80001c22:	157d                	add	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c24:	0536                	sll	a0,a0,0xd
    80001c26:	9782                	jalr	a5
}
    80001c28:	60a2                	ld	ra,8(sp)
    80001c2a:	6402                	ld	s0,0(sp)
    80001c2c:	0141                	add	sp,sp,16
    80001c2e:	8082                	ret

0000000080001c30 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c30:	1101                	add	sp,sp,-32
    80001c32:	ec06                	sd	ra,24(sp)
    80001c34:	e822                	sd	s0,16(sp)
    80001c36:	e426                	sd	s1,8(sp)
    80001c38:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001c3a:	0000d497          	auipc	s1,0xd
    80001c3e:	44648493          	add	s1,s1,1094 # 8000f080 <tickslock>
    80001c42:	8526                	mv	a0,s1
    80001c44:	00004097          	auipc	ra,0x4
    80001c48:	6c2080e7          	jalr	1730(ra) # 80006306 <acquire>
  ticks++;
    80001c4c:	00007517          	auipc	a0,0x7
    80001c50:	3cc50513          	add	a0,a0,972 # 80009018 <ticks>
    80001c54:	411c                	lw	a5,0(a0)
    80001c56:	2785                	addw	a5,a5,1
    80001c58:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c5a:	00000097          	auipc	ra,0x0
    80001c5e:	ac6080e7          	jalr	-1338(ra) # 80001720 <wakeup>
  release(&tickslock);
    80001c62:	8526                	mv	a0,s1
    80001c64:	00004097          	auipc	ra,0x4
    80001c68:	756080e7          	jalr	1878(ra) # 800063ba <release>
}
    80001c6c:	60e2                	ld	ra,24(sp)
    80001c6e:	6442                	ld	s0,16(sp)
    80001c70:	64a2                	ld	s1,8(sp)
    80001c72:	6105                	add	sp,sp,32
    80001c74:	8082                	ret

0000000080001c76 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c76:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c7a:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c7c:	0a07d163          	bgez	a5,80001d1e <devintr+0xa8>
{
    80001c80:	1101                	add	sp,sp,-32
    80001c82:	ec06                	sd	ra,24(sp)
    80001c84:	e822                	sd	s0,16(sp)
    80001c86:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001c88:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c8c:	46a5                	li	a3,9
    80001c8e:	00d70c63          	beq	a4,a3,80001ca6 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001c92:	577d                	li	a4,-1
    80001c94:	177e                	sll	a4,a4,0x3f
    80001c96:	0705                	add	a4,a4,1
    return 0;
    80001c98:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c9a:	06e78163          	beq	a5,a4,80001cfc <devintr+0x86>
  }
}
    80001c9e:	60e2                	ld	ra,24(sp)
    80001ca0:	6442                	ld	s0,16(sp)
    80001ca2:	6105                	add	sp,sp,32
    80001ca4:	8082                	ret
    80001ca6:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001ca8:	00003097          	auipc	ra,0x3
    80001cac:	604080e7          	jalr	1540(ra) # 800052ac <plic_claim>
    80001cb0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cb2:	47a9                	li	a5,10
    80001cb4:	00f50963          	beq	a0,a5,80001cc6 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001cb8:	4785                	li	a5,1
    80001cba:	00f50b63          	beq	a0,a5,80001cd0 <devintr+0x5a>
    return 1;
    80001cbe:	4505                	li	a0,1
    } else if(irq){
    80001cc0:	ec89                	bnez	s1,80001cda <devintr+0x64>
    80001cc2:	64a2                	ld	s1,8(sp)
    80001cc4:	bfe9                	j	80001c9e <devintr+0x28>
      uartintr();
    80001cc6:	00004097          	auipc	ra,0x4
    80001cca:	560080e7          	jalr	1376(ra) # 80006226 <uartintr>
    if(irq)
    80001cce:	a839                	j	80001cec <devintr+0x76>
      virtio_disk_intr();
    80001cd0:	00004097          	auipc	ra,0x4
    80001cd4:	ab0080e7          	jalr	-1360(ra) # 80005780 <virtio_disk_intr>
    if(irq)
    80001cd8:	a811                	j	80001cec <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cda:	85a6                	mv	a1,s1
    80001cdc:	00006517          	auipc	a0,0x6
    80001ce0:	56c50513          	add	a0,a0,1388 # 80008248 <etext+0x248>
    80001ce4:	00004097          	auipc	ra,0x4
    80001ce8:	0f2080e7          	jalr	242(ra) # 80005dd6 <printf>
      plic_complete(irq);
    80001cec:	8526                	mv	a0,s1
    80001cee:	00003097          	auipc	ra,0x3
    80001cf2:	5e2080e7          	jalr	1506(ra) # 800052d0 <plic_complete>
    return 1;
    80001cf6:	4505                	li	a0,1
    80001cf8:	64a2                	ld	s1,8(sp)
    80001cfa:	b755                	j	80001c9e <devintr+0x28>
    if(cpuid() == 0){
    80001cfc:	fffff097          	auipc	ra,0xfffff
    80001d00:	19e080e7          	jalr	414(ra) # 80000e9a <cpuid>
    80001d04:	c901                	beqz	a0,80001d14 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d06:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d0a:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d0c:	14479073          	csrw	sip,a5
    return 2;
    80001d10:	4509                	li	a0,2
    80001d12:	b771                	j	80001c9e <devintr+0x28>
      clockintr();
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	f1c080e7          	jalr	-228(ra) # 80001c30 <clockintr>
    80001d1c:	b7ed                	j	80001d06 <devintr+0x90>
}
    80001d1e:	8082                	ret

0000000080001d20 <usertrap>:
{
    80001d20:	1101                	add	sp,sp,-32
    80001d22:	ec06                	sd	ra,24(sp)
    80001d24:	e822                	sd	s0,16(sp)
    80001d26:	e426                	sd	s1,8(sp)
    80001d28:	e04a                	sd	s2,0(sp)
    80001d2a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d30:	1007f793          	and	a5,a5,256
    80001d34:	e3ad                	bnez	a5,80001d96 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d36:	00003797          	auipc	a5,0x3
    80001d3a:	46a78793          	add	a5,a5,1130 # 800051a0 <kernelvec>
    80001d3e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d42:	fffff097          	auipc	ra,0xfffff
    80001d46:	184080e7          	jalr	388(ra) # 80000ec6 <myproc>
    80001d4a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d4c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d4e:	14102773          	csrr	a4,sepc
    80001d52:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d54:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d58:	47a1                	li	a5,8
    80001d5a:	04f71c63          	bne	a4,a5,80001db2 <usertrap+0x92>
    if(p->killed)
    80001d5e:	551c                	lw	a5,40(a0)
    80001d60:	e3b9                	bnez	a5,80001da6 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d62:	6cb8                	ld	a4,88(s1)
    80001d64:	6f1c                	ld	a5,24(a4)
    80001d66:	0791                	add	a5,a5,4
    80001d68:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d6a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d6e:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d72:	10079073          	csrw	sstatus,a5
    syscall();
    80001d76:	00000097          	auipc	ra,0x0
    80001d7a:	2e0080e7          	jalr	736(ra) # 80002056 <syscall>
  if(p->killed)
    80001d7e:	549c                	lw	a5,40(s1)
    80001d80:	ebc1                	bnez	a5,80001e10 <usertrap+0xf0>
  usertrapret();
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	e10080e7          	jalr	-496(ra) # 80001b92 <usertrapret>
}
    80001d8a:	60e2                	ld	ra,24(sp)
    80001d8c:	6442                	ld	s0,16(sp)
    80001d8e:	64a2                	ld	s1,8(sp)
    80001d90:	6902                	ld	s2,0(sp)
    80001d92:	6105                	add	sp,sp,32
    80001d94:	8082                	ret
    panic("usertrap: not from user mode");
    80001d96:	00006517          	auipc	a0,0x6
    80001d9a:	4d250513          	add	a0,a0,1234 # 80008268 <etext+0x268>
    80001d9e:	00004097          	auipc	ra,0x4
    80001da2:	fee080e7          	jalr	-18(ra) # 80005d8c <panic>
      exit(-1);
    80001da6:	557d                	li	a0,-1
    80001da8:	00000097          	auipc	ra,0x0
    80001dac:	a48080e7          	jalr	-1464(ra) # 800017f0 <exit>
    80001db0:	bf4d                	j	80001d62 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001db2:	00000097          	auipc	ra,0x0
    80001db6:	ec4080e7          	jalr	-316(ra) # 80001c76 <devintr>
    80001dba:	892a                	mv	s2,a0
    80001dbc:	c501                	beqz	a0,80001dc4 <usertrap+0xa4>
  if(p->killed)
    80001dbe:	549c                	lw	a5,40(s1)
    80001dc0:	c3a1                	beqz	a5,80001e00 <usertrap+0xe0>
    80001dc2:	a815                	j	80001df6 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dc4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dc8:	5890                	lw	a2,48(s1)
    80001dca:	00006517          	auipc	a0,0x6
    80001dce:	4be50513          	add	a0,a0,1214 # 80008288 <etext+0x288>
    80001dd2:	00004097          	auipc	ra,0x4
    80001dd6:	004080e7          	jalr	4(ra) # 80005dd6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dda:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dde:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001de2:	00006517          	auipc	a0,0x6
    80001de6:	4d650513          	add	a0,a0,1238 # 800082b8 <etext+0x2b8>
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	fec080e7          	jalr	-20(ra) # 80005dd6 <printf>
    p->killed = 1;
    80001df2:	4785                	li	a5,1
    80001df4:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001df6:	557d                	li	a0,-1
    80001df8:	00000097          	auipc	ra,0x0
    80001dfc:	9f8080e7          	jalr	-1544(ra) # 800017f0 <exit>
  if(which_dev == 2)
    80001e00:	4789                	li	a5,2
    80001e02:	f8f910e3          	bne	s2,a5,80001d82 <usertrap+0x62>
    yield();
    80001e06:	fffff097          	auipc	ra,0xfffff
    80001e0a:	752080e7          	jalr	1874(ra) # 80001558 <yield>
    80001e0e:	bf95                	j	80001d82 <usertrap+0x62>
  int which_dev = 0;
    80001e10:	4901                	li	s2,0
    80001e12:	b7d5                	j	80001df6 <usertrap+0xd6>

0000000080001e14 <kerneltrap>:
{
    80001e14:	7179                	add	sp,sp,-48
    80001e16:	f406                	sd	ra,40(sp)
    80001e18:	f022                	sd	s0,32(sp)
    80001e1a:	ec26                	sd	s1,24(sp)
    80001e1c:	e84a                	sd	s2,16(sp)
    80001e1e:	e44e                	sd	s3,8(sp)
    80001e20:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e22:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e26:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e2a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e2e:	1004f793          	and	a5,s1,256
    80001e32:	cb85                	beqz	a5,80001e62 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e34:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e38:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80001e3a:	ef85                	bnez	a5,80001e72 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e3c:	00000097          	auipc	ra,0x0
    80001e40:	e3a080e7          	jalr	-454(ra) # 80001c76 <devintr>
    80001e44:	cd1d                	beqz	a0,80001e82 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e46:	4789                	li	a5,2
    80001e48:	06f50a63          	beq	a0,a5,80001ebc <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e4c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e50:	10049073          	csrw	sstatus,s1
}
    80001e54:	70a2                	ld	ra,40(sp)
    80001e56:	7402                	ld	s0,32(sp)
    80001e58:	64e2                	ld	s1,24(sp)
    80001e5a:	6942                	ld	s2,16(sp)
    80001e5c:	69a2                	ld	s3,8(sp)
    80001e5e:	6145                	add	sp,sp,48
    80001e60:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e62:	00006517          	auipc	a0,0x6
    80001e66:	47650513          	add	a0,a0,1142 # 800082d8 <etext+0x2d8>
    80001e6a:	00004097          	auipc	ra,0x4
    80001e6e:	f22080e7          	jalr	-222(ra) # 80005d8c <panic>
    panic("kerneltrap: interrupts enabled");
    80001e72:	00006517          	auipc	a0,0x6
    80001e76:	48e50513          	add	a0,a0,1166 # 80008300 <etext+0x300>
    80001e7a:	00004097          	auipc	ra,0x4
    80001e7e:	f12080e7          	jalr	-238(ra) # 80005d8c <panic>
    printf("scause %p\n", scause);
    80001e82:	85ce                	mv	a1,s3
    80001e84:	00006517          	auipc	a0,0x6
    80001e88:	49c50513          	add	a0,a0,1180 # 80008320 <etext+0x320>
    80001e8c:	00004097          	auipc	ra,0x4
    80001e90:	f4a080e7          	jalr	-182(ra) # 80005dd6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e94:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e98:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e9c:	00006517          	auipc	a0,0x6
    80001ea0:	49450513          	add	a0,a0,1172 # 80008330 <etext+0x330>
    80001ea4:	00004097          	auipc	ra,0x4
    80001ea8:	f32080e7          	jalr	-206(ra) # 80005dd6 <printf>
    panic("kerneltrap");
    80001eac:	00006517          	auipc	a0,0x6
    80001eb0:	49c50513          	add	a0,a0,1180 # 80008348 <etext+0x348>
    80001eb4:	00004097          	auipc	ra,0x4
    80001eb8:	ed8080e7          	jalr	-296(ra) # 80005d8c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ebc:	fffff097          	auipc	ra,0xfffff
    80001ec0:	00a080e7          	jalr	10(ra) # 80000ec6 <myproc>
    80001ec4:	d541                	beqz	a0,80001e4c <kerneltrap+0x38>
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	000080e7          	jalr	ra # 80000ec6 <myproc>
    80001ece:	4d18                	lw	a4,24(a0)
    80001ed0:	4791                	li	a5,4
    80001ed2:	f6f71de3          	bne	a4,a5,80001e4c <kerneltrap+0x38>
    yield();
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	682080e7          	jalr	1666(ra) # 80001558 <yield>
    80001ede:	b7bd                	j	80001e4c <kerneltrap+0x38>

0000000080001ee0 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ee0:	1101                	add	sp,sp,-32
    80001ee2:	ec06                	sd	ra,24(sp)
    80001ee4:	e822                	sd	s0,16(sp)
    80001ee6:	e426                	sd	s1,8(sp)
    80001ee8:	1000                	add	s0,sp,32
    80001eea:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001eec:	fffff097          	auipc	ra,0xfffff
    80001ef0:	fda080e7          	jalr	-38(ra) # 80000ec6 <myproc>
    switch (n)
    80001ef4:	4795                	li	a5,5
    80001ef6:	0497e163          	bltu	a5,s1,80001f38 <argraw+0x58>
    80001efa:	048a                	sll	s1,s1,0x2
    80001efc:	00007717          	auipc	a4,0x7
    80001f00:	8f470713          	add	a4,a4,-1804 # 800087f0 <states.0+0x30>
    80001f04:	94ba                	add	s1,s1,a4
    80001f06:	409c                	lw	a5,0(s1)
    80001f08:	97ba                	add	a5,a5,a4
    80001f0a:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80001f0c:	6d3c                	ld	a5,88(a0)
    80001f0e:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80001f10:	60e2                	ld	ra,24(sp)
    80001f12:	6442                	ld	s0,16(sp)
    80001f14:	64a2                	ld	s1,8(sp)
    80001f16:	6105                	add	sp,sp,32
    80001f18:	8082                	ret
        return p->trapframe->a1;
    80001f1a:	6d3c                	ld	a5,88(a0)
    80001f1c:	7fa8                	ld	a0,120(a5)
    80001f1e:	bfcd                	j	80001f10 <argraw+0x30>
        return p->trapframe->a2;
    80001f20:	6d3c                	ld	a5,88(a0)
    80001f22:	63c8                	ld	a0,128(a5)
    80001f24:	b7f5                	j	80001f10 <argraw+0x30>
        return p->trapframe->a3;
    80001f26:	6d3c                	ld	a5,88(a0)
    80001f28:	67c8                	ld	a0,136(a5)
    80001f2a:	b7dd                	j	80001f10 <argraw+0x30>
        return p->trapframe->a4;
    80001f2c:	6d3c                	ld	a5,88(a0)
    80001f2e:	6bc8                	ld	a0,144(a5)
    80001f30:	b7c5                	j	80001f10 <argraw+0x30>
        return p->trapframe->a5;
    80001f32:	6d3c                	ld	a5,88(a0)
    80001f34:	6fc8                	ld	a0,152(a5)
    80001f36:	bfe9                	j	80001f10 <argraw+0x30>
    panic("argraw");
    80001f38:	00006517          	auipc	a0,0x6
    80001f3c:	42050513          	add	a0,a0,1056 # 80008358 <etext+0x358>
    80001f40:	00004097          	auipc	ra,0x4
    80001f44:	e4c080e7          	jalr	-436(ra) # 80005d8c <panic>

0000000080001f48 <fetchaddr>:
{
    80001f48:	1101                	add	sp,sp,-32
    80001f4a:	ec06                	sd	ra,24(sp)
    80001f4c:	e822                	sd	s0,16(sp)
    80001f4e:	e426                	sd	s1,8(sp)
    80001f50:	e04a                	sd	s2,0(sp)
    80001f52:	1000                	add	s0,sp,32
    80001f54:	84aa                	mv	s1,a0
    80001f56:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	f6e080e7          	jalr	-146(ra) # 80000ec6 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz)
    80001f60:	653c                	ld	a5,72(a0)
    80001f62:	02f4f863          	bgeu	s1,a5,80001f92 <fetchaddr+0x4a>
    80001f66:	00848713          	add	a4,s1,8
    80001f6a:	02e7e663          	bltu	a5,a4,80001f96 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f6e:	46a1                	li	a3,8
    80001f70:	8626                	mv	a2,s1
    80001f72:	85ca                	mv	a1,s2
    80001f74:	6928                	ld	a0,80(a0)
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	c78080e7          	jalr	-904(ra) # 80000bee <copyin>
    80001f7e:	00a03533          	snez	a0,a0
    80001f82:	40a00533          	neg	a0,a0
}
    80001f86:	60e2                	ld	ra,24(sp)
    80001f88:	6442                	ld	s0,16(sp)
    80001f8a:	64a2                	ld	s1,8(sp)
    80001f8c:	6902                	ld	s2,0(sp)
    80001f8e:	6105                	add	sp,sp,32
    80001f90:	8082                	ret
        return -1;
    80001f92:	557d                	li	a0,-1
    80001f94:	bfcd                	j	80001f86 <fetchaddr+0x3e>
    80001f96:	557d                	li	a0,-1
    80001f98:	b7fd                	j	80001f86 <fetchaddr+0x3e>

0000000080001f9a <fetchstr>:
{
    80001f9a:	7179                	add	sp,sp,-48
    80001f9c:	f406                	sd	ra,40(sp)
    80001f9e:	f022                	sd	s0,32(sp)
    80001fa0:	ec26                	sd	s1,24(sp)
    80001fa2:	e84a                	sd	s2,16(sp)
    80001fa4:	e44e                	sd	s3,8(sp)
    80001fa6:	1800                	add	s0,sp,48
    80001fa8:	892a                	mv	s2,a0
    80001faa:	84ae                	mv	s1,a1
    80001fac:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	f18080e7          	jalr	-232(ra) # 80000ec6 <myproc>
    int err = copyinstr(p->pagetable, buf, addr, max);
    80001fb6:	86ce                	mv	a3,s3
    80001fb8:	864a                	mv	a2,s2
    80001fba:	85a6                	mv	a1,s1
    80001fbc:	6928                	ld	a0,80(a0)
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	cbe080e7          	jalr	-834(ra) # 80000c7c <copyinstr>
    if (err < 0)
    80001fc6:	00054763          	bltz	a0,80001fd4 <fetchstr+0x3a>
    return strlen(buf);
    80001fca:	8526                	mv	a0,s1
    80001fcc:	ffffe097          	auipc	ra,0xffffe
    80001fd0:	36c080e7          	jalr	876(ra) # 80000338 <strlen>
}
    80001fd4:	70a2                	ld	ra,40(sp)
    80001fd6:	7402                	ld	s0,32(sp)
    80001fd8:	64e2                	ld	s1,24(sp)
    80001fda:	6942                	ld	s2,16(sp)
    80001fdc:	69a2                	ld	s3,8(sp)
    80001fde:	6145                	add	sp,sp,48
    80001fe0:	8082                	ret

0000000080001fe2 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
    80001fe2:	1101                	add	sp,sp,-32
    80001fe4:	ec06                	sd	ra,24(sp)
    80001fe6:	e822                	sd	s0,16(sp)
    80001fe8:	e426                	sd	s1,8(sp)
    80001fea:	1000                	add	s0,sp,32
    80001fec:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80001fee:	00000097          	auipc	ra,0x0
    80001ff2:	ef2080e7          	jalr	-270(ra) # 80001ee0 <argraw>
    80001ff6:	c088                	sw	a0,0(s1)
    return 0;
}
    80001ff8:	4501                	li	a0,0
    80001ffa:	60e2                	ld	ra,24(sp)
    80001ffc:	6442                	ld	s0,16(sp)
    80001ffe:	64a2                	ld	s1,8(sp)
    80002000:	6105                	add	sp,sp,32
    80002002:	8082                	ret

0000000080002004 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int argaddr(int n, uint64 *ip)
{
    80002004:	1101                	add	sp,sp,-32
    80002006:	ec06                	sd	ra,24(sp)
    80002008:	e822                	sd	s0,16(sp)
    8000200a:	e426                	sd	s1,8(sp)
    8000200c:	1000                	add	s0,sp,32
    8000200e:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002010:	00000097          	auipc	ra,0x0
    80002014:	ed0080e7          	jalr	-304(ra) # 80001ee0 <argraw>
    80002018:	e088                	sd	a0,0(s1)
    return 0;
}
    8000201a:	4501                	li	a0,0
    8000201c:	60e2                	ld	ra,24(sp)
    8000201e:	6442                	ld	s0,16(sp)
    80002020:	64a2                	ld	s1,8(sp)
    80002022:	6105                	add	sp,sp,32
    80002024:	8082                	ret

0000000080002026 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80002026:	1101                	add	sp,sp,-32
    80002028:	ec06                	sd	ra,24(sp)
    8000202a:	e822                	sd	s0,16(sp)
    8000202c:	e426                	sd	s1,8(sp)
    8000202e:	e04a                	sd	s2,0(sp)
    80002030:	1000                	add	s0,sp,32
    80002032:	84ae                	mv	s1,a1
    80002034:	8932                	mv	s2,a2
    *ip = argraw(n);
    80002036:	00000097          	auipc	ra,0x0
    8000203a:	eaa080e7          	jalr	-342(ra) # 80001ee0 <argraw>
    uint64 addr;
    if (argaddr(n, &addr) < 0)
        return -1;
    return fetchstr(addr, buf, max);
    8000203e:	864a                	mv	a2,s2
    80002040:	85a6                	mv	a1,s1
    80002042:	00000097          	auipc	ra,0x0
    80002046:	f58080e7          	jalr	-168(ra) # 80001f9a <fetchstr>
}
    8000204a:	60e2                	ld	ra,24(sp)
    8000204c:	6442                	ld	s0,16(sp)
    8000204e:	64a2                	ld	s1,8(sp)
    80002050:	6902                	ld	s2,0(sp)
    80002052:	6105                	add	sp,sp,32
    80002054:	8082                	ret

0000000080002056 <syscall>:
    [SYS_trace] "trace",
    [SYS_sysinfo] "sysinfo",
};

void syscall(void)
{
    80002056:	7179                	add	sp,sp,-48
    80002058:	f406                	sd	ra,40(sp)
    8000205a:	f022                	sd	s0,32(sp)
    8000205c:	ec26                	sd	s1,24(sp)
    8000205e:	e84a                	sd	s2,16(sp)
    80002060:	e44e                	sd	s3,8(sp)
    80002062:	1800                	add	s0,sp,48
    int num;
    struct proc *p = myproc();
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	e62080e7          	jalr	-414(ra) # 80000ec6 <myproc>
    8000206c:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    8000206e:	05853903          	ld	s2,88(a0)
    80002072:	0a893783          	ld	a5,168(s2)
    80002076:	0007899b          	sext.w	s3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000207a:	37fd                	addw	a5,a5,-1
    8000207c:	4759                	li	a4,22
    8000207e:	04f76763          	bltu	a4,a5,800020cc <syscall+0x76>
    80002082:	00399713          	sll	a4,s3,0x3
    80002086:	00006797          	auipc	a5,0x6
    8000208a:	78278793          	add	a5,a5,1922 # 80008808 <syscalls>
    8000208e:	97ba                	add	a5,a5,a4
    80002090:	639c                	ld	a5,0(a5)
    80002092:	cf8d                	beqz	a5,800020cc <syscall+0x76>
    {
        p->trapframe->a0 = syscalls[num]();
    80002094:	9782                	jalr	a5
    80002096:	06a93823          	sd	a0,112(s2)
        if (p->trace_mask & (1 << num))
    8000209a:	1684a783          	lw	a5,360(s1)
    8000209e:	4137d7bb          	sraw	a5,a5,s3
    800020a2:	8b85                	and	a5,a5,1
    800020a4:	c3b9                	beqz	a5,800020ea <syscall+0x94>
        {
            printf("%d: syscall %s -> %d\n", p->pid, syscalls_name[num], p->trapframe->a0);
    800020a6:	6cb8                	ld	a4,88(s1)
    800020a8:	098e                	sll	s3,s3,0x3
    800020aa:	00006797          	auipc	a5,0x6
    800020ae:	75e78793          	add	a5,a5,1886 # 80008808 <syscalls>
    800020b2:	97ce                	add	a5,a5,s3
    800020b4:	7b34                	ld	a3,112(a4)
    800020b6:	63f0                	ld	a2,192(a5)
    800020b8:	588c                	lw	a1,48(s1)
    800020ba:	00006517          	auipc	a0,0x6
    800020be:	2a650513          	add	a0,a0,678 # 80008360 <etext+0x360>
    800020c2:	00004097          	auipc	ra,0x4
    800020c6:	d14080e7          	jalr	-748(ra) # 80005dd6 <printf>
    800020ca:	a005                	j	800020ea <syscall+0x94>
        }
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    800020cc:	86ce                	mv	a3,s3
    800020ce:	15848613          	add	a2,s1,344
    800020d2:	588c                	lw	a1,48(s1)
    800020d4:	00006517          	auipc	a0,0x6
    800020d8:	2a450513          	add	a0,a0,676 # 80008378 <etext+0x378>
    800020dc:	00004097          	auipc	ra,0x4
    800020e0:	cfa080e7          	jalr	-774(ra) # 80005dd6 <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    800020e4:	6cbc                	ld	a5,88(s1)
    800020e6:	577d                	li	a4,-1
    800020e8:	fbb8                	sd	a4,112(a5)
    }
}
    800020ea:	70a2                	ld	ra,40(sp)
    800020ec:	7402                	ld	s0,32(sp)
    800020ee:	64e2                	ld	s1,24(sp)
    800020f0:	6942                	ld	s2,16(sp)
    800020f2:	69a2                	ld	s3,8(sp)
    800020f4:	6145                	add	sp,sp,48
    800020f6:	8082                	ret

00000000800020f8 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    800020f8:	1101                	add	sp,sp,-32
    800020fa:	ec06                	sd	ra,24(sp)
    800020fc:	e822                	sd	s0,16(sp)
    800020fe:	1000                	add	s0,sp,32
    int n;
    if (argint(0, &n) < 0)
    80002100:	fec40593          	add	a1,s0,-20
    80002104:	4501                	li	a0,0
    80002106:	00000097          	auipc	ra,0x0
    8000210a:	edc080e7          	jalr	-292(ra) # 80001fe2 <argint>
        return -1;
    8000210e:	57fd                	li	a5,-1
    if (argint(0, &n) < 0)
    80002110:	00054963          	bltz	a0,80002122 <sys_exit+0x2a>
    exit(n);
    80002114:	fec42503          	lw	a0,-20(s0)
    80002118:	fffff097          	auipc	ra,0xfffff
    8000211c:	6d8080e7          	jalr	1752(ra) # 800017f0 <exit>
    return 0; // not reached
    80002120:	4781                	li	a5,0
}
    80002122:	853e                	mv	a0,a5
    80002124:	60e2                	ld	ra,24(sp)
    80002126:	6442                	ld	s0,16(sp)
    80002128:	6105                	add	sp,sp,32
    8000212a:	8082                	ret

000000008000212c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000212c:	1141                	add	sp,sp,-16
    8000212e:	e406                	sd	ra,8(sp)
    80002130:	e022                	sd	s0,0(sp)
    80002132:	0800                	add	s0,sp,16
    return myproc()->pid;
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	d92080e7          	jalr	-622(ra) # 80000ec6 <myproc>
}
    8000213c:	5908                	lw	a0,48(a0)
    8000213e:	60a2                	ld	ra,8(sp)
    80002140:	6402                	ld	s0,0(sp)
    80002142:	0141                	add	sp,sp,16
    80002144:	8082                	ret

0000000080002146 <sys_fork>:

uint64
sys_fork(void)
{
    80002146:	1141                	add	sp,sp,-16
    80002148:	e406                	sd	ra,8(sp)
    8000214a:	e022                	sd	s0,0(sp)
    8000214c:	0800                	add	s0,sp,16
    return fork();
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	14a080e7          	jalr	330(ra) # 80001298 <fork>
}
    80002156:	60a2                	ld	ra,8(sp)
    80002158:	6402                	ld	s0,0(sp)
    8000215a:	0141                	add	sp,sp,16
    8000215c:	8082                	ret

000000008000215e <sys_wait>:

uint64
sys_wait(void)
{
    8000215e:	1101                	add	sp,sp,-32
    80002160:	ec06                	sd	ra,24(sp)
    80002162:	e822                	sd	s0,16(sp)
    80002164:	1000                	add	s0,sp,32
    uint64 p;
    if (argaddr(0, &p) < 0)
    80002166:	fe840593          	add	a1,s0,-24
    8000216a:	4501                	li	a0,0
    8000216c:	00000097          	auipc	ra,0x0
    80002170:	e98080e7          	jalr	-360(ra) # 80002004 <argaddr>
    80002174:	87aa                	mv	a5,a0
        return -1;
    80002176:	557d                	li	a0,-1
    if (argaddr(0, &p) < 0)
    80002178:	0007c863          	bltz	a5,80002188 <sys_wait+0x2a>
    return wait(p);
    8000217c:	fe843503          	ld	a0,-24(s0)
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	478080e7          	jalr	1144(ra) # 800015f8 <wait>
}
    80002188:	60e2                	ld	ra,24(sp)
    8000218a:	6442                	ld	s0,16(sp)
    8000218c:	6105                	add	sp,sp,32
    8000218e:	8082                	ret

0000000080002190 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002190:	7179                	add	sp,sp,-48
    80002192:	f406                	sd	ra,40(sp)
    80002194:	f022                	sd	s0,32(sp)
    80002196:	1800                	add	s0,sp,48
    int addr;
    int n;

    if (argint(0, &n) < 0)
    80002198:	fdc40593          	add	a1,s0,-36
    8000219c:	4501                	li	a0,0
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	e44080e7          	jalr	-444(ra) # 80001fe2 <argint>
    800021a6:	87aa                	mv	a5,a0
        return -1;
    800021a8:	557d                	li	a0,-1
    if (argint(0, &n) < 0)
    800021aa:	0207c263          	bltz	a5,800021ce <sys_sbrk+0x3e>
    800021ae:	ec26                	sd	s1,24(sp)
    addr = myproc()->sz;
    800021b0:	fffff097          	auipc	ra,0xfffff
    800021b4:	d16080e7          	jalr	-746(ra) # 80000ec6 <myproc>
    800021b8:	4524                	lw	s1,72(a0)
    if (growproc(n) < 0)
    800021ba:	fdc42503          	lw	a0,-36(s0)
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	062080e7          	jalr	98(ra) # 80001220 <growproc>
    800021c6:	00054863          	bltz	a0,800021d6 <sys_sbrk+0x46>
        return -1;
    return addr;
    800021ca:	8526                	mv	a0,s1
    800021cc:	64e2                	ld	s1,24(sp)
}
    800021ce:	70a2                	ld	ra,40(sp)
    800021d0:	7402                	ld	s0,32(sp)
    800021d2:	6145                	add	sp,sp,48
    800021d4:	8082                	ret
        return -1;
    800021d6:	557d                	li	a0,-1
    800021d8:	64e2                	ld	s1,24(sp)
    800021da:	bfd5                	j	800021ce <sys_sbrk+0x3e>

00000000800021dc <sys_sleep>:

uint64
sys_sleep(void)
{
    800021dc:	7139                	add	sp,sp,-64
    800021de:	fc06                	sd	ra,56(sp)
    800021e0:	f822                	sd	s0,48(sp)
    800021e2:	0080                	add	s0,sp,64
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
    800021e4:	fcc40593          	add	a1,s0,-52
    800021e8:	4501                	li	a0,0
    800021ea:	00000097          	auipc	ra,0x0
    800021ee:	df8080e7          	jalr	-520(ra) # 80001fe2 <argint>
        return -1;
    800021f2:	57fd                	li	a5,-1
    if (argint(0, &n) < 0)
    800021f4:	06054b63          	bltz	a0,8000226a <sys_sleep+0x8e>
    800021f8:	f04a                	sd	s2,32(sp)
    acquire(&tickslock);
    800021fa:	0000d517          	auipc	a0,0xd
    800021fe:	e8650513          	add	a0,a0,-378 # 8000f080 <tickslock>
    80002202:	00004097          	auipc	ra,0x4
    80002206:	104080e7          	jalr	260(ra) # 80006306 <acquire>
    ticks0 = ticks;
    8000220a:	00007917          	auipc	s2,0x7
    8000220e:	e0e92903          	lw	s2,-498(s2) # 80009018 <ticks>
    while (ticks - ticks0 < n)
    80002212:	fcc42783          	lw	a5,-52(s0)
    80002216:	c3a1                	beqz	a5,80002256 <sys_sleep+0x7a>
    80002218:	f426                	sd	s1,40(sp)
    8000221a:	ec4e                	sd	s3,24(sp)
        if (myproc()->killed)
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    8000221c:	0000d997          	auipc	s3,0xd
    80002220:	e6498993          	add	s3,s3,-412 # 8000f080 <tickslock>
    80002224:	00007497          	auipc	s1,0x7
    80002228:	df448493          	add	s1,s1,-524 # 80009018 <ticks>
        if (myproc()->killed)
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	c9a080e7          	jalr	-870(ra) # 80000ec6 <myproc>
    80002234:	551c                	lw	a5,40(a0)
    80002236:	ef9d                	bnez	a5,80002274 <sys_sleep+0x98>
        sleep(&ticks, &tickslock);
    80002238:	85ce                	mv	a1,s3
    8000223a:	8526                	mv	a0,s1
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	358080e7          	jalr	856(ra) # 80001594 <sleep>
    while (ticks - ticks0 < n)
    80002244:	409c                	lw	a5,0(s1)
    80002246:	412787bb          	subw	a5,a5,s2
    8000224a:	fcc42703          	lw	a4,-52(s0)
    8000224e:	fce7efe3          	bltu	a5,a4,8000222c <sys_sleep+0x50>
    80002252:	74a2                	ld	s1,40(sp)
    80002254:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    80002256:	0000d517          	auipc	a0,0xd
    8000225a:	e2a50513          	add	a0,a0,-470 # 8000f080 <tickslock>
    8000225e:	00004097          	auipc	ra,0x4
    80002262:	15c080e7          	jalr	348(ra) # 800063ba <release>
    return 0;
    80002266:	4781                	li	a5,0
    80002268:	7902                	ld	s2,32(sp)
}
    8000226a:	853e                	mv	a0,a5
    8000226c:	70e2                	ld	ra,56(sp)
    8000226e:	7442                	ld	s0,48(sp)
    80002270:	6121                	add	sp,sp,64
    80002272:	8082                	ret
            release(&tickslock);
    80002274:	0000d517          	auipc	a0,0xd
    80002278:	e0c50513          	add	a0,a0,-500 # 8000f080 <tickslock>
    8000227c:	00004097          	auipc	ra,0x4
    80002280:	13e080e7          	jalr	318(ra) # 800063ba <release>
            return -1;
    80002284:	57fd                	li	a5,-1
    80002286:	74a2                	ld	s1,40(sp)
    80002288:	7902                	ld	s2,32(sp)
    8000228a:	69e2                	ld	s3,24(sp)
    8000228c:	bff9                	j	8000226a <sys_sleep+0x8e>

000000008000228e <sys_kill>:

uint64
sys_kill(void)
{
    8000228e:	1101                	add	sp,sp,-32
    80002290:	ec06                	sd	ra,24(sp)
    80002292:	e822                	sd	s0,16(sp)
    80002294:	1000                	add	s0,sp,32
    int pid;

    if (argint(0, &pid) < 0)
    80002296:	fec40593          	add	a1,s0,-20
    8000229a:	4501                	li	a0,0
    8000229c:	00000097          	auipc	ra,0x0
    800022a0:	d46080e7          	jalr	-698(ra) # 80001fe2 <argint>
    800022a4:	87aa                	mv	a5,a0
        return -1;
    800022a6:	557d                	li	a0,-1
    if (argint(0, &pid) < 0)
    800022a8:	0007c863          	bltz	a5,800022b8 <sys_kill+0x2a>
    return kill(pid);
    800022ac:	fec42503          	lw	a0,-20(s0)
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	616080e7          	jalr	1558(ra) # 800018c6 <kill>
}
    800022b8:	60e2                	ld	ra,24(sp)
    800022ba:	6442                	ld	s0,16(sp)
    800022bc:	6105                	add	sp,sp,32
    800022be:	8082                	ret

00000000800022c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022c0:	1101                	add	sp,sp,-32
    800022c2:	ec06                	sd	ra,24(sp)
    800022c4:	e822                	sd	s0,16(sp)
    800022c6:	e426                	sd	s1,8(sp)
    800022c8:	1000                	add	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    800022ca:	0000d517          	auipc	a0,0xd
    800022ce:	db650513          	add	a0,a0,-586 # 8000f080 <tickslock>
    800022d2:	00004097          	auipc	ra,0x4
    800022d6:	034080e7          	jalr	52(ra) # 80006306 <acquire>
    xticks = ticks;
    800022da:	00007497          	auipc	s1,0x7
    800022de:	d3e4a483          	lw	s1,-706(s1) # 80009018 <ticks>
    release(&tickslock);
    800022e2:	0000d517          	auipc	a0,0xd
    800022e6:	d9e50513          	add	a0,a0,-610 # 8000f080 <tickslock>
    800022ea:	00004097          	auipc	ra,0x4
    800022ee:	0d0080e7          	jalr	208(ra) # 800063ba <release>
    return xticks;
}
    800022f2:	02049513          	sll	a0,s1,0x20
    800022f6:	9101                	srl	a0,a0,0x20
    800022f8:	60e2                	ld	ra,24(sp)
    800022fa:	6442                	ld	s0,16(sp)
    800022fc:	64a2                	ld	s1,8(sp)
    800022fe:	6105                	add	sp,sp,32
    80002300:	8082                	ret

0000000080002302 <sys_trace>:

// set the trace mask
uint64 sys_trace(void)
{
    80002302:	1101                	add	sp,sp,-32
    80002304:	ec06                	sd	ra,24(sp)
    80002306:	e822                	sd	s0,16(sp)
    80002308:	1000                	add	s0,sp,32
    int n;
    if (argint(0, &n) < 0)
    8000230a:	fec40593          	add	a1,s0,-20
    8000230e:	4501                	li	a0,0
    80002310:	00000097          	auipc	ra,0x0
    80002314:	cd2080e7          	jalr	-814(ra) # 80001fe2 <argint>
        return -1;
    80002318:	57fd                	li	a5,-1
    if (argint(0, &n) < 0)
    8000231a:	00054b63          	bltz	a0,80002330 <sys_trace+0x2e>
    myproc()->trace_mask = n;
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	ba8080e7          	jalr	-1112(ra) # 80000ec6 <myproc>
    80002326:	fec42783          	lw	a5,-20(s0)
    8000232a:	16f52423          	sw	a5,360(a0)
    return 0;
    8000232e:	4781                	li	a5,0
}
    80002330:	853e                	mv	a0,a5
    80002332:	60e2                	ld	ra,24(sp)
    80002334:	6442                	ld	s0,16(sp)
    80002336:	6105                	add	sp,sp,32
    80002338:	8082                	ret

000000008000233a <sys_sysinfo>:

uint64 sys_sysinfo(void)
{
    8000233a:	7139                	add	sp,sp,-64
    8000233c:	fc06                	sd	ra,56(sp)
    8000233e:	f822                	sd	s0,48(sp)
    80002340:	0080                	add	s0,sp,64
    uint64 addr;
    if (argaddr(0, &addr) < 0)
    80002342:	fd840593          	add	a1,s0,-40
    80002346:	4501                	li	a0,0
    80002348:	00000097          	auipc	ra,0x0
    8000234c:	cbc080e7          	jalr	-836(ra) # 80002004 <argaddr>
    80002350:	87aa                	mv	a5,a0
        return -1;
    80002352:	557d                	li	a0,-1
    if (argaddr(0, &addr) < 0)
    80002354:	0407c063          	bltz	a5,80002394 <sys_sysinfo+0x5a>
    80002358:	f426                	sd	s1,40(sp)
    struct proc *p = myproc();
    8000235a:	fffff097          	auipc	ra,0xfffff
    8000235e:	b6c080e7          	jalr	-1172(ra) # 80000ec6 <myproc>
    80002362:	84aa                	mv	s1,a0
    struct sysinfo sf;
    sf.freemem = kfreemem();
    80002364:	ffffe097          	auipc	ra,0xffffe
    80002368:	e16080e7          	jalr	-490(ra) # 8000017a <kfreemem>
    8000236c:	fca43423          	sd	a0,-56(s0)
    sf.nproc = nproc();
    80002370:	fffff097          	auipc	ra,0xfffff
    80002374:	724080e7          	jalr	1828(ra) # 80001a94 <nproc>
    80002378:	fca43823          	sd	a0,-48(s0)
    if (copyout(p->pagetable, addr, (char *)&sf, sizeof(sf)) < 0)
    8000237c:	46c1                	li	a3,16
    8000237e:	fc840613          	add	a2,s0,-56
    80002382:	fd843583          	ld	a1,-40(s0)
    80002386:	68a8                	ld	a0,80(s1)
    80002388:	ffffe097          	auipc	ra,0xffffe
    8000238c:	7da080e7          	jalr	2010(ra) # 80000b62 <copyout>
    80002390:	957d                	sra	a0,a0,0x3f
    80002392:	74a2                	ld	s1,40(sp)
        return -1;
    return 0;
}
    80002394:	70e2                	ld	ra,56(sp)
    80002396:	7442                	ld	s0,48(sp)
    80002398:	6121                	add	sp,sp,64
    8000239a:	8082                	ret

000000008000239c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000239c:	7179                	add	sp,sp,-48
    8000239e:	f406                	sd	ra,40(sp)
    800023a0:	f022                	sd	s0,32(sp)
    800023a2:	ec26                	sd	s1,24(sp)
    800023a4:	e84a                	sd	s2,16(sp)
    800023a6:	e44e                	sd	s3,8(sp)
    800023a8:	e052                	sd	s4,0(sp)
    800023aa:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023ac:	00006597          	auipc	a1,0x6
    800023b0:	09c58593          	add	a1,a1,156 # 80008448 <etext+0x448>
    800023b4:	0000d517          	auipc	a0,0xd
    800023b8:	ce450513          	add	a0,a0,-796 # 8000f098 <bcache>
    800023bc:	00004097          	auipc	ra,0x4
    800023c0:	eba080e7          	jalr	-326(ra) # 80006276 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023c4:	00015797          	auipc	a5,0x15
    800023c8:	cd478793          	add	a5,a5,-812 # 80017098 <bcache+0x8000>
    800023cc:	00015717          	auipc	a4,0x15
    800023d0:	f3470713          	add	a4,a4,-204 # 80017300 <bcache+0x8268>
    800023d4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023d8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023dc:	0000d497          	auipc	s1,0xd
    800023e0:	cd448493          	add	s1,s1,-812 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800023e4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023e6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023e8:	00006a17          	auipc	s4,0x6
    800023ec:	068a0a13          	add	s4,s4,104 # 80008450 <etext+0x450>
    b->next = bcache.head.next;
    800023f0:	2b893783          	ld	a5,696(s2)
    800023f4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023f6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023fa:	85d2                	mv	a1,s4
    800023fc:	01048513          	add	a0,s1,16
    80002400:	00001097          	auipc	ra,0x1
    80002404:	4b2080e7          	jalr	1202(ra) # 800038b2 <initsleeplock>
    bcache.head.next->prev = b;
    80002408:	2b893783          	ld	a5,696(s2)
    8000240c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000240e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002412:	45848493          	add	s1,s1,1112
    80002416:	fd349de3          	bne	s1,s3,800023f0 <binit+0x54>
  }
}
    8000241a:	70a2                	ld	ra,40(sp)
    8000241c:	7402                	ld	s0,32(sp)
    8000241e:	64e2                	ld	s1,24(sp)
    80002420:	6942                	ld	s2,16(sp)
    80002422:	69a2                	ld	s3,8(sp)
    80002424:	6a02                	ld	s4,0(sp)
    80002426:	6145                	add	sp,sp,48
    80002428:	8082                	ret

000000008000242a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000242a:	7179                	add	sp,sp,-48
    8000242c:	f406                	sd	ra,40(sp)
    8000242e:	f022                	sd	s0,32(sp)
    80002430:	ec26                	sd	s1,24(sp)
    80002432:	e84a                	sd	s2,16(sp)
    80002434:	e44e                	sd	s3,8(sp)
    80002436:	1800                	add	s0,sp,48
    80002438:	892a                	mv	s2,a0
    8000243a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000243c:	0000d517          	auipc	a0,0xd
    80002440:	c5c50513          	add	a0,a0,-932 # 8000f098 <bcache>
    80002444:	00004097          	auipc	ra,0x4
    80002448:	ec2080e7          	jalr	-318(ra) # 80006306 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000244c:	00015497          	auipc	s1,0x15
    80002450:	f044b483          	ld	s1,-252(s1) # 80017350 <bcache+0x82b8>
    80002454:	00015797          	auipc	a5,0x15
    80002458:	eac78793          	add	a5,a5,-340 # 80017300 <bcache+0x8268>
    8000245c:	02f48f63          	beq	s1,a5,8000249a <bread+0x70>
    80002460:	873e                	mv	a4,a5
    80002462:	a021                	j	8000246a <bread+0x40>
    80002464:	68a4                	ld	s1,80(s1)
    80002466:	02e48a63          	beq	s1,a4,8000249a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000246a:	449c                	lw	a5,8(s1)
    8000246c:	ff279ce3          	bne	a5,s2,80002464 <bread+0x3a>
    80002470:	44dc                	lw	a5,12(s1)
    80002472:	ff3799e3          	bne	a5,s3,80002464 <bread+0x3a>
      b->refcnt++;
    80002476:	40bc                	lw	a5,64(s1)
    80002478:	2785                	addw	a5,a5,1
    8000247a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000247c:	0000d517          	auipc	a0,0xd
    80002480:	c1c50513          	add	a0,a0,-996 # 8000f098 <bcache>
    80002484:	00004097          	auipc	ra,0x4
    80002488:	f36080e7          	jalr	-202(ra) # 800063ba <release>
      acquiresleep(&b->lock);
    8000248c:	01048513          	add	a0,s1,16
    80002490:	00001097          	auipc	ra,0x1
    80002494:	45c080e7          	jalr	1116(ra) # 800038ec <acquiresleep>
      return b;
    80002498:	a8b9                	j	800024f6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000249a:	00015497          	auipc	s1,0x15
    8000249e:	eae4b483          	ld	s1,-338(s1) # 80017348 <bcache+0x82b0>
    800024a2:	00015797          	auipc	a5,0x15
    800024a6:	e5e78793          	add	a5,a5,-418 # 80017300 <bcache+0x8268>
    800024aa:	00f48863          	beq	s1,a5,800024ba <bread+0x90>
    800024ae:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024b0:	40bc                	lw	a5,64(s1)
    800024b2:	cf81                	beqz	a5,800024ca <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024b4:	64a4                	ld	s1,72(s1)
    800024b6:	fee49de3          	bne	s1,a4,800024b0 <bread+0x86>
  panic("bget: no buffers");
    800024ba:	00006517          	auipc	a0,0x6
    800024be:	f9e50513          	add	a0,a0,-98 # 80008458 <etext+0x458>
    800024c2:	00004097          	auipc	ra,0x4
    800024c6:	8ca080e7          	jalr	-1846(ra) # 80005d8c <panic>
      b->dev = dev;
    800024ca:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024ce:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024d2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024d6:	4785                	li	a5,1
    800024d8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024da:	0000d517          	auipc	a0,0xd
    800024de:	bbe50513          	add	a0,a0,-1090 # 8000f098 <bcache>
    800024e2:	00004097          	auipc	ra,0x4
    800024e6:	ed8080e7          	jalr	-296(ra) # 800063ba <release>
      acquiresleep(&b->lock);
    800024ea:	01048513          	add	a0,s1,16
    800024ee:	00001097          	auipc	ra,0x1
    800024f2:	3fe080e7          	jalr	1022(ra) # 800038ec <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024f6:	409c                	lw	a5,0(s1)
    800024f8:	cb89                	beqz	a5,8000250a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024fa:	8526                	mv	a0,s1
    800024fc:	70a2                	ld	ra,40(sp)
    800024fe:	7402                	ld	s0,32(sp)
    80002500:	64e2                	ld	s1,24(sp)
    80002502:	6942                	ld	s2,16(sp)
    80002504:	69a2                	ld	s3,8(sp)
    80002506:	6145                	add	sp,sp,48
    80002508:	8082                	ret
    virtio_disk_rw(b, 0);
    8000250a:	4581                	li	a1,0
    8000250c:	8526                	mv	a0,s1
    8000250e:	00003097          	auipc	ra,0x3
    80002512:	fe4080e7          	jalr	-28(ra) # 800054f2 <virtio_disk_rw>
    b->valid = 1;
    80002516:	4785                	li	a5,1
    80002518:	c09c                	sw	a5,0(s1)
  return b;
    8000251a:	b7c5                	j	800024fa <bread+0xd0>

000000008000251c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000251c:	1101                	add	sp,sp,-32
    8000251e:	ec06                	sd	ra,24(sp)
    80002520:	e822                	sd	s0,16(sp)
    80002522:	e426                	sd	s1,8(sp)
    80002524:	1000                	add	s0,sp,32
    80002526:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002528:	0541                	add	a0,a0,16
    8000252a:	00001097          	auipc	ra,0x1
    8000252e:	45c080e7          	jalr	1116(ra) # 80003986 <holdingsleep>
    80002532:	cd01                	beqz	a0,8000254a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002534:	4585                	li	a1,1
    80002536:	8526                	mv	a0,s1
    80002538:	00003097          	auipc	ra,0x3
    8000253c:	fba080e7          	jalr	-70(ra) # 800054f2 <virtio_disk_rw>
}
    80002540:	60e2                	ld	ra,24(sp)
    80002542:	6442                	ld	s0,16(sp)
    80002544:	64a2                	ld	s1,8(sp)
    80002546:	6105                	add	sp,sp,32
    80002548:	8082                	ret
    panic("bwrite");
    8000254a:	00006517          	auipc	a0,0x6
    8000254e:	f2650513          	add	a0,a0,-218 # 80008470 <etext+0x470>
    80002552:	00004097          	auipc	ra,0x4
    80002556:	83a080e7          	jalr	-1990(ra) # 80005d8c <panic>

000000008000255a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000255a:	1101                	add	sp,sp,-32
    8000255c:	ec06                	sd	ra,24(sp)
    8000255e:	e822                	sd	s0,16(sp)
    80002560:	e426                	sd	s1,8(sp)
    80002562:	e04a                	sd	s2,0(sp)
    80002564:	1000                	add	s0,sp,32
    80002566:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002568:	01050913          	add	s2,a0,16
    8000256c:	854a                	mv	a0,s2
    8000256e:	00001097          	auipc	ra,0x1
    80002572:	418080e7          	jalr	1048(ra) # 80003986 <holdingsleep>
    80002576:	c925                	beqz	a0,800025e6 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002578:	854a                	mv	a0,s2
    8000257a:	00001097          	auipc	ra,0x1
    8000257e:	3c8080e7          	jalr	968(ra) # 80003942 <releasesleep>

  acquire(&bcache.lock);
    80002582:	0000d517          	auipc	a0,0xd
    80002586:	b1650513          	add	a0,a0,-1258 # 8000f098 <bcache>
    8000258a:	00004097          	auipc	ra,0x4
    8000258e:	d7c080e7          	jalr	-644(ra) # 80006306 <acquire>
  b->refcnt--;
    80002592:	40bc                	lw	a5,64(s1)
    80002594:	37fd                	addw	a5,a5,-1
    80002596:	0007871b          	sext.w	a4,a5
    8000259a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000259c:	e71d                	bnez	a4,800025ca <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000259e:	68b8                	ld	a4,80(s1)
    800025a0:	64bc                	ld	a5,72(s1)
    800025a2:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800025a4:	68b8                	ld	a4,80(s1)
    800025a6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025a8:	00015797          	auipc	a5,0x15
    800025ac:	af078793          	add	a5,a5,-1296 # 80017098 <bcache+0x8000>
    800025b0:	2b87b703          	ld	a4,696(a5)
    800025b4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025b6:	00015717          	auipc	a4,0x15
    800025ba:	d4a70713          	add	a4,a4,-694 # 80017300 <bcache+0x8268>
    800025be:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025c0:	2b87b703          	ld	a4,696(a5)
    800025c4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025c6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025ca:	0000d517          	auipc	a0,0xd
    800025ce:	ace50513          	add	a0,a0,-1330 # 8000f098 <bcache>
    800025d2:	00004097          	auipc	ra,0x4
    800025d6:	de8080e7          	jalr	-536(ra) # 800063ba <release>
}
    800025da:	60e2                	ld	ra,24(sp)
    800025dc:	6442                	ld	s0,16(sp)
    800025de:	64a2                	ld	s1,8(sp)
    800025e0:	6902                	ld	s2,0(sp)
    800025e2:	6105                	add	sp,sp,32
    800025e4:	8082                	ret
    panic("brelse");
    800025e6:	00006517          	auipc	a0,0x6
    800025ea:	e9250513          	add	a0,a0,-366 # 80008478 <etext+0x478>
    800025ee:	00003097          	auipc	ra,0x3
    800025f2:	79e080e7          	jalr	1950(ra) # 80005d8c <panic>

00000000800025f6 <bpin>:

void
bpin(struct buf *b) {
    800025f6:	1101                	add	sp,sp,-32
    800025f8:	ec06                	sd	ra,24(sp)
    800025fa:	e822                	sd	s0,16(sp)
    800025fc:	e426                	sd	s1,8(sp)
    800025fe:	1000                	add	s0,sp,32
    80002600:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002602:	0000d517          	auipc	a0,0xd
    80002606:	a9650513          	add	a0,a0,-1386 # 8000f098 <bcache>
    8000260a:	00004097          	auipc	ra,0x4
    8000260e:	cfc080e7          	jalr	-772(ra) # 80006306 <acquire>
  b->refcnt++;
    80002612:	40bc                	lw	a5,64(s1)
    80002614:	2785                	addw	a5,a5,1
    80002616:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002618:	0000d517          	auipc	a0,0xd
    8000261c:	a8050513          	add	a0,a0,-1408 # 8000f098 <bcache>
    80002620:	00004097          	auipc	ra,0x4
    80002624:	d9a080e7          	jalr	-614(ra) # 800063ba <release>
}
    80002628:	60e2                	ld	ra,24(sp)
    8000262a:	6442                	ld	s0,16(sp)
    8000262c:	64a2                	ld	s1,8(sp)
    8000262e:	6105                	add	sp,sp,32
    80002630:	8082                	ret

0000000080002632 <bunpin>:

void
bunpin(struct buf *b) {
    80002632:	1101                	add	sp,sp,-32
    80002634:	ec06                	sd	ra,24(sp)
    80002636:	e822                	sd	s0,16(sp)
    80002638:	e426                	sd	s1,8(sp)
    8000263a:	1000                	add	s0,sp,32
    8000263c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000263e:	0000d517          	auipc	a0,0xd
    80002642:	a5a50513          	add	a0,a0,-1446 # 8000f098 <bcache>
    80002646:	00004097          	auipc	ra,0x4
    8000264a:	cc0080e7          	jalr	-832(ra) # 80006306 <acquire>
  b->refcnt--;
    8000264e:	40bc                	lw	a5,64(s1)
    80002650:	37fd                	addw	a5,a5,-1
    80002652:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002654:	0000d517          	auipc	a0,0xd
    80002658:	a4450513          	add	a0,a0,-1468 # 8000f098 <bcache>
    8000265c:	00004097          	auipc	ra,0x4
    80002660:	d5e080e7          	jalr	-674(ra) # 800063ba <release>
}
    80002664:	60e2                	ld	ra,24(sp)
    80002666:	6442                	ld	s0,16(sp)
    80002668:	64a2                	ld	s1,8(sp)
    8000266a:	6105                	add	sp,sp,32
    8000266c:	8082                	ret

000000008000266e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000266e:	1101                	add	sp,sp,-32
    80002670:	ec06                	sd	ra,24(sp)
    80002672:	e822                	sd	s0,16(sp)
    80002674:	e426                	sd	s1,8(sp)
    80002676:	e04a                	sd	s2,0(sp)
    80002678:	1000                	add	s0,sp,32
    8000267a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000267c:	00d5d59b          	srlw	a1,a1,0xd
    80002680:	00015797          	auipc	a5,0x15
    80002684:	0f47a783          	lw	a5,244(a5) # 80017774 <sb+0x1c>
    80002688:	9dbd                	addw	a1,a1,a5
    8000268a:	00000097          	auipc	ra,0x0
    8000268e:	da0080e7          	jalr	-608(ra) # 8000242a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002692:	0074f713          	and	a4,s1,7
    80002696:	4785                	li	a5,1
    80002698:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000269c:	14ce                	sll	s1,s1,0x33
    8000269e:	90d9                	srl	s1,s1,0x36
    800026a0:	00950733          	add	a4,a0,s1
    800026a4:	05874703          	lbu	a4,88(a4)
    800026a8:	00e7f6b3          	and	a3,a5,a4
    800026ac:	c69d                	beqz	a3,800026da <bfree+0x6c>
    800026ae:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026b0:	94aa                	add	s1,s1,a0
    800026b2:	fff7c793          	not	a5,a5
    800026b6:	8f7d                	and	a4,a4,a5
    800026b8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026bc:	00001097          	auipc	ra,0x1
    800026c0:	112080e7          	jalr	274(ra) # 800037ce <log_write>
  brelse(bp);
    800026c4:	854a                	mv	a0,s2
    800026c6:	00000097          	auipc	ra,0x0
    800026ca:	e94080e7          	jalr	-364(ra) # 8000255a <brelse>
}
    800026ce:	60e2                	ld	ra,24(sp)
    800026d0:	6442                	ld	s0,16(sp)
    800026d2:	64a2                	ld	s1,8(sp)
    800026d4:	6902                	ld	s2,0(sp)
    800026d6:	6105                	add	sp,sp,32
    800026d8:	8082                	ret
    panic("freeing free block");
    800026da:	00006517          	auipc	a0,0x6
    800026de:	da650513          	add	a0,a0,-602 # 80008480 <etext+0x480>
    800026e2:	00003097          	auipc	ra,0x3
    800026e6:	6aa080e7          	jalr	1706(ra) # 80005d8c <panic>

00000000800026ea <balloc>:
{
    800026ea:	711d                	add	sp,sp,-96
    800026ec:	ec86                	sd	ra,88(sp)
    800026ee:	e8a2                	sd	s0,80(sp)
    800026f0:	e4a6                	sd	s1,72(sp)
    800026f2:	e0ca                	sd	s2,64(sp)
    800026f4:	fc4e                	sd	s3,56(sp)
    800026f6:	f852                	sd	s4,48(sp)
    800026f8:	f456                	sd	s5,40(sp)
    800026fa:	f05a                	sd	s6,32(sp)
    800026fc:	ec5e                	sd	s7,24(sp)
    800026fe:	e862                	sd	s8,16(sp)
    80002700:	e466                	sd	s9,8(sp)
    80002702:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002704:	00015797          	auipc	a5,0x15
    80002708:	0587a783          	lw	a5,88(a5) # 8001775c <sb+0x4>
    8000270c:	cbc1                	beqz	a5,8000279c <balloc+0xb2>
    8000270e:	8baa                	mv	s7,a0
    80002710:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002712:	00015b17          	auipc	s6,0x15
    80002716:	046b0b13          	add	s6,s6,70 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000271a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000271c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000271e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002720:	6c89                	lui	s9,0x2
    80002722:	a831                	j	8000273e <balloc+0x54>
    brelse(bp);
    80002724:	854a                	mv	a0,s2
    80002726:	00000097          	auipc	ra,0x0
    8000272a:	e34080e7          	jalr	-460(ra) # 8000255a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000272e:	015c87bb          	addw	a5,s9,s5
    80002732:	00078a9b          	sext.w	s5,a5
    80002736:	004b2703          	lw	a4,4(s6)
    8000273a:	06eaf163          	bgeu	s5,a4,8000279c <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000273e:	41fad79b          	sraw	a5,s5,0x1f
    80002742:	0137d79b          	srlw	a5,a5,0x13
    80002746:	015787bb          	addw	a5,a5,s5
    8000274a:	40d7d79b          	sraw	a5,a5,0xd
    8000274e:	01cb2583          	lw	a1,28(s6)
    80002752:	9dbd                	addw	a1,a1,a5
    80002754:	855e                	mv	a0,s7
    80002756:	00000097          	auipc	ra,0x0
    8000275a:	cd4080e7          	jalr	-812(ra) # 8000242a <bread>
    8000275e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002760:	004b2503          	lw	a0,4(s6)
    80002764:	000a849b          	sext.w	s1,s5
    80002768:	8762                	mv	a4,s8
    8000276a:	faa4fde3          	bgeu	s1,a0,80002724 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000276e:	00777693          	and	a3,a4,7
    80002772:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002776:	41f7579b          	sraw	a5,a4,0x1f
    8000277a:	01d7d79b          	srlw	a5,a5,0x1d
    8000277e:	9fb9                	addw	a5,a5,a4
    80002780:	4037d79b          	sraw	a5,a5,0x3
    80002784:	00f90633          	add	a2,s2,a5
    80002788:	05864603          	lbu	a2,88(a2)
    8000278c:	00c6f5b3          	and	a1,a3,a2
    80002790:	cd91                	beqz	a1,800027ac <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002792:	2705                	addw	a4,a4,1
    80002794:	2485                	addw	s1,s1,1
    80002796:	fd471ae3          	bne	a4,s4,8000276a <balloc+0x80>
    8000279a:	b769                	j	80002724 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000279c:	00006517          	auipc	a0,0x6
    800027a0:	cfc50513          	add	a0,a0,-772 # 80008498 <etext+0x498>
    800027a4:	00003097          	auipc	ra,0x3
    800027a8:	5e8080e7          	jalr	1512(ra) # 80005d8c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800027ac:	97ca                	add	a5,a5,s2
    800027ae:	8e55                	or	a2,a2,a3
    800027b0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800027b4:	854a                	mv	a0,s2
    800027b6:	00001097          	auipc	ra,0x1
    800027ba:	018080e7          	jalr	24(ra) # 800037ce <log_write>
        brelse(bp);
    800027be:	854a                	mv	a0,s2
    800027c0:	00000097          	auipc	ra,0x0
    800027c4:	d9a080e7          	jalr	-614(ra) # 8000255a <brelse>
  bp = bread(dev, bno);
    800027c8:	85a6                	mv	a1,s1
    800027ca:	855e                	mv	a0,s7
    800027cc:	00000097          	auipc	ra,0x0
    800027d0:	c5e080e7          	jalr	-930(ra) # 8000242a <bread>
    800027d4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027d6:	40000613          	li	a2,1024
    800027da:	4581                	li	a1,0
    800027dc:	05850513          	add	a0,a0,88
    800027e0:	ffffe097          	auipc	ra,0xffffe
    800027e4:	9e4080e7          	jalr	-1564(ra) # 800001c4 <memset>
  log_write(bp);
    800027e8:	854a                	mv	a0,s2
    800027ea:	00001097          	auipc	ra,0x1
    800027ee:	fe4080e7          	jalr	-28(ra) # 800037ce <log_write>
  brelse(bp);
    800027f2:	854a                	mv	a0,s2
    800027f4:	00000097          	auipc	ra,0x0
    800027f8:	d66080e7          	jalr	-666(ra) # 8000255a <brelse>
}
    800027fc:	8526                	mv	a0,s1
    800027fe:	60e6                	ld	ra,88(sp)
    80002800:	6446                	ld	s0,80(sp)
    80002802:	64a6                	ld	s1,72(sp)
    80002804:	6906                	ld	s2,64(sp)
    80002806:	79e2                	ld	s3,56(sp)
    80002808:	7a42                	ld	s4,48(sp)
    8000280a:	7aa2                	ld	s5,40(sp)
    8000280c:	7b02                	ld	s6,32(sp)
    8000280e:	6be2                	ld	s7,24(sp)
    80002810:	6c42                	ld	s8,16(sp)
    80002812:	6ca2                	ld	s9,8(sp)
    80002814:	6125                	add	sp,sp,96
    80002816:	8082                	ret

0000000080002818 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002818:	7179                	add	sp,sp,-48
    8000281a:	f406                	sd	ra,40(sp)
    8000281c:	f022                	sd	s0,32(sp)
    8000281e:	ec26                	sd	s1,24(sp)
    80002820:	e84a                	sd	s2,16(sp)
    80002822:	e44e                	sd	s3,8(sp)
    80002824:	1800                	add	s0,sp,48
    80002826:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002828:	47ad                	li	a5,11
    8000282a:	04b7ff63          	bgeu	a5,a1,80002888 <bmap+0x70>
    8000282e:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002830:	ff45849b          	addw	s1,a1,-12
    80002834:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002838:	0ff00793          	li	a5,255
    8000283c:	0ae7e463          	bltu	a5,a4,800028e4 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002840:	08052583          	lw	a1,128(a0)
    80002844:	c5b5                	beqz	a1,800028b0 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002846:	00092503          	lw	a0,0(s2)
    8000284a:	00000097          	auipc	ra,0x0
    8000284e:	be0080e7          	jalr	-1056(ra) # 8000242a <bread>
    80002852:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002854:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80002858:	02049713          	sll	a4,s1,0x20
    8000285c:	01e75593          	srl	a1,a4,0x1e
    80002860:	00b784b3          	add	s1,a5,a1
    80002864:	0004a983          	lw	s3,0(s1)
    80002868:	04098e63          	beqz	s3,800028c4 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000286c:	8552                	mv	a0,s4
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	cec080e7          	jalr	-788(ra) # 8000255a <brelse>
    return addr;
    80002876:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002878:	854e                	mv	a0,s3
    8000287a:	70a2                	ld	ra,40(sp)
    8000287c:	7402                	ld	s0,32(sp)
    8000287e:	64e2                	ld	s1,24(sp)
    80002880:	6942                	ld	s2,16(sp)
    80002882:	69a2                	ld	s3,8(sp)
    80002884:	6145                	add	sp,sp,48
    80002886:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002888:	02059793          	sll	a5,a1,0x20
    8000288c:	01e7d593          	srl	a1,a5,0x1e
    80002890:	00b504b3          	add	s1,a0,a1
    80002894:	0504a983          	lw	s3,80(s1)
    80002898:	fe0990e3          	bnez	s3,80002878 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000289c:	4108                	lw	a0,0(a0)
    8000289e:	00000097          	auipc	ra,0x0
    800028a2:	e4c080e7          	jalr	-436(ra) # 800026ea <balloc>
    800028a6:	0005099b          	sext.w	s3,a0
    800028aa:	0534a823          	sw	s3,80(s1)
    800028ae:	b7e9                	j	80002878 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800028b0:	4108                	lw	a0,0(a0)
    800028b2:	00000097          	auipc	ra,0x0
    800028b6:	e38080e7          	jalr	-456(ra) # 800026ea <balloc>
    800028ba:	0005059b          	sext.w	a1,a0
    800028be:	08b92023          	sw	a1,128(s2)
    800028c2:	b751                	j	80002846 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800028c4:	00092503          	lw	a0,0(s2)
    800028c8:	00000097          	auipc	ra,0x0
    800028cc:	e22080e7          	jalr	-478(ra) # 800026ea <balloc>
    800028d0:	0005099b          	sext.w	s3,a0
    800028d4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028d8:	8552                	mv	a0,s4
    800028da:	00001097          	auipc	ra,0x1
    800028de:	ef4080e7          	jalr	-268(ra) # 800037ce <log_write>
    800028e2:	b769                	j	8000286c <bmap+0x54>
  panic("bmap: out of range");
    800028e4:	00006517          	auipc	a0,0x6
    800028e8:	bcc50513          	add	a0,a0,-1076 # 800084b0 <etext+0x4b0>
    800028ec:	00003097          	auipc	ra,0x3
    800028f0:	4a0080e7          	jalr	1184(ra) # 80005d8c <panic>

00000000800028f4 <iget>:
{
    800028f4:	7179                	add	sp,sp,-48
    800028f6:	f406                	sd	ra,40(sp)
    800028f8:	f022                	sd	s0,32(sp)
    800028fa:	ec26                	sd	s1,24(sp)
    800028fc:	e84a                	sd	s2,16(sp)
    800028fe:	e44e                	sd	s3,8(sp)
    80002900:	e052                	sd	s4,0(sp)
    80002902:	1800                	add	s0,sp,48
    80002904:	89aa                	mv	s3,a0
    80002906:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002908:	00015517          	auipc	a0,0x15
    8000290c:	e7050513          	add	a0,a0,-400 # 80017778 <itable>
    80002910:	00004097          	auipc	ra,0x4
    80002914:	9f6080e7          	jalr	-1546(ra) # 80006306 <acquire>
  empty = 0;
    80002918:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000291a:	00015497          	auipc	s1,0x15
    8000291e:	e7648493          	add	s1,s1,-394 # 80017790 <itable+0x18>
    80002922:	00017697          	auipc	a3,0x17
    80002926:	8fe68693          	add	a3,a3,-1794 # 80019220 <log>
    8000292a:	a039                	j	80002938 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000292c:	02090b63          	beqz	s2,80002962 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002930:	08848493          	add	s1,s1,136
    80002934:	02d48a63          	beq	s1,a3,80002968 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002938:	449c                	lw	a5,8(s1)
    8000293a:	fef059e3          	blez	a5,8000292c <iget+0x38>
    8000293e:	4098                	lw	a4,0(s1)
    80002940:	ff3716e3          	bne	a4,s3,8000292c <iget+0x38>
    80002944:	40d8                	lw	a4,4(s1)
    80002946:	ff4713e3          	bne	a4,s4,8000292c <iget+0x38>
      ip->ref++;
    8000294a:	2785                	addw	a5,a5,1
    8000294c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000294e:	00015517          	auipc	a0,0x15
    80002952:	e2a50513          	add	a0,a0,-470 # 80017778 <itable>
    80002956:	00004097          	auipc	ra,0x4
    8000295a:	a64080e7          	jalr	-1436(ra) # 800063ba <release>
      return ip;
    8000295e:	8926                	mv	s2,s1
    80002960:	a03d                	j	8000298e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002962:	f7f9                	bnez	a5,80002930 <iget+0x3c>
      empty = ip;
    80002964:	8926                	mv	s2,s1
    80002966:	b7e9                	j	80002930 <iget+0x3c>
  if(empty == 0)
    80002968:	02090c63          	beqz	s2,800029a0 <iget+0xac>
  ip->dev = dev;
    8000296c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002970:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002974:	4785                	li	a5,1
    80002976:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000297a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000297e:	00015517          	auipc	a0,0x15
    80002982:	dfa50513          	add	a0,a0,-518 # 80017778 <itable>
    80002986:	00004097          	auipc	ra,0x4
    8000298a:	a34080e7          	jalr	-1484(ra) # 800063ba <release>
}
    8000298e:	854a                	mv	a0,s2
    80002990:	70a2                	ld	ra,40(sp)
    80002992:	7402                	ld	s0,32(sp)
    80002994:	64e2                	ld	s1,24(sp)
    80002996:	6942                	ld	s2,16(sp)
    80002998:	69a2                	ld	s3,8(sp)
    8000299a:	6a02                	ld	s4,0(sp)
    8000299c:	6145                	add	sp,sp,48
    8000299e:	8082                	ret
    panic("iget: no inodes");
    800029a0:	00006517          	auipc	a0,0x6
    800029a4:	b2850513          	add	a0,a0,-1240 # 800084c8 <etext+0x4c8>
    800029a8:	00003097          	auipc	ra,0x3
    800029ac:	3e4080e7          	jalr	996(ra) # 80005d8c <panic>

00000000800029b0 <fsinit>:
fsinit(int dev) {
    800029b0:	7179                	add	sp,sp,-48
    800029b2:	f406                	sd	ra,40(sp)
    800029b4:	f022                	sd	s0,32(sp)
    800029b6:	ec26                	sd	s1,24(sp)
    800029b8:	e84a                	sd	s2,16(sp)
    800029ba:	e44e                	sd	s3,8(sp)
    800029bc:	1800                	add	s0,sp,48
    800029be:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029c0:	4585                	li	a1,1
    800029c2:	00000097          	auipc	ra,0x0
    800029c6:	a68080e7          	jalr	-1432(ra) # 8000242a <bread>
    800029ca:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029cc:	00015997          	auipc	s3,0x15
    800029d0:	d8c98993          	add	s3,s3,-628 # 80017758 <sb>
    800029d4:	02000613          	li	a2,32
    800029d8:	05850593          	add	a1,a0,88
    800029dc:	854e                	mv	a0,s3
    800029de:	ffffe097          	auipc	ra,0xffffe
    800029e2:	842080e7          	jalr	-1982(ra) # 80000220 <memmove>
  brelse(bp);
    800029e6:	8526                	mv	a0,s1
    800029e8:	00000097          	auipc	ra,0x0
    800029ec:	b72080e7          	jalr	-1166(ra) # 8000255a <brelse>
  if(sb.magic != FSMAGIC)
    800029f0:	0009a703          	lw	a4,0(s3)
    800029f4:	102037b7          	lui	a5,0x10203
    800029f8:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029fc:	02f71263          	bne	a4,a5,80002a20 <fsinit+0x70>
  initlog(dev, &sb);
    80002a00:	00015597          	auipc	a1,0x15
    80002a04:	d5858593          	add	a1,a1,-680 # 80017758 <sb>
    80002a08:	854a                	mv	a0,s2
    80002a0a:	00001097          	auipc	ra,0x1
    80002a0e:	b54080e7          	jalr	-1196(ra) # 8000355e <initlog>
}
    80002a12:	70a2                	ld	ra,40(sp)
    80002a14:	7402                	ld	s0,32(sp)
    80002a16:	64e2                	ld	s1,24(sp)
    80002a18:	6942                	ld	s2,16(sp)
    80002a1a:	69a2                	ld	s3,8(sp)
    80002a1c:	6145                	add	sp,sp,48
    80002a1e:	8082                	ret
    panic("invalid file system");
    80002a20:	00006517          	auipc	a0,0x6
    80002a24:	ab850513          	add	a0,a0,-1352 # 800084d8 <etext+0x4d8>
    80002a28:	00003097          	auipc	ra,0x3
    80002a2c:	364080e7          	jalr	868(ra) # 80005d8c <panic>

0000000080002a30 <iinit>:
{
    80002a30:	7179                	add	sp,sp,-48
    80002a32:	f406                	sd	ra,40(sp)
    80002a34:	f022                	sd	s0,32(sp)
    80002a36:	ec26                	sd	s1,24(sp)
    80002a38:	e84a                	sd	s2,16(sp)
    80002a3a:	e44e                	sd	s3,8(sp)
    80002a3c:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a3e:	00006597          	auipc	a1,0x6
    80002a42:	ab258593          	add	a1,a1,-1358 # 800084f0 <etext+0x4f0>
    80002a46:	00015517          	auipc	a0,0x15
    80002a4a:	d3250513          	add	a0,a0,-718 # 80017778 <itable>
    80002a4e:	00004097          	auipc	ra,0x4
    80002a52:	828080e7          	jalr	-2008(ra) # 80006276 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a56:	00015497          	auipc	s1,0x15
    80002a5a:	d4a48493          	add	s1,s1,-694 # 800177a0 <itable+0x28>
    80002a5e:	00016997          	auipc	s3,0x16
    80002a62:	7d298993          	add	s3,s3,2002 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a66:	00006917          	auipc	s2,0x6
    80002a6a:	a9290913          	add	s2,s2,-1390 # 800084f8 <etext+0x4f8>
    80002a6e:	85ca                	mv	a1,s2
    80002a70:	8526                	mv	a0,s1
    80002a72:	00001097          	auipc	ra,0x1
    80002a76:	e40080e7          	jalr	-448(ra) # 800038b2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a7a:	08848493          	add	s1,s1,136
    80002a7e:	ff3498e3          	bne	s1,s3,80002a6e <iinit+0x3e>
}
    80002a82:	70a2                	ld	ra,40(sp)
    80002a84:	7402                	ld	s0,32(sp)
    80002a86:	64e2                	ld	s1,24(sp)
    80002a88:	6942                	ld	s2,16(sp)
    80002a8a:	69a2                	ld	s3,8(sp)
    80002a8c:	6145                	add	sp,sp,48
    80002a8e:	8082                	ret

0000000080002a90 <ialloc>:
{
    80002a90:	7139                	add	sp,sp,-64
    80002a92:	fc06                	sd	ra,56(sp)
    80002a94:	f822                	sd	s0,48(sp)
    80002a96:	f426                	sd	s1,40(sp)
    80002a98:	f04a                	sd	s2,32(sp)
    80002a9a:	ec4e                	sd	s3,24(sp)
    80002a9c:	e852                	sd	s4,16(sp)
    80002a9e:	e456                	sd	s5,8(sp)
    80002aa0:	e05a                	sd	s6,0(sp)
    80002aa2:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aa4:	00015717          	auipc	a4,0x15
    80002aa8:	cc072703          	lw	a4,-832(a4) # 80017764 <sb+0xc>
    80002aac:	4785                	li	a5,1
    80002aae:	04e7f863          	bgeu	a5,a4,80002afe <ialloc+0x6e>
    80002ab2:	8aaa                	mv	s5,a0
    80002ab4:	8b2e                	mv	s6,a1
    80002ab6:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ab8:	00015a17          	auipc	s4,0x15
    80002abc:	ca0a0a13          	add	s4,s4,-864 # 80017758 <sb>
    80002ac0:	00495593          	srl	a1,s2,0x4
    80002ac4:	018a2783          	lw	a5,24(s4)
    80002ac8:	9dbd                	addw	a1,a1,a5
    80002aca:	8556                	mv	a0,s5
    80002acc:	00000097          	auipc	ra,0x0
    80002ad0:	95e080e7          	jalr	-1698(ra) # 8000242a <bread>
    80002ad4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ad6:	05850993          	add	s3,a0,88
    80002ada:	00f97793          	and	a5,s2,15
    80002ade:	079a                	sll	a5,a5,0x6
    80002ae0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ae2:	00099783          	lh	a5,0(s3)
    80002ae6:	c785                	beqz	a5,80002b0e <ialloc+0x7e>
    brelse(bp);
    80002ae8:	00000097          	auipc	ra,0x0
    80002aec:	a72080e7          	jalr	-1422(ra) # 8000255a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002af0:	0905                	add	s2,s2,1
    80002af2:	00ca2703          	lw	a4,12(s4)
    80002af6:	0009079b          	sext.w	a5,s2
    80002afa:	fce7e3e3          	bltu	a5,a4,80002ac0 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002afe:	00006517          	auipc	a0,0x6
    80002b02:	a0250513          	add	a0,a0,-1534 # 80008500 <etext+0x500>
    80002b06:	00003097          	auipc	ra,0x3
    80002b0a:	286080e7          	jalr	646(ra) # 80005d8c <panic>
      memset(dip, 0, sizeof(*dip));
    80002b0e:	04000613          	li	a2,64
    80002b12:	4581                	li	a1,0
    80002b14:	854e                	mv	a0,s3
    80002b16:	ffffd097          	auipc	ra,0xffffd
    80002b1a:	6ae080e7          	jalr	1710(ra) # 800001c4 <memset>
      dip->type = type;
    80002b1e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b22:	8526                	mv	a0,s1
    80002b24:	00001097          	auipc	ra,0x1
    80002b28:	caa080e7          	jalr	-854(ra) # 800037ce <log_write>
      brelse(bp);
    80002b2c:	8526                	mv	a0,s1
    80002b2e:	00000097          	auipc	ra,0x0
    80002b32:	a2c080e7          	jalr	-1492(ra) # 8000255a <brelse>
      return iget(dev, inum);
    80002b36:	0009059b          	sext.w	a1,s2
    80002b3a:	8556                	mv	a0,s5
    80002b3c:	00000097          	auipc	ra,0x0
    80002b40:	db8080e7          	jalr	-584(ra) # 800028f4 <iget>
}
    80002b44:	70e2                	ld	ra,56(sp)
    80002b46:	7442                	ld	s0,48(sp)
    80002b48:	74a2                	ld	s1,40(sp)
    80002b4a:	7902                	ld	s2,32(sp)
    80002b4c:	69e2                	ld	s3,24(sp)
    80002b4e:	6a42                	ld	s4,16(sp)
    80002b50:	6aa2                	ld	s5,8(sp)
    80002b52:	6b02                	ld	s6,0(sp)
    80002b54:	6121                	add	sp,sp,64
    80002b56:	8082                	ret

0000000080002b58 <iupdate>:
{
    80002b58:	1101                	add	sp,sp,-32
    80002b5a:	ec06                	sd	ra,24(sp)
    80002b5c:	e822                	sd	s0,16(sp)
    80002b5e:	e426                	sd	s1,8(sp)
    80002b60:	e04a                	sd	s2,0(sp)
    80002b62:	1000                	add	s0,sp,32
    80002b64:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b66:	415c                	lw	a5,4(a0)
    80002b68:	0047d79b          	srlw	a5,a5,0x4
    80002b6c:	00015597          	auipc	a1,0x15
    80002b70:	c045a583          	lw	a1,-1020(a1) # 80017770 <sb+0x18>
    80002b74:	9dbd                	addw	a1,a1,a5
    80002b76:	4108                	lw	a0,0(a0)
    80002b78:	00000097          	auipc	ra,0x0
    80002b7c:	8b2080e7          	jalr	-1870(ra) # 8000242a <bread>
    80002b80:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b82:	05850793          	add	a5,a0,88
    80002b86:	40d8                	lw	a4,4(s1)
    80002b88:	8b3d                	and	a4,a4,15
    80002b8a:	071a                	sll	a4,a4,0x6
    80002b8c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b8e:	04449703          	lh	a4,68(s1)
    80002b92:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b96:	04649703          	lh	a4,70(s1)
    80002b9a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b9e:	04849703          	lh	a4,72(s1)
    80002ba2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002ba6:	04a49703          	lh	a4,74(s1)
    80002baa:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002bae:	44f8                	lw	a4,76(s1)
    80002bb0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bb2:	03400613          	li	a2,52
    80002bb6:	05048593          	add	a1,s1,80
    80002bba:	00c78513          	add	a0,a5,12
    80002bbe:	ffffd097          	auipc	ra,0xffffd
    80002bc2:	662080e7          	jalr	1634(ra) # 80000220 <memmove>
  log_write(bp);
    80002bc6:	854a                	mv	a0,s2
    80002bc8:	00001097          	auipc	ra,0x1
    80002bcc:	c06080e7          	jalr	-1018(ra) # 800037ce <log_write>
  brelse(bp);
    80002bd0:	854a                	mv	a0,s2
    80002bd2:	00000097          	auipc	ra,0x0
    80002bd6:	988080e7          	jalr	-1656(ra) # 8000255a <brelse>
}
    80002bda:	60e2                	ld	ra,24(sp)
    80002bdc:	6442                	ld	s0,16(sp)
    80002bde:	64a2                	ld	s1,8(sp)
    80002be0:	6902                	ld	s2,0(sp)
    80002be2:	6105                	add	sp,sp,32
    80002be4:	8082                	ret

0000000080002be6 <idup>:
{
    80002be6:	1101                	add	sp,sp,-32
    80002be8:	ec06                	sd	ra,24(sp)
    80002bea:	e822                	sd	s0,16(sp)
    80002bec:	e426                	sd	s1,8(sp)
    80002bee:	1000                	add	s0,sp,32
    80002bf0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bf2:	00015517          	auipc	a0,0x15
    80002bf6:	b8650513          	add	a0,a0,-1146 # 80017778 <itable>
    80002bfa:	00003097          	auipc	ra,0x3
    80002bfe:	70c080e7          	jalr	1804(ra) # 80006306 <acquire>
  ip->ref++;
    80002c02:	449c                	lw	a5,8(s1)
    80002c04:	2785                	addw	a5,a5,1
    80002c06:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c08:	00015517          	auipc	a0,0x15
    80002c0c:	b7050513          	add	a0,a0,-1168 # 80017778 <itable>
    80002c10:	00003097          	auipc	ra,0x3
    80002c14:	7aa080e7          	jalr	1962(ra) # 800063ba <release>
}
    80002c18:	8526                	mv	a0,s1
    80002c1a:	60e2                	ld	ra,24(sp)
    80002c1c:	6442                	ld	s0,16(sp)
    80002c1e:	64a2                	ld	s1,8(sp)
    80002c20:	6105                	add	sp,sp,32
    80002c22:	8082                	ret

0000000080002c24 <ilock>:
{
    80002c24:	1101                	add	sp,sp,-32
    80002c26:	ec06                	sd	ra,24(sp)
    80002c28:	e822                	sd	s0,16(sp)
    80002c2a:	e426                	sd	s1,8(sp)
    80002c2c:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c2e:	c10d                	beqz	a0,80002c50 <ilock+0x2c>
    80002c30:	84aa                	mv	s1,a0
    80002c32:	451c                	lw	a5,8(a0)
    80002c34:	00f05e63          	blez	a5,80002c50 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002c38:	0541                	add	a0,a0,16
    80002c3a:	00001097          	auipc	ra,0x1
    80002c3e:	cb2080e7          	jalr	-846(ra) # 800038ec <acquiresleep>
  if(ip->valid == 0){
    80002c42:	40bc                	lw	a5,64(s1)
    80002c44:	cf99                	beqz	a5,80002c62 <ilock+0x3e>
}
    80002c46:	60e2                	ld	ra,24(sp)
    80002c48:	6442                	ld	s0,16(sp)
    80002c4a:	64a2                	ld	s1,8(sp)
    80002c4c:	6105                	add	sp,sp,32
    80002c4e:	8082                	ret
    80002c50:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002c52:	00006517          	auipc	a0,0x6
    80002c56:	8c650513          	add	a0,a0,-1850 # 80008518 <etext+0x518>
    80002c5a:	00003097          	auipc	ra,0x3
    80002c5e:	132080e7          	jalr	306(ra) # 80005d8c <panic>
    80002c62:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c64:	40dc                	lw	a5,4(s1)
    80002c66:	0047d79b          	srlw	a5,a5,0x4
    80002c6a:	00015597          	auipc	a1,0x15
    80002c6e:	b065a583          	lw	a1,-1274(a1) # 80017770 <sb+0x18>
    80002c72:	9dbd                	addw	a1,a1,a5
    80002c74:	4088                	lw	a0,0(s1)
    80002c76:	fffff097          	auipc	ra,0xfffff
    80002c7a:	7b4080e7          	jalr	1972(ra) # 8000242a <bread>
    80002c7e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c80:	05850593          	add	a1,a0,88
    80002c84:	40dc                	lw	a5,4(s1)
    80002c86:	8bbd                	and	a5,a5,15
    80002c88:	079a                	sll	a5,a5,0x6
    80002c8a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c8c:	00059783          	lh	a5,0(a1)
    80002c90:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c94:	00259783          	lh	a5,2(a1)
    80002c98:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c9c:	00459783          	lh	a5,4(a1)
    80002ca0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ca4:	00659783          	lh	a5,6(a1)
    80002ca8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cac:	459c                	lw	a5,8(a1)
    80002cae:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cb0:	03400613          	li	a2,52
    80002cb4:	05b1                	add	a1,a1,12
    80002cb6:	05048513          	add	a0,s1,80
    80002cba:	ffffd097          	auipc	ra,0xffffd
    80002cbe:	566080e7          	jalr	1382(ra) # 80000220 <memmove>
    brelse(bp);
    80002cc2:	854a                	mv	a0,s2
    80002cc4:	00000097          	auipc	ra,0x0
    80002cc8:	896080e7          	jalr	-1898(ra) # 8000255a <brelse>
    ip->valid = 1;
    80002ccc:	4785                	li	a5,1
    80002cce:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cd0:	04449783          	lh	a5,68(s1)
    80002cd4:	c399                	beqz	a5,80002cda <ilock+0xb6>
    80002cd6:	6902                	ld	s2,0(sp)
    80002cd8:	b7bd                	j	80002c46 <ilock+0x22>
      panic("ilock: no type");
    80002cda:	00006517          	auipc	a0,0x6
    80002cde:	84650513          	add	a0,a0,-1978 # 80008520 <etext+0x520>
    80002ce2:	00003097          	auipc	ra,0x3
    80002ce6:	0aa080e7          	jalr	170(ra) # 80005d8c <panic>

0000000080002cea <iunlock>:
{
    80002cea:	1101                	add	sp,sp,-32
    80002cec:	ec06                	sd	ra,24(sp)
    80002cee:	e822                	sd	s0,16(sp)
    80002cf0:	e426                	sd	s1,8(sp)
    80002cf2:	e04a                	sd	s2,0(sp)
    80002cf4:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cf6:	c905                	beqz	a0,80002d26 <iunlock+0x3c>
    80002cf8:	84aa                	mv	s1,a0
    80002cfa:	01050913          	add	s2,a0,16
    80002cfe:	854a                	mv	a0,s2
    80002d00:	00001097          	auipc	ra,0x1
    80002d04:	c86080e7          	jalr	-890(ra) # 80003986 <holdingsleep>
    80002d08:	cd19                	beqz	a0,80002d26 <iunlock+0x3c>
    80002d0a:	449c                	lw	a5,8(s1)
    80002d0c:	00f05d63          	blez	a5,80002d26 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d10:	854a                	mv	a0,s2
    80002d12:	00001097          	auipc	ra,0x1
    80002d16:	c30080e7          	jalr	-976(ra) # 80003942 <releasesleep>
}
    80002d1a:	60e2                	ld	ra,24(sp)
    80002d1c:	6442                	ld	s0,16(sp)
    80002d1e:	64a2                	ld	s1,8(sp)
    80002d20:	6902                	ld	s2,0(sp)
    80002d22:	6105                	add	sp,sp,32
    80002d24:	8082                	ret
    panic("iunlock");
    80002d26:	00006517          	auipc	a0,0x6
    80002d2a:	80a50513          	add	a0,a0,-2038 # 80008530 <etext+0x530>
    80002d2e:	00003097          	auipc	ra,0x3
    80002d32:	05e080e7          	jalr	94(ra) # 80005d8c <panic>

0000000080002d36 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d36:	7179                	add	sp,sp,-48
    80002d38:	f406                	sd	ra,40(sp)
    80002d3a:	f022                	sd	s0,32(sp)
    80002d3c:	ec26                	sd	s1,24(sp)
    80002d3e:	e84a                	sd	s2,16(sp)
    80002d40:	e44e                	sd	s3,8(sp)
    80002d42:	1800                	add	s0,sp,48
    80002d44:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d46:	05050493          	add	s1,a0,80
    80002d4a:	08050913          	add	s2,a0,128
    80002d4e:	a021                	j	80002d56 <itrunc+0x20>
    80002d50:	0491                	add	s1,s1,4
    80002d52:	01248d63          	beq	s1,s2,80002d6c <itrunc+0x36>
    if(ip->addrs[i]){
    80002d56:	408c                	lw	a1,0(s1)
    80002d58:	dde5                	beqz	a1,80002d50 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002d5a:	0009a503          	lw	a0,0(s3)
    80002d5e:	00000097          	auipc	ra,0x0
    80002d62:	910080e7          	jalr	-1776(ra) # 8000266e <bfree>
      ip->addrs[i] = 0;
    80002d66:	0004a023          	sw	zero,0(s1)
    80002d6a:	b7dd                	j	80002d50 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d6c:	0809a583          	lw	a1,128(s3)
    80002d70:	ed99                	bnez	a1,80002d8e <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d72:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d76:	854e                	mv	a0,s3
    80002d78:	00000097          	auipc	ra,0x0
    80002d7c:	de0080e7          	jalr	-544(ra) # 80002b58 <iupdate>
}
    80002d80:	70a2                	ld	ra,40(sp)
    80002d82:	7402                	ld	s0,32(sp)
    80002d84:	64e2                	ld	s1,24(sp)
    80002d86:	6942                	ld	s2,16(sp)
    80002d88:	69a2                	ld	s3,8(sp)
    80002d8a:	6145                	add	sp,sp,48
    80002d8c:	8082                	ret
    80002d8e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d90:	0009a503          	lw	a0,0(s3)
    80002d94:	fffff097          	auipc	ra,0xfffff
    80002d98:	696080e7          	jalr	1686(ra) # 8000242a <bread>
    80002d9c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d9e:	05850493          	add	s1,a0,88
    80002da2:	45850913          	add	s2,a0,1112
    80002da6:	a021                	j	80002dae <itrunc+0x78>
    80002da8:	0491                	add	s1,s1,4
    80002daa:	01248b63          	beq	s1,s2,80002dc0 <itrunc+0x8a>
      if(a[j])
    80002dae:	408c                	lw	a1,0(s1)
    80002db0:	dde5                	beqz	a1,80002da8 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002db2:	0009a503          	lw	a0,0(s3)
    80002db6:	00000097          	auipc	ra,0x0
    80002dba:	8b8080e7          	jalr	-1864(ra) # 8000266e <bfree>
    80002dbe:	b7ed                	j	80002da8 <itrunc+0x72>
    brelse(bp);
    80002dc0:	8552                	mv	a0,s4
    80002dc2:	fffff097          	auipc	ra,0xfffff
    80002dc6:	798080e7          	jalr	1944(ra) # 8000255a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dca:	0809a583          	lw	a1,128(s3)
    80002dce:	0009a503          	lw	a0,0(s3)
    80002dd2:	00000097          	auipc	ra,0x0
    80002dd6:	89c080e7          	jalr	-1892(ra) # 8000266e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dda:	0809a023          	sw	zero,128(s3)
    80002dde:	6a02                	ld	s4,0(sp)
    80002de0:	bf49                	j	80002d72 <itrunc+0x3c>

0000000080002de2 <iput>:
{
    80002de2:	1101                	add	sp,sp,-32
    80002de4:	ec06                	sd	ra,24(sp)
    80002de6:	e822                	sd	s0,16(sp)
    80002de8:	e426                	sd	s1,8(sp)
    80002dea:	1000                	add	s0,sp,32
    80002dec:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dee:	00015517          	auipc	a0,0x15
    80002df2:	98a50513          	add	a0,a0,-1654 # 80017778 <itable>
    80002df6:	00003097          	auipc	ra,0x3
    80002dfa:	510080e7          	jalr	1296(ra) # 80006306 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dfe:	4498                	lw	a4,8(s1)
    80002e00:	4785                	li	a5,1
    80002e02:	02f70263          	beq	a4,a5,80002e26 <iput+0x44>
  ip->ref--;
    80002e06:	449c                	lw	a5,8(s1)
    80002e08:	37fd                	addw	a5,a5,-1
    80002e0a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e0c:	00015517          	auipc	a0,0x15
    80002e10:	96c50513          	add	a0,a0,-1684 # 80017778 <itable>
    80002e14:	00003097          	auipc	ra,0x3
    80002e18:	5a6080e7          	jalr	1446(ra) # 800063ba <release>
}
    80002e1c:	60e2                	ld	ra,24(sp)
    80002e1e:	6442                	ld	s0,16(sp)
    80002e20:	64a2                	ld	s1,8(sp)
    80002e22:	6105                	add	sp,sp,32
    80002e24:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e26:	40bc                	lw	a5,64(s1)
    80002e28:	dff9                	beqz	a5,80002e06 <iput+0x24>
    80002e2a:	04a49783          	lh	a5,74(s1)
    80002e2e:	ffe1                	bnez	a5,80002e06 <iput+0x24>
    80002e30:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e32:	01048913          	add	s2,s1,16
    80002e36:	854a                	mv	a0,s2
    80002e38:	00001097          	auipc	ra,0x1
    80002e3c:	ab4080e7          	jalr	-1356(ra) # 800038ec <acquiresleep>
    release(&itable.lock);
    80002e40:	00015517          	auipc	a0,0x15
    80002e44:	93850513          	add	a0,a0,-1736 # 80017778 <itable>
    80002e48:	00003097          	auipc	ra,0x3
    80002e4c:	572080e7          	jalr	1394(ra) # 800063ba <release>
    itrunc(ip);
    80002e50:	8526                	mv	a0,s1
    80002e52:	00000097          	auipc	ra,0x0
    80002e56:	ee4080e7          	jalr	-284(ra) # 80002d36 <itrunc>
    ip->type = 0;
    80002e5a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e5e:	8526                	mv	a0,s1
    80002e60:	00000097          	auipc	ra,0x0
    80002e64:	cf8080e7          	jalr	-776(ra) # 80002b58 <iupdate>
    ip->valid = 0;
    80002e68:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e6c:	854a                	mv	a0,s2
    80002e6e:	00001097          	auipc	ra,0x1
    80002e72:	ad4080e7          	jalr	-1324(ra) # 80003942 <releasesleep>
    acquire(&itable.lock);
    80002e76:	00015517          	auipc	a0,0x15
    80002e7a:	90250513          	add	a0,a0,-1790 # 80017778 <itable>
    80002e7e:	00003097          	auipc	ra,0x3
    80002e82:	488080e7          	jalr	1160(ra) # 80006306 <acquire>
    80002e86:	6902                	ld	s2,0(sp)
    80002e88:	bfbd                	j	80002e06 <iput+0x24>

0000000080002e8a <iunlockput>:
{
    80002e8a:	1101                	add	sp,sp,-32
    80002e8c:	ec06                	sd	ra,24(sp)
    80002e8e:	e822                	sd	s0,16(sp)
    80002e90:	e426                	sd	s1,8(sp)
    80002e92:	1000                	add	s0,sp,32
    80002e94:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e96:	00000097          	auipc	ra,0x0
    80002e9a:	e54080e7          	jalr	-428(ra) # 80002cea <iunlock>
  iput(ip);
    80002e9e:	8526                	mv	a0,s1
    80002ea0:	00000097          	auipc	ra,0x0
    80002ea4:	f42080e7          	jalr	-190(ra) # 80002de2 <iput>
}
    80002ea8:	60e2                	ld	ra,24(sp)
    80002eaa:	6442                	ld	s0,16(sp)
    80002eac:	64a2                	ld	s1,8(sp)
    80002eae:	6105                	add	sp,sp,32
    80002eb0:	8082                	ret

0000000080002eb2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002eb2:	1141                	add	sp,sp,-16
    80002eb4:	e422                	sd	s0,8(sp)
    80002eb6:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80002eb8:	411c                	lw	a5,0(a0)
    80002eba:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ebc:	415c                	lw	a5,4(a0)
    80002ebe:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ec0:	04451783          	lh	a5,68(a0)
    80002ec4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ec8:	04a51783          	lh	a5,74(a0)
    80002ecc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ed0:	04c56783          	lwu	a5,76(a0)
    80002ed4:	e99c                	sd	a5,16(a1)
}
    80002ed6:	6422                	ld	s0,8(sp)
    80002ed8:	0141                	add	sp,sp,16
    80002eda:	8082                	ret

0000000080002edc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002edc:	457c                	lw	a5,76(a0)
    80002ede:	0ed7ef63          	bltu	a5,a3,80002fdc <readi+0x100>
{
    80002ee2:	7159                	add	sp,sp,-112
    80002ee4:	f486                	sd	ra,104(sp)
    80002ee6:	f0a2                	sd	s0,96(sp)
    80002ee8:	eca6                	sd	s1,88(sp)
    80002eea:	fc56                	sd	s5,56(sp)
    80002eec:	f85a                	sd	s6,48(sp)
    80002eee:	f45e                	sd	s7,40(sp)
    80002ef0:	f062                	sd	s8,32(sp)
    80002ef2:	1880                	add	s0,sp,112
    80002ef4:	8baa                	mv	s7,a0
    80002ef6:	8c2e                	mv	s8,a1
    80002ef8:	8ab2                	mv	s5,a2
    80002efa:	84b6                	mv	s1,a3
    80002efc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002efe:	9f35                	addw	a4,a4,a3
    return 0;
    80002f00:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f02:	0ad76c63          	bltu	a4,a3,80002fba <readi+0xde>
    80002f06:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002f08:	00e7f463          	bgeu	a5,a4,80002f10 <readi+0x34>
    n = ip->size - off;
    80002f0c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f10:	0c0b0463          	beqz	s6,80002fd8 <readi+0xfc>
    80002f14:	e8ca                	sd	s2,80(sp)
    80002f16:	e0d2                	sd	s4,64(sp)
    80002f18:	ec66                	sd	s9,24(sp)
    80002f1a:	e86a                	sd	s10,16(sp)
    80002f1c:	e46e                	sd	s11,8(sp)
    80002f1e:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f20:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f24:	5cfd                	li	s9,-1
    80002f26:	a82d                	j	80002f60 <readi+0x84>
    80002f28:	020a1d93          	sll	s11,s4,0x20
    80002f2c:	020ddd93          	srl	s11,s11,0x20
    80002f30:	05890613          	add	a2,s2,88
    80002f34:	86ee                	mv	a3,s11
    80002f36:	963a                	add	a2,a2,a4
    80002f38:	85d6                	mv	a1,s5
    80002f3a:	8562                	mv	a0,s8
    80002f3c:	fffff097          	auipc	ra,0xfffff
    80002f40:	9fc080e7          	jalr	-1540(ra) # 80001938 <either_copyout>
    80002f44:	05950d63          	beq	a0,s9,80002f9e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f48:	854a                	mv	a0,s2
    80002f4a:	fffff097          	auipc	ra,0xfffff
    80002f4e:	610080e7          	jalr	1552(ra) # 8000255a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f52:	013a09bb          	addw	s3,s4,s3
    80002f56:	009a04bb          	addw	s1,s4,s1
    80002f5a:	9aee                	add	s5,s5,s11
    80002f5c:	0769f863          	bgeu	s3,s6,80002fcc <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f60:	000ba903          	lw	s2,0(s7)
    80002f64:	00a4d59b          	srlw	a1,s1,0xa
    80002f68:	855e                	mv	a0,s7
    80002f6a:	00000097          	auipc	ra,0x0
    80002f6e:	8ae080e7          	jalr	-1874(ra) # 80002818 <bmap>
    80002f72:	0005059b          	sext.w	a1,a0
    80002f76:	854a                	mv	a0,s2
    80002f78:	fffff097          	auipc	ra,0xfffff
    80002f7c:	4b2080e7          	jalr	1202(ra) # 8000242a <bread>
    80002f80:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f82:	3ff4f713          	and	a4,s1,1023
    80002f86:	40ed07bb          	subw	a5,s10,a4
    80002f8a:	413b06bb          	subw	a3,s6,s3
    80002f8e:	8a3e                	mv	s4,a5
    80002f90:	2781                	sext.w	a5,a5
    80002f92:	0006861b          	sext.w	a2,a3
    80002f96:	f8f679e3          	bgeu	a2,a5,80002f28 <readi+0x4c>
    80002f9a:	8a36                	mv	s4,a3
    80002f9c:	b771                	j	80002f28 <readi+0x4c>
      brelse(bp);
    80002f9e:	854a                	mv	a0,s2
    80002fa0:	fffff097          	auipc	ra,0xfffff
    80002fa4:	5ba080e7          	jalr	1466(ra) # 8000255a <brelse>
      tot = -1;
    80002fa8:	59fd                	li	s3,-1
      break;
    80002faa:	6946                	ld	s2,80(sp)
    80002fac:	6a06                	ld	s4,64(sp)
    80002fae:	6ce2                	ld	s9,24(sp)
    80002fb0:	6d42                	ld	s10,16(sp)
    80002fb2:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002fb4:	0009851b          	sext.w	a0,s3
    80002fb8:	69a6                	ld	s3,72(sp)
}
    80002fba:	70a6                	ld	ra,104(sp)
    80002fbc:	7406                	ld	s0,96(sp)
    80002fbe:	64e6                	ld	s1,88(sp)
    80002fc0:	7ae2                	ld	s5,56(sp)
    80002fc2:	7b42                	ld	s6,48(sp)
    80002fc4:	7ba2                	ld	s7,40(sp)
    80002fc6:	7c02                	ld	s8,32(sp)
    80002fc8:	6165                	add	sp,sp,112
    80002fca:	8082                	ret
    80002fcc:	6946                	ld	s2,80(sp)
    80002fce:	6a06                	ld	s4,64(sp)
    80002fd0:	6ce2                	ld	s9,24(sp)
    80002fd2:	6d42                	ld	s10,16(sp)
    80002fd4:	6da2                	ld	s11,8(sp)
    80002fd6:	bff9                	j	80002fb4 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fd8:	89da                	mv	s3,s6
    80002fda:	bfe9                	j	80002fb4 <readi+0xd8>
    return 0;
    80002fdc:	4501                	li	a0,0
}
    80002fde:	8082                	ret

0000000080002fe0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fe0:	457c                	lw	a5,76(a0)
    80002fe2:	10d7ee63          	bltu	a5,a3,800030fe <writei+0x11e>
{
    80002fe6:	7159                	add	sp,sp,-112
    80002fe8:	f486                	sd	ra,104(sp)
    80002fea:	f0a2                	sd	s0,96(sp)
    80002fec:	e8ca                	sd	s2,80(sp)
    80002fee:	fc56                	sd	s5,56(sp)
    80002ff0:	f85a                	sd	s6,48(sp)
    80002ff2:	f45e                	sd	s7,40(sp)
    80002ff4:	f062                	sd	s8,32(sp)
    80002ff6:	1880                	add	s0,sp,112
    80002ff8:	8b2a                	mv	s6,a0
    80002ffa:	8c2e                	mv	s8,a1
    80002ffc:	8ab2                	mv	s5,a2
    80002ffe:	8936                	mv	s2,a3
    80003000:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003002:	00e687bb          	addw	a5,a3,a4
    80003006:	0ed7ee63          	bltu	a5,a3,80003102 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000300a:	00043737          	lui	a4,0x43
    8000300e:	0ef76c63          	bltu	a4,a5,80003106 <writei+0x126>
    80003012:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003014:	0c0b8d63          	beqz	s7,800030ee <writei+0x10e>
    80003018:	eca6                	sd	s1,88(sp)
    8000301a:	e4ce                	sd	s3,72(sp)
    8000301c:	ec66                	sd	s9,24(sp)
    8000301e:	e86a                	sd	s10,16(sp)
    80003020:	e46e                	sd	s11,8(sp)
    80003022:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003024:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003028:	5cfd                	li	s9,-1
    8000302a:	a091                	j	8000306e <writei+0x8e>
    8000302c:	02099d93          	sll	s11,s3,0x20
    80003030:	020ddd93          	srl	s11,s11,0x20
    80003034:	05848513          	add	a0,s1,88
    80003038:	86ee                	mv	a3,s11
    8000303a:	8656                	mv	a2,s5
    8000303c:	85e2                	mv	a1,s8
    8000303e:	953a                	add	a0,a0,a4
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	94e080e7          	jalr	-1714(ra) # 8000198e <either_copyin>
    80003048:	07950263          	beq	a0,s9,800030ac <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000304c:	8526                	mv	a0,s1
    8000304e:	00000097          	auipc	ra,0x0
    80003052:	780080e7          	jalr	1920(ra) # 800037ce <log_write>
    brelse(bp);
    80003056:	8526                	mv	a0,s1
    80003058:	fffff097          	auipc	ra,0xfffff
    8000305c:	502080e7          	jalr	1282(ra) # 8000255a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003060:	01498a3b          	addw	s4,s3,s4
    80003064:	0129893b          	addw	s2,s3,s2
    80003068:	9aee                	add	s5,s5,s11
    8000306a:	057a7663          	bgeu	s4,s7,800030b6 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000306e:	000b2483          	lw	s1,0(s6)
    80003072:	00a9559b          	srlw	a1,s2,0xa
    80003076:	855a                	mv	a0,s6
    80003078:	fffff097          	auipc	ra,0xfffff
    8000307c:	7a0080e7          	jalr	1952(ra) # 80002818 <bmap>
    80003080:	0005059b          	sext.w	a1,a0
    80003084:	8526                	mv	a0,s1
    80003086:	fffff097          	auipc	ra,0xfffff
    8000308a:	3a4080e7          	jalr	932(ra) # 8000242a <bread>
    8000308e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003090:	3ff97713          	and	a4,s2,1023
    80003094:	40ed07bb          	subw	a5,s10,a4
    80003098:	414b86bb          	subw	a3,s7,s4
    8000309c:	89be                	mv	s3,a5
    8000309e:	2781                	sext.w	a5,a5
    800030a0:	0006861b          	sext.w	a2,a3
    800030a4:	f8f674e3          	bgeu	a2,a5,8000302c <writei+0x4c>
    800030a8:	89b6                	mv	s3,a3
    800030aa:	b749                	j	8000302c <writei+0x4c>
      brelse(bp);
    800030ac:	8526                	mv	a0,s1
    800030ae:	fffff097          	auipc	ra,0xfffff
    800030b2:	4ac080e7          	jalr	1196(ra) # 8000255a <brelse>
  }

  if(off > ip->size)
    800030b6:	04cb2783          	lw	a5,76(s6)
    800030ba:	0327fc63          	bgeu	a5,s2,800030f2 <writei+0x112>
    ip->size = off;
    800030be:	052b2623          	sw	s2,76(s6)
    800030c2:	64e6                	ld	s1,88(sp)
    800030c4:	69a6                	ld	s3,72(sp)
    800030c6:	6ce2                	ld	s9,24(sp)
    800030c8:	6d42                	ld	s10,16(sp)
    800030ca:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030cc:	855a                	mv	a0,s6
    800030ce:	00000097          	auipc	ra,0x0
    800030d2:	a8a080e7          	jalr	-1398(ra) # 80002b58 <iupdate>

  return tot;
    800030d6:	000a051b          	sext.w	a0,s4
    800030da:	6a06                	ld	s4,64(sp)
}
    800030dc:	70a6                	ld	ra,104(sp)
    800030de:	7406                	ld	s0,96(sp)
    800030e0:	6946                	ld	s2,80(sp)
    800030e2:	7ae2                	ld	s5,56(sp)
    800030e4:	7b42                	ld	s6,48(sp)
    800030e6:	7ba2                	ld	s7,40(sp)
    800030e8:	7c02                	ld	s8,32(sp)
    800030ea:	6165                	add	sp,sp,112
    800030ec:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ee:	8a5e                	mv	s4,s7
    800030f0:	bff1                	j	800030cc <writei+0xec>
    800030f2:	64e6                	ld	s1,88(sp)
    800030f4:	69a6                	ld	s3,72(sp)
    800030f6:	6ce2                	ld	s9,24(sp)
    800030f8:	6d42                	ld	s10,16(sp)
    800030fa:	6da2                	ld	s11,8(sp)
    800030fc:	bfc1                	j	800030cc <writei+0xec>
    return -1;
    800030fe:	557d                	li	a0,-1
}
    80003100:	8082                	ret
    return -1;
    80003102:	557d                	li	a0,-1
    80003104:	bfe1                	j	800030dc <writei+0xfc>
    return -1;
    80003106:	557d                	li	a0,-1
    80003108:	bfd1                	j	800030dc <writei+0xfc>

000000008000310a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000310a:	1141                	add	sp,sp,-16
    8000310c:	e406                	sd	ra,8(sp)
    8000310e:	e022                	sd	s0,0(sp)
    80003110:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003112:	4639                	li	a2,14
    80003114:	ffffd097          	auipc	ra,0xffffd
    80003118:	180080e7          	jalr	384(ra) # 80000294 <strncmp>
}
    8000311c:	60a2                	ld	ra,8(sp)
    8000311e:	6402                	ld	s0,0(sp)
    80003120:	0141                	add	sp,sp,16
    80003122:	8082                	ret

0000000080003124 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003124:	7139                	add	sp,sp,-64
    80003126:	fc06                	sd	ra,56(sp)
    80003128:	f822                	sd	s0,48(sp)
    8000312a:	f426                	sd	s1,40(sp)
    8000312c:	f04a                	sd	s2,32(sp)
    8000312e:	ec4e                	sd	s3,24(sp)
    80003130:	e852                	sd	s4,16(sp)
    80003132:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003134:	04451703          	lh	a4,68(a0)
    80003138:	4785                	li	a5,1
    8000313a:	00f71a63          	bne	a4,a5,8000314e <dirlookup+0x2a>
    8000313e:	892a                	mv	s2,a0
    80003140:	89ae                	mv	s3,a1
    80003142:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003144:	457c                	lw	a5,76(a0)
    80003146:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003148:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000314a:	e79d                	bnez	a5,80003178 <dirlookup+0x54>
    8000314c:	a8a5                	j	800031c4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000314e:	00005517          	auipc	a0,0x5
    80003152:	3ea50513          	add	a0,a0,1002 # 80008538 <etext+0x538>
    80003156:	00003097          	auipc	ra,0x3
    8000315a:	c36080e7          	jalr	-970(ra) # 80005d8c <panic>
      panic("dirlookup read");
    8000315e:	00005517          	auipc	a0,0x5
    80003162:	3f250513          	add	a0,a0,1010 # 80008550 <etext+0x550>
    80003166:	00003097          	auipc	ra,0x3
    8000316a:	c26080e7          	jalr	-986(ra) # 80005d8c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000316e:	24c1                	addw	s1,s1,16
    80003170:	04c92783          	lw	a5,76(s2)
    80003174:	04f4f763          	bgeu	s1,a5,800031c2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003178:	4741                	li	a4,16
    8000317a:	86a6                	mv	a3,s1
    8000317c:	fc040613          	add	a2,s0,-64
    80003180:	4581                	li	a1,0
    80003182:	854a                	mv	a0,s2
    80003184:	00000097          	auipc	ra,0x0
    80003188:	d58080e7          	jalr	-680(ra) # 80002edc <readi>
    8000318c:	47c1                	li	a5,16
    8000318e:	fcf518e3          	bne	a0,a5,8000315e <dirlookup+0x3a>
    if(de.inum == 0)
    80003192:	fc045783          	lhu	a5,-64(s0)
    80003196:	dfe1                	beqz	a5,8000316e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003198:	fc240593          	add	a1,s0,-62
    8000319c:	854e                	mv	a0,s3
    8000319e:	00000097          	auipc	ra,0x0
    800031a2:	f6c080e7          	jalr	-148(ra) # 8000310a <namecmp>
    800031a6:	f561                	bnez	a0,8000316e <dirlookup+0x4a>
      if(poff)
    800031a8:	000a0463          	beqz	s4,800031b0 <dirlookup+0x8c>
        *poff = off;
    800031ac:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031b0:	fc045583          	lhu	a1,-64(s0)
    800031b4:	00092503          	lw	a0,0(s2)
    800031b8:	fffff097          	auipc	ra,0xfffff
    800031bc:	73c080e7          	jalr	1852(ra) # 800028f4 <iget>
    800031c0:	a011                	j	800031c4 <dirlookup+0xa0>
  return 0;
    800031c2:	4501                	li	a0,0
}
    800031c4:	70e2                	ld	ra,56(sp)
    800031c6:	7442                	ld	s0,48(sp)
    800031c8:	74a2                	ld	s1,40(sp)
    800031ca:	7902                	ld	s2,32(sp)
    800031cc:	69e2                	ld	s3,24(sp)
    800031ce:	6a42                	ld	s4,16(sp)
    800031d0:	6121                	add	sp,sp,64
    800031d2:	8082                	ret

00000000800031d4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031d4:	711d                	add	sp,sp,-96
    800031d6:	ec86                	sd	ra,88(sp)
    800031d8:	e8a2                	sd	s0,80(sp)
    800031da:	e4a6                	sd	s1,72(sp)
    800031dc:	e0ca                	sd	s2,64(sp)
    800031de:	fc4e                	sd	s3,56(sp)
    800031e0:	f852                	sd	s4,48(sp)
    800031e2:	f456                	sd	s5,40(sp)
    800031e4:	f05a                	sd	s6,32(sp)
    800031e6:	ec5e                	sd	s7,24(sp)
    800031e8:	e862                	sd	s8,16(sp)
    800031ea:	e466                	sd	s9,8(sp)
    800031ec:	1080                	add	s0,sp,96
    800031ee:	84aa                	mv	s1,a0
    800031f0:	8b2e                	mv	s6,a1
    800031f2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031f4:	00054703          	lbu	a4,0(a0)
    800031f8:	02f00793          	li	a5,47
    800031fc:	02f70263          	beq	a4,a5,80003220 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003200:	ffffe097          	auipc	ra,0xffffe
    80003204:	cc6080e7          	jalr	-826(ra) # 80000ec6 <myproc>
    80003208:	15053503          	ld	a0,336(a0)
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	9da080e7          	jalr	-1574(ra) # 80002be6 <idup>
    80003214:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003216:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000321a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000321c:	4b85                	li	s7,1
    8000321e:	a875                	j	800032da <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003220:	4585                	li	a1,1
    80003222:	4505                	li	a0,1
    80003224:	fffff097          	auipc	ra,0xfffff
    80003228:	6d0080e7          	jalr	1744(ra) # 800028f4 <iget>
    8000322c:	8a2a                	mv	s4,a0
    8000322e:	b7e5                	j	80003216 <namex+0x42>
      iunlockput(ip);
    80003230:	8552                	mv	a0,s4
    80003232:	00000097          	auipc	ra,0x0
    80003236:	c58080e7          	jalr	-936(ra) # 80002e8a <iunlockput>
      return 0;
    8000323a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000323c:	8552                	mv	a0,s4
    8000323e:	60e6                	ld	ra,88(sp)
    80003240:	6446                	ld	s0,80(sp)
    80003242:	64a6                	ld	s1,72(sp)
    80003244:	6906                	ld	s2,64(sp)
    80003246:	79e2                	ld	s3,56(sp)
    80003248:	7a42                	ld	s4,48(sp)
    8000324a:	7aa2                	ld	s5,40(sp)
    8000324c:	7b02                	ld	s6,32(sp)
    8000324e:	6be2                	ld	s7,24(sp)
    80003250:	6c42                	ld	s8,16(sp)
    80003252:	6ca2                	ld	s9,8(sp)
    80003254:	6125                	add	sp,sp,96
    80003256:	8082                	ret
      iunlock(ip);
    80003258:	8552                	mv	a0,s4
    8000325a:	00000097          	auipc	ra,0x0
    8000325e:	a90080e7          	jalr	-1392(ra) # 80002cea <iunlock>
      return ip;
    80003262:	bfe9                	j	8000323c <namex+0x68>
      iunlockput(ip);
    80003264:	8552                	mv	a0,s4
    80003266:	00000097          	auipc	ra,0x0
    8000326a:	c24080e7          	jalr	-988(ra) # 80002e8a <iunlockput>
      return 0;
    8000326e:	8a4e                	mv	s4,s3
    80003270:	b7f1                	j	8000323c <namex+0x68>
  len = path - s;
    80003272:	40998633          	sub	a2,s3,s1
    80003276:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000327a:	099c5863          	bge	s8,s9,8000330a <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000327e:	4639                	li	a2,14
    80003280:	85a6                	mv	a1,s1
    80003282:	8556                	mv	a0,s5
    80003284:	ffffd097          	auipc	ra,0xffffd
    80003288:	f9c080e7          	jalr	-100(ra) # 80000220 <memmove>
    8000328c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000328e:	0004c783          	lbu	a5,0(s1)
    80003292:	01279763          	bne	a5,s2,800032a0 <namex+0xcc>
    path++;
    80003296:	0485                	add	s1,s1,1
  while(*path == '/')
    80003298:	0004c783          	lbu	a5,0(s1)
    8000329c:	ff278de3          	beq	a5,s2,80003296 <namex+0xc2>
    ilock(ip);
    800032a0:	8552                	mv	a0,s4
    800032a2:	00000097          	auipc	ra,0x0
    800032a6:	982080e7          	jalr	-1662(ra) # 80002c24 <ilock>
    if(ip->type != T_DIR){
    800032aa:	044a1783          	lh	a5,68(s4)
    800032ae:	f97791e3          	bne	a5,s7,80003230 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800032b2:	000b0563          	beqz	s6,800032bc <namex+0xe8>
    800032b6:	0004c783          	lbu	a5,0(s1)
    800032ba:	dfd9                	beqz	a5,80003258 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032bc:	4601                	li	a2,0
    800032be:	85d6                	mv	a1,s5
    800032c0:	8552                	mv	a0,s4
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	e62080e7          	jalr	-414(ra) # 80003124 <dirlookup>
    800032ca:	89aa                	mv	s3,a0
    800032cc:	dd41                	beqz	a0,80003264 <namex+0x90>
    iunlockput(ip);
    800032ce:	8552                	mv	a0,s4
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	bba080e7          	jalr	-1094(ra) # 80002e8a <iunlockput>
    ip = next;
    800032d8:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032da:	0004c783          	lbu	a5,0(s1)
    800032de:	01279763          	bne	a5,s2,800032ec <namex+0x118>
    path++;
    800032e2:	0485                	add	s1,s1,1
  while(*path == '/')
    800032e4:	0004c783          	lbu	a5,0(s1)
    800032e8:	ff278de3          	beq	a5,s2,800032e2 <namex+0x10e>
  if(*path == 0)
    800032ec:	cb9d                	beqz	a5,80003322 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032ee:	0004c783          	lbu	a5,0(s1)
    800032f2:	89a6                	mv	s3,s1
  len = path - s;
    800032f4:	4c81                	li	s9,0
    800032f6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032f8:	01278963          	beq	a5,s2,8000330a <namex+0x136>
    800032fc:	dbbd                	beqz	a5,80003272 <namex+0x9e>
    path++;
    800032fe:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003300:	0009c783          	lbu	a5,0(s3)
    80003304:	ff279ce3          	bne	a5,s2,800032fc <namex+0x128>
    80003308:	b7ad                	j	80003272 <namex+0x9e>
    memmove(name, s, len);
    8000330a:	2601                	sext.w	a2,a2
    8000330c:	85a6                	mv	a1,s1
    8000330e:	8556                	mv	a0,s5
    80003310:	ffffd097          	auipc	ra,0xffffd
    80003314:	f10080e7          	jalr	-240(ra) # 80000220 <memmove>
    name[len] = 0;
    80003318:	9cd6                	add	s9,s9,s5
    8000331a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000331e:	84ce                	mv	s1,s3
    80003320:	b7bd                	j	8000328e <namex+0xba>
  if(nameiparent){
    80003322:	f00b0de3          	beqz	s6,8000323c <namex+0x68>
    iput(ip);
    80003326:	8552                	mv	a0,s4
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	aba080e7          	jalr	-1350(ra) # 80002de2 <iput>
    return 0;
    80003330:	4a01                	li	s4,0
    80003332:	b729                	j	8000323c <namex+0x68>

0000000080003334 <dirlink>:
{
    80003334:	7139                	add	sp,sp,-64
    80003336:	fc06                	sd	ra,56(sp)
    80003338:	f822                	sd	s0,48(sp)
    8000333a:	f04a                	sd	s2,32(sp)
    8000333c:	ec4e                	sd	s3,24(sp)
    8000333e:	e852                	sd	s4,16(sp)
    80003340:	0080                	add	s0,sp,64
    80003342:	892a                	mv	s2,a0
    80003344:	8a2e                	mv	s4,a1
    80003346:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003348:	4601                	li	a2,0
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	dda080e7          	jalr	-550(ra) # 80003124 <dirlookup>
    80003352:	ed25                	bnez	a0,800033ca <dirlink+0x96>
    80003354:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003356:	04c92483          	lw	s1,76(s2)
    8000335a:	c49d                	beqz	s1,80003388 <dirlink+0x54>
    8000335c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000335e:	4741                	li	a4,16
    80003360:	86a6                	mv	a3,s1
    80003362:	fc040613          	add	a2,s0,-64
    80003366:	4581                	li	a1,0
    80003368:	854a                	mv	a0,s2
    8000336a:	00000097          	auipc	ra,0x0
    8000336e:	b72080e7          	jalr	-1166(ra) # 80002edc <readi>
    80003372:	47c1                	li	a5,16
    80003374:	06f51163          	bne	a0,a5,800033d6 <dirlink+0xa2>
    if(de.inum == 0)
    80003378:	fc045783          	lhu	a5,-64(s0)
    8000337c:	c791                	beqz	a5,80003388 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000337e:	24c1                	addw	s1,s1,16
    80003380:	04c92783          	lw	a5,76(s2)
    80003384:	fcf4ede3          	bltu	s1,a5,8000335e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003388:	4639                	li	a2,14
    8000338a:	85d2                	mv	a1,s4
    8000338c:	fc240513          	add	a0,s0,-62
    80003390:	ffffd097          	auipc	ra,0xffffd
    80003394:	f3a080e7          	jalr	-198(ra) # 800002ca <strncpy>
  de.inum = inum;
    80003398:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000339c:	4741                	li	a4,16
    8000339e:	86a6                	mv	a3,s1
    800033a0:	fc040613          	add	a2,s0,-64
    800033a4:	4581                	li	a1,0
    800033a6:	854a                	mv	a0,s2
    800033a8:	00000097          	auipc	ra,0x0
    800033ac:	c38080e7          	jalr	-968(ra) # 80002fe0 <writei>
    800033b0:	872a                	mv	a4,a0
    800033b2:	47c1                	li	a5,16
  return 0;
    800033b4:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033b6:	02f71863          	bne	a4,a5,800033e6 <dirlink+0xb2>
    800033ba:	74a2                	ld	s1,40(sp)
}
    800033bc:	70e2                	ld	ra,56(sp)
    800033be:	7442                	ld	s0,48(sp)
    800033c0:	7902                	ld	s2,32(sp)
    800033c2:	69e2                	ld	s3,24(sp)
    800033c4:	6a42                	ld	s4,16(sp)
    800033c6:	6121                	add	sp,sp,64
    800033c8:	8082                	ret
    iput(ip);
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	a18080e7          	jalr	-1512(ra) # 80002de2 <iput>
    return -1;
    800033d2:	557d                	li	a0,-1
    800033d4:	b7e5                	j	800033bc <dirlink+0x88>
      panic("dirlink read");
    800033d6:	00005517          	auipc	a0,0x5
    800033da:	18a50513          	add	a0,a0,394 # 80008560 <etext+0x560>
    800033de:	00003097          	auipc	ra,0x3
    800033e2:	9ae080e7          	jalr	-1618(ra) # 80005d8c <panic>
    panic("dirlink");
    800033e6:	00005517          	auipc	a0,0x5
    800033ea:	28250513          	add	a0,a0,642 # 80008668 <etext+0x668>
    800033ee:	00003097          	auipc	ra,0x3
    800033f2:	99e080e7          	jalr	-1634(ra) # 80005d8c <panic>

00000000800033f6 <namei>:

struct inode*
namei(char *path)
{
    800033f6:	1101                	add	sp,sp,-32
    800033f8:	ec06                	sd	ra,24(sp)
    800033fa:	e822                	sd	s0,16(sp)
    800033fc:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033fe:	fe040613          	add	a2,s0,-32
    80003402:	4581                	li	a1,0
    80003404:	00000097          	auipc	ra,0x0
    80003408:	dd0080e7          	jalr	-560(ra) # 800031d4 <namex>
}
    8000340c:	60e2                	ld	ra,24(sp)
    8000340e:	6442                	ld	s0,16(sp)
    80003410:	6105                	add	sp,sp,32
    80003412:	8082                	ret

0000000080003414 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003414:	1141                	add	sp,sp,-16
    80003416:	e406                	sd	ra,8(sp)
    80003418:	e022                	sd	s0,0(sp)
    8000341a:	0800                	add	s0,sp,16
    8000341c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000341e:	4585                	li	a1,1
    80003420:	00000097          	auipc	ra,0x0
    80003424:	db4080e7          	jalr	-588(ra) # 800031d4 <namex>
}
    80003428:	60a2                	ld	ra,8(sp)
    8000342a:	6402                	ld	s0,0(sp)
    8000342c:	0141                	add	sp,sp,16
    8000342e:	8082                	ret

0000000080003430 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003430:	1101                	add	sp,sp,-32
    80003432:	ec06                	sd	ra,24(sp)
    80003434:	e822                	sd	s0,16(sp)
    80003436:	e426                	sd	s1,8(sp)
    80003438:	e04a                	sd	s2,0(sp)
    8000343a:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000343c:	00016917          	auipc	s2,0x16
    80003440:	de490913          	add	s2,s2,-540 # 80019220 <log>
    80003444:	01892583          	lw	a1,24(s2)
    80003448:	02892503          	lw	a0,40(s2)
    8000344c:	fffff097          	auipc	ra,0xfffff
    80003450:	fde080e7          	jalr	-34(ra) # 8000242a <bread>
    80003454:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003456:	02c92603          	lw	a2,44(s2)
    8000345a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000345c:	00c05f63          	blez	a2,8000347a <write_head+0x4a>
    80003460:	00016717          	auipc	a4,0x16
    80003464:	df070713          	add	a4,a4,-528 # 80019250 <log+0x30>
    80003468:	87aa                	mv	a5,a0
    8000346a:	060a                	sll	a2,a2,0x2
    8000346c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000346e:	4314                	lw	a3,0(a4)
    80003470:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003472:	0711                	add	a4,a4,4
    80003474:	0791                	add	a5,a5,4
    80003476:	fec79ce3          	bne	a5,a2,8000346e <write_head+0x3e>
  }
  bwrite(buf);
    8000347a:	8526                	mv	a0,s1
    8000347c:	fffff097          	auipc	ra,0xfffff
    80003480:	0a0080e7          	jalr	160(ra) # 8000251c <bwrite>
  brelse(buf);
    80003484:	8526                	mv	a0,s1
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	0d4080e7          	jalr	212(ra) # 8000255a <brelse>
}
    8000348e:	60e2                	ld	ra,24(sp)
    80003490:	6442                	ld	s0,16(sp)
    80003492:	64a2                	ld	s1,8(sp)
    80003494:	6902                	ld	s2,0(sp)
    80003496:	6105                	add	sp,sp,32
    80003498:	8082                	ret

000000008000349a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000349a:	00016797          	auipc	a5,0x16
    8000349e:	db27a783          	lw	a5,-590(a5) # 8001924c <log+0x2c>
    800034a2:	0af05d63          	blez	a5,8000355c <install_trans+0xc2>
{
    800034a6:	7139                	add	sp,sp,-64
    800034a8:	fc06                	sd	ra,56(sp)
    800034aa:	f822                	sd	s0,48(sp)
    800034ac:	f426                	sd	s1,40(sp)
    800034ae:	f04a                	sd	s2,32(sp)
    800034b0:	ec4e                	sd	s3,24(sp)
    800034b2:	e852                	sd	s4,16(sp)
    800034b4:	e456                	sd	s5,8(sp)
    800034b6:	e05a                	sd	s6,0(sp)
    800034b8:	0080                	add	s0,sp,64
    800034ba:	8b2a                	mv	s6,a0
    800034bc:	00016a97          	auipc	s5,0x16
    800034c0:	d94a8a93          	add	s5,s5,-620 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034c4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034c6:	00016997          	auipc	s3,0x16
    800034ca:	d5a98993          	add	s3,s3,-678 # 80019220 <log>
    800034ce:	a00d                	j	800034f0 <install_trans+0x56>
    brelse(lbuf);
    800034d0:	854a                	mv	a0,s2
    800034d2:	fffff097          	auipc	ra,0xfffff
    800034d6:	088080e7          	jalr	136(ra) # 8000255a <brelse>
    brelse(dbuf);
    800034da:	8526                	mv	a0,s1
    800034dc:	fffff097          	auipc	ra,0xfffff
    800034e0:	07e080e7          	jalr	126(ra) # 8000255a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034e4:	2a05                	addw	s4,s4,1
    800034e6:	0a91                	add	s5,s5,4
    800034e8:	02c9a783          	lw	a5,44(s3)
    800034ec:	04fa5e63          	bge	s4,a5,80003548 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034f0:	0189a583          	lw	a1,24(s3)
    800034f4:	014585bb          	addw	a1,a1,s4
    800034f8:	2585                	addw	a1,a1,1
    800034fa:	0289a503          	lw	a0,40(s3)
    800034fe:	fffff097          	auipc	ra,0xfffff
    80003502:	f2c080e7          	jalr	-212(ra) # 8000242a <bread>
    80003506:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003508:	000aa583          	lw	a1,0(s5)
    8000350c:	0289a503          	lw	a0,40(s3)
    80003510:	fffff097          	auipc	ra,0xfffff
    80003514:	f1a080e7          	jalr	-230(ra) # 8000242a <bread>
    80003518:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000351a:	40000613          	li	a2,1024
    8000351e:	05890593          	add	a1,s2,88
    80003522:	05850513          	add	a0,a0,88
    80003526:	ffffd097          	auipc	ra,0xffffd
    8000352a:	cfa080e7          	jalr	-774(ra) # 80000220 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000352e:	8526                	mv	a0,s1
    80003530:	fffff097          	auipc	ra,0xfffff
    80003534:	fec080e7          	jalr	-20(ra) # 8000251c <bwrite>
    if(recovering == 0)
    80003538:	f80b1ce3          	bnez	s6,800034d0 <install_trans+0x36>
      bunpin(dbuf);
    8000353c:	8526                	mv	a0,s1
    8000353e:	fffff097          	auipc	ra,0xfffff
    80003542:	0f4080e7          	jalr	244(ra) # 80002632 <bunpin>
    80003546:	b769                	j	800034d0 <install_trans+0x36>
}
    80003548:	70e2                	ld	ra,56(sp)
    8000354a:	7442                	ld	s0,48(sp)
    8000354c:	74a2                	ld	s1,40(sp)
    8000354e:	7902                	ld	s2,32(sp)
    80003550:	69e2                	ld	s3,24(sp)
    80003552:	6a42                	ld	s4,16(sp)
    80003554:	6aa2                	ld	s5,8(sp)
    80003556:	6b02                	ld	s6,0(sp)
    80003558:	6121                	add	sp,sp,64
    8000355a:	8082                	ret
    8000355c:	8082                	ret

000000008000355e <initlog>:
{
    8000355e:	7179                	add	sp,sp,-48
    80003560:	f406                	sd	ra,40(sp)
    80003562:	f022                	sd	s0,32(sp)
    80003564:	ec26                	sd	s1,24(sp)
    80003566:	e84a                	sd	s2,16(sp)
    80003568:	e44e                	sd	s3,8(sp)
    8000356a:	1800                	add	s0,sp,48
    8000356c:	892a                	mv	s2,a0
    8000356e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003570:	00016497          	auipc	s1,0x16
    80003574:	cb048493          	add	s1,s1,-848 # 80019220 <log>
    80003578:	00005597          	auipc	a1,0x5
    8000357c:	ff858593          	add	a1,a1,-8 # 80008570 <etext+0x570>
    80003580:	8526                	mv	a0,s1
    80003582:	00003097          	auipc	ra,0x3
    80003586:	cf4080e7          	jalr	-780(ra) # 80006276 <initlock>
  log.start = sb->logstart;
    8000358a:	0149a583          	lw	a1,20(s3)
    8000358e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003590:	0109a783          	lw	a5,16(s3)
    80003594:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003596:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000359a:	854a                	mv	a0,s2
    8000359c:	fffff097          	auipc	ra,0xfffff
    800035a0:	e8e080e7          	jalr	-370(ra) # 8000242a <bread>
  log.lh.n = lh->n;
    800035a4:	4d30                	lw	a2,88(a0)
    800035a6:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035a8:	00c05f63          	blez	a2,800035c6 <initlog+0x68>
    800035ac:	87aa                	mv	a5,a0
    800035ae:	00016717          	auipc	a4,0x16
    800035b2:	ca270713          	add	a4,a4,-862 # 80019250 <log+0x30>
    800035b6:	060a                	sll	a2,a2,0x2
    800035b8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800035ba:	4ff4                	lw	a3,92(a5)
    800035bc:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035be:	0791                	add	a5,a5,4
    800035c0:	0711                	add	a4,a4,4
    800035c2:	fec79ce3          	bne	a5,a2,800035ba <initlog+0x5c>
  brelse(buf);
    800035c6:	fffff097          	auipc	ra,0xfffff
    800035ca:	f94080e7          	jalr	-108(ra) # 8000255a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035ce:	4505                	li	a0,1
    800035d0:	00000097          	auipc	ra,0x0
    800035d4:	eca080e7          	jalr	-310(ra) # 8000349a <install_trans>
  log.lh.n = 0;
    800035d8:	00016797          	auipc	a5,0x16
    800035dc:	c607aa23          	sw	zero,-908(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800035e0:	00000097          	auipc	ra,0x0
    800035e4:	e50080e7          	jalr	-432(ra) # 80003430 <write_head>
}
    800035e8:	70a2                	ld	ra,40(sp)
    800035ea:	7402                	ld	s0,32(sp)
    800035ec:	64e2                	ld	s1,24(sp)
    800035ee:	6942                	ld	s2,16(sp)
    800035f0:	69a2                	ld	s3,8(sp)
    800035f2:	6145                	add	sp,sp,48
    800035f4:	8082                	ret

00000000800035f6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035f6:	1101                	add	sp,sp,-32
    800035f8:	ec06                	sd	ra,24(sp)
    800035fa:	e822                	sd	s0,16(sp)
    800035fc:	e426                	sd	s1,8(sp)
    800035fe:	e04a                	sd	s2,0(sp)
    80003600:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003602:	00016517          	auipc	a0,0x16
    80003606:	c1e50513          	add	a0,a0,-994 # 80019220 <log>
    8000360a:	00003097          	auipc	ra,0x3
    8000360e:	cfc080e7          	jalr	-772(ra) # 80006306 <acquire>
  while(1){
    if(log.committing){
    80003612:	00016497          	auipc	s1,0x16
    80003616:	c0e48493          	add	s1,s1,-1010 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000361a:	4979                	li	s2,30
    8000361c:	a039                	j	8000362a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000361e:	85a6                	mv	a1,s1
    80003620:	8526                	mv	a0,s1
    80003622:	ffffe097          	auipc	ra,0xffffe
    80003626:	f72080e7          	jalr	-142(ra) # 80001594 <sleep>
    if(log.committing){
    8000362a:	50dc                	lw	a5,36(s1)
    8000362c:	fbed                	bnez	a5,8000361e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000362e:	5098                	lw	a4,32(s1)
    80003630:	2705                	addw	a4,a4,1
    80003632:	0027179b          	sllw	a5,a4,0x2
    80003636:	9fb9                	addw	a5,a5,a4
    80003638:	0017979b          	sllw	a5,a5,0x1
    8000363c:	54d4                	lw	a3,44(s1)
    8000363e:	9fb5                	addw	a5,a5,a3
    80003640:	00f95963          	bge	s2,a5,80003652 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003644:	85a6                	mv	a1,s1
    80003646:	8526                	mv	a0,s1
    80003648:	ffffe097          	auipc	ra,0xffffe
    8000364c:	f4c080e7          	jalr	-180(ra) # 80001594 <sleep>
    80003650:	bfe9                	j	8000362a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003652:	00016517          	auipc	a0,0x16
    80003656:	bce50513          	add	a0,a0,-1074 # 80019220 <log>
    8000365a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	d5e080e7          	jalr	-674(ra) # 800063ba <release>
      break;
    }
  }
}
    80003664:	60e2                	ld	ra,24(sp)
    80003666:	6442                	ld	s0,16(sp)
    80003668:	64a2                	ld	s1,8(sp)
    8000366a:	6902                	ld	s2,0(sp)
    8000366c:	6105                	add	sp,sp,32
    8000366e:	8082                	ret

0000000080003670 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003670:	7139                	add	sp,sp,-64
    80003672:	fc06                	sd	ra,56(sp)
    80003674:	f822                	sd	s0,48(sp)
    80003676:	f426                	sd	s1,40(sp)
    80003678:	f04a                	sd	s2,32(sp)
    8000367a:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000367c:	00016497          	auipc	s1,0x16
    80003680:	ba448493          	add	s1,s1,-1116 # 80019220 <log>
    80003684:	8526                	mv	a0,s1
    80003686:	00003097          	auipc	ra,0x3
    8000368a:	c80080e7          	jalr	-896(ra) # 80006306 <acquire>
  log.outstanding -= 1;
    8000368e:	509c                	lw	a5,32(s1)
    80003690:	37fd                	addw	a5,a5,-1
    80003692:	0007891b          	sext.w	s2,a5
    80003696:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003698:	50dc                	lw	a5,36(s1)
    8000369a:	e7b9                	bnez	a5,800036e8 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000369c:	06091163          	bnez	s2,800036fe <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036a0:	00016497          	auipc	s1,0x16
    800036a4:	b8048493          	add	s1,s1,-1152 # 80019220 <log>
    800036a8:	4785                	li	a5,1
    800036aa:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036ac:	8526                	mv	a0,s1
    800036ae:	00003097          	auipc	ra,0x3
    800036b2:	d0c080e7          	jalr	-756(ra) # 800063ba <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036b6:	54dc                	lw	a5,44(s1)
    800036b8:	06f04763          	bgtz	a5,80003726 <end_op+0xb6>
    acquire(&log.lock);
    800036bc:	00016497          	auipc	s1,0x16
    800036c0:	b6448493          	add	s1,s1,-1180 # 80019220 <log>
    800036c4:	8526                	mv	a0,s1
    800036c6:	00003097          	auipc	ra,0x3
    800036ca:	c40080e7          	jalr	-960(ra) # 80006306 <acquire>
    log.committing = 0;
    800036ce:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036d2:	8526                	mv	a0,s1
    800036d4:	ffffe097          	auipc	ra,0xffffe
    800036d8:	04c080e7          	jalr	76(ra) # 80001720 <wakeup>
    release(&log.lock);
    800036dc:	8526                	mv	a0,s1
    800036de:	00003097          	auipc	ra,0x3
    800036e2:	cdc080e7          	jalr	-804(ra) # 800063ba <release>
}
    800036e6:	a815                	j	8000371a <end_op+0xaa>
    800036e8:	ec4e                	sd	s3,24(sp)
    800036ea:	e852                	sd	s4,16(sp)
    800036ec:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800036ee:	00005517          	auipc	a0,0x5
    800036f2:	e8a50513          	add	a0,a0,-374 # 80008578 <etext+0x578>
    800036f6:	00002097          	auipc	ra,0x2
    800036fa:	696080e7          	jalr	1686(ra) # 80005d8c <panic>
    wakeup(&log);
    800036fe:	00016497          	auipc	s1,0x16
    80003702:	b2248493          	add	s1,s1,-1246 # 80019220 <log>
    80003706:	8526                	mv	a0,s1
    80003708:	ffffe097          	auipc	ra,0xffffe
    8000370c:	018080e7          	jalr	24(ra) # 80001720 <wakeup>
  release(&log.lock);
    80003710:	8526                	mv	a0,s1
    80003712:	00003097          	auipc	ra,0x3
    80003716:	ca8080e7          	jalr	-856(ra) # 800063ba <release>
}
    8000371a:	70e2                	ld	ra,56(sp)
    8000371c:	7442                	ld	s0,48(sp)
    8000371e:	74a2                	ld	s1,40(sp)
    80003720:	7902                	ld	s2,32(sp)
    80003722:	6121                	add	sp,sp,64
    80003724:	8082                	ret
    80003726:	ec4e                	sd	s3,24(sp)
    80003728:	e852                	sd	s4,16(sp)
    8000372a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000372c:	00016a97          	auipc	s5,0x16
    80003730:	b24a8a93          	add	s5,s5,-1244 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003734:	00016a17          	auipc	s4,0x16
    80003738:	aeca0a13          	add	s4,s4,-1300 # 80019220 <log>
    8000373c:	018a2583          	lw	a1,24(s4)
    80003740:	012585bb          	addw	a1,a1,s2
    80003744:	2585                	addw	a1,a1,1
    80003746:	028a2503          	lw	a0,40(s4)
    8000374a:	fffff097          	auipc	ra,0xfffff
    8000374e:	ce0080e7          	jalr	-800(ra) # 8000242a <bread>
    80003752:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003754:	000aa583          	lw	a1,0(s5)
    80003758:	028a2503          	lw	a0,40(s4)
    8000375c:	fffff097          	auipc	ra,0xfffff
    80003760:	cce080e7          	jalr	-818(ra) # 8000242a <bread>
    80003764:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003766:	40000613          	li	a2,1024
    8000376a:	05850593          	add	a1,a0,88
    8000376e:	05848513          	add	a0,s1,88
    80003772:	ffffd097          	auipc	ra,0xffffd
    80003776:	aae080e7          	jalr	-1362(ra) # 80000220 <memmove>
    bwrite(to);  // write the log
    8000377a:	8526                	mv	a0,s1
    8000377c:	fffff097          	auipc	ra,0xfffff
    80003780:	da0080e7          	jalr	-608(ra) # 8000251c <bwrite>
    brelse(from);
    80003784:	854e                	mv	a0,s3
    80003786:	fffff097          	auipc	ra,0xfffff
    8000378a:	dd4080e7          	jalr	-556(ra) # 8000255a <brelse>
    brelse(to);
    8000378e:	8526                	mv	a0,s1
    80003790:	fffff097          	auipc	ra,0xfffff
    80003794:	dca080e7          	jalr	-566(ra) # 8000255a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003798:	2905                	addw	s2,s2,1
    8000379a:	0a91                	add	s5,s5,4
    8000379c:	02ca2783          	lw	a5,44(s4)
    800037a0:	f8f94ee3          	blt	s2,a5,8000373c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037a4:	00000097          	auipc	ra,0x0
    800037a8:	c8c080e7          	jalr	-884(ra) # 80003430 <write_head>
    install_trans(0); // Now install writes to home locations
    800037ac:	4501                	li	a0,0
    800037ae:	00000097          	auipc	ra,0x0
    800037b2:	cec080e7          	jalr	-788(ra) # 8000349a <install_trans>
    log.lh.n = 0;
    800037b6:	00016797          	auipc	a5,0x16
    800037ba:	a807ab23          	sw	zero,-1386(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037be:	00000097          	auipc	ra,0x0
    800037c2:	c72080e7          	jalr	-910(ra) # 80003430 <write_head>
    800037c6:	69e2                	ld	s3,24(sp)
    800037c8:	6a42                	ld	s4,16(sp)
    800037ca:	6aa2                	ld	s5,8(sp)
    800037cc:	bdc5                	j	800036bc <end_op+0x4c>

00000000800037ce <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037ce:	1101                	add	sp,sp,-32
    800037d0:	ec06                	sd	ra,24(sp)
    800037d2:	e822                	sd	s0,16(sp)
    800037d4:	e426                	sd	s1,8(sp)
    800037d6:	e04a                	sd	s2,0(sp)
    800037d8:	1000                	add	s0,sp,32
    800037da:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037dc:	00016917          	auipc	s2,0x16
    800037e0:	a4490913          	add	s2,s2,-1468 # 80019220 <log>
    800037e4:	854a                	mv	a0,s2
    800037e6:	00003097          	auipc	ra,0x3
    800037ea:	b20080e7          	jalr	-1248(ra) # 80006306 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037ee:	02c92603          	lw	a2,44(s2)
    800037f2:	47f5                	li	a5,29
    800037f4:	06c7c563          	blt	a5,a2,8000385e <log_write+0x90>
    800037f8:	00016797          	auipc	a5,0x16
    800037fc:	a447a783          	lw	a5,-1468(a5) # 8001923c <log+0x1c>
    80003800:	37fd                	addw	a5,a5,-1
    80003802:	04f65e63          	bge	a2,a5,8000385e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003806:	00016797          	auipc	a5,0x16
    8000380a:	a3a7a783          	lw	a5,-1478(a5) # 80019240 <log+0x20>
    8000380e:	06f05063          	blez	a5,8000386e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003812:	4781                	li	a5,0
    80003814:	06c05563          	blez	a2,8000387e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003818:	44cc                	lw	a1,12(s1)
    8000381a:	00016717          	auipc	a4,0x16
    8000381e:	a3670713          	add	a4,a4,-1482 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003822:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003824:	4314                	lw	a3,0(a4)
    80003826:	04b68c63          	beq	a3,a1,8000387e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000382a:	2785                	addw	a5,a5,1
    8000382c:	0711                	add	a4,a4,4
    8000382e:	fef61be3          	bne	a2,a5,80003824 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003832:	0621                	add	a2,a2,8
    80003834:	060a                	sll	a2,a2,0x2
    80003836:	00016797          	auipc	a5,0x16
    8000383a:	9ea78793          	add	a5,a5,-1558 # 80019220 <log>
    8000383e:	97b2                	add	a5,a5,a2
    80003840:	44d8                	lw	a4,12(s1)
    80003842:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003844:	8526                	mv	a0,s1
    80003846:	fffff097          	auipc	ra,0xfffff
    8000384a:	db0080e7          	jalr	-592(ra) # 800025f6 <bpin>
    log.lh.n++;
    8000384e:	00016717          	auipc	a4,0x16
    80003852:	9d270713          	add	a4,a4,-1582 # 80019220 <log>
    80003856:	575c                	lw	a5,44(a4)
    80003858:	2785                	addw	a5,a5,1
    8000385a:	d75c                	sw	a5,44(a4)
    8000385c:	a82d                	j	80003896 <log_write+0xc8>
    panic("too big a transaction");
    8000385e:	00005517          	auipc	a0,0x5
    80003862:	d2a50513          	add	a0,a0,-726 # 80008588 <etext+0x588>
    80003866:	00002097          	auipc	ra,0x2
    8000386a:	526080e7          	jalr	1318(ra) # 80005d8c <panic>
    panic("log_write outside of trans");
    8000386e:	00005517          	auipc	a0,0x5
    80003872:	d3250513          	add	a0,a0,-718 # 800085a0 <etext+0x5a0>
    80003876:	00002097          	auipc	ra,0x2
    8000387a:	516080e7          	jalr	1302(ra) # 80005d8c <panic>
  log.lh.block[i] = b->blockno;
    8000387e:	00878693          	add	a3,a5,8
    80003882:	068a                	sll	a3,a3,0x2
    80003884:	00016717          	auipc	a4,0x16
    80003888:	99c70713          	add	a4,a4,-1636 # 80019220 <log>
    8000388c:	9736                	add	a4,a4,a3
    8000388e:	44d4                	lw	a3,12(s1)
    80003890:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003892:	faf609e3          	beq	a2,a5,80003844 <log_write+0x76>
  }
  release(&log.lock);
    80003896:	00016517          	auipc	a0,0x16
    8000389a:	98a50513          	add	a0,a0,-1654 # 80019220 <log>
    8000389e:	00003097          	auipc	ra,0x3
    800038a2:	b1c080e7          	jalr	-1252(ra) # 800063ba <release>
}
    800038a6:	60e2                	ld	ra,24(sp)
    800038a8:	6442                	ld	s0,16(sp)
    800038aa:	64a2                	ld	s1,8(sp)
    800038ac:	6902                	ld	s2,0(sp)
    800038ae:	6105                	add	sp,sp,32
    800038b0:	8082                	ret

00000000800038b2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038b2:	1101                	add	sp,sp,-32
    800038b4:	ec06                	sd	ra,24(sp)
    800038b6:	e822                	sd	s0,16(sp)
    800038b8:	e426                	sd	s1,8(sp)
    800038ba:	e04a                	sd	s2,0(sp)
    800038bc:	1000                	add	s0,sp,32
    800038be:	84aa                	mv	s1,a0
    800038c0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038c2:	00005597          	auipc	a1,0x5
    800038c6:	cfe58593          	add	a1,a1,-770 # 800085c0 <etext+0x5c0>
    800038ca:	0521                	add	a0,a0,8
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	9aa080e7          	jalr	-1622(ra) # 80006276 <initlock>
  lk->name = name;
    800038d4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038d8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038dc:	0204a423          	sw	zero,40(s1)
}
    800038e0:	60e2                	ld	ra,24(sp)
    800038e2:	6442                	ld	s0,16(sp)
    800038e4:	64a2                	ld	s1,8(sp)
    800038e6:	6902                	ld	s2,0(sp)
    800038e8:	6105                	add	sp,sp,32
    800038ea:	8082                	ret

00000000800038ec <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038ec:	1101                	add	sp,sp,-32
    800038ee:	ec06                	sd	ra,24(sp)
    800038f0:	e822                	sd	s0,16(sp)
    800038f2:	e426                	sd	s1,8(sp)
    800038f4:	e04a                	sd	s2,0(sp)
    800038f6:	1000                	add	s0,sp,32
    800038f8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038fa:	00850913          	add	s2,a0,8
    800038fe:	854a                	mv	a0,s2
    80003900:	00003097          	auipc	ra,0x3
    80003904:	a06080e7          	jalr	-1530(ra) # 80006306 <acquire>
  while (lk->locked) {
    80003908:	409c                	lw	a5,0(s1)
    8000390a:	cb89                	beqz	a5,8000391c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000390c:	85ca                	mv	a1,s2
    8000390e:	8526                	mv	a0,s1
    80003910:	ffffe097          	auipc	ra,0xffffe
    80003914:	c84080e7          	jalr	-892(ra) # 80001594 <sleep>
  while (lk->locked) {
    80003918:	409c                	lw	a5,0(s1)
    8000391a:	fbed                	bnez	a5,8000390c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000391c:	4785                	li	a5,1
    8000391e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003920:	ffffd097          	auipc	ra,0xffffd
    80003924:	5a6080e7          	jalr	1446(ra) # 80000ec6 <myproc>
    80003928:	591c                	lw	a5,48(a0)
    8000392a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000392c:	854a                	mv	a0,s2
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	a8c080e7          	jalr	-1396(ra) # 800063ba <release>
}
    80003936:	60e2                	ld	ra,24(sp)
    80003938:	6442                	ld	s0,16(sp)
    8000393a:	64a2                	ld	s1,8(sp)
    8000393c:	6902                	ld	s2,0(sp)
    8000393e:	6105                	add	sp,sp,32
    80003940:	8082                	ret

0000000080003942 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003942:	1101                	add	sp,sp,-32
    80003944:	ec06                	sd	ra,24(sp)
    80003946:	e822                	sd	s0,16(sp)
    80003948:	e426                	sd	s1,8(sp)
    8000394a:	e04a                	sd	s2,0(sp)
    8000394c:	1000                	add	s0,sp,32
    8000394e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003950:	00850913          	add	s2,a0,8
    80003954:	854a                	mv	a0,s2
    80003956:	00003097          	auipc	ra,0x3
    8000395a:	9b0080e7          	jalr	-1616(ra) # 80006306 <acquire>
  lk->locked = 0;
    8000395e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003962:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003966:	8526                	mv	a0,s1
    80003968:	ffffe097          	auipc	ra,0xffffe
    8000396c:	db8080e7          	jalr	-584(ra) # 80001720 <wakeup>
  release(&lk->lk);
    80003970:	854a                	mv	a0,s2
    80003972:	00003097          	auipc	ra,0x3
    80003976:	a48080e7          	jalr	-1464(ra) # 800063ba <release>
}
    8000397a:	60e2                	ld	ra,24(sp)
    8000397c:	6442                	ld	s0,16(sp)
    8000397e:	64a2                	ld	s1,8(sp)
    80003980:	6902                	ld	s2,0(sp)
    80003982:	6105                	add	sp,sp,32
    80003984:	8082                	ret

0000000080003986 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003986:	7179                	add	sp,sp,-48
    80003988:	f406                	sd	ra,40(sp)
    8000398a:	f022                	sd	s0,32(sp)
    8000398c:	ec26                	sd	s1,24(sp)
    8000398e:	e84a                	sd	s2,16(sp)
    80003990:	1800                	add	s0,sp,48
    80003992:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003994:	00850913          	add	s2,a0,8
    80003998:	854a                	mv	a0,s2
    8000399a:	00003097          	auipc	ra,0x3
    8000399e:	96c080e7          	jalr	-1684(ra) # 80006306 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039a2:	409c                	lw	a5,0(s1)
    800039a4:	ef91                	bnez	a5,800039c0 <holdingsleep+0x3a>
    800039a6:	4481                	li	s1,0
  release(&lk->lk);
    800039a8:	854a                	mv	a0,s2
    800039aa:	00003097          	auipc	ra,0x3
    800039ae:	a10080e7          	jalr	-1520(ra) # 800063ba <release>
  return r;
}
    800039b2:	8526                	mv	a0,s1
    800039b4:	70a2                	ld	ra,40(sp)
    800039b6:	7402                	ld	s0,32(sp)
    800039b8:	64e2                	ld	s1,24(sp)
    800039ba:	6942                	ld	s2,16(sp)
    800039bc:	6145                	add	sp,sp,48
    800039be:	8082                	ret
    800039c0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800039c2:	0284a983          	lw	s3,40(s1)
    800039c6:	ffffd097          	auipc	ra,0xffffd
    800039ca:	500080e7          	jalr	1280(ra) # 80000ec6 <myproc>
    800039ce:	5904                	lw	s1,48(a0)
    800039d0:	413484b3          	sub	s1,s1,s3
    800039d4:	0014b493          	seqz	s1,s1
    800039d8:	69a2                	ld	s3,8(sp)
    800039da:	b7f9                	j	800039a8 <holdingsleep+0x22>

00000000800039dc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039dc:	1141                	add	sp,sp,-16
    800039de:	e406                	sd	ra,8(sp)
    800039e0:	e022                	sd	s0,0(sp)
    800039e2:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039e4:	00005597          	auipc	a1,0x5
    800039e8:	bec58593          	add	a1,a1,-1044 # 800085d0 <etext+0x5d0>
    800039ec:	00016517          	auipc	a0,0x16
    800039f0:	97c50513          	add	a0,a0,-1668 # 80019368 <ftable>
    800039f4:	00003097          	auipc	ra,0x3
    800039f8:	882080e7          	jalr	-1918(ra) # 80006276 <initlock>
}
    800039fc:	60a2                	ld	ra,8(sp)
    800039fe:	6402                	ld	s0,0(sp)
    80003a00:	0141                	add	sp,sp,16
    80003a02:	8082                	ret

0000000080003a04 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a04:	1101                	add	sp,sp,-32
    80003a06:	ec06                	sd	ra,24(sp)
    80003a08:	e822                	sd	s0,16(sp)
    80003a0a:	e426                	sd	s1,8(sp)
    80003a0c:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a0e:	00016517          	auipc	a0,0x16
    80003a12:	95a50513          	add	a0,a0,-1702 # 80019368 <ftable>
    80003a16:	00003097          	auipc	ra,0x3
    80003a1a:	8f0080e7          	jalr	-1808(ra) # 80006306 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a1e:	00016497          	auipc	s1,0x16
    80003a22:	96248493          	add	s1,s1,-1694 # 80019380 <ftable+0x18>
    80003a26:	00017717          	auipc	a4,0x17
    80003a2a:	8fa70713          	add	a4,a4,-1798 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003a2e:	40dc                	lw	a5,4(s1)
    80003a30:	cf99                	beqz	a5,80003a4e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a32:	02848493          	add	s1,s1,40
    80003a36:	fee49ce3          	bne	s1,a4,80003a2e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a3a:	00016517          	auipc	a0,0x16
    80003a3e:	92e50513          	add	a0,a0,-1746 # 80019368 <ftable>
    80003a42:	00003097          	auipc	ra,0x3
    80003a46:	978080e7          	jalr	-1672(ra) # 800063ba <release>
  return 0;
    80003a4a:	4481                	li	s1,0
    80003a4c:	a819                	j	80003a62 <filealloc+0x5e>
      f->ref = 1;
    80003a4e:	4785                	li	a5,1
    80003a50:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a52:	00016517          	auipc	a0,0x16
    80003a56:	91650513          	add	a0,a0,-1770 # 80019368 <ftable>
    80003a5a:	00003097          	auipc	ra,0x3
    80003a5e:	960080e7          	jalr	-1696(ra) # 800063ba <release>
}
    80003a62:	8526                	mv	a0,s1
    80003a64:	60e2                	ld	ra,24(sp)
    80003a66:	6442                	ld	s0,16(sp)
    80003a68:	64a2                	ld	s1,8(sp)
    80003a6a:	6105                	add	sp,sp,32
    80003a6c:	8082                	ret

0000000080003a6e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a6e:	1101                	add	sp,sp,-32
    80003a70:	ec06                	sd	ra,24(sp)
    80003a72:	e822                	sd	s0,16(sp)
    80003a74:	e426                	sd	s1,8(sp)
    80003a76:	1000                	add	s0,sp,32
    80003a78:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a7a:	00016517          	auipc	a0,0x16
    80003a7e:	8ee50513          	add	a0,a0,-1810 # 80019368 <ftable>
    80003a82:	00003097          	auipc	ra,0x3
    80003a86:	884080e7          	jalr	-1916(ra) # 80006306 <acquire>
  if(f->ref < 1)
    80003a8a:	40dc                	lw	a5,4(s1)
    80003a8c:	02f05263          	blez	a5,80003ab0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a90:	2785                	addw	a5,a5,1
    80003a92:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a94:	00016517          	auipc	a0,0x16
    80003a98:	8d450513          	add	a0,a0,-1836 # 80019368 <ftable>
    80003a9c:	00003097          	auipc	ra,0x3
    80003aa0:	91e080e7          	jalr	-1762(ra) # 800063ba <release>
  return f;
}
    80003aa4:	8526                	mv	a0,s1
    80003aa6:	60e2                	ld	ra,24(sp)
    80003aa8:	6442                	ld	s0,16(sp)
    80003aaa:	64a2                	ld	s1,8(sp)
    80003aac:	6105                	add	sp,sp,32
    80003aae:	8082                	ret
    panic("filedup");
    80003ab0:	00005517          	auipc	a0,0x5
    80003ab4:	b2850513          	add	a0,a0,-1240 # 800085d8 <etext+0x5d8>
    80003ab8:	00002097          	auipc	ra,0x2
    80003abc:	2d4080e7          	jalr	724(ra) # 80005d8c <panic>

0000000080003ac0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ac0:	7139                	add	sp,sp,-64
    80003ac2:	fc06                	sd	ra,56(sp)
    80003ac4:	f822                	sd	s0,48(sp)
    80003ac6:	f426                	sd	s1,40(sp)
    80003ac8:	0080                	add	s0,sp,64
    80003aca:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003acc:	00016517          	auipc	a0,0x16
    80003ad0:	89c50513          	add	a0,a0,-1892 # 80019368 <ftable>
    80003ad4:	00003097          	auipc	ra,0x3
    80003ad8:	832080e7          	jalr	-1998(ra) # 80006306 <acquire>
  if(f->ref < 1)
    80003adc:	40dc                	lw	a5,4(s1)
    80003ade:	04f05c63          	blez	a5,80003b36 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003ae2:	37fd                	addw	a5,a5,-1
    80003ae4:	0007871b          	sext.w	a4,a5
    80003ae8:	c0dc                	sw	a5,4(s1)
    80003aea:	06e04263          	bgtz	a4,80003b4e <fileclose+0x8e>
    80003aee:	f04a                	sd	s2,32(sp)
    80003af0:	ec4e                	sd	s3,24(sp)
    80003af2:	e852                	sd	s4,16(sp)
    80003af4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003af6:	0004a903          	lw	s2,0(s1)
    80003afa:	0094ca83          	lbu	s5,9(s1)
    80003afe:	0104ba03          	ld	s4,16(s1)
    80003b02:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b06:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b0a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b0e:	00016517          	auipc	a0,0x16
    80003b12:	85a50513          	add	a0,a0,-1958 # 80019368 <ftable>
    80003b16:	00003097          	auipc	ra,0x3
    80003b1a:	8a4080e7          	jalr	-1884(ra) # 800063ba <release>

  if(ff.type == FD_PIPE){
    80003b1e:	4785                	li	a5,1
    80003b20:	04f90463          	beq	s2,a5,80003b68 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b24:	3979                	addw	s2,s2,-2
    80003b26:	4785                	li	a5,1
    80003b28:	0527fb63          	bgeu	a5,s2,80003b7e <fileclose+0xbe>
    80003b2c:	7902                	ld	s2,32(sp)
    80003b2e:	69e2                	ld	s3,24(sp)
    80003b30:	6a42                	ld	s4,16(sp)
    80003b32:	6aa2                	ld	s5,8(sp)
    80003b34:	a02d                	j	80003b5e <fileclose+0x9e>
    80003b36:	f04a                	sd	s2,32(sp)
    80003b38:	ec4e                	sd	s3,24(sp)
    80003b3a:	e852                	sd	s4,16(sp)
    80003b3c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b3e:	00005517          	auipc	a0,0x5
    80003b42:	aa250513          	add	a0,a0,-1374 # 800085e0 <etext+0x5e0>
    80003b46:	00002097          	auipc	ra,0x2
    80003b4a:	246080e7          	jalr	582(ra) # 80005d8c <panic>
    release(&ftable.lock);
    80003b4e:	00016517          	auipc	a0,0x16
    80003b52:	81a50513          	add	a0,a0,-2022 # 80019368 <ftable>
    80003b56:	00003097          	auipc	ra,0x3
    80003b5a:	864080e7          	jalr	-1948(ra) # 800063ba <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b5e:	70e2                	ld	ra,56(sp)
    80003b60:	7442                	ld	s0,48(sp)
    80003b62:	74a2                	ld	s1,40(sp)
    80003b64:	6121                	add	sp,sp,64
    80003b66:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b68:	85d6                	mv	a1,s5
    80003b6a:	8552                	mv	a0,s4
    80003b6c:	00000097          	auipc	ra,0x0
    80003b70:	3a2080e7          	jalr	930(ra) # 80003f0e <pipeclose>
    80003b74:	7902                	ld	s2,32(sp)
    80003b76:	69e2                	ld	s3,24(sp)
    80003b78:	6a42                	ld	s4,16(sp)
    80003b7a:	6aa2                	ld	s5,8(sp)
    80003b7c:	b7cd                	j	80003b5e <fileclose+0x9e>
    begin_op();
    80003b7e:	00000097          	auipc	ra,0x0
    80003b82:	a78080e7          	jalr	-1416(ra) # 800035f6 <begin_op>
    iput(ff.ip);
    80003b86:	854e                	mv	a0,s3
    80003b88:	fffff097          	auipc	ra,0xfffff
    80003b8c:	25a080e7          	jalr	602(ra) # 80002de2 <iput>
    end_op();
    80003b90:	00000097          	auipc	ra,0x0
    80003b94:	ae0080e7          	jalr	-1312(ra) # 80003670 <end_op>
    80003b98:	7902                	ld	s2,32(sp)
    80003b9a:	69e2                	ld	s3,24(sp)
    80003b9c:	6a42                	ld	s4,16(sp)
    80003b9e:	6aa2                	ld	s5,8(sp)
    80003ba0:	bf7d                	j	80003b5e <fileclose+0x9e>

0000000080003ba2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ba2:	715d                	add	sp,sp,-80
    80003ba4:	e486                	sd	ra,72(sp)
    80003ba6:	e0a2                	sd	s0,64(sp)
    80003ba8:	fc26                	sd	s1,56(sp)
    80003baa:	f44e                	sd	s3,40(sp)
    80003bac:	0880                	add	s0,sp,80
    80003bae:	84aa                	mv	s1,a0
    80003bb0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bb2:	ffffd097          	auipc	ra,0xffffd
    80003bb6:	314080e7          	jalr	788(ra) # 80000ec6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bba:	409c                	lw	a5,0(s1)
    80003bbc:	37f9                	addw	a5,a5,-2
    80003bbe:	4705                	li	a4,1
    80003bc0:	04f76863          	bltu	a4,a5,80003c10 <filestat+0x6e>
    80003bc4:	f84a                	sd	s2,48(sp)
    80003bc6:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bc8:	6c88                	ld	a0,24(s1)
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	05a080e7          	jalr	90(ra) # 80002c24 <ilock>
    stati(f->ip, &st);
    80003bd2:	fb840593          	add	a1,s0,-72
    80003bd6:	6c88                	ld	a0,24(s1)
    80003bd8:	fffff097          	auipc	ra,0xfffff
    80003bdc:	2da080e7          	jalr	730(ra) # 80002eb2 <stati>
    iunlock(f->ip);
    80003be0:	6c88                	ld	a0,24(s1)
    80003be2:	fffff097          	auipc	ra,0xfffff
    80003be6:	108080e7          	jalr	264(ra) # 80002cea <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bea:	46e1                	li	a3,24
    80003bec:	fb840613          	add	a2,s0,-72
    80003bf0:	85ce                	mv	a1,s3
    80003bf2:	05093503          	ld	a0,80(s2)
    80003bf6:	ffffd097          	auipc	ra,0xffffd
    80003bfa:	f6c080e7          	jalr	-148(ra) # 80000b62 <copyout>
    80003bfe:	41f5551b          	sraw	a0,a0,0x1f
    80003c02:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003c04:	60a6                	ld	ra,72(sp)
    80003c06:	6406                	ld	s0,64(sp)
    80003c08:	74e2                	ld	s1,56(sp)
    80003c0a:	79a2                	ld	s3,40(sp)
    80003c0c:	6161                	add	sp,sp,80
    80003c0e:	8082                	ret
  return -1;
    80003c10:	557d                	li	a0,-1
    80003c12:	bfcd                	j	80003c04 <filestat+0x62>

0000000080003c14 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c14:	7179                	add	sp,sp,-48
    80003c16:	f406                	sd	ra,40(sp)
    80003c18:	f022                	sd	s0,32(sp)
    80003c1a:	e84a                	sd	s2,16(sp)
    80003c1c:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c1e:	00854783          	lbu	a5,8(a0)
    80003c22:	cbc5                	beqz	a5,80003cd2 <fileread+0xbe>
    80003c24:	ec26                	sd	s1,24(sp)
    80003c26:	e44e                	sd	s3,8(sp)
    80003c28:	84aa                	mv	s1,a0
    80003c2a:	89ae                	mv	s3,a1
    80003c2c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c2e:	411c                	lw	a5,0(a0)
    80003c30:	4705                	li	a4,1
    80003c32:	04e78963          	beq	a5,a4,80003c84 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c36:	470d                	li	a4,3
    80003c38:	04e78f63          	beq	a5,a4,80003c96 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c3c:	4709                	li	a4,2
    80003c3e:	08e79263          	bne	a5,a4,80003cc2 <fileread+0xae>
    ilock(f->ip);
    80003c42:	6d08                	ld	a0,24(a0)
    80003c44:	fffff097          	auipc	ra,0xfffff
    80003c48:	fe0080e7          	jalr	-32(ra) # 80002c24 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c4c:	874a                	mv	a4,s2
    80003c4e:	5094                	lw	a3,32(s1)
    80003c50:	864e                	mv	a2,s3
    80003c52:	4585                	li	a1,1
    80003c54:	6c88                	ld	a0,24(s1)
    80003c56:	fffff097          	auipc	ra,0xfffff
    80003c5a:	286080e7          	jalr	646(ra) # 80002edc <readi>
    80003c5e:	892a                	mv	s2,a0
    80003c60:	00a05563          	blez	a0,80003c6a <fileread+0x56>
      f->off += r;
    80003c64:	509c                	lw	a5,32(s1)
    80003c66:	9fa9                	addw	a5,a5,a0
    80003c68:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c6a:	6c88                	ld	a0,24(s1)
    80003c6c:	fffff097          	auipc	ra,0xfffff
    80003c70:	07e080e7          	jalr	126(ra) # 80002cea <iunlock>
    80003c74:	64e2                	ld	s1,24(sp)
    80003c76:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c78:	854a                	mv	a0,s2
    80003c7a:	70a2                	ld	ra,40(sp)
    80003c7c:	7402                	ld	s0,32(sp)
    80003c7e:	6942                	ld	s2,16(sp)
    80003c80:	6145                	add	sp,sp,48
    80003c82:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c84:	6908                	ld	a0,16(a0)
    80003c86:	00000097          	auipc	ra,0x0
    80003c8a:	3fa080e7          	jalr	1018(ra) # 80004080 <piperead>
    80003c8e:	892a                	mv	s2,a0
    80003c90:	64e2                	ld	s1,24(sp)
    80003c92:	69a2                	ld	s3,8(sp)
    80003c94:	b7d5                	j	80003c78 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c96:	02451783          	lh	a5,36(a0)
    80003c9a:	03079693          	sll	a3,a5,0x30
    80003c9e:	92c1                	srl	a3,a3,0x30
    80003ca0:	4725                	li	a4,9
    80003ca2:	02d76a63          	bltu	a4,a3,80003cd6 <fileread+0xc2>
    80003ca6:	0792                	sll	a5,a5,0x4
    80003ca8:	00015717          	auipc	a4,0x15
    80003cac:	62070713          	add	a4,a4,1568 # 800192c8 <devsw>
    80003cb0:	97ba                	add	a5,a5,a4
    80003cb2:	639c                	ld	a5,0(a5)
    80003cb4:	c78d                	beqz	a5,80003cde <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003cb6:	4505                	li	a0,1
    80003cb8:	9782                	jalr	a5
    80003cba:	892a                	mv	s2,a0
    80003cbc:	64e2                	ld	s1,24(sp)
    80003cbe:	69a2                	ld	s3,8(sp)
    80003cc0:	bf65                	j	80003c78 <fileread+0x64>
    panic("fileread");
    80003cc2:	00005517          	auipc	a0,0x5
    80003cc6:	92e50513          	add	a0,a0,-1746 # 800085f0 <etext+0x5f0>
    80003cca:	00002097          	auipc	ra,0x2
    80003cce:	0c2080e7          	jalr	194(ra) # 80005d8c <panic>
    return -1;
    80003cd2:	597d                	li	s2,-1
    80003cd4:	b755                	j	80003c78 <fileread+0x64>
      return -1;
    80003cd6:	597d                	li	s2,-1
    80003cd8:	64e2                	ld	s1,24(sp)
    80003cda:	69a2                	ld	s3,8(sp)
    80003cdc:	bf71                	j	80003c78 <fileread+0x64>
    80003cde:	597d                	li	s2,-1
    80003ce0:	64e2                	ld	s1,24(sp)
    80003ce2:	69a2                	ld	s3,8(sp)
    80003ce4:	bf51                	j	80003c78 <fileread+0x64>

0000000080003ce6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003ce6:	00954783          	lbu	a5,9(a0)
    80003cea:	12078963          	beqz	a5,80003e1c <filewrite+0x136>
{
    80003cee:	715d                	add	sp,sp,-80
    80003cf0:	e486                	sd	ra,72(sp)
    80003cf2:	e0a2                	sd	s0,64(sp)
    80003cf4:	f84a                	sd	s2,48(sp)
    80003cf6:	f052                	sd	s4,32(sp)
    80003cf8:	e85a                	sd	s6,16(sp)
    80003cfa:	0880                	add	s0,sp,80
    80003cfc:	892a                	mv	s2,a0
    80003cfe:	8b2e                	mv	s6,a1
    80003d00:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d02:	411c                	lw	a5,0(a0)
    80003d04:	4705                	li	a4,1
    80003d06:	02e78763          	beq	a5,a4,80003d34 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d0a:	470d                	li	a4,3
    80003d0c:	02e78a63          	beq	a5,a4,80003d40 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d10:	4709                	li	a4,2
    80003d12:	0ee79863          	bne	a5,a4,80003e02 <filewrite+0x11c>
    80003d16:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d18:	0cc05463          	blez	a2,80003de0 <filewrite+0xfa>
    80003d1c:	fc26                	sd	s1,56(sp)
    80003d1e:	ec56                	sd	s5,24(sp)
    80003d20:	e45e                	sd	s7,8(sp)
    80003d22:	e062                	sd	s8,0(sp)
    int i = 0;
    80003d24:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d26:	6b85                	lui	s7,0x1
    80003d28:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d2c:	6c05                	lui	s8,0x1
    80003d2e:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d32:	a851                	j	80003dc6 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d34:	6908                	ld	a0,16(a0)
    80003d36:	00000097          	auipc	ra,0x0
    80003d3a:	248080e7          	jalr	584(ra) # 80003f7e <pipewrite>
    80003d3e:	a85d                	j	80003df4 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d40:	02451783          	lh	a5,36(a0)
    80003d44:	03079693          	sll	a3,a5,0x30
    80003d48:	92c1                	srl	a3,a3,0x30
    80003d4a:	4725                	li	a4,9
    80003d4c:	0cd76a63          	bltu	a4,a3,80003e20 <filewrite+0x13a>
    80003d50:	0792                	sll	a5,a5,0x4
    80003d52:	00015717          	auipc	a4,0x15
    80003d56:	57670713          	add	a4,a4,1398 # 800192c8 <devsw>
    80003d5a:	97ba                	add	a5,a5,a4
    80003d5c:	679c                	ld	a5,8(a5)
    80003d5e:	c3f9                	beqz	a5,80003e24 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003d60:	4505                	li	a0,1
    80003d62:	9782                	jalr	a5
    80003d64:	a841                	j	80003df4 <filewrite+0x10e>
      if(n1 > max)
    80003d66:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d6a:	00000097          	auipc	ra,0x0
    80003d6e:	88c080e7          	jalr	-1908(ra) # 800035f6 <begin_op>
      ilock(f->ip);
    80003d72:	01893503          	ld	a0,24(s2)
    80003d76:	fffff097          	auipc	ra,0xfffff
    80003d7a:	eae080e7          	jalr	-338(ra) # 80002c24 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d7e:	8756                	mv	a4,s5
    80003d80:	02092683          	lw	a3,32(s2)
    80003d84:	01698633          	add	a2,s3,s6
    80003d88:	4585                	li	a1,1
    80003d8a:	01893503          	ld	a0,24(s2)
    80003d8e:	fffff097          	auipc	ra,0xfffff
    80003d92:	252080e7          	jalr	594(ra) # 80002fe0 <writei>
    80003d96:	84aa                	mv	s1,a0
    80003d98:	00a05763          	blez	a0,80003da6 <filewrite+0xc0>
        f->off += r;
    80003d9c:	02092783          	lw	a5,32(s2)
    80003da0:	9fa9                	addw	a5,a5,a0
    80003da2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003da6:	01893503          	ld	a0,24(s2)
    80003daa:	fffff097          	auipc	ra,0xfffff
    80003dae:	f40080e7          	jalr	-192(ra) # 80002cea <iunlock>
      end_op();
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	8be080e7          	jalr	-1858(ra) # 80003670 <end_op>

      if(r != n1){
    80003dba:	029a9563          	bne	s5,s1,80003de4 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003dbe:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dc2:	0149da63          	bge	s3,s4,80003dd6 <filewrite+0xf0>
      int n1 = n - i;
    80003dc6:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003dca:	0004879b          	sext.w	a5,s1
    80003dce:	f8fbdce3          	bge	s7,a5,80003d66 <filewrite+0x80>
    80003dd2:	84e2                	mv	s1,s8
    80003dd4:	bf49                	j	80003d66 <filewrite+0x80>
    80003dd6:	74e2                	ld	s1,56(sp)
    80003dd8:	6ae2                	ld	s5,24(sp)
    80003dda:	6ba2                	ld	s7,8(sp)
    80003ddc:	6c02                	ld	s8,0(sp)
    80003dde:	a039                	j	80003dec <filewrite+0x106>
    int i = 0;
    80003de0:	4981                	li	s3,0
    80003de2:	a029                	j	80003dec <filewrite+0x106>
    80003de4:	74e2                	ld	s1,56(sp)
    80003de6:	6ae2                	ld	s5,24(sp)
    80003de8:	6ba2                	ld	s7,8(sp)
    80003dea:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003dec:	033a1e63          	bne	s4,s3,80003e28 <filewrite+0x142>
    80003df0:	8552                	mv	a0,s4
    80003df2:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003df4:	60a6                	ld	ra,72(sp)
    80003df6:	6406                	ld	s0,64(sp)
    80003df8:	7942                	ld	s2,48(sp)
    80003dfa:	7a02                	ld	s4,32(sp)
    80003dfc:	6b42                	ld	s6,16(sp)
    80003dfe:	6161                	add	sp,sp,80
    80003e00:	8082                	ret
    80003e02:	fc26                	sd	s1,56(sp)
    80003e04:	f44e                	sd	s3,40(sp)
    80003e06:	ec56                	sd	s5,24(sp)
    80003e08:	e45e                	sd	s7,8(sp)
    80003e0a:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003e0c:	00004517          	auipc	a0,0x4
    80003e10:	7f450513          	add	a0,a0,2036 # 80008600 <etext+0x600>
    80003e14:	00002097          	auipc	ra,0x2
    80003e18:	f78080e7          	jalr	-136(ra) # 80005d8c <panic>
    return -1;
    80003e1c:	557d                	li	a0,-1
}
    80003e1e:	8082                	ret
      return -1;
    80003e20:	557d                	li	a0,-1
    80003e22:	bfc9                	j	80003df4 <filewrite+0x10e>
    80003e24:	557d                	li	a0,-1
    80003e26:	b7f9                	j	80003df4 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e28:	557d                	li	a0,-1
    80003e2a:	79a2                	ld	s3,40(sp)
    80003e2c:	b7e1                	j	80003df4 <filewrite+0x10e>

0000000080003e2e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e2e:	7179                	add	sp,sp,-48
    80003e30:	f406                	sd	ra,40(sp)
    80003e32:	f022                	sd	s0,32(sp)
    80003e34:	ec26                	sd	s1,24(sp)
    80003e36:	e052                	sd	s4,0(sp)
    80003e38:	1800                	add	s0,sp,48
    80003e3a:	84aa                	mv	s1,a0
    80003e3c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e3e:	0005b023          	sd	zero,0(a1)
    80003e42:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e46:	00000097          	auipc	ra,0x0
    80003e4a:	bbe080e7          	jalr	-1090(ra) # 80003a04 <filealloc>
    80003e4e:	e088                	sd	a0,0(s1)
    80003e50:	cd49                	beqz	a0,80003eea <pipealloc+0xbc>
    80003e52:	00000097          	auipc	ra,0x0
    80003e56:	bb2080e7          	jalr	-1102(ra) # 80003a04 <filealloc>
    80003e5a:	00aa3023          	sd	a0,0(s4)
    80003e5e:	c141                	beqz	a0,80003ede <pipealloc+0xb0>
    80003e60:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e62:	ffffc097          	auipc	ra,0xffffc
    80003e66:	2b8080e7          	jalr	696(ra) # 8000011a <kalloc>
    80003e6a:	892a                	mv	s2,a0
    80003e6c:	c13d                	beqz	a0,80003ed2 <pipealloc+0xa4>
    80003e6e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e70:	4985                	li	s3,1
    80003e72:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e76:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e7a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e7e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e82:	00004597          	auipc	a1,0x4
    80003e86:	52e58593          	add	a1,a1,1326 # 800083b0 <etext+0x3b0>
    80003e8a:	00002097          	auipc	ra,0x2
    80003e8e:	3ec080e7          	jalr	1004(ra) # 80006276 <initlock>
  (*f0)->type = FD_PIPE;
    80003e92:	609c                	ld	a5,0(s1)
    80003e94:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e98:	609c                	ld	a5,0(s1)
    80003e9a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e9e:	609c                	ld	a5,0(s1)
    80003ea0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ea4:	609c                	ld	a5,0(s1)
    80003ea6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eaa:	000a3783          	ld	a5,0(s4)
    80003eae:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003eb2:	000a3783          	ld	a5,0(s4)
    80003eb6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eba:	000a3783          	ld	a5,0(s4)
    80003ebe:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ec2:	000a3783          	ld	a5,0(s4)
    80003ec6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003eca:	4501                	li	a0,0
    80003ecc:	6942                	ld	s2,16(sp)
    80003ece:	69a2                	ld	s3,8(sp)
    80003ed0:	a03d                	j	80003efe <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ed2:	6088                	ld	a0,0(s1)
    80003ed4:	c119                	beqz	a0,80003eda <pipealloc+0xac>
    80003ed6:	6942                	ld	s2,16(sp)
    80003ed8:	a029                	j	80003ee2 <pipealloc+0xb4>
    80003eda:	6942                	ld	s2,16(sp)
    80003edc:	a039                	j	80003eea <pipealloc+0xbc>
    80003ede:	6088                	ld	a0,0(s1)
    80003ee0:	c50d                	beqz	a0,80003f0a <pipealloc+0xdc>
    fileclose(*f0);
    80003ee2:	00000097          	auipc	ra,0x0
    80003ee6:	bde080e7          	jalr	-1058(ra) # 80003ac0 <fileclose>
  if(*f1)
    80003eea:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eee:	557d                	li	a0,-1
  if(*f1)
    80003ef0:	c799                	beqz	a5,80003efe <pipealloc+0xd0>
    fileclose(*f1);
    80003ef2:	853e                	mv	a0,a5
    80003ef4:	00000097          	auipc	ra,0x0
    80003ef8:	bcc080e7          	jalr	-1076(ra) # 80003ac0 <fileclose>
  return -1;
    80003efc:	557d                	li	a0,-1
}
    80003efe:	70a2                	ld	ra,40(sp)
    80003f00:	7402                	ld	s0,32(sp)
    80003f02:	64e2                	ld	s1,24(sp)
    80003f04:	6a02                	ld	s4,0(sp)
    80003f06:	6145                	add	sp,sp,48
    80003f08:	8082                	ret
  return -1;
    80003f0a:	557d                	li	a0,-1
    80003f0c:	bfcd                	j	80003efe <pipealloc+0xd0>

0000000080003f0e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f0e:	1101                	add	sp,sp,-32
    80003f10:	ec06                	sd	ra,24(sp)
    80003f12:	e822                	sd	s0,16(sp)
    80003f14:	e426                	sd	s1,8(sp)
    80003f16:	e04a                	sd	s2,0(sp)
    80003f18:	1000                	add	s0,sp,32
    80003f1a:	84aa                	mv	s1,a0
    80003f1c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f1e:	00002097          	auipc	ra,0x2
    80003f22:	3e8080e7          	jalr	1000(ra) # 80006306 <acquire>
  if(writable){
    80003f26:	02090d63          	beqz	s2,80003f60 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f2a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f2e:	21848513          	add	a0,s1,536
    80003f32:	ffffd097          	auipc	ra,0xffffd
    80003f36:	7ee080e7          	jalr	2030(ra) # 80001720 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f3a:	2204b783          	ld	a5,544(s1)
    80003f3e:	eb95                	bnez	a5,80003f72 <pipeclose+0x64>
    release(&pi->lock);
    80003f40:	8526                	mv	a0,s1
    80003f42:	00002097          	auipc	ra,0x2
    80003f46:	478080e7          	jalr	1144(ra) # 800063ba <release>
    kfree((char*)pi);
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	ffffc097          	auipc	ra,0xffffc
    80003f50:	0d0080e7          	jalr	208(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f54:	60e2                	ld	ra,24(sp)
    80003f56:	6442                	ld	s0,16(sp)
    80003f58:	64a2                	ld	s1,8(sp)
    80003f5a:	6902                	ld	s2,0(sp)
    80003f5c:	6105                	add	sp,sp,32
    80003f5e:	8082                	ret
    pi->readopen = 0;
    80003f60:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f64:	21c48513          	add	a0,s1,540
    80003f68:	ffffd097          	auipc	ra,0xffffd
    80003f6c:	7b8080e7          	jalr	1976(ra) # 80001720 <wakeup>
    80003f70:	b7e9                	j	80003f3a <pipeclose+0x2c>
    release(&pi->lock);
    80003f72:	8526                	mv	a0,s1
    80003f74:	00002097          	auipc	ra,0x2
    80003f78:	446080e7          	jalr	1094(ra) # 800063ba <release>
}
    80003f7c:	bfe1                	j	80003f54 <pipeclose+0x46>

0000000080003f7e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f7e:	711d                	add	sp,sp,-96
    80003f80:	ec86                	sd	ra,88(sp)
    80003f82:	e8a2                	sd	s0,80(sp)
    80003f84:	e4a6                	sd	s1,72(sp)
    80003f86:	e0ca                	sd	s2,64(sp)
    80003f88:	fc4e                	sd	s3,56(sp)
    80003f8a:	f852                	sd	s4,48(sp)
    80003f8c:	f456                	sd	s5,40(sp)
    80003f8e:	1080                	add	s0,sp,96
    80003f90:	84aa                	mv	s1,a0
    80003f92:	8aae                	mv	s5,a1
    80003f94:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f96:	ffffd097          	auipc	ra,0xffffd
    80003f9a:	f30080e7          	jalr	-208(ra) # 80000ec6 <myproc>
    80003f9e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fa0:	8526                	mv	a0,s1
    80003fa2:	00002097          	auipc	ra,0x2
    80003fa6:	364080e7          	jalr	868(ra) # 80006306 <acquire>
  while(i < n){
    80003faa:	0d405563          	blez	s4,80004074 <pipewrite+0xf6>
    80003fae:	f05a                	sd	s6,32(sp)
    80003fb0:	ec5e                	sd	s7,24(sp)
    80003fb2:	e862                	sd	s8,16(sp)
  int i = 0;
    80003fb4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fb6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fb8:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fbc:	21c48b93          	add	s7,s1,540
    80003fc0:	a089                	j	80004002 <pipewrite+0x84>
      release(&pi->lock);
    80003fc2:	8526                	mv	a0,s1
    80003fc4:	00002097          	auipc	ra,0x2
    80003fc8:	3f6080e7          	jalr	1014(ra) # 800063ba <release>
      return -1;
    80003fcc:	597d                	li	s2,-1
    80003fce:	7b02                	ld	s6,32(sp)
    80003fd0:	6be2                	ld	s7,24(sp)
    80003fd2:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fd4:	854a                	mv	a0,s2
    80003fd6:	60e6                	ld	ra,88(sp)
    80003fd8:	6446                	ld	s0,80(sp)
    80003fda:	64a6                	ld	s1,72(sp)
    80003fdc:	6906                	ld	s2,64(sp)
    80003fde:	79e2                	ld	s3,56(sp)
    80003fe0:	7a42                	ld	s4,48(sp)
    80003fe2:	7aa2                	ld	s5,40(sp)
    80003fe4:	6125                	add	sp,sp,96
    80003fe6:	8082                	ret
      wakeup(&pi->nread);
    80003fe8:	8562                	mv	a0,s8
    80003fea:	ffffd097          	auipc	ra,0xffffd
    80003fee:	736080e7          	jalr	1846(ra) # 80001720 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ff2:	85a6                	mv	a1,s1
    80003ff4:	855e                	mv	a0,s7
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	59e080e7          	jalr	1438(ra) # 80001594 <sleep>
  while(i < n){
    80003ffe:	05495c63          	bge	s2,s4,80004056 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80004002:	2204a783          	lw	a5,544(s1)
    80004006:	dfd5                	beqz	a5,80003fc2 <pipewrite+0x44>
    80004008:	0289a783          	lw	a5,40(s3)
    8000400c:	fbdd                	bnez	a5,80003fc2 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000400e:	2184a783          	lw	a5,536(s1)
    80004012:	21c4a703          	lw	a4,540(s1)
    80004016:	2007879b          	addw	a5,a5,512
    8000401a:	fcf707e3          	beq	a4,a5,80003fe8 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000401e:	4685                	li	a3,1
    80004020:	01590633          	add	a2,s2,s5
    80004024:	faf40593          	add	a1,s0,-81
    80004028:	0509b503          	ld	a0,80(s3)
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	bc2080e7          	jalr	-1086(ra) # 80000bee <copyin>
    80004034:	05650263          	beq	a0,s6,80004078 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004038:	21c4a783          	lw	a5,540(s1)
    8000403c:	0017871b          	addw	a4,a5,1
    80004040:	20e4ae23          	sw	a4,540(s1)
    80004044:	1ff7f793          	and	a5,a5,511
    80004048:	97a6                	add	a5,a5,s1
    8000404a:	faf44703          	lbu	a4,-81(s0)
    8000404e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004052:	2905                	addw	s2,s2,1
    80004054:	b76d                	j	80003ffe <pipewrite+0x80>
    80004056:	7b02                	ld	s6,32(sp)
    80004058:	6be2                	ld	s7,24(sp)
    8000405a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000405c:	21848513          	add	a0,s1,536
    80004060:	ffffd097          	auipc	ra,0xffffd
    80004064:	6c0080e7          	jalr	1728(ra) # 80001720 <wakeup>
  release(&pi->lock);
    80004068:	8526                	mv	a0,s1
    8000406a:	00002097          	auipc	ra,0x2
    8000406e:	350080e7          	jalr	848(ra) # 800063ba <release>
  return i;
    80004072:	b78d                	j	80003fd4 <pipewrite+0x56>
  int i = 0;
    80004074:	4901                	li	s2,0
    80004076:	b7dd                	j	8000405c <pipewrite+0xde>
    80004078:	7b02                	ld	s6,32(sp)
    8000407a:	6be2                	ld	s7,24(sp)
    8000407c:	6c42                	ld	s8,16(sp)
    8000407e:	bff9                	j	8000405c <pipewrite+0xde>

0000000080004080 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004080:	715d                	add	sp,sp,-80
    80004082:	e486                	sd	ra,72(sp)
    80004084:	e0a2                	sd	s0,64(sp)
    80004086:	fc26                	sd	s1,56(sp)
    80004088:	f84a                	sd	s2,48(sp)
    8000408a:	f44e                	sd	s3,40(sp)
    8000408c:	f052                	sd	s4,32(sp)
    8000408e:	ec56                	sd	s5,24(sp)
    80004090:	0880                	add	s0,sp,80
    80004092:	84aa                	mv	s1,a0
    80004094:	892e                	mv	s2,a1
    80004096:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	e2e080e7          	jalr	-466(ra) # 80000ec6 <myproc>
    800040a0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040a2:	8526                	mv	a0,s1
    800040a4:	00002097          	auipc	ra,0x2
    800040a8:	262080e7          	jalr	610(ra) # 80006306 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ac:	2184a703          	lw	a4,536(s1)
    800040b0:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040b4:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b8:	02f71663          	bne	a4,a5,800040e4 <piperead+0x64>
    800040bc:	2244a783          	lw	a5,548(s1)
    800040c0:	cb9d                	beqz	a5,800040f6 <piperead+0x76>
    if(pr->killed){
    800040c2:	028a2783          	lw	a5,40(s4)
    800040c6:	e38d                	bnez	a5,800040e8 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040c8:	85a6                	mv	a1,s1
    800040ca:	854e                	mv	a0,s3
    800040cc:	ffffd097          	auipc	ra,0xffffd
    800040d0:	4c8080e7          	jalr	1224(ra) # 80001594 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040d4:	2184a703          	lw	a4,536(s1)
    800040d8:	21c4a783          	lw	a5,540(s1)
    800040dc:	fef700e3          	beq	a4,a5,800040bc <piperead+0x3c>
    800040e0:	e85a                	sd	s6,16(sp)
    800040e2:	a819                	j	800040f8 <piperead+0x78>
    800040e4:	e85a                	sd	s6,16(sp)
    800040e6:	a809                	j	800040f8 <piperead+0x78>
      release(&pi->lock);
    800040e8:	8526                	mv	a0,s1
    800040ea:	00002097          	auipc	ra,0x2
    800040ee:	2d0080e7          	jalr	720(ra) # 800063ba <release>
      return -1;
    800040f2:	59fd                	li	s3,-1
    800040f4:	a0a5                	j	8000415c <piperead+0xdc>
    800040f6:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040fa:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040fc:	05505463          	blez	s5,80004144 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004100:	2184a783          	lw	a5,536(s1)
    80004104:	21c4a703          	lw	a4,540(s1)
    80004108:	02f70e63          	beq	a4,a5,80004144 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000410c:	0017871b          	addw	a4,a5,1
    80004110:	20e4ac23          	sw	a4,536(s1)
    80004114:	1ff7f793          	and	a5,a5,511
    80004118:	97a6                	add	a5,a5,s1
    8000411a:	0187c783          	lbu	a5,24(a5)
    8000411e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004122:	4685                	li	a3,1
    80004124:	fbf40613          	add	a2,s0,-65
    80004128:	85ca                	mv	a1,s2
    8000412a:	050a3503          	ld	a0,80(s4)
    8000412e:	ffffd097          	auipc	ra,0xffffd
    80004132:	a34080e7          	jalr	-1484(ra) # 80000b62 <copyout>
    80004136:	01650763          	beq	a0,s6,80004144 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000413a:	2985                	addw	s3,s3,1
    8000413c:	0905                	add	s2,s2,1
    8000413e:	fd3a91e3          	bne	s5,s3,80004100 <piperead+0x80>
    80004142:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004144:	21c48513          	add	a0,s1,540
    80004148:	ffffd097          	auipc	ra,0xffffd
    8000414c:	5d8080e7          	jalr	1496(ra) # 80001720 <wakeup>
  release(&pi->lock);
    80004150:	8526                	mv	a0,s1
    80004152:	00002097          	auipc	ra,0x2
    80004156:	268080e7          	jalr	616(ra) # 800063ba <release>
    8000415a:	6b42                	ld	s6,16(sp)
  return i;
}
    8000415c:	854e                	mv	a0,s3
    8000415e:	60a6                	ld	ra,72(sp)
    80004160:	6406                	ld	s0,64(sp)
    80004162:	74e2                	ld	s1,56(sp)
    80004164:	7942                	ld	s2,48(sp)
    80004166:	79a2                	ld	s3,40(sp)
    80004168:	7a02                	ld	s4,32(sp)
    8000416a:	6ae2                	ld	s5,24(sp)
    8000416c:	6161                	add	sp,sp,80
    8000416e:	8082                	ret

0000000080004170 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004170:	df010113          	add	sp,sp,-528
    80004174:	20113423          	sd	ra,520(sp)
    80004178:	20813023          	sd	s0,512(sp)
    8000417c:	ffa6                	sd	s1,504(sp)
    8000417e:	fbca                	sd	s2,496(sp)
    80004180:	0c00                	add	s0,sp,528
    80004182:	892a                	mv	s2,a0
    80004184:	dea43c23          	sd	a0,-520(s0)
    80004188:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000418c:	ffffd097          	auipc	ra,0xffffd
    80004190:	d3a080e7          	jalr	-710(ra) # 80000ec6 <myproc>
    80004194:	84aa                	mv	s1,a0

  begin_op();
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	460080e7          	jalr	1120(ra) # 800035f6 <begin_op>

  if((ip = namei(path)) == 0){
    8000419e:	854a                	mv	a0,s2
    800041a0:	fffff097          	auipc	ra,0xfffff
    800041a4:	256080e7          	jalr	598(ra) # 800033f6 <namei>
    800041a8:	c135                	beqz	a0,8000420c <exec+0x9c>
    800041aa:	f3d2                	sd	s4,480(sp)
    800041ac:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041ae:	fffff097          	auipc	ra,0xfffff
    800041b2:	a76080e7          	jalr	-1418(ra) # 80002c24 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041b6:	04000713          	li	a4,64
    800041ba:	4681                	li	a3,0
    800041bc:	e5040613          	add	a2,s0,-432
    800041c0:	4581                	li	a1,0
    800041c2:	8552                	mv	a0,s4
    800041c4:	fffff097          	auipc	ra,0xfffff
    800041c8:	d18080e7          	jalr	-744(ra) # 80002edc <readi>
    800041cc:	04000793          	li	a5,64
    800041d0:	00f51a63          	bne	a0,a5,800041e4 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041d4:	e5042703          	lw	a4,-432(s0)
    800041d8:	464c47b7          	lui	a5,0x464c4
    800041dc:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041e0:	02f70c63          	beq	a4,a5,80004218 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041e4:	8552                	mv	a0,s4
    800041e6:	fffff097          	auipc	ra,0xfffff
    800041ea:	ca4080e7          	jalr	-860(ra) # 80002e8a <iunlockput>
    end_op();
    800041ee:	fffff097          	auipc	ra,0xfffff
    800041f2:	482080e7          	jalr	1154(ra) # 80003670 <end_op>
  }
  return -1;
    800041f6:	557d                	li	a0,-1
    800041f8:	7a1e                	ld	s4,480(sp)
}
    800041fa:	20813083          	ld	ra,520(sp)
    800041fe:	20013403          	ld	s0,512(sp)
    80004202:	74fe                	ld	s1,504(sp)
    80004204:	795e                	ld	s2,496(sp)
    80004206:	21010113          	add	sp,sp,528
    8000420a:	8082                	ret
    end_op();
    8000420c:	fffff097          	auipc	ra,0xfffff
    80004210:	464080e7          	jalr	1124(ra) # 80003670 <end_op>
    return -1;
    80004214:	557d                	li	a0,-1
    80004216:	b7d5                	j	800041fa <exec+0x8a>
    80004218:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000421a:	8526                	mv	a0,s1
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	d6e080e7          	jalr	-658(ra) # 80000f8a <proc_pagetable>
    80004224:	8b2a                	mv	s6,a0
    80004226:	30050563          	beqz	a0,80004530 <exec+0x3c0>
    8000422a:	f7ce                	sd	s3,488(sp)
    8000422c:	efd6                	sd	s5,472(sp)
    8000422e:	e7de                	sd	s7,456(sp)
    80004230:	e3e2                	sd	s8,448(sp)
    80004232:	ff66                	sd	s9,440(sp)
    80004234:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004236:	e7042d03          	lw	s10,-400(s0)
    8000423a:	e8845783          	lhu	a5,-376(s0)
    8000423e:	14078563          	beqz	a5,80004388 <exec+0x218>
    80004242:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004244:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004246:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004248:	6c85                	lui	s9,0x1
    8000424a:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000424e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004252:	6a85                	lui	s5,0x1
    80004254:	a0b5                	j	800042c0 <exec+0x150>
      panic("loadseg: address should exist");
    80004256:	00004517          	auipc	a0,0x4
    8000425a:	3ba50513          	add	a0,a0,954 # 80008610 <etext+0x610>
    8000425e:	00002097          	auipc	ra,0x2
    80004262:	b2e080e7          	jalr	-1234(ra) # 80005d8c <panic>
    if(sz - i < PGSIZE)
    80004266:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004268:	8726                	mv	a4,s1
    8000426a:	012c06bb          	addw	a3,s8,s2
    8000426e:	4581                	li	a1,0
    80004270:	8552                	mv	a0,s4
    80004272:	fffff097          	auipc	ra,0xfffff
    80004276:	c6a080e7          	jalr	-918(ra) # 80002edc <readi>
    8000427a:	2501                	sext.w	a0,a0
    8000427c:	26a49e63          	bne	s1,a0,800044f8 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    80004280:	012a893b          	addw	s2,s5,s2
    80004284:	03397563          	bgeu	s2,s3,800042ae <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004288:	02091593          	sll	a1,s2,0x20
    8000428c:	9181                	srl	a1,a1,0x20
    8000428e:	95de                	add	a1,a1,s7
    80004290:	855a                	mv	a0,s6
    80004292:	ffffc097          	auipc	ra,0xffffc
    80004296:	2b0080e7          	jalr	688(ra) # 80000542 <walkaddr>
    8000429a:	862a                	mv	a2,a0
    if(pa == 0)
    8000429c:	dd4d                	beqz	a0,80004256 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000429e:	412984bb          	subw	s1,s3,s2
    800042a2:	0004879b          	sext.w	a5,s1
    800042a6:	fcfcf0e3          	bgeu	s9,a5,80004266 <exec+0xf6>
    800042aa:	84d6                	mv	s1,s5
    800042ac:	bf6d                	j	80004266 <exec+0xf6>
    sz = sz1;
    800042ae:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042b2:	2d85                	addw	s11,s11,1
    800042b4:	038d0d1b          	addw	s10,s10,56
    800042b8:	e8845783          	lhu	a5,-376(s0)
    800042bc:	06fddf63          	bge	s11,a5,8000433a <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800042c0:	2d01                	sext.w	s10,s10
    800042c2:	03800713          	li	a4,56
    800042c6:	86ea                	mv	a3,s10
    800042c8:	e1840613          	add	a2,s0,-488
    800042cc:	4581                	li	a1,0
    800042ce:	8552                	mv	a0,s4
    800042d0:	fffff097          	auipc	ra,0xfffff
    800042d4:	c0c080e7          	jalr	-1012(ra) # 80002edc <readi>
    800042d8:	03800793          	li	a5,56
    800042dc:	1ef51863          	bne	a0,a5,800044cc <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    800042e0:	e1842783          	lw	a5,-488(s0)
    800042e4:	4705                	li	a4,1
    800042e6:	fce796e3          	bne	a5,a4,800042b2 <exec+0x142>
    if(ph.memsz < ph.filesz)
    800042ea:	e4043603          	ld	a2,-448(s0)
    800042ee:	e3843783          	ld	a5,-456(s0)
    800042f2:	1ef66163          	bltu	a2,a5,800044d4 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042f6:	e2843783          	ld	a5,-472(s0)
    800042fa:	963e                	add	a2,a2,a5
    800042fc:	1ef66063          	bltu	a2,a5,800044dc <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004300:	85a6                	mv	a1,s1
    80004302:	855a                	mv	a0,s6
    80004304:	ffffc097          	auipc	ra,0xffffc
    80004308:	602080e7          	jalr	1538(ra) # 80000906 <uvmalloc>
    8000430c:	e0a43423          	sd	a0,-504(s0)
    80004310:	1c050a63          	beqz	a0,800044e4 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    80004314:	e2843b83          	ld	s7,-472(s0)
    80004318:	df043783          	ld	a5,-528(s0)
    8000431c:	00fbf7b3          	and	a5,s7,a5
    80004320:	1c079a63          	bnez	a5,800044f4 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004324:	e2042c03          	lw	s8,-480(s0)
    80004328:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000432c:	00098463          	beqz	s3,80004334 <exec+0x1c4>
    80004330:	4901                	li	s2,0
    80004332:	bf99                	j	80004288 <exec+0x118>
    sz = sz1;
    80004334:	e0843483          	ld	s1,-504(s0)
    80004338:	bfad                	j	800042b2 <exec+0x142>
    8000433a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000433c:	8552                	mv	a0,s4
    8000433e:	fffff097          	auipc	ra,0xfffff
    80004342:	b4c080e7          	jalr	-1204(ra) # 80002e8a <iunlockput>
  end_op();
    80004346:	fffff097          	auipc	ra,0xfffff
    8000434a:	32a080e7          	jalr	810(ra) # 80003670 <end_op>
  p = myproc();
    8000434e:	ffffd097          	auipc	ra,0xffffd
    80004352:	b78080e7          	jalr	-1160(ra) # 80000ec6 <myproc>
    80004356:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004358:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000435c:	6985                	lui	s3,0x1
    8000435e:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004360:	99a6                	add	s3,s3,s1
    80004362:	77fd                	lui	a5,0xfffff
    80004364:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004368:	6609                	lui	a2,0x2
    8000436a:	964e                	add	a2,a2,s3
    8000436c:	85ce                	mv	a1,s3
    8000436e:	855a                	mv	a0,s6
    80004370:	ffffc097          	auipc	ra,0xffffc
    80004374:	596080e7          	jalr	1430(ra) # 80000906 <uvmalloc>
    80004378:	892a                	mv	s2,a0
    8000437a:	e0a43423          	sd	a0,-504(s0)
    8000437e:	e519                	bnez	a0,8000438c <exec+0x21c>
  if(pagetable)
    80004380:	e1343423          	sd	s3,-504(s0)
    80004384:	4a01                	li	s4,0
    80004386:	aa95                	j	800044fa <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004388:	4481                	li	s1,0
    8000438a:	bf4d                	j	8000433c <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000438c:	75f9                	lui	a1,0xffffe
    8000438e:	95aa                	add	a1,a1,a0
    80004390:	855a                	mv	a0,s6
    80004392:	ffffc097          	auipc	ra,0xffffc
    80004396:	79e080e7          	jalr	1950(ra) # 80000b30 <uvmclear>
  stackbase = sp - PGSIZE;
    8000439a:	7bfd                	lui	s7,0xfffff
    8000439c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000439e:	e0043783          	ld	a5,-512(s0)
    800043a2:	6388                	ld	a0,0(a5)
    800043a4:	c52d                	beqz	a0,8000440e <exec+0x29e>
    800043a6:	e9040993          	add	s3,s0,-368
    800043aa:	f9040c13          	add	s8,s0,-112
    800043ae:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043b0:	ffffc097          	auipc	ra,0xffffc
    800043b4:	f88080e7          	jalr	-120(ra) # 80000338 <strlen>
    800043b8:	0015079b          	addw	a5,a0,1
    800043bc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043c0:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    800043c4:	13796463          	bltu	s2,s7,800044ec <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043c8:	e0043d03          	ld	s10,-512(s0)
    800043cc:	000d3a03          	ld	s4,0(s10)
    800043d0:	8552                	mv	a0,s4
    800043d2:	ffffc097          	auipc	ra,0xffffc
    800043d6:	f66080e7          	jalr	-154(ra) # 80000338 <strlen>
    800043da:	0015069b          	addw	a3,a0,1
    800043de:	8652                	mv	a2,s4
    800043e0:	85ca                	mv	a1,s2
    800043e2:	855a                	mv	a0,s6
    800043e4:	ffffc097          	auipc	ra,0xffffc
    800043e8:	77e080e7          	jalr	1918(ra) # 80000b62 <copyout>
    800043ec:	10054263          	bltz	a0,800044f0 <exec+0x380>
    ustack[argc] = sp;
    800043f0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043f4:	0485                	add	s1,s1,1
    800043f6:	008d0793          	add	a5,s10,8
    800043fa:	e0f43023          	sd	a5,-512(s0)
    800043fe:	008d3503          	ld	a0,8(s10)
    80004402:	c909                	beqz	a0,80004414 <exec+0x2a4>
    if(argc >= MAXARG)
    80004404:	09a1                	add	s3,s3,8
    80004406:	fb8995e3          	bne	s3,s8,800043b0 <exec+0x240>
  ip = 0;
    8000440a:	4a01                	li	s4,0
    8000440c:	a0fd                	j	800044fa <exec+0x38a>
  sp = sz;
    8000440e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004412:	4481                	li	s1,0
  ustack[argc] = 0;
    80004414:	00349793          	sll	a5,s1,0x3
    80004418:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    8000441c:	97a2                	add	a5,a5,s0
    8000441e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004422:	00148693          	add	a3,s1,1
    80004426:	068e                	sll	a3,a3,0x3
    80004428:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000442c:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004430:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004434:	f57966e3          	bltu	s2,s7,80004380 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004438:	e9040613          	add	a2,s0,-368
    8000443c:	85ca                	mv	a1,s2
    8000443e:	855a                	mv	a0,s6
    80004440:	ffffc097          	auipc	ra,0xffffc
    80004444:	722080e7          	jalr	1826(ra) # 80000b62 <copyout>
    80004448:	0e054663          	bltz	a0,80004534 <exec+0x3c4>
  p->trapframe->a1 = sp;
    8000444c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004450:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004454:	df843783          	ld	a5,-520(s0)
    80004458:	0007c703          	lbu	a4,0(a5)
    8000445c:	cf11                	beqz	a4,80004478 <exec+0x308>
    8000445e:	0785                	add	a5,a5,1
    if(*s == '/')
    80004460:	02f00693          	li	a3,47
    80004464:	a039                	j	80004472 <exec+0x302>
      last = s+1;
    80004466:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000446a:	0785                	add	a5,a5,1
    8000446c:	fff7c703          	lbu	a4,-1(a5)
    80004470:	c701                	beqz	a4,80004478 <exec+0x308>
    if(*s == '/')
    80004472:	fed71ce3          	bne	a4,a3,8000446a <exec+0x2fa>
    80004476:	bfc5                	j	80004466 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004478:	4641                	li	a2,16
    8000447a:	df843583          	ld	a1,-520(s0)
    8000447e:	158a8513          	add	a0,s5,344
    80004482:	ffffc097          	auipc	ra,0xffffc
    80004486:	e84080e7          	jalr	-380(ra) # 80000306 <safestrcpy>
  oldpagetable = p->pagetable;
    8000448a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000448e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004492:	e0843783          	ld	a5,-504(s0)
    80004496:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000449a:	058ab783          	ld	a5,88(s5)
    8000449e:	e6843703          	ld	a4,-408(s0)
    800044a2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044a4:	058ab783          	ld	a5,88(s5)
    800044a8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044ac:	85e6                	mv	a1,s9
    800044ae:	ffffd097          	auipc	ra,0xffffd
    800044b2:	b78080e7          	jalr	-1160(ra) # 80001026 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044b6:	0004851b          	sext.w	a0,s1
    800044ba:	79be                	ld	s3,488(sp)
    800044bc:	7a1e                	ld	s4,480(sp)
    800044be:	6afe                	ld	s5,472(sp)
    800044c0:	6b5e                	ld	s6,464(sp)
    800044c2:	6bbe                	ld	s7,456(sp)
    800044c4:	6c1e                	ld	s8,448(sp)
    800044c6:	7cfa                	ld	s9,440(sp)
    800044c8:	7d5a                	ld	s10,432(sp)
    800044ca:	bb05                	j	800041fa <exec+0x8a>
    800044cc:	e0943423          	sd	s1,-504(s0)
    800044d0:	7dba                	ld	s11,424(sp)
    800044d2:	a025                	j	800044fa <exec+0x38a>
    800044d4:	e0943423          	sd	s1,-504(s0)
    800044d8:	7dba                	ld	s11,424(sp)
    800044da:	a005                	j	800044fa <exec+0x38a>
    800044dc:	e0943423          	sd	s1,-504(s0)
    800044e0:	7dba                	ld	s11,424(sp)
    800044e2:	a821                	j	800044fa <exec+0x38a>
    800044e4:	e0943423          	sd	s1,-504(s0)
    800044e8:	7dba                	ld	s11,424(sp)
    800044ea:	a801                	j	800044fa <exec+0x38a>
  ip = 0;
    800044ec:	4a01                	li	s4,0
    800044ee:	a031                	j	800044fa <exec+0x38a>
    800044f0:	4a01                	li	s4,0
  if(pagetable)
    800044f2:	a021                	j	800044fa <exec+0x38a>
    800044f4:	7dba                	ld	s11,424(sp)
    800044f6:	a011                	j	800044fa <exec+0x38a>
    800044f8:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800044fa:	e0843583          	ld	a1,-504(s0)
    800044fe:	855a                	mv	a0,s6
    80004500:	ffffd097          	auipc	ra,0xffffd
    80004504:	b26080e7          	jalr	-1242(ra) # 80001026 <proc_freepagetable>
  return -1;
    80004508:	557d                	li	a0,-1
  if(ip){
    8000450a:	000a1b63          	bnez	s4,80004520 <exec+0x3b0>
    8000450e:	79be                	ld	s3,488(sp)
    80004510:	7a1e                	ld	s4,480(sp)
    80004512:	6afe                	ld	s5,472(sp)
    80004514:	6b5e                	ld	s6,464(sp)
    80004516:	6bbe                	ld	s7,456(sp)
    80004518:	6c1e                	ld	s8,448(sp)
    8000451a:	7cfa                	ld	s9,440(sp)
    8000451c:	7d5a                	ld	s10,432(sp)
    8000451e:	b9f1                	j	800041fa <exec+0x8a>
    80004520:	79be                	ld	s3,488(sp)
    80004522:	6afe                	ld	s5,472(sp)
    80004524:	6b5e                	ld	s6,464(sp)
    80004526:	6bbe                	ld	s7,456(sp)
    80004528:	6c1e                	ld	s8,448(sp)
    8000452a:	7cfa                	ld	s9,440(sp)
    8000452c:	7d5a                	ld	s10,432(sp)
    8000452e:	b95d                	j	800041e4 <exec+0x74>
    80004530:	6b5e                	ld	s6,464(sp)
    80004532:	b94d                	j	800041e4 <exec+0x74>
  sz = sz1;
    80004534:	e0843983          	ld	s3,-504(s0)
    80004538:	b5a1                	j	80004380 <exec+0x210>

000000008000453a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000453a:	7179                	add	sp,sp,-48
    8000453c:	f406                	sd	ra,40(sp)
    8000453e:	f022                	sd	s0,32(sp)
    80004540:	ec26                	sd	s1,24(sp)
    80004542:	e84a                	sd	s2,16(sp)
    80004544:	1800                	add	s0,sp,48
    80004546:	892e                	mv	s2,a1
    80004548:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000454a:	fdc40593          	add	a1,s0,-36
    8000454e:	ffffe097          	auipc	ra,0xffffe
    80004552:	a94080e7          	jalr	-1388(ra) # 80001fe2 <argint>
    80004556:	04054063          	bltz	a0,80004596 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000455a:	fdc42703          	lw	a4,-36(s0)
    8000455e:	47bd                	li	a5,15
    80004560:	02e7ed63          	bltu	a5,a4,8000459a <argfd+0x60>
    80004564:	ffffd097          	auipc	ra,0xffffd
    80004568:	962080e7          	jalr	-1694(ra) # 80000ec6 <myproc>
    8000456c:	fdc42703          	lw	a4,-36(s0)
    80004570:	01a70793          	add	a5,a4,26
    80004574:	078e                	sll	a5,a5,0x3
    80004576:	953e                	add	a0,a0,a5
    80004578:	611c                	ld	a5,0(a0)
    8000457a:	c395                	beqz	a5,8000459e <argfd+0x64>
    return -1;
  if(pfd)
    8000457c:	00090463          	beqz	s2,80004584 <argfd+0x4a>
    *pfd = fd;
    80004580:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004584:	4501                	li	a0,0
  if(pf)
    80004586:	c091                	beqz	s1,8000458a <argfd+0x50>
    *pf = f;
    80004588:	e09c                	sd	a5,0(s1)
}
    8000458a:	70a2                	ld	ra,40(sp)
    8000458c:	7402                	ld	s0,32(sp)
    8000458e:	64e2                	ld	s1,24(sp)
    80004590:	6942                	ld	s2,16(sp)
    80004592:	6145                	add	sp,sp,48
    80004594:	8082                	ret
    return -1;
    80004596:	557d                	li	a0,-1
    80004598:	bfcd                	j	8000458a <argfd+0x50>
    return -1;
    8000459a:	557d                	li	a0,-1
    8000459c:	b7fd                	j	8000458a <argfd+0x50>
    8000459e:	557d                	li	a0,-1
    800045a0:	b7ed                	j	8000458a <argfd+0x50>

00000000800045a2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045a2:	1101                	add	sp,sp,-32
    800045a4:	ec06                	sd	ra,24(sp)
    800045a6:	e822                	sd	s0,16(sp)
    800045a8:	e426                	sd	s1,8(sp)
    800045aa:	1000                	add	s0,sp,32
    800045ac:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045ae:	ffffd097          	auipc	ra,0xffffd
    800045b2:	918080e7          	jalr	-1768(ra) # 80000ec6 <myproc>
    800045b6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045b8:	0d050793          	add	a5,a0,208
    800045bc:	4501                	li	a0,0
    800045be:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045c0:	6398                	ld	a4,0(a5)
    800045c2:	cb19                	beqz	a4,800045d8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045c4:	2505                	addw	a0,a0,1
    800045c6:	07a1                	add	a5,a5,8
    800045c8:	fed51ce3          	bne	a0,a3,800045c0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045cc:	557d                	li	a0,-1
}
    800045ce:	60e2                	ld	ra,24(sp)
    800045d0:	6442                	ld	s0,16(sp)
    800045d2:	64a2                	ld	s1,8(sp)
    800045d4:	6105                	add	sp,sp,32
    800045d6:	8082                	ret
      p->ofile[fd] = f;
    800045d8:	01a50793          	add	a5,a0,26
    800045dc:	078e                	sll	a5,a5,0x3
    800045de:	963e                	add	a2,a2,a5
    800045e0:	e204                	sd	s1,0(a2)
      return fd;
    800045e2:	b7f5                	j	800045ce <fdalloc+0x2c>

00000000800045e4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045e4:	715d                	add	sp,sp,-80
    800045e6:	e486                	sd	ra,72(sp)
    800045e8:	e0a2                	sd	s0,64(sp)
    800045ea:	fc26                	sd	s1,56(sp)
    800045ec:	f84a                	sd	s2,48(sp)
    800045ee:	f44e                	sd	s3,40(sp)
    800045f0:	f052                	sd	s4,32(sp)
    800045f2:	ec56                	sd	s5,24(sp)
    800045f4:	0880                	add	s0,sp,80
    800045f6:	8aae                	mv	s5,a1
    800045f8:	8a32                	mv	s4,a2
    800045fa:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045fc:	fb040593          	add	a1,s0,-80
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	e14080e7          	jalr	-492(ra) # 80003414 <nameiparent>
    80004608:	892a                	mv	s2,a0
    8000460a:	12050c63          	beqz	a0,80004742 <create+0x15e>
    return 0;

  ilock(dp);
    8000460e:	ffffe097          	auipc	ra,0xffffe
    80004612:	616080e7          	jalr	1558(ra) # 80002c24 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004616:	4601                	li	a2,0
    80004618:	fb040593          	add	a1,s0,-80
    8000461c:	854a                	mv	a0,s2
    8000461e:	fffff097          	auipc	ra,0xfffff
    80004622:	b06080e7          	jalr	-1274(ra) # 80003124 <dirlookup>
    80004626:	84aa                	mv	s1,a0
    80004628:	c539                	beqz	a0,80004676 <create+0x92>
    iunlockput(dp);
    8000462a:	854a                	mv	a0,s2
    8000462c:	fffff097          	auipc	ra,0xfffff
    80004630:	85e080e7          	jalr	-1954(ra) # 80002e8a <iunlockput>
    ilock(ip);
    80004634:	8526                	mv	a0,s1
    80004636:	ffffe097          	auipc	ra,0xffffe
    8000463a:	5ee080e7          	jalr	1518(ra) # 80002c24 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000463e:	4789                	li	a5,2
    80004640:	02fa9463          	bne	s5,a5,80004668 <create+0x84>
    80004644:	0444d783          	lhu	a5,68(s1)
    80004648:	37f9                	addw	a5,a5,-2
    8000464a:	17c2                	sll	a5,a5,0x30
    8000464c:	93c1                	srl	a5,a5,0x30
    8000464e:	4705                	li	a4,1
    80004650:	00f76c63          	bltu	a4,a5,80004668 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004654:	8526                	mv	a0,s1
    80004656:	60a6                	ld	ra,72(sp)
    80004658:	6406                	ld	s0,64(sp)
    8000465a:	74e2                	ld	s1,56(sp)
    8000465c:	7942                	ld	s2,48(sp)
    8000465e:	79a2                	ld	s3,40(sp)
    80004660:	7a02                	ld	s4,32(sp)
    80004662:	6ae2                	ld	s5,24(sp)
    80004664:	6161                	add	sp,sp,80
    80004666:	8082                	ret
    iunlockput(ip);
    80004668:	8526                	mv	a0,s1
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	820080e7          	jalr	-2016(ra) # 80002e8a <iunlockput>
    return 0;
    80004672:	4481                	li	s1,0
    80004674:	b7c5                	j	80004654 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004676:	85d6                	mv	a1,s5
    80004678:	00092503          	lw	a0,0(s2)
    8000467c:	ffffe097          	auipc	ra,0xffffe
    80004680:	414080e7          	jalr	1044(ra) # 80002a90 <ialloc>
    80004684:	84aa                	mv	s1,a0
    80004686:	c139                	beqz	a0,800046cc <create+0xe8>
  ilock(ip);
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	59c080e7          	jalr	1436(ra) # 80002c24 <ilock>
  ip->major = major;
    80004690:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004694:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004698:	4985                	li	s3,1
    8000469a:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    8000469e:	8526                	mv	a0,s1
    800046a0:	ffffe097          	auipc	ra,0xffffe
    800046a4:	4b8080e7          	jalr	1208(ra) # 80002b58 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046a8:	033a8a63          	beq	s5,s3,800046dc <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800046ac:	40d0                	lw	a2,4(s1)
    800046ae:	fb040593          	add	a1,s0,-80
    800046b2:	854a                	mv	a0,s2
    800046b4:	fffff097          	auipc	ra,0xfffff
    800046b8:	c80080e7          	jalr	-896(ra) # 80003334 <dirlink>
    800046bc:	06054b63          	bltz	a0,80004732 <create+0x14e>
  iunlockput(dp);
    800046c0:	854a                	mv	a0,s2
    800046c2:	ffffe097          	auipc	ra,0xffffe
    800046c6:	7c8080e7          	jalr	1992(ra) # 80002e8a <iunlockput>
  return ip;
    800046ca:	b769                	j	80004654 <create+0x70>
    panic("create: ialloc");
    800046cc:	00004517          	auipc	a0,0x4
    800046d0:	f6450513          	add	a0,a0,-156 # 80008630 <etext+0x630>
    800046d4:	00001097          	auipc	ra,0x1
    800046d8:	6b8080e7          	jalr	1720(ra) # 80005d8c <panic>
    dp->nlink++;  // for ".."
    800046dc:	04a95783          	lhu	a5,74(s2)
    800046e0:	2785                	addw	a5,a5,1
    800046e2:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046e6:	854a                	mv	a0,s2
    800046e8:	ffffe097          	auipc	ra,0xffffe
    800046ec:	470080e7          	jalr	1136(ra) # 80002b58 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046f0:	40d0                	lw	a2,4(s1)
    800046f2:	00004597          	auipc	a1,0x4
    800046f6:	f4e58593          	add	a1,a1,-178 # 80008640 <etext+0x640>
    800046fa:	8526                	mv	a0,s1
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	c38080e7          	jalr	-968(ra) # 80003334 <dirlink>
    80004704:	00054f63          	bltz	a0,80004722 <create+0x13e>
    80004708:	00492603          	lw	a2,4(s2)
    8000470c:	00004597          	auipc	a1,0x4
    80004710:	f3c58593          	add	a1,a1,-196 # 80008648 <etext+0x648>
    80004714:	8526                	mv	a0,s1
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	c1e080e7          	jalr	-994(ra) # 80003334 <dirlink>
    8000471e:	f80557e3          	bgez	a0,800046ac <create+0xc8>
      panic("create dots");
    80004722:	00004517          	auipc	a0,0x4
    80004726:	f2e50513          	add	a0,a0,-210 # 80008650 <etext+0x650>
    8000472a:	00001097          	auipc	ra,0x1
    8000472e:	662080e7          	jalr	1634(ra) # 80005d8c <panic>
    panic("create: dirlink");
    80004732:	00004517          	auipc	a0,0x4
    80004736:	f2e50513          	add	a0,a0,-210 # 80008660 <etext+0x660>
    8000473a:	00001097          	auipc	ra,0x1
    8000473e:	652080e7          	jalr	1618(ra) # 80005d8c <panic>
    return 0;
    80004742:	84aa                	mv	s1,a0
    80004744:	bf01                	j	80004654 <create+0x70>

0000000080004746 <sys_dup>:
{
    80004746:	7179                	add	sp,sp,-48
    80004748:	f406                	sd	ra,40(sp)
    8000474a:	f022                	sd	s0,32(sp)
    8000474c:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000474e:	fd840613          	add	a2,s0,-40
    80004752:	4581                	li	a1,0
    80004754:	4501                	li	a0,0
    80004756:	00000097          	auipc	ra,0x0
    8000475a:	de4080e7          	jalr	-540(ra) # 8000453a <argfd>
    return -1;
    8000475e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004760:	02054763          	bltz	a0,8000478e <sys_dup+0x48>
    80004764:	ec26                	sd	s1,24(sp)
    80004766:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004768:	fd843903          	ld	s2,-40(s0)
    8000476c:	854a                	mv	a0,s2
    8000476e:	00000097          	auipc	ra,0x0
    80004772:	e34080e7          	jalr	-460(ra) # 800045a2 <fdalloc>
    80004776:	84aa                	mv	s1,a0
    return -1;
    80004778:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000477a:	00054f63          	bltz	a0,80004798 <sys_dup+0x52>
  filedup(f);
    8000477e:	854a                	mv	a0,s2
    80004780:	fffff097          	auipc	ra,0xfffff
    80004784:	2ee080e7          	jalr	750(ra) # 80003a6e <filedup>
  return fd;
    80004788:	87a6                	mv	a5,s1
    8000478a:	64e2                	ld	s1,24(sp)
    8000478c:	6942                	ld	s2,16(sp)
}
    8000478e:	853e                	mv	a0,a5
    80004790:	70a2                	ld	ra,40(sp)
    80004792:	7402                	ld	s0,32(sp)
    80004794:	6145                	add	sp,sp,48
    80004796:	8082                	ret
    80004798:	64e2                	ld	s1,24(sp)
    8000479a:	6942                	ld	s2,16(sp)
    8000479c:	bfcd                	j	8000478e <sys_dup+0x48>

000000008000479e <sys_read>:
{
    8000479e:	7179                	add	sp,sp,-48
    800047a0:	f406                	sd	ra,40(sp)
    800047a2:	f022                	sd	s0,32(sp)
    800047a4:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047a6:	fe840613          	add	a2,s0,-24
    800047aa:	4581                	li	a1,0
    800047ac:	4501                	li	a0,0
    800047ae:	00000097          	auipc	ra,0x0
    800047b2:	d8c080e7          	jalr	-628(ra) # 8000453a <argfd>
    return -1;
    800047b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047b8:	04054163          	bltz	a0,800047fa <sys_read+0x5c>
    800047bc:	fe440593          	add	a1,s0,-28
    800047c0:	4509                	li	a0,2
    800047c2:	ffffe097          	auipc	ra,0xffffe
    800047c6:	820080e7          	jalr	-2016(ra) # 80001fe2 <argint>
    return -1;
    800047ca:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047cc:	02054763          	bltz	a0,800047fa <sys_read+0x5c>
    800047d0:	fd840593          	add	a1,s0,-40
    800047d4:	4505                	li	a0,1
    800047d6:	ffffe097          	auipc	ra,0xffffe
    800047da:	82e080e7          	jalr	-2002(ra) # 80002004 <argaddr>
    return -1;
    800047de:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047e0:	00054d63          	bltz	a0,800047fa <sys_read+0x5c>
  return fileread(f, p, n);
    800047e4:	fe442603          	lw	a2,-28(s0)
    800047e8:	fd843583          	ld	a1,-40(s0)
    800047ec:	fe843503          	ld	a0,-24(s0)
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	424080e7          	jalr	1060(ra) # 80003c14 <fileread>
    800047f8:	87aa                	mv	a5,a0
}
    800047fa:	853e                	mv	a0,a5
    800047fc:	70a2                	ld	ra,40(sp)
    800047fe:	7402                	ld	s0,32(sp)
    80004800:	6145                	add	sp,sp,48
    80004802:	8082                	ret

0000000080004804 <sys_write>:
{
    80004804:	7179                	add	sp,sp,-48
    80004806:	f406                	sd	ra,40(sp)
    80004808:	f022                	sd	s0,32(sp)
    8000480a:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000480c:	fe840613          	add	a2,s0,-24
    80004810:	4581                	li	a1,0
    80004812:	4501                	li	a0,0
    80004814:	00000097          	auipc	ra,0x0
    80004818:	d26080e7          	jalr	-730(ra) # 8000453a <argfd>
    return -1;
    8000481c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000481e:	04054163          	bltz	a0,80004860 <sys_write+0x5c>
    80004822:	fe440593          	add	a1,s0,-28
    80004826:	4509                	li	a0,2
    80004828:	ffffd097          	auipc	ra,0xffffd
    8000482c:	7ba080e7          	jalr	1978(ra) # 80001fe2 <argint>
    return -1;
    80004830:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004832:	02054763          	bltz	a0,80004860 <sys_write+0x5c>
    80004836:	fd840593          	add	a1,s0,-40
    8000483a:	4505                	li	a0,1
    8000483c:	ffffd097          	auipc	ra,0xffffd
    80004840:	7c8080e7          	jalr	1992(ra) # 80002004 <argaddr>
    return -1;
    80004844:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004846:	00054d63          	bltz	a0,80004860 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000484a:	fe442603          	lw	a2,-28(s0)
    8000484e:	fd843583          	ld	a1,-40(s0)
    80004852:	fe843503          	ld	a0,-24(s0)
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	490080e7          	jalr	1168(ra) # 80003ce6 <filewrite>
    8000485e:	87aa                	mv	a5,a0
}
    80004860:	853e                	mv	a0,a5
    80004862:	70a2                	ld	ra,40(sp)
    80004864:	7402                	ld	s0,32(sp)
    80004866:	6145                	add	sp,sp,48
    80004868:	8082                	ret

000000008000486a <sys_close>:
{
    8000486a:	1101                	add	sp,sp,-32
    8000486c:	ec06                	sd	ra,24(sp)
    8000486e:	e822                	sd	s0,16(sp)
    80004870:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004872:	fe040613          	add	a2,s0,-32
    80004876:	fec40593          	add	a1,s0,-20
    8000487a:	4501                	li	a0,0
    8000487c:	00000097          	auipc	ra,0x0
    80004880:	cbe080e7          	jalr	-834(ra) # 8000453a <argfd>
    return -1;
    80004884:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004886:	02054463          	bltz	a0,800048ae <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000488a:	ffffc097          	auipc	ra,0xffffc
    8000488e:	63c080e7          	jalr	1596(ra) # 80000ec6 <myproc>
    80004892:	fec42783          	lw	a5,-20(s0)
    80004896:	07e9                	add	a5,a5,26
    80004898:	078e                	sll	a5,a5,0x3
    8000489a:	953e                	add	a0,a0,a5
    8000489c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800048a0:	fe043503          	ld	a0,-32(s0)
    800048a4:	fffff097          	auipc	ra,0xfffff
    800048a8:	21c080e7          	jalr	540(ra) # 80003ac0 <fileclose>
  return 0;
    800048ac:	4781                	li	a5,0
}
    800048ae:	853e                	mv	a0,a5
    800048b0:	60e2                	ld	ra,24(sp)
    800048b2:	6442                	ld	s0,16(sp)
    800048b4:	6105                	add	sp,sp,32
    800048b6:	8082                	ret

00000000800048b8 <sys_fstat>:
{
    800048b8:	1101                	add	sp,sp,-32
    800048ba:	ec06                	sd	ra,24(sp)
    800048bc:	e822                	sd	s0,16(sp)
    800048be:	1000                	add	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048c0:	fe840613          	add	a2,s0,-24
    800048c4:	4581                	li	a1,0
    800048c6:	4501                	li	a0,0
    800048c8:	00000097          	auipc	ra,0x0
    800048cc:	c72080e7          	jalr	-910(ra) # 8000453a <argfd>
    return -1;
    800048d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048d2:	02054563          	bltz	a0,800048fc <sys_fstat+0x44>
    800048d6:	fe040593          	add	a1,s0,-32
    800048da:	4505                	li	a0,1
    800048dc:	ffffd097          	auipc	ra,0xffffd
    800048e0:	728080e7          	jalr	1832(ra) # 80002004 <argaddr>
    return -1;
    800048e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048e6:	00054b63          	bltz	a0,800048fc <sys_fstat+0x44>
  return filestat(f, st);
    800048ea:	fe043583          	ld	a1,-32(s0)
    800048ee:	fe843503          	ld	a0,-24(s0)
    800048f2:	fffff097          	auipc	ra,0xfffff
    800048f6:	2b0080e7          	jalr	688(ra) # 80003ba2 <filestat>
    800048fa:	87aa                	mv	a5,a0
}
    800048fc:	853e                	mv	a0,a5
    800048fe:	60e2                	ld	ra,24(sp)
    80004900:	6442                	ld	s0,16(sp)
    80004902:	6105                	add	sp,sp,32
    80004904:	8082                	ret

0000000080004906 <sys_link>:
{
    80004906:	7169                	add	sp,sp,-304
    80004908:	f606                	sd	ra,296(sp)
    8000490a:	f222                	sd	s0,288(sp)
    8000490c:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000490e:	08000613          	li	a2,128
    80004912:	ed040593          	add	a1,s0,-304
    80004916:	4501                	li	a0,0
    80004918:	ffffd097          	auipc	ra,0xffffd
    8000491c:	70e080e7          	jalr	1806(ra) # 80002026 <argstr>
    return -1;
    80004920:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004922:	12054663          	bltz	a0,80004a4e <sys_link+0x148>
    80004926:	08000613          	li	a2,128
    8000492a:	f5040593          	add	a1,s0,-176
    8000492e:	4505                	li	a0,1
    80004930:	ffffd097          	auipc	ra,0xffffd
    80004934:	6f6080e7          	jalr	1782(ra) # 80002026 <argstr>
    return -1;
    80004938:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000493a:	10054a63          	bltz	a0,80004a4e <sys_link+0x148>
    8000493e:	ee26                	sd	s1,280(sp)
  begin_op();
    80004940:	fffff097          	auipc	ra,0xfffff
    80004944:	cb6080e7          	jalr	-842(ra) # 800035f6 <begin_op>
  if((ip = namei(old)) == 0){
    80004948:	ed040513          	add	a0,s0,-304
    8000494c:	fffff097          	auipc	ra,0xfffff
    80004950:	aaa080e7          	jalr	-1366(ra) # 800033f6 <namei>
    80004954:	84aa                	mv	s1,a0
    80004956:	c949                	beqz	a0,800049e8 <sys_link+0xe2>
  ilock(ip);
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	2cc080e7          	jalr	716(ra) # 80002c24 <ilock>
  if(ip->type == T_DIR){
    80004960:	04449703          	lh	a4,68(s1)
    80004964:	4785                	li	a5,1
    80004966:	08f70863          	beq	a4,a5,800049f6 <sys_link+0xf0>
    8000496a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000496c:	04a4d783          	lhu	a5,74(s1)
    80004970:	2785                	addw	a5,a5,1
    80004972:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004976:	8526                	mv	a0,s1
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	1e0080e7          	jalr	480(ra) # 80002b58 <iupdate>
  iunlock(ip);
    80004980:	8526                	mv	a0,s1
    80004982:	ffffe097          	auipc	ra,0xffffe
    80004986:	368080e7          	jalr	872(ra) # 80002cea <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000498a:	fd040593          	add	a1,s0,-48
    8000498e:	f5040513          	add	a0,s0,-176
    80004992:	fffff097          	auipc	ra,0xfffff
    80004996:	a82080e7          	jalr	-1406(ra) # 80003414 <nameiparent>
    8000499a:	892a                	mv	s2,a0
    8000499c:	cd35                	beqz	a0,80004a18 <sys_link+0x112>
  ilock(dp);
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	286080e7          	jalr	646(ra) # 80002c24 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049a6:	00092703          	lw	a4,0(s2)
    800049aa:	409c                	lw	a5,0(s1)
    800049ac:	06f71163          	bne	a4,a5,80004a0e <sys_link+0x108>
    800049b0:	40d0                	lw	a2,4(s1)
    800049b2:	fd040593          	add	a1,s0,-48
    800049b6:	854a                	mv	a0,s2
    800049b8:	fffff097          	auipc	ra,0xfffff
    800049bc:	97c080e7          	jalr	-1668(ra) # 80003334 <dirlink>
    800049c0:	04054763          	bltz	a0,80004a0e <sys_link+0x108>
  iunlockput(dp);
    800049c4:	854a                	mv	a0,s2
    800049c6:	ffffe097          	auipc	ra,0xffffe
    800049ca:	4c4080e7          	jalr	1220(ra) # 80002e8a <iunlockput>
  iput(ip);
    800049ce:	8526                	mv	a0,s1
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	412080e7          	jalr	1042(ra) # 80002de2 <iput>
  end_op();
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	c98080e7          	jalr	-872(ra) # 80003670 <end_op>
  return 0;
    800049e0:	4781                	li	a5,0
    800049e2:	64f2                	ld	s1,280(sp)
    800049e4:	6952                	ld	s2,272(sp)
    800049e6:	a0a5                	j	80004a4e <sys_link+0x148>
    end_op();
    800049e8:	fffff097          	auipc	ra,0xfffff
    800049ec:	c88080e7          	jalr	-888(ra) # 80003670 <end_op>
    return -1;
    800049f0:	57fd                	li	a5,-1
    800049f2:	64f2                	ld	s1,280(sp)
    800049f4:	a8a9                	j	80004a4e <sys_link+0x148>
    iunlockput(ip);
    800049f6:	8526                	mv	a0,s1
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	492080e7          	jalr	1170(ra) # 80002e8a <iunlockput>
    end_op();
    80004a00:	fffff097          	auipc	ra,0xfffff
    80004a04:	c70080e7          	jalr	-912(ra) # 80003670 <end_op>
    return -1;
    80004a08:	57fd                	li	a5,-1
    80004a0a:	64f2                	ld	s1,280(sp)
    80004a0c:	a089                	j	80004a4e <sys_link+0x148>
    iunlockput(dp);
    80004a0e:	854a                	mv	a0,s2
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	47a080e7          	jalr	1146(ra) # 80002e8a <iunlockput>
  ilock(ip);
    80004a18:	8526                	mv	a0,s1
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	20a080e7          	jalr	522(ra) # 80002c24 <ilock>
  ip->nlink--;
    80004a22:	04a4d783          	lhu	a5,74(s1)
    80004a26:	37fd                	addw	a5,a5,-1
    80004a28:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a2c:	8526                	mv	a0,s1
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	12a080e7          	jalr	298(ra) # 80002b58 <iupdate>
  iunlockput(ip);
    80004a36:	8526                	mv	a0,s1
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	452080e7          	jalr	1106(ra) # 80002e8a <iunlockput>
  end_op();
    80004a40:	fffff097          	auipc	ra,0xfffff
    80004a44:	c30080e7          	jalr	-976(ra) # 80003670 <end_op>
  return -1;
    80004a48:	57fd                	li	a5,-1
    80004a4a:	64f2                	ld	s1,280(sp)
    80004a4c:	6952                	ld	s2,272(sp)
}
    80004a4e:	853e                	mv	a0,a5
    80004a50:	70b2                	ld	ra,296(sp)
    80004a52:	7412                	ld	s0,288(sp)
    80004a54:	6155                	add	sp,sp,304
    80004a56:	8082                	ret

0000000080004a58 <sys_unlink>:
{
    80004a58:	7151                	add	sp,sp,-240
    80004a5a:	f586                	sd	ra,232(sp)
    80004a5c:	f1a2                	sd	s0,224(sp)
    80004a5e:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a60:	08000613          	li	a2,128
    80004a64:	f3040593          	add	a1,s0,-208
    80004a68:	4501                	li	a0,0
    80004a6a:	ffffd097          	auipc	ra,0xffffd
    80004a6e:	5bc080e7          	jalr	1468(ra) # 80002026 <argstr>
    80004a72:	1a054a63          	bltz	a0,80004c26 <sys_unlink+0x1ce>
    80004a76:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a78:	fffff097          	auipc	ra,0xfffff
    80004a7c:	b7e080e7          	jalr	-1154(ra) # 800035f6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a80:	fb040593          	add	a1,s0,-80
    80004a84:	f3040513          	add	a0,s0,-208
    80004a88:	fffff097          	auipc	ra,0xfffff
    80004a8c:	98c080e7          	jalr	-1652(ra) # 80003414 <nameiparent>
    80004a90:	84aa                	mv	s1,a0
    80004a92:	cd71                	beqz	a0,80004b6e <sys_unlink+0x116>
  ilock(dp);
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	190080e7          	jalr	400(ra) # 80002c24 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a9c:	00004597          	auipc	a1,0x4
    80004aa0:	ba458593          	add	a1,a1,-1116 # 80008640 <etext+0x640>
    80004aa4:	fb040513          	add	a0,s0,-80
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	662080e7          	jalr	1634(ra) # 8000310a <namecmp>
    80004ab0:	14050c63          	beqz	a0,80004c08 <sys_unlink+0x1b0>
    80004ab4:	00004597          	auipc	a1,0x4
    80004ab8:	b9458593          	add	a1,a1,-1132 # 80008648 <etext+0x648>
    80004abc:	fb040513          	add	a0,s0,-80
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	64a080e7          	jalr	1610(ra) # 8000310a <namecmp>
    80004ac8:	14050063          	beqz	a0,80004c08 <sys_unlink+0x1b0>
    80004acc:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ace:	f2c40613          	add	a2,s0,-212
    80004ad2:	fb040593          	add	a1,s0,-80
    80004ad6:	8526                	mv	a0,s1
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	64c080e7          	jalr	1612(ra) # 80003124 <dirlookup>
    80004ae0:	892a                	mv	s2,a0
    80004ae2:	12050263          	beqz	a0,80004c06 <sys_unlink+0x1ae>
  ilock(ip);
    80004ae6:	ffffe097          	auipc	ra,0xffffe
    80004aea:	13e080e7          	jalr	318(ra) # 80002c24 <ilock>
  if(ip->nlink < 1)
    80004aee:	04a91783          	lh	a5,74(s2)
    80004af2:	08f05563          	blez	a5,80004b7c <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004af6:	04491703          	lh	a4,68(s2)
    80004afa:	4785                	li	a5,1
    80004afc:	08f70963          	beq	a4,a5,80004b8e <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004b00:	4641                	li	a2,16
    80004b02:	4581                	li	a1,0
    80004b04:	fc040513          	add	a0,s0,-64
    80004b08:	ffffb097          	auipc	ra,0xffffb
    80004b0c:	6bc080e7          	jalr	1724(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b10:	4741                	li	a4,16
    80004b12:	f2c42683          	lw	a3,-212(s0)
    80004b16:	fc040613          	add	a2,s0,-64
    80004b1a:	4581                	li	a1,0
    80004b1c:	8526                	mv	a0,s1
    80004b1e:	ffffe097          	auipc	ra,0xffffe
    80004b22:	4c2080e7          	jalr	1218(ra) # 80002fe0 <writei>
    80004b26:	47c1                	li	a5,16
    80004b28:	0af51b63          	bne	a0,a5,80004bde <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004b2c:	04491703          	lh	a4,68(s2)
    80004b30:	4785                	li	a5,1
    80004b32:	0af70f63          	beq	a4,a5,80004bf0 <sys_unlink+0x198>
  iunlockput(dp);
    80004b36:	8526                	mv	a0,s1
    80004b38:	ffffe097          	auipc	ra,0xffffe
    80004b3c:	352080e7          	jalr	850(ra) # 80002e8a <iunlockput>
  ip->nlink--;
    80004b40:	04a95783          	lhu	a5,74(s2)
    80004b44:	37fd                	addw	a5,a5,-1
    80004b46:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b4a:	854a                	mv	a0,s2
    80004b4c:	ffffe097          	auipc	ra,0xffffe
    80004b50:	00c080e7          	jalr	12(ra) # 80002b58 <iupdate>
  iunlockput(ip);
    80004b54:	854a                	mv	a0,s2
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	334080e7          	jalr	820(ra) # 80002e8a <iunlockput>
  end_op();
    80004b5e:	fffff097          	auipc	ra,0xfffff
    80004b62:	b12080e7          	jalr	-1262(ra) # 80003670 <end_op>
  return 0;
    80004b66:	4501                	li	a0,0
    80004b68:	64ee                	ld	s1,216(sp)
    80004b6a:	694e                	ld	s2,208(sp)
    80004b6c:	a84d                	j	80004c1e <sys_unlink+0x1c6>
    end_op();
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	b02080e7          	jalr	-1278(ra) # 80003670 <end_op>
    return -1;
    80004b76:	557d                	li	a0,-1
    80004b78:	64ee                	ld	s1,216(sp)
    80004b7a:	a055                	j	80004c1e <sys_unlink+0x1c6>
    80004b7c:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004b7e:	00004517          	auipc	a0,0x4
    80004b82:	af250513          	add	a0,a0,-1294 # 80008670 <etext+0x670>
    80004b86:	00001097          	auipc	ra,0x1
    80004b8a:	206080e7          	jalr	518(ra) # 80005d8c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b8e:	04c92703          	lw	a4,76(s2)
    80004b92:	02000793          	li	a5,32
    80004b96:	f6e7f5e3          	bgeu	a5,a4,80004b00 <sys_unlink+0xa8>
    80004b9a:	e5ce                	sd	s3,200(sp)
    80004b9c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ba0:	4741                	li	a4,16
    80004ba2:	86ce                	mv	a3,s3
    80004ba4:	f1840613          	add	a2,s0,-232
    80004ba8:	4581                	li	a1,0
    80004baa:	854a                	mv	a0,s2
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	330080e7          	jalr	816(ra) # 80002edc <readi>
    80004bb4:	47c1                	li	a5,16
    80004bb6:	00f51c63          	bne	a0,a5,80004bce <sys_unlink+0x176>
    if(de.inum != 0)
    80004bba:	f1845783          	lhu	a5,-232(s0)
    80004bbe:	e7b5                	bnez	a5,80004c2a <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bc0:	29c1                	addw	s3,s3,16
    80004bc2:	04c92783          	lw	a5,76(s2)
    80004bc6:	fcf9ede3          	bltu	s3,a5,80004ba0 <sys_unlink+0x148>
    80004bca:	69ae                	ld	s3,200(sp)
    80004bcc:	bf15                	j	80004b00 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004bce:	00004517          	auipc	a0,0x4
    80004bd2:	aba50513          	add	a0,a0,-1350 # 80008688 <etext+0x688>
    80004bd6:	00001097          	auipc	ra,0x1
    80004bda:	1b6080e7          	jalr	438(ra) # 80005d8c <panic>
    80004bde:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004be0:	00004517          	auipc	a0,0x4
    80004be4:	ac050513          	add	a0,a0,-1344 # 800086a0 <etext+0x6a0>
    80004be8:	00001097          	auipc	ra,0x1
    80004bec:	1a4080e7          	jalr	420(ra) # 80005d8c <panic>
    dp->nlink--;
    80004bf0:	04a4d783          	lhu	a5,74(s1)
    80004bf4:	37fd                	addw	a5,a5,-1
    80004bf6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	f5c080e7          	jalr	-164(ra) # 80002b58 <iupdate>
    80004c04:	bf0d                	j	80004b36 <sys_unlink+0xde>
    80004c06:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004c08:	8526                	mv	a0,s1
    80004c0a:	ffffe097          	auipc	ra,0xffffe
    80004c0e:	280080e7          	jalr	640(ra) # 80002e8a <iunlockput>
  end_op();
    80004c12:	fffff097          	auipc	ra,0xfffff
    80004c16:	a5e080e7          	jalr	-1442(ra) # 80003670 <end_op>
  return -1;
    80004c1a:	557d                	li	a0,-1
    80004c1c:	64ee                	ld	s1,216(sp)
}
    80004c1e:	70ae                	ld	ra,232(sp)
    80004c20:	740e                	ld	s0,224(sp)
    80004c22:	616d                	add	sp,sp,240
    80004c24:	8082                	ret
    return -1;
    80004c26:	557d                	li	a0,-1
    80004c28:	bfdd                	j	80004c1e <sys_unlink+0x1c6>
    iunlockput(ip);
    80004c2a:	854a                	mv	a0,s2
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	25e080e7          	jalr	606(ra) # 80002e8a <iunlockput>
    goto bad;
    80004c34:	694e                	ld	s2,208(sp)
    80004c36:	69ae                	ld	s3,200(sp)
    80004c38:	bfc1                	j	80004c08 <sys_unlink+0x1b0>

0000000080004c3a <sys_open>:

uint64
sys_open(void)
{
    80004c3a:	7131                	add	sp,sp,-192
    80004c3c:	fd06                	sd	ra,184(sp)
    80004c3e:	f922                	sd	s0,176(sp)
    80004c40:	f526                	sd	s1,168(sp)
    80004c42:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c44:	08000613          	li	a2,128
    80004c48:	f5040593          	add	a1,s0,-176
    80004c4c:	4501                	li	a0,0
    80004c4e:	ffffd097          	auipc	ra,0xffffd
    80004c52:	3d8080e7          	jalr	984(ra) # 80002026 <argstr>
    return -1;
    80004c56:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c58:	0c054463          	bltz	a0,80004d20 <sys_open+0xe6>
    80004c5c:	f4c40593          	add	a1,s0,-180
    80004c60:	4505                	li	a0,1
    80004c62:	ffffd097          	auipc	ra,0xffffd
    80004c66:	380080e7          	jalr	896(ra) # 80001fe2 <argint>
    80004c6a:	0a054b63          	bltz	a0,80004d20 <sys_open+0xe6>
    80004c6e:	f14a                	sd	s2,160(sp)

  begin_op();
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	986080e7          	jalr	-1658(ra) # 800035f6 <begin_op>

  if(omode & O_CREATE){
    80004c78:	f4c42783          	lw	a5,-180(s0)
    80004c7c:	2007f793          	and	a5,a5,512
    80004c80:	cfc5                	beqz	a5,80004d38 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c82:	4681                	li	a3,0
    80004c84:	4601                	li	a2,0
    80004c86:	4589                	li	a1,2
    80004c88:	f5040513          	add	a0,s0,-176
    80004c8c:	00000097          	auipc	ra,0x0
    80004c90:	958080e7          	jalr	-1704(ra) # 800045e4 <create>
    80004c94:	892a                	mv	s2,a0
    if(ip == 0){
    80004c96:	c959                	beqz	a0,80004d2c <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c98:	04491703          	lh	a4,68(s2)
    80004c9c:	478d                	li	a5,3
    80004c9e:	00f71763          	bne	a4,a5,80004cac <sys_open+0x72>
    80004ca2:	04695703          	lhu	a4,70(s2)
    80004ca6:	47a5                	li	a5,9
    80004ca8:	0ce7ef63          	bltu	a5,a4,80004d86 <sys_open+0x14c>
    80004cac:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cae:	fffff097          	auipc	ra,0xfffff
    80004cb2:	d56080e7          	jalr	-682(ra) # 80003a04 <filealloc>
    80004cb6:	89aa                	mv	s3,a0
    80004cb8:	c965                	beqz	a0,80004da8 <sys_open+0x16e>
    80004cba:	00000097          	auipc	ra,0x0
    80004cbe:	8e8080e7          	jalr	-1816(ra) # 800045a2 <fdalloc>
    80004cc2:	84aa                	mv	s1,a0
    80004cc4:	0c054d63          	bltz	a0,80004d9e <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cc8:	04491703          	lh	a4,68(s2)
    80004ccc:	478d                	li	a5,3
    80004cce:	0ef70a63          	beq	a4,a5,80004dc2 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cd2:	4789                	li	a5,2
    80004cd4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cd8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cdc:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004ce0:	f4c42783          	lw	a5,-180(s0)
    80004ce4:	0017c713          	xor	a4,a5,1
    80004ce8:	8b05                	and	a4,a4,1
    80004cea:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cee:	0037f713          	and	a4,a5,3
    80004cf2:	00e03733          	snez	a4,a4
    80004cf6:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cfa:	4007f793          	and	a5,a5,1024
    80004cfe:	c791                	beqz	a5,80004d0a <sys_open+0xd0>
    80004d00:	04491703          	lh	a4,68(s2)
    80004d04:	4789                	li	a5,2
    80004d06:	0cf70563          	beq	a4,a5,80004dd0 <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004d0a:	854a                	mv	a0,s2
    80004d0c:	ffffe097          	auipc	ra,0xffffe
    80004d10:	fde080e7          	jalr	-34(ra) # 80002cea <iunlock>
  end_op();
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	95c080e7          	jalr	-1700(ra) # 80003670 <end_op>
    80004d1c:	790a                	ld	s2,160(sp)
    80004d1e:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004d20:	8526                	mv	a0,s1
    80004d22:	70ea                	ld	ra,184(sp)
    80004d24:	744a                	ld	s0,176(sp)
    80004d26:	74aa                	ld	s1,168(sp)
    80004d28:	6129                	add	sp,sp,192
    80004d2a:	8082                	ret
      end_op();
    80004d2c:	fffff097          	auipc	ra,0xfffff
    80004d30:	944080e7          	jalr	-1724(ra) # 80003670 <end_op>
      return -1;
    80004d34:	790a                	ld	s2,160(sp)
    80004d36:	b7ed                	j	80004d20 <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004d38:	f5040513          	add	a0,s0,-176
    80004d3c:	ffffe097          	auipc	ra,0xffffe
    80004d40:	6ba080e7          	jalr	1722(ra) # 800033f6 <namei>
    80004d44:	892a                	mv	s2,a0
    80004d46:	c90d                	beqz	a0,80004d78 <sys_open+0x13e>
    ilock(ip);
    80004d48:	ffffe097          	auipc	ra,0xffffe
    80004d4c:	edc080e7          	jalr	-292(ra) # 80002c24 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d50:	04491703          	lh	a4,68(s2)
    80004d54:	4785                	li	a5,1
    80004d56:	f4f711e3          	bne	a4,a5,80004c98 <sys_open+0x5e>
    80004d5a:	f4c42783          	lw	a5,-180(s0)
    80004d5e:	d7b9                	beqz	a5,80004cac <sys_open+0x72>
      iunlockput(ip);
    80004d60:	854a                	mv	a0,s2
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	128080e7          	jalr	296(ra) # 80002e8a <iunlockput>
      end_op();
    80004d6a:	fffff097          	auipc	ra,0xfffff
    80004d6e:	906080e7          	jalr	-1786(ra) # 80003670 <end_op>
      return -1;
    80004d72:	54fd                	li	s1,-1
    80004d74:	790a                	ld	s2,160(sp)
    80004d76:	b76d                	j	80004d20 <sys_open+0xe6>
      end_op();
    80004d78:	fffff097          	auipc	ra,0xfffff
    80004d7c:	8f8080e7          	jalr	-1800(ra) # 80003670 <end_op>
      return -1;
    80004d80:	54fd                	li	s1,-1
    80004d82:	790a                	ld	s2,160(sp)
    80004d84:	bf71                	j	80004d20 <sys_open+0xe6>
    iunlockput(ip);
    80004d86:	854a                	mv	a0,s2
    80004d88:	ffffe097          	auipc	ra,0xffffe
    80004d8c:	102080e7          	jalr	258(ra) # 80002e8a <iunlockput>
    end_op();
    80004d90:	fffff097          	auipc	ra,0xfffff
    80004d94:	8e0080e7          	jalr	-1824(ra) # 80003670 <end_op>
    return -1;
    80004d98:	54fd                	li	s1,-1
    80004d9a:	790a                	ld	s2,160(sp)
    80004d9c:	b751                	j	80004d20 <sys_open+0xe6>
      fileclose(f);
    80004d9e:	854e                	mv	a0,s3
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	d20080e7          	jalr	-736(ra) # 80003ac0 <fileclose>
    iunlockput(ip);
    80004da8:	854a                	mv	a0,s2
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	0e0080e7          	jalr	224(ra) # 80002e8a <iunlockput>
    end_op();
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	8be080e7          	jalr	-1858(ra) # 80003670 <end_op>
    return -1;
    80004dba:	54fd                	li	s1,-1
    80004dbc:	790a                	ld	s2,160(sp)
    80004dbe:	69ea                	ld	s3,152(sp)
    80004dc0:	b785                	j	80004d20 <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004dc2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dc6:	04691783          	lh	a5,70(s2)
    80004dca:	02f99223          	sh	a5,36(s3)
    80004dce:	b739                	j	80004cdc <sys_open+0xa2>
    itrunc(ip);
    80004dd0:	854a                	mv	a0,s2
    80004dd2:	ffffe097          	auipc	ra,0xffffe
    80004dd6:	f64080e7          	jalr	-156(ra) # 80002d36 <itrunc>
    80004dda:	bf05                	j	80004d0a <sys_open+0xd0>

0000000080004ddc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ddc:	7175                	add	sp,sp,-144
    80004dde:	e506                	sd	ra,136(sp)
    80004de0:	e122                	sd	s0,128(sp)
    80004de2:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	812080e7          	jalr	-2030(ra) # 800035f6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dec:	08000613          	li	a2,128
    80004df0:	f7040593          	add	a1,s0,-144
    80004df4:	4501                	li	a0,0
    80004df6:	ffffd097          	auipc	ra,0xffffd
    80004dfa:	230080e7          	jalr	560(ra) # 80002026 <argstr>
    80004dfe:	02054963          	bltz	a0,80004e30 <sys_mkdir+0x54>
    80004e02:	4681                	li	a3,0
    80004e04:	4601                	li	a2,0
    80004e06:	4585                	li	a1,1
    80004e08:	f7040513          	add	a0,s0,-144
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	7d8080e7          	jalr	2008(ra) # 800045e4 <create>
    80004e14:	cd11                	beqz	a0,80004e30 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	074080e7          	jalr	116(ra) # 80002e8a <iunlockput>
  end_op();
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	852080e7          	jalr	-1966(ra) # 80003670 <end_op>
  return 0;
    80004e26:	4501                	li	a0,0
}
    80004e28:	60aa                	ld	ra,136(sp)
    80004e2a:	640a                	ld	s0,128(sp)
    80004e2c:	6149                	add	sp,sp,144
    80004e2e:	8082                	ret
    end_op();
    80004e30:	fffff097          	auipc	ra,0xfffff
    80004e34:	840080e7          	jalr	-1984(ra) # 80003670 <end_op>
    return -1;
    80004e38:	557d                	li	a0,-1
    80004e3a:	b7fd                	j	80004e28 <sys_mkdir+0x4c>

0000000080004e3c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e3c:	7135                	add	sp,sp,-160
    80004e3e:	ed06                	sd	ra,152(sp)
    80004e40:	e922                	sd	s0,144(sp)
    80004e42:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e44:	ffffe097          	auipc	ra,0xffffe
    80004e48:	7b2080e7          	jalr	1970(ra) # 800035f6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e4c:	08000613          	li	a2,128
    80004e50:	f7040593          	add	a1,s0,-144
    80004e54:	4501                	li	a0,0
    80004e56:	ffffd097          	auipc	ra,0xffffd
    80004e5a:	1d0080e7          	jalr	464(ra) # 80002026 <argstr>
    80004e5e:	04054a63          	bltz	a0,80004eb2 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e62:	f6c40593          	add	a1,s0,-148
    80004e66:	4505                	li	a0,1
    80004e68:	ffffd097          	auipc	ra,0xffffd
    80004e6c:	17a080e7          	jalr	378(ra) # 80001fe2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e70:	04054163          	bltz	a0,80004eb2 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e74:	f6840593          	add	a1,s0,-152
    80004e78:	4509                	li	a0,2
    80004e7a:	ffffd097          	auipc	ra,0xffffd
    80004e7e:	168080e7          	jalr	360(ra) # 80001fe2 <argint>
     argint(1, &major) < 0 ||
    80004e82:	02054863          	bltz	a0,80004eb2 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e86:	f6841683          	lh	a3,-152(s0)
    80004e8a:	f6c41603          	lh	a2,-148(s0)
    80004e8e:	458d                	li	a1,3
    80004e90:	f7040513          	add	a0,s0,-144
    80004e94:	fffff097          	auipc	ra,0xfffff
    80004e98:	750080e7          	jalr	1872(ra) # 800045e4 <create>
     argint(2, &minor) < 0 ||
    80004e9c:	c919                	beqz	a0,80004eb2 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e9e:	ffffe097          	auipc	ra,0xffffe
    80004ea2:	fec080e7          	jalr	-20(ra) # 80002e8a <iunlockput>
  end_op();
    80004ea6:	ffffe097          	auipc	ra,0xffffe
    80004eaa:	7ca080e7          	jalr	1994(ra) # 80003670 <end_op>
  return 0;
    80004eae:	4501                	li	a0,0
    80004eb0:	a031                	j	80004ebc <sys_mknod+0x80>
    end_op();
    80004eb2:	ffffe097          	auipc	ra,0xffffe
    80004eb6:	7be080e7          	jalr	1982(ra) # 80003670 <end_op>
    return -1;
    80004eba:	557d                	li	a0,-1
}
    80004ebc:	60ea                	ld	ra,152(sp)
    80004ebe:	644a                	ld	s0,144(sp)
    80004ec0:	610d                	add	sp,sp,160
    80004ec2:	8082                	ret

0000000080004ec4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ec4:	7135                	add	sp,sp,-160
    80004ec6:	ed06                	sd	ra,152(sp)
    80004ec8:	e922                	sd	s0,144(sp)
    80004eca:	e14a                	sd	s2,128(sp)
    80004ecc:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ece:	ffffc097          	auipc	ra,0xffffc
    80004ed2:	ff8080e7          	jalr	-8(ra) # 80000ec6 <myproc>
    80004ed6:	892a                	mv	s2,a0
  
  begin_op();
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	71e080e7          	jalr	1822(ra) # 800035f6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ee0:	08000613          	li	a2,128
    80004ee4:	f6040593          	add	a1,s0,-160
    80004ee8:	4501                	li	a0,0
    80004eea:	ffffd097          	auipc	ra,0xffffd
    80004eee:	13c080e7          	jalr	316(ra) # 80002026 <argstr>
    80004ef2:	04054d63          	bltz	a0,80004f4c <sys_chdir+0x88>
    80004ef6:	e526                	sd	s1,136(sp)
    80004ef8:	f6040513          	add	a0,s0,-160
    80004efc:	ffffe097          	auipc	ra,0xffffe
    80004f00:	4fa080e7          	jalr	1274(ra) # 800033f6 <namei>
    80004f04:	84aa                	mv	s1,a0
    80004f06:	c131                	beqz	a0,80004f4a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f08:	ffffe097          	auipc	ra,0xffffe
    80004f0c:	d1c080e7          	jalr	-740(ra) # 80002c24 <ilock>
  if(ip->type != T_DIR){
    80004f10:	04449703          	lh	a4,68(s1)
    80004f14:	4785                	li	a5,1
    80004f16:	04f71163          	bne	a4,a5,80004f58 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f1a:	8526                	mv	a0,s1
    80004f1c:	ffffe097          	auipc	ra,0xffffe
    80004f20:	dce080e7          	jalr	-562(ra) # 80002cea <iunlock>
  iput(p->cwd);
    80004f24:	15093503          	ld	a0,336(s2)
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	eba080e7          	jalr	-326(ra) # 80002de2 <iput>
  end_op();
    80004f30:	ffffe097          	auipc	ra,0xffffe
    80004f34:	740080e7          	jalr	1856(ra) # 80003670 <end_op>
  p->cwd = ip;
    80004f38:	14993823          	sd	s1,336(s2)
  return 0;
    80004f3c:	4501                	li	a0,0
    80004f3e:	64aa                	ld	s1,136(sp)
}
    80004f40:	60ea                	ld	ra,152(sp)
    80004f42:	644a                	ld	s0,144(sp)
    80004f44:	690a                	ld	s2,128(sp)
    80004f46:	610d                	add	sp,sp,160
    80004f48:	8082                	ret
    80004f4a:	64aa                	ld	s1,136(sp)
    end_op();
    80004f4c:	ffffe097          	auipc	ra,0xffffe
    80004f50:	724080e7          	jalr	1828(ra) # 80003670 <end_op>
    return -1;
    80004f54:	557d                	li	a0,-1
    80004f56:	b7ed                	j	80004f40 <sys_chdir+0x7c>
    iunlockput(ip);
    80004f58:	8526                	mv	a0,s1
    80004f5a:	ffffe097          	auipc	ra,0xffffe
    80004f5e:	f30080e7          	jalr	-208(ra) # 80002e8a <iunlockput>
    end_op();
    80004f62:	ffffe097          	auipc	ra,0xffffe
    80004f66:	70e080e7          	jalr	1806(ra) # 80003670 <end_op>
    return -1;
    80004f6a:	557d                	li	a0,-1
    80004f6c:	64aa                	ld	s1,136(sp)
    80004f6e:	bfc9                	j	80004f40 <sys_chdir+0x7c>

0000000080004f70 <sys_exec>:

uint64
sys_exec(void)
{
    80004f70:	7121                	add	sp,sp,-448
    80004f72:	ff06                	sd	ra,440(sp)
    80004f74:	fb22                	sd	s0,432(sp)
    80004f76:	f34a                	sd	s2,416(sp)
    80004f78:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f7a:	08000613          	li	a2,128
    80004f7e:	f5040593          	add	a1,s0,-176
    80004f82:	4501                	li	a0,0
    80004f84:	ffffd097          	auipc	ra,0xffffd
    80004f88:	0a2080e7          	jalr	162(ra) # 80002026 <argstr>
    return -1;
    80004f8c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f8e:	0e054a63          	bltz	a0,80005082 <sys_exec+0x112>
    80004f92:	e4840593          	add	a1,s0,-440
    80004f96:	4505                	li	a0,1
    80004f98:	ffffd097          	auipc	ra,0xffffd
    80004f9c:	06c080e7          	jalr	108(ra) # 80002004 <argaddr>
    80004fa0:	0e054163          	bltz	a0,80005082 <sys_exec+0x112>
    80004fa4:	f726                	sd	s1,424(sp)
    80004fa6:	ef4e                	sd	s3,408(sp)
    80004fa8:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004faa:	10000613          	li	a2,256
    80004fae:	4581                	li	a1,0
    80004fb0:	e5040513          	add	a0,s0,-432
    80004fb4:	ffffb097          	auipc	ra,0xffffb
    80004fb8:	210080e7          	jalr	528(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fbc:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004fc0:	89a6                	mv	s3,s1
    80004fc2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fc4:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fc8:	00391513          	sll	a0,s2,0x3
    80004fcc:	e4040593          	add	a1,s0,-448
    80004fd0:	e4843783          	ld	a5,-440(s0)
    80004fd4:	953e                	add	a0,a0,a5
    80004fd6:	ffffd097          	auipc	ra,0xffffd
    80004fda:	f72080e7          	jalr	-142(ra) # 80001f48 <fetchaddr>
    80004fde:	02054a63          	bltz	a0,80005012 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004fe2:	e4043783          	ld	a5,-448(s0)
    80004fe6:	c7b1                	beqz	a5,80005032 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fe8:	ffffb097          	auipc	ra,0xffffb
    80004fec:	132080e7          	jalr	306(ra) # 8000011a <kalloc>
    80004ff0:	85aa                	mv	a1,a0
    80004ff2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ff6:	cd11                	beqz	a0,80005012 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ff8:	6605                	lui	a2,0x1
    80004ffa:	e4043503          	ld	a0,-448(s0)
    80004ffe:	ffffd097          	auipc	ra,0xffffd
    80005002:	f9c080e7          	jalr	-100(ra) # 80001f9a <fetchstr>
    80005006:	00054663          	bltz	a0,80005012 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    8000500a:	0905                	add	s2,s2,1
    8000500c:	09a1                	add	s3,s3,8
    8000500e:	fb491de3          	bne	s2,s4,80004fc8 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005012:	f5040913          	add	s2,s0,-176
    80005016:	6088                	ld	a0,0(s1)
    80005018:	c12d                	beqz	a0,8000507a <sys_exec+0x10a>
    kfree(argv[i]);
    8000501a:	ffffb097          	auipc	ra,0xffffb
    8000501e:	002080e7          	jalr	2(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005022:	04a1                	add	s1,s1,8
    80005024:	ff2499e3          	bne	s1,s2,80005016 <sys_exec+0xa6>
  return -1;
    80005028:	597d                	li	s2,-1
    8000502a:	74ba                	ld	s1,424(sp)
    8000502c:	69fa                	ld	s3,408(sp)
    8000502e:	6a5a                	ld	s4,400(sp)
    80005030:	a889                	j	80005082 <sys_exec+0x112>
      argv[i] = 0;
    80005032:	0009079b          	sext.w	a5,s2
    80005036:	078e                	sll	a5,a5,0x3
    80005038:	fd078793          	add	a5,a5,-48
    8000503c:	97a2                	add	a5,a5,s0
    8000503e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005042:	e5040593          	add	a1,s0,-432
    80005046:	f5040513          	add	a0,s0,-176
    8000504a:	fffff097          	auipc	ra,0xfffff
    8000504e:	126080e7          	jalr	294(ra) # 80004170 <exec>
    80005052:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005054:	f5040993          	add	s3,s0,-176
    80005058:	6088                	ld	a0,0(s1)
    8000505a:	cd01                	beqz	a0,80005072 <sys_exec+0x102>
    kfree(argv[i]);
    8000505c:	ffffb097          	auipc	ra,0xffffb
    80005060:	fc0080e7          	jalr	-64(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005064:	04a1                	add	s1,s1,8
    80005066:	ff3499e3          	bne	s1,s3,80005058 <sys_exec+0xe8>
    8000506a:	74ba                	ld	s1,424(sp)
    8000506c:	69fa                	ld	s3,408(sp)
    8000506e:	6a5a                	ld	s4,400(sp)
    80005070:	a809                	j	80005082 <sys_exec+0x112>
  return ret;
    80005072:	74ba                	ld	s1,424(sp)
    80005074:	69fa                	ld	s3,408(sp)
    80005076:	6a5a                	ld	s4,400(sp)
    80005078:	a029                	j	80005082 <sys_exec+0x112>
  return -1;
    8000507a:	597d                	li	s2,-1
    8000507c:	74ba                	ld	s1,424(sp)
    8000507e:	69fa                	ld	s3,408(sp)
    80005080:	6a5a                	ld	s4,400(sp)
}
    80005082:	854a                	mv	a0,s2
    80005084:	70fa                	ld	ra,440(sp)
    80005086:	745a                	ld	s0,432(sp)
    80005088:	791a                	ld	s2,416(sp)
    8000508a:	6139                	add	sp,sp,448
    8000508c:	8082                	ret

000000008000508e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000508e:	7139                	add	sp,sp,-64
    80005090:	fc06                	sd	ra,56(sp)
    80005092:	f822                	sd	s0,48(sp)
    80005094:	f426                	sd	s1,40(sp)
    80005096:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005098:	ffffc097          	auipc	ra,0xffffc
    8000509c:	e2e080e7          	jalr	-466(ra) # 80000ec6 <myproc>
    800050a0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050a2:	fd840593          	add	a1,s0,-40
    800050a6:	4501                	li	a0,0
    800050a8:	ffffd097          	auipc	ra,0xffffd
    800050ac:	f5c080e7          	jalr	-164(ra) # 80002004 <argaddr>
    return -1;
    800050b0:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050b2:	0e054063          	bltz	a0,80005192 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050b6:	fc840593          	add	a1,s0,-56
    800050ba:	fd040513          	add	a0,s0,-48
    800050be:	fffff097          	auipc	ra,0xfffff
    800050c2:	d70080e7          	jalr	-656(ra) # 80003e2e <pipealloc>
    return -1;
    800050c6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050c8:	0c054563          	bltz	a0,80005192 <sys_pipe+0x104>
  fd0 = -1;
    800050cc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050d0:	fd043503          	ld	a0,-48(s0)
    800050d4:	fffff097          	auipc	ra,0xfffff
    800050d8:	4ce080e7          	jalr	1230(ra) # 800045a2 <fdalloc>
    800050dc:	fca42223          	sw	a0,-60(s0)
    800050e0:	08054c63          	bltz	a0,80005178 <sys_pipe+0xea>
    800050e4:	fc843503          	ld	a0,-56(s0)
    800050e8:	fffff097          	auipc	ra,0xfffff
    800050ec:	4ba080e7          	jalr	1210(ra) # 800045a2 <fdalloc>
    800050f0:	fca42023          	sw	a0,-64(s0)
    800050f4:	06054963          	bltz	a0,80005166 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050f8:	4691                	li	a3,4
    800050fa:	fc440613          	add	a2,s0,-60
    800050fe:	fd843583          	ld	a1,-40(s0)
    80005102:	68a8                	ld	a0,80(s1)
    80005104:	ffffc097          	auipc	ra,0xffffc
    80005108:	a5e080e7          	jalr	-1442(ra) # 80000b62 <copyout>
    8000510c:	02054063          	bltz	a0,8000512c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005110:	4691                	li	a3,4
    80005112:	fc040613          	add	a2,s0,-64
    80005116:	fd843583          	ld	a1,-40(s0)
    8000511a:	0591                	add	a1,a1,4
    8000511c:	68a8                	ld	a0,80(s1)
    8000511e:	ffffc097          	auipc	ra,0xffffc
    80005122:	a44080e7          	jalr	-1468(ra) # 80000b62 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005126:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005128:	06055563          	bgez	a0,80005192 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000512c:	fc442783          	lw	a5,-60(s0)
    80005130:	07e9                	add	a5,a5,26
    80005132:	078e                	sll	a5,a5,0x3
    80005134:	97a6                	add	a5,a5,s1
    80005136:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000513a:	fc042783          	lw	a5,-64(s0)
    8000513e:	07e9                	add	a5,a5,26
    80005140:	078e                	sll	a5,a5,0x3
    80005142:	00f48533          	add	a0,s1,a5
    80005146:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000514a:	fd043503          	ld	a0,-48(s0)
    8000514e:	fffff097          	auipc	ra,0xfffff
    80005152:	972080e7          	jalr	-1678(ra) # 80003ac0 <fileclose>
    fileclose(wf);
    80005156:	fc843503          	ld	a0,-56(s0)
    8000515a:	fffff097          	auipc	ra,0xfffff
    8000515e:	966080e7          	jalr	-1690(ra) # 80003ac0 <fileclose>
    return -1;
    80005162:	57fd                	li	a5,-1
    80005164:	a03d                	j	80005192 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005166:	fc442783          	lw	a5,-60(s0)
    8000516a:	0007c763          	bltz	a5,80005178 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000516e:	07e9                	add	a5,a5,26
    80005170:	078e                	sll	a5,a5,0x3
    80005172:	97a6                	add	a5,a5,s1
    80005174:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005178:	fd043503          	ld	a0,-48(s0)
    8000517c:	fffff097          	auipc	ra,0xfffff
    80005180:	944080e7          	jalr	-1724(ra) # 80003ac0 <fileclose>
    fileclose(wf);
    80005184:	fc843503          	ld	a0,-56(s0)
    80005188:	fffff097          	auipc	ra,0xfffff
    8000518c:	938080e7          	jalr	-1736(ra) # 80003ac0 <fileclose>
    return -1;
    80005190:	57fd                	li	a5,-1
}
    80005192:	853e                	mv	a0,a5
    80005194:	70e2                	ld	ra,56(sp)
    80005196:	7442                	ld	s0,48(sp)
    80005198:	74a2                	ld	s1,40(sp)
    8000519a:	6121                	add	sp,sp,64
    8000519c:	8082                	ret
	...

00000000800051a0 <kernelvec>:
    800051a0:	7111                	add	sp,sp,-256
    800051a2:	e006                	sd	ra,0(sp)
    800051a4:	e40a                	sd	sp,8(sp)
    800051a6:	e80e                	sd	gp,16(sp)
    800051a8:	ec12                	sd	tp,24(sp)
    800051aa:	f016                	sd	t0,32(sp)
    800051ac:	f41a                	sd	t1,40(sp)
    800051ae:	f81e                	sd	t2,48(sp)
    800051b0:	fc22                	sd	s0,56(sp)
    800051b2:	e0a6                	sd	s1,64(sp)
    800051b4:	e4aa                	sd	a0,72(sp)
    800051b6:	e8ae                	sd	a1,80(sp)
    800051b8:	ecb2                	sd	a2,88(sp)
    800051ba:	f0b6                	sd	a3,96(sp)
    800051bc:	f4ba                	sd	a4,104(sp)
    800051be:	f8be                	sd	a5,112(sp)
    800051c0:	fcc2                	sd	a6,120(sp)
    800051c2:	e146                	sd	a7,128(sp)
    800051c4:	e54a                	sd	s2,136(sp)
    800051c6:	e94e                	sd	s3,144(sp)
    800051c8:	ed52                	sd	s4,152(sp)
    800051ca:	f156                	sd	s5,160(sp)
    800051cc:	f55a                	sd	s6,168(sp)
    800051ce:	f95e                	sd	s7,176(sp)
    800051d0:	fd62                	sd	s8,184(sp)
    800051d2:	e1e6                	sd	s9,192(sp)
    800051d4:	e5ea                	sd	s10,200(sp)
    800051d6:	e9ee                	sd	s11,208(sp)
    800051d8:	edf2                	sd	t3,216(sp)
    800051da:	f1f6                	sd	t4,224(sp)
    800051dc:	f5fa                	sd	t5,232(sp)
    800051de:	f9fe                	sd	t6,240(sp)
    800051e0:	c35fc0ef          	jal	80001e14 <kerneltrap>
    800051e4:	6082                	ld	ra,0(sp)
    800051e6:	6122                	ld	sp,8(sp)
    800051e8:	61c2                	ld	gp,16(sp)
    800051ea:	7282                	ld	t0,32(sp)
    800051ec:	7322                	ld	t1,40(sp)
    800051ee:	73c2                	ld	t2,48(sp)
    800051f0:	7462                	ld	s0,56(sp)
    800051f2:	6486                	ld	s1,64(sp)
    800051f4:	6526                	ld	a0,72(sp)
    800051f6:	65c6                	ld	a1,80(sp)
    800051f8:	6666                	ld	a2,88(sp)
    800051fa:	7686                	ld	a3,96(sp)
    800051fc:	7726                	ld	a4,104(sp)
    800051fe:	77c6                	ld	a5,112(sp)
    80005200:	7866                	ld	a6,120(sp)
    80005202:	688a                	ld	a7,128(sp)
    80005204:	692a                	ld	s2,136(sp)
    80005206:	69ca                	ld	s3,144(sp)
    80005208:	6a6a                	ld	s4,152(sp)
    8000520a:	7a8a                	ld	s5,160(sp)
    8000520c:	7b2a                	ld	s6,168(sp)
    8000520e:	7bca                	ld	s7,176(sp)
    80005210:	7c6a                	ld	s8,184(sp)
    80005212:	6c8e                	ld	s9,192(sp)
    80005214:	6d2e                	ld	s10,200(sp)
    80005216:	6dce                	ld	s11,208(sp)
    80005218:	6e6e                	ld	t3,216(sp)
    8000521a:	7e8e                	ld	t4,224(sp)
    8000521c:	7f2e                	ld	t5,232(sp)
    8000521e:	7fce                	ld	t6,240(sp)
    80005220:	6111                	add	sp,sp,256
    80005222:	10200073          	sret
    80005226:	00000013          	nop
    8000522a:	00000013          	nop
    8000522e:	0001                	nop

0000000080005230 <timervec>:
    80005230:	34051573          	csrrw	a0,mscratch,a0
    80005234:	e10c                	sd	a1,0(a0)
    80005236:	e510                	sd	a2,8(a0)
    80005238:	e914                	sd	a3,16(a0)
    8000523a:	6d0c                	ld	a1,24(a0)
    8000523c:	7110                	ld	a2,32(a0)
    8000523e:	6194                	ld	a3,0(a1)
    80005240:	96b2                	add	a3,a3,a2
    80005242:	e194                	sd	a3,0(a1)
    80005244:	4589                	li	a1,2
    80005246:	14459073          	csrw	sip,a1
    8000524a:	6914                	ld	a3,16(a0)
    8000524c:	6510                	ld	a2,8(a0)
    8000524e:	610c                	ld	a1,0(a0)
    80005250:	34051573          	csrrw	a0,mscratch,a0
    80005254:	30200073          	mret
	...

000000008000525a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000525a:	1141                	add	sp,sp,-16
    8000525c:	e422                	sd	s0,8(sp)
    8000525e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005260:	0c0007b7          	lui	a5,0xc000
    80005264:	4705                	li	a4,1
    80005266:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005268:	0c0007b7          	lui	a5,0xc000
    8000526c:	c3d8                	sw	a4,4(a5)
}
    8000526e:	6422                	ld	s0,8(sp)
    80005270:	0141                	add	sp,sp,16
    80005272:	8082                	ret

0000000080005274 <plicinithart>:

void
plicinithart(void)
{
    80005274:	1141                	add	sp,sp,-16
    80005276:	e406                	sd	ra,8(sp)
    80005278:	e022                	sd	s0,0(sp)
    8000527a:	0800                	add	s0,sp,16
  int hart = cpuid();
    8000527c:	ffffc097          	auipc	ra,0xffffc
    80005280:	c1e080e7          	jalr	-994(ra) # 80000e9a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005284:	0085171b          	sllw	a4,a0,0x8
    80005288:	0c0027b7          	lui	a5,0xc002
    8000528c:	97ba                	add	a5,a5,a4
    8000528e:	40200713          	li	a4,1026
    80005292:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005296:	00d5151b          	sllw	a0,a0,0xd
    8000529a:	0c2017b7          	lui	a5,0xc201
    8000529e:	97aa                	add	a5,a5,a0
    800052a0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052a4:	60a2                	ld	ra,8(sp)
    800052a6:	6402                	ld	s0,0(sp)
    800052a8:	0141                	add	sp,sp,16
    800052aa:	8082                	ret

00000000800052ac <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052ac:	1141                	add	sp,sp,-16
    800052ae:	e406                	sd	ra,8(sp)
    800052b0:	e022                	sd	s0,0(sp)
    800052b2:	0800                	add	s0,sp,16
  int hart = cpuid();
    800052b4:	ffffc097          	auipc	ra,0xffffc
    800052b8:	be6080e7          	jalr	-1050(ra) # 80000e9a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052bc:	00d5151b          	sllw	a0,a0,0xd
    800052c0:	0c2017b7          	lui	a5,0xc201
    800052c4:	97aa                	add	a5,a5,a0
  return irq;
}
    800052c6:	43c8                	lw	a0,4(a5)
    800052c8:	60a2                	ld	ra,8(sp)
    800052ca:	6402                	ld	s0,0(sp)
    800052cc:	0141                	add	sp,sp,16
    800052ce:	8082                	ret

00000000800052d0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052d0:	1101                	add	sp,sp,-32
    800052d2:	ec06                	sd	ra,24(sp)
    800052d4:	e822                	sd	s0,16(sp)
    800052d6:	e426                	sd	s1,8(sp)
    800052d8:	1000                	add	s0,sp,32
    800052da:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052dc:	ffffc097          	auipc	ra,0xffffc
    800052e0:	bbe080e7          	jalr	-1090(ra) # 80000e9a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052e4:	00d5151b          	sllw	a0,a0,0xd
    800052e8:	0c2017b7          	lui	a5,0xc201
    800052ec:	97aa                	add	a5,a5,a0
    800052ee:	c3c4                	sw	s1,4(a5)
}
    800052f0:	60e2                	ld	ra,24(sp)
    800052f2:	6442                	ld	s0,16(sp)
    800052f4:	64a2                	ld	s1,8(sp)
    800052f6:	6105                	add	sp,sp,32
    800052f8:	8082                	ret

00000000800052fa <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052fa:	1141                	add	sp,sp,-16
    800052fc:	e406                	sd	ra,8(sp)
    800052fe:	e022                	sd	s0,0(sp)
    80005300:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005302:	479d                	li	a5,7
    80005304:	06a7c863          	blt	a5,a0,80005374 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005308:	00016717          	auipc	a4,0x16
    8000530c:	cf870713          	add	a4,a4,-776 # 8001b000 <disk>
    80005310:	972a                	add	a4,a4,a0
    80005312:	6789                	lui	a5,0x2
    80005314:	97ba                	add	a5,a5,a4
    80005316:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000531a:	e7ad                	bnez	a5,80005384 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000531c:	00451793          	sll	a5,a0,0x4
    80005320:	00018717          	auipc	a4,0x18
    80005324:	ce070713          	add	a4,a4,-800 # 8001d000 <disk+0x2000>
    80005328:	6314                	ld	a3,0(a4)
    8000532a:	96be                	add	a3,a3,a5
    8000532c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005330:	6314                	ld	a3,0(a4)
    80005332:	96be                	add	a3,a3,a5
    80005334:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005338:	6314                	ld	a3,0(a4)
    8000533a:	96be                	add	a3,a3,a5
    8000533c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005340:	6318                	ld	a4,0(a4)
    80005342:	97ba                	add	a5,a5,a4
    80005344:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005348:	00016717          	auipc	a4,0x16
    8000534c:	cb870713          	add	a4,a4,-840 # 8001b000 <disk>
    80005350:	972a                	add	a4,a4,a0
    80005352:	6789                	lui	a5,0x2
    80005354:	97ba                	add	a5,a5,a4
    80005356:	4705                	li	a4,1
    80005358:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000535c:	00018517          	auipc	a0,0x18
    80005360:	cbc50513          	add	a0,a0,-836 # 8001d018 <disk+0x2018>
    80005364:	ffffc097          	auipc	ra,0xffffc
    80005368:	3bc080e7          	jalr	956(ra) # 80001720 <wakeup>
}
    8000536c:	60a2                	ld	ra,8(sp)
    8000536e:	6402                	ld	s0,0(sp)
    80005370:	0141                	add	sp,sp,16
    80005372:	8082                	ret
    panic("free_desc 1");
    80005374:	00003517          	auipc	a0,0x3
    80005378:	33c50513          	add	a0,a0,828 # 800086b0 <etext+0x6b0>
    8000537c:	00001097          	auipc	ra,0x1
    80005380:	a10080e7          	jalr	-1520(ra) # 80005d8c <panic>
    panic("free_desc 2");
    80005384:	00003517          	auipc	a0,0x3
    80005388:	33c50513          	add	a0,a0,828 # 800086c0 <etext+0x6c0>
    8000538c:	00001097          	auipc	ra,0x1
    80005390:	a00080e7          	jalr	-1536(ra) # 80005d8c <panic>

0000000080005394 <virtio_disk_init>:
{
    80005394:	1141                	add	sp,sp,-16
    80005396:	e406                	sd	ra,8(sp)
    80005398:	e022                	sd	s0,0(sp)
    8000539a:	0800                	add	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000539c:	00003597          	auipc	a1,0x3
    800053a0:	33458593          	add	a1,a1,820 # 800086d0 <etext+0x6d0>
    800053a4:	00018517          	auipc	a0,0x18
    800053a8:	d8450513          	add	a0,a0,-636 # 8001d128 <disk+0x2128>
    800053ac:	00001097          	auipc	ra,0x1
    800053b0:	eca080e7          	jalr	-310(ra) # 80006276 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053b4:	100017b7          	lui	a5,0x10001
    800053b8:	4398                	lw	a4,0(a5)
    800053ba:	2701                	sext.w	a4,a4
    800053bc:	747277b7          	lui	a5,0x74727
    800053c0:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053c4:	0ef71f63          	bne	a4,a5,800054c2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053c8:	100017b7          	lui	a5,0x10001
    800053cc:	0791                	add	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800053ce:	439c                	lw	a5,0(a5)
    800053d0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053d2:	4705                	li	a4,1
    800053d4:	0ee79763          	bne	a5,a4,800054c2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053d8:	100017b7          	lui	a5,0x10001
    800053dc:	07a1                	add	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800053de:	439c                	lw	a5,0(a5)
    800053e0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053e2:	4709                	li	a4,2
    800053e4:	0ce79f63          	bne	a5,a4,800054c2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053e8:	100017b7          	lui	a5,0x10001
    800053ec:	47d8                	lw	a4,12(a5)
    800053ee:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053f0:	554d47b7          	lui	a5,0x554d4
    800053f4:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053f8:	0cf71563          	bne	a4,a5,800054c2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053fc:	100017b7          	lui	a5,0x10001
    80005400:	4705                	li	a4,1
    80005402:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005404:	470d                	li	a4,3
    80005406:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005408:	10001737          	lui	a4,0x10001
    8000540c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000540e:	c7ffe737          	lui	a4,0xc7ffe
    80005412:	75f70713          	add	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005416:	8ef9                	and	a3,a3,a4
    80005418:	10001737          	lui	a4,0x10001
    8000541c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000541e:	472d                	li	a4,11
    80005420:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005422:	473d                	li	a4,15
    80005424:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005426:	100017b7          	lui	a5,0x10001
    8000542a:	6705                	lui	a4,0x1
    8000542c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000542e:	100017b7          	lui	a5,0x10001
    80005432:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005436:	100017b7          	lui	a5,0x10001
    8000543a:	03478793          	add	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000543e:	439c                	lw	a5,0(a5)
    80005440:	2781                	sext.w	a5,a5
  if(max == 0)
    80005442:	cbc1                	beqz	a5,800054d2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005444:	471d                	li	a4,7
    80005446:	08f77e63          	bgeu	a4,a5,800054e2 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000544a:	100017b7          	lui	a5,0x10001
    8000544e:	4721                	li	a4,8
    80005450:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005452:	6609                	lui	a2,0x2
    80005454:	4581                	li	a1,0
    80005456:	00016517          	auipc	a0,0x16
    8000545a:	baa50513          	add	a0,a0,-1110 # 8001b000 <disk>
    8000545e:	ffffb097          	auipc	ra,0xffffb
    80005462:	d66080e7          	jalr	-666(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005466:	00016697          	auipc	a3,0x16
    8000546a:	b9a68693          	add	a3,a3,-1126 # 8001b000 <disk>
    8000546e:	00c6d713          	srl	a4,a3,0xc
    80005472:	2701                	sext.w	a4,a4
    80005474:	100017b7          	lui	a5,0x10001
    80005478:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000547a:	00018797          	auipc	a5,0x18
    8000547e:	b8678793          	add	a5,a5,-1146 # 8001d000 <disk+0x2000>
    80005482:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005484:	00016717          	auipc	a4,0x16
    80005488:	bfc70713          	add	a4,a4,-1028 # 8001b080 <disk+0x80>
    8000548c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000548e:	00017717          	auipc	a4,0x17
    80005492:	b7270713          	add	a4,a4,-1166 # 8001c000 <disk+0x1000>
    80005496:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005498:	4705                	li	a4,1
    8000549a:	00e78c23          	sb	a4,24(a5)
    8000549e:	00e78ca3          	sb	a4,25(a5)
    800054a2:	00e78d23          	sb	a4,26(a5)
    800054a6:	00e78da3          	sb	a4,27(a5)
    800054aa:	00e78e23          	sb	a4,28(a5)
    800054ae:	00e78ea3          	sb	a4,29(a5)
    800054b2:	00e78f23          	sb	a4,30(a5)
    800054b6:	00e78fa3          	sb	a4,31(a5)
}
    800054ba:	60a2                	ld	ra,8(sp)
    800054bc:	6402                	ld	s0,0(sp)
    800054be:	0141                	add	sp,sp,16
    800054c0:	8082                	ret
    panic("could not find virtio disk");
    800054c2:	00003517          	auipc	a0,0x3
    800054c6:	21e50513          	add	a0,a0,542 # 800086e0 <etext+0x6e0>
    800054ca:	00001097          	auipc	ra,0x1
    800054ce:	8c2080e7          	jalr	-1854(ra) # 80005d8c <panic>
    panic("virtio disk has no queue 0");
    800054d2:	00003517          	auipc	a0,0x3
    800054d6:	22e50513          	add	a0,a0,558 # 80008700 <etext+0x700>
    800054da:	00001097          	auipc	ra,0x1
    800054de:	8b2080e7          	jalr	-1870(ra) # 80005d8c <panic>
    panic("virtio disk max queue too short");
    800054e2:	00003517          	auipc	a0,0x3
    800054e6:	23e50513          	add	a0,a0,574 # 80008720 <etext+0x720>
    800054ea:	00001097          	auipc	ra,0x1
    800054ee:	8a2080e7          	jalr	-1886(ra) # 80005d8c <panic>

00000000800054f2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054f2:	7159                	add	sp,sp,-112
    800054f4:	f486                	sd	ra,104(sp)
    800054f6:	f0a2                	sd	s0,96(sp)
    800054f8:	eca6                	sd	s1,88(sp)
    800054fa:	e8ca                	sd	s2,80(sp)
    800054fc:	e4ce                	sd	s3,72(sp)
    800054fe:	e0d2                	sd	s4,64(sp)
    80005500:	fc56                	sd	s5,56(sp)
    80005502:	f85a                	sd	s6,48(sp)
    80005504:	f45e                	sd	s7,40(sp)
    80005506:	f062                	sd	s8,32(sp)
    80005508:	ec66                	sd	s9,24(sp)
    8000550a:	1880                	add	s0,sp,112
    8000550c:	8a2a                	mv	s4,a0
    8000550e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005510:	00c52c03          	lw	s8,12(a0)
    80005514:	001c1c1b          	sllw	s8,s8,0x1
    80005518:	1c02                	sll	s8,s8,0x20
    8000551a:	020c5c13          	srl	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000551e:	00018517          	auipc	a0,0x18
    80005522:	c0a50513          	add	a0,a0,-1014 # 8001d128 <disk+0x2128>
    80005526:	00001097          	auipc	ra,0x1
    8000552a:	de0080e7          	jalr	-544(ra) # 80006306 <acquire>
  for(int i = 0; i < 3; i++){
    8000552e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005530:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005532:	00016b97          	auipc	s7,0x16
    80005536:	aceb8b93          	add	s7,s7,-1330 # 8001b000 <disk>
    8000553a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000553c:	4a8d                	li	s5,3
    8000553e:	a88d                	j	800055b0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005540:	00fb8733          	add	a4,s7,a5
    80005544:	975a                	add	a4,a4,s6
    80005546:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000554a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000554c:	0207c563          	bltz	a5,80005576 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005550:	2905                	addw	s2,s2,1
    80005552:	0611                	add	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005554:	1b590163          	beq	s2,s5,800056f6 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005558:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000555a:	00018717          	auipc	a4,0x18
    8000555e:	abe70713          	add	a4,a4,-1346 # 8001d018 <disk+0x2018>
    80005562:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005564:	00074683          	lbu	a3,0(a4)
    80005568:	fee1                	bnez	a3,80005540 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000556a:	2785                	addw	a5,a5,1
    8000556c:	0705                	add	a4,a4,1
    8000556e:	fe979be3          	bne	a5,s1,80005564 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005572:	57fd                	li	a5,-1
    80005574:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005576:	03205163          	blez	s2,80005598 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000557a:	f9042503          	lw	a0,-112(s0)
    8000557e:	00000097          	auipc	ra,0x0
    80005582:	d7c080e7          	jalr	-644(ra) # 800052fa <free_desc>
      for(int j = 0; j < i; j++)
    80005586:	4785                	li	a5,1
    80005588:	0127d863          	bge	a5,s2,80005598 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000558c:	f9442503          	lw	a0,-108(s0)
    80005590:	00000097          	auipc	ra,0x0
    80005594:	d6a080e7          	jalr	-662(ra) # 800052fa <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005598:	00018597          	auipc	a1,0x18
    8000559c:	b9058593          	add	a1,a1,-1136 # 8001d128 <disk+0x2128>
    800055a0:	00018517          	auipc	a0,0x18
    800055a4:	a7850513          	add	a0,a0,-1416 # 8001d018 <disk+0x2018>
    800055a8:	ffffc097          	auipc	ra,0xffffc
    800055ac:	fec080e7          	jalr	-20(ra) # 80001594 <sleep>
  for(int i = 0; i < 3; i++){
    800055b0:	f9040613          	add	a2,s0,-112
    800055b4:	894e                	mv	s2,s3
    800055b6:	b74d                	j	80005558 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055b8:	00018717          	auipc	a4,0x18
    800055bc:	a4873703          	ld	a4,-1464(a4) # 8001d000 <disk+0x2000>
    800055c0:	973e                	add	a4,a4,a5
    800055c2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055c6:	00016897          	auipc	a7,0x16
    800055ca:	a3a88893          	add	a7,a7,-1478 # 8001b000 <disk>
    800055ce:	00018717          	auipc	a4,0x18
    800055d2:	a3270713          	add	a4,a4,-1486 # 8001d000 <disk+0x2000>
    800055d6:	6314                	ld	a3,0(a4)
    800055d8:	96be                	add	a3,a3,a5
    800055da:	00c6d583          	lhu	a1,12(a3)
    800055de:	0015e593          	or	a1,a1,1
    800055e2:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055e6:	f9842683          	lw	a3,-104(s0)
    800055ea:	630c                	ld	a1,0(a4)
    800055ec:	97ae                	add	a5,a5,a1
    800055ee:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055f2:	20050593          	add	a1,a0,512
    800055f6:	0592                	sll	a1,a1,0x4
    800055f8:	95c6                	add	a1,a1,a7
    800055fa:	57fd                	li	a5,-1
    800055fc:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005600:	00469793          	sll	a5,a3,0x4
    80005604:	00073803          	ld	a6,0(a4)
    80005608:	983e                	add	a6,a6,a5
    8000560a:	6689                	lui	a3,0x2
    8000560c:	03068693          	add	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005610:	96b2                	add	a3,a3,a2
    80005612:	96c6                	add	a3,a3,a7
    80005614:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005618:	6314                	ld	a3,0(a4)
    8000561a:	96be                	add	a3,a3,a5
    8000561c:	4605                	li	a2,1
    8000561e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005620:	6314                	ld	a3,0(a4)
    80005622:	96be                	add	a3,a3,a5
    80005624:	4809                	li	a6,2
    80005626:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000562a:	6314                	ld	a3,0(a4)
    8000562c:	97b6                	add	a5,a5,a3
    8000562e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005632:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005636:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000563a:	6714                	ld	a3,8(a4)
    8000563c:	0026d783          	lhu	a5,2(a3)
    80005640:	8b9d                	and	a5,a5,7
    80005642:	0786                	sll	a5,a5,0x1
    80005644:	96be                	add	a3,a3,a5
    80005646:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000564a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000564e:	6718                	ld	a4,8(a4)
    80005650:	00275783          	lhu	a5,2(a4)
    80005654:	2785                	addw	a5,a5,1
    80005656:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000565a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000565e:	100017b7          	lui	a5,0x10001
    80005662:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005666:	004a2783          	lw	a5,4(s4)
    8000566a:	02c79163          	bne	a5,a2,8000568c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000566e:	00018917          	auipc	s2,0x18
    80005672:	aba90913          	add	s2,s2,-1350 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005676:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005678:	85ca                	mv	a1,s2
    8000567a:	8552                	mv	a0,s4
    8000567c:	ffffc097          	auipc	ra,0xffffc
    80005680:	f18080e7          	jalr	-232(ra) # 80001594 <sleep>
  while(b->disk == 1) {
    80005684:	004a2783          	lw	a5,4(s4)
    80005688:	fe9788e3          	beq	a5,s1,80005678 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000568c:	f9042903          	lw	s2,-112(s0)
    80005690:	20090713          	add	a4,s2,512
    80005694:	0712                	sll	a4,a4,0x4
    80005696:	00016797          	auipc	a5,0x16
    8000569a:	96a78793          	add	a5,a5,-1686 # 8001b000 <disk>
    8000569e:	97ba                	add	a5,a5,a4
    800056a0:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056a4:	00018997          	auipc	s3,0x18
    800056a8:	95c98993          	add	s3,s3,-1700 # 8001d000 <disk+0x2000>
    800056ac:	00491713          	sll	a4,s2,0x4
    800056b0:	0009b783          	ld	a5,0(s3)
    800056b4:	97ba                	add	a5,a5,a4
    800056b6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056ba:	854a                	mv	a0,s2
    800056bc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056c0:	00000097          	auipc	ra,0x0
    800056c4:	c3a080e7          	jalr	-966(ra) # 800052fa <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056c8:	8885                	and	s1,s1,1
    800056ca:	f0ed                	bnez	s1,800056ac <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056cc:	00018517          	auipc	a0,0x18
    800056d0:	a5c50513          	add	a0,a0,-1444 # 8001d128 <disk+0x2128>
    800056d4:	00001097          	auipc	ra,0x1
    800056d8:	ce6080e7          	jalr	-794(ra) # 800063ba <release>
}
    800056dc:	70a6                	ld	ra,104(sp)
    800056de:	7406                	ld	s0,96(sp)
    800056e0:	64e6                	ld	s1,88(sp)
    800056e2:	6946                	ld	s2,80(sp)
    800056e4:	69a6                	ld	s3,72(sp)
    800056e6:	6a06                	ld	s4,64(sp)
    800056e8:	7ae2                	ld	s5,56(sp)
    800056ea:	7b42                	ld	s6,48(sp)
    800056ec:	7ba2                	ld	s7,40(sp)
    800056ee:	7c02                	ld	s8,32(sp)
    800056f0:	6ce2                	ld	s9,24(sp)
    800056f2:	6165                	add	sp,sp,112
    800056f4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056f6:	f9042503          	lw	a0,-112(s0)
    800056fa:	00451613          	sll	a2,a0,0x4
  if(write)
    800056fe:	00016597          	auipc	a1,0x16
    80005702:	90258593          	add	a1,a1,-1790 # 8001b000 <disk>
    80005706:	20050793          	add	a5,a0,512
    8000570a:	0792                	sll	a5,a5,0x4
    8000570c:	97ae                	add	a5,a5,a1
    8000570e:	01903733          	snez	a4,s9
    80005712:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005716:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000571a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000571e:	00018717          	auipc	a4,0x18
    80005722:	8e270713          	add	a4,a4,-1822 # 8001d000 <disk+0x2000>
    80005726:	6314                	ld	a3,0(a4)
    80005728:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000572a:	6789                	lui	a5,0x2
    8000572c:	0a878793          	add	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005730:	97b2                	add	a5,a5,a2
    80005732:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005734:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005736:	631c                	ld	a5,0(a4)
    80005738:	97b2                	add	a5,a5,a2
    8000573a:	46c1                	li	a3,16
    8000573c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000573e:	631c                	ld	a5,0(a4)
    80005740:	97b2                	add	a5,a5,a2
    80005742:	4685                	li	a3,1
    80005744:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005748:	f9442783          	lw	a5,-108(s0)
    8000574c:	6314                	ld	a3,0(a4)
    8000574e:	96b2                	add	a3,a3,a2
    80005750:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005754:	0792                	sll	a5,a5,0x4
    80005756:	6314                	ld	a3,0(a4)
    80005758:	96be                	add	a3,a3,a5
    8000575a:	058a0593          	add	a1,s4,88
    8000575e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005760:	6318                	ld	a4,0(a4)
    80005762:	973e                	add	a4,a4,a5
    80005764:	40000693          	li	a3,1024
    80005768:	c714                	sw	a3,8(a4)
  if(write)
    8000576a:	e40c97e3          	bnez	s9,800055b8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000576e:	00018717          	auipc	a4,0x18
    80005772:	89273703          	ld	a4,-1902(a4) # 8001d000 <disk+0x2000>
    80005776:	973e                	add	a4,a4,a5
    80005778:	4689                	li	a3,2
    8000577a:	00d71623          	sh	a3,12(a4)
    8000577e:	b5a1                	j	800055c6 <virtio_disk_rw+0xd4>

0000000080005780 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005780:	1101                	add	sp,sp,-32
    80005782:	ec06                	sd	ra,24(sp)
    80005784:	e822                	sd	s0,16(sp)
    80005786:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005788:	00018517          	auipc	a0,0x18
    8000578c:	9a050513          	add	a0,a0,-1632 # 8001d128 <disk+0x2128>
    80005790:	00001097          	auipc	ra,0x1
    80005794:	b76080e7          	jalr	-1162(ra) # 80006306 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005798:	100017b7          	lui	a5,0x10001
    8000579c:	53b8                	lw	a4,96(a5)
    8000579e:	8b0d                	and	a4,a4,3
    800057a0:	100017b7          	lui	a5,0x10001
    800057a4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800057a6:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057aa:	00018797          	auipc	a5,0x18
    800057ae:	85678793          	add	a5,a5,-1962 # 8001d000 <disk+0x2000>
    800057b2:	6b94                	ld	a3,16(a5)
    800057b4:	0207d703          	lhu	a4,32(a5)
    800057b8:	0026d783          	lhu	a5,2(a3)
    800057bc:	06f70563          	beq	a4,a5,80005826 <virtio_disk_intr+0xa6>
    800057c0:	e426                	sd	s1,8(sp)
    800057c2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057c4:	00016917          	auipc	s2,0x16
    800057c8:	83c90913          	add	s2,s2,-1988 # 8001b000 <disk>
    800057cc:	00018497          	auipc	s1,0x18
    800057d0:	83448493          	add	s1,s1,-1996 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800057d4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057d8:	6898                	ld	a4,16(s1)
    800057da:	0204d783          	lhu	a5,32(s1)
    800057de:	8b9d                	and	a5,a5,7
    800057e0:	078e                	sll	a5,a5,0x3
    800057e2:	97ba                	add	a5,a5,a4
    800057e4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057e6:	20078713          	add	a4,a5,512
    800057ea:	0712                	sll	a4,a4,0x4
    800057ec:	974a                	add	a4,a4,s2
    800057ee:	03074703          	lbu	a4,48(a4)
    800057f2:	e731                	bnez	a4,8000583e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057f4:	20078793          	add	a5,a5,512
    800057f8:	0792                	sll	a5,a5,0x4
    800057fa:	97ca                	add	a5,a5,s2
    800057fc:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057fe:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005802:	ffffc097          	auipc	ra,0xffffc
    80005806:	f1e080e7          	jalr	-226(ra) # 80001720 <wakeup>

    disk.used_idx += 1;
    8000580a:	0204d783          	lhu	a5,32(s1)
    8000580e:	2785                	addw	a5,a5,1
    80005810:	17c2                	sll	a5,a5,0x30
    80005812:	93c1                	srl	a5,a5,0x30
    80005814:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005818:	6898                	ld	a4,16(s1)
    8000581a:	00275703          	lhu	a4,2(a4)
    8000581e:	faf71be3          	bne	a4,a5,800057d4 <virtio_disk_intr+0x54>
    80005822:	64a2                	ld	s1,8(sp)
    80005824:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005826:	00018517          	auipc	a0,0x18
    8000582a:	90250513          	add	a0,a0,-1790 # 8001d128 <disk+0x2128>
    8000582e:	00001097          	auipc	ra,0x1
    80005832:	b8c080e7          	jalr	-1140(ra) # 800063ba <release>
}
    80005836:	60e2                	ld	ra,24(sp)
    80005838:	6442                	ld	s0,16(sp)
    8000583a:	6105                	add	sp,sp,32
    8000583c:	8082                	ret
      panic("virtio_disk_intr status");
    8000583e:	00003517          	auipc	a0,0x3
    80005842:	f0250513          	add	a0,a0,-254 # 80008740 <etext+0x740>
    80005846:	00000097          	auipc	ra,0x0
    8000584a:	546080e7          	jalr	1350(ra) # 80005d8c <panic>

000000008000584e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000584e:	1141                	add	sp,sp,-16
    80005850:	e422                	sd	s0,8(sp)
    80005852:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005854:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005858:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000585c:	0037979b          	sllw	a5,a5,0x3
    80005860:	02004737          	lui	a4,0x2004
    80005864:	97ba                	add	a5,a5,a4
    80005866:	0200c737          	lui	a4,0x200c
    8000586a:	1761                	add	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000586c:	6318                	ld	a4,0(a4)
    8000586e:	000f4637          	lui	a2,0xf4
    80005872:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005876:	9732                	add	a4,a4,a2
    80005878:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000587a:	00259693          	sll	a3,a1,0x2
    8000587e:	96ae                	add	a3,a3,a1
    80005880:	068e                	sll	a3,a3,0x3
    80005882:	00018717          	auipc	a4,0x18
    80005886:	77e70713          	add	a4,a4,1918 # 8001e000 <timer_scratch>
    8000588a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000588c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000588e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005890:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005894:	00000797          	auipc	a5,0x0
    80005898:	99c78793          	add	a5,a5,-1636 # 80005230 <timervec>
    8000589c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058a0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058a4:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058ac:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058b0:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058b4:	30479073          	csrw	mie,a5
}
    800058b8:	6422                	ld	s0,8(sp)
    800058ba:	0141                	add	sp,sp,16
    800058bc:	8082                	ret

00000000800058be <start>:
{
    800058be:	1141                	add	sp,sp,-16
    800058c0:	e406                	sd	ra,8(sp)
    800058c2:	e022                	sd	s0,0(sp)
    800058c4:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058c6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058ca:	7779                	lui	a4,0xffffe
    800058cc:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800058d0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058d2:	6705                	lui	a4,0x1
    800058d4:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058d8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058da:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058de:	ffffb797          	auipc	a5,0xffffb
    800058e2:	a8478793          	add	a5,a5,-1404 # 80000362 <main>
    800058e6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058ea:	4781                	li	a5,0
    800058ec:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058f0:	67c1                	lui	a5,0x10
    800058f2:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058f4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058f8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058fc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005900:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005904:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005908:	57fd                	li	a5,-1
    8000590a:	83a9                	srl	a5,a5,0xa
    8000590c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005910:	47bd                	li	a5,15
    80005912:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005916:	00000097          	auipc	ra,0x0
    8000591a:	f38080e7          	jalr	-200(ra) # 8000584e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000591e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005922:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005924:	823e                	mv	tp,a5
  asm volatile("mret");
    80005926:	30200073          	mret
}
    8000592a:	60a2                	ld	ra,8(sp)
    8000592c:	6402                	ld	s0,0(sp)
    8000592e:	0141                	add	sp,sp,16
    80005930:	8082                	ret

0000000080005932 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005932:	715d                	add	sp,sp,-80
    80005934:	e486                	sd	ra,72(sp)
    80005936:	e0a2                	sd	s0,64(sp)
    80005938:	f84a                	sd	s2,48(sp)
    8000593a:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000593c:	04c05663          	blez	a2,80005988 <consolewrite+0x56>
    80005940:	fc26                	sd	s1,56(sp)
    80005942:	f44e                	sd	s3,40(sp)
    80005944:	f052                	sd	s4,32(sp)
    80005946:	ec56                	sd	s5,24(sp)
    80005948:	8a2a                	mv	s4,a0
    8000594a:	84ae                	mv	s1,a1
    8000594c:	89b2                	mv	s3,a2
    8000594e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005950:	5afd                	li	s5,-1
    80005952:	4685                	li	a3,1
    80005954:	8626                	mv	a2,s1
    80005956:	85d2                	mv	a1,s4
    80005958:	fbf40513          	add	a0,s0,-65
    8000595c:	ffffc097          	auipc	ra,0xffffc
    80005960:	032080e7          	jalr	50(ra) # 8000198e <either_copyin>
    80005964:	03550463          	beq	a0,s5,8000598c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005968:	fbf44503          	lbu	a0,-65(s0)
    8000596c:	00000097          	auipc	ra,0x0
    80005970:	7de080e7          	jalr	2014(ra) # 8000614a <uartputc>
  for(i = 0; i < n; i++){
    80005974:	2905                	addw	s2,s2,1
    80005976:	0485                	add	s1,s1,1
    80005978:	fd299de3          	bne	s3,s2,80005952 <consolewrite+0x20>
    8000597c:	894e                	mv	s2,s3
    8000597e:	74e2                	ld	s1,56(sp)
    80005980:	79a2                	ld	s3,40(sp)
    80005982:	7a02                	ld	s4,32(sp)
    80005984:	6ae2                	ld	s5,24(sp)
    80005986:	a039                	j	80005994 <consolewrite+0x62>
    80005988:	4901                	li	s2,0
    8000598a:	a029                	j	80005994 <consolewrite+0x62>
    8000598c:	74e2                	ld	s1,56(sp)
    8000598e:	79a2                	ld	s3,40(sp)
    80005990:	7a02                	ld	s4,32(sp)
    80005992:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005994:	854a                	mv	a0,s2
    80005996:	60a6                	ld	ra,72(sp)
    80005998:	6406                	ld	s0,64(sp)
    8000599a:	7942                	ld	s2,48(sp)
    8000599c:	6161                	add	sp,sp,80
    8000599e:	8082                	ret

00000000800059a0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059a0:	711d                	add	sp,sp,-96
    800059a2:	ec86                	sd	ra,88(sp)
    800059a4:	e8a2                	sd	s0,80(sp)
    800059a6:	e4a6                	sd	s1,72(sp)
    800059a8:	e0ca                	sd	s2,64(sp)
    800059aa:	fc4e                	sd	s3,56(sp)
    800059ac:	f852                	sd	s4,48(sp)
    800059ae:	f456                	sd	s5,40(sp)
    800059b0:	f05a                	sd	s6,32(sp)
    800059b2:	1080                	add	s0,sp,96
    800059b4:	8aaa                	mv	s5,a0
    800059b6:	8a2e                	mv	s4,a1
    800059b8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059ba:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059be:	00020517          	auipc	a0,0x20
    800059c2:	78250513          	add	a0,a0,1922 # 80026140 <cons>
    800059c6:	00001097          	auipc	ra,0x1
    800059ca:	940080e7          	jalr	-1728(ra) # 80006306 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059ce:	00020497          	auipc	s1,0x20
    800059d2:	77248493          	add	s1,s1,1906 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059d6:	00021917          	auipc	s2,0x21
    800059da:	80290913          	add	s2,s2,-2046 # 800261d8 <cons+0x98>
  while(n > 0){
    800059de:	0d305463          	blez	s3,80005aa6 <consoleread+0x106>
    while(cons.r == cons.w){
    800059e2:	0984a783          	lw	a5,152(s1)
    800059e6:	09c4a703          	lw	a4,156(s1)
    800059ea:	0af71963          	bne	a4,a5,80005a9c <consoleread+0xfc>
      if(myproc()->killed){
    800059ee:	ffffb097          	auipc	ra,0xffffb
    800059f2:	4d8080e7          	jalr	1240(ra) # 80000ec6 <myproc>
    800059f6:	551c                	lw	a5,40(a0)
    800059f8:	e7ad                	bnez	a5,80005a62 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    800059fa:	85a6                	mv	a1,s1
    800059fc:	854a                	mv	a0,s2
    800059fe:	ffffc097          	auipc	ra,0xffffc
    80005a02:	b96080e7          	jalr	-1130(ra) # 80001594 <sleep>
    while(cons.r == cons.w){
    80005a06:	0984a783          	lw	a5,152(s1)
    80005a0a:	09c4a703          	lw	a4,156(s1)
    80005a0e:	fef700e3          	beq	a4,a5,800059ee <consoleread+0x4e>
    80005a12:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a14:	00020717          	auipc	a4,0x20
    80005a18:	72c70713          	add	a4,a4,1836 # 80026140 <cons>
    80005a1c:	0017869b          	addw	a3,a5,1
    80005a20:	08d72c23          	sw	a3,152(a4)
    80005a24:	07f7f693          	and	a3,a5,127
    80005a28:	9736                	add	a4,a4,a3
    80005a2a:	01874703          	lbu	a4,24(a4)
    80005a2e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a32:	4691                	li	a3,4
    80005a34:	04db8a63          	beq	s7,a3,80005a88 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a38:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a3c:	4685                	li	a3,1
    80005a3e:	faf40613          	add	a2,s0,-81
    80005a42:	85d2                	mv	a1,s4
    80005a44:	8556                	mv	a0,s5
    80005a46:	ffffc097          	auipc	ra,0xffffc
    80005a4a:	ef2080e7          	jalr	-270(ra) # 80001938 <either_copyout>
    80005a4e:	57fd                	li	a5,-1
    80005a50:	04f50a63          	beq	a0,a5,80005aa4 <consoleread+0x104>
      break;

    dst++;
    80005a54:	0a05                	add	s4,s4,1
    --n;
    80005a56:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80005a58:	47a9                	li	a5,10
    80005a5a:	06fb8163          	beq	s7,a5,80005abc <consoleread+0x11c>
    80005a5e:	6be2                	ld	s7,24(sp)
    80005a60:	bfbd                	j	800059de <consoleread+0x3e>
        release(&cons.lock);
    80005a62:	00020517          	auipc	a0,0x20
    80005a66:	6de50513          	add	a0,a0,1758 # 80026140 <cons>
    80005a6a:	00001097          	auipc	ra,0x1
    80005a6e:	950080e7          	jalr	-1712(ra) # 800063ba <release>
        return -1;
    80005a72:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005a74:	60e6                	ld	ra,88(sp)
    80005a76:	6446                	ld	s0,80(sp)
    80005a78:	64a6                	ld	s1,72(sp)
    80005a7a:	6906                	ld	s2,64(sp)
    80005a7c:	79e2                	ld	s3,56(sp)
    80005a7e:	7a42                	ld	s4,48(sp)
    80005a80:	7aa2                	ld	s5,40(sp)
    80005a82:	7b02                	ld	s6,32(sp)
    80005a84:	6125                	add	sp,sp,96
    80005a86:	8082                	ret
      if(n < target){
    80005a88:	0009871b          	sext.w	a4,s3
    80005a8c:	01677a63          	bgeu	a4,s6,80005aa0 <consoleread+0x100>
        cons.r--;
    80005a90:	00020717          	auipc	a4,0x20
    80005a94:	74f72423          	sw	a5,1864(a4) # 800261d8 <cons+0x98>
    80005a98:	6be2                	ld	s7,24(sp)
    80005a9a:	a031                	j	80005aa6 <consoleread+0x106>
    80005a9c:	ec5e                	sd	s7,24(sp)
    80005a9e:	bf9d                	j	80005a14 <consoleread+0x74>
    80005aa0:	6be2                	ld	s7,24(sp)
    80005aa2:	a011                	j	80005aa6 <consoleread+0x106>
    80005aa4:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005aa6:	00020517          	auipc	a0,0x20
    80005aaa:	69a50513          	add	a0,a0,1690 # 80026140 <cons>
    80005aae:	00001097          	auipc	ra,0x1
    80005ab2:	90c080e7          	jalr	-1780(ra) # 800063ba <release>
  return target - n;
    80005ab6:	413b053b          	subw	a0,s6,s3
    80005aba:	bf6d                	j	80005a74 <consoleread+0xd4>
    80005abc:	6be2                	ld	s7,24(sp)
    80005abe:	b7e5                	j	80005aa6 <consoleread+0x106>

0000000080005ac0 <consputc>:
{
    80005ac0:	1141                	add	sp,sp,-16
    80005ac2:	e406                	sd	ra,8(sp)
    80005ac4:	e022                	sd	s0,0(sp)
    80005ac6:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80005ac8:	10000793          	li	a5,256
    80005acc:	00f50a63          	beq	a0,a5,80005ae0 <consputc+0x20>
    uartputc_sync(c);
    80005ad0:	00000097          	auipc	ra,0x0
    80005ad4:	59c080e7          	jalr	1436(ra) # 8000606c <uartputc_sync>
}
    80005ad8:	60a2                	ld	ra,8(sp)
    80005ada:	6402                	ld	s0,0(sp)
    80005adc:	0141                	add	sp,sp,16
    80005ade:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ae0:	4521                	li	a0,8
    80005ae2:	00000097          	auipc	ra,0x0
    80005ae6:	58a080e7          	jalr	1418(ra) # 8000606c <uartputc_sync>
    80005aea:	02000513          	li	a0,32
    80005aee:	00000097          	auipc	ra,0x0
    80005af2:	57e080e7          	jalr	1406(ra) # 8000606c <uartputc_sync>
    80005af6:	4521                	li	a0,8
    80005af8:	00000097          	auipc	ra,0x0
    80005afc:	574080e7          	jalr	1396(ra) # 8000606c <uartputc_sync>
    80005b00:	bfe1                	j	80005ad8 <consputc+0x18>

0000000080005b02 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b02:	1101                	add	sp,sp,-32
    80005b04:	ec06                	sd	ra,24(sp)
    80005b06:	e822                	sd	s0,16(sp)
    80005b08:	e426                	sd	s1,8(sp)
    80005b0a:	1000                	add	s0,sp,32
    80005b0c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b0e:	00020517          	auipc	a0,0x20
    80005b12:	63250513          	add	a0,a0,1586 # 80026140 <cons>
    80005b16:	00000097          	auipc	ra,0x0
    80005b1a:	7f0080e7          	jalr	2032(ra) # 80006306 <acquire>

  switch(c){
    80005b1e:	47d5                	li	a5,21
    80005b20:	0af48563          	beq	s1,a5,80005bca <consoleintr+0xc8>
    80005b24:	0297c963          	blt	a5,s1,80005b56 <consoleintr+0x54>
    80005b28:	47a1                	li	a5,8
    80005b2a:	0ef48c63          	beq	s1,a5,80005c22 <consoleintr+0x120>
    80005b2e:	47c1                	li	a5,16
    80005b30:	10f49f63          	bne	s1,a5,80005c4e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005b34:	ffffc097          	auipc	ra,0xffffc
    80005b38:	eb0080e7          	jalr	-336(ra) # 800019e4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b3c:	00020517          	auipc	a0,0x20
    80005b40:	60450513          	add	a0,a0,1540 # 80026140 <cons>
    80005b44:	00001097          	auipc	ra,0x1
    80005b48:	876080e7          	jalr	-1930(ra) # 800063ba <release>
}
    80005b4c:	60e2                	ld	ra,24(sp)
    80005b4e:	6442                	ld	s0,16(sp)
    80005b50:	64a2                	ld	s1,8(sp)
    80005b52:	6105                	add	sp,sp,32
    80005b54:	8082                	ret
  switch(c){
    80005b56:	07f00793          	li	a5,127
    80005b5a:	0cf48463          	beq	s1,a5,80005c22 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b5e:	00020717          	auipc	a4,0x20
    80005b62:	5e270713          	add	a4,a4,1506 # 80026140 <cons>
    80005b66:	0a072783          	lw	a5,160(a4)
    80005b6a:	09872703          	lw	a4,152(a4)
    80005b6e:	9f99                	subw	a5,a5,a4
    80005b70:	07f00713          	li	a4,127
    80005b74:	fcf764e3          	bltu	a4,a5,80005b3c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005b78:	47b5                	li	a5,13
    80005b7a:	0cf48d63          	beq	s1,a5,80005c54 <consoleintr+0x152>
      consputc(c);
    80005b7e:	8526                	mv	a0,s1
    80005b80:	00000097          	auipc	ra,0x0
    80005b84:	f40080e7          	jalr	-192(ra) # 80005ac0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b88:	00020797          	auipc	a5,0x20
    80005b8c:	5b878793          	add	a5,a5,1464 # 80026140 <cons>
    80005b90:	0a07a703          	lw	a4,160(a5)
    80005b94:	0017069b          	addw	a3,a4,1
    80005b98:	0006861b          	sext.w	a2,a3
    80005b9c:	0ad7a023          	sw	a3,160(a5)
    80005ba0:	07f77713          	and	a4,a4,127
    80005ba4:	97ba                	add	a5,a5,a4
    80005ba6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005baa:	47a9                	li	a5,10
    80005bac:	0cf48b63          	beq	s1,a5,80005c82 <consoleintr+0x180>
    80005bb0:	4791                	li	a5,4
    80005bb2:	0cf48863          	beq	s1,a5,80005c82 <consoleintr+0x180>
    80005bb6:	00020797          	auipc	a5,0x20
    80005bba:	6227a783          	lw	a5,1570(a5) # 800261d8 <cons+0x98>
    80005bbe:	0807879b          	addw	a5,a5,128
    80005bc2:	f6f61de3          	bne	a2,a5,80005b3c <consoleintr+0x3a>
    80005bc6:	863e                	mv	a2,a5
    80005bc8:	a86d                	j	80005c82 <consoleintr+0x180>
    80005bca:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005bcc:	00020717          	auipc	a4,0x20
    80005bd0:	57470713          	add	a4,a4,1396 # 80026140 <cons>
    80005bd4:	0a072783          	lw	a5,160(a4)
    80005bd8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bdc:	00020497          	auipc	s1,0x20
    80005be0:	56448493          	add	s1,s1,1380 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005be4:	4929                	li	s2,10
    80005be6:	02f70a63          	beq	a4,a5,80005c1a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bea:	37fd                	addw	a5,a5,-1
    80005bec:	07f7f713          	and	a4,a5,127
    80005bf0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bf2:	01874703          	lbu	a4,24(a4)
    80005bf6:	03270463          	beq	a4,s2,80005c1e <consoleintr+0x11c>
      cons.e--;
    80005bfa:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bfe:	10000513          	li	a0,256
    80005c02:	00000097          	auipc	ra,0x0
    80005c06:	ebe080e7          	jalr	-322(ra) # 80005ac0 <consputc>
    while(cons.e != cons.w &&
    80005c0a:	0a04a783          	lw	a5,160(s1)
    80005c0e:	09c4a703          	lw	a4,156(s1)
    80005c12:	fcf71ce3          	bne	a4,a5,80005bea <consoleintr+0xe8>
    80005c16:	6902                	ld	s2,0(sp)
    80005c18:	b715                	j	80005b3c <consoleintr+0x3a>
    80005c1a:	6902                	ld	s2,0(sp)
    80005c1c:	b705                	j	80005b3c <consoleintr+0x3a>
    80005c1e:	6902                	ld	s2,0(sp)
    80005c20:	bf31                	j	80005b3c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005c22:	00020717          	auipc	a4,0x20
    80005c26:	51e70713          	add	a4,a4,1310 # 80026140 <cons>
    80005c2a:	0a072783          	lw	a5,160(a4)
    80005c2e:	09c72703          	lw	a4,156(a4)
    80005c32:	f0f705e3          	beq	a4,a5,80005b3c <consoleintr+0x3a>
      cons.e--;
    80005c36:	37fd                	addw	a5,a5,-1
    80005c38:	00020717          	auipc	a4,0x20
    80005c3c:	5af72423          	sw	a5,1448(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c40:	10000513          	li	a0,256
    80005c44:	00000097          	auipc	ra,0x0
    80005c48:	e7c080e7          	jalr	-388(ra) # 80005ac0 <consputc>
    80005c4c:	bdc5                	j	80005b3c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c4e:	ee0487e3          	beqz	s1,80005b3c <consoleintr+0x3a>
    80005c52:	b731                	j	80005b5e <consoleintr+0x5c>
      consputc(c);
    80005c54:	4529                	li	a0,10
    80005c56:	00000097          	auipc	ra,0x0
    80005c5a:	e6a080e7          	jalr	-406(ra) # 80005ac0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c5e:	00020797          	auipc	a5,0x20
    80005c62:	4e278793          	add	a5,a5,1250 # 80026140 <cons>
    80005c66:	0a07a703          	lw	a4,160(a5)
    80005c6a:	0017069b          	addw	a3,a4,1
    80005c6e:	0006861b          	sext.w	a2,a3
    80005c72:	0ad7a023          	sw	a3,160(a5)
    80005c76:	07f77713          	and	a4,a4,127
    80005c7a:	97ba                	add	a5,a5,a4
    80005c7c:	4729                	li	a4,10
    80005c7e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c82:	00020797          	auipc	a5,0x20
    80005c86:	54c7ad23          	sw	a2,1370(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c8a:	00020517          	auipc	a0,0x20
    80005c8e:	54e50513          	add	a0,a0,1358 # 800261d8 <cons+0x98>
    80005c92:	ffffc097          	auipc	ra,0xffffc
    80005c96:	a8e080e7          	jalr	-1394(ra) # 80001720 <wakeup>
    80005c9a:	b54d                	j	80005b3c <consoleintr+0x3a>

0000000080005c9c <consoleinit>:

void
consoleinit(void)
{
    80005c9c:	1141                	add	sp,sp,-16
    80005c9e:	e406                	sd	ra,8(sp)
    80005ca0:	e022                	sd	s0,0(sp)
    80005ca2:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ca4:	00003597          	auipc	a1,0x3
    80005ca8:	ab458593          	add	a1,a1,-1356 # 80008758 <etext+0x758>
    80005cac:	00020517          	auipc	a0,0x20
    80005cb0:	49450513          	add	a0,a0,1172 # 80026140 <cons>
    80005cb4:	00000097          	auipc	ra,0x0
    80005cb8:	5c2080e7          	jalr	1474(ra) # 80006276 <initlock>

  uartinit();
    80005cbc:	00000097          	auipc	ra,0x0
    80005cc0:	354080e7          	jalr	852(ra) # 80006010 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cc4:	00013797          	auipc	a5,0x13
    80005cc8:	60478793          	add	a5,a5,1540 # 800192c8 <devsw>
    80005ccc:	00000717          	auipc	a4,0x0
    80005cd0:	cd470713          	add	a4,a4,-812 # 800059a0 <consoleread>
    80005cd4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cd6:	00000717          	auipc	a4,0x0
    80005cda:	c5c70713          	add	a4,a4,-932 # 80005932 <consolewrite>
    80005cde:	ef98                	sd	a4,24(a5)
}
    80005ce0:	60a2                	ld	ra,8(sp)
    80005ce2:	6402                	ld	s0,0(sp)
    80005ce4:	0141                	add	sp,sp,16
    80005ce6:	8082                	ret

0000000080005ce8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ce8:	7179                	add	sp,sp,-48
    80005cea:	f406                	sd	ra,40(sp)
    80005cec:	f022                	sd	s0,32(sp)
    80005cee:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cf0:	c219                	beqz	a2,80005cf6 <printint+0xe>
    80005cf2:	08054963          	bltz	a0,80005d84 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005cf6:	2501                	sext.w	a0,a0
    80005cf8:	4881                	li	a7,0
    80005cfa:	fd040693          	add	a3,s0,-48

  i = 0;
    80005cfe:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d00:	2581                	sext.w	a1,a1
    80005d02:	00003617          	auipc	a2,0x3
    80005d06:	c8660613          	add	a2,a2,-890 # 80008988 <digits>
    80005d0a:	883a                	mv	a6,a4
    80005d0c:	2705                	addw	a4,a4,1
    80005d0e:	02b577bb          	remuw	a5,a0,a1
    80005d12:	1782                	sll	a5,a5,0x20
    80005d14:	9381                	srl	a5,a5,0x20
    80005d16:	97b2                	add	a5,a5,a2
    80005d18:	0007c783          	lbu	a5,0(a5)
    80005d1c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d20:	0005079b          	sext.w	a5,a0
    80005d24:	02b5553b          	divuw	a0,a0,a1
    80005d28:	0685                	add	a3,a3,1
    80005d2a:	feb7f0e3          	bgeu	a5,a1,80005d0a <printint+0x22>

  if(sign)
    80005d2e:	00088c63          	beqz	a7,80005d46 <printint+0x5e>
    buf[i++] = '-';
    80005d32:	fe070793          	add	a5,a4,-32
    80005d36:	00878733          	add	a4,a5,s0
    80005d3a:	02d00793          	li	a5,45
    80005d3e:	fef70823          	sb	a5,-16(a4)
    80005d42:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005d46:	02e05b63          	blez	a4,80005d7c <printint+0x94>
    80005d4a:	ec26                	sd	s1,24(sp)
    80005d4c:	e84a                	sd	s2,16(sp)
    80005d4e:	fd040793          	add	a5,s0,-48
    80005d52:	00e784b3          	add	s1,a5,a4
    80005d56:	fff78913          	add	s2,a5,-1
    80005d5a:	993a                	add	s2,s2,a4
    80005d5c:	377d                	addw	a4,a4,-1
    80005d5e:	1702                	sll	a4,a4,0x20
    80005d60:	9301                	srl	a4,a4,0x20
    80005d62:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d66:	fff4c503          	lbu	a0,-1(s1)
    80005d6a:	00000097          	auipc	ra,0x0
    80005d6e:	d56080e7          	jalr	-682(ra) # 80005ac0 <consputc>
  while(--i >= 0)
    80005d72:	14fd                	add	s1,s1,-1
    80005d74:	ff2499e3          	bne	s1,s2,80005d66 <printint+0x7e>
    80005d78:	64e2                	ld	s1,24(sp)
    80005d7a:	6942                	ld	s2,16(sp)
}
    80005d7c:	70a2                	ld	ra,40(sp)
    80005d7e:	7402                	ld	s0,32(sp)
    80005d80:	6145                	add	sp,sp,48
    80005d82:	8082                	ret
    x = -xx;
    80005d84:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d88:	4885                	li	a7,1
    x = -xx;
    80005d8a:	bf85                	j	80005cfa <printint+0x12>

0000000080005d8c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d8c:	1101                	add	sp,sp,-32
    80005d8e:	ec06                	sd	ra,24(sp)
    80005d90:	e822                	sd	s0,16(sp)
    80005d92:	e426                	sd	s1,8(sp)
    80005d94:	1000                	add	s0,sp,32
    80005d96:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d98:	00020797          	auipc	a5,0x20
    80005d9c:	4607a423          	sw	zero,1128(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005da0:	00003517          	auipc	a0,0x3
    80005da4:	9c050513          	add	a0,a0,-1600 # 80008760 <etext+0x760>
    80005da8:	00000097          	auipc	ra,0x0
    80005dac:	02e080e7          	jalr	46(ra) # 80005dd6 <printf>
  printf(s);
    80005db0:	8526                	mv	a0,s1
    80005db2:	00000097          	auipc	ra,0x0
    80005db6:	024080e7          	jalr	36(ra) # 80005dd6 <printf>
  printf("\n");
    80005dba:	00002517          	auipc	a0,0x2
    80005dbe:	25e50513          	add	a0,a0,606 # 80008018 <etext+0x18>
    80005dc2:	00000097          	auipc	ra,0x0
    80005dc6:	014080e7          	jalr	20(ra) # 80005dd6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dca:	4785                	li	a5,1
    80005dcc:	00003717          	auipc	a4,0x3
    80005dd0:	24f72823          	sw	a5,592(a4) # 8000901c <panicked>
  for(;;)
    80005dd4:	a001                	j	80005dd4 <panic+0x48>

0000000080005dd6 <printf>:
{
    80005dd6:	7131                	add	sp,sp,-192
    80005dd8:	fc86                	sd	ra,120(sp)
    80005dda:	f8a2                	sd	s0,112(sp)
    80005ddc:	e8d2                	sd	s4,80(sp)
    80005dde:	f06a                	sd	s10,32(sp)
    80005de0:	0100                	add	s0,sp,128
    80005de2:	8a2a                	mv	s4,a0
    80005de4:	e40c                	sd	a1,8(s0)
    80005de6:	e810                	sd	a2,16(s0)
    80005de8:	ec14                	sd	a3,24(s0)
    80005dea:	f018                	sd	a4,32(s0)
    80005dec:	f41c                	sd	a5,40(s0)
    80005dee:	03043823          	sd	a6,48(s0)
    80005df2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005df6:	00020d17          	auipc	s10,0x20
    80005dfa:	40ad2d03          	lw	s10,1034(s10) # 80026200 <pr+0x18>
  if(locking)
    80005dfe:	040d1463          	bnez	s10,80005e46 <printf+0x70>
  if (fmt == 0)
    80005e02:	040a0b63          	beqz	s4,80005e58 <printf+0x82>
  va_start(ap, fmt);
    80005e06:	00840793          	add	a5,s0,8
    80005e0a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e0e:	000a4503          	lbu	a0,0(s4)
    80005e12:	18050b63          	beqz	a0,80005fa8 <printf+0x1d2>
    80005e16:	f4a6                	sd	s1,104(sp)
    80005e18:	f0ca                	sd	s2,96(sp)
    80005e1a:	ecce                	sd	s3,88(sp)
    80005e1c:	e4d6                	sd	s5,72(sp)
    80005e1e:	e0da                	sd	s6,64(sp)
    80005e20:	fc5e                	sd	s7,56(sp)
    80005e22:	f862                	sd	s8,48(sp)
    80005e24:	f466                	sd	s9,40(sp)
    80005e26:	ec6e                	sd	s11,24(sp)
    80005e28:	4981                	li	s3,0
    if(c != '%'){
    80005e2a:	02500b13          	li	s6,37
    switch(c){
    80005e2e:	07000b93          	li	s7,112
  consputc('x');
    80005e32:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e34:	00003a97          	auipc	s5,0x3
    80005e38:	b54a8a93          	add	s5,s5,-1196 # 80008988 <digits>
    switch(c){
    80005e3c:	07300c13          	li	s8,115
    80005e40:	06400d93          	li	s11,100
    80005e44:	a0b1                	j	80005e90 <printf+0xba>
    acquire(&pr.lock);
    80005e46:	00020517          	auipc	a0,0x20
    80005e4a:	3a250513          	add	a0,a0,930 # 800261e8 <pr>
    80005e4e:	00000097          	auipc	ra,0x0
    80005e52:	4b8080e7          	jalr	1208(ra) # 80006306 <acquire>
    80005e56:	b775                	j	80005e02 <printf+0x2c>
    80005e58:	f4a6                	sd	s1,104(sp)
    80005e5a:	f0ca                	sd	s2,96(sp)
    80005e5c:	ecce                	sd	s3,88(sp)
    80005e5e:	e4d6                	sd	s5,72(sp)
    80005e60:	e0da                	sd	s6,64(sp)
    80005e62:	fc5e                	sd	s7,56(sp)
    80005e64:	f862                	sd	s8,48(sp)
    80005e66:	f466                	sd	s9,40(sp)
    80005e68:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005e6a:	00003517          	auipc	a0,0x3
    80005e6e:	90650513          	add	a0,a0,-1786 # 80008770 <etext+0x770>
    80005e72:	00000097          	auipc	ra,0x0
    80005e76:	f1a080e7          	jalr	-230(ra) # 80005d8c <panic>
      consputc(c);
    80005e7a:	00000097          	auipc	ra,0x0
    80005e7e:	c46080e7          	jalr	-954(ra) # 80005ac0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e82:	2985                	addw	s3,s3,1
    80005e84:	013a07b3          	add	a5,s4,s3
    80005e88:	0007c503          	lbu	a0,0(a5)
    80005e8c:	10050563          	beqz	a0,80005f96 <printf+0x1c0>
    if(c != '%'){
    80005e90:	ff6515e3          	bne	a0,s6,80005e7a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005e94:	2985                	addw	s3,s3,1
    80005e96:	013a07b3          	add	a5,s4,s3
    80005e9a:	0007c783          	lbu	a5,0(a5)
    80005e9e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ea2:	10078b63          	beqz	a5,80005fb8 <printf+0x1e2>
    switch(c){
    80005ea6:	05778a63          	beq	a5,s7,80005efa <printf+0x124>
    80005eaa:	02fbf663          	bgeu	s7,a5,80005ed6 <printf+0x100>
    80005eae:	09878863          	beq	a5,s8,80005f3e <printf+0x168>
    80005eb2:	07800713          	li	a4,120
    80005eb6:	0ce79563          	bne	a5,a4,80005f80 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005eba:	f8843783          	ld	a5,-120(s0)
    80005ebe:	00878713          	add	a4,a5,8
    80005ec2:	f8e43423          	sd	a4,-120(s0)
    80005ec6:	4605                	li	a2,1
    80005ec8:	85e6                	mv	a1,s9
    80005eca:	4388                	lw	a0,0(a5)
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	e1c080e7          	jalr	-484(ra) # 80005ce8 <printint>
      break;
    80005ed4:	b77d                	j	80005e82 <printf+0xac>
    switch(c){
    80005ed6:	09678f63          	beq	a5,s6,80005f74 <printf+0x19e>
    80005eda:	0bb79363          	bne	a5,s11,80005f80 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005ede:	f8843783          	ld	a5,-120(s0)
    80005ee2:	00878713          	add	a4,a5,8
    80005ee6:	f8e43423          	sd	a4,-120(s0)
    80005eea:	4605                	li	a2,1
    80005eec:	45a9                	li	a1,10
    80005eee:	4388                	lw	a0,0(a5)
    80005ef0:	00000097          	auipc	ra,0x0
    80005ef4:	df8080e7          	jalr	-520(ra) # 80005ce8 <printint>
      break;
    80005ef8:	b769                	j	80005e82 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005efa:	f8843783          	ld	a5,-120(s0)
    80005efe:	00878713          	add	a4,a5,8
    80005f02:	f8e43423          	sd	a4,-120(s0)
    80005f06:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f0a:	03000513          	li	a0,48
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	bb2080e7          	jalr	-1102(ra) # 80005ac0 <consputc>
  consputc('x');
    80005f16:	07800513          	li	a0,120
    80005f1a:	00000097          	auipc	ra,0x0
    80005f1e:	ba6080e7          	jalr	-1114(ra) # 80005ac0 <consputc>
    80005f22:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f24:	03c95793          	srl	a5,s2,0x3c
    80005f28:	97d6                	add	a5,a5,s5
    80005f2a:	0007c503          	lbu	a0,0(a5)
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	b92080e7          	jalr	-1134(ra) # 80005ac0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f36:	0912                	sll	s2,s2,0x4
    80005f38:	34fd                	addw	s1,s1,-1
    80005f3a:	f4ed                	bnez	s1,80005f24 <printf+0x14e>
    80005f3c:	b799                	j	80005e82 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005f3e:	f8843783          	ld	a5,-120(s0)
    80005f42:	00878713          	add	a4,a5,8
    80005f46:	f8e43423          	sd	a4,-120(s0)
    80005f4a:	6384                	ld	s1,0(a5)
    80005f4c:	cc89                	beqz	s1,80005f66 <printf+0x190>
      for(; *s; s++)
    80005f4e:	0004c503          	lbu	a0,0(s1)
    80005f52:	d905                	beqz	a0,80005e82 <printf+0xac>
        consputc(*s);
    80005f54:	00000097          	auipc	ra,0x0
    80005f58:	b6c080e7          	jalr	-1172(ra) # 80005ac0 <consputc>
      for(; *s; s++)
    80005f5c:	0485                	add	s1,s1,1
    80005f5e:	0004c503          	lbu	a0,0(s1)
    80005f62:	f96d                	bnez	a0,80005f54 <printf+0x17e>
    80005f64:	bf39                	j	80005e82 <printf+0xac>
        s = "(null)";
    80005f66:	00003497          	auipc	s1,0x3
    80005f6a:	80248493          	add	s1,s1,-2046 # 80008768 <etext+0x768>
      for(; *s; s++)
    80005f6e:	02800513          	li	a0,40
    80005f72:	b7cd                	j	80005f54 <printf+0x17e>
      consputc('%');
    80005f74:	855a                	mv	a0,s6
    80005f76:	00000097          	auipc	ra,0x0
    80005f7a:	b4a080e7          	jalr	-1206(ra) # 80005ac0 <consputc>
      break;
    80005f7e:	b711                	j	80005e82 <printf+0xac>
      consputc('%');
    80005f80:	855a                	mv	a0,s6
    80005f82:	00000097          	auipc	ra,0x0
    80005f86:	b3e080e7          	jalr	-1218(ra) # 80005ac0 <consputc>
      consputc(c);
    80005f8a:	8526                	mv	a0,s1
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	b34080e7          	jalr	-1228(ra) # 80005ac0 <consputc>
      break;
    80005f94:	b5fd                	j	80005e82 <printf+0xac>
    80005f96:	74a6                	ld	s1,104(sp)
    80005f98:	7906                	ld	s2,96(sp)
    80005f9a:	69e6                	ld	s3,88(sp)
    80005f9c:	6aa6                	ld	s5,72(sp)
    80005f9e:	6b06                	ld	s6,64(sp)
    80005fa0:	7be2                	ld	s7,56(sp)
    80005fa2:	7c42                	ld	s8,48(sp)
    80005fa4:	7ca2                	ld	s9,40(sp)
    80005fa6:	6de2                	ld	s11,24(sp)
  if(locking)
    80005fa8:	020d1263          	bnez	s10,80005fcc <printf+0x1f6>
}
    80005fac:	70e6                	ld	ra,120(sp)
    80005fae:	7446                	ld	s0,112(sp)
    80005fb0:	6a46                	ld	s4,80(sp)
    80005fb2:	7d02                	ld	s10,32(sp)
    80005fb4:	6129                	add	sp,sp,192
    80005fb6:	8082                	ret
    80005fb8:	74a6                	ld	s1,104(sp)
    80005fba:	7906                	ld	s2,96(sp)
    80005fbc:	69e6                	ld	s3,88(sp)
    80005fbe:	6aa6                	ld	s5,72(sp)
    80005fc0:	6b06                	ld	s6,64(sp)
    80005fc2:	7be2                	ld	s7,56(sp)
    80005fc4:	7c42                	ld	s8,48(sp)
    80005fc6:	7ca2                	ld	s9,40(sp)
    80005fc8:	6de2                	ld	s11,24(sp)
    80005fca:	bff9                	j	80005fa8 <printf+0x1d2>
    release(&pr.lock);
    80005fcc:	00020517          	auipc	a0,0x20
    80005fd0:	21c50513          	add	a0,a0,540 # 800261e8 <pr>
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	3e6080e7          	jalr	998(ra) # 800063ba <release>
}
    80005fdc:	bfc1                	j	80005fac <printf+0x1d6>

0000000080005fde <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fde:	1101                	add	sp,sp,-32
    80005fe0:	ec06                	sd	ra,24(sp)
    80005fe2:	e822                	sd	s0,16(sp)
    80005fe4:	e426                	sd	s1,8(sp)
    80005fe6:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fe8:	00020497          	auipc	s1,0x20
    80005fec:	20048493          	add	s1,s1,512 # 800261e8 <pr>
    80005ff0:	00002597          	auipc	a1,0x2
    80005ff4:	79058593          	add	a1,a1,1936 # 80008780 <etext+0x780>
    80005ff8:	8526                	mv	a0,s1
    80005ffa:	00000097          	auipc	ra,0x0
    80005ffe:	27c080e7          	jalr	636(ra) # 80006276 <initlock>
  pr.locking = 1;
    80006002:	4785                	li	a5,1
    80006004:	cc9c                	sw	a5,24(s1)
}
    80006006:	60e2                	ld	ra,24(sp)
    80006008:	6442                	ld	s0,16(sp)
    8000600a:	64a2                	ld	s1,8(sp)
    8000600c:	6105                	add	sp,sp,32
    8000600e:	8082                	ret

0000000080006010 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006010:	1141                	add	sp,sp,-16
    80006012:	e406                	sd	ra,8(sp)
    80006014:	e022                	sd	s0,0(sp)
    80006016:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006018:	100007b7          	lui	a5,0x10000
    8000601c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006020:	10000737          	lui	a4,0x10000
    80006024:	f8000693          	li	a3,-128
    80006028:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000602c:	468d                	li	a3,3
    8000602e:	10000637          	lui	a2,0x10000
    80006032:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006036:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000603a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000603e:	10000737          	lui	a4,0x10000
    80006042:	461d                	li	a2,7
    80006044:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006048:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000604c:	00002597          	auipc	a1,0x2
    80006050:	73c58593          	add	a1,a1,1852 # 80008788 <etext+0x788>
    80006054:	00020517          	auipc	a0,0x20
    80006058:	1b450513          	add	a0,a0,436 # 80026208 <uart_tx_lock>
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	21a080e7          	jalr	538(ra) # 80006276 <initlock>
}
    80006064:	60a2                	ld	ra,8(sp)
    80006066:	6402                	ld	s0,0(sp)
    80006068:	0141                	add	sp,sp,16
    8000606a:	8082                	ret

000000008000606c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000606c:	1101                	add	sp,sp,-32
    8000606e:	ec06                	sd	ra,24(sp)
    80006070:	e822                	sd	s0,16(sp)
    80006072:	e426                	sd	s1,8(sp)
    80006074:	1000                	add	s0,sp,32
    80006076:	84aa                	mv	s1,a0
  push_off();
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	242080e7          	jalr	578(ra) # 800062ba <push_off>

  if(panicked){
    80006080:	00003797          	auipc	a5,0x3
    80006084:	f9c7a783          	lw	a5,-100(a5) # 8000901c <panicked>
    80006088:	eb85                	bnez	a5,800060b8 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000608a:	10000737          	lui	a4,0x10000
    8000608e:	0715                	add	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006090:	00074783          	lbu	a5,0(a4)
    80006094:	0207f793          	and	a5,a5,32
    80006098:	dfe5                	beqz	a5,80006090 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000609a:	0ff4f513          	zext.b	a0,s1
    8000609e:	100007b7          	lui	a5,0x10000
    800060a2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060a6:	00000097          	auipc	ra,0x0
    800060aa:	2b4080e7          	jalr	692(ra) # 8000635a <pop_off>
}
    800060ae:	60e2                	ld	ra,24(sp)
    800060b0:	6442                	ld	s0,16(sp)
    800060b2:	64a2                	ld	s1,8(sp)
    800060b4:	6105                	add	sp,sp,32
    800060b6:	8082                	ret
    for(;;)
    800060b8:	a001                	j	800060b8 <uartputc_sync+0x4c>

00000000800060ba <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060ba:	00003797          	auipc	a5,0x3
    800060be:	f667b783          	ld	a5,-154(a5) # 80009020 <uart_tx_r>
    800060c2:	00003717          	auipc	a4,0x3
    800060c6:	f6673703          	ld	a4,-154(a4) # 80009028 <uart_tx_w>
    800060ca:	06f70f63          	beq	a4,a5,80006148 <uartstart+0x8e>
{
    800060ce:	7139                	add	sp,sp,-64
    800060d0:	fc06                	sd	ra,56(sp)
    800060d2:	f822                	sd	s0,48(sp)
    800060d4:	f426                	sd	s1,40(sp)
    800060d6:	f04a                	sd	s2,32(sp)
    800060d8:	ec4e                	sd	s3,24(sp)
    800060da:	e852                	sd	s4,16(sp)
    800060dc:	e456                	sd	s5,8(sp)
    800060de:	e05a                	sd	s6,0(sp)
    800060e0:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060e2:	10000937          	lui	s2,0x10000
    800060e6:	0915                	add	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060e8:	00020a97          	auipc	s5,0x20
    800060ec:	120a8a93          	add	s5,s5,288 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060f0:	00003497          	auipc	s1,0x3
    800060f4:	f3048493          	add	s1,s1,-208 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800060f8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800060fc:	00003997          	auipc	s3,0x3
    80006100:	f2c98993          	add	s3,s3,-212 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006104:	00094703          	lbu	a4,0(s2)
    80006108:	02077713          	and	a4,a4,32
    8000610c:	c705                	beqz	a4,80006134 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000610e:	01f7f713          	and	a4,a5,31
    80006112:	9756                	add	a4,a4,s5
    80006114:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006118:	0785                	add	a5,a5,1
    8000611a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000611c:	8526                	mv	a0,s1
    8000611e:	ffffb097          	auipc	ra,0xffffb
    80006122:	602080e7          	jalr	1538(ra) # 80001720 <wakeup>
    WriteReg(THR, c);
    80006126:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000612a:	609c                	ld	a5,0(s1)
    8000612c:	0009b703          	ld	a4,0(s3)
    80006130:	fcf71ae3          	bne	a4,a5,80006104 <uartstart+0x4a>
  }
}
    80006134:	70e2                	ld	ra,56(sp)
    80006136:	7442                	ld	s0,48(sp)
    80006138:	74a2                	ld	s1,40(sp)
    8000613a:	7902                	ld	s2,32(sp)
    8000613c:	69e2                	ld	s3,24(sp)
    8000613e:	6a42                	ld	s4,16(sp)
    80006140:	6aa2                	ld	s5,8(sp)
    80006142:	6b02                	ld	s6,0(sp)
    80006144:	6121                	add	sp,sp,64
    80006146:	8082                	ret
    80006148:	8082                	ret

000000008000614a <uartputc>:
{
    8000614a:	7179                	add	sp,sp,-48
    8000614c:	f406                	sd	ra,40(sp)
    8000614e:	f022                	sd	s0,32(sp)
    80006150:	e052                	sd	s4,0(sp)
    80006152:	1800                	add	s0,sp,48
    80006154:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006156:	00020517          	auipc	a0,0x20
    8000615a:	0b250513          	add	a0,a0,178 # 80026208 <uart_tx_lock>
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	1a8080e7          	jalr	424(ra) # 80006306 <acquire>
  if(panicked){
    80006166:	00003797          	auipc	a5,0x3
    8000616a:	eb67a783          	lw	a5,-330(a5) # 8000901c <panicked>
    8000616e:	c391                	beqz	a5,80006172 <uartputc+0x28>
    for(;;)
    80006170:	a001                	j	80006170 <uartputc+0x26>
    80006172:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006174:	00003717          	auipc	a4,0x3
    80006178:	eb473703          	ld	a4,-332(a4) # 80009028 <uart_tx_w>
    8000617c:	00003797          	auipc	a5,0x3
    80006180:	ea47b783          	ld	a5,-348(a5) # 80009020 <uart_tx_r>
    80006184:	02078793          	add	a5,a5,32
    80006188:	02e79f63          	bne	a5,a4,800061c6 <uartputc+0x7c>
    8000618c:	e84a                	sd	s2,16(sp)
    8000618e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006190:	00020997          	auipc	s3,0x20
    80006194:	07898993          	add	s3,s3,120 # 80026208 <uart_tx_lock>
    80006198:	00003497          	auipc	s1,0x3
    8000619c:	e8848493          	add	s1,s1,-376 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061a0:	00003917          	auipc	s2,0x3
    800061a4:	e8890913          	add	s2,s2,-376 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061a8:	85ce                	mv	a1,s3
    800061aa:	8526                	mv	a0,s1
    800061ac:	ffffb097          	auipc	ra,0xffffb
    800061b0:	3e8080e7          	jalr	1000(ra) # 80001594 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061b4:	00093703          	ld	a4,0(s2)
    800061b8:	609c                	ld	a5,0(s1)
    800061ba:	02078793          	add	a5,a5,32
    800061be:	fee785e3          	beq	a5,a4,800061a8 <uartputc+0x5e>
    800061c2:	6942                	ld	s2,16(sp)
    800061c4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061c6:	00020497          	auipc	s1,0x20
    800061ca:	04248493          	add	s1,s1,66 # 80026208 <uart_tx_lock>
    800061ce:	01f77793          	and	a5,a4,31
    800061d2:	97a6                	add	a5,a5,s1
    800061d4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800061d8:	0705                	add	a4,a4,1
    800061da:	00003797          	auipc	a5,0x3
    800061de:	e4e7b723          	sd	a4,-434(a5) # 80009028 <uart_tx_w>
      uartstart();
    800061e2:	00000097          	auipc	ra,0x0
    800061e6:	ed8080e7          	jalr	-296(ra) # 800060ba <uartstart>
      release(&uart_tx_lock);
    800061ea:	8526                	mv	a0,s1
    800061ec:	00000097          	auipc	ra,0x0
    800061f0:	1ce080e7          	jalr	462(ra) # 800063ba <release>
    800061f4:	64e2                	ld	s1,24(sp)
}
    800061f6:	70a2                	ld	ra,40(sp)
    800061f8:	7402                	ld	s0,32(sp)
    800061fa:	6a02                	ld	s4,0(sp)
    800061fc:	6145                	add	sp,sp,48
    800061fe:	8082                	ret

0000000080006200 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006200:	1141                	add	sp,sp,-16
    80006202:	e422                	sd	s0,8(sp)
    80006204:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006206:	100007b7          	lui	a5,0x10000
    8000620a:	0795                	add	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000620c:	0007c783          	lbu	a5,0(a5)
    80006210:	8b85                	and	a5,a5,1
    80006212:	cb81                	beqz	a5,80006222 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006214:	100007b7          	lui	a5,0x10000
    80006218:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000621c:	6422                	ld	s0,8(sp)
    8000621e:	0141                	add	sp,sp,16
    80006220:	8082                	ret
    return -1;
    80006222:	557d                	li	a0,-1
    80006224:	bfe5                	j	8000621c <uartgetc+0x1c>

0000000080006226 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006226:	1101                	add	sp,sp,-32
    80006228:	ec06                	sd	ra,24(sp)
    8000622a:	e822                	sd	s0,16(sp)
    8000622c:	e426                	sd	s1,8(sp)
    8000622e:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006230:	54fd                	li	s1,-1
    80006232:	a029                	j	8000623c <uartintr+0x16>
      break;
    consoleintr(c);
    80006234:	00000097          	auipc	ra,0x0
    80006238:	8ce080e7          	jalr	-1842(ra) # 80005b02 <consoleintr>
    int c = uartgetc();
    8000623c:	00000097          	auipc	ra,0x0
    80006240:	fc4080e7          	jalr	-60(ra) # 80006200 <uartgetc>
    if(c == -1)
    80006244:	fe9518e3          	bne	a0,s1,80006234 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006248:	00020497          	auipc	s1,0x20
    8000624c:	fc048493          	add	s1,s1,-64 # 80026208 <uart_tx_lock>
    80006250:	8526                	mv	a0,s1
    80006252:	00000097          	auipc	ra,0x0
    80006256:	0b4080e7          	jalr	180(ra) # 80006306 <acquire>
  uartstart();
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	e60080e7          	jalr	-416(ra) # 800060ba <uartstart>
  release(&uart_tx_lock);
    80006262:	8526                	mv	a0,s1
    80006264:	00000097          	auipc	ra,0x0
    80006268:	156080e7          	jalr	342(ra) # 800063ba <release>
}
    8000626c:	60e2                	ld	ra,24(sp)
    8000626e:	6442                	ld	s0,16(sp)
    80006270:	64a2                	ld	s1,8(sp)
    80006272:	6105                	add	sp,sp,32
    80006274:	8082                	ret

0000000080006276 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006276:	1141                	add	sp,sp,-16
    80006278:	e422                	sd	s0,8(sp)
    8000627a:	0800                	add	s0,sp,16
  lk->name = name;
    8000627c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000627e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006282:	00053823          	sd	zero,16(a0)
}
    80006286:	6422                	ld	s0,8(sp)
    80006288:	0141                	add	sp,sp,16
    8000628a:	8082                	ret

000000008000628c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000628c:	411c                	lw	a5,0(a0)
    8000628e:	e399                	bnez	a5,80006294 <holding+0x8>
    80006290:	4501                	li	a0,0
  return r;
}
    80006292:	8082                	ret
{
    80006294:	1101                	add	sp,sp,-32
    80006296:	ec06                	sd	ra,24(sp)
    80006298:	e822                	sd	s0,16(sp)
    8000629a:	e426                	sd	s1,8(sp)
    8000629c:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000629e:	6904                	ld	s1,16(a0)
    800062a0:	ffffb097          	auipc	ra,0xffffb
    800062a4:	c0a080e7          	jalr	-1014(ra) # 80000eaa <mycpu>
    800062a8:	40a48533          	sub	a0,s1,a0
    800062ac:	00153513          	seqz	a0,a0
}
    800062b0:	60e2                	ld	ra,24(sp)
    800062b2:	6442                	ld	s0,16(sp)
    800062b4:	64a2                	ld	s1,8(sp)
    800062b6:	6105                	add	sp,sp,32
    800062b8:	8082                	ret

00000000800062ba <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062ba:	1101                	add	sp,sp,-32
    800062bc:	ec06                	sd	ra,24(sp)
    800062be:	e822                	sd	s0,16(sp)
    800062c0:	e426                	sd	s1,8(sp)
    800062c2:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062c4:	100024f3          	csrr	s1,sstatus
    800062c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062cc:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062ce:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062d2:	ffffb097          	auipc	ra,0xffffb
    800062d6:	bd8080e7          	jalr	-1064(ra) # 80000eaa <mycpu>
    800062da:	5d3c                	lw	a5,120(a0)
    800062dc:	cf89                	beqz	a5,800062f6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062de:	ffffb097          	auipc	ra,0xffffb
    800062e2:	bcc080e7          	jalr	-1076(ra) # 80000eaa <mycpu>
    800062e6:	5d3c                	lw	a5,120(a0)
    800062e8:	2785                	addw	a5,a5,1
    800062ea:	dd3c                	sw	a5,120(a0)
}
    800062ec:	60e2                	ld	ra,24(sp)
    800062ee:	6442                	ld	s0,16(sp)
    800062f0:	64a2                	ld	s1,8(sp)
    800062f2:	6105                	add	sp,sp,32
    800062f4:	8082                	ret
    mycpu()->intena = old;
    800062f6:	ffffb097          	auipc	ra,0xffffb
    800062fa:	bb4080e7          	jalr	-1100(ra) # 80000eaa <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062fe:	8085                	srl	s1,s1,0x1
    80006300:	8885                	and	s1,s1,1
    80006302:	dd64                	sw	s1,124(a0)
    80006304:	bfe9                	j	800062de <push_off+0x24>

0000000080006306 <acquire>:
{
    80006306:	1101                	add	sp,sp,-32
    80006308:	ec06                	sd	ra,24(sp)
    8000630a:	e822                	sd	s0,16(sp)
    8000630c:	e426                	sd	s1,8(sp)
    8000630e:	1000                	add	s0,sp,32
    80006310:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006312:	00000097          	auipc	ra,0x0
    80006316:	fa8080e7          	jalr	-88(ra) # 800062ba <push_off>
  if(holding(lk))
    8000631a:	8526                	mv	a0,s1
    8000631c:	00000097          	auipc	ra,0x0
    80006320:	f70080e7          	jalr	-144(ra) # 8000628c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006324:	4705                	li	a4,1
  if(holding(lk))
    80006326:	e115                	bnez	a0,8000634a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006328:	87ba                	mv	a5,a4
    8000632a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000632e:	2781                	sext.w	a5,a5
    80006330:	ffe5                	bnez	a5,80006328 <acquire+0x22>
  __sync_synchronize();
    80006332:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006336:	ffffb097          	auipc	ra,0xffffb
    8000633a:	b74080e7          	jalr	-1164(ra) # 80000eaa <mycpu>
    8000633e:	e888                	sd	a0,16(s1)
}
    80006340:	60e2                	ld	ra,24(sp)
    80006342:	6442                	ld	s0,16(sp)
    80006344:	64a2                	ld	s1,8(sp)
    80006346:	6105                	add	sp,sp,32
    80006348:	8082                	ret
    panic("acquire");
    8000634a:	00002517          	auipc	a0,0x2
    8000634e:	44650513          	add	a0,a0,1094 # 80008790 <etext+0x790>
    80006352:	00000097          	auipc	ra,0x0
    80006356:	a3a080e7          	jalr	-1478(ra) # 80005d8c <panic>

000000008000635a <pop_off>:

void
pop_off(void)
{
    8000635a:	1141                	add	sp,sp,-16
    8000635c:	e406                	sd	ra,8(sp)
    8000635e:	e022                	sd	s0,0(sp)
    80006360:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80006362:	ffffb097          	auipc	ra,0xffffb
    80006366:	b48080e7          	jalr	-1208(ra) # 80000eaa <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000636a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000636e:	8b89                	and	a5,a5,2
  if(intr_get())
    80006370:	e78d                	bnez	a5,8000639a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006372:	5d3c                	lw	a5,120(a0)
    80006374:	02f05b63          	blez	a5,800063aa <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006378:	37fd                	addw	a5,a5,-1
    8000637a:	0007871b          	sext.w	a4,a5
    8000637e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006380:	eb09                	bnez	a4,80006392 <pop_off+0x38>
    80006382:	5d7c                	lw	a5,124(a0)
    80006384:	c799                	beqz	a5,80006392 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006386:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000638a:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000638e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006392:	60a2                	ld	ra,8(sp)
    80006394:	6402                	ld	s0,0(sp)
    80006396:	0141                	add	sp,sp,16
    80006398:	8082                	ret
    panic("pop_off - interruptible");
    8000639a:	00002517          	auipc	a0,0x2
    8000639e:	3fe50513          	add	a0,a0,1022 # 80008798 <etext+0x798>
    800063a2:	00000097          	auipc	ra,0x0
    800063a6:	9ea080e7          	jalr	-1558(ra) # 80005d8c <panic>
    panic("pop_off");
    800063aa:	00002517          	auipc	a0,0x2
    800063ae:	40650513          	add	a0,a0,1030 # 800087b0 <etext+0x7b0>
    800063b2:	00000097          	auipc	ra,0x0
    800063b6:	9da080e7          	jalr	-1574(ra) # 80005d8c <panic>

00000000800063ba <release>:
{
    800063ba:	1101                	add	sp,sp,-32
    800063bc:	ec06                	sd	ra,24(sp)
    800063be:	e822                	sd	s0,16(sp)
    800063c0:	e426                	sd	s1,8(sp)
    800063c2:	1000                	add	s0,sp,32
    800063c4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063c6:	00000097          	auipc	ra,0x0
    800063ca:	ec6080e7          	jalr	-314(ra) # 8000628c <holding>
    800063ce:	c115                	beqz	a0,800063f2 <release+0x38>
  lk->cpu = 0;
    800063d0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063d4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063d8:	0f50000f          	fence	iorw,ow
    800063dc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063e0:	00000097          	auipc	ra,0x0
    800063e4:	f7a080e7          	jalr	-134(ra) # 8000635a <pop_off>
}
    800063e8:	60e2                	ld	ra,24(sp)
    800063ea:	6442                	ld	s0,16(sp)
    800063ec:	64a2                	ld	s1,8(sp)
    800063ee:	6105                	add	sp,sp,32
    800063f0:	8082                	ret
    panic("release");
    800063f2:	00002517          	auipc	a0,0x2
    800063f6:	3c650513          	add	a0,a0,966 # 800087b8 <etext+0x7b8>
    800063fa:	00000097          	auipc	ra,0x0
    800063fe:	992080e7          	jalr	-1646(ra) # 80005d8c <panic>
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
