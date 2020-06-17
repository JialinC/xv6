
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
    1000:	1101                	addi	sp,sp,-32
    1002:	ec06                	sd	ra,24(sp)
    1004:	e822                	sd	s0,16(sp)
    1006:	e426                	sd	s1,8(sp)
    1008:	1000                	addi	s0,sp,32
  if(argc != 3){
    100a:	478d                	li	a5,3
    100c:	02f50063          	beq	a0,a5,102c <main+0x2c>
    fprintf(2, "Usage: ln old new\n");
    1010:	00000597          	auipc	a1,0x0
    1014:	77058593          	addi	a1,a1,1904 # 1780 <malloc+0xe4>
    1018:	4509                	li	a0,2
    101a:	00000097          	auipc	ra,0x0
    101e:	596080e7          	jalr	1430(ra) # 15b0 <fprintf>
    exit(1);
    1022:	4505                	li	a0,1
    1024:	00000097          	auipc	ra,0x0
    1028:	232080e7          	jalr	562(ra) # 1256 <exit>
    102c:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
    102e:	698c                	ld	a1,16(a1)
    1030:	6488                	ld	a0,8(s1)
    1032:	00000097          	auipc	ra,0x0
    1036:	284080e7          	jalr	644(ra) # 12b6 <link>
    103a:	00054763          	bltz	a0,1048 <main+0x48>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
    103e:	4501                	li	a0,0
    1040:	00000097          	auipc	ra,0x0
    1044:	216080e7          	jalr	534(ra) # 1256 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
    1048:	6894                	ld	a3,16(s1)
    104a:	6490                	ld	a2,8(s1)
    104c:	00000597          	auipc	a1,0x0
    1050:	74c58593          	addi	a1,a1,1868 # 1798 <malloc+0xfc>
    1054:	4509                	li	a0,2
    1056:	00000097          	auipc	ra,0x0
    105a:	55a080e7          	jalr	1370(ra) # 15b0 <fprintf>
    105e:	b7c5                	j	103e <main+0x3e>

0000000000001060 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    1060:	1141                	addi	sp,sp,-16
    1062:	e422                	sd	s0,8(sp)
    1064:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1066:	87aa                	mv	a5,a0
    1068:	0585                	addi	a1,a1,1
    106a:	0785                	addi	a5,a5,1
    106c:	fff5c703          	lbu	a4,-1(a1)
    1070:	fee78fa3          	sb	a4,-1(a5)
    1074:	fb75                	bnez	a4,1068 <strcpy+0x8>
    ;
  return os;
}
    1076:	6422                	ld	s0,8(sp)
    1078:	0141                	addi	sp,sp,16
    107a:	8082                	ret

000000000000107c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    107c:	1141                	addi	sp,sp,-16
    107e:	e422                	sd	s0,8(sp)
    1080:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1082:	00054783          	lbu	a5,0(a0)
    1086:	cb91                	beqz	a5,109a <strcmp+0x1e>
    1088:	0005c703          	lbu	a4,0(a1)
    108c:	00f71763          	bne	a4,a5,109a <strcmp+0x1e>
    p++, q++;
    1090:	0505                	addi	a0,a0,1
    1092:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1094:	00054783          	lbu	a5,0(a0)
    1098:	fbe5                	bnez	a5,1088 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    109a:	0005c503          	lbu	a0,0(a1)
}
    109e:	40a7853b          	subw	a0,a5,a0
    10a2:	6422                	ld	s0,8(sp)
    10a4:	0141                	addi	sp,sp,16
    10a6:	8082                	ret

00000000000010a8 <strlen>:

uint
strlen(const char *s)
{
    10a8:	1141                	addi	sp,sp,-16
    10aa:	e422                	sd	s0,8(sp)
    10ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    10ae:	00054783          	lbu	a5,0(a0)
    10b2:	cf91                	beqz	a5,10ce <strlen+0x26>
    10b4:	0505                	addi	a0,a0,1
    10b6:	87aa                	mv	a5,a0
    10b8:	4685                	li	a3,1
    10ba:	9e89                	subw	a3,a3,a0
    10bc:	00f6853b          	addw	a0,a3,a5
    10c0:	0785                	addi	a5,a5,1
    10c2:	fff7c703          	lbu	a4,-1(a5)
    10c6:	fb7d                	bnez	a4,10bc <strlen+0x14>
    ;
  return n;
}
    10c8:	6422                	ld	s0,8(sp)
    10ca:	0141                	addi	sp,sp,16
    10cc:	8082                	ret
  for(n = 0; s[n]; n++)
    10ce:	4501                	li	a0,0
    10d0:	bfe5                	j	10c8 <strlen+0x20>

00000000000010d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10d2:	1141                	addi	sp,sp,-16
    10d4:	e422                	sd	s0,8(sp)
    10d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10d8:	ce09                	beqz	a2,10f2 <memset+0x20>
    10da:	87aa                	mv	a5,a0
    10dc:	fff6071b          	addiw	a4,a2,-1
    10e0:	1702                	slli	a4,a4,0x20
    10e2:	9301                	srli	a4,a4,0x20
    10e4:	0705                	addi	a4,a4,1
    10e6:	972a                	add	a4,a4,a0
    cdst[i] = c;
    10e8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    10ec:	0785                	addi	a5,a5,1
    10ee:	fee79de3          	bne	a5,a4,10e8 <memset+0x16>
  }
  return dst;
}
    10f2:	6422                	ld	s0,8(sp)
    10f4:	0141                	addi	sp,sp,16
    10f6:	8082                	ret

00000000000010f8 <strchr>:

char*
strchr(const char *s, char c)
{
    10f8:	1141                	addi	sp,sp,-16
    10fa:	e422                	sd	s0,8(sp)
    10fc:	0800                	addi	s0,sp,16
  for(; *s; s++)
    10fe:	00054783          	lbu	a5,0(a0)
    1102:	cb99                	beqz	a5,1118 <strchr+0x20>
    if(*s == c)
    1104:	00f58763          	beq	a1,a5,1112 <strchr+0x1a>
  for(; *s; s++)
    1108:	0505                	addi	a0,a0,1
    110a:	00054783          	lbu	a5,0(a0)
    110e:	fbfd                	bnez	a5,1104 <strchr+0xc>
      return (char*)s;
  return 0;
    1110:	4501                	li	a0,0
}
    1112:	6422                	ld	s0,8(sp)
    1114:	0141                	addi	sp,sp,16
    1116:	8082                	ret
  return 0;
    1118:	4501                	li	a0,0
    111a:	bfe5                	j	1112 <strchr+0x1a>

000000000000111c <gets>:

char*
gets(char *buf, int max)
{
    111c:	711d                	addi	sp,sp,-96
    111e:	ec86                	sd	ra,88(sp)
    1120:	e8a2                	sd	s0,80(sp)
    1122:	e4a6                	sd	s1,72(sp)
    1124:	e0ca                	sd	s2,64(sp)
    1126:	fc4e                	sd	s3,56(sp)
    1128:	f852                	sd	s4,48(sp)
    112a:	f456                	sd	s5,40(sp)
    112c:	f05a                	sd	s6,32(sp)
    112e:	ec5e                	sd	s7,24(sp)
    1130:	1080                	addi	s0,sp,96
    1132:	8baa                	mv	s7,a0
    1134:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1136:	892a                	mv	s2,a0
    1138:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    113a:	4aa9                	li	s5,10
    113c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    113e:	89a6                	mv	s3,s1
    1140:	2485                	addiw	s1,s1,1
    1142:	0344d863          	bge	s1,s4,1172 <gets+0x56>
    cc = read(0, &c, 1);
    1146:	4605                	li	a2,1
    1148:	faf40593          	addi	a1,s0,-81
    114c:	4501                	li	a0,0
    114e:	00000097          	auipc	ra,0x0
    1152:	120080e7          	jalr	288(ra) # 126e <read>
    if(cc < 1)
    1156:	00a05e63          	blez	a0,1172 <gets+0x56>
    buf[i++] = c;
    115a:	faf44783          	lbu	a5,-81(s0)
    115e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1162:	01578763          	beq	a5,s5,1170 <gets+0x54>
    1166:	0905                	addi	s2,s2,1
    1168:	fd679be3          	bne	a5,s6,113e <gets+0x22>
  for(i=0; i+1 < max; ){
    116c:	89a6                	mv	s3,s1
    116e:	a011                	j	1172 <gets+0x56>
    1170:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1172:	99de                	add	s3,s3,s7
    1174:	00098023          	sb	zero,0(s3)
  return buf;
}
    1178:	855e                	mv	a0,s7
    117a:	60e6                	ld	ra,88(sp)
    117c:	6446                	ld	s0,80(sp)
    117e:	64a6                	ld	s1,72(sp)
    1180:	6906                	ld	s2,64(sp)
    1182:	79e2                	ld	s3,56(sp)
    1184:	7a42                	ld	s4,48(sp)
    1186:	7aa2                	ld	s5,40(sp)
    1188:	7b02                	ld	s6,32(sp)
    118a:	6be2                	ld	s7,24(sp)
    118c:	6125                	addi	sp,sp,96
    118e:	8082                	ret

0000000000001190 <stat>:

int
stat(const char *n, struct stat *st)
{
    1190:	1101                	addi	sp,sp,-32
    1192:	ec06                	sd	ra,24(sp)
    1194:	e822                	sd	s0,16(sp)
    1196:	e426                	sd	s1,8(sp)
    1198:	e04a                	sd	s2,0(sp)
    119a:	1000                	addi	s0,sp,32
    119c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    119e:	4581                	li	a1,0
    11a0:	00000097          	auipc	ra,0x0
    11a4:	0f6080e7          	jalr	246(ra) # 1296 <open>
  if(fd < 0)
    11a8:	02054563          	bltz	a0,11d2 <stat+0x42>
    11ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    11ae:	85ca                	mv	a1,s2
    11b0:	00000097          	auipc	ra,0x0
    11b4:	0fe080e7          	jalr	254(ra) # 12ae <fstat>
    11b8:	892a                	mv	s2,a0
  close(fd);
    11ba:	8526                	mv	a0,s1
    11bc:	00000097          	auipc	ra,0x0
    11c0:	0c2080e7          	jalr	194(ra) # 127e <close>
  return r;
}
    11c4:	854a                	mv	a0,s2
    11c6:	60e2                	ld	ra,24(sp)
    11c8:	6442                	ld	s0,16(sp)
    11ca:	64a2                	ld	s1,8(sp)
    11cc:	6902                	ld	s2,0(sp)
    11ce:	6105                	addi	sp,sp,32
    11d0:	8082                	ret
    return -1;
    11d2:	597d                	li	s2,-1
    11d4:	bfc5                	j	11c4 <stat+0x34>

00000000000011d6 <atoi>:

int
atoi(const char *s)
{
    11d6:	1141                	addi	sp,sp,-16
    11d8:	e422                	sd	s0,8(sp)
    11da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11dc:	00054603          	lbu	a2,0(a0)
    11e0:	fd06079b          	addiw	a5,a2,-48
    11e4:	0ff7f793          	andi	a5,a5,255
    11e8:	4725                	li	a4,9
    11ea:	02f76963          	bltu	a4,a5,121c <atoi+0x46>
    11ee:	86aa                	mv	a3,a0
  n = 0;
    11f0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    11f2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    11f4:	0685                	addi	a3,a3,1
    11f6:	0025179b          	slliw	a5,a0,0x2
    11fa:	9fa9                	addw	a5,a5,a0
    11fc:	0017979b          	slliw	a5,a5,0x1
    1200:	9fb1                	addw	a5,a5,a2
    1202:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    1206:	0006c603          	lbu	a2,0(a3)
    120a:	fd06071b          	addiw	a4,a2,-48
    120e:	0ff77713          	andi	a4,a4,255
    1212:	fee5f1e3          	bgeu	a1,a4,11f4 <atoi+0x1e>
  return n;
}
    1216:	6422                	ld	s0,8(sp)
    1218:	0141                	addi	sp,sp,16
    121a:	8082                	ret
  n = 0;
    121c:	4501                	li	a0,0
    121e:	bfe5                	j	1216 <atoi+0x40>

0000000000001220 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1220:	1141                	addi	sp,sp,-16
    1222:	e422                	sd	s0,8(sp)
    1224:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1226:	02c05163          	blez	a2,1248 <memmove+0x28>
    122a:	fff6071b          	addiw	a4,a2,-1
    122e:	1702                	slli	a4,a4,0x20
    1230:	9301                	srli	a4,a4,0x20
    1232:	0705                	addi	a4,a4,1
    1234:	972a                	add	a4,a4,a0
  dst = vdst;
    1236:	87aa                	mv	a5,a0
    *dst++ = *src++;
    1238:	0585                	addi	a1,a1,1
    123a:	0785                	addi	a5,a5,1
    123c:	fff5c683          	lbu	a3,-1(a1)
    1240:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    1244:	fee79ae3          	bne	a5,a4,1238 <memmove+0x18>
  return vdst;
}
    1248:	6422                	ld	s0,8(sp)
    124a:	0141                	addi	sp,sp,16
    124c:	8082                	ret

000000000000124e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    124e:	4885                	li	a7,1
 ecall
    1250:	00000073          	ecall
 ret
    1254:	8082                	ret

0000000000001256 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1256:	4889                	li	a7,2
 ecall
    1258:	00000073          	ecall
 ret
    125c:	8082                	ret

000000000000125e <wait>:
.global wait
wait:
 li a7, SYS_wait
    125e:	488d                	li	a7,3
 ecall
    1260:	00000073          	ecall
 ret
    1264:	8082                	ret

0000000000001266 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1266:	4891                	li	a7,4
 ecall
    1268:	00000073          	ecall
 ret
    126c:	8082                	ret

000000000000126e <read>:
.global read
read:
 li a7, SYS_read
    126e:	4895                	li	a7,5
 ecall
    1270:	00000073          	ecall
 ret
    1274:	8082                	ret

0000000000001276 <write>:
.global write
write:
 li a7, SYS_write
    1276:	48c1                	li	a7,16
 ecall
    1278:	00000073          	ecall
 ret
    127c:	8082                	ret

000000000000127e <close>:
.global close
close:
 li a7, SYS_close
    127e:	48d5                	li	a7,21
 ecall
    1280:	00000073          	ecall
 ret
    1284:	8082                	ret

0000000000001286 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1286:	4899                	li	a7,6
 ecall
    1288:	00000073          	ecall
 ret
    128c:	8082                	ret

000000000000128e <exec>:
.global exec
exec:
 li a7, SYS_exec
    128e:	489d                	li	a7,7
 ecall
    1290:	00000073          	ecall
 ret
    1294:	8082                	ret

0000000000001296 <open>:
.global open
open:
 li a7, SYS_open
    1296:	48bd                	li	a7,15
 ecall
    1298:	00000073          	ecall
 ret
    129c:	8082                	ret

000000000000129e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    129e:	48c5                	li	a7,17
 ecall
    12a0:	00000073          	ecall
 ret
    12a4:	8082                	ret

00000000000012a6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    12a6:	48c9                	li	a7,18
 ecall
    12a8:	00000073          	ecall
 ret
    12ac:	8082                	ret

00000000000012ae <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    12ae:	48a1                	li	a7,8
 ecall
    12b0:	00000073          	ecall
 ret
    12b4:	8082                	ret

00000000000012b6 <link>:
.global link
link:
 li a7, SYS_link
    12b6:	48cd                	li	a7,19
 ecall
    12b8:	00000073          	ecall
 ret
    12bc:	8082                	ret

00000000000012be <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    12be:	48d1                	li	a7,20
 ecall
    12c0:	00000073          	ecall
 ret
    12c4:	8082                	ret

00000000000012c6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    12c6:	48a5                	li	a7,9
 ecall
    12c8:	00000073          	ecall
 ret
    12cc:	8082                	ret

00000000000012ce <dup>:
.global dup
dup:
 li a7, SYS_dup
    12ce:	48a9                	li	a7,10
 ecall
    12d0:	00000073          	ecall
 ret
    12d4:	8082                	ret

00000000000012d6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    12d6:	48ad                	li	a7,11
 ecall
    12d8:	00000073          	ecall
 ret
    12dc:	8082                	ret

00000000000012de <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    12de:	48b1                	li	a7,12
 ecall
    12e0:	00000073          	ecall
 ret
    12e4:	8082                	ret

00000000000012e6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    12e6:	48b5                	li	a7,13
 ecall
    12e8:	00000073          	ecall
 ret
    12ec:	8082                	ret

00000000000012ee <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    12ee:	48b9                	li	a7,14
 ecall
    12f0:	00000073          	ecall
 ret
    12f4:	8082                	ret

00000000000012f6 <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    12f6:	48d9                	li	a7,22
 ecall
    12f8:	00000073          	ecall
 ret
    12fc:	8082                	ret

00000000000012fe <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    12fe:	48dd                	li	a7,23
 ecall
    1300:	00000073          	ecall
 ret
    1304:	8082                	ret

0000000000001306 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1306:	1101                	addi	sp,sp,-32
    1308:	ec06                	sd	ra,24(sp)
    130a:	e822                	sd	s0,16(sp)
    130c:	1000                	addi	s0,sp,32
    130e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1312:	4605                	li	a2,1
    1314:	fef40593          	addi	a1,s0,-17
    1318:	00000097          	auipc	ra,0x0
    131c:	f5e080e7          	jalr	-162(ra) # 1276 <write>
}
    1320:	60e2                	ld	ra,24(sp)
    1322:	6442                	ld	s0,16(sp)
    1324:	6105                	addi	sp,sp,32
    1326:	8082                	ret

0000000000001328 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1328:	7139                	addi	sp,sp,-64
    132a:	fc06                	sd	ra,56(sp)
    132c:	f822                	sd	s0,48(sp)
    132e:	f426                	sd	s1,40(sp)
    1330:	f04a                	sd	s2,32(sp)
    1332:	ec4e                	sd	s3,24(sp)
    1334:	0080                	addi	s0,sp,64
    1336:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1338:	c299                	beqz	a3,133e <printint+0x16>
    133a:	0805c863          	bltz	a1,13ca <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    133e:	2581                	sext.w	a1,a1
  neg = 0;
    1340:	4881                	li	a7,0
    1342:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1346:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1348:	2601                	sext.w	a2,a2
    134a:	00000517          	auipc	a0,0x0
    134e:	46e50513          	addi	a0,a0,1134 # 17b8 <digits>
    1352:	883a                	mv	a6,a4
    1354:	2705                	addiw	a4,a4,1
    1356:	02c5f7bb          	remuw	a5,a1,a2
    135a:	1782                	slli	a5,a5,0x20
    135c:	9381                	srli	a5,a5,0x20
    135e:	97aa                	add	a5,a5,a0
    1360:	0007c783          	lbu	a5,0(a5)
    1364:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1368:	0005879b          	sext.w	a5,a1
    136c:	02c5d5bb          	divuw	a1,a1,a2
    1370:	0685                	addi	a3,a3,1
    1372:	fec7f0e3          	bgeu	a5,a2,1352 <printint+0x2a>
  if(neg)
    1376:	00088b63          	beqz	a7,138c <printint+0x64>
    buf[i++] = '-';
    137a:	fd040793          	addi	a5,s0,-48
    137e:	973e                	add	a4,a4,a5
    1380:	02d00793          	li	a5,45
    1384:	fef70823          	sb	a5,-16(a4)
    1388:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    138c:	02e05863          	blez	a4,13bc <printint+0x94>
    1390:	fc040793          	addi	a5,s0,-64
    1394:	00e78933          	add	s2,a5,a4
    1398:	fff78993          	addi	s3,a5,-1
    139c:	99ba                	add	s3,s3,a4
    139e:	377d                	addiw	a4,a4,-1
    13a0:	1702                	slli	a4,a4,0x20
    13a2:	9301                	srli	a4,a4,0x20
    13a4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    13a8:	fff94583          	lbu	a1,-1(s2)
    13ac:	8526                	mv	a0,s1
    13ae:	00000097          	auipc	ra,0x0
    13b2:	f58080e7          	jalr	-168(ra) # 1306 <putc>
  while(--i >= 0)
    13b6:	197d                	addi	s2,s2,-1
    13b8:	ff3918e3          	bne	s2,s3,13a8 <printint+0x80>
}
    13bc:	70e2                	ld	ra,56(sp)
    13be:	7442                	ld	s0,48(sp)
    13c0:	74a2                	ld	s1,40(sp)
    13c2:	7902                	ld	s2,32(sp)
    13c4:	69e2                	ld	s3,24(sp)
    13c6:	6121                	addi	sp,sp,64
    13c8:	8082                	ret
    x = -xx;
    13ca:	40b005bb          	negw	a1,a1
    neg = 1;
    13ce:	4885                	li	a7,1
    x = -xx;
    13d0:	bf8d                	j	1342 <printint+0x1a>

00000000000013d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    13d2:	7119                	addi	sp,sp,-128
    13d4:	fc86                	sd	ra,120(sp)
    13d6:	f8a2                	sd	s0,112(sp)
    13d8:	f4a6                	sd	s1,104(sp)
    13da:	f0ca                	sd	s2,96(sp)
    13dc:	ecce                	sd	s3,88(sp)
    13de:	e8d2                	sd	s4,80(sp)
    13e0:	e4d6                	sd	s5,72(sp)
    13e2:	e0da                	sd	s6,64(sp)
    13e4:	fc5e                	sd	s7,56(sp)
    13e6:	f862                	sd	s8,48(sp)
    13e8:	f466                	sd	s9,40(sp)
    13ea:	f06a                	sd	s10,32(sp)
    13ec:	ec6e                	sd	s11,24(sp)
    13ee:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    13f0:	0005c903          	lbu	s2,0(a1)
    13f4:	18090f63          	beqz	s2,1592 <vprintf+0x1c0>
    13f8:	8aaa                	mv	s5,a0
    13fa:	8b32                	mv	s6,a2
    13fc:	00158493          	addi	s1,a1,1
  state = 0;
    1400:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1402:	02500a13          	li	s4,37
      if(c == 'd'){
    1406:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    140a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    140e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1412:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1416:	00000b97          	auipc	s7,0x0
    141a:	3a2b8b93          	addi	s7,s7,930 # 17b8 <digits>
    141e:	a839                	j	143c <vprintf+0x6a>
        putc(fd, c);
    1420:	85ca                	mv	a1,s2
    1422:	8556                	mv	a0,s5
    1424:	00000097          	auipc	ra,0x0
    1428:	ee2080e7          	jalr	-286(ra) # 1306 <putc>
    142c:	a019                	j	1432 <vprintf+0x60>
    } else if(state == '%'){
    142e:	01498f63          	beq	s3,s4,144c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1432:	0485                	addi	s1,s1,1
    1434:	fff4c903          	lbu	s2,-1(s1)
    1438:	14090d63          	beqz	s2,1592 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    143c:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1440:	fe0997e3          	bnez	s3,142e <vprintf+0x5c>
      if(c == '%'){
    1444:	fd479ee3          	bne	a5,s4,1420 <vprintf+0x4e>
        state = '%';
    1448:	89be                	mv	s3,a5
    144a:	b7e5                	j	1432 <vprintf+0x60>
      if(c == 'd'){
    144c:	05878063          	beq	a5,s8,148c <vprintf+0xba>
      } else if(c == 'l') {
    1450:	05978c63          	beq	a5,s9,14a8 <vprintf+0xd6>
      } else if(c == 'x') {
    1454:	07a78863          	beq	a5,s10,14c4 <vprintf+0xf2>
      } else if(c == 'p') {
    1458:	09b78463          	beq	a5,s11,14e0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    145c:	07300713          	li	a4,115
    1460:	0ce78663          	beq	a5,a4,152c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1464:	06300713          	li	a4,99
    1468:	0ee78e63          	beq	a5,a4,1564 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    146c:	11478863          	beq	a5,s4,157c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1470:	85d2                	mv	a1,s4
    1472:	8556                	mv	a0,s5
    1474:	00000097          	auipc	ra,0x0
    1478:	e92080e7          	jalr	-366(ra) # 1306 <putc>
        putc(fd, c);
    147c:	85ca                	mv	a1,s2
    147e:	8556                	mv	a0,s5
    1480:	00000097          	auipc	ra,0x0
    1484:	e86080e7          	jalr	-378(ra) # 1306 <putc>
      }
      state = 0;
    1488:	4981                	li	s3,0
    148a:	b765                	j	1432 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    148c:	008b0913          	addi	s2,s6,8
    1490:	4685                	li	a3,1
    1492:	4629                	li	a2,10
    1494:	000b2583          	lw	a1,0(s6)
    1498:	8556                	mv	a0,s5
    149a:	00000097          	auipc	ra,0x0
    149e:	e8e080e7          	jalr	-370(ra) # 1328 <printint>
    14a2:	8b4a                	mv	s6,s2
      state = 0;
    14a4:	4981                	li	s3,0
    14a6:	b771                	j	1432 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    14a8:	008b0913          	addi	s2,s6,8
    14ac:	4681                	li	a3,0
    14ae:	4629                	li	a2,10
    14b0:	000b2583          	lw	a1,0(s6)
    14b4:	8556                	mv	a0,s5
    14b6:	00000097          	auipc	ra,0x0
    14ba:	e72080e7          	jalr	-398(ra) # 1328 <printint>
    14be:	8b4a                	mv	s6,s2
      state = 0;
    14c0:	4981                	li	s3,0
    14c2:	bf85                	j	1432 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    14c4:	008b0913          	addi	s2,s6,8
    14c8:	4681                	li	a3,0
    14ca:	4641                	li	a2,16
    14cc:	000b2583          	lw	a1,0(s6)
    14d0:	8556                	mv	a0,s5
    14d2:	00000097          	auipc	ra,0x0
    14d6:	e56080e7          	jalr	-426(ra) # 1328 <printint>
    14da:	8b4a                	mv	s6,s2
      state = 0;
    14dc:	4981                	li	s3,0
    14de:	bf91                	j	1432 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    14e0:	008b0793          	addi	a5,s6,8
    14e4:	f8f43423          	sd	a5,-120(s0)
    14e8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    14ec:	03000593          	li	a1,48
    14f0:	8556                	mv	a0,s5
    14f2:	00000097          	auipc	ra,0x0
    14f6:	e14080e7          	jalr	-492(ra) # 1306 <putc>
  putc(fd, 'x');
    14fa:	85ea                	mv	a1,s10
    14fc:	8556                	mv	a0,s5
    14fe:	00000097          	auipc	ra,0x0
    1502:	e08080e7          	jalr	-504(ra) # 1306 <putc>
    1506:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1508:	03c9d793          	srli	a5,s3,0x3c
    150c:	97de                	add	a5,a5,s7
    150e:	0007c583          	lbu	a1,0(a5)
    1512:	8556                	mv	a0,s5
    1514:	00000097          	auipc	ra,0x0
    1518:	df2080e7          	jalr	-526(ra) # 1306 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    151c:	0992                	slli	s3,s3,0x4
    151e:	397d                	addiw	s2,s2,-1
    1520:	fe0914e3          	bnez	s2,1508 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1524:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1528:	4981                	li	s3,0
    152a:	b721                	j	1432 <vprintf+0x60>
        s = va_arg(ap, char*);
    152c:	008b0993          	addi	s3,s6,8
    1530:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1534:	02090163          	beqz	s2,1556 <vprintf+0x184>
        while(*s != 0){
    1538:	00094583          	lbu	a1,0(s2)
    153c:	c9a1                	beqz	a1,158c <vprintf+0x1ba>
          putc(fd, *s);
    153e:	8556                	mv	a0,s5
    1540:	00000097          	auipc	ra,0x0
    1544:	dc6080e7          	jalr	-570(ra) # 1306 <putc>
          s++;
    1548:	0905                	addi	s2,s2,1
        while(*s != 0){
    154a:	00094583          	lbu	a1,0(s2)
    154e:	f9e5                	bnez	a1,153e <vprintf+0x16c>
        s = va_arg(ap, char*);
    1550:	8b4e                	mv	s6,s3
      state = 0;
    1552:	4981                	li	s3,0
    1554:	bdf9                	j	1432 <vprintf+0x60>
          s = "(null)";
    1556:	00000917          	auipc	s2,0x0
    155a:	25a90913          	addi	s2,s2,602 # 17b0 <malloc+0x114>
        while(*s != 0){
    155e:	02800593          	li	a1,40
    1562:	bff1                	j	153e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    1564:	008b0913          	addi	s2,s6,8
    1568:	000b4583          	lbu	a1,0(s6)
    156c:	8556                	mv	a0,s5
    156e:	00000097          	auipc	ra,0x0
    1572:	d98080e7          	jalr	-616(ra) # 1306 <putc>
    1576:	8b4a                	mv	s6,s2
      state = 0;
    1578:	4981                	li	s3,0
    157a:	bd65                	j	1432 <vprintf+0x60>
        putc(fd, c);
    157c:	85d2                	mv	a1,s4
    157e:	8556                	mv	a0,s5
    1580:	00000097          	auipc	ra,0x0
    1584:	d86080e7          	jalr	-634(ra) # 1306 <putc>
      state = 0;
    1588:	4981                	li	s3,0
    158a:	b565                	j	1432 <vprintf+0x60>
        s = va_arg(ap, char*);
    158c:	8b4e                	mv	s6,s3
      state = 0;
    158e:	4981                	li	s3,0
    1590:	b54d                	j	1432 <vprintf+0x60>
    }
  }
}
    1592:	70e6                	ld	ra,120(sp)
    1594:	7446                	ld	s0,112(sp)
    1596:	74a6                	ld	s1,104(sp)
    1598:	7906                	ld	s2,96(sp)
    159a:	69e6                	ld	s3,88(sp)
    159c:	6a46                	ld	s4,80(sp)
    159e:	6aa6                	ld	s5,72(sp)
    15a0:	6b06                	ld	s6,64(sp)
    15a2:	7be2                	ld	s7,56(sp)
    15a4:	7c42                	ld	s8,48(sp)
    15a6:	7ca2                	ld	s9,40(sp)
    15a8:	7d02                	ld	s10,32(sp)
    15aa:	6de2                	ld	s11,24(sp)
    15ac:	6109                	addi	sp,sp,128
    15ae:	8082                	ret

00000000000015b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    15b0:	715d                	addi	sp,sp,-80
    15b2:	ec06                	sd	ra,24(sp)
    15b4:	e822                	sd	s0,16(sp)
    15b6:	1000                	addi	s0,sp,32
    15b8:	e010                	sd	a2,0(s0)
    15ba:	e414                	sd	a3,8(s0)
    15bc:	e818                	sd	a4,16(s0)
    15be:	ec1c                	sd	a5,24(s0)
    15c0:	03043023          	sd	a6,32(s0)
    15c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    15c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    15cc:	8622                	mv	a2,s0
    15ce:	00000097          	auipc	ra,0x0
    15d2:	e04080e7          	jalr	-508(ra) # 13d2 <vprintf>
}
    15d6:	60e2                	ld	ra,24(sp)
    15d8:	6442                	ld	s0,16(sp)
    15da:	6161                	addi	sp,sp,80
    15dc:	8082                	ret

00000000000015de <printf>:

void
printf(const char *fmt, ...)
{
    15de:	711d                	addi	sp,sp,-96
    15e0:	ec06                	sd	ra,24(sp)
    15e2:	e822                	sd	s0,16(sp)
    15e4:	1000                	addi	s0,sp,32
    15e6:	e40c                	sd	a1,8(s0)
    15e8:	e810                	sd	a2,16(s0)
    15ea:	ec14                	sd	a3,24(s0)
    15ec:	f018                	sd	a4,32(s0)
    15ee:	f41c                	sd	a5,40(s0)
    15f0:	03043823          	sd	a6,48(s0)
    15f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    15f8:	00840613          	addi	a2,s0,8
    15fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1600:	85aa                	mv	a1,a0
    1602:	4505                	li	a0,1
    1604:	00000097          	auipc	ra,0x0
    1608:	dce080e7          	jalr	-562(ra) # 13d2 <vprintf>
}
    160c:	60e2                	ld	ra,24(sp)
    160e:	6442                	ld	s0,16(sp)
    1610:	6125                	addi	sp,sp,96
    1612:	8082                	ret

0000000000001614 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1614:	1141                	addi	sp,sp,-16
    1616:	e422                	sd	s0,8(sp)
    1618:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    161a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    161e:	00000797          	auipc	a5,0x0
    1622:	1b27b783          	ld	a5,434(a5) # 17d0 <freep>
    1626:	a805                	j	1656 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1628:	4618                	lw	a4,8(a2)
    162a:	9db9                	addw	a1,a1,a4
    162c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1630:	6398                	ld	a4,0(a5)
    1632:	6318                	ld	a4,0(a4)
    1634:	fee53823          	sd	a4,-16(a0)
    1638:	a091                	j	167c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    163a:	ff852703          	lw	a4,-8(a0)
    163e:	9e39                	addw	a2,a2,a4
    1640:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1642:	ff053703          	ld	a4,-16(a0)
    1646:	e398                	sd	a4,0(a5)
    1648:	a099                	j	168e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    164a:	6398                	ld	a4,0(a5)
    164c:	00e7e463          	bltu	a5,a4,1654 <free+0x40>
    1650:	00e6ea63          	bltu	a3,a4,1664 <free+0x50>
{
    1654:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1656:	fed7fae3          	bgeu	a5,a3,164a <free+0x36>
    165a:	6398                	ld	a4,0(a5)
    165c:	00e6e463          	bltu	a3,a4,1664 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1660:	fee7eae3          	bltu	a5,a4,1654 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1664:	ff852583          	lw	a1,-8(a0)
    1668:	6390                	ld	a2,0(a5)
    166a:	02059713          	slli	a4,a1,0x20
    166e:	9301                	srli	a4,a4,0x20
    1670:	0712                	slli	a4,a4,0x4
    1672:	9736                	add	a4,a4,a3
    1674:	fae60ae3          	beq	a2,a4,1628 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1678:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    167c:	4790                	lw	a2,8(a5)
    167e:	02061713          	slli	a4,a2,0x20
    1682:	9301                	srli	a4,a4,0x20
    1684:	0712                	slli	a4,a4,0x4
    1686:	973e                	add	a4,a4,a5
    1688:	fae689e3          	beq	a3,a4,163a <free+0x26>
  } else
    p->s.ptr = bp;
    168c:	e394                	sd	a3,0(a5)
  freep = p;
    168e:	00000717          	auipc	a4,0x0
    1692:	14f73123          	sd	a5,322(a4) # 17d0 <freep>
}
    1696:	6422                	ld	s0,8(sp)
    1698:	0141                	addi	sp,sp,16
    169a:	8082                	ret

000000000000169c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    169c:	7139                	addi	sp,sp,-64
    169e:	fc06                	sd	ra,56(sp)
    16a0:	f822                	sd	s0,48(sp)
    16a2:	f426                	sd	s1,40(sp)
    16a4:	f04a                	sd	s2,32(sp)
    16a6:	ec4e                	sd	s3,24(sp)
    16a8:	e852                	sd	s4,16(sp)
    16aa:	e456                	sd	s5,8(sp)
    16ac:	e05a                	sd	s6,0(sp)
    16ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16b0:	02051493          	slli	s1,a0,0x20
    16b4:	9081                	srli	s1,s1,0x20
    16b6:	04bd                	addi	s1,s1,15
    16b8:	8091                	srli	s1,s1,0x4
    16ba:	0014899b          	addiw	s3,s1,1
    16be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    16c0:	00000517          	auipc	a0,0x0
    16c4:	11053503          	ld	a0,272(a0) # 17d0 <freep>
    16c8:	c515                	beqz	a0,16f4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    16cc:	4798                	lw	a4,8(a5)
    16ce:	02977f63          	bgeu	a4,s1,170c <malloc+0x70>
    16d2:	8a4e                	mv	s4,s3
    16d4:	0009871b          	sext.w	a4,s3
    16d8:	6685                	lui	a3,0x1
    16da:	00d77363          	bgeu	a4,a3,16e0 <malloc+0x44>
    16de:	6a05                	lui	s4,0x1
    16e0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    16e4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    16e8:	00000917          	auipc	s2,0x0
    16ec:	0e890913          	addi	s2,s2,232 # 17d0 <freep>
  if(p == (char*)-1)
    16f0:	5afd                	li	s5,-1
    16f2:	a88d                	j	1764 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    16f4:	00000797          	auipc	a5,0x0
    16f8:	0e478793          	addi	a5,a5,228 # 17d8 <base>
    16fc:	00000717          	auipc	a4,0x0
    1700:	0cf73a23          	sd	a5,212(a4) # 17d0 <freep>
    1704:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1706:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    170a:	b7e1                	j	16d2 <malloc+0x36>
      if(p->s.size == nunits)
    170c:	02e48b63          	beq	s1,a4,1742 <malloc+0xa6>
        p->s.size -= nunits;
    1710:	4137073b          	subw	a4,a4,s3
    1714:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1716:	1702                	slli	a4,a4,0x20
    1718:	9301                	srli	a4,a4,0x20
    171a:	0712                	slli	a4,a4,0x4
    171c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    171e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1722:	00000717          	auipc	a4,0x0
    1726:	0aa73723          	sd	a0,174(a4) # 17d0 <freep>
      return (void*)(p + 1);
    172a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    172e:	70e2                	ld	ra,56(sp)
    1730:	7442                	ld	s0,48(sp)
    1732:	74a2                	ld	s1,40(sp)
    1734:	7902                	ld	s2,32(sp)
    1736:	69e2                	ld	s3,24(sp)
    1738:	6a42                	ld	s4,16(sp)
    173a:	6aa2                	ld	s5,8(sp)
    173c:	6b02                	ld	s6,0(sp)
    173e:	6121                	addi	sp,sp,64
    1740:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1742:	6398                	ld	a4,0(a5)
    1744:	e118                	sd	a4,0(a0)
    1746:	bff1                	j	1722 <malloc+0x86>
  hp->s.size = nu;
    1748:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    174c:	0541                	addi	a0,a0,16
    174e:	00000097          	auipc	ra,0x0
    1752:	ec6080e7          	jalr	-314(ra) # 1614 <free>
  return freep;
    1756:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    175a:	d971                	beqz	a0,172e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    175c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    175e:	4798                	lw	a4,8(a5)
    1760:	fa9776e3          	bgeu	a4,s1,170c <malloc+0x70>
    if(p == freep)
    1764:	00093703          	ld	a4,0(s2)
    1768:	853e                	mv	a0,a5
    176a:	fef719e3          	bne	a4,a5,175c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    176e:	8552                	mv	a0,s4
    1770:	00000097          	auipc	ra,0x0
    1774:	b6e080e7          	jalr	-1170(ra) # 12de <sbrk>
  if(p == (char*)-1)
    1778:	fd5518e3          	bne	a0,s5,1748 <malloc+0xac>
        return 0;
    177c:	4501                	li	a0,0
    177e:	bf45                	j	172e <malloc+0x92>
