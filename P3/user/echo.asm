
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
    1000:	7179                	addi	sp,sp,-48
    1002:	f406                	sd	ra,40(sp)
    1004:	f022                	sd	s0,32(sp)
    1006:	ec26                	sd	s1,24(sp)
    1008:	e84a                	sd	s2,16(sp)
    100a:	e44e                	sd	s3,8(sp)
    100c:	e052                	sd	s4,0(sp)
    100e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
    1010:	4785                	li	a5,1
    1012:	06a7d463          	bge	a5,a0,107a <main+0x7a>
    1016:	00858493          	addi	s1,a1,8
    101a:	ffe5099b          	addiw	s3,a0,-2
    101e:	1982                	slli	s3,s3,0x20
    1020:	0209d993          	srli	s3,s3,0x20
    1024:	098e                	slli	s3,s3,0x3
    1026:	05c1                	addi	a1,a1,16
    1028:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
    102a:	00000a17          	auipc	s4,0x0
    102e:	77ea0a13          	addi	s4,s4,1918 # 17a8 <malloc+0xe8>
    write(1, argv[i], strlen(argv[i]));
    1032:	0004b903          	ld	s2,0(s1)
    1036:	854a                	mv	a0,s2
    1038:	00000097          	auipc	ra,0x0
    103c:	094080e7          	jalr	148(ra) # 10cc <strlen>
    1040:	0005061b          	sext.w	a2,a0
    1044:	85ca                	mv	a1,s2
    1046:	4505                	li	a0,1
    1048:	00000097          	auipc	ra,0x0
    104c:	252080e7          	jalr	594(ra) # 129a <write>
    if(i + 1 < argc){
    1050:	04a1                	addi	s1,s1,8
    1052:	01348a63          	beq	s1,s3,1066 <main+0x66>
      write(1, " ", 1);
    1056:	4605                	li	a2,1
    1058:	85d2                	mv	a1,s4
    105a:	4505                	li	a0,1
    105c:	00000097          	auipc	ra,0x0
    1060:	23e080e7          	jalr	574(ra) # 129a <write>
  for(i = 1; i < argc; i++){
    1064:	b7f9                	j	1032 <main+0x32>
    } else {
      write(1, "\n", 1);
    1066:	4605                	li	a2,1
    1068:	00000597          	auipc	a1,0x0
    106c:	74858593          	addi	a1,a1,1864 # 17b0 <malloc+0xf0>
    1070:	4505                	li	a0,1
    1072:	00000097          	auipc	ra,0x0
    1076:	228080e7          	jalr	552(ra) # 129a <write>
    }
  }
  exit(0);
    107a:	4501                	li	a0,0
    107c:	00000097          	auipc	ra,0x0
    1080:	1fe080e7          	jalr	510(ra) # 127a <exit>

0000000000001084 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    1084:	1141                	addi	sp,sp,-16
    1086:	e422                	sd	s0,8(sp)
    1088:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    108a:	87aa                	mv	a5,a0
    108c:	0585                	addi	a1,a1,1
    108e:	0785                	addi	a5,a5,1
    1090:	fff5c703          	lbu	a4,-1(a1)
    1094:	fee78fa3          	sb	a4,-1(a5)
    1098:	fb75                	bnez	a4,108c <strcpy+0x8>
    ;
  return os;
}
    109a:	6422                	ld	s0,8(sp)
    109c:	0141                	addi	sp,sp,16
    109e:	8082                	ret

00000000000010a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10a0:	1141                	addi	sp,sp,-16
    10a2:	e422                	sd	s0,8(sp)
    10a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    10a6:	00054783          	lbu	a5,0(a0)
    10aa:	cb91                	beqz	a5,10be <strcmp+0x1e>
    10ac:	0005c703          	lbu	a4,0(a1)
    10b0:	00f71763          	bne	a4,a5,10be <strcmp+0x1e>
    p++, q++;
    10b4:	0505                	addi	a0,a0,1
    10b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    10b8:	00054783          	lbu	a5,0(a0)
    10bc:	fbe5                	bnez	a5,10ac <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    10be:	0005c503          	lbu	a0,0(a1)
}
    10c2:	40a7853b          	subw	a0,a5,a0
    10c6:	6422                	ld	s0,8(sp)
    10c8:	0141                	addi	sp,sp,16
    10ca:	8082                	ret

00000000000010cc <strlen>:

uint
strlen(const char *s)
{
    10cc:	1141                	addi	sp,sp,-16
    10ce:	e422                	sd	s0,8(sp)
    10d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    10d2:	00054783          	lbu	a5,0(a0)
    10d6:	cf91                	beqz	a5,10f2 <strlen+0x26>
    10d8:	0505                	addi	a0,a0,1
    10da:	87aa                	mv	a5,a0
    10dc:	4685                	li	a3,1
    10de:	9e89                	subw	a3,a3,a0
    10e0:	00f6853b          	addw	a0,a3,a5
    10e4:	0785                	addi	a5,a5,1
    10e6:	fff7c703          	lbu	a4,-1(a5)
    10ea:	fb7d                	bnez	a4,10e0 <strlen+0x14>
    ;
  return n;
}
    10ec:	6422                	ld	s0,8(sp)
    10ee:	0141                	addi	sp,sp,16
    10f0:	8082                	ret
  for(n = 0; s[n]; n++)
    10f2:	4501                	li	a0,0
    10f4:	bfe5                	j	10ec <strlen+0x20>

00000000000010f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10f6:	1141                	addi	sp,sp,-16
    10f8:	e422                	sd	s0,8(sp)
    10fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10fc:	ce09                	beqz	a2,1116 <memset+0x20>
    10fe:	87aa                	mv	a5,a0
    1100:	fff6071b          	addiw	a4,a2,-1
    1104:	1702                	slli	a4,a4,0x20
    1106:	9301                	srli	a4,a4,0x20
    1108:	0705                	addi	a4,a4,1
    110a:	972a                	add	a4,a4,a0
    cdst[i] = c;
    110c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1110:	0785                	addi	a5,a5,1
    1112:	fee79de3          	bne	a5,a4,110c <memset+0x16>
  }
  return dst;
}
    1116:	6422                	ld	s0,8(sp)
    1118:	0141                	addi	sp,sp,16
    111a:	8082                	ret

000000000000111c <strchr>:

char*
strchr(const char *s, char c)
{
    111c:	1141                	addi	sp,sp,-16
    111e:	e422                	sd	s0,8(sp)
    1120:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1122:	00054783          	lbu	a5,0(a0)
    1126:	cb99                	beqz	a5,113c <strchr+0x20>
    if(*s == c)
    1128:	00f58763          	beq	a1,a5,1136 <strchr+0x1a>
  for(; *s; s++)
    112c:	0505                	addi	a0,a0,1
    112e:	00054783          	lbu	a5,0(a0)
    1132:	fbfd                	bnez	a5,1128 <strchr+0xc>
      return (char*)s;
  return 0;
    1134:	4501                	li	a0,0
}
    1136:	6422                	ld	s0,8(sp)
    1138:	0141                	addi	sp,sp,16
    113a:	8082                	ret
  return 0;
    113c:	4501                	li	a0,0
    113e:	bfe5                	j	1136 <strchr+0x1a>

0000000000001140 <gets>:

char*
gets(char *buf, int max)
{
    1140:	711d                	addi	sp,sp,-96
    1142:	ec86                	sd	ra,88(sp)
    1144:	e8a2                	sd	s0,80(sp)
    1146:	e4a6                	sd	s1,72(sp)
    1148:	e0ca                	sd	s2,64(sp)
    114a:	fc4e                	sd	s3,56(sp)
    114c:	f852                	sd	s4,48(sp)
    114e:	f456                	sd	s5,40(sp)
    1150:	f05a                	sd	s6,32(sp)
    1152:	ec5e                	sd	s7,24(sp)
    1154:	1080                	addi	s0,sp,96
    1156:	8baa                	mv	s7,a0
    1158:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    115a:	892a                	mv	s2,a0
    115c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    115e:	4aa9                	li	s5,10
    1160:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1162:	89a6                	mv	s3,s1
    1164:	2485                	addiw	s1,s1,1
    1166:	0344d863          	bge	s1,s4,1196 <gets+0x56>
    cc = read(0, &c, 1);
    116a:	4605                	li	a2,1
    116c:	faf40593          	addi	a1,s0,-81
    1170:	4501                	li	a0,0
    1172:	00000097          	auipc	ra,0x0
    1176:	120080e7          	jalr	288(ra) # 1292 <read>
    if(cc < 1)
    117a:	00a05e63          	blez	a0,1196 <gets+0x56>
    buf[i++] = c;
    117e:	faf44783          	lbu	a5,-81(s0)
    1182:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1186:	01578763          	beq	a5,s5,1194 <gets+0x54>
    118a:	0905                	addi	s2,s2,1
    118c:	fd679be3          	bne	a5,s6,1162 <gets+0x22>
  for(i=0; i+1 < max; ){
    1190:	89a6                	mv	s3,s1
    1192:	a011                	j	1196 <gets+0x56>
    1194:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1196:	99de                	add	s3,s3,s7
    1198:	00098023          	sb	zero,0(s3)
  return buf;
}
    119c:	855e                	mv	a0,s7
    119e:	60e6                	ld	ra,88(sp)
    11a0:	6446                	ld	s0,80(sp)
    11a2:	64a6                	ld	s1,72(sp)
    11a4:	6906                	ld	s2,64(sp)
    11a6:	79e2                	ld	s3,56(sp)
    11a8:	7a42                	ld	s4,48(sp)
    11aa:	7aa2                	ld	s5,40(sp)
    11ac:	7b02                	ld	s6,32(sp)
    11ae:	6be2                	ld	s7,24(sp)
    11b0:	6125                	addi	sp,sp,96
    11b2:	8082                	ret

00000000000011b4 <stat>:

int
stat(const char *n, struct stat *st)
{
    11b4:	1101                	addi	sp,sp,-32
    11b6:	ec06                	sd	ra,24(sp)
    11b8:	e822                	sd	s0,16(sp)
    11ba:	e426                	sd	s1,8(sp)
    11bc:	e04a                	sd	s2,0(sp)
    11be:	1000                	addi	s0,sp,32
    11c0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11c2:	4581                	li	a1,0
    11c4:	00000097          	auipc	ra,0x0
    11c8:	0f6080e7          	jalr	246(ra) # 12ba <open>
  if(fd < 0)
    11cc:	02054563          	bltz	a0,11f6 <stat+0x42>
    11d0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    11d2:	85ca                	mv	a1,s2
    11d4:	00000097          	auipc	ra,0x0
    11d8:	0fe080e7          	jalr	254(ra) # 12d2 <fstat>
    11dc:	892a                	mv	s2,a0
  close(fd);
    11de:	8526                	mv	a0,s1
    11e0:	00000097          	auipc	ra,0x0
    11e4:	0c2080e7          	jalr	194(ra) # 12a2 <close>
  return r;
}
    11e8:	854a                	mv	a0,s2
    11ea:	60e2                	ld	ra,24(sp)
    11ec:	6442                	ld	s0,16(sp)
    11ee:	64a2                	ld	s1,8(sp)
    11f0:	6902                	ld	s2,0(sp)
    11f2:	6105                	addi	sp,sp,32
    11f4:	8082                	ret
    return -1;
    11f6:	597d                	li	s2,-1
    11f8:	bfc5                	j	11e8 <stat+0x34>

00000000000011fa <atoi>:

int
atoi(const char *s)
{
    11fa:	1141                	addi	sp,sp,-16
    11fc:	e422                	sd	s0,8(sp)
    11fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1200:	00054603          	lbu	a2,0(a0)
    1204:	fd06079b          	addiw	a5,a2,-48
    1208:	0ff7f793          	andi	a5,a5,255
    120c:	4725                	li	a4,9
    120e:	02f76963          	bltu	a4,a5,1240 <atoi+0x46>
    1212:	86aa                	mv	a3,a0
  n = 0;
    1214:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    1216:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    1218:	0685                	addi	a3,a3,1
    121a:	0025179b          	slliw	a5,a0,0x2
    121e:	9fa9                	addw	a5,a5,a0
    1220:	0017979b          	slliw	a5,a5,0x1
    1224:	9fb1                	addw	a5,a5,a2
    1226:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    122a:	0006c603          	lbu	a2,0(a3)
    122e:	fd06071b          	addiw	a4,a2,-48
    1232:	0ff77713          	andi	a4,a4,255
    1236:	fee5f1e3          	bgeu	a1,a4,1218 <atoi+0x1e>
  return n;
}
    123a:	6422                	ld	s0,8(sp)
    123c:	0141                	addi	sp,sp,16
    123e:	8082                	ret
  n = 0;
    1240:	4501                	li	a0,0
    1242:	bfe5                	j	123a <atoi+0x40>

0000000000001244 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1244:	1141                	addi	sp,sp,-16
    1246:	e422                	sd	s0,8(sp)
    1248:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    124a:	02c05163          	blez	a2,126c <memmove+0x28>
    124e:	fff6071b          	addiw	a4,a2,-1
    1252:	1702                	slli	a4,a4,0x20
    1254:	9301                	srli	a4,a4,0x20
    1256:	0705                	addi	a4,a4,1
    1258:	972a                	add	a4,a4,a0
  dst = vdst;
    125a:	87aa                	mv	a5,a0
    *dst++ = *src++;
    125c:	0585                	addi	a1,a1,1
    125e:	0785                	addi	a5,a5,1
    1260:	fff5c683          	lbu	a3,-1(a1)
    1264:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    1268:	fee79ae3          	bne	a5,a4,125c <memmove+0x18>
  return vdst;
}
    126c:	6422                	ld	s0,8(sp)
    126e:	0141                	addi	sp,sp,16
    1270:	8082                	ret

0000000000001272 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1272:	4885                	li	a7,1
 ecall
    1274:	00000073          	ecall
 ret
    1278:	8082                	ret

000000000000127a <exit>:
.global exit
exit:
 li a7, SYS_exit
    127a:	4889                	li	a7,2
 ecall
    127c:	00000073          	ecall
 ret
    1280:	8082                	ret

0000000000001282 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1282:	488d                	li	a7,3
 ecall
    1284:	00000073          	ecall
 ret
    1288:	8082                	ret

000000000000128a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    128a:	4891                	li	a7,4
 ecall
    128c:	00000073          	ecall
 ret
    1290:	8082                	ret

0000000000001292 <read>:
.global read
read:
 li a7, SYS_read
    1292:	4895                	li	a7,5
 ecall
    1294:	00000073          	ecall
 ret
    1298:	8082                	ret

000000000000129a <write>:
.global write
write:
 li a7, SYS_write
    129a:	48c1                	li	a7,16
 ecall
    129c:	00000073          	ecall
 ret
    12a0:	8082                	ret

00000000000012a2 <close>:
.global close
close:
 li a7, SYS_close
    12a2:	48d5                	li	a7,21
 ecall
    12a4:	00000073          	ecall
 ret
    12a8:	8082                	ret

00000000000012aa <kill>:
.global kill
kill:
 li a7, SYS_kill
    12aa:	4899                	li	a7,6
 ecall
    12ac:	00000073          	ecall
 ret
    12b0:	8082                	ret

00000000000012b2 <exec>:
.global exec
exec:
 li a7, SYS_exec
    12b2:	489d                	li	a7,7
 ecall
    12b4:	00000073          	ecall
 ret
    12b8:	8082                	ret

00000000000012ba <open>:
.global open
open:
 li a7, SYS_open
    12ba:	48bd                	li	a7,15
 ecall
    12bc:	00000073          	ecall
 ret
    12c0:	8082                	ret

00000000000012c2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    12c2:	48c5                	li	a7,17
 ecall
    12c4:	00000073          	ecall
 ret
    12c8:	8082                	ret

00000000000012ca <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    12ca:	48c9                	li	a7,18
 ecall
    12cc:	00000073          	ecall
 ret
    12d0:	8082                	ret

00000000000012d2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    12d2:	48a1                	li	a7,8
 ecall
    12d4:	00000073          	ecall
 ret
    12d8:	8082                	ret

00000000000012da <link>:
.global link
link:
 li a7, SYS_link
    12da:	48cd                	li	a7,19
 ecall
    12dc:	00000073          	ecall
 ret
    12e0:	8082                	ret

00000000000012e2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    12e2:	48d1                	li	a7,20
 ecall
    12e4:	00000073          	ecall
 ret
    12e8:	8082                	ret

00000000000012ea <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    12ea:	48a5                	li	a7,9
 ecall
    12ec:	00000073          	ecall
 ret
    12f0:	8082                	ret

00000000000012f2 <dup>:
.global dup
dup:
 li a7, SYS_dup
    12f2:	48a9                	li	a7,10
 ecall
    12f4:	00000073          	ecall
 ret
    12f8:	8082                	ret

00000000000012fa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    12fa:	48ad                	li	a7,11
 ecall
    12fc:	00000073          	ecall
 ret
    1300:	8082                	ret

0000000000001302 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1302:	48b1                	li	a7,12
 ecall
    1304:	00000073          	ecall
 ret
    1308:	8082                	ret

000000000000130a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    130a:	48b5                	li	a7,13
 ecall
    130c:	00000073          	ecall
 ret
    1310:	8082                	ret

0000000000001312 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1312:	48b9                	li	a7,14
 ecall
    1314:	00000073          	ecall
 ret
    1318:	8082                	ret

000000000000131a <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    131a:	48d9                	li	a7,22
 ecall
    131c:	00000073          	ecall
 ret
    1320:	8082                	ret

0000000000001322 <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    1322:	48dd                	li	a7,23
 ecall
    1324:	00000073          	ecall
 ret
    1328:	8082                	ret

000000000000132a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    132a:	1101                	addi	sp,sp,-32
    132c:	ec06                	sd	ra,24(sp)
    132e:	e822                	sd	s0,16(sp)
    1330:	1000                	addi	s0,sp,32
    1332:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1336:	4605                	li	a2,1
    1338:	fef40593          	addi	a1,s0,-17
    133c:	00000097          	auipc	ra,0x0
    1340:	f5e080e7          	jalr	-162(ra) # 129a <write>
}
    1344:	60e2                	ld	ra,24(sp)
    1346:	6442                	ld	s0,16(sp)
    1348:	6105                	addi	sp,sp,32
    134a:	8082                	ret

000000000000134c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    134c:	7139                	addi	sp,sp,-64
    134e:	fc06                	sd	ra,56(sp)
    1350:	f822                	sd	s0,48(sp)
    1352:	f426                	sd	s1,40(sp)
    1354:	f04a                	sd	s2,32(sp)
    1356:	ec4e                	sd	s3,24(sp)
    1358:	0080                	addi	s0,sp,64
    135a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    135c:	c299                	beqz	a3,1362 <printint+0x16>
    135e:	0805c863          	bltz	a1,13ee <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1362:	2581                	sext.w	a1,a1
  neg = 0;
    1364:	4881                	li	a7,0
    1366:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    136a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    136c:	2601                	sext.w	a2,a2
    136e:	00000517          	auipc	a0,0x0
    1372:	45250513          	addi	a0,a0,1106 # 17c0 <digits>
    1376:	883a                	mv	a6,a4
    1378:	2705                	addiw	a4,a4,1
    137a:	02c5f7bb          	remuw	a5,a1,a2
    137e:	1782                	slli	a5,a5,0x20
    1380:	9381                	srli	a5,a5,0x20
    1382:	97aa                	add	a5,a5,a0
    1384:	0007c783          	lbu	a5,0(a5)
    1388:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    138c:	0005879b          	sext.w	a5,a1
    1390:	02c5d5bb          	divuw	a1,a1,a2
    1394:	0685                	addi	a3,a3,1
    1396:	fec7f0e3          	bgeu	a5,a2,1376 <printint+0x2a>
  if(neg)
    139a:	00088b63          	beqz	a7,13b0 <printint+0x64>
    buf[i++] = '-';
    139e:	fd040793          	addi	a5,s0,-48
    13a2:	973e                	add	a4,a4,a5
    13a4:	02d00793          	li	a5,45
    13a8:	fef70823          	sb	a5,-16(a4)
    13ac:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    13b0:	02e05863          	blez	a4,13e0 <printint+0x94>
    13b4:	fc040793          	addi	a5,s0,-64
    13b8:	00e78933          	add	s2,a5,a4
    13bc:	fff78993          	addi	s3,a5,-1
    13c0:	99ba                	add	s3,s3,a4
    13c2:	377d                	addiw	a4,a4,-1
    13c4:	1702                	slli	a4,a4,0x20
    13c6:	9301                	srli	a4,a4,0x20
    13c8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    13cc:	fff94583          	lbu	a1,-1(s2)
    13d0:	8526                	mv	a0,s1
    13d2:	00000097          	auipc	ra,0x0
    13d6:	f58080e7          	jalr	-168(ra) # 132a <putc>
  while(--i >= 0)
    13da:	197d                	addi	s2,s2,-1
    13dc:	ff3918e3          	bne	s2,s3,13cc <printint+0x80>
}
    13e0:	70e2                	ld	ra,56(sp)
    13e2:	7442                	ld	s0,48(sp)
    13e4:	74a2                	ld	s1,40(sp)
    13e6:	7902                	ld	s2,32(sp)
    13e8:	69e2                	ld	s3,24(sp)
    13ea:	6121                	addi	sp,sp,64
    13ec:	8082                	ret
    x = -xx;
    13ee:	40b005bb          	negw	a1,a1
    neg = 1;
    13f2:	4885                	li	a7,1
    x = -xx;
    13f4:	bf8d                	j	1366 <printint+0x1a>

00000000000013f6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    13f6:	7119                	addi	sp,sp,-128
    13f8:	fc86                	sd	ra,120(sp)
    13fa:	f8a2                	sd	s0,112(sp)
    13fc:	f4a6                	sd	s1,104(sp)
    13fe:	f0ca                	sd	s2,96(sp)
    1400:	ecce                	sd	s3,88(sp)
    1402:	e8d2                	sd	s4,80(sp)
    1404:	e4d6                	sd	s5,72(sp)
    1406:	e0da                	sd	s6,64(sp)
    1408:	fc5e                	sd	s7,56(sp)
    140a:	f862                	sd	s8,48(sp)
    140c:	f466                	sd	s9,40(sp)
    140e:	f06a                	sd	s10,32(sp)
    1410:	ec6e                	sd	s11,24(sp)
    1412:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1414:	0005c903          	lbu	s2,0(a1)
    1418:	18090f63          	beqz	s2,15b6 <vprintf+0x1c0>
    141c:	8aaa                	mv	s5,a0
    141e:	8b32                	mv	s6,a2
    1420:	00158493          	addi	s1,a1,1
  state = 0;
    1424:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1426:	02500a13          	li	s4,37
      if(c == 'd'){
    142a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    142e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1432:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1436:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    143a:	00000b97          	auipc	s7,0x0
    143e:	386b8b93          	addi	s7,s7,902 # 17c0 <digits>
    1442:	a839                	j	1460 <vprintf+0x6a>
        putc(fd, c);
    1444:	85ca                	mv	a1,s2
    1446:	8556                	mv	a0,s5
    1448:	00000097          	auipc	ra,0x0
    144c:	ee2080e7          	jalr	-286(ra) # 132a <putc>
    1450:	a019                	j	1456 <vprintf+0x60>
    } else if(state == '%'){
    1452:	01498f63          	beq	s3,s4,1470 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1456:	0485                	addi	s1,s1,1
    1458:	fff4c903          	lbu	s2,-1(s1)
    145c:	14090d63          	beqz	s2,15b6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1460:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1464:	fe0997e3          	bnez	s3,1452 <vprintf+0x5c>
      if(c == '%'){
    1468:	fd479ee3          	bne	a5,s4,1444 <vprintf+0x4e>
        state = '%';
    146c:	89be                	mv	s3,a5
    146e:	b7e5                	j	1456 <vprintf+0x60>
      if(c == 'd'){
    1470:	05878063          	beq	a5,s8,14b0 <vprintf+0xba>
      } else if(c == 'l') {
    1474:	05978c63          	beq	a5,s9,14cc <vprintf+0xd6>
      } else if(c == 'x') {
    1478:	07a78863          	beq	a5,s10,14e8 <vprintf+0xf2>
      } else if(c == 'p') {
    147c:	09b78463          	beq	a5,s11,1504 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1480:	07300713          	li	a4,115
    1484:	0ce78663          	beq	a5,a4,1550 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1488:	06300713          	li	a4,99
    148c:	0ee78e63          	beq	a5,a4,1588 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1490:	11478863          	beq	a5,s4,15a0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1494:	85d2                	mv	a1,s4
    1496:	8556                	mv	a0,s5
    1498:	00000097          	auipc	ra,0x0
    149c:	e92080e7          	jalr	-366(ra) # 132a <putc>
        putc(fd, c);
    14a0:	85ca                	mv	a1,s2
    14a2:	8556                	mv	a0,s5
    14a4:	00000097          	auipc	ra,0x0
    14a8:	e86080e7          	jalr	-378(ra) # 132a <putc>
      }
      state = 0;
    14ac:	4981                	li	s3,0
    14ae:	b765                	j	1456 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    14b0:	008b0913          	addi	s2,s6,8
    14b4:	4685                	li	a3,1
    14b6:	4629                	li	a2,10
    14b8:	000b2583          	lw	a1,0(s6)
    14bc:	8556                	mv	a0,s5
    14be:	00000097          	auipc	ra,0x0
    14c2:	e8e080e7          	jalr	-370(ra) # 134c <printint>
    14c6:	8b4a                	mv	s6,s2
      state = 0;
    14c8:	4981                	li	s3,0
    14ca:	b771                	j	1456 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    14cc:	008b0913          	addi	s2,s6,8
    14d0:	4681                	li	a3,0
    14d2:	4629                	li	a2,10
    14d4:	000b2583          	lw	a1,0(s6)
    14d8:	8556                	mv	a0,s5
    14da:	00000097          	auipc	ra,0x0
    14de:	e72080e7          	jalr	-398(ra) # 134c <printint>
    14e2:	8b4a                	mv	s6,s2
      state = 0;
    14e4:	4981                	li	s3,0
    14e6:	bf85                	j	1456 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    14e8:	008b0913          	addi	s2,s6,8
    14ec:	4681                	li	a3,0
    14ee:	4641                	li	a2,16
    14f0:	000b2583          	lw	a1,0(s6)
    14f4:	8556                	mv	a0,s5
    14f6:	00000097          	auipc	ra,0x0
    14fa:	e56080e7          	jalr	-426(ra) # 134c <printint>
    14fe:	8b4a                	mv	s6,s2
      state = 0;
    1500:	4981                	li	s3,0
    1502:	bf91                	j	1456 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1504:	008b0793          	addi	a5,s6,8
    1508:	f8f43423          	sd	a5,-120(s0)
    150c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1510:	03000593          	li	a1,48
    1514:	8556                	mv	a0,s5
    1516:	00000097          	auipc	ra,0x0
    151a:	e14080e7          	jalr	-492(ra) # 132a <putc>
  putc(fd, 'x');
    151e:	85ea                	mv	a1,s10
    1520:	8556                	mv	a0,s5
    1522:	00000097          	auipc	ra,0x0
    1526:	e08080e7          	jalr	-504(ra) # 132a <putc>
    152a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    152c:	03c9d793          	srli	a5,s3,0x3c
    1530:	97de                	add	a5,a5,s7
    1532:	0007c583          	lbu	a1,0(a5)
    1536:	8556                	mv	a0,s5
    1538:	00000097          	auipc	ra,0x0
    153c:	df2080e7          	jalr	-526(ra) # 132a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1540:	0992                	slli	s3,s3,0x4
    1542:	397d                	addiw	s2,s2,-1
    1544:	fe0914e3          	bnez	s2,152c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1548:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    154c:	4981                	li	s3,0
    154e:	b721                	j	1456 <vprintf+0x60>
        s = va_arg(ap, char*);
    1550:	008b0993          	addi	s3,s6,8
    1554:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1558:	02090163          	beqz	s2,157a <vprintf+0x184>
        while(*s != 0){
    155c:	00094583          	lbu	a1,0(s2)
    1560:	c9a1                	beqz	a1,15b0 <vprintf+0x1ba>
          putc(fd, *s);
    1562:	8556                	mv	a0,s5
    1564:	00000097          	auipc	ra,0x0
    1568:	dc6080e7          	jalr	-570(ra) # 132a <putc>
          s++;
    156c:	0905                	addi	s2,s2,1
        while(*s != 0){
    156e:	00094583          	lbu	a1,0(s2)
    1572:	f9e5                	bnez	a1,1562 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1574:	8b4e                	mv	s6,s3
      state = 0;
    1576:	4981                	li	s3,0
    1578:	bdf9                	j	1456 <vprintf+0x60>
          s = "(null)";
    157a:	00000917          	auipc	s2,0x0
    157e:	23e90913          	addi	s2,s2,574 # 17b8 <malloc+0xf8>
        while(*s != 0){
    1582:	02800593          	li	a1,40
    1586:	bff1                	j	1562 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    1588:	008b0913          	addi	s2,s6,8
    158c:	000b4583          	lbu	a1,0(s6)
    1590:	8556                	mv	a0,s5
    1592:	00000097          	auipc	ra,0x0
    1596:	d98080e7          	jalr	-616(ra) # 132a <putc>
    159a:	8b4a                	mv	s6,s2
      state = 0;
    159c:	4981                	li	s3,0
    159e:	bd65                	j	1456 <vprintf+0x60>
        putc(fd, c);
    15a0:	85d2                	mv	a1,s4
    15a2:	8556                	mv	a0,s5
    15a4:	00000097          	auipc	ra,0x0
    15a8:	d86080e7          	jalr	-634(ra) # 132a <putc>
      state = 0;
    15ac:	4981                	li	s3,0
    15ae:	b565                	j	1456 <vprintf+0x60>
        s = va_arg(ap, char*);
    15b0:	8b4e                	mv	s6,s3
      state = 0;
    15b2:	4981                	li	s3,0
    15b4:	b54d                	j	1456 <vprintf+0x60>
    }
  }
}
    15b6:	70e6                	ld	ra,120(sp)
    15b8:	7446                	ld	s0,112(sp)
    15ba:	74a6                	ld	s1,104(sp)
    15bc:	7906                	ld	s2,96(sp)
    15be:	69e6                	ld	s3,88(sp)
    15c0:	6a46                	ld	s4,80(sp)
    15c2:	6aa6                	ld	s5,72(sp)
    15c4:	6b06                	ld	s6,64(sp)
    15c6:	7be2                	ld	s7,56(sp)
    15c8:	7c42                	ld	s8,48(sp)
    15ca:	7ca2                	ld	s9,40(sp)
    15cc:	7d02                	ld	s10,32(sp)
    15ce:	6de2                	ld	s11,24(sp)
    15d0:	6109                	addi	sp,sp,128
    15d2:	8082                	ret

00000000000015d4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    15d4:	715d                	addi	sp,sp,-80
    15d6:	ec06                	sd	ra,24(sp)
    15d8:	e822                	sd	s0,16(sp)
    15da:	1000                	addi	s0,sp,32
    15dc:	e010                	sd	a2,0(s0)
    15de:	e414                	sd	a3,8(s0)
    15e0:	e818                	sd	a4,16(s0)
    15e2:	ec1c                	sd	a5,24(s0)
    15e4:	03043023          	sd	a6,32(s0)
    15e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    15ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    15f0:	8622                	mv	a2,s0
    15f2:	00000097          	auipc	ra,0x0
    15f6:	e04080e7          	jalr	-508(ra) # 13f6 <vprintf>
}
    15fa:	60e2                	ld	ra,24(sp)
    15fc:	6442                	ld	s0,16(sp)
    15fe:	6161                	addi	sp,sp,80
    1600:	8082                	ret

0000000000001602 <printf>:

void
printf(const char *fmt, ...)
{
    1602:	711d                	addi	sp,sp,-96
    1604:	ec06                	sd	ra,24(sp)
    1606:	e822                	sd	s0,16(sp)
    1608:	1000                	addi	s0,sp,32
    160a:	e40c                	sd	a1,8(s0)
    160c:	e810                	sd	a2,16(s0)
    160e:	ec14                	sd	a3,24(s0)
    1610:	f018                	sd	a4,32(s0)
    1612:	f41c                	sd	a5,40(s0)
    1614:	03043823          	sd	a6,48(s0)
    1618:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    161c:	00840613          	addi	a2,s0,8
    1620:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1624:	85aa                	mv	a1,a0
    1626:	4505                	li	a0,1
    1628:	00000097          	auipc	ra,0x0
    162c:	dce080e7          	jalr	-562(ra) # 13f6 <vprintf>
}
    1630:	60e2                	ld	ra,24(sp)
    1632:	6442                	ld	s0,16(sp)
    1634:	6125                	addi	sp,sp,96
    1636:	8082                	ret

0000000000001638 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1638:	1141                	addi	sp,sp,-16
    163a:	e422                	sd	s0,8(sp)
    163c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    163e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1642:	00000797          	auipc	a5,0x0
    1646:	1967b783          	ld	a5,406(a5) # 17d8 <freep>
    164a:	a805                	j	167a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    164c:	4618                	lw	a4,8(a2)
    164e:	9db9                	addw	a1,a1,a4
    1650:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1654:	6398                	ld	a4,0(a5)
    1656:	6318                	ld	a4,0(a4)
    1658:	fee53823          	sd	a4,-16(a0)
    165c:	a091                	j	16a0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    165e:	ff852703          	lw	a4,-8(a0)
    1662:	9e39                	addw	a2,a2,a4
    1664:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1666:	ff053703          	ld	a4,-16(a0)
    166a:	e398                	sd	a4,0(a5)
    166c:	a099                	j	16b2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    166e:	6398                	ld	a4,0(a5)
    1670:	00e7e463          	bltu	a5,a4,1678 <free+0x40>
    1674:	00e6ea63          	bltu	a3,a4,1688 <free+0x50>
{
    1678:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    167a:	fed7fae3          	bgeu	a5,a3,166e <free+0x36>
    167e:	6398                	ld	a4,0(a5)
    1680:	00e6e463          	bltu	a3,a4,1688 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1684:	fee7eae3          	bltu	a5,a4,1678 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1688:	ff852583          	lw	a1,-8(a0)
    168c:	6390                	ld	a2,0(a5)
    168e:	02059713          	slli	a4,a1,0x20
    1692:	9301                	srli	a4,a4,0x20
    1694:	0712                	slli	a4,a4,0x4
    1696:	9736                	add	a4,a4,a3
    1698:	fae60ae3          	beq	a2,a4,164c <free+0x14>
    bp->s.ptr = p->s.ptr;
    169c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    16a0:	4790                	lw	a2,8(a5)
    16a2:	02061713          	slli	a4,a2,0x20
    16a6:	9301                	srli	a4,a4,0x20
    16a8:	0712                	slli	a4,a4,0x4
    16aa:	973e                	add	a4,a4,a5
    16ac:	fae689e3          	beq	a3,a4,165e <free+0x26>
  } else
    p->s.ptr = bp;
    16b0:	e394                	sd	a3,0(a5)
  freep = p;
    16b2:	00000717          	auipc	a4,0x0
    16b6:	12f73323          	sd	a5,294(a4) # 17d8 <freep>
}
    16ba:	6422                	ld	s0,8(sp)
    16bc:	0141                	addi	sp,sp,16
    16be:	8082                	ret

00000000000016c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    16c0:	7139                	addi	sp,sp,-64
    16c2:	fc06                	sd	ra,56(sp)
    16c4:	f822                	sd	s0,48(sp)
    16c6:	f426                	sd	s1,40(sp)
    16c8:	f04a                	sd	s2,32(sp)
    16ca:	ec4e                	sd	s3,24(sp)
    16cc:	e852                	sd	s4,16(sp)
    16ce:	e456                	sd	s5,8(sp)
    16d0:	e05a                	sd	s6,0(sp)
    16d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16d4:	02051493          	slli	s1,a0,0x20
    16d8:	9081                	srli	s1,s1,0x20
    16da:	04bd                	addi	s1,s1,15
    16dc:	8091                	srli	s1,s1,0x4
    16de:	0014899b          	addiw	s3,s1,1
    16e2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    16e4:	00000517          	auipc	a0,0x0
    16e8:	0f453503          	ld	a0,244(a0) # 17d8 <freep>
    16ec:	c515                	beqz	a0,1718 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    16f0:	4798                	lw	a4,8(a5)
    16f2:	02977f63          	bgeu	a4,s1,1730 <malloc+0x70>
    16f6:	8a4e                	mv	s4,s3
    16f8:	0009871b          	sext.w	a4,s3
    16fc:	6685                	lui	a3,0x1
    16fe:	00d77363          	bgeu	a4,a3,1704 <malloc+0x44>
    1702:	6a05                	lui	s4,0x1
    1704:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1708:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    170c:	00000917          	auipc	s2,0x0
    1710:	0cc90913          	addi	s2,s2,204 # 17d8 <freep>
  if(p == (char*)-1)
    1714:	5afd                	li	s5,-1
    1716:	a88d                	j	1788 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    1718:	00000797          	auipc	a5,0x0
    171c:	0c878793          	addi	a5,a5,200 # 17e0 <base>
    1720:	00000717          	auipc	a4,0x0
    1724:	0af73c23          	sd	a5,184(a4) # 17d8 <freep>
    1728:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    172a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    172e:	b7e1                	j	16f6 <malloc+0x36>
      if(p->s.size == nunits)
    1730:	02e48b63          	beq	s1,a4,1766 <malloc+0xa6>
        p->s.size -= nunits;
    1734:	4137073b          	subw	a4,a4,s3
    1738:	c798                	sw	a4,8(a5)
        p += p->s.size;
    173a:	1702                	slli	a4,a4,0x20
    173c:	9301                	srli	a4,a4,0x20
    173e:	0712                	slli	a4,a4,0x4
    1740:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1742:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1746:	00000717          	auipc	a4,0x0
    174a:	08a73923          	sd	a0,146(a4) # 17d8 <freep>
      return (void*)(p + 1);
    174e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1752:	70e2                	ld	ra,56(sp)
    1754:	7442                	ld	s0,48(sp)
    1756:	74a2                	ld	s1,40(sp)
    1758:	7902                	ld	s2,32(sp)
    175a:	69e2                	ld	s3,24(sp)
    175c:	6a42                	ld	s4,16(sp)
    175e:	6aa2                	ld	s5,8(sp)
    1760:	6b02                	ld	s6,0(sp)
    1762:	6121                	addi	sp,sp,64
    1764:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1766:	6398                	ld	a4,0(a5)
    1768:	e118                	sd	a4,0(a0)
    176a:	bff1                	j	1746 <malloc+0x86>
  hp->s.size = nu;
    176c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1770:	0541                	addi	a0,a0,16
    1772:	00000097          	auipc	ra,0x0
    1776:	ec6080e7          	jalr	-314(ra) # 1638 <free>
  return freep;
    177a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    177e:	d971                	beqz	a0,1752 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1780:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1782:	4798                	lw	a4,8(a5)
    1784:	fa9776e3          	bgeu	a4,s1,1730 <malloc+0x70>
    if(p == freep)
    1788:	00093703          	ld	a4,0(s2)
    178c:	853e                	mv	a0,a5
    178e:	fef719e3          	bne	a4,a5,1780 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1792:	8552                	mv	a0,s4
    1794:	00000097          	auipc	ra,0x0
    1798:	b6e080e7          	jalr	-1170(ra) # 1302 <sbrk>
  if(p == (char*)-1)
    179c:	fd5518e3          	bne	a0,s5,176c <malloc+0xac>
        return 0;
    17a0:	4501                	li	a0,0
    17a2:	bf45                	j	1752 <malloc+0x92>
