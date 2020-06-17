
user/_mkdir:     file format elf64-littleriscv


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
    100c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
    100e:	4785                	li	a5,1
    1010:	02a7d763          	bge	a5,a0,103e <main+0x3e>
    1014:	00858493          	addi	s1,a1,8
    1018:	ffe5091b          	addiw	s2,a0,-2
    101c:	1902                	slli	s2,s2,0x20
    101e:	02095913          	srli	s2,s2,0x20
    1022:	090e                	slli	s2,s2,0x3
    1024:	05c1                	addi	a1,a1,16
    1026:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
    1028:	6088                	ld	a0,0(s1)
    102a:	00000097          	auipc	ra,0x0
    102e:	2ac080e7          	jalr	684(ra) # 12d6 <mkdir>
    1032:	02054463          	bltz	a0,105a <main+0x5a>
  for(i = 1; i < argc; i++){
    1036:	04a1                	addi	s1,s1,8
    1038:	ff2498e3          	bne	s1,s2,1028 <main+0x28>
    103c:	a80d                	j	106e <main+0x6e>
    fprintf(2, "Usage: mkdir files...\n");
    103e:	00000597          	auipc	a1,0x0
    1042:	75a58593          	addi	a1,a1,1882 # 1798 <malloc+0xe4>
    1046:	4509                	li	a0,2
    1048:	00000097          	auipc	ra,0x0
    104c:	580080e7          	jalr	1408(ra) # 15c8 <fprintf>
    exit(1);
    1050:	4505                	li	a0,1
    1052:	00000097          	auipc	ra,0x0
    1056:	21c080e7          	jalr	540(ra) # 126e <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
    105a:	6090                	ld	a2,0(s1)
    105c:	00000597          	auipc	a1,0x0
    1060:	75458593          	addi	a1,a1,1876 # 17b0 <malloc+0xfc>
    1064:	4509                	li	a0,2
    1066:	00000097          	auipc	ra,0x0
    106a:	562080e7          	jalr	1378(ra) # 15c8 <fprintf>
      break;
    }
  }

  exit(0);
    106e:	4501                	li	a0,0
    1070:	00000097          	auipc	ra,0x0
    1074:	1fe080e7          	jalr	510(ra) # 126e <exit>

0000000000001078 <strcpy>:
#endif


char*
strcpy(char *s, const char *t)
{
    1078:	1141                	addi	sp,sp,-16
    107a:	e422                	sd	s0,8(sp)
    107c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    107e:	87aa                	mv	a5,a0
    1080:	0585                	addi	a1,a1,1
    1082:	0785                	addi	a5,a5,1
    1084:	fff5c703          	lbu	a4,-1(a1)
    1088:	fee78fa3          	sb	a4,-1(a5)
    108c:	fb75                	bnez	a4,1080 <strcpy+0x8>
    ;
  return os;
}
    108e:	6422                	ld	s0,8(sp)
    1090:	0141                	addi	sp,sp,16
    1092:	8082                	ret

0000000000001094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1094:	1141                	addi	sp,sp,-16
    1096:	e422                	sd	s0,8(sp)
    1098:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    109a:	00054783          	lbu	a5,0(a0)
    109e:	cb91                	beqz	a5,10b2 <strcmp+0x1e>
    10a0:	0005c703          	lbu	a4,0(a1)
    10a4:	00f71763          	bne	a4,a5,10b2 <strcmp+0x1e>
    p++, q++;
    10a8:	0505                	addi	a0,a0,1
    10aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    10ac:	00054783          	lbu	a5,0(a0)
    10b0:	fbe5                	bnez	a5,10a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    10b2:	0005c503          	lbu	a0,0(a1)
}
    10b6:	40a7853b          	subw	a0,a5,a0
    10ba:	6422                	ld	s0,8(sp)
    10bc:	0141                	addi	sp,sp,16
    10be:	8082                	ret

00000000000010c0 <strlen>:

uint
strlen(const char *s)
{
    10c0:	1141                	addi	sp,sp,-16
    10c2:	e422                	sd	s0,8(sp)
    10c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    10c6:	00054783          	lbu	a5,0(a0)
    10ca:	cf91                	beqz	a5,10e6 <strlen+0x26>
    10cc:	0505                	addi	a0,a0,1
    10ce:	87aa                	mv	a5,a0
    10d0:	4685                	li	a3,1
    10d2:	9e89                	subw	a3,a3,a0
    10d4:	00f6853b          	addw	a0,a3,a5
    10d8:	0785                	addi	a5,a5,1
    10da:	fff7c703          	lbu	a4,-1(a5)
    10de:	fb7d                	bnez	a4,10d4 <strlen+0x14>
    ;
  return n;
}
    10e0:	6422                	ld	s0,8(sp)
    10e2:	0141                	addi	sp,sp,16
    10e4:	8082                	ret
  for(n = 0; s[n]; n++)
    10e6:	4501                	li	a0,0
    10e8:	bfe5                	j	10e0 <strlen+0x20>

00000000000010ea <memset>:

void*
memset(void *dst, int c, uint n)
{
    10ea:	1141                	addi	sp,sp,-16
    10ec:	e422                	sd	s0,8(sp)
    10ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10f0:	ce09                	beqz	a2,110a <memset+0x20>
    10f2:	87aa                	mv	a5,a0
    10f4:	fff6071b          	addiw	a4,a2,-1
    10f8:	1702                	slli	a4,a4,0x20
    10fa:	9301                	srli	a4,a4,0x20
    10fc:	0705                	addi	a4,a4,1
    10fe:	972a                	add	a4,a4,a0
    cdst[i] = c;
    1100:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1104:	0785                	addi	a5,a5,1
    1106:	fee79de3          	bne	a5,a4,1100 <memset+0x16>
  }
  return dst;
}
    110a:	6422                	ld	s0,8(sp)
    110c:	0141                	addi	sp,sp,16
    110e:	8082                	ret

0000000000001110 <strchr>:

char*
strchr(const char *s, char c)
{
    1110:	1141                	addi	sp,sp,-16
    1112:	e422                	sd	s0,8(sp)
    1114:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1116:	00054783          	lbu	a5,0(a0)
    111a:	cb99                	beqz	a5,1130 <strchr+0x20>
    if(*s == c)
    111c:	00f58763          	beq	a1,a5,112a <strchr+0x1a>
  for(; *s; s++)
    1120:	0505                	addi	a0,a0,1
    1122:	00054783          	lbu	a5,0(a0)
    1126:	fbfd                	bnez	a5,111c <strchr+0xc>
      return (char*)s;
  return 0;
    1128:	4501                	li	a0,0
}
    112a:	6422                	ld	s0,8(sp)
    112c:	0141                	addi	sp,sp,16
    112e:	8082                	ret
  return 0;
    1130:	4501                	li	a0,0
    1132:	bfe5                	j	112a <strchr+0x1a>

0000000000001134 <gets>:

char*
gets(char *buf, int max)
{
    1134:	711d                	addi	sp,sp,-96
    1136:	ec86                	sd	ra,88(sp)
    1138:	e8a2                	sd	s0,80(sp)
    113a:	e4a6                	sd	s1,72(sp)
    113c:	e0ca                	sd	s2,64(sp)
    113e:	fc4e                	sd	s3,56(sp)
    1140:	f852                	sd	s4,48(sp)
    1142:	f456                	sd	s5,40(sp)
    1144:	f05a                	sd	s6,32(sp)
    1146:	ec5e                	sd	s7,24(sp)
    1148:	1080                	addi	s0,sp,96
    114a:	8baa                	mv	s7,a0
    114c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    114e:	892a                	mv	s2,a0
    1150:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1152:	4aa9                	li	s5,10
    1154:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1156:	89a6                	mv	s3,s1
    1158:	2485                	addiw	s1,s1,1
    115a:	0344d863          	bge	s1,s4,118a <gets+0x56>
    cc = read(0, &c, 1);
    115e:	4605                	li	a2,1
    1160:	faf40593          	addi	a1,s0,-81
    1164:	4501                	li	a0,0
    1166:	00000097          	auipc	ra,0x0
    116a:	120080e7          	jalr	288(ra) # 1286 <read>
    if(cc < 1)
    116e:	00a05e63          	blez	a0,118a <gets+0x56>
    buf[i++] = c;
    1172:	faf44783          	lbu	a5,-81(s0)
    1176:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    117a:	01578763          	beq	a5,s5,1188 <gets+0x54>
    117e:	0905                	addi	s2,s2,1
    1180:	fd679be3          	bne	a5,s6,1156 <gets+0x22>
  for(i=0; i+1 < max; ){
    1184:	89a6                	mv	s3,s1
    1186:	a011                	j	118a <gets+0x56>
    1188:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    118a:	99de                	add	s3,s3,s7
    118c:	00098023          	sb	zero,0(s3)
  return buf;
}
    1190:	855e                	mv	a0,s7
    1192:	60e6                	ld	ra,88(sp)
    1194:	6446                	ld	s0,80(sp)
    1196:	64a6                	ld	s1,72(sp)
    1198:	6906                	ld	s2,64(sp)
    119a:	79e2                	ld	s3,56(sp)
    119c:	7a42                	ld	s4,48(sp)
    119e:	7aa2                	ld	s5,40(sp)
    11a0:	7b02                	ld	s6,32(sp)
    11a2:	6be2                	ld	s7,24(sp)
    11a4:	6125                	addi	sp,sp,96
    11a6:	8082                	ret

00000000000011a8 <stat>:

int
stat(const char *n, struct stat *st)
{
    11a8:	1101                	addi	sp,sp,-32
    11aa:	ec06                	sd	ra,24(sp)
    11ac:	e822                	sd	s0,16(sp)
    11ae:	e426                	sd	s1,8(sp)
    11b0:	e04a                	sd	s2,0(sp)
    11b2:	1000                	addi	s0,sp,32
    11b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11b6:	4581                	li	a1,0
    11b8:	00000097          	auipc	ra,0x0
    11bc:	0f6080e7          	jalr	246(ra) # 12ae <open>
  if(fd < 0)
    11c0:	02054563          	bltz	a0,11ea <stat+0x42>
    11c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    11c6:	85ca                	mv	a1,s2
    11c8:	00000097          	auipc	ra,0x0
    11cc:	0fe080e7          	jalr	254(ra) # 12c6 <fstat>
    11d0:	892a                	mv	s2,a0
  close(fd);
    11d2:	8526                	mv	a0,s1
    11d4:	00000097          	auipc	ra,0x0
    11d8:	0c2080e7          	jalr	194(ra) # 1296 <close>
  return r;
}
    11dc:	854a                	mv	a0,s2
    11de:	60e2                	ld	ra,24(sp)
    11e0:	6442                	ld	s0,16(sp)
    11e2:	64a2                	ld	s1,8(sp)
    11e4:	6902                	ld	s2,0(sp)
    11e6:	6105                	addi	sp,sp,32
    11e8:	8082                	ret
    return -1;
    11ea:	597d                	li	s2,-1
    11ec:	bfc5                	j	11dc <stat+0x34>

00000000000011ee <atoi>:

int
atoi(const char *s)
{
    11ee:	1141                	addi	sp,sp,-16
    11f0:	e422                	sd	s0,8(sp)
    11f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11f4:	00054603          	lbu	a2,0(a0)
    11f8:	fd06079b          	addiw	a5,a2,-48
    11fc:	0ff7f793          	andi	a5,a5,255
    1200:	4725                	li	a4,9
    1202:	02f76963          	bltu	a4,a5,1234 <atoi+0x46>
    1206:	86aa                	mv	a3,a0
  n = 0;
    1208:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    120a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    120c:	0685                	addi	a3,a3,1
    120e:	0025179b          	slliw	a5,a0,0x2
    1212:	9fa9                	addw	a5,a5,a0
    1214:	0017979b          	slliw	a5,a5,0x1
    1218:	9fb1                	addw	a5,a5,a2
    121a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    121e:	0006c603          	lbu	a2,0(a3)
    1222:	fd06071b          	addiw	a4,a2,-48
    1226:	0ff77713          	andi	a4,a4,255
    122a:	fee5f1e3          	bgeu	a1,a4,120c <atoi+0x1e>
  return n;
}
    122e:	6422                	ld	s0,8(sp)
    1230:	0141                	addi	sp,sp,16
    1232:	8082                	ret
  n = 0;
    1234:	4501                	li	a0,0
    1236:	bfe5                	j	122e <atoi+0x40>

0000000000001238 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1238:	1141                	addi	sp,sp,-16
    123a:	e422                	sd	s0,8(sp)
    123c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    123e:	02c05163          	blez	a2,1260 <memmove+0x28>
    1242:	fff6071b          	addiw	a4,a2,-1
    1246:	1702                	slli	a4,a4,0x20
    1248:	9301                	srli	a4,a4,0x20
    124a:	0705                	addi	a4,a4,1
    124c:	972a                	add	a4,a4,a0
  dst = vdst;
    124e:	87aa                	mv	a5,a0
    *dst++ = *src++;
    1250:	0585                	addi	a1,a1,1
    1252:	0785                	addi	a5,a5,1
    1254:	fff5c683          	lbu	a3,-1(a1)
    1258:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    125c:	fee79ae3          	bne	a5,a4,1250 <memmove+0x18>
  return vdst;
}
    1260:	6422                	ld	s0,8(sp)
    1262:	0141                	addi	sp,sp,16
    1264:	8082                	ret

0000000000001266 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1266:	4885                	li	a7,1
 ecall
    1268:	00000073          	ecall
 ret
    126c:	8082                	ret

000000000000126e <exit>:
.global exit
exit:
 li a7, SYS_exit
    126e:	4889                	li	a7,2
 ecall
    1270:	00000073          	ecall
 ret
    1274:	8082                	ret

0000000000001276 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1276:	488d                	li	a7,3
 ecall
    1278:	00000073          	ecall
 ret
    127c:	8082                	ret

000000000000127e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    127e:	4891                	li	a7,4
 ecall
    1280:	00000073          	ecall
 ret
    1284:	8082                	ret

0000000000001286 <read>:
.global read
read:
 li a7, SYS_read
    1286:	4895                	li	a7,5
 ecall
    1288:	00000073          	ecall
 ret
    128c:	8082                	ret

000000000000128e <write>:
.global write
write:
 li a7, SYS_write
    128e:	48c1                	li	a7,16
 ecall
    1290:	00000073          	ecall
 ret
    1294:	8082                	ret

0000000000001296 <close>:
.global close
close:
 li a7, SYS_close
    1296:	48d5                	li	a7,21
 ecall
    1298:	00000073          	ecall
 ret
    129c:	8082                	ret

000000000000129e <kill>:
.global kill
kill:
 li a7, SYS_kill
    129e:	4899                	li	a7,6
 ecall
    12a0:	00000073          	ecall
 ret
    12a4:	8082                	ret

00000000000012a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
    12a6:	489d                	li	a7,7
 ecall
    12a8:	00000073          	ecall
 ret
    12ac:	8082                	ret

00000000000012ae <open>:
.global open
open:
 li a7, SYS_open
    12ae:	48bd                	li	a7,15
 ecall
    12b0:	00000073          	ecall
 ret
    12b4:	8082                	ret

00000000000012b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    12b6:	48c5                	li	a7,17
 ecall
    12b8:	00000073          	ecall
 ret
    12bc:	8082                	ret

00000000000012be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    12be:	48c9                	li	a7,18
 ecall
    12c0:	00000073          	ecall
 ret
    12c4:	8082                	ret

00000000000012c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    12c6:	48a1                	li	a7,8
 ecall
    12c8:	00000073          	ecall
 ret
    12cc:	8082                	ret

00000000000012ce <link>:
.global link
link:
 li a7, SYS_link
    12ce:	48cd                	li	a7,19
 ecall
    12d0:	00000073          	ecall
 ret
    12d4:	8082                	ret

00000000000012d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    12d6:	48d1                	li	a7,20
 ecall
    12d8:	00000073          	ecall
 ret
    12dc:	8082                	ret

00000000000012de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    12de:	48a5                	li	a7,9
 ecall
    12e0:	00000073          	ecall
 ret
    12e4:	8082                	ret

00000000000012e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
    12e6:	48a9                	li	a7,10
 ecall
    12e8:	00000073          	ecall
 ret
    12ec:	8082                	ret

00000000000012ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    12ee:	48ad                	li	a7,11
 ecall
    12f0:	00000073          	ecall
 ret
    12f4:	8082                	ret

00000000000012f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    12f6:	48b1                	li	a7,12
 ecall
    12f8:	00000073          	ecall
 ret
    12fc:	8082                	ret

00000000000012fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    12fe:	48b5                	li	a7,13
 ecall
    1300:	00000073          	ecall
 ret
    1304:	8082                	ret

0000000000001306 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1306:	48b9                	li	a7,14
 ecall
    1308:	00000073          	ecall
 ret
    130c:	8082                	ret

000000000000130e <mprotect>:
.global mprotect
mprotect:
 li a7, SYS_mprotect
    130e:	48d9                	li	a7,22
 ecall
    1310:	00000073          	ecall
 ret
    1314:	8082                	ret

0000000000001316 <munprotect>:
.global munprotect
munprotect:
 li a7, SYS_munprotect
    1316:	48dd                	li	a7,23
 ecall
    1318:	00000073          	ecall
 ret
    131c:	8082                	ret

000000000000131e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    131e:	1101                	addi	sp,sp,-32
    1320:	ec06                	sd	ra,24(sp)
    1322:	e822                	sd	s0,16(sp)
    1324:	1000                	addi	s0,sp,32
    1326:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    132a:	4605                	li	a2,1
    132c:	fef40593          	addi	a1,s0,-17
    1330:	00000097          	auipc	ra,0x0
    1334:	f5e080e7          	jalr	-162(ra) # 128e <write>
}
    1338:	60e2                	ld	ra,24(sp)
    133a:	6442                	ld	s0,16(sp)
    133c:	6105                	addi	sp,sp,32
    133e:	8082                	ret

0000000000001340 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1340:	7139                	addi	sp,sp,-64
    1342:	fc06                	sd	ra,56(sp)
    1344:	f822                	sd	s0,48(sp)
    1346:	f426                	sd	s1,40(sp)
    1348:	f04a                	sd	s2,32(sp)
    134a:	ec4e                	sd	s3,24(sp)
    134c:	0080                	addi	s0,sp,64
    134e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1350:	c299                	beqz	a3,1356 <printint+0x16>
    1352:	0805c863          	bltz	a1,13e2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1356:	2581                	sext.w	a1,a1
  neg = 0;
    1358:	4881                	li	a7,0
    135a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    135e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1360:	2601                	sext.w	a2,a2
    1362:	00000517          	auipc	a0,0x0
    1366:	47650513          	addi	a0,a0,1142 # 17d8 <digits>
    136a:	883a                	mv	a6,a4
    136c:	2705                	addiw	a4,a4,1
    136e:	02c5f7bb          	remuw	a5,a1,a2
    1372:	1782                	slli	a5,a5,0x20
    1374:	9381                	srli	a5,a5,0x20
    1376:	97aa                	add	a5,a5,a0
    1378:	0007c783          	lbu	a5,0(a5)
    137c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1380:	0005879b          	sext.w	a5,a1
    1384:	02c5d5bb          	divuw	a1,a1,a2
    1388:	0685                	addi	a3,a3,1
    138a:	fec7f0e3          	bgeu	a5,a2,136a <printint+0x2a>
  if(neg)
    138e:	00088b63          	beqz	a7,13a4 <printint+0x64>
    buf[i++] = '-';
    1392:	fd040793          	addi	a5,s0,-48
    1396:	973e                	add	a4,a4,a5
    1398:	02d00793          	li	a5,45
    139c:	fef70823          	sb	a5,-16(a4)
    13a0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    13a4:	02e05863          	blez	a4,13d4 <printint+0x94>
    13a8:	fc040793          	addi	a5,s0,-64
    13ac:	00e78933          	add	s2,a5,a4
    13b0:	fff78993          	addi	s3,a5,-1
    13b4:	99ba                	add	s3,s3,a4
    13b6:	377d                	addiw	a4,a4,-1
    13b8:	1702                	slli	a4,a4,0x20
    13ba:	9301                	srli	a4,a4,0x20
    13bc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    13c0:	fff94583          	lbu	a1,-1(s2)
    13c4:	8526                	mv	a0,s1
    13c6:	00000097          	auipc	ra,0x0
    13ca:	f58080e7          	jalr	-168(ra) # 131e <putc>
  while(--i >= 0)
    13ce:	197d                	addi	s2,s2,-1
    13d0:	ff3918e3          	bne	s2,s3,13c0 <printint+0x80>
}
    13d4:	70e2                	ld	ra,56(sp)
    13d6:	7442                	ld	s0,48(sp)
    13d8:	74a2                	ld	s1,40(sp)
    13da:	7902                	ld	s2,32(sp)
    13dc:	69e2                	ld	s3,24(sp)
    13de:	6121                	addi	sp,sp,64
    13e0:	8082                	ret
    x = -xx;
    13e2:	40b005bb          	negw	a1,a1
    neg = 1;
    13e6:	4885                	li	a7,1
    x = -xx;
    13e8:	bf8d                	j	135a <printint+0x1a>

00000000000013ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    13ea:	7119                	addi	sp,sp,-128
    13ec:	fc86                	sd	ra,120(sp)
    13ee:	f8a2                	sd	s0,112(sp)
    13f0:	f4a6                	sd	s1,104(sp)
    13f2:	f0ca                	sd	s2,96(sp)
    13f4:	ecce                	sd	s3,88(sp)
    13f6:	e8d2                	sd	s4,80(sp)
    13f8:	e4d6                	sd	s5,72(sp)
    13fa:	e0da                	sd	s6,64(sp)
    13fc:	fc5e                	sd	s7,56(sp)
    13fe:	f862                	sd	s8,48(sp)
    1400:	f466                	sd	s9,40(sp)
    1402:	f06a                	sd	s10,32(sp)
    1404:	ec6e                	sd	s11,24(sp)
    1406:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1408:	0005c903          	lbu	s2,0(a1)
    140c:	18090f63          	beqz	s2,15aa <vprintf+0x1c0>
    1410:	8aaa                	mv	s5,a0
    1412:	8b32                	mv	s6,a2
    1414:	00158493          	addi	s1,a1,1
  state = 0;
    1418:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    141a:	02500a13          	li	s4,37
      if(c == 'd'){
    141e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    1422:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1426:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    142a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    142e:	00000b97          	auipc	s7,0x0
    1432:	3aab8b93          	addi	s7,s7,938 # 17d8 <digits>
    1436:	a839                	j	1454 <vprintf+0x6a>
        putc(fd, c);
    1438:	85ca                	mv	a1,s2
    143a:	8556                	mv	a0,s5
    143c:	00000097          	auipc	ra,0x0
    1440:	ee2080e7          	jalr	-286(ra) # 131e <putc>
    1444:	a019                	j	144a <vprintf+0x60>
    } else if(state == '%'){
    1446:	01498f63          	beq	s3,s4,1464 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    144a:	0485                	addi	s1,s1,1
    144c:	fff4c903          	lbu	s2,-1(s1)
    1450:	14090d63          	beqz	s2,15aa <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1454:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1458:	fe0997e3          	bnez	s3,1446 <vprintf+0x5c>
      if(c == '%'){
    145c:	fd479ee3          	bne	a5,s4,1438 <vprintf+0x4e>
        state = '%';
    1460:	89be                	mv	s3,a5
    1462:	b7e5                	j	144a <vprintf+0x60>
      if(c == 'd'){
    1464:	05878063          	beq	a5,s8,14a4 <vprintf+0xba>
      } else if(c == 'l') {
    1468:	05978c63          	beq	a5,s9,14c0 <vprintf+0xd6>
      } else if(c == 'x') {
    146c:	07a78863          	beq	a5,s10,14dc <vprintf+0xf2>
      } else if(c == 'p') {
    1470:	09b78463          	beq	a5,s11,14f8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1474:	07300713          	li	a4,115
    1478:	0ce78663          	beq	a5,a4,1544 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    147c:	06300713          	li	a4,99
    1480:	0ee78e63          	beq	a5,a4,157c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1484:	11478863          	beq	a5,s4,1594 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1488:	85d2                	mv	a1,s4
    148a:	8556                	mv	a0,s5
    148c:	00000097          	auipc	ra,0x0
    1490:	e92080e7          	jalr	-366(ra) # 131e <putc>
        putc(fd, c);
    1494:	85ca                	mv	a1,s2
    1496:	8556                	mv	a0,s5
    1498:	00000097          	auipc	ra,0x0
    149c:	e86080e7          	jalr	-378(ra) # 131e <putc>
      }
      state = 0;
    14a0:	4981                	li	s3,0
    14a2:	b765                	j	144a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    14a4:	008b0913          	addi	s2,s6,8
    14a8:	4685                	li	a3,1
    14aa:	4629                	li	a2,10
    14ac:	000b2583          	lw	a1,0(s6)
    14b0:	8556                	mv	a0,s5
    14b2:	00000097          	auipc	ra,0x0
    14b6:	e8e080e7          	jalr	-370(ra) # 1340 <printint>
    14ba:	8b4a                	mv	s6,s2
      state = 0;
    14bc:	4981                	li	s3,0
    14be:	b771                	j	144a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    14c0:	008b0913          	addi	s2,s6,8
    14c4:	4681                	li	a3,0
    14c6:	4629                	li	a2,10
    14c8:	000b2583          	lw	a1,0(s6)
    14cc:	8556                	mv	a0,s5
    14ce:	00000097          	auipc	ra,0x0
    14d2:	e72080e7          	jalr	-398(ra) # 1340 <printint>
    14d6:	8b4a                	mv	s6,s2
      state = 0;
    14d8:	4981                	li	s3,0
    14da:	bf85                	j	144a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    14dc:	008b0913          	addi	s2,s6,8
    14e0:	4681                	li	a3,0
    14e2:	4641                	li	a2,16
    14e4:	000b2583          	lw	a1,0(s6)
    14e8:	8556                	mv	a0,s5
    14ea:	00000097          	auipc	ra,0x0
    14ee:	e56080e7          	jalr	-426(ra) # 1340 <printint>
    14f2:	8b4a                	mv	s6,s2
      state = 0;
    14f4:	4981                	li	s3,0
    14f6:	bf91                	j	144a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    14f8:	008b0793          	addi	a5,s6,8
    14fc:	f8f43423          	sd	a5,-120(s0)
    1500:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1504:	03000593          	li	a1,48
    1508:	8556                	mv	a0,s5
    150a:	00000097          	auipc	ra,0x0
    150e:	e14080e7          	jalr	-492(ra) # 131e <putc>
  putc(fd, 'x');
    1512:	85ea                	mv	a1,s10
    1514:	8556                	mv	a0,s5
    1516:	00000097          	auipc	ra,0x0
    151a:	e08080e7          	jalr	-504(ra) # 131e <putc>
    151e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1520:	03c9d793          	srli	a5,s3,0x3c
    1524:	97de                	add	a5,a5,s7
    1526:	0007c583          	lbu	a1,0(a5)
    152a:	8556                	mv	a0,s5
    152c:	00000097          	auipc	ra,0x0
    1530:	df2080e7          	jalr	-526(ra) # 131e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1534:	0992                	slli	s3,s3,0x4
    1536:	397d                	addiw	s2,s2,-1
    1538:	fe0914e3          	bnez	s2,1520 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    153c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1540:	4981                	li	s3,0
    1542:	b721                	j	144a <vprintf+0x60>
        s = va_arg(ap, char*);
    1544:	008b0993          	addi	s3,s6,8
    1548:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    154c:	02090163          	beqz	s2,156e <vprintf+0x184>
        while(*s != 0){
    1550:	00094583          	lbu	a1,0(s2)
    1554:	c9a1                	beqz	a1,15a4 <vprintf+0x1ba>
          putc(fd, *s);
    1556:	8556                	mv	a0,s5
    1558:	00000097          	auipc	ra,0x0
    155c:	dc6080e7          	jalr	-570(ra) # 131e <putc>
          s++;
    1560:	0905                	addi	s2,s2,1
        while(*s != 0){
    1562:	00094583          	lbu	a1,0(s2)
    1566:	f9e5                	bnez	a1,1556 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1568:	8b4e                	mv	s6,s3
      state = 0;
    156a:	4981                	li	s3,0
    156c:	bdf9                	j	144a <vprintf+0x60>
          s = "(null)";
    156e:	00000917          	auipc	s2,0x0
    1572:	26290913          	addi	s2,s2,610 # 17d0 <malloc+0x11c>
        while(*s != 0){
    1576:	02800593          	li	a1,40
    157a:	bff1                	j	1556 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    157c:	008b0913          	addi	s2,s6,8
    1580:	000b4583          	lbu	a1,0(s6)
    1584:	8556                	mv	a0,s5
    1586:	00000097          	auipc	ra,0x0
    158a:	d98080e7          	jalr	-616(ra) # 131e <putc>
    158e:	8b4a                	mv	s6,s2
      state = 0;
    1590:	4981                	li	s3,0
    1592:	bd65                	j	144a <vprintf+0x60>
        putc(fd, c);
    1594:	85d2                	mv	a1,s4
    1596:	8556                	mv	a0,s5
    1598:	00000097          	auipc	ra,0x0
    159c:	d86080e7          	jalr	-634(ra) # 131e <putc>
      state = 0;
    15a0:	4981                	li	s3,0
    15a2:	b565                	j	144a <vprintf+0x60>
        s = va_arg(ap, char*);
    15a4:	8b4e                	mv	s6,s3
      state = 0;
    15a6:	4981                	li	s3,0
    15a8:	b54d                	j	144a <vprintf+0x60>
    }
  }
}
    15aa:	70e6                	ld	ra,120(sp)
    15ac:	7446                	ld	s0,112(sp)
    15ae:	74a6                	ld	s1,104(sp)
    15b0:	7906                	ld	s2,96(sp)
    15b2:	69e6                	ld	s3,88(sp)
    15b4:	6a46                	ld	s4,80(sp)
    15b6:	6aa6                	ld	s5,72(sp)
    15b8:	6b06                	ld	s6,64(sp)
    15ba:	7be2                	ld	s7,56(sp)
    15bc:	7c42                	ld	s8,48(sp)
    15be:	7ca2                	ld	s9,40(sp)
    15c0:	7d02                	ld	s10,32(sp)
    15c2:	6de2                	ld	s11,24(sp)
    15c4:	6109                	addi	sp,sp,128
    15c6:	8082                	ret

00000000000015c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    15c8:	715d                	addi	sp,sp,-80
    15ca:	ec06                	sd	ra,24(sp)
    15cc:	e822                	sd	s0,16(sp)
    15ce:	1000                	addi	s0,sp,32
    15d0:	e010                	sd	a2,0(s0)
    15d2:	e414                	sd	a3,8(s0)
    15d4:	e818                	sd	a4,16(s0)
    15d6:	ec1c                	sd	a5,24(s0)
    15d8:	03043023          	sd	a6,32(s0)
    15dc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    15e0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    15e4:	8622                	mv	a2,s0
    15e6:	00000097          	auipc	ra,0x0
    15ea:	e04080e7          	jalr	-508(ra) # 13ea <vprintf>
}
    15ee:	60e2                	ld	ra,24(sp)
    15f0:	6442                	ld	s0,16(sp)
    15f2:	6161                	addi	sp,sp,80
    15f4:	8082                	ret

00000000000015f6 <printf>:

void
printf(const char *fmt, ...)
{
    15f6:	711d                	addi	sp,sp,-96
    15f8:	ec06                	sd	ra,24(sp)
    15fa:	e822                	sd	s0,16(sp)
    15fc:	1000                	addi	s0,sp,32
    15fe:	e40c                	sd	a1,8(s0)
    1600:	e810                	sd	a2,16(s0)
    1602:	ec14                	sd	a3,24(s0)
    1604:	f018                	sd	a4,32(s0)
    1606:	f41c                	sd	a5,40(s0)
    1608:	03043823          	sd	a6,48(s0)
    160c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1610:	00840613          	addi	a2,s0,8
    1614:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1618:	85aa                	mv	a1,a0
    161a:	4505                	li	a0,1
    161c:	00000097          	auipc	ra,0x0
    1620:	dce080e7          	jalr	-562(ra) # 13ea <vprintf>
}
    1624:	60e2                	ld	ra,24(sp)
    1626:	6442                	ld	s0,16(sp)
    1628:	6125                	addi	sp,sp,96
    162a:	8082                	ret

000000000000162c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    162c:	1141                	addi	sp,sp,-16
    162e:	e422                	sd	s0,8(sp)
    1630:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1632:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1636:	00000797          	auipc	a5,0x0
    163a:	1ba7b783          	ld	a5,442(a5) # 17f0 <freep>
    163e:	a805                	j	166e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1640:	4618                	lw	a4,8(a2)
    1642:	9db9                	addw	a1,a1,a4
    1644:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1648:	6398                	ld	a4,0(a5)
    164a:	6318                	ld	a4,0(a4)
    164c:	fee53823          	sd	a4,-16(a0)
    1650:	a091                	j	1694 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1652:	ff852703          	lw	a4,-8(a0)
    1656:	9e39                	addw	a2,a2,a4
    1658:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    165a:	ff053703          	ld	a4,-16(a0)
    165e:	e398                	sd	a4,0(a5)
    1660:	a099                	j	16a6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1662:	6398                	ld	a4,0(a5)
    1664:	00e7e463          	bltu	a5,a4,166c <free+0x40>
    1668:	00e6ea63          	bltu	a3,a4,167c <free+0x50>
{
    166c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    166e:	fed7fae3          	bgeu	a5,a3,1662 <free+0x36>
    1672:	6398                	ld	a4,0(a5)
    1674:	00e6e463          	bltu	a3,a4,167c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1678:	fee7eae3          	bltu	a5,a4,166c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    167c:	ff852583          	lw	a1,-8(a0)
    1680:	6390                	ld	a2,0(a5)
    1682:	02059713          	slli	a4,a1,0x20
    1686:	9301                	srli	a4,a4,0x20
    1688:	0712                	slli	a4,a4,0x4
    168a:	9736                	add	a4,a4,a3
    168c:	fae60ae3          	beq	a2,a4,1640 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1690:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1694:	4790                	lw	a2,8(a5)
    1696:	02061713          	slli	a4,a2,0x20
    169a:	9301                	srli	a4,a4,0x20
    169c:	0712                	slli	a4,a4,0x4
    169e:	973e                	add	a4,a4,a5
    16a0:	fae689e3          	beq	a3,a4,1652 <free+0x26>
  } else
    p->s.ptr = bp;
    16a4:	e394                	sd	a3,0(a5)
  freep = p;
    16a6:	00000717          	auipc	a4,0x0
    16aa:	14f73523          	sd	a5,330(a4) # 17f0 <freep>
}
    16ae:	6422                	ld	s0,8(sp)
    16b0:	0141                	addi	sp,sp,16
    16b2:	8082                	ret

00000000000016b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    16b4:	7139                	addi	sp,sp,-64
    16b6:	fc06                	sd	ra,56(sp)
    16b8:	f822                	sd	s0,48(sp)
    16ba:	f426                	sd	s1,40(sp)
    16bc:	f04a                	sd	s2,32(sp)
    16be:	ec4e                	sd	s3,24(sp)
    16c0:	e852                	sd	s4,16(sp)
    16c2:	e456                	sd	s5,8(sp)
    16c4:	e05a                	sd	s6,0(sp)
    16c6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16c8:	02051493          	slli	s1,a0,0x20
    16cc:	9081                	srli	s1,s1,0x20
    16ce:	04bd                	addi	s1,s1,15
    16d0:	8091                	srli	s1,s1,0x4
    16d2:	0014899b          	addiw	s3,s1,1
    16d6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    16d8:	00000517          	auipc	a0,0x0
    16dc:	11853503          	ld	a0,280(a0) # 17f0 <freep>
    16e0:	c515                	beqz	a0,170c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    16e4:	4798                	lw	a4,8(a5)
    16e6:	02977f63          	bgeu	a4,s1,1724 <malloc+0x70>
    16ea:	8a4e                	mv	s4,s3
    16ec:	0009871b          	sext.w	a4,s3
    16f0:	6685                	lui	a3,0x1
    16f2:	00d77363          	bgeu	a4,a3,16f8 <malloc+0x44>
    16f6:	6a05                	lui	s4,0x1
    16f8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    16fc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1700:	00000917          	auipc	s2,0x0
    1704:	0f090913          	addi	s2,s2,240 # 17f0 <freep>
  if(p == (char*)-1)
    1708:	5afd                	li	s5,-1
    170a:	a88d                	j	177c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    170c:	00000797          	auipc	a5,0x0
    1710:	0ec78793          	addi	a5,a5,236 # 17f8 <base>
    1714:	00000717          	auipc	a4,0x0
    1718:	0cf73e23          	sd	a5,220(a4) # 17f0 <freep>
    171c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    171e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1722:	b7e1                	j	16ea <malloc+0x36>
      if(p->s.size == nunits)
    1724:	02e48b63          	beq	s1,a4,175a <malloc+0xa6>
        p->s.size -= nunits;
    1728:	4137073b          	subw	a4,a4,s3
    172c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    172e:	1702                	slli	a4,a4,0x20
    1730:	9301                	srli	a4,a4,0x20
    1732:	0712                	slli	a4,a4,0x4
    1734:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1736:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    173a:	00000717          	auipc	a4,0x0
    173e:	0aa73b23          	sd	a0,182(a4) # 17f0 <freep>
      return (void*)(p + 1);
    1742:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1746:	70e2                	ld	ra,56(sp)
    1748:	7442                	ld	s0,48(sp)
    174a:	74a2                	ld	s1,40(sp)
    174c:	7902                	ld	s2,32(sp)
    174e:	69e2                	ld	s3,24(sp)
    1750:	6a42                	ld	s4,16(sp)
    1752:	6aa2                	ld	s5,8(sp)
    1754:	6b02                	ld	s6,0(sp)
    1756:	6121                	addi	sp,sp,64
    1758:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    175a:	6398                	ld	a4,0(a5)
    175c:	e118                	sd	a4,0(a0)
    175e:	bff1                	j	173a <malloc+0x86>
  hp->s.size = nu;
    1760:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1764:	0541                	addi	a0,a0,16
    1766:	00000097          	auipc	ra,0x0
    176a:	ec6080e7          	jalr	-314(ra) # 162c <free>
  return freep;
    176e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1772:	d971                	beqz	a0,1746 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1774:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1776:	4798                	lw	a4,8(a5)
    1778:	fa9776e3          	bgeu	a4,s1,1724 <malloc+0x70>
    if(p == freep)
    177c:	00093703          	ld	a4,0(s2)
    1780:	853e                	mv	a0,a5
    1782:	fef719e3          	bne	a4,a5,1774 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1786:	8552                	mv	a0,s4
    1788:	00000097          	auipc	ra,0x0
    178c:	b6e080e7          	jalr	-1170(ra) # 12f6 <sbrk>
  if(p == (char*)-1)
    1790:	fd5518e3          	bne	a0,s5,1760 <malloc+0xac>
        return 0;
    1794:	4501                	li	a0,0
    1796:	bf45                	j	1746 <malloc+0x92>
