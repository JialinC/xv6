
user/_test_memory:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[]) {
    1000:	1141                	addi	sp,sp,-16
    1002:	e406                	sd	ra,8(sp)
    1004:	e022                	sd	s0,0(sp)
    1006:	0800                	addi	s0,sp,16
  //  printf("update p2:%p\n", p2);
  //}
  ///////////////////////////////////// read write protection test ///////////////////////////////////////////////////
  
  ///////////////////////////////////////// protect syscall test /////////////////////////////////////////////////////
  int x2 = mprotect((void*)0x1000, 1);
    1008:	4585                	li	a1,1
    100a:	6505                	lui	a0,0x1
    100c:	00000097          	auipc	ra,0x0
    1010:	2c0080e7          	jalr	704(ra) # 12cc <mprotect>
    1014:	85aa                	mv	a1,a0
  printf("XV6_TEST_OUTPUT syscall result:%d\n", x2);
    1016:	00000517          	auipc	a0,0x0
    101a:	74250513          	addi	a0,a0,1858 # 1758 <malloc+0xe6>
    101e:	00000097          	auipc	ra,0x0
    1022:	596080e7          	jalr	1430(ra) # 15b4 <printf>
  uint64 *p2 = (uint64 *)0x1000;
  //int x3 = munprotect((void*)0x1000, 1);
  //printf("XV6_TEST_OUTPUT syscall result:%d\n", x3);
  *p2 = 0;
    1026:	6785                	lui	a5,0x1
    1028:	0007b023          	sd	zero,0(a5) # 1000 <main>
  //int x4 = mprotect((void*)0x1234, 10);
  //printf("XV6_TEST_OUTPUT pass invalid pointer as argument of syscall:%d\n", x3);
  ///////////////////////////////////////// protect syscall test /////////////////////////////////////////////////////

  exit(0);
    102c:	4501                	li	a0,0
    102e:	00000097          	auipc	ra,0x0
    1032:	1fe080e7          	jalr	510(ra) # 122c <exit>

0000000000001036 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    1036:	1141                	addi	sp,sp,-16
    1038:	e422                	sd	s0,8(sp)
    103a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    103c:	87aa                	mv	a5,a0
    103e:	0585                	addi	a1,a1,1
    1040:	0785                	addi	a5,a5,1
    1042:	fff5c703          	lbu	a4,-1(a1)
    1046:	fee78fa3          	sb	a4,-1(a5)
    104a:	fb75                	bnez	a4,103e <strcpy+0x8>
    ;
  return os;
}
    104c:	6422                	ld	s0,8(sp)
    104e:	0141                	addi	sp,sp,16
    1050:	8082                	ret

0000000000001052 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1052:	1141                	addi	sp,sp,-16
    1054:	e422                	sd	s0,8(sp)
    1056:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1058:	00054783          	lbu	a5,0(a0)
    105c:	cb91                	beqz	a5,1070 <strcmp+0x1e>
    105e:	0005c703          	lbu	a4,0(a1)
    1062:	00f71763          	bne	a4,a5,1070 <strcmp+0x1e>
    p++, q++;
    1066:	0505                	addi	a0,a0,1
    1068:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    106a:	00054783          	lbu	a5,0(a0)
    106e:	fbe5                	bnez	a5,105e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1070:	0005c503          	lbu	a0,0(a1)
}
    1074:	40a7853b          	subw	a0,a5,a0
    1078:	6422                	ld	s0,8(sp)
    107a:	0141                	addi	sp,sp,16
    107c:	8082                	ret

000000000000107e <strlen>:

uint
strlen(const char *s)
{
    107e:	1141                	addi	sp,sp,-16
    1080:	e422                	sd	s0,8(sp)
    1082:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    1084:	00054783          	lbu	a5,0(a0)
    1088:	cf91                	beqz	a5,10a4 <strlen+0x26>
    108a:	0505                	addi	a0,a0,1
    108c:	87aa                	mv	a5,a0
    108e:	4685                	li	a3,1
    1090:	9e89                	subw	a3,a3,a0
    1092:	00f6853b          	addw	a0,a3,a5
    1096:	0785                	addi	a5,a5,1
    1098:	fff7c703          	lbu	a4,-1(a5)
    109c:	fb7d                	bnez	a4,1092 <strlen+0x14>
    ;
  return n;
}
    109e:	6422                	ld	s0,8(sp)
    10a0:	0141                	addi	sp,sp,16
    10a2:	8082                	ret
  for(n = 0; s[n]; n++)
    10a4:	4501                	li	a0,0
    10a6:	bfe5                	j	109e <strlen+0x20>

00000000000010a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10a8:	1141                	addi	sp,sp,-16
    10aa:	e422                	sd	s0,8(sp)
    10ac:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10ae:	ce09                	beqz	a2,10c8 <memset+0x20>
    10b0:	87aa                	mv	a5,a0
    10b2:	fff6071b          	addiw	a4,a2,-1
    10b6:	1702                	slli	a4,a4,0x20
    10b8:	9301                	srli	a4,a4,0x20
    10ba:	0705                	addi	a4,a4,1
    10bc:	972a                	add	a4,a4,a0
    cdst[i] = c;
    10be:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    10c2:	0785                	addi	a5,a5,1
    10c4:	fee79de3          	bne	a5,a4,10be <memset+0x16>
  }
  return dst;
}
    10c8:	6422                	ld	s0,8(sp)
    10ca:	0141                	addi	sp,sp,16
    10cc:	8082                	ret

00000000000010ce <strchr>:

char*
strchr(const char *s, char c)
{
    10ce:	1141                	addi	sp,sp,-16
    10d0:	e422                	sd	s0,8(sp)
    10d2:	0800                	addi	s0,sp,16
  for(; *s; s++)
    10d4:	00054783          	lbu	a5,0(a0)
    10d8:	cb99                	beqz	a5,10ee <strchr+0x20>
    if(*s == c)
    10da:	00f58763          	beq	a1,a5,10e8 <strchr+0x1a>
  for(; *s; s++)
    10de:	0505                	addi	a0,a0,1
    10e0:	00054783          	lbu	a5,0(a0)
    10e4:	fbfd                	bnez	a5,10da <strchr+0xc>
      return (char*)s;
  return 0;
    10e6:	4501                	li	a0,0
}
    10e8:	6422                	ld	s0,8(sp)
    10ea:	0141                	addi	sp,sp,16
    10ec:	8082                	ret
  return 0;
    10ee:	4501                	li	a0,0
    10f0:	bfe5                	j	10e8 <strchr+0x1a>

00000000000010f2 <gets>:

char*
gets(char *buf, int max)
{
    10f2:	711d                	addi	sp,sp,-96
    10f4:	ec86                	sd	ra,88(sp)
    10f6:	e8a2                	sd	s0,80(sp)
    10f8:	e4a6                	sd	s1,72(sp)
    10fa:	e0ca                	sd	s2,64(sp)
    10fc:	fc4e                	sd	s3,56(sp)
    10fe:	f852                	sd	s4,48(sp)
    1100:	f456                	sd	s5,40(sp)
    1102:	f05a                	sd	s6,32(sp)
    1104:	ec5e                	sd	s7,24(sp)
    1106:	1080                	addi	s0,sp,96
    1108:	8baa                	mv	s7,a0
    110a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    110c:	892a                	mv	s2,a0
    110e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1110:	4aa9                	li	s5,10
    1112:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1114:	89a6                	mv	s3,s1
    1116:	2485                	addiw	s1,s1,1
    1118:	0344d863          	bge	s1,s4,1148 <gets+0x56>
    cc = read(0, &c, 1);
    111c:	4605                	li	a2,1
    111e:	faf40593          	addi	a1,s0,-81
    1122:	4501                	li	a0,0
    1124:	00000097          	auipc	ra,0x0
    1128:	120080e7          	jalr	288(ra) # 1244 <read>
    if(cc < 1)
    112c:	00a05e63          	blez	a0,1148 <gets+0x56>
    buf[i++] = c;
    1130:	faf44783          	lbu	a5,-81(s0)
    1134:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1138:	01578763          	beq	a5,s5,1146 <gets+0x54>
    113c:	0905                	addi	s2,s2,1
    113e:	fd679be3          	bne	a5,s6,1114 <gets+0x22>
  for(i=0; i+1 < max; ){
    1142:	89a6                	mv	s3,s1
    1144:	a011                	j	1148 <gets+0x56>
    1146:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1148:	99de                	add	s3,s3,s7
    114a:	00098023          	sb	zero,0(s3)
  return buf;
}
    114e:	855e                	mv	a0,s7
    1150:	60e6                	ld	ra,88(sp)
    1152:	6446                	ld	s0,80(sp)
    1154:	64a6                	ld	s1,72(sp)
    1156:	6906                	ld	s2,64(sp)
    1158:	79e2                	ld	s3,56(sp)
    115a:	7a42                	ld	s4,48(sp)
    115c:	7aa2                	ld	s5,40(sp)
    115e:	7b02                	ld	s6,32(sp)
    1160:	6be2                	ld	s7,24(sp)
    1162:	6125                	addi	sp,sp,96
    1164:	8082                	ret

0000000000001166 <stat>:

int
stat(const char *n, struct stat *st)
{
    1166:	1101                	addi	sp,sp,-32
    1168:	ec06                	sd	ra,24(sp)
    116a:	e822                	sd	s0,16(sp)
    116c:	e426                	sd	s1,8(sp)
    116e:	e04a                	sd	s2,0(sp)
    1170:	1000                	addi	s0,sp,32
    1172:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1174:	4581                	li	a1,0
    1176:	00000097          	auipc	ra,0x0
    117a:	0f6080e7          	jalr	246(ra) # 126c <open>
  if(fd < 0)
    117e:	02054563          	bltz	a0,11a8 <stat+0x42>
    1182:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1184:	85ca                	mv	a1,s2
    1186:	00000097          	auipc	ra,0x0
    118a:	0fe080e7          	jalr	254(ra) # 1284 <fstat>
    118e:	892a                	mv	s2,a0
  close(fd);
    1190:	8526                	mv	a0,s1
    1192:	00000097          	auipc	ra,0x0
    1196:	0c2080e7          	jalr	194(ra) # 1254 <close>
  return r;
}
    119a:	854a                	mv	a0,s2
    119c:	60e2                	ld	ra,24(sp)
    119e:	6442                	ld	s0,16(sp)
    11a0:	64a2                	ld	s1,8(sp)
    11a2:	6902                	ld	s2,0(sp)
    11a4:	6105                	addi	sp,sp,32
    11a6:	8082                	ret
    return -1;
    11a8:	597d                	li	s2,-1
    11aa:	bfc5                	j	119a <stat+0x34>

00000000000011ac <atoi>:

int
atoi(const char *s)
{
    11ac:	1141                	addi	sp,sp,-16
    11ae:	e422                	sd	s0,8(sp)
    11b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11b2:	00054603          	lbu	a2,0(a0)
    11b6:	fd06079b          	addiw	a5,a2,-48
    11ba:	0ff7f793          	andi	a5,a5,255
    11be:	4725                	li	a4,9
    11c0:	02f76963          	bltu	a4,a5,11f2 <atoi+0x46>
    11c4:	86aa                	mv	a3,a0
  n = 0;
    11c6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    11c8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    11ca:	0685                	addi	a3,a3,1
    11cc:	0025179b          	slliw	a5,a0,0x2
    11d0:	9fa9                	addw	a5,a5,a0
    11d2:	0017979b          	slliw	a5,a5,0x1
    11d6:	9fb1                	addw	a5,a5,a2
    11d8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    11dc:	0006c603          	lbu	a2,0(a3)
    11e0:	fd06071b          	addiw	a4,a2,-48
    11e4:	0ff77713          	andi	a4,a4,255
    11e8:	fee5f1e3          	bgeu	a1,a4,11ca <atoi+0x1e>
  return n;
}
    11ec:	6422                	ld	s0,8(sp)
    11ee:	0141                	addi	sp,sp,16
    11f0:	8082                	ret
  n = 0;
    11f2:	4501                	li	a0,0
    11f4:	bfe5                	j	11ec <atoi+0x40>

00000000000011f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    11f6:	1141                	addi	sp,sp,-16
    11f8:	e422                	sd	s0,8(sp)
    11fa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    11fc:	02c05163          	blez	a2,121e <memmove+0x28>
    1200:	fff6071b          	addiw	a4,a2,-1
    1204:	1702                	slli	a4,a4,0x20
    1206:	9301                	srli	a4,a4,0x20
    1208:	0705                	addi	a4,a4,1
    120a:	972a                	add	a4,a4,a0
  dst = vdst;
    120c:	87aa                	mv	a5,a0
    *dst++ = *src++;
    120e:	0585                	addi	a1,a1,1
    1210:	0785                	addi	a5,a5,1
    1212:	fff5c683          	lbu	a3,-1(a1)
    1216:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    121a:	fee79ae3          	bne	a5,a4,120e <memmove+0x18>
  return vdst;
}
    121e:	6422                	ld	s0,8(sp)
    1220:	0141                	addi	sp,sp,16
    1222:	8082                	ret

0000000000001224 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1224:	4885                	li	a7,1
 ecall
    1226:	00000073          	ecall
 ret
    122a:	8082                	ret

000000000000122c <exit>:
.global exit
exit:
 li a7, SYS_exit
    122c:	4889                	li	a7,2
 ecall
    122e:	00000073          	ecall
 ret
    1232:	8082                	ret

0000000000001234 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1234:	488d                	li	a7,3
 ecall
    1236:	00000073          	ecall
 ret
    123a:	8082                	ret

000000000000123c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    123c:	4891                	li	a7,4
 ecall
    123e:	00000073          	ecall
 ret
    1242:	8082                	ret

0000000000001244 <read>:
.global read
read:
 li a7, SYS_read
    1244:	4895                	li	a7,5
 ecall
    1246:	00000073          	ecall
 ret
    124a:	8082                	ret

000000000000124c <write>:
.global write
write:
 li a7, SYS_write
    124c:	48c1                	li	a7,16
 ecall
    124e:	00000073          	ecall
 ret
    1252:	8082                	ret

0000000000001254 <close>:
.global close
close:
 li a7, SYS_close
    1254:	48d5                	li	a7,21
 ecall
    1256:	00000073          	ecall
 ret
    125a:	8082                	ret

000000000000125c <kill>:
.global kill
kill:
 li a7, SYS_kill
    125c:	4899                	li	a7,6
 ecall
    125e:	00000073          	ecall
 ret
    1262:	8082                	ret

0000000000001264 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1264:	489d                	li	a7,7
 ecall
    1266:	00000073          	ecall
 ret
    126a:	8082                	ret

000000000000126c <open>:
.global open
open:
 li a7, SYS_open
    126c:	48bd                	li	a7,15
 ecall
    126e:	00000073          	ecall
 ret
    1272:	8082                	ret

0000000000001274 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1274:	48c5                	li	a7,17
 ecall
    1276:	00000073          	ecall
 ret
    127a:	8082                	ret

000000000000127c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    127c:	48c9                	li	a7,18
 ecall
    127e:	00000073          	ecall
 ret
    1282:	8082                	ret

0000000000001284 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1284:	48a1                	li	a7,8
 ecall
    1286:	00000073          	ecall
 ret
    128a:	8082                	ret

000000000000128c <link>:
.global link
link:
 li a7, SYS_link
    128c:	48cd                	li	a7,19
 ecall
    128e:	00000073          	ecall
 ret
    1292:	8082                	ret

0000000000001294 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1294:	48d1                	li	a7,20
 ecall
    1296:	00000073          	ecall
 ret
    129a:	8082                	ret

000000000000129c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    129c:	48a5                	li	a7,9
 ecall
    129e:	00000073          	ecall
 ret
    12a2:	8082                	ret

00000000000012a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
    12a4:	48a9                	li	a7,10
 ecall
    12a6:	00000073          	ecall
 ret
    12aa:	8082                	ret

00000000000012ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    12ac:	48ad                	li	a7,11
 ecall
    12ae:	00000073          	ecall
 ret
    12b2:	8082                	ret

00000000000012b4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    12b4:	48b1                	li	a7,12
 ecall
    12b6:	00000073          	ecall
 ret
    12ba:	8082                	ret

00000000000012bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    12bc:	48b5                	li	a7,13
 ecall
    12be:	00000073          	ecall
 ret
    12c2:	8082                	ret

00000000000012c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    12c4:	48b9                	li	a7,14
 ecall
    12c6:	00000073          	ecall
 ret
    12ca:	8082                	ret

00000000000012cc <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    12cc:	48d9                	li	a7,22
 ecall
    12ce:	00000073          	ecall
 ret
    12d2:	8082                	ret

00000000000012d4 <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    12d4:	48dd                	li	a7,23
 ecall
    12d6:	00000073          	ecall
 ret
    12da:	8082                	ret

00000000000012dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    12dc:	1101                	addi	sp,sp,-32
    12de:	ec06                	sd	ra,24(sp)
    12e0:	e822                	sd	s0,16(sp)
    12e2:	1000                	addi	s0,sp,32
    12e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    12e8:	4605                	li	a2,1
    12ea:	fef40593          	addi	a1,s0,-17
    12ee:	00000097          	auipc	ra,0x0
    12f2:	f5e080e7          	jalr	-162(ra) # 124c <write>
}
    12f6:	60e2                	ld	ra,24(sp)
    12f8:	6442                	ld	s0,16(sp)
    12fa:	6105                	addi	sp,sp,32
    12fc:	8082                	ret

00000000000012fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    12fe:	7139                	addi	sp,sp,-64
    1300:	fc06                	sd	ra,56(sp)
    1302:	f822                	sd	s0,48(sp)
    1304:	f426                	sd	s1,40(sp)
    1306:	f04a                	sd	s2,32(sp)
    1308:	ec4e                	sd	s3,24(sp)
    130a:	0080                	addi	s0,sp,64
    130c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    130e:	c299                	beqz	a3,1314 <printint+0x16>
    1310:	0805c863          	bltz	a1,13a0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1314:	2581                	sext.w	a1,a1
  neg = 0;
    1316:	4881                	li	a7,0
    1318:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    131c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    131e:	2601                	sext.w	a2,a2
    1320:	00000517          	auipc	a0,0x0
    1324:	46850513          	addi	a0,a0,1128 # 1788 <digits>
    1328:	883a                	mv	a6,a4
    132a:	2705                	addiw	a4,a4,1
    132c:	02c5f7bb          	remuw	a5,a1,a2
    1330:	1782                	slli	a5,a5,0x20
    1332:	9381                	srli	a5,a5,0x20
    1334:	97aa                	add	a5,a5,a0
    1336:	0007c783          	lbu	a5,0(a5)
    133a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    133e:	0005879b          	sext.w	a5,a1
    1342:	02c5d5bb          	divuw	a1,a1,a2
    1346:	0685                	addi	a3,a3,1
    1348:	fec7f0e3          	bgeu	a5,a2,1328 <printint+0x2a>
  if(neg)
    134c:	00088b63          	beqz	a7,1362 <printint+0x64>
    buf[i++] = '-';
    1350:	fd040793          	addi	a5,s0,-48
    1354:	973e                	add	a4,a4,a5
    1356:	02d00793          	li	a5,45
    135a:	fef70823          	sb	a5,-16(a4)
    135e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1362:	02e05863          	blez	a4,1392 <printint+0x94>
    1366:	fc040793          	addi	a5,s0,-64
    136a:	00e78933          	add	s2,a5,a4
    136e:	fff78993          	addi	s3,a5,-1
    1372:	99ba                	add	s3,s3,a4
    1374:	377d                	addiw	a4,a4,-1
    1376:	1702                	slli	a4,a4,0x20
    1378:	9301                	srli	a4,a4,0x20
    137a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    137e:	fff94583          	lbu	a1,-1(s2)
    1382:	8526                	mv	a0,s1
    1384:	00000097          	auipc	ra,0x0
    1388:	f58080e7          	jalr	-168(ra) # 12dc <putc>
  while(--i >= 0)
    138c:	197d                	addi	s2,s2,-1
    138e:	ff3918e3          	bne	s2,s3,137e <printint+0x80>
}
    1392:	70e2                	ld	ra,56(sp)
    1394:	7442                	ld	s0,48(sp)
    1396:	74a2                	ld	s1,40(sp)
    1398:	7902                	ld	s2,32(sp)
    139a:	69e2                	ld	s3,24(sp)
    139c:	6121                	addi	sp,sp,64
    139e:	8082                	ret
    x = -xx;
    13a0:	40b005bb          	negw	a1,a1
    neg = 1;
    13a4:	4885                	li	a7,1
    x = -xx;
    13a6:	bf8d                	j	1318 <printint+0x1a>

00000000000013a8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    13a8:	7119                	addi	sp,sp,-128
    13aa:	fc86                	sd	ra,120(sp)
    13ac:	f8a2                	sd	s0,112(sp)
    13ae:	f4a6                	sd	s1,104(sp)
    13b0:	f0ca                	sd	s2,96(sp)
    13b2:	ecce                	sd	s3,88(sp)
    13b4:	e8d2                	sd	s4,80(sp)
    13b6:	e4d6                	sd	s5,72(sp)
    13b8:	e0da                	sd	s6,64(sp)
    13ba:	fc5e                	sd	s7,56(sp)
    13bc:	f862                	sd	s8,48(sp)
    13be:	f466                	sd	s9,40(sp)
    13c0:	f06a                	sd	s10,32(sp)
    13c2:	ec6e                	sd	s11,24(sp)
    13c4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    13c6:	0005c903          	lbu	s2,0(a1)
    13ca:	18090f63          	beqz	s2,1568 <vprintf+0x1c0>
    13ce:	8aaa                	mv	s5,a0
    13d0:	8b32                	mv	s6,a2
    13d2:	00158493          	addi	s1,a1,1
  state = 0;
    13d6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    13d8:	02500a13          	li	s4,37
      if(c == 'd'){
    13dc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    13e0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    13e4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    13e8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    13ec:	00000b97          	auipc	s7,0x0
    13f0:	39cb8b93          	addi	s7,s7,924 # 1788 <digits>
    13f4:	a839                	j	1412 <vprintf+0x6a>
        putc(fd, c);
    13f6:	85ca                	mv	a1,s2
    13f8:	8556                	mv	a0,s5
    13fa:	00000097          	auipc	ra,0x0
    13fe:	ee2080e7          	jalr	-286(ra) # 12dc <putc>
    1402:	a019                	j	1408 <vprintf+0x60>
    } else if(state == '%'){
    1404:	01498f63          	beq	s3,s4,1422 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1408:	0485                	addi	s1,s1,1
    140a:	fff4c903          	lbu	s2,-1(s1)
    140e:	14090d63          	beqz	s2,1568 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1412:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1416:	fe0997e3          	bnez	s3,1404 <vprintf+0x5c>
      if(c == '%'){
    141a:	fd479ee3          	bne	a5,s4,13f6 <vprintf+0x4e>
        state = '%';
    141e:	89be                	mv	s3,a5
    1420:	b7e5                	j	1408 <vprintf+0x60>
      if(c == 'd'){
    1422:	05878063          	beq	a5,s8,1462 <vprintf+0xba>
      } else if(c == 'l') {
    1426:	05978c63          	beq	a5,s9,147e <vprintf+0xd6>
      } else if(c == 'x') {
    142a:	07a78863          	beq	a5,s10,149a <vprintf+0xf2>
      } else if(c == 'p') {
    142e:	09b78463          	beq	a5,s11,14b6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1432:	07300713          	li	a4,115
    1436:	0ce78663          	beq	a5,a4,1502 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    143a:	06300713          	li	a4,99
    143e:	0ee78e63          	beq	a5,a4,153a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1442:	11478863          	beq	a5,s4,1552 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1446:	85d2                	mv	a1,s4
    1448:	8556                	mv	a0,s5
    144a:	00000097          	auipc	ra,0x0
    144e:	e92080e7          	jalr	-366(ra) # 12dc <putc>
        putc(fd, c);
    1452:	85ca                	mv	a1,s2
    1454:	8556                	mv	a0,s5
    1456:	00000097          	auipc	ra,0x0
    145a:	e86080e7          	jalr	-378(ra) # 12dc <putc>
      }
      state = 0;
    145e:	4981                	li	s3,0
    1460:	b765                	j	1408 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1462:	008b0913          	addi	s2,s6,8
    1466:	4685                	li	a3,1
    1468:	4629                	li	a2,10
    146a:	000b2583          	lw	a1,0(s6)
    146e:	8556                	mv	a0,s5
    1470:	00000097          	auipc	ra,0x0
    1474:	e8e080e7          	jalr	-370(ra) # 12fe <printint>
    1478:	8b4a                	mv	s6,s2
      state = 0;
    147a:	4981                	li	s3,0
    147c:	b771                	j	1408 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    147e:	008b0913          	addi	s2,s6,8
    1482:	4681                	li	a3,0
    1484:	4629                	li	a2,10
    1486:	000b2583          	lw	a1,0(s6)
    148a:	8556                	mv	a0,s5
    148c:	00000097          	auipc	ra,0x0
    1490:	e72080e7          	jalr	-398(ra) # 12fe <printint>
    1494:	8b4a                	mv	s6,s2
      state = 0;
    1496:	4981                	li	s3,0
    1498:	bf85                	j	1408 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    149a:	008b0913          	addi	s2,s6,8
    149e:	4681                	li	a3,0
    14a0:	4641                	li	a2,16
    14a2:	000b2583          	lw	a1,0(s6)
    14a6:	8556                	mv	a0,s5
    14a8:	00000097          	auipc	ra,0x0
    14ac:	e56080e7          	jalr	-426(ra) # 12fe <printint>
    14b0:	8b4a                	mv	s6,s2
      state = 0;
    14b2:	4981                	li	s3,0
    14b4:	bf91                	j	1408 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    14b6:	008b0793          	addi	a5,s6,8
    14ba:	f8f43423          	sd	a5,-120(s0)
    14be:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    14c2:	03000593          	li	a1,48
    14c6:	8556                	mv	a0,s5
    14c8:	00000097          	auipc	ra,0x0
    14cc:	e14080e7          	jalr	-492(ra) # 12dc <putc>
  putc(fd, 'x');
    14d0:	85ea                	mv	a1,s10
    14d2:	8556                	mv	a0,s5
    14d4:	00000097          	auipc	ra,0x0
    14d8:	e08080e7          	jalr	-504(ra) # 12dc <putc>
    14dc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    14de:	03c9d793          	srli	a5,s3,0x3c
    14e2:	97de                	add	a5,a5,s7
    14e4:	0007c583          	lbu	a1,0(a5)
    14e8:	8556                	mv	a0,s5
    14ea:	00000097          	auipc	ra,0x0
    14ee:	df2080e7          	jalr	-526(ra) # 12dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    14f2:	0992                	slli	s3,s3,0x4
    14f4:	397d                	addiw	s2,s2,-1
    14f6:	fe0914e3          	bnez	s2,14de <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    14fa:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    14fe:	4981                	li	s3,0
    1500:	b721                	j	1408 <vprintf+0x60>
        s = va_arg(ap, char*);
    1502:	008b0993          	addi	s3,s6,8
    1506:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    150a:	02090163          	beqz	s2,152c <vprintf+0x184>
        while(*s != 0){
    150e:	00094583          	lbu	a1,0(s2)
    1512:	c9a1                	beqz	a1,1562 <vprintf+0x1ba>
          putc(fd, *s);
    1514:	8556                	mv	a0,s5
    1516:	00000097          	auipc	ra,0x0
    151a:	dc6080e7          	jalr	-570(ra) # 12dc <putc>
          s++;
    151e:	0905                	addi	s2,s2,1
        while(*s != 0){
    1520:	00094583          	lbu	a1,0(s2)
    1524:	f9e5                	bnez	a1,1514 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1526:	8b4e                	mv	s6,s3
      state = 0;
    1528:	4981                	li	s3,0
    152a:	bdf9                	j	1408 <vprintf+0x60>
          s = "(null)";
    152c:	00000917          	auipc	s2,0x0
    1530:	25490913          	addi	s2,s2,596 # 1780 <malloc+0x10e>
        while(*s != 0){
    1534:	02800593          	li	a1,40
    1538:	bff1                	j	1514 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    153a:	008b0913          	addi	s2,s6,8
    153e:	000b4583          	lbu	a1,0(s6)
    1542:	8556                	mv	a0,s5
    1544:	00000097          	auipc	ra,0x0
    1548:	d98080e7          	jalr	-616(ra) # 12dc <putc>
    154c:	8b4a                	mv	s6,s2
      state = 0;
    154e:	4981                	li	s3,0
    1550:	bd65                	j	1408 <vprintf+0x60>
        putc(fd, c);
    1552:	85d2                	mv	a1,s4
    1554:	8556                	mv	a0,s5
    1556:	00000097          	auipc	ra,0x0
    155a:	d86080e7          	jalr	-634(ra) # 12dc <putc>
      state = 0;
    155e:	4981                	li	s3,0
    1560:	b565                	j	1408 <vprintf+0x60>
        s = va_arg(ap, char*);
    1562:	8b4e                	mv	s6,s3
      state = 0;
    1564:	4981                	li	s3,0
    1566:	b54d                	j	1408 <vprintf+0x60>
    }
  }
}
    1568:	70e6                	ld	ra,120(sp)
    156a:	7446                	ld	s0,112(sp)
    156c:	74a6                	ld	s1,104(sp)
    156e:	7906                	ld	s2,96(sp)
    1570:	69e6                	ld	s3,88(sp)
    1572:	6a46                	ld	s4,80(sp)
    1574:	6aa6                	ld	s5,72(sp)
    1576:	6b06                	ld	s6,64(sp)
    1578:	7be2                	ld	s7,56(sp)
    157a:	7c42                	ld	s8,48(sp)
    157c:	7ca2                	ld	s9,40(sp)
    157e:	7d02                	ld	s10,32(sp)
    1580:	6de2                	ld	s11,24(sp)
    1582:	6109                	addi	sp,sp,128
    1584:	8082                	ret

0000000000001586 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1586:	715d                	addi	sp,sp,-80
    1588:	ec06                	sd	ra,24(sp)
    158a:	e822                	sd	s0,16(sp)
    158c:	1000                	addi	s0,sp,32
    158e:	e010                	sd	a2,0(s0)
    1590:	e414                	sd	a3,8(s0)
    1592:	e818                	sd	a4,16(s0)
    1594:	ec1c                	sd	a5,24(s0)
    1596:	03043023          	sd	a6,32(s0)
    159a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    159e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    15a2:	8622                	mv	a2,s0
    15a4:	00000097          	auipc	ra,0x0
    15a8:	e04080e7          	jalr	-508(ra) # 13a8 <vprintf>
}
    15ac:	60e2                	ld	ra,24(sp)
    15ae:	6442                	ld	s0,16(sp)
    15b0:	6161                	addi	sp,sp,80
    15b2:	8082                	ret

00000000000015b4 <printf>:

void
printf(const char *fmt, ...)
{
    15b4:	711d                	addi	sp,sp,-96
    15b6:	ec06                	sd	ra,24(sp)
    15b8:	e822                	sd	s0,16(sp)
    15ba:	1000                	addi	s0,sp,32
    15bc:	e40c                	sd	a1,8(s0)
    15be:	e810                	sd	a2,16(s0)
    15c0:	ec14                	sd	a3,24(s0)
    15c2:	f018                	sd	a4,32(s0)
    15c4:	f41c                	sd	a5,40(s0)
    15c6:	03043823          	sd	a6,48(s0)
    15ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    15ce:	00840613          	addi	a2,s0,8
    15d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    15d6:	85aa                	mv	a1,a0
    15d8:	4505                	li	a0,1
    15da:	00000097          	auipc	ra,0x0
    15de:	dce080e7          	jalr	-562(ra) # 13a8 <vprintf>
}
    15e2:	60e2                	ld	ra,24(sp)
    15e4:	6442                	ld	s0,16(sp)
    15e6:	6125                	addi	sp,sp,96
    15e8:	8082                	ret

00000000000015ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15ea:	1141                	addi	sp,sp,-16
    15ec:	e422                	sd	s0,8(sp)
    15ee:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15f0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15f4:	00000797          	auipc	a5,0x0
    15f8:	1ac7b783          	ld	a5,428(a5) # 17a0 <freep>
    15fc:	a805                	j	162c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    15fe:	4618                	lw	a4,8(a2)
    1600:	9db9                	addw	a1,a1,a4
    1602:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1606:	6398                	ld	a4,0(a5)
    1608:	6318                	ld	a4,0(a4)
    160a:	fee53823          	sd	a4,-16(a0)
    160e:	a091                	j	1652 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1610:	ff852703          	lw	a4,-8(a0)
    1614:	9e39                	addw	a2,a2,a4
    1616:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1618:	ff053703          	ld	a4,-16(a0)
    161c:	e398                	sd	a4,0(a5)
    161e:	a099                	j	1664 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1620:	6398                	ld	a4,0(a5)
    1622:	00e7e463          	bltu	a5,a4,162a <free+0x40>
    1626:	00e6ea63          	bltu	a3,a4,163a <free+0x50>
{
    162a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    162c:	fed7fae3          	bgeu	a5,a3,1620 <free+0x36>
    1630:	6398                	ld	a4,0(a5)
    1632:	00e6e463          	bltu	a3,a4,163a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1636:	fee7eae3          	bltu	a5,a4,162a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    163a:	ff852583          	lw	a1,-8(a0)
    163e:	6390                	ld	a2,0(a5)
    1640:	02059713          	slli	a4,a1,0x20
    1644:	9301                	srli	a4,a4,0x20
    1646:	0712                	slli	a4,a4,0x4
    1648:	9736                	add	a4,a4,a3
    164a:	fae60ae3          	beq	a2,a4,15fe <free+0x14>
    bp->s.ptr = p->s.ptr;
    164e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1652:	4790                	lw	a2,8(a5)
    1654:	02061713          	slli	a4,a2,0x20
    1658:	9301                	srli	a4,a4,0x20
    165a:	0712                	slli	a4,a4,0x4
    165c:	973e                	add	a4,a4,a5
    165e:	fae689e3          	beq	a3,a4,1610 <free+0x26>
  } else
    p->s.ptr = bp;
    1662:	e394                	sd	a3,0(a5)
  freep = p;
    1664:	00000717          	auipc	a4,0x0
    1668:	12f73e23          	sd	a5,316(a4) # 17a0 <freep>
}
    166c:	6422                	ld	s0,8(sp)
    166e:	0141                	addi	sp,sp,16
    1670:	8082                	ret

0000000000001672 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1672:	7139                	addi	sp,sp,-64
    1674:	fc06                	sd	ra,56(sp)
    1676:	f822                	sd	s0,48(sp)
    1678:	f426                	sd	s1,40(sp)
    167a:	f04a                	sd	s2,32(sp)
    167c:	ec4e                	sd	s3,24(sp)
    167e:	e852                	sd	s4,16(sp)
    1680:	e456                	sd	s5,8(sp)
    1682:	e05a                	sd	s6,0(sp)
    1684:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1686:	02051493          	slli	s1,a0,0x20
    168a:	9081                	srli	s1,s1,0x20
    168c:	04bd                	addi	s1,s1,15
    168e:	8091                	srli	s1,s1,0x4
    1690:	0014899b          	addiw	s3,s1,1
    1694:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1696:	00000517          	auipc	a0,0x0
    169a:	10a53503          	ld	a0,266(a0) # 17a0 <freep>
    169e:	c515                	beqz	a0,16ca <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    16a2:	4798                	lw	a4,8(a5)
    16a4:	02977f63          	bgeu	a4,s1,16e2 <malloc+0x70>
    16a8:	8a4e                	mv	s4,s3
    16aa:	0009871b          	sext.w	a4,s3
    16ae:	6685                	lui	a3,0x1
    16b0:	00d77363          	bgeu	a4,a3,16b6 <malloc+0x44>
    16b4:	6a05                	lui	s4,0x1
    16b6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    16ba:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    16be:	00000917          	auipc	s2,0x0
    16c2:	0e290913          	addi	s2,s2,226 # 17a0 <freep>
  if(p == (char*)-1)
    16c6:	5afd                	li	s5,-1
    16c8:	a88d                	j	173a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    16ca:	00000797          	auipc	a5,0x0
    16ce:	0de78793          	addi	a5,a5,222 # 17a8 <base>
    16d2:	00000717          	auipc	a4,0x0
    16d6:	0cf73723          	sd	a5,206(a4) # 17a0 <freep>
    16da:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    16dc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    16e0:	b7e1                	j	16a8 <malloc+0x36>
      if(p->s.size == nunits)
    16e2:	02e48b63          	beq	s1,a4,1718 <malloc+0xa6>
        p->s.size -= nunits;
    16e6:	4137073b          	subw	a4,a4,s3
    16ea:	c798                	sw	a4,8(a5)
        p += p->s.size;
    16ec:	1702                	slli	a4,a4,0x20
    16ee:	9301                	srli	a4,a4,0x20
    16f0:	0712                	slli	a4,a4,0x4
    16f2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    16f4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    16f8:	00000717          	auipc	a4,0x0
    16fc:	0aa73423          	sd	a0,168(a4) # 17a0 <freep>
      return (void*)(p + 1);
    1700:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1704:	70e2                	ld	ra,56(sp)
    1706:	7442                	ld	s0,48(sp)
    1708:	74a2                	ld	s1,40(sp)
    170a:	7902                	ld	s2,32(sp)
    170c:	69e2                	ld	s3,24(sp)
    170e:	6a42                	ld	s4,16(sp)
    1710:	6aa2                	ld	s5,8(sp)
    1712:	6b02                	ld	s6,0(sp)
    1714:	6121                	addi	sp,sp,64
    1716:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1718:	6398                	ld	a4,0(a5)
    171a:	e118                	sd	a4,0(a0)
    171c:	bff1                	j	16f8 <malloc+0x86>
  hp->s.size = nu;
    171e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1722:	0541                	addi	a0,a0,16
    1724:	00000097          	auipc	ra,0x0
    1728:	ec6080e7          	jalr	-314(ra) # 15ea <free>
  return freep;
    172c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1730:	d971                	beqz	a0,1704 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1732:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1734:	4798                	lw	a4,8(a5)
    1736:	fa9776e3          	bgeu	a4,s1,16e2 <malloc+0x70>
    if(p == freep)
    173a:	00093703          	ld	a4,0(s2)
    173e:	853e                	mv	a0,a5
    1740:	fef719e3          	bne	a4,a5,1732 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1744:	8552                	mv	a0,s4
    1746:	00000097          	auipc	ra,0x0
    174a:	b6e080e7          	jalr	-1170(ra) # 12b4 <sbrk>
  if(p == (char*)-1)
    174e:	fd5518e3          	bne	a0,s5,171e <malloc+0xac>
        return 0;
    1752:	4501                	li	a0,0
    1754:	bf45                	j	1704 <malloc+0x92>
