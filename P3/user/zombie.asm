
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
    1000:	1141                	addi	sp,sp,-16
    1002:	e406                	sd	ra,8(sp)
    1004:	e022                	sd	s0,0(sp)
    1006:	0800                	addi	s0,sp,16
  if(fork() > 0)
    1008:	00000097          	auipc	ra,0x0
    100c:	210080e7          	jalr	528(ra) # 1218 <fork>
    1010:	00a04763          	bgtz	a0,101e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
    1014:	4501                	li	a0,0
    1016:	00000097          	auipc	ra,0x0
    101a:	20a080e7          	jalr	522(ra) # 1220 <exit>
    sleep(5);  // Let child exit before parent.
    101e:	4515                	li	a0,5
    1020:	00000097          	auipc	ra,0x0
    1024:	290080e7          	jalr	656(ra) # 12b0 <sleep>
    1028:	b7f5                	j	1014 <main+0x14>

000000000000102a <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    102a:	1141                	addi	sp,sp,-16
    102c:	e422                	sd	s0,8(sp)
    102e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1030:	87aa                	mv	a5,a0
    1032:	0585                	addi	a1,a1,1
    1034:	0785                	addi	a5,a5,1
    1036:	fff5c703          	lbu	a4,-1(a1)
    103a:	fee78fa3          	sb	a4,-1(a5)
    103e:	fb75                	bnez	a4,1032 <strcpy+0x8>
    ;
  return os;
}
    1040:	6422                	ld	s0,8(sp)
    1042:	0141                	addi	sp,sp,16
    1044:	8082                	ret

0000000000001046 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1046:	1141                	addi	sp,sp,-16
    1048:	e422                	sd	s0,8(sp)
    104a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    104c:	00054783          	lbu	a5,0(a0)
    1050:	cb91                	beqz	a5,1064 <strcmp+0x1e>
    1052:	0005c703          	lbu	a4,0(a1)
    1056:	00f71763          	bne	a4,a5,1064 <strcmp+0x1e>
    p++, q++;
    105a:	0505                	addi	a0,a0,1
    105c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    105e:	00054783          	lbu	a5,0(a0)
    1062:	fbe5                	bnez	a5,1052 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1064:	0005c503          	lbu	a0,0(a1)
}
    1068:	40a7853b          	subw	a0,a5,a0
    106c:	6422                	ld	s0,8(sp)
    106e:	0141                	addi	sp,sp,16
    1070:	8082                	ret

0000000000001072 <strlen>:

uint
strlen(const char *s)
{
    1072:	1141                	addi	sp,sp,-16
    1074:	e422                	sd	s0,8(sp)
    1076:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    1078:	00054783          	lbu	a5,0(a0)
    107c:	cf91                	beqz	a5,1098 <strlen+0x26>
    107e:	0505                	addi	a0,a0,1
    1080:	87aa                	mv	a5,a0
    1082:	4685                	li	a3,1
    1084:	9e89                	subw	a3,a3,a0
    1086:	00f6853b          	addw	a0,a3,a5
    108a:	0785                	addi	a5,a5,1
    108c:	fff7c703          	lbu	a4,-1(a5)
    1090:	fb7d                	bnez	a4,1086 <strlen+0x14>
    ;
  return n;
}
    1092:	6422                	ld	s0,8(sp)
    1094:	0141                	addi	sp,sp,16
    1096:	8082                	ret
  for(n = 0; s[n]; n++)
    1098:	4501                	li	a0,0
    109a:	bfe5                	j	1092 <strlen+0x20>

000000000000109c <memset>:

void*
memset(void *dst, int c, uint n)
{
    109c:	1141                	addi	sp,sp,-16
    109e:	e422                	sd	s0,8(sp)
    10a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10a2:	ce09                	beqz	a2,10bc <memset+0x20>
    10a4:	87aa                	mv	a5,a0
    10a6:	fff6071b          	addiw	a4,a2,-1
    10aa:	1702                	slli	a4,a4,0x20
    10ac:	9301                	srli	a4,a4,0x20
    10ae:	0705                	addi	a4,a4,1
    10b0:	972a                	add	a4,a4,a0
    cdst[i] = c;
    10b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    10b6:	0785                	addi	a5,a5,1
    10b8:	fee79de3          	bne	a5,a4,10b2 <memset+0x16>
  }
  return dst;
}
    10bc:	6422                	ld	s0,8(sp)
    10be:	0141                	addi	sp,sp,16
    10c0:	8082                	ret

00000000000010c2 <strchr>:

char*
strchr(const char *s, char c)
{
    10c2:	1141                	addi	sp,sp,-16
    10c4:	e422                	sd	s0,8(sp)
    10c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
    10c8:	00054783          	lbu	a5,0(a0)
    10cc:	cb99                	beqz	a5,10e2 <strchr+0x20>
    if(*s == c)
    10ce:	00f58763          	beq	a1,a5,10dc <strchr+0x1a>
  for(; *s; s++)
    10d2:	0505                	addi	a0,a0,1
    10d4:	00054783          	lbu	a5,0(a0)
    10d8:	fbfd                	bnez	a5,10ce <strchr+0xc>
      return (char*)s;
  return 0;
    10da:	4501                	li	a0,0
}
    10dc:	6422                	ld	s0,8(sp)
    10de:	0141                	addi	sp,sp,16
    10e0:	8082                	ret
  return 0;
    10e2:	4501                	li	a0,0
    10e4:	bfe5                	j	10dc <strchr+0x1a>

00000000000010e6 <gets>:

char*
gets(char *buf, int max)
{
    10e6:	711d                	addi	sp,sp,-96
    10e8:	ec86                	sd	ra,88(sp)
    10ea:	e8a2                	sd	s0,80(sp)
    10ec:	e4a6                	sd	s1,72(sp)
    10ee:	e0ca                	sd	s2,64(sp)
    10f0:	fc4e                	sd	s3,56(sp)
    10f2:	f852                	sd	s4,48(sp)
    10f4:	f456                	sd	s5,40(sp)
    10f6:	f05a                	sd	s6,32(sp)
    10f8:	ec5e                	sd	s7,24(sp)
    10fa:	1080                	addi	s0,sp,96
    10fc:	8baa                	mv	s7,a0
    10fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1100:	892a                	mv	s2,a0
    1102:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1104:	4aa9                	li	s5,10
    1106:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1108:	89a6                	mv	s3,s1
    110a:	2485                	addiw	s1,s1,1
    110c:	0344d863          	bge	s1,s4,113c <gets+0x56>
    cc = read(0, &c, 1);
    1110:	4605                	li	a2,1
    1112:	faf40593          	addi	a1,s0,-81
    1116:	4501                	li	a0,0
    1118:	00000097          	auipc	ra,0x0
    111c:	120080e7          	jalr	288(ra) # 1238 <read>
    if(cc < 1)
    1120:	00a05e63          	blez	a0,113c <gets+0x56>
    buf[i++] = c;
    1124:	faf44783          	lbu	a5,-81(s0)
    1128:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    112c:	01578763          	beq	a5,s5,113a <gets+0x54>
    1130:	0905                	addi	s2,s2,1
    1132:	fd679be3          	bne	a5,s6,1108 <gets+0x22>
  for(i=0; i+1 < max; ){
    1136:	89a6                	mv	s3,s1
    1138:	a011                	j	113c <gets+0x56>
    113a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    113c:	99de                	add	s3,s3,s7
    113e:	00098023          	sb	zero,0(s3)
  return buf;
}
    1142:	855e                	mv	a0,s7
    1144:	60e6                	ld	ra,88(sp)
    1146:	6446                	ld	s0,80(sp)
    1148:	64a6                	ld	s1,72(sp)
    114a:	6906                	ld	s2,64(sp)
    114c:	79e2                	ld	s3,56(sp)
    114e:	7a42                	ld	s4,48(sp)
    1150:	7aa2                	ld	s5,40(sp)
    1152:	7b02                	ld	s6,32(sp)
    1154:	6be2                	ld	s7,24(sp)
    1156:	6125                	addi	sp,sp,96
    1158:	8082                	ret

000000000000115a <stat>:

int
stat(const char *n, struct stat *st)
{
    115a:	1101                	addi	sp,sp,-32
    115c:	ec06                	sd	ra,24(sp)
    115e:	e822                	sd	s0,16(sp)
    1160:	e426                	sd	s1,8(sp)
    1162:	e04a                	sd	s2,0(sp)
    1164:	1000                	addi	s0,sp,32
    1166:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1168:	4581                	li	a1,0
    116a:	00000097          	auipc	ra,0x0
    116e:	0f6080e7          	jalr	246(ra) # 1260 <open>
  if(fd < 0)
    1172:	02054563          	bltz	a0,119c <stat+0x42>
    1176:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1178:	85ca                	mv	a1,s2
    117a:	00000097          	auipc	ra,0x0
    117e:	0fe080e7          	jalr	254(ra) # 1278 <fstat>
    1182:	892a                	mv	s2,a0
  close(fd);
    1184:	8526                	mv	a0,s1
    1186:	00000097          	auipc	ra,0x0
    118a:	0c2080e7          	jalr	194(ra) # 1248 <close>
  return r;
}
    118e:	854a                	mv	a0,s2
    1190:	60e2                	ld	ra,24(sp)
    1192:	6442                	ld	s0,16(sp)
    1194:	64a2                	ld	s1,8(sp)
    1196:	6902                	ld	s2,0(sp)
    1198:	6105                	addi	sp,sp,32
    119a:	8082                	ret
    return -1;
    119c:	597d                	li	s2,-1
    119e:	bfc5                	j	118e <stat+0x34>

00000000000011a0 <atoi>:

int
atoi(const char *s)
{
    11a0:	1141                	addi	sp,sp,-16
    11a2:	e422                	sd	s0,8(sp)
    11a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11a6:	00054603          	lbu	a2,0(a0)
    11aa:	fd06079b          	addiw	a5,a2,-48
    11ae:	0ff7f793          	andi	a5,a5,255
    11b2:	4725                	li	a4,9
    11b4:	02f76963          	bltu	a4,a5,11e6 <atoi+0x46>
    11b8:	86aa                	mv	a3,a0
  n = 0;
    11ba:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    11bc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    11be:	0685                	addi	a3,a3,1
    11c0:	0025179b          	slliw	a5,a0,0x2
    11c4:	9fa9                	addw	a5,a5,a0
    11c6:	0017979b          	slliw	a5,a5,0x1
    11ca:	9fb1                	addw	a5,a5,a2
    11cc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    11d0:	0006c603          	lbu	a2,0(a3)
    11d4:	fd06071b          	addiw	a4,a2,-48
    11d8:	0ff77713          	andi	a4,a4,255
    11dc:	fee5f1e3          	bgeu	a1,a4,11be <atoi+0x1e>
  return n;
}
    11e0:	6422                	ld	s0,8(sp)
    11e2:	0141                	addi	sp,sp,16
    11e4:	8082                	ret
  n = 0;
    11e6:	4501                	li	a0,0
    11e8:	bfe5                	j	11e0 <atoi+0x40>

00000000000011ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    11ea:	1141                	addi	sp,sp,-16
    11ec:	e422                	sd	s0,8(sp)
    11ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    11f0:	02c05163          	blez	a2,1212 <memmove+0x28>
    11f4:	fff6071b          	addiw	a4,a2,-1
    11f8:	1702                	slli	a4,a4,0x20
    11fa:	9301                	srli	a4,a4,0x20
    11fc:	0705                	addi	a4,a4,1
    11fe:	972a                	add	a4,a4,a0
  dst = vdst;
    1200:	87aa                	mv	a5,a0
    *dst++ = *src++;
    1202:	0585                	addi	a1,a1,1
    1204:	0785                	addi	a5,a5,1
    1206:	fff5c683          	lbu	a3,-1(a1)
    120a:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    120e:	fee79ae3          	bne	a5,a4,1202 <memmove+0x18>
  return vdst;
}
    1212:	6422                	ld	s0,8(sp)
    1214:	0141                	addi	sp,sp,16
    1216:	8082                	ret

0000000000001218 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1218:	4885                	li	a7,1
 ecall
    121a:	00000073          	ecall
 ret
    121e:	8082                	ret

0000000000001220 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1220:	4889                	li	a7,2
 ecall
    1222:	00000073          	ecall
 ret
    1226:	8082                	ret

0000000000001228 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1228:	488d                	li	a7,3
 ecall
    122a:	00000073          	ecall
 ret
    122e:	8082                	ret

0000000000001230 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1230:	4891                	li	a7,4
 ecall
    1232:	00000073          	ecall
 ret
    1236:	8082                	ret

0000000000001238 <read>:
.global read
read:
 li a7, SYS_read
    1238:	4895                	li	a7,5
 ecall
    123a:	00000073          	ecall
 ret
    123e:	8082                	ret

0000000000001240 <write>:
.global write
write:
 li a7, SYS_write
    1240:	48c1                	li	a7,16
 ecall
    1242:	00000073          	ecall
 ret
    1246:	8082                	ret

0000000000001248 <close>:
.global close
close:
 li a7, SYS_close
    1248:	48d5                	li	a7,21
 ecall
    124a:	00000073          	ecall
 ret
    124e:	8082                	ret

0000000000001250 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1250:	4899                	li	a7,6
 ecall
    1252:	00000073          	ecall
 ret
    1256:	8082                	ret

0000000000001258 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1258:	489d                	li	a7,7
 ecall
    125a:	00000073          	ecall
 ret
    125e:	8082                	ret

0000000000001260 <open>:
.global open
open:
 li a7, SYS_open
    1260:	48bd                	li	a7,15
 ecall
    1262:	00000073          	ecall
 ret
    1266:	8082                	ret

0000000000001268 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1268:	48c5                	li	a7,17
 ecall
    126a:	00000073          	ecall
 ret
    126e:	8082                	ret

0000000000001270 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1270:	48c9                	li	a7,18
 ecall
    1272:	00000073          	ecall
 ret
    1276:	8082                	ret

0000000000001278 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1278:	48a1                	li	a7,8
 ecall
    127a:	00000073          	ecall
 ret
    127e:	8082                	ret

0000000000001280 <link>:
.global link
link:
 li a7, SYS_link
    1280:	48cd                	li	a7,19
 ecall
    1282:	00000073          	ecall
 ret
    1286:	8082                	ret

0000000000001288 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1288:	48d1                	li	a7,20
 ecall
    128a:	00000073          	ecall
 ret
    128e:	8082                	ret

0000000000001290 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1290:	48a5                	li	a7,9
 ecall
    1292:	00000073          	ecall
 ret
    1296:	8082                	ret

0000000000001298 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1298:	48a9                	li	a7,10
 ecall
    129a:	00000073          	ecall
 ret
    129e:	8082                	ret

00000000000012a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    12a0:	48ad                	li	a7,11
 ecall
    12a2:	00000073          	ecall
 ret
    12a6:	8082                	ret

00000000000012a8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    12a8:	48b1                	li	a7,12
 ecall
    12aa:	00000073          	ecall
 ret
    12ae:	8082                	ret

00000000000012b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    12b0:	48b5                	li	a7,13
 ecall
    12b2:	00000073          	ecall
 ret
    12b6:	8082                	ret

00000000000012b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    12b8:	48b9                	li	a7,14
 ecall
    12ba:	00000073          	ecall
 ret
    12be:	8082                	ret

00000000000012c0 <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    12c0:	48d9                	li	a7,22
 ecall
    12c2:	00000073          	ecall
 ret
    12c6:	8082                	ret

00000000000012c8 <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    12c8:	48dd                	li	a7,23
 ecall
    12ca:	00000073          	ecall
 ret
    12ce:	8082                	ret

00000000000012d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    12d0:	1101                	addi	sp,sp,-32
    12d2:	ec06                	sd	ra,24(sp)
    12d4:	e822                	sd	s0,16(sp)
    12d6:	1000                	addi	s0,sp,32
    12d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    12dc:	4605                	li	a2,1
    12de:	fef40593          	addi	a1,s0,-17
    12e2:	00000097          	auipc	ra,0x0
    12e6:	f5e080e7          	jalr	-162(ra) # 1240 <write>
}
    12ea:	60e2                	ld	ra,24(sp)
    12ec:	6442                	ld	s0,16(sp)
    12ee:	6105                	addi	sp,sp,32
    12f0:	8082                	ret

00000000000012f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    12f2:	7139                	addi	sp,sp,-64
    12f4:	fc06                	sd	ra,56(sp)
    12f6:	f822                	sd	s0,48(sp)
    12f8:	f426                	sd	s1,40(sp)
    12fa:	f04a                	sd	s2,32(sp)
    12fc:	ec4e                	sd	s3,24(sp)
    12fe:	0080                	addi	s0,sp,64
    1300:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1302:	c299                	beqz	a3,1308 <printint+0x16>
    1304:	0805c863          	bltz	a1,1394 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1308:	2581                	sext.w	a1,a1
  neg = 0;
    130a:	4881                	li	a7,0
    130c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1310:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1312:	2601                	sext.w	a2,a2
    1314:	00000517          	auipc	a0,0x0
    1318:	44450513          	addi	a0,a0,1092 # 1758 <digits>
    131c:	883a                	mv	a6,a4
    131e:	2705                	addiw	a4,a4,1
    1320:	02c5f7bb          	remuw	a5,a1,a2
    1324:	1782                	slli	a5,a5,0x20
    1326:	9381                	srli	a5,a5,0x20
    1328:	97aa                	add	a5,a5,a0
    132a:	0007c783          	lbu	a5,0(a5)
    132e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1332:	0005879b          	sext.w	a5,a1
    1336:	02c5d5bb          	divuw	a1,a1,a2
    133a:	0685                	addi	a3,a3,1
    133c:	fec7f0e3          	bgeu	a5,a2,131c <printint+0x2a>
  if(neg)
    1340:	00088b63          	beqz	a7,1356 <printint+0x64>
    buf[i++] = '-';
    1344:	fd040793          	addi	a5,s0,-48
    1348:	973e                	add	a4,a4,a5
    134a:	02d00793          	li	a5,45
    134e:	fef70823          	sb	a5,-16(a4)
    1352:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1356:	02e05863          	blez	a4,1386 <printint+0x94>
    135a:	fc040793          	addi	a5,s0,-64
    135e:	00e78933          	add	s2,a5,a4
    1362:	fff78993          	addi	s3,a5,-1
    1366:	99ba                	add	s3,s3,a4
    1368:	377d                	addiw	a4,a4,-1
    136a:	1702                	slli	a4,a4,0x20
    136c:	9301                	srli	a4,a4,0x20
    136e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1372:	fff94583          	lbu	a1,-1(s2)
    1376:	8526                	mv	a0,s1
    1378:	00000097          	auipc	ra,0x0
    137c:	f58080e7          	jalr	-168(ra) # 12d0 <putc>
  while(--i >= 0)
    1380:	197d                	addi	s2,s2,-1
    1382:	ff3918e3          	bne	s2,s3,1372 <printint+0x80>
}
    1386:	70e2                	ld	ra,56(sp)
    1388:	7442                	ld	s0,48(sp)
    138a:	74a2                	ld	s1,40(sp)
    138c:	7902                	ld	s2,32(sp)
    138e:	69e2                	ld	s3,24(sp)
    1390:	6121                	addi	sp,sp,64
    1392:	8082                	ret
    x = -xx;
    1394:	40b005bb          	negw	a1,a1
    neg = 1;
    1398:	4885                	li	a7,1
    x = -xx;
    139a:	bf8d                	j	130c <printint+0x1a>

000000000000139c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    139c:	7119                	addi	sp,sp,-128
    139e:	fc86                	sd	ra,120(sp)
    13a0:	f8a2                	sd	s0,112(sp)
    13a2:	f4a6                	sd	s1,104(sp)
    13a4:	f0ca                	sd	s2,96(sp)
    13a6:	ecce                	sd	s3,88(sp)
    13a8:	e8d2                	sd	s4,80(sp)
    13aa:	e4d6                	sd	s5,72(sp)
    13ac:	e0da                	sd	s6,64(sp)
    13ae:	fc5e                	sd	s7,56(sp)
    13b0:	f862                	sd	s8,48(sp)
    13b2:	f466                	sd	s9,40(sp)
    13b4:	f06a                	sd	s10,32(sp)
    13b6:	ec6e                	sd	s11,24(sp)
    13b8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    13ba:	0005c903          	lbu	s2,0(a1)
    13be:	18090f63          	beqz	s2,155c <vprintf+0x1c0>
    13c2:	8aaa                	mv	s5,a0
    13c4:	8b32                	mv	s6,a2
    13c6:	00158493          	addi	s1,a1,1
  state = 0;
    13ca:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    13cc:	02500a13          	li	s4,37
      if(c == 'd'){
    13d0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    13d4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    13d8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    13dc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    13e0:	00000b97          	auipc	s7,0x0
    13e4:	378b8b93          	addi	s7,s7,888 # 1758 <digits>
    13e8:	a839                	j	1406 <vprintf+0x6a>
        putc(fd, c);
    13ea:	85ca                	mv	a1,s2
    13ec:	8556                	mv	a0,s5
    13ee:	00000097          	auipc	ra,0x0
    13f2:	ee2080e7          	jalr	-286(ra) # 12d0 <putc>
    13f6:	a019                	j	13fc <vprintf+0x60>
    } else if(state == '%'){
    13f8:	01498f63          	beq	s3,s4,1416 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    13fc:	0485                	addi	s1,s1,1
    13fe:	fff4c903          	lbu	s2,-1(s1)
    1402:	14090d63          	beqz	s2,155c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1406:	0009079b          	sext.w	a5,s2
    if(state == 0){
    140a:	fe0997e3          	bnez	s3,13f8 <vprintf+0x5c>
      if(c == '%'){
    140e:	fd479ee3          	bne	a5,s4,13ea <vprintf+0x4e>
        state = '%';
    1412:	89be                	mv	s3,a5
    1414:	b7e5                	j	13fc <vprintf+0x60>
      if(c == 'd'){
    1416:	05878063          	beq	a5,s8,1456 <vprintf+0xba>
      } else if(c == 'l') {
    141a:	05978c63          	beq	a5,s9,1472 <vprintf+0xd6>
      } else if(c == 'x') {
    141e:	07a78863          	beq	a5,s10,148e <vprintf+0xf2>
      } else if(c == 'p') {
    1422:	09b78463          	beq	a5,s11,14aa <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1426:	07300713          	li	a4,115
    142a:	0ce78663          	beq	a5,a4,14f6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    142e:	06300713          	li	a4,99
    1432:	0ee78e63          	beq	a5,a4,152e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1436:	11478863          	beq	a5,s4,1546 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    143a:	85d2                	mv	a1,s4
    143c:	8556                	mv	a0,s5
    143e:	00000097          	auipc	ra,0x0
    1442:	e92080e7          	jalr	-366(ra) # 12d0 <putc>
        putc(fd, c);
    1446:	85ca                	mv	a1,s2
    1448:	8556                	mv	a0,s5
    144a:	00000097          	auipc	ra,0x0
    144e:	e86080e7          	jalr	-378(ra) # 12d0 <putc>
      }
      state = 0;
    1452:	4981                	li	s3,0
    1454:	b765                	j	13fc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1456:	008b0913          	addi	s2,s6,8
    145a:	4685                	li	a3,1
    145c:	4629                	li	a2,10
    145e:	000b2583          	lw	a1,0(s6)
    1462:	8556                	mv	a0,s5
    1464:	00000097          	auipc	ra,0x0
    1468:	e8e080e7          	jalr	-370(ra) # 12f2 <printint>
    146c:	8b4a                	mv	s6,s2
      state = 0;
    146e:	4981                	li	s3,0
    1470:	b771                	j	13fc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1472:	008b0913          	addi	s2,s6,8
    1476:	4681                	li	a3,0
    1478:	4629                	li	a2,10
    147a:	000b2583          	lw	a1,0(s6)
    147e:	8556                	mv	a0,s5
    1480:	00000097          	auipc	ra,0x0
    1484:	e72080e7          	jalr	-398(ra) # 12f2 <printint>
    1488:	8b4a                	mv	s6,s2
      state = 0;
    148a:	4981                	li	s3,0
    148c:	bf85                	j	13fc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    148e:	008b0913          	addi	s2,s6,8
    1492:	4681                	li	a3,0
    1494:	4641                	li	a2,16
    1496:	000b2583          	lw	a1,0(s6)
    149a:	8556                	mv	a0,s5
    149c:	00000097          	auipc	ra,0x0
    14a0:	e56080e7          	jalr	-426(ra) # 12f2 <printint>
    14a4:	8b4a                	mv	s6,s2
      state = 0;
    14a6:	4981                	li	s3,0
    14a8:	bf91                	j	13fc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    14aa:	008b0793          	addi	a5,s6,8
    14ae:	f8f43423          	sd	a5,-120(s0)
    14b2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    14b6:	03000593          	li	a1,48
    14ba:	8556                	mv	a0,s5
    14bc:	00000097          	auipc	ra,0x0
    14c0:	e14080e7          	jalr	-492(ra) # 12d0 <putc>
  putc(fd, 'x');
    14c4:	85ea                	mv	a1,s10
    14c6:	8556                	mv	a0,s5
    14c8:	00000097          	auipc	ra,0x0
    14cc:	e08080e7          	jalr	-504(ra) # 12d0 <putc>
    14d0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    14d2:	03c9d793          	srli	a5,s3,0x3c
    14d6:	97de                	add	a5,a5,s7
    14d8:	0007c583          	lbu	a1,0(a5)
    14dc:	8556                	mv	a0,s5
    14de:	00000097          	auipc	ra,0x0
    14e2:	df2080e7          	jalr	-526(ra) # 12d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    14e6:	0992                	slli	s3,s3,0x4
    14e8:	397d                	addiw	s2,s2,-1
    14ea:	fe0914e3          	bnez	s2,14d2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    14ee:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    14f2:	4981                	li	s3,0
    14f4:	b721                	j	13fc <vprintf+0x60>
        s = va_arg(ap, char*);
    14f6:	008b0993          	addi	s3,s6,8
    14fa:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    14fe:	02090163          	beqz	s2,1520 <vprintf+0x184>
        while(*s != 0){
    1502:	00094583          	lbu	a1,0(s2)
    1506:	c9a1                	beqz	a1,1556 <vprintf+0x1ba>
          putc(fd, *s);
    1508:	8556                	mv	a0,s5
    150a:	00000097          	auipc	ra,0x0
    150e:	dc6080e7          	jalr	-570(ra) # 12d0 <putc>
          s++;
    1512:	0905                	addi	s2,s2,1
        while(*s != 0){
    1514:	00094583          	lbu	a1,0(s2)
    1518:	f9e5                	bnez	a1,1508 <vprintf+0x16c>
        s = va_arg(ap, char*);
    151a:	8b4e                	mv	s6,s3
      state = 0;
    151c:	4981                	li	s3,0
    151e:	bdf9                	j	13fc <vprintf+0x60>
          s = "(null)";
    1520:	00000917          	auipc	s2,0x0
    1524:	23090913          	addi	s2,s2,560 # 1750 <malloc+0xea>
        while(*s != 0){
    1528:	02800593          	li	a1,40
    152c:	bff1                	j	1508 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    152e:	008b0913          	addi	s2,s6,8
    1532:	000b4583          	lbu	a1,0(s6)
    1536:	8556                	mv	a0,s5
    1538:	00000097          	auipc	ra,0x0
    153c:	d98080e7          	jalr	-616(ra) # 12d0 <putc>
    1540:	8b4a                	mv	s6,s2
      state = 0;
    1542:	4981                	li	s3,0
    1544:	bd65                	j	13fc <vprintf+0x60>
        putc(fd, c);
    1546:	85d2                	mv	a1,s4
    1548:	8556                	mv	a0,s5
    154a:	00000097          	auipc	ra,0x0
    154e:	d86080e7          	jalr	-634(ra) # 12d0 <putc>
      state = 0;
    1552:	4981                	li	s3,0
    1554:	b565                	j	13fc <vprintf+0x60>
        s = va_arg(ap, char*);
    1556:	8b4e                	mv	s6,s3
      state = 0;
    1558:	4981                	li	s3,0
    155a:	b54d                	j	13fc <vprintf+0x60>
    }
  }
}
    155c:	70e6                	ld	ra,120(sp)
    155e:	7446                	ld	s0,112(sp)
    1560:	74a6                	ld	s1,104(sp)
    1562:	7906                	ld	s2,96(sp)
    1564:	69e6                	ld	s3,88(sp)
    1566:	6a46                	ld	s4,80(sp)
    1568:	6aa6                	ld	s5,72(sp)
    156a:	6b06                	ld	s6,64(sp)
    156c:	7be2                	ld	s7,56(sp)
    156e:	7c42                	ld	s8,48(sp)
    1570:	7ca2                	ld	s9,40(sp)
    1572:	7d02                	ld	s10,32(sp)
    1574:	6de2                	ld	s11,24(sp)
    1576:	6109                	addi	sp,sp,128
    1578:	8082                	ret

000000000000157a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    157a:	715d                	addi	sp,sp,-80
    157c:	ec06                	sd	ra,24(sp)
    157e:	e822                	sd	s0,16(sp)
    1580:	1000                	addi	s0,sp,32
    1582:	e010                	sd	a2,0(s0)
    1584:	e414                	sd	a3,8(s0)
    1586:	e818                	sd	a4,16(s0)
    1588:	ec1c                	sd	a5,24(s0)
    158a:	03043023          	sd	a6,32(s0)
    158e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1592:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1596:	8622                	mv	a2,s0
    1598:	00000097          	auipc	ra,0x0
    159c:	e04080e7          	jalr	-508(ra) # 139c <vprintf>
}
    15a0:	60e2                	ld	ra,24(sp)
    15a2:	6442                	ld	s0,16(sp)
    15a4:	6161                	addi	sp,sp,80
    15a6:	8082                	ret

00000000000015a8 <printf>:

void
printf(const char *fmt, ...)
{
    15a8:	711d                	addi	sp,sp,-96
    15aa:	ec06                	sd	ra,24(sp)
    15ac:	e822                	sd	s0,16(sp)
    15ae:	1000                	addi	s0,sp,32
    15b0:	e40c                	sd	a1,8(s0)
    15b2:	e810                	sd	a2,16(s0)
    15b4:	ec14                	sd	a3,24(s0)
    15b6:	f018                	sd	a4,32(s0)
    15b8:	f41c                	sd	a5,40(s0)
    15ba:	03043823          	sd	a6,48(s0)
    15be:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    15c2:	00840613          	addi	a2,s0,8
    15c6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    15ca:	85aa                	mv	a1,a0
    15cc:	4505                	li	a0,1
    15ce:	00000097          	auipc	ra,0x0
    15d2:	dce080e7          	jalr	-562(ra) # 139c <vprintf>
}
    15d6:	60e2                	ld	ra,24(sp)
    15d8:	6442                	ld	s0,16(sp)
    15da:	6125                	addi	sp,sp,96
    15dc:	8082                	ret

00000000000015de <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15de:	1141                	addi	sp,sp,-16
    15e0:	e422                	sd	s0,8(sp)
    15e2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15e4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15e8:	00000797          	auipc	a5,0x0
    15ec:	1887b783          	ld	a5,392(a5) # 1770 <freep>
    15f0:	a805                	j	1620 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    15f2:	4618                	lw	a4,8(a2)
    15f4:	9db9                	addw	a1,a1,a4
    15f6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    15fa:	6398                	ld	a4,0(a5)
    15fc:	6318                	ld	a4,0(a4)
    15fe:	fee53823          	sd	a4,-16(a0)
    1602:	a091                	j	1646 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1604:	ff852703          	lw	a4,-8(a0)
    1608:	9e39                	addw	a2,a2,a4
    160a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    160c:	ff053703          	ld	a4,-16(a0)
    1610:	e398                	sd	a4,0(a5)
    1612:	a099                	j	1658 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1614:	6398                	ld	a4,0(a5)
    1616:	00e7e463          	bltu	a5,a4,161e <free+0x40>
    161a:	00e6ea63          	bltu	a3,a4,162e <free+0x50>
{
    161e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1620:	fed7fae3          	bgeu	a5,a3,1614 <free+0x36>
    1624:	6398                	ld	a4,0(a5)
    1626:	00e6e463          	bltu	a3,a4,162e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    162a:	fee7eae3          	bltu	a5,a4,161e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    162e:	ff852583          	lw	a1,-8(a0)
    1632:	6390                	ld	a2,0(a5)
    1634:	02059713          	slli	a4,a1,0x20
    1638:	9301                	srli	a4,a4,0x20
    163a:	0712                	slli	a4,a4,0x4
    163c:	9736                	add	a4,a4,a3
    163e:	fae60ae3          	beq	a2,a4,15f2 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1642:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1646:	4790                	lw	a2,8(a5)
    1648:	02061713          	slli	a4,a2,0x20
    164c:	9301                	srli	a4,a4,0x20
    164e:	0712                	slli	a4,a4,0x4
    1650:	973e                	add	a4,a4,a5
    1652:	fae689e3          	beq	a3,a4,1604 <free+0x26>
  } else
    p->s.ptr = bp;
    1656:	e394                	sd	a3,0(a5)
  freep = p;
    1658:	00000717          	auipc	a4,0x0
    165c:	10f73c23          	sd	a5,280(a4) # 1770 <freep>
}
    1660:	6422                	ld	s0,8(sp)
    1662:	0141                	addi	sp,sp,16
    1664:	8082                	ret

0000000000001666 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1666:	7139                	addi	sp,sp,-64
    1668:	fc06                	sd	ra,56(sp)
    166a:	f822                	sd	s0,48(sp)
    166c:	f426                	sd	s1,40(sp)
    166e:	f04a                	sd	s2,32(sp)
    1670:	ec4e                	sd	s3,24(sp)
    1672:	e852                	sd	s4,16(sp)
    1674:	e456                	sd	s5,8(sp)
    1676:	e05a                	sd	s6,0(sp)
    1678:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    167a:	02051493          	slli	s1,a0,0x20
    167e:	9081                	srli	s1,s1,0x20
    1680:	04bd                	addi	s1,s1,15
    1682:	8091                	srli	s1,s1,0x4
    1684:	0014899b          	addiw	s3,s1,1
    1688:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    168a:	00000517          	auipc	a0,0x0
    168e:	0e653503          	ld	a0,230(a0) # 1770 <freep>
    1692:	c515                	beqz	a0,16be <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1694:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1696:	4798                	lw	a4,8(a5)
    1698:	02977f63          	bgeu	a4,s1,16d6 <malloc+0x70>
    169c:	8a4e                	mv	s4,s3
    169e:	0009871b          	sext.w	a4,s3
    16a2:	6685                	lui	a3,0x1
    16a4:	00d77363          	bgeu	a4,a3,16aa <malloc+0x44>
    16a8:	6a05                	lui	s4,0x1
    16aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    16ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    16b2:	00000917          	auipc	s2,0x0
    16b6:	0be90913          	addi	s2,s2,190 # 1770 <freep>
  if(p == (char*)-1)
    16ba:	5afd                	li	s5,-1
    16bc:	a88d                	j	172e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    16be:	00000797          	auipc	a5,0x0
    16c2:	0ba78793          	addi	a5,a5,186 # 1778 <base>
    16c6:	00000717          	auipc	a4,0x0
    16ca:	0af73523          	sd	a5,170(a4) # 1770 <freep>
    16ce:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    16d0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    16d4:	b7e1                	j	169c <malloc+0x36>
      if(p->s.size == nunits)
    16d6:	02e48b63          	beq	s1,a4,170c <malloc+0xa6>
        p->s.size -= nunits;
    16da:	4137073b          	subw	a4,a4,s3
    16de:	c798                	sw	a4,8(a5)
        p += p->s.size;
    16e0:	1702                	slli	a4,a4,0x20
    16e2:	9301                	srli	a4,a4,0x20
    16e4:	0712                	slli	a4,a4,0x4
    16e6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    16e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    16ec:	00000717          	auipc	a4,0x0
    16f0:	08a73223          	sd	a0,132(a4) # 1770 <freep>
      return (void*)(p + 1);
    16f4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    16f8:	70e2                	ld	ra,56(sp)
    16fa:	7442                	ld	s0,48(sp)
    16fc:	74a2                	ld	s1,40(sp)
    16fe:	7902                	ld	s2,32(sp)
    1700:	69e2                	ld	s3,24(sp)
    1702:	6a42                	ld	s4,16(sp)
    1704:	6aa2                	ld	s5,8(sp)
    1706:	6b02                	ld	s6,0(sp)
    1708:	6121                	addi	sp,sp,64
    170a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    170c:	6398                	ld	a4,0(a5)
    170e:	e118                	sd	a4,0(a0)
    1710:	bff1                	j	16ec <malloc+0x86>
  hp->s.size = nu;
    1712:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1716:	0541                	addi	a0,a0,16
    1718:	00000097          	auipc	ra,0x0
    171c:	ec6080e7          	jalr	-314(ra) # 15de <free>
  return freep;
    1720:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1724:	d971                	beqz	a0,16f8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1726:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1728:	4798                	lw	a4,8(a5)
    172a:	fa9776e3          	bgeu	a4,s1,16d6 <malloc+0x70>
    if(p == freep)
    172e:	00093703          	ld	a4,0(s2)
    1732:	853e                	mv	a0,a5
    1734:	fef719e3          	bne	a4,a5,1726 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1738:	8552                	mv	a0,s4
    173a:	00000097          	auipc	ra,0x0
    173e:	b6e080e7          	jalr	-1170(ra) # 12a8 <sbrk>
  if(p == (char*)-1)
    1742:	fd5518e3          	bne	a0,s5,1712 <malloc+0xac>
        return 0;
    1746:	4501                	li	a0,0
    1748:	bf45                	j	16f8 <malloc+0x92>
