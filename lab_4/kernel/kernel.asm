
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
    80000016:	099050ef          	jal	800058ae <start>

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
    8000005e:	2f8080e7          	jalr	760(ra) # 80006352 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	398080e7          	jalr	920(ra) # 80006406 <release>
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
    8000008e:	cf2080e7          	jalr	-782(ra) # 80005d7c <panic>

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
    800000fa:	1cc080e7          	jalr	460(ra) # 800062c2 <initlock>
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
    80000132:	224080e7          	jalr	548(ra) # 80006352 <acquire>
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
    8000014a:	2c0080e7          	jalr	704(ra) # 80006406 <release>

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
    80000174:	296080e7          	jalr	662(ra) # 80006406 <release>
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
    80000324:	b30080e7          	jalr	-1232(ra) # 80000e50 <cpuid>
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
    80000340:	b14080e7          	jalr	-1260(ra) # 80000e50 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	add	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	a78080e7          	jalr	-1416(ra) # 80005dc6 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00001097          	auipc	ra,0x1
    80000362:	7d0080e7          	jalr	2000(ra) # 80001b2e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	efe080e7          	jalr	-258(ra) # 80005264 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	07c080e7          	jalr	124(ra) # 800013ea <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	916080e7          	jalr	-1770(ra) # 80005c8c <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	c50080e7          	jalr	-944(ra) # 80005fce <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	add	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	a38080e7          	jalr	-1480(ra) # 80005dc6 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	add	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	a28080e7          	jalr	-1496(ra) # 80005dc6 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	add	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	a18080e7          	jalr	-1512(ra) # 80005dc6 <printf>
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
    800003d2:	9c4080e7          	jalr	-1596(ra) # 80000d92 <procinit>
    trapinit();      // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	730080e7          	jalr	1840(ra) # 80001b06 <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	750080e7          	jalr	1872(ra) # 80001b2e <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	e64080e7          	jalr	-412(ra) # 8000524a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	e76080e7          	jalr	-394(ra) # 80005264 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	f98080e7          	jalr	-104(ra) # 8000238e <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	624080e7          	jalr	1572(ra) # 80002a22 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	5c8080e7          	jalr	1480(ra) # 800039ce <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	f76080e7          	jalr	-138(ra) # 80005384 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	d98080e7          	jalr	-616(ra) # 800011ae <userinit>
    __sync_synchronize();
    8000041e:	0ff0000f          	fence
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	00009717          	auipc	a4,0x9
    80000428:	bcf72e23          	sw	a5,-1060(a4) # 80009000 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
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
  asm volatile("csrw satp, %0" : : "r" (x));
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
  if(va >= MAXVA)
    8000046c:	57fd                	li	a5,-1
    8000046e:	83e9                	srl	a5,a5,0x1a
    80000470:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000472:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000474:	04b7f263          	bgeu	a5,a1,800004b8 <walk+0x66>
    panic("walk");
    80000478:	00008517          	auipc	a0,0x8
    8000047c:	bd850513          	add	a0,a0,-1064 # 80008050 <etext+0x50>
    80000480:	00006097          	auipc	ra,0x6
    80000484:	8fc080e7          	jalr	-1796(ra) # 80005d7c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
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
  for(int level = 2; level > 0; level--) {
    800004b2:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004b4:	036a0063          	beq	s4,s6,800004d4 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004b8:	0149d933          	srl	s2,s3,s4
    800004bc:	1ff97913          	and	s2,s2,511
    800004c0:	090e                	sll	s2,s2,0x3
    800004c2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
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

  if(va >= MAXVA)
    800004f8:	57fd                	li	a5,-1
    800004fa:	83e9                	srl	a5,a5,0x1a
    800004fc:	00b7f463          	bgeu	a5,a1,80000504 <walkaddr+0xc>
    return 0;
    80000500:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
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
  if(pte == 0)
    80000516:	c105                	beqz	a0,80000536 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000518:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000051a:	0117f693          	and	a3,a5,17
    8000051e:	4745                	li	a4,17
    return 0;
    80000520:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
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
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
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

  if(size == 0)
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
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000056c:	6b85                	lui	s7,0x1
    8000056e:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000572:	4605                	li	a2,1
    80000574:	85ca                	mv	a1,s2
    80000576:	8556                	mv	a0,s5
    80000578:	00000097          	auipc	ra,0x0
    8000057c:	eda080e7          	jalr	-294(ra) # 80000452 <walk>
    80000580:	cd1d                	beqz	a0,800005be <mappages+0x84>
    if(*pte & PTE_V)
    80000582:	611c                	ld	a5,0(a0)
    80000584:	8b85                	and	a5,a5,1
    80000586:	e785                	bnez	a5,800005ae <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000588:	80b1                	srl	s1,s1,0xc
    8000058a:	04aa                	sll	s1,s1,0xa
    8000058c:	0164e4b3          	or	s1,s1,s6
    80000590:	0014e493          	or	s1,s1,1
    80000594:	e104                	sd	s1,0(a0)
    if(a == last)
    80000596:	05390063          	beq	s2,s3,800005d6 <mappages+0x9c>
    a += PGSIZE;
    8000059a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000059c:	bfc9                	j	8000056e <mappages+0x34>
    panic("mappages: size");
    8000059e:	00008517          	auipc	a0,0x8
    800005a2:	aba50513          	add	a0,a0,-1350 # 80008058 <etext+0x58>
    800005a6:	00005097          	auipc	ra,0x5
    800005aa:	7d6080e7          	jalr	2006(ra) # 80005d7c <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	add	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00005097          	auipc	ra,0x5
    800005ba:	7c6080e7          	jalr	1990(ra) # 80005d7c <panic>
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
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
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
    80000602:	00005097          	auipc	ra,0x5
    80000606:	77a080e7          	jalr	1914(ra) # 80005d7c <panic>

000000008000060a <kvmmake>:
{
    8000060a:	1101                	add	sp,sp,-32
    8000060c:	ec06                	sd	ra,24(sp)
    8000060e:	e822                	sd	s0,16(sp)
    80000610:	e426                	sd	s1,8(sp)
    80000612:	e04a                	sd	s2,0(sp)
    80000614:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
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
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
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
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
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
    800006ce:	624080e7          	jalr	1572(ra) # 80000cee <proc_mapstacks>
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
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000700:	715d                	add	sp,sp,-80
    80000702:	e486                	sd	ra,72(sp)
    80000704:	e0a2                	sd	s0,64(sp)
    80000706:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
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

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000720:	0632                	sll	a2,a2,0xc
    80000722:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000726:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
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
    8000074c:	634080e7          	jalr	1588(ra) # 80005d7c <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	add	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	624080e7          	jalr	1572(ra) # 80005d7c <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	add	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	614080e7          	jalr	1556(ra) # 80005d7c <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	add	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	604080e7          	jalr	1540(ra) # 80005d7c <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000780:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000784:	995a                	add	s2,s2,s6
    80000786:	03397c63          	bgeu	s2,s3,800007be <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000078a:	4601                	li	a2,0
    8000078c:	85ca                	mv	a1,s2
    8000078e:	8552                	mv	a0,s4
    80000790:	00000097          	auipc	ra,0x0
    80000794:	cc2080e7          	jalr	-830(ra) # 80000452 <walk>
    80000798:	84aa                	mv	s1,a0
    8000079a:	d95d                	beqz	a0,80000750 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000079c:	6108                	ld	a0,0(a0)
    8000079e:	00157793          	and	a5,a0,1
    800007a2:	dfdd                	beqz	a5,80000760 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a4:	3ff57793          	and	a5,a0,1023
    800007a8:	fd7784e3          	beq	a5,s7,80000770 <uvmunmap+0x70>
    if(do_free){
    800007ac:	fc0a8ae3          	beqz	s5,80000780 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007b0:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
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
  pagetable = (pagetable_t) kalloc();
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	93c080e7          	jalr	-1732(ra) # 8000011a <kalloc>
    800007e6:	84aa                	mv	s1,a0
  if(pagetable == 0)
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
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
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

  if(sz >= PGSIZE)
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
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
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
    80000870:	510080e7          	jalr	1296(ra) # 80005d7c <panic>

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
  if(newsz >= oldsz)
    return oldsz;
    8000087e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000880:	00b67d63          	bgeu	a2,a1,8000089a <uvmdealloc+0x26>
    80000884:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
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
  if(newsz < oldsz)
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
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f663          	bgeu	s3,a2,8000096a <uvmalloc+0xae>
    800008e2:	f426                	sd	s1,40(sp)
    800008e4:	f04a                	sd	s2,32(sp)
    800008e6:	894e                	mv	s2,s3
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c90d                	beqz	a0,80000924 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000900:	4779                	li	a4,30
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c30080e7          	jalr	-976(ra) # 8000053a <mappages>
    80000912:	e915                	bnez	a0,80000946 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
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
void
freewalk(pagetable_t pagetable)
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
  for(int i = 0; i < 512; i++){
    80000980:	84aa                	mv	s1,a0
    80000982:	6905                	lui	s2,0x1
    80000984:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000986:	4985                	li	s3,1
    80000988:	a829                	j	800009a2 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000098a:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000098c:	00c79513          	sll	a0,a5,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fde080e7          	jalr	-34(ra) # 8000096e <freewalk>
      pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000099c:	04a1                	add	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009a2:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	00f7f713          	and	a4,a5,15
    800009a8:	ff3701e3          	beq	a4,s3,8000098a <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ac:	8b85                	and	a5,a5,1
    800009ae:	d7fd                	beqz	a5,8000099c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	add	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	3c4080e7          	jalr	964(ra) # 80005d7c <panic>
    }
  }
  kfree((void*)pagetable);
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
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	add	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	add	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
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
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
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

  for(i = 0; i < sz; i += PGSIZE){
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
  for(i = 0; i < sz; i += PGSIZE){
    80000a32:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a34:	4601                	li	a2,0
    80000a36:	85ce                	mv	a1,s3
    80000a38:	855a                	mv	a0,s6
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	a18080e7          	jalr	-1512(ra) # 80000452 <walk>
    80000a42:	c531                	beqz	a0,80000a8e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a44:	6118                	ld	a4,0(a0)
    80000a46:	00177793          	and	a5,a4,1
    80000a4a:	cbb1                	beqz	a5,80000a9e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4c:	00a75593          	srl	a1,a4,0xa
    80000a50:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a54:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	6c2080e7          	jalr	1730(ra) # 8000011a <kalloc>
    80000a60:	892a                	mv	s2,a0
    80000a62:	c939                	beqz	a0,80000ab8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85de                	mv	a1,s7
    80000a68:	fffff097          	auipc	ra,0xfffff
    80000a6c:	76e080e7          	jalr	1902(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a70:	8726                	mv	a4,s1
    80000a72:	86ca                	mv	a3,s2
    80000a74:	6605                	lui	a2,0x1
    80000a76:	85ce                	mv	a1,s3
    80000a78:	8556                	mv	a0,s5
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	ac0080e7          	jalr	-1344(ra) # 8000053a <mappages>
    80000a82:	e515                	bnez	a0,80000aae <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a84:	6785                	lui	a5,0x1
    80000a86:	99be                	add	s3,s3,a5
    80000a88:	fb49e6e3          	bltu	s3,s4,80000a34 <uvmcopy+0x20>
    80000a8c:	a081                	j	80000acc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	67a50513          	add	a0,a0,1658 # 80008108 <etext+0x108>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	2e6080e7          	jalr	742(ra) # 80005d7c <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	add	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	2d6080e7          	jalr	726(ra) # 80005d7c <panic>
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
void
uvmclear(pagetable_t pagetable, uint64 va)
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
  if(pte == 0)
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
    80000b14:	26c080e7          	jalr	620(ra) # 80005d7c <panic>

0000000080000b18 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
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
    va0 = PGROUNDDOWN(dstva);
    80000b3a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3c:	6a85                	lui	s5,0x1
    80000b3e:	a015                	j	80000b62 <copyout+0x4a>
    if(n > len)
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
  while(len > 0){
    80000b5e:	02098263          	beqz	s3,80000b82 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b62:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b66:	85ca                	mv	a1,s2
    80000b68:	855a                	mv	a0,s6
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	98e080e7          	jalr	-1650(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000b72:	cd01                	beqz	a0,80000b8a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b74:	418904b3          	sub	s1,s2,s8
    80000b78:	94d6                	add	s1,s1,s5
    if(n > len)
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
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
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
    va0 = PGROUNDDOWN(srcva);
    80000bc6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc8:	6a85                	lui	s5,0x1
    80000bca:	a01d                	j	80000bf0 <copyin+0x4c>
    if(n > len)
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
  while(len > 0){
    80000bec:	02098263          	beqz	s3,80000c10 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bf0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf4:	85ca                	mv	a1,s2
    80000bf6:	855a                	mv	a0,s6
    80000bf8:	00000097          	auipc	ra,0x0
    80000bfc:	900080e7          	jalr	-1792(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c00:	cd01                	beqz	a0,80000c18 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c02:	418904b3          	sub	s1,s2,s8
    80000c06:	94d6                	add	s1,s1,s5
    if(n > len)
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
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
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
    va0 = PGROUNDDOWN(srcva);
    80000c52:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c54:	6985                	lui	s3,0x1
    80000c56:	a825                	j	80000c8e <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c58:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c5c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5e:	37fd                	addw	a5,a5,-1
    80000c60:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
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
  while(got_null == 0 && max > 0){
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
    if(pa0 == 0)
    80000c9e:	cd0d                	beqz	a0,80000cd8 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000ca0:	417486b3          	sub	a3,s1,s7
    80000ca4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000ca6:	00d97363          	bgeu	s2,a3,80000cac <copyinstr+0x7a>
    80000caa:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000cac:	955e                	add	a0,a0,s7
    80000cae:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000cb0:	c695                	beqz	a3,80000cdc <copyinstr+0xaa>
    80000cb2:	87da                	mv	a5,s6
    80000cb4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000cb6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000cba:	96da                	add	a3,a3,s6
    80000cbc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cbe:	00f60733          	add	a4,a2,a5
    80000cc2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cc6:	db49                	beqz	a4,80000c58 <copyinstr+0x26>
        *dst = *p;
    80000cc8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000ccc:	0785                	add	a5,a5,1
    while(n > 0){
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
  if(got_null){
    80000ce6:	37fd                	addw	a5,a5,-1
    80000ce8:	0007851b          	sext.w	a0,a5
}
    80000cec:	8082                	ret

0000000080000cee <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000cee:	7139                	add	sp,sp,-64
    80000cf0:	fc06                	sd	ra,56(sp)
    80000cf2:	f822                	sd	s0,48(sp)
    80000cf4:	f426                	sd	s1,40(sp)
    80000cf6:	f04a                	sd	s2,32(sp)
    80000cf8:	ec4e                	sd	s3,24(sp)
    80000cfa:	e852                	sd	s4,16(sp)
    80000cfc:	e456                	sd	s5,8(sp)
    80000cfe:	e05a                	sd	s6,0(sp)
    80000d00:	0080                	add	s0,sp,64
    80000d02:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80000d04:	00008497          	auipc	s1,0x8
    80000d08:	77c48493          	add	s1,s1,1916 # 80009480 <proc>
    {
        char *pa = kalloc();
        if (pa == 0)
            panic("kalloc");
        uint64 va = KSTACK((int)(p - proc));
    80000d0c:	8b26                	mv	s6,s1
    80000d0e:	03eb2937          	lui	s2,0x3eb2
    80000d12:	a1f90913          	add	s2,s2,-1505 # 3eb1a1f <_entry-0x7c14e5e1>
    80000d16:	0932                	sll	s2,s2,0xc
    80000d18:	58d90913          	add	s2,s2,1421
    80000d1c:	0932                	sll	s2,s2,0xc
    80000d1e:	0fb90913          	add	s2,s2,251
    80000d22:	0936                	sll	s2,s2,0xd
    80000d24:	8d190913          	add	s2,s2,-1839
    80000d28:	040009b7          	lui	s3,0x4000
    80000d2c:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d2e:	09b2                	sll	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80000d30:	0000fa97          	auipc	s5,0xf
    80000d34:	950a8a93          	add	s5,s5,-1712 # 8000f680 <tickslock>
        char *pa = kalloc();
    80000d38:	fffff097          	auipc	ra,0xfffff
    80000d3c:	3e2080e7          	jalr	994(ra) # 8000011a <kalloc>
    80000d40:	862a                	mv	a2,a0
        if (pa == 0)
    80000d42:	c121                	beqz	a0,80000d82 <proc_mapstacks+0x94>
        uint64 va = KSTACK((int)(p - proc));
    80000d44:	416485b3          	sub	a1,s1,s6
    80000d48:	858d                	sra	a1,a1,0x3
    80000d4a:	032585b3          	mul	a1,a1,s2
    80000d4e:	2585                	addw	a1,a1,1
    80000d50:	00d5959b          	sllw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d54:	4719                	li	a4,6
    80000d56:	6685                	lui	a3,0x1
    80000d58:	40b985b3          	sub	a1,s3,a1
    80000d5c:	8552                	mv	a0,s4
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	87c080e7          	jalr	-1924(ra) # 800005da <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80000d66:	18848493          	add	s1,s1,392
    80000d6a:	fd5497e3          	bne	s1,s5,80000d38 <proc_mapstacks+0x4a>
    }
}
    80000d6e:	70e2                	ld	ra,56(sp)
    80000d70:	7442                	ld	s0,48(sp)
    80000d72:	74a2                	ld	s1,40(sp)
    80000d74:	7902                	ld	s2,32(sp)
    80000d76:	69e2                	ld	s3,24(sp)
    80000d78:	6a42                	ld	s4,16(sp)
    80000d7a:	6aa2                	ld	s5,8(sp)
    80000d7c:	6b02                	ld	s6,0(sp)
    80000d7e:	6121                	add	sp,sp,64
    80000d80:	8082                	ret
            panic("kalloc");
    80000d82:	00007517          	auipc	a0,0x7
    80000d86:	3d650513          	add	a0,a0,982 # 80008158 <etext+0x158>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	ff2080e7          	jalr	-14(ra) # 80005d7c <panic>

0000000080000d92 <procinit>:

// initialize the proc table at boot time.
void procinit(void)
{
    80000d92:	7139                	add	sp,sp,-64
    80000d94:	fc06                	sd	ra,56(sp)
    80000d96:	f822                	sd	s0,48(sp)
    80000d98:	f426                	sd	s1,40(sp)
    80000d9a:	f04a                	sd	s2,32(sp)
    80000d9c:	ec4e                	sd	s3,24(sp)
    80000d9e:	e852                	sd	s4,16(sp)
    80000da0:	e456                	sd	s5,8(sp)
    80000da2:	e05a                	sd	s6,0(sp)
    80000da4:	0080                	add	s0,sp,64
    struct proc *p;

    initlock(&pid_lock, "nextpid");
    80000da6:	00007597          	auipc	a1,0x7
    80000daa:	3ba58593          	add	a1,a1,954 # 80008160 <etext+0x160>
    80000dae:	00008517          	auipc	a0,0x8
    80000db2:	2a250513          	add	a0,a0,674 # 80009050 <pid_lock>
    80000db6:	00005097          	auipc	ra,0x5
    80000dba:	50c080e7          	jalr	1292(ra) # 800062c2 <initlock>
    initlock(&wait_lock, "wait_lock");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	3aa58593          	add	a1,a1,938 # 80008168 <etext+0x168>
    80000dc6:	00008517          	auipc	a0,0x8
    80000dca:	2a250513          	add	a0,a0,674 # 80009068 <wait_lock>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	4f4080e7          	jalr	1268(ra) # 800062c2 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80000dd6:	00008497          	auipc	s1,0x8
    80000dda:	6aa48493          	add	s1,s1,1706 # 80009480 <proc>
    {
        initlock(&p->lock, "proc");
    80000dde:	00007b17          	auipc	s6,0x7
    80000de2:	39ab0b13          	add	s6,s6,922 # 80008178 <etext+0x178>
        p->kstack = KSTACK((int)(p - proc));
    80000de6:	8aa6                	mv	s5,s1
    80000de8:	03eb2937          	lui	s2,0x3eb2
    80000dec:	a1f90913          	add	s2,s2,-1505 # 3eb1a1f <_entry-0x7c14e5e1>
    80000df0:	0932                	sll	s2,s2,0xc
    80000df2:	58d90913          	add	s2,s2,1421
    80000df6:	0932                	sll	s2,s2,0xc
    80000df8:	0fb90913          	add	s2,s2,251
    80000dfc:	0936                	sll	s2,s2,0xd
    80000dfe:	8d190913          	add	s2,s2,-1839
    80000e02:	040009b7          	lui	s3,0x4000
    80000e06:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e08:	09b2                	sll	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80000e0a:	0000fa17          	auipc	s4,0xf
    80000e0e:	876a0a13          	add	s4,s4,-1930 # 8000f680 <tickslock>
        initlock(&p->lock, "proc");
    80000e12:	85da                	mv	a1,s6
    80000e14:	8526                	mv	a0,s1
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	4ac080e7          	jalr	1196(ra) # 800062c2 <initlock>
        p->kstack = KSTACK((int)(p - proc));
    80000e1e:	415487b3          	sub	a5,s1,s5
    80000e22:	878d                	sra	a5,a5,0x3
    80000e24:	032787b3          	mul	a5,a5,s2
    80000e28:	2785                	addw	a5,a5,1
    80000e2a:	00d7979b          	sllw	a5,a5,0xd
    80000e2e:	40f987b3          	sub	a5,s3,a5
    80000e32:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80000e34:	18848493          	add	s1,s1,392
    80000e38:	fd449de3          	bne	s1,s4,80000e12 <procinit+0x80>
    }
}
    80000e3c:	70e2                	ld	ra,56(sp)
    80000e3e:	7442                	ld	s0,48(sp)
    80000e40:	74a2                	ld	s1,40(sp)
    80000e42:	7902                	ld	s2,32(sp)
    80000e44:	69e2                	ld	s3,24(sp)
    80000e46:	6a42                	ld	s4,16(sp)
    80000e48:	6aa2                	ld	s5,8(sp)
    80000e4a:	6b02                	ld	s6,0(sp)
    80000e4c:	6121                	add	sp,sp,64
    80000e4e:	8082                	ret

0000000080000e50 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000e50:	1141                	add	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e56:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80000e58:	2501                	sext.w	a0,a0
    80000e5a:	6422                	ld	s0,8(sp)
    80000e5c:	0141                	add	sp,sp,16
    80000e5e:	8082                	ret

0000000080000e60 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000e60:	1141                	add	sp,sp,-16
    80000e62:	e422                	sd	s0,8(sp)
    80000e64:	0800                	add	s0,sp,16
    80000e66:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu *c = &cpus[id];
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	sll	a5,a5,0x7
    return c;
}
    80000e6c:	00008517          	auipc	a0,0x8
    80000e70:	21450513          	add	a0,a0,532 # 80009080 <cpus>
    80000e74:	953e                	add	a0,a0,a5
    80000e76:	6422                	ld	s0,8(sp)
    80000e78:	0141                	add	sp,sp,16
    80000e7a:	8082                	ret

0000000080000e7c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000e7c:	1101                	add	sp,sp,-32
    80000e7e:	ec06                	sd	ra,24(sp)
    80000e80:	e822                	sd	s0,16(sp)
    80000e82:	e426                	sd	s1,8(sp)
    80000e84:	1000                	add	s0,sp,32
    push_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	480080e7          	jalr	1152(ra) # 80006306 <push_off>
    80000e8e:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000e90:	2781                	sext.w	a5,a5
    80000e92:	079e                	sll	a5,a5,0x7
    80000e94:	00008717          	auipc	a4,0x8
    80000e98:	1bc70713          	add	a4,a4,444 # 80009050 <pid_lock>
    80000e9c:	97ba                	add	a5,a5,a4
    80000e9e:	7b84                	ld	s1,48(a5)
    pop_off();
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	506080e7          	jalr	1286(ra) # 800063a6 <pop_off>
    return p;
}
    80000ea8:	8526                	mv	a0,s1
    80000eaa:	60e2                	ld	ra,24(sp)
    80000eac:	6442                	ld	s0,16(sp)
    80000eae:	64a2                	ld	s1,8(sp)
    80000eb0:	6105                	add	sp,sp,32
    80000eb2:	8082                	ret

0000000080000eb4 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000eb4:	1141                	add	sp,sp,-16
    80000eb6:	e406                	sd	ra,8(sp)
    80000eb8:	e022                	sd	s0,0(sp)
    80000eba:	0800                	add	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80000ebc:	00000097          	auipc	ra,0x0
    80000ec0:	fc0080e7          	jalr	-64(ra) # 80000e7c <myproc>
    80000ec4:	00005097          	auipc	ra,0x5
    80000ec8:	542080e7          	jalr	1346(ra) # 80006406 <release>

    if (first)
    80000ecc:	00008797          	auipc	a5,0x8
    80000ed0:	9647a783          	lw	a5,-1692(a5) # 80008830 <first.1>
    80000ed4:	eb89                	bnez	a5,80000ee6 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80000ed6:	00001097          	auipc	ra,0x1
    80000eda:	c70080e7          	jalr	-912(ra) # 80001b46 <usertrapret>
}
    80000ede:	60a2                	ld	ra,8(sp)
    80000ee0:	6402                	ld	s0,0(sp)
    80000ee2:	0141                	add	sp,sp,16
    80000ee4:	8082                	ret
        first = 0;
    80000ee6:	00008797          	auipc	a5,0x8
    80000eea:	9407a523          	sw	zero,-1718(a5) # 80008830 <first.1>
        fsinit(ROOTDEV);
    80000eee:	4505                	li	a0,1
    80000ef0:	00002097          	auipc	ra,0x2
    80000ef4:	ab2080e7          	jalr	-1358(ra) # 800029a2 <fsinit>
    80000ef8:	bff9                	j	80000ed6 <forkret+0x22>

0000000080000efa <allocpid>:
{
    80000efa:	1101                	add	sp,sp,-32
    80000efc:	ec06                	sd	ra,24(sp)
    80000efe:	e822                	sd	s0,16(sp)
    80000f00:	e426                	sd	s1,8(sp)
    80000f02:	e04a                	sd	s2,0(sp)
    80000f04:	1000                	add	s0,sp,32
    acquire(&pid_lock);
    80000f06:	00008917          	auipc	s2,0x8
    80000f0a:	14a90913          	add	s2,s2,330 # 80009050 <pid_lock>
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	442080e7          	jalr	1090(ra) # 80006352 <acquire>
    pid = nextpid;
    80000f18:	00008797          	auipc	a5,0x8
    80000f1c:	91c78793          	add	a5,a5,-1764 # 80008834 <nextpid>
    80000f20:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000f22:	0014871b          	addw	a4,s1,1
    80000f26:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000f28:	854a                	mv	a0,s2
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	4dc080e7          	jalr	1244(ra) # 80006406 <release>
}
    80000f32:	8526                	mv	a0,s1
    80000f34:	60e2                	ld	ra,24(sp)
    80000f36:	6442                	ld	s0,16(sp)
    80000f38:	64a2                	ld	s1,8(sp)
    80000f3a:	6902                	ld	s2,0(sp)
    80000f3c:	6105                	add	sp,sp,32
    80000f3e:	8082                	ret

0000000080000f40 <proc_pagetable>:
{
    80000f40:	1101                	add	sp,sp,-32
    80000f42:	ec06                	sd	ra,24(sp)
    80000f44:	e822                	sd	s0,16(sp)
    80000f46:	e426                	sd	s1,8(sp)
    80000f48:	e04a                	sd	s2,0(sp)
    80000f4a:	1000                	add	s0,sp,32
    80000f4c:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80000f4e:	00000097          	auipc	ra,0x0
    80000f52:	886080e7          	jalr	-1914(ra) # 800007d4 <uvmcreate>
    80000f56:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80000f58:	c121                	beqz	a0,80000f98 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f5a:	4729                	li	a4,10
    80000f5c:	00006697          	auipc	a3,0x6
    80000f60:	0a468693          	add	a3,a3,164 # 80007000 <_trampoline>
    80000f64:	6605                	lui	a2,0x1
    80000f66:	040005b7          	lui	a1,0x4000
    80000f6a:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f6c:	05b2                	sll	a1,a1,0xc
    80000f6e:	fffff097          	auipc	ra,0xfffff
    80000f72:	5cc080e7          	jalr	1484(ra) # 8000053a <mappages>
    80000f76:	02054863          	bltz	a0,80000fa6 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f7a:	4719                	li	a4,6
    80000f7c:	05893683          	ld	a3,88(s2)
    80000f80:	6605                	lui	a2,0x1
    80000f82:	020005b7          	lui	a1,0x2000
    80000f86:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f88:	05b6                	sll	a1,a1,0xd
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	5ae080e7          	jalr	1454(ra) # 8000053a <mappages>
    80000f94:	02054163          	bltz	a0,80000fb6 <proc_pagetable+0x76>
}
    80000f98:	8526                	mv	a0,s1
    80000f9a:	60e2                	ld	ra,24(sp)
    80000f9c:	6442                	ld	s0,16(sp)
    80000f9e:	64a2                	ld	s1,8(sp)
    80000fa0:	6902                	ld	s2,0(sp)
    80000fa2:	6105                	add	sp,sp,32
    80000fa4:	8082                	ret
        uvmfree(pagetable, 0);
    80000fa6:	4581                	li	a1,0
    80000fa8:	8526                	mv	a0,s1
    80000faa:	00000097          	auipc	ra,0x0
    80000fae:	a30080e7          	jalr	-1488(ra) # 800009da <uvmfree>
        return 0;
    80000fb2:	4481                	li	s1,0
    80000fb4:	b7d5                	j	80000f98 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb6:	4681                	li	a3,0
    80000fb8:	4605                	li	a2,1
    80000fba:	040005b7          	lui	a1,0x4000
    80000fbe:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fc0:	05b2                	sll	a1,a1,0xc
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	73c080e7          	jalr	1852(ra) # 80000700 <uvmunmap>
        uvmfree(pagetable, 0);
    80000fcc:	4581                	li	a1,0
    80000fce:	8526                	mv	a0,s1
    80000fd0:	00000097          	auipc	ra,0x0
    80000fd4:	a0a080e7          	jalr	-1526(ra) # 800009da <uvmfree>
        return 0;
    80000fd8:	4481                	li	s1,0
    80000fda:	bf7d                	j	80000f98 <proc_pagetable+0x58>

0000000080000fdc <proc_freepagetable>:
{
    80000fdc:	1101                	add	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	e04a                	sd	s2,0(sp)
    80000fe6:	1000                	add	s0,sp,32
    80000fe8:	84aa                	mv	s1,a0
    80000fea:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fec:	4681                	li	a3,0
    80000fee:	4605                	li	a2,1
    80000ff0:	040005b7          	lui	a1,0x4000
    80000ff4:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff6:	05b2                	sll	a1,a1,0xc
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	708080e7          	jalr	1800(ra) # 80000700 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001000:	4681                	li	a3,0
    80001002:	4605                	li	a2,1
    80001004:	020005b7          	lui	a1,0x2000
    80001008:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000100a:	05b6                	sll	a1,a1,0xd
    8000100c:	8526                	mv	a0,s1
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	6f2080e7          	jalr	1778(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, sz);
    80001016:	85ca                	mv	a1,s2
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	9c0080e7          	jalr	-1600(ra) # 800009da <uvmfree>
}
    80001022:	60e2                	ld	ra,24(sp)
    80001024:	6442                	ld	s0,16(sp)
    80001026:	64a2                	ld	s1,8(sp)
    80001028:	6902                	ld	s2,0(sp)
    8000102a:	6105                	add	sp,sp,32
    8000102c:	8082                	ret

000000008000102e <freeproc>:
{
    8000102e:	1101                	add	sp,sp,-32
    80001030:	ec06                	sd	ra,24(sp)
    80001032:	e822                	sd	s0,16(sp)
    80001034:	e426                	sd	s1,8(sp)
    80001036:	1000                	add	s0,sp,32
    80001038:	84aa                	mv	s1,a0
    if (p->trapframe)
    8000103a:	6d28                	ld	a0,88(a0)
    8000103c:	c509                	beqz	a0,80001046 <freeproc+0x18>
        kfree((void *)p->trapframe);
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	fde080e7          	jalr	-34(ra) # 8000001c <kfree>
    p->trapframe = 0;
    80001046:	0404bc23          	sd	zero,88(s1)
    if (p->alarm_trapframe)
    8000104a:	1804b503          	ld	a0,384(s1)
    8000104e:	c509                	beqz	a0,80001058 <freeproc+0x2a>
        kfree((void *)p->alarm_trapframe);
    80001050:	fffff097          	auipc	ra,0xfffff
    80001054:	fcc080e7          	jalr	-52(ra) # 8000001c <kfree>
    p->alarm_trapframe = 0;
    80001058:	1804b023          	sd	zero,384(s1)
    if (p->pagetable)
    8000105c:	68a8                	ld	a0,80(s1)
    8000105e:	c511                	beqz	a0,8000106a <freeproc+0x3c>
        proc_freepagetable(p->pagetable, p->sz);
    80001060:	64ac                	ld	a1,72(s1)
    80001062:	00000097          	auipc	ra,0x0
    80001066:	f7a080e7          	jalr	-134(ra) # 80000fdc <proc_freepagetable>
    p->pagetable = 0;
    8000106a:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    8000106e:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001072:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001076:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    8000107a:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    8000107e:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001082:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001086:	0204a623          	sw	zero,44(s1)
    p->alarm_info.alarm_running = 0;
    8000108a:	1604ae23          	sw	zero,380(s1)
    p->alarm_info.alarm_ticks = 0;
    8000108e:	1604ac23          	sw	zero,376(s1)
    p->alarm_info.alarm_handler = 0;
    80001092:	1604b823          	sd	zero,368(s1)
    p->alarm_info.alarm_interval = 0;
    80001096:	1604a423          	sw	zero,360(s1)
    p->state = UNUSED;
    8000109a:	0004ac23          	sw	zero,24(s1)
}
    8000109e:	60e2                	ld	ra,24(sp)
    800010a0:	6442                	ld	s0,16(sp)
    800010a2:	64a2                	ld	s1,8(sp)
    800010a4:	6105                	add	sp,sp,32
    800010a6:	8082                	ret

00000000800010a8 <allocproc>:
{
    800010a8:	1101                	add	sp,sp,-32
    800010aa:	ec06                	sd	ra,24(sp)
    800010ac:	e822                	sd	s0,16(sp)
    800010ae:	e426                	sd	s1,8(sp)
    800010b0:	e04a                	sd	s2,0(sp)
    800010b2:	1000                	add	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    800010b4:	00008497          	auipc	s1,0x8
    800010b8:	3cc48493          	add	s1,s1,972 # 80009480 <proc>
    800010bc:	0000e917          	auipc	s2,0xe
    800010c0:	5c490913          	add	s2,s2,1476 # 8000f680 <tickslock>
        acquire(&p->lock);
    800010c4:	8526                	mv	a0,s1
    800010c6:	00005097          	auipc	ra,0x5
    800010ca:	28c080e7          	jalr	652(ra) # 80006352 <acquire>
        if (p->state == UNUSED)
    800010ce:	4c9c                	lw	a5,24(s1)
    800010d0:	cf81                	beqz	a5,800010e8 <allocproc+0x40>
            release(&p->lock);
    800010d2:	8526                	mv	a0,s1
    800010d4:	00005097          	auipc	ra,0x5
    800010d8:	332080e7          	jalr	818(ra) # 80006406 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800010dc:	18848493          	add	s1,s1,392
    800010e0:	ff2492e3          	bne	s1,s2,800010c4 <allocproc+0x1c>
    return 0;
    800010e4:	4481                	li	s1,0
    800010e6:	a88d                	j	80001158 <allocproc+0xb0>
    p->pid = allocpid();
    800010e8:	00000097          	auipc	ra,0x0
    800010ec:	e12080e7          	jalr	-494(ra) # 80000efa <allocpid>
    800010f0:	d888                	sw	a0,48(s1)
    p->state = USED;
    800010f2:	4785                	li	a5,1
    800010f4:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    800010f6:	fffff097          	auipc	ra,0xfffff
    800010fa:	024080e7          	jalr	36(ra) # 8000011a <kalloc>
    800010fe:	892a                	mv	s2,a0
    80001100:	eca8                	sd	a0,88(s1)
    80001102:	c135                	beqz	a0,80001166 <allocproc+0xbe>
    if ((p->alarm_trapframe = (struct trapframe *)kalloc()) == 0)
    80001104:	fffff097          	auipc	ra,0xfffff
    80001108:	016080e7          	jalr	22(ra) # 8000011a <kalloc>
    8000110c:	892a                	mv	s2,a0
    8000110e:	18a4b023          	sd	a0,384(s1)
    80001112:	c535                	beqz	a0,8000117e <allocproc+0xd6>
    p->alarm_info.alarm_running = 0;
    80001114:	1604ae23          	sw	zero,380(s1)
    p->alarm_info.alarm_ticks = 0;
    80001118:	1604ac23          	sw	zero,376(s1)
    p->alarm_info.alarm_handler = 0;
    8000111c:	1604b823          	sd	zero,368(s1)
    p->alarm_info.alarm_interval = 0;
    80001120:	1604a423          	sw	zero,360(s1)
    p->pagetable = proc_pagetable(p);
    80001124:	8526                	mv	a0,s1
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	e1a080e7          	jalr	-486(ra) # 80000f40 <proc_pagetable>
    8000112e:	892a                	mv	s2,a0
    80001130:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    80001132:	c135                	beqz	a0,80001196 <allocproc+0xee>
    memset(&p->context, 0, sizeof(p->context));
    80001134:	07000613          	li	a2,112
    80001138:	4581                	li	a1,0
    8000113a:	06048513          	add	a0,s1,96
    8000113e:	fffff097          	auipc	ra,0xfffff
    80001142:	03c080e7          	jalr	60(ra) # 8000017a <memset>
    p->context.ra = (uint64)forkret;
    80001146:	00000797          	auipc	a5,0x0
    8000114a:	d6e78793          	add	a5,a5,-658 # 80000eb4 <forkret>
    8000114e:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001150:	60bc                	ld	a5,64(s1)
    80001152:	6705                	lui	a4,0x1
    80001154:	97ba                	add	a5,a5,a4
    80001156:	f4bc                	sd	a5,104(s1)
}
    80001158:	8526                	mv	a0,s1
    8000115a:	60e2                	ld	ra,24(sp)
    8000115c:	6442                	ld	s0,16(sp)
    8000115e:	64a2                	ld	s1,8(sp)
    80001160:	6902                	ld	s2,0(sp)
    80001162:	6105                	add	sp,sp,32
    80001164:	8082                	ret
        freeproc(p);
    80001166:	8526                	mv	a0,s1
    80001168:	00000097          	auipc	ra,0x0
    8000116c:	ec6080e7          	jalr	-314(ra) # 8000102e <freeproc>
        release(&p->lock);
    80001170:	8526                	mv	a0,s1
    80001172:	00005097          	auipc	ra,0x5
    80001176:	294080e7          	jalr	660(ra) # 80006406 <release>
        return 0;
    8000117a:	84ca                	mv	s1,s2
    8000117c:	bff1                	j	80001158 <allocproc+0xb0>
        freeproc(p);
    8000117e:	8526                	mv	a0,s1
    80001180:	00000097          	auipc	ra,0x0
    80001184:	eae080e7          	jalr	-338(ra) # 8000102e <freeproc>
        release(&p->lock);
    80001188:	8526                	mv	a0,s1
    8000118a:	00005097          	auipc	ra,0x5
    8000118e:	27c080e7          	jalr	636(ra) # 80006406 <release>
        return 0;
    80001192:	84ca                	mv	s1,s2
    80001194:	b7d1                	j	80001158 <allocproc+0xb0>
        freeproc(p);
    80001196:	8526                	mv	a0,s1
    80001198:	00000097          	auipc	ra,0x0
    8000119c:	e96080e7          	jalr	-362(ra) # 8000102e <freeproc>
        release(&p->lock);
    800011a0:	8526                	mv	a0,s1
    800011a2:	00005097          	auipc	ra,0x5
    800011a6:	264080e7          	jalr	612(ra) # 80006406 <release>
        return 0;
    800011aa:	84ca                	mv	s1,s2
    800011ac:	b775                	j	80001158 <allocproc+0xb0>

00000000800011ae <userinit>:
{
    800011ae:	1101                	add	sp,sp,-32
    800011b0:	ec06                	sd	ra,24(sp)
    800011b2:	e822                	sd	s0,16(sp)
    800011b4:	e426                	sd	s1,8(sp)
    800011b6:	1000                	add	s0,sp,32
    p = allocproc();
    800011b8:	00000097          	auipc	ra,0x0
    800011bc:	ef0080e7          	jalr	-272(ra) # 800010a8 <allocproc>
    800011c0:	84aa                	mv	s1,a0
    initproc = p;
    800011c2:	00008797          	auipc	a5,0x8
    800011c6:	e4a7b723          	sd	a0,-434(a5) # 80009010 <initproc>
    uvminit(p->pagetable, initcode, sizeof(initcode));
    800011ca:	03400613          	li	a2,52
    800011ce:	00007597          	auipc	a1,0x7
    800011d2:	67258593          	add	a1,a1,1650 # 80008840 <initcode>
    800011d6:	6928                	ld	a0,80(a0)
    800011d8:	fffff097          	auipc	ra,0xfffff
    800011dc:	62a080e7          	jalr	1578(ra) # 80000802 <uvminit>
    p->sz = PGSIZE;
    800011e0:	6785                	lui	a5,0x1
    800011e2:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    800011e4:	6cb8                	ld	a4,88(s1)
    800011e6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    800011ea:	6cb8                	ld	a4,88(s1)
    800011ec:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    800011ee:	4641                	li	a2,16
    800011f0:	00007597          	auipc	a1,0x7
    800011f4:	f9058593          	add	a1,a1,-112 # 80008180 <etext+0x180>
    800011f8:	15848513          	add	a0,s1,344
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	0c0080e7          	jalr	192(ra) # 800002bc <safestrcpy>
    p->cwd = namei("/");
    80001204:	00007517          	auipc	a0,0x7
    80001208:	f8c50513          	add	a0,a0,-116 # 80008190 <etext+0x190>
    8000120c:	00002097          	auipc	ra,0x2
    80001210:	1dc080e7          	jalr	476(ra) # 800033e8 <namei>
    80001214:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001218:	478d                	li	a5,3
    8000121a:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    8000121c:	8526                	mv	a0,s1
    8000121e:	00005097          	auipc	ra,0x5
    80001222:	1e8080e7          	jalr	488(ra) # 80006406 <release>
}
    80001226:	60e2                	ld	ra,24(sp)
    80001228:	6442                	ld	s0,16(sp)
    8000122a:	64a2                	ld	s1,8(sp)
    8000122c:	6105                	add	sp,sp,32
    8000122e:	8082                	ret

0000000080001230 <growproc>:
{
    80001230:	1101                	add	sp,sp,-32
    80001232:	ec06                	sd	ra,24(sp)
    80001234:	e822                	sd	s0,16(sp)
    80001236:	e426                	sd	s1,8(sp)
    80001238:	e04a                	sd	s2,0(sp)
    8000123a:	1000                	add	s0,sp,32
    8000123c:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	c3e080e7          	jalr	-962(ra) # 80000e7c <myproc>
    80001246:	892a                	mv	s2,a0
    sz = p->sz;
    80001248:	652c                	ld	a1,72(a0)
    8000124a:	0005879b          	sext.w	a5,a1
    if (n > 0)
    8000124e:	00904f63          	bgtz	s1,8000126c <growproc+0x3c>
    else if (n < 0)
    80001252:	0204cd63          	bltz	s1,8000128c <growproc+0x5c>
    p->sz = sz;
    80001256:	1782                	sll	a5,a5,0x20
    80001258:	9381                	srl	a5,a5,0x20
    8000125a:	04f93423          	sd	a5,72(s2)
    return 0;
    8000125e:	4501                	li	a0,0
}
    80001260:	60e2                	ld	ra,24(sp)
    80001262:	6442                	ld	s0,16(sp)
    80001264:	64a2                	ld	s1,8(sp)
    80001266:	6902                	ld	s2,0(sp)
    80001268:	6105                	add	sp,sp,32
    8000126a:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0)
    8000126c:	00f4863b          	addw	a2,s1,a5
    80001270:	1602                	sll	a2,a2,0x20
    80001272:	9201                	srl	a2,a2,0x20
    80001274:	1582                	sll	a1,a1,0x20
    80001276:	9181                	srl	a1,a1,0x20
    80001278:	6928                	ld	a0,80(a0)
    8000127a:	fffff097          	auipc	ra,0xfffff
    8000127e:	642080e7          	jalr	1602(ra) # 800008bc <uvmalloc>
    80001282:	0005079b          	sext.w	a5,a0
    80001286:	fbe1                	bnez	a5,80001256 <growproc+0x26>
            return -1;
    80001288:	557d                	li	a0,-1
    8000128a:	bfd9                	j	80001260 <growproc+0x30>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000128c:	00f4863b          	addw	a2,s1,a5
    80001290:	1602                	sll	a2,a2,0x20
    80001292:	9201                	srl	a2,a2,0x20
    80001294:	1582                	sll	a1,a1,0x20
    80001296:	9181                	srl	a1,a1,0x20
    80001298:	6928                	ld	a0,80(a0)
    8000129a:	fffff097          	auipc	ra,0xfffff
    8000129e:	5da080e7          	jalr	1498(ra) # 80000874 <uvmdealloc>
    800012a2:	0005079b          	sext.w	a5,a0
    800012a6:	bf45                	j	80001256 <growproc+0x26>

00000000800012a8 <fork>:
{
    800012a8:	7139                	add	sp,sp,-64
    800012aa:	fc06                	sd	ra,56(sp)
    800012ac:	f822                	sd	s0,48(sp)
    800012ae:	f04a                	sd	s2,32(sp)
    800012b0:	e456                	sd	s5,8(sp)
    800012b2:	0080                	add	s0,sp,64
    struct proc *p = myproc();
    800012b4:	00000097          	auipc	ra,0x0
    800012b8:	bc8080e7          	jalr	-1080(ra) # 80000e7c <myproc>
    800012bc:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    800012be:	00000097          	auipc	ra,0x0
    800012c2:	dea080e7          	jalr	-534(ra) # 800010a8 <allocproc>
    800012c6:	12050063          	beqz	a0,800013e6 <fork+0x13e>
    800012ca:	e852                	sd	s4,16(sp)
    800012cc:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    800012ce:	048ab603          	ld	a2,72(s5)
    800012d2:	692c                	ld	a1,80(a0)
    800012d4:	050ab503          	ld	a0,80(s5)
    800012d8:	fffff097          	auipc	ra,0xfffff
    800012dc:	73c080e7          	jalr	1852(ra) # 80000a14 <uvmcopy>
    800012e0:	04054a63          	bltz	a0,80001334 <fork+0x8c>
    800012e4:	f426                	sd	s1,40(sp)
    800012e6:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    800012e8:	048ab783          	ld	a5,72(s5)
    800012ec:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    800012f0:	058ab683          	ld	a3,88(s5)
    800012f4:	87b6                	mv	a5,a3
    800012f6:	058a3703          	ld	a4,88(s4)
    800012fa:	12068693          	add	a3,a3,288
    800012fe:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001302:	6788                	ld	a0,8(a5)
    80001304:	6b8c                	ld	a1,16(a5)
    80001306:	6f90                	ld	a2,24(a5)
    80001308:	01073023          	sd	a6,0(a4)
    8000130c:	e708                	sd	a0,8(a4)
    8000130e:	eb0c                	sd	a1,16(a4)
    80001310:	ef10                	sd	a2,24(a4)
    80001312:	02078793          	add	a5,a5,32
    80001316:	02070713          	add	a4,a4,32
    8000131a:	fed792e3          	bne	a5,a3,800012fe <fork+0x56>
    np->trapframe->a0 = 0;
    8000131e:	058a3783          	ld	a5,88(s4)
    80001322:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    80001326:	0d0a8493          	add	s1,s5,208
    8000132a:	0d0a0913          	add	s2,s4,208
    8000132e:	150a8993          	add	s3,s5,336
    80001332:	a015                	j	80001356 <fork+0xae>
        freeproc(np);
    80001334:	8552                	mv	a0,s4
    80001336:	00000097          	auipc	ra,0x0
    8000133a:	cf8080e7          	jalr	-776(ra) # 8000102e <freeproc>
        release(&np->lock);
    8000133e:	8552                	mv	a0,s4
    80001340:	00005097          	auipc	ra,0x5
    80001344:	0c6080e7          	jalr	198(ra) # 80006406 <release>
        return -1;
    80001348:	597d                	li	s2,-1
    8000134a:	6a42                	ld	s4,16(sp)
    8000134c:	a071                	j	800013d8 <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    8000134e:	04a1                	add	s1,s1,8
    80001350:	0921                	add	s2,s2,8
    80001352:	01348b63          	beq	s1,s3,80001368 <fork+0xc0>
        if (p->ofile[i])
    80001356:	6088                	ld	a0,0(s1)
    80001358:	d97d                	beqz	a0,8000134e <fork+0xa6>
            np->ofile[i] = filedup(p->ofile[i]);
    8000135a:	00002097          	auipc	ra,0x2
    8000135e:	706080e7          	jalr	1798(ra) # 80003a60 <filedup>
    80001362:	00a93023          	sd	a0,0(s2)
    80001366:	b7e5                	j	8000134e <fork+0xa6>
    np->cwd = idup(p->cwd);
    80001368:	150ab503          	ld	a0,336(s5)
    8000136c:	00002097          	auipc	ra,0x2
    80001370:	86c080e7          	jalr	-1940(ra) # 80002bd8 <idup>
    80001374:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80001378:	4641                	li	a2,16
    8000137a:	158a8593          	add	a1,s5,344
    8000137e:	158a0513          	add	a0,s4,344
    80001382:	fffff097          	auipc	ra,0xfffff
    80001386:	f3a080e7          	jalr	-198(ra) # 800002bc <safestrcpy>
    pid = np->pid;
    8000138a:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    8000138e:	8552                	mv	a0,s4
    80001390:	00005097          	auipc	ra,0x5
    80001394:	076080e7          	jalr	118(ra) # 80006406 <release>
    acquire(&wait_lock);
    80001398:	00008497          	auipc	s1,0x8
    8000139c:	cd048493          	add	s1,s1,-816 # 80009068 <wait_lock>
    800013a0:	8526                	mv	a0,s1
    800013a2:	00005097          	auipc	ra,0x5
    800013a6:	fb0080e7          	jalr	-80(ra) # 80006352 <acquire>
    np->parent = p;
    800013aa:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    800013ae:	8526                	mv	a0,s1
    800013b0:	00005097          	auipc	ra,0x5
    800013b4:	056080e7          	jalr	86(ra) # 80006406 <release>
    acquire(&np->lock);
    800013b8:	8552                	mv	a0,s4
    800013ba:	00005097          	auipc	ra,0x5
    800013be:	f98080e7          	jalr	-104(ra) # 80006352 <acquire>
    np->state = RUNNABLE;
    800013c2:	478d                	li	a5,3
    800013c4:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    800013c8:	8552                	mv	a0,s4
    800013ca:	00005097          	auipc	ra,0x5
    800013ce:	03c080e7          	jalr	60(ra) # 80006406 <release>
    return pid;
    800013d2:	74a2                	ld	s1,40(sp)
    800013d4:	69e2                	ld	s3,24(sp)
    800013d6:	6a42                	ld	s4,16(sp)
}
    800013d8:	854a                	mv	a0,s2
    800013da:	70e2                	ld	ra,56(sp)
    800013dc:	7442                	ld	s0,48(sp)
    800013de:	7902                	ld	s2,32(sp)
    800013e0:	6aa2                	ld	s5,8(sp)
    800013e2:	6121                	add	sp,sp,64
    800013e4:	8082                	ret
        return -1;
    800013e6:	597d                	li	s2,-1
    800013e8:	bfc5                	j	800013d8 <fork+0x130>

00000000800013ea <scheduler>:
{
    800013ea:	7139                	add	sp,sp,-64
    800013ec:	fc06                	sd	ra,56(sp)
    800013ee:	f822                	sd	s0,48(sp)
    800013f0:	f426                	sd	s1,40(sp)
    800013f2:	f04a                	sd	s2,32(sp)
    800013f4:	ec4e                	sd	s3,24(sp)
    800013f6:	e852                	sd	s4,16(sp)
    800013f8:	e456                	sd	s5,8(sp)
    800013fa:	e05a                	sd	s6,0(sp)
    800013fc:	0080                	add	s0,sp,64
    800013fe:	8792                	mv	a5,tp
    int id = r_tp();
    80001400:	2781                	sext.w	a5,a5
    c->proc = 0;
    80001402:	00779a93          	sll	s5,a5,0x7
    80001406:	00008717          	auipc	a4,0x8
    8000140a:	c4a70713          	add	a4,a4,-950 # 80009050 <pid_lock>
    8000140e:	9756                	add	a4,a4,s5
    80001410:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    80001414:	00008717          	auipc	a4,0x8
    80001418:	c7470713          	add	a4,a4,-908 # 80009088 <cpus+0x8>
    8000141c:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE)
    8000141e:	498d                	li	s3,3
                p->state = RUNNING;
    80001420:	4b11                	li	s6,4
                c->proc = p;
    80001422:	079e                	sll	a5,a5,0x7
    80001424:	00008a17          	auipc	s4,0x8
    80001428:	c2ca0a13          	add	s4,s4,-980 # 80009050 <pid_lock>
    8000142c:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++)
    8000142e:	0000e917          	auipc	s2,0xe
    80001432:	25290913          	add	s2,s2,594 # 8000f680 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001436:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000143a:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000143e:	10079073          	csrw	sstatus,a5
    80001442:	00008497          	auipc	s1,0x8
    80001446:	03e48493          	add	s1,s1,62 # 80009480 <proc>
    8000144a:	a811                	j	8000145e <scheduler+0x74>
            release(&p->lock);
    8000144c:	8526                	mv	a0,s1
    8000144e:	00005097          	auipc	ra,0x5
    80001452:	fb8080e7          	jalr	-72(ra) # 80006406 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    80001456:	18848493          	add	s1,s1,392
    8000145a:	fd248ee3          	beq	s1,s2,80001436 <scheduler+0x4c>
            acquire(&p->lock);
    8000145e:	8526                	mv	a0,s1
    80001460:	00005097          	auipc	ra,0x5
    80001464:	ef2080e7          	jalr	-270(ra) # 80006352 <acquire>
            if (p->state == RUNNABLE)
    80001468:	4c9c                	lw	a5,24(s1)
    8000146a:	ff3791e3          	bne	a5,s3,8000144c <scheduler+0x62>
                p->state = RUNNING;
    8000146e:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    80001472:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    80001476:	06048593          	add	a1,s1,96
    8000147a:	8556                	mv	a0,s5
    8000147c:	00000097          	auipc	ra,0x0
    80001480:	620080e7          	jalr	1568(ra) # 80001a9c <swtch>
                c->proc = 0;
    80001484:	020a3823          	sd	zero,48(s4)
    80001488:	b7d1                	j	8000144c <scheduler+0x62>

000000008000148a <sched>:
{
    8000148a:	7179                	add	sp,sp,-48
    8000148c:	f406                	sd	ra,40(sp)
    8000148e:	f022                	sd	s0,32(sp)
    80001490:	ec26                	sd	s1,24(sp)
    80001492:	e84a                	sd	s2,16(sp)
    80001494:	e44e                	sd	s3,8(sp)
    80001496:	1800                	add	s0,sp,48
    struct proc *p = myproc();
    80001498:	00000097          	auipc	ra,0x0
    8000149c:	9e4080e7          	jalr	-1564(ra) # 80000e7c <myproc>
    800014a0:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    800014a2:	00005097          	auipc	ra,0x5
    800014a6:	e36080e7          	jalr	-458(ra) # 800062d8 <holding>
    800014aa:	c93d                	beqz	a0,80001520 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014ac:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    800014ae:	2781                	sext.w	a5,a5
    800014b0:	079e                	sll	a5,a5,0x7
    800014b2:	00008717          	auipc	a4,0x8
    800014b6:	b9e70713          	add	a4,a4,-1122 # 80009050 <pid_lock>
    800014ba:	97ba                	add	a5,a5,a4
    800014bc:	0a87a703          	lw	a4,168(a5)
    800014c0:	4785                	li	a5,1
    800014c2:	06f71763          	bne	a4,a5,80001530 <sched+0xa6>
    if (p->state == RUNNING)
    800014c6:	4c98                	lw	a4,24(s1)
    800014c8:	4791                	li	a5,4
    800014ca:	06f70b63          	beq	a4,a5,80001540 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014ce:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014d2:	8b89                	and	a5,a5,2
    if (intr_get())
    800014d4:	efb5                	bnez	a5,80001550 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014d6:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    800014d8:	00008917          	auipc	s2,0x8
    800014dc:	b7890913          	add	s2,s2,-1160 # 80009050 <pid_lock>
    800014e0:	2781                	sext.w	a5,a5
    800014e2:	079e                	sll	a5,a5,0x7
    800014e4:	97ca                	add	a5,a5,s2
    800014e6:	0ac7a983          	lw	s3,172(a5)
    800014ea:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    800014ec:	2781                	sext.w	a5,a5
    800014ee:	079e                	sll	a5,a5,0x7
    800014f0:	00008597          	auipc	a1,0x8
    800014f4:	b9858593          	add	a1,a1,-1128 # 80009088 <cpus+0x8>
    800014f8:	95be                	add	a1,a1,a5
    800014fa:	06048513          	add	a0,s1,96
    800014fe:	00000097          	auipc	ra,0x0
    80001502:	59e080e7          	jalr	1438(ra) # 80001a9c <swtch>
    80001506:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80001508:	2781                	sext.w	a5,a5
    8000150a:	079e                	sll	a5,a5,0x7
    8000150c:	993e                	add	s2,s2,a5
    8000150e:	0b392623          	sw	s3,172(s2)
}
    80001512:	70a2                	ld	ra,40(sp)
    80001514:	7402                	ld	s0,32(sp)
    80001516:	64e2                	ld	s1,24(sp)
    80001518:	6942                	ld	s2,16(sp)
    8000151a:	69a2                	ld	s3,8(sp)
    8000151c:	6145                	add	sp,sp,48
    8000151e:	8082                	ret
        panic("sched p->lock");
    80001520:	00007517          	auipc	a0,0x7
    80001524:	c7850513          	add	a0,a0,-904 # 80008198 <etext+0x198>
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	854080e7          	jalr	-1964(ra) # 80005d7c <panic>
        panic("sched locks");
    80001530:	00007517          	auipc	a0,0x7
    80001534:	c7850513          	add	a0,a0,-904 # 800081a8 <etext+0x1a8>
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	844080e7          	jalr	-1980(ra) # 80005d7c <panic>
        panic("sched running");
    80001540:	00007517          	auipc	a0,0x7
    80001544:	c7850513          	add	a0,a0,-904 # 800081b8 <etext+0x1b8>
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	834080e7          	jalr	-1996(ra) # 80005d7c <panic>
        panic("sched interruptible");
    80001550:	00007517          	auipc	a0,0x7
    80001554:	c7850513          	add	a0,a0,-904 # 800081c8 <etext+0x1c8>
    80001558:	00005097          	auipc	ra,0x5
    8000155c:	824080e7          	jalr	-2012(ra) # 80005d7c <panic>

0000000080001560 <yield>:
{
    80001560:	1101                	add	sp,sp,-32
    80001562:	ec06                	sd	ra,24(sp)
    80001564:	e822                	sd	s0,16(sp)
    80001566:	e426                	sd	s1,8(sp)
    80001568:	1000                	add	s0,sp,32
    struct proc *p = myproc();
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	912080e7          	jalr	-1774(ra) # 80000e7c <myproc>
    80001572:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80001574:	00005097          	auipc	ra,0x5
    80001578:	dde080e7          	jalr	-546(ra) # 80006352 <acquire>
    p->state = RUNNABLE;
    8000157c:	478d                	li	a5,3
    8000157e:	cc9c                	sw	a5,24(s1)
    sched();
    80001580:	00000097          	auipc	ra,0x0
    80001584:	f0a080e7          	jalr	-246(ra) # 8000148a <sched>
    release(&p->lock);
    80001588:	8526                	mv	a0,s1
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	e7c080e7          	jalr	-388(ra) # 80006406 <release>
}
    80001592:	60e2                	ld	ra,24(sp)
    80001594:	6442                	ld	s0,16(sp)
    80001596:	64a2                	ld	s1,8(sp)
    80001598:	6105                	add	sp,sp,32
    8000159a:	8082                	ret

000000008000159c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000159c:	7179                	add	sp,sp,-48
    8000159e:	f406                	sd	ra,40(sp)
    800015a0:	f022                	sd	s0,32(sp)
    800015a2:	ec26                	sd	s1,24(sp)
    800015a4:	e84a                	sd	s2,16(sp)
    800015a6:	e44e                	sd	s3,8(sp)
    800015a8:	1800                	add	s0,sp,48
    800015aa:	89aa                	mv	s3,a0
    800015ac:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800015ae:	00000097          	auipc	ra,0x0
    800015b2:	8ce080e7          	jalr	-1842(ra) # 80000e7c <myproc>
    800015b6:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    800015b8:	00005097          	auipc	ra,0x5
    800015bc:	d9a080e7          	jalr	-614(ra) # 80006352 <acquire>
    release(lk);
    800015c0:	854a                	mv	a0,s2
    800015c2:	00005097          	auipc	ra,0x5
    800015c6:	e44080e7          	jalr	-444(ra) # 80006406 <release>

    // Go to sleep.
    p->chan = chan;
    800015ca:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    800015ce:	4789                	li	a5,2
    800015d0:	cc9c                	sw	a5,24(s1)

    sched();
    800015d2:	00000097          	auipc	ra,0x0
    800015d6:	eb8080e7          	jalr	-328(ra) # 8000148a <sched>

    // Tidy up.
    p->chan = 0;
    800015da:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    800015de:	8526                	mv	a0,s1
    800015e0:	00005097          	auipc	ra,0x5
    800015e4:	e26080e7          	jalr	-474(ra) # 80006406 <release>
    acquire(lk);
    800015e8:	854a                	mv	a0,s2
    800015ea:	00005097          	auipc	ra,0x5
    800015ee:	d68080e7          	jalr	-664(ra) # 80006352 <acquire>
}
    800015f2:	70a2                	ld	ra,40(sp)
    800015f4:	7402                	ld	s0,32(sp)
    800015f6:	64e2                	ld	s1,24(sp)
    800015f8:	6942                	ld	s2,16(sp)
    800015fa:	69a2                	ld	s3,8(sp)
    800015fc:	6145                	add	sp,sp,48
    800015fe:	8082                	ret

0000000080001600 <wait>:
{
    80001600:	715d                	add	sp,sp,-80
    80001602:	e486                	sd	ra,72(sp)
    80001604:	e0a2                	sd	s0,64(sp)
    80001606:	fc26                	sd	s1,56(sp)
    80001608:	f84a                	sd	s2,48(sp)
    8000160a:	f44e                	sd	s3,40(sp)
    8000160c:	f052                	sd	s4,32(sp)
    8000160e:	ec56                	sd	s5,24(sp)
    80001610:	e85a                	sd	s6,16(sp)
    80001612:	e45e                	sd	s7,8(sp)
    80001614:	e062                	sd	s8,0(sp)
    80001616:	0880                	add	s0,sp,80
    80001618:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    8000161a:	00000097          	auipc	ra,0x0
    8000161e:	862080e7          	jalr	-1950(ra) # 80000e7c <myproc>
    80001622:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80001624:	00008517          	auipc	a0,0x8
    80001628:	a4450513          	add	a0,a0,-1468 # 80009068 <wait_lock>
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	d26080e7          	jalr	-730(ra) # 80006352 <acquire>
        havekids = 0;
    80001634:	4b81                	li	s7,0
                if (np->state == ZOMBIE)
    80001636:	4a15                	li	s4,5
                havekids = 1;
    80001638:	4a85                	li	s5,1
        for (np = proc; np < &proc[NPROC]; np++)
    8000163a:	0000e997          	auipc	s3,0xe
    8000163e:	04698993          	add	s3,s3,70 # 8000f680 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001642:	00008c17          	auipc	s8,0x8
    80001646:	a26c0c13          	add	s8,s8,-1498 # 80009068 <wait_lock>
    8000164a:	a87d                	j	80001708 <wait+0x108>
                    pid = np->pid;
    8000164c:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001650:	000b0e63          	beqz	s6,8000166c <wait+0x6c>
    80001654:	4691                	li	a3,4
    80001656:	02c48613          	add	a2,s1,44
    8000165a:	85da                	mv	a1,s6
    8000165c:	05093503          	ld	a0,80(s2)
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	4b8080e7          	jalr	1208(ra) # 80000b18 <copyout>
    80001668:	04054163          	bltz	a0,800016aa <wait+0xaa>
                    freeproc(np);
    8000166c:	8526                	mv	a0,s1
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	9c0080e7          	jalr	-1600(ra) # 8000102e <freeproc>
                    release(&np->lock);
    80001676:	8526                	mv	a0,s1
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	d8e080e7          	jalr	-626(ra) # 80006406 <release>
                    release(&wait_lock);
    80001680:	00008517          	auipc	a0,0x8
    80001684:	9e850513          	add	a0,a0,-1560 # 80009068 <wait_lock>
    80001688:	00005097          	auipc	ra,0x5
    8000168c:	d7e080e7          	jalr	-642(ra) # 80006406 <release>
}
    80001690:	854e                	mv	a0,s3
    80001692:	60a6                	ld	ra,72(sp)
    80001694:	6406                	ld	s0,64(sp)
    80001696:	74e2                	ld	s1,56(sp)
    80001698:	7942                	ld	s2,48(sp)
    8000169a:	79a2                	ld	s3,40(sp)
    8000169c:	7a02                	ld	s4,32(sp)
    8000169e:	6ae2                	ld	s5,24(sp)
    800016a0:	6b42                	ld	s6,16(sp)
    800016a2:	6ba2                	ld	s7,8(sp)
    800016a4:	6c02                	ld	s8,0(sp)
    800016a6:	6161                	add	sp,sp,80
    800016a8:	8082                	ret
                        release(&np->lock);
    800016aa:	8526                	mv	a0,s1
    800016ac:	00005097          	auipc	ra,0x5
    800016b0:	d5a080e7          	jalr	-678(ra) # 80006406 <release>
                        release(&wait_lock);
    800016b4:	00008517          	auipc	a0,0x8
    800016b8:	9b450513          	add	a0,a0,-1612 # 80009068 <wait_lock>
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	d4a080e7          	jalr	-694(ra) # 80006406 <release>
                        return -1;
    800016c4:	59fd                	li	s3,-1
    800016c6:	b7e9                	j	80001690 <wait+0x90>
        for (np = proc; np < &proc[NPROC]; np++)
    800016c8:	18848493          	add	s1,s1,392
    800016cc:	03348463          	beq	s1,s3,800016f4 <wait+0xf4>
            if (np->parent == p)
    800016d0:	7c9c                	ld	a5,56(s1)
    800016d2:	ff279be3          	bne	a5,s2,800016c8 <wait+0xc8>
                acquire(&np->lock);
    800016d6:	8526                	mv	a0,s1
    800016d8:	00005097          	auipc	ra,0x5
    800016dc:	c7a080e7          	jalr	-902(ra) # 80006352 <acquire>
                if (np->state == ZOMBIE)
    800016e0:	4c9c                	lw	a5,24(s1)
    800016e2:	f74785e3          	beq	a5,s4,8000164c <wait+0x4c>
                release(&np->lock);
    800016e6:	8526                	mv	a0,s1
    800016e8:	00005097          	auipc	ra,0x5
    800016ec:	d1e080e7          	jalr	-738(ra) # 80006406 <release>
                havekids = 1;
    800016f0:	8756                	mv	a4,s5
    800016f2:	bfd9                	j	800016c8 <wait+0xc8>
        if (!havekids || p->killed)
    800016f4:	c305                	beqz	a4,80001714 <wait+0x114>
    800016f6:	02892783          	lw	a5,40(s2)
    800016fa:	ef89                	bnez	a5,80001714 <wait+0x114>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800016fc:	85e2                	mv	a1,s8
    800016fe:	854a                	mv	a0,s2
    80001700:	00000097          	auipc	ra,0x0
    80001704:	e9c080e7          	jalr	-356(ra) # 8000159c <sleep>
        havekids = 0;
    80001708:	875e                	mv	a4,s7
        for (np = proc; np < &proc[NPROC]; np++)
    8000170a:	00008497          	auipc	s1,0x8
    8000170e:	d7648493          	add	s1,s1,-650 # 80009480 <proc>
    80001712:	bf7d                	j	800016d0 <wait+0xd0>
            release(&wait_lock);
    80001714:	00008517          	auipc	a0,0x8
    80001718:	95450513          	add	a0,a0,-1708 # 80009068 <wait_lock>
    8000171c:	00005097          	auipc	ra,0x5
    80001720:	cea080e7          	jalr	-790(ra) # 80006406 <release>
            return -1;
    80001724:	59fd                	li	s3,-1
    80001726:	b7ad                	j	80001690 <wait+0x90>

0000000080001728 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80001728:	7139                	add	sp,sp,-64
    8000172a:	fc06                	sd	ra,56(sp)
    8000172c:	f822                	sd	s0,48(sp)
    8000172e:	f426                	sd	s1,40(sp)
    80001730:	f04a                	sd	s2,32(sp)
    80001732:	ec4e                	sd	s3,24(sp)
    80001734:	e852                	sd	s4,16(sp)
    80001736:	e456                	sd	s5,8(sp)
    80001738:	0080                	add	s0,sp,64
    8000173a:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000173c:	00008497          	auipc	s1,0x8
    80001740:	d4448493          	add	s1,s1,-700 # 80009480 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80001744:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    80001746:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    80001748:	0000e917          	auipc	s2,0xe
    8000174c:	f3890913          	add	s2,s2,-200 # 8000f680 <tickslock>
    80001750:	a811                	j	80001764 <wakeup+0x3c>
            }
            release(&p->lock);
    80001752:	8526                	mv	a0,s1
    80001754:	00005097          	auipc	ra,0x5
    80001758:	cb2080e7          	jalr	-846(ra) # 80006406 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000175c:	18848493          	add	s1,s1,392
    80001760:	03248663          	beq	s1,s2,8000178c <wakeup+0x64>
        if (p != myproc())
    80001764:	fffff097          	auipc	ra,0xfffff
    80001768:	718080e7          	jalr	1816(ra) # 80000e7c <myproc>
    8000176c:	fea488e3          	beq	s1,a0,8000175c <wakeup+0x34>
            acquire(&p->lock);
    80001770:	8526                	mv	a0,s1
    80001772:	00005097          	auipc	ra,0x5
    80001776:	be0080e7          	jalr	-1056(ra) # 80006352 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    8000177a:	4c9c                	lw	a5,24(s1)
    8000177c:	fd379be3          	bne	a5,s3,80001752 <wakeup+0x2a>
    80001780:	709c                	ld	a5,32(s1)
    80001782:	fd4798e3          	bne	a5,s4,80001752 <wakeup+0x2a>
                p->state = RUNNABLE;
    80001786:	0154ac23          	sw	s5,24(s1)
    8000178a:	b7e1                	j	80001752 <wakeup+0x2a>
        }
    }
}
    8000178c:	70e2                	ld	ra,56(sp)
    8000178e:	7442                	ld	s0,48(sp)
    80001790:	74a2                	ld	s1,40(sp)
    80001792:	7902                	ld	s2,32(sp)
    80001794:	69e2                	ld	s3,24(sp)
    80001796:	6a42                	ld	s4,16(sp)
    80001798:	6aa2                	ld	s5,8(sp)
    8000179a:	6121                	add	sp,sp,64
    8000179c:	8082                	ret

000000008000179e <reparent>:
{
    8000179e:	7179                	add	sp,sp,-48
    800017a0:	f406                	sd	ra,40(sp)
    800017a2:	f022                	sd	s0,32(sp)
    800017a4:	ec26                	sd	s1,24(sp)
    800017a6:	e84a                	sd	s2,16(sp)
    800017a8:	e44e                	sd	s3,8(sp)
    800017aa:	e052                	sd	s4,0(sp)
    800017ac:	1800                	add	s0,sp,48
    800017ae:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800017b0:	00008497          	auipc	s1,0x8
    800017b4:	cd048493          	add	s1,s1,-816 # 80009480 <proc>
            pp->parent = initproc;
    800017b8:	00008a17          	auipc	s4,0x8
    800017bc:	858a0a13          	add	s4,s4,-1960 # 80009010 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800017c0:	0000e997          	auipc	s3,0xe
    800017c4:	ec098993          	add	s3,s3,-320 # 8000f680 <tickslock>
    800017c8:	a029                	j	800017d2 <reparent+0x34>
    800017ca:	18848493          	add	s1,s1,392
    800017ce:	01348d63          	beq	s1,s3,800017e8 <reparent+0x4a>
        if (pp->parent == p)
    800017d2:	7c9c                	ld	a5,56(s1)
    800017d4:	ff279be3          	bne	a5,s2,800017ca <reparent+0x2c>
            pp->parent = initproc;
    800017d8:	000a3503          	ld	a0,0(s4)
    800017dc:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    800017de:	00000097          	auipc	ra,0x0
    800017e2:	f4a080e7          	jalr	-182(ra) # 80001728 <wakeup>
    800017e6:	b7d5                	j	800017ca <reparent+0x2c>
}
    800017e8:	70a2                	ld	ra,40(sp)
    800017ea:	7402                	ld	s0,32(sp)
    800017ec:	64e2                	ld	s1,24(sp)
    800017ee:	6942                	ld	s2,16(sp)
    800017f0:	69a2                	ld	s3,8(sp)
    800017f2:	6a02                	ld	s4,0(sp)
    800017f4:	6145                	add	sp,sp,48
    800017f6:	8082                	ret

00000000800017f8 <exit>:
{
    800017f8:	7179                	add	sp,sp,-48
    800017fa:	f406                	sd	ra,40(sp)
    800017fc:	f022                	sd	s0,32(sp)
    800017fe:	ec26                	sd	s1,24(sp)
    80001800:	e84a                	sd	s2,16(sp)
    80001802:	e44e                	sd	s3,8(sp)
    80001804:	e052                	sd	s4,0(sp)
    80001806:	1800                	add	s0,sp,48
    80001808:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000180a:	fffff097          	auipc	ra,0xfffff
    8000180e:	672080e7          	jalr	1650(ra) # 80000e7c <myproc>
    80001812:	89aa                	mv	s3,a0
    if (p == initproc)
    80001814:	00007797          	auipc	a5,0x7
    80001818:	7fc7b783          	ld	a5,2044(a5) # 80009010 <initproc>
    8000181c:	0d050493          	add	s1,a0,208
    80001820:	15050913          	add	s2,a0,336
    80001824:	02a79363          	bne	a5,a0,8000184a <exit+0x52>
        panic("init exiting");
    80001828:	00007517          	auipc	a0,0x7
    8000182c:	9b850513          	add	a0,a0,-1608 # 800081e0 <etext+0x1e0>
    80001830:	00004097          	auipc	ra,0x4
    80001834:	54c080e7          	jalr	1356(ra) # 80005d7c <panic>
            fileclose(f);
    80001838:	00002097          	auipc	ra,0x2
    8000183c:	27a080e7          	jalr	634(ra) # 80003ab2 <fileclose>
            p->ofile[fd] = 0;
    80001840:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    80001844:	04a1                	add	s1,s1,8
    80001846:	01248563          	beq	s1,s2,80001850 <exit+0x58>
        if (p->ofile[fd])
    8000184a:	6088                	ld	a0,0(s1)
    8000184c:	f575                	bnez	a0,80001838 <exit+0x40>
    8000184e:	bfdd                	j	80001844 <exit+0x4c>
    begin_op();
    80001850:	00002097          	auipc	ra,0x2
    80001854:	d98080e7          	jalr	-616(ra) # 800035e8 <begin_op>
    iput(p->cwd);
    80001858:	1509b503          	ld	a0,336(s3)
    8000185c:	00001097          	auipc	ra,0x1
    80001860:	578080e7          	jalr	1400(ra) # 80002dd4 <iput>
    end_op();
    80001864:	00002097          	auipc	ra,0x2
    80001868:	dfe080e7          	jalr	-514(ra) # 80003662 <end_op>
    p->cwd = 0;
    8000186c:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    80001870:	00007497          	auipc	s1,0x7
    80001874:	7f848493          	add	s1,s1,2040 # 80009068 <wait_lock>
    80001878:	8526                	mv	a0,s1
    8000187a:	00005097          	auipc	ra,0x5
    8000187e:	ad8080e7          	jalr	-1320(ra) # 80006352 <acquire>
    reparent(p);
    80001882:	854e                	mv	a0,s3
    80001884:	00000097          	auipc	ra,0x0
    80001888:	f1a080e7          	jalr	-230(ra) # 8000179e <reparent>
    wakeup(p->parent);
    8000188c:	0389b503          	ld	a0,56(s3)
    80001890:	00000097          	auipc	ra,0x0
    80001894:	e98080e7          	jalr	-360(ra) # 80001728 <wakeup>
    acquire(&p->lock);
    80001898:	854e                	mv	a0,s3
    8000189a:	00005097          	auipc	ra,0x5
    8000189e:	ab8080e7          	jalr	-1352(ra) # 80006352 <acquire>
    p->xstate = status;
    800018a2:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800018a6:	4795                	li	a5,5
    800018a8:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800018ac:	8526                	mv	a0,s1
    800018ae:	00005097          	auipc	ra,0x5
    800018b2:	b58080e7          	jalr	-1192(ra) # 80006406 <release>
    sched();
    800018b6:	00000097          	auipc	ra,0x0
    800018ba:	bd4080e7          	jalr	-1068(ra) # 8000148a <sched>
    panic("zombie exit");
    800018be:	00007517          	auipc	a0,0x7
    800018c2:	93250513          	add	a0,a0,-1742 # 800081f0 <etext+0x1f0>
    800018c6:	00004097          	auipc	ra,0x4
    800018ca:	4b6080e7          	jalr	1206(ra) # 80005d7c <panic>

00000000800018ce <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800018ce:	7179                	add	sp,sp,-48
    800018d0:	f406                	sd	ra,40(sp)
    800018d2:	f022                	sd	s0,32(sp)
    800018d4:	ec26                	sd	s1,24(sp)
    800018d6:	e84a                	sd	s2,16(sp)
    800018d8:	e44e                	sd	s3,8(sp)
    800018da:	1800                	add	s0,sp,48
    800018dc:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800018de:	00008497          	auipc	s1,0x8
    800018e2:	ba248493          	add	s1,s1,-1118 # 80009480 <proc>
    800018e6:	0000e997          	auipc	s3,0xe
    800018ea:	d9a98993          	add	s3,s3,-614 # 8000f680 <tickslock>
    {
        acquire(&p->lock);
    800018ee:	8526                	mv	a0,s1
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	a62080e7          	jalr	-1438(ra) # 80006352 <acquire>
        if (p->pid == pid)
    800018f8:	589c                	lw	a5,48(s1)
    800018fa:	01278d63          	beq	a5,s2,80001914 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    800018fe:	8526                	mv	a0,s1
    80001900:	00005097          	auipc	ra,0x5
    80001904:	b06080e7          	jalr	-1274(ra) # 80006406 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001908:	18848493          	add	s1,s1,392
    8000190c:	ff3491e3          	bne	s1,s3,800018ee <kill+0x20>
    }
    return -1;
    80001910:	557d                	li	a0,-1
    80001912:	a829                	j	8000192c <kill+0x5e>
            p->killed = 1;
    80001914:	4785                	li	a5,1
    80001916:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    80001918:	4c98                	lw	a4,24(s1)
    8000191a:	4789                	li	a5,2
    8000191c:	00f70f63          	beq	a4,a5,8000193a <kill+0x6c>
            release(&p->lock);
    80001920:	8526                	mv	a0,s1
    80001922:	00005097          	auipc	ra,0x5
    80001926:	ae4080e7          	jalr	-1308(ra) # 80006406 <release>
            return 0;
    8000192a:	4501                	li	a0,0
}
    8000192c:	70a2                	ld	ra,40(sp)
    8000192e:	7402                	ld	s0,32(sp)
    80001930:	64e2                	ld	s1,24(sp)
    80001932:	6942                	ld	s2,16(sp)
    80001934:	69a2                	ld	s3,8(sp)
    80001936:	6145                	add	sp,sp,48
    80001938:	8082                	ret
                p->state = RUNNABLE;
    8000193a:	478d                	li	a5,3
    8000193c:	cc9c                	sw	a5,24(s1)
    8000193e:	b7cd                	j	80001920 <kill+0x52>

0000000080001940 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001940:	7179                	add	sp,sp,-48
    80001942:	f406                	sd	ra,40(sp)
    80001944:	f022                	sd	s0,32(sp)
    80001946:	ec26                	sd	s1,24(sp)
    80001948:	e84a                	sd	s2,16(sp)
    8000194a:	e44e                	sd	s3,8(sp)
    8000194c:	e052                	sd	s4,0(sp)
    8000194e:	1800                	add	s0,sp,48
    80001950:	84aa                	mv	s1,a0
    80001952:	892e                	mv	s2,a1
    80001954:	89b2                	mv	s3,a2
    80001956:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	524080e7          	jalr	1316(ra) # 80000e7c <myproc>
    if (user_dst)
    80001960:	c08d                	beqz	s1,80001982 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80001962:	86d2                	mv	a3,s4
    80001964:	864e                	mv	a2,s3
    80001966:	85ca                	mv	a1,s2
    80001968:	6928                	ld	a0,80(a0)
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	1ae080e7          	jalr	430(ra) # 80000b18 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80001972:	70a2                	ld	ra,40(sp)
    80001974:	7402                	ld	s0,32(sp)
    80001976:	64e2                	ld	s1,24(sp)
    80001978:	6942                	ld	s2,16(sp)
    8000197a:	69a2                	ld	s3,8(sp)
    8000197c:	6a02                	ld	s4,0(sp)
    8000197e:	6145                	add	sp,sp,48
    80001980:	8082                	ret
        memmove((char *)dst, src, len);
    80001982:	000a061b          	sext.w	a2,s4
    80001986:	85ce                	mv	a1,s3
    80001988:	854a                	mv	a0,s2
    8000198a:	fffff097          	auipc	ra,0xfffff
    8000198e:	84c080e7          	jalr	-1972(ra) # 800001d6 <memmove>
        return 0;
    80001992:	8526                	mv	a0,s1
    80001994:	bff9                	j	80001972 <either_copyout+0x32>

0000000080001996 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001996:	7179                	add	sp,sp,-48
    80001998:	f406                	sd	ra,40(sp)
    8000199a:	f022                	sd	s0,32(sp)
    8000199c:	ec26                	sd	s1,24(sp)
    8000199e:	e84a                	sd	s2,16(sp)
    800019a0:	e44e                	sd	s3,8(sp)
    800019a2:	e052                	sd	s4,0(sp)
    800019a4:	1800                	add	s0,sp,48
    800019a6:	892a                	mv	s2,a0
    800019a8:	84ae                	mv	s1,a1
    800019aa:	89b2                	mv	s3,a2
    800019ac:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800019ae:	fffff097          	auipc	ra,0xfffff
    800019b2:	4ce080e7          	jalr	1230(ra) # 80000e7c <myproc>
    if (user_src)
    800019b6:	c08d                	beqz	s1,800019d8 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    800019b8:	86d2                	mv	a3,s4
    800019ba:	864e                	mv	a2,s3
    800019bc:	85ca                	mv	a1,s2
    800019be:	6928                	ld	a0,80(a0)
    800019c0:	fffff097          	auipc	ra,0xfffff
    800019c4:	1e4080e7          	jalr	484(ra) # 80000ba4 <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800019c8:	70a2                	ld	ra,40(sp)
    800019ca:	7402                	ld	s0,32(sp)
    800019cc:	64e2                	ld	s1,24(sp)
    800019ce:	6942                	ld	s2,16(sp)
    800019d0:	69a2                	ld	s3,8(sp)
    800019d2:	6a02                	ld	s4,0(sp)
    800019d4:	6145                	add	sp,sp,48
    800019d6:	8082                	ret
        memmove(dst, (char *)src, len);
    800019d8:	000a061b          	sext.w	a2,s4
    800019dc:	85ce                	mv	a1,s3
    800019de:	854a                	mv	a0,s2
    800019e0:	ffffe097          	auipc	ra,0xffffe
    800019e4:	7f6080e7          	jalr	2038(ra) # 800001d6 <memmove>
        return 0;
    800019e8:	8526                	mv	a0,s1
    800019ea:	bff9                	j	800019c8 <either_copyin+0x32>

00000000800019ec <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800019ec:	715d                	add	sp,sp,-80
    800019ee:	e486                	sd	ra,72(sp)
    800019f0:	e0a2                	sd	s0,64(sp)
    800019f2:	fc26                	sd	s1,56(sp)
    800019f4:	f84a                	sd	s2,48(sp)
    800019f6:	f44e                	sd	s3,40(sp)
    800019f8:	f052                	sd	s4,32(sp)
    800019fa:	ec56                	sd	s5,24(sp)
    800019fc:	e85a                	sd	s6,16(sp)
    800019fe:	e45e                	sd	s7,8(sp)
    80001a00:	0880                	add	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80001a02:	00006517          	auipc	a0,0x6
    80001a06:	61650513          	add	a0,a0,1558 # 80008018 <etext+0x18>
    80001a0a:	00004097          	auipc	ra,0x4
    80001a0e:	3bc080e7          	jalr	956(ra) # 80005dc6 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a12:	00008497          	auipc	s1,0x8
    80001a16:	bc648493          	add	s1,s1,-1082 # 800095d8 <proc+0x158>
    80001a1a:	0000e917          	auipc	s2,0xe
    80001a1e:	dbe90913          	add	s2,s2,-578 # 8000f7d8 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a22:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80001a24:	00006997          	auipc	s3,0x6
    80001a28:	7dc98993          	add	s3,s3,2012 # 80008200 <etext+0x200>
        printf("%d %s %s", p->pid, state, p->name);
    80001a2c:	00006a97          	auipc	s5,0x6
    80001a30:	7dca8a93          	add	s5,s5,2012 # 80008208 <etext+0x208>
        printf("\n");
    80001a34:	00006a17          	auipc	s4,0x6
    80001a38:	5e4a0a13          	add	s4,s4,1508 # 80008018 <etext+0x18>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3c:	00007b97          	auipc	s7,0x7
    80001a40:	cccb8b93          	add	s7,s7,-820 # 80008708 <states.0>
    80001a44:	a00d                	j	80001a66 <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001a46:	ed86a583          	lw	a1,-296(a3)
    80001a4a:	8556                	mv	a0,s5
    80001a4c:	00004097          	auipc	ra,0x4
    80001a50:	37a080e7          	jalr	890(ra) # 80005dc6 <printf>
        printf("\n");
    80001a54:	8552                	mv	a0,s4
    80001a56:	00004097          	auipc	ra,0x4
    80001a5a:	370080e7          	jalr	880(ra) # 80005dc6 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a5e:	18848493          	add	s1,s1,392
    80001a62:	03248263          	beq	s1,s2,80001a86 <procdump+0x9a>
        if (p->state == UNUSED)
    80001a66:	86a6                	mv	a3,s1
    80001a68:	ec04a783          	lw	a5,-320(s1)
    80001a6c:	dbed                	beqz	a5,80001a5e <procdump+0x72>
            state = "???";
    80001a6e:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a70:	fcfb6be3          	bltu	s6,a5,80001a46 <procdump+0x5a>
    80001a74:	02079713          	sll	a4,a5,0x20
    80001a78:	01d75793          	srl	a5,a4,0x1d
    80001a7c:	97de                	add	a5,a5,s7
    80001a7e:	6390                	ld	a2,0(a5)
    80001a80:	f279                	bnez	a2,80001a46 <procdump+0x5a>
            state = "???";
    80001a82:	864e                	mv	a2,s3
    80001a84:	b7c9                	j	80001a46 <procdump+0x5a>
    }
}
    80001a86:	60a6                	ld	ra,72(sp)
    80001a88:	6406                	ld	s0,64(sp)
    80001a8a:	74e2                	ld	s1,56(sp)
    80001a8c:	7942                	ld	s2,48(sp)
    80001a8e:	79a2                	ld	s3,40(sp)
    80001a90:	7a02                	ld	s4,32(sp)
    80001a92:	6ae2                	ld	s5,24(sp)
    80001a94:	6b42                	ld	s6,16(sp)
    80001a96:	6ba2                	ld	s7,8(sp)
    80001a98:	6161                	add	sp,sp,80
    80001a9a:	8082                	ret

0000000080001a9c <swtch>:
    80001a9c:	00153023          	sd	ra,0(a0)
    80001aa0:	00253423          	sd	sp,8(a0)
    80001aa4:	e900                	sd	s0,16(a0)
    80001aa6:	ed04                	sd	s1,24(a0)
    80001aa8:	03253023          	sd	s2,32(a0)
    80001aac:	03353423          	sd	s3,40(a0)
    80001ab0:	03453823          	sd	s4,48(a0)
    80001ab4:	03553c23          	sd	s5,56(a0)
    80001ab8:	05653023          	sd	s6,64(a0)
    80001abc:	05753423          	sd	s7,72(a0)
    80001ac0:	05853823          	sd	s8,80(a0)
    80001ac4:	05953c23          	sd	s9,88(a0)
    80001ac8:	07a53023          	sd	s10,96(a0)
    80001acc:	07b53423          	sd	s11,104(a0)
    80001ad0:	0005b083          	ld	ra,0(a1)
    80001ad4:	0085b103          	ld	sp,8(a1)
    80001ad8:	6980                	ld	s0,16(a1)
    80001ada:	6d84                	ld	s1,24(a1)
    80001adc:	0205b903          	ld	s2,32(a1)
    80001ae0:	0285b983          	ld	s3,40(a1)
    80001ae4:	0305ba03          	ld	s4,48(a1)
    80001ae8:	0385ba83          	ld	s5,56(a1)
    80001aec:	0405bb03          	ld	s6,64(a1)
    80001af0:	0485bb83          	ld	s7,72(a1)
    80001af4:	0505bc03          	ld	s8,80(a1)
    80001af8:	0585bc83          	ld	s9,88(a1)
    80001afc:	0605bd03          	ld	s10,96(a1)
    80001b00:	0685bd83          	ld	s11,104(a1)
    80001b04:	8082                	ret

0000000080001b06 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001b06:	1141                	add	sp,sp,-16
    80001b08:	e406                	sd	ra,8(sp)
    80001b0a:	e022                	sd	s0,0(sp)
    80001b0c:	0800                	add	s0,sp,16
    initlock(&tickslock, "time");
    80001b0e:	00006597          	auipc	a1,0x6
    80001b12:	73258593          	add	a1,a1,1842 # 80008240 <etext+0x240>
    80001b16:	0000e517          	auipc	a0,0xe
    80001b1a:	b6a50513          	add	a0,a0,-1174 # 8000f680 <tickslock>
    80001b1e:	00004097          	auipc	ra,0x4
    80001b22:	7a4080e7          	jalr	1956(ra) # 800062c2 <initlock>
}
    80001b26:	60a2                	ld	ra,8(sp)
    80001b28:	6402                	ld	s0,0(sp)
    80001b2a:	0141                	add	sp,sp,16
    80001b2c:	8082                	ret

0000000080001b2e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001b2e:	1141                	add	sp,sp,-16
    80001b30:	e422                	sd	s0,8(sp)
    80001b32:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b34:	00003797          	auipc	a5,0x3
    80001b38:	65c78793          	add	a5,a5,1628 # 80005190 <kernelvec>
    80001b3c:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80001b40:	6422                	ld	s0,8(sp)
    80001b42:	0141                	add	sp,sp,16
    80001b44:	8082                	ret

0000000080001b46 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001b46:	1141                	add	sp,sp,-16
    80001b48:	e406                	sd	ra,8(sp)
    80001b4a:	e022                	sd	s0,0(sp)
    80001b4c:	0800                	add	s0,sp,16
    struct proc *p = myproc();
    80001b4e:	fffff097          	auipc	ra,0xfffff
    80001b52:	32e080e7          	jalr	814(ra) # 80000e7c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b56:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b5a:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b5c:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to trampoline.S
    w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b60:	00005697          	auipc	a3,0x5
    80001b64:	4a068693          	add	a3,a3,1184 # 80007000 <_trampoline>
    80001b68:	00005717          	auipc	a4,0x5
    80001b6c:	49870713          	add	a4,a4,1176 # 80007000 <_trampoline>
    80001b70:	8f15                	sub	a4,a4,a3
    80001b72:	040007b7          	lui	a5,0x4000
    80001b76:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b78:	07b2                	sll	a5,a5,0xc
    80001b7a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b7c:	10571073          	csrw	stvec,a4

    // set up trapframe values that uservec will need when
    // the process next re-enters the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b80:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b82:	18002673          	csrr	a2,satp
    80001b86:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b88:	6d30                	ld	a2,88(a0)
    80001b8a:	6138                	ld	a4,64(a0)
    80001b8c:	6585                	lui	a1,0x1
    80001b8e:	972e                	add	a4,a4,a1
    80001b90:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80001b92:	6d38                	ld	a4,88(a0)
    80001b94:	00000617          	auipc	a2,0x0
    80001b98:	14060613          	add	a2,a2,320 # 80001cd4 <usertrap>
    80001b9c:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001b9e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ba0:	8612                	mv	a2,tp
    80001ba2:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ba4:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001ba8:	eff77713          	and	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bac:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bb0:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80001bb4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bb6:	6f18                	ld	a4,24(a4)
    80001bb8:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80001bbc:	692c                	ld	a1,80(a0)
    80001bbe:	81b1                	srl	a1,a1,0xc

    // jump to trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bc0:	00005717          	auipc	a4,0x5
    80001bc4:	4d070713          	add	a4,a4,1232 # 80007090 <userret>
    80001bc8:	8f15                	sub	a4,a4,a3
    80001bca:	97ba                	add	a5,a5,a4
    ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80001bcc:	577d                	li	a4,-1
    80001bce:	177e                	sll	a4,a4,0x3f
    80001bd0:	8dd9                	or	a1,a1,a4
    80001bd2:	02000537          	lui	a0,0x2000
    80001bd6:	157d                	add	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001bd8:	0536                	sll	a0,a0,0xd
    80001bda:	9782                	jalr	a5
}
    80001bdc:	60a2                	ld	ra,8(sp)
    80001bde:	6402                	ld	s0,0(sp)
    80001be0:	0141                	add	sp,sp,16
    80001be2:	8082                	ret

0000000080001be4 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80001be4:	1101                	add	sp,sp,-32
    80001be6:	ec06                	sd	ra,24(sp)
    80001be8:	e822                	sd	s0,16(sp)
    80001bea:	e426                	sd	s1,8(sp)
    80001bec:	1000                	add	s0,sp,32
    acquire(&tickslock);
    80001bee:	0000e497          	auipc	s1,0xe
    80001bf2:	a9248493          	add	s1,s1,-1390 # 8000f680 <tickslock>
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	00004097          	auipc	ra,0x4
    80001bfc:	75a080e7          	jalr	1882(ra) # 80006352 <acquire>
    ticks++;
    80001c00:	00007517          	auipc	a0,0x7
    80001c04:	41850513          	add	a0,a0,1048 # 80009018 <ticks>
    80001c08:	411c                	lw	a5,0(a0)
    80001c0a:	2785                	addw	a5,a5,1
    80001c0c:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001c0e:	00000097          	auipc	ra,0x0
    80001c12:	b1a080e7          	jalr	-1254(ra) # 80001728 <wakeup>
    release(&tickslock);
    80001c16:	8526                	mv	a0,s1
    80001c18:	00004097          	auipc	ra,0x4
    80001c1c:	7ee080e7          	jalr	2030(ra) # 80006406 <release>
}
    80001c20:	60e2                	ld	ra,24(sp)
    80001c22:	6442                	ld	s0,16(sp)
    80001c24:	64a2                	ld	s1,8(sp)
    80001c26:	6105                	add	sp,sp,32
    80001c28:	8082                	ret

0000000080001c2a <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c2a:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80001c2e:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80001c30:	0a07d163          	bgez	a5,80001cd2 <devintr+0xa8>
{
    80001c34:	1101                	add	sp,sp,-32
    80001c36:	ec06                	sd	ra,24(sp)
    80001c38:	e822                	sd	s0,16(sp)
    80001c3a:	1000                	add	s0,sp,32
        (scause & 0xff) == 9)
    80001c3c:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80001c40:	46a5                	li	a3,9
    80001c42:	00d70c63          	beq	a4,a3,80001c5a <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80001c46:	577d                	li	a4,-1
    80001c48:	177e                	sll	a4,a4,0x3f
    80001c4a:	0705                	add	a4,a4,1
        return 0;
    80001c4c:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80001c4e:	06e78163          	beq	a5,a4,80001cb0 <devintr+0x86>
    }
}
    80001c52:	60e2                	ld	ra,24(sp)
    80001c54:	6442                	ld	s0,16(sp)
    80001c56:	6105                	add	sp,sp,32
    80001c58:	8082                	ret
    80001c5a:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80001c5c:	00003097          	auipc	ra,0x3
    80001c60:	640080e7          	jalr	1600(ra) # 8000529c <plic_claim>
    80001c64:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80001c66:	47a9                	li	a5,10
    80001c68:	00f50963          	beq	a0,a5,80001c7a <devintr+0x50>
        else if (irq == VIRTIO0_IRQ)
    80001c6c:	4785                	li	a5,1
    80001c6e:	00f50b63          	beq	a0,a5,80001c84 <devintr+0x5a>
        return 1;
    80001c72:	4505                	li	a0,1
        else if (irq)
    80001c74:	ec89                	bnez	s1,80001c8e <devintr+0x64>
    80001c76:	64a2                	ld	s1,8(sp)
    80001c78:	bfe9                	j	80001c52 <devintr+0x28>
            uartintr();
    80001c7a:	00004097          	auipc	ra,0x4
    80001c7e:	5f8080e7          	jalr	1528(ra) # 80006272 <uartintr>
        if (irq)
    80001c82:	a839                	j	80001ca0 <devintr+0x76>
            virtio_disk_intr();
    80001c84:	00004097          	auipc	ra,0x4
    80001c88:	aec080e7          	jalr	-1300(ra) # 80005770 <virtio_disk_intr>
        if (irq)
    80001c8c:	a811                	j	80001ca0 <devintr+0x76>
            printf("unexpected interrupt irq=%d\n", irq);
    80001c8e:	85a6                	mv	a1,s1
    80001c90:	00006517          	auipc	a0,0x6
    80001c94:	5b850513          	add	a0,a0,1464 # 80008248 <etext+0x248>
    80001c98:	00004097          	auipc	ra,0x4
    80001c9c:	12e080e7          	jalr	302(ra) # 80005dc6 <printf>
            plic_complete(irq);
    80001ca0:	8526                	mv	a0,s1
    80001ca2:	00003097          	auipc	ra,0x3
    80001ca6:	61e080e7          	jalr	1566(ra) # 800052c0 <plic_complete>
        return 1;
    80001caa:	4505                	li	a0,1
    80001cac:	64a2                	ld	s1,8(sp)
    80001cae:	b755                	j	80001c52 <devintr+0x28>
        if (cpuid() == 0)
    80001cb0:	fffff097          	auipc	ra,0xfffff
    80001cb4:	1a0080e7          	jalr	416(ra) # 80000e50 <cpuid>
    80001cb8:	c901                	beqz	a0,80001cc8 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cba:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80001cbe:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cc0:	14479073          	csrw	sip,a5
        return 2;
    80001cc4:	4509                	li	a0,2
    80001cc6:	b771                	j	80001c52 <devintr+0x28>
            clockintr();
    80001cc8:	00000097          	auipc	ra,0x0
    80001ccc:	f1c080e7          	jalr	-228(ra) # 80001be4 <clockintr>
    80001cd0:	b7ed                	j	80001cba <devintr+0x90>
}
    80001cd2:	8082                	ret

0000000080001cd4 <usertrap>:
{
    80001cd4:	1101                	add	sp,sp,-32
    80001cd6:	ec06                	sd	ra,24(sp)
    80001cd8:	e822                	sd	s0,16(sp)
    80001cda:	e426                	sd	s1,8(sp)
    80001cdc:	e04a                	sd	s2,0(sp)
    80001cde:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce0:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001ce4:	1007f793          	and	a5,a5,256
    80001ce8:	e3ad                	bnez	a5,80001d4a <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cea:	00003797          	auipc	a5,0x3
    80001cee:	4a678793          	add	a5,a5,1190 # 80005190 <kernelvec>
    80001cf2:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80001cf6:	fffff097          	auipc	ra,0xfffff
    80001cfa:	186080e7          	jalr	390(ra) # 80000e7c <myproc>
    80001cfe:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80001d00:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d02:	14102773          	csrr	a4,sepc
    80001d06:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d08:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80001d0c:	47a1                	li	a5,8
    80001d0e:	04f71c63          	bne	a4,a5,80001d66 <usertrap+0x92>
        if (p->killed)
    80001d12:	551c                	lw	a5,40(a0)
    80001d14:	e3b9                	bnez	a5,80001d5a <usertrap+0x86>
        p->trapframe->epc += 4;
    80001d16:	6cb8                	ld	a4,88(s1)
    80001d18:	6f1c                	ld	a5,24(a4)
    80001d1a:	0791                	add	a5,a5,4
    80001d1c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d22:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d26:	10079073          	csrw	sstatus,a5
        syscall();
    80001d2a:	00000097          	auipc	ra,0x0
    80001d2e:	340080e7          	jalr	832(ra) # 8000206a <syscall>
    if (p->killed)
    80001d32:	549c                	lw	a5,40(s1)
    80001d34:	e7cd                	bnez	a5,80001dde <usertrap+0x10a>
    usertrapret();
    80001d36:	00000097          	auipc	ra,0x0
    80001d3a:	e10080e7          	jalr	-496(ra) # 80001b46 <usertrapret>
}
    80001d3e:	60e2                	ld	ra,24(sp)
    80001d40:	6442                	ld	s0,16(sp)
    80001d42:	64a2                	ld	s1,8(sp)
    80001d44:	6902                	ld	s2,0(sp)
    80001d46:	6105                	add	sp,sp,32
    80001d48:	8082                	ret
        panic("usertrap: not from user mode");
    80001d4a:	00006517          	auipc	a0,0x6
    80001d4e:	51e50513          	add	a0,a0,1310 # 80008268 <etext+0x268>
    80001d52:	00004097          	auipc	ra,0x4
    80001d56:	02a080e7          	jalr	42(ra) # 80005d7c <panic>
            exit(-1);
    80001d5a:	557d                	li	a0,-1
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	a9c080e7          	jalr	-1380(ra) # 800017f8 <exit>
    80001d64:	bf4d                	j	80001d16 <usertrap+0x42>
    else if ((which_dev = devintr()) != 0)
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	ec4080e7          	jalr	-316(ra) # 80001c2a <devintr>
    80001d6e:	892a                	mv	s2,a0
    80001d70:	c501                	beqz	a0,80001d78 <usertrap+0xa4>
    if (p->killed)
    80001d72:	549c                	lw	a5,40(s1)
    80001d74:	c3a1                	beqz	a5,80001db4 <usertrap+0xe0>
    80001d76:	a815                	j	80001daa <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d78:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d7c:	5890                	lw	a2,48(s1)
    80001d7e:	00006517          	auipc	a0,0x6
    80001d82:	50a50513          	add	a0,a0,1290 # 80008288 <etext+0x288>
    80001d86:	00004097          	auipc	ra,0x4
    80001d8a:	040080e7          	jalr	64(ra) # 80005dc6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d8e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d92:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d96:	00006517          	auipc	a0,0x6
    80001d9a:	52250513          	add	a0,a0,1314 # 800082b8 <etext+0x2b8>
    80001d9e:	00004097          	auipc	ra,0x4
    80001da2:	028080e7          	jalr	40(ra) # 80005dc6 <printf>
        p->killed = 1;
    80001da6:	4785                	li	a5,1
    80001da8:	d49c                	sw	a5,40(s1)
        exit(-1);
    80001daa:	557d                	li	a0,-1
    80001dac:	00000097          	auipc	ra,0x0
    80001db0:	a4c080e7          	jalr	-1460(ra) # 800017f8 <exit>
    if (which_dev == 2)
    80001db4:	4789                	li	a5,2
    80001db6:	f8f910e3          	bne	s2,a5,80001d36 <usertrap+0x62>
        if (p->alarm_info.alarm_interval > 0)
    80001dba:	1684a703          	lw	a4,360(s1)
    80001dbe:	00e05b63          	blez	a4,80001dd4 <usertrap+0x100>
            --p->alarm_info.alarm_ticks;
    80001dc2:	1784a783          	lw	a5,376(s1)
    80001dc6:	37fd                	addw	a5,a5,-1
    80001dc8:	0007869b          	sext.w	a3,a5
    80001dcc:	16f4ac23          	sw	a5,376(s1)
            if (p->alarm_info.alarm_ticks <= 0 && !p->alarm_info.alarm_running)
    80001dd0:	00d05963          	blez	a3,80001de2 <usertrap+0x10e>
        yield();
    80001dd4:	fffff097          	auipc	ra,0xfffff
    80001dd8:	78c080e7          	jalr	1932(ra) # 80001560 <yield>
    80001ddc:	bfa9                	j	80001d36 <usertrap+0x62>
    int which_dev = 0;
    80001dde:	4901                	li	s2,0
    80001de0:	b7e9                	j	80001daa <usertrap+0xd6>
            if (p->alarm_info.alarm_ticks <= 0 && !p->alarm_info.alarm_running)
    80001de2:	17c4a783          	lw	a5,380(s1)
    80001de6:	f7fd                	bnez	a5,80001dd4 <usertrap+0x100>
                p->alarm_info.alarm_ticks = p->alarm_info.alarm_interval;
    80001de8:	16e4ac23          	sw	a4,376(s1)
                *p->alarm_trapframe = *p->trapframe;
    80001dec:	6cb4                	ld	a3,88(s1)
    80001dee:	87b6                	mv	a5,a3
    80001df0:	1804b703          	ld	a4,384(s1)
    80001df4:	12068693          	add	a3,a3,288
    80001df8:	0007b803          	ld	a6,0(a5)
    80001dfc:	6788                	ld	a0,8(a5)
    80001dfe:	6b8c                	ld	a1,16(a5)
    80001e00:	6f90                	ld	a2,24(a5)
    80001e02:	01073023          	sd	a6,0(a4)
    80001e06:	e708                	sd	a0,8(a4)
    80001e08:	eb0c                	sd	a1,16(a4)
    80001e0a:	ef10                	sd	a2,24(a4)
    80001e0c:	02078793          	add	a5,a5,32
    80001e10:	02070713          	add	a4,a4,32
    80001e14:	fed792e3          	bne	a5,a3,80001df8 <usertrap+0x124>
                p->trapframe->epc = p->alarm_info.alarm_handler;
    80001e18:	6cbc                	ld	a5,88(s1)
    80001e1a:	1704b703          	ld	a4,368(s1)
    80001e1e:	ef98                	sd	a4,24(a5)
                p->alarm_info.alarm_running = 1;
    80001e20:	4785                	li	a5,1
    80001e22:	16f4ae23          	sw	a5,380(s1)
    80001e26:	b77d                	j	80001dd4 <usertrap+0x100>

0000000080001e28 <kerneltrap>:
{
    80001e28:	7179                	add	sp,sp,-48
    80001e2a:	f406                	sd	ra,40(sp)
    80001e2c:	f022                	sd	s0,32(sp)
    80001e2e:	ec26                	sd	s1,24(sp)
    80001e30:	e84a                	sd	s2,16(sp)
    80001e32:	e44e                	sd	s3,8(sp)
    80001e34:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e36:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e3a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e3e:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80001e42:	1004f793          	and	a5,s1,256
    80001e46:	cb85                	beqz	a5,80001e76 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e48:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e4c:	8b89                	and	a5,a5,2
    if (intr_get() != 0)
    80001e4e:	ef85                	bnez	a5,80001e86 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80001e50:	00000097          	auipc	ra,0x0
    80001e54:	dda080e7          	jalr	-550(ra) # 80001c2a <devintr>
    80001e58:	cd1d                	beqz	a0,80001e96 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e5a:	4789                	li	a5,2
    80001e5c:	06f50a63          	beq	a0,a5,80001ed0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e60:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e64:	10049073          	csrw	sstatus,s1
}
    80001e68:	70a2                	ld	ra,40(sp)
    80001e6a:	7402                	ld	s0,32(sp)
    80001e6c:	64e2                	ld	s1,24(sp)
    80001e6e:	6942                	ld	s2,16(sp)
    80001e70:	69a2                	ld	s3,8(sp)
    80001e72:	6145                	add	sp,sp,48
    80001e74:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80001e76:	00006517          	auipc	a0,0x6
    80001e7a:	46250513          	add	a0,a0,1122 # 800082d8 <etext+0x2d8>
    80001e7e:	00004097          	auipc	ra,0x4
    80001e82:	efe080e7          	jalr	-258(ra) # 80005d7c <panic>
        panic("kerneltrap: interrupts enabled");
    80001e86:	00006517          	auipc	a0,0x6
    80001e8a:	47a50513          	add	a0,a0,1146 # 80008300 <etext+0x300>
    80001e8e:	00004097          	auipc	ra,0x4
    80001e92:	eee080e7          	jalr	-274(ra) # 80005d7c <panic>
        printf("scause %p\n", scause);
    80001e96:	85ce                	mv	a1,s3
    80001e98:	00006517          	auipc	a0,0x6
    80001e9c:	48850513          	add	a0,a0,1160 # 80008320 <etext+0x320>
    80001ea0:	00004097          	auipc	ra,0x4
    80001ea4:	f26080e7          	jalr	-218(ra) # 80005dc6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ea8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eac:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eb0:	00006517          	auipc	a0,0x6
    80001eb4:	48050513          	add	a0,a0,1152 # 80008330 <etext+0x330>
    80001eb8:	00004097          	auipc	ra,0x4
    80001ebc:	f0e080e7          	jalr	-242(ra) # 80005dc6 <printf>
        panic("kerneltrap");
    80001ec0:	00006517          	auipc	a0,0x6
    80001ec4:	48850513          	add	a0,a0,1160 # 80008348 <etext+0x348>
    80001ec8:	00004097          	auipc	ra,0x4
    80001ecc:	eb4080e7          	jalr	-332(ra) # 80005d7c <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	fac080e7          	jalr	-84(ra) # 80000e7c <myproc>
    80001ed8:	d541                	beqz	a0,80001e60 <kerneltrap+0x38>
    80001eda:	fffff097          	auipc	ra,0xfffff
    80001ede:	fa2080e7          	jalr	-94(ra) # 80000e7c <myproc>
    80001ee2:	4d18                	lw	a4,24(a0)
    80001ee4:	4791                	li	a5,4
    80001ee6:	f6f71de3          	bne	a4,a5,80001e60 <kerneltrap+0x38>
        yield();
    80001eea:	fffff097          	auipc	ra,0xfffff
    80001eee:	676080e7          	jalr	1654(ra) # 80001560 <yield>
    80001ef2:	b7bd                	j	80001e60 <kerneltrap+0x38>

0000000080001ef4 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ef4:	1101                	add	sp,sp,-32
    80001ef6:	ec06                	sd	ra,24(sp)
    80001ef8:	e822                	sd	s0,16(sp)
    80001efa:	e426                	sd	s1,8(sp)
    80001efc:	1000                	add	s0,sp,32
    80001efe:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	f7c080e7          	jalr	-132(ra) # 80000e7c <myproc>
    switch (n)
    80001f08:	4795                	li	a5,5
    80001f0a:	0497e163          	bltu	a5,s1,80001f4c <argraw+0x58>
    80001f0e:	048a                	sll	s1,s1,0x2
    80001f10:	00007717          	auipc	a4,0x7
    80001f14:	82870713          	add	a4,a4,-2008 # 80008738 <states.0+0x30>
    80001f18:	94ba                	add	s1,s1,a4
    80001f1a:	409c                	lw	a5,0(s1)
    80001f1c:	97ba                	add	a5,a5,a4
    80001f1e:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80001f20:	6d3c                	ld	a5,88(a0)
    80001f22:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80001f24:	60e2                	ld	ra,24(sp)
    80001f26:	6442                	ld	s0,16(sp)
    80001f28:	64a2                	ld	s1,8(sp)
    80001f2a:	6105                	add	sp,sp,32
    80001f2c:	8082                	ret
        return p->trapframe->a1;
    80001f2e:	6d3c                	ld	a5,88(a0)
    80001f30:	7fa8                	ld	a0,120(a5)
    80001f32:	bfcd                	j	80001f24 <argraw+0x30>
        return p->trapframe->a2;
    80001f34:	6d3c                	ld	a5,88(a0)
    80001f36:	63c8                	ld	a0,128(a5)
    80001f38:	b7f5                	j	80001f24 <argraw+0x30>
        return p->trapframe->a3;
    80001f3a:	6d3c                	ld	a5,88(a0)
    80001f3c:	67c8                	ld	a0,136(a5)
    80001f3e:	b7dd                	j	80001f24 <argraw+0x30>
        return p->trapframe->a4;
    80001f40:	6d3c                	ld	a5,88(a0)
    80001f42:	6bc8                	ld	a0,144(a5)
    80001f44:	b7c5                	j	80001f24 <argraw+0x30>
        return p->trapframe->a5;
    80001f46:	6d3c                	ld	a5,88(a0)
    80001f48:	6fc8                	ld	a0,152(a5)
    80001f4a:	bfe9                	j	80001f24 <argraw+0x30>
    panic("argraw");
    80001f4c:	00006517          	auipc	a0,0x6
    80001f50:	40c50513          	add	a0,a0,1036 # 80008358 <etext+0x358>
    80001f54:	00004097          	auipc	ra,0x4
    80001f58:	e28080e7          	jalr	-472(ra) # 80005d7c <panic>

0000000080001f5c <fetchaddr>:
{
    80001f5c:	1101                	add	sp,sp,-32
    80001f5e:	ec06                	sd	ra,24(sp)
    80001f60:	e822                	sd	s0,16(sp)
    80001f62:	e426                	sd	s1,8(sp)
    80001f64:	e04a                	sd	s2,0(sp)
    80001f66:	1000                	add	s0,sp,32
    80001f68:	84aa                	mv	s1,a0
    80001f6a:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	f10080e7          	jalr	-240(ra) # 80000e7c <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz)
    80001f74:	653c                	ld	a5,72(a0)
    80001f76:	02f4f863          	bgeu	s1,a5,80001fa6 <fetchaddr+0x4a>
    80001f7a:	00848713          	add	a4,s1,8
    80001f7e:	02e7e663          	bltu	a5,a4,80001faa <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f82:	46a1                	li	a3,8
    80001f84:	8626                	mv	a2,s1
    80001f86:	85ca                	mv	a1,s2
    80001f88:	6928                	ld	a0,80(a0)
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	c1a080e7          	jalr	-998(ra) # 80000ba4 <copyin>
    80001f92:	00a03533          	snez	a0,a0
    80001f96:	40a00533          	neg	a0,a0
}
    80001f9a:	60e2                	ld	ra,24(sp)
    80001f9c:	6442                	ld	s0,16(sp)
    80001f9e:	64a2                	ld	s1,8(sp)
    80001fa0:	6902                	ld	s2,0(sp)
    80001fa2:	6105                	add	sp,sp,32
    80001fa4:	8082                	ret
        return -1;
    80001fa6:	557d                	li	a0,-1
    80001fa8:	bfcd                	j	80001f9a <fetchaddr+0x3e>
    80001faa:	557d                	li	a0,-1
    80001fac:	b7fd                	j	80001f9a <fetchaddr+0x3e>

0000000080001fae <fetchstr>:
{
    80001fae:	7179                	add	sp,sp,-48
    80001fb0:	f406                	sd	ra,40(sp)
    80001fb2:	f022                	sd	s0,32(sp)
    80001fb4:	ec26                	sd	s1,24(sp)
    80001fb6:	e84a                	sd	s2,16(sp)
    80001fb8:	e44e                	sd	s3,8(sp)
    80001fba:	1800                	add	s0,sp,48
    80001fbc:	892a                	mv	s2,a0
    80001fbe:	84ae                	mv	s1,a1
    80001fc0:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80001fc2:	fffff097          	auipc	ra,0xfffff
    80001fc6:	eba080e7          	jalr	-326(ra) # 80000e7c <myproc>
    int err = copyinstr(p->pagetable, buf, addr, max);
    80001fca:	86ce                	mv	a3,s3
    80001fcc:	864a                	mv	a2,s2
    80001fce:	85a6                	mv	a1,s1
    80001fd0:	6928                	ld	a0,80(a0)
    80001fd2:	fffff097          	auipc	ra,0xfffff
    80001fd6:	c60080e7          	jalr	-928(ra) # 80000c32 <copyinstr>
    if (err < 0)
    80001fda:	00054763          	bltz	a0,80001fe8 <fetchstr+0x3a>
    return strlen(buf);
    80001fde:	8526                	mv	a0,s1
    80001fe0:	ffffe097          	auipc	ra,0xffffe
    80001fe4:	30e080e7          	jalr	782(ra) # 800002ee <strlen>
}
    80001fe8:	70a2                	ld	ra,40(sp)
    80001fea:	7402                	ld	s0,32(sp)
    80001fec:	64e2                	ld	s1,24(sp)
    80001fee:	6942                	ld	s2,16(sp)
    80001ff0:	69a2                	ld	s3,8(sp)
    80001ff2:	6145                	add	sp,sp,48
    80001ff4:	8082                	ret

0000000080001ff6 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
    80001ff6:	1101                	add	sp,sp,-32
    80001ff8:	ec06                	sd	ra,24(sp)
    80001ffa:	e822                	sd	s0,16(sp)
    80001ffc:	e426                	sd	s1,8(sp)
    80001ffe:	1000                	add	s0,sp,32
    80002000:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002002:	00000097          	auipc	ra,0x0
    80002006:	ef2080e7          	jalr	-270(ra) # 80001ef4 <argraw>
    8000200a:	c088                	sw	a0,0(s1)
    return 0;
}
    8000200c:	4501                	li	a0,0
    8000200e:	60e2                	ld	ra,24(sp)
    80002010:	6442                	ld	s0,16(sp)
    80002012:	64a2                	ld	s1,8(sp)
    80002014:	6105                	add	sp,sp,32
    80002016:	8082                	ret

0000000080002018 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int argaddr(int n, uint64 *ip)
{
    80002018:	1101                	add	sp,sp,-32
    8000201a:	ec06                	sd	ra,24(sp)
    8000201c:	e822                	sd	s0,16(sp)
    8000201e:	e426                	sd	s1,8(sp)
    80002020:	1000                	add	s0,sp,32
    80002022:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002024:	00000097          	auipc	ra,0x0
    80002028:	ed0080e7          	jalr	-304(ra) # 80001ef4 <argraw>
    8000202c:	e088                	sd	a0,0(s1)
    return 0;
}
    8000202e:	4501                	li	a0,0
    80002030:	60e2                	ld	ra,24(sp)
    80002032:	6442                	ld	s0,16(sp)
    80002034:	64a2                	ld	s1,8(sp)
    80002036:	6105                	add	sp,sp,32
    80002038:	8082                	ret

000000008000203a <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    8000203a:	1101                	add	sp,sp,-32
    8000203c:	ec06                	sd	ra,24(sp)
    8000203e:	e822                	sd	s0,16(sp)
    80002040:	e426                	sd	s1,8(sp)
    80002042:	e04a                	sd	s2,0(sp)
    80002044:	1000                	add	s0,sp,32
    80002046:	84ae                	mv	s1,a1
    80002048:	8932                	mv	s2,a2
    *ip = argraw(n);
    8000204a:	00000097          	auipc	ra,0x0
    8000204e:	eaa080e7          	jalr	-342(ra) # 80001ef4 <argraw>
    uint64 addr;
    if (argaddr(n, &addr) < 0)
        return -1;
    return fetchstr(addr, buf, max);
    80002052:	864a                	mv	a2,s2
    80002054:	85a6                	mv	a1,s1
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	f58080e7          	jalr	-168(ra) # 80001fae <fetchstr>
}
    8000205e:	60e2                	ld	ra,24(sp)
    80002060:	6442                	ld	s0,16(sp)
    80002062:	64a2                	ld	s1,8(sp)
    80002064:	6902                	ld	s2,0(sp)
    80002066:	6105                	add	sp,sp,32
    80002068:	8082                	ret

000000008000206a <syscall>:
    [SYS_sigalarm] sys_sigalarm,
    [SYS_sigreturn] sys_sigreturn,
};

void syscall(void)
{
    8000206a:	1101                	add	sp,sp,-32
    8000206c:	ec06                	sd	ra,24(sp)
    8000206e:	e822                	sd	s0,16(sp)
    80002070:	e426                	sd	s1,8(sp)
    80002072:	e04a                	sd	s2,0(sp)
    80002074:	1000                	add	s0,sp,32
    int num;
    struct proc *p = myproc();
    80002076:	fffff097          	auipc	ra,0xfffff
    8000207a:	e06080e7          	jalr	-506(ra) # 80000e7c <myproc>
    8000207e:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002080:	05853903          	ld	s2,88(a0)
    80002084:	0a893783          	ld	a5,168(s2)
    80002088:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000208c:	37fd                	addw	a5,a5,-1
    8000208e:	4759                	li	a4,22
    80002090:	00f76f63          	bltu	a4,a5,800020ae <syscall+0x44>
    80002094:	00369713          	sll	a4,a3,0x3
    80002098:	00006797          	auipc	a5,0x6
    8000209c:	6b878793          	add	a5,a5,1720 # 80008750 <syscalls>
    800020a0:	97ba                	add	a5,a5,a4
    800020a2:	639c                	ld	a5,0(a5)
    800020a4:	c789                	beqz	a5,800020ae <syscall+0x44>
    {
        p->trapframe->a0 = syscalls[num]();
    800020a6:	9782                	jalr	a5
    800020a8:	06a93823          	sd	a0,112(s2)
    800020ac:	a839                	j	800020ca <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    800020ae:	15848613          	add	a2,s1,344
    800020b2:	588c                	lw	a1,48(s1)
    800020b4:	00006517          	auipc	a0,0x6
    800020b8:	2ac50513          	add	a0,a0,684 # 80008360 <etext+0x360>
    800020bc:	00004097          	auipc	ra,0x4
    800020c0:	d0a080e7          	jalr	-758(ra) # 80005dc6 <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    800020c4:	6cbc                	ld	a5,88(s1)
    800020c6:	577d                	li	a4,-1
    800020c8:	fbb8                	sd	a4,112(a5)
    }
}
    800020ca:	60e2                	ld	ra,24(sp)
    800020cc:	6442                	ld	s0,16(sp)
    800020ce:	64a2                	ld	s1,8(sp)
    800020d0:	6902                	ld	s2,0(sp)
    800020d2:	6105                	add	sp,sp,32
    800020d4:	8082                	ret

00000000800020d6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020d6:	1101                	add	sp,sp,-32
    800020d8:	ec06                	sd	ra,24(sp)
    800020da:	e822                	sd	s0,16(sp)
    800020dc:	1000                	add	s0,sp,32
    int n;
    if (argint(0, &n) < 0)
    800020de:	fec40593          	add	a1,s0,-20
    800020e2:	4501                	li	a0,0
    800020e4:	00000097          	auipc	ra,0x0
    800020e8:	f12080e7          	jalr	-238(ra) # 80001ff6 <argint>
        return -1;
    800020ec:	57fd                	li	a5,-1
    if (argint(0, &n) < 0)
    800020ee:	00054963          	bltz	a0,80002100 <sys_exit+0x2a>
    exit(n);
    800020f2:	fec42503          	lw	a0,-20(s0)
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	702080e7          	jalr	1794(ra) # 800017f8 <exit>
    return 0; // not reached
    800020fe:	4781                	li	a5,0
}
    80002100:	853e                	mv	a0,a5
    80002102:	60e2                	ld	ra,24(sp)
    80002104:	6442                	ld	s0,16(sp)
    80002106:	6105                	add	sp,sp,32
    80002108:	8082                	ret

000000008000210a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000210a:	1141                	add	sp,sp,-16
    8000210c:	e406                	sd	ra,8(sp)
    8000210e:	e022                	sd	s0,0(sp)
    80002110:	0800                	add	s0,sp,16
    return myproc()->pid;
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	d6a080e7          	jalr	-662(ra) # 80000e7c <myproc>
}
    8000211a:	5908                	lw	a0,48(a0)
    8000211c:	60a2                	ld	ra,8(sp)
    8000211e:	6402                	ld	s0,0(sp)
    80002120:	0141                	add	sp,sp,16
    80002122:	8082                	ret

0000000080002124 <sys_fork>:

uint64
sys_fork(void)
{
    80002124:	1141                	add	sp,sp,-16
    80002126:	e406                	sd	ra,8(sp)
    80002128:	e022                	sd	s0,0(sp)
    8000212a:	0800                	add	s0,sp,16
    return fork();
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	17c080e7          	jalr	380(ra) # 800012a8 <fork>
}
    80002134:	60a2                	ld	ra,8(sp)
    80002136:	6402                	ld	s0,0(sp)
    80002138:	0141                	add	sp,sp,16
    8000213a:	8082                	ret

000000008000213c <sys_wait>:

uint64
sys_wait(void)
{
    8000213c:	1101                	add	sp,sp,-32
    8000213e:	ec06                	sd	ra,24(sp)
    80002140:	e822                	sd	s0,16(sp)
    80002142:	1000                	add	s0,sp,32
    uint64 p;
    if (argaddr(0, &p) < 0)
    80002144:	fe840593          	add	a1,s0,-24
    80002148:	4501                	li	a0,0
    8000214a:	00000097          	auipc	ra,0x0
    8000214e:	ece080e7          	jalr	-306(ra) # 80002018 <argaddr>
    80002152:	87aa                	mv	a5,a0
        return -1;
    80002154:	557d                	li	a0,-1
    if (argaddr(0, &p) < 0)
    80002156:	0007c863          	bltz	a5,80002166 <sys_wait+0x2a>
    return wait(p);
    8000215a:	fe843503          	ld	a0,-24(s0)
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	4a2080e7          	jalr	1186(ra) # 80001600 <wait>
}
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	6105                	add	sp,sp,32
    8000216c:	8082                	ret

000000008000216e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000216e:	7179                	add	sp,sp,-48
    80002170:	f406                	sd	ra,40(sp)
    80002172:	f022                	sd	s0,32(sp)
    80002174:	1800                	add	s0,sp,48
    int addr;
    int n;

    if (argint(0, &n) < 0)
    80002176:	fdc40593          	add	a1,s0,-36
    8000217a:	4501                	li	a0,0
    8000217c:	00000097          	auipc	ra,0x0
    80002180:	e7a080e7          	jalr	-390(ra) # 80001ff6 <argint>
    80002184:	87aa                	mv	a5,a0
        return -1;
    80002186:	557d                	li	a0,-1
    if (argint(0, &n) < 0)
    80002188:	0207c263          	bltz	a5,800021ac <sys_sbrk+0x3e>
    8000218c:	ec26                	sd	s1,24(sp)
    addr = myproc()->sz;
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	cee080e7          	jalr	-786(ra) # 80000e7c <myproc>
    80002196:	4524                	lw	s1,72(a0)
    if (growproc(n) < 0)
    80002198:	fdc42503          	lw	a0,-36(s0)
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	094080e7          	jalr	148(ra) # 80001230 <growproc>
    800021a4:	00054863          	bltz	a0,800021b4 <sys_sbrk+0x46>
        return -1;
    return addr;
    800021a8:	8526                	mv	a0,s1
    800021aa:	64e2                	ld	s1,24(sp)
}
    800021ac:	70a2                	ld	ra,40(sp)
    800021ae:	7402                	ld	s0,32(sp)
    800021b0:	6145                	add	sp,sp,48
    800021b2:	8082                	ret
        return -1;
    800021b4:	557d                	li	a0,-1
    800021b6:	64e2                	ld	s1,24(sp)
    800021b8:	bfd5                	j	800021ac <sys_sbrk+0x3e>

00000000800021ba <sys_sleep>:

uint64
sys_sleep(void)
{
    800021ba:	7139                	add	sp,sp,-64
    800021bc:	fc06                	sd	ra,56(sp)
    800021be:	f822                	sd	s0,48(sp)
    800021c0:	0080                	add	s0,sp,64
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
    800021c2:	fcc40593          	add	a1,s0,-52
    800021c6:	4501                	li	a0,0
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	e2e080e7          	jalr	-466(ra) # 80001ff6 <argint>
        return -1;
    800021d0:	57fd                	li	a5,-1
    if (argint(0, &n) < 0)
    800021d2:	06054f63          	bltz	a0,80002250 <sys_sleep+0x96>
    800021d6:	f04a                	sd	s2,32(sp)
    acquire(&tickslock);
    800021d8:	0000d517          	auipc	a0,0xd
    800021dc:	4a850513          	add	a0,a0,1192 # 8000f680 <tickslock>
    800021e0:	00004097          	auipc	ra,0x4
    800021e4:	172080e7          	jalr	370(ra) # 80006352 <acquire>
    backtrace();
    800021e8:	00004097          	auipc	ra,0x4
    800021ec:	e18080e7          	jalr	-488(ra) # 80006000 <backtrace>
    ticks0 = ticks;
    800021f0:	00007917          	auipc	s2,0x7
    800021f4:	e2892903          	lw	s2,-472(s2) # 80009018 <ticks>
    while (ticks - ticks0 < n)
    800021f8:	fcc42783          	lw	a5,-52(s0)
    800021fc:	c3a1                	beqz	a5,8000223c <sys_sleep+0x82>
    800021fe:	f426                	sd	s1,40(sp)
    80002200:	ec4e                	sd	s3,24(sp)
        if (myproc()->killed)
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    80002202:	0000d997          	auipc	s3,0xd
    80002206:	47e98993          	add	s3,s3,1150 # 8000f680 <tickslock>
    8000220a:	00007497          	auipc	s1,0x7
    8000220e:	e0e48493          	add	s1,s1,-498 # 80009018 <ticks>
        if (myproc()->killed)
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	c6a080e7          	jalr	-918(ra) # 80000e7c <myproc>
    8000221a:	551c                	lw	a5,40(a0)
    8000221c:	ef9d                	bnez	a5,8000225a <sys_sleep+0xa0>
        sleep(&ticks, &tickslock);
    8000221e:	85ce                	mv	a1,s3
    80002220:	8526                	mv	a0,s1
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	37a080e7          	jalr	890(ra) # 8000159c <sleep>
    while (ticks - ticks0 < n)
    8000222a:	409c                	lw	a5,0(s1)
    8000222c:	412787bb          	subw	a5,a5,s2
    80002230:	fcc42703          	lw	a4,-52(s0)
    80002234:	fce7efe3          	bltu	a5,a4,80002212 <sys_sleep+0x58>
    80002238:	74a2                	ld	s1,40(sp)
    8000223a:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    8000223c:	0000d517          	auipc	a0,0xd
    80002240:	44450513          	add	a0,a0,1092 # 8000f680 <tickslock>
    80002244:	00004097          	auipc	ra,0x4
    80002248:	1c2080e7          	jalr	450(ra) # 80006406 <release>
    return 0;
    8000224c:	4781                	li	a5,0
    8000224e:	7902                	ld	s2,32(sp)
}
    80002250:	853e                	mv	a0,a5
    80002252:	70e2                	ld	ra,56(sp)
    80002254:	7442                	ld	s0,48(sp)
    80002256:	6121                	add	sp,sp,64
    80002258:	8082                	ret
            release(&tickslock);
    8000225a:	0000d517          	auipc	a0,0xd
    8000225e:	42650513          	add	a0,a0,1062 # 8000f680 <tickslock>
    80002262:	00004097          	auipc	ra,0x4
    80002266:	1a4080e7          	jalr	420(ra) # 80006406 <release>
            return -1;
    8000226a:	57fd                	li	a5,-1
    8000226c:	74a2                	ld	s1,40(sp)
    8000226e:	7902                	ld	s2,32(sp)
    80002270:	69e2                	ld	s3,24(sp)
    80002272:	bff9                	j	80002250 <sys_sleep+0x96>

0000000080002274 <sys_kill>:

uint64
sys_kill(void)
{
    80002274:	1101                	add	sp,sp,-32
    80002276:	ec06                	sd	ra,24(sp)
    80002278:	e822                	sd	s0,16(sp)
    8000227a:	1000                	add	s0,sp,32
    int pid;

    if (argint(0, &pid) < 0)
    8000227c:	fec40593          	add	a1,s0,-20
    80002280:	4501                	li	a0,0
    80002282:	00000097          	auipc	ra,0x0
    80002286:	d74080e7          	jalr	-652(ra) # 80001ff6 <argint>
    8000228a:	87aa                	mv	a5,a0
        return -1;
    8000228c:	557d                	li	a0,-1
    if (argint(0, &pid) < 0)
    8000228e:	0007c863          	bltz	a5,8000229e <sys_kill+0x2a>
    return kill(pid);
    80002292:	fec42503          	lw	a0,-20(s0)
    80002296:	fffff097          	auipc	ra,0xfffff
    8000229a:	638080e7          	jalr	1592(ra) # 800018ce <kill>
}
    8000229e:	60e2                	ld	ra,24(sp)
    800022a0:	6442                	ld	s0,16(sp)
    800022a2:	6105                	add	sp,sp,32
    800022a4:	8082                	ret

00000000800022a6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022a6:	1101                	add	sp,sp,-32
    800022a8:	ec06                	sd	ra,24(sp)
    800022aa:	e822                	sd	s0,16(sp)
    800022ac:	e426                	sd	s1,8(sp)
    800022ae:	1000                	add	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    800022b0:	0000d517          	auipc	a0,0xd
    800022b4:	3d050513          	add	a0,a0,976 # 8000f680 <tickslock>
    800022b8:	00004097          	auipc	ra,0x4
    800022bc:	09a080e7          	jalr	154(ra) # 80006352 <acquire>
    xticks = ticks;
    800022c0:	00007497          	auipc	s1,0x7
    800022c4:	d584a483          	lw	s1,-680(s1) # 80009018 <ticks>
    release(&tickslock);
    800022c8:	0000d517          	auipc	a0,0xd
    800022cc:	3b850513          	add	a0,a0,952 # 8000f680 <tickslock>
    800022d0:	00004097          	auipc	ra,0x4
    800022d4:	136080e7          	jalr	310(ra) # 80006406 <release>
    return xticks;
}
    800022d8:	02049513          	sll	a0,s1,0x20
    800022dc:	9101                	srl	a0,a0,0x20
    800022de:	60e2                	ld	ra,24(sp)
    800022e0:	6442                	ld	s0,16(sp)
    800022e2:	64a2                	ld	s1,8(sp)
    800022e4:	6105                	add	sp,sp,32
    800022e6:	8082                	ret

00000000800022e8 <sys_sigalarm>:

uint64 sys_sigalarm(void)
{
    800022e8:	1101                	add	sp,sp,-32
    800022ea:	ec06                	sd	ra,24(sp)
    800022ec:	e822                	sd	s0,16(sp)
    800022ee:	1000                	add	s0,sp,32
    int ticks;
    uint64 fn;
    if (argint(0, &ticks) < 0 || argaddr(1, &fn) < 0)
    800022f0:	fec40593          	add	a1,s0,-20
    800022f4:	4501                	li	a0,0
    800022f6:	00000097          	auipc	ra,0x0
    800022fa:	d00080e7          	jalr	-768(ra) # 80001ff6 <argint>
    {
        return -1;
    800022fe:	57fd                	li	a5,-1
    if (argint(0, &ticks) < 0 || argaddr(1, &fn) < 0)
    80002300:	02054b63          	bltz	a0,80002336 <sys_sigalarm+0x4e>
    80002304:	fe040593          	add	a1,s0,-32
    80002308:	4505                	li	a0,1
    8000230a:	00000097          	auipc	ra,0x0
    8000230e:	d0e080e7          	jalr	-754(ra) # 80002018 <argaddr>
        return -1;
    80002312:	57fd                	li	a5,-1
    if (argint(0, &ticks) < 0 || argaddr(1, &fn) < 0)
    80002314:	02054163          	bltz	a0,80002336 <sys_sigalarm+0x4e>
    }
    struct proc *p = myproc();
    80002318:	fffff097          	auipc	ra,0xfffff
    8000231c:	b64080e7          	jalr	-1180(ra) # 80000e7c <myproc>
    p->alarm_info.alarm_interval = ticks;
    80002320:	fec42783          	lw	a5,-20(s0)
    80002324:	16f52423          	sw	a5,360(a0)
    p->alarm_info.alarm_ticks = ticks;
    80002328:	16f52c23          	sw	a5,376(a0)
    p->alarm_info.alarm_handler = fn;
    8000232c:	fe043783          	ld	a5,-32(s0)
    80002330:	16f53823          	sd	a5,368(a0)
    return 0;
    80002334:	4781                	li	a5,0
}
    80002336:	853e                	mv	a0,a5
    80002338:	60e2                	ld	ra,24(sp)
    8000233a:	6442                	ld	s0,16(sp)
    8000233c:	6105                	add	sp,sp,32
    8000233e:	8082                	ret

0000000080002340 <sys_sigreturn>:

uint64 sys_sigreturn(void)
{
    80002340:	1141                	add	sp,sp,-16
    80002342:	e406                	sd	ra,8(sp)
    80002344:	e022                	sd	s0,0(sp)
    80002346:	0800                	add	s0,sp,16
    struct proc *p = myproc();
    80002348:	fffff097          	auipc	ra,0xfffff
    8000234c:	b34080e7          	jalr	-1228(ra) # 80000e7c <myproc>
    *p->trapframe = *p->alarm_trapframe;
    80002350:	18053683          	ld	a3,384(a0)
    80002354:	87b6                	mv	a5,a3
    80002356:	6d38                	ld	a4,88(a0)
    80002358:	12068693          	add	a3,a3,288
    8000235c:	0007b883          	ld	a7,0(a5)
    80002360:	0087b803          	ld	a6,8(a5)
    80002364:	6b8c                	ld	a1,16(a5)
    80002366:	6f90                	ld	a2,24(a5)
    80002368:	01173023          	sd	a7,0(a4)
    8000236c:	01073423          	sd	a6,8(a4)
    80002370:	eb0c                	sd	a1,16(a4)
    80002372:	ef10                	sd	a2,24(a4)
    80002374:	02078793          	add	a5,a5,32
    80002378:	02070713          	add	a4,a4,32
    8000237c:	fed790e3          	bne	a5,a3,8000235c <sys_sigreturn+0x1c>
    p->alarm_info.alarm_running = 0;
    80002380:	16052e23          	sw	zero,380(a0)
    return 0;
}
    80002384:	4501                	li	a0,0
    80002386:	60a2                	ld	ra,8(sp)
    80002388:	6402                	ld	s0,0(sp)
    8000238a:	0141                	add	sp,sp,16
    8000238c:	8082                	ret

000000008000238e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000238e:	7179                	add	sp,sp,-48
    80002390:	f406                	sd	ra,40(sp)
    80002392:	f022                	sd	s0,32(sp)
    80002394:	ec26                	sd	s1,24(sp)
    80002396:	e84a                	sd	s2,16(sp)
    80002398:	e44e                	sd	s3,8(sp)
    8000239a:	e052                	sd	s4,0(sp)
    8000239c:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000239e:	00006597          	auipc	a1,0x6
    800023a2:	fe258593          	add	a1,a1,-30 # 80008380 <etext+0x380>
    800023a6:	0000d517          	auipc	a0,0xd
    800023aa:	2f250513          	add	a0,a0,754 # 8000f698 <bcache>
    800023ae:	00004097          	auipc	ra,0x4
    800023b2:	f14080e7          	jalr	-236(ra) # 800062c2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023b6:	00015797          	auipc	a5,0x15
    800023ba:	2e278793          	add	a5,a5,738 # 80017698 <bcache+0x8000>
    800023be:	00015717          	auipc	a4,0x15
    800023c2:	54270713          	add	a4,a4,1346 # 80017900 <bcache+0x8268>
    800023c6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023ca:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ce:	0000d497          	auipc	s1,0xd
    800023d2:	2e248493          	add	s1,s1,738 # 8000f6b0 <bcache+0x18>
    b->next = bcache.head.next;
    800023d6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023d8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023da:	00006a17          	auipc	s4,0x6
    800023de:	faea0a13          	add	s4,s4,-82 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    800023e2:	2b893783          	ld	a5,696(s2)
    800023e6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023e8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023ec:	85d2                	mv	a1,s4
    800023ee:	01048513          	add	a0,s1,16
    800023f2:	00001097          	auipc	ra,0x1
    800023f6:	4b2080e7          	jalr	1202(ra) # 800038a4 <initsleeplock>
    bcache.head.next->prev = b;
    800023fa:	2b893783          	ld	a5,696(s2)
    800023fe:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002400:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002404:	45848493          	add	s1,s1,1112
    80002408:	fd349de3          	bne	s1,s3,800023e2 <binit+0x54>
  }
}
    8000240c:	70a2                	ld	ra,40(sp)
    8000240e:	7402                	ld	s0,32(sp)
    80002410:	64e2                	ld	s1,24(sp)
    80002412:	6942                	ld	s2,16(sp)
    80002414:	69a2                	ld	s3,8(sp)
    80002416:	6a02                	ld	s4,0(sp)
    80002418:	6145                	add	sp,sp,48
    8000241a:	8082                	ret

000000008000241c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000241c:	7179                	add	sp,sp,-48
    8000241e:	f406                	sd	ra,40(sp)
    80002420:	f022                	sd	s0,32(sp)
    80002422:	ec26                	sd	s1,24(sp)
    80002424:	e84a                	sd	s2,16(sp)
    80002426:	e44e                	sd	s3,8(sp)
    80002428:	1800                	add	s0,sp,48
    8000242a:	892a                	mv	s2,a0
    8000242c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000242e:	0000d517          	auipc	a0,0xd
    80002432:	26a50513          	add	a0,a0,618 # 8000f698 <bcache>
    80002436:	00004097          	auipc	ra,0x4
    8000243a:	f1c080e7          	jalr	-228(ra) # 80006352 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000243e:	00015497          	auipc	s1,0x15
    80002442:	5124b483          	ld	s1,1298(s1) # 80017950 <bcache+0x82b8>
    80002446:	00015797          	auipc	a5,0x15
    8000244a:	4ba78793          	add	a5,a5,1210 # 80017900 <bcache+0x8268>
    8000244e:	02f48f63          	beq	s1,a5,8000248c <bread+0x70>
    80002452:	873e                	mv	a4,a5
    80002454:	a021                	j	8000245c <bread+0x40>
    80002456:	68a4                	ld	s1,80(s1)
    80002458:	02e48a63          	beq	s1,a4,8000248c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000245c:	449c                	lw	a5,8(s1)
    8000245e:	ff279ce3          	bne	a5,s2,80002456 <bread+0x3a>
    80002462:	44dc                	lw	a5,12(s1)
    80002464:	ff3799e3          	bne	a5,s3,80002456 <bread+0x3a>
      b->refcnt++;
    80002468:	40bc                	lw	a5,64(s1)
    8000246a:	2785                	addw	a5,a5,1
    8000246c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000246e:	0000d517          	auipc	a0,0xd
    80002472:	22a50513          	add	a0,a0,554 # 8000f698 <bcache>
    80002476:	00004097          	auipc	ra,0x4
    8000247a:	f90080e7          	jalr	-112(ra) # 80006406 <release>
      acquiresleep(&b->lock);
    8000247e:	01048513          	add	a0,s1,16
    80002482:	00001097          	auipc	ra,0x1
    80002486:	45c080e7          	jalr	1116(ra) # 800038de <acquiresleep>
      return b;
    8000248a:	a8b9                	j	800024e8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000248c:	00015497          	auipc	s1,0x15
    80002490:	4bc4b483          	ld	s1,1212(s1) # 80017948 <bcache+0x82b0>
    80002494:	00015797          	auipc	a5,0x15
    80002498:	46c78793          	add	a5,a5,1132 # 80017900 <bcache+0x8268>
    8000249c:	00f48863          	beq	s1,a5,800024ac <bread+0x90>
    800024a0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024a2:	40bc                	lw	a5,64(s1)
    800024a4:	cf81                	beqz	a5,800024bc <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024a6:	64a4                	ld	s1,72(s1)
    800024a8:	fee49de3          	bne	s1,a4,800024a2 <bread+0x86>
  panic("bget: no buffers");
    800024ac:	00006517          	auipc	a0,0x6
    800024b0:	ee450513          	add	a0,a0,-284 # 80008390 <etext+0x390>
    800024b4:	00004097          	auipc	ra,0x4
    800024b8:	8c8080e7          	jalr	-1848(ra) # 80005d7c <panic>
      b->dev = dev;
    800024bc:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024c0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024c4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024c8:	4785                	li	a5,1
    800024ca:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024cc:	0000d517          	auipc	a0,0xd
    800024d0:	1cc50513          	add	a0,a0,460 # 8000f698 <bcache>
    800024d4:	00004097          	auipc	ra,0x4
    800024d8:	f32080e7          	jalr	-206(ra) # 80006406 <release>
      acquiresleep(&b->lock);
    800024dc:	01048513          	add	a0,s1,16
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	3fe080e7          	jalr	1022(ra) # 800038de <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024e8:	409c                	lw	a5,0(s1)
    800024ea:	cb89                	beqz	a5,800024fc <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024ec:	8526                	mv	a0,s1
    800024ee:	70a2                	ld	ra,40(sp)
    800024f0:	7402                	ld	s0,32(sp)
    800024f2:	64e2                	ld	s1,24(sp)
    800024f4:	6942                	ld	s2,16(sp)
    800024f6:	69a2                	ld	s3,8(sp)
    800024f8:	6145                	add	sp,sp,48
    800024fa:	8082                	ret
    virtio_disk_rw(b, 0);
    800024fc:	4581                	li	a1,0
    800024fe:	8526                	mv	a0,s1
    80002500:	00003097          	auipc	ra,0x3
    80002504:	fe2080e7          	jalr	-30(ra) # 800054e2 <virtio_disk_rw>
    b->valid = 1;
    80002508:	4785                	li	a5,1
    8000250a:	c09c                	sw	a5,0(s1)
  return b;
    8000250c:	b7c5                	j	800024ec <bread+0xd0>

000000008000250e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000250e:	1101                	add	sp,sp,-32
    80002510:	ec06                	sd	ra,24(sp)
    80002512:	e822                	sd	s0,16(sp)
    80002514:	e426                	sd	s1,8(sp)
    80002516:	1000                	add	s0,sp,32
    80002518:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000251a:	0541                	add	a0,a0,16
    8000251c:	00001097          	auipc	ra,0x1
    80002520:	45c080e7          	jalr	1116(ra) # 80003978 <holdingsleep>
    80002524:	cd01                	beqz	a0,8000253c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002526:	4585                	li	a1,1
    80002528:	8526                	mv	a0,s1
    8000252a:	00003097          	auipc	ra,0x3
    8000252e:	fb8080e7          	jalr	-72(ra) # 800054e2 <virtio_disk_rw>
}
    80002532:	60e2                	ld	ra,24(sp)
    80002534:	6442                	ld	s0,16(sp)
    80002536:	64a2                	ld	s1,8(sp)
    80002538:	6105                	add	sp,sp,32
    8000253a:	8082                	ret
    panic("bwrite");
    8000253c:	00006517          	auipc	a0,0x6
    80002540:	e6c50513          	add	a0,a0,-404 # 800083a8 <etext+0x3a8>
    80002544:	00004097          	auipc	ra,0x4
    80002548:	838080e7          	jalr	-1992(ra) # 80005d7c <panic>

000000008000254c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000254c:	1101                	add	sp,sp,-32
    8000254e:	ec06                	sd	ra,24(sp)
    80002550:	e822                	sd	s0,16(sp)
    80002552:	e426                	sd	s1,8(sp)
    80002554:	e04a                	sd	s2,0(sp)
    80002556:	1000                	add	s0,sp,32
    80002558:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000255a:	01050913          	add	s2,a0,16
    8000255e:	854a                	mv	a0,s2
    80002560:	00001097          	auipc	ra,0x1
    80002564:	418080e7          	jalr	1048(ra) # 80003978 <holdingsleep>
    80002568:	c925                	beqz	a0,800025d8 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000256a:	854a                	mv	a0,s2
    8000256c:	00001097          	auipc	ra,0x1
    80002570:	3c8080e7          	jalr	968(ra) # 80003934 <releasesleep>

  acquire(&bcache.lock);
    80002574:	0000d517          	auipc	a0,0xd
    80002578:	12450513          	add	a0,a0,292 # 8000f698 <bcache>
    8000257c:	00004097          	auipc	ra,0x4
    80002580:	dd6080e7          	jalr	-554(ra) # 80006352 <acquire>
  b->refcnt--;
    80002584:	40bc                	lw	a5,64(s1)
    80002586:	37fd                	addw	a5,a5,-1
    80002588:	0007871b          	sext.w	a4,a5
    8000258c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000258e:	e71d                	bnez	a4,800025bc <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002590:	68b8                	ld	a4,80(s1)
    80002592:	64bc                	ld	a5,72(s1)
    80002594:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002596:	68b8                	ld	a4,80(s1)
    80002598:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000259a:	00015797          	auipc	a5,0x15
    8000259e:	0fe78793          	add	a5,a5,254 # 80017698 <bcache+0x8000>
    800025a2:	2b87b703          	ld	a4,696(a5)
    800025a6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025a8:	00015717          	auipc	a4,0x15
    800025ac:	35870713          	add	a4,a4,856 # 80017900 <bcache+0x8268>
    800025b0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025b2:	2b87b703          	ld	a4,696(a5)
    800025b6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025b8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025bc:	0000d517          	auipc	a0,0xd
    800025c0:	0dc50513          	add	a0,a0,220 # 8000f698 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	e42080e7          	jalr	-446(ra) # 80006406 <release>
}
    800025cc:	60e2                	ld	ra,24(sp)
    800025ce:	6442                	ld	s0,16(sp)
    800025d0:	64a2                	ld	s1,8(sp)
    800025d2:	6902                	ld	s2,0(sp)
    800025d4:	6105                	add	sp,sp,32
    800025d6:	8082                	ret
    panic("brelse");
    800025d8:	00006517          	auipc	a0,0x6
    800025dc:	dd850513          	add	a0,a0,-552 # 800083b0 <etext+0x3b0>
    800025e0:	00003097          	auipc	ra,0x3
    800025e4:	79c080e7          	jalr	1948(ra) # 80005d7c <panic>

00000000800025e8 <bpin>:

void
bpin(struct buf *b) {
    800025e8:	1101                	add	sp,sp,-32
    800025ea:	ec06                	sd	ra,24(sp)
    800025ec:	e822                	sd	s0,16(sp)
    800025ee:	e426                	sd	s1,8(sp)
    800025f0:	1000                	add	s0,sp,32
    800025f2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f4:	0000d517          	auipc	a0,0xd
    800025f8:	0a450513          	add	a0,a0,164 # 8000f698 <bcache>
    800025fc:	00004097          	auipc	ra,0x4
    80002600:	d56080e7          	jalr	-682(ra) # 80006352 <acquire>
  b->refcnt++;
    80002604:	40bc                	lw	a5,64(s1)
    80002606:	2785                	addw	a5,a5,1
    80002608:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000260a:	0000d517          	auipc	a0,0xd
    8000260e:	08e50513          	add	a0,a0,142 # 8000f698 <bcache>
    80002612:	00004097          	auipc	ra,0x4
    80002616:	df4080e7          	jalr	-524(ra) # 80006406 <release>
}
    8000261a:	60e2                	ld	ra,24(sp)
    8000261c:	6442                	ld	s0,16(sp)
    8000261e:	64a2                	ld	s1,8(sp)
    80002620:	6105                	add	sp,sp,32
    80002622:	8082                	ret

0000000080002624 <bunpin>:

void
bunpin(struct buf *b) {
    80002624:	1101                	add	sp,sp,-32
    80002626:	ec06                	sd	ra,24(sp)
    80002628:	e822                	sd	s0,16(sp)
    8000262a:	e426                	sd	s1,8(sp)
    8000262c:	1000                	add	s0,sp,32
    8000262e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002630:	0000d517          	auipc	a0,0xd
    80002634:	06850513          	add	a0,a0,104 # 8000f698 <bcache>
    80002638:	00004097          	auipc	ra,0x4
    8000263c:	d1a080e7          	jalr	-742(ra) # 80006352 <acquire>
  b->refcnt--;
    80002640:	40bc                	lw	a5,64(s1)
    80002642:	37fd                	addw	a5,a5,-1
    80002644:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002646:	0000d517          	auipc	a0,0xd
    8000264a:	05250513          	add	a0,a0,82 # 8000f698 <bcache>
    8000264e:	00004097          	auipc	ra,0x4
    80002652:	db8080e7          	jalr	-584(ra) # 80006406 <release>
}
    80002656:	60e2                	ld	ra,24(sp)
    80002658:	6442                	ld	s0,16(sp)
    8000265a:	64a2                	ld	s1,8(sp)
    8000265c:	6105                	add	sp,sp,32
    8000265e:	8082                	ret

0000000080002660 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002660:	1101                	add	sp,sp,-32
    80002662:	ec06                	sd	ra,24(sp)
    80002664:	e822                	sd	s0,16(sp)
    80002666:	e426                	sd	s1,8(sp)
    80002668:	e04a                	sd	s2,0(sp)
    8000266a:	1000                	add	s0,sp,32
    8000266c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000266e:	00d5d59b          	srlw	a1,a1,0xd
    80002672:	00015797          	auipc	a5,0x15
    80002676:	7027a783          	lw	a5,1794(a5) # 80017d74 <sb+0x1c>
    8000267a:	9dbd                	addw	a1,a1,a5
    8000267c:	00000097          	auipc	ra,0x0
    80002680:	da0080e7          	jalr	-608(ra) # 8000241c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002684:	0074f713          	and	a4,s1,7
    80002688:	4785                	li	a5,1
    8000268a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000268e:	14ce                	sll	s1,s1,0x33
    80002690:	90d9                	srl	s1,s1,0x36
    80002692:	00950733          	add	a4,a0,s1
    80002696:	05874703          	lbu	a4,88(a4)
    8000269a:	00e7f6b3          	and	a3,a5,a4
    8000269e:	c69d                	beqz	a3,800026cc <bfree+0x6c>
    800026a0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026a2:	94aa                	add	s1,s1,a0
    800026a4:	fff7c793          	not	a5,a5
    800026a8:	8f7d                	and	a4,a4,a5
    800026aa:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026ae:	00001097          	auipc	ra,0x1
    800026b2:	112080e7          	jalr	274(ra) # 800037c0 <log_write>
  brelse(bp);
    800026b6:	854a                	mv	a0,s2
    800026b8:	00000097          	auipc	ra,0x0
    800026bc:	e94080e7          	jalr	-364(ra) # 8000254c <brelse>
}
    800026c0:	60e2                	ld	ra,24(sp)
    800026c2:	6442                	ld	s0,16(sp)
    800026c4:	64a2                	ld	s1,8(sp)
    800026c6:	6902                	ld	s2,0(sp)
    800026c8:	6105                	add	sp,sp,32
    800026ca:	8082                	ret
    panic("freeing free block");
    800026cc:	00006517          	auipc	a0,0x6
    800026d0:	cec50513          	add	a0,a0,-788 # 800083b8 <etext+0x3b8>
    800026d4:	00003097          	auipc	ra,0x3
    800026d8:	6a8080e7          	jalr	1704(ra) # 80005d7c <panic>

00000000800026dc <balloc>:
{
    800026dc:	711d                	add	sp,sp,-96
    800026de:	ec86                	sd	ra,88(sp)
    800026e0:	e8a2                	sd	s0,80(sp)
    800026e2:	e4a6                	sd	s1,72(sp)
    800026e4:	e0ca                	sd	s2,64(sp)
    800026e6:	fc4e                	sd	s3,56(sp)
    800026e8:	f852                	sd	s4,48(sp)
    800026ea:	f456                	sd	s5,40(sp)
    800026ec:	f05a                	sd	s6,32(sp)
    800026ee:	ec5e                	sd	s7,24(sp)
    800026f0:	e862                	sd	s8,16(sp)
    800026f2:	e466                	sd	s9,8(sp)
    800026f4:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026f6:	00015797          	auipc	a5,0x15
    800026fa:	6667a783          	lw	a5,1638(a5) # 80017d5c <sb+0x4>
    800026fe:	cbc1                	beqz	a5,8000278e <balloc+0xb2>
    80002700:	8baa                	mv	s7,a0
    80002702:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002704:	00015b17          	auipc	s6,0x15
    80002708:	654b0b13          	add	s6,s6,1620 # 80017d58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000270c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000270e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002710:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002712:	6c89                	lui	s9,0x2
    80002714:	a831                	j	80002730 <balloc+0x54>
    brelse(bp);
    80002716:	854a                	mv	a0,s2
    80002718:	00000097          	auipc	ra,0x0
    8000271c:	e34080e7          	jalr	-460(ra) # 8000254c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002720:	015c87bb          	addw	a5,s9,s5
    80002724:	00078a9b          	sext.w	s5,a5
    80002728:	004b2703          	lw	a4,4(s6)
    8000272c:	06eaf163          	bgeu	s5,a4,8000278e <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002730:	41fad79b          	sraw	a5,s5,0x1f
    80002734:	0137d79b          	srlw	a5,a5,0x13
    80002738:	015787bb          	addw	a5,a5,s5
    8000273c:	40d7d79b          	sraw	a5,a5,0xd
    80002740:	01cb2583          	lw	a1,28(s6)
    80002744:	9dbd                	addw	a1,a1,a5
    80002746:	855e                	mv	a0,s7
    80002748:	00000097          	auipc	ra,0x0
    8000274c:	cd4080e7          	jalr	-812(ra) # 8000241c <bread>
    80002750:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002752:	004b2503          	lw	a0,4(s6)
    80002756:	000a849b          	sext.w	s1,s5
    8000275a:	8762                	mv	a4,s8
    8000275c:	faa4fde3          	bgeu	s1,a0,80002716 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002760:	00777693          	and	a3,a4,7
    80002764:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002768:	41f7579b          	sraw	a5,a4,0x1f
    8000276c:	01d7d79b          	srlw	a5,a5,0x1d
    80002770:	9fb9                	addw	a5,a5,a4
    80002772:	4037d79b          	sraw	a5,a5,0x3
    80002776:	00f90633          	add	a2,s2,a5
    8000277a:	05864603          	lbu	a2,88(a2)
    8000277e:	00c6f5b3          	and	a1,a3,a2
    80002782:	cd91                	beqz	a1,8000279e <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002784:	2705                	addw	a4,a4,1
    80002786:	2485                	addw	s1,s1,1
    80002788:	fd471ae3          	bne	a4,s4,8000275c <balloc+0x80>
    8000278c:	b769                	j	80002716 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000278e:	00006517          	auipc	a0,0x6
    80002792:	c4250513          	add	a0,a0,-958 # 800083d0 <etext+0x3d0>
    80002796:	00003097          	auipc	ra,0x3
    8000279a:	5e6080e7          	jalr	1510(ra) # 80005d7c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000279e:	97ca                	add	a5,a5,s2
    800027a0:	8e55                	or	a2,a2,a3
    800027a2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800027a6:	854a                	mv	a0,s2
    800027a8:	00001097          	auipc	ra,0x1
    800027ac:	018080e7          	jalr	24(ra) # 800037c0 <log_write>
        brelse(bp);
    800027b0:	854a                	mv	a0,s2
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	d9a080e7          	jalr	-614(ra) # 8000254c <brelse>
  bp = bread(dev, bno);
    800027ba:	85a6                	mv	a1,s1
    800027bc:	855e                	mv	a0,s7
    800027be:	00000097          	auipc	ra,0x0
    800027c2:	c5e080e7          	jalr	-930(ra) # 8000241c <bread>
    800027c6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027c8:	40000613          	li	a2,1024
    800027cc:	4581                	li	a1,0
    800027ce:	05850513          	add	a0,a0,88
    800027d2:	ffffe097          	auipc	ra,0xffffe
    800027d6:	9a8080e7          	jalr	-1624(ra) # 8000017a <memset>
  log_write(bp);
    800027da:	854a                	mv	a0,s2
    800027dc:	00001097          	auipc	ra,0x1
    800027e0:	fe4080e7          	jalr	-28(ra) # 800037c0 <log_write>
  brelse(bp);
    800027e4:	854a                	mv	a0,s2
    800027e6:	00000097          	auipc	ra,0x0
    800027ea:	d66080e7          	jalr	-666(ra) # 8000254c <brelse>
}
    800027ee:	8526                	mv	a0,s1
    800027f0:	60e6                	ld	ra,88(sp)
    800027f2:	6446                	ld	s0,80(sp)
    800027f4:	64a6                	ld	s1,72(sp)
    800027f6:	6906                	ld	s2,64(sp)
    800027f8:	79e2                	ld	s3,56(sp)
    800027fa:	7a42                	ld	s4,48(sp)
    800027fc:	7aa2                	ld	s5,40(sp)
    800027fe:	7b02                	ld	s6,32(sp)
    80002800:	6be2                	ld	s7,24(sp)
    80002802:	6c42                	ld	s8,16(sp)
    80002804:	6ca2                	ld	s9,8(sp)
    80002806:	6125                	add	sp,sp,96
    80002808:	8082                	ret

000000008000280a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000280a:	7179                	add	sp,sp,-48
    8000280c:	f406                	sd	ra,40(sp)
    8000280e:	f022                	sd	s0,32(sp)
    80002810:	ec26                	sd	s1,24(sp)
    80002812:	e84a                	sd	s2,16(sp)
    80002814:	e44e                	sd	s3,8(sp)
    80002816:	1800                	add	s0,sp,48
    80002818:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000281a:	47ad                	li	a5,11
    8000281c:	04b7ff63          	bgeu	a5,a1,8000287a <bmap+0x70>
    80002820:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002822:	ff45849b          	addw	s1,a1,-12
    80002826:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000282a:	0ff00793          	li	a5,255
    8000282e:	0ae7e463          	bltu	a5,a4,800028d6 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002832:	08052583          	lw	a1,128(a0)
    80002836:	c5b5                	beqz	a1,800028a2 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002838:	00092503          	lw	a0,0(s2)
    8000283c:	00000097          	auipc	ra,0x0
    80002840:	be0080e7          	jalr	-1056(ra) # 8000241c <bread>
    80002844:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002846:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    8000284a:	02049713          	sll	a4,s1,0x20
    8000284e:	01e75593          	srl	a1,a4,0x1e
    80002852:	00b784b3          	add	s1,a5,a1
    80002856:	0004a983          	lw	s3,0(s1)
    8000285a:	04098e63          	beqz	s3,800028b6 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000285e:	8552                	mv	a0,s4
    80002860:	00000097          	auipc	ra,0x0
    80002864:	cec080e7          	jalr	-788(ra) # 8000254c <brelse>
    return addr;
    80002868:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000286a:	854e                	mv	a0,s3
    8000286c:	70a2                	ld	ra,40(sp)
    8000286e:	7402                	ld	s0,32(sp)
    80002870:	64e2                	ld	s1,24(sp)
    80002872:	6942                	ld	s2,16(sp)
    80002874:	69a2                	ld	s3,8(sp)
    80002876:	6145                	add	sp,sp,48
    80002878:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000287a:	02059793          	sll	a5,a1,0x20
    8000287e:	01e7d593          	srl	a1,a5,0x1e
    80002882:	00b504b3          	add	s1,a0,a1
    80002886:	0504a983          	lw	s3,80(s1)
    8000288a:	fe0990e3          	bnez	s3,8000286a <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000288e:	4108                	lw	a0,0(a0)
    80002890:	00000097          	auipc	ra,0x0
    80002894:	e4c080e7          	jalr	-436(ra) # 800026dc <balloc>
    80002898:	0005099b          	sext.w	s3,a0
    8000289c:	0534a823          	sw	s3,80(s1)
    800028a0:	b7e9                	j	8000286a <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800028a2:	4108                	lw	a0,0(a0)
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	e38080e7          	jalr	-456(ra) # 800026dc <balloc>
    800028ac:	0005059b          	sext.w	a1,a0
    800028b0:	08b92023          	sw	a1,128(s2)
    800028b4:	b751                	j	80002838 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800028b6:	00092503          	lw	a0,0(s2)
    800028ba:	00000097          	auipc	ra,0x0
    800028be:	e22080e7          	jalr	-478(ra) # 800026dc <balloc>
    800028c2:	0005099b          	sext.w	s3,a0
    800028c6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028ca:	8552                	mv	a0,s4
    800028cc:	00001097          	auipc	ra,0x1
    800028d0:	ef4080e7          	jalr	-268(ra) # 800037c0 <log_write>
    800028d4:	b769                	j	8000285e <bmap+0x54>
  panic("bmap: out of range");
    800028d6:	00006517          	auipc	a0,0x6
    800028da:	b1250513          	add	a0,a0,-1262 # 800083e8 <etext+0x3e8>
    800028de:	00003097          	auipc	ra,0x3
    800028e2:	49e080e7          	jalr	1182(ra) # 80005d7c <panic>

00000000800028e6 <iget>:
{
    800028e6:	7179                	add	sp,sp,-48
    800028e8:	f406                	sd	ra,40(sp)
    800028ea:	f022                	sd	s0,32(sp)
    800028ec:	ec26                	sd	s1,24(sp)
    800028ee:	e84a                	sd	s2,16(sp)
    800028f0:	e44e                	sd	s3,8(sp)
    800028f2:	e052                	sd	s4,0(sp)
    800028f4:	1800                	add	s0,sp,48
    800028f6:	89aa                	mv	s3,a0
    800028f8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028fa:	00015517          	auipc	a0,0x15
    800028fe:	47e50513          	add	a0,a0,1150 # 80017d78 <itable>
    80002902:	00004097          	auipc	ra,0x4
    80002906:	a50080e7          	jalr	-1456(ra) # 80006352 <acquire>
  empty = 0;
    8000290a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000290c:	00015497          	auipc	s1,0x15
    80002910:	48448493          	add	s1,s1,1156 # 80017d90 <itable+0x18>
    80002914:	00017697          	auipc	a3,0x17
    80002918:	f0c68693          	add	a3,a3,-244 # 80019820 <log>
    8000291c:	a039                	j	8000292a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000291e:	02090b63          	beqz	s2,80002954 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002922:	08848493          	add	s1,s1,136
    80002926:	02d48a63          	beq	s1,a3,8000295a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000292a:	449c                	lw	a5,8(s1)
    8000292c:	fef059e3          	blez	a5,8000291e <iget+0x38>
    80002930:	4098                	lw	a4,0(s1)
    80002932:	ff3716e3          	bne	a4,s3,8000291e <iget+0x38>
    80002936:	40d8                	lw	a4,4(s1)
    80002938:	ff4713e3          	bne	a4,s4,8000291e <iget+0x38>
      ip->ref++;
    8000293c:	2785                	addw	a5,a5,1
    8000293e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002940:	00015517          	auipc	a0,0x15
    80002944:	43850513          	add	a0,a0,1080 # 80017d78 <itable>
    80002948:	00004097          	auipc	ra,0x4
    8000294c:	abe080e7          	jalr	-1346(ra) # 80006406 <release>
      return ip;
    80002950:	8926                	mv	s2,s1
    80002952:	a03d                	j	80002980 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002954:	f7f9                	bnez	a5,80002922 <iget+0x3c>
      empty = ip;
    80002956:	8926                	mv	s2,s1
    80002958:	b7e9                	j	80002922 <iget+0x3c>
  if(empty == 0)
    8000295a:	02090c63          	beqz	s2,80002992 <iget+0xac>
  ip->dev = dev;
    8000295e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002962:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002966:	4785                	li	a5,1
    80002968:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000296c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002970:	00015517          	auipc	a0,0x15
    80002974:	40850513          	add	a0,a0,1032 # 80017d78 <itable>
    80002978:	00004097          	auipc	ra,0x4
    8000297c:	a8e080e7          	jalr	-1394(ra) # 80006406 <release>
}
    80002980:	854a                	mv	a0,s2
    80002982:	70a2                	ld	ra,40(sp)
    80002984:	7402                	ld	s0,32(sp)
    80002986:	64e2                	ld	s1,24(sp)
    80002988:	6942                	ld	s2,16(sp)
    8000298a:	69a2                	ld	s3,8(sp)
    8000298c:	6a02                	ld	s4,0(sp)
    8000298e:	6145                	add	sp,sp,48
    80002990:	8082                	ret
    panic("iget: no inodes");
    80002992:	00006517          	auipc	a0,0x6
    80002996:	a6e50513          	add	a0,a0,-1426 # 80008400 <etext+0x400>
    8000299a:	00003097          	auipc	ra,0x3
    8000299e:	3e2080e7          	jalr	994(ra) # 80005d7c <panic>

00000000800029a2 <fsinit>:
fsinit(int dev) {
    800029a2:	7179                	add	sp,sp,-48
    800029a4:	f406                	sd	ra,40(sp)
    800029a6:	f022                	sd	s0,32(sp)
    800029a8:	ec26                	sd	s1,24(sp)
    800029aa:	e84a                	sd	s2,16(sp)
    800029ac:	e44e                	sd	s3,8(sp)
    800029ae:	1800                	add	s0,sp,48
    800029b0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029b2:	4585                	li	a1,1
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	a68080e7          	jalr	-1432(ra) # 8000241c <bread>
    800029bc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029be:	00015997          	auipc	s3,0x15
    800029c2:	39a98993          	add	s3,s3,922 # 80017d58 <sb>
    800029c6:	02000613          	li	a2,32
    800029ca:	05850593          	add	a1,a0,88
    800029ce:	854e                	mv	a0,s3
    800029d0:	ffffe097          	auipc	ra,0xffffe
    800029d4:	806080e7          	jalr	-2042(ra) # 800001d6 <memmove>
  brelse(bp);
    800029d8:	8526                	mv	a0,s1
    800029da:	00000097          	auipc	ra,0x0
    800029de:	b72080e7          	jalr	-1166(ra) # 8000254c <brelse>
  if(sb.magic != FSMAGIC)
    800029e2:	0009a703          	lw	a4,0(s3)
    800029e6:	102037b7          	lui	a5,0x10203
    800029ea:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029ee:	02f71263          	bne	a4,a5,80002a12 <fsinit+0x70>
  initlog(dev, &sb);
    800029f2:	00015597          	auipc	a1,0x15
    800029f6:	36658593          	add	a1,a1,870 # 80017d58 <sb>
    800029fa:	854a                	mv	a0,s2
    800029fc:	00001097          	auipc	ra,0x1
    80002a00:	b54080e7          	jalr	-1196(ra) # 80003550 <initlog>
}
    80002a04:	70a2                	ld	ra,40(sp)
    80002a06:	7402                	ld	s0,32(sp)
    80002a08:	64e2                	ld	s1,24(sp)
    80002a0a:	6942                	ld	s2,16(sp)
    80002a0c:	69a2                	ld	s3,8(sp)
    80002a0e:	6145                	add	sp,sp,48
    80002a10:	8082                	ret
    panic("invalid file system");
    80002a12:	00006517          	auipc	a0,0x6
    80002a16:	9fe50513          	add	a0,a0,-1538 # 80008410 <etext+0x410>
    80002a1a:	00003097          	auipc	ra,0x3
    80002a1e:	362080e7          	jalr	866(ra) # 80005d7c <panic>

0000000080002a22 <iinit>:
{
    80002a22:	7179                	add	sp,sp,-48
    80002a24:	f406                	sd	ra,40(sp)
    80002a26:	f022                	sd	s0,32(sp)
    80002a28:	ec26                	sd	s1,24(sp)
    80002a2a:	e84a                	sd	s2,16(sp)
    80002a2c:	e44e                	sd	s3,8(sp)
    80002a2e:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a30:	00006597          	auipc	a1,0x6
    80002a34:	9f858593          	add	a1,a1,-1544 # 80008428 <etext+0x428>
    80002a38:	00015517          	auipc	a0,0x15
    80002a3c:	34050513          	add	a0,a0,832 # 80017d78 <itable>
    80002a40:	00004097          	auipc	ra,0x4
    80002a44:	882080e7          	jalr	-1918(ra) # 800062c2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a48:	00015497          	auipc	s1,0x15
    80002a4c:	35848493          	add	s1,s1,856 # 80017da0 <itable+0x28>
    80002a50:	00017997          	auipc	s3,0x17
    80002a54:	de098993          	add	s3,s3,-544 # 80019830 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a58:	00006917          	auipc	s2,0x6
    80002a5c:	9d890913          	add	s2,s2,-1576 # 80008430 <etext+0x430>
    80002a60:	85ca                	mv	a1,s2
    80002a62:	8526                	mv	a0,s1
    80002a64:	00001097          	auipc	ra,0x1
    80002a68:	e40080e7          	jalr	-448(ra) # 800038a4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a6c:	08848493          	add	s1,s1,136
    80002a70:	ff3498e3          	bne	s1,s3,80002a60 <iinit+0x3e>
}
    80002a74:	70a2                	ld	ra,40(sp)
    80002a76:	7402                	ld	s0,32(sp)
    80002a78:	64e2                	ld	s1,24(sp)
    80002a7a:	6942                	ld	s2,16(sp)
    80002a7c:	69a2                	ld	s3,8(sp)
    80002a7e:	6145                	add	sp,sp,48
    80002a80:	8082                	ret

0000000080002a82 <ialloc>:
{
    80002a82:	7139                	add	sp,sp,-64
    80002a84:	fc06                	sd	ra,56(sp)
    80002a86:	f822                	sd	s0,48(sp)
    80002a88:	f426                	sd	s1,40(sp)
    80002a8a:	f04a                	sd	s2,32(sp)
    80002a8c:	ec4e                	sd	s3,24(sp)
    80002a8e:	e852                	sd	s4,16(sp)
    80002a90:	e456                	sd	s5,8(sp)
    80002a92:	e05a                	sd	s6,0(sp)
    80002a94:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a96:	00015717          	auipc	a4,0x15
    80002a9a:	2ce72703          	lw	a4,718(a4) # 80017d64 <sb+0xc>
    80002a9e:	4785                	li	a5,1
    80002aa0:	04e7f863          	bgeu	a5,a4,80002af0 <ialloc+0x6e>
    80002aa4:	8aaa                	mv	s5,a0
    80002aa6:	8b2e                	mv	s6,a1
    80002aa8:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002aaa:	00015a17          	auipc	s4,0x15
    80002aae:	2aea0a13          	add	s4,s4,686 # 80017d58 <sb>
    80002ab2:	00495593          	srl	a1,s2,0x4
    80002ab6:	018a2783          	lw	a5,24(s4)
    80002aba:	9dbd                	addw	a1,a1,a5
    80002abc:	8556                	mv	a0,s5
    80002abe:	00000097          	auipc	ra,0x0
    80002ac2:	95e080e7          	jalr	-1698(ra) # 8000241c <bread>
    80002ac6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ac8:	05850993          	add	s3,a0,88
    80002acc:	00f97793          	and	a5,s2,15
    80002ad0:	079a                	sll	a5,a5,0x6
    80002ad2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ad4:	00099783          	lh	a5,0(s3)
    80002ad8:	c785                	beqz	a5,80002b00 <ialloc+0x7e>
    brelse(bp);
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	a72080e7          	jalr	-1422(ra) # 8000254c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ae2:	0905                	add	s2,s2,1
    80002ae4:	00ca2703          	lw	a4,12(s4)
    80002ae8:	0009079b          	sext.w	a5,s2
    80002aec:	fce7e3e3          	bltu	a5,a4,80002ab2 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002af0:	00006517          	auipc	a0,0x6
    80002af4:	94850513          	add	a0,a0,-1720 # 80008438 <etext+0x438>
    80002af8:	00003097          	auipc	ra,0x3
    80002afc:	284080e7          	jalr	644(ra) # 80005d7c <panic>
      memset(dip, 0, sizeof(*dip));
    80002b00:	04000613          	li	a2,64
    80002b04:	4581                	li	a1,0
    80002b06:	854e                	mv	a0,s3
    80002b08:	ffffd097          	auipc	ra,0xffffd
    80002b0c:	672080e7          	jalr	1650(ra) # 8000017a <memset>
      dip->type = type;
    80002b10:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b14:	8526                	mv	a0,s1
    80002b16:	00001097          	auipc	ra,0x1
    80002b1a:	caa080e7          	jalr	-854(ra) # 800037c0 <log_write>
      brelse(bp);
    80002b1e:	8526                	mv	a0,s1
    80002b20:	00000097          	auipc	ra,0x0
    80002b24:	a2c080e7          	jalr	-1492(ra) # 8000254c <brelse>
      return iget(dev, inum);
    80002b28:	0009059b          	sext.w	a1,s2
    80002b2c:	8556                	mv	a0,s5
    80002b2e:	00000097          	auipc	ra,0x0
    80002b32:	db8080e7          	jalr	-584(ra) # 800028e6 <iget>
}
    80002b36:	70e2                	ld	ra,56(sp)
    80002b38:	7442                	ld	s0,48(sp)
    80002b3a:	74a2                	ld	s1,40(sp)
    80002b3c:	7902                	ld	s2,32(sp)
    80002b3e:	69e2                	ld	s3,24(sp)
    80002b40:	6a42                	ld	s4,16(sp)
    80002b42:	6aa2                	ld	s5,8(sp)
    80002b44:	6b02                	ld	s6,0(sp)
    80002b46:	6121                	add	sp,sp,64
    80002b48:	8082                	ret

0000000080002b4a <iupdate>:
{
    80002b4a:	1101                	add	sp,sp,-32
    80002b4c:	ec06                	sd	ra,24(sp)
    80002b4e:	e822                	sd	s0,16(sp)
    80002b50:	e426                	sd	s1,8(sp)
    80002b52:	e04a                	sd	s2,0(sp)
    80002b54:	1000                	add	s0,sp,32
    80002b56:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b58:	415c                	lw	a5,4(a0)
    80002b5a:	0047d79b          	srlw	a5,a5,0x4
    80002b5e:	00015597          	auipc	a1,0x15
    80002b62:	2125a583          	lw	a1,530(a1) # 80017d70 <sb+0x18>
    80002b66:	9dbd                	addw	a1,a1,a5
    80002b68:	4108                	lw	a0,0(a0)
    80002b6a:	00000097          	auipc	ra,0x0
    80002b6e:	8b2080e7          	jalr	-1870(ra) # 8000241c <bread>
    80002b72:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b74:	05850793          	add	a5,a0,88
    80002b78:	40d8                	lw	a4,4(s1)
    80002b7a:	8b3d                	and	a4,a4,15
    80002b7c:	071a                	sll	a4,a4,0x6
    80002b7e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b80:	04449703          	lh	a4,68(s1)
    80002b84:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b88:	04649703          	lh	a4,70(s1)
    80002b8c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b90:	04849703          	lh	a4,72(s1)
    80002b94:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b98:	04a49703          	lh	a4,74(s1)
    80002b9c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ba0:	44f8                	lw	a4,76(s1)
    80002ba2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ba4:	03400613          	li	a2,52
    80002ba8:	05048593          	add	a1,s1,80
    80002bac:	00c78513          	add	a0,a5,12
    80002bb0:	ffffd097          	auipc	ra,0xffffd
    80002bb4:	626080e7          	jalr	1574(ra) # 800001d6 <memmove>
  log_write(bp);
    80002bb8:	854a                	mv	a0,s2
    80002bba:	00001097          	auipc	ra,0x1
    80002bbe:	c06080e7          	jalr	-1018(ra) # 800037c0 <log_write>
  brelse(bp);
    80002bc2:	854a                	mv	a0,s2
    80002bc4:	00000097          	auipc	ra,0x0
    80002bc8:	988080e7          	jalr	-1656(ra) # 8000254c <brelse>
}
    80002bcc:	60e2                	ld	ra,24(sp)
    80002bce:	6442                	ld	s0,16(sp)
    80002bd0:	64a2                	ld	s1,8(sp)
    80002bd2:	6902                	ld	s2,0(sp)
    80002bd4:	6105                	add	sp,sp,32
    80002bd6:	8082                	ret

0000000080002bd8 <idup>:
{
    80002bd8:	1101                	add	sp,sp,-32
    80002bda:	ec06                	sd	ra,24(sp)
    80002bdc:	e822                	sd	s0,16(sp)
    80002bde:	e426                	sd	s1,8(sp)
    80002be0:	1000                	add	s0,sp,32
    80002be2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002be4:	00015517          	auipc	a0,0x15
    80002be8:	19450513          	add	a0,a0,404 # 80017d78 <itable>
    80002bec:	00003097          	auipc	ra,0x3
    80002bf0:	766080e7          	jalr	1894(ra) # 80006352 <acquire>
  ip->ref++;
    80002bf4:	449c                	lw	a5,8(s1)
    80002bf6:	2785                	addw	a5,a5,1
    80002bf8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bfa:	00015517          	auipc	a0,0x15
    80002bfe:	17e50513          	add	a0,a0,382 # 80017d78 <itable>
    80002c02:	00004097          	auipc	ra,0x4
    80002c06:	804080e7          	jalr	-2044(ra) # 80006406 <release>
}
    80002c0a:	8526                	mv	a0,s1
    80002c0c:	60e2                	ld	ra,24(sp)
    80002c0e:	6442                	ld	s0,16(sp)
    80002c10:	64a2                	ld	s1,8(sp)
    80002c12:	6105                	add	sp,sp,32
    80002c14:	8082                	ret

0000000080002c16 <ilock>:
{
    80002c16:	1101                	add	sp,sp,-32
    80002c18:	ec06                	sd	ra,24(sp)
    80002c1a:	e822                	sd	s0,16(sp)
    80002c1c:	e426                	sd	s1,8(sp)
    80002c1e:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c20:	c10d                	beqz	a0,80002c42 <ilock+0x2c>
    80002c22:	84aa                	mv	s1,a0
    80002c24:	451c                	lw	a5,8(a0)
    80002c26:	00f05e63          	blez	a5,80002c42 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002c2a:	0541                	add	a0,a0,16
    80002c2c:	00001097          	auipc	ra,0x1
    80002c30:	cb2080e7          	jalr	-846(ra) # 800038de <acquiresleep>
  if(ip->valid == 0){
    80002c34:	40bc                	lw	a5,64(s1)
    80002c36:	cf99                	beqz	a5,80002c54 <ilock+0x3e>
}
    80002c38:	60e2                	ld	ra,24(sp)
    80002c3a:	6442                	ld	s0,16(sp)
    80002c3c:	64a2                	ld	s1,8(sp)
    80002c3e:	6105                	add	sp,sp,32
    80002c40:	8082                	ret
    80002c42:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002c44:	00006517          	auipc	a0,0x6
    80002c48:	80c50513          	add	a0,a0,-2036 # 80008450 <etext+0x450>
    80002c4c:	00003097          	auipc	ra,0x3
    80002c50:	130080e7          	jalr	304(ra) # 80005d7c <panic>
    80002c54:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c56:	40dc                	lw	a5,4(s1)
    80002c58:	0047d79b          	srlw	a5,a5,0x4
    80002c5c:	00015597          	auipc	a1,0x15
    80002c60:	1145a583          	lw	a1,276(a1) # 80017d70 <sb+0x18>
    80002c64:	9dbd                	addw	a1,a1,a5
    80002c66:	4088                	lw	a0,0(s1)
    80002c68:	fffff097          	auipc	ra,0xfffff
    80002c6c:	7b4080e7          	jalr	1972(ra) # 8000241c <bread>
    80002c70:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c72:	05850593          	add	a1,a0,88
    80002c76:	40dc                	lw	a5,4(s1)
    80002c78:	8bbd                	and	a5,a5,15
    80002c7a:	079a                	sll	a5,a5,0x6
    80002c7c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c7e:	00059783          	lh	a5,0(a1)
    80002c82:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c86:	00259783          	lh	a5,2(a1)
    80002c8a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c8e:	00459783          	lh	a5,4(a1)
    80002c92:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c96:	00659783          	lh	a5,6(a1)
    80002c9a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c9e:	459c                	lw	a5,8(a1)
    80002ca0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ca2:	03400613          	li	a2,52
    80002ca6:	05b1                	add	a1,a1,12
    80002ca8:	05048513          	add	a0,s1,80
    80002cac:	ffffd097          	auipc	ra,0xffffd
    80002cb0:	52a080e7          	jalr	1322(ra) # 800001d6 <memmove>
    brelse(bp);
    80002cb4:	854a                	mv	a0,s2
    80002cb6:	00000097          	auipc	ra,0x0
    80002cba:	896080e7          	jalr	-1898(ra) # 8000254c <brelse>
    ip->valid = 1;
    80002cbe:	4785                	li	a5,1
    80002cc0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cc2:	04449783          	lh	a5,68(s1)
    80002cc6:	c399                	beqz	a5,80002ccc <ilock+0xb6>
    80002cc8:	6902                	ld	s2,0(sp)
    80002cca:	b7bd                	j	80002c38 <ilock+0x22>
      panic("ilock: no type");
    80002ccc:	00005517          	auipc	a0,0x5
    80002cd0:	78c50513          	add	a0,a0,1932 # 80008458 <etext+0x458>
    80002cd4:	00003097          	auipc	ra,0x3
    80002cd8:	0a8080e7          	jalr	168(ra) # 80005d7c <panic>

0000000080002cdc <iunlock>:
{
    80002cdc:	1101                	add	sp,sp,-32
    80002cde:	ec06                	sd	ra,24(sp)
    80002ce0:	e822                	sd	s0,16(sp)
    80002ce2:	e426                	sd	s1,8(sp)
    80002ce4:	e04a                	sd	s2,0(sp)
    80002ce6:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ce8:	c905                	beqz	a0,80002d18 <iunlock+0x3c>
    80002cea:	84aa                	mv	s1,a0
    80002cec:	01050913          	add	s2,a0,16
    80002cf0:	854a                	mv	a0,s2
    80002cf2:	00001097          	auipc	ra,0x1
    80002cf6:	c86080e7          	jalr	-890(ra) # 80003978 <holdingsleep>
    80002cfa:	cd19                	beqz	a0,80002d18 <iunlock+0x3c>
    80002cfc:	449c                	lw	a5,8(s1)
    80002cfe:	00f05d63          	blez	a5,80002d18 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d02:	854a                	mv	a0,s2
    80002d04:	00001097          	auipc	ra,0x1
    80002d08:	c30080e7          	jalr	-976(ra) # 80003934 <releasesleep>
}
    80002d0c:	60e2                	ld	ra,24(sp)
    80002d0e:	6442                	ld	s0,16(sp)
    80002d10:	64a2                	ld	s1,8(sp)
    80002d12:	6902                	ld	s2,0(sp)
    80002d14:	6105                	add	sp,sp,32
    80002d16:	8082                	ret
    panic("iunlock");
    80002d18:	00005517          	auipc	a0,0x5
    80002d1c:	75050513          	add	a0,a0,1872 # 80008468 <etext+0x468>
    80002d20:	00003097          	auipc	ra,0x3
    80002d24:	05c080e7          	jalr	92(ra) # 80005d7c <panic>

0000000080002d28 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d28:	7179                	add	sp,sp,-48
    80002d2a:	f406                	sd	ra,40(sp)
    80002d2c:	f022                	sd	s0,32(sp)
    80002d2e:	ec26                	sd	s1,24(sp)
    80002d30:	e84a                	sd	s2,16(sp)
    80002d32:	e44e                	sd	s3,8(sp)
    80002d34:	1800                	add	s0,sp,48
    80002d36:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d38:	05050493          	add	s1,a0,80
    80002d3c:	08050913          	add	s2,a0,128
    80002d40:	a021                	j	80002d48 <itrunc+0x20>
    80002d42:	0491                	add	s1,s1,4
    80002d44:	01248d63          	beq	s1,s2,80002d5e <itrunc+0x36>
    if(ip->addrs[i]){
    80002d48:	408c                	lw	a1,0(s1)
    80002d4a:	dde5                	beqz	a1,80002d42 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002d4c:	0009a503          	lw	a0,0(s3)
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	910080e7          	jalr	-1776(ra) # 80002660 <bfree>
      ip->addrs[i] = 0;
    80002d58:	0004a023          	sw	zero,0(s1)
    80002d5c:	b7dd                	j	80002d42 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d5e:	0809a583          	lw	a1,128(s3)
    80002d62:	ed99                	bnez	a1,80002d80 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d64:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d68:	854e                	mv	a0,s3
    80002d6a:	00000097          	auipc	ra,0x0
    80002d6e:	de0080e7          	jalr	-544(ra) # 80002b4a <iupdate>
}
    80002d72:	70a2                	ld	ra,40(sp)
    80002d74:	7402                	ld	s0,32(sp)
    80002d76:	64e2                	ld	s1,24(sp)
    80002d78:	6942                	ld	s2,16(sp)
    80002d7a:	69a2                	ld	s3,8(sp)
    80002d7c:	6145                	add	sp,sp,48
    80002d7e:	8082                	ret
    80002d80:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d82:	0009a503          	lw	a0,0(s3)
    80002d86:	fffff097          	auipc	ra,0xfffff
    80002d8a:	696080e7          	jalr	1686(ra) # 8000241c <bread>
    80002d8e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d90:	05850493          	add	s1,a0,88
    80002d94:	45850913          	add	s2,a0,1112
    80002d98:	a021                	j	80002da0 <itrunc+0x78>
    80002d9a:	0491                	add	s1,s1,4
    80002d9c:	01248b63          	beq	s1,s2,80002db2 <itrunc+0x8a>
      if(a[j])
    80002da0:	408c                	lw	a1,0(s1)
    80002da2:	dde5                	beqz	a1,80002d9a <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002da4:	0009a503          	lw	a0,0(s3)
    80002da8:	00000097          	auipc	ra,0x0
    80002dac:	8b8080e7          	jalr	-1864(ra) # 80002660 <bfree>
    80002db0:	b7ed                	j	80002d9a <itrunc+0x72>
    brelse(bp);
    80002db2:	8552                	mv	a0,s4
    80002db4:	fffff097          	auipc	ra,0xfffff
    80002db8:	798080e7          	jalr	1944(ra) # 8000254c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dbc:	0809a583          	lw	a1,128(s3)
    80002dc0:	0009a503          	lw	a0,0(s3)
    80002dc4:	00000097          	auipc	ra,0x0
    80002dc8:	89c080e7          	jalr	-1892(ra) # 80002660 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dcc:	0809a023          	sw	zero,128(s3)
    80002dd0:	6a02                	ld	s4,0(sp)
    80002dd2:	bf49                	j	80002d64 <itrunc+0x3c>

0000000080002dd4 <iput>:
{
    80002dd4:	1101                	add	sp,sp,-32
    80002dd6:	ec06                	sd	ra,24(sp)
    80002dd8:	e822                	sd	s0,16(sp)
    80002dda:	e426                	sd	s1,8(sp)
    80002ddc:	1000                	add	s0,sp,32
    80002dde:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002de0:	00015517          	auipc	a0,0x15
    80002de4:	f9850513          	add	a0,a0,-104 # 80017d78 <itable>
    80002de8:	00003097          	auipc	ra,0x3
    80002dec:	56a080e7          	jalr	1386(ra) # 80006352 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002df0:	4498                	lw	a4,8(s1)
    80002df2:	4785                	li	a5,1
    80002df4:	02f70263          	beq	a4,a5,80002e18 <iput+0x44>
  ip->ref--;
    80002df8:	449c                	lw	a5,8(s1)
    80002dfa:	37fd                	addw	a5,a5,-1
    80002dfc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dfe:	00015517          	auipc	a0,0x15
    80002e02:	f7a50513          	add	a0,a0,-134 # 80017d78 <itable>
    80002e06:	00003097          	auipc	ra,0x3
    80002e0a:	600080e7          	jalr	1536(ra) # 80006406 <release>
}
    80002e0e:	60e2                	ld	ra,24(sp)
    80002e10:	6442                	ld	s0,16(sp)
    80002e12:	64a2                	ld	s1,8(sp)
    80002e14:	6105                	add	sp,sp,32
    80002e16:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e18:	40bc                	lw	a5,64(s1)
    80002e1a:	dff9                	beqz	a5,80002df8 <iput+0x24>
    80002e1c:	04a49783          	lh	a5,74(s1)
    80002e20:	ffe1                	bnez	a5,80002df8 <iput+0x24>
    80002e22:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e24:	01048913          	add	s2,s1,16
    80002e28:	854a                	mv	a0,s2
    80002e2a:	00001097          	auipc	ra,0x1
    80002e2e:	ab4080e7          	jalr	-1356(ra) # 800038de <acquiresleep>
    release(&itable.lock);
    80002e32:	00015517          	auipc	a0,0x15
    80002e36:	f4650513          	add	a0,a0,-186 # 80017d78 <itable>
    80002e3a:	00003097          	auipc	ra,0x3
    80002e3e:	5cc080e7          	jalr	1484(ra) # 80006406 <release>
    itrunc(ip);
    80002e42:	8526                	mv	a0,s1
    80002e44:	00000097          	auipc	ra,0x0
    80002e48:	ee4080e7          	jalr	-284(ra) # 80002d28 <itrunc>
    ip->type = 0;
    80002e4c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e50:	8526                	mv	a0,s1
    80002e52:	00000097          	auipc	ra,0x0
    80002e56:	cf8080e7          	jalr	-776(ra) # 80002b4a <iupdate>
    ip->valid = 0;
    80002e5a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e5e:	854a                	mv	a0,s2
    80002e60:	00001097          	auipc	ra,0x1
    80002e64:	ad4080e7          	jalr	-1324(ra) # 80003934 <releasesleep>
    acquire(&itable.lock);
    80002e68:	00015517          	auipc	a0,0x15
    80002e6c:	f1050513          	add	a0,a0,-240 # 80017d78 <itable>
    80002e70:	00003097          	auipc	ra,0x3
    80002e74:	4e2080e7          	jalr	1250(ra) # 80006352 <acquire>
    80002e78:	6902                	ld	s2,0(sp)
    80002e7a:	bfbd                	j	80002df8 <iput+0x24>

0000000080002e7c <iunlockput>:
{
    80002e7c:	1101                	add	sp,sp,-32
    80002e7e:	ec06                	sd	ra,24(sp)
    80002e80:	e822                	sd	s0,16(sp)
    80002e82:	e426                	sd	s1,8(sp)
    80002e84:	1000                	add	s0,sp,32
    80002e86:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e88:	00000097          	auipc	ra,0x0
    80002e8c:	e54080e7          	jalr	-428(ra) # 80002cdc <iunlock>
  iput(ip);
    80002e90:	8526                	mv	a0,s1
    80002e92:	00000097          	auipc	ra,0x0
    80002e96:	f42080e7          	jalr	-190(ra) # 80002dd4 <iput>
}
    80002e9a:	60e2                	ld	ra,24(sp)
    80002e9c:	6442                	ld	s0,16(sp)
    80002e9e:	64a2                	ld	s1,8(sp)
    80002ea0:	6105                	add	sp,sp,32
    80002ea2:	8082                	ret

0000000080002ea4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ea4:	1141                	add	sp,sp,-16
    80002ea6:	e422                	sd	s0,8(sp)
    80002ea8:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80002eaa:	411c                	lw	a5,0(a0)
    80002eac:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002eae:	415c                	lw	a5,4(a0)
    80002eb0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002eb2:	04451783          	lh	a5,68(a0)
    80002eb6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002eba:	04a51783          	lh	a5,74(a0)
    80002ebe:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ec2:	04c56783          	lwu	a5,76(a0)
    80002ec6:	e99c                	sd	a5,16(a1)
}
    80002ec8:	6422                	ld	s0,8(sp)
    80002eca:	0141                	add	sp,sp,16
    80002ecc:	8082                	ret

0000000080002ece <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ece:	457c                	lw	a5,76(a0)
    80002ed0:	0ed7ef63          	bltu	a5,a3,80002fce <readi+0x100>
{
    80002ed4:	7159                	add	sp,sp,-112
    80002ed6:	f486                	sd	ra,104(sp)
    80002ed8:	f0a2                	sd	s0,96(sp)
    80002eda:	eca6                	sd	s1,88(sp)
    80002edc:	fc56                	sd	s5,56(sp)
    80002ede:	f85a                	sd	s6,48(sp)
    80002ee0:	f45e                	sd	s7,40(sp)
    80002ee2:	f062                	sd	s8,32(sp)
    80002ee4:	1880                	add	s0,sp,112
    80002ee6:	8baa                	mv	s7,a0
    80002ee8:	8c2e                	mv	s8,a1
    80002eea:	8ab2                	mv	s5,a2
    80002eec:	84b6                	mv	s1,a3
    80002eee:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ef0:	9f35                	addw	a4,a4,a3
    return 0;
    80002ef2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ef4:	0ad76c63          	bltu	a4,a3,80002fac <readi+0xde>
    80002ef8:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002efa:	00e7f463          	bgeu	a5,a4,80002f02 <readi+0x34>
    n = ip->size - off;
    80002efe:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f02:	0c0b0463          	beqz	s6,80002fca <readi+0xfc>
    80002f06:	e8ca                	sd	s2,80(sp)
    80002f08:	e0d2                	sd	s4,64(sp)
    80002f0a:	ec66                	sd	s9,24(sp)
    80002f0c:	e86a                	sd	s10,16(sp)
    80002f0e:	e46e                	sd	s11,8(sp)
    80002f10:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f12:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f16:	5cfd                	li	s9,-1
    80002f18:	a82d                	j	80002f52 <readi+0x84>
    80002f1a:	020a1d93          	sll	s11,s4,0x20
    80002f1e:	020ddd93          	srl	s11,s11,0x20
    80002f22:	05890613          	add	a2,s2,88
    80002f26:	86ee                	mv	a3,s11
    80002f28:	963a                	add	a2,a2,a4
    80002f2a:	85d6                	mv	a1,s5
    80002f2c:	8562                	mv	a0,s8
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	a12080e7          	jalr	-1518(ra) # 80001940 <either_copyout>
    80002f36:	05950d63          	beq	a0,s9,80002f90 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f3a:	854a                	mv	a0,s2
    80002f3c:	fffff097          	auipc	ra,0xfffff
    80002f40:	610080e7          	jalr	1552(ra) # 8000254c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f44:	013a09bb          	addw	s3,s4,s3
    80002f48:	009a04bb          	addw	s1,s4,s1
    80002f4c:	9aee                	add	s5,s5,s11
    80002f4e:	0769f863          	bgeu	s3,s6,80002fbe <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f52:	000ba903          	lw	s2,0(s7)
    80002f56:	00a4d59b          	srlw	a1,s1,0xa
    80002f5a:	855e                	mv	a0,s7
    80002f5c:	00000097          	auipc	ra,0x0
    80002f60:	8ae080e7          	jalr	-1874(ra) # 8000280a <bmap>
    80002f64:	0005059b          	sext.w	a1,a0
    80002f68:	854a                	mv	a0,s2
    80002f6a:	fffff097          	auipc	ra,0xfffff
    80002f6e:	4b2080e7          	jalr	1202(ra) # 8000241c <bread>
    80002f72:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f74:	3ff4f713          	and	a4,s1,1023
    80002f78:	40ed07bb          	subw	a5,s10,a4
    80002f7c:	413b06bb          	subw	a3,s6,s3
    80002f80:	8a3e                	mv	s4,a5
    80002f82:	2781                	sext.w	a5,a5
    80002f84:	0006861b          	sext.w	a2,a3
    80002f88:	f8f679e3          	bgeu	a2,a5,80002f1a <readi+0x4c>
    80002f8c:	8a36                	mv	s4,a3
    80002f8e:	b771                	j	80002f1a <readi+0x4c>
      brelse(bp);
    80002f90:	854a                	mv	a0,s2
    80002f92:	fffff097          	auipc	ra,0xfffff
    80002f96:	5ba080e7          	jalr	1466(ra) # 8000254c <brelse>
      tot = -1;
    80002f9a:	59fd                	li	s3,-1
      break;
    80002f9c:	6946                	ld	s2,80(sp)
    80002f9e:	6a06                	ld	s4,64(sp)
    80002fa0:	6ce2                	ld	s9,24(sp)
    80002fa2:	6d42                	ld	s10,16(sp)
    80002fa4:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002fa6:	0009851b          	sext.w	a0,s3
    80002faa:	69a6                	ld	s3,72(sp)
}
    80002fac:	70a6                	ld	ra,104(sp)
    80002fae:	7406                	ld	s0,96(sp)
    80002fb0:	64e6                	ld	s1,88(sp)
    80002fb2:	7ae2                	ld	s5,56(sp)
    80002fb4:	7b42                	ld	s6,48(sp)
    80002fb6:	7ba2                	ld	s7,40(sp)
    80002fb8:	7c02                	ld	s8,32(sp)
    80002fba:	6165                	add	sp,sp,112
    80002fbc:	8082                	ret
    80002fbe:	6946                	ld	s2,80(sp)
    80002fc0:	6a06                	ld	s4,64(sp)
    80002fc2:	6ce2                	ld	s9,24(sp)
    80002fc4:	6d42                	ld	s10,16(sp)
    80002fc6:	6da2                	ld	s11,8(sp)
    80002fc8:	bff9                	j	80002fa6 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fca:	89da                	mv	s3,s6
    80002fcc:	bfe9                	j	80002fa6 <readi+0xd8>
    return 0;
    80002fce:	4501                	li	a0,0
}
    80002fd0:	8082                	ret

0000000080002fd2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fd2:	457c                	lw	a5,76(a0)
    80002fd4:	10d7ee63          	bltu	a5,a3,800030f0 <writei+0x11e>
{
    80002fd8:	7159                	add	sp,sp,-112
    80002fda:	f486                	sd	ra,104(sp)
    80002fdc:	f0a2                	sd	s0,96(sp)
    80002fde:	e8ca                	sd	s2,80(sp)
    80002fe0:	fc56                	sd	s5,56(sp)
    80002fe2:	f85a                	sd	s6,48(sp)
    80002fe4:	f45e                	sd	s7,40(sp)
    80002fe6:	f062                	sd	s8,32(sp)
    80002fe8:	1880                	add	s0,sp,112
    80002fea:	8b2a                	mv	s6,a0
    80002fec:	8c2e                	mv	s8,a1
    80002fee:	8ab2                	mv	s5,a2
    80002ff0:	8936                	mv	s2,a3
    80002ff2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002ff4:	00e687bb          	addw	a5,a3,a4
    80002ff8:	0ed7ee63          	bltu	a5,a3,800030f4 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ffc:	00043737          	lui	a4,0x43
    80003000:	0ef76c63          	bltu	a4,a5,800030f8 <writei+0x126>
    80003004:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003006:	0c0b8d63          	beqz	s7,800030e0 <writei+0x10e>
    8000300a:	eca6                	sd	s1,88(sp)
    8000300c:	e4ce                	sd	s3,72(sp)
    8000300e:	ec66                	sd	s9,24(sp)
    80003010:	e86a                	sd	s10,16(sp)
    80003012:	e46e                	sd	s11,8(sp)
    80003014:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003016:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000301a:	5cfd                	li	s9,-1
    8000301c:	a091                	j	80003060 <writei+0x8e>
    8000301e:	02099d93          	sll	s11,s3,0x20
    80003022:	020ddd93          	srl	s11,s11,0x20
    80003026:	05848513          	add	a0,s1,88
    8000302a:	86ee                	mv	a3,s11
    8000302c:	8656                	mv	a2,s5
    8000302e:	85e2                	mv	a1,s8
    80003030:	953a                	add	a0,a0,a4
    80003032:	fffff097          	auipc	ra,0xfffff
    80003036:	964080e7          	jalr	-1692(ra) # 80001996 <either_copyin>
    8000303a:	07950263          	beq	a0,s9,8000309e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000303e:	8526                	mv	a0,s1
    80003040:	00000097          	auipc	ra,0x0
    80003044:	780080e7          	jalr	1920(ra) # 800037c0 <log_write>
    brelse(bp);
    80003048:	8526                	mv	a0,s1
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	502080e7          	jalr	1282(ra) # 8000254c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003052:	01498a3b          	addw	s4,s3,s4
    80003056:	0129893b          	addw	s2,s3,s2
    8000305a:	9aee                	add	s5,s5,s11
    8000305c:	057a7663          	bgeu	s4,s7,800030a8 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003060:	000b2483          	lw	s1,0(s6)
    80003064:	00a9559b          	srlw	a1,s2,0xa
    80003068:	855a                	mv	a0,s6
    8000306a:	fffff097          	auipc	ra,0xfffff
    8000306e:	7a0080e7          	jalr	1952(ra) # 8000280a <bmap>
    80003072:	0005059b          	sext.w	a1,a0
    80003076:	8526                	mv	a0,s1
    80003078:	fffff097          	auipc	ra,0xfffff
    8000307c:	3a4080e7          	jalr	932(ra) # 8000241c <bread>
    80003080:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003082:	3ff97713          	and	a4,s2,1023
    80003086:	40ed07bb          	subw	a5,s10,a4
    8000308a:	414b86bb          	subw	a3,s7,s4
    8000308e:	89be                	mv	s3,a5
    80003090:	2781                	sext.w	a5,a5
    80003092:	0006861b          	sext.w	a2,a3
    80003096:	f8f674e3          	bgeu	a2,a5,8000301e <writei+0x4c>
    8000309a:	89b6                	mv	s3,a3
    8000309c:	b749                	j	8000301e <writei+0x4c>
      brelse(bp);
    8000309e:	8526                	mv	a0,s1
    800030a0:	fffff097          	auipc	ra,0xfffff
    800030a4:	4ac080e7          	jalr	1196(ra) # 8000254c <brelse>
  }

  if(off > ip->size)
    800030a8:	04cb2783          	lw	a5,76(s6)
    800030ac:	0327fc63          	bgeu	a5,s2,800030e4 <writei+0x112>
    ip->size = off;
    800030b0:	052b2623          	sw	s2,76(s6)
    800030b4:	64e6                	ld	s1,88(sp)
    800030b6:	69a6                	ld	s3,72(sp)
    800030b8:	6ce2                	ld	s9,24(sp)
    800030ba:	6d42                	ld	s10,16(sp)
    800030bc:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030be:	855a                	mv	a0,s6
    800030c0:	00000097          	auipc	ra,0x0
    800030c4:	a8a080e7          	jalr	-1398(ra) # 80002b4a <iupdate>

  return tot;
    800030c8:	000a051b          	sext.w	a0,s4
    800030cc:	6a06                	ld	s4,64(sp)
}
    800030ce:	70a6                	ld	ra,104(sp)
    800030d0:	7406                	ld	s0,96(sp)
    800030d2:	6946                	ld	s2,80(sp)
    800030d4:	7ae2                	ld	s5,56(sp)
    800030d6:	7b42                	ld	s6,48(sp)
    800030d8:	7ba2                	ld	s7,40(sp)
    800030da:	7c02                	ld	s8,32(sp)
    800030dc:	6165                	add	sp,sp,112
    800030de:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030e0:	8a5e                	mv	s4,s7
    800030e2:	bff1                	j	800030be <writei+0xec>
    800030e4:	64e6                	ld	s1,88(sp)
    800030e6:	69a6                	ld	s3,72(sp)
    800030e8:	6ce2                	ld	s9,24(sp)
    800030ea:	6d42                	ld	s10,16(sp)
    800030ec:	6da2                	ld	s11,8(sp)
    800030ee:	bfc1                	j	800030be <writei+0xec>
    return -1;
    800030f0:	557d                	li	a0,-1
}
    800030f2:	8082                	ret
    return -1;
    800030f4:	557d                	li	a0,-1
    800030f6:	bfe1                	j	800030ce <writei+0xfc>
    return -1;
    800030f8:	557d                	li	a0,-1
    800030fa:	bfd1                	j	800030ce <writei+0xfc>

00000000800030fc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030fc:	1141                	add	sp,sp,-16
    800030fe:	e406                	sd	ra,8(sp)
    80003100:	e022                	sd	s0,0(sp)
    80003102:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003104:	4639                	li	a2,14
    80003106:	ffffd097          	auipc	ra,0xffffd
    8000310a:	144080e7          	jalr	324(ra) # 8000024a <strncmp>
}
    8000310e:	60a2                	ld	ra,8(sp)
    80003110:	6402                	ld	s0,0(sp)
    80003112:	0141                	add	sp,sp,16
    80003114:	8082                	ret

0000000080003116 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003116:	7139                	add	sp,sp,-64
    80003118:	fc06                	sd	ra,56(sp)
    8000311a:	f822                	sd	s0,48(sp)
    8000311c:	f426                	sd	s1,40(sp)
    8000311e:	f04a                	sd	s2,32(sp)
    80003120:	ec4e                	sd	s3,24(sp)
    80003122:	e852                	sd	s4,16(sp)
    80003124:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003126:	04451703          	lh	a4,68(a0)
    8000312a:	4785                	li	a5,1
    8000312c:	00f71a63          	bne	a4,a5,80003140 <dirlookup+0x2a>
    80003130:	892a                	mv	s2,a0
    80003132:	89ae                	mv	s3,a1
    80003134:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003136:	457c                	lw	a5,76(a0)
    80003138:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000313a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000313c:	e79d                	bnez	a5,8000316a <dirlookup+0x54>
    8000313e:	a8a5                	j	800031b6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003140:	00005517          	auipc	a0,0x5
    80003144:	33050513          	add	a0,a0,816 # 80008470 <etext+0x470>
    80003148:	00003097          	auipc	ra,0x3
    8000314c:	c34080e7          	jalr	-972(ra) # 80005d7c <panic>
      panic("dirlookup read");
    80003150:	00005517          	auipc	a0,0x5
    80003154:	33850513          	add	a0,a0,824 # 80008488 <etext+0x488>
    80003158:	00003097          	auipc	ra,0x3
    8000315c:	c24080e7          	jalr	-988(ra) # 80005d7c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003160:	24c1                	addw	s1,s1,16
    80003162:	04c92783          	lw	a5,76(s2)
    80003166:	04f4f763          	bgeu	s1,a5,800031b4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000316a:	4741                	li	a4,16
    8000316c:	86a6                	mv	a3,s1
    8000316e:	fc040613          	add	a2,s0,-64
    80003172:	4581                	li	a1,0
    80003174:	854a                	mv	a0,s2
    80003176:	00000097          	auipc	ra,0x0
    8000317a:	d58080e7          	jalr	-680(ra) # 80002ece <readi>
    8000317e:	47c1                	li	a5,16
    80003180:	fcf518e3          	bne	a0,a5,80003150 <dirlookup+0x3a>
    if(de.inum == 0)
    80003184:	fc045783          	lhu	a5,-64(s0)
    80003188:	dfe1                	beqz	a5,80003160 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000318a:	fc240593          	add	a1,s0,-62
    8000318e:	854e                	mv	a0,s3
    80003190:	00000097          	auipc	ra,0x0
    80003194:	f6c080e7          	jalr	-148(ra) # 800030fc <namecmp>
    80003198:	f561                	bnez	a0,80003160 <dirlookup+0x4a>
      if(poff)
    8000319a:	000a0463          	beqz	s4,800031a2 <dirlookup+0x8c>
        *poff = off;
    8000319e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031a2:	fc045583          	lhu	a1,-64(s0)
    800031a6:	00092503          	lw	a0,0(s2)
    800031aa:	fffff097          	auipc	ra,0xfffff
    800031ae:	73c080e7          	jalr	1852(ra) # 800028e6 <iget>
    800031b2:	a011                	j	800031b6 <dirlookup+0xa0>
  return 0;
    800031b4:	4501                	li	a0,0
}
    800031b6:	70e2                	ld	ra,56(sp)
    800031b8:	7442                	ld	s0,48(sp)
    800031ba:	74a2                	ld	s1,40(sp)
    800031bc:	7902                	ld	s2,32(sp)
    800031be:	69e2                	ld	s3,24(sp)
    800031c0:	6a42                	ld	s4,16(sp)
    800031c2:	6121                	add	sp,sp,64
    800031c4:	8082                	ret

00000000800031c6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031c6:	711d                	add	sp,sp,-96
    800031c8:	ec86                	sd	ra,88(sp)
    800031ca:	e8a2                	sd	s0,80(sp)
    800031cc:	e4a6                	sd	s1,72(sp)
    800031ce:	e0ca                	sd	s2,64(sp)
    800031d0:	fc4e                	sd	s3,56(sp)
    800031d2:	f852                	sd	s4,48(sp)
    800031d4:	f456                	sd	s5,40(sp)
    800031d6:	f05a                	sd	s6,32(sp)
    800031d8:	ec5e                	sd	s7,24(sp)
    800031da:	e862                	sd	s8,16(sp)
    800031dc:	e466                	sd	s9,8(sp)
    800031de:	1080                	add	s0,sp,96
    800031e0:	84aa                	mv	s1,a0
    800031e2:	8b2e                	mv	s6,a1
    800031e4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031e6:	00054703          	lbu	a4,0(a0)
    800031ea:	02f00793          	li	a5,47
    800031ee:	02f70263          	beq	a4,a5,80003212 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031f2:	ffffe097          	auipc	ra,0xffffe
    800031f6:	c8a080e7          	jalr	-886(ra) # 80000e7c <myproc>
    800031fa:	15053503          	ld	a0,336(a0)
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	9da080e7          	jalr	-1574(ra) # 80002bd8 <idup>
    80003206:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003208:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000320c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000320e:	4b85                	li	s7,1
    80003210:	a875                	j	800032cc <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003212:	4585                	li	a1,1
    80003214:	4505                	li	a0,1
    80003216:	fffff097          	auipc	ra,0xfffff
    8000321a:	6d0080e7          	jalr	1744(ra) # 800028e6 <iget>
    8000321e:	8a2a                	mv	s4,a0
    80003220:	b7e5                	j	80003208 <namex+0x42>
      iunlockput(ip);
    80003222:	8552                	mv	a0,s4
    80003224:	00000097          	auipc	ra,0x0
    80003228:	c58080e7          	jalr	-936(ra) # 80002e7c <iunlockput>
      return 0;
    8000322c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000322e:	8552                	mv	a0,s4
    80003230:	60e6                	ld	ra,88(sp)
    80003232:	6446                	ld	s0,80(sp)
    80003234:	64a6                	ld	s1,72(sp)
    80003236:	6906                	ld	s2,64(sp)
    80003238:	79e2                	ld	s3,56(sp)
    8000323a:	7a42                	ld	s4,48(sp)
    8000323c:	7aa2                	ld	s5,40(sp)
    8000323e:	7b02                	ld	s6,32(sp)
    80003240:	6be2                	ld	s7,24(sp)
    80003242:	6c42                	ld	s8,16(sp)
    80003244:	6ca2                	ld	s9,8(sp)
    80003246:	6125                	add	sp,sp,96
    80003248:	8082                	ret
      iunlock(ip);
    8000324a:	8552                	mv	a0,s4
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	a90080e7          	jalr	-1392(ra) # 80002cdc <iunlock>
      return ip;
    80003254:	bfe9                	j	8000322e <namex+0x68>
      iunlockput(ip);
    80003256:	8552                	mv	a0,s4
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	c24080e7          	jalr	-988(ra) # 80002e7c <iunlockput>
      return 0;
    80003260:	8a4e                	mv	s4,s3
    80003262:	b7f1                	j	8000322e <namex+0x68>
  len = path - s;
    80003264:	40998633          	sub	a2,s3,s1
    80003268:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000326c:	099c5863          	bge	s8,s9,800032fc <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003270:	4639                	li	a2,14
    80003272:	85a6                	mv	a1,s1
    80003274:	8556                	mv	a0,s5
    80003276:	ffffd097          	auipc	ra,0xffffd
    8000327a:	f60080e7          	jalr	-160(ra) # 800001d6 <memmove>
    8000327e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003280:	0004c783          	lbu	a5,0(s1)
    80003284:	01279763          	bne	a5,s2,80003292 <namex+0xcc>
    path++;
    80003288:	0485                	add	s1,s1,1
  while(*path == '/')
    8000328a:	0004c783          	lbu	a5,0(s1)
    8000328e:	ff278de3          	beq	a5,s2,80003288 <namex+0xc2>
    ilock(ip);
    80003292:	8552                	mv	a0,s4
    80003294:	00000097          	auipc	ra,0x0
    80003298:	982080e7          	jalr	-1662(ra) # 80002c16 <ilock>
    if(ip->type != T_DIR){
    8000329c:	044a1783          	lh	a5,68(s4)
    800032a0:	f97791e3          	bne	a5,s7,80003222 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800032a4:	000b0563          	beqz	s6,800032ae <namex+0xe8>
    800032a8:	0004c783          	lbu	a5,0(s1)
    800032ac:	dfd9                	beqz	a5,8000324a <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032ae:	4601                	li	a2,0
    800032b0:	85d6                	mv	a1,s5
    800032b2:	8552                	mv	a0,s4
    800032b4:	00000097          	auipc	ra,0x0
    800032b8:	e62080e7          	jalr	-414(ra) # 80003116 <dirlookup>
    800032bc:	89aa                	mv	s3,a0
    800032be:	dd41                	beqz	a0,80003256 <namex+0x90>
    iunlockput(ip);
    800032c0:	8552                	mv	a0,s4
    800032c2:	00000097          	auipc	ra,0x0
    800032c6:	bba080e7          	jalr	-1094(ra) # 80002e7c <iunlockput>
    ip = next;
    800032ca:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032cc:	0004c783          	lbu	a5,0(s1)
    800032d0:	01279763          	bne	a5,s2,800032de <namex+0x118>
    path++;
    800032d4:	0485                	add	s1,s1,1
  while(*path == '/')
    800032d6:	0004c783          	lbu	a5,0(s1)
    800032da:	ff278de3          	beq	a5,s2,800032d4 <namex+0x10e>
  if(*path == 0)
    800032de:	cb9d                	beqz	a5,80003314 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032e0:	0004c783          	lbu	a5,0(s1)
    800032e4:	89a6                	mv	s3,s1
  len = path - s;
    800032e6:	4c81                	li	s9,0
    800032e8:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032ea:	01278963          	beq	a5,s2,800032fc <namex+0x136>
    800032ee:	dbbd                	beqz	a5,80003264 <namex+0x9e>
    path++;
    800032f0:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    800032f2:	0009c783          	lbu	a5,0(s3)
    800032f6:	ff279ce3          	bne	a5,s2,800032ee <namex+0x128>
    800032fa:	b7ad                	j	80003264 <namex+0x9e>
    memmove(name, s, len);
    800032fc:	2601                	sext.w	a2,a2
    800032fe:	85a6                	mv	a1,s1
    80003300:	8556                	mv	a0,s5
    80003302:	ffffd097          	auipc	ra,0xffffd
    80003306:	ed4080e7          	jalr	-300(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000330a:	9cd6                	add	s9,s9,s5
    8000330c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003310:	84ce                	mv	s1,s3
    80003312:	b7bd                	j	80003280 <namex+0xba>
  if(nameiparent){
    80003314:	f00b0de3          	beqz	s6,8000322e <namex+0x68>
    iput(ip);
    80003318:	8552                	mv	a0,s4
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	aba080e7          	jalr	-1350(ra) # 80002dd4 <iput>
    return 0;
    80003322:	4a01                	li	s4,0
    80003324:	b729                	j	8000322e <namex+0x68>

0000000080003326 <dirlink>:
{
    80003326:	7139                	add	sp,sp,-64
    80003328:	fc06                	sd	ra,56(sp)
    8000332a:	f822                	sd	s0,48(sp)
    8000332c:	f04a                	sd	s2,32(sp)
    8000332e:	ec4e                	sd	s3,24(sp)
    80003330:	e852                	sd	s4,16(sp)
    80003332:	0080                	add	s0,sp,64
    80003334:	892a                	mv	s2,a0
    80003336:	8a2e                	mv	s4,a1
    80003338:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000333a:	4601                	li	a2,0
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	dda080e7          	jalr	-550(ra) # 80003116 <dirlookup>
    80003344:	ed25                	bnez	a0,800033bc <dirlink+0x96>
    80003346:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003348:	04c92483          	lw	s1,76(s2)
    8000334c:	c49d                	beqz	s1,8000337a <dirlink+0x54>
    8000334e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003350:	4741                	li	a4,16
    80003352:	86a6                	mv	a3,s1
    80003354:	fc040613          	add	a2,s0,-64
    80003358:	4581                	li	a1,0
    8000335a:	854a                	mv	a0,s2
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	b72080e7          	jalr	-1166(ra) # 80002ece <readi>
    80003364:	47c1                	li	a5,16
    80003366:	06f51163          	bne	a0,a5,800033c8 <dirlink+0xa2>
    if(de.inum == 0)
    8000336a:	fc045783          	lhu	a5,-64(s0)
    8000336e:	c791                	beqz	a5,8000337a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003370:	24c1                	addw	s1,s1,16
    80003372:	04c92783          	lw	a5,76(s2)
    80003376:	fcf4ede3          	bltu	s1,a5,80003350 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000337a:	4639                	li	a2,14
    8000337c:	85d2                	mv	a1,s4
    8000337e:	fc240513          	add	a0,s0,-62
    80003382:	ffffd097          	auipc	ra,0xffffd
    80003386:	efe080e7          	jalr	-258(ra) # 80000280 <strncpy>
  de.inum = inum;
    8000338a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000338e:	4741                	li	a4,16
    80003390:	86a6                	mv	a3,s1
    80003392:	fc040613          	add	a2,s0,-64
    80003396:	4581                	li	a1,0
    80003398:	854a                	mv	a0,s2
    8000339a:	00000097          	auipc	ra,0x0
    8000339e:	c38080e7          	jalr	-968(ra) # 80002fd2 <writei>
    800033a2:	872a                	mv	a4,a0
    800033a4:	47c1                	li	a5,16
  return 0;
    800033a6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033a8:	02f71863          	bne	a4,a5,800033d8 <dirlink+0xb2>
    800033ac:	74a2                	ld	s1,40(sp)
}
    800033ae:	70e2                	ld	ra,56(sp)
    800033b0:	7442                	ld	s0,48(sp)
    800033b2:	7902                	ld	s2,32(sp)
    800033b4:	69e2                	ld	s3,24(sp)
    800033b6:	6a42                	ld	s4,16(sp)
    800033b8:	6121                	add	sp,sp,64
    800033ba:	8082                	ret
    iput(ip);
    800033bc:	00000097          	auipc	ra,0x0
    800033c0:	a18080e7          	jalr	-1512(ra) # 80002dd4 <iput>
    return -1;
    800033c4:	557d                	li	a0,-1
    800033c6:	b7e5                	j	800033ae <dirlink+0x88>
      panic("dirlink read");
    800033c8:	00005517          	auipc	a0,0x5
    800033cc:	0d050513          	add	a0,a0,208 # 80008498 <etext+0x498>
    800033d0:	00003097          	auipc	ra,0x3
    800033d4:	9ac080e7          	jalr	-1620(ra) # 80005d7c <panic>
    panic("dirlink");
    800033d8:	00005517          	auipc	a0,0x5
    800033dc:	1d050513          	add	a0,a0,464 # 800085a8 <etext+0x5a8>
    800033e0:	00003097          	auipc	ra,0x3
    800033e4:	99c080e7          	jalr	-1636(ra) # 80005d7c <panic>

00000000800033e8 <namei>:

struct inode*
namei(char *path)
{
    800033e8:	1101                	add	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033f0:	fe040613          	add	a2,s0,-32
    800033f4:	4581                	li	a1,0
    800033f6:	00000097          	auipc	ra,0x0
    800033fa:	dd0080e7          	jalr	-560(ra) # 800031c6 <namex>
}
    800033fe:	60e2                	ld	ra,24(sp)
    80003400:	6442                	ld	s0,16(sp)
    80003402:	6105                	add	sp,sp,32
    80003404:	8082                	ret

0000000080003406 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003406:	1141                	add	sp,sp,-16
    80003408:	e406                	sd	ra,8(sp)
    8000340a:	e022                	sd	s0,0(sp)
    8000340c:	0800                	add	s0,sp,16
    8000340e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003410:	4585                	li	a1,1
    80003412:	00000097          	auipc	ra,0x0
    80003416:	db4080e7          	jalr	-588(ra) # 800031c6 <namex>
}
    8000341a:	60a2                	ld	ra,8(sp)
    8000341c:	6402                	ld	s0,0(sp)
    8000341e:	0141                	add	sp,sp,16
    80003420:	8082                	ret

0000000080003422 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003422:	1101                	add	sp,sp,-32
    80003424:	ec06                	sd	ra,24(sp)
    80003426:	e822                	sd	s0,16(sp)
    80003428:	e426                	sd	s1,8(sp)
    8000342a:	e04a                	sd	s2,0(sp)
    8000342c:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000342e:	00016917          	auipc	s2,0x16
    80003432:	3f290913          	add	s2,s2,1010 # 80019820 <log>
    80003436:	01892583          	lw	a1,24(s2)
    8000343a:	02892503          	lw	a0,40(s2)
    8000343e:	fffff097          	auipc	ra,0xfffff
    80003442:	fde080e7          	jalr	-34(ra) # 8000241c <bread>
    80003446:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003448:	02c92603          	lw	a2,44(s2)
    8000344c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000344e:	00c05f63          	blez	a2,8000346c <write_head+0x4a>
    80003452:	00016717          	auipc	a4,0x16
    80003456:	3fe70713          	add	a4,a4,1022 # 80019850 <log+0x30>
    8000345a:	87aa                	mv	a5,a0
    8000345c:	060a                	sll	a2,a2,0x2
    8000345e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003460:	4314                	lw	a3,0(a4)
    80003462:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003464:	0711                	add	a4,a4,4
    80003466:	0791                	add	a5,a5,4
    80003468:	fec79ce3          	bne	a5,a2,80003460 <write_head+0x3e>
  }
  bwrite(buf);
    8000346c:	8526                	mv	a0,s1
    8000346e:	fffff097          	auipc	ra,0xfffff
    80003472:	0a0080e7          	jalr	160(ra) # 8000250e <bwrite>
  brelse(buf);
    80003476:	8526                	mv	a0,s1
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	0d4080e7          	jalr	212(ra) # 8000254c <brelse>
}
    80003480:	60e2                	ld	ra,24(sp)
    80003482:	6442                	ld	s0,16(sp)
    80003484:	64a2                	ld	s1,8(sp)
    80003486:	6902                	ld	s2,0(sp)
    80003488:	6105                	add	sp,sp,32
    8000348a:	8082                	ret

000000008000348c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000348c:	00016797          	auipc	a5,0x16
    80003490:	3c07a783          	lw	a5,960(a5) # 8001984c <log+0x2c>
    80003494:	0af05d63          	blez	a5,8000354e <install_trans+0xc2>
{
    80003498:	7139                	add	sp,sp,-64
    8000349a:	fc06                	sd	ra,56(sp)
    8000349c:	f822                	sd	s0,48(sp)
    8000349e:	f426                	sd	s1,40(sp)
    800034a0:	f04a                	sd	s2,32(sp)
    800034a2:	ec4e                	sd	s3,24(sp)
    800034a4:	e852                	sd	s4,16(sp)
    800034a6:	e456                	sd	s5,8(sp)
    800034a8:	e05a                	sd	s6,0(sp)
    800034aa:	0080                	add	s0,sp,64
    800034ac:	8b2a                	mv	s6,a0
    800034ae:	00016a97          	auipc	s5,0x16
    800034b2:	3a2a8a93          	add	s5,s5,930 # 80019850 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034b6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034b8:	00016997          	auipc	s3,0x16
    800034bc:	36898993          	add	s3,s3,872 # 80019820 <log>
    800034c0:	a00d                	j	800034e2 <install_trans+0x56>
    brelse(lbuf);
    800034c2:	854a                	mv	a0,s2
    800034c4:	fffff097          	auipc	ra,0xfffff
    800034c8:	088080e7          	jalr	136(ra) # 8000254c <brelse>
    brelse(dbuf);
    800034cc:	8526                	mv	a0,s1
    800034ce:	fffff097          	auipc	ra,0xfffff
    800034d2:	07e080e7          	jalr	126(ra) # 8000254c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034d6:	2a05                	addw	s4,s4,1
    800034d8:	0a91                	add	s5,s5,4
    800034da:	02c9a783          	lw	a5,44(s3)
    800034de:	04fa5e63          	bge	s4,a5,8000353a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034e2:	0189a583          	lw	a1,24(s3)
    800034e6:	014585bb          	addw	a1,a1,s4
    800034ea:	2585                	addw	a1,a1,1
    800034ec:	0289a503          	lw	a0,40(s3)
    800034f0:	fffff097          	auipc	ra,0xfffff
    800034f4:	f2c080e7          	jalr	-212(ra) # 8000241c <bread>
    800034f8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034fa:	000aa583          	lw	a1,0(s5)
    800034fe:	0289a503          	lw	a0,40(s3)
    80003502:	fffff097          	auipc	ra,0xfffff
    80003506:	f1a080e7          	jalr	-230(ra) # 8000241c <bread>
    8000350a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000350c:	40000613          	li	a2,1024
    80003510:	05890593          	add	a1,s2,88
    80003514:	05850513          	add	a0,a0,88
    80003518:	ffffd097          	auipc	ra,0xffffd
    8000351c:	cbe080e7          	jalr	-834(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003520:	8526                	mv	a0,s1
    80003522:	fffff097          	auipc	ra,0xfffff
    80003526:	fec080e7          	jalr	-20(ra) # 8000250e <bwrite>
    if(recovering == 0)
    8000352a:	f80b1ce3          	bnez	s6,800034c2 <install_trans+0x36>
      bunpin(dbuf);
    8000352e:	8526                	mv	a0,s1
    80003530:	fffff097          	auipc	ra,0xfffff
    80003534:	0f4080e7          	jalr	244(ra) # 80002624 <bunpin>
    80003538:	b769                	j	800034c2 <install_trans+0x36>
}
    8000353a:	70e2                	ld	ra,56(sp)
    8000353c:	7442                	ld	s0,48(sp)
    8000353e:	74a2                	ld	s1,40(sp)
    80003540:	7902                	ld	s2,32(sp)
    80003542:	69e2                	ld	s3,24(sp)
    80003544:	6a42                	ld	s4,16(sp)
    80003546:	6aa2                	ld	s5,8(sp)
    80003548:	6b02                	ld	s6,0(sp)
    8000354a:	6121                	add	sp,sp,64
    8000354c:	8082                	ret
    8000354e:	8082                	ret

0000000080003550 <initlog>:
{
    80003550:	7179                	add	sp,sp,-48
    80003552:	f406                	sd	ra,40(sp)
    80003554:	f022                	sd	s0,32(sp)
    80003556:	ec26                	sd	s1,24(sp)
    80003558:	e84a                	sd	s2,16(sp)
    8000355a:	e44e                	sd	s3,8(sp)
    8000355c:	1800                	add	s0,sp,48
    8000355e:	892a                	mv	s2,a0
    80003560:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003562:	00016497          	auipc	s1,0x16
    80003566:	2be48493          	add	s1,s1,702 # 80019820 <log>
    8000356a:	00005597          	auipc	a1,0x5
    8000356e:	f3e58593          	add	a1,a1,-194 # 800084a8 <etext+0x4a8>
    80003572:	8526                	mv	a0,s1
    80003574:	00003097          	auipc	ra,0x3
    80003578:	d4e080e7          	jalr	-690(ra) # 800062c2 <initlock>
  log.start = sb->logstart;
    8000357c:	0149a583          	lw	a1,20(s3)
    80003580:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003582:	0109a783          	lw	a5,16(s3)
    80003586:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003588:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000358c:	854a                	mv	a0,s2
    8000358e:	fffff097          	auipc	ra,0xfffff
    80003592:	e8e080e7          	jalr	-370(ra) # 8000241c <bread>
  log.lh.n = lh->n;
    80003596:	4d30                	lw	a2,88(a0)
    80003598:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000359a:	00c05f63          	blez	a2,800035b8 <initlog+0x68>
    8000359e:	87aa                	mv	a5,a0
    800035a0:	00016717          	auipc	a4,0x16
    800035a4:	2b070713          	add	a4,a4,688 # 80019850 <log+0x30>
    800035a8:	060a                	sll	a2,a2,0x2
    800035aa:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800035ac:	4ff4                	lw	a3,92(a5)
    800035ae:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035b0:	0791                	add	a5,a5,4
    800035b2:	0711                	add	a4,a4,4
    800035b4:	fec79ce3          	bne	a5,a2,800035ac <initlog+0x5c>
  brelse(buf);
    800035b8:	fffff097          	auipc	ra,0xfffff
    800035bc:	f94080e7          	jalr	-108(ra) # 8000254c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035c0:	4505                	li	a0,1
    800035c2:	00000097          	auipc	ra,0x0
    800035c6:	eca080e7          	jalr	-310(ra) # 8000348c <install_trans>
  log.lh.n = 0;
    800035ca:	00016797          	auipc	a5,0x16
    800035ce:	2807a123          	sw	zero,642(a5) # 8001984c <log+0x2c>
  write_head(); // clear the log
    800035d2:	00000097          	auipc	ra,0x0
    800035d6:	e50080e7          	jalr	-432(ra) # 80003422 <write_head>
}
    800035da:	70a2                	ld	ra,40(sp)
    800035dc:	7402                	ld	s0,32(sp)
    800035de:	64e2                	ld	s1,24(sp)
    800035e0:	6942                	ld	s2,16(sp)
    800035e2:	69a2                	ld	s3,8(sp)
    800035e4:	6145                	add	sp,sp,48
    800035e6:	8082                	ret

00000000800035e8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035e8:	1101                	add	sp,sp,-32
    800035ea:	ec06                	sd	ra,24(sp)
    800035ec:	e822                	sd	s0,16(sp)
    800035ee:	e426                	sd	s1,8(sp)
    800035f0:	e04a                	sd	s2,0(sp)
    800035f2:	1000                	add	s0,sp,32
  acquire(&log.lock);
    800035f4:	00016517          	auipc	a0,0x16
    800035f8:	22c50513          	add	a0,a0,556 # 80019820 <log>
    800035fc:	00003097          	auipc	ra,0x3
    80003600:	d56080e7          	jalr	-682(ra) # 80006352 <acquire>
  while(1){
    if(log.committing){
    80003604:	00016497          	auipc	s1,0x16
    80003608:	21c48493          	add	s1,s1,540 # 80019820 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000360c:	4979                	li	s2,30
    8000360e:	a039                	j	8000361c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003610:	85a6                	mv	a1,s1
    80003612:	8526                	mv	a0,s1
    80003614:	ffffe097          	auipc	ra,0xffffe
    80003618:	f88080e7          	jalr	-120(ra) # 8000159c <sleep>
    if(log.committing){
    8000361c:	50dc                	lw	a5,36(s1)
    8000361e:	fbed                	bnez	a5,80003610 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003620:	5098                	lw	a4,32(s1)
    80003622:	2705                	addw	a4,a4,1
    80003624:	0027179b          	sllw	a5,a4,0x2
    80003628:	9fb9                	addw	a5,a5,a4
    8000362a:	0017979b          	sllw	a5,a5,0x1
    8000362e:	54d4                	lw	a3,44(s1)
    80003630:	9fb5                	addw	a5,a5,a3
    80003632:	00f95963          	bge	s2,a5,80003644 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003636:	85a6                	mv	a1,s1
    80003638:	8526                	mv	a0,s1
    8000363a:	ffffe097          	auipc	ra,0xffffe
    8000363e:	f62080e7          	jalr	-158(ra) # 8000159c <sleep>
    80003642:	bfe9                	j	8000361c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003644:	00016517          	auipc	a0,0x16
    80003648:	1dc50513          	add	a0,a0,476 # 80019820 <log>
    8000364c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000364e:	00003097          	auipc	ra,0x3
    80003652:	db8080e7          	jalr	-584(ra) # 80006406 <release>
      break;
    }
  }
}
    80003656:	60e2                	ld	ra,24(sp)
    80003658:	6442                	ld	s0,16(sp)
    8000365a:	64a2                	ld	s1,8(sp)
    8000365c:	6902                	ld	s2,0(sp)
    8000365e:	6105                	add	sp,sp,32
    80003660:	8082                	ret

0000000080003662 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003662:	7139                	add	sp,sp,-64
    80003664:	fc06                	sd	ra,56(sp)
    80003666:	f822                	sd	s0,48(sp)
    80003668:	f426                	sd	s1,40(sp)
    8000366a:	f04a                	sd	s2,32(sp)
    8000366c:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000366e:	00016497          	auipc	s1,0x16
    80003672:	1b248493          	add	s1,s1,434 # 80019820 <log>
    80003676:	8526                	mv	a0,s1
    80003678:	00003097          	auipc	ra,0x3
    8000367c:	cda080e7          	jalr	-806(ra) # 80006352 <acquire>
  log.outstanding -= 1;
    80003680:	509c                	lw	a5,32(s1)
    80003682:	37fd                	addw	a5,a5,-1
    80003684:	0007891b          	sext.w	s2,a5
    80003688:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000368a:	50dc                	lw	a5,36(s1)
    8000368c:	e7b9                	bnez	a5,800036da <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000368e:	06091163          	bnez	s2,800036f0 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003692:	00016497          	auipc	s1,0x16
    80003696:	18e48493          	add	s1,s1,398 # 80019820 <log>
    8000369a:	4785                	li	a5,1
    8000369c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000369e:	8526                	mv	a0,s1
    800036a0:	00003097          	auipc	ra,0x3
    800036a4:	d66080e7          	jalr	-666(ra) # 80006406 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036a8:	54dc                	lw	a5,44(s1)
    800036aa:	06f04763          	bgtz	a5,80003718 <end_op+0xb6>
    acquire(&log.lock);
    800036ae:	00016497          	auipc	s1,0x16
    800036b2:	17248493          	add	s1,s1,370 # 80019820 <log>
    800036b6:	8526                	mv	a0,s1
    800036b8:	00003097          	auipc	ra,0x3
    800036bc:	c9a080e7          	jalr	-870(ra) # 80006352 <acquire>
    log.committing = 0;
    800036c0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036c4:	8526                	mv	a0,s1
    800036c6:	ffffe097          	auipc	ra,0xffffe
    800036ca:	062080e7          	jalr	98(ra) # 80001728 <wakeup>
    release(&log.lock);
    800036ce:	8526                	mv	a0,s1
    800036d0:	00003097          	auipc	ra,0x3
    800036d4:	d36080e7          	jalr	-714(ra) # 80006406 <release>
}
    800036d8:	a815                	j	8000370c <end_op+0xaa>
    800036da:	ec4e                	sd	s3,24(sp)
    800036dc:	e852                	sd	s4,16(sp)
    800036de:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800036e0:	00005517          	auipc	a0,0x5
    800036e4:	dd050513          	add	a0,a0,-560 # 800084b0 <etext+0x4b0>
    800036e8:	00002097          	auipc	ra,0x2
    800036ec:	694080e7          	jalr	1684(ra) # 80005d7c <panic>
    wakeup(&log);
    800036f0:	00016497          	auipc	s1,0x16
    800036f4:	13048493          	add	s1,s1,304 # 80019820 <log>
    800036f8:	8526                	mv	a0,s1
    800036fa:	ffffe097          	auipc	ra,0xffffe
    800036fe:	02e080e7          	jalr	46(ra) # 80001728 <wakeup>
  release(&log.lock);
    80003702:	8526                	mv	a0,s1
    80003704:	00003097          	auipc	ra,0x3
    80003708:	d02080e7          	jalr	-766(ra) # 80006406 <release>
}
    8000370c:	70e2                	ld	ra,56(sp)
    8000370e:	7442                	ld	s0,48(sp)
    80003710:	74a2                	ld	s1,40(sp)
    80003712:	7902                	ld	s2,32(sp)
    80003714:	6121                	add	sp,sp,64
    80003716:	8082                	ret
    80003718:	ec4e                	sd	s3,24(sp)
    8000371a:	e852                	sd	s4,16(sp)
    8000371c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000371e:	00016a97          	auipc	s5,0x16
    80003722:	132a8a93          	add	s5,s5,306 # 80019850 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003726:	00016a17          	auipc	s4,0x16
    8000372a:	0faa0a13          	add	s4,s4,250 # 80019820 <log>
    8000372e:	018a2583          	lw	a1,24(s4)
    80003732:	012585bb          	addw	a1,a1,s2
    80003736:	2585                	addw	a1,a1,1
    80003738:	028a2503          	lw	a0,40(s4)
    8000373c:	fffff097          	auipc	ra,0xfffff
    80003740:	ce0080e7          	jalr	-800(ra) # 8000241c <bread>
    80003744:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003746:	000aa583          	lw	a1,0(s5)
    8000374a:	028a2503          	lw	a0,40(s4)
    8000374e:	fffff097          	auipc	ra,0xfffff
    80003752:	cce080e7          	jalr	-818(ra) # 8000241c <bread>
    80003756:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003758:	40000613          	li	a2,1024
    8000375c:	05850593          	add	a1,a0,88
    80003760:	05848513          	add	a0,s1,88
    80003764:	ffffd097          	auipc	ra,0xffffd
    80003768:	a72080e7          	jalr	-1422(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000376c:	8526                	mv	a0,s1
    8000376e:	fffff097          	auipc	ra,0xfffff
    80003772:	da0080e7          	jalr	-608(ra) # 8000250e <bwrite>
    brelse(from);
    80003776:	854e                	mv	a0,s3
    80003778:	fffff097          	auipc	ra,0xfffff
    8000377c:	dd4080e7          	jalr	-556(ra) # 8000254c <brelse>
    brelse(to);
    80003780:	8526                	mv	a0,s1
    80003782:	fffff097          	auipc	ra,0xfffff
    80003786:	dca080e7          	jalr	-566(ra) # 8000254c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000378a:	2905                	addw	s2,s2,1
    8000378c:	0a91                	add	s5,s5,4
    8000378e:	02ca2783          	lw	a5,44(s4)
    80003792:	f8f94ee3          	blt	s2,a5,8000372e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003796:	00000097          	auipc	ra,0x0
    8000379a:	c8c080e7          	jalr	-884(ra) # 80003422 <write_head>
    install_trans(0); // Now install writes to home locations
    8000379e:	4501                	li	a0,0
    800037a0:	00000097          	auipc	ra,0x0
    800037a4:	cec080e7          	jalr	-788(ra) # 8000348c <install_trans>
    log.lh.n = 0;
    800037a8:	00016797          	auipc	a5,0x16
    800037ac:	0a07a223          	sw	zero,164(a5) # 8001984c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037b0:	00000097          	auipc	ra,0x0
    800037b4:	c72080e7          	jalr	-910(ra) # 80003422 <write_head>
    800037b8:	69e2                	ld	s3,24(sp)
    800037ba:	6a42                	ld	s4,16(sp)
    800037bc:	6aa2                	ld	s5,8(sp)
    800037be:	bdc5                	j	800036ae <end_op+0x4c>

00000000800037c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037c0:	1101                	add	sp,sp,-32
    800037c2:	ec06                	sd	ra,24(sp)
    800037c4:	e822                	sd	s0,16(sp)
    800037c6:	e426                	sd	s1,8(sp)
    800037c8:	e04a                	sd	s2,0(sp)
    800037ca:	1000                	add	s0,sp,32
    800037cc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037ce:	00016917          	auipc	s2,0x16
    800037d2:	05290913          	add	s2,s2,82 # 80019820 <log>
    800037d6:	854a                	mv	a0,s2
    800037d8:	00003097          	auipc	ra,0x3
    800037dc:	b7a080e7          	jalr	-1158(ra) # 80006352 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037e0:	02c92603          	lw	a2,44(s2)
    800037e4:	47f5                	li	a5,29
    800037e6:	06c7c563          	blt	a5,a2,80003850 <log_write+0x90>
    800037ea:	00016797          	auipc	a5,0x16
    800037ee:	0527a783          	lw	a5,82(a5) # 8001983c <log+0x1c>
    800037f2:	37fd                	addw	a5,a5,-1
    800037f4:	04f65e63          	bge	a2,a5,80003850 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037f8:	00016797          	auipc	a5,0x16
    800037fc:	0487a783          	lw	a5,72(a5) # 80019840 <log+0x20>
    80003800:	06f05063          	blez	a5,80003860 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003804:	4781                	li	a5,0
    80003806:	06c05563          	blez	a2,80003870 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000380a:	44cc                	lw	a1,12(s1)
    8000380c:	00016717          	auipc	a4,0x16
    80003810:	04470713          	add	a4,a4,68 # 80019850 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003814:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003816:	4314                	lw	a3,0(a4)
    80003818:	04b68c63          	beq	a3,a1,80003870 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000381c:	2785                	addw	a5,a5,1
    8000381e:	0711                	add	a4,a4,4
    80003820:	fef61be3          	bne	a2,a5,80003816 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003824:	0621                	add	a2,a2,8
    80003826:	060a                	sll	a2,a2,0x2
    80003828:	00016797          	auipc	a5,0x16
    8000382c:	ff878793          	add	a5,a5,-8 # 80019820 <log>
    80003830:	97b2                	add	a5,a5,a2
    80003832:	44d8                	lw	a4,12(s1)
    80003834:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003836:	8526                	mv	a0,s1
    80003838:	fffff097          	auipc	ra,0xfffff
    8000383c:	db0080e7          	jalr	-592(ra) # 800025e8 <bpin>
    log.lh.n++;
    80003840:	00016717          	auipc	a4,0x16
    80003844:	fe070713          	add	a4,a4,-32 # 80019820 <log>
    80003848:	575c                	lw	a5,44(a4)
    8000384a:	2785                	addw	a5,a5,1
    8000384c:	d75c                	sw	a5,44(a4)
    8000384e:	a82d                	j	80003888 <log_write+0xc8>
    panic("too big a transaction");
    80003850:	00005517          	auipc	a0,0x5
    80003854:	c7050513          	add	a0,a0,-912 # 800084c0 <etext+0x4c0>
    80003858:	00002097          	auipc	ra,0x2
    8000385c:	524080e7          	jalr	1316(ra) # 80005d7c <panic>
    panic("log_write outside of trans");
    80003860:	00005517          	auipc	a0,0x5
    80003864:	c7850513          	add	a0,a0,-904 # 800084d8 <etext+0x4d8>
    80003868:	00002097          	auipc	ra,0x2
    8000386c:	514080e7          	jalr	1300(ra) # 80005d7c <panic>
  log.lh.block[i] = b->blockno;
    80003870:	00878693          	add	a3,a5,8
    80003874:	068a                	sll	a3,a3,0x2
    80003876:	00016717          	auipc	a4,0x16
    8000387a:	faa70713          	add	a4,a4,-86 # 80019820 <log>
    8000387e:	9736                	add	a4,a4,a3
    80003880:	44d4                	lw	a3,12(s1)
    80003882:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003884:	faf609e3          	beq	a2,a5,80003836 <log_write+0x76>
  }
  release(&log.lock);
    80003888:	00016517          	auipc	a0,0x16
    8000388c:	f9850513          	add	a0,a0,-104 # 80019820 <log>
    80003890:	00003097          	auipc	ra,0x3
    80003894:	b76080e7          	jalr	-1162(ra) # 80006406 <release>
}
    80003898:	60e2                	ld	ra,24(sp)
    8000389a:	6442                	ld	s0,16(sp)
    8000389c:	64a2                	ld	s1,8(sp)
    8000389e:	6902                	ld	s2,0(sp)
    800038a0:	6105                	add	sp,sp,32
    800038a2:	8082                	ret

00000000800038a4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038a4:	1101                	add	sp,sp,-32
    800038a6:	ec06                	sd	ra,24(sp)
    800038a8:	e822                	sd	s0,16(sp)
    800038aa:	e426                	sd	s1,8(sp)
    800038ac:	e04a                	sd	s2,0(sp)
    800038ae:	1000                	add	s0,sp,32
    800038b0:	84aa                	mv	s1,a0
    800038b2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038b4:	00005597          	auipc	a1,0x5
    800038b8:	c4458593          	add	a1,a1,-956 # 800084f8 <etext+0x4f8>
    800038bc:	0521                	add	a0,a0,8
    800038be:	00003097          	auipc	ra,0x3
    800038c2:	a04080e7          	jalr	-1532(ra) # 800062c2 <initlock>
  lk->name = name;
    800038c6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038ca:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038ce:	0204a423          	sw	zero,40(s1)
}
    800038d2:	60e2                	ld	ra,24(sp)
    800038d4:	6442                	ld	s0,16(sp)
    800038d6:	64a2                	ld	s1,8(sp)
    800038d8:	6902                	ld	s2,0(sp)
    800038da:	6105                	add	sp,sp,32
    800038dc:	8082                	ret

00000000800038de <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038de:	1101                	add	sp,sp,-32
    800038e0:	ec06                	sd	ra,24(sp)
    800038e2:	e822                	sd	s0,16(sp)
    800038e4:	e426                	sd	s1,8(sp)
    800038e6:	e04a                	sd	s2,0(sp)
    800038e8:	1000                	add	s0,sp,32
    800038ea:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038ec:	00850913          	add	s2,a0,8
    800038f0:	854a                	mv	a0,s2
    800038f2:	00003097          	auipc	ra,0x3
    800038f6:	a60080e7          	jalr	-1440(ra) # 80006352 <acquire>
  while (lk->locked) {
    800038fa:	409c                	lw	a5,0(s1)
    800038fc:	cb89                	beqz	a5,8000390e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038fe:	85ca                	mv	a1,s2
    80003900:	8526                	mv	a0,s1
    80003902:	ffffe097          	auipc	ra,0xffffe
    80003906:	c9a080e7          	jalr	-870(ra) # 8000159c <sleep>
  while (lk->locked) {
    8000390a:	409c                	lw	a5,0(s1)
    8000390c:	fbed                	bnez	a5,800038fe <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000390e:	4785                	li	a5,1
    80003910:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003912:	ffffd097          	auipc	ra,0xffffd
    80003916:	56a080e7          	jalr	1386(ra) # 80000e7c <myproc>
    8000391a:	591c                	lw	a5,48(a0)
    8000391c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000391e:	854a                	mv	a0,s2
    80003920:	00003097          	auipc	ra,0x3
    80003924:	ae6080e7          	jalr	-1306(ra) # 80006406 <release>
}
    80003928:	60e2                	ld	ra,24(sp)
    8000392a:	6442                	ld	s0,16(sp)
    8000392c:	64a2                	ld	s1,8(sp)
    8000392e:	6902                	ld	s2,0(sp)
    80003930:	6105                	add	sp,sp,32
    80003932:	8082                	ret

0000000080003934 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003934:	1101                	add	sp,sp,-32
    80003936:	ec06                	sd	ra,24(sp)
    80003938:	e822                	sd	s0,16(sp)
    8000393a:	e426                	sd	s1,8(sp)
    8000393c:	e04a                	sd	s2,0(sp)
    8000393e:	1000                	add	s0,sp,32
    80003940:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003942:	00850913          	add	s2,a0,8
    80003946:	854a                	mv	a0,s2
    80003948:	00003097          	auipc	ra,0x3
    8000394c:	a0a080e7          	jalr	-1526(ra) # 80006352 <acquire>
  lk->locked = 0;
    80003950:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003954:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003958:	8526                	mv	a0,s1
    8000395a:	ffffe097          	auipc	ra,0xffffe
    8000395e:	dce080e7          	jalr	-562(ra) # 80001728 <wakeup>
  release(&lk->lk);
    80003962:	854a                	mv	a0,s2
    80003964:	00003097          	auipc	ra,0x3
    80003968:	aa2080e7          	jalr	-1374(ra) # 80006406 <release>
}
    8000396c:	60e2                	ld	ra,24(sp)
    8000396e:	6442                	ld	s0,16(sp)
    80003970:	64a2                	ld	s1,8(sp)
    80003972:	6902                	ld	s2,0(sp)
    80003974:	6105                	add	sp,sp,32
    80003976:	8082                	ret

0000000080003978 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003978:	7179                	add	sp,sp,-48
    8000397a:	f406                	sd	ra,40(sp)
    8000397c:	f022                	sd	s0,32(sp)
    8000397e:	ec26                	sd	s1,24(sp)
    80003980:	e84a                	sd	s2,16(sp)
    80003982:	1800                	add	s0,sp,48
    80003984:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003986:	00850913          	add	s2,a0,8
    8000398a:	854a                	mv	a0,s2
    8000398c:	00003097          	auipc	ra,0x3
    80003990:	9c6080e7          	jalr	-1594(ra) # 80006352 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003994:	409c                	lw	a5,0(s1)
    80003996:	ef91                	bnez	a5,800039b2 <holdingsleep+0x3a>
    80003998:	4481                	li	s1,0
  release(&lk->lk);
    8000399a:	854a                	mv	a0,s2
    8000399c:	00003097          	auipc	ra,0x3
    800039a0:	a6a080e7          	jalr	-1430(ra) # 80006406 <release>
  return r;
}
    800039a4:	8526                	mv	a0,s1
    800039a6:	70a2                	ld	ra,40(sp)
    800039a8:	7402                	ld	s0,32(sp)
    800039aa:	64e2                	ld	s1,24(sp)
    800039ac:	6942                	ld	s2,16(sp)
    800039ae:	6145                	add	sp,sp,48
    800039b0:	8082                	ret
    800039b2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800039b4:	0284a983          	lw	s3,40(s1)
    800039b8:	ffffd097          	auipc	ra,0xffffd
    800039bc:	4c4080e7          	jalr	1220(ra) # 80000e7c <myproc>
    800039c0:	5904                	lw	s1,48(a0)
    800039c2:	413484b3          	sub	s1,s1,s3
    800039c6:	0014b493          	seqz	s1,s1
    800039ca:	69a2                	ld	s3,8(sp)
    800039cc:	b7f9                	j	8000399a <holdingsleep+0x22>

00000000800039ce <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039ce:	1141                	add	sp,sp,-16
    800039d0:	e406                	sd	ra,8(sp)
    800039d2:	e022                	sd	s0,0(sp)
    800039d4:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039d6:	00005597          	auipc	a1,0x5
    800039da:	b3258593          	add	a1,a1,-1230 # 80008508 <etext+0x508>
    800039de:	00016517          	auipc	a0,0x16
    800039e2:	f8a50513          	add	a0,a0,-118 # 80019968 <ftable>
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	8dc080e7          	jalr	-1828(ra) # 800062c2 <initlock>
}
    800039ee:	60a2                	ld	ra,8(sp)
    800039f0:	6402                	ld	s0,0(sp)
    800039f2:	0141                	add	sp,sp,16
    800039f4:	8082                	ret

00000000800039f6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039f6:	1101                	add	sp,sp,-32
    800039f8:	ec06                	sd	ra,24(sp)
    800039fa:	e822                	sd	s0,16(sp)
    800039fc:	e426                	sd	s1,8(sp)
    800039fe:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a00:	00016517          	auipc	a0,0x16
    80003a04:	f6850513          	add	a0,a0,-152 # 80019968 <ftable>
    80003a08:	00003097          	auipc	ra,0x3
    80003a0c:	94a080e7          	jalr	-1718(ra) # 80006352 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a10:	00016497          	auipc	s1,0x16
    80003a14:	f7048493          	add	s1,s1,-144 # 80019980 <ftable+0x18>
    80003a18:	00017717          	auipc	a4,0x17
    80003a1c:	f0870713          	add	a4,a4,-248 # 8001a920 <ftable+0xfb8>
    if(f->ref == 0){
    80003a20:	40dc                	lw	a5,4(s1)
    80003a22:	cf99                	beqz	a5,80003a40 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a24:	02848493          	add	s1,s1,40
    80003a28:	fee49ce3          	bne	s1,a4,80003a20 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a2c:	00016517          	auipc	a0,0x16
    80003a30:	f3c50513          	add	a0,a0,-196 # 80019968 <ftable>
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	9d2080e7          	jalr	-1582(ra) # 80006406 <release>
  return 0;
    80003a3c:	4481                	li	s1,0
    80003a3e:	a819                	j	80003a54 <filealloc+0x5e>
      f->ref = 1;
    80003a40:	4785                	li	a5,1
    80003a42:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a44:	00016517          	auipc	a0,0x16
    80003a48:	f2450513          	add	a0,a0,-220 # 80019968 <ftable>
    80003a4c:	00003097          	auipc	ra,0x3
    80003a50:	9ba080e7          	jalr	-1606(ra) # 80006406 <release>
}
    80003a54:	8526                	mv	a0,s1
    80003a56:	60e2                	ld	ra,24(sp)
    80003a58:	6442                	ld	s0,16(sp)
    80003a5a:	64a2                	ld	s1,8(sp)
    80003a5c:	6105                	add	sp,sp,32
    80003a5e:	8082                	ret

0000000080003a60 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a60:	1101                	add	sp,sp,-32
    80003a62:	ec06                	sd	ra,24(sp)
    80003a64:	e822                	sd	s0,16(sp)
    80003a66:	e426                	sd	s1,8(sp)
    80003a68:	1000                	add	s0,sp,32
    80003a6a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a6c:	00016517          	auipc	a0,0x16
    80003a70:	efc50513          	add	a0,a0,-260 # 80019968 <ftable>
    80003a74:	00003097          	auipc	ra,0x3
    80003a78:	8de080e7          	jalr	-1826(ra) # 80006352 <acquire>
  if(f->ref < 1)
    80003a7c:	40dc                	lw	a5,4(s1)
    80003a7e:	02f05263          	blez	a5,80003aa2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a82:	2785                	addw	a5,a5,1
    80003a84:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a86:	00016517          	auipc	a0,0x16
    80003a8a:	ee250513          	add	a0,a0,-286 # 80019968 <ftable>
    80003a8e:	00003097          	auipc	ra,0x3
    80003a92:	978080e7          	jalr	-1672(ra) # 80006406 <release>
  return f;
}
    80003a96:	8526                	mv	a0,s1
    80003a98:	60e2                	ld	ra,24(sp)
    80003a9a:	6442                	ld	s0,16(sp)
    80003a9c:	64a2                	ld	s1,8(sp)
    80003a9e:	6105                	add	sp,sp,32
    80003aa0:	8082                	ret
    panic("filedup");
    80003aa2:	00005517          	auipc	a0,0x5
    80003aa6:	a6e50513          	add	a0,a0,-1426 # 80008510 <etext+0x510>
    80003aaa:	00002097          	auipc	ra,0x2
    80003aae:	2d2080e7          	jalr	722(ra) # 80005d7c <panic>

0000000080003ab2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ab2:	7139                	add	sp,sp,-64
    80003ab4:	fc06                	sd	ra,56(sp)
    80003ab6:	f822                	sd	s0,48(sp)
    80003ab8:	f426                	sd	s1,40(sp)
    80003aba:	0080                	add	s0,sp,64
    80003abc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003abe:	00016517          	auipc	a0,0x16
    80003ac2:	eaa50513          	add	a0,a0,-342 # 80019968 <ftable>
    80003ac6:	00003097          	auipc	ra,0x3
    80003aca:	88c080e7          	jalr	-1908(ra) # 80006352 <acquire>
  if(f->ref < 1)
    80003ace:	40dc                	lw	a5,4(s1)
    80003ad0:	04f05c63          	blez	a5,80003b28 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003ad4:	37fd                	addw	a5,a5,-1
    80003ad6:	0007871b          	sext.w	a4,a5
    80003ada:	c0dc                	sw	a5,4(s1)
    80003adc:	06e04263          	bgtz	a4,80003b40 <fileclose+0x8e>
    80003ae0:	f04a                	sd	s2,32(sp)
    80003ae2:	ec4e                	sd	s3,24(sp)
    80003ae4:	e852                	sd	s4,16(sp)
    80003ae6:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ae8:	0004a903          	lw	s2,0(s1)
    80003aec:	0094ca83          	lbu	s5,9(s1)
    80003af0:	0104ba03          	ld	s4,16(s1)
    80003af4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003af8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003afc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b00:	00016517          	auipc	a0,0x16
    80003b04:	e6850513          	add	a0,a0,-408 # 80019968 <ftable>
    80003b08:	00003097          	auipc	ra,0x3
    80003b0c:	8fe080e7          	jalr	-1794(ra) # 80006406 <release>

  if(ff.type == FD_PIPE){
    80003b10:	4785                	li	a5,1
    80003b12:	04f90463          	beq	s2,a5,80003b5a <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b16:	3979                	addw	s2,s2,-2
    80003b18:	4785                	li	a5,1
    80003b1a:	0527fb63          	bgeu	a5,s2,80003b70 <fileclose+0xbe>
    80003b1e:	7902                	ld	s2,32(sp)
    80003b20:	69e2                	ld	s3,24(sp)
    80003b22:	6a42                	ld	s4,16(sp)
    80003b24:	6aa2                	ld	s5,8(sp)
    80003b26:	a02d                	j	80003b50 <fileclose+0x9e>
    80003b28:	f04a                	sd	s2,32(sp)
    80003b2a:	ec4e                	sd	s3,24(sp)
    80003b2c:	e852                	sd	s4,16(sp)
    80003b2e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b30:	00005517          	auipc	a0,0x5
    80003b34:	9e850513          	add	a0,a0,-1560 # 80008518 <etext+0x518>
    80003b38:	00002097          	auipc	ra,0x2
    80003b3c:	244080e7          	jalr	580(ra) # 80005d7c <panic>
    release(&ftable.lock);
    80003b40:	00016517          	auipc	a0,0x16
    80003b44:	e2850513          	add	a0,a0,-472 # 80019968 <ftable>
    80003b48:	00003097          	auipc	ra,0x3
    80003b4c:	8be080e7          	jalr	-1858(ra) # 80006406 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b50:	70e2                	ld	ra,56(sp)
    80003b52:	7442                	ld	s0,48(sp)
    80003b54:	74a2                	ld	s1,40(sp)
    80003b56:	6121                	add	sp,sp,64
    80003b58:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b5a:	85d6                	mv	a1,s5
    80003b5c:	8552                	mv	a0,s4
    80003b5e:	00000097          	auipc	ra,0x0
    80003b62:	3a2080e7          	jalr	930(ra) # 80003f00 <pipeclose>
    80003b66:	7902                	ld	s2,32(sp)
    80003b68:	69e2                	ld	s3,24(sp)
    80003b6a:	6a42                	ld	s4,16(sp)
    80003b6c:	6aa2                	ld	s5,8(sp)
    80003b6e:	b7cd                	j	80003b50 <fileclose+0x9e>
    begin_op();
    80003b70:	00000097          	auipc	ra,0x0
    80003b74:	a78080e7          	jalr	-1416(ra) # 800035e8 <begin_op>
    iput(ff.ip);
    80003b78:	854e                	mv	a0,s3
    80003b7a:	fffff097          	auipc	ra,0xfffff
    80003b7e:	25a080e7          	jalr	602(ra) # 80002dd4 <iput>
    end_op();
    80003b82:	00000097          	auipc	ra,0x0
    80003b86:	ae0080e7          	jalr	-1312(ra) # 80003662 <end_op>
    80003b8a:	7902                	ld	s2,32(sp)
    80003b8c:	69e2                	ld	s3,24(sp)
    80003b8e:	6a42                	ld	s4,16(sp)
    80003b90:	6aa2                	ld	s5,8(sp)
    80003b92:	bf7d                	j	80003b50 <fileclose+0x9e>

0000000080003b94 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b94:	715d                	add	sp,sp,-80
    80003b96:	e486                	sd	ra,72(sp)
    80003b98:	e0a2                	sd	s0,64(sp)
    80003b9a:	fc26                	sd	s1,56(sp)
    80003b9c:	f44e                	sd	s3,40(sp)
    80003b9e:	0880                	add	s0,sp,80
    80003ba0:	84aa                	mv	s1,a0
    80003ba2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003ba4:	ffffd097          	auipc	ra,0xffffd
    80003ba8:	2d8080e7          	jalr	728(ra) # 80000e7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bac:	409c                	lw	a5,0(s1)
    80003bae:	37f9                	addw	a5,a5,-2
    80003bb0:	4705                	li	a4,1
    80003bb2:	04f76863          	bltu	a4,a5,80003c02 <filestat+0x6e>
    80003bb6:	f84a                	sd	s2,48(sp)
    80003bb8:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bba:	6c88                	ld	a0,24(s1)
    80003bbc:	fffff097          	auipc	ra,0xfffff
    80003bc0:	05a080e7          	jalr	90(ra) # 80002c16 <ilock>
    stati(f->ip, &st);
    80003bc4:	fb840593          	add	a1,s0,-72
    80003bc8:	6c88                	ld	a0,24(s1)
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	2da080e7          	jalr	730(ra) # 80002ea4 <stati>
    iunlock(f->ip);
    80003bd2:	6c88                	ld	a0,24(s1)
    80003bd4:	fffff097          	auipc	ra,0xfffff
    80003bd8:	108080e7          	jalr	264(ra) # 80002cdc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bdc:	46e1                	li	a3,24
    80003bde:	fb840613          	add	a2,s0,-72
    80003be2:	85ce                	mv	a1,s3
    80003be4:	05093503          	ld	a0,80(s2)
    80003be8:	ffffd097          	auipc	ra,0xffffd
    80003bec:	f30080e7          	jalr	-208(ra) # 80000b18 <copyout>
    80003bf0:	41f5551b          	sraw	a0,a0,0x1f
    80003bf4:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003bf6:	60a6                	ld	ra,72(sp)
    80003bf8:	6406                	ld	s0,64(sp)
    80003bfa:	74e2                	ld	s1,56(sp)
    80003bfc:	79a2                	ld	s3,40(sp)
    80003bfe:	6161                	add	sp,sp,80
    80003c00:	8082                	ret
  return -1;
    80003c02:	557d                	li	a0,-1
    80003c04:	bfcd                	j	80003bf6 <filestat+0x62>

0000000080003c06 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c06:	7179                	add	sp,sp,-48
    80003c08:	f406                	sd	ra,40(sp)
    80003c0a:	f022                	sd	s0,32(sp)
    80003c0c:	e84a                	sd	s2,16(sp)
    80003c0e:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c10:	00854783          	lbu	a5,8(a0)
    80003c14:	cbc5                	beqz	a5,80003cc4 <fileread+0xbe>
    80003c16:	ec26                	sd	s1,24(sp)
    80003c18:	e44e                	sd	s3,8(sp)
    80003c1a:	84aa                	mv	s1,a0
    80003c1c:	89ae                	mv	s3,a1
    80003c1e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c20:	411c                	lw	a5,0(a0)
    80003c22:	4705                	li	a4,1
    80003c24:	04e78963          	beq	a5,a4,80003c76 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c28:	470d                	li	a4,3
    80003c2a:	04e78f63          	beq	a5,a4,80003c88 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c2e:	4709                	li	a4,2
    80003c30:	08e79263          	bne	a5,a4,80003cb4 <fileread+0xae>
    ilock(f->ip);
    80003c34:	6d08                	ld	a0,24(a0)
    80003c36:	fffff097          	auipc	ra,0xfffff
    80003c3a:	fe0080e7          	jalr	-32(ra) # 80002c16 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c3e:	874a                	mv	a4,s2
    80003c40:	5094                	lw	a3,32(s1)
    80003c42:	864e                	mv	a2,s3
    80003c44:	4585                	li	a1,1
    80003c46:	6c88                	ld	a0,24(s1)
    80003c48:	fffff097          	auipc	ra,0xfffff
    80003c4c:	286080e7          	jalr	646(ra) # 80002ece <readi>
    80003c50:	892a                	mv	s2,a0
    80003c52:	00a05563          	blez	a0,80003c5c <fileread+0x56>
      f->off += r;
    80003c56:	509c                	lw	a5,32(s1)
    80003c58:	9fa9                	addw	a5,a5,a0
    80003c5a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c5c:	6c88                	ld	a0,24(s1)
    80003c5e:	fffff097          	auipc	ra,0xfffff
    80003c62:	07e080e7          	jalr	126(ra) # 80002cdc <iunlock>
    80003c66:	64e2                	ld	s1,24(sp)
    80003c68:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c6a:	854a                	mv	a0,s2
    80003c6c:	70a2                	ld	ra,40(sp)
    80003c6e:	7402                	ld	s0,32(sp)
    80003c70:	6942                	ld	s2,16(sp)
    80003c72:	6145                	add	sp,sp,48
    80003c74:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c76:	6908                	ld	a0,16(a0)
    80003c78:	00000097          	auipc	ra,0x0
    80003c7c:	3fa080e7          	jalr	1018(ra) # 80004072 <piperead>
    80003c80:	892a                	mv	s2,a0
    80003c82:	64e2                	ld	s1,24(sp)
    80003c84:	69a2                	ld	s3,8(sp)
    80003c86:	b7d5                	j	80003c6a <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c88:	02451783          	lh	a5,36(a0)
    80003c8c:	03079693          	sll	a3,a5,0x30
    80003c90:	92c1                	srl	a3,a3,0x30
    80003c92:	4725                	li	a4,9
    80003c94:	02d76a63          	bltu	a4,a3,80003cc8 <fileread+0xc2>
    80003c98:	0792                	sll	a5,a5,0x4
    80003c9a:	00016717          	auipc	a4,0x16
    80003c9e:	c2e70713          	add	a4,a4,-978 # 800198c8 <devsw>
    80003ca2:	97ba                	add	a5,a5,a4
    80003ca4:	639c                	ld	a5,0(a5)
    80003ca6:	c78d                	beqz	a5,80003cd0 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003ca8:	4505                	li	a0,1
    80003caa:	9782                	jalr	a5
    80003cac:	892a                	mv	s2,a0
    80003cae:	64e2                	ld	s1,24(sp)
    80003cb0:	69a2                	ld	s3,8(sp)
    80003cb2:	bf65                	j	80003c6a <fileread+0x64>
    panic("fileread");
    80003cb4:	00005517          	auipc	a0,0x5
    80003cb8:	87450513          	add	a0,a0,-1932 # 80008528 <etext+0x528>
    80003cbc:	00002097          	auipc	ra,0x2
    80003cc0:	0c0080e7          	jalr	192(ra) # 80005d7c <panic>
    return -1;
    80003cc4:	597d                	li	s2,-1
    80003cc6:	b755                	j	80003c6a <fileread+0x64>
      return -1;
    80003cc8:	597d                	li	s2,-1
    80003cca:	64e2                	ld	s1,24(sp)
    80003ccc:	69a2                	ld	s3,8(sp)
    80003cce:	bf71                	j	80003c6a <fileread+0x64>
    80003cd0:	597d                	li	s2,-1
    80003cd2:	64e2                	ld	s1,24(sp)
    80003cd4:	69a2                	ld	s3,8(sp)
    80003cd6:	bf51                	j	80003c6a <fileread+0x64>

0000000080003cd8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003cd8:	00954783          	lbu	a5,9(a0)
    80003cdc:	12078963          	beqz	a5,80003e0e <filewrite+0x136>
{
    80003ce0:	715d                	add	sp,sp,-80
    80003ce2:	e486                	sd	ra,72(sp)
    80003ce4:	e0a2                	sd	s0,64(sp)
    80003ce6:	f84a                	sd	s2,48(sp)
    80003ce8:	f052                	sd	s4,32(sp)
    80003cea:	e85a                	sd	s6,16(sp)
    80003cec:	0880                	add	s0,sp,80
    80003cee:	892a                	mv	s2,a0
    80003cf0:	8b2e                	mv	s6,a1
    80003cf2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cf4:	411c                	lw	a5,0(a0)
    80003cf6:	4705                	li	a4,1
    80003cf8:	02e78763          	beq	a5,a4,80003d26 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cfc:	470d                	li	a4,3
    80003cfe:	02e78a63          	beq	a5,a4,80003d32 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d02:	4709                	li	a4,2
    80003d04:	0ee79863          	bne	a5,a4,80003df4 <filewrite+0x11c>
    80003d08:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d0a:	0cc05463          	blez	a2,80003dd2 <filewrite+0xfa>
    80003d0e:	fc26                	sd	s1,56(sp)
    80003d10:	ec56                	sd	s5,24(sp)
    80003d12:	e45e                	sd	s7,8(sp)
    80003d14:	e062                	sd	s8,0(sp)
    int i = 0;
    80003d16:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d18:	6b85                	lui	s7,0x1
    80003d1a:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d1e:	6c05                	lui	s8,0x1
    80003d20:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d24:	a851                	j	80003db8 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d26:	6908                	ld	a0,16(a0)
    80003d28:	00000097          	auipc	ra,0x0
    80003d2c:	248080e7          	jalr	584(ra) # 80003f70 <pipewrite>
    80003d30:	a85d                	j	80003de6 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d32:	02451783          	lh	a5,36(a0)
    80003d36:	03079693          	sll	a3,a5,0x30
    80003d3a:	92c1                	srl	a3,a3,0x30
    80003d3c:	4725                	li	a4,9
    80003d3e:	0cd76a63          	bltu	a4,a3,80003e12 <filewrite+0x13a>
    80003d42:	0792                	sll	a5,a5,0x4
    80003d44:	00016717          	auipc	a4,0x16
    80003d48:	b8470713          	add	a4,a4,-1148 # 800198c8 <devsw>
    80003d4c:	97ba                	add	a5,a5,a4
    80003d4e:	679c                	ld	a5,8(a5)
    80003d50:	c3f9                	beqz	a5,80003e16 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003d52:	4505                	li	a0,1
    80003d54:	9782                	jalr	a5
    80003d56:	a841                	j	80003de6 <filewrite+0x10e>
      if(n1 > max)
    80003d58:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	88c080e7          	jalr	-1908(ra) # 800035e8 <begin_op>
      ilock(f->ip);
    80003d64:	01893503          	ld	a0,24(s2)
    80003d68:	fffff097          	auipc	ra,0xfffff
    80003d6c:	eae080e7          	jalr	-338(ra) # 80002c16 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d70:	8756                	mv	a4,s5
    80003d72:	02092683          	lw	a3,32(s2)
    80003d76:	01698633          	add	a2,s3,s6
    80003d7a:	4585                	li	a1,1
    80003d7c:	01893503          	ld	a0,24(s2)
    80003d80:	fffff097          	auipc	ra,0xfffff
    80003d84:	252080e7          	jalr	594(ra) # 80002fd2 <writei>
    80003d88:	84aa                	mv	s1,a0
    80003d8a:	00a05763          	blez	a0,80003d98 <filewrite+0xc0>
        f->off += r;
    80003d8e:	02092783          	lw	a5,32(s2)
    80003d92:	9fa9                	addw	a5,a5,a0
    80003d94:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d98:	01893503          	ld	a0,24(s2)
    80003d9c:	fffff097          	auipc	ra,0xfffff
    80003da0:	f40080e7          	jalr	-192(ra) # 80002cdc <iunlock>
      end_op();
    80003da4:	00000097          	auipc	ra,0x0
    80003da8:	8be080e7          	jalr	-1858(ra) # 80003662 <end_op>

      if(r != n1){
    80003dac:	029a9563          	bne	s5,s1,80003dd6 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003db0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003db4:	0149da63          	bge	s3,s4,80003dc8 <filewrite+0xf0>
      int n1 = n - i;
    80003db8:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003dbc:	0004879b          	sext.w	a5,s1
    80003dc0:	f8fbdce3          	bge	s7,a5,80003d58 <filewrite+0x80>
    80003dc4:	84e2                	mv	s1,s8
    80003dc6:	bf49                	j	80003d58 <filewrite+0x80>
    80003dc8:	74e2                	ld	s1,56(sp)
    80003dca:	6ae2                	ld	s5,24(sp)
    80003dcc:	6ba2                	ld	s7,8(sp)
    80003dce:	6c02                	ld	s8,0(sp)
    80003dd0:	a039                	j	80003dde <filewrite+0x106>
    int i = 0;
    80003dd2:	4981                	li	s3,0
    80003dd4:	a029                	j	80003dde <filewrite+0x106>
    80003dd6:	74e2                	ld	s1,56(sp)
    80003dd8:	6ae2                	ld	s5,24(sp)
    80003dda:	6ba2                	ld	s7,8(sp)
    80003ddc:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003dde:	033a1e63          	bne	s4,s3,80003e1a <filewrite+0x142>
    80003de2:	8552                	mv	a0,s4
    80003de4:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003de6:	60a6                	ld	ra,72(sp)
    80003de8:	6406                	ld	s0,64(sp)
    80003dea:	7942                	ld	s2,48(sp)
    80003dec:	7a02                	ld	s4,32(sp)
    80003dee:	6b42                	ld	s6,16(sp)
    80003df0:	6161                	add	sp,sp,80
    80003df2:	8082                	ret
    80003df4:	fc26                	sd	s1,56(sp)
    80003df6:	f44e                	sd	s3,40(sp)
    80003df8:	ec56                	sd	s5,24(sp)
    80003dfa:	e45e                	sd	s7,8(sp)
    80003dfc:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003dfe:	00004517          	auipc	a0,0x4
    80003e02:	73a50513          	add	a0,a0,1850 # 80008538 <etext+0x538>
    80003e06:	00002097          	auipc	ra,0x2
    80003e0a:	f76080e7          	jalr	-138(ra) # 80005d7c <panic>
    return -1;
    80003e0e:	557d                	li	a0,-1
}
    80003e10:	8082                	ret
      return -1;
    80003e12:	557d                	li	a0,-1
    80003e14:	bfc9                	j	80003de6 <filewrite+0x10e>
    80003e16:	557d                	li	a0,-1
    80003e18:	b7f9                	j	80003de6 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e1a:	557d                	li	a0,-1
    80003e1c:	79a2                	ld	s3,40(sp)
    80003e1e:	b7e1                	j	80003de6 <filewrite+0x10e>

0000000080003e20 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e20:	7179                	add	sp,sp,-48
    80003e22:	f406                	sd	ra,40(sp)
    80003e24:	f022                	sd	s0,32(sp)
    80003e26:	ec26                	sd	s1,24(sp)
    80003e28:	e052                	sd	s4,0(sp)
    80003e2a:	1800                	add	s0,sp,48
    80003e2c:	84aa                	mv	s1,a0
    80003e2e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e30:	0005b023          	sd	zero,0(a1)
    80003e34:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e38:	00000097          	auipc	ra,0x0
    80003e3c:	bbe080e7          	jalr	-1090(ra) # 800039f6 <filealloc>
    80003e40:	e088                	sd	a0,0(s1)
    80003e42:	cd49                	beqz	a0,80003edc <pipealloc+0xbc>
    80003e44:	00000097          	auipc	ra,0x0
    80003e48:	bb2080e7          	jalr	-1102(ra) # 800039f6 <filealloc>
    80003e4c:	00aa3023          	sd	a0,0(s4)
    80003e50:	c141                	beqz	a0,80003ed0 <pipealloc+0xb0>
    80003e52:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e54:	ffffc097          	auipc	ra,0xffffc
    80003e58:	2c6080e7          	jalr	710(ra) # 8000011a <kalloc>
    80003e5c:	892a                	mv	s2,a0
    80003e5e:	c13d                	beqz	a0,80003ec4 <pipealloc+0xa4>
    80003e60:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e62:	4985                	li	s3,1
    80003e64:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e68:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e6c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e70:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e74:	00004597          	auipc	a1,0x4
    80003e78:	6d458593          	add	a1,a1,1748 # 80008548 <etext+0x548>
    80003e7c:	00002097          	auipc	ra,0x2
    80003e80:	446080e7          	jalr	1094(ra) # 800062c2 <initlock>
  (*f0)->type = FD_PIPE;
    80003e84:	609c                	ld	a5,0(s1)
    80003e86:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e8a:	609c                	ld	a5,0(s1)
    80003e8c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e90:	609c                	ld	a5,0(s1)
    80003e92:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e96:	609c                	ld	a5,0(s1)
    80003e98:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e9c:	000a3783          	ld	a5,0(s4)
    80003ea0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ea4:	000a3783          	ld	a5,0(s4)
    80003ea8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eac:	000a3783          	ld	a5,0(s4)
    80003eb0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003eb4:	000a3783          	ld	a5,0(s4)
    80003eb8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ebc:	4501                	li	a0,0
    80003ebe:	6942                	ld	s2,16(sp)
    80003ec0:	69a2                	ld	s3,8(sp)
    80003ec2:	a03d                	j	80003ef0 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ec4:	6088                	ld	a0,0(s1)
    80003ec6:	c119                	beqz	a0,80003ecc <pipealloc+0xac>
    80003ec8:	6942                	ld	s2,16(sp)
    80003eca:	a029                	j	80003ed4 <pipealloc+0xb4>
    80003ecc:	6942                	ld	s2,16(sp)
    80003ece:	a039                	j	80003edc <pipealloc+0xbc>
    80003ed0:	6088                	ld	a0,0(s1)
    80003ed2:	c50d                	beqz	a0,80003efc <pipealloc+0xdc>
    fileclose(*f0);
    80003ed4:	00000097          	auipc	ra,0x0
    80003ed8:	bde080e7          	jalr	-1058(ra) # 80003ab2 <fileclose>
  if(*f1)
    80003edc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ee0:	557d                	li	a0,-1
  if(*f1)
    80003ee2:	c799                	beqz	a5,80003ef0 <pipealloc+0xd0>
    fileclose(*f1);
    80003ee4:	853e                	mv	a0,a5
    80003ee6:	00000097          	auipc	ra,0x0
    80003eea:	bcc080e7          	jalr	-1076(ra) # 80003ab2 <fileclose>
  return -1;
    80003eee:	557d                	li	a0,-1
}
    80003ef0:	70a2                	ld	ra,40(sp)
    80003ef2:	7402                	ld	s0,32(sp)
    80003ef4:	64e2                	ld	s1,24(sp)
    80003ef6:	6a02                	ld	s4,0(sp)
    80003ef8:	6145                	add	sp,sp,48
    80003efa:	8082                	ret
  return -1;
    80003efc:	557d                	li	a0,-1
    80003efe:	bfcd                	j	80003ef0 <pipealloc+0xd0>

0000000080003f00 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f00:	1101                	add	sp,sp,-32
    80003f02:	ec06                	sd	ra,24(sp)
    80003f04:	e822                	sd	s0,16(sp)
    80003f06:	e426                	sd	s1,8(sp)
    80003f08:	e04a                	sd	s2,0(sp)
    80003f0a:	1000                	add	s0,sp,32
    80003f0c:	84aa                	mv	s1,a0
    80003f0e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f10:	00002097          	auipc	ra,0x2
    80003f14:	442080e7          	jalr	1090(ra) # 80006352 <acquire>
  if(writable){
    80003f18:	02090d63          	beqz	s2,80003f52 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f1c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f20:	21848513          	add	a0,s1,536
    80003f24:	ffffe097          	auipc	ra,0xffffe
    80003f28:	804080e7          	jalr	-2044(ra) # 80001728 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f2c:	2204b783          	ld	a5,544(s1)
    80003f30:	eb95                	bnez	a5,80003f64 <pipeclose+0x64>
    release(&pi->lock);
    80003f32:	8526                	mv	a0,s1
    80003f34:	00002097          	auipc	ra,0x2
    80003f38:	4d2080e7          	jalr	1234(ra) # 80006406 <release>
    kfree((char*)pi);
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	ffffc097          	auipc	ra,0xffffc
    80003f42:	0de080e7          	jalr	222(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f46:	60e2                	ld	ra,24(sp)
    80003f48:	6442                	ld	s0,16(sp)
    80003f4a:	64a2                	ld	s1,8(sp)
    80003f4c:	6902                	ld	s2,0(sp)
    80003f4e:	6105                	add	sp,sp,32
    80003f50:	8082                	ret
    pi->readopen = 0;
    80003f52:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f56:	21c48513          	add	a0,s1,540
    80003f5a:	ffffd097          	auipc	ra,0xffffd
    80003f5e:	7ce080e7          	jalr	1998(ra) # 80001728 <wakeup>
    80003f62:	b7e9                	j	80003f2c <pipeclose+0x2c>
    release(&pi->lock);
    80003f64:	8526                	mv	a0,s1
    80003f66:	00002097          	auipc	ra,0x2
    80003f6a:	4a0080e7          	jalr	1184(ra) # 80006406 <release>
}
    80003f6e:	bfe1                	j	80003f46 <pipeclose+0x46>

0000000080003f70 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f70:	711d                	add	sp,sp,-96
    80003f72:	ec86                	sd	ra,88(sp)
    80003f74:	e8a2                	sd	s0,80(sp)
    80003f76:	e4a6                	sd	s1,72(sp)
    80003f78:	e0ca                	sd	s2,64(sp)
    80003f7a:	fc4e                	sd	s3,56(sp)
    80003f7c:	f852                	sd	s4,48(sp)
    80003f7e:	f456                	sd	s5,40(sp)
    80003f80:	1080                	add	s0,sp,96
    80003f82:	84aa                	mv	s1,a0
    80003f84:	8aae                	mv	s5,a1
    80003f86:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	ef4080e7          	jalr	-268(ra) # 80000e7c <myproc>
    80003f90:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f92:	8526                	mv	a0,s1
    80003f94:	00002097          	auipc	ra,0x2
    80003f98:	3be080e7          	jalr	958(ra) # 80006352 <acquire>
  while(i < n){
    80003f9c:	0d405563          	blez	s4,80004066 <pipewrite+0xf6>
    80003fa0:	f05a                	sd	s6,32(sp)
    80003fa2:	ec5e                	sd	s7,24(sp)
    80003fa4:	e862                	sd	s8,16(sp)
  int i = 0;
    80003fa6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fa8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003faa:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fae:	21c48b93          	add	s7,s1,540
    80003fb2:	a089                	j	80003ff4 <pipewrite+0x84>
      release(&pi->lock);
    80003fb4:	8526                	mv	a0,s1
    80003fb6:	00002097          	auipc	ra,0x2
    80003fba:	450080e7          	jalr	1104(ra) # 80006406 <release>
      return -1;
    80003fbe:	597d                	li	s2,-1
    80003fc0:	7b02                	ld	s6,32(sp)
    80003fc2:	6be2                	ld	s7,24(sp)
    80003fc4:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fc6:	854a                	mv	a0,s2
    80003fc8:	60e6                	ld	ra,88(sp)
    80003fca:	6446                	ld	s0,80(sp)
    80003fcc:	64a6                	ld	s1,72(sp)
    80003fce:	6906                	ld	s2,64(sp)
    80003fd0:	79e2                	ld	s3,56(sp)
    80003fd2:	7a42                	ld	s4,48(sp)
    80003fd4:	7aa2                	ld	s5,40(sp)
    80003fd6:	6125                	add	sp,sp,96
    80003fd8:	8082                	ret
      wakeup(&pi->nread);
    80003fda:	8562                	mv	a0,s8
    80003fdc:	ffffd097          	auipc	ra,0xffffd
    80003fe0:	74c080e7          	jalr	1868(ra) # 80001728 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fe4:	85a6                	mv	a1,s1
    80003fe6:	855e                	mv	a0,s7
    80003fe8:	ffffd097          	auipc	ra,0xffffd
    80003fec:	5b4080e7          	jalr	1460(ra) # 8000159c <sleep>
  while(i < n){
    80003ff0:	05495c63          	bge	s2,s4,80004048 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80003ff4:	2204a783          	lw	a5,544(s1)
    80003ff8:	dfd5                	beqz	a5,80003fb4 <pipewrite+0x44>
    80003ffa:	0289a783          	lw	a5,40(s3)
    80003ffe:	fbdd                	bnez	a5,80003fb4 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004000:	2184a783          	lw	a5,536(s1)
    80004004:	21c4a703          	lw	a4,540(s1)
    80004008:	2007879b          	addw	a5,a5,512
    8000400c:	fcf707e3          	beq	a4,a5,80003fda <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004010:	4685                	li	a3,1
    80004012:	01590633          	add	a2,s2,s5
    80004016:	faf40593          	add	a1,s0,-81
    8000401a:	0509b503          	ld	a0,80(s3)
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	b86080e7          	jalr	-1146(ra) # 80000ba4 <copyin>
    80004026:	05650263          	beq	a0,s6,8000406a <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000402a:	21c4a783          	lw	a5,540(s1)
    8000402e:	0017871b          	addw	a4,a5,1
    80004032:	20e4ae23          	sw	a4,540(s1)
    80004036:	1ff7f793          	and	a5,a5,511
    8000403a:	97a6                	add	a5,a5,s1
    8000403c:	faf44703          	lbu	a4,-81(s0)
    80004040:	00e78c23          	sb	a4,24(a5)
      i++;
    80004044:	2905                	addw	s2,s2,1
    80004046:	b76d                	j	80003ff0 <pipewrite+0x80>
    80004048:	7b02                	ld	s6,32(sp)
    8000404a:	6be2                	ld	s7,24(sp)
    8000404c:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000404e:	21848513          	add	a0,s1,536
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	6d6080e7          	jalr	1750(ra) # 80001728 <wakeup>
  release(&pi->lock);
    8000405a:	8526                	mv	a0,s1
    8000405c:	00002097          	auipc	ra,0x2
    80004060:	3aa080e7          	jalr	938(ra) # 80006406 <release>
  return i;
    80004064:	b78d                	j	80003fc6 <pipewrite+0x56>
  int i = 0;
    80004066:	4901                	li	s2,0
    80004068:	b7dd                	j	8000404e <pipewrite+0xde>
    8000406a:	7b02                	ld	s6,32(sp)
    8000406c:	6be2                	ld	s7,24(sp)
    8000406e:	6c42                	ld	s8,16(sp)
    80004070:	bff9                	j	8000404e <pipewrite+0xde>

0000000080004072 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004072:	715d                	add	sp,sp,-80
    80004074:	e486                	sd	ra,72(sp)
    80004076:	e0a2                	sd	s0,64(sp)
    80004078:	fc26                	sd	s1,56(sp)
    8000407a:	f84a                	sd	s2,48(sp)
    8000407c:	f44e                	sd	s3,40(sp)
    8000407e:	f052                	sd	s4,32(sp)
    80004080:	ec56                	sd	s5,24(sp)
    80004082:	0880                	add	s0,sp,80
    80004084:	84aa                	mv	s1,a0
    80004086:	892e                	mv	s2,a1
    80004088:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000408a:	ffffd097          	auipc	ra,0xffffd
    8000408e:	df2080e7          	jalr	-526(ra) # 80000e7c <myproc>
    80004092:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004094:	8526                	mv	a0,s1
    80004096:	00002097          	auipc	ra,0x2
    8000409a:	2bc080e7          	jalr	700(ra) # 80006352 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000409e:	2184a703          	lw	a4,536(s1)
    800040a2:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040a6:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040aa:	02f71663          	bne	a4,a5,800040d6 <piperead+0x64>
    800040ae:	2244a783          	lw	a5,548(s1)
    800040b2:	cb9d                	beqz	a5,800040e8 <piperead+0x76>
    if(pr->killed){
    800040b4:	028a2783          	lw	a5,40(s4)
    800040b8:	e38d                	bnez	a5,800040da <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040ba:	85a6                	mv	a1,s1
    800040bc:	854e                	mv	a0,s3
    800040be:	ffffd097          	auipc	ra,0xffffd
    800040c2:	4de080e7          	jalr	1246(ra) # 8000159c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040c6:	2184a703          	lw	a4,536(s1)
    800040ca:	21c4a783          	lw	a5,540(s1)
    800040ce:	fef700e3          	beq	a4,a5,800040ae <piperead+0x3c>
    800040d2:	e85a                	sd	s6,16(sp)
    800040d4:	a819                	j	800040ea <piperead+0x78>
    800040d6:	e85a                	sd	s6,16(sp)
    800040d8:	a809                	j	800040ea <piperead+0x78>
      release(&pi->lock);
    800040da:	8526                	mv	a0,s1
    800040dc:	00002097          	auipc	ra,0x2
    800040e0:	32a080e7          	jalr	810(ra) # 80006406 <release>
      return -1;
    800040e4:	59fd                	li	s3,-1
    800040e6:	a0a5                	j	8000414e <piperead+0xdc>
    800040e8:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ea:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040ec:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ee:	05505463          	blez	s5,80004136 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    800040f2:	2184a783          	lw	a5,536(s1)
    800040f6:	21c4a703          	lw	a4,540(s1)
    800040fa:	02f70e63          	beq	a4,a5,80004136 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040fe:	0017871b          	addw	a4,a5,1
    80004102:	20e4ac23          	sw	a4,536(s1)
    80004106:	1ff7f793          	and	a5,a5,511
    8000410a:	97a6                	add	a5,a5,s1
    8000410c:	0187c783          	lbu	a5,24(a5)
    80004110:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004114:	4685                	li	a3,1
    80004116:	fbf40613          	add	a2,s0,-65
    8000411a:	85ca                	mv	a1,s2
    8000411c:	050a3503          	ld	a0,80(s4)
    80004120:	ffffd097          	auipc	ra,0xffffd
    80004124:	9f8080e7          	jalr	-1544(ra) # 80000b18 <copyout>
    80004128:	01650763          	beq	a0,s6,80004136 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000412c:	2985                	addw	s3,s3,1
    8000412e:	0905                	add	s2,s2,1
    80004130:	fd3a91e3          	bne	s5,s3,800040f2 <piperead+0x80>
    80004134:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004136:	21c48513          	add	a0,s1,540
    8000413a:	ffffd097          	auipc	ra,0xffffd
    8000413e:	5ee080e7          	jalr	1518(ra) # 80001728 <wakeup>
  release(&pi->lock);
    80004142:	8526                	mv	a0,s1
    80004144:	00002097          	auipc	ra,0x2
    80004148:	2c2080e7          	jalr	706(ra) # 80006406 <release>
    8000414c:	6b42                	ld	s6,16(sp)
  return i;
}
    8000414e:	854e                	mv	a0,s3
    80004150:	60a6                	ld	ra,72(sp)
    80004152:	6406                	ld	s0,64(sp)
    80004154:	74e2                	ld	s1,56(sp)
    80004156:	7942                	ld	s2,48(sp)
    80004158:	79a2                	ld	s3,40(sp)
    8000415a:	7a02                	ld	s4,32(sp)
    8000415c:	6ae2                	ld	s5,24(sp)
    8000415e:	6161                	add	sp,sp,80
    80004160:	8082                	ret

0000000080004162 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004162:	df010113          	add	sp,sp,-528
    80004166:	20113423          	sd	ra,520(sp)
    8000416a:	20813023          	sd	s0,512(sp)
    8000416e:	ffa6                	sd	s1,504(sp)
    80004170:	fbca                	sd	s2,496(sp)
    80004172:	0c00                	add	s0,sp,528
    80004174:	892a                	mv	s2,a0
    80004176:	dea43c23          	sd	a0,-520(s0)
    8000417a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000417e:	ffffd097          	auipc	ra,0xffffd
    80004182:	cfe080e7          	jalr	-770(ra) # 80000e7c <myproc>
    80004186:	84aa                	mv	s1,a0

  begin_op();
    80004188:	fffff097          	auipc	ra,0xfffff
    8000418c:	460080e7          	jalr	1120(ra) # 800035e8 <begin_op>

  if((ip = namei(path)) == 0){
    80004190:	854a                	mv	a0,s2
    80004192:	fffff097          	auipc	ra,0xfffff
    80004196:	256080e7          	jalr	598(ra) # 800033e8 <namei>
    8000419a:	c135                	beqz	a0,800041fe <exec+0x9c>
    8000419c:	f3d2                	sd	s4,480(sp)
    8000419e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041a0:	fffff097          	auipc	ra,0xfffff
    800041a4:	a76080e7          	jalr	-1418(ra) # 80002c16 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041a8:	04000713          	li	a4,64
    800041ac:	4681                	li	a3,0
    800041ae:	e5040613          	add	a2,s0,-432
    800041b2:	4581                	li	a1,0
    800041b4:	8552                	mv	a0,s4
    800041b6:	fffff097          	auipc	ra,0xfffff
    800041ba:	d18080e7          	jalr	-744(ra) # 80002ece <readi>
    800041be:	04000793          	li	a5,64
    800041c2:	00f51a63          	bne	a0,a5,800041d6 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041c6:	e5042703          	lw	a4,-432(s0)
    800041ca:	464c47b7          	lui	a5,0x464c4
    800041ce:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041d2:	02f70c63          	beq	a4,a5,8000420a <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041d6:	8552                	mv	a0,s4
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	ca4080e7          	jalr	-860(ra) # 80002e7c <iunlockput>
    end_op();
    800041e0:	fffff097          	auipc	ra,0xfffff
    800041e4:	482080e7          	jalr	1154(ra) # 80003662 <end_op>
  }
  return -1;
    800041e8:	557d                	li	a0,-1
    800041ea:	7a1e                	ld	s4,480(sp)
}
    800041ec:	20813083          	ld	ra,520(sp)
    800041f0:	20013403          	ld	s0,512(sp)
    800041f4:	74fe                	ld	s1,504(sp)
    800041f6:	795e                	ld	s2,496(sp)
    800041f8:	21010113          	add	sp,sp,528
    800041fc:	8082                	ret
    end_op();
    800041fe:	fffff097          	auipc	ra,0xfffff
    80004202:	464080e7          	jalr	1124(ra) # 80003662 <end_op>
    return -1;
    80004206:	557d                	li	a0,-1
    80004208:	b7d5                	j	800041ec <exec+0x8a>
    8000420a:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000420c:	8526                	mv	a0,s1
    8000420e:	ffffd097          	auipc	ra,0xffffd
    80004212:	d32080e7          	jalr	-718(ra) # 80000f40 <proc_pagetable>
    80004216:	8b2a                	mv	s6,a0
    80004218:	30050563          	beqz	a0,80004522 <exec+0x3c0>
    8000421c:	f7ce                	sd	s3,488(sp)
    8000421e:	efd6                	sd	s5,472(sp)
    80004220:	e7de                	sd	s7,456(sp)
    80004222:	e3e2                	sd	s8,448(sp)
    80004224:	ff66                	sd	s9,440(sp)
    80004226:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004228:	e7042d03          	lw	s10,-400(s0)
    8000422c:	e8845783          	lhu	a5,-376(s0)
    80004230:	14078563          	beqz	a5,8000437a <exec+0x218>
    80004234:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004236:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004238:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    8000423a:	6c85                	lui	s9,0x1
    8000423c:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004240:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004244:	6a85                	lui	s5,0x1
    80004246:	a0b5                	j	800042b2 <exec+0x150>
      panic("loadseg: address should exist");
    80004248:	00004517          	auipc	a0,0x4
    8000424c:	30850513          	add	a0,a0,776 # 80008550 <etext+0x550>
    80004250:	00002097          	auipc	ra,0x2
    80004254:	b2c080e7          	jalr	-1236(ra) # 80005d7c <panic>
    if(sz - i < PGSIZE)
    80004258:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000425a:	8726                	mv	a4,s1
    8000425c:	012c06bb          	addw	a3,s8,s2
    80004260:	4581                	li	a1,0
    80004262:	8552                	mv	a0,s4
    80004264:	fffff097          	auipc	ra,0xfffff
    80004268:	c6a080e7          	jalr	-918(ra) # 80002ece <readi>
    8000426c:	2501                	sext.w	a0,a0
    8000426e:	26a49e63          	bne	s1,a0,800044ea <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    80004272:	012a893b          	addw	s2,s5,s2
    80004276:	03397563          	bgeu	s2,s3,800042a0 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    8000427a:	02091593          	sll	a1,s2,0x20
    8000427e:	9181                	srl	a1,a1,0x20
    80004280:	95de                	add	a1,a1,s7
    80004282:	855a                	mv	a0,s6
    80004284:	ffffc097          	auipc	ra,0xffffc
    80004288:	274080e7          	jalr	628(ra) # 800004f8 <walkaddr>
    8000428c:	862a                	mv	a2,a0
    if(pa == 0)
    8000428e:	dd4d                	beqz	a0,80004248 <exec+0xe6>
    if(sz - i < PGSIZE)
    80004290:	412984bb          	subw	s1,s3,s2
    80004294:	0004879b          	sext.w	a5,s1
    80004298:	fcfcf0e3          	bgeu	s9,a5,80004258 <exec+0xf6>
    8000429c:	84d6                	mv	s1,s5
    8000429e:	bf6d                	j	80004258 <exec+0xf6>
    sz = sz1;
    800042a0:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042a4:	2d85                	addw	s11,s11,1
    800042a6:	038d0d1b          	addw	s10,s10,56
    800042aa:	e8845783          	lhu	a5,-376(s0)
    800042ae:	06fddf63          	bge	s11,a5,8000432c <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800042b2:	2d01                	sext.w	s10,s10
    800042b4:	03800713          	li	a4,56
    800042b8:	86ea                	mv	a3,s10
    800042ba:	e1840613          	add	a2,s0,-488
    800042be:	4581                	li	a1,0
    800042c0:	8552                	mv	a0,s4
    800042c2:	fffff097          	auipc	ra,0xfffff
    800042c6:	c0c080e7          	jalr	-1012(ra) # 80002ece <readi>
    800042ca:	03800793          	li	a5,56
    800042ce:	1ef51863          	bne	a0,a5,800044be <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    800042d2:	e1842783          	lw	a5,-488(s0)
    800042d6:	4705                	li	a4,1
    800042d8:	fce796e3          	bne	a5,a4,800042a4 <exec+0x142>
    if(ph.memsz < ph.filesz)
    800042dc:	e4043603          	ld	a2,-448(s0)
    800042e0:	e3843783          	ld	a5,-456(s0)
    800042e4:	1ef66163          	bltu	a2,a5,800044c6 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042e8:	e2843783          	ld	a5,-472(s0)
    800042ec:	963e                	add	a2,a2,a5
    800042ee:	1ef66063          	bltu	a2,a5,800044ce <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042f2:	85a6                	mv	a1,s1
    800042f4:	855a                	mv	a0,s6
    800042f6:	ffffc097          	auipc	ra,0xffffc
    800042fa:	5c6080e7          	jalr	1478(ra) # 800008bc <uvmalloc>
    800042fe:	e0a43423          	sd	a0,-504(s0)
    80004302:	1c050a63          	beqz	a0,800044d6 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    80004306:	e2843b83          	ld	s7,-472(s0)
    8000430a:	df043783          	ld	a5,-528(s0)
    8000430e:	00fbf7b3          	and	a5,s7,a5
    80004312:	1c079a63          	bnez	a5,800044e6 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004316:	e2042c03          	lw	s8,-480(s0)
    8000431a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000431e:	00098463          	beqz	s3,80004326 <exec+0x1c4>
    80004322:	4901                	li	s2,0
    80004324:	bf99                	j	8000427a <exec+0x118>
    sz = sz1;
    80004326:	e0843483          	ld	s1,-504(s0)
    8000432a:	bfad                	j	800042a4 <exec+0x142>
    8000432c:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000432e:	8552                	mv	a0,s4
    80004330:	fffff097          	auipc	ra,0xfffff
    80004334:	b4c080e7          	jalr	-1204(ra) # 80002e7c <iunlockput>
  end_op();
    80004338:	fffff097          	auipc	ra,0xfffff
    8000433c:	32a080e7          	jalr	810(ra) # 80003662 <end_op>
  p = myproc();
    80004340:	ffffd097          	auipc	ra,0xffffd
    80004344:	b3c080e7          	jalr	-1220(ra) # 80000e7c <myproc>
    80004348:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000434a:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000434e:	6985                	lui	s3,0x1
    80004350:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004352:	99a6                	add	s3,s3,s1
    80004354:	77fd                	lui	a5,0xfffff
    80004356:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000435a:	6609                	lui	a2,0x2
    8000435c:	964e                	add	a2,a2,s3
    8000435e:	85ce                	mv	a1,s3
    80004360:	855a                	mv	a0,s6
    80004362:	ffffc097          	auipc	ra,0xffffc
    80004366:	55a080e7          	jalr	1370(ra) # 800008bc <uvmalloc>
    8000436a:	892a                	mv	s2,a0
    8000436c:	e0a43423          	sd	a0,-504(s0)
    80004370:	e519                	bnez	a0,8000437e <exec+0x21c>
  if(pagetable)
    80004372:	e1343423          	sd	s3,-504(s0)
    80004376:	4a01                	li	s4,0
    80004378:	aa95                	j	800044ec <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000437a:	4481                	li	s1,0
    8000437c:	bf4d                	j	8000432e <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000437e:	75f9                	lui	a1,0xffffe
    80004380:	95aa                	add	a1,a1,a0
    80004382:	855a                	mv	a0,s6
    80004384:	ffffc097          	auipc	ra,0xffffc
    80004388:	762080e7          	jalr	1890(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    8000438c:	7bfd                	lui	s7,0xfffff
    8000438e:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004390:	e0043783          	ld	a5,-512(s0)
    80004394:	6388                	ld	a0,0(a5)
    80004396:	c52d                	beqz	a0,80004400 <exec+0x29e>
    80004398:	e9040993          	add	s3,s0,-368
    8000439c:	f9040c13          	add	s8,s0,-112
    800043a0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043a2:	ffffc097          	auipc	ra,0xffffc
    800043a6:	f4c080e7          	jalr	-180(ra) # 800002ee <strlen>
    800043aa:	0015079b          	addw	a5,a0,1
    800043ae:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043b2:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    800043b6:	13796463          	bltu	s2,s7,800044de <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043ba:	e0043d03          	ld	s10,-512(s0)
    800043be:	000d3a03          	ld	s4,0(s10)
    800043c2:	8552                	mv	a0,s4
    800043c4:	ffffc097          	auipc	ra,0xffffc
    800043c8:	f2a080e7          	jalr	-214(ra) # 800002ee <strlen>
    800043cc:	0015069b          	addw	a3,a0,1
    800043d0:	8652                	mv	a2,s4
    800043d2:	85ca                	mv	a1,s2
    800043d4:	855a                	mv	a0,s6
    800043d6:	ffffc097          	auipc	ra,0xffffc
    800043da:	742080e7          	jalr	1858(ra) # 80000b18 <copyout>
    800043de:	10054263          	bltz	a0,800044e2 <exec+0x380>
    ustack[argc] = sp;
    800043e2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043e6:	0485                	add	s1,s1,1
    800043e8:	008d0793          	add	a5,s10,8
    800043ec:	e0f43023          	sd	a5,-512(s0)
    800043f0:	008d3503          	ld	a0,8(s10)
    800043f4:	c909                	beqz	a0,80004406 <exec+0x2a4>
    if(argc >= MAXARG)
    800043f6:	09a1                	add	s3,s3,8
    800043f8:	fb8995e3          	bne	s3,s8,800043a2 <exec+0x240>
  ip = 0;
    800043fc:	4a01                	li	s4,0
    800043fe:	a0fd                	j	800044ec <exec+0x38a>
  sp = sz;
    80004400:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004404:	4481                	li	s1,0
  ustack[argc] = 0;
    80004406:	00349793          	sll	a5,s1,0x3
    8000440a:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    8000440e:	97a2                	add	a5,a5,s0
    80004410:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004414:	00148693          	add	a3,s1,1
    80004418:	068e                	sll	a3,a3,0x3
    8000441a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000441e:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004422:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004426:	f57966e3          	bltu	s2,s7,80004372 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000442a:	e9040613          	add	a2,s0,-368
    8000442e:	85ca                	mv	a1,s2
    80004430:	855a                	mv	a0,s6
    80004432:	ffffc097          	auipc	ra,0xffffc
    80004436:	6e6080e7          	jalr	1766(ra) # 80000b18 <copyout>
    8000443a:	0e054663          	bltz	a0,80004526 <exec+0x3c4>
  p->trapframe->a1 = sp;
    8000443e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004442:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004446:	df843783          	ld	a5,-520(s0)
    8000444a:	0007c703          	lbu	a4,0(a5)
    8000444e:	cf11                	beqz	a4,8000446a <exec+0x308>
    80004450:	0785                	add	a5,a5,1
    if(*s == '/')
    80004452:	02f00693          	li	a3,47
    80004456:	a039                	j	80004464 <exec+0x302>
      last = s+1;
    80004458:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000445c:	0785                	add	a5,a5,1
    8000445e:	fff7c703          	lbu	a4,-1(a5)
    80004462:	c701                	beqz	a4,8000446a <exec+0x308>
    if(*s == '/')
    80004464:	fed71ce3          	bne	a4,a3,8000445c <exec+0x2fa>
    80004468:	bfc5                	j	80004458 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    8000446a:	4641                	li	a2,16
    8000446c:	df843583          	ld	a1,-520(s0)
    80004470:	158a8513          	add	a0,s5,344
    80004474:	ffffc097          	auipc	ra,0xffffc
    80004478:	e48080e7          	jalr	-440(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    8000447c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004480:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004484:	e0843783          	ld	a5,-504(s0)
    80004488:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000448c:	058ab783          	ld	a5,88(s5)
    80004490:	e6843703          	ld	a4,-408(s0)
    80004494:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004496:	058ab783          	ld	a5,88(s5)
    8000449a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000449e:	85e6                	mv	a1,s9
    800044a0:	ffffd097          	auipc	ra,0xffffd
    800044a4:	b3c080e7          	jalr	-1220(ra) # 80000fdc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044a8:	0004851b          	sext.w	a0,s1
    800044ac:	79be                	ld	s3,488(sp)
    800044ae:	7a1e                	ld	s4,480(sp)
    800044b0:	6afe                	ld	s5,472(sp)
    800044b2:	6b5e                	ld	s6,464(sp)
    800044b4:	6bbe                	ld	s7,456(sp)
    800044b6:	6c1e                	ld	s8,448(sp)
    800044b8:	7cfa                	ld	s9,440(sp)
    800044ba:	7d5a                	ld	s10,432(sp)
    800044bc:	bb05                	j	800041ec <exec+0x8a>
    800044be:	e0943423          	sd	s1,-504(s0)
    800044c2:	7dba                	ld	s11,424(sp)
    800044c4:	a025                	j	800044ec <exec+0x38a>
    800044c6:	e0943423          	sd	s1,-504(s0)
    800044ca:	7dba                	ld	s11,424(sp)
    800044cc:	a005                	j	800044ec <exec+0x38a>
    800044ce:	e0943423          	sd	s1,-504(s0)
    800044d2:	7dba                	ld	s11,424(sp)
    800044d4:	a821                	j	800044ec <exec+0x38a>
    800044d6:	e0943423          	sd	s1,-504(s0)
    800044da:	7dba                	ld	s11,424(sp)
    800044dc:	a801                	j	800044ec <exec+0x38a>
  ip = 0;
    800044de:	4a01                	li	s4,0
    800044e0:	a031                	j	800044ec <exec+0x38a>
    800044e2:	4a01                	li	s4,0
  if(pagetable)
    800044e4:	a021                	j	800044ec <exec+0x38a>
    800044e6:	7dba                	ld	s11,424(sp)
    800044e8:	a011                	j	800044ec <exec+0x38a>
    800044ea:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800044ec:	e0843583          	ld	a1,-504(s0)
    800044f0:	855a                	mv	a0,s6
    800044f2:	ffffd097          	auipc	ra,0xffffd
    800044f6:	aea080e7          	jalr	-1302(ra) # 80000fdc <proc_freepagetable>
  return -1;
    800044fa:	557d                	li	a0,-1
  if(ip){
    800044fc:	000a1b63          	bnez	s4,80004512 <exec+0x3b0>
    80004500:	79be                	ld	s3,488(sp)
    80004502:	7a1e                	ld	s4,480(sp)
    80004504:	6afe                	ld	s5,472(sp)
    80004506:	6b5e                	ld	s6,464(sp)
    80004508:	6bbe                	ld	s7,456(sp)
    8000450a:	6c1e                	ld	s8,448(sp)
    8000450c:	7cfa                	ld	s9,440(sp)
    8000450e:	7d5a                	ld	s10,432(sp)
    80004510:	b9f1                	j	800041ec <exec+0x8a>
    80004512:	79be                	ld	s3,488(sp)
    80004514:	6afe                	ld	s5,472(sp)
    80004516:	6b5e                	ld	s6,464(sp)
    80004518:	6bbe                	ld	s7,456(sp)
    8000451a:	6c1e                	ld	s8,448(sp)
    8000451c:	7cfa                	ld	s9,440(sp)
    8000451e:	7d5a                	ld	s10,432(sp)
    80004520:	b95d                	j	800041d6 <exec+0x74>
    80004522:	6b5e                	ld	s6,464(sp)
    80004524:	b94d                	j	800041d6 <exec+0x74>
  sz = sz1;
    80004526:	e0843983          	ld	s3,-504(s0)
    8000452a:	b5a1                	j	80004372 <exec+0x210>

000000008000452c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000452c:	7179                	add	sp,sp,-48
    8000452e:	f406                	sd	ra,40(sp)
    80004530:	f022                	sd	s0,32(sp)
    80004532:	ec26                	sd	s1,24(sp)
    80004534:	e84a                	sd	s2,16(sp)
    80004536:	1800                	add	s0,sp,48
    80004538:	892e                	mv	s2,a1
    8000453a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000453c:	fdc40593          	add	a1,s0,-36
    80004540:	ffffe097          	auipc	ra,0xffffe
    80004544:	ab6080e7          	jalr	-1354(ra) # 80001ff6 <argint>
    80004548:	04054063          	bltz	a0,80004588 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000454c:	fdc42703          	lw	a4,-36(s0)
    80004550:	47bd                	li	a5,15
    80004552:	02e7ed63          	bltu	a5,a4,8000458c <argfd+0x60>
    80004556:	ffffd097          	auipc	ra,0xffffd
    8000455a:	926080e7          	jalr	-1754(ra) # 80000e7c <myproc>
    8000455e:	fdc42703          	lw	a4,-36(s0)
    80004562:	01a70793          	add	a5,a4,26
    80004566:	078e                	sll	a5,a5,0x3
    80004568:	953e                	add	a0,a0,a5
    8000456a:	611c                	ld	a5,0(a0)
    8000456c:	c395                	beqz	a5,80004590 <argfd+0x64>
    return -1;
  if(pfd)
    8000456e:	00090463          	beqz	s2,80004576 <argfd+0x4a>
    *pfd = fd;
    80004572:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004576:	4501                	li	a0,0
  if(pf)
    80004578:	c091                	beqz	s1,8000457c <argfd+0x50>
    *pf = f;
    8000457a:	e09c                	sd	a5,0(s1)
}
    8000457c:	70a2                	ld	ra,40(sp)
    8000457e:	7402                	ld	s0,32(sp)
    80004580:	64e2                	ld	s1,24(sp)
    80004582:	6942                	ld	s2,16(sp)
    80004584:	6145                	add	sp,sp,48
    80004586:	8082                	ret
    return -1;
    80004588:	557d                	li	a0,-1
    8000458a:	bfcd                	j	8000457c <argfd+0x50>
    return -1;
    8000458c:	557d                	li	a0,-1
    8000458e:	b7fd                	j	8000457c <argfd+0x50>
    80004590:	557d                	li	a0,-1
    80004592:	b7ed                	j	8000457c <argfd+0x50>

0000000080004594 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004594:	1101                	add	sp,sp,-32
    80004596:	ec06                	sd	ra,24(sp)
    80004598:	e822                	sd	s0,16(sp)
    8000459a:	e426                	sd	s1,8(sp)
    8000459c:	1000                	add	s0,sp,32
    8000459e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045a0:	ffffd097          	auipc	ra,0xffffd
    800045a4:	8dc080e7          	jalr	-1828(ra) # 80000e7c <myproc>
    800045a8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045aa:	0d050793          	add	a5,a0,208
    800045ae:	4501                	li	a0,0
    800045b0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045b2:	6398                	ld	a4,0(a5)
    800045b4:	cb19                	beqz	a4,800045ca <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045b6:	2505                	addw	a0,a0,1
    800045b8:	07a1                	add	a5,a5,8
    800045ba:	fed51ce3          	bne	a0,a3,800045b2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045be:	557d                	li	a0,-1
}
    800045c0:	60e2                	ld	ra,24(sp)
    800045c2:	6442                	ld	s0,16(sp)
    800045c4:	64a2                	ld	s1,8(sp)
    800045c6:	6105                	add	sp,sp,32
    800045c8:	8082                	ret
      p->ofile[fd] = f;
    800045ca:	01a50793          	add	a5,a0,26
    800045ce:	078e                	sll	a5,a5,0x3
    800045d0:	963e                	add	a2,a2,a5
    800045d2:	e204                	sd	s1,0(a2)
      return fd;
    800045d4:	b7f5                	j	800045c0 <fdalloc+0x2c>

00000000800045d6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045d6:	715d                	add	sp,sp,-80
    800045d8:	e486                	sd	ra,72(sp)
    800045da:	e0a2                	sd	s0,64(sp)
    800045dc:	fc26                	sd	s1,56(sp)
    800045de:	f84a                	sd	s2,48(sp)
    800045e0:	f44e                	sd	s3,40(sp)
    800045e2:	f052                	sd	s4,32(sp)
    800045e4:	ec56                	sd	s5,24(sp)
    800045e6:	0880                	add	s0,sp,80
    800045e8:	8aae                	mv	s5,a1
    800045ea:	8a32                	mv	s4,a2
    800045ec:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045ee:	fb040593          	add	a1,s0,-80
    800045f2:	fffff097          	auipc	ra,0xfffff
    800045f6:	e14080e7          	jalr	-492(ra) # 80003406 <nameiparent>
    800045fa:	892a                	mv	s2,a0
    800045fc:	12050c63          	beqz	a0,80004734 <create+0x15e>
    return 0;

  ilock(dp);
    80004600:	ffffe097          	auipc	ra,0xffffe
    80004604:	616080e7          	jalr	1558(ra) # 80002c16 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004608:	4601                	li	a2,0
    8000460a:	fb040593          	add	a1,s0,-80
    8000460e:	854a                	mv	a0,s2
    80004610:	fffff097          	auipc	ra,0xfffff
    80004614:	b06080e7          	jalr	-1274(ra) # 80003116 <dirlookup>
    80004618:	84aa                	mv	s1,a0
    8000461a:	c539                	beqz	a0,80004668 <create+0x92>
    iunlockput(dp);
    8000461c:	854a                	mv	a0,s2
    8000461e:	fffff097          	auipc	ra,0xfffff
    80004622:	85e080e7          	jalr	-1954(ra) # 80002e7c <iunlockput>
    ilock(ip);
    80004626:	8526                	mv	a0,s1
    80004628:	ffffe097          	auipc	ra,0xffffe
    8000462c:	5ee080e7          	jalr	1518(ra) # 80002c16 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004630:	4789                	li	a5,2
    80004632:	02fa9463          	bne	s5,a5,8000465a <create+0x84>
    80004636:	0444d783          	lhu	a5,68(s1)
    8000463a:	37f9                	addw	a5,a5,-2
    8000463c:	17c2                	sll	a5,a5,0x30
    8000463e:	93c1                	srl	a5,a5,0x30
    80004640:	4705                	li	a4,1
    80004642:	00f76c63          	bltu	a4,a5,8000465a <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004646:	8526                	mv	a0,s1
    80004648:	60a6                	ld	ra,72(sp)
    8000464a:	6406                	ld	s0,64(sp)
    8000464c:	74e2                	ld	s1,56(sp)
    8000464e:	7942                	ld	s2,48(sp)
    80004650:	79a2                	ld	s3,40(sp)
    80004652:	7a02                	ld	s4,32(sp)
    80004654:	6ae2                	ld	s5,24(sp)
    80004656:	6161                	add	sp,sp,80
    80004658:	8082                	ret
    iunlockput(ip);
    8000465a:	8526                	mv	a0,s1
    8000465c:	fffff097          	auipc	ra,0xfffff
    80004660:	820080e7          	jalr	-2016(ra) # 80002e7c <iunlockput>
    return 0;
    80004664:	4481                	li	s1,0
    80004666:	b7c5                	j	80004646 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004668:	85d6                	mv	a1,s5
    8000466a:	00092503          	lw	a0,0(s2)
    8000466e:	ffffe097          	auipc	ra,0xffffe
    80004672:	414080e7          	jalr	1044(ra) # 80002a82 <ialloc>
    80004676:	84aa                	mv	s1,a0
    80004678:	c139                	beqz	a0,800046be <create+0xe8>
  ilock(ip);
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	59c080e7          	jalr	1436(ra) # 80002c16 <ilock>
  ip->major = major;
    80004682:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004686:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    8000468a:	4985                	li	s3,1
    8000468c:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004690:	8526                	mv	a0,s1
    80004692:	ffffe097          	auipc	ra,0xffffe
    80004696:	4b8080e7          	jalr	1208(ra) # 80002b4a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000469a:	033a8a63          	beq	s5,s3,800046ce <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    8000469e:	40d0                	lw	a2,4(s1)
    800046a0:	fb040593          	add	a1,s0,-80
    800046a4:	854a                	mv	a0,s2
    800046a6:	fffff097          	auipc	ra,0xfffff
    800046aa:	c80080e7          	jalr	-896(ra) # 80003326 <dirlink>
    800046ae:	06054b63          	bltz	a0,80004724 <create+0x14e>
  iunlockput(dp);
    800046b2:	854a                	mv	a0,s2
    800046b4:	ffffe097          	auipc	ra,0xffffe
    800046b8:	7c8080e7          	jalr	1992(ra) # 80002e7c <iunlockput>
  return ip;
    800046bc:	b769                	j	80004646 <create+0x70>
    panic("create: ialloc");
    800046be:	00004517          	auipc	a0,0x4
    800046c2:	eb250513          	add	a0,a0,-334 # 80008570 <etext+0x570>
    800046c6:	00001097          	auipc	ra,0x1
    800046ca:	6b6080e7          	jalr	1718(ra) # 80005d7c <panic>
    dp->nlink++;  // for ".."
    800046ce:	04a95783          	lhu	a5,74(s2)
    800046d2:	2785                	addw	a5,a5,1
    800046d4:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046d8:	854a                	mv	a0,s2
    800046da:	ffffe097          	auipc	ra,0xffffe
    800046de:	470080e7          	jalr	1136(ra) # 80002b4a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046e2:	40d0                	lw	a2,4(s1)
    800046e4:	00004597          	auipc	a1,0x4
    800046e8:	e9c58593          	add	a1,a1,-356 # 80008580 <etext+0x580>
    800046ec:	8526                	mv	a0,s1
    800046ee:	fffff097          	auipc	ra,0xfffff
    800046f2:	c38080e7          	jalr	-968(ra) # 80003326 <dirlink>
    800046f6:	00054f63          	bltz	a0,80004714 <create+0x13e>
    800046fa:	00492603          	lw	a2,4(s2)
    800046fe:	00004597          	auipc	a1,0x4
    80004702:	e8a58593          	add	a1,a1,-374 # 80008588 <etext+0x588>
    80004706:	8526                	mv	a0,s1
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	c1e080e7          	jalr	-994(ra) # 80003326 <dirlink>
    80004710:	f80557e3          	bgez	a0,8000469e <create+0xc8>
      panic("create dots");
    80004714:	00004517          	auipc	a0,0x4
    80004718:	e7c50513          	add	a0,a0,-388 # 80008590 <etext+0x590>
    8000471c:	00001097          	auipc	ra,0x1
    80004720:	660080e7          	jalr	1632(ra) # 80005d7c <panic>
    panic("create: dirlink");
    80004724:	00004517          	auipc	a0,0x4
    80004728:	e7c50513          	add	a0,a0,-388 # 800085a0 <etext+0x5a0>
    8000472c:	00001097          	auipc	ra,0x1
    80004730:	650080e7          	jalr	1616(ra) # 80005d7c <panic>
    return 0;
    80004734:	84aa                	mv	s1,a0
    80004736:	bf01                	j	80004646 <create+0x70>

0000000080004738 <sys_dup>:
{
    80004738:	7179                	add	sp,sp,-48
    8000473a:	f406                	sd	ra,40(sp)
    8000473c:	f022                	sd	s0,32(sp)
    8000473e:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004740:	fd840613          	add	a2,s0,-40
    80004744:	4581                	li	a1,0
    80004746:	4501                	li	a0,0
    80004748:	00000097          	auipc	ra,0x0
    8000474c:	de4080e7          	jalr	-540(ra) # 8000452c <argfd>
    return -1;
    80004750:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004752:	02054763          	bltz	a0,80004780 <sys_dup+0x48>
    80004756:	ec26                	sd	s1,24(sp)
    80004758:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000475a:	fd843903          	ld	s2,-40(s0)
    8000475e:	854a                	mv	a0,s2
    80004760:	00000097          	auipc	ra,0x0
    80004764:	e34080e7          	jalr	-460(ra) # 80004594 <fdalloc>
    80004768:	84aa                	mv	s1,a0
    return -1;
    8000476a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000476c:	00054f63          	bltz	a0,8000478a <sys_dup+0x52>
  filedup(f);
    80004770:	854a                	mv	a0,s2
    80004772:	fffff097          	auipc	ra,0xfffff
    80004776:	2ee080e7          	jalr	750(ra) # 80003a60 <filedup>
  return fd;
    8000477a:	87a6                	mv	a5,s1
    8000477c:	64e2                	ld	s1,24(sp)
    8000477e:	6942                	ld	s2,16(sp)
}
    80004780:	853e                	mv	a0,a5
    80004782:	70a2                	ld	ra,40(sp)
    80004784:	7402                	ld	s0,32(sp)
    80004786:	6145                	add	sp,sp,48
    80004788:	8082                	ret
    8000478a:	64e2                	ld	s1,24(sp)
    8000478c:	6942                	ld	s2,16(sp)
    8000478e:	bfcd                	j	80004780 <sys_dup+0x48>

0000000080004790 <sys_read>:
{
    80004790:	7179                	add	sp,sp,-48
    80004792:	f406                	sd	ra,40(sp)
    80004794:	f022                	sd	s0,32(sp)
    80004796:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004798:	fe840613          	add	a2,s0,-24
    8000479c:	4581                	li	a1,0
    8000479e:	4501                	li	a0,0
    800047a0:	00000097          	auipc	ra,0x0
    800047a4:	d8c080e7          	jalr	-628(ra) # 8000452c <argfd>
    return -1;
    800047a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047aa:	04054163          	bltz	a0,800047ec <sys_read+0x5c>
    800047ae:	fe440593          	add	a1,s0,-28
    800047b2:	4509                	li	a0,2
    800047b4:	ffffe097          	auipc	ra,0xffffe
    800047b8:	842080e7          	jalr	-1982(ra) # 80001ff6 <argint>
    return -1;
    800047bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047be:	02054763          	bltz	a0,800047ec <sys_read+0x5c>
    800047c2:	fd840593          	add	a1,s0,-40
    800047c6:	4505                	li	a0,1
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	850080e7          	jalr	-1968(ra) # 80002018 <argaddr>
    return -1;
    800047d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047d2:	00054d63          	bltz	a0,800047ec <sys_read+0x5c>
  return fileread(f, p, n);
    800047d6:	fe442603          	lw	a2,-28(s0)
    800047da:	fd843583          	ld	a1,-40(s0)
    800047de:	fe843503          	ld	a0,-24(s0)
    800047e2:	fffff097          	auipc	ra,0xfffff
    800047e6:	424080e7          	jalr	1060(ra) # 80003c06 <fileread>
    800047ea:	87aa                	mv	a5,a0
}
    800047ec:	853e                	mv	a0,a5
    800047ee:	70a2                	ld	ra,40(sp)
    800047f0:	7402                	ld	s0,32(sp)
    800047f2:	6145                	add	sp,sp,48
    800047f4:	8082                	ret

00000000800047f6 <sys_write>:
{
    800047f6:	7179                	add	sp,sp,-48
    800047f8:	f406                	sd	ra,40(sp)
    800047fa:	f022                	sd	s0,32(sp)
    800047fc:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047fe:	fe840613          	add	a2,s0,-24
    80004802:	4581                	li	a1,0
    80004804:	4501                	li	a0,0
    80004806:	00000097          	auipc	ra,0x0
    8000480a:	d26080e7          	jalr	-730(ra) # 8000452c <argfd>
    return -1;
    8000480e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004810:	04054163          	bltz	a0,80004852 <sys_write+0x5c>
    80004814:	fe440593          	add	a1,s0,-28
    80004818:	4509                	li	a0,2
    8000481a:	ffffd097          	auipc	ra,0xffffd
    8000481e:	7dc080e7          	jalr	2012(ra) # 80001ff6 <argint>
    return -1;
    80004822:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004824:	02054763          	bltz	a0,80004852 <sys_write+0x5c>
    80004828:	fd840593          	add	a1,s0,-40
    8000482c:	4505                	li	a0,1
    8000482e:	ffffd097          	auipc	ra,0xffffd
    80004832:	7ea080e7          	jalr	2026(ra) # 80002018 <argaddr>
    return -1;
    80004836:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004838:	00054d63          	bltz	a0,80004852 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000483c:	fe442603          	lw	a2,-28(s0)
    80004840:	fd843583          	ld	a1,-40(s0)
    80004844:	fe843503          	ld	a0,-24(s0)
    80004848:	fffff097          	auipc	ra,0xfffff
    8000484c:	490080e7          	jalr	1168(ra) # 80003cd8 <filewrite>
    80004850:	87aa                	mv	a5,a0
}
    80004852:	853e                	mv	a0,a5
    80004854:	70a2                	ld	ra,40(sp)
    80004856:	7402                	ld	s0,32(sp)
    80004858:	6145                	add	sp,sp,48
    8000485a:	8082                	ret

000000008000485c <sys_close>:
{
    8000485c:	1101                	add	sp,sp,-32
    8000485e:	ec06                	sd	ra,24(sp)
    80004860:	e822                	sd	s0,16(sp)
    80004862:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004864:	fe040613          	add	a2,s0,-32
    80004868:	fec40593          	add	a1,s0,-20
    8000486c:	4501                	li	a0,0
    8000486e:	00000097          	auipc	ra,0x0
    80004872:	cbe080e7          	jalr	-834(ra) # 8000452c <argfd>
    return -1;
    80004876:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004878:	02054463          	bltz	a0,800048a0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000487c:	ffffc097          	auipc	ra,0xffffc
    80004880:	600080e7          	jalr	1536(ra) # 80000e7c <myproc>
    80004884:	fec42783          	lw	a5,-20(s0)
    80004888:	07e9                	add	a5,a5,26
    8000488a:	078e                	sll	a5,a5,0x3
    8000488c:	953e                	add	a0,a0,a5
    8000488e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004892:	fe043503          	ld	a0,-32(s0)
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	21c080e7          	jalr	540(ra) # 80003ab2 <fileclose>
  return 0;
    8000489e:	4781                	li	a5,0
}
    800048a0:	853e                	mv	a0,a5
    800048a2:	60e2                	ld	ra,24(sp)
    800048a4:	6442                	ld	s0,16(sp)
    800048a6:	6105                	add	sp,sp,32
    800048a8:	8082                	ret

00000000800048aa <sys_fstat>:
{
    800048aa:	1101                	add	sp,sp,-32
    800048ac:	ec06                	sd	ra,24(sp)
    800048ae:	e822                	sd	s0,16(sp)
    800048b0:	1000                	add	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048b2:	fe840613          	add	a2,s0,-24
    800048b6:	4581                	li	a1,0
    800048b8:	4501                	li	a0,0
    800048ba:	00000097          	auipc	ra,0x0
    800048be:	c72080e7          	jalr	-910(ra) # 8000452c <argfd>
    return -1;
    800048c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048c4:	02054563          	bltz	a0,800048ee <sys_fstat+0x44>
    800048c8:	fe040593          	add	a1,s0,-32
    800048cc:	4505                	li	a0,1
    800048ce:	ffffd097          	auipc	ra,0xffffd
    800048d2:	74a080e7          	jalr	1866(ra) # 80002018 <argaddr>
    return -1;
    800048d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048d8:	00054b63          	bltz	a0,800048ee <sys_fstat+0x44>
  return filestat(f, st);
    800048dc:	fe043583          	ld	a1,-32(s0)
    800048e0:	fe843503          	ld	a0,-24(s0)
    800048e4:	fffff097          	auipc	ra,0xfffff
    800048e8:	2b0080e7          	jalr	688(ra) # 80003b94 <filestat>
    800048ec:	87aa                	mv	a5,a0
}
    800048ee:	853e                	mv	a0,a5
    800048f0:	60e2                	ld	ra,24(sp)
    800048f2:	6442                	ld	s0,16(sp)
    800048f4:	6105                	add	sp,sp,32
    800048f6:	8082                	ret

00000000800048f8 <sys_link>:
{
    800048f8:	7169                	add	sp,sp,-304
    800048fa:	f606                	sd	ra,296(sp)
    800048fc:	f222                	sd	s0,288(sp)
    800048fe:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004900:	08000613          	li	a2,128
    80004904:	ed040593          	add	a1,s0,-304
    80004908:	4501                	li	a0,0
    8000490a:	ffffd097          	auipc	ra,0xffffd
    8000490e:	730080e7          	jalr	1840(ra) # 8000203a <argstr>
    return -1;
    80004912:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004914:	12054663          	bltz	a0,80004a40 <sys_link+0x148>
    80004918:	08000613          	li	a2,128
    8000491c:	f5040593          	add	a1,s0,-176
    80004920:	4505                	li	a0,1
    80004922:	ffffd097          	auipc	ra,0xffffd
    80004926:	718080e7          	jalr	1816(ra) # 8000203a <argstr>
    return -1;
    8000492a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000492c:	10054a63          	bltz	a0,80004a40 <sys_link+0x148>
    80004930:	ee26                	sd	s1,280(sp)
  begin_op();
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	cb6080e7          	jalr	-842(ra) # 800035e8 <begin_op>
  if((ip = namei(old)) == 0){
    8000493a:	ed040513          	add	a0,s0,-304
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	aaa080e7          	jalr	-1366(ra) # 800033e8 <namei>
    80004946:	84aa                	mv	s1,a0
    80004948:	c949                	beqz	a0,800049da <sys_link+0xe2>
  ilock(ip);
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	2cc080e7          	jalr	716(ra) # 80002c16 <ilock>
  if(ip->type == T_DIR){
    80004952:	04449703          	lh	a4,68(s1)
    80004956:	4785                	li	a5,1
    80004958:	08f70863          	beq	a4,a5,800049e8 <sys_link+0xf0>
    8000495c:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000495e:	04a4d783          	lhu	a5,74(s1)
    80004962:	2785                	addw	a5,a5,1
    80004964:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004968:	8526                	mv	a0,s1
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	1e0080e7          	jalr	480(ra) # 80002b4a <iupdate>
  iunlock(ip);
    80004972:	8526                	mv	a0,s1
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	368080e7          	jalr	872(ra) # 80002cdc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000497c:	fd040593          	add	a1,s0,-48
    80004980:	f5040513          	add	a0,s0,-176
    80004984:	fffff097          	auipc	ra,0xfffff
    80004988:	a82080e7          	jalr	-1406(ra) # 80003406 <nameiparent>
    8000498c:	892a                	mv	s2,a0
    8000498e:	cd35                	beqz	a0,80004a0a <sys_link+0x112>
  ilock(dp);
    80004990:	ffffe097          	auipc	ra,0xffffe
    80004994:	286080e7          	jalr	646(ra) # 80002c16 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004998:	00092703          	lw	a4,0(s2)
    8000499c:	409c                	lw	a5,0(s1)
    8000499e:	06f71163          	bne	a4,a5,80004a00 <sys_link+0x108>
    800049a2:	40d0                	lw	a2,4(s1)
    800049a4:	fd040593          	add	a1,s0,-48
    800049a8:	854a                	mv	a0,s2
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	97c080e7          	jalr	-1668(ra) # 80003326 <dirlink>
    800049b2:	04054763          	bltz	a0,80004a00 <sys_link+0x108>
  iunlockput(dp);
    800049b6:	854a                	mv	a0,s2
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	4c4080e7          	jalr	1220(ra) # 80002e7c <iunlockput>
  iput(ip);
    800049c0:	8526                	mv	a0,s1
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	412080e7          	jalr	1042(ra) # 80002dd4 <iput>
  end_op();
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	c98080e7          	jalr	-872(ra) # 80003662 <end_op>
  return 0;
    800049d2:	4781                	li	a5,0
    800049d4:	64f2                	ld	s1,280(sp)
    800049d6:	6952                	ld	s2,272(sp)
    800049d8:	a0a5                	j	80004a40 <sys_link+0x148>
    end_op();
    800049da:	fffff097          	auipc	ra,0xfffff
    800049de:	c88080e7          	jalr	-888(ra) # 80003662 <end_op>
    return -1;
    800049e2:	57fd                	li	a5,-1
    800049e4:	64f2                	ld	s1,280(sp)
    800049e6:	a8a9                	j	80004a40 <sys_link+0x148>
    iunlockput(ip);
    800049e8:	8526                	mv	a0,s1
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	492080e7          	jalr	1170(ra) # 80002e7c <iunlockput>
    end_op();
    800049f2:	fffff097          	auipc	ra,0xfffff
    800049f6:	c70080e7          	jalr	-912(ra) # 80003662 <end_op>
    return -1;
    800049fa:	57fd                	li	a5,-1
    800049fc:	64f2                	ld	s1,280(sp)
    800049fe:	a089                	j	80004a40 <sys_link+0x148>
    iunlockput(dp);
    80004a00:	854a                	mv	a0,s2
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	47a080e7          	jalr	1146(ra) # 80002e7c <iunlockput>
  ilock(ip);
    80004a0a:	8526                	mv	a0,s1
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	20a080e7          	jalr	522(ra) # 80002c16 <ilock>
  ip->nlink--;
    80004a14:	04a4d783          	lhu	a5,74(s1)
    80004a18:	37fd                	addw	a5,a5,-1
    80004a1a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a1e:	8526                	mv	a0,s1
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	12a080e7          	jalr	298(ra) # 80002b4a <iupdate>
  iunlockput(ip);
    80004a28:	8526                	mv	a0,s1
    80004a2a:	ffffe097          	auipc	ra,0xffffe
    80004a2e:	452080e7          	jalr	1106(ra) # 80002e7c <iunlockput>
  end_op();
    80004a32:	fffff097          	auipc	ra,0xfffff
    80004a36:	c30080e7          	jalr	-976(ra) # 80003662 <end_op>
  return -1;
    80004a3a:	57fd                	li	a5,-1
    80004a3c:	64f2                	ld	s1,280(sp)
    80004a3e:	6952                	ld	s2,272(sp)
}
    80004a40:	853e                	mv	a0,a5
    80004a42:	70b2                	ld	ra,296(sp)
    80004a44:	7412                	ld	s0,288(sp)
    80004a46:	6155                	add	sp,sp,304
    80004a48:	8082                	ret

0000000080004a4a <sys_unlink>:
{
    80004a4a:	7151                	add	sp,sp,-240
    80004a4c:	f586                	sd	ra,232(sp)
    80004a4e:	f1a2                	sd	s0,224(sp)
    80004a50:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a52:	08000613          	li	a2,128
    80004a56:	f3040593          	add	a1,s0,-208
    80004a5a:	4501                	li	a0,0
    80004a5c:	ffffd097          	auipc	ra,0xffffd
    80004a60:	5de080e7          	jalr	1502(ra) # 8000203a <argstr>
    80004a64:	1a054a63          	bltz	a0,80004c18 <sys_unlink+0x1ce>
    80004a68:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a6a:	fffff097          	auipc	ra,0xfffff
    80004a6e:	b7e080e7          	jalr	-1154(ra) # 800035e8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a72:	fb040593          	add	a1,s0,-80
    80004a76:	f3040513          	add	a0,s0,-208
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	98c080e7          	jalr	-1652(ra) # 80003406 <nameiparent>
    80004a82:	84aa                	mv	s1,a0
    80004a84:	cd71                	beqz	a0,80004b60 <sys_unlink+0x116>
  ilock(dp);
    80004a86:	ffffe097          	auipc	ra,0xffffe
    80004a8a:	190080e7          	jalr	400(ra) # 80002c16 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a8e:	00004597          	auipc	a1,0x4
    80004a92:	af258593          	add	a1,a1,-1294 # 80008580 <etext+0x580>
    80004a96:	fb040513          	add	a0,s0,-80
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	662080e7          	jalr	1634(ra) # 800030fc <namecmp>
    80004aa2:	14050c63          	beqz	a0,80004bfa <sys_unlink+0x1b0>
    80004aa6:	00004597          	auipc	a1,0x4
    80004aaa:	ae258593          	add	a1,a1,-1310 # 80008588 <etext+0x588>
    80004aae:	fb040513          	add	a0,s0,-80
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	64a080e7          	jalr	1610(ra) # 800030fc <namecmp>
    80004aba:	14050063          	beqz	a0,80004bfa <sys_unlink+0x1b0>
    80004abe:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ac0:	f2c40613          	add	a2,s0,-212
    80004ac4:	fb040593          	add	a1,s0,-80
    80004ac8:	8526                	mv	a0,s1
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	64c080e7          	jalr	1612(ra) # 80003116 <dirlookup>
    80004ad2:	892a                	mv	s2,a0
    80004ad4:	12050263          	beqz	a0,80004bf8 <sys_unlink+0x1ae>
  ilock(ip);
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	13e080e7          	jalr	318(ra) # 80002c16 <ilock>
  if(ip->nlink < 1)
    80004ae0:	04a91783          	lh	a5,74(s2)
    80004ae4:	08f05563          	blez	a5,80004b6e <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ae8:	04491703          	lh	a4,68(s2)
    80004aec:	4785                	li	a5,1
    80004aee:	08f70963          	beq	a4,a5,80004b80 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004af2:	4641                	li	a2,16
    80004af4:	4581                	li	a1,0
    80004af6:	fc040513          	add	a0,s0,-64
    80004afa:	ffffb097          	auipc	ra,0xffffb
    80004afe:	680080e7          	jalr	1664(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b02:	4741                	li	a4,16
    80004b04:	f2c42683          	lw	a3,-212(s0)
    80004b08:	fc040613          	add	a2,s0,-64
    80004b0c:	4581                	li	a1,0
    80004b0e:	8526                	mv	a0,s1
    80004b10:	ffffe097          	auipc	ra,0xffffe
    80004b14:	4c2080e7          	jalr	1218(ra) # 80002fd2 <writei>
    80004b18:	47c1                	li	a5,16
    80004b1a:	0af51b63          	bne	a0,a5,80004bd0 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004b1e:	04491703          	lh	a4,68(s2)
    80004b22:	4785                	li	a5,1
    80004b24:	0af70f63          	beq	a4,a5,80004be2 <sys_unlink+0x198>
  iunlockput(dp);
    80004b28:	8526                	mv	a0,s1
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	352080e7          	jalr	850(ra) # 80002e7c <iunlockput>
  ip->nlink--;
    80004b32:	04a95783          	lhu	a5,74(s2)
    80004b36:	37fd                	addw	a5,a5,-1
    80004b38:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b3c:	854a                	mv	a0,s2
    80004b3e:	ffffe097          	auipc	ra,0xffffe
    80004b42:	00c080e7          	jalr	12(ra) # 80002b4a <iupdate>
  iunlockput(ip);
    80004b46:	854a                	mv	a0,s2
    80004b48:	ffffe097          	auipc	ra,0xffffe
    80004b4c:	334080e7          	jalr	820(ra) # 80002e7c <iunlockput>
  end_op();
    80004b50:	fffff097          	auipc	ra,0xfffff
    80004b54:	b12080e7          	jalr	-1262(ra) # 80003662 <end_op>
  return 0;
    80004b58:	4501                	li	a0,0
    80004b5a:	64ee                	ld	s1,216(sp)
    80004b5c:	694e                	ld	s2,208(sp)
    80004b5e:	a84d                	j	80004c10 <sys_unlink+0x1c6>
    end_op();
    80004b60:	fffff097          	auipc	ra,0xfffff
    80004b64:	b02080e7          	jalr	-1278(ra) # 80003662 <end_op>
    return -1;
    80004b68:	557d                	li	a0,-1
    80004b6a:	64ee                	ld	s1,216(sp)
    80004b6c:	a055                	j	80004c10 <sys_unlink+0x1c6>
    80004b6e:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004b70:	00004517          	auipc	a0,0x4
    80004b74:	a4050513          	add	a0,a0,-1472 # 800085b0 <etext+0x5b0>
    80004b78:	00001097          	auipc	ra,0x1
    80004b7c:	204080e7          	jalr	516(ra) # 80005d7c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b80:	04c92703          	lw	a4,76(s2)
    80004b84:	02000793          	li	a5,32
    80004b88:	f6e7f5e3          	bgeu	a5,a4,80004af2 <sys_unlink+0xa8>
    80004b8c:	e5ce                	sd	s3,200(sp)
    80004b8e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b92:	4741                	li	a4,16
    80004b94:	86ce                	mv	a3,s3
    80004b96:	f1840613          	add	a2,s0,-232
    80004b9a:	4581                	li	a1,0
    80004b9c:	854a                	mv	a0,s2
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	330080e7          	jalr	816(ra) # 80002ece <readi>
    80004ba6:	47c1                	li	a5,16
    80004ba8:	00f51c63          	bne	a0,a5,80004bc0 <sys_unlink+0x176>
    if(de.inum != 0)
    80004bac:	f1845783          	lhu	a5,-232(s0)
    80004bb0:	e7b5                	bnez	a5,80004c1c <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bb2:	29c1                	addw	s3,s3,16
    80004bb4:	04c92783          	lw	a5,76(s2)
    80004bb8:	fcf9ede3          	bltu	s3,a5,80004b92 <sys_unlink+0x148>
    80004bbc:	69ae                	ld	s3,200(sp)
    80004bbe:	bf15                	j	80004af2 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004bc0:	00004517          	auipc	a0,0x4
    80004bc4:	a0850513          	add	a0,a0,-1528 # 800085c8 <etext+0x5c8>
    80004bc8:	00001097          	auipc	ra,0x1
    80004bcc:	1b4080e7          	jalr	436(ra) # 80005d7c <panic>
    80004bd0:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004bd2:	00004517          	auipc	a0,0x4
    80004bd6:	a0e50513          	add	a0,a0,-1522 # 800085e0 <etext+0x5e0>
    80004bda:	00001097          	auipc	ra,0x1
    80004bde:	1a2080e7          	jalr	418(ra) # 80005d7c <panic>
    dp->nlink--;
    80004be2:	04a4d783          	lhu	a5,74(s1)
    80004be6:	37fd                	addw	a5,a5,-1
    80004be8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bec:	8526                	mv	a0,s1
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	f5c080e7          	jalr	-164(ra) # 80002b4a <iupdate>
    80004bf6:	bf0d                	j	80004b28 <sys_unlink+0xde>
    80004bf8:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	280080e7          	jalr	640(ra) # 80002e7c <iunlockput>
  end_op();
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	a5e080e7          	jalr	-1442(ra) # 80003662 <end_op>
  return -1;
    80004c0c:	557d                	li	a0,-1
    80004c0e:	64ee                	ld	s1,216(sp)
}
    80004c10:	70ae                	ld	ra,232(sp)
    80004c12:	740e                	ld	s0,224(sp)
    80004c14:	616d                	add	sp,sp,240
    80004c16:	8082                	ret
    return -1;
    80004c18:	557d                	li	a0,-1
    80004c1a:	bfdd                	j	80004c10 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004c1c:	854a                	mv	a0,s2
    80004c1e:	ffffe097          	auipc	ra,0xffffe
    80004c22:	25e080e7          	jalr	606(ra) # 80002e7c <iunlockput>
    goto bad;
    80004c26:	694e                	ld	s2,208(sp)
    80004c28:	69ae                	ld	s3,200(sp)
    80004c2a:	bfc1                	j	80004bfa <sys_unlink+0x1b0>

0000000080004c2c <sys_open>:

uint64
sys_open(void)
{
    80004c2c:	7131                	add	sp,sp,-192
    80004c2e:	fd06                	sd	ra,184(sp)
    80004c30:	f922                	sd	s0,176(sp)
    80004c32:	f526                	sd	s1,168(sp)
    80004c34:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c36:	08000613          	li	a2,128
    80004c3a:	f5040593          	add	a1,s0,-176
    80004c3e:	4501                	li	a0,0
    80004c40:	ffffd097          	auipc	ra,0xffffd
    80004c44:	3fa080e7          	jalr	1018(ra) # 8000203a <argstr>
    return -1;
    80004c48:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c4a:	0c054463          	bltz	a0,80004d12 <sys_open+0xe6>
    80004c4e:	f4c40593          	add	a1,s0,-180
    80004c52:	4505                	li	a0,1
    80004c54:	ffffd097          	auipc	ra,0xffffd
    80004c58:	3a2080e7          	jalr	930(ra) # 80001ff6 <argint>
    80004c5c:	0a054b63          	bltz	a0,80004d12 <sys_open+0xe6>
    80004c60:	f14a                	sd	s2,160(sp)

  begin_op();
    80004c62:	fffff097          	auipc	ra,0xfffff
    80004c66:	986080e7          	jalr	-1658(ra) # 800035e8 <begin_op>

  if(omode & O_CREATE){
    80004c6a:	f4c42783          	lw	a5,-180(s0)
    80004c6e:	2007f793          	and	a5,a5,512
    80004c72:	cfc5                	beqz	a5,80004d2a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c74:	4681                	li	a3,0
    80004c76:	4601                	li	a2,0
    80004c78:	4589                	li	a1,2
    80004c7a:	f5040513          	add	a0,s0,-176
    80004c7e:	00000097          	auipc	ra,0x0
    80004c82:	958080e7          	jalr	-1704(ra) # 800045d6 <create>
    80004c86:	892a                	mv	s2,a0
    if(ip == 0){
    80004c88:	c959                	beqz	a0,80004d1e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c8a:	04491703          	lh	a4,68(s2)
    80004c8e:	478d                	li	a5,3
    80004c90:	00f71763          	bne	a4,a5,80004c9e <sys_open+0x72>
    80004c94:	04695703          	lhu	a4,70(s2)
    80004c98:	47a5                	li	a5,9
    80004c9a:	0ce7ef63          	bltu	a5,a4,80004d78 <sys_open+0x14c>
    80004c9e:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	d56080e7          	jalr	-682(ra) # 800039f6 <filealloc>
    80004ca8:	89aa                	mv	s3,a0
    80004caa:	c965                	beqz	a0,80004d9a <sys_open+0x16e>
    80004cac:	00000097          	auipc	ra,0x0
    80004cb0:	8e8080e7          	jalr	-1816(ra) # 80004594 <fdalloc>
    80004cb4:	84aa                	mv	s1,a0
    80004cb6:	0c054d63          	bltz	a0,80004d90 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cba:	04491703          	lh	a4,68(s2)
    80004cbe:	478d                	li	a5,3
    80004cc0:	0ef70a63          	beq	a4,a5,80004db4 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cc4:	4789                	li	a5,2
    80004cc6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cca:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cce:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cd2:	f4c42783          	lw	a5,-180(s0)
    80004cd6:	0017c713          	xor	a4,a5,1
    80004cda:	8b05                	and	a4,a4,1
    80004cdc:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ce0:	0037f713          	and	a4,a5,3
    80004ce4:	00e03733          	snez	a4,a4
    80004ce8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cec:	4007f793          	and	a5,a5,1024
    80004cf0:	c791                	beqz	a5,80004cfc <sys_open+0xd0>
    80004cf2:	04491703          	lh	a4,68(s2)
    80004cf6:	4789                	li	a5,2
    80004cf8:	0cf70563          	beq	a4,a5,80004dc2 <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004cfc:	854a                	mv	a0,s2
    80004cfe:	ffffe097          	auipc	ra,0xffffe
    80004d02:	fde080e7          	jalr	-34(ra) # 80002cdc <iunlock>
  end_op();
    80004d06:	fffff097          	auipc	ra,0xfffff
    80004d0a:	95c080e7          	jalr	-1700(ra) # 80003662 <end_op>
    80004d0e:	790a                	ld	s2,160(sp)
    80004d10:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004d12:	8526                	mv	a0,s1
    80004d14:	70ea                	ld	ra,184(sp)
    80004d16:	744a                	ld	s0,176(sp)
    80004d18:	74aa                	ld	s1,168(sp)
    80004d1a:	6129                	add	sp,sp,192
    80004d1c:	8082                	ret
      end_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	944080e7          	jalr	-1724(ra) # 80003662 <end_op>
      return -1;
    80004d26:	790a                	ld	s2,160(sp)
    80004d28:	b7ed                	j	80004d12 <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004d2a:	f5040513          	add	a0,s0,-176
    80004d2e:	ffffe097          	auipc	ra,0xffffe
    80004d32:	6ba080e7          	jalr	1722(ra) # 800033e8 <namei>
    80004d36:	892a                	mv	s2,a0
    80004d38:	c90d                	beqz	a0,80004d6a <sys_open+0x13e>
    ilock(ip);
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	edc080e7          	jalr	-292(ra) # 80002c16 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d42:	04491703          	lh	a4,68(s2)
    80004d46:	4785                	li	a5,1
    80004d48:	f4f711e3          	bne	a4,a5,80004c8a <sys_open+0x5e>
    80004d4c:	f4c42783          	lw	a5,-180(s0)
    80004d50:	d7b9                	beqz	a5,80004c9e <sys_open+0x72>
      iunlockput(ip);
    80004d52:	854a                	mv	a0,s2
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	128080e7          	jalr	296(ra) # 80002e7c <iunlockput>
      end_op();
    80004d5c:	fffff097          	auipc	ra,0xfffff
    80004d60:	906080e7          	jalr	-1786(ra) # 80003662 <end_op>
      return -1;
    80004d64:	54fd                	li	s1,-1
    80004d66:	790a                	ld	s2,160(sp)
    80004d68:	b76d                	j	80004d12 <sys_open+0xe6>
      end_op();
    80004d6a:	fffff097          	auipc	ra,0xfffff
    80004d6e:	8f8080e7          	jalr	-1800(ra) # 80003662 <end_op>
      return -1;
    80004d72:	54fd                	li	s1,-1
    80004d74:	790a                	ld	s2,160(sp)
    80004d76:	bf71                	j	80004d12 <sys_open+0xe6>
    iunlockput(ip);
    80004d78:	854a                	mv	a0,s2
    80004d7a:	ffffe097          	auipc	ra,0xffffe
    80004d7e:	102080e7          	jalr	258(ra) # 80002e7c <iunlockput>
    end_op();
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	8e0080e7          	jalr	-1824(ra) # 80003662 <end_op>
    return -1;
    80004d8a:	54fd                	li	s1,-1
    80004d8c:	790a                	ld	s2,160(sp)
    80004d8e:	b751                	j	80004d12 <sys_open+0xe6>
      fileclose(f);
    80004d90:	854e                	mv	a0,s3
    80004d92:	fffff097          	auipc	ra,0xfffff
    80004d96:	d20080e7          	jalr	-736(ra) # 80003ab2 <fileclose>
    iunlockput(ip);
    80004d9a:	854a                	mv	a0,s2
    80004d9c:	ffffe097          	auipc	ra,0xffffe
    80004da0:	0e0080e7          	jalr	224(ra) # 80002e7c <iunlockput>
    end_op();
    80004da4:	fffff097          	auipc	ra,0xfffff
    80004da8:	8be080e7          	jalr	-1858(ra) # 80003662 <end_op>
    return -1;
    80004dac:	54fd                	li	s1,-1
    80004dae:	790a                	ld	s2,160(sp)
    80004db0:	69ea                	ld	s3,152(sp)
    80004db2:	b785                	j	80004d12 <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004db4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004db8:	04691783          	lh	a5,70(s2)
    80004dbc:	02f99223          	sh	a5,36(s3)
    80004dc0:	b739                	j	80004cce <sys_open+0xa2>
    itrunc(ip);
    80004dc2:	854a                	mv	a0,s2
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	f64080e7          	jalr	-156(ra) # 80002d28 <itrunc>
    80004dcc:	bf05                	j	80004cfc <sys_open+0xd0>

0000000080004dce <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dce:	7175                	add	sp,sp,-144
    80004dd0:	e506                	sd	ra,136(sp)
    80004dd2:	e122                	sd	s0,128(sp)
    80004dd4:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dd6:	fffff097          	auipc	ra,0xfffff
    80004dda:	812080e7          	jalr	-2030(ra) # 800035e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dde:	08000613          	li	a2,128
    80004de2:	f7040593          	add	a1,s0,-144
    80004de6:	4501                	li	a0,0
    80004de8:	ffffd097          	auipc	ra,0xffffd
    80004dec:	252080e7          	jalr	594(ra) # 8000203a <argstr>
    80004df0:	02054963          	bltz	a0,80004e22 <sys_mkdir+0x54>
    80004df4:	4681                	li	a3,0
    80004df6:	4601                	li	a2,0
    80004df8:	4585                	li	a1,1
    80004dfa:	f7040513          	add	a0,s0,-144
    80004dfe:	fffff097          	auipc	ra,0xfffff
    80004e02:	7d8080e7          	jalr	2008(ra) # 800045d6 <create>
    80004e06:	cd11                	beqz	a0,80004e22 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e08:	ffffe097          	auipc	ra,0xffffe
    80004e0c:	074080e7          	jalr	116(ra) # 80002e7c <iunlockput>
  end_op();
    80004e10:	fffff097          	auipc	ra,0xfffff
    80004e14:	852080e7          	jalr	-1966(ra) # 80003662 <end_op>
  return 0;
    80004e18:	4501                	li	a0,0
}
    80004e1a:	60aa                	ld	ra,136(sp)
    80004e1c:	640a                	ld	s0,128(sp)
    80004e1e:	6149                	add	sp,sp,144
    80004e20:	8082                	ret
    end_op();
    80004e22:	fffff097          	auipc	ra,0xfffff
    80004e26:	840080e7          	jalr	-1984(ra) # 80003662 <end_op>
    return -1;
    80004e2a:	557d                	li	a0,-1
    80004e2c:	b7fd                	j	80004e1a <sys_mkdir+0x4c>

0000000080004e2e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e2e:	7135                	add	sp,sp,-160
    80004e30:	ed06                	sd	ra,152(sp)
    80004e32:	e922                	sd	s0,144(sp)
    80004e34:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	7b2080e7          	jalr	1970(ra) # 800035e8 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e3e:	08000613          	li	a2,128
    80004e42:	f7040593          	add	a1,s0,-144
    80004e46:	4501                	li	a0,0
    80004e48:	ffffd097          	auipc	ra,0xffffd
    80004e4c:	1f2080e7          	jalr	498(ra) # 8000203a <argstr>
    80004e50:	04054a63          	bltz	a0,80004ea4 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e54:	f6c40593          	add	a1,s0,-148
    80004e58:	4505                	li	a0,1
    80004e5a:	ffffd097          	auipc	ra,0xffffd
    80004e5e:	19c080e7          	jalr	412(ra) # 80001ff6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e62:	04054163          	bltz	a0,80004ea4 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e66:	f6840593          	add	a1,s0,-152
    80004e6a:	4509                	li	a0,2
    80004e6c:	ffffd097          	auipc	ra,0xffffd
    80004e70:	18a080e7          	jalr	394(ra) # 80001ff6 <argint>
     argint(1, &major) < 0 ||
    80004e74:	02054863          	bltz	a0,80004ea4 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e78:	f6841683          	lh	a3,-152(s0)
    80004e7c:	f6c41603          	lh	a2,-148(s0)
    80004e80:	458d                	li	a1,3
    80004e82:	f7040513          	add	a0,s0,-144
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	750080e7          	jalr	1872(ra) # 800045d6 <create>
     argint(2, &minor) < 0 ||
    80004e8e:	c919                	beqz	a0,80004ea4 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e90:	ffffe097          	auipc	ra,0xffffe
    80004e94:	fec080e7          	jalr	-20(ra) # 80002e7c <iunlockput>
  end_op();
    80004e98:	ffffe097          	auipc	ra,0xffffe
    80004e9c:	7ca080e7          	jalr	1994(ra) # 80003662 <end_op>
  return 0;
    80004ea0:	4501                	li	a0,0
    80004ea2:	a031                	j	80004eae <sys_mknod+0x80>
    end_op();
    80004ea4:	ffffe097          	auipc	ra,0xffffe
    80004ea8:	7be080e7          	jalr	1982(ra) # 80003662 <end_op>
    return -1;
    80004eac:	557d                	li	a0,-1
}
    80004eae:	60ea                	ld	ra,152(sp)
    80004eb0:	644a                	ld	s0,144(sp)
    80004eb2:	610d                	add	sp,sp,160
    80004eb4:	8082                	ret

0000000080004eb6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004eb6:	7135                	add	sp,sp,-160
    80004eb8:	ed06                	sd	ra,152(sp)
    80004eba:	e922                	sd	s0,144(sp)
    80004ebc:	e14a                	sd	s2,128(sp)
    80004ebe:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ec0:	ffffc097          	auipc	ra,0xffffc
    80004ec4:	fbc080e7          	jalr	-68(ra) # 80000e7c <myproc>
    80004ec8:	892a                	mv	s2,a0
  
  begin_op();
    80004eca:	ffffe097          	auipc	ra,0xffffe
    80004ece:	71e080e7          	jalr	1822(ra) # 800035e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ed2:	08000613          	li	a2,128
    80004ed6:	f6040593          	add	a1,s0,-160
    80004eda:	4501                	li	a0,0
    80004edc:	ffffd097          	auipc	ra,0xffffd
    80004ee0:	15e080e7          	jalr	350(ra) # 8000203a <argstr>
    80004ee4:	04054d63          	bltz	a0,80004f3e <sys_chdir+0x88>
    80004ee8:	e526                	sd	s1,136(sp)
    80004eea:	f6040513          	add	a0,s0,-160
    80004eee:	ffffe097          	auipc	ra,0xffffe
    80004ef2:	4fa080e7          	jalr	1274(ra) # 800033e8 <namei>
    80004ef6:	84aa                	mv	s1,a0
    80004ef8:	c131                	beqz	a0,80004f3c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004efa:	ffffe097          	auipc	ra,0xffffe
    80004efe:	d1c080e7          	jalr	-740(ra) # 80002c16 <ilock>
  if(ip->type != T_DIR){
    80004f02:	04449703          	lh	a4,68(s1)
    80004f06:	4785                	li	a5,1
    80004f08:	04f71163          	bne	a4,a5,80004f4a <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f0c:	8526                	mv	a0,s1
    80004f0e:	ffffe097          	auipc	ra,0xffffe
    80004f12:	dce080e7          	jalr	-562(ra) # 80002cdc <iunlock>
  iput(p->cwd);
    80004f16:	15093503          	ld	a0,336(s2)
    80004f1a:	ffffe097          	auipc	ra,0xffffe
    80004f1e:	eba080e7          	jalr	-326(ra) # 80002dd4 <iput>
  end_op();
    80004f22:	ffffe097          	auipc	ra,0xffffe
    80004f26:	740080e7          	jalr	1856(ra) # 80003662 <end_op>
  p->cwd = ip;
    80004f2a:	14993823          	sd	s1,336(s2)
  return 0;
    80004f2e:	4501                	li	a0,0
    80004f30:	64aa                	ld	s1,136(sp)
}
    80004f32:	60ea                	ld	ra,152(sp)
    80004f34:	644a                	ld	s0,144(sp)
    80004f36:	690a                	ld	s2,128(sp)
    80004f38:	610d                	add	sp,sp,160
    80004f3a:	8082                	ret
    80004f3c:	64aa                	ld	s1,136(sp)
    end_op();
    80004f3e:	ffffe097          	auipc	ra,0xffffe
    80004f42:	724080e7          	jalr	1828(ra) # 80003662 <end_op>
    return -1;
    80004f46:	557d                	li	a0,-1
    80004f48:	b7ed                	j	80004f32 <sys_chdir+0x7c>
    iunlockput(ip);
    80004f4a:	8526                	mv	a0,s1
    80004f4c:	ffffe097          	auipc	ra,0xffffe
    80004f50:	f30080e7          	jalr	-208(ra) # 80002e7c <iunlockput>
    end_op();
    80004f54:	ffffe097          	auipc	ra,0xffffe
    80004f58:	70e080e7          	jalr	1806(ra) # 80003662 <end_op>
    return -1;
    80004f5c:	557d                	li	a0,-1
    80004f5e:	64aa                	ld	s1,136(sp)
    80004f60:	bfc9                	j	80004f32 <sys_chdir+0x7c>

0000000080004f62 <sys_exec>:

uint64
sys_exec(void)
{
    80004f62:	7121                	add	sp,sp,-448
    80004f64:	ff06                	sd	ra,440(sp)
    80004f66:	fb22                	sd	s0,432(sp)
    80004f68:	f34a                	sd	s2,416(sp)
    80004f6a:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f6c:	08000613          	li	a2,128
    80004f70:	f5040593          	add	a1,s0,-176
    80004f74:	4501                	li	a0,0
    80004f76:	ffffd097          	auipc	ra,0xffffd
    80004f7a:	0c4080e7          	jalr	196(ra) # 8000203a <argstr>
    return -1;
    80004f7e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f80:	0e054a63          	bltz	a0,80005074 <sys_exec+0x112>
    80004f84:	e4840593          	add	a1,s0,-440
    80004f88:	4505                	li	a0,1
    80004f8a:	ffffd097          	auipc	ra,0xffffd
    80004f8e:	08e080e7          	jalr	142(ra) # 80002018 <argaddr>
    80004f92:	0e054163          	bltz	a0,80005074 <sys_exec+0x112>
    80004f96:	f726                	sd	s1,424(sp)
    80004f98:	ef4e                	sd	s3,408(sp)
    80004f9a:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004f9c:	10000613          	li	a2,256
    80004fa0:	4581                	li	a1,0
    80004fa2:	e5040513          	add	a0,s0,-432
    80004fa6:	ffffb097          	auipc	ra,0xffffb
    80004faa:	1d4080e7          	jalr	468(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fae:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004fb2:	89a6                	mv	s3,s1
    80004fb4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fb6:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fba:	00391513          	sll	a0,s2,0x3
    80004fbe:	e4040593          	add	a1,s0,-448
    80004fc2:	e4843783          	ld	a5,-440(s0)
    80004fc6:	953e                	add	a0,a0,a5
    80004fc8:	ffffd097          	auipc	ra,0xffffd
    80004fcc:	f94080e7          	jalr	-108(ra) # 80001f5c <fetchaddr>
    80004fd0:	02054a63          	bltz	a0,80005004 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004fd4:	e4043783          	ld	a5,-448(s0)
    80004fd8:	c7b1                	beqz	a5,80005024 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fda:	ffffb097          	auipc	ra,0xffffb
    80004fde:	140080e7          	jalr	320(ra) # 8000011a <kalloc>
    80004fe2:	85aa                	mv	a1,a0
    80004fe4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fe8:	cd11                	beqz	a0,80005004 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fea:	6605                	lui	a2,0x1
    80004fec:	e4043503          	ld	a0,-448(s0)
    80004ff0:	ffffd097          	auipc	ra,0xffffd
    80004ff4:	fbe080e7          	jalr	-66(ra) # 80001fae <fetchstr>
    80004ff8:	00054663          	bltz	a0,80005004 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80004ffc:	0905                	add	s2,s2,1
    80004ffe:	09a1                	add	s3,s3,8
    80005000:	fb491de3          	bne	s2,s4,80004fba <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005004:	f5040913          	add	s2,s0,-176
    80005008:	6088                	ld	a0,0(s1)
    8000500a:	c12d                	beqz	a0,8000506c <sys_exec+0x10a>
    kfree(argv[i]);
    8000500c:	ffffb097          	auipc	ra,0xffffb
    80005010:	010080e7          	jalr	16(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005014:	04a1                	add	s1,s1,8
    80005016:	ff2499e3          	bne	s1,s2,80005008 <sys_exec+0xa6>
  return -1;
    8000501a:	597d                	li	s2,-1
    8000501c:	74ba                	ld	s1,424(sp)
    8000501e:	69fa                	ld	s3,408(sp)
    80005020:	6a5a                	ld	s4,400(sp)
    80005022:	a889                	j	80005074 <sys_exec+0x112>
      argv[i] = 0;
    80005024:	0009079b          	sext.w	a5,s2
    80005028:	078e                	sll	a5,a5,0x3
    8000502a:	fd078793          	add	a5,a5,-48
    8000502e:	97a2                	add	a5,a5,s0
    80005030:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005034:	e5040593          	add	a1,s0,-432
    80005038:	f5040513          	add	a0,s0,-176
    8000503c:	fffff097          	auipc	ra,0xfffff
    80005040:	126080e7          	jalr	294(ra) # 80004162 <exec>
    80005044:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005046:	f5040993          	add	s3,s0,-176
    8000504a:	6088                	ld	a0,0(s1)
    8000504c:	cd01                	beqz	a0,80005064 <sys_exec+0x102>
    kfree(argv[i]);
    8000504e:	ffffb097          	auipc	ra,0xffffb
    80005052:	fce080e7          	jalr	-50(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005056:	04a1                	add	s1,s1,8
    80005058:	ff3499e3          	bne	s1,s3,8000504a <sys_exec+0xe8>
    8000505c:	74ba                	ld	s1,424(sp)
    8000505e:	69fa                	ld	s3,408(sp)
    80005060:	6a5a                	ld	s4,400(sp)
    80005062:	a809                	j	80005074 <sys_exec+0x112>
  return ret;
    80005064:	74ba                	ld	s1,424(sp)
    80005066:	69fa                	ld	s3,408(sp)
    80005068:	6a5a                	ld	s4,400(sp)
    8000506a:	a029                	j	80005074 <sys_exec+0x112>
  return -1;
    8000506c:	597d                	li	s2,-1
    8000506e:	74ba                	ld	s1,424(sp)
    80005070:	69fa                	ld	s3,408(sp)
    80005072:	6a5a                	ld	s4,400(sp)
}
    80005074:	854a                	mv	a0,s2
    80005076:	70fa                	ld	ra,440(sp)
    80005078:	745a                	ld	s0,432(sp)
    8000507a:	791a                	ld	s2,416(sp)
    8000507c:	6139                	add	sp,sp,448
    8000507e:	8082                	ret

0000000080005080 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005080:	7139                	add	sp,sp,-64
    80005082:	fc06                	sd	ra,56(sp)
    80005084:	f822                	sd	s0,48(sp)
    80005086:	f426                	sd	s1,40(sp)
    80005088:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000508a:	ffffc097          	auipc	ra,0xffffc
    8000508e:	df2080e7          	jalr	-526(ra) # 80000e7c <myproc>
    80005092:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005094:	fd840593          	add	a1,s0,-40
    80005098:	4501                	li	a0,0
    8000509a:	ffffd097          	auipc	ra,0xffffd
    8000509e:	f7e080e7          	jalr	-130(ra) # 80002018 <argaddr>
    return -1;
    800050a2:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050a4:	0e054063          	bltz	a0,80005184 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050a8:	fc840593          	add	a1,s0,-56
    800050ac:	fd040513          	add	a0,s0,-48
    800050b0:	fffff097          	auipc	ra,0xfffff
    800050b4:	d70080e7          	jalr	-656(ra) # 80003e20 <pipealloc>
    return -1;
    800050b8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050ba:	0c054563          	bltz	a0,80005184 <sys_pipe+0x104>
  fd0 = -1;
    800050be:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050c2:	fd043503          	ld	a0,-48(s0)
    800050c6:	fffff097          	auipc	ra,0xfffff
    800050ca:	4ce080e7          	jalr	1230(ra) # 80004594 <fdalloc>
    800050ce:	fca42223          	sw	a0,-60(s0)
    800050d2:	08054c63          	bltz	a0,8000516a <sys_pipe+0xea>
    800050d6:	fc843503          	ld	a0,-56(s0)
    800050da:	fffff097          	auipc	ra,0xfffff
    800050de:	4ba080e7          	jalr	1210(ra) # 80004594 <fdalloc>
    800050e2:	fca42023          	sw	a0,-64(s0)
    800050e6:	06054963          	bltz	a0,80005158 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ea:	4691                	li	a3,4
    800050ec:	fc440613          	add	a2,s0,-60
    800050f0:	fd843583          	ld	a1,-40(s0)
    800050f4:	68a8                	ld	a0,80(s1)
    800050f6:	ffffc097          	auipc	ra,0xffffc
    800050fa:	a22080e7          	jalr	-1502(ra) # 80000b18 <copyout>
    800050fe:	02054063          	bltz	a0,8000511e <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005102:	4691                	li	a3,4
    80005104:	fc040613          	add	a2,s0,-64
    80005108:	fd843583          	ld	a1,-40(s0)
    8000510c:	0591                	add	a1,a1,4
    8000510e:	68a8                	ld	a0,80(s1)
    80005110:	ffffc097          	auipc	ra,0xffffc
    80005114:	a08080e7          	jalr	-1528(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005118:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000511a:	06055563          	bgez	a0,80005184 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000511e:	fc442783          	lw	a5,-60(s0)
    80005122:	07e9                	add	a5,a5,26
    80005124:	078e                	sll	a5,a5,0x3
    80005126:	97a6                	add	a5,a5,s1
    80005128:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000512c:	fc042783          	lw	a5,-64(s0)
    80005130:	07e9                	add	a5,a5,26
    80005132:	078e                	sll	a5,a5,0x3
    80005134:	00f48533          	add	a0,s1,a5
    80005138:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000513c:	fd043503          	ld	a0,-48(s0)
    80005140:	fffff097          	auipc	ra,0xfffff
    80005144:	972080e7          	jalr	-1678(ra) # 80003ab2 <fileclose>
    fileclose(wf);
    80005148:	fc843503          	ld	a0,-56(s0)
    8000514c:	fffff097          	auipc	ra,0xfffff
    80005150:	966080e7          	jalr	-1690(ra) # 80003ab2 <fileclose>
    return -1;
    80005154:	57fd                	li	a5,-1
    80005156:	a03d                	j	80005184 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005158:	fc442783          	lw	a5,-60(s0)
    8000515c:	0007c763          	bltz	a5,8000516a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005160:	07e9                	add	a5,a5,26
    80005162:	078e                	sll	a5,a5,0x3
    80005164:	97a6                	add	a5,a5,s1
    80005166:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000516a:	fd043503          	ld	a0,-48(s0)
    8000516e:	fffff097          	auipc	ra,0xfffff
    80005172:	944080e7          	jalr	-1724(ra) # 80003ab2 <fileclose>
    fileclose(wf);
    80005176:	fc843503          	ld	a0,-56(s0)
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	938080e7          	jalr	-1736(ra) # 80003ab2 <fileclose>
    return -1;
    80005182:	57fd                	li	a5,-1
}
    80005184:	853e                	mv	a0,a5
    80005186:	70e2                	ld	ra,56(sp)
    80005188:	7442                	ld	s0,48(sp)
    8000518a:	74a2                	ld	s1,40(sp)
    8000518c:	6121                	add	sp,sp,64
    8000518e:	8082                	ret

0000000080005190 <kernelvec>:
    80005190:	7111                	add	sp,sp,-256
    80005192:	e006                	sd	ra,0(sp)
    80005194:	e40a                	sd	sp,8(sp)
    80005196:	e80e                	sd	gp,16(sp)
    80005198:	ec12                	sd	tp,24(sp)
    8000519a:	f016                	sd	t0,32(sp)
    8000519c:	f41a                	sd	t1,40(sp)
    8000519e:	f81e                	sd	t2,48(sp)
    800051a0:	fc22                	sd	s0,56(sp)
    800051a2:	e0a6                	sd	s1,64(sp)
    800051a4:	e4aa                	sd	a0,72(sp)
    800051a6:	e8ae                	sd	a1,80(sp)
    800051a8:	ecb2                	sd	a2,88(sp)
    800051aa:	f0b6                	sd	a3,96(sp)
    800051ac:	f4ba                	sd	a4,104(sp)
    800051ae:	f8be                	sd	a5,112(sp)
    800051b0:	fcc2                	sd	a6,120(sp)
    800051b2:	e146                	sd	a7,128(sp)
    800051b4:	e54a                	sd	s2,136(sp)
    800051b6:	e94e                	sd	s3,144(sp)
    800051b8:	ed52                	sd	s4,152(sp)
    800051ba:	f156                	sd	s5,160(sp)
    800051bc:	f55a                	sd	s6,168(sp)
    800051be:	f95e                	sd	s7,176(sp)
    800051c0:	fd62                	sd	s8,184(sp)
    800051c2:	e1e6                	sd	s9,192(sp)
    800051c4:	e5ea                	sd	s10,200(sp)
    800051c6:	e9ee                	sd	s11,208(sp)
    800051c8:	edf2                	sd	t3,216(sp)
    800051ca:	f1f6                	sd	t4,224(sp)
    800051cc:	f5fa                	sd	t5,232(sp)
    800051ce:	f9fe                	sd	t6,240(sp)
    800051d0:	c59fc0ef          	jal	80001e28 <kerneltrap>
    800051d4:	6082                	ld	ra,0(sp)
    800051d6:	6122                	ld	sp,8(sp)
    800051d8:	61c2                	ld	gp,16(sp)
    800051da:	7282                	ld	t0,32(sp)
    800051dc:	7322                	ld	t1,40(sp)
    800051de:	73c2                	ld	t2,48(sp)
    800051e0:	7462                	ld	s0,56(sp)
    800051e2:	6486                	ld	s1,64(sp)
    800051e4:	6526                	ld	a0,72(sp)
    800051e6:	65c6                	ld	a1,80(sp)
    800051e8:	6666                	ld	a2,88(sp)
    800051ea:	7686                	ld	a3,96(sp)
    800051ec:	7726                	ld	a4,104(sp)
    800051ee:	77c6                	ld	a5,112(sp)
    800051f0:	7866                	ld	a6,120(sp)
    800051f2:	688a                	ld	a7,128(sp)
    800051f4:	692a                	ld	s2,136(sp)
    800051f6:	69ca                	ld	s3,144(sp)
    800051f8:	6a6a                	ld	s4,152(sp)
    800051fa:	7a8a                	ld	s5,160(sp)
    800051fc:	7b2a                	ld	s6,168(sp)
    800051fe:	7bca                	ld	s7,176(sp)
    80005200:	7c6a                	ld	s8,184(sp)
    80005202:	6c8e                	ld	s9,192(sp)
    80005204:	6d2e                	ld	s10,200(sp)
    80005206:	6dce                	ld	s11,208(sp)
    80005208:	6e6e                	ld	t3,216(sp)
    8000520a:	7e8e                	ld	t4,224(sp)
    8000520c:	7f2e                	ld	t5,232(sp)
    8000520e:	7fce                	ld	t6,240(sp)
    80005210:	6111                	add	sp,sp,256
    80005212:	10200073          	sret
    80005216:	00000013          	nop
    8000521a:	00000013          	nop
    8000521e:	0001                	nop

0000000080005220 <timervec>:
    80005220:	34051573          	csrrw	a0,mscratch,a0
    80005224:	e10c                	sd	a1,0(a0)
    80005226:	e510                	sd	a2,8(a0)
    80005228:	e914                	sd	a3,16(a0)
    8000522a:	6d0c                	ld	a1,24(a0)
    8000522c:	7110                	ld	a2,32(a0)
    8000522e:	6194                	ld	a3,0(a1)
    80005230:	96b2                	add	a3,a3,a2
    80005232:	e194                	sd	a3,0(a1)
    80005234:	4589                	li	a1,2
    80005236:	14459073          	csrw	sip,a1
    8000523a:	6914                	ld	a3,16(a0)
    8000523c:	6510                	ld	a2,8(a0)
    8000523e:	610c                	ld	a1,0(a0)
    80005240:	34051573          	csrrw	a0,mscratch,a0
    80005244:	30200073          	mret
	...

000000008000524a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000524a:	1141                	add	sp,sp,-16
    8000524c:	e422                	sd	s0,8(sp)
    8000524e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005250:	0c0007b7          	lui	a5,0xc000
    80005254:	4705                	li	a4,1
    80005256:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005258:	0c0007b7          	lui	a5,0xc000
    8000525c:	c3d8                	sw	a4,4(a5)
}
    8000525e:	6422                	ld	s0,8(sp)
    80005260:	0141                	add	sp,sp,16
    80005262:	8082                	ret

0000000080005264 <plicinithart>:

void
plicinithart(void)
{
    80005264:	1141                	add	sp,sp,-16
    80005266:	e406                	sd	ra,8(sp)
    80005268:	e022                	sd	s0,0(sp)
    8000526a:	0800                	add	s0,sp,16
  int hart = cpuid();
    8000526c:	ffffc097          	auipc	ra,0xffffc
    80005270:	be4080e7          	jalr	-1052(ra) # 80000e50 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005274:	0085171b          	sllw	a4,a0,0x8
    80005278:	0c0027b7          	lui	a5,0xc002
    8000527c:	97ba                	add	a5,a5,a4
    8000527e:	40200713          	li	a4,1026
    80005282:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005286:	00d5151b          	sllw	a0,a0,0xd
    8000528a:	0c2017b7          	lui	a5,0xc201
    8000528e:	97aa                	add	a5,a5,a0
    80005290:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005294:	60a2                	ld	ra,8(sp)
    80005296:	6402                	ld	s0,0(sp)
    80005298:	0141                	add	sp,sp,16
    8000529a:	8082                	ret

000000008000529c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000529c:	1141                	add	sp,sp,-16
    8000529e:	e406                	sd	ra,8(sp)
    800052a0:	e022                	sd	s0,0(sp)
    800052a2:	0800                	add	s0,sp,16
  int hart = cpuid();
    800052a4:	ffffc097          	auipc	ra,0xffffc
    800052a8:	bac080e7          	jalr	-1108(ra) # 80000e50 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052ac:	00d5151b          	sllw	a0,a0,0xd
    800052b0:	0c2017b7          	lui	a5,0xc201
    800052b4:	97aa                	add	a5,a5,a0
  return irq;
}
    800052b6:	43c8                	lw	a0,4(a5)
    800052b8:	60a2                	ld	ra,8(sp)
    800052ba:	6402                	ld	s0,0(sp)
    800052bc:	0141                	add	sp,sp,16
    800052be:	8082                	ret

00000000800052c0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052c0:	1101                	add	sp,sp,-32
    800052c2:	ec06                	sd	ra,24(sp)
    800052c4:	e822                	sd	s0,16(sp)
    800052c6:	e426                	sd	s1,8(sp)
    800052c8:	1000                	add	s0,sp,32
    800052ca:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052cc:	ffffc097          	auipc	ra,0xffffc
    800052d0:	b84080e7          	jalr	-1148(ra) # 80000e50 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052d4:	00d5151b          	sllw	a0,a0,0xd
    800052d8:	0c2017b7          	lui	a5,0xc201
    800052dc:	97aa                	add	a5,a5,a0
    800052de:	c3c4                	sw	s1,4(a5)
}
    800052e0:	60e2                	ld	ra,24(sp)
    800052e2:	6442                	ld	s0,16(sp)
    800052e4:	64a2                	ld	s1,8(sp)
    800052e6:	6105                	add	sp,sp,32
    800052e8:	8082                	ret

00000000800052ea <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052ea:	1141                	add	sp,sp,-16
    800052ec:	e406                	sd	ra,8(sp)
    800052ee:	e022                	sd	s0,0(sp)
    800052f0:	0800                	add	s0,sp,16
  if(i >= NUM)
    800052f2:	479d                	li	a5,7
    800052f4:	06a7c863          	blt	a5,a0,80005364 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800052f8:	00016717          	auipc	a4,0x16
    800052fc:	d0870713          	add	a4,a4,-760 # 8001b000 <disk>
    80005300:	972a                	add	a4,a4,a0
    80005302:	6789                	lui	a5,0x2
    80005304:	97ba                	add	a5,a5,a4
    80005306:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000530a:	e7ad                	bnez	a5,80005374 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000530c:	00451793          	sll	a5,a0,0x4
    80005310:	00018717          	auipc	a4,0x18
    80005314:	cf070713          	add	a4,a4,-784 # 8001d000 <disk+0x2000>
    80005318:	6314                	ld	a3,0(a4)
    8000531a:	96be                	add	a3,a3,a5
    8000531c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005320:	6314                	ld	a3,0(a4)
    80005322:	96be                	add	a3,a3,a5
    80005324:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005328:	6314                	ld	a3,0(a4)
    8000532a:	96be                	add	a3,a3,a5
    8000532c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005330:	6318                	ld	a4,0(a4)
    80005332:	97ba                	add	a5,a5,a4
    80005334:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005338:	00016717          	auipc	a4,0x16
    8000533c:	cc870713          	add	a4,a4,-824 # 8001b000 <disk>
    80005340:	972a                	add	a4,a4,a0
    80005342:	6789                	lui	a5,0x2
    80005344:	97ba                	add	a5,a5,a4
    80005346:	4705                	li	a4,1
    80005348:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000534c:	00018517          	auipc	a0,0x18
    80005350:	ccc50513          	add	a0,a0,-820 # 8001d018 <disk+0x2018>
    80005354:	ffffc097          	auipc	ra,0xffffc
    80005358:	3d4080e7          	jalr	980(ra) # 80001728 <wakeup>
}
    8000535c:	60a2                	ld	ra,8(sp)
    8000535e:	6402                	ld	s0,0(sp)
    80005360:	0141                	add	sp,sp,16
    80005362:	8082                	ret
    panic("free_desc 1");
    80005364:	00003517          	auipc	a0,0x3
    80005368:	28c50513          	add	a0,a0,652 # 800085f0 <etext+0x5f0>
    8000536c:	00001097          	auipc	ra,0x1
    80005370:	a10080e7          	jalr	-1520(ra) # 80005d7c <panic>
    panic("free_desc 2");
    80005374:	00003517          	auipc	a0,0x3
    80005378:	28c50513          	add	a0,a0,652 # 80008600 <etext+0x600>
    8000537c:	00001097          	auipc	ra,0x1
    80005380:	a00080e7          	jalr	-1536(ra) # 80005d7c <panic>

0000000080005384 <virtio_disk_init>:
{
    80005384:	1141                	add	sp,sp,-16
    80005386:	e406                	sd	ra,8(sp)
    80005388:	e022                	sd	s0,0(sp)
    8000538a:	0800                	add	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000538c:	00003597          	auipc	a1,0x3
    80005390:	28458593          	add	a1,a1,644 # 80008610 <etext+0x610>
    80005394:	00018517          	auipc	a0,0x18
    80005398:	d9450513          	add	a0,a0,-620 # 8001d128 <disk+0x2128>
    8000539c:	00001097          	auipc	ra,0x1
    800053a0:	f26080e7          	jalr	-218(ra) # 800062c2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053a4:	100017b7          	lui	a5,0x10001
    800053a8:	4398                	lw	a4,0(a5)
    800053aa:	2701                	sext.w	a4,a4
    800053ac:	747277b7          	lui	a5,0x74727
    800053b0:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053b4:	0ef71f63          	bne	a4,a5,800054b2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053b8:	100017b7          	lui	a5,0x10001
    800053bc:	0791                	add	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800053be:	439c                	lw	a5,0(a5)
    800053c0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053c2:	4705                	li	a4,1
    800053c4:	0ee79763          	bne	a5,a4,800054b2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053c8:	100017b7          	lui	a5,0x10001
    800053cc:	07a1                	add	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800053ce:	439c                	lw	a5,0(a5)
    800053d0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053d2:	4709                	li	a4,2
    800053d4:	0ce79f63          	bne	a5,a4,800054b2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053d8:	100017b7          	lui	a5,0x10001
    800053dc:	47d8                	lw	a4,12(a5)
    800053de:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053e0:	554d47b7          	lui	a5,0x554d4
    800053e4:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053e8:	0cf71563          	bne	a4,a5,800054b2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ec:	100017b7          	lui	a5,0x10001
    800053f0:	4705                	li	a4,1
    800053f2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f4:	470d                	li	a4,3
    800053f6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053f8:	10001737          	lui	a4,0x10001
    800053fc:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053fe:	c7ffe737          	lui	a4,0xc7ffe
    80005402:	75f70713          	add	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005406:	8ef9                	and	a3,a3,a4
    80005408:	10001737          	lui	a4,0x10001
    8000540c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000540e:	472d                	li	a4,11
    80005410:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005412:	473d                	li	a4,15
    80005414:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005416:	100017b7          	lui	a5,0x10001
    8000541a:	6705                	lui	a4,0x1
    8000541c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000541e:	100017b7          	lui	a5,0x10001
    80005422:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005426:	100017b7          	lui	a5,0x10001
    8000542a:	03478793          	add	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000542e:	439c                	lw	a5,0(a5)
    80005430:	2781                	sext.w	a5,a5
  if(max == 0)
    80005432:	cbc1                	beqz	a5,800054c2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005434:	471d                	li	a4,7
    80005436:	08f77e63          	bgeu	a4,a5,800054d2 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000543a:	100017b7          	lui	a5,0x10001
    8000543e:	4721                	li	a4,8
    80005440:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005442:	6609                	lui	a2,0x2
    80005444:	4581                	li	a1,0
    80005446:	00016517          	auipc	a0,0x16
    8000544a:	bba50513          	add	a0,a0,-1094 # 8001b000 <disk>
    8000544e:	ffffb097          	auipc	ra,0xffffb
    80005452:	d2c080e7          	jalr	-724(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005456:	00016697          	auipc	a3,0x16
    8000545a:	baa68693          	add	a3,a3,-1110 # 8001b000 <disk>
    8000545e:	00c6d713          	srl	a4,a3,0xc
    80005462:	2701                	sext.w	a4,a4
    80005464:	100017b7          	lui	a5,0x10001
    80005468:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000546a:	00018797          	auipc	a5,0x18
    8000546e:	b9678793          	add	a5,a5,-1130 # 8001d000 <disk+0x2000>
    80005472:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005474:	00016717          	auipc	a4,0x16
    80005478:	c0c70713          	add	a4,a4,-1012 # 8001b080 <disk+0x80>
    8000547c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000547e:	00017717          	auipc	a4,0x17
    80005482:	b8270713          	add	a4,a4,-1150 # 8001c000 <disk+0x1000>
    80005486:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005488:	4705                	li	a4,1
    8000548a:	00e78c23          	sb	a4,24(a5)
    8000548e:	00e78ca3          	sb	a4,25(a5)
    80005492:	00e78d23          	sb	a4,26(a5)
    80005496:	00e78da3          	sb	a4,27(a5)
    8000549a:	00e78e23          	sb	a4,28(a5)
    8000549e:	00e78ea3          	sb	a4,29(a5)
    800054a2:	00e78f23          	sb	a4,30(a5)
    800054a6:	00e78fa3          	sb	a4,31(a5)
}
    800054aa:	60a2                	ld	ra,8(sp)
    800054ac:	6402                	ld	s0,0(sp)
    800054ae:	0141                	add	sp,sp,16
    800054b0:	8082                	ret
    panic("could not find virtio disk");
    800054b2:	00003517          	auipc	a0,0x3
    800054b6:	16e50513          	add	a0,a0,366 # 80008620 <etext+0x620>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	8c2080e7          	jalr	-1854(ra) # 80005d7c <panic>
    panic("virtio disk has no queue 0");
    800054c2:	00003517          	auipc	a0,0x3
    800054c6:	17e50513          	add	a0,a0,382 # 80008640 <etext+0x640>
    800054ca:	00001097          	auipc	ra,0x1
    800054ce:	8b2080e7          	jalr	-1870(ra) # 80005d7c <panic>
    panic("virtio disk max queue too short");
    800054d2:	00003517          	auipc	a0,0x3
    800054d6:	18e50513          	add	a0,a0,398 # 80008660 <etext+0x660>
    800054da:	00001097          	auipc	ra,0x1
    800054de:	8a2080e7          	jalr	-1886(ra) # 80005d7c <panic>

00000000800054e2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054e2:	7159                	add	sp,sp,-112
    800054e4:	f486                	sd	ra,104(sp)
    800054e6:	f0a2                	sd	s0,96(sp)
    800054e8:	eca6                	sd	s1,88(sp)
    800054ea:	e8ca                	sd	s2,80(sp)
    800054ec:	e4ce                	sd	s3,72(sp)
    800054ee:	e0d2                	sd	s4,64(sp)
    800054f0:	fc56                	sd	s5,56(sp)
    800054f2:	f85a                	sd	s6,48(sp)
    800054f4:	f45e                	sd	s7,40(sp)
    800054f6:	f062                	sd	s8,32(sp)
    800054f8:	ec66                	sd	s9,24(sp)
    800054fa:	1880                	add	s0,sp,112
    800054fc:	8a2a                	mv	s4,a0
    800054fe:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005500:	00c52c03          	lw	s8,12(a0)
    80005504:	001c1c1b          	sllw	s8,s8,0x1
    80005508:	1c02                	sll	s8,s8,0x20
    8000550a:	020c5c13          	srl	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000550e:	00018517          	auipc	a0,0x18
    80005512:	c1a50513          	add	a0,a0,-998 # 8001d128 <disk+0x2128>
    80005516:	00001097          	auipc	ra,0x1
    8000551a:	e3c080e7          	jalr	-452(ra) # 80006352 <acquire>
  for(int i = 0; i < 3; i++){
    8000551e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005520:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005522:	00016b97          	auipc	s7,0x16
    80005526:	adeb8b93          	add	s7,s7,-1314 # 8001b000 <disk>
    8000552a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000552c:	4a8d                	li	s5,3
    8000552e:	a88d                	j	800055a0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005530:	00fb8733          	add	a4,s7,a5
    80005534:	975a                	add	a4,a4,s6
    80005536:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000553a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000553c:	0207c563          	bltz	a5,80005566 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005540:	2905                	addw	s2,s2,1
    80005542:	0611                	add	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005544:	1b590163          	beq	s2,s5,800056e6 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005548:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000554a:	00018717          	auipc	a4,0x18
    8000554e:	ace70713          	add	a4,a4,-1330 # 8001d018 <disk+0x2018>
    80005552:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005554:	00074683          	lbu	a3,0(a4)
    80005558:	fee1                	bnez	a3,80005530 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000555a:	2785                	addw	a5,a5,1
    8000555c:	0705                	add	a4,a4,1
    8000555e:	fe979be3          	bne	a5,s1,80005554 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005562:	57fd                	li	a5,-1
    80005564:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005566:	03205163          	blez	s2,80005588 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000556a:	f9042503          	lw	a0,-112(s0)
    8000556e:	00000097          	auipc	ra,0x0
    80005572:	d7c080e7          	jalr	-644(ra) # 800052ea <free_desc>
      for(int j = 0; j < i; j++)
    80005576:	4785                	li	a5,1
    80005578:	0127d863          	bge	a5,s2,80005588 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000557c:	f9442503          	lw	a0,-108(s0)
    80005580:	00000097          	auipc	ra,0x0
    80005584:	d6a080e7          	jalr	-662(ra) # 800052ea <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005588:	00018597          	auipc	a1,0x18
    8000558c:	ba058593          	add	a1,a1,-1120 # 8001d128 <disk+0x2128>
    80005590:	00018517          	auipc	a0,0x18
    80005594:	a8850513          	add	a0,a0,-1400 # 8001d018 <disk+0x2018>
    80005598:	ffffc097          	auipc	ra,0xffffc
    8000559c:	004080e7          	jalr	4(ra) # 8000159c <sleep>
  for(int i = 0; i < 3; i++){
    800055a0:	f9040613          	add	a2,s0,-112
    800055a4:	894e                	mv	s2,s3
    800055a6:	b74d                	j	80005548 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055a8:	00018717          	auipc	a4,0x18
    800055ac:	a5873703          	ld	a4,-1448(a4) # 8001d000 <disk+0x2000>
    800055b0:	973e                	add	a4,a4,a5
    800055b2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055b6:	00016897          	auipc	a7,0x16
    800055ba:	a4a88893          	add	a7,a7,-1462 # 8001b000 <disk>
    800055be:	00018717          	auipc	a4,0x18
    800055c2:	a4270713          	add	a4,a4,-1470 # 8001d000 <disk+0x2000>
    800055c6:	6314                	ld	a3,0(a4)
    800055c8:	96be                	add	a3,a3,a5
    800055ca:	00c6d583          	lhu	a1,12(a3)
    800055ce:	0015e593          	or	a1,a1,1
    800055d2:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055d6:	f9842683          	lw	a3,-104(s0)
    800055da:	630c                	ld	a1,0(a4)
    800055dc:	97ae                	add	a5,a5,a1
    800055de:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055e2:	20050593          	add	a1,a0,512
    800055e6:	0592                	sll	a1,a1,0x4
    800055e8:	95c6                	add	a1,a1,a7
    800055ea:	57fd                	li	a5,-1
    800055ec:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055f0:	00469793          	sll	a5,a3,0x4
    800055f4:	00073803          	ld	a6,0(a4)
    800055f8:	983e                	add	a6,a6,a5
    800055fa:	6689                	lui	a3,0x2
    800055fc:	03068693          	add	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005600:	96b2                	add	a3,a3,a2
    80005602:	96c6                	add	a3,a3,a7
    80005604:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005608:	6314                	ld	a3,0(a4)
    8000560a:	96be                	add	a3,a3,a5
    8000560c:	4605                	li	a2,1
    8000560e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005610:	6314                	ld	a3,0(a4)
    80005612:	96be                	add	a3,a3,a5
    80005614:	4809                	li	a6,2
    80005616:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000561a:	6314                	ld	a3,0(a4)
    8000561c:	97b6                	add	a5,a5,a3
    8000561e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005622:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005626:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000562a:	6714                	ld	a3,8(a4)
    8000562c:	0026d783          	lhu	a5,2(a3)
    80005630:	8b9d                	and	a5,a5,7
    80005632:	0786                	sll	a5,a5,0x1
    80005634:	96be                	add	a3,a3,a5
    80005636:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000563a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000563e:	6718                	ld	a4,8(a4)
    80005640:	00275783          	lhu	a5,2(a4)
    80005644:	2785                	addw	a5,a5,1
    80005646:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000564a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000564e:	100017b7          	lui	a5,0x10001
    80005652:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005656:	004a2783          	lw	a5,4(s4)
    8000565a:	02c79163          	bne	a5,a2,8000567c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000565e:	00018917          	auipc	s2,0x18
    80005662:	aca90913          	add	s2,s2,-1334 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005666:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005668:	85ca                	mv	a1,s2
    8000566a:	8552                	mv	a0,s4
    8000566c:	ffffc097          	auipc	ra,0xffffc
    80005670:	f30080e7          	jalr	-208(ra) # 8000159c <sleep>
  while(b->disk == 1) {
    80005674:	004a2783          	lw	a5,4(s4)
    80005678:	fe9788e3          	beq	a5,s1,80005668 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000567c:	f9042903          	lw	s2,-112(s0)
    80005680:	20090713          	add	a4,s2,512
    80005684:	0712                	sll	a4,a4,0x4
    80005686:	00016797          	auipc	a5,0x16
    8000568a:	97a78793          	add	a5,a5,-1670 # 8001b000 <disk>
    8000568e:	97ba                	add	a5,a5,a4
    80005690:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005694:	00018997          	auipc	s3,0x18
    80005698:	96c98993          	add	s3,s3,-1684 # 8001d000 <disk+0x2000>
    8000569c:	00491713          	sll	a4,s2,0x4
    800056a0:	0009b783          	ld	a5,0(s3)
    800056a4:	97ba                	add	a5,a5,a4
    800056a6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056aa:	854a                	mv	a0,s2
    800056ac:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056b0:	00000097          	auipc	ra,0x0
    800056b4:	c3a080e7          	jalr	-966(ra) # 800052ea <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056b8:	8885                	and	s1,s1,1
    800056ba:	f0ed                	bnez	s1,8000569c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056bc:	00018517          	auipc	a0,0x18
    800056c0:	a6c50513          	add	a0,a0,-1428 # 8001d128 <disk+0x2128>
    800056c4:	00001097          	auipc	ra,0x1
    800056c8:	d42080e7          	jalr	-702(ra) # 80006406 <release>
}
    800056cc:	70a6                	ld	ra,104(sp)
    800056ce:	7406                	ld	s0,96(sp)
    800056d0:	64e6                	ld	s1,88(sp)
    800056d2:	6946                	ld	s2,80(sp)
    800056d4:	69a6                	ld	s3,72(sp)
    800056d6:	6a06                	ld	s4,64(sp)
    800056d8:	7ae2                	ld	s5,56(sp)
    800056da:	7b42                	ld	s6,48(sp)
    800056dc:	7ba2                	ld	s7,40(sp)
    800056de:	7c02                	ld	s8,32(sp)
    800056e0:	6ce2                	ld	s9,24(sp)
    800056e2:	6165                	add	sp,sp,112
    800056e4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056e6:	f9042503          	lw	a0,-112(s0)
    800056ea:	00451613          	sll	a2,a0,0x4
  if(write)
    800056ee:	00016597          	auipc	a1,0x16
    800056f2:	91258593          	add	a1,a1,-1774 # 8001b000 <disk>
    800056f6:	20050793          	add	a5,a0,512
    800056fa:	0792                	sll	a5,a5,0x4
    800056fc:	97ae                	add	a5,a5,a1
    800056fe:	01903733          	snez	a4,s9
    80005702:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005706:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000570a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000570e:	00018717          	auipc	a4,0x18
    80005712:	8f270713          	add	a4,a4,-1806 # 8001d000 <disk+0x2000>
    80005716:	6314                	ld	a3,0(a4)
    80005718:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000571a:	6789                	lui	a5,0x2
    8000571c:	0a878793          	add	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005720:	97b2                	add	a5,a5,a2
    80005722:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005724:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005726:	631c                	ld	a5,0(a4)
    80005728:	97b2                	add	a5,a5,a2
    8000572a:	46c1                	li	a3,16
    8000572c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000572e:	631c                	ld	a5,0(a4)
    80005730:	97b2                	add	a5,a5,a2
    80005732:	4685                	li	a3,1
    80005734:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005738:	f9442783          	lw	a5,-108(s0)
    8000573c:	6314                	ld	a3,0(a4)
    8000573e:	96b2                	add	a3,a3,a2
    80005740:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005744:	0792                	sll	a5,a5,0x4
    80005746:	6314                	ld	a3,0(a4)
    80005748:	96be                	add	a3,a3,a5
    8000574a:	058a0593          	add	a1,s4,88
    8000574e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005750:	6318                	ld	a4,0(a4)
    80005752:	973e                	add	a4,a4,a5
    80005754:	40000693          	li	a3,1024
    80005758:	c714                	sw	a3,8(a4)
  if(write)
    8000575a:	e40c97e3          	bnez	s9,800055a8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000575e:	00018717          	auipc	a4,0x18
    80005762:	8a273703          	ld	a4,-1886(a4) # 8001d000 <disk+0x2000>
    80005766:	973e                	add	a4,a4,a5
    80005768:	4689                	li	a3,2
    8000576a:	00d71623          	sh	a3,12(a4)
    8000576e:	b5a1                	j	800055b6 <virtio_disk_rw+0xd4>

0000000080005770 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005770:	1101                	add	sp,sp,-32
    80005772:	ec06                	sd	ra,24(sp)
    80005774:	e822                	sd	s0,16(sp)
    80005776:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005778:	00018517          	auipc	a0,0x18
    8000577c:	9b050513          	add	a0,a0,-1616 # 8001d128 <disk+0x2128>
    80005780:	00001097          	auipc	ra,0x1
    80005784:	bd2080e7          	jalr	-1070(ra) # 80006352 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005788:	100017b7          	lui	a5,0x10001
    8000578c:	53b8                	lw	a4,96(a5)
    8000578e:	8b0d                	and	a4,a4,3
    80005790:	100017b7          	lui	a5,0x10001
    80005794:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005796:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000579a:	00018797          	auipc	a5,0x18
    8000579e:	86678793          	add	a5,a5,-1946 # 8001d000 <disk+0x2000>
    800057a2:	6b94                	ld	a3,16(a5)
    800057a4:	0207d703          	lhu	a4,32(a5)
    800057a8:	0026d783          	lhu	a5,2(a3)
    800057ac:	06f70563          	beq	a4,a5,80005816 <virtio_disk_intr+0xa6>
    800057b0:	e426                	sd	s1,8(sp)
    800057b2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057b4:	00016917          	auipc	s2,0x16
    800057b8:	84c90913          	add	s2,s2,-1972 # 8001b000 <disk>
    800057bc:	00018497          	auipc	s1,0x18
    800057c0:	84448493          	add	s1,s1,-1980 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800057c4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057c8:	6898                	ld	a4,16(s1)
    800057ca:	0204d783          	lhu	a5,32(s1)
    800057ce:	8b9d                	and	a5,a5,7
    800057d0:	078e                	sll	a5,a5,0x3
    800057d2:	97ba                	add	a5,a5,a4
    800057d4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057d6:	20078713          	add	a4,a5,512
    800057da:	0712                	sll	a4,a4,0x4
    800057dc:	974a                	add	a4,a4,s2
    800057de:	03074703          	lbu	a4,48(a4)
    800057e2:	e731                	bnez	a4,8000582e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057e4:	20078793          	add	a5,a5,512
    800057e8:	0792                	sll	a5,a5,0x4
    800057ea:	97ca                	add	a5,a5,s2
    800057ec:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057ee:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057f2:	ffffc097          	auipc	ra,0xffffc
    800057f6:	f36080e7          	jalr	-202(ra) # 80001728 <wakeup>

    disk.used_idx += 1;
    800057fa:	0204d783          	lhu	a5,32(s1)
    800057fe:	2785                	addw	a5,a5,1
    80005800:	17c2                	sll	a5,a5,0x30
    80005802:	93c1                	srl	a5,a5,0x30
    80005804:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005808:	6898                	ld	a4,16(s1)
    8000580a:	00275703          	lhu	a4,2(a4)
    8000580e:	faf71be3          	bne	a4,a5,800057c4 <virtio_disk_intr+0x54>
    80005812:	64a2                	ld	s1,8(sp)
    80005814:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005816:	00018517          	auipc	a0,0x18
    8000581a:	91250513          	add	a0,a0,-1774 # 8001d128 <disk+0x2128>
    8000581e:	00001097          	auipc	ra,0x1
    80005822:	be8080e7          	jalr	-1048(ra) # 80006406 <release>
}
    80005826:	60e2                	ld	ra,24(sp)
    80005828:	6442                	ld	s0,16(sp)
    8000582a:	6105                	add	sp,sp,32
    8000582c:	8082                	ret
      panic("virtio_disk_intr status");
    8000582e:	00003517          	auipc	a0,0x3
    80005832:	e5250513          	add	a0,a0,-430 # 80008680 <etext+0x680>
    80005836:	00000097          	auipc	ra,0x0
    8000583a:	546080e7          	jalr	1350(ra) # 80005d7c <panic>

000000008000583e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000583e:	1141                	add	sp,sp,-16
    80005840:	e422                	sd	s0,8(sp)
    80005842:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005844:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005848:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000584c:	0037979b          	sllw	a5,a5,0x3
    80005850:	02004737          	lui	a4,0x2004
    80005854:	97ba                	add	a5,a5,a4
    80005856:	0200c737          	lui	a4,0x200c
    8000585a:	1761                	add	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000585c:	6318                	ld	a4,0(a4)
    8000585e:	000f4637          	lui	a2,0xf4
    80005862:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005866:	9732                	add	a4,a4,a2
    80005868:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000586a:	00259693          	sll	a3,a1,0x2
    8000586e:	96ae                	add	a3,a3,a1
    80005870:	068e                	sll	a3,a3,0x3
    80005872:	00018717          	auipc	a4,0x18
    80005876:	78e70713          	add	a4,a4,1934 # 8001e000 <timer_scratch>
    8000587a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000587c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000587e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005880:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005884:	00000797          	auipc	a5,0x0
    80005888:	99c78793          	add	a5,a5,-1636 # 80005220 <timervec>
    8000588c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005890:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005894:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005898:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000589c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058a0:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058a4:	30479073          	csrw	mie,a5
}
    800058a8:	6422                	ld	s0,8(sp)
    800058aa:	0141                	add	sp,sp,16
    800058ac:	8082                	ret

00000000800058ae <start>:
{
    800058ae:	1141                	add	sp,sp,-16
    800058b0:	e406                	sd	ra,8(sp)
    800058b2:	e022                	sd	s0,0(sp)
    800058b4:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058b6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058ba:	7779                	lui	a4,0xffffe
    800058bc:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800058c0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058c2:	6705                	lui	a4,0x1
    800058c4:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058c8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058ca:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058ce:	ffffb797          	auipc	a5,0xffffb
    800058d2:	a4a78793          	add	a5,a5,-1462 # 80000318 <main>
    800058d6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058da:	4781                	li	a5,0
    800058dc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058e0:	67c1                	lui	a5,0x10
    800058e2:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058e4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058e8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058ec:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058f0:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058f4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058f8:	57fd                	li	a5,-1
    800058fa:	83a9                	srl	a5,a5,0xa
    800058fc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005900:	47bd                	li	a5,15
    80005902:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005906:	00000097          	auipc	ra,0x0
    8000590a:	f38080e7          	jalr	-200(ra) # 8000583e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000590e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005912:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005914:	823e                	mv	tp,a5
  asm volatile("mret");
    80005916:	30200073          	mret
}
    8000591a:	60a2                	ld	ra,8(sp)
    8000591c:	6402                	ld	s0,0(sp)
    8000591e:	0141                	add	sp,sp,16
    80005920:	8082                	ret

0000000080005922 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005922:	715d                	add	sp,sp,-80
    80005924:	e486                	sd	ra,72(sp)
    80005926:	e0a2                	sd	s0,64(sp)
    80005928:	f84a                	sd	s2,48(sp)
    8000592a:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000592c:	04c05663          	blez	a2,80005978 <consolewrite+0x56>
    80005930:	fc26                	sd	s1,56(sp)
    80005932:	f44e                	sd	s3,40(sp)
    80005934:	f052                	sd	s4,32(sp)
    80005936:	ec56                	sd	s5,24(sp)
    80005938:	8a2a                	mv	s4,a0
    8000593a:	84ae                	mv	s1,a1
    8000593c:	89b2                	mv	s3,a2
    8000593e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005940:	5afd                	li	s5,-1
    80005942:	4685                	li	a3,1
    80005944:	8626                	mv	a2,s1
    80005946:	85d2                	mv	a1,s4
    80005948:	fbf40513          	add	a0,s0,-65
    8000594c:	ffffc097          	auipc	ra,0xffffc
    80005950:	04a080e7          	jalr	74(ra) # 80001996 <either_copyin>
    80005954:	03550463          	beq	a0,s5,8000597c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005958:	fbf44503          	lbu	a0,-65(s0)
    8000595c:	00001097          	auipc	ra,0x1
    80005960:	83a080e7          	jalr	-1990(ra) # 80006196 <uartputc>
  for(i = 0; i < n; i++){
    80005964:	2905                	addw	s2,s2,1
    80005966:	0485                	add	s1,s1,1
    80005968:	fd299de3          	bne	s3,s2,80005942 <consolewrite+0x20>
    8000596c:	894e                	mv	s2,s3
    8000596e:	74e2                	ld	s1,56(sp)
    80005970:	79a2                	ld	s3,40(sp)
    80005972:	7a02                	ld	s4,32(sp)
    80005974:	6ae2                	ld	s5,24(sp)
    80005976:	a039                	j	80005984 <consolewrite+0x62>
    80005978:	4901                	li	s2,0
    8000597a:	a029                	j	80005984 <consolewrite+0x62>
    8000597c:	74e2                	ld	s1,56(sp)
    8000597e:	79a2                	ld	s3,40(sp)
    80005980:	7a02                	ld	s4,32(sp)
    80005982:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005984:	854a                	mv	a0,s2
    80005986:	60a6                	ld	ra,72(sp)
    80005988:	6406                	ld	s0,64(sp)
    8000598a:	7942                	ld	s2,48(sp)
    8000598c:	6161                	add	sp,sp,80
    8000598e:	8082                	ret

0000000080005990 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005990:	711d                	add	sp,sp,-96
    80005992:	ec86                	sd	ra,88(sp)
    80005994:	e8a2                	sd	s0,80(sp)
    80005996:	e4a6                	sd	s1,72(sp)
    80005998:	e0ca                	sd	s2,64(sp)
    8000599a:	fc4e                	sd	s3,56(sp)
    8000599c:	f852                	sd	s4,48(sp)
    8000599e:	f456                	sd	s5,40(sp)
    800059a0:	f05a                	sd	s6,32(sp)
    800059a2:	1080                	add	s0,sp,96
    800059a4:	8aaa                	mv	s5,a0
    800059a6:	8a2e                	mv	s4,a1
    800059a8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059aa:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059ae:	00020517          	auipc	a0,0x20
    800059b2:	79250513          	add	a0,a0,1938 # 80026140 <cons>
    800059b6:	00001097          	auipc	ra,0x1
    800059ba:	99c080e7          	jalr	-1636(ra) # 80006352 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059be:	00020497          	auipc	s1,0x20
    800059c2:	78248493          	add	s1,s1,1922 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059c6:	00021917          	auipc	s2,0x21
    800059ca:	81290913          	add	s2,s2,-2030 # 800261d8 <cons+0x98>
  while(n > 0){
    800059ce:	0d305463          	blez	s3,80005a96 <consoleread+0x106>
    while(cons.r == cons.w){
    800059d2:	0984a783          	lw	a5,152(s1)
    800059d6:	09c4a703          	lw	a4,156(s1)
    800059da:	0af71963          	bne	a4,a5,80005a8c <consoleread+0xfc>
      if(myproc()->killed){
    800059de:	ffffb097          	auipc	ra,0xffffb
    800059e2:	49e080e7          	jalr	1182(ra) # 80000e7c <myproc>
    800059e6:	551c                	lw	a5,40(a0)
    800059e8:	e7ad                	bnez	a5,80005a52 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    800059ea:	85a6                	mv	a1,s1
    800059ec:	854a                	mv	a0,s2
    800059ee:	ffffc097          	auipc	ra,0xffffc
    800059f2:	bae080e7          	jalr	-1106(ra) # 8000159c <sleep>
    while(cons.r == cons.w){
    800059f6:	0984a783          	lw	a5,152(s1)
    800059fa:	09c4a703          	lw	a4,156(s1)
    800059fe:	fef700e3          	beq	a4,a5,800059de <consoleread+0x4e>
    80005a02:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a04:	00020717          	auipc	a4,0x20
    80005a08:	73c70713          	add	a4,a4,1852 # 80026140 <cons>
    80005a0c:	0017869b          	addw	a3,a5,1
    80005a10:	08d72c23          	sw	a3,152(a4)
    80005a14:	07f7f693          	and	a3,a5,127
    80005a18:	9736                	add	a4,a4,a3
    80005a1a:	01874703          	lbu	a4,24(a4)
    80005a1e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a22:	4691                	li	a3,4
    80005a24:	04db8a63          	beq	s7,a3,80005a78 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a28:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a2c:	4685                	li	a3,1
    80005a2e:	faf40613          	add	a2,s0,-81
    80005a32:	85d2                	mv	a1,s4
    80005a34:	8556                	mv	a0,s5
    80005a36:	ffffc097          	auipc	ra,0xffffc
    80005a3a:	f0a080e7          	jalr	-246(ra) # 80001940 <either_copyout>
    80005a3e:	57fd                	li	a5,-1
    80005a40:	04f50a63          	beq	a0,a5,80005a94 <consoleread+0x104>
      break;

    dst++;
    80005a44:	0a05                	add	s4,s4,1
    --n;
    80005a46:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80005a48:	47a9                	li	a5,10
    80005a4a:	06fb8163          	beq	s7,a5,80005aac <consoleread+0x11c>
    80005a4e:	6be2                	ld	s7,24(sp)
    80005a50:	bfbd                	j	800059ce <consoleread+0x3e>
        release(&cons.lock);
    80005a52:	00020517          	auipc	a0,0x20
    80005a56:	6ee50513          	add	a0,a0,1774 # 80026140 <cons>
    80005a5a:	00001097          	auipc	ra,0x1
    80005a5e:	9ac080e7          	jalr	-1620(ra) # 80006406 <release>
        return -1;
    80005a62:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005a64:	60e6                	ld	ra,88(sp)
    80005a66:	6446                	ld	s0,80(sp)
    80005a68:	64a6                	ld	s1,72(sp)
    80005a6a:	6906                	ld	s2,64(sp)
    80005a6c:	79e2                	ld	s3,56(sp)
    80005a6e:	7a42                	ld	s4,48(sp)
    80005a70:	7aa2                	ld	s5,40(sp)
    80005a72:	7b02                	ld	s6,32(sp)
    80005a74:	6125                	add	sp,sp,96
    80005a76:	8082                	ret
      if(n < target){
    80005a78:	0009871b          	sext.w	a4,s3
    80005a7c:	01677a63          	bgeu	a4,s6,80005a90 <consoleread+0x100>
        cons.r--;
    80005a80:	00020717          	auipc	a4,0x20
    80005a84:	74f72c23          	sw	a5,1880(a4) # 800261d8 <cons+0x98>
    80005a88:	6be2                	ld	s7,24(sp)
    80005a8a:	a031                	j	80005a96 <consoleread+0x106>
    80005a8c:	ec5e                	sd	s7,24(sp)
    80005a8e:	bf9d                	j	80005a04 <consoleread+0x74>
    80005a90:	6be2                	ld	s7,24(sp)
    80005a92:	a011                	j	80005a96 <consoleread+0x106>
    80005a94:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005a96:	00020517          	auipc	a0,0x20
    80005a9a:	6aa50513          	add	a0,a0,1706 # 80026140 <cons>
    80005a9e:	00001097          	auipc	ra,0x1
    80005aa2:	968080e7          	jalr	-1688(ra) # 80006406 <release>
  return target - n;
    80005aa6:	413b053b          	subw	a0,s6,s3
    80005aaa:	bf6d                	j	80005a64 <consoleread+0xd4>
    80005aac:	6be2                	ld	s7,24(sp)
    80005aae:	b7e5                	j	80005a96 <consoleread+0x106>

0000000080005ab0 <consputc>:
{
    80005ab0:	1141                	add	sp,sp,-16
    80005ab2:	e406                	sd	ra,8(sp)
    80005ab4:	e022                	sd	s0,0(sp)
    80005ab6:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80005ab8:	10000793          	li	a5,256
    80005abc:	00f50a63          	beq	a0,a5,80005ad0 <consputc+0x20>
    uartputc_sync(c);
    80005ac0:	00000097          	auipc	ra,0x0
    80005ac4:	5f8080e7          	jalr	1528(ra) # 800060b8 <uartputc_sync>
}
    80005ac8:	60a2                	ld	ra,8(sp)
    80005aca:	6402                	ld	s0,0(sp)
    80005acc:	0141                	add	sp,sp,16
    80005ace:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ad0:	4521                	li	a0,8
    80005ad2:	00000097          	auipc	ra,0x0
    80005ad6:	5e6080e7          	jalr	1510(ra) # 800060b8 <uartputc_sync>
    80005ada:	02000513          	li	a0,32
    80005ade:	00000097          	auipc	ra,0x0
    80005ae2:	5da080e7          	jalr	1498(ra) # 800060b8 <uartputc_sync>
    80005ae6:	4521                	li	a0,8
    80005ae8:	00000097          	auipc	ra,0x0
    80005aec:	5d0080e7          	jalr	1488(ra) # 800060b8 <uartputc_sync>
    80005af0:	bfe1                	j	80005ac8 <consputc+0x18>

0000000080005af2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005af2:	1101                	add	sp,sp,-32
    80005af4:	ec06                	sd	ra,24(sp)
    80005af6:	e822                	sd	s0,16(sp)
    80005af8:	e426                	sd	s1,8(sp)
    80005afa:	1000                	add	s0,sp,32
    80005afc:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005afe:	00020517          	auipc	a0,0x20
    80005b02:	64250513          	add	a0,a0,1602 # 80026140 <cons>
    80005b06:	00001097          	auipc	ra,0x1
    80005b0a:	84c080e7          	jalr	-1972(ra) # 80006352 <acquire>

  switch(c){
    80005b0e:	47d5                	li	a5,21
    80005b10:	0af48563          	beq	s1,a5,80005bba <consoleintr+0xc8>
    80005b14:	0297c963          	blt	a5,s1,80005b46 <consoleintr+0x54>
    80005b18:	47a1                	li	a5,8
    80005b1a:	0ef48c63          	beq	s1,a5,80005c12 <consoleintr+0x120>
    80005b1e:	47c1                	li	a5,16
    80005b20:	10f49f63          	bne	s1,a5,80005c3e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005b24:	ffffc097          	auipc	ra,0xffffc
    80005b28:	ec8080e7          	jalr	-312(ra) # 800019ec <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b2c:	00020517          	auipc	a0,0x20
    80005b30:	61450513          	add	a0,a0,1556 # 80026140 <cons>
    80005b34:	00001097          	auipc	ra,0x1
    80005b38:	8d2080e7          	jalr	-1838(ra) # 80006406 <release>
}
    80005b3c:	60e2                	ld	ra,24(sp)
    80005b3e:	6442                	ld	s0,16(sp)
    80005b40:	64a2                	ld	s1,8(sp)
    80005b42:	6105                	add	sp,sp,32
    80005b44:	8082                	ret
  switch(c){
    80005b46:	07f00793          	li	a5,127
    80005b4a:	0cf48463          	beq	s1,a5,80005c12 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b4e:	00020717          	auipc	a4,0x20
    80005b52:	5f270713          	add	a4,a4,1522 # 80026140 <cons>
    80005b56:	0a072783          	lw	a5,160(a4)
    80005b5a:	09872703          	lw	a4,152(a4)
    80005b5e:	9f99                	subw	a5,a5,a4
    80005b60:	07f00713          	li	a4,127
    80005b64:	fcf764e3          	bltu	a4,a5,80005b2c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005b68:	47b5                	li	a5,13
    80005b6a:	0cf48d63          	beq	s1,a5,80005c44 <consoleintr+0x152>
      consputc(c);
    80005b6e:	8526                	mv	a0,s1
    80005b70:	00000097          	auipc	ra,0x0
    80005b74:	f40080e7          	jalr	-192(ra) # 80005ab0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b78:	00020797          	auipc	a5,0x20
    80005b7c:	5c878793          	add	a5,a5,1480 # 80026140 <cons>
    80005b80:	0a07a703          	lw	a4,160(a5)
    80005b84:	0017069b          	addw	a3,a4,1
    80005b88:	0006861b          	sext.w	a2,a3
    80005b8c:	0ad7a023          	sw	a3,160(a5)
    80005b90:	07f77713          	and	a4,a4,127
    80005b94:	97ba                	add	a5,a5,a4
    80005b96:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b9a:	47a9                	li	a5,10
    80005b9c:	0cf48b63          	beq	s1,a5,80005c72 <consoleintr+0x180>
    80005ba0:	4791                	li	a5,4
    80005ba2:	0cf48863          	beq	s1,a5,80005c72 <consoleintr+0x180>
    80005ba6:	00020797          	auipc	a5,0x20
    80005baa:	6327a783          	lw	a5,1586(a5) # 800261d8 <cons+0x98>
    80005bae:	0807879b          	addw	a5,a5,128
    80005bb2:	f6f61de3          	bne	a2,a5,80005b2c <consoleintr+0x3a>
    80005bb6:	863e                	mv	a2,a5
    80005bb8:	a86d                	j	80005c72 <consoleintr+0x180>
    80005bba:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005bbc:	00020717          	auipc	a4,0x20
    80005bc0:	58470713          	add	a4,a4,1412 # 80026140 <cons>
    80005bc4:	0a072783          	lw	a5,160(a4)
    80005bc8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bcc:	00020497          	auipc	s1,0x20
    80005bd0:	57448493          	add	s1,s1,1396 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005bd4:	4929                	li	s2,10
    80005bd6:	02f70a63          	beq	a4,a5,80005c0a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bda:	37fd                	addw	a5,a5,-1
    80005bdc:	07f7f713          	and	a4,a5,127
    80005be0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005be2:	01874703          	lbu	a4,24(a4)
    80005be6:	03270463          	beq	a4,s2,80005c0e <consoleintr+0x11c>
      cons.e--;
    80005bea:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bee:	10000513          	li	a0,256
    80005bf2:	00000097          	auipc	ra,0x0
    80005bf6:	ebe080e7          	jalr	-322(ra) # 80005ab0 <consputc>
    while(cons.e != cons.w &&
    80005bfa:	0a04a783          	lw	a5,160(s1)
    80005bfe:	09c4a703          	lw	a4,156(s1)
    80005c02:	fcf71ce3          	bne	a4,a5,80005bda <consoleintr+0xe8>
    80005c06:	6902                	ld	s2,0(sp)
    80005c08:	b715                	j	80005b2c <consoleintr+0x3a>
    80005c0a:	6902                	ld	s2,0(sp)
    80005c0c:	b705                	j	80005b2c <consoleintr+0x3a>
    80005c0e:	6902                	ld	s2,0(sp)
    80005c10:	bf31                	j	80005b2c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005c12:	00020717          	auipc	a4,0x20
    80005c16:	52e70713          	add	a4,a4,1326 # 80026140 <cons>
    80005c1a:	0a072783          	lw	a5,160(a4)
    80005c1e:	09c72703          	lw	a4,156(a4)
    80005c22:	f0f705e3          	beq	a4,a5,80005b2c <consoleintr+0x3a>
      cons.e--;
    80005c26:	37fd                	addw	a5,a5,-1
    80005c28:	00020717          	auipc	a4,0x20
    80005c2c:	5af72c23          	sw	a5,1464(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c30:	10000513          	li	a0,256
    80005c34:	00000097          	auipc	ra,0x0
    80005c38:	e7c080e7          	jalr	-388(ra) # 80005ab0 <consputc>
    80005c3c:	bdc5                	j	80005b2c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c3e:	ee0487e3          	beqz	s1,80005b2c <consoleintr+0x3a>
    80005c42:	b731                	j	80005b4e <consoleintr+0x5c>
      consputc(c);
    80005c44:	4529                	li	a0,10
    80005c46:	00000097          	auipc	ra,0x0
    80005c4a:	e6a080e7          	jalr	-406(ra) # 80005ab0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c4e:	00020797          	auipc	a5,0x20
    80005c52:	4f278793          	add	a5,a5,1266 # 80026140 <cons>
    80005c56:	0a07a703          	lw	a4,160(a5)
    80005c5a:	0017069b          	addw	a3,a4,1
    80005c5e:	0006861b          	sext.w	a2,a3
    80005c62:	0ad7a023          	sw	a3,160(a5)
    80005c66:	07f77713          	and	a4,a4,127
    80005c6a:	97ba                	add	a5,a5,a4
    80005c6c:	4729                	li	a4,10
    80005c6e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c72:	00020797          	auipc	a5,0x20
    80005c76:	56c7a523          	sw	a2,1386(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c7a:	00020517          	auipc	a0,0x20
    80005c7e:	55e50513          	add	a0,a0,1374 # 800261d8 <cons+0x98>
    80005c82:	ffffc097          	auipc	ra,0xffffc
    80005c86:	aa6080e7          	jalr	-1370(ra) # 80001728 <wakeup>
    80005c8a:	b54d                	j	80005b2c <consoleintr+0x3a>

0000000080005c8c <consoleinit>:

void
consoleinit(void)
{
    80005c8c:	1141                	add	sp,sp,-16
    80005c8e:	e406                	sd	ra,8(sp)
    80005c90:	e022                	sd	s0,0(sp)
    80005c92:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c94:	00003597          	auipc	a1,0x3
    80005c98:	a0458593          	add	a1,a1,-1532 # 80008698 <etext+0x698>
    80005c9c:	00020517          	auipc	a0,0x20
    80005ca0:	4a450513          	add	a0,a0,1188 # 80026140 <cons>
    80005ca4:	00000097          	auipc	ra,0x0
    80005ca8:	61e080e7          	jalr	1566(ra) # 800062c2 <initlock>

  uartinit();
    80005cac:	00000097          	auipc	ra,0x0
    80005cb0:	3b0080e7          	jalr	944(ra) # 8000605c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cb4:	00014797          	auipc	a5,0x14
    80005cb8:	c1478793          	add	a5,a5,-1004 # 800198c8 <devsw>
    80005cbc:	00000717          	auipc	a4,0x0
    80005cc0:	cd470713          	add	a4,a4,-812 # 80005990 <consoleread>
    80005cc4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cc6:	00000717          	auipc	a4,0x0
    80005cca:	c5c70713          	add	a4,a4,-932 # 80005922 <consolewrite>
    80005cce:	ef98                	sd	a4,24(a5)
}
    80005cd0:	60a2                	ld	ra,8(sp)
    80005cd2:	6402                	ld	s0,0(sp)
    80005cd4:	0141                	add	sp,sp,16
    80005cd6:	8082                	ret

0000000080005cd8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cd8:	7179                	add	sp,sp,-48
    80005cda:	f406                	sd	ra,40(sp)
    80005cdc:	f022                	sd	s0,32(sp)
    80005cde:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ce0:	c219                	beqz	a2,80005ce6 <printint+0xe>
    80005ce2:	08054963          	bltz	a0,80005d74 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005ce6:	2501                	sext.w	a0,a0
    80005ce8:	4881                	li	a7,0
    80005cea:	fd040693          	add	a3,s0,-48

  i = 0;
    80005cee:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cf0:	2581                	sext.w	a1,a1
    80005cf2:	00003617          	auipc	a2,0x3
    80005cf6:	b1e60613          	add	a2,a2,-1250 # 80008810 <digits>
    80005cfa:	883a                	mv	a6,a4
    80005cfc:	2705                	addw	a4,a4,1
    80005cfe:	02b577bb          	remuw	a5,a0,a1
    80005d02:	1782                	sll	a5,a5,0x20
    80005d04:	9381                	srl	a5,a5,0x20
    80005d06:	97b2                	add	a5,a5,a2
    80005d08:	0007c783          	lbu	a5,0(a5)
    80005d0c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d10:	0005079b          	sext.w	a5,a0
    80005d14:	02b5553b          	divuw	a0,a0,a1
    80005d18:	0685                	add	a3,a3,1
    80005d1a:	feb7f0e3          	bgeu	a5,a1,80005cfa <printint+0x22>

  if(sign)
    80005d1e:	00088c63          	beqz	a7,80005d36 <printint+0x5e>
    buf[i++] = '-';
    80005d22:	fe070793          	add	a5,a4,-32
    80005d26:	00878733          	add	a4,a5,s0
    80005d2a:	02d00793          	li	a5,45
    80005d2e:	fef70823          	sb	a5,-16(a4)
    80005d32:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005d36:	02e05b63          	blez	a4,80005d6c <printint+0x94>
    80005d3a:	ec26                	sd	s1,24(sp)
    80005d3c:	e84a                	sd	s2,16(sp)
    80005d3e:	fd040793          	add	a5,s0,-48
    80005d42:	00e784b3          	add	s1,a5,a4
    80005d46:	fff78913          	add	s2,a5,-1
    80005d4a:	993a                	add	s2,s2,a4
    80005d4c:	377d                	addw	a4,a4,-1
    80005d4e:	1702                	sll	a4,a4,0x20
    80005d50:	9301                	srl	a4,a4,0x20
    80005d52:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d56:	fff4c503          	lbu	a0,-1(s1)
    80005d5a:	00000097          	auipc	ra,0x0
    80005d5e:	d56080e7          	jalr	-682(ra) # 80005ab0 <consputc>
  while(--i >= 0)
    80005d62:	14fd                	add	s1,s1,-1
    80005d64:	ff2499e3          	bne	s1,s2,80005d56 <printint+0x7e>
    80005d68:	64e2                	ld	s1,24(sp)
    80005d6a:	6942                	ld	s2,16(sp)
}
    80005d6c:	70a2                	ld	ra,40(sp)
    80005d6e:	7402                	ld	s0,32(sp)
    80005d70:	6145                	add	sp,sp,48
    80005d72:	8082                	ret
    x = -xx;
    80005d74:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d78:	4885                	li	a7,1
    x = -xx;
    80005d7a:	bf85                	j	80005cea <printint+0x12>

0000000080005d7c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d7c:	1101                	add	sp,sp,-32
    80005d7e:	ec06                	sd	ra,24(sp)
    80005d80:	e822                	sd	s0,16(sp)
    80005d82:	e426                	sd	s1,8(sp)
    80005d84:	1000                	add	s0,sp,32
    80005d86:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d88:	00020797          	auipc	a5,0x20
    80005d8c:	4607ac23          	sw	zero,1144(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005d90:	00003517          	auipc	a0,0x3
    80005d94:	91050513          	add	a0,a0,-1776 # 800086a0 <etext+0x6a0>
    80005d98:	00000097          	auipc	ra,0x0
    80005d9c:	02e080e7          	jalr	46(ra) # 80005dc6 <printf>
  printf(s);
    80005da0:	8526                	mv	a0,s1
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	024080e7          	jalr	36(ra) # 80005dc6 <printf>
  printf("\n");
    80005daa:	00002517          	auipc	a0,0x2
    80005dae:	26e50513          	add	a0,a0,622 # 80008018 <etext+0x18>
    80005db2:	00000097          	auipc	ra,0x0
    80005db6:	014080e7          	jalr	20(ra) # 80005dc6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dba:	4785                	li	a5,1
    80005dbc:	00003717          	auipc	a4,0x3
    80005dc0:	26f72023          	sw	a5,608(a4) # 8000901c <panicked>
  for(;;)
    80005dc4:	a001                	j	80005dc4 <panic+0x48>

0000000080005dc6 <printf>:
{
    80005dc6:	7131                	add	sp,sp,-192
    80005dc8:	fc86                	sd	ra,120(sp)
    80005dca:	f8a2                	sd	s0,112(sp)
    80005dcc:	e8d2                	sd	s4,80(sp)
    80005dce:	f06a                	sd	s10,32(sp)
    80005dd0:	0100                	add	s0,sp,128
    80005dd2:	8a2a                	mv	s4,a0
    80005dd4:	e40c                	sd	a1,8(s0)
    80005dd6:	e810                	sd	a2,16(s0)
    80005dd8:	ec14                	sd	a3,24(s0)
    80005dda:	f018                	sd	a4,32(s0)
    80005ddc:	f41c                	sd	a5,40(s0)
    80005dde:	03043823          	sd	a6,48(s0)
    80005de2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005de6:	00020d17          	auipc	s10,0x20
    80005dea:	41ad2d03          	lw	s10,1050(s10) # 80026200 <pr+0x18>
  if(locking)
    80005dee:	040d1463          	bnez	s10,80005e36 <printf+0x70>
  if (fmt == 0)
    80005df2:	040a0b63          	beqz	s4,80005e48 <printf+0x82>
  va_start(ap, fmt);
    80005df6:	00840793          	add	a5,s0,8
    80005dfa:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dfe:	000a4503          	lbu	a0,0(s4)
    80005e02:	18050b63          	beqz	a0,80005f98 <printf+0x1d2>
    80005e06:	f4a6                	sd	s1,104(sp)
    80005e08:	f0ca                	sd	s2,96(sp)
    80005e0a:	ecce                	sd	s3,88(sp)
    80005e0c:	e4d6                	sd	s5,72(sp)
    80005e0e:	e0da                	sd	s6,64(sp)
    80005e10:	fc5e                	sd	s7,56(sp)
    80005e12:	f862                	sd	s8,48(sp)
    80005e14:	f466                	sd	s9,40(sp)
    80005e16:	ec6e                	sd	s11,24(sp)
    80005e18:	4981                	li	s3,0
    if(c != '%'){
    80005e1a:	02500b13          	li	s6,37
    switch(c){
    80005e1e:	07000b93          	li	s7,112
  consputc('x');
    80005e22:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e24:	00003a97          	auipc	s5,0x3
    80005e28:	9eca8a93          	add	s5,s5,-1556 # 80008810 <digits>
    switch(c){
    80005e2c:	07300c13          	li	s8,115
    80005e30:	06400d93          	li	s11,100
    80005e34:	a0b1                	j	80005e80 <printf+0xba>
    acquire(&pr.lock);
    80005e36:	00020517          	auipc	a0,0x20
    80005e3a:	3b250513          	add	a0,a0,946 # 800261e8 <pr>
    80005e3e:	00000097          	auipc	ra,0x0
    80005e42:	514080e7          	jalr	1300(ra) # 80006352 <acquire>
    80005e46:	b775                	j	80005df2 <printf+0x2c>
    80005e48:	f4a6                	sd	s1,104(sp)
    80005e4a:	f0ca                	sd	s2,96(sp)
    80005e4c:	ecce                	sd	s3,88(sp)
    80005e4e:	e4d6                	sd	s5,72(sp)
    80005e50:	e0da                	sd	s6,64(sp)
    80005e52:	fc5e                	sd	s7,56(sp)
    80005e54:	f862                	sd	s8,48(sp)
    80005e56:	f466                	sd	s9,40(sp)
    80005e58:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005e5a:	00003517          	auipc	a0,0x3
    80005e5e:	85650513          	add	a0,a0,-1962 # 800086b0 <etext+0x6b0>
    80005e62:	00000097          	auipc	ra,0x0
    80005e66:	f1a080e7          	jalr	-230(ra) # 80005d7c <panic>
      consputc(c);
    80005e6a:	00000097          	auipc	ra,0x0
    80005e6e:	c46080e7          	jalr	-954(ra) # 80005ab0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e72:	2985                	addw	s3,s3,1
    80005e74:	013a07b3          	add	a5,s4,s3
    80005e78:	0007c503          	lbu	a0,0(a5)
    80005e7c:	10050563          	beqz	a0,80005f86 <printf+0x1c0>
    if(c != '%'){
    80005e80:	ff6515e3          	bne	a0,s6,80005e6a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005e84:	2985                	addw	s3,s3,1
    80005e86:	013a07b3          	add	a5,s4,s3
    80005e8a:	0007c783          	lbu	a5,0(a5)
    80005e8e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e92:	10078b63          	beqz	a5,80005fa8 <printf+0x1e2>
    switch(c){
    80005e96:	05778a63          	beq	a5,s7,80005eea <printf+0x124>
    80005e9a:	02fbf663          	bgeu	s7,a5,80005ec6 <printf+0x100>
    80005e9e:	09878863          	beq	a5,s8,80005f2e <printf+0x168>
    80005ea2:	07800713          	li	a4,120
    80005ea6:	0ce79563          	bne	a5,a4,80005f70 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005eaa:	f8843783          	ld	a5,-120(s0)
    80005eae:	00878713          	add	a4,a5,8
    80005eb2:	f8e43423          	sd	a4,-120(s0)
    80005eb6:	4605                	li	a2,1
    80005eb8:	85e6                	mv	a1,s9
    80005eba:	4388                	lw	a0,0(a5)
    80005ebc:	00000097          	auipc	ra,0x0
    80005ec0:	e1c080e7          	jalr	-484(ra) # 80005cd8 <printint>
      break;
    80005ec4:	b77d                	j	80005e72 <printf+0xac>
    switch(c){
    80005ec6:	09678f63          	beq	a5,s6,80005f64 <printf+0x19e>
    80005eca:	0bb79363          	bne	a5,s11,80005f70 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005ece:	f8843783          	ld	a5,-120(s0)
    80005ed2:	00878713          	add	a4,a5,8
    80005ed6:	f8e43423          	sd	a4,-120(s0)
    80005eda:	4605                	li	a2,1
    80005edc:	45a9                	li	a1,10
    80005ede:	4388                	lw	a0,0(a5)
    80005ee0:	00000097          	auipc	ra,0x0
    80005ee4:	df8080e7          	jalr	-520(ra) # 80005cd8 <printint>
      break;
    80005ee8:	b769                	j	80005e72 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005eea:	f8843783          	ld	a5,-120(s0)
    80005eee:	00878713          	add	a4,a5,8
    80005ef2:	f8e43423          	sd	a4,-120(s0)
    80005ef6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005efa:	03000513          	li	a0,48
    80005efe:	00000097          	auipc	ra,0x0
    80005f02:	bb2080e7          	jalr	-1102(ra) # 80005ab0 <consputc>
  consputc('x');
    80005f06:	07800513          	li	a0,120
    80005f0a:	00000097          	auipc	ra,0x0
    80005f0e:	ba6080e7          	jalr	-1114(ra) # 80005ab0 <consputc>
    80005f12:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f14:	03c95793          	srl	a5,s2,0x3c
    80005f18:	97d6                	add	a5,a5,s5
    80005f1a:	0007c503          	lbu	a0,0(a5)
    80005f1e:	00000097          	auipc	ra,0x0
    80005f22:	b92080e7          	jalr	-1134(ra) # 80005ab0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f26:	0912                	sll	s2,s2,0x4
    80005f28:	34fd                	addw	s1,s1,-1
    80005f2a:	f4ed                	bnez	s1,80005f14 <printf+0x14e>
    80005f2c:	b799                	j	80005e72 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005f2e:	f8843783          	ld	a5,-120(s0)
    80005f32:	00878713          	add	a4,a5,8
    80005f36:	f8e43423          	sd	a4,-120(s0)
    80005f3a:	6384                	ld	s1,0(a5)
    80005f3c:	cc89                	beqz	s1,80005f56 <printf+0x190>
      for(; *s; s++)
    80005f3e:	0004c503          	lbu	a0,0(s1)
    80005f42:	d905                	beqz	a0,80005e72 <printf+0xac>
        consputc(*s);
    80005f44:	00000097          	auipc	ra,0x0
    80005f48:	b6c080e7          	jalr	-1172(ra) # 80005ab0 <consputc>
      for(; *s; s++)
    80005f4c:	0485                	add	s1,s1,1
    80005f4e:	0004c503          	lbu	a0,0(s1)
    80005f52:	f96d                	bnez	a0,80005f44 <printf+0x17e>
    80005f54:	bf39                	j	80005e72 <printf+0xac>
        s = "(null)";
    80005f56:	00002497          	auipc	s1,0x2
    80005f5a:	75248493          	add	s1,s1,1874 # 800086a8 <etext+0x6a8>
      for(; *s; s++)
    80005f5e:	02800513          	li	a0,40
    80005f62:	b7cd                	j	80005f44 <printf+0x17e>
      consputc('%');
    80005f64:	855a                	mv	a0,s6
    80005f66:	00000097          	auipc	ra,0x0
    80005f6a:	b4a080e7          	jalr	-1206(ra) # 80005ab0 <consputc>
      break;
    80005f6e:	b711                	j	80005e72 <printf+0xac>
      consputc('%');
    80005f70:	855a                	mv	a0,s6
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	b3e080e7          	jalr	-1218(ra) # 80005ab0 <consputc>
      consputc(c);
    80005f7a:	8526                	mv	a0,s1
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	b34080e7          	jalr	-1228(ra) # 80005ab0 <consputc>
      break;
    80005f84:	b5fd                	j	80005e72 <printf+0xac>
    80005f86:	74a6                	ld	s1,104(sp)
    80005f88:	7906                	ld	s2,96(sp)
    80005f8a:	69e6                	ld	s3,88(sp)
    80005f8c:	6aa6                	ld	s5,72(sp)
    80005f8e:	6b06                	ld	s6,64(sp)
    80005f90:	7be2                	ld	s7,56(sp)
    80005f92:	7c42                	ld	s8,48(sp)
    80005f94:	7ca2                	ld	s9,40(sp)
    80005f96:	6de2                	ld	s11,24(sp)
  if(locking)
    80005f98:	020d1263          	bnez	s10,80005fbc <printf+0x1f6>
}
    80005f9c:	70e6                	ld	ra,120(sp)
    80005f9e:	7446                	ld	s0,112(sp)
    80005fa0:	6a46                	ld	s4,80(sp)
    80005fa2:	7d02                	ld	s10,32(sp)
    80005fa4:	6129                	add	sp,sp,192
    80005fa6:	8082                	ret
    80005fa8:	74a6                	ld	s1,104(sp)
    80005faa:	7906                	ld	s2,96(sp)
    80005fac:	69e6                	ld	s3,88(sp)
    80005fae:	6aa6                	ld	s5,72(sp)
    80005fb0:	6b06                	ld	s6,64(sp)
    80005fb2:	7be2                	ld	s7,56(sp)
    80005fb4:	7c42                	ld	s8,48(sp)
    80005fb6:	7ca2                	ld	s9,40(sp)
    80005fb8:	6de2                	ld	s11,24(sp)
    80005fba:	bff9                	j	80005f98 <printf+0x1d2>
    release(&pr.lock);
    80005fbc:	00020517          	auipc	a0,0x20
    80005fc0:	22c50513          	add	a0,a0,556 # 800261e8 <pr>
    80005fc4:	00000097          	auipc	ra,0x0
    80005fc8:	442080e7          	jalr	1090(ra) # 80006406 <release>
}
    80005fcc:	bfc1                	j	80005f9c <printf+0x1d6>

0000000080005fce <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fce:	1101                	add	sp,sp,-32
    80005fd0:	ec06                	sd	ra,24(sp)
    80005fd2:	e822                	sd	s0,16(sp)
    80005fd4:	e426                	sd	s1,8(sp)
    80005fd6:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fd8:	00020497          	auipc	s1,0x20
    80005fdc:	21048493          	add	s1,s1,528 # 800261e8 <pr>
    80005fe0:	00002597          	auipc	a1,0x2
    80005fe4:	6e058593          	add	a1,a1,1760 # 800086c0 <etext+0x6c0>
    80005fe8:	8526                	mv	a0,s1
    80005fea:	00000097          	auipc	ra,0x0
    80005fee:	2d8080e7          	jalr	728(ra) # 800062c2 <initlock>
  pr.locking = 1;
    80005ff2:	4785                	li	a5,1
    80005ff4:	cc9c                	sw	a5,24(s1)
}
    80005ff6:	60e2                	ld	ra,24(sp)
    80005ff8:	6442                	ld	s0,16(sp)
    80005ffa:	64a2                	ld	s1,8(sp)
    80005ffc:	6105                	add	sp,sp,32
    80005ffe:	8082                	ret

0000000080006000 <backtrace>:

void backtrace(void) {
    80006000:	7179                	add	sp,sp,-48
    80006002:	f406                	sd	ra,40(sp)
    80006004:	f022                	sd	s0,32(sp)
    80006006:	ec26                	sd	s1,24(sp)
    80006008:	1800                	add	s0,sp,48

// get value from s0 register
static inline uint64 r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    8000600a:	84a2                	mv	s1,s0
  uint64 fp = r_fp();
  while (fp != PGROUNDUP(fp)) {
    8000600c:	6785                	lui	a5,0x1
    8000600e:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80006010:	97a6                	add	a5,a5,s1
    80006012:	777d                	lui	a4,0xfffff
    80006014:	8ff9                	and	a5,a5,a4
    80006016:	02f48e63          	beq	s1,a5,80006052 <backtrace+0x52>
    8000601a:	e84a                	sd	s2,16(sp)
    8000601c:	e44e                	sd	s3,8(sp)
    8000601e:	e052                	sd	s4,0(sp)
    // get the return address
    uint64 *ra = *(uint64 *)(fp-8);
    printf("%p\n", ra);
    80006020:	00002a17          	auipc	s4,0x2
    80006024:	6a8a0a13          	add	s4,s4,1704 # 800086c8 <etext+0x6c8>
  while (fp != PGROUNDUP(fp)) {
    80006028:	6905                	lui	s2,0x1
    8000602a:	197d                	add	s2,s2,-1 # fff <_entry-0x7ffff001>
    8000602c:	79fd                	lui	s3,0xfffff
    printf("%p\n", ra);
    8000602e:	ff84b583          	ld	a1,-8(s1)
    80006032:	8552                	mv	a0,s4
    80006034:	00000097          	auipc	ra,0x0
    80006038:	d92080e7          	jalr	-622(ra) # 80005dc6 <printf>
    // get the prev frame pointer
    fp = *(uint64 *)(fp-16);
    8000603c:	ff04b483          	ld	s1,-16(s1)
  while (fp != PGROUNDUP(fp)) {
    80006040:	012487b3          	add	a5,s1,s2
    80006044:	0137f7b3          	and	a5,a5,s3
    80006048:	fe9793e3          	bne	a5,s1,8000602e <backtrace+0x2e>
    8000604c:	6942                	ld	s2,16(sp)
    8000604e:	69a2                	ld	s3,8(sp)
    80006050:	6a02                	ld	s4,0(sp)
  }
    80006052:	70a2                	ld	ra,40(sp)
    80006054:	7402                	ld	s0,32(sp)
    80006056:	64e2                	ld	s1,24(sp)
    80006058:	6145                	add	sp,sp,48
    8000605a:	8082                	ret

000000008000605c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000605c:	1141                	add	sp,sp,-16
    8000605e:	e406                	sd	ra,8(sp)
    80006060:	e022                	sd	s0,0(sp)
    80006062:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006064:	100007b7          	lui	a5,0x10000
    80006068:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000606c:	10000737          	lui	a4,0x10000
    80006070:	f8000693          	li	a3,-128
    80006074:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006078:	468d                	li	a3,3
    8000607a:	10000637          	lui	a2,0x10000
    8000607e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006082:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006086:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000608a:	10000737          	lui	a4,0x10000
    8000608e:	461d                	li	a2,7
    80006090:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006094:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006098:	00002597          	auipc	a1,0x2
    8000609c:	63858593          	add	a1,a1,1592 # 800086d0 <etext+0x6d0>
    800060a0:	00020517          	auipc	a0,0x20
    800060a4:	16850513          	add	a0,a0,360 # 80026208 <uart_tx_lock>
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	21a080e7          	jalr	538(ra) # 800062c2 <initlock>
}
    800060b0:	60a2                	ld	ra,8(sp)
    800060b2:	6402                	ld	s0,0(sp)
    800060b4:	0141                	add	sp,sp,16
    800060b6:	8082                	ret

00000000800060b8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060b8:	1101                	add	sp,sp,-32
    800060ba:	ec06                	sd	ra,24(sp)
    800060bc:	e822                	sd	s0,16(sp)
    800060be:	e426                	sd	s1,8(sp)
    800060c0:	1000                	add	s0,sp,32
    800060c2:	84aa                	mv	s1,a0
  push_off();
    800060c4:	00000097          	auipc	ra,0x0
    800060c8:	242080e7          	jalr	578(ra) # 80006306 <push_off>

  if(panicked){
    800060cc:	00003797          	auipc	a5,0x3
    800060d0:	f507a783          	lw	a5,-176(a5) # 8000901c <panicked>
    800060d4:	eb85                	bnez	a5,80006104 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060d6:	10000737          	lui	a4,0x10000
    800060da:	0715                	add	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800060dc:	00074783          	lbu	a5,0(a4)
    800060e0:	0207f793          	and	a5,a5,32
    800060e4:	dfe5                	beqz	a5,800060dc <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060e6:	0ff4f513          	zext.b	a0,s1
    800060ea:	100007b7          	lui	a5,0x10000
    800060ee:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060f2:	00000097          	auipc	ra,0x0
    800060f6:	2b4080e7          	jalr	692(ra) # 800063a6 <pop_off>
}
    800060fa:	60e2                	ld	ra,24(sp)
    800060fc:	6442                	ld	s0,16(sp)
    800060fe:	64a2                	ld	s1,8(sp)
    80006100:	6105                	add	sp,sp,32
    80006102:	8082                	ret
    for(;;)
    80006104:	a001                	j	80006104 <uartputc_sync+0x4c>

0000000080006106 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006106:	00003797          	auipc	a5,0x3
    8000610a:	f1a7b783          	ld	a5,-230(a5) # 80009020 <uart_tx_r>
    8000610e:	00003717          	auipc	a4,0x3
    80006112:	f1a73703          	ld	a4,-230(a4) # 80009028 <uart_tx_w>
    80006116:	06f70f63          	beq	a4,a5,80006194 <uartstart+0x8e>
{
    8000611a:	7139                	add	sp,sp,-64
    8000611c:	fc06                	sd	ra,56(sp)
    8000611e:	f822                	sd	s0,48(sp)
    80006120:	f426                	sd	s1,40(sp)
    80006122:	f04a                	sd	s2,32(sp)
    80006124:	ec4e                	sd	s3,24(sp)
    80006126:	e852                	sd	s4,16(sp)
    80006128:	e456                	sd	s5,8(sp)
    8000612a:	e05a                	sd	s6,0(sp)
    8000612c:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000612e:	10000937          	lui	s2,0x10000
    80006132:	0915                	add	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006134:	00020a97          	auipc	s5,0x20
    80006138:	0d4a8a93          	add	s5,s5,212 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    8000613c:	00003497          	auipc	s1,0x3
    80006140:	ee448493          	add	s1,s1,-284 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006144:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006148:	00003997          	auipc	s3,0x3
    8000614c:	ee098993          	add	s3,s3,-288 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006150:	00094703          	lbu	a4,0(s2)
    80006154:	02077713          	and	a4,a4,32
    80006158:	c705                	beqz	a4,80006180 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000615a:	01f7f713          	and	a4,a5,31
    8000615e:	9756                	add	a4,a4,s5
    80006160:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006164:	0785                	add	a5,a5,1
    80006166:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006168:	8526                	mv	a0,s1
    8000616a:	ffffb097          	auipc	ra,0xffffb
    8000616e:	5be080e7          	jalr	1470(ra) # 80001728 <wakeup>
    WriteReg(THR, c);
    80006172:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006176:	609c                	ld	a5,0(s1)
    80006178:	0009b703          	ld	a4,0(s3)
    8000617c:	fcf71ae3          	bne	a4,a5,80006150 <uartstart+0x4a>
  }
}
    80006180:	70e2                	ld	ra,56(sp)
    80006182:	7442                	ld	s0,48(sp)
    80006184:	74a2                	ld	s1,40(sp)
    80006186:	7902                	ld	s2,32(sp)
    80006188:	69e2                	ld	s3,24(sp)
    8000618a:	6a42                	ld	s4,16(sp)
    8000618c:	6aa2                	ld	s5,8(sp)
    8000618e:	6b02                	ld	s6,0(sp)
    80006190:	6121                	add	sp,sp,64
    80006192:	8082                	ret
    80006194:	8082                	ret

0000000080006196 <uartputc>:
{
    80006196:	7179                	add	sp,sp,-48
    80006198:	f406                	sd	ra,40(sp)
    8000619a:	f022                	sd	s0,32(sp)
    8000619c:	e052                	sd	s4,0(sp)
    8000619e:	1800                	add	s0,sp,48
    800061a0:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800061a2:	00020517          	auipc	a0,0x20
    800061a6:	06650513          	add	a0,a0,102 # 80026208 <uart_tx_lock>
    800061aa:	00000097          	auipc	ra,0x0
    800061ae:	1a8080e7          	jalr	424(ra) # 80006352 <acquire>
  if(panicked){
    800061b2:	00003797          	auipc	a5,0x3
    800061b6:	e6a7a783          	lw	a5,-406(a5) # 8000901c <panicked>
    800061ba:	c391                	beqz	a5,800061be <uartputc+0x28>
    for(;;)
    800061bc:	a001                	j	800061bc <uartputc+0x26>
    800061be:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061c0:	00003717          	auipc	a4,0x3
    800061c4:	e6873703          	ld	a4,-408(a4) # 80009028 <uart_tx_w>
    800061c8:	00003797          	auipc	a5,0x3
    800061cc:	e587b783          	ld	a5,-424(a5) # 80009020 <uart_tx_r>
    800061d0:	02078793          	add	a5,a5,32
    800061d4:	02e79f63          	bne	a5,a4,80006212 <uartputc+0x7c>
    800061d8:	e84a                	sd	s2,16(sp)
    800061da:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800061dc:	00020997          	auipc	s3,0x20
    800061e0:	02c98993          	add	s3,s3,44 # 80026208 <uart_tx_lock>
    800061e4:	00003497          	auipc	s1,0x3
    800061e8:	e3c48493          	add	s1,s1,-452 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061ec:	00003917          	auipc	s2,0x3
    800061f0:	e3c90913          	add	s2,s2,-452 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061f4:	85ce                	mv	a1,s3
    800061f6:	8526                	mv	a0,s1
    800061f8:	ffffb097          	auipc	ra,0xffffb
    800061fc:	3a4080e7          	jalr	932(ra) # 8000159c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006200:	00093703          	ld	a4,0(s2)
    80006204:	609c                	ld	a5,0(s1)
    80006206:	02078793          	add	a5,a5,32
    8000620a:	fee785e3          	beq	a5,a4,800061f4 <uartputc+0x5e>
    8000620e:	6942                	ld	s2,16(sp)
    80006210:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006212:	00020497          	auipc	s1,0x20
    80006216:	ff648493          	add	s1,s1,-10 # 80026208 <uart_tx_lock>
    8000621a:	01f77793          	and	a5,a4,31
    8000621e:	97a6                	add	a5,a5,s1
    80006220:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006224:	0705                	add	a4,a4,1
    80006226:	00003797          	auipc	a5,0x3
    8000622a:	e0e7b123          	sd	a4,-510(a5) # 80009028 <uart_tx_w>
      uartstart();
    8000622e:	00000097          	auipc	ra,0x0
    80006232:	ed8080e7          	jalr	-296(ra) # 80006106 <uartstart>
      release(&uart_tx_lock);
    80006236:	8526                	mv	a0,s1
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	1ce080e7          	jalr	462(ra) # 80006406 <release>
    80006240:	64e2                	ld	s1,24(sp)
}
    80006242:	70a2                	ld	ra,40(sp)
    80006244:	7402                	ld	s0,32(sp)
    80006246:	6a02                	ld	s4,0(sp)
    80006248:	6145                	add	sp,sp,48
    8000624a:	8082                	ret

000000008000624c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000624c:	1141                	add	sp,sp,-16
    8000624e:	e422                	sd	s0,8(sp)
    80006250:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006252:	100007b7          	lui	a5,0x10000
    80006256:	0795                	add	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80006258:	0007c783          	lbu	a5,0(a5)
    8000625c:	8b85                	and	a5,a5,1
    8000625e:	cb81                	beqz	a5,8000626e <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006260:	100007b7          	lui	a5,0x10000
    80006264:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006268:	6422                	ld	s0,8(sp)
    8000626a:	0141                	add	sp,sp,16
    8000626c:	8082                	ret
    return -1;
    8000626e:	557d                	li	a0,-1
    80006270:	bfe5                	j	80006268 <uartgetc+0x1c>

0000000080006272 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006272:	1101                	add	sp,sp,-32
    80006274:	ec06                	sd	ra,24(sp)
    80006276:	e822                	sd	s0,16(sp)
    80006278:	e426                	sd	s1,8(sp)
    8000627a:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000627c:	54fd                	li	s1,-1
    8000627e:	a029                	j	80006288 <uartintr+0x16>
      break;
    consoleintr(c);
    80006280:	00000097          	auipc	ra,0x0
    80006284:	872080e7          	jalr	-1934(ra) # 80005af2 <consoleintr>
    int c = uartgetc();
    80006288:	00000097          	auipc	ra,0x0
    8000628c:	fc4080e7          	jalr	-60(ra) # 8000624c <uartgetc>
    if(c == -1)
    80006290:	fe9518e3          	bne	a0,s1,80006280 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006294:	00020497          	auipc	s1,0x20
    80006298:	f7448493          	add	s1,s1,-140 # 80026208 <uart_tx_lock>
    8000629c:	8526                	mv	a0,s1
    8000629e:	00000097          	auipc	ra,0x0
    800062a2:	0b4080e7          	jalr	180(ra) # 80006352 <acquire>
  uartstart();
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	e60080e7          	jalr	-416(ra) # 80006106 <uartstart>
  release(&uart_tx_lock);
    800062ae:	8526                	mv	a0,s1
    800062b0:	00000097          	auipc	ra,0x0
    800062b4:	156080e7          	jalr	342(ra) # 80006406 <release>
}
    800062b8:	60e2                	ld	ra,24(sp)
    800062ba:	6442                	ld	s0,16(sp)
    800062bc:	64a2                	ld	s1,8(sp)
    800062be:	6105                	add	sp,sp,32
    800062c0:	8082                	ret

00000000800062c2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062c2:	1141                	add	sp,sp,-16
    800062c4:	e422                	sd	s0,8(sp)
    800062c6:	0800                	add	s0,sp,16
  lk->name = name;
    800062c8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062ca:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062ce:	00053823          	sd	zero,16(a0)
}
    800062d2:	6422                	ld	s0,8(sp)
    800062d4:	0141                	add	sp,sp,16
    800062d6:	8082                	ret

00000000800062d8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062d8:	411c                	lw	a5,0(a0)
    800062da:	e399                	bnez	a5,800062e0 <holding+0x8>
    800062dc:	4501                	li	a0,0
  return r;
}
    800062de:	8082                	ret
{
    800062e0:	1101                	add	sp,sp,-32
    800062e2:	ec06                	sd	ra,24(sp)
    800062e4:	e822                	sd	s0,16(sp)
    800062e6:	e426                	sd	s1,8(sp)
    800062e8:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062ea:	6904                	ld	s1,16(a0)
    800062ec:	ffffb097          	auipc	ra,0xffffb
    800062f0:	b74080e7          	jalr	-1164(ra) # 80000e60 <mycpu>
    800062f4:	40a48533          	sub	a0,s1,a0
    800062f8:	00153513          	seqz	a0,a0
}
    800062fc:	60e2                	ld	ra,24(sp)
    800062fe:	6442                	ld	s0,16(sp)
    80006300:	64a2                	ld	s1,8(sp)
    80006302:	6105                	add	sp,sp,32
    80006304:	8082                	ret

0000000080006306 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006306:	1101                	add	sp,sp,-32
    80006308:	ec06                	sd	ra,24(sp)
    8000630a:	e822                	sd	s0,16(sp)
    8000630c:	e426                	sd	s1,8(sp)
    8000630e:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006310:	100024f3          	csrr	s1,sstatus
    80006314:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006318:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000631a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000631e:	ffffb097          	auipc	ra,0xffffb
    80006322:	b42080e7          	jalr	-1214(ra) # 80000e60 <mycpu>
    80006326:	5d3c                	lw	a5,120(a0)
    80006328:	cf89                	beqz	a5,80006342 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000632a:	ffffb097          	auipc	ra,0xffffb
    8000632e:	b36080e7          	jalr	-1226(ra) # 80000e60 <mycpu>
    80006332:	5d3c                	lw	a5,120(a0)
    80006334:	2785                	addw	a5,a5,1
    80006336:	dd3c                	sw	a5,120(a0)
}
    80006338:	60e2                	ld	ra,24(sp)
    8000633a:	6442                	ld	s0,16(sp)
    8000633c:	64a2                	ld	s1,8(sp)
    8000633e:	6105                	add	sp,sp,32
    80006340:	8082                	ret
    mycpu()->intena = old;
    80006342:	ffffb097          	auipc	ra,0xffffb
    80006346:	b1e080e7          	jalr	-1250(ra) # 80000e60 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000634a:	8085                	srl	s1,s1,0x1
    8000634c:	8885                	and	s1,s1,1
    8000634e:	dd64                	sw	s1,124(a0)
    80006350:	bfe9                	j	8000632a <push_off+0x24>

0000000080006352 <acquire>:
{
    80006352:	1101                	add	sp,sp,-32
    80006354:	ec06                	sd	ra,24(sp)
    80006356:	e822                	sd	s0,16(sp)
    80006358:	e426                	sd	s1,8(sp)
    8000635a:	1000                	add	s0,sp,32
    8000635c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000635e:	00000097          	auipc	ra,0x0
    80006362:	fa8080e7          	jalr	-88(ra) # 80006306 <push_off>
  if(holding(lk))
    80006366:	8526                	mv	a0,s1
    80006368:	00000097          	auipc	ra,0x0
    8000636c:	f70080e7          	jalr	-144(ra) # 800062d8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006370:	4705                	li	a4,1
  if(holding(lk))
    80006372:	e115                	bnez	a0,80006396 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006374:	87ba                	mv	a5,a4
    80006376:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000637a:	2781                	sext.w	a5,a5
    8000637c:	ffe5                	bnez	a5,80006374 <acquire+0x22>
  __sync_synchronize();
    8000637e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006382:	ffffb097          	auipc	ra,0xffffb
    80006386:	ade080e7          	jalr	-1314(ra) # 80000e60 <mycpu>
    8000638a:	e888                	sd	a0,16(s1)
}
    8000638c:	60e2                	ld	ra,24(sp)
    8000638e:	6442                	ld	s0,16(sp)
    80006390:	64a2                	ld	s1,8(sp)
    80006392:	6105                	add	sp,sp,32
    80006394:	8082                	ret
    panic("acquire");
    80006396:	00002517          	auipc	a0,0x2
    8000639a:	34250513          	add	a0,a0,834 # 800086d8 <etext+0x6d8>
    8000639e:	00000097          	auipc	ra,0x0
    800063a2:	9de080e7          	jalr	-1570(ra) # 80005d7c <panic>

00000000800063a6 <pop_off>:

void
pop_off(void)
{
    800063a6:	1141                	add	sp,sp,-16
    800063a8:	e406                	sd	ra,8(sp)
    800063aa:	e022                	sd	s0,0(sp)
    800063ac:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    800063ae:	ffffb097          	auipc	ra,0xffffb
    800063b2:	ab2080e7          	jalr	-1358(ra) # 80000e60 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063b6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063ba:	8b89                	and	a5,a5,2
  if(intr_get())
    800063bc:	e78d                	bnez	a5,800063e6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063be:	5d3c                	lw	a5,120(a0)
    800063c0:	02f05b63          	blez	a5,800063f6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063c4:	37fd                	addw	a5,a5,-1
    800063c6:	0007871b          	sext.w	a4,a5
    800063ca:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063cc:	eb09                	bnez	a4,800063de <pop_off+0x38>
    800063ce:	5d7c                	lw	a5,124(a0)
    800063d0:	c799                	beqz	a5,800063de <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063d2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063d6:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063da:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063de:	60a2                	ld	ra,8(sp)
    800063e0:	6402                	ld	s0,0(sp)
    800063e2:	0141                	add	sp,sp,16
    800063e4:	8082                	ret
    panic("pop_off - interruptible");
    800063e6:	00002517          	auipc	a0,0x2
    800063ea:	2fa50513          	add	a0,a0,762 # 800086e0 <etext+0x6e0>
    800063ee:	00000097          	auipc	ra,0x0
    800063f2:	98e080e7          	jalr	-1650(ra) # 80005d7c <panic>
    panic("pop_off");
    800063f6:	00002517          	auipc	a0,0x2
    800063fa:	30250513          	add	a0,a0,770 # 800086f8 <etext+0x6f8>
    800063fe:	00000097          	auipc	ra,0x0
    80006402:	97e080e7          	jalr	-1666(ra) # 80005d7c <panic>

0000000080006406 <release>:
{
    80006406:	1101                	add	sp,sp,-32
    80006408:	ec06                	sd	ra,24(sp)
    8000640a:	e822                	sd	s0,16(sp)
    8000640c:	e426                	sd	s1,8(sp)
    8000640e:	1000                	add	s0,sp,32
    80006410:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006412:	00000097          	auipc	ra,0x0
    80006416:	ec6080e7          	jalr	-314(ra) # 800062d8 <holding>
    8000641a:	c115                	beqz	a0,8000643e <release+0x38>
  lk->cpu = 0;
    8000641c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006420:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006424:	0f50000f          	fence	iorw,ow
    80006428:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000642c:	00000097          	auipc	ra,0x0
    80006430:	f7a080e7          	jalr	-134(ra) # 800063a6 <pop_off>
}
    80006434:	60e2                	ld	ra,24(sp)
    80006436:	6442                	ld	s0,16(sp)
    80006438:	64a2                	ld	s1,8(sp)
    8000643a:	6105                	add	sp,sp,32
    8000643c:	8082                	ret
    panic("release");
    8000643e:	00002517          	auipc	a0,0x2
    80006442:	2c250513          	add	a0,a0,706 # 80008700 <etext+0x700>
    80006446:	00000097          	auipc	ra,0x0
    8000644a:	936080e7          	jalr	-1738(ra) # 80005d7c <panic>
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
