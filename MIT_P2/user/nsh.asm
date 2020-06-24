
user/_nsh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <readline>:
#define MAX_ARGS 32
#define R 0
#define W 1

int
readline(char* buf, int n) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  gets(buf, n);
   c:	00000097          	auipc	ra,0x0
  10:	56e080e7          	jalr	1390(ra) # 57a <gets>
  if (buf[0] == 0) return -1;
  14:	0004c783          	lbu	a5,0(s1)
  18:	c395                	beqz	a5,3c <readline+0x3c>
  buf[strlen(buf) - 1] = 0;
  1a:	8526                	mv	a0,s1
  1c:	00000097          	auipc	ra,0x0
  20:	4ea080e7          	jalr	1258(ra) # 506 <strlen>
  24:	357d                	addiw	a0,a0,-1
  26:	1502                	slli	a0,a0,0x20
  28:	9101                	srli	a0,a0,0x20
  2a:	94aa                	add	s1,s1,a0
  2c:	00048023          	sb	zero,0(s1)
  return 0;
  30:	4501                	li	a0,0
}
  32:	60e2                	ld	ra,24(sp)
  34:	6442                	ld	s0,16(sp)
  36:	64a2                	ld	s1,8(sp)
  38:	6105                	addi	sp,sp,32
  3a:	8082                	ret
  if (buf[0] == 0) return -1;
  3c:	557d                	li	a0,-1
  3e:	bfd5                	j	32 <readline+0x32>

0000000000000040 <open_stdin>:

int
open_stdin(char* path) {
  40:	1101                	addi	sp,sp,-32
  42:	ec06                	sd	ra,24(sp)
  44:	e822                	sd	s0,16(sp)
  46:	e426                	sd	s1,8(sp)
  48:	1000                	addi	s0,sp,32
  4a:	84aa                	mv	s1,a0
  close(0);
  4c:	4501                	li	a0,0
  4e:	00000097          	auipc	ra,0x0
  52:	68e080e7          	jalr	1678(ra) # 6dc <close>
  if (open(path, O_RDONLY) != 0) {
  56:	4581                	li	a1,0
  58:	8526                	mv	a0,s1
  5a:	00000097          	auipc	ra,0x0
  5e:	69a080e7          	jalr	1690(ra) # 6f4 <open>
  62:	e519                	bnez	a0,70 <open_stdin+0x30>
    fprintf(2, "open stdin %s failed!\n", path);
    exit(1);
  }
  return 0;
}
  64:	4501                	li	a0,0
  66:	60e2                	ld	ra,24(sp)
  68:	6442                	ld	s0,16(sp)
  6a:	64a2                	ld	s1,8(sp)
  6c:	6105                	addi	sp,sp,32
  6e:	8082                	ret
    fprintf(2, "open stdin %s failed!\n", path);
  70:	8626                	mv	a2,s1
  72:	00001597          	auipc	a1,0x1
  76:	b7e58593          	addi	a1,a1,-1154 # bf0 <malloc+0xe6>
  7a:	4509                	li	a0,2
  7c:	00001097          	auipc	ra,0x1
  80:	9a2080e7          	jalr	-1630(ra) # a1e <fprintf>
    exit(1);
  84:	4505                	li	a0,1
  86:	00000097          	auipc	ra,0x0
  8a:	62e080e7          	jalr	1582(ra) # 6b4 <exit>

000000000000008e <redirect_stdin>:

int
redirect_stdin(int fd) {
  8e:	1101                	addi	sp,sp,-32
  90:	ec06                	sd	ra,24(sp)
  92:	e822                	sd	s0,16(sp)
  94:	e426                	sd	s1,8(sp)
  96:	1000                	addi	s0,sp,32
  98:	84aa                	mv	s1,a0
  close(0);
  9a:	4501                	li	a0,0
  9c:	00000097          	auipc	ra,0x0
  a0:	640080e7          	jalr	1600(ra) # 6dc <close>
  if (dup(fd) != 0) {
  a4:	8526                	mv	a0,s1
  a6:	00000097          	auipc	ra,0x0
  aa:	686080e7          	jalr	1670(ra) # 72c <dup>
  ae:	e519                	bnez	a0,bc <redirect_stdin+0x2e>
    fprintf(2, "redirect stdin failed!\n");
    exit(1);
  }
  return 0;
}
  b0:	4501                	li	a0,0
  b2:	60e2                	ld	ra,24(sp)
  b4:	6442                	ld	s0,16(sp)
  b6:	64a2                	ld	s1,8(sp)
  b8:	6105                	addi	sp,sp,32
  ba:	8082                	ret
    fprintf(2, "redirect stdin failed!\n");
  bc:	00001597          	auipc	a1,0x1
  c0:	b4c58593          	addi	a1,a1,-1204 # c08 <malloc+0xfe>
  c4:	4509                	li	a0,2
  c6:	00001097          	auipc	ra,0x1
  ca:	958080e7          	jalr	-1704(ra) # a1e <fprintf>
    exit(1);
  ce:	4505                	li	a0,1
  d0:	00000097          	auipc	ra,0x0
  d4:	5e4080e7          	jalr	1508(ra) # 6b4 <exit>

00000000000000d8 <open_stdout>:

int
open_stdout(char* path) {
  d8:	1101                	addi	sp,sp,-32
  da:	ec06                	sd	ra,24(sp)
  dc:	e822                	sd	s0,16(sp)
  de:	e426                	sd	s1,8(sp)
  e0:	1000                	addi	s0,sp,32
  e2:	84aa                	mv	s1,a0
  close(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	5f6080e7          	jalr	1526(ra) # 6dc <close>
  if (open(path, O_CREATE | O_WRONLY) != 1) {
  ee:	20100593          	li	a1,513
  f2:	8526                	mv	a0,s1
  f4:	00000097          	auipc	ra,0x0
  f8:	600080e7          	jalr	1536(ra) # 6f4 <open>
  fc:	4785                	li	a5,1
  fe:	00f51863          	bne	a0,a5,10e <open_stdout+0x36>
    fprintf(2, "open stdout %s failed!\n", path);
    exit(1);
  }
  return 0;
}
 102:	4501                	li	a0,0
 104:	60e2                	ld	ra,24(sp)
 106:	6442                	ld	s0,16(sp)
 108:	64a2                	ld	s1,8(sp)
 10a:	6105                	addi	sp,sp,32
 10c:	8082                	ret
    fprintf(2, "open stdout %s failed!\n", path);
 10e:	8626                	mv	a2,s1
 110:	00001597          	auipc	a1,0x1
 114:	b1058593          	addi	a1,a1,-1264 # c20 <malloc+0x116>
 118:	4509                	li	a0,2
 11a:	00001097          	auipc	ra,0x1
 11e:	904080e7          	jalr	-1788(ra) # a1e <fprintf>
    exit(1);
 122:	4505                	li	a0,1
 124:	00000097          	auipc	ra,0x0
 128:	590080e7          	jalr	1424(ra) # 6b4 <exit>

000000000000012c <redirect_stdout>:

int
redirect_stdout(int fd) {
 12c:	1101                	addi	sp,sp,-32
 12e:	ec06                	sd	ra,24(sp)
 130:	e822                	sd	s0,16(sp)
 132:	e426                	sd	s1,8(sp)
 134:	1000                	addi	s0,sp,32
 136:	84aa                	mv	s1,a0
  close(1);
 138:	4505                	li	a0,1
 13a:	00000097          	auipc	ra,0x0
 13e:	5a2080e7          	jalr	1442(ra) # 6dc <close>
  if (dup(fd) != 1) {
 142:	8526                	mv	a0,s1
 144:	00000097          	auipc	ra,0x0
 148:	5e8080e7          	jalr	1512(ra) # 72c <dup>
 14c:	4785                	li	a5,1
 14e:	00f51863          	bne	a0,a5,15e <redirect_stdout+0x32>
    fprintf(2, "redirect stdout failed!\n");
    exit(1);
  }
  return 0;
}
 152:	4501                	li	a0,0
 154:	60e2                	ld	ra,24(sp)
 156:	6442                	ld	s0,16(sp)
 158:	64a2                	ld	s1,8(sp)
 15a:	6105                	addi	sp,sp,32
 15c:	8082                	ret
    fprintf(2, "redirect stdout failed!\n");
 15e:	00001597          	auipc	a1,0x1
 162:	ada58593          	addi	a1,a1,-1318 # c38 <malloc+0x12e>
 166:	4509                	li	a0,2
 168:	00001097          	auipc	ra,0x1
 16c:	8b6080e7          	jalr	-1866(ra) # a1e <fprintf>
    exit(1);
 170:	4505                	li	a0,1
 172:	00000097          	auipc	ra,0x0
 176:	542080e7          	jalr	1346(ra) # 6b4 <exit>

000000000000017a <destroy_stdin>:

int
destroy_stdin() {
 17a:	1141                	addi	sp,sp,-16
 17c:	e406                	sd	ra,8(sp)
 17e:	e022                	sd	s0,0(sp)
 180:	0800                	addi	s0,sp,16
  close(0);
 182:	4501                	li	a0,0
 184:	00000097          	auipc	ra,0x0
 188:	558080e7          	jalr	1368(ra) # 6dc <close>
  return 0;
}
 18c:	4501                	li	a0,0
 18e:	60a2                	ld	ra,8(sp)
 190:	6402                	ld	s0,0(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret

0000000000000196 <destroy_stdout>:

int
destroy_stdout() {
 196:	1141                	addi	sp,sp,-16
 198:	e406                	sd	ra,8(sp)
 19a:	e022                	sd	s0,0(sp)
 19c:	0800                	addi	s0,sp,16
  close(1);
 19e:	4505                	li	a0,1
 1a0:	00000097          	auipc	ra,0x0
 1a4:	53c080e7          	jalr	1340(ra) # 6dc <close>
  return 0;
}
 1a8:	4501                	li	a0,0
 1aa:	60a2                	ld	ra,8(sp)
 1ac:	6402                	ld	s0,0(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <run>:


int
run(char* path, char** argv) {
 1b2:	7159                	addi	sp,sp,-112
 1b4:	f486                	sd	ra,104(sp)
 1b6:	f0a2                	sd	s0,96(sp)
 1b8:	eca6                	sd	s1,88(sp)
 1ba:	e8ca                	sd	s2,80(sp)
 1bc:	e4ce                	sd	s3,72(sp)
 1be:	e0d2                	sd	s4,64(sp)
 1c0:	fc56                	sd	s5,56(sp)
 1c2:	f85a                	sd	s6,48(sp)
 1c4:	f45e                	sd	s7,40(sp)
 1c6:	f062                	sd	s8,32(sp)
 1c8:	ec66                	sd	s9,24(sp)
 1ca:	1880                	addi	s0,sp,112
 1cc:	8caa                	mv	s9,a0
 1ce:	8c2e                	mv	s8,a1
  char** pipe_argv = 0;
  char* stdin = 0;
  char* stdout = 0;
  for (char** v = argv; *v != 0; ++v) {
 1d0:	6188                	ld	a0,0(a1)
 1d2:	18050263          	beqz	a0,356 <run+0x1a4>
 1d6:	84ae                	mv	s1,a1
  char* stdout = 0;
 1d8:	4b81                	li	s7,0
  char* stdin = 0;
 1da:	4b01                	li	s6,0
    if (strcmp(*v, "<") == 0) {
 1dc:	00001a97          	auipc	s5,0x1
 1e0:	a7ca8a93          	addi	s5,s5,-1412 # c58 <malloc+0x14e>
      *v = 0;
      stdin = *(v + 1);
      ++v;
    }
    if (strcmp(*v, ">") == 0) {
 1e4:	00001a17          	auipc	s4,0x1
 1e8:	a7ca0a13          	addi	s4,s4,-1412 # c60 <malloc+0x156>
      *v = 0;
      stdout = *(v + 1);
      ++v;
    }
    if (strcmp(*v, "|") == 0) {
 1ec:	00001997          	auipc	s3,0x1
 1f0:	a7c98993          	addi	s3,s3,-1412 # c68 <malloc+0x15e>
 1f4:	a839                	j	212 <run+0x60>
 1f6:	85ce                	mv	a1,s3
 1f8:	00093503          	ld	a0,0(s2)
 1fc:	00000097          	auipc	ra,0x0
 200:	2de080e7          	jalr	734(ra) # 4da <strcmp>
 204:	c129                	beqz	a0,246 <run+0x94>
  for (char** v = argv; *v != 0; ++v) {
 206:	00890493          	addi	s1,s2,8
 20a:	00893503          	ld	a0,8(s2)
 20e:	14050663          	beqz	a0,35a <run+0x1a8>
    if (strcmp(*v, "<") == 0) {
 212:	85d6                	mv	a1,s5
 214:	00000097          	auipc	ra,0x0
 218:	2c6080e7          	jalr	710(ra) # 4da <strcmp>
 21c:	e511                	bnez	a0,228 <run+0x76>
      *v = 0;
 21e:	0004b023          	sd	zero,0(s1)
      stdin = *(v + 1);
 222:	0084bb03          	ld	s6,8(s1)
      ++v;
 226:	04a1                	addi	s1,s1,8
    if (strcmp(*v, ">") == 0) {
 228:	85d2                	mv	a1,s4
 22a:	6088                	ld	a0,0(s1)
 22c:	00000097          	auipc	ra,0x0
 230:	2ae080e7          	jalr	686(ra) # 4da <strcmp>
 234:	8926                	mv	s2,s1
 236:	f161                	bnez	a0,1f6 <run+0x44>
      *v = 0;
 238:	0004b023          	sd	zero,0(s1)
      stdout = *(v + 1);
 23c:	0084bb83          	ld	s7,8(s1)
      ++v;
 240:	00848913          	addi	s2,s1,8
 244:	bf4d                	j	1f6 <run+0x44>
      *v = 0;
 246:	00093023          	sd	zero,0(s2)
      pipe_argv = v + 1;
 24a:	00890493          	addi	s1,s2,8
      break;
    }
  }

  if (fork() == 0) {
 24e:	00000097          	auipc	ra,0x0
 252:	45e080e7          	jalr	1118(ra) # 6ac <fork>
 256:	10051763          	bnez	a0,364 <run+0x1b2>
    int fd[2];
    if (pipe_argv != 0) {
      pipe(fd);
 25a:	f9840513          	addi	a0,s0,-104
 25e:	00000097          	auipc	ra,0x0
 262:	466080e7          	jalr	1126(ra) # 6c4 <pipe>
      if (fork() == 0) {
 266:	00000097          	auipc	ra,0x0
 26a:	446080e7          	jalr	1094(ra) # 6ac <fork>
 26e:	e139                	bnez	a0,2b4 <run+0x102>
        close(fd[W]);
 270:	f9c42503          	lw	a0,-100(s0)
 274:	00000097          	auipc	ra,0x0
 278:	468080e7          	jalr	1128(ra) # 6dc <close>
        redirect_stdin(fd[R]);
 27c:	f9842503          	lw	a0,-104(s0)
 280:	00000097          	auipc	ra,0x0
 284:	e0e080e7          	jalr	-498(ra) # 8e <redirect_stdin>
        run(pipe_argv[0], pipe_argv);
 288:	85a6                	mv	a1,s1
 28a:	00893503          	ld	a0,8(s2)
 28e:	00000097          	auipc	ra,0x0
 292:	f24080e7          	jalr	-220(ra) # 1b2 <run>
        close(fd[R]);
 296:	f9842503          	lw	a0,-104(s0)
 29a:	00000097          	auipc	ra,0x0
 29e:	442080e7          	jalr	1090(ra) # 6dc <close>
        destroy_stdin();
 2a2:	00000097          	auipc	ra,0x0
 2a6:	ed8080e7          	jalr	-296(ra) # 17a <destroy_stdin>
        exit(0);
 2aa:	4501                	li	a0,0
 2ac:	00000097          	auipc	ra,0x0
 2b0:	408080e7          	jalr	1032(ra) # 6b4 <exit>
      }
      close(fd[R]);
 2b4:	f9842503          	lw	a0,-104(s0)
 2b8:	00000097          	auipc	ra,0x0
 2bc:	424080e7          	jalr	1060(ra) # 6dc <close>
      redirect_stdout(fd[W]);
 2c0:	f9c42503          	lw	a0,-100(s0)
 2c4:	00000097          	auipc	ra,0x0
 2c8:	e68080e7          	jalr	-408(ra) # 12c <redirect_stdout>
    }

    if (stdin != 0) open_stdin(stdin);
 2cc:	0a0b0f63          	beqz	s6,38a <run+0x1d8>
 2d0:	855a                	mv	a0,s6
 2d2:	00000097          	auipc	ra,0x0
 2d6:	d6e080e7          	jalr	-658(ra) # 40 <open_stdin>
    if (stdout != 0) open_stdout(stdout);
 2da:	060b8063          	beqz	s7,33a <run+0x188>
 2de:	855e                	mv	a0,s7
 2e0:	00000097          	auipc	ra,0x0
 2e4:	df8080e7          	jalr	-520(ra) # d8 <open_stdout>
    
    exec(path, argv);
 2e8:	85e2                	mv	a1,s8
 2ea:	8566                	mv	a0,s9
 2ec:	00000097          	auipc	ra,0x0
 2f0:	400080e7          	jalr	1024(ra) # 6ec <exec>

    if (stdin != 0) destroy_stdin(stdin);
 2f4:	000b0763          	beqz	s6,302 <run+0x150>
 2f8:	855a                	mv	a0,s6
 2fa:	00000097          	auipc	ra,0x0
 2fe:	e80080e7          	jalr	-384(ra) # 17a <destroy_stdin>
    if (stdout != 0) destroy_stdout(stdout);
 302:	855e                	mv	a0,s7
 304:	00000097          	auipc	ra,0x0
 308:	e92080e7          	jalr	-366(ra) # 196 <destroy_stdout>
  
    if (pipe_argv != 0) {
 30c:	c085                	beqz	s1,32c <run+0x17a>
      close(fd[W]);
 30e:	f9c42503          	lw	a0,-100(s0)
 312:	00000097          	auipc	ra,0x0
 316:	3ca080e7          	jalr	970(ra) # 6dc <close>
      destroy_stdout();
 31a:	00000097          	auipc	ra,0x0
 31e:	e7c080e7          	jalr	-388(ra) # 196 <destroy_stdout>
      wait(0);
 322:	4501                	li	a0,0
 324:	00000097          	auipc	ra,0x0
 328:	398080e7          	jalr	920(ra) # 6bc <wait>
    }
    exit(0);
 32c:	4501                	li	a0,0
 32e:	00000097          	auipc	ra,0x0
 332:	386080e7          	jalr	902(ra) # 6b4 <exit>
  if (fork() == 0) {
 336:	4481                	li	s1,0
 338:	bf51                	j	2cc <run+0x11a>
    exec(path, argv);
 33a:	85e2                	mv	a1,s8
 33c:	8566                	mv	a0,s9
 33e:	00000097          	auipc	ra,0x0
 342:	3ae080e7          	jalr	942(ra) # 6ec <exec>
    if (stdin != 0) destroy_stdin(stdin);
 346:	fc0b03e3          	beqz	s6,30c <run+0x15a>
 34a:	855a                	mv	a0,s6
 34c:	00000097          	auipc	ra,0x0
 350:	e2e080e7          	jalr	-466(ra) # 17a <destroy_stdin>
    if (stdout != 0) destroy_stdout(stdout);
 354:	bf65                	j	30c <run+0x15a>
  char* stdout = 0;
 356:	8baa                	mv	s7,a0
  char* stdin = 0;
 358:	8b2a                	mv	s6,a0
  if (fork() == 0) {
 35a:	00000097          	auipc	ra,0x0
 35e:	352080e7          	jalr	850(ra) # 6ac <fork>
 362:	d971                	beqz	a0,336 <run+0x184>
  } else {
    wait(0);
 364:	4501                	li	a0,0
 366:	00000097          	auipc	ra,0x0
 36a:	356080e7          	jalr	854(ra) # 6bc <wait>
  }
  return 0;
}
 36e:	4501                	li	a0,0
 370:	70a6                	ld	ra,104(sp)
 372:	7406                	ld	s0,96(sp)
 374:	64e6                	ld	s1,88(sp)
 376:	6946                	ld	s2,80(sp)
 378:	69a6                	ld	s3,72(sp)
 37a:	6a06                	ld	s4,64(sp)
 37c:	7ae2                	ld	s5,56(sp)
 37e:	7b42                	ld	s6,48(sp)
 380:	7ba2                	ld	s7,40(sp)
 382:	7c02                	ld	s8,32(sp)
 384:	6ce2                	ld	s9,24(sp)
 386:	6165                	addi	sp,sp,112
 388:	8082                	ret
    if (stdout != 0) open_stdout(stdout);
 38a:	fa0b88e3          	beqz	s7,33a <run+0x188>
 38e:	855e                	mv	a0,s7
 390:	00000097          	auipc	ra,0x0
 394:	d48080e7          	jalr	-696(ra) # d8 <open_stdout>
    exec(path, argv);
 398:	85e2                	mv	a1,s8
 39a:	8566                	mv	a0,s9
 39c:	00000097          	auipc	ra,0x0
 3a0:	350080e7          	jalr	848(ra) # 6ec <exec>
    if (stdin != 0) destroy_stdin(stdin);
 3a4:	bfb9                	j	302 <run+0x150>

00000000000003a6 <main>:

int
main(int argc, char *argv[])
{
 3a6:	7161                	addi	sp,sp,-432
 3a8:	f706                	sd	ra,424(sp)
 3aa:	f322                	sd	s0,416(sp)
 3ac:	ef26                	sd	s1,408(sp)
 3ae:	eb4a                	sd	s2,400(sp)
 3b0:	e74e                	sd	s3,392(sp)
 3b2:	1b00                	addi	s0,sp,432
  char buf[MAX_CHAR] = { 0 };
 3b4:	f4043823          	sd	zero,-176(s0)
 3b8:	f4043c23          	sd	zero,-168(s0)
 3bc:	f6043023          	sd	zero,-160(s0)
 3c0:	f6043423          	sd	zero,-152(s0)
 3c4:	f6043823          	sd	zero,-144(s0)
 3c8:	f6043c23          	sd	zero,-136(s0)
 3cc:	f8043023          	sd	zero,-128(s0)
 3d0:	f8043423          	sd	zero,-120(s0)
 3d4:	f8043823          	sd	zero,-112(s0)
 3d8:	f8043c23          	sd	zero,-104(s0)
 3dc:	fa043023          	sd	zero,-96(s0)
 3e0:	fa043423          	sd	zero,-88(s0)
 3e4:	fa043823          	sd	zero,-80(s0)
 3e8:	fa043c23          	sd	zero,-72(s0)
 3ec:	fc043023          	sd	zero,-64(s0)
 3f0:	fc043423          	sd	zero,-56(s0)
  char* aargv[MAX_ARGS] = { 0 };
 3f4:	10000613          	li	a2,256
 3f8:	4581                	li	a1,0
 3fa:	e5040513          	addi	a0,s0,-432
 3fe:	00000097          	auipc	ra,0x0
 402:	132080e7          	jalr	306(ra) # 530 <memset>
  int aargc = 0;
  printf("@ ");
 406:	00001517          	auipc	a0,0x1
 40a:	86a50513          	addi	a0,a0,-1942 # c70 <malloc+0x166>
 40e:	00000097          	auipc	ra,0x0
 412:	63e080e7          	jalr	1598(ra) # a4c <printf>
  while(!readline(buf, MAX_CHAR)) {
    int _len = strlen(buf);
    aargc = 0;
    aargv[aargc++] = buf;
 416:	4985                	li	s3,1
    for (int i = 0; i < _len; i++) {
      if (buf[i] == ' ') {
 418:	02000493          	li	s1,32
        aargv[aargc++] = &buf[i + 1];
      }
    }
    aargv[aargc] = 0;
    run(aargv[0], aargv);
    printf("@ ");
 41c:	00001917          	auipc	s2,0x1
 420:	85490913          	addi	s2,s2,-1964 # c70 <malloc+0x166>
  while(!readline(buf, MAX_CHAR)) {
 424:	a0b9                	j	472 <main+0xcc>
    for (int i = 0; i < _len; i++) {
 426:	0785                	addi	a5,a5,1
 428:	02d78263          	beq	a5,a3,44c <main+0xa6>
      if (buf[i] == ' ') {
 42c:	fff7c703          	lbu	a4,-1(a5)
 430:	fe971be3          	bne	a4,s1,426 <main+0x80>
        buf[i] = '\0';
 434:	fe078fa3          	sb	zero,-1(a5)
        aargv[aargc++] = &buf[i + 1];
 438:	00361713          	slli	a4,a2,0x3
 43c:	fd040593          	addi	a1,s0,-48
 440:	972e                	add	a4,a4,a1
 442:	e8f73023          	sd	a5,-384(a4)
 446:	2605                	addiw	a2,a2,1
 448:	bff9                	j	426 <main+0x80>
    aargv[aargc++] = buf;
 44a:	864e                	mv	a2,s3
    aargv[aargc] = 0;
 44c:	060e                	slli	a2,a2,0x3
 44e:	fd040793          	addi	a5,s0,-48
 452:	963e                	add	a2,a2,a5
 454:	e8063023          	sd	zero,-384(a2)
    run(aargv[0], aargv);
 458:	e5040593          	addi	a1,s0,-432
 45c:	e5043503          	ld	a0,-432(s0)
 460:	00000097          	auipc	ra,0x0
 464:	d52080e7          	jalr	-686(ra) # 1b2 <run>
    printf("@ ");
 468:	854a                	mv	a0,s2
 46a:	00000097          	auipc	ra,0x0
 46e:	5e2080e7          	jalr	1506(ra) # a4c <printf>
  while(!readline(buf, MAX_CHAR)) {
 472:	08000593          	li	a1,128
 476:	f5040513          	addi	a0,s0,-176
 47a:	00000097          	auipc	ra,0x0
 47e:	b86080e7          	jalr	-1146(ra) # 0 <readline>
 482:	e90d                	bnez	a0,4b4 <main+0x10e>
    int _len = strlen(buf);
 484:	f5040513          	addi	a0,s0,-176
 488:	00000097          	auipc	ra,0x0
 48c:	07e080e7          	jalr	126(ra) # 506 <strlen>
 490:	0005069b          	sext.w	a3,a0
    aargv[aargc++] = buf;
 494:	f5040793          	addi	a5,s0,-176
 498:	e4f43823          	sd	a5,-432(s0)
    for (int i = 0; i < _len; i++) {
 49c:	fad057e3          	blez	a3,44a <main+0xa4>
 4a0:	f5140793          	addi	a5,s0,-175
 4a4:	36fd                	addiw	a3,a3,-1
 4a6:	1682                	slli	a3,a3,0x20
 4a8:	9281                	srli	a3,a3,0x20
 4aa:	f5240713          	addi	a4,s0,-174
 4ae:	96ba                	add	a3,a3,a4
    aargv[aargc++] = buf;
 4b0:	864e                	mv	a2,s3
 4b2:	bfad                	j	42c <main+0x86>
  }
  exit(0);
 4b4:	4501                	li	a0,0
 4b6:	00000097          	auipc	ra,0x0
 4ba:	1fe080e7          	jalr	510(ra) # 6b4 <exit>

00000000000004be <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 4be:	1141                	addi	sp,sp,-16
 4c0:	e422                	sd	s0,8(sp)
 4c2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4c4:	87aa                	mv	a5,a0
 4c6:	0585                	addi	a1,a1,1
 4c8:	0785                	addi	a5,a5,1
 4ca:	fff5c703          	lbu	a4,-1(a1)
 4ce:	fee78fa3          	sb	a4,-1(a5)
 4d2:	fb75                	bnez	a4,4c6 <strcpy+0x8>
    ;
  return os;
}
 4d4:	6422                	ld	s0,8(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret

00000000000004da <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4da:	1141                	addi	sp,sp,-16
 4dc:	e422                	sd	s0,8(sp)
 4de:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4e0:	00054783          	lbu	a5,0(a0)
 4e4:	cb91                	beqz	a5,4f8 <strcmp+0x1e>
 4e6:	0005c703          	lbu	a4,0(a1)
 4ea:	00f71763          	bne	a4,a5,4f8 <strcmp+0x1e>
    p++, q++;
 4ee:	0505                	addi	a0,a0,1
 4f0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4f2:	00054783          	lbu	a5,0(a0)
 4f6:	fbe5                	bnez	a5,4e6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4f8:	0005c503          	lbu	a0,0(a1)
}
 4fc:	40a7853b          	subw	a0,a5,a0
 500:	6422                	ld	s0,8(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret

0000000000000506 <strlen>:

uint
strlen(const char *s)
{
 506:	1141                	addi	sp,sp,-16
 508:	e422                	sd	s0,8(sp)
 50a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 50c:	00054783          	lbu	a5,0(a0)
 510:	cf91                	beqz	a5,52c <strlen+0x26>
 512:	0505                	addi	a0,a0,1
 514:	87aa                	mv	a5,a0
 516:	4685                	li	a3,1
 518:	9e89                	subw	a3,a3,a0
 51a:	00f6853b          	addw	a0,a3,a5
 51e:	0785                	addi	a5,a5,1
 520:	fff7c703          	lbu	a4,-1(a5)
 524:	fb7d                	bnez	a4,51a <strlen+0x14>
    ;
  return n;
}
 526:	6422                	ld	s0,8(sp)
 528:	0141                	addi	sp,sp,16
 52a:	8082                	ret
  for(n = 0; s[n]; n++)
 52c:	4501                	li	a0,0
 52e:	bfe5                	j	526 <strlen+0x20>

0000000000000530 <memset>:

void*
memset(void *dst, int c, uint n)
{
 530:	1141                	addi	sp,sp,-16
 532:	e422                	sd	s0,8(sp)
 534:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 536:	ce09                	beqz	a2,550 <memset+0x20>
 538:	87aa                	mv	a5,a0
 53a:	fff6071b          	addiw	a4,a2,-1
 53e:	1702                	slli	a4,a4,0x20
 540:	9301                	srli	a4,a4,0x20
 542:	0705                	addi	a4,a4,1
 544:	972a                	add	a4,a4,a0
    cdst[i] = c;
 546:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 54a:	0785                	addi	a5,a5,1
 54c:	fee79de3          	bne	a5,a4,546 <memset+0x16>
  }
  return dst;
}
 550:	6422                	ld	s0,8(sp)
 552:	0141                	addi	sp,sp,16
 554:	8082                	ret

0000000000000556 <strchr>:

char*
strchr(const char *s, char c)
{
 556:	1141                	addi	sp,sp,-16
 558:	e422                	sd	s0,8(sp)
 55a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 55c:	00054783          	lbu	a5,0(a0)
 560:	cb99                	beqz	a5,576 <strchr+0x20>
    if(*s == c)
 562:	00f58763          	beq	a1,a5,570 <strchr+0x1a>
  for(; *s; s++)
 566:	0505                	addi	a0,a0,1
 568:	00054783          	lbu	a5,0(a0)
 56c:	fbfd                	bnez	a5,562 <strchr+0xc>
      return (char*)s;
  return 0;
 56e:	4501                	li	a0,0
}
 570:	6422                	ld	s0,8(sp)
 572:	0141                	addi	sp,sp,16
 574:	8082                	ret
  return 0;
 576:	4501                	li	a0,0
 578:	bfe5                	j	570 <strchr+0x1a>

000000000000057a <gets>:

char*
gets(char *buf, int max)
{
 57a:	711d                	addi	sp,sp,-96
 57c:	ec86                	sd	ra,88(sp)
 57e:	e8a2                	sd	s0,80(sp)
 580:	e4a6                	sd	s1,72(sp)
 582:	e0ca                	sd	s2,64(sp)
 584:	fc4e                	sd	s3,56(sp)
 586:	f852                	sd	s4,48(sp)
 588:	f456                	sd	s5,40(sp)
 58a:	f05a                	sd	s6,32(sp)
 58c:	ec5e                	sd	s7,24(sp)
 58e:	1080                	addi	s0,sp,96
 590:	8baa                	mv	s7,a0
 592:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 594:	892a                	mv	s2,a0
 596:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 598:	4aa9                	li	s5,10
 59a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 59c:	89a6                	mv	s3,s1
 59e:	2485                	addiw	s1,s1,1
 5a0:	0344d863          	bge	s1,s4,5d0 <gets+0x56>
    cc = read(0, &c, 1);
 5a4:	4605                	li	a2,1
 5a6:	faf40593          	addi	a1,s0,-81
 5aa:	4501                	li	a0,0
 5ac:	00000097          	auipc	ra,0x0
 5b0:	120080e7          	jalr	288(ra) # 6cc <read>
    if(cc < 1)
 5b4:	00a05e63          	blez	a0,5d0 <gets+0x56>
    buf[i++] = c;
 5b8:	faf44783          	lbu	a5,-81(s0)
 5bc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5c0:	01578763          	beq	a5,s5,5ce <gets+0x54>
 5c4:	0905                	addi	s2,s2,1
 5c6:	fd679be3          	bne	a5,s6,59c <gets+0x22>
  for(i=0; i+1 < max; ){
 5ca:	89a6                	mv	s3,s1
 5cc:	a011                	j	5d0 <gets+0x56>
 5ce:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 5d0:	99de                	add	s3,s3,s7
 5d2:	00098023          	sb	zero,0(s3)
  return buf;
}
 5d6:	855e                	mv	a0,s7
 5d8:	60e6                	ld	ra,88(sp)
 5da:	6446                	ld	s0,80(sp)
 5dc:	64a6                	ld	s1,72(sp)
 5de:	6906                	ld	s2,64(sp)
 5e0:	79e2                	ld	s3,56(sp)
 5e2:	7a42                	ld	s4,48(sp)
 5e4:	7aa2                	ld	s5,40(sp)
 5e6:	7b02                	ld	s6,32(sp)
 5e8:	6be2                	ld	s7,24(sp)
 5ea:	6125                	addi	sp,sp,96
 5ec:	8082                	ret

00000000000005ee <stat>:

int
stat(const char *n, struct stat *st)
{
 5ee:	1101                	addi	sp,sp,-32
 5f0:	ec06                	sd	ra,24(sp)
 5f2:	e822                	sd	s0,16(sp)
 5f4:	e426                	sd	s1,8(sp)
 5f6:	e04a                	sd	s2,0(sp)
 5f8:	1000                	addi	s0,sp,32
 5fa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5fc:	4581                	li	a1,0
 5fe:	00000097          	auipc	ra,0x0
 602:	0f6080e7          	jalr	246(ra) # 6f4 <open>
  if(fd < 0)
 606:	02054563          	bltz	a0,630 <stat+0x42>
 60a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 60c:	85ca                	mv	a1,s2
 60e:	00000097          	auipc	ra,0x0
 612:	0fe080e7          	jalr	254(ra) # 70c <fstat>
 616:	892a                	mv	s2,a0
  close(fd);
 618:	8526                	mv	a0,s1
 61a:	00000097          	auipc	ra,0x0
 61e:	0c2080e7          	jalr	194(ra) # 6dc <close>
  return r;
}
 622:	854a                	mv	a0,s2
 624:	60e2                	ld	ra,24(sp)
 626:	6442                	ld	s0,16(sp)
 628:	64a2                	ld	s1,8(sp)
 62a:	6902                	ld	s2,0(sp)
 62c:	6105                	addi	sp,sp,32
 62e:	8082                	ret
    return -1;
 630:	597d                	li	s2,-1
 632:	bfc5                	j	622 <stat+0x34>

0000000000000634 <atoi>:

int
atoi(const char *s)
{
 634:	1141                	addi	sp,sp,-16
 636:	e422                	sd	s0,8(sp)
 638:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 63a:	00054603          	lbu	a2,0(a0)
 63e:	fd06079b          	addiw	a5,a2,-48
 642:	0ff7f793          	andi	a5,a5,255
 646:	4725                	li	a4,9
 648:	02f76963          	bltu	a4,a5,67a <atoi+0x46>
 64c:	86aa                	mv	a3,a0
  n = 0;
 64e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 650:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 652:	0685                	addi	a3,a3,1
 654:	0025179b          	slliw	a5,a0,0x2
 658:	9fa9                	addw	a5,a5,a0
 65a:	0017979b          	slliw	a5,a5,0x1
 65e:	9fb1                	addw	a5,a5,a2
 660:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 664:	0006c603          	lbu	a2,0(a3)
 668:	fd06071b          	addiw	a4,a2,-48
 66c:	0ff77713          	andi	a4,a4,255
 670:	fee5f1e3          	bgeu	a1,a4,652 <atoi+0x1e>
  return n;
}
 674:	6422                	ld	s0,8(sp)
 676:	0141                	addi	sp,sp,16
 678:	8082                	ret
  n = 0;
 67a:	4501                	li	a0,0
 67c:	bfe5                	j	674 <atoi+0x40>

000000000000067e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 67e:	1141                	addi	sp,sp,-16
 680:	e422                	sd	s0,8(sp)
 682:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 684:	02c05163          	blez	a2,6a6 <memmove+0x28>
 688:	fff6071b          	addiw	a4,a2,-1
 68c:	1702                	slli	a4,a4,0x20
 68e:	9301                	srli	a4,a4,0x20
 690:	0705                	addi	a4,a4,1
 692:	972a                	add	a4,a4,a0
  dst = vdst;
 694:	87aa                	mv	a5,a0
    *dst++ = *src++;
 696:	0585                	addi	a1,a1,1
 698:	0785                	addi	a5,a5,1
 69a:	fff5c683          	lbu	a3,-1(a1)
 69e:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 6a2:	fee79ae3          	bne	a5,a4,696 <memmove+0x18>
  return vdst;
}
 6a6:	6422                	ld	s0,8(sp)
 6a8:	0141                	addi	sp,sp,16
 6aa:	8082                	ret

00000000000006ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ac:	4885                	li	a7,1
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6b4:	4889                	li	a7,2
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 6bc:	488d                	li	a7,3
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6c4:	4891                	li	a7,4
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <read>:
.global read
read:
 li a7, SYS_read
 6cc:	4895                	li	a7,5
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <write>:
.global write
write:
 li a7, SYS_write
 6d4:	48c1                	li	a7,16
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <close>:
.global close
close:
 li a7, SYS_close
 6dc:	48d5                	li	a7,21
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6e4:	4899                	li	a7,6
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <exec>:
.global exec
exec:
 li a7, SYS_exec
 6ec:	489d                	li	a7,7
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <open>:
.global open
open:
 li a7, SYS_open
 6f4:	48bd                	li	a7,15
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6fc:	48c5                	li	a7,17
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 704:	48c9                	li	a7,18
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 70c:	48a1                	li	a7,8
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <link>:
.global link
link:
 li a7, SYS_link
 714:	48cd                	li	a7,19
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 71c:	48d1                	li	a7,20
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 724:	48a5                	li	a7,9
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <dup>:
.global dup
dup:
 li a7, SYS_dup
 72c:	48a9                	li	a7,10
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 734:	48ad                	li	a7,11
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 73c:	48b1                	li	a7,12
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 744:	48b5                	li	a7,13
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 74c:	48b9                	li	a7,14
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 754:	48d9                	li	a7,22
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <crash>:
.global crash
crash:
 li a7, SYS_crash
 75c:	48dd                	li	a7,23
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <mount>:
.global mount
mount:
 li a7, SYS_mount
 764:	48e1                	li	a7,24
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <umount>:
.global umount
umount:
 li a7, SYS_umount
 76c:	48e5                	li	a7,25
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 774:	1101                	addi	sp,sp,-32
 776:	ec06                	sd	ra,24(sp)
 778:	e822                	sd	s0,16(sp)
 77a:	1000                	addi	s0,sp,32
 77c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 780:	4605                	li	a2,1
 782:	fef40593          	addi	a1,s0,-17
 786:	00000097          	auipc	ra,0x0
 78a:	f4e080e7          	jalr	-178(ra) # 6d4 <write>
}
 78e:	60e2                	ld	ra,24(sp)
 790:	6442                	ld	s0,16(sp)
 792:	6105                	addi	sp,sp,32
 794:	8082                	ret

0000000000000796 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 796:	7139                	addi	sp,sp,-64
 798:	fc06                	sd	ra,56(sp)
 79a:	f822                	sd	s0,48(sp)
 79c:	f426                	sd	s1,40(sp)
 79e:	f04a                	sd	s2,32(sp)
 7a0:	ec4e                	sd	s3,24(sp)
 7a2:	0080                	addi	s0,sp,64
 7a4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7a6:	c299                	beqz	a3,7ac <printint+0x16>
 7a8:	0805c863          	bltz	a1,838 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7ac:	2581                	sext.w	a1,a1
  neg = 0;
 7ae:	4881                	li	a7,0
 7b0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7b4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7b6:	2601                	sext.w	a2,a2
 7b8:	00000517          	auipc	a0,0x0
 7bc:	4c850513          	addi	a0,a0,1224 # c80 <digits>
 7c0:	883a                	mv	a6,a4
 7c2:	2705                	addiw	a4,a4,1
 7c4:	02c5f7bb          	remuw	a5,a1,a2
 7c8:	1782                	slli	a5,a5,0x20
 7ca:	9381                	srli	a5,a5,0x20
 7cc:	97aa                	add	a5,a5,a0
 7ce:	0007c783          	lbu	a5,0(a5)
 7d2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7d6:	0005879b          	sext.w	a5,a1
 7da:	02c5d5bb          	divuw	a1,a1,a2
 7de:	0685                	addi	a3,a3,1
 7e0:	fec7f0e3          	bgeu	a5,a2,7c0 <printint+0x2a>
  if(neg)
 7e4:	00088b63          	beqz	a7,7fa <printint+0x64>
    buf[i++] = '-';
 7e8:	fd040793          	addi	a5,s0,-48
 7ec:	973e                	add	a4,a4,a5
 7ee:	02d00793          	li	a5,45
 7f2:	fef70823          	sb	a5,-16(a4)
 7f6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 7fa:	02e05863          	blez	a4,82a <printint+0x94>
 7fe:	fc040793          	addi	a5,s0,-64
 802:	00e78933          	add	s2,a5,a4
 806:	fff78993          	addi	s3,a5,-1
 80a:	99ba                	add	s3,s3,a4
 80c:	377d                	addiw	a4,a4,-1
 80e:	1702                	slli	a4,a4,0x20
 810:	9301                	srli	a4,a4,0x20
 812:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 816:	fff94583          	lbu	a1,-1(s2)
 81a:	8526                	mv	a0,s1
 81c:	00000097          	auipc	ra,0x0
 820:	f58080e7          	jalr	-168(ra) # 774 <putc>
  while(--i >= 0)
 824:	197d                	addi	s2,s2,-1
 826:	ff3918e3          	bne	s2,s3,816 <printint+0x80>
}
 82a:	70e2                	ld	ra,56(sp)
 82c:	7442                	ld	s0,48(sp)
 82e:	74a2                	ld	s1,40(sp)
 830:	7902                	ld	s2,32(sp)
 832:	69e2                	ld	s3,24(sp)
 834:	6121                	addi	sp,sp,64
 836:	8082                	ret
    x = -xx;
 838:	40b005bb          	negw	a1,a1
    neg = 1;
 83c:	4885                	li	a7,1
    x = -xx;
 83e:	bf8d                	j	7b0 <printint+0x1a>

0000000000000840 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 840:	7119                	addi	sp,sp,-128
 842:	fc86                	sd	ra,120(sp)
 844:	f8a2                	sd	s0,112(sp)
 846:	f4a6                	sd	s1,104(sp)
 848:	f0ca                	sd	s2,96(sp)
 84a:	ecce                	sd	s3,88(sp)
 84c:	e8d2                	sd	s4,80(sp)
 84e:	e4d6                	sd	s5,72(sp)
 850:	e0da                	sd	s6,64(sp)
 852:	fc5e                	sd	s7,56(sp)
 854:	f862                	sd	s8,48(sp)
 856:	f466                	sd	s9,40(sp)
 858:	f06a                	sd	s10,32(sp)
 85a:	ec6e                	sd	s11,24(sp)
 85c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 85e:	0005c903          	lbu	s2,0(a1)
 862:	18090f63          	beqz	s2,a00 <vprintf+0x1c0>
 866:	8aaa                	mv	s5,a0
 868:	8b32                	mv	s6,a2
 86a:	00158493          	addi	s1,a1,1
  state = 0;
 86e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 870:	02500a13          	li	s4,37
      if(c == 'd'){
 874:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 878:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 87c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 880:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 884:	00000b97          	auipc	s7,0x0
 888:	3fcb8b93          	addi	s7,s7,1020 # c80 <digits>
 88c:	a839                	j	8aa <vprintf+0x6a>
        putc(fd, c);
 88e:	85ca                	mv	a1,s2
 890:	8556                	mv	a0,s5
 892:	00000097          	auipc	ra,0x0
 896:	ee2080e7          	jalr	-286(ra) # 774 <putc>
 89a:	a019                	j	8a0 <vprintf+0x60>
    } else if(state == '%'){
 89c:	01498f63          	beq	s3,s4,8ba <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 8a0:	0485                	addi	s1,s1,1
 8a2:	fff4c903          	lbu	s2,-1(s1)
 8a6:	14090d63          	beqz	s2,a00 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8aa:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8ae:	fe0997e3          	bnez	s3,89c <vprintf+0x5c>
      if(c == '%'){
 8b2:	fd479ee3          	bne	a5,s4,88e <vprintf+0x4e>
        state = '%';
 8b6:	89be                	mv	s3,a5
 8b8:	b7e5                	j	8a0 <vprintf+0x60>
      if(c == 'd'){
 8ba:	05878063          	beq	a5,s8,8fa <vprintf+0xba>
      } else if(c == 'l') {
 8be:	05978c63          	beq	a5,s9,916 <vprintf+0xd6>
      } else if(c == 'x') {
 8c2:	07a78863          	beq	a5,s10,932 <vprintf+0xf2>
      } else if(c == 'p') {
 8c6:	09b78463          	beq	a5,s11,94e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 8ca:	07300713          	li	a4,115
 8ce:	0ce78663          	beq	a5,a4,99a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8d2:	06300713          	li	a4,99
 8d6:	0ee78e63          	beq	a5,a4,9d2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 8da:	11478863          	beq	a5,s4,9ea <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8de:	85d2                	mv	a1,s4
 8e0:	8556                	mv	a0,s5
 8e2:	00000097          	auipc	ra,0x0
 8e6:	e92080e7          	jalr	-366(ra) # 774 <putc>
        putc(fd, c);
 8ea:	85ca                	mv	a1,s2
 8ec:	8556                	mv	a0,s5
 8ee:	00000097          	auipc	ra,0x0
 8f2:	e86080e7          	jalr	-378(ra) # 774 <putc>
      }
      state = 0;
 8f6:	4981                	li	s3,0
 8f8:	b765                	j	8a0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 8fa:	008b0913          	addi	s2,s6,8
 8fe:	4685                	li	a3,1
 900:	4629                	li	a2,10
 902:	000b2583          	lw	a1,0(s6)
 906:	8556                	mv	a0,s5
 908:	00000097          	auipc	ra,0x0
 90c:	e8e080e7          	jalr	-370(ra) # 796 <printint>
 910:	8b4a                	mv	s6,s2
      state = 0;
 912:	4981                	li	s3,0
 914:	b771                	j	8a0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 916:	008b0913          	addi	s2,s6,8
 91a:	4681                	li	a3,0
 91c:	4629                	li	a2,10
 91e:	000b2583          	lw	a1,0(s6)
 922:	8556                	mv	a0,s5
 924:	00000097          	auipc	ra,0x0
 928:	e72080e7          	jalr	-398(ra) # 796 <printint>
 92c:	8b4a                	mv	s6,s2
      state = 0;
 92e:	4981                	li	s3,0
 930:	bf85                	j	8a0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 932:	008b0913          	addi	s2,s6,8
 936:	4681                	li	a3,0
 938:	4641                	li	a2,16
 93a:	000b2583          	lw	a1,0(s6)
 93e:	8556                	mv	a0,s5
 940:	00000097          	auipc	ra,0x0
 944:	e56080e7          	jalr	-426(ra) # 796 <printint>
 948:	8b4a                	mv	s6,s2
      state = 0;
 94a:	4981                	li	s3,0
 94c:	bf91                	j	8a0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 94e:	008b0793          	addi	a5,s6,8
 952:	f8f43423          	sd	a5,-120(s0)
 956:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 95a:	03000593          	li	a1,48
 95e:	8556                	mv	a0,s5
 960:	00000097          	auipc	ra,0x0
 964:	e14080e7          	jalr	-492(ra) # 774 <putc>
  putc(fd, 'x');
 968:	85ea                	mv	a1,s10
 96a:	8556                	mv	a0,s5
 96c:	00000097          	auipc	ra,0x0
 970:	e08080e7          	jalr	-504(ra) # 774 <putc>
 974:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 976:	03c9d793          	srli	a5,s3,0x3c
 97a:	97de                	add	a5,a5,s7
 97c:	0007c583          	lbu	a1,0(a5)
 980:	8556                	mv	a0,s5
 982:	00000097          	auipc	ra,0x0
 986:	df2080e7          	jalr	-526(ra) # 774 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 98a:	0992                	slli	s3,s3,0x4
 98c:	397d                	addiw	s2,s2,-1
 98e:	fe0914e3          	bnez	s2,976 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 992:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 996:	4981                	li	s3,0
 998:	b721                	j	8a0 <vprintf+0x60>
        s = va_arg(ap, char*);
 99a:	008b0993          	addi	s3,s6,8
 99e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9a2:	02090163          	beqz	s2,9c4 <vprintf+0x184>
        while(*s != 0){
 9a6:	00094583          	lbu	a1,0(s2)
 9aa:	c9a1                	beqz	a1,9fa <vprintf+0x1ba>
          putc(fd, *s);
 9ac:	8556                	mv	a0,s5
 9ae:	00000097          	auipc	ra,0x0
 9b2:	dc6080e7          	jalr	-570(ra) # 774 <putc>
          s++;
 9b6:	0905                	addi	s2,s2,1
        while(*s != 0){
 9b8:	00094583          	lbu	a1,0(s2)
 9bc:	f9e5                	bnez	a1,9ac <vprintf+0x16c>
        s = va_arg(ap, char*);
 9be:	8b4e                	mv	s6,s3
      state = 0;
 9c0:	4981                	li	s3,0
 9c2:	bdf9                	j	8a0 <vprintf+0x60>
          s = "(null)";
 9c4:	00000917          	auipc	s2,0x0
 9c8:	2b490913          	addi	s2,s2,692 # c78 <malloc+0x16e>
        while(*s != 0){
 9cc:	02800593          	li	a1,40
 9d0:	bff1                	j	9ac <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 9d2:	008b0913          	addi	s2,s6,8
 9d6:	000b4583          	lbu	a1,0(s6)
 9da:	8556                	mv	a0,s5
 9dc:	00000097          	auipc	ra,0x0
 9e0:	d98080e7          	jalr	-616(ra) # 774 <putc>
 9e4:	8b4a                	mv	s6,s2
      state = 0;
 9e6:	4981                	li	s3,0
 9e8:	bd65                	j	8a0 <vprintf+0x60>
        putc(fd, c);
 9ea:	85d2                	mv	a1,s4
 9ec:	8556                	mv	a0,s5
 9ee:	00000097          	auipc	ra,0x0
 9f2:	d86080e7          	jalr	-634(ra) # 774 <putc>
      state = 0;
 9f6:	4981                	li	s3,0
 9f8:	b565                	j	8a0 <vprintf+0x60>
        s = va_arg(ap, char*);
 9fa:	8b4e                	mv	s6,s3
      state = 0;
 9fc:	4981                	li	s3,0
 9fe:	b54d                	j	8a0 <vprintf+0x60>
    }
  }
}
 a00:	70e6                	ld	ra,120(sp)
 a02:	7446                	ld	s0,112(sp)
 a04:	74a6                	ld	s1,104(sp)
 a06:	7906                	ld	s2,96(sp)
 a08:	69e6                	ld	s3,88(sp)
 a0a:	6a46                	ld	s4,80(sp)
 a0c:	6aa6                	ld	s5,72(sp)
 a0e:	6b06                	ld	s6,64(sp)
 a10:	7be2                	ld	s7,56(sp)
 a12:	7c42                	ld	s8,48(sp)
 a14:	7ca2                	ld	s9,40(sp)
 a16:	7d02                	ld	s10,32(sp)
 a18:	6de2                	ld	s11,24(sp)
 a1a:	6109                	addi	sp,sp,128
 a1c:	8082                	ret

0000000000000a1e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a1e:	715d                	addi	sp,sp,-80
 a20:	ec06                	sd	ra,24(sp)
 a22:	e822                	sd	s0,16(sp)
 a24:	1000                	addi	s0,sp,32
 a26:	e010                	sd	a2,0(s0)
 a28:	e414                	sd	a3,8(s0)
 a2a:	e818                	sd	a4,16(s0)
 a2c:	ec1c                	sd	a5,24(s0)
 a2e:	03043023          	sd	a6,32(s0)
 a32:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a36:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a3a:	8622                	mv	a2,s0
 a3c:	00000097          	auipc	ra,0x0
 a40:	e04080e7          	jalr	-508(ra) # 840 <vprintf>
}
 a44:	60e2                	ld	ra,24(sp)
 a46:	6442                	ld	s0,16(sp)
 a48:	6161                	addi	sp,sp,80
 a4a:	8082                	ret

0000000000000a4c <printf>:

void
printf(const char *fmt, ...)
{
 a4c:	711d                	addi	sp,sp,-96
 a4e:	ec06                	sd	ra,24(sp)
 a50:	e822                	sd	s0,16(sp)
 a52:	1000                	addi	s0,sp,32
 a54:	e40c                	sd	a1,8(s0)
 a56:	e810                	sd	a2,16(s0)
 a58:	ec14                	sd	a3,24(s0)
 a5a:	f018                	sd	a4,32(s0)
 a5c:	f41c                	sd	a5,40(s0)
 a5e:	03043823          	sd	a6,48(s0)
 a62:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a66:	00840613          	addi	a2,s0,8
 a6a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a6e:	85aa                	mv	a1,a0
 a70:	4505                	li	a0,1
 a72:	00000097          	auipc	ra,0x0
 a76:	dce080e7          	jalr	-562(ra) # 840 <vprintf>
}
 a7a:	60e2                	ld	ra,24(sp)
 a7c:	6442                	ld	s0,16(sp)
 a7e:	6125                	addi	sp,sp,96
 a80:	8082                	ret

0000000000000a82 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a82:	1141                	addi	sp,sp,-16
 a84:	e422                	sd	s0,8(sp)
 a86:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a88:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8c:	00000797          	auipc	a5,0x0
 a90:	20c7b783          	ld	a5,524(a5) # c98 <freep>
 a94:	a805                	j	ac4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a96:	4618                	lw	a4,8(a2)
 a98:	9db9                	addw	a1,a1,a4
 a9a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a9e:	6398                	ld	a4,0(a5)
 aa0:	6318                	ld	a4,0(a4)
 aa2:	fee53823          	sd	a4,-16(a0)
 aa6:	a091                	j	aea <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aa8:	ff852703          	lw	a4,-8(a0)
 aac:	9e39                	addw	a2,a2,a4
 aae:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 ab0:	ff053703          	ld	a4,-16(a0)
 ab4:	e398                	sd	a4,0(a5)
 ab6:	a099                	j	afc <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ab8:	6398                	ld	a4,0(a5)
 aba:	00e7e463          	bltu	a5,a4,ac2 <free+0x40>
 abe:	00e6ea63          	bltu	a3,a4,ad2 <free+0x50>
{
 ac2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac4:	fed7fae3          	bgeu	a5,a3,ab8 <free+0x36>
 ac8:	6398                	ld	a4,0(a5)
 aca:	00e6e463          	bltu	a3,a4,ad2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ace:	fee7eae3          	bltu	a5,a4,ac2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 ad2:	ff852583          	lw	a1,-8(a0)
 ad6:	6390                	ld	a2,0(a5)
 ad8:	02059713          	slli	a4,a1,0x20
 adc:	9301                	srli	a4,a4,0x20
 ade:	0712                	slli	a4,a4,0x4
 ae0:	9736                	add	a4,a4,a3
 ae2:	fae60ae3          	beq	a2,a4,a96 <free+0x14>
    bp->s.ptr = p->s.ptr;
 ae6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 aea:	4790                	lw	a2,8(a5)
 aec:	02061713          	slli	a4,a2,0x20
 af0:	9301                	srli	a4,a4,0x20
 af2:	0712                	slli	a4,a4,0x4
 af4:	973e                	add	a4,a4,a5
 af6:	fae689e3          	beq	a3,a4,aa8 <free+0x26>
  } else
    p->s.ptr = bp;
 afa:	e394                	sd	a3,0(a5)
  freep = p;
 afc:	00000717          	auipc	a4,0x0
 b00:	18f73e23          	sd	a5,412(a4) # c98 <freep>
}
 b04:	6422                	ld	s0,8(sp)
 b06:	0141                	addi	sp,sp,16
 b08:	8082                	ret

0000000000000b0a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b0a:	7139                	addi	sp,sp,-64
 b0c:	fc06                	sd	ra,56(sp)
 b0e:	f822                	sd	s0,48(sp)
 b10:	f426                	sd	s1,40(sp)
 b12:	f04a                	sd	s2,32(sp)
 b14:	ec4e                	sd	s3,24(sp)
 b16:	e852                	sd	s4,16(sp)
 b18:	e456                	sd	s5,8(sp)
 b1a:	e05a                	sd	s6,0(sp)
 b1c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b1e:	02051493          	slli	s1,a0,0x20
 b22:	9081                	srli	s1,s1,0x20
 b24:	04bd                	addi	s1,s1,15
 b26:	8091                	srli	s1,s1,0x4
 b28:	0014899b          	addiw	s3,s1,1
 b2c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b2e:	00000517          	auipc	a0,0x0
 b32:	16a53503          	ld	a0,362(a0) # c98 <freep>
 b36:	c515                	beqz	a0,b62 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b38:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b3a:	4798                	lw	a4,8(a5)
 b3c:	02977f63          	bgeu	a4,s1,b7a <malloc+0x70>
 b40:	8a4e                	mv	s4,s3
 b42:	0009871b          	sext.w	a4,s3
 b46:	6685                	lui	a3,0x1
 b48:	00d77363          	bgeu	a4,a3,b4e <malloc+0x44>
 b4c:	6a05                	lui	s4,0x1
 b4e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b52:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b56:	00000917          	auipc	s2,0x0
 b5a:	14290913          	addi	s2,s2,322 # c98 <freep>
  if(p == (char*)-1)
 b5e:	5afd                	li	s5,-1
 b60:	a88d                	j	bd2 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 b62:	00000797          	auipc	a5,0x0
 b66:	13e78793          	addi	a5,a5,318 # ca0 <base>
 b6a:	00000717          	auipc	a4,0x0
 b6e:	12f73723          	sd	a5,302(a4) # c98 <freep>
 b72:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b74:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b78:	b7e1                	j	b40 <malloc+0x36>
      if(p->s.size == nunits)
 b7a:	02e48b63          	beq	s1,a4,bb0 <malloc+0xa6>
        p->s.size -= nunits;
 b7e:	4137073b          	subw	a4,a4,s3
 b82:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b84:	1702                	slli	a4,a4,0x20
 b86:	9301                	srli	a4,a4,0x20
 b88:	0712                	slli	a4,a4,0x4
 b8a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b8c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b90:	00000717          	auipc	a4,0x0
 b94:	10a73423          	sd	a0,264(a4) # c98 <freep>
      return (void*)(p + 1);
 b98:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b9c:	70e2                	ld	ra,56(sp)
 b9e:	7442                	ld	s0,48(sp)
 ba0:	74a2                	ld	s1,40(sp)
 ba2:	7902                	ld	s2,32(sp)
 ba4:	69e2                	ld	s3,24(sp)
 ba6:	6a42                	ld	s4,16(sp)
 ba8:	6aa2                	ld	s5,8(sp)
 baa:	6b02                	ld	s6,0(sp)
 bac:	6121                	addi	sp,sp,64
 bae:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bb0:	6398                	ld	a4,0(a5)
 bb2:	e118                	sd	a4,0(a0)
 bb4:	bff1                	j	b90 <malloc+0x86>
  hp->s.size = nu;
 bb6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bba:	0541                	addi	a0,a0,16
 bbc:	00000097          	auipc	ra,0x0
 bc0:	ec6080e7          	jalr	-314(ra) # a82 <free>
  return freep;
 bc4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bc8:	d971                	beqz	a0,b9c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bcc:	4798                	lw	a4,8(a5)
 bce:	fa9776e3          	bgeu	a4,s1,b7a <malloc+0x70>
    if(p == freep)
 bd2:	00093703          	ld	a4,0(s2)
 bd6:	853e                	mv	a0,a5
 bd8:	fef719e3          	bne	a4,a5,bca <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 bdc:	8552                	mv	a0,s4
 bde:	00000097          	auipc	ra,0x0
 be2:	b5e080e7          	jalr	-1186(ra) # 73c <sbrk>
  if(p == (char*)-1)
 be6:	fd5518e3          	bne	a0,s5,bb6 <malloc+0xac>
        return 0;
 bea:	4501                	li	a0,0
 bec:	bf45                	j	b9c <malloc+0x92>
